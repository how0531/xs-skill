// ==================================================
// RSI 均值回歸策略（台指期）
// --------------------------------------------------
// 腳本類別：交易（自動交易/波段）
// 策略構想：TradingView 內建 RSI Strategy（超賣反彈做多、
//           超買回落做空），改為出場回到中線 + 固定點數停損
// 適用商品：台指期近月（FITX*1.TF 日盤；FITXN*1.TF 全日盤亦可）
// 建議頻率：30 / 60 分鐘
// 策略邏輯：RSI 自超賣區向上翻揚做多、自超買區向下反轉做空，
//           RSI 回到中線視為動能修復完成離場，另設固定點數停損
// 注意事項：均值回歸策略在單邊大趨勢中容易連續停損，
//           建議搭配回測確認參數；波段留倉，結算日轉倉
//           請另行參考 references/script-types/trading.md §12
// 免責聲明：本範例僅供程式教學，不構成任何投資建議
// ==================================================

// ==============================
// 1. 參數宣告區
// ==============================
input: _RsiLen(14, "RSI期數");
input: _OverSold(30, "超賣線");
input: _OverBought(70, "超買線");
input: _ExitMid(50, "出場中線");
input: _StopPoint(60, "停損點數");
input: _Lots(1, "下單口數");

// ==============================
// 2. 變數宣告區
// ==============================
var: _RsiVal(0);                      // RSI 指標值
var: intrabarpersist _ControlBar(0);  // K棒控制權：同一根K棒不重複進出

// ==============================
// 3. 環境預檢區
// ==============================
if _StopPoint <= 0 then RaiseRunTimeError("停損點數必須大於 0");
if _OverSold >= _ExitMid or _OverBought <= _ExitMid then RaiseRunTimeError("超賣線須低於中線、超買線須高於中線");
SetTotalBar(_RsiLen * 4 + 100);  // RSI 暖機所需資料 + 安全邊界

// ==============================
// 4. 邏輯運算區
// ==============================
_RsiVal = RSI(Close, _RsiLen);

// ==============================
// 5. 執行與輸出區
// ==============================
// 5.1 進場：RSI 自超賣區向上翻揚做多、自超買區向下反轉做空
if position = 0 and _ControlBar <> CurrentBar then begin
    if _RsiVal cross above _OverSold then begin
        SetPosition(_Lots, market, label:="超賣反彈做多");
        _ControlBar = CurrentBar;
    end else if _RsiVal cross below _OverBought then begin
        SetPosition(-_Lots, market, label:="超買回落做空");
        _ControlBar = CurrentBar;
    end;
end;

// 5.2 多單出場：觸價停損優先，其次 RSI 回到中線（動能修復完成）
if position > 0 and filled > 0 then begin
    if Low <= FilledAvgPrice - _StopPoint then begin
        SetPosition(0, market, label:="多單停損");
        _ControlBar = CurrentBar;
    end else if _RsiVal >= _ExitMid then begin
        SetPosition(0, market, label:="多單修復出場");
        _ControlBar = CurrentBar;
    end;
end;

// 5.3 空單出場：觸價停損優先，其次 RSI 回到中線
if position < 0 and filled < 0 then begin
    if High >= FilledAvgPrice + _StopPoint then begin
        SetPosition(0, market, label:="空單停損");
        _ControlBar = CurrentBar;
    end else if _RsiVal <= _ExitMid then begin
        SetPosition(0, market, label:="空單修復出場");
        _ControlBar = CurrentBar;
    end;
end;
