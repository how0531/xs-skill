// ==================================================
// SuperTrend 趨勢跟蹤策略（台指期）
// --------------------------------------------------
// 腳本類別：交易（自動交易）
// 策略構想：TradingView 人氣指標 SuperTrend 的多空互換用法
// 適用商品：台指期近月（FITX*1.TF 日盤；FITXN*1.TF 全日盤亦可）
// 建議頻率：15 / 30 / 60 分鐘
// 策略邏輯：以 (最高+最低)/2 ± N 倍 ATR 建立趨勢通道，
//           收盤站上通道翻多、跌破通道翻空，多空互換、永遠在場，
//           通道線本身即為移動停損
// 注意事項：波段留倉策略；監控連續月合約時，結算日轉倉
//           請另行參考 references/script-types/trading.md §12
// 免責聲明：本範例僅供程式教學，不構成任何投資建議
// ==================================================

// ==============================
// 1. 參數宣告區
// ==============================
input: _AtrLen(10, "ATR期數");
input: _Mult(3, "ATR倍數");
input: _Lots(1, "下單口數");

// ==============================
// 2. 變數宣告區
// ==============================
var: _AtrVal(0);     // 平均真實區間
var: _Mid(0);        // K棒中價 (最高+最低)/2
var: _BasicUp(0);    // 原始上通道
var: _BasicDn(0);    // 原始下通道
var: _FinalUp(0);    // 收斂後上通道（空方趨勢線）
var: _FinalDn(0);    // 收斂後下通道（多方趨勢線）
var: _Trend(1);      // 趨勢方向：1=多方, -1=空方

// ==============================
// 3. 環境預檢區
// ==============================
if BarFreq <> "Min" then RaiseRunTimeError("僅支援分鐘線頻率");
SetTotalBar(_AtrLen * 4 + 100);  // ATR 暖機所需資料 + 安全邊界

// ==============================
// 4. 邏輯運算區
// ==============================
_AtrVal = ATR(_AtrLen);
_Mid = (High + Low) / 2;
_BasicUp = _Mid + _Mult * _AtrVal;
_BasicDn = _Mid - _Mult * _AtrVal;

// 上通道只往下收斂，除非前一根收盤已站上通道（趨勢已翻多則重新展開）
if _BasicUp < _FinalUp[1] or Close[1] > _FinalUp[1] then begin
    _FinalUp = _BasicUp;
end else begin
    _FinalUp = _FinalUp[1];
end;

// 下通道只往上收斂，除非前一根收盤已跌破通道（趨勢已翻空則重新展開）
if _BasicDn > _FinalDn[1] or Close[1] < _FinalDn[1] then begin
    _FinalDn = _BasicDn;
end else begin
    _FinalDn = _FinalDn[1];
end;

// 趨勢判定：突破上通道翻多、跌破下通道翻空，其餘沿用前一根方向
if Close > _FinalUp[1] then begin
    _Trend = 1;
end else if Close < _FinalDn[1] then begin
    _Trend = -1;
end else begin
    _Trend = _Trend[1];
end;

// ==============================
// 5. 執行與輸出區
// ==============================
// 翻多：回補空單並反手做多（期貨僅需判斷 position，不需股票的同步檢查）
if _Trend = 1 and position <= 0 then begin
    SetPosition(_Lots, market, label:="翻多進場");
end;

// 翻空：平掉多單並反手做空
if _Trend = -1 and position >= 0 then begin
    SetPosition(-_Lots, market, label:="翻空進場");
end;
