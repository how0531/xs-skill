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

## 3. 跨頻率取值不可用 `_var[N]` 回溯

**真正的雷區**：跨頻率取值存進變數後，**對該變數用 `[N]` 索引回溯**。變數會在主頻每根 K 棒被覆寫，`_var[1]` 取到的是「前一根主頻 K 棒當下的快照」，不是「前一根目標頻率的值」。

```xs
// ❌ 錯誤：對變數用 [N] 回溯跨頻率值
var: _weeklyClose(0);
_weeklyClose = GetField("收盤價", "W");
if _weeklyClose > _weeklyClose[1] then ...   // [1] 對位錯誤

// ✅ 正確：要回溯就直接在 GetField 內用 [N]
if GetField("收盤價", "W") > GetField("收盤價", "W")[1] then ...
```

**同一根 bar 內賦值再使用是安全的** — 因為值在當下執行週期內就被用掉了，不涉及跨 bar 對位：

```xs
// ✅ 安全：同 bar 賦值並立即使用（無 [N] 回溯）
value1 = GetField("收盤價", "D");
plot1(value1, "日線收盤");                      // 同 bar 內用，沒問題

// ✅ 安全：用變數整理可讀性
var: _dChg(0);
_dChg = GetField("漲跌幅", "D");
if _dChg > 5 then ret = 1;                      // 沒對變數做 [N] 回溯
```

**判斷準則：寫 `_var[N]` 或 `_var[1]` 之前先問自己「`_var` 是不是跨頻率取值？」是的話改寫成 `GetField(..., "W")[N]` 直接從欄位回溯。**

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
value1 = GetField("外資買賣超");      // 官方支援台股/大盤/類股指數，美股不支援
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
Value1 = GetField("成交金額", "1");

// ✅ 正確：完整保留括號與單位（欄位名經 references/xshelp/ 官方鏡像核實）
Value1 = GetField("每股稅後淨利(元)");
Value1 = GetField("成交金額(元)", "1");
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

## 23. if-else 鏈建議一律用 begin/end 包裹（實測踩雷；官方文件允許裸 statement）

官方 CONTROLFLOW 文件示範單一陳述句可以不加 begin/end（例：`if value1 < 0 then value2 = 1 else if value1 < 10 then value2 = 2;`）。但**實測**在某些寫法下（特別是分支內是帶 `label:=` 具名參數的函數呼叫、且陳述句以 `;` 結尾再接 `else`）編譯器會報「else 可能是多餘的」「無法辨認的字」。保守做法：**else 鏈一律包 begin/end**，穩定不踩雷。注意 `;` 後面不能直接接 `else`（這是與官方範例一致的規則：官方裸寫法在 else 前沒有分號）。

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
| `"M"` 月 | **`月營收年增率`**（xshelp/FBASIC） | ❌ `GetField("營收成長率", "M")` 會回 0 |
| `"Q"` 季 | **`營收成長率`**（xshelp/FFINANCE） | ❌ `GetField("月營收年增率", "Q")` 會回 0 |
| `"Y"` 年 | **`營收成長率`** | ❌ 同上 |

```xs
// ❌ 錯誤：月頻率用「營收成長率」，回 0
value1 = GetField("營收成長率", "M");

// ✅ 正確：月頻用「月營收年增率」、季年用「營收成長率」（官方 GENERALFUNC 範例同此）
value1 = GetField("月營收年增率", "M");        // 月：YoY
value2 = GetField("營收成長率", "Q");          // 季：成長率
value3 = GetField("累計營收年增率", "M");      // 月：累計 YoY，常用於選股
```

**Why：** XQ 系統認為「月營收」這個資料項本身就是月份概念，所以月頻率下的成長率欄位用「月…年增率」(YoY) 描述；季/年頻率下使用「成長率」是直覺命名。**這是命名邏輯不一致導致的歷史遺留**，使用前務必比對欄位字典。另注意：無「月」字的「營收年增率」是**報價欄位**（QFINANCE，僅最新一期、走 GetQuote），不是月頻 GetField 欄位。

## 25. 欄位字串小心「正名」陷阱：總負債 ≠ 負債總額

部分財報/資產類欄位的「直覺寫法」與「官方正名」差異很微妙，**寫錯一樣靜默回 0**：

| 直覺（❌） | 正名（✅） | 備註 |
|---|---|---|
| `總負債` | **`負債總額`** | 名詞順序顛倒，XQ 用後者 |
| `總資產` | **`資產總額`** | 同上 |
| `股價現金流比` | **`股價自由現金流量比`** | 是「自由現金流量」，官方名含「量」字（xshelp/FFINANCE） |
| `企業價值倍數` | **`企業價值`** | XQ 直接命名為「企業價值」 |
| `每股淨利` | **`每股稅後淨利(元)`** | 必須含 `(元)` 後綴，見 #6 |

另注意：「內部人持股比例」與「董監持股佔股本比例」**兩個都是真實官方欄位**（xshelp/FCHIP、TCHIP），內部人範圍大於董監，依需求選用，別把其中一個當錯字改掉。

**檢查清單**：寫完 `GetField` 字串後，在送回給使用者前，逐一 `grep -rn "^## 欄位名" references/xshelp/`（官方鏡像）確認存在；查不到再回 [XSHelp 官網](https://xshelp.xq.com.tw/XSHelp/) 二次確認。

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

## 27. 逐筆洗價下 `series[1]` 不能用來偵測「剛變動」

`position`、`filled` 這類序列函數的 `[1]` 是「**上一根 K 棒結束時**」的值，**不是「上個 tick」的值**。在逐筆洗價下，這根 K 棒結束前 `[1]` 永遠維持「上一根 K 結束時」的快照不變，所以 `position <> position[1]` 一旦在這根 K 內成立，會在**整根 K 棒剩下的每個 tick 持續成立** — 想用它觸發「只執行一次」的動作會變成每 tick 都觸發。

```xs
// ❌ 錯誤：想在「部位剛變動」時 print，結果整根 K 的每個 tick 都 print
if position <> position[1] then begin
    print(file(_LogPath), "部位變動：" + numtostr(position, 0));
end;

// ✅ 正確：用 intrabarpersist 變數追蹤「上次觀察到的值」，動作完立刻更新
var: intrabarpersist _LastPos(0);
var: intrabarpersist _LoggedToday(false);

// 每日歸零區（必備）：時間/旗標類歸 0，部位對照類「同步」不歸 0
if Date <> Date[1] then begin
    _LoggedToday = false;      // 旗標類 → 歸 false
    _LastPos = position;       // 部位對照類 → 同步為當下值（硬歸 0 留倉會誤觸發假變動）
end;

if position <> _LastPos then begin
    print(file(_LogPath), "部位變動：" + numtostr(position, 0));
    _LastPos = position;     // ← 印完立刻同步，下個 tick 就不會再進
end;
```

同樣模式適用於 `filled`、`State` 狀態機、`_Trend` 趨勢方向等任何「想在剛變動時做一次事」的情境。

**判斷準則**：要偵測的是「**這次執行 vs 上次執行**」的差異，就用 `intrabarpersist _LastX` 追蹤；要偵測的是「**這根 K vs 前一根 K**」的差異（例如「今天剛開盤」），才用 `[1]`。

**配套**：所有用來追蹤狀態的 `intrabarpersist` 變數，都要在每日歸零區（`if isfirstBar then` 或 `if Date <> Date[1] then`）處理，但**「重置」的正確方式依變數性質而異**：

- **時間/旗標類**（`_last_log_time`、`_alerted`…）→ 重置為 0／false。不重置會被昨日值卡住（例：今日定時回報整天不會印）
- **部位對照類**（`_LastPos`…）→ **同步為當下值** `_LastPos = position;`，**不可硬歸 0** — 留倉時歸 0 會讓 `position <> _LastPos` 在開盤第一個 tick 誤觸發一筆假「變動」

## 28. 「判方向」用前後差、「判狀態」用當下值 — 兩者不可混用

寫部位 log 時最常見的錯誤：用同一套判斷式同時想表達「這筆是買還是賣」（方向／事件）和「現在是多單還是空單」（狀態／快照）。兩者的正確寫法完全不同：

- **判方向（事件）**：這筆動作是 Buy 還是 Sell → 比較 `position` 與「上次記錄的部位」`_LastPos`（前後差）
- **判狀態（快照）**：現在持有多單還是空單 → 直接看 `position > 0` / `position < 0`（當下值）

```xs
var: intrabarpersist _LastPos(0);

// ❌ 錯誤一：方向判斷用 filled[1]
// filled[1] 是「上一根 K 結束時」的 filled，不是上個 tick；
// 而且 SetPosition 後 filled 還沒回報，空單回補時 filled(-50) > filled[1](-50) = false → 印成 S
if position <> _LastPos then begin
    if filled > filled[1] then _Dir = "B" else _Dir = "S";   // 空單回補印錯成 S
end;

// ❌ 錯誤二：狀態快照誤用前後差
// 定時回報時 position 早就 = _LastPos，兩個比較都不成立 → _Dir 殘留上次值
if time = 100300 then begin
    if position > _LastPos then _Dir = "B"
    else if position < _LastPos then _Dir = "S";             // 整段不成立，印出殘值
end;

// ✅ 正確：方向用前後差，狀態用當下值
if position <> _LastPos then begin                            // 事件：部位剛變動
    if position > _LastPos then _Dir = "B" else _Dir = "S";   // 前後差判方向
    print(file(_LogPath), _Dir + "," + numtostr(position * 1000, 0));
    _LastPos = position;
end;

if time = 100300 then begin                                   // 快照：定時回報
    if position > 0 then _Dir = "B"
    else if position < 0 then _Dir = "S";                     // 當下值判狀態
    print(file(_LogPath), _Dir + "," + numtostr(position * 1000, 0));
end;
```

方向判定四情境驗證（`_LastPos` 為動作前部位）：

| 事件 | position | _LastPos | `position > _LastPos` | 印 |
|---|---|---|---|---|
| 做多進場 | +50 | 0 | true | B ✓ |
| 多單出場 | 0 | +50 | false | S ✓ |
| 做空進場 | -50 | 0 | false | S ✓ |
| 空單回補 | 0 | -50 | true | B ✓ |

**與 #27 的關係**：#27 講「偵測剛變動」要用 `intrabarpersist` 不要用 `[1]`；本條進一步講「變動的方向怎麼判」——同樣不能用 `filled[1]`／`position[1]`，要用 `position` 對 `_LastPos` 的前後差。`SetPosition` 一呼叫 `position` 立刻更新但 `filled` 會延遲數個 tick，所以一切方向／變動判斷都應以 `position` 為準，不要碰 `filled[1]`。

## 29. `GetInfo("IsRealTime")` 回測時恆為 0 — 實戰初始化邏輯回測不會執行

**Why**（官方論壇 虎科大許教授，以期貨市場為例）：實盤時只要在交易時段（日盤/夜盤）`GetInfo("IsRealTime")` 都是 1；但**回測全程走歷史資料，它永遠是 0**。所以 `if GetInfo("IsRealTime")=0 then return;` 這條實戰常用防護，會讓整支腳本在回測時**一根 K 都不執行**；延伸推論：`Once(GetInfo("IsRealTime")=1 ...)` 式的初始化（見 #31 實案）在回測同樣永遠沒機會跑。

**How to apply：**

- 實戰腳本要回測前，先檢查是否有 `IsRealTime` 相關防護/初始化，通常需要暫時拿掉或改寫
- 想寫「實戰回測兩用」也可以（例如用 `GetInfo("TradeMode")` 分流），但代價是實戰效率；多數情況「實戰版/回測版分開維護」更省事
- 這也是為什麼「回測正常、實盤不動」或反過來時，第一個要查的就是 `IsRealTime` 相關條件

## 30. 資料日期陷阱：夜盤 `Date` 三兄弟不一致 ＋ 盤前洗價抓到昨日 K

**Why（一）夜盤三兄弟**（官方論壇 虎科大許教授 實測，台指期全日盤）：三個「都叫日期」的函數在夜盤回傳值不同——

| 時點 | `Date` | `GetFieldDate("日期")` | `GetField("日期","D")` | `GetFieldDate("日期")[1]` | `GetField("日期","D")[1]` |
|---|---|---|---|---|---|
| 週五晚上（夜盤） | 週五 | 下週一 | 下週一 | 下週一 | 週五 |
| 週六凌晨（夜盤） | 週六 | 下週一 | 下週一 | 下週一 | 週五 |

夜盤跨日邏輯（每日歸零區 `Date <> Date[1]`）與「今天是星期幾」判斷混用這三者會出現難以重現的錯誤；同一支腳本內只用其中一種，並實測列印確認。

**Why（二）盤前洗價抓到昨日 K**（使用者實測回報，非上列論壇串）：盤前執行洗價時，若該商品當天的 tick 尚未進來，`GetField` 系列抓到的「最新一根 K」其實是**昨日**的 K 棒 — 邏輯照常執行、資料卻是昨天的，全程不報錯。

**How to apply**：凡「開盤初期就要用今日資料」的邏輯，先加日期驗證 guard：

```xs
// 確認今日 K 棒已存在再往下（盤前 tick 未進來時 GetFieldDate 會是昨日）
if GetFieldDate("開盤價", "D") = CurrentDate then begin
    // ... 今日資料才可用的邏輯
end;
```

## 31. `Once` 賦值的變數沒加 `intrabarpersist` → 委託價歸零 → 被系統夾成漲跌停價（變相市價單）

**Why**（官方論壇實案。值得注意：許教授第一時間診斷「問題並不在 intrabarpersist」，是 XS 小編後續指出真因 — 連專家都會誤判，可見其隱蔽）：逐筆洗價下，三個各自「合理」的行為疊加成一張神祕市價單（教授觀察到委託價 32.8 正是當天跌停價；「委託價超出漲跌停會被轉成漲跌停價」的平台語意由小編確認）：

1. `Once(...) begin _RecO = GetField("開盤價","D"); end` 只執行一次；`_RecO` 沒宣告 `intrabarpersist`，**下一次洗價就被重置回預設值 0**（除非那次 Once 剛好是該根 bar 最後一次洗價）
2. `SetPosition(qty, _RecO * 1.02)` 的委託價因此算出 0
3. **`SetPosition` 的委託價超出漲跌停範圍時，系統自動改成漲跌停價**（0 → 跌停價）— 空單掛在跌停 ≈ 市價單，立刻成交

三步全部靜默。表象是「掛單價格跟算式對不上、莫名用市價成交」。

```xs
// ❌ 錯誤：Once 賦值 + 一般變數，逐筆洗價下秒歸零
var: _RecO(0);
Once(GetInfo("IsRealTime")=1 and GetField("成交量","Tick")<>0) begin
    _RecO = GetField("開盤價","D");
end;
SetPosition(-1 * _Qty, _RecO * (1 + 0.01 * _P1));   // _RecO=0 → 委託價被夾到跌停

// ✅ 正確：跨洗價要保值的變數一律 intrabarpersist
var: intrabarpersist _RecO(0);
```

**How to apply：**

- 「交易腳本狀態變數必須 intrabarpersist」不只指旗標 — **凡是「某次洗價賦值、之後洗價還要用」的數值（Once 初始化、記錄的開盤價/成本價）都算**
- 下單前 `print` 出實際委託價驗證，是抓這類問題最快的手段
- 記住平台語意：SetPosition 委託價超出漲跌停 → 自動夾到漲跌停價，不會報錯拒單
