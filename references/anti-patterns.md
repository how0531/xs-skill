# XS 常見錯誤與重構對照表

> 整理自三個來源（xs-helper、xq-copilot、XScript_Preset）中反覆強調的踩雷點。
> 每條錯誤都附上 ❌ 錯誤寫法 → ✅ 正確寫法，以及為什麼會錯的「Why」。

## 1. 跨平台語法混用（最常見）

來自 PineScript / MultiCharts(PowerLanguage) / EasyLanguage 的使用者最容易踩這些雷。

| ❌ 錯誤（其他平台語法） | ✅ XS 正確寫法 | Why |
|---|---|---|
| `MarketPosition` | `Position` | XS 沒有 `MarketPosition` 函數 |
| `Buy / Sell / Short / Cover` | `SetPosition(口數)` | XS 統一用 `SetPosition` 管理部位，正數做多、負數做空、0 平倉 |
| `BarsSinceEntry` | `GetBarOffset(FilledEntryDate)` | XS 無此內建變數，需透過進場日期計算 |
| `EntryPrice()` | `FilledAvgPrice` | XS 用 `FilledAvgPrice` 表示成交均價 |
| `ExitPrice()` | `Close` 或自行紀錄 | XS 沒有出場價函數 |
| `==`（相等比較） | `=` | XS 賦值與相等比較都用 `=` |
| `MINVAL` (Input 屬性) | XS 不支援 | 改用條件判斷做下限檢查 |
| `NewDay` | `Date <> Date[1]` 或 `IsFirstBar` | `NewDay` 在 XS 行為不一致 |
| `Close of "2330"` | `GetSymbolField("2330", "收盤價")` | XS 沒有 `of` 語法 |

## 2. 變數宣告陷阱

```xs
// ❌ 錯誤：var 包含描述文字
var: _Flag(0, "標記"); 

// ✅ 正確：var 只有名稱與初始值
var: _Flag(0);
```

```xs
// ❌ 錯誤：input 漏掉 _ 前綴
input: Length(20, "週期");

// ✅ 正確：input 加 _ 前綴避免與內建衝突
input: _Length(20, "週期");
```

```xs
// ⚠️ 風險：在 if 區塊內宣告變數
if condition then begin
    var: _temp(0);     // XS 變數是 Function Scope，仍視為全域
    _temp = 1;
end;

// ✅ 正確：所有變數宣告統一放在檔案最上方
var: _temp(0);
```

## 3. 跨頻率取值

```xs
// ❌ 錯誤：用變數暫存跨頻率資料（會被主頻覆蓋而對位錯誤）
var: _weeklyClose(0);
_weeklyClose = GetField("收盤價", "W");
if _weeklyClose > _weeklyClose[1] then ...

// ✅ 正確：直接在邏輯中呼叫 GetField
if GetField("收盤價", "W") > GetField("收盤價", "W")[1] then ...
```

## 4. Look-ahead Bias（盤中嚴禁取 `[0]`）

「盤後才公布」的籌碼資料，在交易/警示腳本中盤中執行時必須用 `[1]`：

```xs
// ❌ 錯誤：盤中取當日 [0]，但這資料根本還沒公布
if GetField("外資買賣超", "D") > 1000 then ret = 1;

// ✅ 正確：用昨日資料
if GetField("外資買賣超", "D")[1] > 1000 then ret = 1;
```

**黑名單（盤中禁止 `[0]`）：**
- 三大法人（外資、投信、自營商買賣超）
- 信用交易（融資/融券/借券餘額）
- 主力籌碼（主力買賣超、分公司進出）
- 集保庫存

**例外**：選股腳本（盤後執行）可用 `[0]`。

## 5. 商品支援不匹配（靜默失敗陷阱）

XS 對商品×欄位不支援組合 **不會報錯**，而是回傳 0 或空值，極易產生隱蔽錯誤：

```xs
// ❌ 在美股上執行，外資買賣超永遠是 0
value1 = GetField("外資買賣超");      // 僅支援台股
if value1 > 1000 then ret = 1;        // 條件永遠不成立

// ❌ 在個股上執行，漲停家數永遠是 0
value1 = GetField("漲停家數", "D");   // 僅支援大盤、類股指數
```

| 欄位類別 | 支援商品 |
|---|---|
| 籌碼（融資/融券/主力/法人） | 僅台股 |
| 事件（除權息/法說會/營收公布） | 僅台股 |
| 期權 Greeks（Delta/Gamma/Theta） | 僅台(權證)、選擇權 |
| 市場統計（漲停家數/上漲家數） | 僅大盤、類股指數 |
| 價格量能（收盤價/成交量/均價） | 全商品通用 |

## 6. 欄位字串不精確

`GetField` 字串必須與官方標籤 100% 匹配，**單位後綴不可省略**：

```xs
// ❌ 錯誤：缺少單位後綴，GetField 會失敗
Value1 = GetField("每股稅後淨利");
Value1 = GetField("營利率");
Value1 = GetField("流通在外股數");

// ✅ 正確：完整保留括號與單位
Value1 = GetField("每股稅後淨利(元)");
Value1 = GetField("營利率(%)");
Value1 = GetField("流通在外股數(張)");
```

## 7. 除以零

```xs
// ❌ 錯誤：分母為 0 會崩潰
value1 = (High - Low) / (High[1] - Low[1]);

// ✅ 正確：先檢查分母
if (High[1] - Low[1]) <> 0 then
    value1 = (High - Low) / (High[1] - Low[1])
else
    value1 = 0;
```

## 8. 指標腳本：plot vs PlotK 互斥

```xs
// ❌ 錯誤：同一腳本混用 plot 與 PlotK
plot1(value1, "MA");
PlotK(1, _open, _high, _low, _close, "K");  // 會衝突！

// ✅ 正確：擇一使用
// 方案 A：只用 plot 系列
plot1(value1, "MA5");
plot2(value2, "MA20");

// 方案 B：只用 PlotK
PlotK(1, _open, _high, _low, _close, "自訂K線");
```

## 9. 指標腳本：多色線疊加（圖層重複渲染）

```xs
// ❌ 錯誤：主線疊加多條色線會重複渲染
plot1(supertrend, "SuperTrend");
if trend = 1 then plot2(supertrend, "上升趨勢");
if trend = -1 then plot3(supertrend, "下降趨勢");

// ✅ 正確：條件式分線繪製
if trend = 1 then plot1(supertrend, "上升趨勢");
if trend = -1 then plot2(supertrend, "下降趨勢");
```

## 10. 交易腳本：缺少雙重部位同步檢查（股票必備）

```xs
// ❌ 錯誤：只看 position，可能在「委託送出但尚未成交」期間重複下單
if position > 0 and (出場條件) then SetPosition(0);

// ✅ 正確：filled 與 position 雙重檢查
if filled > 0 and position > 0 and filled = position and (出場條件) then SetPosition(0);
```

期貨不需要此雙重檢查（無「現股當沖未成交」狀態）。

## 11. 交易腳本：張數計算

```xs
// ❌ 錯誤：直接用股價計算，會算出股數而非張數，且 XQ 自動交易不支援零股
_Quantity = IntPortion(_Amount * 10000 / close);

// ✅ 正確：以「張」為單位（1 張 = 1000 股），使用漲停價符合券商最嚴格風控
_Lots = IntPortion(_Amount * 10000 / (GetField("漲停價", "D") * 1000));
SetPosition(_Lots);
```

## 12. 交易腳本：狀態變數未用 intrabarpersist

```xs
// ❌ 錯誤：日線回測逐筆洗價時，每個 Tick 變數會重置為開盤狀態
var: _Trend(0), _LastHigh(0), _CumulativePos(0);

// ✅ 正確：狀態紀錄/累計變數加 intrabarpersist
var:
    intrabarpersist _Trend(0),
    intrabarpersist _LastHigh(0),
    intrabarpersist _CumulativePos(0);
```

**布林變數陷阱**：`intrabarpersist` 用於布林旗標時，一旦設為 `true` 除非手動重置否則永遠 `true`。建議僅用於計數器或狀態機 ID。

## 13. 警示腳本：用 OutputField 或漏掉 retmsg

```xs
// ❌ 錯誤：警示腳本不支援 OutputField
outputField1(value1, "數值");

// ❌ 錯誤：缺少 retmsg，App 推播沒有訊息
if (條件) then ret = 1;

// ✅ 正確：用 ret + retmsg
if (條件) then begin
    ret = 1;
    retmsg = text("數值：", numtostr(value1, 2));
end;
```

## 14. 選股腳本：rank 內使用外部變數

```xs
// ❌ 錯誤：rank 是獨立空間，無法使用外部 input
input: _Length(10);
rank myRank begin
    Value1 = Average(Close, _Length);   // _Length 無法傳入
    retval = (Close - Value1);
end;

// ✅ 正確：rank 內另行宣告
rank myRank begin
    var: _len(10);                       // rank 內部宣告
    Value1 = Average(Close, _len);
    retval = (Close - Value1);
end;
```

## 15. 選股腳本：使用分鐘頻率 GetField

```xs
// ❌ 錯誤：選股引擎不支援分鐘回溯
value1 = GetField("內盤量", "1");

// ✅ 正確：用日線或更長頻率
value1 = GetField("內盤量", "D");

// 替代方案：分鐘級監控請改用「警示腳本（策略雷達）」
```

## 16. 函數腳本：忘記 NumericRef

```xs
// ❌ 錯誤：用 Numeric 無法回傳數值
input: Result(Numeric);
Result = Average(Price, Length);

// ✅ 正確：需回傳的參數使用 NumericRef
input: Result(NumericRef);
Result = Average(Price, Length);
```

## 17. 函數腳本：陣列未宣告大小

```xs
// ❌ 錯誤：不知道陣列長度
input: MyArray(NumericArray);

// ✅ 正確：用 [X] 宣告大小變數
input: MyArray[X](NumericArray);
for Value1 = 1 to X begin
    // 使用 MyArray[Value1]
end;
```

## 18. 預讀取機制陷阱

`SetTotalBar`、`SetBarFreq`、`SetBarBack`、`GetSymbolField` 在「初始化階段」就執行，**無視 if 條件**：

```xs
// ❌ 錯誤：以為條件不成立就不會執行 SetTotalBar
if condition then SetTotalBar(100);   // 系統還是會直接設定

// ❌ 錯誤：以為 condition=false 就不會載入台積電資料
if condition then value1 = GetSymbolField("2330.TW", "Close");
// 系統仍會預先載入台積電資料，可能拖慢效能

// ✅ 正確：把這些函數放在腳本最上方無條件執行
SetTotalBar(100);
```

## 19. AvgPrice 函數 vs GetField("AvgPrice")

兩者完全不同，常被混用：

```xs
// AvgPrice 函數：(Open + High + Low + Close) / 4
Value1 = AvgPrice;                          // 當根 K 棒的四價均值

// GetField("AvgPrice")：成交均價 = 當日總成交金額 / 當日總成交量
Value2 = GetField("AvgPrice", "D");         // 量加權的實際成交均價
```

需要哪個視策略而定，但**不要混用**。

## 20. 收盤價停損（盤中暴跌會錯過）

```xs
// ❌ 錯誤：收盤價判斷停損
if Close <= _StopLossPrice then SetPosition(0);
// 若盤中瞬間暴跌但收盤拉回，此邏輯不會觸發

// ✅ 正確：用 Low 觸價判斷
if Low <= _StopLossPrice then SetPosition(0);
// 進階：回測可用 SetPosition(0, _StopLossPrice) 模擬限價單
```

## 21. 選擇權群組遍歷未過濾聚合代碼

選擇權群組除了具體合約（如 `TXO202412C21000.TF`），常會包含 `TXO00.TF` 這類「聚合/總代碼」（代表全部合約合計值）。對聚合代碼呼叫 `GetSymbolField` 會編譯失敗報「不支援 TXOxx.TF」。

```xs
// ❌ 錯誤：直接掃描群組，沒過濾聚合代碼
for _i = 1 to GroupSize(_OptGroup) begin
    _myValue = GetSymbolField(_OptGroup[_i], "未平倉", "D");  // 掃到 TXO00.TF 就炸
end;

// ✅ 正確：先用 GetSymbolInfo 確認是具體合約再取資料
for _i = 1 to GroupSize(_OptGroup) begin
    _strike = GetSymbolInfo(_OptGroup[_i], "履約價");
    _cp = GetSymbolInfo(_OptGroup[_i], "買賣權");

    // 聚合代碼的履約價=0、買賣權=空字串，自然會被跳過
    if _strike > 0 and (_cp = "Call" or _cp = "Put") then begin
        _myValue = GetSymbolField(_OptGroup[_i], "未平倉", "D");
        // ... 後續處理
    end;
end;
```

`GetSymbolInfo` 對聚合代碼回傳安全的預設值（0 / 空字串）不會炸，但 `GetSymbolField` 會。所以總是「先 Info 過濾、再 Field 取值」。

## 22. 分鐘線下跨頻率引用日資料取不到 `[1]`

`SetBarBack` / `SetTotalBar` 是以**腳本主頻**計算的。在分鐘線指標下，若主頻 K 棒數不足以涵蓋目標日 KBar，`GetField("X", "D")[1]` 會超出範圍回 0，造成「OI 變化量」「昨日均價」等邏輯錯誤。

```xs
// ❌ 錯誤：分鐘線指標只設 SetBarBack(5)，無法跨日取昨日 OI
SetBarBack(5);
SetTotalBar(20);
_delta = GetSymbolField(sym, "未平倉", "D") - GetSymbolField(sym, "未平倉", "D")[1];
// [1] 落在 SetBarBack 範圍外 → 永遠回 0 → _delta 永遠等於今日 OI

// ✅ 正確：分鐘線下要把主頻 K 棒設得足以跨日
// 全日盤一天約 300 根、日盤 270 根，至少留 2 天的量
SetTotalBar(5000);
SetBarBack(500);
```

**經驗法則**：分鐘線指標若要引用日頻 `[N]`，`SetTotalBar` 設 `(目標商品一天根數 × N × 1.5)` 起跳；`SetBarBack` 至少 `(目標商品一天根數 × N)`。台股日盤 270 根、全日盤 300 根。指標腳本可粗估 `SetTotalBar(5000)`、`SetBarBack(500)` 應付 1~2 日跨頻引用。

## 23. if-else 鏈不可使用「裸 statement + else」，必須用 begin/end 包裹

XS 不支援 Pascal/Delphi 風格的單行 `if-then-statement; else if ...` 寫法。即使分支只有一條陳述句也必須用 `begin ... end` 包起來，否則編譯器報「else 可能是多餘的」「無法辨認的字」。

```xs
// ❌ 錯誤：裸 statement + else
if Low <= _StopLoss then
    SetPosition(0, label:="停損");
else if Low <= _ExitDn then
    SetPosition(0, label:="跌破出場");

// ❌ 錯誤：單行 if 也不能省略 begin/end 就接 else
if A then SetPosition(1); else SetPosition(-1);

// ✅ 正確：每個分支都包 begin/end，結尾 end 接分號
if Low <= _StopLoss then begin
    SetPosition(0, label:="停損");
end else if Low <= _ExitDn then begin
    SetPosition(0, label:="跌破出場");
end;
```

注意 `end else if` 是 XS 標準寫法（end 與 else 之間有空格，不寫 `end; else`）。trading.md 範例的出場邏輯就是用這種寫法，可參照。

## 24. 欄位名依「頻率」而變身：營收年增率 vs 營收成長率

**最容易踩**，連有經驗的使用者也常常寫錯：「成長率」這一族欄位在 XQ 系統內依照 `GetField` 的頻率參數會切換到不同的「正名」字串，**直接套同一個名字會靜默回 0**。

| 頻率 | 正確欄位名 | 錯誤示範 |
|---|---|---|
| `"M"` 月 | **`營收年增率`** | ❌ `GetField("營收成長率", "M")` 會回 0 |
| `"Q"` 季 | **`營收成長率`** | ❌ `GetField("營收年增率", "Q")` 會回 0 |
| `"Y"` 年 | **`營收成長率`** | ❌ 同上 |

```xs
// ❌ 錯誤：月頻率用「營收成長率」，回 0
value1 = GetField("營收成長率", "M");

// ✅ 正確：月頻用「營收年增率」、季年用「營收成長率」
value1 = GetField("營收年增率", "M");          // 月：YoY
value2 = GetField("營收成長率", "Q");          // 季：成長率
value3 = GetField("累計營收年增率", "M");      // 月：累計 YoY，常用於選股
```

**Why：** XQ 系統認為「月營收」這個資料項本身就是月份概念，所以月頻率下的成長率欄位用「年增率」(YoY) 描述更精確；季/年頻率下使用「成長率」是直覺命名。**這是命名邏輯不一致導致的歷史遺留**，使用前務必比對欄位字典。

## 25. 欄位字串小心「正名」陷阱：總負債 ≠ 負債總額

部分財報/資產類欄位的「直覺寫法」與「官方正名」差異很微妙，**寫錯一樣靜默回 0**：

| 直覺（❌） | 正名（✅） | 備註 |
|---|---|---|
| `總負債` | **`負債總額`** | 名詞順序顛倒，XQ 用後者 |
| `總資產` | **`資產總額`** | 同上 |
| `內部人持股比例` | **`董監持股佔股本比例`** | 「董監」是 XQ 對內部人的官方稱呼 |
| `股價現金流比` | **`股價自由現金流比`** | 是「自由現金流」不是泛指現金流 |
| `企業價值倍數` | **`企業價值`** | XQ 直接命名為「企業價值」 |
| `每股淨利` | **`每股稅後淨利(元)`** | 必須含 `(元)` 後綴，見 #6 |

**檢查清單**：寫完 `GetField` 字串後，在送回給使用者前，至少抽查 1~2 個欄位名是否真的存在於 [XSHelp 官方欄位字典](https://xshelp.xq.com.tw/XSHelp/) 或本機 `references/source/XScript_官方語法與核心說明文件.md` §7–9。

## 26. 變數命名陷阱：避開「系統字段片段」

XS **不區分大小寫**，且部分內建識別字會與使用者變數產生「片段碰撞」。即使加了 `_` 前綴避開「保留字」，仍有可能踩到「片段」雷：

```xs
// ⚠️ 風險：daily 是 q_DailyXxx 系列前綴，部分版本下會產生混淆
var: _dailyVol(0);          // 編譯可能通過，但行為詭異
var: _DailyHighPrice(0);    // 同樣可能踩到 q_DailyHigh 命名空間

// ✅ 建議：用語意更明確的名稱避開
var: _volToday(0);
var: _todayHigh(0);
```

**經驗法則**：避開以下「片段」作為自訂變數的名稱主體 — `daily`, `close`, `high`, `low`, `volume`, `bid`, `ask`, `last`。這些都是 XS 報價欄位的核心識別字。

> **取捨**：這條是經驗值不是硬性規則。多數情況下加 `_` 前綴就足夠，但若 input/var 命名後遇到「腳本回傳值不對但找不到語法錯誤」，先檢查是否有片段碰撞。
