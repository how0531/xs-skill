# XScript 官方語法與核心說明文件

本文件為 XQ（嘉實資訊）XScript 交易語法的完整技術參考手冊，融合《程式交易的第一本書》教學內容與 [XSHelp 官方說明](https://xshelp.xq.com.tw/XSHelp/) 的函數/欄位定義。 可直接上傳至 AI 助理知識庫，作為 XScript 語法的最高指導原則。

---

## 1\. 基礎語法與時間序列 (Basic Syntax & Time Series)

XScript 的語法基本架構是由一行行最後由分號 `;` 結束的**敘述式 (statement)** 所組成。把這些敘述式按照執行的先後順序排在一起，就是一個**腳本 (script)**。電腦會依序一行一行地執行腳本上的指令。

### 1.1 敘述式 (Statement) 與腳本結構

- 每一行敘述式以分號 `;` 結束，宣告該行指令已完成。  
- 腳本由多行敘述式按執行順序組成。  
- XScript 建構在 **K 棒時間序列** 的基礎上，所有運算都以 K 棒為單位進行。  
- 語法不區分大小寫（`Close` 與 `close` 等價）。

// 這是一個完整的腳本範例

Input: length(20);

Variable: ma(0);

ma \= Average(Close, length);

if Close CrossOver ma then ret \= 1;

### 1.2 變數與參數宣告 (Variable & Input)

#### 參數 (Input)

使用 `Input:` 宣告可於介面調整的參數，參數值在指定後**不會隨運算改變**。

Input: length(5);          // 宣告參數 length，預設值為 5

Input: ratio(3);           // 宣告參數 ratio，預設值為 3

Input: N(NumericSimple);   // 宣告參數為簡單數值型態（不帶預設值）

- 可透過 `SetInputName(N, "說明文字");` 為第 N 個參數加上中文標籤。  
- 可用 `Inputs:` 作為 `Input:` 的複數別名。

#### 變數 (Variable)

使用 `Variable:` 或簡寫 `Var:` 宣告變數，變數的值**會隨運算結果改變**。

Var: x1(0);                // 宣告數值變數，初始值 0

Var: isMatch(true);        // 宣告布林變數，初始值 true

Var: msg("hello");         // 宣告字串變數

Var: x1(0), x2(0), x3(0); // 同時宣告多個變數，用逗號分隔

變數宣告三步驟：**宣告** → **指定** → **應用**

Var: range(0);             // 1\. 宣告

range \= High \- Low;        // 2\. 指定

if range \> range\[1\] then ret \= 1; // 3\. 應用

#### 變數與參數的差異

| 特性 | Input (參數) | Variable (變數) |
| :---- | :---- | :---- |
| 值是否改變 | 指定後固定不變 | 隨運算結果改變 |
| 用途 | 指定絕對值，方便調整 | 代表運算結果，方便引用 |
| 宣告語法 | `Input: name(value);` | `Var: name(value);` |
| 介面可調 | ✅ 可在參數設定中修改 | ❌ 只能在腳本中修改 |

### 1.3 相對 K 棒參照與標點符號

#### 時間序列參照

使用中括號 `[n]` 代表前 n 根 K 棒的值：

| 語法 | 意義 |
| :---- | :---- |
| `Close` 或 `Close[0]` | 當前 K 棒收盤價 |
| `Close[1]` | 前一根 K 棒收盤價 |
| `High[5]` | 前第 5 根 K 棒最高價 |
| `Volume[2]` | 前第 2 根 K 棒成交量 |

⚠️ 變數也支援時間序列參照：`range[1]` 代表前一根 K 棒的 range 值。

#### 標點符號

| 符號 | 名稱 | 說明 |
| :---- | :---- | :---- |
| `;` | 分號 | 宣告一個敘述式結束。例：`x1 = High - Close;` |
| `:` | 冒號 | 宣告變數及參數。例：`Var: x1(0);`、`Input: days(5);` |
| `[n]` | 中括號 | 指定前 n 根 K 棒的回傳值。例：`Close[3]` |
| `//` | 雙斜線 | 單行註解，雙斜線後面同一行文字電腦忽略 |
| `{ }` | 大括號 | 多行區塊註解，中間所有內容電腦不予理會 |
| `,` | 逗號 | 分隔多個變數/參數，或函數的參數 |
| `" "` | 雙引號 | 定義文字字串 |
| `( )` | 小括號 | 函數參數、運算式分組 |

### 1.4 常數與布林值

XScript 支援的常數：

| 常數 | 說明 |
| :---- | :---- |
| 阿拉伯數字 | 如 `1`、`100`、`3.14` |
| `True` | 布林值「真」 |
| `False` | 布林值「假」 |
| `PI` | 圓周率 3.14159 |
| `Sunday`\~`Saturday` | 星期常數，值為 0\~6 |

### 1.5 免宣告系統變數

系統預設提供以下變數，**無須宣告**即可直接使用：

| 變數 | 型態 | 數量 |
| :---- | :---- | :---- |
| `Value1` \~ `Value99` | 數值變數 | 99 個 |
| `Condition1` \~ `Condition99` | 布林變數 | 99 個 |

Value1 \= Average(Close, 20);    // 不需要宣告，直接使用

Condition1 \= Close \> Value1;    // 布林值也可以直接使用

### 1.6 保留字與忽略字

#### 忽略字 (Ignored Words)

為了讓語法更貼近口語化英文，以下字詞可自由穿插在腳本中，電腦會自動忽略：

`A`, `An`, `At`, `Based`, `By`, `Does`, `From`, `Is`, `Of`, `On`, `Place`, `Than`, `The`, `Was`

例如 `Close is > High[1]` 等同於 `Close > High[1]`。

#### 保留字

變數和參數取名時，不可使用系統保留字（在編輯器中會以藍色標示）。主要保留字包括：`If`, `Then`, `Else`, `For`, `To`, `DownTo`, `Begin`, `End`, `While`, `Switch`, `Case`, `Default`, `Break`, `Return`, `And`, `Or`, `Not`, `Xor`, `True`, `False`, `Input`, `Variable`, `Array`, `Plot`, `Print` 等。

### 1.7 資料格式

XScript 支援四種資料格式：

| 格式 | 說明 | 宣告方式 |
| :---- | :---- | :---- |
| 數值 | 整數或小數 | `Var: x(0);` |
| 字串 | 文字字串 | `Var: x("文字");` |
| 布林值 | True / False | `Var: x(True);` |
| 日期/時間 | 8碼日期(yyyyMMdd) 或 6碼時間(HHmmss) | `Var: x(090000);` |

⚠️ 日期/時間在宣告時被當作數值，但用在時間函數（如 `TimeDiff`）時系統會自動識別為時間格式。

---

## 2\. 運算子 (Operators)

### 2.1 數學運算子

| 運算子 | 功能 | 範例 |
| :---- | :---- | :---- |
| `+` | 相加 | `Close + Open` |
| `-` | 相減 | `High - Low` |
| `*` | 相乘 | `Close * 1.05` |
| `/` | 相除 | `Close / Close[1]` |

### 2.2 關係運算子

| 運算子 | 功能 | 範例 |
| :---- | :---- | :---- |
| `>` | 大於 | `Close > Open` |
| `<` | 小於 | `Close < Close[1]` |
| `>=` | 大於等於 | `Volume >= 1000` |
| `<=` | 小於等於 | `RSI(Close,14) <= 30` |
| `=` | 等於 | `Close = High` |
| `<>` | 不等於 | `BarFreq <> "D"` |

⚠️ **等於判斷用單一等號 `=`**（不是 `==`）。

⚠️ 關係運算式的兩端各只能是一個數值，不可寫成 `Close > Close[1] > Close[2]`，必須拆成 `Close > Close[1] and Close[1] > Close[2]`。

### 2.3 邏輯運算子

| 運算子 | 功能 | 說明 |
| :---- | :---- | :---- |
| `And` | 且 | 兩邊都為 True 才回傳 True |
| `Or` | 或 | 任一邊為 True 即回傳 True |
| `Not` | 否定 | `Not False = True`，`Not True = False` |
| `Xor` | 互斥或 | 兩邊不同時回傳 True |

---

## 3\. 流程控制 (Flow Control)

### 3.1 If...Then...Else

最常用的流程控制語法，共有以下幾種寫法：

**單條件單敘述：**

if Close \> Close\[1\] then ret \= 1;

**單條件帶 Else：**

if Close\[1\] \> High then TrueHigh \= Close\[1\]

else TrueHigh \= High;

⚠️ 有 `Else` 時，`Then` 後的敘述式結束處**不打分號**，分號打在 `Else` 後的敘述式結束處。

**多條件串接：**

if Open \= q\_DailyUplimit then ret \= 1

else if Open \> Close\[1\] \* 1.025 and Close \= q\_DailyUplimit and Time \< 091500

     then ret \= 1;

### 3.2 Begin...End;

當條件符合時需要執行多行敘述，必須用 `Begin...End;` 包裹：

if Open \> High\[1\] then

begin

    Value1 \= (1 \- Close\[1\] / Close\[3\]) \* 100;

    Value2 \= (Open \- High\[1\]) / Close \* 100;

end;

### 3.3 For...To/DownTo...Begin...End;

迴圈控制，`To` 為遞增，`DownTo` 為遞減：

Var: total(0);

for Value1 \= 1 to 10

begin

    total \= total \+ Close\[Value1\];

end;

### 3.4 While...Begin...End;

當條件成立時持續執行迴圈：

Var: i(0);

i \= 0;

while i \< 10

begin

    Value1 \= Value1 \+ Close\[i\];

    i \= i \+ 1;

end;

### 3.5 Switch...Case...Default...End;

多重條件分支，用來檢查變數的不同數值選項：

Value1 \= GetField("外資買賣超");

Var: count(0);

switch(Value1)

begin

    case \> 0: count \= count \+ 1;

    case \< 0: count \= count;

    case 0:   count \= count;

end;

### 3.6 Repeat...Until

先執行再判斷條件的迴圈：

Var: i(0);

i \= 0;

repeat

    Value1 \= Value1 \+ Close\[i\];

    i \= i \+ 1;

until (i \>= 10);

### 3.7 Once / Break / Return

| 關鍵字 | 說明 |
| :---- | :---- |
| `Once` | 後面的描述只要符合一次，下次程式就會自動忽略 |
| `Break` | 跳出目前的迴圈 |
| `Return` | 中止腳本執行，回到呼叫者（常見用法：`if BarFreq <> "D" then Return;`） |

---

## 4\. 資料讀取與時序函數 (Data Access & Time Functions)

### 4.1 回傳值 (Reserved Data Words)

K 棒上最基本的數據，寫下名稱電腦就會自動傳回對應數值：

| 回傳值 | 簡寫 | 說明 |
| :---- | :---- | :---- |
| `Open` | `O` | K 棒開盤價 |
| `High` | `H` | K 棒最高價 |
| `Low` | `L` | K 棒最低價 |
| `Close` | `C` | K 棒收盤價 |
| `Volume` | `V` | K 棒成交量 |
| `Date` | `D` | K 棒日期（YYYYMMDD） |
| `Time` | `T` | K 棒時間（HHMMSS） |
| `OpenInterest` | `I` | 未平倉量（僅期貨/選擇權） |
| `Uplimit` | — | 漲停價（僅日頻率） |
| `Downlimit` | — | 跌停價（僅日頻率） |

### 4.2 日期與時間函數

#### 系統時間

| 函數 | 說明 | 格式 |
| :---- | :---- | :---- |
| `CurrentDate` | 執行當下的日期 | yyyyMMdd（如 20240115） |
| `CurrentTime` | 執行當下的時間 | HHmmss（如 093020） |
| `CurrentTimeMS` | 執行當下的時間含毫秒 | HHmmss.fff |

#### K 棒頻率

| 函數 | 說明 |
| :---- | :---- |
| `BarFreq` | 傳回 K 棒頻率單位（字串）：`"Tick"`, `"Min"`, `"Hour"`, `"D"`, `"W"`, `"M"`, `"Q"`, `"H"`, `"Y"` |
| `BarInterval` | 傳回 K 棒間隔數值（如 5 分鐘線時回傳 5） |

// 限定腳本只在 5 分鐘線執行

if BarFreq \<\> "Min" or BarInterval \<\> 5 then

    RaiseRunTimeError("請設定頻率為5分鐘線");

#### 常用時間函數一覽

| 函數 | 說明 |
| :---- | :---- |
| `DateAdd(date, n, unit)` | 日期加減運算 |
| `DateDiff(date1, date2)` | 計算兩個日期的差異天數 |
| `TimeDiff(time1, time2, unit)` | 計算兩個時間的差異 |
| `TimeAdd(time, n, unit)` | 時間加減運算 |
| `Year(date)` | 取得年份 |
| `Month(date)` | 取得月份 |
| `DayOfMonth(date)` | 取得日 |
| `DayOfWeek(date)` | 取得星期（0=日） |
| `Hour(time)` | 取得小時 |
| `Minute(time)` | 取得分鐘 |
| `EncodeDate(y, m, d)` | 合併年月日為日期數值 |
| `EncodeTime(h, m, s)` | 合併時分秒為時間數值 |
| `FormatDate(date, fmt)` | 日期轉格式化字串 |
| `FormatTime(time, fmt)` | 時間轉格式化字串 |
| `DateToString(date)` | 日期轉字串 |
| `StringToDate(str)` | 字串轉日期 |

#### 限定今日 K 棒才執行的常用寫法

if Date \<\> CurrentDate then Return; // 只在今天的 K 棒才執行

### 4.3 盤後資料 GetField

**語法**：`GetField("欄位名稱", "頻率")`

讀取日線以上的盤後籌碼、財報、基本面資料。可搭配中括號取得歷史數值。

Value1 \= GetField("外資買賣超");      // 取得今日外資買賣超（張數）

Value2 \= GetField("外資買賣超")\[1\];   // 取得前一日外資買賣超

Value3 \= GetField("營收年增率", "M"); // 取得月頻率的營收年增率

⚠️ GetField 的資料都是盤後資料（日資料），使用這些欄位的腳本，在設定策略雷達時，頻率必須設定為**日線以上**。

#### GetField 常用籌碼欄位對照表

| 中文欄位名 | 英文變數名 | 說明 |
| :---- | :---- | :---- |
| 外資買賣超 | Fdifference | 外資買張 \- 外資賣張 |
| 外資持股比例 | Fsharesheldratio | 外資持股佔股本比例 |
| 投信買賣超 | Sdifference | 投信買張 \- 投信賣張 |
| 自營商買賣超 | Ddifference | 自營商買張 \- 自營商賣張 |
| 法人買賣超張數 | investorDifference | 三大法人合計買賣超 |
| 融資餘額張數 | Pomremain | 融資餘額 |
| 融券餘額張數 | shortsaleremain | 融券餘額 |
| 借券餘額張數 | SBLbalance | 借券餘額 |
| 主力買賣超張數 | LeaderDifference | 主力買張 \- 主力賣張 |
| 散戶買賣超張數 | retaildifference | 散戶買張 \- 散戶賣張 |
| 控盤者買賣超張數 | controllerdifference | 控盤者淨買超 |
| 當日沖銷張數 | daytradeshares | 當日沖銷張數 |
| 成交金額 | TradeValue | 成交金額 |
| 內盤量 | TradeVolumeAtBid | 內盤量 |
| 外盤量 | TradeVolumeAtAsk | 外盤量 |
| 董監持股佔股本比例 | — | 內部人持股 |

ℹ️ GetField 可同時使用中文名或英文名，例如 `GetField("外資買賣超")` 等同於 `GetField("Fdifference")`。

### 4.4 即時欄位 GetQuote

讀取盤中即時的成交價量、委買委賣等資料。使用方式是直接將欄位名稱指定給變數。

Value1 \= q\_DailyOpen;      // 今日開盤價

Value2 \= q\_DailyVolume;    // 今日累計成交量

Value3 \= q\_OutSize;        // 今日外盤量

#### GetQuote 即時欄位完整列表

| 欄位名稱 | 說明 |
| :---- | :---- |
| `q_DailyOpen` | 當日開盤價 |
| `q_DailyHigh` | 當日最高價 |
| `q_DailyLow` | 當日最低價 |
| `q_DailyVolume` | 當日總成交量 |
| `q_RefPrice` | 參考價 |
| `q_AvgPrice` | 均價 |
| `q_Last` | 最新成交價 |
| `q_Bid` | 買進價 |
| `q_Ask` | 賣出價 |
| `q_BidAskFlag` | 內外盤標記（1=外盤, \-1=內盤） |
| `q_TickVolume` | 單量 |
| `q_PreTotalVolume` | 昨量 |
| `q_PriceChangeRatio` | 當日漲跌幅(%) |
| `q_InSize` | 當日內盤量 |
| `q_OutSize` | 當日外盤量 |
| `q_BestBid1`\~`q_BestBid5` | 五檔買進價 |
| `q_BestAsk1`\~`q_BestAsk5` | 五檔賣出價 |
| `q_BestBidSize` | 最佳買進委買量 |
| `q_BestAskSize` | 最佳賣出委賣量 |
| `q_BestBidSize1`\~`q_BestBidSize5` | 五檔委買量 |
| `q_BestAskSize1`\~`q_BestAskSize5` | 五檔委賣量 |
| `q_SumBidSize` | 總委買量 |
| `q_SumAskSize` | 總委賣量 |
| `q_DailyUplimit` | 今日漲停價 |
| `q_DailyDownlimit` | 今日跌停價 |

### 4.5 跨商品資料 GetSymbolField / GetSymbolQuote

讀取**其他商品**的欄位資料：

Value1 \= GetSymbolField("2330.TW", "收盤價");    // 取得台積電收盤價

Value2 \= GetSymbolField("2330.TW", "外資買賣超"); // 取得台積電外資買賣超

| 函數 | 說明 |
| :---- | :---- |
| `GetSymbolField(symbol, field)` | 讀取指定商品的盤後欄位資料 |
| `GetSymbolInfo(symbol, field)` | 讀取商品基本資訊 |
| `CheckSymbolField(symbol, field)` | 判斷指定商品欄位是否合法 |
| `Symbol` | 目前執行腳本的商品代碼 |
| `SymbolName` | 目前執行腳本的商品名稱 |

---

## 5\. 函數 (Functions)

函數讓使用者可以把經常要計算的方法，用簡單的名稱來表示。例如 `Average(Close, 5)` 代表收盤價的 5 期移動平均。

### 5.1 內建函數總覽

#### 一般函數

| 函數名稱 | 說明 |
| :---- | :---- |
| `BarAdjusted` | 目前執行的K棒是否為還原頻率 |
| `BarFreq` | 取得目前執行的K棒的頻率 |
| `BarInterval` | 分鐘區間 |
| `CallFunction` | 呼叫函數執行 |
| `CurrentBar` | 目前K棒的編號 |
| `DataAlign` | 資料對位 |
| `ExecOffset` | 取得K棒偏移筆數 |
| `File` | 指定Print輸出的檔案位置 |
| `GetBackBar / GetBarBack` | 讀取資料引用筆數 |
| `GetBarOffset` | 依傳入的交易日日期取得相對K棒位置 |
| `GetFieldStartOffset` | 判斷欄位初始點 |
| `GetFirstBarDate` | 讀取第一筆資料的日期 |
| `GetInfo` | 取得執行資訊 |
| `GetSymbolFieldStartOffset` | 判斷指定商品欄位初始點 |
| `GetSymbolGroup` | 抓取目前執行商品的相關商品清單 |
| `GetTBMode` | 取得自定指標繪圖模式 |
| `GetTotalBar` | 讀取總額資料 |
| `GroupSize` | 取得Group的大小 |
| `IsFirstCall` | 特定執行時機點 |
| `IsLastBar` | 判斷是否為最新的K棒 |
| `IsSessionFirstBar` | 判斷是否為當日第一根K棒 |
| `IsSessionLastBar` | 判斷是否為當日最後一根K棒 |
| `MaxBarsBack` | 回傳腳本所設定的最大引用筆數 |
| `NoPlot` | 清除某個指標序列的數值 |
| `OutputField` | 設定選股輸出欄位 |
| `PlaySound` | 播放音效 |
| `Plot / PlotN` | 產生圖形上的繪圖序列 |
| `PlotFill` | 產生填充繪圖序列 |
| `PlotK` | 繪製K棒於計算位置 |
| `PlotLine` | 繪製指標趨勢線 |
| `Print` | 輸出執行結果至編輯器和檔案 |
| `RaiseRunTimeError` | 產生錯誤中斷 |
| `SetAlign` | 設定資料對位方式 |
| `SetBackBar / SetBarBack` | 設定最大引用筆數 |
| `SetBarFreq` | 指定腳本支援的頻率 |
| `SetBarMode` | 設定函數計算方式 |
| `SetFirstBarDate` | 設定資料開始日期 |
| `SetInputName` | 設定輸入參數的名稱 |
| `SetOutputName` | 設定選股輸出欄位標題 |
| `SetPlotLabel` | 設定繪圖標記名稱 |
| `SetRemoveOutlier` | 排除離群值 |
| `SetTBMode` | 設定自定指標繪圖模式 |
| `SetTotalBar` | 設定資料讀取筆數 |
| `SymbolExchange` | 目前執行商品的交易所編碼 |
| `SymbolType` | 目前執行腳本的商品類型 |

#### 時間函數

| 函數名稱 | 說明 |
| :---- | :---- |
| `CurrentTime` | 回傳腳本執行時間（HHMMSS） |
| `CurrentTimeMS` | 回傳腳本執行時間含毫秒 |
| `EncodeTime` | 將時、分、秒合併為時間數值 |
| `FormatTime` | 將時間值轉成格式化字串 |
| `Hour` | 取得小時值（0-23） |
| `MilliSecond` | 取得毫秒值（0-999） |
| `Minute` | 取得分鐘值（0-59） |
| `Second` | 取得秒值（0-59） |
| `StringToTime` | 將字串轉成時間數值 |
| `TimeAdd` | 時間加減運算 |
| `TimeDiff` | 計算兩個時間的差異 |
| `TimeToString` | 將時間數值轉成字串 |
| `TimeValue` | 取得時間的指定欄位值 |

#### 日期函數

| 函數名稱 | 說明 |
| :---- | :---- |
| `CurrentDate` | 回傳腳本執行日期（YYYYMMDD） |
| `DateAdd` | 日期加減運算 |
| `DateDiff` | 計算兩個日期的差異天數 |
| `DateToJulian` | 西曆日期轉儒略日 |
| `DateToString` | 日期轉字串 |
| `DateValue` | 取得日期的指定欄位值 |
| `DayOfMonth` | 取得日（1-31） |
| `DayOfWeek` | 取得星期（0=日, 1=一...） |
| `EncodeDate` | 將年、月、日合併為日期數值 |
| `FormatDate` | 將日期轉成格式化字串 |
| `JulianToDate` | 儒略日轉西曆日期 |
| `Month` | 取得月份（1-12） |
| `StringToDate` | 字串轉日期數值 |
| `WeekOfMonth` | 取得月中第幾週 |
| `WeekOfYear` | 取得年中第幾週 |
| `Year` | 取得年份 |

#### 字串函數

| 函數名稱 | 說明 |
| :---- | :---- |
| `InStr` | 查詢字串是否包含某個子字串 |
| `LeftStr` | 取字串的左邊子字串 |
| `LowerStr` | 把字串改成小寫 |
| `MidStr` | 取字串內部的一個子字串 |
| `NumToStr` | 把數值轉成字串 |
| `RightStr` | 取字串的右邊子字串 |
| `StrCompare` | 字串比較 |
| `StrEndWith` | 判斷字串結尾是否相同 |
| `StrLen` | 回傳字串長度 |
| `StrSplit` | 字串切割 |
| `StrStartWith` | 判斷字串開頭是否相同 |
| `StrToNum` | 把字串轉成數值 |
| `StrTrim` | 去除空白 |
| `Text` | 組成字串（多參數連結） |
| `UpperStr` | 把字串改成大寫 |

#### 數學函數

| 函數名稱 | 說明 |
| :---- | :---- |
| `AbsValue` | 取得絕對值 |
| `ArcCosine / ArcSine / ArcTangent` | 反三角函數 |
| `AvgList` | 計算多個數值的平均值 |
| `Ceiling` | 小數無條件進位轉整數 |
| `Combination` | 計算組合數 |
| `Cos / Cosine` | 餘弦函數 |
| `CoTangent` | 餘切函數 |
| `ExpValue` | 自然對數的次方 |
| `Factorial` | 階乘 |
| `Floor` | 小數無條件捨去轉整數 |
| `FracPortion` | 回傳小數部分 |
| `IntPortion` | 回傳整數部分 |
| `Log` | 自然對數 |
| `MaxList / MaxList2` | 多數值取最大/第二大 |
| `MinList / MinList2` | 多數值取最小/第二小 |
| `Mod` | 餘數 |
| `Neg` | 負絕對值 |
| `NthMaxList / NthMinList` | 取第N大/小的數值 |
| `Permutation` | 排列數 |
| `Pos` | 正數值 |
| `Power` | 乘冪 |
| `Random` | 亂數值 |
| `Round` | 四捨五入 |
| `Sign` | 正負號 |
| `Sin / Sine` | 正弦函數 |
| `Square` | 平方 |
| `SquareRoot` | 平方根 |
| `SumList` | 多數值加總 |
| `Tan / Tangent` | 正切函數 |

#### 欄位函數

| 函數名稱 | 說明 |
| :---- | :---- |
| `CheckField` | 判斷欄位數值是否合法 |
| `CheckSymbolField` | 判斷指定商品欄位是否合法 |
| `GetField` | 讀取欄位資料 |
| `GetFieldDate` | 取出欄位最新一期的日期 |
| `GetFieldPublishDate` | 取得欄位在XQ中更新的日期 |
| `GetQuote` | 讀取報價欄位資料 |
| `GetSymbolField` | 讀取指定商品的欄位資料 |
| `GetSymbolFieldDate` | 取出指定商品欄位最新日期 |
| `GetSymbolInfo` | 讀取商品資訊欄位資料 |
| `IsSupportField` | 判斷欄位是否支援 |
| `IsSupportSymbolField` | 判斷指定商品欄位是否支援 |
| `Symbol` | 目前商品代碼 |
| `SymbolName` | 目前商品名稱 |
| `UserID` | 回傳XQ登入帳號 |

#### 陣列函數

| 函數名稱 | 說明 |
| :---- | :---- |
| `Array_Compare` | 比較陣列內元素 |
| `Array_Copy` | 複製陣列的元素 |
| `Array_GetMaxIndex` | 取得陣列內元素個數 |
| `Array_GetType` | 取得陣列資料類型 |
| `Array_SetMaxIndex` | 重設陣列大小 |
| `Array_SetValRange` | 重設陣列值 |
| `Array_Sort` | 陣列排序 |
| `Array_Sort2d` | 二維陣列排序 |
| `Array_Sum` | 取得陣列內元素加總 |

#### 交易函數

| 函數名稱 | 說明 |
| :---- | :---- |
| `AddSpread` | 計算調整檔位後的價格 |
| `Alert` | 警示紀錄 |
| `Buy` | 多單加碼 |
| `CancelAllOrders` | 取消交易 |
| `Cover` | 空單回補 |
| `DefaultBuyPrice` | 預設買進價格 |
| `DefaultSellPrice` | 預設賣出價格 |
| `Filled` | 成交部位 |
| `FilledAtBroker` | 實際庫存數量 |
| `FilledAvgPrice` | 未平倉成本 |
| `FilledEntryDate / FilledEntryTime` | 部位建立日期/時間 |
| `FilledRecordBS` | 成交方向（1=買, \-1=賣） |
| `FilledRecordCount` | 成交紀錄筆數 |
| `FilledRecordDate / FilledRecordTime` | 成交日期/時間 |
| `FilledRecordPrice / FilledRecordQty` | 成交價格/數量 |
| `IsListedSymbol` | 清單商品判斷 |
| `IsMarketPrice` | 市價判斷 |
| `Market` | 市價委託 |
| `Position` | 目前部位 |
| `Sell` | 多單減碼 |
| `SetPosition` | 調整部位 |
| `Short` | 空單加碼 |

### 5.2 系統函數總覽

#### 價格取得函數

| 函數名稱 | 說明 |
| :---- | :---- |
| `AvgPrice` | 利用K棒開高低收計算的平均價格 |
| `CloseD / CloseW / CloseM / CloseQ / CloseH / CloseY` | 日/週/月/季/半年/年收盤價 |
| `HighD / HighW / HighM / HighQ / HighH / HighY` | 日/週/月/季/半年/年最高價 |
| `LowD / LowW / LowM / LowQ / LowH / LowY` | 日/週/月/季/半年/年最低價 |
| `OpenD / OpenW / OpenM / OpenQ / OpenH / OpenY` | 日/週/月/季/半年/年開盤價 |
| `Highest(data, length)` | 區間最大值 |
| `Lowest(data, length)` | 區間最小值 |
| `FastHighest / FastLowest` | 區間最大/最小值（快速版） |
| `TrueHigh / TrueLow` | 真實區間高/低點 |
| `TypicalPrice` | 典型價 \= (H+L+C)/3 |
| `WeightedClose` | 加權平均價 \= (H+L+2C)/4 |

#### 價格計算函數

| 函數名稱 | 說明 |
| :---- | :---- |
| `Average(data, length)` | 移動平均 |
| `EMA(data, length)` | XQ的EMA移動平均線 |
| `XAverage(data, length)` | 指數平滑化移動平均數 |
| `WMA(data, length)` | 加權移動平均數 |
| `Summation(data, length)` | 數列資料加總 |
| `Range` | 高低價區間 \= High \- Low |
| `TrueRange` | 真實區間 |
| `AvgDeviation` | 平均偏移值 |
| `RateOfChange` | 變動率 |
| `UpLimit / DwLimit` | 漲停價 / 跌停價 |
| `SimpleHighestBar / SimpleLowestBar` | 區間內最大/最小值位置 |

#### 價格關係函數

| 函數名稱 | 說明 |
| :---- | :---- |
| `HighestBar(data, length)` | 區間最大值位置 |
| `LowestBar(data, length)` | 區間最小值位置 |
| `FastHighestBar / FastLowestBar` | 區間最大/最小值位置（快速） |
| `HighDays / LowDays` | 創新高/低次數 |
| `NthHighest(data, length, n)` | 第N個極大值 |
| `NthLowest(data, length, n)` | 第N個極小值 |
| `NthHighestBar / NthLowestBar` | 第N個極大/極小值位置 |
| `NthExtremes / NthExtremesArray` | 第N個極值 |
| `Extremes / ExtremesArray` | 極端值計算 |
| `HighestArray / LowestArray` | 陣列最大/最小值 |
| `MoM / QoQ / YoY` | 月/季/年變化率 |
| `OHLCPeriodsAgo` | 取得過去期間內的OHLC |
| `ReadTicks` | 讀取Tick資料 |
| `SimpleHighest / SimpleLowest` | 區間最大/最小值 |

#### 技術指標函數

| 函數名稱 | 說明 |
| :---- | :---- |
| `RSI(data, length)` | 相對強弱指標 |
| `MACD(data, fast, slow)` | 指數平滑異同移動平均線 |
| `Stochastic(h, l, c, len, k, d)` | KD/RSV 隨機指標 |
| `K_Value / D_Value` | KD 快速/慢速平均值 |
| `RSV` | 未成熟隨機值 |
| `BollingerBand(data, len, dev)` | 布林通道 |
| `ATR(length)` | 平均真實區間 |
| `Momentum(data, length)` | 動能指標 |
| `CCI / CommodityChannel` | 商品通道指標 |
| `SAR` | SAR停損點轉向指標 |
| `ADI` | 累積分配指標 |
| `ADO` | 聚散擺盪指標 |
| `AR / BR` | 買賣氣勢/意願指標 |
| `Bias / BiasDiff` | 乖離率 / 乖離率差 |
| `DIF` | 移動平均線差離值 |
| `DirectionMovement` | 動向指標(DMI) |
| `DMO` | 方向性移動振盪指標 |
| `DPO` | 非趨勢價格擺盪 |
| `HL_Osc / MA_Osc` | 高低/均線振盪指標 |
| `KeltnerUB / KeltnerMA / KeltnerLB` | 肯特納通道（上/中/下） |
| `MAM / MTM / MTM_MA` | 動量相關指標 |
| `PercentR` | 威廉指標 |
| `PSY` | 心理線 |
| `RC / ERC` | 變動率指標 |
| `TRIX` | TRIX指標 |
| `VA / VAO / VPT / VR / VVA` | 成交量相關指標 |
| `VHF` | 垂直水平過濾指標 |
| `WAD` | 威廉集散指標 |
| `TechScore` | 多空判斷分數 |
| `ACC` | 加速量指標 |

#### 統計分析函數

| 函數名稱 | 說明 |
| :---- | :---- |
| `StandardDev(data, length)` | 標準差 |
| `VariancePS(data, length)` | 變異數 |
| `Correlation(data1, data2, length)` | 相關係數 |
| `Covariance` | 共變異數 |
| `CoefficientR` | Pearson積差相關係數 |
| `RSquare` | 判定係數（R²） |

#### 趨勢分析函數

| 函數名稱 | 說明 |
| :---- | :---- |
| `Angle(data, length)` | 二點間的角度 |
| `LinearReg(data, length)` | 線性迴歸 |
| `LinearRegAngle / LinearRegSlope` | 線性迴歸角度/斜率 |
| `SwingHigh(data, leftStr, rightStr, n)` | 最近轉折高點的價格 |
| `SwingHighBar` | 最近轉折高點的K棒位置 |
| `SwingLow(data, leftStr, rightStr, n)` | 最近轉折低點的價格 |
| `SwingLowBar` | 最近轉折低點的K棒位置 |
| `TimeSeriesForecast` | 線性迴歸預測值 |
| `NDaysAngle` | 計算股價N日走勢的角度 |
| `UpShadow` | 上影線佔整體比例 |
| `TSELSindex` | 大盤多空指標 |
| `TSEMFI` | 大盤資金流向指標 |

#### 邏輯判斷函數

| 函數名稱 | 說明 |
| :---- | :---- |
| `CrossOver(A, B)` | A 向上穿越 B（黃金交叉）：A\[1\]\<=B\[1\] and A\>B |
| `CrossUnder(A, B)` | A 向下跌破 B（死亡交叉）：A\[1\]\>=B\[1\] and A\<B |
| `TrueAll(cond, length)` | 最近 length 期條件是否全部為真 |
| `TrueAny(cond, length)` | 最近 length 期條件是否有任一筆為真 |
| `TrueCount(cond, length)` | 最近 length 期條件為真的次數 |
| `CountIf(cond, length)` | 條件成立次數 |
| `CountIfARow(cond)` | 連續符合次數 |
| `AverageIF(data, cond, length)` | 條件平均 |
| `SummationIf(data, cond, length)` | 條件加總 |
| `IFF(cond, trueVal, falseVal)` | 條件回傳值（類似三元運算） |
| `BarsLast(cond)` | 上次條件成立距今期數 |
| `Filter(cond, length)` | 過濾連續出現的警示 |
| `DateTime` | 日期時間（14位數格式） |
| `GetBarOffsetForYears` | 依年份取得相對K棒位置 |

#### 期權相關函數

| 函數名稱 | 說明 |
| :---- | :---- |
| `BSPrice / BSDelta / BSGamma / BSTheta / BSVega` | BlackScholes 選擇權評價模型 |
| `blackscholesmodel` | BlackScholes 完整模型 |
| `HVolatility` | 歷史波動率 |
| `IVolatility` | 隱含波動率 |
| `DaysToExpiration / DaysToExpirationTF` | 離到期日天數 |
| `IsXLOrder / IsXOrder` | 判斷是否大單/特大單 |
| `NORMSDIST` | 標準常態累加分配函數 |

#### 跨頻率函數

| 函數名稱 | 說明 |
| :---- | :---- |
| `xf_CrossOver / xf_CrossUnder` | 跨頻率向上穿越/向下跌破 |
| `xf_EMA / xf_XAverage` | 跨頻率指數移動平均 |
| `xf_MACD` | 跨頻率MACD |
| `xf_RSI` | 跨頻率RSI |
| `xf_Stochastic` | 跨頻率KD/RSV |
| `xf_PercentR` | 跨頻率威廉指標 |
| `xf_DirectionMovement` | 跨頻率動向指標 |
| `xf_GetValue / xf_GetBoolean` | 取得跨頻率數值/布林值 |
| `xf_GetDTValue` | 計算指定頻率的序列值 |
| `xf_GetCurrentBar` | 跨頻率K棒編號 |
| `xf_WeightedClose` | 跨頻率加權平均價 |
| `xfMin_* 系列` | 跨分鐘頻率版本（CrossOver/EMA/MACD/RSI/Stochastic等） |
| `BollingerBandWidth` | 布林帶寬度指標 |
| `PercentB` | %b指標 |
| `TurnOverRate` | 周轉率 |

#### Array系統函數

| 函數名稱 | 說明 |
| :---- | :---- |
| `ArrayLinearRegSlope` | 陣列線性迴歸斜率 |
| `ArrayMASeries` | 均線數值序列轉陣列 |
| `ArraySeries` | 數值序列轉陣列 |
| `ArrayXDaySeries` | 跨頻率序列值轉陣列 |

#### 量能相關函數

| 函數名稱 | 說明 |
| :---- | :---- |
| `DiffBidAskVolumeLxL` | 近15分鐘大戶買賣超 |
| `DiffBidAskVolumeXL` | 近15分鐘特大單買賣超張數 |
| `DiffTradeVolumeAtAskBid` | 分時買賣力 |
| `DiffUpDownVolume` | 分時漲跌成交量 |

#### 日期相關函數

| 函數名稱 | 說明 |
| :---- | :---- |
| `angleprice` | 用N期至今的角度計算趨勢線價格 |
| `DownTrend / UpTrend` | 判斷數列是否趨勢向下/向上 |
| `formatMQY` | 依頻率取得代表日期字串 |
| `GetLastTradeDate` | 取得期貨到期日 |
| `LastDayOfMonth` | 月的最後一個日曆天 |
| `NthDayofMonth` | 自開始日算的第N個星期序數日期 |
| `calcvwapdistribution` | 計算過去N日的VWAP分布 |
| `EnterMarketCloseTime` | 判斷是否已進入收盤階段 |

### 5.3 常用函數詳解

#### Average — 移動平均

Average(Close, 20\)      // 20 日收盤價移動平均

Average(Volume, 10\)     // 10 日成交量移動平均

#### CrossOver / CrossUnder — 黃金交叉與死亡交叉

// CrossOver \= A\[1\] \<= B\[1\] and A \> B （向上穿越）

if Close CrossOver Average(Close, 5\) then ret \= 1;

// CrossUnder \= A\[1\] \>= B\[1\] and A \< B （向下跌破）

if RSI(Close, 6\) CrossUnder RSI(Close, 12\) then ret \= 1;

#### Highest / Lowest — 區間極值

Value1 \= Highest(High, 20);   // 最近 20 期的最高價

Value2 \= Lowest(Low, 20);     // 最近 20 期的最低價

#### TrueAll / TrueAny / CountIf

// 最近 3 天都上漲

if TrueAll(Close \> Close\[1\], 3\) then ret \= 1;

// 最近 10 天有任一天漲停

if TrueAny(Close \= Uplimit, 10\) then ret \= 1;

// 最近 20 天中外資買超的天數

Value1 \= CountIf(GetField("外資買賣超") \> 0, 20);

#### BarsLast — 距離上次條件成立的期數

Value1 \= BarsLast(Close CrossOver Average(Close, 20));

// 距離上次黃金交叉已過了幾根 K 棒

### 5.4 自訂函數撰寫

使用者可在 XScript 編輯器中新增函數類型腳本，函數名稱**必須為英文**。

#### 函數參數型態（20種）

| 型態 | 說明 |
| :---- | :---- |
| `Numeric` | 數值 |
| `NumericSimple` | 簡單數值（非時間序列） |
| `NumericSeries` | 數值時間序列（如 Close） |
| `NumericRef` | 數值傳址 |
| `NumericArray` | 數值陣列 |
| `NumericArrayRef` | 數值陣列傳址 |
| `String` | 字串 |
| `StringSimple` | 簡單字串 |
| `StringSeries` | 字串時間序列 |
| `StringRef` | 字串傳址 |
| `StringArray` | 字串陣列 |
| `StringArrayRef` | 字串陣列傳址 |
| `TrueFalse` | 布林值 |
| `TrueFalseSimple` | 簡單布林值 |
| `TrueFalseSeries` | 布林值時間序列 |
| `TrueFalseRef` | 布林值傳址 |
| `TrueFalseArray` | 布林值陣列 |
| `TrueFalseArrayRef` | 布林值陣列傳址 |
| `Value1~99` | 免宣告數值變數 |
| `Condition1~99` | 免宣告布林變數 |

#### 自訂函數範例

// 函數名稱：UpShadow

// 功能：計算上影線佔整體K棒比例

if High \<\> Low then

begin

    if Close \>= Open then

        UpShadow \= (High \- Close) / (High \- Low)

    else

        UpShadow \= (High \- Open) / (High \- Low);

end;

---

## 6\. 執行環境輸出指令與自動交易 (Output Commands & Auto Trading)

### 6.1 選股與警示 RetVal

當篩選條件成立時，使用 `ret = 1;` 觸發警示通知或將商品加入選股清單。

// 最基本的警示觸發

if Close \= High then ret \= 1;

// 帶條件的警示

if Close CrossOver Average(Close, 20\) and Volume \> Volume\[1\] then ret \= 1;

- `RetVal` 是 Return Value 的簡寫，可簡寫為 `ret`。  
- `ret = 1` 時電腦觸發警示；`ret = 0` 或不設定時不觸發。

### 6.2 指標繪圖 Plot

於自訂指標中，使用 `Plot1(數值, "名稱");` 至 `PlotN` 將數值繪製成曲線。

Plot1(Average(Close, 5), "MA5");    // 繪製 5 日均線

Plot2(Average(Close, 20), "MA20");  // 繪製 20 日均線

- **副圖指標**：自訂指標預設在主圖下方開新框顯示。  
- **主圖疊圖**：可將自訂指標疊在K線圖上顯示（在技術分析設定中選擇主圖疊圖頁籤）。  
- `PlotFill`：填充繪圖序列。  
- `PlotK`：繪製K棒。  
- `PlotLine`：繪製趨勢線。  
- `NoPlot`：清除指標序列數值。

### 6.3 自動交易語法 (Auto Trading Syntax)

XScript 提供完整的自動交易指令，可透過策略雷達串接至交易執行。

#### 交易指令

| 函數 | 說明 |
| :---- | :---- |
| `Buy` | 多單加碼（買進） |
| `Sell` | 多單減碼（賣出） |
| `Short` | 空單加碼（放空） |
| `Cover` | 空單回補（回補） |
| `SetPosition(n)` | 調整部位至 n 單位 |
| `CancelAllOrders` | 取消所有未成交委託 |
| `Market` | 市價委託 |

#### 部位查詢

| 函數 | 說明 |
| :---- | :---- |
| `Position` | 目前部位（正數=多單, 負數=空單, 0=無部位） |
| `Filled` | 成交部位 |
| `FilledAtBroker` | 實際庫存數量 |
| `FilledAvgPrice` | 未平倉成本 |
| `FilledEntryDate` / `FilledEntryTime` | 部位建立日期/時間 |
| `FilledRecordBS` | 成交方向（1=買, \-1=賣） |
| `FilledRecordCount` | 成交紀錄筆數 |
| `FilledRecordPrice` / `FilledRecordQty` | 成交價格/數量 |

#### 委託價格設定

| 函數 | 說明 |
| :---- | :---- |
| `DefaultBuyPrice` | 預設買進價格 |
| `DefaultSellPrice` | 預設賣出價格 |
| `AddSpread(price, ticks)` | 計算調整檔位後的價格 |
| `IsMarketPrice` | 市價判斷 |
| `IsListedSymbol` | 清單商品判斷 |

#### 交易時間控制

| 函數 | 說明 |
| :---- | :---- |
| `EnterMarketCloseTime` | 判斷是否已進入收盤階段 |

#### 策略雷達串接自動交易流程

1. 在 XScript 編輯器撰寫交易腳本  
2. 在策略雷達中新增策略，選擇腳本  
3. 設定參數、參照商品、多空方向  
4. 指定頻率（Tick / 分鐘線 / 日線等）  
5. 設定觸發模式（連續觸發 / K棒內單次觸發 / 日內單次觸發）  
6. 串接至自動交易帳號，設定下單參數

// 簡單的均線交叉交易策略範例

Input: fastLen(5), slowLen(20);

Var: fastMA(0), slowMA(0);

fastMA \= Average(Close, fastLen);

slowMA \= Average(Close, slowLen);

if fastMA CrossOver slowMA then Buy;

if fastMA CrossUnder slowMA then Sell;

### 6.4 文字輸出 Print

使用 `Print()` 將數值輸出至本機文字檔，主要用於除錯與回測研究。

Print(CurrentDate, Open, High, Low, Close);

// 研究 RSI 黃金交叉後隔天的漲跌

if RSI(Close, 5\) CrossOver RSI(Close, 10\) then

    Print(Date, Close, Close \- Close\[1\], "RSI黃金交叉");

- 輸出檔案位置：`sysjust/XQ2005/XS/Print/` 目錄下。  
- 可用 `File("路徑")` 指定輸出檔案位置。

### 6.5 中斷防呆 RaiseRunTimeError

若腳本被用在錯誤的頻率或發生運算錯誤，中止腳本執行並輸出提示。

if BarFreq \<\> "Min" or BarInterval \<\> 1 then

    RaiseRunTimeError("請設定頻率為1分鐘線");

### 6.6 選股輸出 SetOutputField / SetOutputName

在選股腳本中，可輸出自訂欄位供結果顯示：

OutputField(1, Value1);            // 輸出第1個自訂欄位

SetOutputName(1, "外資買超天數");    // 設定欄位標題

---

## 7\. XQ 報價欄位完整字典 (Quote Fields)

報價欄位為即時欄位，可透過 `GetQuote` 或 `q_` 前綴取得。

### 7.1 常用

| 欄位名稱 | 說明 |
| :---- | :---- |
| Close | 成交 \- 最新一筆成交的價格 |
| Time | 成交時間 \- 最新一筆成交的時間 |
| EstimatedVolume | 估計量 \- 當日收盤的預估成交量 |
| PreviousDayVolume | 昨量 \- 前一個交易日的盤中成交量 |
| RefPrice | 參考價 \- 當日的參考價 |
| Low | 最低(日) \- 當日的最低價 |
| High | 最高(日) \- 當日的最高價 |
| SingleLotVolume | 單量 \- 最後一筆成交的單量 |
| Bid | 買進 \- 委託簿內買方最高的買價 |
| Open | 開盤(日) \- 當日的開盤價 |
| Ask | 賣出 \- 委託簿內賣方最低的賣價 |
| TotalVolume | 總量(日) \- 當日的總成交量 |

### 7.2 價格

| 欄位名稱 | 說明 |
| :---- | :---- |
| 一個月前收盤價 | 一個月前的收盤價 |
| 一年前收盤價 | 一年前的收盤價 |
| 一週前收盤價 | 五個交易日前的收盤價 |
| 三個月前收盤價 | 三個月前的收盤價 |
| 內外盤標記 | 最後一筆成交價的內外盤標記 |
| 去年收盤 | 去年最後一個交易日的收盤價 |
| 成交 | 最新一筆成交的價格 |
| 均價 | 當日的平均成交價 |
| 前一\~四成交價 | 前第一到第四筆成交價格 |
| 振幅 | 當日的振幅 |
| 參考價 | 當日的參考價 |
| 基差 | 現貨價格與期貨價格的差異 |
| 最低(日) / 最高(日) | 當日的最低/最高價 |
| 買賣價差比 | 買賣價差占買價的比例 |
| 跌停價 / 漲停價 | 當日的跌停/漲停價 |
| 開盤(日) | 當日的開盤價 |
| 漲跌幅 | 當日的漲跌幅 |
| 價差 | 期貨價格與現貨價格的差額 |

### 7.3 量能

| 欄位名稱 | 說明 |
| :---- | :---- |
| 內盤量 / 外盤量 | 當日累計迄今的內/外盤量 |
| 成交比重 | 成交值占大盤的成交比重(%) |
| 成交均量 | 每筆成交平均張數 |
| 成交金額(元) | 當日的總成交金額 |
| 估計量 | 當日收盤的預估成交量 |
| 委買均 / 委賣均 | 每一筆委買/委賣的平均張數 |
| 昨量 | 前一個交易日的盤中成交量 |
| 累成交筆 / 累委買筆 / 累委賣筆 | 開盤迄今的成交/委買/委賣總筆數 |
| 累計成交 / 累計委買 / 累計委賣 | 開盤迄今的成交/委買/委賣總量 |
| 累買成筆 / 累賣成筆 | 以買進/賣出成交的總筆數 |
| 單量 | 最後一筆成交的單量 |
| 量比 | 當日估計量對比昨日的放大比例 |
| 開盤委買 / 開盤委賣 | 開盤時委買/委賣的數量 |
| 開盤買均 / 開盤買筆 / 開盤賣均 / 開盤賣筆 | 開盤時委買賣的均量/筆數 |
| 總成交次數 | 當日成交明細資料總筆數 |
| 總量(日) | 當日的總成交量 |

### 7.4 財務

| 欄位名稱 | 說明 |
| :---- | :---- |
| 營業毛利率 | 最新一期財報的營業毛利率(%) |
| 每股盈餘 | 最新一期財報的每股盈餘 |
| 每股淨值 | 最新一期財報的每股淨值 |
| 每股營業額 | 最新一期財報的每股營業額(元) |
| 股東權益報酬率 | 最新一期財報的ROE(%) |
| 財報年月 | 最新一期財報的年月別(YYYYMM) |
| 營收年月 | 最新一期營收的年月別(YYYYMM) |
| 營收年增率 | 最新一期營收較去年同期的成長率(%) |
| 營收月增率 | 最新一期營收較上一期的成長率(%) |
| 營業利益率 | 最新一期財報的營業利益率(%) |

### 7.5 市場統計

| 欄位名稱 | 說明 |
| :---- | :---- |
| 上漲家數 | 指數成分股內目前上漲的家數 |
| 下跌家數 | 指數成分股內目前下跌的家數 |
| 漲停家數 | 指數成分股內目前漲停的家數 |
| 跌停家數 | 指數成分股內目前跌停的家數 |

### 7.6 期權

| 欄位名稱 | 說明 |
| :---- | :---- |
| Delta / Gamma / RHO / Theta / Vega | 選擇權希臘字母 |
| 內含值 | 選擇權的內含值 |
| 有效槓桿 | 標的變動1%時商品價格變動比率 |
| 到期日 | 商品的到期日(YYYYMMDD) |
| 波動率 / 波動率差額 | 歷史波動率及其與隱含波動率的差異 |
| 時間價值 | 選擇權的時間價值 |
| 執行比例 | 權證商品的執行比例 |
| 理論價 | BlackScholes理論價格 |
| 最後交易日 | 商品的最後交易日 |
| 剩餘日 / 剩餘交易日 | 距最後交易日天數 |
| 買進隱含波動率 / 賣出隱含波動率 | 由最新買/賣價推算的隱含波動率 |
| 買賣權未平倉量比率 / 買賣權成交量比率 | PUT/CALL比率 |
| 損益兩平 | 可達損益兩平的標的股價格 |
| 溢價率百分比 / 價內外百分比 | 權證溢價率/價內外比率 |
| 履約價 | 選擇權/權證的履約價 |
| 標的漲跌 / 標的漲跌幅 / 標的價格 | 標的股相關價格 |
| 獲利率百分比 | (理論價-賣價)/賣價×100% |

### 7.7 五檔統計

| 欄位名稱 | 說明 |
| :---- | :---- |
| 委比 | 目前委買賣差佔委買賣比重(%) |
| 委買 / 委賣 | 最佳一檔的委買/委賣數量 |
| 委買1~~5 / 委賣1~~5 | 第一到第五檔的委買/委賣數量 |
| 委買賣差 | 總委買與總委賣的差 |
| 買進 / 賣出 | 最佳一檔的買/賣價 |
| 買進1~~5 / 賣出1~~5 | 第一到第五檔的買/賣價 |
| 總委買 / 總委賣 | 前五檔委買/委賣數量的加總 |

---

## 8\. XQ 資料欄位完整字典 (Data Fields — GetField 可用)

資料欄位為盤後資料，透過 `GetField("欄位名稱")` 取得。完整欄位列表請參閱 [XSHelp 官方說明](https://xshelp.xq.com.tw/XSHelp/)。

### 8.1 常用 (17項)

| 欄位名稱 | 說明 |
| :---- | :---- |
| 內盤量 | K棒內標記為內盤成交的加總數量 |
| 日期 | K棒資料的日期(YYYYMMDD) |
| 外盤量 | K棒內被標記為外盤成交的加總數量 |
| 成交金額 | 成交的加總金額 |
| 成交量 | K棒資料的成交量 |
| 收盤價 | K棒資料的收盤價 |
| 估計量 | 當日收盤的預估成交量 |
| 均價 | 每日的平均成交價 |
| 時間 | K棒資料的時間(hhmmss) |
| 參考價 | 當日交易的參考價 |
| 最低價 | K棒資料的最低成交價位 |
| 最高價 | K棒資料的最高成交價位 |
| 買入價 | 成交明細內的買進價格 |
| 跌停價 | 當日的跌停價 |
| 開盤價 | K棒資料的開盤價 |
| 漲停價 | 當日的漲停價 |
| 賣出價 | 成交明細內的賣出價格 |

### 8.2 價格 (15項)

| 欄位名稱 | 說明 |
| :---- | :---- |
| 內外盤 | 成交明細的內外盤標記(1=外盤, \-1=內盤, 0=無法判斷) |
| 投資建議目標價 | 由FactSet提供的投資建議目標價格 |
| 基差 | 現貨價格與期貨價格之間的差異 |
| 強弱指標 | 商品漲跌幅與大盤漲跌幅的差異 |
| 收盤/開盤/最高/最低/買入/賣出/均/參考/漲停/跌停 | K棒基本價格欄位 |

### 8.3 量能 (63項)

*GDP佔比、上漲量、下跌量、內外盤量及成交次數、成交金額、成交量、估計量、委買賣均量、累計成交/委買/委賣筆數及張數、買進/賣出大單/中單/小單/特大單成交次數及金額及量、跌停/漲停委買賣筆數及數量、量比、開盤委買賣、新聞正負向分數及聲量分數、當日序、資金流向、盤中零股/整股成交量、盤後量、總成交次數等*

### 8.4 籌碼 (126項)

*CB剩餘張數、大戶/散戶持股人數及比例及張數、內部人持股及異動、分公司交易及買賣家數、主力成本/持股/買賣超張數及金額、外資/投信/自營商持股及買賣超及成本、法人持股及買賣超、券資比、官股券商買賣超、借券/融券/融資餘額及買賣張數、庫藏股預計及實際買回張數、控盤者成本線及買賣張數、現券償還/現股當沖/現金償還張數、散戶買賣超、實戶買賣超、董監持股及質設比例、綜合前十大券商買賣超、關聯/關鍵券商買賣超、地緣券商買賣超、吉尼係數、主動性交易比重/買力/賣力、收集派發指標、實質買賣盤比等*

### 8.5 基本面 (9項)

| 欄位名稱 | 說明 |
| :---- | :---- |
| 月營收 | 每個月的營業收入 |
| 本益比 | 股票的本益比 |
| 投資建議評級 | 市場機構的投資建議評等分數 |
| 股本(元) / 股本(億) | 股票的股本 |
| 財報股本(億) | 財報上的股本 |
| 殖利率 | 股票的殖利率 |
| 發行張數(張) | 當期的發行張數 |
| 總市值(元) | 股票或指數的市值 |

### 8.6 事件 (28項)

*法說會日期、股東會日期、庫藏股開始/結束日期、除息/除權日期及年度及值、除權息日期及年度及值、停止轉換起始/結束日、現增相關日期及價格、處置開始/結束日期、最後交易日、最後過戶日期、減資日期/比例/過戶日/新股上市日、新股上市日、融券最後回補日等*

### 8.7 市場統計 (17項)

| 欄位名稱 | 說明 |
| :---- | :---- |
| TW50相關指標 | KD多空家數、MTM多空家數、上昇趨勢家數、大戶買賣力、大單成交次數/買進金額、均線多空家數、紅K家數、創新低/高家數、價格上漲家數 |
| 大盤指標 | 上漲/下跌家數、內外盤家數、漲停/跌停家數、騰落指標 |

### 8.8 期權 (51項)

*Delta/Gamma/RHO/Theta/Vega、前十大/前五大交易人及法人買賣方未沖銷口數、三大法人/外資/自營商/投信多空方交易口數及金額及未平倉口數及金額、未平倉口數、預估除息點數、波動率指數、波動率、時間價值、理論價、買賣權未平倉量比率及成交量比率、買權/賣權未平倉量及成交量、隱含波動率、內含值等*

---

## 9\. XQ 選股欄位完整字典 (Stock Selection Fields)

選股欄位用於選股腳本中，搭配 `GetField` 使用。完整列表請參閱 [XSHelp 官方說明](https://xshelp.xq.com.tw/XSHelp/)。

### 9.1 常用 (19項)

| 欄位名稱 | 說明 |
| :---- | :---- |
| 月營收 | 台股上市櫃公司每月公告的營業收入數值 |
| 主力買賣超張數 | 主力買張 \- 主力賣張 |
| 本益比 | 股票的本益比 |
| 成交金額(億) | 成交的加總金額 |
| 成交量 | K棒資料的成交量 |
| 收盤價 | K棒資料的收盤價 |
| 均價 | 每日的平均成交價 |
| 每股稅後淨利(元) | 損益表上的每股盈餘項目 |
| 法人買賣超張數 | 三大法人合計買賣超張數 |
| 股東權益報酬率 | 財務比率表的ROE(A)-稅後 |
| 股價淨值比 | 收盤價/每股淨值 |
| 最低價 / 最高價 | K棒的最低/最高價 |
| 殖利率 | 股票的殖利率 |
| 開盤價 | K棒的開盤價 |
| 漲跌幅 | 當期股價的漲跌幅 |
| 營業毛利率 | 財務比率表的營業毛利率 |
| 總市值(億) | 股票/指數的市值 |
| 轉換價格 | 可轉債的轉換價格 |

### 9.2 價格 (27項)

*Jensen/SHARPE/Treynor指標、上下游/同業股價指標、月/週平均收益率、本益比、收盤價、均價、投資建議目標價、貝他值、波動率、股價淨值比、振幅、真實範圍及波幅、高低差、參考價、最高低價、跌停價、開盤價、漲停價、漲跌幅、標準差等*

### 9.3 量能 (57項)

*上漲量/下跌量、內外盤比/成交次數/均量/量、成交均量/金額/量、收盤量/開盤量、佔大盤/全市場成交量比、買進/賣出大單/中單/小單/特大單成交次數及金額及量、跌停/漲停委買賣筆數及數量、開盤委買賣、新聞正負向分數及聲量分數、鉅額交易量、零股量、盤中零股/整股成交量、盤後量、總成交次數/筆數等*

### 9.4 籌碼 (109項)

*CB剩餘張數、ETF規模、大戶/散戶持股、內部人持股及異動、分公司交易及買賣家數、主力平均買賣超成本/成本/持股/買賣超張數、外資/投信/自營商持股及買賣超及成本、法人持股及買賣超、券資比、官股/綜合前十大券商買賣超、借券/融券/融資餘額及使用率及買賣張數、庫藏股買回張數、控盤者買賣超、現券/現股當沖/現金償還張數、董監持股及質設比例、集保張數、週轉率、籌碼鎖定率、地緣/關聯/關鍵券商買賣超、吉尼係數、買賣家數/公司家數、實戶/實質買賣盤比、機構持股比重等*

### 9.5 基本面 (32項)

*公司成立/掛牌日期、公司風格/類型、公積配股、月營收及月增率/年增率、投資建議評級、股本、股利合計、股票/現金股利及比率及殖利率、盈餘配股、員工人數及配股率、財報股本、累計營收及年增率、殖利率、發行張數、填息/填權天數、新產能預計量產日期、董事長、總市值、總經理等*

### 9.6 財務報表 (155+項)

*完整財務報表項目：損益表、資產負債表、現金流量表、財務比率表，以及因子分析指標（QMJ安全/獲利、動能因子、流動性因子、帳面市值比等）*

### 9.7 事件 (35項)

*下一次董監改選年/日期、法說會日期、股利年度、股東會日期、庫藏股開始/結束日期、除息/除權/除權息日期及年度及值、停止轉換起始/結束日、現增相關日期及比率/金額/價格、處置開始/結束日期、最後交易日、最後過戶日期、減資日期及比例及過戶日/新股上市日、新股上市日、董監事就任日期、融券最後回補日等*

---

## 10\. 腳本撰寫實戰流程 (Script Writing Workflow)

### 10.1 六步驟流程

| 步驟 | 內容 | 範例 |
| :---- | :---- | :---- |
| 1\. 宣告參數 | `Input: length(10);` | 設定可調整的參數 |
| 2\. 宣告變數 | `Var: ma(0);` | 設定運算用變數 |
| 3\. 取得盤後資料 | `GetField("外資買賣超")` | 籌碼、財報等 |
| 4\. 取得即時數據 | `q_DailyOpen` | 盤中價量委買賣 |
| 5\. 建構運算關係 | `ma = Average(Close, length);` | 數學計算 |
| 6\. 設立觸發/繪圖 | `if ... then ret=1;` 或 `Plot1(...)` | 輸出結果 |

// 完整範例：法人買超 \+ 外盤量大 \+ 股價上漲

// 步驟一：宣告參數

Input: days(10);

Input: minBuy(1000);

// 步驟三：取得盤後資料

Value1 \= GetField("外資買賣超");

// 步驟四：取得即時數據

Value2 \= q\_OutSize;

Value3 \= q\_DailyVolume;

// 步驟五：建構運算關係

Value4 \= Average(Value1, days);      // 法人N日平均買超

Condition1 \= Value4 \> minBuy;         // 買超超過門檻

Condition2 \= Value2 / Value3 \> 0.5;   // 外盤量佔比超過五成

Condition3 \= Close \> Close\[1\];        // 今日上漲

// 步驟六：設立觸發

if Condition1 and Condition2 and Condition3 then ret \= 1;

### 10.2 編譯與勘誤

- 撰寫完成後，點擊「編譯」按鈕（或快捷鍵），系統會檢查語法錯誤。  
- 編譯成功：下方顯示「編譯開始 → 編譯成功 → 全部物件編譯結束」。  
- 編譯失敗：系統以中文提示錯誤位置（第幾行第幾個字）及可能原因。  
- 常見錯誤：缺少分號、保留字被用作變數名、括號不匹配、型態不符。

### 10.3 策略雷達設定

| 設定項目 | 說明 |
| :---- | :---- |
| 腳本選擇 | 選取已編譯的腳本 |
| 參數設定 | 調整 Input 的參數值 |
| 參照商品 | 指定要監控的商品清單 |
| 多空方向 | 做多或做空 |
| 頻率 | Tick / 1分鐘 / 5分鐘 / 10分鐘 / 1小時 / 日 / 週線 |
| 觸發設定 | 連續觸發、K棒內單次觸發、日內單次觸發、單次洗價模式 |
| 最大引用 | 設定歷史資料引用筆數（`SetBackBar` 可在腳本中設定） |
| 排程 | 設定自動執行的時間排程 |
| 串接自動交易 | 觸發後自動下單 |

### 10.4 選股設定

| 模式 | 說明 |
| :---- | :---- |
| 條件式 | 透過介面勾選預設條件組合 |
| 腳本式 | 使用 XScript 腳本自訂選股邏輯 |

- 選股支援跨頻率的計算方式（日線+週線+月線混合）。  
- 可使用 `SetOutputField` / `SetOutputName` 輸出自訂欄位到選股結果。  
- 選股也可設定排程，定時自動執行。

---

## 附錄 A：關鍵字速查表

### 流程控制

`If`, `Then`, `Else`, `For`, `To`, `DownTo`, `Begin`, `End`, `While`, `Switch`, `Case`, `Default`, `Break`, `Return`, `And`, `Or`, `Not`, `Xor`, `True`, `False`, `Once`, `Repeat`, `Until`

### 宣告

`Var` / `Variable` / `Variables` / `Vars`, `Input` / `Inputs`, `Array` / `Arrays`, `IntrabarPersist`, `Rank`

### 型態宣告

`Numeric`, `NumericSimple`, `NumericSeries`, `NumericRef`, `NumericArray`, `NumericArrayRef`, `String`, `StringSimple`, `StringSeries`, `StringRef`, `StringArray`, `StringArrayRef`, `TrueFalse`, `TrueFalseSimple`, `TrueFalseSeries`, `TrueFalseRef`, `TrueFalseArray`, `TrueFalseArrayRef`

### 忽略字

`A`, `An`, `At`, `Based`, `By`, `Does`, `From`, `Is`, `Of`, `On`, `Place`, `Than`, `The`, `Was`

### 常數

`PI`, `Sunday`(0), `Monday`(1), `Tuesday`(2), `Wednesday`(3), `Thursday`(4), `Friday`(5), `Saturday`(6)

## 附錄 B：GetQuote 即時欄位速查表

q\_DailyOpen

q\_DailyHigh

q\_DailyLow

q\_DailyVolume

q\_RefPrice

q\_AvgPrice

q\_Last

q\_Bid

q\_Ask

q\_BidAskFlag

q\_TickVolume

q\_PreTotalVolume

q\_PriceChangeRatio

q\_InSize

q\_OutSize

q\_BestBid1\~5

q\_BestAsk1\~5

q\_BestBidSize

q\_BestAskSize

q\_BestBidSize1\~5

q\_BestAskSize1\~5

q\_SumBidSize

q\_SumAskSize

q\_DailyUplimit

q\_DailyDownlimit

## 附錄 C：函數參數型態宣告速查表

| 型態 | 值/址 | 陣列 | 序列 |
| :---- | :---- | :---- | :---- |
| Numeric | 值 | ❌ | ❌ |
| NumericSimple | 值 | ❌ | ❌ (單一值) |
| NumericSeries | 值 | ❌ | ✅ (時間序列) |
| NumericRef | 址 | ❌ | ❌ |
| NumericArray | 值 | ✅ | ❌ |
| NumericArrayRef | 址 | ✅ | ❌ |
| String | 值 | ❌ | ❌ |
| StringSimple | 值 | ❌ | ❌ |
| StringSeries | 值 | ❌ | ✅ |
| StringRef | 址 | ❌ | ❌ |
| StringArray | 值 | ✅ | ❌ |
| StringArrayRef | 址 | ✅ | ❌ |
| TrueFalse | 值 | ❌ | ❌ |
| TrueFalseSimple | 值 | ❌ | ❌ |
| TrueFalseSeries | 值 | ❌ | ✅ |
| TrueFalseRef | 址 | ❌ | ❌ |
| TrueFalseArray | 值 | ✅ | ❌ |
| TrueFalseArrayRef | 址 | ✅ | ❌ |

---

📖 完整函數與欄位說明請參閱：[https://xshelp.xq.com.tw/XSHelp/](https://xshelp.xq.com.tw/XSHelp/)

📝 實戰範例程式碼請參閱：XScript\_實戰範例寶典.md（859 篇文章，1,241 段程式碼）  
