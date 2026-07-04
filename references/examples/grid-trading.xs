// ============================================================
// 網格交易策略（期貨 / 特定月份合約；回測可用 *1 連續）
// 特色：整數口數、自我校準網格、乾淨的每日重置與結算轉倉
//       + 風控模組(停損/保證金揭露/防呆/到期警示/跳空分批)
// 適用頻率：分鐘（1/5/15…）；商品：期貨、選擇權（口數計）
//
// 核心概念：目標部位純粹由「現價落在第幾格」決定，
//           帶 ±1 格遲滯防抖；重啟／隔夜留倉／轉倉都能自動接手。
//
// 使用方式：
//   回測：交易模式=回測，直接跑策略回測(可掛 *1 連續)。
//   實單：掛「自動交易中心」，交易模式=實盤、了解風險選【是】；
//         *實盤請掛「特定月份合約」，勿掛 *1 連續(結算會靜默失效,程式已擋)。
//   風控參數預設全關=維持純網格；要保護帳戶請自行開啟(見 1.1)。
// ============================================================

// ------------------------------------------------------------
// 1. 參數宣告區
// ------------------------------------------------------------
input: _UpLimit(0, "區間最高價");
input: _DnLimit(0, "區間最低價");
input: _Grid(10, "網格數");
input: _GridV(1, "每格口數");
input: _BasicPos(1, "基本庫存(最低保留口數,不賣出)");

input: _InitialTF(0, "進場方式", inputkind:=Dict(["跌到起始價才啟動", 1], ["直接依現價啟動", 0]));
input: _InitialPrice(0, "起始進場價(僅在跌到起始價模式使用)");

// 註：網格一律用市價下單。限價掛單若未成交，SetPosition 後 Position 仍會=目標值，
//     會讓「_target<>Position」守門恆為 false → 網格永久卡死，故不提供限價選項。

// 結算 / 轉倉
input: _ExpiryMode(2, "結算處理", inputkind:=Dict(["自動轉倉(當日夜盤買回)", 2], ["到期出場當日不再進場", 1], ["關閉(回測用)", 0]));
input: _ExitTime("13:29:00", "結算出場時間 HH:MM:SS");
input: _ReEnterTime("15:03:00", "轉倉買回時間 HH:MM:SS(需有夜盤資料)");

// 除錯輸出
input: _PrintTF(1, "文字輸出", inputkind:=Dict(["開啟", 1], ["關閉", 0]));
input: _PrintSec(5, "心跳輸出秒數間距");

// ------------------------------------------------------------
// 1.1 風控參數（預設全關=維持原純網格行為；要用再開）
// ------------------------------------------------------------
input: _StopLossPrice(0, "破區間停損價(0=關;跌破此價全平並永久停止網格)");
input: _MaxLotsPerOrder(0, "單筆最多調整口數(0=不限;>0時跳空分批補,降滑價)");
input: _MinGap(0, "最小容許格距(價格單位,0=不檢查;防格距過窄被成本吃光)");
input: _MarginPerLot(0, "每口原始保證金(元,0=不估算,只做揭露)");
input: _MaintMarginPerLot(0, "每口維持保證金(元,0=不估算)");
input: _AlertDays(1, "到期前N日主動警示(實盤)");

// ------------------------------------------------------------
// 2. 變數宣告區（狀態變數一律 intrabarpersist；每根重算的用純 var）
// ------------------------------------------------------------
var: _gap(0);                              // 網格間距（每根重算）
var: _expiry(0);                           // 到期日 YYYYMMDD（每根重算，隨轉倉更新）
var: _maxPos(0);                           // 最大部位口數（計畫表/保證金/停損顯示用）
var: intrabarpersist _cell(0);             // 目前格號 0~_Grid（帶遲滯的狀態，需持久）
var: intrabarpersist _cellReady(0);        // _cell 是否已依現價定錨（首次/重啟/轉倉後重錨）
var: _target(0);                           // 現價對應目標口數
var: _step(0);                             // 單筆調整量（跳空分批用）
var: _blockUp(0);                          // 目前格上緣價（顯示用）
var: _blockDn(0);                          // 目前格下緣價（顯示用）

var: intrabarpersist _started(0);          // 網格是否已啟動
var: intrabarpersist _inSettle(0);         // 是否處於結算暫停（1=已平倉待恢復）
var: intrabarpersist _stopped(0);          // 是否已觸發停損（停損後網格永久停止）
var: intrabarpersist _settleDate(0);       // 已在哪一天結算過（防當日重複出場、當恢復判斷的錨）
var: intrabarpersist _expiryAlerted(0);    // 到期臨界是否已響鈴（避免重複 alert）
var: intrabarpersist _lastPos(0);          // 上次觀察到的部位（偵測剛變動用）
var: intrabarpersist _lastPrintTime(0);    // 上次心跳列印時間

// 注意：XS 不分大小寫，var 名不可與 input 只差大小寫（_exitTime 會撞 _ExitTime），故加 v 前綴
var: _vExitTime(0), _vReEnterTime(0);      // 出場/買回時間（once 轉為數字，之後不變）
var: _i(0), _gp(0), _gq(0);                // 計畫表列印用暫存

// ------------------------------------------------------------
// 3. 參數防呆
// ------------------------------------------------------------
if _Grid < 1 then raiseRunTimeError("網格數不能小於1");
if _Grid <> IntPortion(_Grid) then raiseRunTimeError("網格數必須為整數");
if _Grid > 200 then raiseRunTimeError("網格數過大(>200)，格距過小易被手續費滑價吃光，請調小");
if _GridV < 1 then raiseRunTimeError("每格口數不能小於1");
if _GridV <> IntPortion(_GridV) then raiseRunTimeError("每格口數必須為整數");
if _BasicPos < 0 then raiseRunTimeError("基本庫存不能為負");
if _BasicPos <> IntPortion(_BasicPos) then raiseRunTimeError("基本庫存必須為整數");
if _UpLimit <= _DnLimit then raiseRunTimeError("最高價必須大於最低價");
if _InitialTF = 1 and (_InitialPrice < _DnLimit or _InitialPrice > _UpLimit) then
    raiseRunTimeError("起始進場價需落在區間內");
if _MaxLotsPerOrder < 0 or _MaxLotsPerOrder <> IntPortion(_MaxLotsPerOrder) then
    raiseRunTimeError("單筆最多調整口數需為>=0的整數");
if _StopLossPrice > 0 and _StopLossPrice >= _DnLimit then
    raiseRunTimeError("停損價需低於區間最低價(這是跌破區間的保命線)");
if _MinGap < 0 then raiseRunTimeError("最小容許格距不能為負");

// ------------------------------------------------------------
// 3.1 環境防呆與實單前確認
// ------------------------------------------------------------
if BarFreq <> "Min" then raiseRunTimeError("請使用分鐘頻率(1/5/15分皆可)");

input: _TradeMode(0, "交易模式", InputKind:=Dict(["回測", 0], ["實盤(實際下單)", 1]));
input: _MakeSure(0, "了解風險(實盤必選是)", InputKind:=Dict(["否", 0], ["是", 1]));

// 實盤前確認：避免誤掛實單
if _TradeMode = 1 and _MakeSure <> 1 then
    raiseRunTimeError("實盤模式請先了解腳本內容，並將【了解風險】選【是】");

// 實盤禁用 *1 連續合約：連續合約換月時到期日會跳次月 → 結算/轉倉靜默失效(對不到 Date=_expiry)
if _TradeMode = 1 and InStr(Symbol, "*") > 0 then
    raiseRunTimeError("實盤請改掛特定月份合約(勿用 *1 連續)，否則結算/轉倉會因換月而靜默失效");

// 實盤模式下，歷史回放不執行：掛上後從第一筆即時報價起以乾淨狀態運作，
// 既有庫存由第 8 段的 FilledAtBroker 偵測自動接手
if _TradeMode = 1 and GetInfo("IsRealTime") = 0 then return;

// ------------------------------------------------------------
// 4. 每根重算（放在 once 之外，轉倉換月後仍正確）
// ------------------------------------------------------------
_gap = (_UpLimit - _DnLimit) / _Grid;      // _UpLimit>_DnLimit 已驗證，_Grid>=1，無除零
_expiry = getSymbolInfo("到期日");
_maxPos = _Grid * _GridV + _BasicPos;      // 跌到區間底時的滿倉口數

// 格距成本把關（放在 _gap 算好之後）
if _MinGap > 0 and _gap < _MinGap then
    raiseRunTimeError("格距小於最小容許格距，滑價+手續費恐大於格距利潤，請縮小網格數或放大區間");

// ------------------------------------------------------------
// 5. 只做一次：時間轉換 + 網格計畫表 + 保證金揭露
// ------------------------------------------------------------
once begin
    _vExitTime    = stringToTime(_ExitTime);
    _vReEnterTime = stringToTime(_ReEnterTime);

    Print("=== 網格交易計畫表 ===");
    Print("區間 ", numToStr(_DnLimit,0), "~", numToStr(_UpLimit,0),
          "  網格數=", numToStr(_Grid,0), "  間距=", numToStr(_gap,0),
          "  每格=", numToStr(_GridV,0), " 口  底倉=", numToStr(_BasicPos,0), " 口");
    for _i = _Grid downto 0 begin
        _gp = _DnLimit + _i * _gap;
        _gq = (_Grid - _i) * _GridV + _BasicPos;
        Print("格[", numToStr(_i,0), "]  價<=", numToStr(_gp,0),
              "  應持有(含底倉)=", numToStr(_gq,0), " 口");
    end;
    Print("最大部位=", numToStr(_maxPos,0), " 口");

    // 保證金揭露（填了每口保證金才印）
    if _MarginPerLot > 0 then
        Print("  → 最大部位需原始保證金 ≈ ", numToStr(_maxPos * _MarginPerLot,0),
              " 元 (建議備 1.5~2 倍以承受波動追繳)");
    if _MaintMarginPerLot > 0 then
        Print("  → 最大部位需維持保證金 ≈ ", numToStr(_maxPos * _MaintMarginPerLot,0),
              " 元 (帳戶權益低於此恐被強制平倉)");

    // 停損揭露：沒設停損就明確警告「跌破區間死抱最大部位、浮虧無下限」
    if _StopLossPrice > 0 then begin
        Print("停損：跌破 ", numToStr(_StopLossPrice,0), " 全平並停止網格");
    end else begin
        Print("⚠ 未設停損：跌破區間將持有最大部位死抱，浮虧無下限，請自行控管口數與保證金");
    end;

    // 結算診斷：實盤已擋 *1；掛特定月份合約者請確認此到期日為該合約真正到期日
    Print("到期日=", numToStr(getSymbolInfo("到期日"),0),
          "  離到期日天數=", numToStr(DaysToExpirationTF,0));
    Print("======================");
end;

// ------------------------------------------------------------
// 6. 每日重置
// ------------------------------------------------------------
if Date <> Date[1] then begin
    _lastPrintTime = 0;                     // 心跳計時歸零，跨日重新起算
    if DaysToExpirationTF > _AlertDays then _expiryAlerted = 0;   // 遠離到期日→重置警示旗標
end;

// ------------------------------------------------------------
// 7. 結算 / 轉倉（先處理，settle 期間暫停網格）
// ------------------------------------------------------------
// 7.1 到期日出場（`_settleDate <> Date` 確保每個結算日只出場一次）
if _ExpiryMode > 0 and _inSettle = 0 and _settleDate <> Date and Date = _expiry
   and CurrentTime >= _vExitTime then begin
    if Position <> 0 then SetPosition(0, Market, label:="結算出場");
    _settleDate = Date;
    _inSettle = 1;
    _cellReady = 0;                         // 轉倉後在新合約依現價重新定錨網格
    if _PrintTF = 1 then Print(numToStr(Date,0), " 結算平倉，模式=", numToStr(_ExpiryMode,0));
end;

// 7.2 恢復條件（以 _settleDate 為錨，不用會隨轉倉跳月的 _expiry）
if _inSettle = 1 then begin
    if _ExpiryMode = 1 then begin
        if Date <> _settleDate then begin
            _inSettle = 0;
            if _PrintTF = 1 then Print("已過結算日，網格恢復（新合約依現價自動建倉）");
        end;
    end else if _ExpiryMode = 2 then begin
        // 到買回時間恢復；跨日(無夜盤資料)則隔日恢復當安全網，避免永久卡死
        if CurrentTime >= _vReEnterTime or Date <> _settleDate then begin
            _inSettle = 0;
            if _PrintTF = 1 then Print("轉倉恢復，網格在新合約依現價自動建倉");
        end;
    end;
end;

// 7.3 到期臨界主動警示（實盤；掛特定月份合約時提醒確認結算設定，避免不自知）
if _TradeMode = 1 and _expiryAlerted = 0 and Position <> 0
   and DaysToExpirationTF >= 0 and DaysToExpirationTF <= _AlertDays then begin
    Alert("合約將於 ", numToStr(DaysToExpirationTF,0), " 日內到期，請確認結算/轉倉設定與合約月份");
    _expiryAlerted = 1;
end;

// ------------------------------------------------------------
// 8. 網格啟動判斷
// ------------------------------------------------------------
// (a) 帳上已有部位 → 直接接手（重啟 / 隔夜留倉 / 轉倉後）
//     用 FilledAtBroker(實際庫存數量) 偵測：實盤重啟時 Position 與策略自身的
//     Filled(成交部位) 都可能歸 0，只有券商實際庫存 FilledAtBroker 保有留倉
if _started = 0 and _inSettle = 0 and _stopped = 0 and (Position <> 0 or FilledAtBroker <> 0) then begin
    _started = 1;
    if _PrintTF = 1 then Print("偵測到既有庫存 FilledAtBroker=", numToStr(FilledAtBroker,0), " → 網格接手");
end;

// (b) 首次啟動
if _started = 0 and _inSettle = 0 and _stopped = 0 then begin
    if _InitialTF = 0 then begin
        _started = 1;                       // 直接依現價啟動
    end else if Close <= _InitialPrice then begin
        _started = 1;                       // 跌到起始價才啟動
    end;
    if _started = 1 and _PrintTF = 1 then
        Print("網格啟動，現價=", numToStr(Close,0));
end;

// ------------------------------------------------------------
// 8.5 破區間停損（可選；跌破停損價→全平並永久停止網格，保命線）
//     用 Low 觸價判斷(anti-pattern #20)，盤中跌破即出，不等收盤
// ------------------------------------------------------------
if _StopLossPrice > 0 and _started = 1 and _stopped = 0 and _inSettle = 0 and Low <= _StopLossPrice then begin
    if Position <> 0 then SetPosition(0, Market, label:="破區間停損");
    _stopped = 1;
    if _PrintTF = 1 then Print(numToStr(Date,0), " ", numToStr(Time,0),
        " 觸發停損(Low<=", numToStr(_StopLossPrice,0), ")，網格已停止，請檢視後再重掛");
end;

// ------------------------------------------------------------
// 9. 網格核心：現價 → 格號 → 目標口數，變動才下單
//    (target 已天然夾在 _BasicPos ~ _maxPos，無須額外 maxlist/minlist)
// ------------------------------------------------------------
if _started = 1 and _inSettle = 0 and _stopped = 0 then begin
    // 定錨：首次啟動/重啟/轉倉後，依現價把 _cell 設到對應格
    //       (+微量 epsilon 吸收非整數 _gap 在格線上的浮點誤差，避免 off-by-one)
    if _cellReady = 0 then begin
        _cell = MinList(MaxList(Floor((Close - _DnLimit) / _gap + 0.00000001), 0), _Grid);
        _cellReady = 1;
    end else begin
        // 遲滯(hysteresis)：需「漲破上一格上緣」或「跌破下一格下緣」整整一格才換手，
        // 現價貼在單一格線上下抖動時 _cell 不變 → 不再每 tick 一買一賣(whipsaw)。
        if Close >= _DnLimit + (_cell + 1) * _gap then begin
            _cell = MinList(Floor((Close - _DnLimit) / _gap + 0.00000001), _Grid);
        end else if Close <= _DnLimit + (_cell - 1) * _gap then begin
            _cell = MaxList(Floor((Close - _DnLimit) / _gap + 0.00000001), 0);
        end;
    end;

    _target  = (_Grid - _cell) * _GridV + _BasicPos;
    _blockDn = _DnLimit + _cell * _gap;
    _blockUp = _DnLimit + (_cell + 1) * _gap;

    // 下單：市價；若設了單筆上限，跳空時分批(逐 tick 朝目標最多走 N 口)以降滑價
    if _target <> Position then begin
        if _MaxLotsPerOrder > 0 then begin
            if _target > Position then begin
                _step = MinList(_target, Position + _MaxLotsPerOrder);
            end else begin
                _step = MaxList(_target, Position - _MaxLotsPerOrder);
            end;
            SetPosition(_step, Market, label:="網格調整");
        end else begin
            SetPosition(_target, Market, label:="網格調整");
        end;
    end;
end;

// ------------------------------------------------------------
// 10. 部位剛變動時輸出一次（用 _lastPos 追蹤，避免逐筆洗價每 tick 狂印）
// ------------------------------------------------------------
if _PrintTF = 1 and Position <> _lastPos then begin
    Print(numToStr(Date,0), " ", numToStr(Time,0),
          "  部位 ", numToStr(_lastPos,0), " → ", numToStr(Position,0),
          "  格號=", numToStr(_cell,0),
          "  [", numToStr(_blockDn,0), " ~ ", numToStr(_blockUp,0), "]");
    _lastPos = Position;                    // 印完立刻同步，下個 tick 不會再進
end;

// ------------------------------------------------------------
// 11. 定時心跳輸出
// ------------------------------------------------------------
// 用 TimeDiff 判斷距上次列印秒數；CurrentTime < _lastPrintTime＝跨午夜回捲，重錨避免靜默。
if _PrintTF = 1 and (_lastPrintTime = 0 or CurrentTime < _lastPrintTime
                     or TimeDiff(CurrentTime, _lastPrintTime, "S") >= _PrintSec) then begin
    _lastPrintTime = CurrentTime;
    Print(numToStr(Date,0), " ", numToStr(Time,0),
          "  現價=", numToStr(Close,0),
          "  格號=", numToStr(_cell,0),
          "  目標=", numToStr(_target,0),
          "  部位=", numToStr(Position,0),
          "  started=", numToStr(_started,0),
          "  settle=", numToStr(_inSettle,0),
          "  stopped=", numToStr(_stopped,0));
end;
