// ==================================================
// Donchian 通道突破策略（台指期，海龜法則）
// --------------------------------------------------
// 腳本類別：交易（自動交易/波段）
// 策略構想：TradingView 內建 Channel Break Out 策略（唐奇安通道，
//           即海龜交易法則的突破邏輯）
// 適用商品：台指期近月（FITX*1.TF 日盤；FITXN*1.TF 全日盤亦可）
// 建議頻率：60 分鐘或日線
// 策略邏輯：突破前 N 期最高做多、跌破前 N 期最低做空，
//           反向跌破較短出場通道離場，另設 ATR 倍數保護性停損
// 注意事項：波段留倉策略；監控連續月合約時，結算日轉倉
//           請另行參考 references/script-types/trading.md §12
// 免責聲明：本範例僅供程式教學，不構成任何投資建議
// ==================================================

// ==============================
// 1. 參數宣告區
// ==============================
input: _EntryLen(20, "進場通道期數");
input: _ExitLen(10, "出場通道期數");
input: _AtrLen(20, "ATR期數");
input: _StopMult(2, "停損ATR倍數(0=不啟用)");
input: _Lots(1, "下單口數");

// ==============================
// 2. 變數宣告區
// ==============================
var: _AtrVal(0);     // 平均真實區間
var: _EntryTop(0);   // 進場通道上緣（前N期最高，不含當根）
var: _EntryBot(0);   // 進場通道下緣（前N期最低，不含當根）
var: _ExitTop(0);    // 出場通道上緣（空單回補線）
var: _ExitBot(0);    // 出場通道下緣（多單出場線）
var: intrabarpersist _ControlBar(0);  // K棒控制權：同一根K棒不重複進出

// ==============================
// 3. 環境預檢區
// ==============================
SetTotalBar(MaxList(_EntryLen, MaxList(_ExitLen, _AtrLen)) * 2 + 100);  // 通道與ATR暖機 + 安全邊界

// ==============================
// 4. 邏輯運算區
// ==============================
_AtrVal = ATR(_AtrLen);

// 通道一律取前一根為止的極值，避免拿當根盤中高低點自我觸發
_EntryTop = Highest(High, _EntryLen)[1];
_EntryBot = Lowest(Low, _EntryLen)[1];
_ExitTop = Highest(High, _ExitLen)[1];
_ExitBot = Lowest(Low, _ExitLen)[1];

// ==============================
// 5. 執行與輸出區
// ==============================
// 5.1 進場：突破前N期高點做多、跌破前N期低點做空（期貨僅需判斷 position）
if position = 0 and _ControlBar <> CurrentBar then begin
    if Close > _EntryTop then begin
        SetPosition(_Lots, market, label:="突破通道做多");
        _ControlBar = CurrentBar;
    end else if Close < _EntryBot then begin
        SetPosition(-_Lots, market, label:="跌破通道做空");
        _ControlBar = CurrentBar;
    end;
end;

// 5.2 多單出場：ATR 保護性停損優先，其次跌破出場通道下緣
if position > 0 and filled > 0 then begin
    if _StopMult > 0 and Low <= FilledAvgPrice - _StopMult * _AtrVal then begin
        SetPosition(0, market, label:="多單ATR停損");
        _ControlBar = CurrentBar;
    end else if Low <= _ExitBot then begin
        SetPosition(0, market, label:="多單通道出場");
        _ControlBar = CurrentBar;
    end;
end;

// 5.3 空單出場：ATR 保護性停損優先，其次突破出場通道上緣
if position < 0 and filled < 0 then begin
    if _StopMult > 0 and High >= FilledAvgPrice + _StopMult * _AtrVal then begin
        SetPosition(0, market, label:="空單ATR停損");
        _ControlBar = CurrentBar;
    end else if High >= _ExitTop then begin
        SetPosition(0, market, label:="空單通道出場");
        _ControlBar = CurrentBar;
    end;
end;
