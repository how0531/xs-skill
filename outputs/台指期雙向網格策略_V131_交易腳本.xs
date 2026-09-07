// ==============================================================
// 台指期 雙向 DCA 網格策略 V1.31（微台版）— XS 自動交易腳本
// 適用商品：台指期／微型台指 全日盤連續月
// 適用頻率：分鐘線。加倉與停利停損為觸價判斷，請以逐筆洗價執行
// 策略骨架：MACD 交叉配長均線方向濾網進首倉，逆勢等比網格加倉，
//           整體停利停損，止損後可反手開反向首倉
// ==============================================================
// 【已知偏移】原策略的均線來源頻率為 360 分鐘，XS 的分鐘頻率代碼
// 僅支援 1/2/3/5/10/15/20/30/45/60/90/120/135/180/240，無 360，
// 故改用 240 分鐘。要換頻率請一併修改下方三行 GetField 的頻率字串。
// ==============================================================

SetBarBack(300);                                                                     // 主頻：EMA 200 期暖機
SetBarBack(5, "240");                                                                // 均線來源頻率的引用筆數

// ==============================================================
// 1. 參數宣告區
// ==============================================================
// 1.1 均線方向濾網
input: _MaLen(200, "均線長度");                                                      // 期
input: _MaUpSrc(2, "上均線來源", InputKind:=Dict(["最高價", 2], ["最低價", 3], ["收盤價", 4]), Quickedit:=True);
input: _MaDnSrc(3, "下均線來源", InputKind:=Dict(["最低價", 3], ["最高價", 2], ["收盤價", 4]), Quickedit:=True);

// 1.2 MACD（原策略以簡單移動平均計算，非一般的指數平滑版本）
input: _MacdF(12, "快線長度");                                                       // 期
input: _MacdS(26, "慢線長度");                                                       // 期
input: _SignalLen(9, "信號平滑");                                                    // 期
input: _MacdSrc(4, "MACD 來源", InputKind:=Dict(["收盤價", 4], ["開盤價", 1], ["最高價", 2], ["最低價", 3]), Quickedit:=True);

// 1.3 DCA 網格
input: _Qty(1, "每次開倉／加倉口數");                                                // 口
input: _MaxPosQty(10, "最大總開倉口數上限");                                         // 口
input: _GridPts(88, "首倉加倉網格間距");                                             // 點
input: _GridMult(1.2, "加倉網格間距乘數");                                           // 設 1.0 即固定間距
input: _MaxDca(8, "最大加倉次數");                                                   // 次
input: _BaseTP(102, "首倉止盈");                                                     // 點
input: _TpMult(1.3, "加倉後止盈乘數");

// 1.4 全局止損
input: _UseSL(1, "開啟全局止損", InputKind:=Dict(["是", 1], ["否", 0]), Quickedit:=True);
input: _SLPoints(2500, "全局止損點數");                                              // 點，依平均成本計算，0 等同無止損

// 1.5 止損反手
input: _UseReverse(1, "止損後反向開倉", InputKind:=Dict(["是", 1], ["否", 0]), Quickedit:=True);

// ==============================================================
// 2. 變數宣告區
// ==============================================================
// 2.1 指標：每次洗價重算，用 [N] 可取得已收 K 棒的定版值
var: _Src(0), _Macd(0), _Signal(0);
var: _Hi240(0), _Lo240(0), _Cl240(0);
var: _MaUpVal(0), _MaDnVal(0);
var: _MaHi(0), _MaLo(0), _KMa(0);

// 2.2 訊號快照與本次洗價的暫時旗標
var: _SigC(0), _SigMacd(0), _SigMacdP(0), _SigSig(0), _SigSigP(0);
var: _SigMaHi(0), _SigMaLo(0), _SigBar(0);
var: _IsNewBar(0), _Acted(0);
var: _Dir(0), _Fills(0), _AvgPx(0), _TpPts(0), _TpPx(0), _SlPx(0);
var: _HitTP(0), _HitSL(0), _IsWin(0);
var: _MaxDcaEff(0), _TargetFills(0), _Cum(0), _Step(0), _i(0);
var: _LongCond(0), _ShortCond(0), _RevLong(0), _RevShort(0), _DoLong(0), _DoShort(0);
var: _EntryDir(0), _WasRev(0);

// 2.3 跨洗價必須保值的狀態變數
var: intrabarpersist _CalcBar(0);                                                    // 上次跑過訊號判定的 K 棒編號
var: intrabarpersist _FirstPx(0);                                                    // 首倉成交價，網格層級的基準
var: intrabarpersist _EntryBar(0);
var: intrabarpersist _PendRevBar(0), intrabarpersist _PendRevDir(0);                 // 排定中的反手：K 棒編號與方向

// ==============================================================
// 3. 環境預檢區
// ==============================================================
if BarFreq <> "Min" then RaiseRunTimeError("本策略僅支援分鐘線頻率");
if _Qty <= 0 then RaiseRunTimeError("每次開倉口數必須大於 0");
if _MaxPosQty < _Qty then RaiseRunTimeError("總口數上限不可小於每次開倉口數");
if _GridPts <= 0 or _BaseTP <= 0 then RaiseRunTimeError("網格間距與止盈點數必須大於 0");
if _GridMult < 1.0 then RaiseRunTimeError("網格間距乘數不可小於 1.0");

_Acted = 0;

// 同趨勢內最多能加幾次，同時受加倉次數與總口數上限拘束
_MaxDcaEff = MinList(_MaxDca, IntPortion((_MaxPosQty - _Qty) / _Qty));

// ==============================================================
// 4. 指標計算
// ==============================================================
// 4.1 MACD 來源
if _MacdSrc = 1 then begin
    _Src = Open;
end else if _MacdSrc = 2 then begin
    _Src = High;
end else if _MacdSrc = 3 then begin
    _Src = Low;
end else begin
    _Src = Close;
end;

_Macd = Average(_Src, _MacdF) - Average(_Src, _MacdS);
_Signal = Average(_Macd, _SignalLen);

// 4.2 長均線來源：取已收完的高頻 K 棒，避免引用未完成的區間資料
_Hi240 = GetField("最高價", "240")[1];
_Lo240 = GetField("最低價", "240")[1];
_Cl240 = GetField("收盤價", "240")[1];

if _MaUpSrc = 2 then begin
    _MaUpVal = _Hi240;
end else if _MaUpSrc = 3 then begin
    _MaUpVal = _Lo240;
end else begin
    _MaUpVal = _Cl240;
end;

if _MaDnSrc = 2 then begin
    _MaDnVal = _Hi240;
end else if _MaDnSrc = 3 then begin
    _MaDnVal = _Lo240;
end else begin
    _MaDnVal = _Cl240;
end;

// 4.3 均線在「主頻」上做指數平滑，與原策略的計算位置一致
_KMa = 2 / (_MaLen + 1);

if _MaUpVal > 0 then begin
    if _MaHi[1] <= 0 then begin
        _MaHi = _MaUpVal;
    end else begin
        _MaHi = _MaHi[1] + _KMa * (_MaUpVal - _MaHi[1]);
    end;
end else begin
    _MaHi = _MaHi[1];
end;

if _MaDnVal > 0 then begin
    if _MaLo[1] <= 0 then begin
        _MaLo = _MaDnVal;
    end else begin
        _MaLo = _MaLo[1] + _KMa * (_MaDnVal - _MaLo[1]);
    end;
end else begin
    _MaLo = _MaLo[1];
end;

// ==============================================================
// 5. 部位快照與停利停損價
// ==============================================================
// 停利停損一律以「實際成交部位」為基準，加倉委託還在路上時也不會漏掉出場
if Filled > 0 then begin
    _Dir = 1;
end else if Filled < 0 then begin
    _Dir = -1;
end else begin
    _Dir = 0;
end;

_Fills = 0;
if _Dir <> 0 then begin
    _Fills = IntPortion(AbsValue(Filled) / _Qty + 0.0001);
end;

// 首倉成交後鎖定基準價，網格層級全部由它推算
if _Dir <> 0 and _FirstPx = 0 then begin
    _FirstPx = FilledAvgPrice;
end;

// 平倉後清掉殘留狀態，等同原策略的撤銷所有掛單
if Position = 0 and Filled = 0 then begin
    _FirstPx = 0;
end;

_AvgPx = 0;
_TpPts = 0;
_TpPx = 0;
_SlPx = 0;

if _Dir <> 0 then begin
    _AvgPx = FilledAvgPrice;
    // 每加一層，止盈點數等比放大
    _TpPts = _BaseTP * Power(_TpMult, MaxList(0, _Fills - 1));

    if _Dir = 1 then begin
        _TpPx = _AvgPx + _TpPts;
        if _UseSL = 1 and _SLPoints > 0 then _SlPx = _AvgPx - _SLPoints;
    end else begin
        _TpPx = _AvgPx - _TpPts;
        if _UseSL = 1 and _SLPoints > 0 then _SlPx = _AvgPx + _SLPoints;
    end;
end;

// ==============================================================
// 6. 出場判定（觸價，逐筆洗價）
// ==============================================================
_HitTP = 0;
_HitSL = 0;

if _Dir <> 0 and _TpPx <> 0 then begin

    // 進場當根只認最新成交價，避免拿進場之前的高低點誤判
    if CurrentBar = _EntryBar then begin
        if _Dir = 1 then begin
            if Close >= _TpPx then _HitTP = 1;
            if _SlPx <> 0 and Close <= _SlPx then _HitSL = 1;
        end else begin
            if Close <= _TpPx then _HitTP = 1;
            if _SlPx <> 0 and Close >= _SlPx then _HitSL = 1;
        end;
    end else begin
        if _Dir = 1 then begin
            if High >= _TpPx then _HitTP = 1;
            if _SlPx <> 0 and Low <= _SlPx then _HitSL = 1;
        end else begin
            if Low <= _TpPx then _HitTP = 1;
            if _SlPx <> 0 and High >= _SlPx then _HitSL = 1;
        end;
    end;

    // 同一次洗價兩邊都觸及時無從分辨先後，一律以停損認列
    if _HitSL = 1 then begin
        _HitTP = 0;
    end;

    if _HitTP = 1 then begin
        SetPosition(0, MARKET, label:="停利平倉");
        Alert("止盈平倉", _Fills * _Qty, _TpPx);
        _IsWin = 1;
        _Acted = 1;
    end else if _HitSL = 1 then begin
        SetPosition(0, MARKET, label:="停損平倉");
        Alert("止損平倉", _Fills * _Qty, _SlPx);
        _IsWin = 0;
        _Acted = 1;

        // 止損才排反手，止盈不排
        if _UseReverse = 1 then begin
            _PendRevBar = CurrentBar;
            _PendRevDir = -1 * _Dir;
        end;
    end;

    if _Acted = 1 then begin
        _FirstPx = 0;
    end;
end;

// ==============================================================
// 7. 網格加倉（觸價，逐筆洗價）
// ==============================================================
if _Acted = 0 and _Dir <> 0 and Filled = Position and _FirstPx <> 0 and _MaxDcaEff >= 1 then begin

    _TargetFills = _Fills;
    _Cum = 0;
    _Step = _GridPts;

    // 逐層累加等比間距，取價格已經穿到的最深一層
    for _i = 1 to _MaxDcaEff begin
        _Cum = _Cum + _Step;
        _Step = _Step * _GridMult;

        if _Dir = 1 then begin
            if CurrentBar = _EntryBar then begin
                if Close <= _FirstPx - _Cum then _TargetFills = _i + 1;
            end else begin
                if Low <= _FirstPx - _Cum then _TargetFills = _i + 1;
            end;
        end else begin
            if CurrentBar = _EntryBar then begin
                if Close >= _FirstPx + _Cum then _TargetFills = _i + 1;
            end else begin
                if High >= _FirstPx + _Cum then _TargetFills = _i + 1;
            end;
        end;
    end;

    if _TargetFills > _Fills then begin
        SetPosition(_Dir * _Qty * _TargetFills, MARKET, label:="網格加倉");
        if _Dir = 1 then begin
            Alert("加多", _TargetFills - 1, Close);
        end else begin
            Alert("加空", _TargetFills - 1, Close);
        end;
        _Acted = 1;
    end;
end;

// ==============================================================
// 8. 訊號引擎（每根 K 棒只跑一次，資料一律取剛收完的那根）
// ==============================================================
_IsNewBar = 0;
if CurrentBar <> _CalcBar then begin
    _IsNewBar = 1;
end;

if _IsNewBar = 1 then begin

    _CalcBar = CurrentBar;
    _SigBar = CurrentBar - 1;

    // 8.1 訊號快照
    _SigC = Close[1];
    _SigMacd = _Macd[1];
    _SigMacdP = _Macd[2];
    _SigSig = _Signal[1];
    _SigSigP = _Signal[2];
    _SigMaHi = _MaHi[1];
    _SigMaLo = _MaLo[1];

    // 8.2 反手觸發：止損 K 棒的下一根為訊號根，與原策略同步
    _RevLong = 0;
    _RevShort = 0;
    if _UseReverse = 1 and _PendRevBar > 0 and _SigBar = _PendRevBar + 1 then begin
        if _PendRevDir = 1 then begin
            _RevLong = 1;
        end else if _PendRevDir = -1 then begin
            _RevShort = 1;
        end;
    end;

    // 不論有沒有真的進場，過了這根就作廢
    if _PendRevBar > 0 and _SigBar >= _PendRevBar + 1 then begin
        _PendRevBar = 0;
        _PendRevDir = 0;
    end;

    // 8.3 常規進場條件：MACD 交叉配長均線方向
    _LongCond = 0;
    if _SigMaHi > 0 and _SigMacd > _SigSig and _SigMacdP <= _SigSigP and _SigC >= _SigMaHi then begin
        _LongCond = 1;
    end;

    _ShortCond = 0;
    if _SigMaLo > 0 and _SigMacd < _SigSig and _SigMacdP >= _SigSigP and _SigC <= _SigMaLo then begin
        _ShortCond = 1;
    end;

    _DoLong = 0;
    _DoShort = 0;
    if _LongCond = 1 or _RevLong = 1 then begin
        _DoLong = 1;
    end;
    if _ShortCond = 1 or _RevShort = 1 then begin
        _DoShort = 1;
    end;

    // 多空同根成立時以多方優先，與原策略的 if/else 順序一致
    if _DoLong = 1 and _DoShort = 1 then begin
        _DoShort = 0;
    end;

    // ==============================================================
    // 9. 首倉進場
    // ==============================================================
    _EntryDir = 0;
    if Position = 0 and Filled = 0 and _Acted = 0 then begin
        if _DoLong = 1 then begin
            _EntryDir = 1;
        end else if _DoShort = 1 then begin
            _EntryDir = -1;
        end;
    end;

    if _EntryDir <> 0 then begin
        SetPosition(_EntryDir * _Qty, MARKET, label:="首倉進場");

        _WasRev = 0;
        if (_EntryDir = 1 and _RevLong = 1) or (_EntryDir = -1 and _RevShort = 1) then begin
            _WasRev = 1;
        end;

        if _EntryDir = 1 then begin
            if _WasRev = 1 then begin
                Alert("反手首多", Close);
            end else begin
                Alert("首多", Close);
            end;
        end else begin
            if _WasRev = 1 then begin
                Alert("反手首空", Close);
            end else begin
                Alert("首空", Close);
            end;
        end;

        _EntryBar = CurrentBar;
        _FirstPx = 0;                                                                // 等成交回報再以成交均價鎖定基準
        _Acted = 1;
    end;

end;
