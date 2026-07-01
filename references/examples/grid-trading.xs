// ============================================================
// 網格交易策略（期貨 / 近月連續合約 *1）
// 特色：整數口數、自我校準網格、乾淨的每日重置與結算轉倉
// 適用頻率：分鐘（1/5/15…）；商品：期貨、選擇權（口數計）
//
// 核心概念：目標部位純粹由「現價落在第幾格」決定，
//           每根重算 → 天生自我校準，重啟／隔夜留倉／轉倉都能自動接手，
//           不需要脆弱的兩階段補單與 filled 反推。
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

input: _OrderType(0, "下單方式", inputkind:=Dict(["市價(建議,確保成交)", 0], ["限價掛收盤價", 1]));

// 結算 / 轉倉
input: _ExpiryMode(2, "結算處理", inputkind:=Dict(["自動轉倉(當日夜盤買回)", 2], ["到期出場當日不再進場", 1], ["關閉(回測用)", 0]));
input: _ExitTime("13:29:00", "結算出場時間 HH:MM:SS");
input: _ReEnterTime("15:03:00", "轉倉買回時間 HH:MM:SS(需有夜盤資料)");

// 除錯輸出
input: _PrintTF(1, "文字輸出", inputkind:=Dict(["開啟", 1], ["關閉", 0]));
input: _PrintSec(5, "心跳輸出秒數間距");

// ------------------------------------------------------------
// 2. 變數宣告區（狀態變數一律 intrabarpersist；每根重算的用純 var）
// ------------------------------------------------------------
var: _gap(0);                              // 網格間距（每根重算）
var: _expiry(0);                           // 到期日 YYYYMMDD（每根重算，隨轉倉更新）
var: _cell(0);                             // 現價落點格號 0~_Grid
var: _target(0);                           // 現價對應目標口數
var: _blockUp(0);                          // 目前格上緣價（顯示用）
var: _blockDn(0);                          // 目前格下緣價（顯示用）

var: intrabarpersist _started(0);          // 網格是否已啟動
var: intrabarpersist _inSettle(0);         // 是否處於結算暫停（1=已平倉待恢復）
var: intrabarpersist _lastPos(0);          // 上次觀察到的部位（偵測剛變動用，見 anti-pattern #27）
var: intrabarpersist _nextPrintTime(0);    // 下次心跳列印時間

var: _exitTime(0), _reEnterTime(0);        // 出場/買回時間（once 轉為數字，之後不變）
var: _i(0), _gp(0), _gq(0);                // 計畫表列印用暫存

// ------------------------------------------------------------
// 3. 參數防呆
// ------------------------------------------------------------
if _Grid < 1 then raiseRunTimeError("網格數不能小於1");
if _GridV < 1 then raiseRunTimeError("每格口數不能小於1");
if _BasicPos < 0 then raiseRunTimeError("基本庫存不能為負");
if _UpLimit <= _DnLimit then raiseRunTimeError("最高價必須大於最低價");
if _InitialTF = 1 and (_InitialPrice < _DnLimit or _InitialPrice > _UpLimit) then
    raiseRunTimeError("起始進場價需落在區間內");

// ------------------------------------------------------------
// 4. 每根重算（放在 once 之外，轉倉換月後仍正確）
// ------------------------------------------------------------
_gap = (_UpLimit - _DnLimit) / _Grid;      // _UpLimit>_DnLimit 已驗證，_Grid>=1，無除零
_expiry = getSymbolInfo("到期日");

// ------------------------------------------------------------
// 5. 只做一次：時間轉換 + 網格計畫表（用 Print，不用 alert 洗版）
// ------------------------------------------------------------
once begin
    _exitTime    = stringToTime(_ExitTime);
    _reEnterTime = stringToTime(_ReEnterTime);

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
    Print("最大部位=", numToStr(_Grid * _GridV + _BasicPos,0), " 口");
    Print("======================");
end;

// ------------------------------------------------------------
// 6. 每日重置（換日該歸零的狀態一律放這，見 trading.md「每日參數歸零區」）
// ------------------------------------------------------------
if Date <> Date[1] then begin
    _nextPrintTime = 0;            // 心跳門檻歸零，否則跨日到隔天中午才會恢復列印
end;

// ------------------------------------------------------------
// 7. 結算 / 轉倉（先處理，settle 期間暫停網格）
// ------------------------------------------------------------
// 7.1 到期日出場
if _ExpiryMode > 0 and _inSettle = 0 and Date = _expiry
   and CurrentTime >= _exitTime and CurrentTime <= 133000 then begin
    if Position <> 0 then SetPosition(0, Market, label:="結算出場");
    _inSettle = 1;
    if _PrintTF = 1 then Print(numToStr(Date,0), " 結算平倉，模式=", numToStr(_ExpiryMode,0));
end;

// 7.2 恢復條件
if _inSettle = 1 then begin
    if _ExpiryMode = 1 then begin
        // 到期出場、當日不再進場：離開到期日（含當晚夜盤/隔日新合約）即恢復
        if Date <> _expiry then begin
            _inSettle = 0;
            if _PrintTF = 1 then Print("已過結算日，網格恢復（新合約依現價自動建倉）");
        end;
    end else if _ExpiryMode = 2 then begin
        // 自動轉倉：到買回時間即恢復，網格會在新合約依現價把部位補回目標
        if CurrentTime >= _reEnterTime then begin
            _inSettle = 0;
            if _PrintTF = 1 then Print("轉倉時段到，網格恢復（新合約依現價自動建倉）");
        end;
    end;
end;

// ------------------------------------------------------------
// 8. 網格啟動判斷
// ------------------------------------------------------------
// (a) 帳上已有部位 → 直接接手（重啟 / 隔夜留倉 / 轉倉後）
if _started = 0 and _inSettle = 0 and Position <> 0 then begin
    _started = 1;
    if _PrintTF = 1 then Print("偵測到既有部位 ", numToStr(Position,0), " 口 → 網格接手");
end;

// (b) 首次啟動
if _started = 0 and _inSettle = 0 then begin
    if _InitialTF = 0 then begin
        _started = 1;                       // 直接依現價啟動
    end else if Close <= _InitialPrice then begin
        _started = 1;                       // 跌到起始價才啟動
    end;
    if _started = 1 and _PrintTF = 1 then
        Print("網格啟動，現價=", numToStr(Close,0));
end;

// ------------------------------------------------------------
// 9. 網格核心：現價 → 格號 → 目標口數，變動才下單
//    (target 已天然夾在 _BasicPos ~ _Grid*_GridV+_BasicPos，無須額外 maxlist/minlist)
// ------------------------------------------------------------
if _started = 1 and _inSettle = 0 then begin
    _cell    = MinList(MaxList(Floor((Close - _DnLimit) / _gap), 0), _Grid);
    _target  = (_Grid - _cell) * _GridV + _BasicPos;
    _blockDn = _DnLimit + _cell * _gap;
    _blockUp = _DnLimit + (_cell + 1) * _gap;

    if _target <> Position then begin
        if _OrderType = 0 then begin
            SetPosition(_target, Market, label:="網格調整");
        end else begin
            SetPosition(_target);   // 限價：掛收盤價，快市可能不成交
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
    _lastPos = Position;          // 印完立刻同步，下個 tick 不會再進
end;

// ------------------------------------------------------------
// 11. 定時心跳輸出
// ------------------------------------------------------------
if _PrintTF = 1 and CurrentTime >= _nextPrintTime then begin
    _nextPrintTime = timeAdd(CurrentTime, "S", _PrintSec);
    Print(numToStr(Date,0), " ", numToStr(Time,0),
          "  現價=", numToStr(Close,0),
          "  格號=", numToStr(_cell,0),
          "  目標=", numToStr(_target,0),
          "  部位=", numToStr(Position,0),
          "  started=", numToStr(_started,0),
          "  settle=", numToStr(_inSettle,0));
end;
