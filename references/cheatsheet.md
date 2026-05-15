# XS 查表速查表（XS-LOOKUP）

> **這份檔案是「查表用」**：函數分類、欄位命名、頻率商品相容、實戰片段都在這裡。
> **「規則與流程」** 在 `master-guide.md`，**「錯誤對照」** 在 `anti-patterns.md`，**「腳本類別專屬規範」** 在 `script-types/*.md`。

## 也可參考

- 線上：[XS 官方語法手冊](https://xshelp.xq.com.tw/XSHelp/) — 最新函數說明與版本更新
- `references/source/XScript_官方語法與核心說明文件.md` — 1538 行完整語法 + 報價 132 / 資料 500+ / 選股 400+ 三大欄位字典
- `references/examples-index.md` — 622 個 xstrader 實戰場景索引

---

## 1. 資料存取函數對照表

XS 有三種主要的資料存取函數，適用場景不同：

| 函數 | 用途 | 適用腳本 | 歷史資料 | 頻率參數 |
|---|---|---|---|---|
| `GetField()` | 取得資料欄位（價格、量能、籌碼等） | 指標、警示、交易、選股、函數 | 可回溯 `[N]` | 支援（"D", "W", "M", "Q" 等） |
| `GetQuote()` | 取得即時報價欄位 | **僅** 警示、交易、函數 | **不可回溯** | 無（僅即時值） |
| `GetSymbolField()` | 取得**其他商品**的資料欄位 | 指標、警示、交易、選股、函數 | 可回溯 `[N]` | 支援 |

### GetField 語法與頻率參數

```xs
Value1 = GetField("收盤價");                              // 使用腳本主頻
Value1 = GetField("收盤價", "D");                          // 指定日頻
Value1 = GetField("收盤價", "1", Adjusted:=true);          // 1分鐘還原頻率
Value1 = GetField("本益比", "D", Default:=0);              // 無資料時回傳 0
Value1 = GetField("外資買賣超")[1];                         // 取前一根 K 棒的值
```

**可用頻率代碼：**
- Tick: `"1 Tick"`
- 分鐘: `"1"`, `"5"`, `"10"`, `"15"`, `"30"`, `"60"`, `"120"`, `"240"`
- 日/週/月: `"D"`, `"W"`, `"M"`
- 季/半年/年: `"Q"`, `"H"`, `"Y"`
- 還原: `"AD"`, `"AW"`, `"AM"`

### GetQuote 語法

```xs
Value1 = GetQuote("成交");          // 中文名稱
Value1 = GetQuote("Last");          // 英文代碼
Value1 = q_Last;                    // q_ 前綴快捷語法
```

**注意：** GetQuote 只能在**警示**和**交易**腳本中使用，不能用於回測（無歷史資料）。

### GetSymbolField 語法

```xs
Value1 = GetSymbolField("2330", "收盤價");                     // 取其他商品
Value1 = GetSymbolField("2330", "收盤價", "D");                 // 指定頻率
Value1 = GetSymbolField("Underlying", "收盤價");                // 取標的股
Value1 = GetSymbolField("Future*1", "收盤價");                  // 取近月期貨
```

---

## 2. 欄位命名精確規則

### 中英文欄位代碼對照

許多欄位同時有中文和英文代碼，兩者等效：

| 中文名稱 | 英文代碼 | 存取方式 |
|---|---|---|
| 成交 | Last | `GetQuote("成交")` 或 `GetQuote("Last")` 或 `q_Last` |
| 買進 | Bid | `GetQuote("買進")` 或 `GetQuote("Bid")` 或 `q_Bid` |
| 收盤價 | Close | `GetField("收盤價")` 或 `GetField("Close")` |
| 成交量 | Volume | `GetField("成交量")` 或 `GetField("Volume")` |
| 漲停家數 | UpLimitSecs | `GetQuote("漲停家數")` 或 `q_UpLimitSecs` |
| 估計量 | EstimatedTotalVolume | `GetQuote("估計量")` 或 `q_EstimatedTotalVolume` |

### 單位後綴必須完整保留

部分欄位名稱包含單位後綴（括號+單位），撰寫時**必須完整保留**，否則 GetField 會失效：

```xs
// 正確
Value1 = GetField("每股稅後淨利(元)");
Value1 = GetField("營利率(%)");
Value1 = GetField("流通在外股數(張)");

// 錯誤 — 會導致執行失敗
Value1 = GetField("每股稅後淨利");     // 缺少 (元)
Value1 = GetField("營利率");           // 缺少 (%)
```

### q_ 前綴快捷語法（僅報價欄位）

報價欄位可用 `q_` 前綴直接存取，無需呼叫 GetQuote：

```xs
Value1 = q_Last;                    // 等同 GetQuote("成交")
Value1 = q_Bid;                     // 等同 GetQuote("買進")
Value1 = q_DailyHigh;               // 等同 GetQuote("最高(日)")
Value1 = q_RefPrice;                // 等同 GetQuote("參考價")
Value1 = q_UpLimitSecs;             // 等同 GetQuote("漲停家數")
```

### 頻率切換時欄位名「變身」（極易踩雷）

部分財務成長率欄位的字串會依 `GetField` 第二個參數的頻率而切換，**寫錯靜默回 0**：

| 概念 | 月頻 (`"M"`) | 季頻 (`"Q"`) / 年頻 (`"Y"`) |
|---|---|---|
| 營收成長率 | `營收年增率` | `營收成長率` |
| 累計營收成長率 | `累計營收年增率` | （季年頻一般直接用報表欄位） |

```xs
// ❌ 錯誤：月頻用「營收成長率」會回 0
value1 = GetField("營收成長率", "M");

// ✅ 正確：月頻一律用 YoY 描述
value1 = GetField("營收年增率", "M");
value2 = GetField("累計營收年增率", "M");

// ✅ 正確：季年頻用「成長率」
value3 = GetField("營收成長率", "Q");
```

### 正名差異對照（常見直覺寫法 vs 官方欄位名）

| 直覺 ❌ | 官方正名 ✅ |
|---|---|
| 總負債 | **負債總額** |
| 總資產 | **資產總額** |
| 內部人持股比例 | **董監持股佔股本比例** |
| 股價現金流比 | **股價自由現金流比** |
| 企業價值倍數 | **企業價值** |
| 每股淨利 | **每股稅後淨利(元)** |

撰寫前若不確定欄位名，到 `references/source/XScript_官方語法與核心說明文件.md` §7–9 或 [XSHelp](https://xshelp.xq.com.tw/XSHelp/) 比對。

---

## 3. 頻率與商品相容性

### 頻率相容性

| 欄位類別 | 支援 Tick | 支援分鐘 | 支援日 | 支援週+ | 適用腳本 |
|---|---|---|---|---|---|
| 報價欄位 | - | - | - | - | 警示、交易（僅即時值） |
| 資料欄位 - 價格/量能 | 部分 | 部分 | 全部 | 全部 | 指標、警示、交易 |
| 資料欄位 - 籌碼 | - | - | 全部 | 全部 | 指標、警示、交易 |
| 資料欄位 - 事件 | - | - | 全部 | - | 指標、警示、交易 |
| 選股欄位 - 全部 | - | **不可** | 全部 | 全部 | **僅**選股、函數 |

### 商品支援範圍（按欄位子分類）

| 欄位子分類 | 台股 | 美股 | 港股 | 陸股 | 期貨/選擇權 | 大盤/類股 |
|---|---|---|---|---|---|---|
| 價格（開高低收） | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| 成交量/成交金額 | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| 籌碼（三大法人/主力） | ✓ | ✗ | ✗ | ✗ | 部分 | ✗ |
| 融資融券 | ✓ | ✗ | ✗ | ✗ | ✗ | ✗ |
| 財務報表（營收/EPS） | ✓ | 部分 | 部分 | 部分 | ✗ | ✗ |
| 事件（除權息/法說會） | ✓ | ✗ | ✗ | ✗ | ✗ | ✗ |
| 期權 Greeks | ✗ | ✗ | ✗ | ✗ | ✓ | ✗ |
| 市場統計（漲停家數等） | ✗ | ✗ | ✗ | ✗ | ✗ | ✓ |
| 可轉債相關 | 台(可轉債) | ✗ | ✗ | ✗ | ✗ | ✗ |

**關鍵限制：**
- **選股腳本**不可使用分鐘頻率的 GetField（選股引擎不支援分鐘回溯）
- **報價欄位**僅提供即時值，不可回溯歷史（`GetQuote("成交")[1]` 無效）
- 成交量單位因商品而異：台股=張、指數=元、期貨=口、海外=股
- **籌碼欄位幾乎全為台股專屬**，撰寫美股/港股策略時不可使用融資融券、主力買賣超等欄位
- 使用不支援的商品+欄位組合**不會報錯**，但回傳值為 0 或空值，容易造成隱蔽的邏輯錯誤

---

## 4. 函數分類速查

### 內建函數（179 個）

| 分類 | 數量 | 主要函數 |
|---|---|---|
| 一般函數 | 48 | `BarAdjusted`, `BarFreq`, `BarInterval`, `CurrentBar`, `OutputField`, `Plot`, `PlotK`, `RaiseRunTimeError`, `SetBarFreq` |
| 數學函數 | 35 | `AbsValue`, `Ceiling`, `Floor`, `IntPortion`, `FracPortion`, `Mod`, `Power`, `Round`, `SquareRoot`, `MaxList`, `MinList` |
| 交易函數 | 27 | `SetPosition`, `Position`, `Filled`, `FilledAvgPrice`, `Buy`, `Sell`, `Short`, `Cover`, `Alert`, `IsMarketPrice` |
| 日期函數 | 16 | `CurrentDate`, `DateAdd`, `DateDiff`, `Year`, `Month`, `DayOfMonth`, `DayOfWeek` |
| 字串函數 | 15 | `InStr`, `LeftStr`, `MidStr`, `NumToStr`, `StrToNum`, `StrLen`, `Text`, `UpperStr` |
| 欄位函數 | 14 | `GetField`, `GetQuote`, `GetSymbolField`, `CheckField`, `Symbol`, `SymbolName` |
| 時間函數 | 13 | `CurrentTime`, `Hour`, `Minute`, `Second`, `TimeValue`, `TimeDiff`, `TimeAdd` |
| 陣列函數 | 9 | `Array_Sort`, `Array_Sum`, `Array_Copy`, `Array_GetMaxIndex` |

### 系統函數（216 個）

| 分類 | 數量 | 主要函數 |
|---|---|---|
| 技術指標 | 49 | `MACD`, `RSI`, `KD(Stochastic)`, `CCI`, `ATR`, `BollingerBand`, `SAR`, `ADI`, `ACC`, `VR` |
| 價格取得 | 33 | `Highest`, `Lowest`, `AvgPrice`, `TypicalPrice`, `CloseD`, `HighD`, `LowD`, `OpenD` |
| 跨頻率 | 31 | `xf_GetValue`, `xf_EMA`, `xf_MACD`, `xf_RSI`, `xfMin_GetValue`, `xfMin_EMA`, `BollingerBandWidth` |
| 價格關係 | 26 | `HighestBar`, `LowestBar`, `HighDays`, `LowDays`, `NthHighest`, `NthLowest`, `MoM`, `QoQ`, `YoY` |
| 價格計算 | 13 | `Average`, `EMA`, `XAverage`, `WMA`, `RateOfChange`, `Range`, `TrueRange`, `Summation` |
| 邏輯判斷 | 13 | `CrossOver`, `CrossUnder`, `AverageIF`, `CountIf`, `SummationIf`, `IFF`, `Filter` |
| 期權相關 | 12 | `BSDelta`, `BSGamma`, `BSTheta`, `BSVega`, `IVolatility`, `HVolatility` |
| 趨勢分析 | 12 | `SwingHigh`, `SwingLow`, `LinearReg`, `Angle`, `UpTrend`, `DownTrend` |
| 日期相關 | 10 | `BarsLast`, `DaysToExpiration`, `GetLastTradeDate`, `LastDayOfMonth` |
| 統計分析 | 6 | `StandardDev`, `Correlation`, `Covariance`, `RSquare` |
| 量能相關 | 4 | `DiffBidAskVolumeLxL`, `DiffUpDownVolume` |
| Array 函數 | 4 | `ArraySeries`, `ArrayMASeries`, `ArrayLinearRegSlope` |

完整函數簽名與用法在 `references/source/XScript_官方語法與核心說明文件.md` §5。

---

## 5. 領域專用欄位速查

### 報價欄位分類（132 欄位）

| 子分類 | 數量 | 主要支援商品 | 代表欄位 |
|---|---|---|---|
| 常用 | 12 | 多數全商品；估計量僅台股/大盤 | 成交, 成交時間, 估計量, 昨量, 參考價, 總量(日) |
| 價格 | 23 | 台股/期貨/選擇權/港股/陸股/美股 | 開盤(日), 最高(日), 最低(日), 漲停價, 跌停價 |
| 量能 | 27 | 多數台股/期貨/選擇權/港股/陸股/美股 | 單量, 內盤量, 外盤量, 買賣力道 |
| 五檔統計 | 28 | 台股/期貨/選擇權/港股/陸股/美股 | 委買1~5, 委賣1~5, 總委買, 總委賣 |
| 財務 | 10 | **僅台股** | 每股盈餘, 每股淨值, 股東權益報酬率, 毛利率 |
| 市場統計 | 4 | **僅大盤/類股指數** | 漲停家數, 跌停家數, 上漲家數, 下跌家數 |
| 期權 | 28 | **僅台(權證)/選擇權** | Delta, Gamma, Theta, Vega, 隱含波動率 |

### 資料欄位分類（371 欄位）

| 子分類 | 數量 | 主要支援商品 | 代表欄位 |
|---|---|---|---|
| 常用 | 17 | 價格類全商品；外資買賣超僅台股 | 收盤價, 開盤價, 最高價, 最低價, 成交量 |
| 價格 | 14 | 多數全商品 | 均價, 上影線, 下影線, 漲幅, 振幅 |
| 量能 | 69 | 多數台股；部分含大盤 | 內盤量, 外盤量, 估計量, 上漲量 |
| 籌碼 | 156 | **幾乎全為台股專屬** | 主力買賣超, 融資張數, 融券張數, CB剩餘張數 |
| 基本 | 9 | 台股為主；部分含港/陸/美 | 股本, 市值, 上市日期 |
| 事件 | 29 | **僅台股** | 除權日, 除息日, 股東會日期 |
| 市場統計 | 18 | **僅大盤/類股指數** | 漲停家數, 跌停家數, 成交金額 |
| 期權 | 59 | **僅期貨/選擇權** | Delta, Gamma, 結算價, 未平倉（注意：不是「未平倉量」） |

### 選股欄位分類（508 欄位）

| 子分類 | 數量 | 主要支援商品 | 代表欄位 |
|---|---|---|---|
| 常用 | 19 | 價格類含台/港/陸/美；籌碼類僅台股 | 收盤價, 成交量, 漲幅, 外資買賣超 |
| 價格 | 27 | 多數台股；部分含港/陸/美 | 還原收盤價, 均價, 振幅 |
| 量能 | 61 | 多數台股/美股 | 成交金額, 週轉率, 內外盤比 |
| 籌碼 | 119 | **幾乎全為台股專屬** | 主力買賣超, 三大法人買賣超, 融資融券 |
| 基本 | 34 | 台股為主；部分含港/陸/美 | 股本, 市值, 本益比, 殖利率 |
| 財務 | 213 | **多數僅台股**；少數含美股 | 每股稅後淨利(元), 營收年增率(%), ROE |
| 事件 | 35 | **僅台股** | 除權息日, 法說會日期, 營收公布日 |

完整欄位清單（每個欄位名稱、單位、支援商品）在 `references/source/XScript_官方語法與核心說明文件.md` §7–9。

---

## 6. 常用語法片段

### GROUP 群組遍歷（指數成分股的營收加總）

```xs
group: _symbolGroup();
var: _sum(0), _num(0);

_symbolGroup = GetSymbolGroup("成分股");
value1 = GroupSize(_symbolGroup);

_sum = 0; _num = 0;
for value2 = 1 to value1 begin
    if CheckSymbolField(_symbolGroup[value2], "月營收", "M") then begin
        _sum += GetSymbolField(_symbolGroup[value2], "月營收", "M");
        _num += 1;
    end;
end;

plot1(_sum, "成分股月營收");
plot2(_num, "有月營收家數");
plot3(value1, "成分股家數");
```

選擇權群組遍歷時需先過濾聚合代碼（如 `TXO00.TF`），見 `anti-patterns.md` #21。

### InputKind 下拉選單

```xs
input:
_TargetMult(0.5, "滿足點倍數", InputKind:=Dict(
    ["0.5倍", 0.5],
    ["1.0倍", 1],
    ["1.5倍", 1.5],
    ["2.0倍", 2]
), Quickedit:=True);
```

預設值必須是 Dict 第一項；整數不要寫 `1.0`。

### 雙重部位同步檢查（股票交易必備）

```xs
// 進場
if Filled = 0 and Position = 0 and (進場條件) then SetPosition(_Lots);

// 出場（多單）
if Filled > 0 and Position > 0 and Filled = Position and (出場條件) then SetPosition(0);

// 出場（空單）
if Filled < 0 and Position < 0 and Filled = Position and (出場條件) then SetPosition(0);
```

期貨不需要雙重檢查，只看 `Position`。詳見 `script-types/trading.md`。

---

## 也可參考

- `master-guide.md` — 程序性規則：撰寫流程、可行性預審、look-ahead bias、註解風格、資源宣告
- `anti-patterns.md` — 28 條 wrong → right 對照與重構案例
- `examples-index.md` — 622 個實戰場景索引
- `script-types/{indicator, trading, alert, stock-picker, function}.md` — 各類腳本專屬規範
