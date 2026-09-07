// ==============================================================
// 台指期 雙向 DCA 網格策略（XS 自動交易腳本）
// 來源：PineScript v6「台指期雙向網格策略 V1.31 (微台版)」轉寫
// 適用商品：微台／小台／台指期　適用頻率：分鐘
// 訊號規則：以「已收盤的 K 棒」確認訊號，下一根 K 棒開盤市價進場
// 網格機制：XS 一次僅能保留一筆未成交委託，無法同時掛多筆限價單，
//           故改為「價格觸及網格價位時即時補到對應口數」的觸價加碼
// ==============================================================

// ==============================================================
// 1. 參數宣告區
// ==============================================================

// 1.1 交易總開關
input: _MakeSure(0, "了解策略風險請選【是】", InputKind:=Dict(["否", 0], ["是", 1]), Quickedit:=True);

// 1.2 均線通道期數
// 取價頻率無法做成參數：GetField 與 SetBarBack 的頻率必須是字串常數，
// 資料在初始化階段就要決定載入哪一個頻率，傳入 input 變數會編譯失敗。
// 原策略為 360 分鐘，XS 官方頻率代碼沒有 360
// （只有 1／2／3／5／10／15／20／30／45／60／90／120／135／180／240），故取最接近的 240。
// 要改頻率請同步修改下方三處標記【通道頻率】的字串。
input: _ChanLen(200, "均線通道期數");

// 1.3 MACD 設定（原策略以簡單移動平均計算，非標準指數型 MACD）
input: _MacdFast(12, "快線長度");
input: _MacdSlow(26, "慢線長度");
input: _SignalLen(9, "信號平滑");

// 1.4 DCA 網格參數
input: _OrderQty(1, "每次開倉／加倉口數");
input: _MaxPosQty(10, "最大總持倉口數上限");
input: _GridPoints(88, "首次加倉網格間距(點)");
input: _GridMult(1.2, "加倉網格間距乘數");
input: _MaxDca(8, "最大加倉次數");
input: _BaseTpPoints(102, "首倉止盈點數");
input: _TpMult(1.3, "加倉後止盈乘數");

// 1.5 全局止損
input: _SlOn(1, "開啟全局止損", InputKind:=Dict(["是", 1], ["否", 0]), Quickedit:=True);
input: _SlPoints(2500, "全局止損點數(0=不啟用)");

// 1.6 止損反向開倉
input: _EnableRev(1, "止損後立即反向開倉", InputKind:=Dict(["是", 1], ["否", 0]), Quickedit:=True);

// ==============================================================
// 2. 變數宣告區
// ==============================================================

// 2.1 指標與訊號（每次洗價重算）
var: _Macd(0), _MacdSignal(0), _MaHigh(0), _MaLow(0);
var: _IsNewBar(false), _LongSignal(false), _ShortSignal(false);
var: _RevLongTrig(false), _RevShortTrig(false), _DoLong(false), _DoShort(false);

// 2.2 網格與出場計算暫存
var: _AllowedByQty(0), _ActualMaxDca(0);
var: _OpenTradeCount(0), _TpPoints(0), _AvgCost(0), _TpPrice(0), _SlPrice(0);
var: _TargetIdx(0), _TargetQty(0), _CumOffset(0), _GridStep(0), _i(0);
var: _OrderSent(0), _ExitDir(0);

// 2.3 跨洗價保留的狀態
var:
    intrabarpersist _FirstEntryPrice(0),   // 首倉成交參考價，網格價位由此往外推
    intrabarpersist _PendingRevLong(0),    // 待反手做多的 K 棒編號（0=無）
    intrabarpersist _PendingRevShort(0);   // 待反手做空的 K 棒編號（0=無）

// ==============================================================
// 3. 資源預載與環境預檢
// ==============================================================
// 通道均線在主頻上平滑，需要主頻至少 期數＋緩衝 根；跨頻率取價另外預留
SetBarBack(MaxList(_ChanLen, _MacdSlow, _SignalLen) + 120);
SetBarBack(150, "240");        // 【通道頻率】

if BarFreq <> "Min" then RaiseRunTimeError("本策略僅支援分鐘頻率");
if _MakeSure <> 1 then RaiseRunTimeError("請確實了解策略內容，並將【了解策略風險】設為【是】");
if _OrderQty <= 0 then RaiseRunTimeError("每次開倉口數必須大於 0");
if _MaxPosQty < _OrderQty then RaiseRunTimeError("最大總持倉口數不可小於單次開倉口數");
if _GridPoints <= 0 then RaiseRunTimeError("網格間距必須大於 0");
if _GridMult < 1 then RaiseRunTimeError("網格間距乘數不可小於 1");
if _BaseTpPoints <= 0 then RaiseRunTimeError("首倉止盈點數必須大於 0");
if _TpMult <= 0 then RaiseRunTimeError("止盈乘數必須大於 0");
if _SlPoints < 0 then RaiseRunTimeError("止損點數不可為負數");
if _ChanLen <= 0 or _MacdFast <= 0 or _MacdSlow <= 0 or _SignalLen <= 0 then RaiseRunTimeError("指標期數必須大於 0");

// IsFirstCall 會被「呼叫」消耗，必須無條件取值後存起來重複使用
_IsNewBar = IsFirstCall("Bar");

// ==============================================================
// 4. 指標計算
// ==============================================================
// 原策略的 MACD 以簡單移動平均計算，這裡沿用同一種平均方式
_Macd = Average(Close, _MacdFast) - Average(Close, _MacdSlow);
_MacdSignal = Average(_Macd, _SignalLen);

// 通道：取指定頻率的高低價，再於主頻做指數平滑（與原策略的計算層級相同）
_MaHigh = XAverage(GetField("最高價", "240"), _ChanLen);   // 【通道頻率】
_MaLow = XAverage(GetField("最低價", "240"), _ChanLen);    // 【通道頻率】

// 訊號需回溯到前兩根 K 棒，資料不足時不做判斷
if CurrentBar <= 4 then return;

// ==============================================================
// 5. 進場訊號（以已收盤的前一根 K 棒判定，避免盤中重繪）
// ==============================================================
_LongSignal = (_Macd[1] > _MacdSignal[1]) and (_Macd[2] <= _MacdSignal[2]) and (Close[1] >= _MaHigh);
_ShortSignal = (_Macd[1] < _MacdSignal[1]) and (_Macd[2] >= _MacdSignal[2]) and (Close[1] <= _MaLow);

// ==============================================================
// 6. 網格上限計算
// ==============================================================
_AllowedByQty = IntPortion((_MaxPosQty - _OrderQty) / _OrderQty);
_ActualMaxDca = MinList(_MaxDca, _AllowedByQty);

_OrderSent = 0;

// ==============================================================
// 7. 止盈與全局止損（每次洗價；一次洗價只會送出一個交易指令）
// ==============================================================
if Position <> 0 and Filled <> 0 then begin
    if Filled > 0 then begin
        _ExitDir = 1;
    end else begin
        _ExitDir = -1;
    end;

    _AvgCost = FilledAvgPrice;
    _OpenTradeCount = IntPortion(AbsValue(Filled) / _OrderQty);
    if _OpenTradeCount < 1 then _OpenTradeCount = 1;
    // 止盈點數隨加碼次數等比放大
    _TpPoints = _BaseTpPoints * Power(_TpMult, MaxList(0, _OpenTradeCount - 1));

    if (_ExitDir = 1) and _AvgCost > 0 then begin
        _SlPrice = _AvgCost - _SlPoints;
        _TpPrice = _AvgCost + _TpPoints;
        if (_SlOn = 1) and _SlPoints > 0 and Low <= _SlPrice then begin
            SetPosition(0, Market, label:="多單全局止損");
            _OrderSent = 1;
            _FirstEntryPrice = 0;
            if (_EnableRev = 1) then _PendingRevShort = CurrentBar;
        end else if High >= _TpPrice then begin
            SetPosition(0, Market, label:="多單止盈");
            _OrderSent = 1;
            _FirstEntryPrice = 0;
        end;
    end;

    if (_ExitDir = -1) and _AvgCost > 0 then begin
        _SlPrice = _AvgCost + _SlPoints;
        _TpPrice = _AvgCost - _TpPoints;
        if (_SlOn = 1) and _SlPoints > 0 and High >= _SlPrice then begin
            SetPosition(0, Market, label:="空單全局止損");
            _OrderSent = 1;
            _FirstEntryPrice = 0;
            if (_EnableRev = 1) then _PendingRevLong = CurrentBar;
        end else if Low <= _TpPrice then begin
            SetPosition(0, Market, label:="空單止盈");
            _OrderSent = 1;
            _FirstEntryPrice = 0;
        end;
    end;
end;

// ==============================================================
// 8. 網格加碼（觸價即補到對應口數，可一次跨越多層）
// ==============================================================
if (_OrderSent = 0) and Position <> 0 and (Position = Filled) and _FirstEntryPrice > 0 and _ActualMaxDca >= 1 then begin
    _TargetIdx = 0;
    _CumOffset = 0;
    _GridStep = _GridPoints;

    // 逐層累加間距（等比級數），找出目前價格已觸及的最深一層
    for _i = 1 to _ActualMaxDca begin
        _CumOffset = _CumOffset + _GridStep;
        if Position > 0 and Low <= _FirstEntryPrice - _CumOffset then _TargetIdx = _i;
        if Position < 0 and High >= _FirstEntryPrice + _CumOffset then _TargetIdx = _i;
        _GridStep = _GridStep * _GridMult;
    end;

    _TargetQty = (_TargetIdx + 1) * _OrderQty;

    if Position > 0 and _TargetQty > Position then begin
        SetPosition(_TargetQty, Market, label:="網格加碼多單");
        _OrderSent = 1;
    end else if Position < 0 and _TargetQty > AbsValue(Position) then begin
        SetPosition(-_TargetQty, Market, label:="網格加碼空單");
        _OrderSent = 1;
    end;
end;

// ==============================================================
// 9. 反手排程檢查（每根 K 棒一次，過期排程一律清掉）
// ==============================================================
_RevLongTrig = false;
_RevShortTrig = false;

if _IsNewBar then begin
    if _PendingRevLong > 0 and (CurrentBar = _PendingRevLong + 1) then begin
        if (_EnableRev = 1) then _RevLongTrig = true;
        _PendingRevLong = 0;
    end;
    if _PendingRevShort > 0 and (CurrentBar = _PendingRevShort + 1) then begin
        if (_EnableRev = 1) then _RevShortTrig = true;
        _PendingRevShort = 0;
    end;
end;

// ==============================================================
// 10. 首倉進場（空手才開，反手訊號不受指標條件限制）
// ==============================================================
if (_OrderSent = 0) and _IsNewBar and (Position = 0) and (Filled = 0) then begin
    _DoLong = _LongSignal or _RevLongTrig;
    _DoShort = _ShortSignal or _RevShortTrig;

    if _DoLong then begin
        SetPosition(_OrderQty, Market, label:="首倉做多");
        _FirstEntryPrice = Close[1];
        _OrderSent = 1;
    end else if _DoShort then begin
        SetPosition(-_OrderQty, Market, label:="首倉做空");
        _FirstEntryPrice = Close[1];
        _OrderSent = 1;
    end;
end;

// ==============================================================
// 11. 空手時清除網格基準（本次洗價已下單時不清，Position 要等本次執行完才更新）
// ==============================================================
if (_OrderSent = 0) and (Position = 0) and (Filled = 0) then _FirstEntryPrice = 0;
