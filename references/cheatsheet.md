# XS 查表速查表（XS-LOOKUP）

> **這份檔案是「查表用」**：函數分類、欄位命名、頻率商品相容、實戰片段都在這裡。
> **「規則與流程」** 在 `master-guide.md`，**「錯誤對照」** 在 `anti-patterns.md`，**「腳本類別專屬規範」** 在 `script-types/*.md`。

## 也可參考

- 線上：[XS 官方語法手冊](https://xshelp.xq.com.tw/XSHelp/) — 最新函數說明與版本更新
- `references/source/XScript_官方語法與核心說明文件.md` — 1538 行完整語法 + 報價 132 / 資料 500+ / 選股 400+ 三大欄位字典
- `references/examples-index.md` — 622 個 xstrader 實戰場景索引

---

## 1. 資料存取函數對照表

XS 有四種主要的資料存取函數，適用場景不同：

| 函數 | 用途 | 適用腳本 | 歷史資料 | 頻率參數 |
|---|---|---|---|---|
| `GetField()` | 取得資料欄位（價格、量能、籌碼等） | 指標、警示、交易、選股、函數 | 可回溯 `[N]` | 支援（"D", "W", "M", "Q" 等） |
| `GetQuote()` | 取得即時報價欄位 | **僅** 警示、交易（官方 FIELDFUNC 明定；函數腳本未列入支援） | **不可回溯** | 無（僅即時值） |
| `GetSymbolField()` | 取得**其他商品**的資料欄位 | 指標、警示、交易、選股、函數 | 可回溯 `[N]` | 支援 |
| `GetSymbolInfo()` | 取得**商品靜態屬性**（到期日、合約乘數、資格等） | 指標、警示、交易、選股、函數 | 不適用（屬性非時序） | 無 |

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

### GetSymbolInfo 語法與商品資訊欄位

```xs
Value1 = GetSymbolInfo("到期日");                   // 本商品屬性
Value1 = GetSymbolInfo("exchange");                 // 中英文欄位名皆可
Value1 = GetSymbolInfo(_OptGroup[_i], "履約價");     // 指定商品（Group 遍歷）
```

回傳型別依欄位而異（String / Boolean / Numeric / Date）。**不支援的商品×欄位組合回傳安全預設值（`0` / 空字串）而不報錯** —— 與 `GetSymbolField` 相反，故遍歷群組時應「先 Info 過濾、再 Field 取值」（見 anti-patterns 聚合代碼過濾）。

| 欄位 | 說明 | 型別 | 支援商品 |
|---|---|---|---|
| `到期日` | 到期日 YYYYMMDD（如 20221101） | Date | **期貨**、選擇權、台權證、可轉債、美(特別股) |
| `合約乘數` | 契約值乘數（大台 200 / 小台 50） | Numeric | 台期貨、台選擇權 — ⚠️ **交易腳本不可用**（見下方） |
| `標的物` | 衍生性商品的標的代碼 | String | 期貨、選擇權、台權證、可轉債、特別股 |
| `履約價` | 選擇權／權證履約價 | Numeric | 選擇權、台權證 |
| `買賣權` | CALL / PUT | String | 選擇權、台權證 |
| `期貨近月` | 相關期貨近月代碼（如 FITXN01.TF） | String | 台股、期貨 |
| `期貨遠月` / `期貨次遠月` | 遠月／次遠月代碼（FITXN02/03.TF） | String | 台股、期貨 |
| `交易所` | 商品掛牌的交易所 | String | 台股、權證、可轉債、特別股、美股 |
| `買賣現沖` / `先買現沖` | 當日現沖資格 | Boolean | 台股 |
| `可放空` / `平可空` | 融券／平盤下放空資格 | Boolean | 台股 |
| `處置股` / `注意股` / `累計異常注意股` | 處置與注意狀態 | Boolean | 台股、權證、可轉債、特別股 |
| `即將處置結束股` / `近期處置結束股` | 處置最後一日／近 7 日剛結束 | Boolean | 台股、權證、可轉債 |
| `有期貨` / `有選擇權` / `有認購權證` / `有認售權證` / `有牛證` / `有熊證` / `有可轉債` | 是否有對應衍生商品 | Boolean | 台股、指數 |
| `交易單位` / `交易幣別` / `面額` / `面額幣別` | 交易單位與幣別 | Numeric/String | 台股 |
| `轉換價格` / `可轉換日` / `票面利率` / `擔保品` / `發行張數` | 可轉債專屬 | 依欄位 | 台可轉債 |
| `執行比例` | 權證執行比例 | Numeric | 台權證 |
| `ETD` / `第一個回購日` | 美股特別股專屬 | Boolean/Date | 美(特別股) |

**期貨常用寫法：**

```xs
// 轉倉：直接取次月合約代碼，不必自行組裝年月字串
_NextMonth = GetSymbolInfo("期貨遠月");     // 例：FITXN02.TF
```

🚨 **欄位還有「腳本類型」限制，官方 GetSymbolInfo 說明頁只列支援商品、沒列這一層**（平台實測）：

| 欄位 | 實測結果 |
|---|---|
| `合約乘數` | **交易腳本會編譯錯誤**「在『交易』腳本中無法使用『合約乘數』」。交易腳本請改用 `input` 自行指定（大台 200／小台 50），切換商品時連同保證金一起改 |
| `到期日` | 交易腳本可用（已實測） |
| `期貨遠月` | 交易腳本可用（已實測） |

因此**支援商品 ≠ 支援腳本類型**；寫交易腳本用到冷門商品屬性時，務必先在平台編譯一次確認。

⚠️ **`到期日` 支援期貨**：官方欄位總表把它與選擇權欄位並列，容易誤判成「僅限選擇權」而改寫成其他函數。（官方鏡像兩處敘述不一致：xshelp/QOPTION 對 `GetSymbolInfo("到期日")` 只列「台權證/期貨/選擇權」；可轉債、美特別股僅見於 FIELDFUNC 的資料欄位條目，未明確綁定 GetSymbolInfo — 用到後兩者時先實測。）

**台指期（TX）結算規格與腳本陷阱**（依 TAIFEX 契約規格）：

| 項目 | 規格 |
|---|---|
| 最後交易日 | 交割月份**第三個星期三** |
| 最後結算日 | **同最後交易日**（非次一營業日） |
| 最後結算價 | 最後結算日收盤前 30 分鐘標的指數簡單算術平均價 |
| 一般交易時段 | 08:45–13:45；**最後交易日縮短為 08:45–13:30** |
| 盤後交易時段 | 15:00–次日 05:00；**最後交易日無盤後交易時段** |
| 契約乘數 | 指數 × NT$200（小台 ×50） |
| 每日漲跌幅 | 前一般交易時段結算價 ±10% |

🚨 寫結算／轉倉邏輯時最常踩的雷：**最後交易日既沒有夜盤、日盤也提早到 13:30 收**。任何排在 13:30 之後或夜盤時段的動作（例如「15:03 轉倉買回」）在到期合約上**永遠不會觸發**，若狀態旗標的還原依賴那段程式碼，策略會就此卡死且不報錯。狀態旗標務必改由換日歸零區無條件重置。

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
// 正確（欄位名皆經官方鏡像 references/xshelp/ 核實）
Value1 = GetField("每股稅後淨利(元)");
Value1 = GetField("成交金額(元)", "D");

// 錯誤 — 會靜默回 0
Value1 = GetField("每股稅後淨利");     // 缺少 (元)
Value1 = GetField("成交金額", "1");    // 分鐘頻缺 (元)；官方僅在 "D" 頻率允許無單位別名
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
| 營收成長率 | `月營收年增率`（FBASIC，選股欄位） | `營收成長率`（FFINANCE，選股欄位） |
| 累計營收成長率 | `累計營收年增率`（FBASIC，選股欄位） | （季年頻一般直接用報表欄位） |

```xs
// ❌ 錯誤：月頻用「營收成長率」會回 0
value1 = GetField("營收成長率", "M");

// ✅ 正確：月頻一律用 YoY 描述（官方範例 GENERALFUNC 同此寫法）
value1 = GetField("月營收年增率", "M");
value2 = GetField("累計營收年增率", "M");

// ✅ 正確：季年頻用「成長率」
value3 = GetField("營收成長率", "Q");
```

注意：「營收年增率」（無「月」字）是**報價欄位**（QFINANCE，僅最新一期、走 `GetQuote`），與月頻 GetField 的「月營收年增率」不同；上表皆為**選股欄位**（F 類），在指標/警示/交易腳本用之前先以 `CheckField` 驗證可用性。

### 正名差異對照（常見直覺寫法 vs 官方欄位名）

| 直覺 ❌ | 官方正名 ✅ |
|---|---|
| 總負債 | **負債總額** |
| 總資產 | **資產總額** |
| 股價現金流比 | **股價自由現金流量比** |
| 企業價值倍數 | **企業價值** |
| 每股淨利 | **每股稅後淨利(元)** |

注意：「內部人持股比例」與「董監持股佔股本比例」是**兩個都存在、範圍不同**的官方欄位（內部人 ⊇ 董監，見 xshelp/FCHIP.md、TCHIP.md），依需求選用，不要互相「訂正」。

撰寫前若不確定欄位名，先 `grep -rn "^## 欄位名" references/xshelp/`（官方鏡像），輔以 `references/source/XScript_官方語法與核心說明文件.md` §7–9。

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
| 籌碼（三大法人/主力） | ✓ | ✗ | ✗ | ✗ | 部分 | 部分（如「外資買賣超」官方明列支援大盤/類股指數） |
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

> 數量以官方鏡像 `references/xshelp/INDEX.md` 為準（2026-07 爬取）；查單一函數：`grep -rn "^## 函數名" references/xshelp/`

### 內建函數（182 個，8 分類）

| 分類 | 數量 | 主要函數 |
|---|---|---|
| 一般函數 | 47 | `BarAdjusted`, `BarFreq`, `BarInterval`, `CurrentBar`, `OutputField`, `Plot`, `PlotK`, `RaiseRunTimeError`, `SetBarFreq`(僅選股), `IsFirstCall`, `SetRemoveOutlier`, `SetAlign` |
| 數學函數 | 37 | `AbsValue`, `Ceiling`, `Floor`, `IntPortion`, `FracPortion`, `Mod`, `Power`, `Round`, `SquareRoot`, `MaxList`, `MinList` |
| 交易函數 | 28 | `SetPosition`, `Position`, `Filled`, `FilledAvgPrice`, `FilledAtBroker`, `DefaultBuyPrice`, `Buy`, `Sell`, `Short`, `Cover`, `IsMarketPrice` |
| 日期函數 | 16 | `CurrentDate`, `DateAdd`, `DateDiff`, `Year`, `Month`, `DayOfMonth`, `DayOfWeek` |
| 字串函數 | 15 | `InStr`, `LeftStr`, `MidStr`, `NumToStr`, `StrToNum`, `StrLen`, `Text`, `UpperStr` |
| 欄位函數 | 17 | `GetField`, `GetQuote`, `GetSymbolField`, `CheckField`, `CheckSymbolField`, `Symbol`, `SymbolName` |
| 時間函數 | 13 | `CurrentTime`, `Hour`, `Minute`, `Second`, `TimeValue`, `TimeDiff`, `TimeAdd` |
| 陣列函數 | 9 | `Array_Sort`, `Array_Sum`, `Array_Copy`, `Array_GetMaxIndex` |

### 系統函數（267 個，14 分類）

| 分類 | 數量 | 主要函數 |
|---|---|---|
| 技術指標 | 53 | `MACD`, `RSI`, `KD(Stochastic)`, `CCI`, `ATR`, `BollingerBand`, `SAR`, `ADI`, `ACC`, `VR` |
| 量化因子 | 51 | 見 `references/xshelp/QUANTFACTOR.md` |
| 價格取得 | 33 | `Highest`, `Lowest`, `AvgPrice`, `TypicalPrice`, `CloseD`, `HighD`, `LowD`, `OpenD` |
| 跨頻率 | 29 | `xf_GetValue`, `xf_EMA`, `xf_MACD`, `xf_RSI`, `xfMin_GetValue`, `xfMin_EMA`, `BollingerBandWidth` |
| 價格關係 | 25 | `HighestBar`, `LowestBar`, `HighDays`, `LowDays`, `NthHighest`, `NthLowest`, `MoM`, `QoQ`, `YoY` |
| 價格計算 | 13 | `Average`, `EMA`, `XAverage`, `WMA`, `RateOfChange`, `Range`, `TrueRange`, `Summation` |
| 邏輯判斷 | 13 | `CrossOver`, `CrossUnder`, `AverageIF`, `CountIf`, `SummationIf`, `IFF`, `Filter` |
| 期權相關 | 12 | `BSDelta`, `BSGamma`, `BSTheta`, `BSVega`, `IVolatility`, `HVolatility` |
| 趨勢分析 | 12 | `SwingHigh`, `SwingLow`, `LinearReg`, `Angle`, `UpTrend`, `DownTrend` |
| 日期相關 | 10 | `BarsLast`, `DaysToExpiration`, `GetLastTradeDate`, `LastDayOfMonth` |
| 統計分析 | 6 | `StandardDev`, `Correlation`, `Covariance`, `RSquare` |
| 量能相關 | 4 | `DiffBidAskVolumeLxL`, `DiffUpDownVolume` |
| Array 函數 | 4 | `ArraySeries`, `ArrayMASeries`, `ArrayLinearRegSlope` |
| 交易相關 | 2 | `calcvwapdistribution`(VWAP 分佈), `EnterMarketCloseTime` |

完整函數簽名與用法：優先查 `references/xshelp/`（官方鏡像），輔以 `references/source/XScript_官方語法與核心說明文件.md` §5。

### 官方防呆與進階函數（skill 過去未收錄，實戰高價值）

| 函數 | 用途 | 出處 |
|---|---|---|
| `CheckField` / `CheckSymbolField` | 呼叫 GetField 前先確認欄位資料存在（回傳 True/False），**官方版「靜默回 0」解藥** | xshelp/FIELDFUNC.md |
| `IsSupportField` / `IsSupportSymbolField` | 判斷欄位是否被目前商品支援 | xshelp/GENERALFUNC.md |
| `IsFirstCall("Bar"/"Date"/"Realtime"...)` | 精準判斷各種「第一次洗價」時機，比 `Date <> Date[1]` 更細 | xshelp/GENERALFUNC.md |
| `SetAlign` / `DataAlign` | 跨頻率取值的資料對位模式（絕對 vs 遞補），anti-pattern #22 的機制根源 | xshelp/GENERALFUNC.md、FIELDFUNC.md |
| `SetRemoveOutlier` | Rank 排行時排除離群值（zscore/IQR） | xshelp/GENERALFUNC.md |
| `FilledAtBroker` | 券商實際庫存（官方明言可能 ≠ `Filled`） | xshelp/TRANSACTIONFUNC.md |
| `FilledRecordCount/Price/Qty/Date/BS` | 逐筆歷史成交紀錄，自算已實現損益 | xshelp/TRANSACTIONFUNC.md |
| `DefaultBuyPrice` / `DefaultSellPrice` | 官方標準的委託價換算（優於手刻漲停價算張數） | xshelp/TRANSACTIONFUNC.md |
| `IsListedSymbol` | 判斷商品是策略原設定或後補庫存商品 | xshelp/TRANSACTIONFUNC.md |
| `GetBarBack` / `GetTotalBar` | 讀出目前資料範圍設定值（與 Set 系列成對，可防呆） | xshelp/GENERALFUNC.md |

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
| 期權 | 59 | **僅期貨/選擇權** | Delta, Gamma, 未平倉（注意：不是「未平倉量」）。⚠️ `結算價` 經平台實測 **GetField 系列不支援**，需要漲跌停基準時請改用 `收盤價` 近似 |

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

### 即時排行（指標/警示用 Array_Sort2D 模擬 rank）

`rank` 只能用在選股腳本。指標／警示要「即時排名」（例如找當下最強類股），改用 **`Group` input + 二維陣列 + `Array_Sort2D`**：

```xs
input: _sectorGroup(Group, "類股");      // Group 型別，元素從 [1] 起算，不是 [0]
Array: _sortSector[19, 2](-9999);        // 宣告二維陣列：[類股索引, 漲跌幅]
var: _i(0), _cnt(0), _chg(0);

_cnt = GroupSize(_sectorGroup);
for _i = 1 to _cnt begin
    // Group 陣列元素可直接傳給 GetSymbolField（見下方說明）
    // 用「參考價」當昨收，避免 收盤價[1] 在 settotalBar 太小時取不到（見下方陷阱）
    value1 = GetSymbolField(_sectorGroup[_i], "收盤價", "D");
    value2 = GetSymbolField(_sectorGroup[_i], "參考價", "D");
    _chg = (value1 - value2) / value2 * 100;
    _sortSector[_i, 1] = _i;      // 第幾類股
    _sortSector[_i, 2] = _chg;    // 漲跌幅
end;

// Array_Sort2D(陣列, 起始位置, 結束位置, 比較欄位, 順序)；False=大到小, True=小到大
Array_Sort2D(_sortSector, 1, _cnt, 2, False);
// 排序後 _sortSector[1,1] 就是最強類股的索引
```

| 函數 | 用途 |
|---|---|
| `Array: name[列, 欄](初值);` | 宣告二維陣列 |
| `Array_Sort(陣列, 起, 迄, 順序)` | 一維陣列排序 |
| `Array_Sort2D(陣列, 起, 迄, 比較欄, 順序)` | 二維陣列依指定欄排序（`False`=大到小） |
| `GroupSize(group)` | Group 元素個數 |
| `GetSymbolGroup("TSE11.TW", "成分股")` | 取類股成分股（第 1 參數也只吃字面值，不可用變數，需逐一比對） |

**關鍵限制**：`GetSymbolField` / `GetSymbolGroup` 第 1 參數不可用「一般變數」，但 **`Group` 陣列元素 `_sectorGroup[_i]` 可以**——因為 Group 是「不可變動的清單」，編譯器視為合法來源。設定上：執行商品掛單一商品（如加權指數）、頻率設 60 分之類、**逐筆洗價不要勾**（每 tick 重排沒意義且嚴重拖慢），建議只做提醒不掛自動交易。

#### 兩階段排行（類股 → 成分股）實戰四大陷阱

做「先排最強類股、再進該類股排最強個股」時（XQ 官方教材主題），實測會踩到四個**靜默**錯誤（不報錯、結果卻錯）：

**① 類股漲幅算法：用 `參考價` 不要用 `收盤價[1]`。**
`settotalBar(1)` 等小值下，跨頻率 `GetSymbolField("收盤價","D")[1]` 取不到昨日 → 回 0 → 漲幅變 `(今/0)` 怪值，類股排序整個錯。改用 `參考價`（當日參考價＝昨收基準）就免 `[1]`，`settotalBar(1)` 也夠。若一定要用 `[1]`，`settotalBar` 至少設 5。

**② Array_Sort2D 只排「被指定的數值陣列」，平行的字串陣列不會跟著動。**
二維陣列不能混型別，所以股號（字串）要存在另一個字串陣列。排序數值陣列後，**字串陣列仍是原始順序**，不能用排序後名次直接索引，否則「漲幅對、股號錯」。正解：數值陣列存一欄「原始列索引」，排序後靠它回查字串陣列：

```xs
Array: _sortStock[2000, 2](-9999);   // [原始列索引, 漲跌幅]（數值）
Array: _regSymbol[2000, 2]("");      // [股號, 類股代號]（字串，平行存放）

// 建表：第 1 欄存「這一列的流水號」，不要存類股索引！
_sortStock[_row, 1] = _row;          // ← 關鍵：存自己的列號
_sortStock[_row, 2] = _chg;
_regSymbol[_row, 1] = _stockGroup[_j];
_regSymbol[_row, 2] = _sectorGroup[_idx];

Array_Sort2D(_sortStock, 1, _totCount, 2, False);

for _i = 1 to MinList(_topStock, _totCount) begin   // 加 MinList 防越界
    _k = _sortStock[_i, 1];           // ← 取原始列索引
    Alert("股號:", _regSymbol[_k, 1], " 漲幅:", NumToStr(_sortStock[_i, 2], 2));
end;
```

**③ 混合多類股成分股時，跨類股的列偏移累加用 `k = k + j - 1`。**
把 TopN 類股的成分股全倒進同一個大陣列再整體排序時，每跑完一個類股要把偏移 `k` 往後推。XS 的 `for j = 1 to n` 結束後 `j = n+1`，所以 `k = k + j - 1` 剛好累加 `n`：

```xs
_k = 0; _totCount = 0;
for _i = 1 to _topGroup begin
    ... // 內層 for _j = 1 to _stockCount，寫入 _sortStock[_j + _k, ...]
    _k = _k + _j - 1;          // j 結束時 = stockCount+1，故 +j-1 = +stockCount
    _totCount += _stockCount;
end;
```

**④ idx → 代碼對照表是「順序強耦合」。**
`if idx = N then stockGroup = GetSymbolGroup("TSExx.TW", ...)` 這串硬對照，要求掛指標時 Group「類股」的成員與順序跟對照表 1:1（idx 1→TSE11、2→TSE12…，上市 19 類股：TSE11–TSE29 + TSE99，注意跳過 TSE24 用 TSE25）。Group 一改順序就靜默選錯類股。對照表旁務必註明對應的 Group 版本。

### 群組聚合值（如股池平均漲跌幅）：每根 K 第一個 tick 重算一次

要在警示/交易腳本盤中追蹤「一籃子商品的聚合值」（平均漲跌幅、上漲家數…），**不要**用 tick 序號做增量更新（要處理漏 tick、補償邏輯複雜且易錯）；直接在「每根 K 的第一個 tick」歸零全重算（官方論壇 虎科大許教授 解法）：

```xs
input: _myGroup(Group, "股池");
var: intrabarpersist _groupRatio(0);
var: intrabarpersist _lastTime(0);
var: _i(0), _cnt(0);

if GetInfo("IsRealTime") = 0 then return;    // 只在實盤即時執行（注意：回測恆為 0，見 anti-patterns #29）

if _lastTime <> Time then begin              // Time = 當根 K 時間戳 → 每根 K 只進來一次
    _groupRatio = 0;
    _lastTime = Time;
    for _i = 1 to GroupSize(_myGroup) begin
        _groupRatio += (GetSymbolField(_myGroup[_i], "收盤價", "tick")
                      - GetSymbolField(_myGroup[_i], "參考價", "D"))
                      / GetSymbolField(_myGroup[_i], "參考價", "D") * 100 / GroupSize(_myGroup);
    end;
end;
```

- `if _lastTime <> Time` 是「每根 K 第一個 tick 執行一次」的標準 idiom（`Date <> Date[1]` 的 K 棒版；同族技巧見 anti-patterns #27 的 intrabarpersist 追蹤變數）
- ⚠️ **跨商品 tick 不對齊**：迴圈裡 `GetSymbolField(_myGroup[_i], "...", "tick")` 抓到的是該商品「當下最新一筆 tick」，時間點不與洗價商品的 K 棒邊界對齊（教授原文警告）。要求嚴格對齊時這個方法不適用
- 偵測漏 tick 可用欄位「當日序號」（Tick 頻率，當日第幾筆成交、從 1 起算，xshelp/TVOLUME）——但通常「全重算」就不需要它

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
- `anti-patterns.md` — 31 條 wrong → right 對照與重構案例
- `examples-index.md` — 622 個實戰場景索引
- `script-types/{indicator, trading, alert, stock-picker, function}.md` — 各類腳本專屬規範
