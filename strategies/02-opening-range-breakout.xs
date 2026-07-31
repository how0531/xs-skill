// ==================================================
// 開盤區間突破當沖策略（台指期）
// --------------------------------------------------
// 腳本類別：交易（自動交易/當沖）
// 策略構想：TradingView 指數期貨社群熱門的 Opening Range Breakout
// 適用商品：台指期近月「日盤」（FITX*1.TF）
//           ⚠️ 不建議掛全日盤：夜盤跨日會干擾每日歸零與區間統計
// 建議頻率：1 / 5 分鐘
// 策略邏輯：08:45 開盤後前 N 分鐘的高低點為開盤區間，
//           突破區間上緣做多、跌破下緣做空（多空每日各限一次），
//           固定點數停損 + 區間寬度倍數停利，收盤前強制平倉
// 免責聲明：本範例僅供程式教學，不構成任何投資建議
// ==================================================

// ==============================
// 1. 參數宣告區
// ==============================
input: _RangeEndTime(090000, "開盤區間結束時間(HHMMSS)");
input: _EntryEndTime(130000, "最後進場時間(HHMMSS)");
input: _ExitTime(134000, "強制平倉時間(HHMMSS)");
input: _Lots(1, "下單口數");
input: _StopPoint(30, "停損點數");
input: _TargetMult(1, "停利=區間寬度x倍數(0=不停利)");

// ==============================
// 2. 變數宣告區
// ==============================
var: intrabarpersist _RangeTop(0);       // 開盤區間高點
var: intrabarpersist _RangeBot(999999);  // 開盤區間低點
var: intrabarpersist _LongDone(0);       // 今日已做多旗標
var: intrabarpersist _ShortDone(0);      // 今日已做空旗標
var: _RangeWidth(0);                     // 區間寬度（點）

// ==============================
// 3. 環境預檢區
// ==============================
if BarFreq <> "Min" then RaiseRunTimeError("僅支援分鐘線頻率");
if _StopPoint <= 0 then RaiseRunTimeError("停損點數必須大於 0");

// ==============================
// 4. 每日參數歸零區（當沖必備）
// ==============================
if Date <> Date[1] then begin
    _RangeTop = 0;
    _RangeBot = 999999;
    _LongDone = 0;
    _ShortDone = 0;
end;

// ==============================
// 5. 邏輯運算區
// ==============================
// 建立開盤區間：08:45 起至區間結束時間，滾動記錄高低點
if Time >= 084500 and Time <= _RangeEndTime then begin
    if High > _RangeTop then begin
        _RangeTop = High;
    end;
    if Low < _RangeBot then begin
        _RangeBot = Low;
    end;
end;

_RangeWidth = _RangeTop - _RangeBot;

// ==============================
// 6. 執行與輸出區
// ==============================
// 6.1 進場：區間完成後、最後進場時間前，突破追進（多空每日各限一次）
if Time > _RangeEndTime and Time <= _EntryEndTime and _RangeWidth > 0 then begin
    if position = 0 and _LongDone = 0 and Close > _RangeTop then begin
        SetPosition(_Lots, market, label:="突破區間做多");
        _LongDone = 1;
    end;
    if position = 0 and _ShortDone = 0 and Close < _RangeBot then begin
        SetPosition(-_Lots, market, label:="跌破區間做空");
        _ShortDone = 1;
    end;
end;

// 6.2 多單出場：觸價停損優先，其次區間倍數停利
if position > 0 and filled > 0 then begin
    if Low <= FilledAvgPrice - _StopPoint then begin
        SetPosition(0, market, label:="多單停損");
    end else if _TargetMult > 0 and High >= FilledAvgPrice + _RangeWidth * _TargetMult then begin
        SetPosition(0, market, label:="多單停利");
    end;
end;

// 6.3 空單出場：觸價停損優先，其次區間倍數停利
if position < 0 and filled < 0 then begin
    if High >= FilledAvgPrice + _StopPoint then begin
        SetPosition(0, market, label:="空單停損");
    end else if _TargetMult > 0 and Low <= FilledAvgPrice - _RangeWidth * _TargetMult then begin
        SetPosition(0, market, label:="空單停利");
    end;
end;

// 6.4 收盤前強制平倉（當沖不留倉）
if CurrentTime >= _ExitTime and position <> 0 then begin
    SetPosition(0, market, label:="收盤前強制平倉");
end;
