// ==============================================================
// 台指期 疾速標靶策略 V4.38（全天版）— XS 自動交易腳本
// 適用商品：台指期／小台指 全日盤連續月（例：FITXN*1.TF）
// 適用頻率：分鐘線。停利停損為觸價判斷，請以逐筆洗價執行
// 進場模式：趨勢翻轉、回踩支撐、主線觸線、錨定支撐、紫線穿越、
//           夜盤支撐線突破、四陽三陰，共七套，可個別開關
// ==============================================================

// 樞軸點與 ATR 的回溯需求；資源宣告不受 if 控制，必須放在最上方
SetBarBack(150);

// ==============================================================
// 1. 參數宣告區
// ==============================================================
input: _Qty(1, "每次下單口數");                                                     // 口
input: _TPPoints(70, "停利點數");                                                   // 點
input: _SLPoints(91, "停損點數");                                                   // 點

input: _LongOpen(1, "開啟做多", InputKind:=Dict(["是", 1], ["否", 0]), Quickedit:=True);
input: _ShortOpen(1, "開啟做空", InputKind:=Dict(["是", 1], ["否", 0]), Quickedit:=True);

// 1.1 動態停利：每次停利後點數 +1，停損後歸回基礎值
input: _UseDynTP(0, "啟用動態停利遞增", InputKind:=Dict(["否", 0], ["是", 1]), Quickedit:=True);

// 1.2 止損後的冷卻與型態確認
input: _UseSLDelay(0, "開啟止損後延遲", InputKind:=Dict(["否", 0], ["是", 1]), Quickedit:=True);
input: _SLDelayBars(1, "止損後停止判定的 K 棒數");                                   // 根
input: _UseSLCandle(0, "開啟止損後 K 棒型態確認", InputKind:=Dict(["否", 0], ["是", 1]), Quickedit:=True);

// 1.3 V2：平倉後回踩支撐線再突破
input: _V2Long(1, "V2 做多開倉", InputKind:=Dict(["是", 1], ["否", 0]), Quickedit:=True);
input: _V2Short(0, "V2 做空開倉", InputKind:=Dict(["否", 0], ["是", 1]), Quickedit:=True);
input: _UseSLCooldown(1, "V2 同趨勢止損後暫停", InputKind:=Dict(["是", 1], ["否", 0]), Quickedit:=True);

// 1.4 V3：主趨勢線觸及紫色支撐線
input: _V3Long(0, "V3 做多開倉", InputKind:=Dict(["否", 0], ["是", 1]), Quickedit:=True);
input: _V3Short(0, "V3 做空開倉", InputKind:=Dict(["否", 0], ["是", 1]), Quickedit:=True);

// 1.5 V4：主趨勢線到達錨定支撐
input: _V4Long(0, "V4 做多開倉", InputKind:=Dict(["否", 0], ["是", 1]), Quickedit:=True);
input: _V4Short(0, "V4 做空開倉", InputKind:=Dict(["否", 0], ["是", 1]), Quickedit:=True);
input: _V4SLTolerance(1, "V4 容許連續止損次數（0 為不限）");                          // 次
input: _V4MaxEntries(1, "V4 同趨勢最大開倉次數");                                    // 次
input: _V4LooseMode(0, "V4 寬鬆模式（停利後次數歸零）", InputKind:=Dict(["否", 0], ["是", 1]), Quickedit:=True);

// 1.6 V5：紫線穿越主線，可選回踩確認或傳統即時交叉
input: _V5Long(0, "V5 做多開倉", InputKind:=Dict(["否", 0], ["是", 1]), Quickedit:=True);
input: _V5Short(0, "V5 做空開倉", InputKind:=Dict(["否", 0], ["是", 1]), Quickedit:=True);
input: _V5Pullback(1, "V5 回踩確認模式", InputKind:=Dict(["是", 1], ["否", 0]), Quickedit:=True);
input: _V5MaxEntries(1, "V5 同趨勢最大開倉次數");                                    // 次
input: _V5SLTolerance(1, "V5 容許連續止損次數（0 為不限）");                          // 次
input: _V5ConfirmBars(0, "V5 傳統交叉延遲確認 K 棒數");                              // 根
input: _V5PriceDist(1.0, "V5 傳統交叉價格與主線距離上限");                           // %

// 1.7 夜盤支撐線突破：08:45 錨定前一根紫線，日盤突破即進場
input: _UseBreakout(0, "開啟夜盤支撐線突破", InputKind:=Dict(["否", 0], ["是", 1]), Quickedit:=True);
input: _BreakEndTime(120000, "突破開倉截止時間");                                    // HHMMSS

// 1.8 四陽三陰：全天候順勢連續 K 棒開倉
input: _ThreeLong(0, "開啟四陽做多", InputKind:=Dict(["否", 0], ["是", 1]), Quickedit:=True);
input: _ThreeShort(0, "開啟三陰做空", InputKind:=Dict(["否", 0], ["是", 1]), Quickedit:=True);
input: _ThreeIgnorePurple(1, "四陽三陰無視紫線阻擋", InputKind:=Dict(["是", 1], ["否", 0]), Quickedit:=True);
input: _ThreeMaxEntries(1, "四陽三陰同趨勢最大開倉次數");                            // 次

// 1.9 時間與風控濾網
input: _UseStartDate(0, "開啟起始日期過濾", InputKind:=Dict(["否", 0], ["是", 1]), Quickedit:=True);
input: _StartDate(20240101, "起始日期");                                             // YYYYMMDD
input: _UseNoOpenBefore0900(0, "日盤 08:45~09:00 禁止開倉", InputKind:=Dict(["否", 0], ["是", 1]), Quickedit:=True);
input: _UseNightFilter(0, "開啟夜盤禁止開倉時段", InputKind:=Dict(["否", 0], ["是", 1]), Quickedit:=True);
input: _NightBlockStart(20000, "禁止開倉起始時間");                                  // HHMMSS
input: _NightBlockEnd(50000, "禁止開倉結束時間");                                    // HHMMSS
input: _UseGapProtect(0, "開啟跳空保護", InputKind:=Dict(["否", 0], ["是", 1]), Quickedit:=True);
input: _UseLoss64(0, "開啟前六倉累積四損停盤", InputKind:=Dict(["否", 0], ["是", 1]), Quickedit:=True);
input: _UseWinRateStop(0, "開啟日勝率達標停盤", InputKind:=Dict(["否", 0], ["是", 1]), Quickedit:=True);
input: _TargetWinRate(80.0, "目標勝率");                                             // %
input: _MinTradesForWR(2, "最少交易次數始判定勝率");                                 // 次

// 1.10 雙軌 SuperTrend 參數
input: _Prd1(2, "樞軸點週期（主線）");                                               // 根
input: _Factor1(3.0, "ATR 係數（主線）");
input: _AtrLen1(10, "ATR 週期（主線）");                                             // 根
input: _Prd2(1, "樞軸點週期（支撐線）");                                             // 根
input: _Factor2(3.0, "ATR 係數（支撐線）");
input: _AtrLen2(10, "ATR 週期（支撐線）");                                           // 根

// ==============================================================
// 2. 變數宣告區
// ==============================================================
// 2.1 趨勢線：每次洗價重算，用 [N] 可取得已收 K 棒的定版值
var: _Atr1(0), _Atr2(0);
var: _Pp1(0), _Pp2(0);                                                               // 本根確認的樞軸值，0 代表無
var: _Center1(0), _Center2(0);
var: _Up1(0), _Dn1(0), _Up2(0), _Dn2(0);
var: _TUp1(0), _TDn1(0), _TUp2(0), _TDn2(0);
var: _Trend1(1), _Trend2(1);
var: _Main(0), _Purple(0);

// 2.2 訊號快照：只在新 K 棒的第一次洗價寫入並立即用掉
var: _SigO(0), _SigH(0), _SigL(0), _SigC(0);
var: _SigT1(0), _SigT1P(0);
var: _SigMain(0), _SigMainP(0), _SigPur(0), _SigPurP(0);
var: _SigBar(0);

// 2.3 本次洗價的暫時旗標
var: _IsNewBar(0), _IsSessionOpen(0), _IsNewTradeDay(0), _Acted(0);
var: _TPPts(0), _HitTP(0), _HitSL(0), _IsWin(0);
var: _CanTrade(0), _InTimeWindow(0), _BlockLongGap(0), _BlockShortGap(0), _BlockDelay(0);
var: _DoneCnt(0), _WinRate(0);
var: _SigWasOpenBar(0), _GapDown(0), _GapUp(0);
var: _ThreeGreen(0), _ThreeRed(0), _AboveLines(0), _UnderLines(0), _ThreeSCap(0);
var: _V1L(0), _V1S(0), _V2L(0), _V2S(0), _V3L(0), _V3S(0), _V4L(0), _V4S(0);
var: _V5L(0), _V5S(0), _BkL(0), _BkS(0), _ThreeL(0), _ThreeS(0);
var: _LongEntry(0), _ShortEntry(0), _NewType(0), _DistOK(0);
var: _TypeTxt("");

// 2.4 跨洗價必須保值的狀態變數
var: intrabarpersist _CalcBar(0);                                                    // 上次跑過訊號判定的 K 棒編號
var: intrabarpersist _PrevDate(0), intrabarpersist _PrevTime(0);
var: intrabarpersist _OpenBarNo(0);                                                  // 最近一次盤別開盤的 K 棒編號
var: intrabarpersist _GapBars(0), intrabarpersist _GapDir(0);

var: intrabarpersist _EntryPx(0), intrabarpersist _TPPx(0), intrabarpersist _SLPx(0);
var: intrabarpersist _EntryBar(0), intrabarpersist _ActType(0), intrabarpersist _ActDir(0);
var: intrabarpersist _DynTP(0);

var: intrabarpersist _WinCnt(0), intrabarpersist _LossCnt(0), intrabarpersist _EntryCnt(0);
var: intrabarpersist _LossBlocked(0), intrabarpersist _WRBlocked(0);

var: intrabarpersist _V2LArmed(0), intrabarpersist _V2LPull(0);
var: intrabarpersist _V2SArmed(0), intrabarpersist _V2SPull(0);
var: intrabarpersist _SLHitL(0), intrabarpersist _SLHitS(0);

var: intrabarpersist _V4LAnchor(0), intrabarpersist _V4SAnchor(0);                   // 0 代表尚未錨定
var: intrabarpersist _V4LCnt(0), intrabarpersist _V4SCnt(0);
var: intrabarpersist _SLRunL(0), intrabarpersist _SLRunS(0);

var: intrabarpersist _V5LCnt(0), intrabarpersist _V5SCnt(0);
var: intrabarpersist _V5LSLRun(0), intrabarpersist _V5SSLRun(0);
var: intrabarpersist _V5LCross(0), intrabarpersist _V5LPull(0);
var: intrabarpersist _V5SCross(0), intrabarpersist _V5SPull(0);
var: intrabarpersist _V5LOK(0), intrabarpersist _V5SOK(0);
var: intrabarpersist _V5LBars(0), intrabarpersist _V5SBars(0);

var: intrabarpersist _PrevSLBar(0);                                                  // 最近一次止損的 K 棒編號
var: intrabarpersist _CandleOKL(1), intrabarpersist _CandleOKS(1);

var: intrabarpersist _ThreeLCnt(0), intrabarpersist _ThreeSCnt(0), intrabarpersist _ThreeSWin(0);

var: intrabarpersist _BreakAnchor(0), intrabarpersist _BkLFired(0), intrabarpersist _BkSFired(0);

// ==============================================================
// 3. 環境預檢區
// ==============================================================
if BarFreq <> "Min" then RaiseRunTimeError("本策略僅支援分鐘線頻率");
if _TPPoints <= 0 or _SLPoints <= 0 then RaiseRunTimeError("停利與停損點數必須大於 0");
if _Qty <= 0 then RaiseRunTimeError("下單口數必須大於 0");

// 動態停利的基礎值跟著停利參數走，避免改參數後兩者脫鉤
if _DynTP <= 0 then begin
    _DynTP = _TPPoints;
end;

if _UseDynTP = 1 then begin
    _TPPts = _DynTP;
end else begin
    _TPPts = _TPPoints;
end;

_Acted = 0;

// ==============================================================
// 4. 盤別與交易日偵測
// ==============================================================
// 不倚賴 K 棒時間戳記語意，改以「執行時間跨越門檻」判定，夜盤跨日一樣適用
_IsNewTradeDay = 0;
_IsSessionOpen = 0;

if CurrentTime >= 084500 and (_PrevDate <> Date or _PrevTime < 084500) then begin
    _IsNewTradeDay = 1;                                                              // 交易日以 08:45 分界，日盤與其後夜盤算同一日
    _IsSessionOpen = 1;
end;

if CurrentTime >= 150000 and _PrevDate = Date and _PrevTime < 150000 then begin
    _IsSessionOpen = 1;                                                              // 夜盤開盤
end;

if _IsSessionOpen = 1 then begin
    _OpenBarNo = CurrentBar;
end;

// 4.1 每日統計歸零
if _IsNewTradeDay = 1 then begin
    _WinCnt = 0;
    _LossCnt = 0;
    _EntryCnt = 0;
    _LossBlocked = 0;
    _WRBlocked = 0;
    _BkLFired = 0;
    _BkSFired = 0;
    _BreakAnchor = _Purple[1];                                                       // 錨定夜盤最後一根的支撐線
end;

// 4.2 錨定線只在日盤有效，跨進夜盤即作廢
if CurrentTime >= 150000 or CurrentTime < 080000 then begin
    _BreakAnchor = 0;
end;

// ==============================================================
// 5. 雙軌 SuperTrend 計算
// ==============================================================
// 5.1 ATR 採韋爾達平滑，與原策略的 ATR 定義一致
if CurrentBar <= _AtrLen1 then begin
    _Atr1 = Average(TrueRange, _AtrLen1);
end else begin
    _Atr1 = (_Atr1[1] * (_AtrLen1 - 1) + TrueRange) / _AtrLen1;
end;

if CurrentBar <= _AtrLen2 then begin
    _Atr2 = Average(TrueRange, _AtrLen2);
end else begin
    _Atr2 = (_Atr2[1] * (_AtrLen2 - 1) + TrueRange) / _AtrLen2;
end;

// 5.2 樞軸點確認：位於 _Prd 根之前的那根，左右各 _Prd 根都不及它
_Pp1 = 0;
if CurrentBar > 2 * _Prd1 + 1 then begin
    if High[_Prd1] > Highest(High, _Prd1)[_Prd1 + 1] and High[_Prd1] > Highest(High, _Prd1) then begin
        _Pp1 = High[_Prd1];
    end else if Low[_Prd1] < Lowest(Low, _Prd1)[_Prd1 + 1] and Low[_Prd1] < Lowest(Low, _Prd1) then begin
        _Pp1 = Low[_Prd1];
    end;
end;

_Pp2 = 0;
if CurrentBar > 2 * _Prd2 + 1 then begin
    if High[_Prd2] > Highest(High, _Prd2)[_Prd2 + 1] and High[_Prd2] > Highest(High, _Prd2) then begin
        _Pp2 = High[_Prd2];
    end else if Low[_Prd2] < Lowest(Low, _Prd2)[_Prd2 + 1] and Low[_Prd2] < Lowest(Low, _Prd2) then begin
        _Pp2 = Low[_Prd2];
    end;
end;

// 5.3 中心線：每出現一個新樞軸就往它收斂三分之一
if _Pp1 <> 0 then begin
    if _Center1 = 0 then begin
        _Center1 = _Pp1;
    end else begin
        _Center1 = (_Center1 * 2 + _Pp1) / 3;
    end;
end;

if _Pp2 <> 0 then begin
    if _Center2 = 0 then begin
        _Center2 = _Pp2;
    end else begin
        _Center2 = (_Center2 * 2 + _Pp2) / 3;
    end;
end;

// 5.4 主趨勢線（原策略的紅綠線）
_Up1 = _Center1 - _Factor1 * _Atr1;
_Dn1 = _Center1 + _Factor1 * _Atr1;

if CurrentBar <= 1 then begin
    _TUp1 = _Up1;
    _TDn1 = _Dn1;
end else begin
    if Close[1] > _TUp1[1] then begin
        _TUp1 = MaxList(_Up1, _TUp1[1]);
    end else begin
        _TUp1 = _Up1;
    end;

    if Close[1] < _TDn1[1] then begin
        _TDn1 = MinList(_Dn1, _TDn1[1]);
    end else begin
        _TDn1 = _Dn1;
    end;
end;

if CurrentBar <= 1 then begin
    _Trend1 = 1;
end else if Close > _TDn1[1] then begin
    _Trend1 = 1;
end else if Close < _TUp1[1] then begin
    _Trend1 = -1;
end else begin
    _Trend1 = _Trend1[1];
end;

if _Trend1 = 1 then begin
    _Main = _TUp1;
end else begin
    _Main = _TDn1;
end;

// 5.5 紫色支撐線
_Up2 = _Center2 - _Factor2 * _Atr2;
_Dn2 = _Center2 + _Factor2 * _Atr2;

if CurrentBar <= 1 then begin
    _TUp2 = _Up2;
    _TDn2 = _Dn2;
end else begin
    if Close[1] > _TUp2[1] then begin
        _TUp2 = MaxList(_Up2, _TUp2[1]);
    end else begin
        _TUp2 = _Up2;
    end;

    if Close[1] < _TDn2[1] then begin
        _TDn2 = MinList(_Dn2, _TDn2[1]);
    end else begin
        _TDn2 = _Dn2;
    end;
end;

if CurrentBar <= 1 then begin
    _Trend2 = 1;
end else if Close > _TDn2[1] then begin
    _Trend2 = 1;
end else if Close < _TUp2[1] then begin
    _Trend2 = -1;
end else begin
    _Trend2 = _Trend2[1];
end;

if _Trend2 = 1 then begin
    _Purple = _TUp2;
end else begin
    _Purple = _TDn2;
end;

// ==============================================================
// 6. 成交同步與停利停損掛價
// ==============================================================
// 腳本重啟或帶入既有庫存時，先依實際部位補回方向，避免停損停利算反邊
if Position <> 0 and _ActDir = 0 then begin
    if Position > 0 then begin
        _ActDir = 1;
    end else begin
        _ActDir = -1;
    end;
    _EntryBar = CurrentBar;
end;

// 委託成交後才鎖定成本，停利停損一律以成交均價為基準
if Position <> 0 and Filled = Position and _EntryPx = 0 then begin
    _EntryPx = FilledAvgPrice;
    if _ActDir = 1 then begin
        _TPPx = _EntryPx + _TPPts;
        _SLPx = _EntryPx - _SLPoints;
    end else begin
        _TPPx = _EntryPx - _TPPts;
        _SLPx = _EntryPx + _SLPoints;
    end;
end;

// 部位若不是被本腳本平掉（例如人工出場），清掉殘留的追蹤狀態
if Position = 0 and Filled = 0 and _EntryPx <> 0 then begin
    _EntryPx = 0;
    _TPPx = 0;
    _SLPx = 0;
    _ActType = 0;
    _ActDir = 0;
end;

// ==============================================================
// 7. 出場判定（觸價，逐筆洗價）
// ==============================================================
_HitTP = 0;
_HitSL = 0;

if Position <> 0 and Filled = Position and _EntryPx <> 0 then begin

    // 進場當根只認最新成交價，避免拿進場之前的高低點誤判
    if CurrentBar = _EntryBar then begin
        if _ActDir = 1 then begin
            if Close >= _TPPx then _HitTP = 1;
            if Close <= _SLPx then _HitSL = 1;
        end else begin
            if Close <= _TPPx then _HitTP = 1;
            if Close >= _SLPx then _HitSL = 1;
        end;
    end else begin
        if _ActDir = 1 then begin
            if High >= _TPPx then _HitTP = 1;
            if Low <= _SLPx then _HitSL = 1;
        end else begin
            if Low <= _TPPx then _HitTP = 1;
            if High >= _SLPx then _HitSL = 1;
        end;
    end;

    // 同一次洗價兩邊都觸及時無從分辨先後，一律以停損認列
    if _HitSL = 1 then begin
        _HitTP = 0;
    end;

    if _HitTP = 1 or _HitSL = 1 then begin

        if _HitTP = 1 then begin
            SetPosition(0, MARKET, label:="停利平倉");
            Alert("停利出場", _TPPx);
            _IsWin = 1;
        end else begin
            SetPosition(0, MARKET, label:="停損平倉");
            Alert("停損出場", _SLPx);
            _IsWin = 0;
        end;
        _Acted = 1;

        // 7.1 日統計
        if _IsWin = 1 then begin
            _WinCnt = _WinCnt + 1;
        end else begin
            _LossCnt = _LossCnt + 1;
        end;

        // 7.2 動態停利點數：連續停利遞增，停損歸回基礎值
        if _UseDynTP = 1 then begin
            if _IsWin = 1 then begin
                _DynTP = _DynTP + 1;
            end else begin
                _DynTP = _TPPoints;
            end;
        end;

        // 7.3 止損後的冷卻與型態旗標
        if _IsWin = 0 then begin
            _PrevSLBar = CurrentBar;
            if _ActDir = 1 then begin
                _SLHitL = 1;
                _CandleOKL = 0;
            end else begin
                _SLHitS = 1;
                _CandleOKS = 0;
            end;
        end;

        // 7.4 多單平倉後的各模式狀態接續
        if _ActDir = 1 then begin

            // V3、V5 走各自的計數機制，不重新裝填 V2
            if _ActType <> 3 and _ActType <> 5 then begin
                _V2LArmed = 1;
                _V2LPull = 0;
            end;

            if _IsWin = 0 then begin
                _SLRunL = _SLRunL + 1;
                // 連續止損達容許次數就撤掉錨定線，該趨勢內不再觸發 V4
                if _V4SLTolerance > 0 and _SLRunL >= _V4SLTolerance then begin
                    _V4LAnchor = 0;
                end else begin
                    _V4LAnchor = _Purple;
                end;
            end else begin
                _SLRunL = 0;
                _V4LAnchor = _Purple;
                if _V4LooseMode = 1 and _ActType = 4 then begin
                    _V4LCnt = 0;
                end;
                if _ActType = 7 then begin
                    _V4LCnt = 0;
                end;
            end;

            if _ActType = 5 then begin
                if _IsWin = 0 then begin
                    _V5LSLRun = _V5LSLRun + 1;
                end else begin
                    _V5LSLRun = 0;
                end;
            end;
        end;

        // 7.5 空單平倉後的各模式狀態接續
        if _ActDir = -1 then begin

            if _ActType <> 3 and _ActType <> 5 then begin
                _V2SArmed = 1;
                _V2SPull = 0;
            end;

            if _IsWin = 1 and _ActType = 7 then begin
                _ThreeSWin = _ThreeSWin + 1;
            end;

            if _IsWin = 0 then begin
                _SLRunS = _SLRunS + 1;
                if _V4SLTolerance > 0 and _SLRunS >= _V4SLTolerance then begin
                    _V4SAnchor = 0;
                end else begin
                    _V4SAnchor = _Purple;
                end;
            end else begin
                _SLRunS = 0;
                _V4SAnchor = _Purple;
                if _V4LooseMode = 1 and _ActType = 4 then begin
                    _V4SCnt = 0;
                end;
                if _ActType = 7 then begin
                    _V4SCnt = 0;
                end;
            end;

            if _ActType = 5 then begin
                if _IsWin = 0 then begin
                    _V5SSLRun = _V5SSLRun + 1;
                end else begin
                    _V5SSLRun = 0;
                end;
            end;
        end;

        _ActType = 0;
        _ActDir = 0;
        _EntryPx = 0;
        _TPPx = 0;
        _SLPx = 0;
    end;
end;

// ==============================================================
// 8. 停盤條件評估
// ==============================================================
_DoneCnt = _WinCnt + _LossCnt;

if _DoneCnt > 0 then begin
    _WinRate = _WinCnt / _DoneCnt * 100;
end else begin
    _WinRate = 0;
end;

if _UseWinRateStop = 1 and _DoneCnt >= _MinTradesForWR and _WinRate >= _TargetWinRate then begin
    _WRBlocked = 1;
end;

// 開倉前六倉內累計四次止損即當日收手
if _UseLoss64 = 1 and _EntryCnt <= 6 and _LossCnt >= 4 then begin
    _LossBlocked = 1;
end;

// ==============================================================
// 9. 訊號引擎（每根 K 棒只跑一次，資料一律取剛收完的那根）
// ==============================================================
_IsNewBar = 0;
if CurrentBar <> _CalcBar then begin
    _IsNewBar = 1;
end;

if _IsNewBar = 1 then begin

    _CalcBar = CurrentBar;
    _SigBar = CurrentBar - 1;

    // 9.1 訊號快照
    _SigO = Open[1];
    _SigH = High[1];
    _SigL = Low[1];
    _SigC = Close[1];
    _SigT1 = _Trend1[1];
    _SigT1P = _Trend1[2];
    _SigMain = _Main[1];
    _SigMainP = _Main[2];
    _SigPur = _Purple[1];
    _SigPurP = _Purple[2];

    // 9.2 跳空保護：開盤根反向跳空，該根與下一根都放棄開倉
    _SigWasOpenBar = 0;
    if _OpenBarNo > 0 and _SigBar = _OpenBarNo then begin
        _SigWasOpenBar = 1;
    end;

    if _UseGapProtect = 1 then begin
        if _SigWasOpenBar = 1 then begin
            _GapDown = 0;
            _GapUp = 0;
            if _SigO < Close[2] then _GapDown = 1;
            if _SigO > Close[2] then _GapUp = 1;

            if _GapDown = 1 then begin
                _GapDir = -1;
                _GapBars = 2;
            end else if _GapUp = 1 then begin
                _GapDir = 1;
                _GapBars = 2;
            end else begin
                _GapDir = 0;
                _GapBars = 0;
            end;
        end else if _GapBars > 0 then begin
            _GapBars = _GapBars - 1;
            if _GapBars <= 0 then begin
                _GapDir = 0;
            end;
        end;
    end else begin
        _GapBars = 0;
        _GapDir = 0;
    end;

    _BlockLongGap = 0;
    _BlockShortGap = 0;
    if _UseGapProtect = 1 and _GapBars > 0 and _GapDir = -1 then begin
        _BlockLongGap = 1;
    end;
    if _UseGapProtect = 1 and _GapBars > 0 and _GapDir = 1 then begin
        _BlockShortGap = 1;
    end;

    // 9.3 止損後型態確認：多單需先出一根陽 K，空單需先出一根陰 K
    if _CandleOKL = 0 and _SigC > _SigO then begin
        _CandleOKL = 1;
    end;
    if _CandleOKS = 0 and _SigC < _SigO then begin
        _CandleOKS = 1;
    end;

    // 9.4 V5 回踩模式狀態機
    if _V5Long = 1 and _V5Pullback = 1 then begin
        if _SigPur > _SigMain and _SigPurP <= _SigMainP then begin
            _V5LCross = 1;
            _V5LPull = 0;
        end;
        if _V5LCross = 1 and _SigL <= _SigPur then begin
            _V5LPull = 1;
        end;
    end;

    if _V5Short = 1 and _V5Pullback = 1 then begin
        if _SigPur < _SigMain and _SigPurP >= _SigMainP then begin
            _V5SCross = 1;
            _V5SPull = 0;
        end;
        if _V5SCross = 1 and _SigH >= _SigPur then begin
            _V5SPull = 1;
        end;
    end;

    // 9.5 V5 傳統模式的延遲確認
    if _V5Pullback = 0 then begin

        if _V5Long = 1 and _V5ConfirmBars > 0 then begin
            if _SigPur > _SigMain and _SigPurP <= _SigMainP then begin
                _V5LBars = 0;
                _V5LOK = 0;
            end;
            if _V5LBars < _V5ConfirmBars then begin
                _V5LBars = _V5LBars + 1;
                if _SigC > _SigMain and _SigC > _SigPur then begin
                    _V5LOK = 1;
                end else begin
                    _V5LOK = 0;
                end;
            end;
        end else begin
            _V5LOK = 1;
        end;

        if _V5Short = 1 and _V5ConfirmBars > 0 then begin
            if _SigPur < _SigMain and _SigPurP >= _SigMainP then begin
                _V5SBars = 0;
                _V5SOK = 0;
            end;
            if _V5SBars < _V5ConfirmBars then begin
                _V5SBars = _V5SBars + 1;
                if _SigC < _SigMain and _SigC < _SigPur then begin
                    _V5SOK = 1;
                end else begin
                    _V5SOK = 0;
                end;
            end;
        end else begin
            _V5SOK = 1;
        end;
    end;

    // 9.6 趨勢翻轉：對側狀態全部歸零重新計數
    if _SigT1 = -1 and _SigT1P = 1 then begin
        _V2LArmed = 0;
        _V4LAnchor = 0;
        _SLHitL = 0;
        _SLRunL = 0;
        _V4LCnt = 0;
        _CandleOKL = 1;
        _BkLFired = 0;
        _ThreeLCnt = 0;
        _V5LCnt = 0;
        _V5LSLRun = 0;
        _V5LCross = 0;
        _V5LPull = 0;
        _V5LOK = 0;
        _V5LBars = 0;
    end;

    if _SigT1 = 1 and _SigT1P = -1 then begin
        _V2SArmed = 0;
        _V4SAnchor = 0;
        _SLHitS = 0;
        _SLRunS = 0;
        _V4SCnt = 0;
        _CandleOKS = 1;
        _BkSFired = 0;
        _ThreeSCnt = 0;
        _ThreeSWin = 0;
        _V5SCnt = 0;
        _V5SSLRun = 0;
        _V5SCross = 0;
        _V5SPull = 0;
        _V5SOK = 0;
        _V5SBars = 0;
    end;

    // 9.7 V2 回踩偵測
    if _V2LArmed = 1 and _SigL <= _SigPur then begin
        _V2LPull = 1;
    end;
    if _V2SArmed = 1 and _SigH >= _SigPur then begin
        _V2SPull = 1;
    end;

    // 9.8 共用濾網
    _InTimeWindow = 1;
    if _UseStartDate = 1 and Date < _StartDate then begin
        _InTimeWindow = 0;
    end;

    if _UseNightFilter = 1 then begin
        if _NightBlockStart < _NightBlockEnd then begin
            if CurrentTime >= _NightBlockStart and CurrentTime < _NightBlockEnd then begin
                _InTimeWindow = 0;
            end;
        end else begin
            // 起訖跨過午夜時，兩段時間都算在禁止區間內
            if CurrentTime >= _NightBlockStart or CurrentTime < _NightBlockEnd then begin
                _InTimeWindow = 0;
            end;
        end;
    end;

    _BlockDelay = 0;
    if _UseSLDelay = 1 and _PrevSLBar > 0 and _SigBar <= _PrevSLBar + _SLDelayBars then begin
        _BlockDelay = 1;
    end;

    _CanTrade = 1;
    if _UseNoOpenBefore0900 = 1 and CurrentTime >= 084500 and CurrentTime < 090000 then begin
        _CanTrade = 0;
    end;
    if _LossBlocked = 1 or _WRBlocked = 1 then begin
        _CanTrade = 0;
    end;
    if Position <> 0 or Filled <> 0 then begin
        _CanTrade = 0;
    end;
    if _Acted = 1 then begin
        _CanTrade = 0;                                                               // 本次洗價已送出平倉，讓下一根再判進場
    end;

    // 9.9 四陽三陰
    _ThreeGreen = 0;
    _ThreeRed = 0;
    if Close[1] > Open[1] and Close[2] > Open[2] and Close[3] > Open[3] and Close[4] > Open[4] then begin
        _ThreeGreen = 1;
    end;
    if Close[1] < Open[1] and Close[2] < Open[2] and Close[3] < Open[3] then begin
        _ThreeRed = 1;
    end;

    _AboveLines = 0;
    _UnderLines = 0;
    if _ThreeIgnorePurple = 1 then begin
        if _SigC > _SigMain then _AboveLines = 1;
        if _SigC < _SigMain then _UnderLines = 1;
    end else begin
        if _SigC > _SigMain and _SigC > _SigPur then _AboveLines = 1;
        if _SigC < _SigMain and _SigC < _SigPur then _UnderLines = 1;
    end;

    // 設定 3 次以上時，空單需前兩次皆停利才放行第 3 次
    if _ThreeMaxEntries >= 3 and _ThreeSWin < 2 then begin
        _ThreeSCap = 2;
    end else begin
        _ThreeSCap = _ThreeMaxEntries;
    end;

    _ThreeL = 0;
    if _ThreeLong = 1 and _SigT1 = 1 and _ThreeGreen = 1 and _AboveLines = 1 and _LongOpen = 1
        and _InTimeWindow = 1 and _BlockLongGap = 0 and _ThreeLCnt < _ThreeMaxEntries then begin
        _ThreeL = 1;
    end;

    _ThreeS = 0;
    if _ThreeShort = 1 and _SigT1 = -1 and _ThreeRed = 1 and _UnderLines = 1 and _ShortOpen = 1
        and _InTimeWindow = 1 and _BlockShortGap = 0 and _ThreeSCnt < _ThreeSCap then begin
        _ThreeS = 1;
    end;

    // 9.10 V1 趨勢翻轉進場
    _V1L = 0;
    if _SigT1 = 1 and _SigT1P = -1 and _LongOpen = 1 and _InTimeWindow = 1
        and _BlockLongGap = 0 and _BlockDelay = 0 then begin
        _V1L = 1;
    end;

    _V1S = 0;
    if _SigT1 = -1 and _SigT1P = 1 and _ShortOpen = 1 and _InTimeWindow = 1
        and _BlockShortGap = 0 and _BlockDelay = 0 then begin
        _V1S = 1;
    end;

    // 9.11 V2 回踩支撐後突破
    _V2L = 0;
    if _V2Long = 1 and _SigT1 = 1 and _V2LPull = 1 and _SigC > _SigPur
        and _InTimeWindow = 1 and _BlockLongGap = 0 and _BlockDelay = 0
        and (_UseSLCooldown = 0 or _SLHitL = 0)
        and (_UseSLCandle = 0 or _CandleOKL = 1) then begin
        _V2L = 1;
    end;

    _V2S = 0;
    if _V2Short = 1 and _SigT1 = -1 and _V2SPull = 1 and _SigC < _SigPur
        and _InTimeWindow = 1 and _BlockShortGap = 0 and _BlockDelay = 0
        and (_UseSLCooldown = 0 or _SLHitS = 0)
        and (_UseSLCandle = 0 or _CandleOKS = 1) then begin
        _V2S = 1;
    end;

    // 9.12 V3 主線觸及紫線
    _V3L = 0;
    if _V3Long = 1 and _SigT1 = 1 and _SigMain > _SigPur and _SigMainP <= _SigPurP
        and _LongOpen = 1 and _InTimeWindow = 1 and _BlockLongGap = 0 and _BlockDelay = 0
        and (_UseSLCandle = 0 or _CandleOKL = 1) then begin
        _V3L = 1;
    end;

    _V3S = 0;
    if _V3Short = 1 and _SigT1 = -1 and _SigMain < _SigPur and _SigMainP >= _SigPurP
        and _ShortOpen = 1 and _InTimeWindow = 1 and _BlockShortGap = 0 and _BlockDelay = 0
        and (_UseSLCandle = 0 or _CandleOKS = 1) then begin
        _V3S = 1;
    end;

    // 9.13 V4 主線到達錨定支撐
    _V4L = 0;
    if _V4Long = 1 and _V4LAnchor <> 0 and _SigT1 = 1 and _SigMain >= _V4LAnchor
        and _LongOpen = 1 and _InTimeWindow = 1 and _BlockLongGap = 0 and _BlockDelay = 0
        and _V4LCnt < _V4MaxEntries and (_UseSLCandle = 0 or _CandleOKL = 1) then begin
        _V4L = 1;
    end;

    _V4S = 0;
    if _V4Short = 1 and _V4SAnchor <> 0 and _SigT1 = -1 and _SigMain <= _V4SAnchor
        and _ShortOpen = 1 and _InTimeWindow = 1 and _BlockShortGap = 0 and _BlockDelay = 0
        and _V4SCnt < _V4MaxEntries and (_UseSLCandle = 0 or _CandleOKS = 1) then begin
        _V4S = 1;
    end;

    // 9.14 夜盤支撐線突破
    _BkL = 0;
    if _UseBreakout = 1 and _BreakAnchor <> 0 and _SigT1 = 1 and _SigMain >= _BreakAnchor
        and (_SigT1P = -1 or _SigMainP < _BreakAnchor)
        and _LongOpen = 1 and _InTimeWindow = 1 and _BlockLongGap = 0 and _BlockDelay = 0
        and (_UseSLCandle = 0 or _CandleOKL = 1)
        and _BkLFired = 0 and CurrentTime < _BreakEndTime then begin
        _BkL = 1;
    end;

    _BkS = 0;
    if _UseBreakout = 1 and _BreakAnchor <> 0 and _SigT1 = -1 and _SigMain <= _BreakAnchor
        and (_SigT1P = 1 or _SigMainP > _BreakAnchor)
        and _ShortOpen = 1 and _InTimeWindow = 1 and _BlockShortGap = 0 and _BlockDelay = 0
        and (_UseSLCandle = 0 or _CandleOKS = 1)
        and _BkSFired = 0 and CurrentTime < _BreakEndTime then begin
        _BkS = 1;
    end;

    // 9.15 V5 紫線穿越主線
    _V5L = 0;
    _V5S = 0;

    if _V5Pullback = 1 then begin

        if _V5Long = 1 and _V5LCross = 1 and _V5LPull = 1 and _SigC > _SigPur and _SigC > _SigMain
            and _SigT1 = 1 and _LongOpen = 1 and _InTimeWindow = 1
            and _BlockLongGap = 0 and _BlockDelay = 0 and (_UseSLCandle = 0 or _CandleOKL = 1)
            and _V5LCnt < _V5MaxEntries
            and (_V5SLTolerance = 0 or _V5LSLRun < _V5SLTolerance) then begin
            _V5L = 1;
        end;

        if _V5Short = 1 and _V5SCross = 1 and _V5SPull = 1 and _SigC < _SigPur and _SigC < _SigMain
            and _SigT1 = -1 and _ShortOpen = 1 and _InTimeWindow = 1
            and _BlockShortGap = 0 and _BlockDelay = 0 and (_UseSLCandle = 0 or _CandleOKS = 1)
            and _V5SCnt < _V5MaxEntries
            and (_V5SLTolerance = 0 or _V5SSLRun < _V5SLTolerance) then begin
            _V5S = 1;
        end;

    end else begin

        // 傳統模式加掛「價格離主線不得太遠」的追高防護
        _DistOK = 0;
        if _SigMain <> 0 and AbsValue(_SigC - _SigMain) / _SigMain * 100 <= _V5PriceDist then begin
            _DistOK = 1;
        end;

        if _V5Long = 1 and _DistOK = 1 and _SigT1 = 1 and _SigPur > _SigMain and _SigPurP <= _SigMainP
            and _LongOpen = 1 and _InTimeWindow = 1
            and _BlockLongGap = 0 and _BlockDelay = 0 and (_UseSLCandle = 0 or _CandleOKL = 1)
            and _V5LCnt < _V5MaxEntries
            and (_V5SLTolerance = 0 or _V5LSLRun < _V5SLTolerance)
            and (_V5ConfirmBars = 0 or _V5LOK = 1) then begin
            _V5L = 1;
        end;

        if _V5Short = 1 and _DistOK = 1 and _SigT1 = -1 and _SigPur < _SigMain and _SigPurP >= _SigMainP
            and _ShortOpen = 1 and _InTimeWindow = 1
            and _BlockShortGap = 0 and _BlockDelay = 0 and (_UseSLCandle = 0 or _CandleOKS = 1)
            and _V5SCnt < _V5MaxEntries
            and (_V5SLTolerance = 0 or _V5SSLRun < _V5SLTolerance)
            and (_V5ConfirmBars = 0 or _V5SOK = 1) then begin
            _V5S = 1;
        end;
    end;

    // 9.16 互斥網：四陽三陰 > V1 > V2 > V3 > V4 > 夜盤突破 > V5
    _NewType = 0;
    _LongEntry = 0;
    _ShortEntry = 0;

    if _ThreeL = 1 then begin
        _LongEntry = 1;
        _NewType = 7;
    end else if _V1L = 1 then begin
        _LongEntry = 1;
        _NewType = 1;
    end else if _V2L = 1 then begin
        _LongEntry = 1;
        _NewType = 2;
    end else if _V3L = 1 then begin
        _LongEntry = 1;
        _NewType = 3;
    end else if _V4L = 1 then begin
        _LongEntry = 1;
        _NewType = 4;
    end else if _BkL = 1 then begin
        _LongEntry = 1;
        _NewType = 6;
    end else if _V5L = 1 then begin
        _LongEntry = 1;
        _NewType = 5;
    end;

    if _ThreeS = 1 or _V1S = 1 or _V2S = 1 or _V3S = 1 or _V4S = 1 or _BkS = 1 or _V5S = 1 then begin
        _ShortEntry = 1;
    end;

    // 多空同根成立時讓給空方，維持原策略的優先序
    if _LongEntry = 1 and _ShortEntry = 1 then begin
        _LongEntry = 0;
    end;

    if _ShortEntry = 1 then begin
        if _ThreeS = 1 then begin
            _NewType = 7;
        end else if _V1S = 1 then begin
            _NewType = 1;
        end else if _V2S = 1 then begin
            _NewType = 2;
        end else if _V3S = 1 then begin
            _NewType = 3;
        end else if _V4S = 1 then begin
            _NewType = 4;
        end else if _BkS = 1 then begin
            _NewType = 6;
        end else begin
            _NewType = 5;
        end;
    end;

    // 四陽三陰以外的模式仍須主趨勢方向相符
    if _LongEntry = 1 and _NewType <> 7 and _SigT1 <> 1 then begin
        _LongEntry = 0;
    end;
    if _ShortEntry = 1 and _NewType <> 7 and _SigT1 <> -1 then begin
        _ShortEntry = 0;
    end;

    if _CanTrade = 0 then begin
        _LongEntry = 0;
        _ShortEntry = 0;
    end;

    // 9.17 模式名稱，供警示訊息辨識
    if _NewType = 1 then begin
        _TypeTxt = "V1 趨勢翻轉";
    end else if _NewType = 2 then begin
        _TypeTxt = "V2 回踩突破";
    end else if _NewType = 3 then begin
        _TypeTxt = "V3 主線觸線";
    end else if _NewType = 4 then begin
        _TypeTxt = "V4 錨定支撐";
    end else if _NewType = 5 then begin
        _TypeTxt = "V5 紫線穿越";
    end else if _NewType = 6 then begin
        _TypeTxt = "夜盤支撐突破";
    end else if _NewType = 7 then begin
        _TypeTxt = "四陽三陰";
    end else begin
        _TypeTxt = "";
    end;

    // ==============================================================
    // 10. 進場執行
    // ==============================================================
    if _LongEntry = 1 then begin
        SetPosition(_Qty, MARKET, label:="做多進場");
        Alert("做多進場", _TypeTxt, Close);

        _ActType = _NewType;
        _ActDir = 1;
        _EntryBar = CurrentBar;
        _EntryPx = 0;
        _EntryCnt = _EntryCnt + 1;
        _Acted = 1;

        if _NewType = 7 then begin
            _ThreeLCnt = _ThreeLCnt + 1;
        end;
        if _NewType = 4 then begin
            _V4LCnt = _V4LCnt + 1;
            _V4LAnchor = 0;
        end;
        if _NewType = 6 then begin
            _BkLFired = 1;
            _BreakAnchor = 0;
        end;
        if _NewType = 5 then begin
            _V5LCnt = _V5LCnt + 1;
            _V5LCross = 0;
            _V5LPull = 0;
        end;
        if _NewType = 2 then begin
            _V2LArmed = 0;
            _V2LPull = 0;
        end;
    end;

    if _ShortEntry = 1 then begin
        SetPosition(-1 * _Qty, MARKET, label:="做空進場");
        Alert("做空進場", _TypeTxt, Close);

        _ActType = _NewType;
        _ActDir = -1;
        _EntryBar = CurrentBar;
        _EntryPx = 0;
        _EntryCnt = _EntryCnt + 1;
        _Acted = 1;

        if _NewType = 7 then begin
            _ThreeSCnt = _ThreeSCnt + 1;
        end;
        if _NewType = 4 then begin
            _V4SCnt = _V4SCnt + 1;
            _V4SAnchor = 0;
        end;
        if _NewType = 6 then begin
            _BkSFired = 1;
            _BreakAnchor = 0;
        end;
        if _NewType = 5 then begin
            _V5SCnt = _V5SCnt + 1;
            _V5SCross = 0;
            _V5SPull = 0;
        end;
        if _NewType = 2 then begin
            _V2SArmed = 0;
            _V2SPull = 0;
        end;
    end;

end;

// ==============================================================
// 11. 收尾：記錄本次洗價的日期時間，供下次盤別判定
// ==============================================================
_PrevDate = Date;
_PrevTime = CurrentTime;
