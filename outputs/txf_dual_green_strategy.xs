// ==============================================================
// 台指期 雙陽開泰策略（XS 自動交易腳本）
// 來源：PineScript v6「台指期 の 雙陽開泰策略 V3.93」轉寫
// 適用商品：台指期／小台（全日盤）　適用頻率：分鐘
// 訊號規則：以「已收盤的 K 棒」確認訊號，下一根 K 棒開盤市價進場
//           （等同原策略「收盤確認訊號、次根成交」的機制）
// ==============================================================

// ==============================================================
// 1. 參數宣告區
// ==============================================================

// 1.1 交易總開關
input: _MakeSure(0, "了解策略風險請選【是】", InputKind:=Dict(["否", 0], ["是", 1]), Quickedit:=True);
input: _Lots(1, "每次進場口數");
input: _EnableLong(1, "開啟多單", InputKind:=Dict(["是", 1], ["否", 0]), Quickedit:=True);
input: _EnableShort(1, "開啟空單", InputKind:=Dict(["是", 1], ["否", 0]), Quickedit:=True);

// 1.2 均線設定（多空各自獨立，可用不同型態與期數）
input: _LongMaType(2, "做多均線類型", InputKind:=Dict(["EMA", 2], ["SMA", 1], ["WMA", 3], ["RMA", 4], ["HMA", 5]), Quickedit:=True);
input: _LongFastLen(7, "做多短均線期數");
input: _LongSlowLen(33, "做多中均線期數");
input: _ShortMaType(2, "做空均線類型", InputKind:=Dict(["EMA", 2], ["SMA", 1], ["WMA", 3], ["RMA", 4], ["HMA", 5]), Quickedit:=True);
input: _ShortFastLen(7, "做空短均線期數");
input: _ShortSlowLen(33, "做空中均線期數");
input: _LongSlopeTh(0.5, "做多中均線斜率下限(點)");
input: _ShortSlopeTh(-0.5, "做空中均線斜率上限(點)");

// 1.3 進場模式
input: _LooseLong(0, "做多寬鬆進場模式", InputKind:=Dict(["否", 0], ["是", 1]), Quickedit:=True);
input: _LooseShort(0, "做空寬鬆進場模式", InputKind:=Dict(["否", 0], ["是", 1]), Quickedit:=True);
input: _StepCrossLong(0, "做多寬鬆允許跨根完成", InputKind:=Dict(["否", 0], ["是", 1]), Quickedit:=True);
input: _StepCrossShort(0, "做空寬鬆允許跨根完成", InputKind:=Dict(["否", 0], ["是", 1]), Quickedit:=True);
input: _AggressiveLong(0, "做多止盈後激進進場", InputKind:=Dict(["否", 0], ["是", 1]), Quickedit:=True);
input: _AggressiveShort(0, "做空止盈後激進進場", InputKind:=Dict(["否", 0], ["是", 1]), Quickedit:=True);
input: _FourGreenLong(0, "四陽獨立開多(無視均線)", InputKind:=Dict(["否", 0], ["是", 1]), Quickedit:=True);
input: _FourGreenMaxEntry(2, "四陽開多同趨勢最多進場次數");
input: _FourGreenMaxSl(2, "四陽開多累計止損阻斷次數");

// 1.4 風險控管
input: _EnableMinSl(0, "限制初始止損距離過小", InputKind:=Dict(["否", 0], ["是", 1]), Quickedit:=True);
input: _MinSlPoints(20, "最小允許止損點數");
input: _EnableMaxSl(1, "啟用最大強制止損", InputKind:=Dict(["是", 1], ["否", 0]), Quickedit:=True);
input: _MaxSlPoints(100, "最大強制止損點數");
input: _EnableDynMinSl(0, "啟用動態最小止損距離", InputKind:=Dict(["否", 0], ["是", 1]), Quickedit:=True);
input: _DynMinSlPoints(10, "動態最小止損距離(點)");
input: _AntiKnifeLong(0, "做多止損後防接刀", InputKind:=Dict(["否", 0], ["是", 1]), Quickedit:=True);
input: _AntiKnifeShort(0, "做空止損後防接刀", InputKind:=Dict(["否", 0], ["是", 1]), Quickedit:=True);
input: _AntiConsecSlLong(0, "連兩次止損阻斷一般做多", InputKind:=Dict(["否", 0], ["是", 1]), Quickedit:=True);
input: _AntiConsecSlShort(0, "連兩次止損阻斷一般做空", InputKind:=Dict(["否", 0], ["是", 1]), Quickedit:=True);
input: _AllowLongSl(1, "同趨勢做多允許止損次數(0=不限)");
input: _AllowShortSl(1, "同趨勢做空允許止損次數(0=不限)");

// 1.5 移動止盈
input: _EnableTrailTp(1, "啟用移動止盈", InputKind:=Dict(["是", 1], ["否", 0]), Quickedit:=True);
input: _TrailTpTrigger(400, "移動止盈觸發點數");
input: _TrailTpRetrace(5.0, "移動止盈回吐百分比(%)");

// 1.6 跳空與止損冷卻
input: _EnableGapProtect(1, "開啟跳空保護", InputKind:=Dict(["是", 1], ["否", 0]), Quickedit:=True);
input: _GapPoints(50, "跳空最小點數");
input: _GapCooldown(3, "跳空後冷卻根數");
input: _EnableSlCooldown(1, "開啟止損後冷卻", InputKind:=Dict(["是", 1], ["否", 0]), Quickedit:=True);
input: _SlCooldownBars(3, "止損後冷卻根數");

// 1.7 時間過濾
input: _NoWeekendHold(1, "不跨週盤(週五午後只平不開)", InputKind:=Dict(["是", 1], ["否", 0]), Quickedit:=True);
input: _Restrict0430(0, "04:30~09:00 禁止開倉", InputKind:=Dict(["否", 0], ["是", 1]), Quickedit:=True);
input: _OpenCooldown(1, "避開開盤跳空冷卻", InputKind:=Dict(["是", 1], ["否", 0]), Quickedit:=True);
input: _OpenCooldownMins(15, "開盤冷卻分鐘數");
input: _NightClose(1, "夜盤定時強制平倉", InputKind:=Dict(["是", 1], ["否", 0]), Quickedit:=True);
input: _NightCloseHour(4, "夜盤平倉時(0-23)");
input: _NightCloseMin(50, "夜盤平倉分(0-59)");
input: _ForbidSession(1, "開啟禁止開倉時段", InputKind:=Dict(["是", 1], ["否", 0]), Quickedit:=True);
input: _ForbidStartHour(21, "禁止開倉起始時");
input: _ForbidStartMin(0, "禁止開倉起始分");
input: _ForbidEndHour(9, "禁止開倉結束時");
input: _ForbidEndMin(0, "禁止開倉結束分");

// ==============================================================
// 2. 變數宣告區
// ==============================================================

// 2.1 指標與訊號（每次洗價重算，需保留序列以取用前一根數值）
var: _Src(0);
var: _LongMa1(0), _LongMa2(0), _ShortMa1(0), _ShortMa2(0);
var: _L1Hull(0), _L2Hull(0), _S1Hull(0), _S2Hull(0);
var: _SigOpen(0), _SigClose(0);
var: _PreOpen(0), _PreClose(0), _PreLow(0), _PreHigh(0);
var: _LongMa1Sig(0), _LongMa2Sig(0), _LongMa1Pre(0), _LongMa2Pre(0), _LongSlope(0);
var: _ShortMa1Sig(0), _ShortMa2Sig(0), _ShortMa1Pre(0), _ShortMa2Pre(0), _ShortSlope(0);

// 2.2 進場條件（布林暫存，不跨洗價保留）
var: _IsNewBar(false);
var: _StrictLong(false), _LooseLongCross(false), _LooseLongOk(false), _BaseLong(false);
var: _StrictShort(false), _LooseShortCross(false), _LooseShortOk(false), _BaseShort(false);
var: _PassMinSlLong(false), _PassMinSlShort(false);
var: _PassKnifeLong(false), _PassKnifeShort(false);
var: _StrictTpOk(false), _LooseTpOk(false), _FourGreen(false);
var: _LongCond(false), _ShortCond(false), _FourGreenCond(false);
var: _TrigNormalLong(false), _TrigLong(false), _TrigShort(false), _PureFourGreen(false);
var: _FinalLong(false), _FinalShort(false), _FinalPureFourGreen(false);
var: _AggLongTrig(false), _AggShortTrig(false);
var: _InitSlLong(0), _InitSlShort(0), _InitSlLongCap(0), _InitSlShortCap(0);

// 2.3 時間與冷卻旗標
var: _NowMins(0), _DayIdx(0);
var: _NoOpenWindow(false), _WeekendClose(false), _Is0845(false), _IsSessionTail(false);
var: _InForbidSession(false), _In0430Window(false), _IsNightCloseTime(false);
var: _InGapCooldown(false), _InSlCooldown(false);
var: _BlockStartMins(0), _BlockEndMins(0);

// 2.4 出場暫存
var: _ExitReason(0), _ExitRefPrice(0), _ExitDir(0), _ExitIsWin(0);
var: _TrailTpPrice(0), _TrailArmed(false), _MaxSlPrice(0), _DynSlPrice(0);

// 2.5 跨洗價保留的狀態（部位、阻斷計數、冷卻位置）
var:
    intrabarpersist _EntryPrice(0),          // 進場成本
    intrabarpersist _StopPrice(0),           // 目前止損價（會隨 K 棒推升／下壓）
    intrabarpersist _PeakPrice(0),           // 持倉期間極值：多單取最高、空單取最低
    intrabarpersist _LastLongIsFourGreen(0), // 本筆多單是否由四陽訊號觸發
    intrabarpersist _LongSlCount(0),         // 同趨勢做多止損次數
    intrabarpersist _ShortSlCount(0),        // 同趨勢做空止損次數
    intrabarpersist _BlockLong(0),           // 同趨勢做多阻斷
    intrabarpersist _BlockShort(0),          // 同趨勢做空阻斷
    intrabarpersist _ConsecLongSl(0),        // 一般做多連續止損計數
    intrabarpersist _ConsecShortSl(0),       // 一般做空連續止損計數
    intrabarpersist _NormalLongBlocked(0),   // 一般做多被連續止損阻斷
    intrabarpersist _NormalShortBlocked(0),  // 一般做空被連續止損阻斷
    intrabarpersist _LastSlEntryLong(0),     // 上次做多止損單的進場價（0=無紀錄）
    intrabarpersist _LastSlEntryShort(0),    // 上次做空止損單的進場價（0=無紀錄）
    intrabarpersist _FourGreenEntry(0),      // 四陽開多已進場次數
    intrabarpersist _FourGreenSl(0),         // 四陽開多止損次數
    intrabarpersist _FourGreenBlocked(0),    // 四陽開多阻斷
    intrabarpersist _LastGapBar(0),          // 最近一次跳空的 K 棒編號
    intrabarpersist _LastSlBar(0),           // 最近一次止損的 K 棒編號
    intrabarpersist _LastTpBar(0),           // 最近一次止盈的 K 棒編號
    intrabarpersist _AggLongBar(0),          // 待觸發的激進做多 K 棒編號
    intrabarpersist _AggShortBar(0),         // 待觸發的激進做空 K 棒編號
    intrabarpersist _PendingLong(0),         // 04:30~09:00 暫存的多單訊號
    intrabarpersist _PendingShort(0),        // 04:30~09:00 暫存的空單訊號
    intrabarpersist _PendingFourGreen(0);    // 暫存訊號是否為純四陽開多

// ==============================================================
// 3. 資源預載與環境預檢
// ==============================================================
// 均線最長期數的數倍加緩衝，確保 HMA／EMA 初始化收斂
SetBarBack(MaxList(_LongSlowLen, _ShortSlowLen, _LongFastLen, _ShortFastLen) * 4 + 60);

if BarFreq <> "Min" then RaiseRunTimeError("本策略僅支援分鐘頻率");
if _MakeSure <> 1 then RaiseRunTimeError("請確實了解策略內容，並將【了解策略風險】設為【是】");
if _Lots <= 0 then RaiseRunTimeError("每次進場口數必須大於 0");
if _LongFastLen <= 0 or _LongSlowLen <= 0 or _ShortFastLen <= 0 or _ShortSlowLen <= 0 then RaiseRunTimeError("均線期數必須大於 0");
if _MinSlPoints <= 0 or _MaxSlPoints <= 0 or _DynMinSlPoints <= 0 then RaiseRunTimeError("止損點數參數必須大於 0");
if _TrailTpTrigger <= 0 then RaiseRunTimeError("移動止盈觸發點數必須大於 0");
if _TrailTpRetrace <= 0 or _TrailTpRetrace > 100 then RaiseRunTimeError("移動止盈回吐百分比須介於 0 與 100 之間");

// IsFirstCall 會被「呼叫」消耗，必須無條件取值後存起來重複使用
_IsNewBar = IsFirstCall("Bar");

// ==============================================================
// 4. 時間與環境判斷（每次洗價都要更新，強制平倉需即時反應）
// ==============================================================
_NowMins = Hour(CurrentTime) * 60 + Minute(CurrentTime);
_DayIdx = DayOfWeek(Date);           // 0=星期日 ... 6=星期六

_NoOpenWindow = false;
_WeekendClose = false;

// 4.1 不跨週盤：週五 13:30 後只平不開，週六 04:30 起強制平倉，直到週一 08:45
if _NoWeekendHold = 1 then begin
    if (_DayIdx = 5) and _NowMins >= 810 then _NoOpenWindow = true;
    if _DayIdx = 6 then begin
        _NoOpenWindow = true;
        if _NowMins >= 270 then _WeekendClose = true;
    end;
    if _DayIdx = 0 then begin
        _NoOpenWindow = true;
        _WeekendClose = true;
    end;
    if (_DayIdx = 1) and _NowMins < 525 then begin
        _NoOpenWindow = true;
        _WeekendClose = true;
    end;
end;

// 4.2 開盤跳空冷卻：08:45 起算 N 分鐘內不開新倉
if (_OpenCooldown = 1) and _NowMins >= 525 and _NowMins < 525 + _OpenCooldownMins then _NoOpenWindow = true;

// 4.3 禁止開倉時段（支援跨日，例如 21:00~次日 09:00）
_BlockStartMins = _ForbidStartHour * 60 + _ForbidStartMin;
_BlockEndMins = _ForbidEndHour * 60 + _ForbidEndMin;
_InForbidSession = false;
if _ForbidSession = 1 then begin
    if _BlockEndMins <= _BlockStartMins then begin
        if _NowMins >= _BlockStartMins or _NowMins < _BlockEndMins then _InForbidSession = true;
    end else begin
        if _NowMins >= _BlockStartMins and _NowMins < _BlockEndMins then _InForbidSession = true;
    end;
end;
if _InForbidSession then _NoOpenWindow = true;

// 4.4 開盤第一根與日夜盤尾盤不開新倉
_Is0845 = (_NowMins = 525);
_IsSessionTail = (_NowMins >= 270 and _NowMins <= 300) or (_NowMins >= 795 and _NowMins <= 825);

// 4.5 04:30~09:00 禁開（訊號改為暫存，延到 09:00 後執行）
_In0430Window = (_Restrict0430 = 1) and _NowMins >= 270 and _NowMins < 540;

// 4.6 夜盤定時強制平倉時段
_IsNightCloseTime = (_NightClose = 1) and _NowMins >= _NightCloseHour * 60 + _NightCloseMin and _NowMins <= 300;

// ==============================================================
// 5. 均線與訊號取價
// ==============================================================
_Src = Close;   // 均線取價來源；XS 無「價格來源」型參數，要換取價直接改這一行

// 均線型態由參數決定，全程走同一分支，遞迴型均線不會因跳過而斷序
if _LongMaType = 1 then begin
    _LongMa1 = Average(_Src, _LongFastLen);
    _LongMa2 = Average(_Src, _LongSlowLen);
end else if _LongMaType = 2 then begin
    _LongMa1 = XAverage(_Src, _LongFastLen);
    _LongMa2 = XAverage(_Src, _LongSlowLen);
end else if _LongMaType = 3 then begin
    _LongMa1 = WMA(_Src, _LongFastLen);
    _LongMa2 = WMA(_Src, _LongSlowLen);
end else if _LongMaType = 4 then begin
    // RMA(Wilder 平滑) 的平滑係數 1/N，等價於期數 2N-1 的指數平滑
    _LongMa1 = XAverage(_Src, 2 * _LongFastLen - 1);
    _LongMa2 = XAverage(_Src, 2 * _LongSlowLen - 1);
end else begin
    // HMA = WMA(2*WMA(n/2) - WMA(n), sqrt(n))
    _L1Hull = 2 * WMA(_Src, IntPortion(_LongFastLen / 2)) - WMA(_Src, _LongFastLen);
    _L2Hull = 2 * WMA(_Src, IntPortion(_LongSlowLen / 2)) - WMA(_Src, _LongSlowLen);
    _LongMa1 = WMA(_L1Hull, IntPortion(Round(SquareRoot(_LongFastLen), 0)));
    _LongMa2 = WMA(_L2Hull, IntPortion(Round(SquareRoot(_LongSlowLen), 0)));
end;

if _ShortMaType = 1 then begin
    _ShortMa1 = Average(_Src, _ShortFastLen);
    _ShortMa2 = Average(_Src, _ShortSlowLen);
end else if _ShortMaType = 2 then begin
    _ShortMa1 = XAverage(_Src, _ShortFastLen);
    _ShortMa2 = XAverage(_Src, _ShortSlowLen);
end else if _ShortMaType = 3 then begin
    _ShortMa1 = WMA(_Src, _ShortFastLen);
    _ShortMa2 = WMA(_Src, _ShortSlowLen);
end else if _ShortMaType = 4 then begin
    _ShortMa1 = XAverage(_Src, 2 * _ShortFastLen - 1);
    _ShortMa2 = XAverage(_Src, 2 * _ShortSlowLen - 1);
end else begin
    _S1Hull = 2 * WMA(_Src, IntPortion(_ShortFastLen / 2)) - WMA(_Src, _ShortFastLen);
    _S2Hull = 2 * WMA(_Src, IntPortion(_ShortSlowLen / 2)) - WMA(_Src, _ShortSlowLen);
    _ShortMa1 = WMA(_S1Hull, IntPortion(Round(SquareRoot(_ShortFastLen), 0)));
    _ShortMa2 = WMA(_S2Hull, IntPortion(Round(SquareRoot(_ShortSlowLen), 0)));
end;

// 均線遞迴需要每根 K 棒都運算，故資料不足的保護放在均線算完之後
if CurrentBar <= 6 then return;

// 訊號 K 棒＝已收盤的前一根；再前一根用於「連續兩根」型條件
_SigOpen = Open[1];
_SigClose = Close[1];
_PreOpen = Open[2];
_PreClose = Close[2];
_PreLow = Low[2];
_PreHigh = High[2];

_LongMa1Sig = _LongMa1[1];
_LongMa2Sig = _LongMa2[1];
_LongMa1Pre = _LongMa1[2];
_LongMa2Pre = _LongMa2[2];
_LongSlope = _LongMa2[1] - _LongMa2[2];

_ShortMa1Sig = _ShortMa1[1];
_ShortMa2Sig = _ShortMa2[1];
_ShortMa1Pre = _ShortMa1[2];
_ShortMa2Pre = _ShortMa2[2];
_ShortSlope = _ShortMa2[1] - _ShortMa2[2];

// ==============================================================
// 6. 趨勢反轉時重置阻斷狀態
// ==============================================================
if _LongMa1Sig <= _LongMa2Sig then begin
    _BlockLong = 0;
    _LongSlCount = 0;
    _LastSlEntryLong = 0;
    _FourGreenEntry = 0;
    _FourGreenSl = 0;
    _FourGreenBlocked = 0;
    _ConsecLongSl = 0;
    _NormalLongBlocked = 0;
end;

if _ShortMa1Sig >= _ShortMa2Sig then begin
    _BlockShort = 0;
    _ShortSlCount = 0;
    _LastSlEntryShort = 0;
    _ConsecShortSl = 0;
    _NormalShortBlocked = 0;
end;

// ==============================================================
// 7. 跳空與止損冷卻
// ==============================================================
if (_EnableGapProtect = 1) and (AbsValue(_SigOpen - _PreClose) >= _GapPoints) then _LastGapBar = CurrentBar;

_InGapCooldown = (_EnableGapProtect = 1) and _LastGapBar > 0 and (CurrentBar - _LastGapBar <= _GapCooldown);
_InSlCooldown = (_EnableSlCooldown = 1) and _LastSlBar > 0 and (CurrentBar - _LastSlBar <= _SlCooldownBars);

// ==============================================================
// 8. 初始止損與最小止損距離檢查
// ==============================================================
_InitSlLong = _PreLow;      // 訊號 K 棒的前一根低點
_InitSlShort = _PreHigh;    // 訊號 K 棒的前一根高點

if _EnableMaxSl = 1 then begin
    _InitSlLongCap = MaxList(_InitSlLong, _SigClose - _MaxSlPoints);
    _InitSlShortCap = MinList(_InitSlShort, _SigClose + _MaxSlPoints);
end else begin
    _InitSlLongCap = _InitSlLong;
    _InitSlShortCap = _InitSlShort;
end;

_PassMinSlLong = (_EnableMinSl = 0) or (_SigClose - _InitSlLong >= _MinSlPoints);
_PassMinSlShort = (_EnableMinSl = 0) or (_InitSlShort - _SigClose >= _MinSlPoints);

// ==============================================================
// 9. 進場條件計算
// ==============================================================
// 止盈後的冷靜期：嚴格模式需隔 2 根、寬鬆模式需隔 1 根
_StrictTpOk = (_LastTpBar = 0) or (CurrentBar - _LastTpBar >= 2);
_LooseTpOk = (_LastTpBar = 0) or (CurrentBar - _LastTpBar >= 1);

// 9.1 嚴格模式：多頭排列 + 連續兩根陽 K 站上短均線
_StrictLong = (_LongMa1Sig > _LongMa2Sig) and (_SigClose > _LongMa1Sig) and (_PreClose > _LongMa1Pre)
              and (_SigClose > _SigOpen) and (_PreClose > _PreOpen) and _StrictTpOk;
_StrictShort = (_ShortMa1Sig < _ShortMa2Sig) and (_SigClose < _ShortMa1Sig) and (_PreClose < _ShortMa1Pre)
               and (_SigClose < _SigOpen) and (_PreClose < _PreOpen) and _StrictTpOk;

// 9.2 寬鬆模式：單根貫穿雙均線；開啟跨根後允許前一根先破一條
if _StepCrossLong = 1 then begin
    _LooseLongCross = (_SigOpen <= _LongMa1Sig or _SigOpen <= _LongMa2Sig)
                      or (_PreClose <= _LongMa1Pre or _PreClose <= _LongMa2Pre);
end else begin
    _LooseLongCross = (_SigOpen <= _LongMa1Sig or _SigOpen <= _LongMa2Sig);
end;

if _StepCrossShort = 1 then begin
    _LooseShortCross = (_SigOpen >= _ShortMa1Sig or _SigOpen >= _ShortMa2Sig)
                       or (_PreClose >= _ShortMa1Pre or _PreClose >= _ShortMa2Pre);
end else begin
    _LooseShortCross = (_SigOpen >= _ShortMa1Sig or _SigOpen >= _ShortMa2Sig);
end;

_LooseLongOk = _LooseLongCross and (_SigClose > _LongMa1Sig) and (_SigClose > _LongMa2Sig) and _LooseTpOk;
_LooseShortOk = _LooseShortCross and (_SigClose < _ShortMa1Sig) and (_SigClose < _ShortMa2Sig) and _LooseTpOk;

if _LooseLong = 1 then begin
    _BaseLong = _StrictLong or _LooseLongOk;
end else begin
    _BaseLong = _StrictLong;
end;

if _LooseShort = 1 then begin
    _BaseShort = _StrictShort or _LooseShortOk;
end else begin
    _BaseShort = _StrictShort;
end;

// 9.3 防接刀：止損後再進場的價格必須優於前次止損單的進場價
_PassKnifeLong = (_AntiKnifeLong = 0) or (_LastSlEntryLong = 0) or (_SigClose > _LastSlEntryLong);
_PassKnifeShort = (_AntiKnifeShort = 0) or (_LastSlEntryShort = 0) or (_SigClose < _LastSlEntryShort);

// 9.4 四陽獨立開多：連四根陽 K，不看均線與斜率
_FourGreen = (_SigClose > _SigOpen) and (_PreClose > _PreOpen)
             and (Close[3] > Open[3]) and (Close[4] > Open[4]);
_FourGreenCond = (_FourGreenLong = 1) and _FourGreen and _PassMinSlLong and (_BlockLong = 0)
                 and _PassKnifeLong and (_FourGreenEntry < _FourGreenMaxEntry) and (_FourGreenBlocked = 0);

// 9.5 一般進場條件
_LongCond = _BaseLong and (_LongSlope > _LongSlopeTh) and _PassMinSlLong and (_BlockLong = 0)
            and _PassKnifeLong and (_NormalLongBlocked = 0);
_ShortCond = _BaseShort and (_ShortSlope < _ShortSlopeTh) and _PassMinSlShort and (_BlockShort = 0)
             and _PassKnifeShort and (_NormalShortBlocked = 0);

// ==============================================================
// 10. 出場判斷與執行（每次洗價；一次洗價只會送出一個交易指令）
// ==============================================================
_ExitReason = 0;
_ExitRefPrice = 0;
_ExitDir = 0;
_TrailArmed = false;
_TrailTpPrice = 0;

if Position <> 0 and (Filled = Position) and Filled <> 0 then _EntryPrice = FilledAvgPrice;

if Position > 0 then begin
    _ExitDir = 1;

    // 10.1 補齊追蹤基準（策略帶入既有庫存部位時，極值與止損價會是初始 0）
    if _EntryPrice > 0 and _PeakPrice <= 0 then _PeakPrice = High;
    if _EntryPrice > 0 and _StopPrice <= 0 then _StopPrice = _EntryPrice - _MaxSlPoints;

    // 10.2 更新持倉最高價與止損價
    _PeakPrice = MaxList(_PeakPrice, High);
    if _IsNewBar and Close[1] >= Open[1] then _StopPrice = MaxList(_StopPrice, Low[1]);
    if _EnableMaxSl = 1 then begin
        _MaxSlPrice = _EntryPrice - _MaxSlPoints;
        _StopPrice = MaxList(_StopPrice, _MaxSlPrice);
    end;
    // 動態最小止損距離：讓止損價與現價保持距離，避免被貼著掃出場
    if _EnableDynMinSl = 1 then begin
        _DynSlPrice = Close - _DynMinSlPoints;
        _StopPrice = MinList(_StopPrice, _DynSlPrice);
    end;

    // 10.3 移動止盈：浮盈達觸發點數後，自最高價回吐設定比例即出場
    if (_EnableTrailTp = 1) and (_PeakPrice - _EntryPrice >= _TrailTpTrigger) then begin
        _TrailArmed = true;
        _TrailTpPrice = _PeakPrice - MaxList((_PeakPrice - _EntryPrice) * _TrailTpRetrace / 100, 1);
    end;

    // 10.4 出場優先序：觸價出場 > 移動止盈 > 不跨週強平 > 夜盤強平
    if Low <= _StopPrice then begin
        _ExitReason = 1;
        _ExitRefPrice = _StopPrice;
    end else if _TrailArmed and (Low <= _TrailTpPrice) then begin
        _ExitReason = 2;
        _ExitRefPrice = _TrailTpPrice;
    end else if _WeekendClose then begin
        _ExitReason = 3;
        _ExitRefPrice = Close;
    end else if _IsNightCloseTime then begin
        _ExitReason = 4;
        _ExitRefPrice = Close;
    end;

end else if Position < 0 then begin
    _ExitDir = -1;

    if _EntryPrice > 0 and _PeakPrice <= 0 then _PeakPrice = Low;
    if _EntryPrice > 0 and _StopPrice <= 0 then _StopPrice = _EntryPrice + _MaxSlPoints;

    _PeakPrice = MinList(_PeakPrice, Low);
    if _IsNewBar and Close[1] <= Open[1] then _StopPrice = MinList(_StopPrice, High[1]);
    if _EnableMaxSl = 1 then begin
        _MaxSlPrice = _EntryPrice + _MaxSlPoints;
        _StopPrice = MinList(_StopPrice, _MaxSlPrice);
    end;
    if _EnableDynMinSl = 1 then begin
        _DynSlPrice = Close + _DynMinSlPoints;
        _StopPrice = MaxList(_StopPrice, _DynSlPrice);
    end;

    if (_EnableTrailTp = 1) and (_EntryPrice - _PeakPrice >= _TrailTpTrigger) then begin
        _TrailArmed = true;
        _TrailTpPrice = _PeakPrice + MaxList((_EntryPrice - _PeakPrice) * _TrailTpRetrace / 100, 1);
    end;

    if High >= _StopPrice then begin
        _ExitReason = 1;
        _ExitRefPrice = _StopPrice;
    end else if _TrailArmed and (High >= _TrailTpPrice) then begin
        _ExitReason = 2;
        _ExitRefPrice = _TrailTpPrice;
    end else if _WeekendClose then begin
        _ExitReason = 3;
        _ExitRefPrice = Close;
    end else if _IsNightCloseTime then begin
        _ExitReason = 4;
        _ExitRefPrice = Close;
    end;
end;

if _ExitReason > 0 then begin
    if _ExitReason = 1 then begin
        SetPosition(0, Market, label:="觸價出場");
    end else if _ExitReason = 2 then begin
        SetPosition(0, Market, label:="移動止盈出場");
    end else if _ExitReason = 3 then begin
        SetPosition(0, Market, label:="不跨週強制平倉");
    end else begin
        SetPosition(0, Market, label:="夜盤定時強制平倉");
    end;

    // 10.5 判定本筆為止盈或止損（止損價已推過成本時，觸價出場也算止盈）
    _ExitIsWin = 0;
    if (_ExitDir = 1) and _ExitRefPrice > _EntryPrice then _ExitIsWin = 1;
    if (_ExitDir = -1) and _ExitRefPrice < _EntryPrice then _ExitIsWin = 1;

    if _ExitDir = 1 then begin
        if _ExitIsWin = 1 then begin
            _LastTpBar = CurrentBar;
            if (_AggressiveLong = 1) then _AggLongBar = CurrentBar;
            _LastSlEntryLong = 0;
            _ConsecLongSl = 0;
        end else begin
            _LongSlCount = _LongSlCount + 1;
            if _AllowLongSl > 0 and _LongSlCount >= _AllowLongSl then _BlockLong = 1;
            _LastSlEntryLong = _EntryPrice;
            if _LastLongIsFourGreen = 1 then begin
                _FourGreenSl = _FourGreenSl + 1;
                if _FourGreenSl >= _FourGreenMaxSl then _FourGreenBlocked = 1;
            end else begin
                _ConsecLongSl = _ConsecLongSl + 1;
                if (_AntiConsecSlLong = 1) and (_ConsecLongSl >= 2) then _NormalLongBlocked = 1;
            end;
            _LastSlBar = CurrentBar;
        end;
    end else begin
        if _ExitIsWin = 1 then begin
            _LastTpBar = CurrentBar;
            if (_AggressiveShort = 1) then _AggShortBar = CurrentBar;
            _LastSlEntryShort = 0;
            _ConsecShortSl = 0;
        end else begin
            _ShortSlCount = _ShortSlCount + 1;
            if _AllowShortSl > 0 and _ShortSlCount >= _AllowShortSl then _BlockShort = 1;
            _LastSlEntryShort = _EntryPrice;
            _ConsecShortSl = _ConsecShortSl + 1;
            if (_AntiConsecSlShort = 1) and (_ConsecShortSl >= 2) then _NormalShortBlocked = 1;
            _LastSlBar = CurrentBar;
        end;
    end;

    _EntryPrice = 0;
    _StopPrice = 0;
    _PeakPrice = 0;
    _LastLongIsFourGreen = 0;
end;

// ==============================================================
// 11. 進場訊號彙整與下單（每根 K 棒只評估一次，且不與出場指令同一次洗價）
// ==============================================================
if _IsNewBar and (_ExitReason = 0) then begin

    // 11.1 止盈後激進進場：止盈當根收陽(陰)則下一根直接進場
    _AggLongTrig = false;
    if _AggLongBar > 0 and (CurrentBar = _AggLongBar + 1) then begin
        if _SigClose > _SigOpen then _AggLongTrig = true;
        _AggLongBar = 0;
    end;

    _AggShortTrig = false;
    if _AggShortBar > 0 and (CurrentBar = _AggShortBar + 1) then begin
        if _SigClose < _SigOpen then _AggShortTrig = true;
        _AggShortBar = 0;
    end;

    // 11.2 彙整觸發條件
    _TrigNormalLong = (_LongCond and (_EnableLong = 1))
                      or ((_AggressiveLong = 1) and _AggLongTrig and (_EnableLong = 1) and (_BlockLong = 0)
                          and _PassMinSlLong and _PassKnifeLong and (_NormalLongBlocked = 0));
    _TrigLong = _TrigNormalLong or _FourGreenCond;
    _PureFourGreen = _FourGreenCond and (not _TrigNormalLong);

    _TrigShort = (_ShortCond and (_EnableShort = 1))
                 or ((_AggressiveShort = 1) and _AggShortTrig and (_EnableShort = 1) and (_BlockShort = 0)
                     and _PassMinSlShort and _PassKnifeShort and (_NormalShortBlocked = 0));

    // 11.3 04:30~09:00 禁開時段：訊號先暫存，延到 09:00 後補進場
    if _In0430Window and (not _NoOpenWindow) then begin
        if _TrigLong then begin
            _PendingLong = 1;
            _PendingShort = 0;
            if _PureFourGreen then begin
                _PendingFourGreen = 1;
            end else begin
                _PendingFourGreen = 0;
            end;
        end;
        if _TrigShort then begin
            _PendingShort = 1;
            _PendingLong = 0;
        end;
    end;

    // 反向訊號出現時清掉暫存，避免延後執行到過期方向
    if _ShortCond then _PendingLong = 0;
    if _LongCond then _PendingShort = 0;

    // 11.4 通過所有時段與冷卻濾網後才真正進場
    _FinalLong = false;
    _FinalShort = false;
    _FinalPureFourGreen = _PureFourGreen;

    if (not _InGapCooldown) and (not _InSlCooldown) and (not _NoOpenWindow)
       and (not _Is0845) and (not _IsSessionTail) and (not _In0430Window) then begin

        if _TrigLong then begin
            _FinalLong = true;
        end else if (_PendingLong = 1) then begin
            _FinalLong = true;
            _FinalPureFourGreen = (_PendingFourGreen = 1);
            _PendingLong = 0;
        end;

        if _TrigShort then begin
            _FinalShort = true;
        end else if (_PendingShort = 1) then begin
            _FinalShort = true;
            _PendingShort = 0;
        end;
    end;

    // 11.5 下單（多單優先，與原策略的 if / else if 順序一致）
    if _FinalLong and (Position = 0) and (Filled = 0) then begin
        SetPosition(_Lots, Market, label:="雙陽開多");
        _EntryPrice = _SigClose;
        _StopPrice = _InitSlLongCap;
        _PeakPrice = High;
        if _FinalPureFourGreen then begin
            _LastLongIsFourGreen = 1;
            _FourGreenEntry = _FourGreenEntry + 1;
        end else begin
            _LastLongIsFourGreen = 0;
        end;
    end else if _FinalShort and (Position = 0) and (Filled = 0) then begin
        SetPosition(-_Lots, Market, label:="雙陽開空");
        _EntryPrice = _SigClose;
        _StopPrice = _InitSlShortCap;
        _PeakPrice = Low;
    end;
end;
