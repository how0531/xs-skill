# 內建函數 - 一般函數（GENERALFUNC）

> 來源：https://xshelp.xq.com.tw/XSHelp/lists?a=GENERALFUNC（官方 XSHelp，自動爬取）

## BarAdjusted（目前執行的K棒是否為還原頻率）

**語法**：回傳執行腳本資料頻率是否為還原頻率。回傳布林值。
若為還原頻率，則回傳「True」
若不為還原頻率，則回傳「False」

運用這個函數來判斷目前的執行頻率是否為還原頻率。

在執行頻率為「分鐘」的資料表達為：

- 如果資料頻率是還原5分鐘，則 BarInterval  = 5，BarFreq = "Min"，BarBarAdjusted = true。

- 如果資料頻率是5分鐘，則 BarInterval  = 5，BarFreq = "Min"，BarBarAdjusted = false。

在執行頻率為「日」以上頻率的資料表達為：

- 如果資料是還原日線, 則 BarFreq = "AD", BarAdjusted = true。

- 如果資料是日線, 則BarFreq = "D", BarAdjusted = false。

---

應用在指定策略執行的頻率，避免執行頻率設定錯誤的範例語法如下：

- **範例一**：確認執行頻率必須是「還原日」頻率才可執行

```xs
if BarFreq <> "D" or BarAdjusted <> True  then raiseRunTimeError("僅支援還原日頻率");
```

- **範例二**：確認執行頻率必須是「還原5分鐘」頻率才可執行

```xs
if BarInterval <> 5
or barFreq <> "Min"
or BarAdjusted <> true then raiseRunTimeError("僅支援還原5分鐘線圖");
```

## BarFreq（取得目前執行的K棒的頻率）

**語法**：傳回執行腳本資料頻率的單位。
執行頻率 = BarFreq
回傳以下字串: 分鐘線:"Min",
日線:"D",周線:"W", 月線:"M",
還原日線:"AD",還原周線:"AW", 還原月線:"AM",
季線:"Q", 半年線:"H",年線:"Y"

一般可以使用這個函數來判斷目前的執行頻率

```xs
//確認資料必須是日線
if BarFreq <> "D" then return;
```

## BarInterval（分鐘區間）

**語法**：傳回執行腳本資料的分鐘頻率間隔
分鐘區間 = BarInterval
如果頻率是分鐘資料，則回傳分鐘的間隔，例如30分鐘線的話則回傳30，否則一律回傳1

一般而言BarInterval函數會跟BarFreq一起搭配使用，用來判斷目前執行的分鐘頻率的分鐘間隔。

```xs
// 先判斷目前是分鐘線
If BarFreq = "Min" Then
Begin
	If BarInterval = 30 Then
	Begin
		// 資料為30分鐘線
	End;
End;
```

## CallFunction（呼叫函數）

**語法**：呼叫函數執行
回傳數值=CallFunction(函數名稱,參數一,參數二,...)
傳入一個以上參數:
- 第一個參數是函數名稱的字串。
- 第二個參數是被呼叫函數的第一個參數。
- 第三個參數是被呼叫函數的第二個參數。依此類推。

從 v6.20 開始，我們開放函數使用中文名稱，更方便大家使用。不過中文函數在被其他腳本呼叫時，會需要透過CallFunction這個函數來執行。

CallFunction的用法很簡單，第一個參數固定是要被呼叫的函數名稱，其餘的參數就是看被呼叫函數需要幾個參數，依序填入即可。

範例：

```xs
plot1(average(c,5));
plot2(callfunction("average",c,5));
//以上二個寫法效果是一樣的
```

## CurrentBar（目前K棒的編號）

**語法**：傳回K棒目前的編號。
K棒編號 = CurrentBar

傳回執行腳本時的K棒序列編號，由1開始，第一筆K棒編號為1，第二筆K棒編號為2，依序遞增。

可以使用這個函數來判斷目前腳本執行的時機點

```xs
if CurrentBar = 1 then
	value1 = Close
else
	value1 = value1[1] + value2 * (Close - value1[1]);
```

上述範例利用CurrentBar來判斷目前是否是第一筆K棒。如果是的話則回傳XAverage的初始數值。

## DataAlign（資料對位）

**語法**：設定資料對位方式
DataAlign(欲設定的資料對位方式)
如果是絕對對位的話，資料對位方式為0，如果是遞補對位的話，資料對位方式為1

在腳本執行時如果透過GetField函數讀取開高低收以外的資料欄位時，有可能會遇到需要讀取的欄位資料的資料時間與目前價位資料時間不一致的情形，此時系統會依照**資料對位**的設定方式來決定如何處理。

以下的圖示內我們使用日線頻率的**外資買賣超**資料來說明資料對位的處理邏輯。

由於每日外資買賣超資料都是在下午16:00以後才會公布，也就是在當日交易區段時價位資料的日期與外資買賣超資料的日期會有一天的差異。所以當以下的腳本在5/28日上午執行時

```xs
if Close > Close[1] and
   GetField("外資買賣超") > 0 then ...
```

系統會依照對位方式決定GetField("外資買賣超")函數會取得哪一天的外資買賣超資料。

目前系統支援兩種資料對位方式，分別是

- **絕對對位**

```xs
DataAlign(0);
```

- **遞補對位**

```xs
DataAlign(1);
```

在**絕對對位**模式時，GetField("外資買賣超")函數的日期必須與價位日期一致(**同期別**)，也就是說系統會嘗試讀取5/28日的外資買賣超資料，此時由於資料尚未公佈，所以執行會發生失敗(引用資料不存在)。

而在**遞補對位**模式時，系統在找不到5/28日的外資買賣超資料時，會**自動往前尋找**。在上面的範例內 GetField("外資買賣超")則會找到5/27日的外資買賣超資料。

目前系統預設的資料對位方式依照腳本類型而有所不同:

- 如果是指標腳本或是雷達腳本，資料對位方式預設為絕對對位 (DataAlign(0))

- 如果是選股腳本，資料對位方式預設為遞補對位 (DataAlign(1))

選股腳本由於常常需要讀取營收/財報等欄位資料，而這些資料通常公佈時間都是落後於價位日期的，所以預設為遞補對位。

使用者如果知道所需資料的日期的話，也可以透過不同的寫法來讀取到預期的資料，不需要更改對位模式。以上述範例而言，如果這是一個策略雷達腳本的話，由於策略雷達腳本的執行時間通常是在交易時間區段，此時外資買賣超資料一定會落後一期。所以腳本可以修改成下列寫法:

```xs
if Close > Close[1] and
   GetField("外資買賣超")[1] > 0 then ...
```

注意到腳本內使用**GetField("外資買賣超")[1]**語法來讀取前一期的外資買賣超。

## ExecOffset（取得K棒偏移筆數）

**語法**：回傳目前函數執行時偏移的K棒筆數
偏移筆數 = ExecOffset

使用在函數內，用來取得目前函數執行時偏移的K棒根數。

一般的函數呼叫方式如下:

```xs
Value1 = Average(Volume, 5);
```

此時如果從Average函數內去呼叫ExecOffset時得到的值是0。

如果呼叫的方式改成:

```xs
Value1 = Average(Volume, 5)[1];
```

的話，則在呼叫Average函數時利用**[1]**設定了偏移的K棒個數，此時Average function執行時取得的資料是當時資料往前偏移一筆的結果，也就是說Value1會是前5日成交量的平均值，不包含最新一日的成交量。

在這樣子的使用情境底下，Average函數內讀取**ExecOffset**時會得到1.

## File（指定Print輸出的檔案位置）

**語法**：與Print指令搭配，用來指定Print輸出檔案的位置
Print(File(檔案路徑), 輸出數值1, 輸出數值2, 輸出數值3)
Print(File(檔案名稱), 輸出數值1, 輸出數值2, 輸出數值3)

Print指令如果沒有傳入指定檔案欄位時，預設會將所有的Print輸出到XQ安裝目錄底下的XS/Print子目錄內，輸出檔案的名稱為**策略名稱_商品代碼.log**，例如 **MyStrategy_2330.TW.log**。

如果使用者希望指定不同的輸出目錄，或是不同的輸出檔案名稱的話，則可以使用File指令來做設定。

File指令有兩種用法:

第一種用法是傳入目錄名稱，例如File("d:\Print")，請注意路徑名稱的結尾必須是""。一旦指定目錄之後，所有的Print輸出檔案都會產生在這個目錄底下，輸出檔案名稱還是**策略名稱_商品代碼.log**，

第二種用法是傳入檔案名稱，例如File("d:\Print\MyOutput.log")。一旦指定檔案名稱之後，所有Print的輸出都會寫到這個檔案內，包含所有被執行到的商品。

以下是完整的範例:

```xs
Print(File("d:\Print\"), date,symbol,close);
Print(File("d:\Print\MyOutput.log"), date,symbol,close);
```

除了以上用法之外，File內的檔案名稱或是目錄名稱也可以包含以下的特殊字串:

- [StrategyName] ← 轉換成策略名稱，也就是代表雷達名稱、選股策略名稱、指標名稱、自動交易策略名稱

- [StartTime] ← 轉換成策略的啟動時間，格式為HHMMSS

- [Symbol] ← 轉換成執行的商品代碼

- [Freq] ← 轉換成執行的頻率

- [ScriptName] ← 轉換成腳本名稱

- [Date] ← 轉換成YYYYMMDD的日期

如果檔案名稱或是目錄名稱包含以上的特殊字串的話，則XS會把這些字串轉換成執行的商品，頻率，腳本名稱後組成輸出的目錄名稱或是檔案名稱。

舉例而言:

```xs
Print(File("d:\Print\[Date]_[ScriptName]_[Symbol]_[Freq].log"), date, symbol, close);
```

如果腳本名稱是"MyScript", 執行的頻率是日, 執行的商品為2330.TW的話，則Print指令所產生的檔案會是"d:\Print\MyScript_2330.TW_D.log"。請注意如果檔案名稱內有包含特殊字串的話，則每個商品的Print檔案會獨立產生，而不是寫到同一個檔案內。

---

如果需要避開重覆Print在同一個檔案，可以運用File指令搭配[StartTime]參數，讓每次執行的Print檔案可以分開不同目錄，檔案維護上比較方便。

以下的範例會把輸出資料分開到不同檔案：

```xs
Print(file("[StrategyName]_[Symbol]_[StartTime].log"), "Date=", NumToStr(Date, 0), "Close=", NumToStr(Close, 2));
```

請參考File指令，以及教學文章。

## GetBackBar（讀取資料引用筆數）

**語法**：回傳目前腳本計算所使用的資料引用筆數
回傳數值= GetBackBar

回傳目前腳本計算所使用的資料引用筆數，為一固定常數。

關於資料讀取範圍以及最大引用筆數的定義，請參考資料讀取範圍與腳本執行的關係。

## GetBarBack（讀取資料引用筆數）

**語法**：回傳目前腳本計算所使用的資料引用筆數
回傳數值= GetBarBack

回傳目前腳本計算所使用的資料引用筆數，為一固定常數。

關於資料讀取範圍以及最大引用筆數的定義，請參考資料讀取範圍與腳本執行的關係。

## GetBarOffset（取得相對K棒位置）

**語法**：依傳入的交易日的日期取得相對K棒位置。
回傳數值=GetBarOffset(日期)
回傳數值=GetBarOffset(日期，時間)
傳入二個參數：
- 第一個參數是交易日的日期，格式為YYYYMMDD。
- 第二個參數是時間，格式為HHMMSS，第二個參數可以不用傳。

依傳入的交易日的日期取得相對K棒位置。

可以傳入兩個參數：

- 第一個參數是日期，格式為YYYYMMDD。

- 第二個參數是時間，格式為HHMMSS，第二個參數可以不用傳。

當回傳值為0時，表示傳入日期/時間 ≧K棒日期/時間。
當回傳值為1時，代表目前K棒的前一根K棒日期/時間為傳入日期/時間。

範例：

```xs
value1 = GetBarOffset(20150831); //取得20150831這根K棒的相對位置
value2 = High[value1]; //取得20150831當天的最高價
plot1(value2); //繪出20150831最高價的水平線
```

注意，當無傳入日期這根K棒時，會往前找到最接近的一根。例如：20150829、20150830是非交易日，所以會往前找到20150828這根K棒。也就是說GetBarOffset(20150828)、GetBarOffset(20150829)、GetBarOffset(20150830)的回傳值會是相等的。

## GetFieldStartOffset（判斷欄位初始點）

**語法**：判斷欄位初始點
欄位筆數 = GetFieldStartOffset("欄位名稱")
欄位筆數 = GetFieldStartOffset("欄位名稱", "頻率")
回傳目前最新一筆欄位與此欄位的第一筆資料間的欄位筆數。
如果無此欄位，或是欄位的初始點超過目前bar的位置，則回-1。
※如果不傳頻率的話，則讀取目前執行頻率的對應欄位。
※僅支援「選股」腳本類型。

請注意，回傳欄位的筆數，是依照傳入的欄位頻率來計算，可能與目前腳本執行的K棒頻率不同。
例如目前可能是跑日線，然後GetFieldStartOffset要查的是月頻率欄位，此時 GetFieldStartOffset所回傳的是月頻率欄位有幾筆。

**選股腳本範例：判斷當月營收是否創掛牌新高**

```xs
value1 = GetFieldStartOffset("月營收", "M");
if value1 = 0 then begin
    ret = 1;  // 只有1期, 就當成創新高了吧
	outputField1(GetField("月營收", "M"),"月營收");
end else if value1 > 0 then begin
    // 算出前N期的最大值
    value2 = Highest(GetField("月營收", "M")[1], value1);
    if GetField("月營收", "M") > value2 then ret = 1;
	outputField1(GetField("月營收", "M"),"月營收");
end;
```

**範例選股範例：判斷創N期新高**

```xs
input: min_period(12, "最低期別");
value1 = GetFieldStartOffset("月營收", "M");
value2 = GetField("月營收", "M");// 最新一期營收
var: idx(0);
idx = 1;
while idx <= value1 begin
    if GetField("月營收", "M")[idx] < value2 then
        idx = idx + 1
    else
        break;
end;
if idx >= min_period then begin
    ret=1;
	OutputField(1, idx, 0, "創新高期別");
	OutputField(2, GetField("月營收", "M")[idx], "創新高的月營收");
	OutputField(3, GetFielddate("月營收", "M")[idx], 0, "創新高的月營收資料日期");
end;
```

## GetFirstBarDate（讀取第一筆資料的日期）

**語法**：回傳目前腳本計算所使用第一筆資料的日期
回傳日期= GetFirstBarDate

回傳目前腳本計算所使用第一筆資料的日期，為一固定常數。

日期格式是一個8碼的數字，如果第一筆資料日期是是2009年1月2日，則回傳20090102

關於資料讀取範圍的定義，請參考資料讀取範圍與腳本執行的關係。

## GetInfo（取得執行資訊）

**語法**：用來取得目前腳本的執行環境資訊。
回傳數值=GetInfo(資訊名稱)
傳入一個參數:
- 第一個參數是資訊名稱字串，可以是"Instance"、"IsRealTime"、"IsTimerMode"、"FilterMode"、"TradeMode"、"AT_EnableTrade"、"AT_BID"、"AT_AccType"或"AT_AID"

依傳入的參數回傳相關資訊。

當參數為"Instance"時，可以取得腳本執行的功能：

- 回傳值為1表示自訂指標。

- 回傳值為2表示策略雷達。

- 回傳值為3表示XS選股。

- 回傳值為31表示XS選股自訂排行。

- 回傳值為4表示策略雷達回測（進場）。

- 回傳值為41表示策略雷達回測（出場）。

- 回傳值為5表示自動交易

- 回傳值為6表示自動交易回測

當參數為"IsRealTime"時，可以取得K棒的狀態：

- 回傳值為0表示該筆資料為歷史資料或其他。

- 回傳值為1表示該筆資料為即時成交更新資料，需注意當該筆運算是因為自動洗價觸發時，就算資料不是即時成交更新也會回傳1。

當參數為"IsTimerMode"時，可以判斷該次洗價是否因為自動洗價所觸發，只支援警示腳本和交易腳本：

- 回傳值為1表示該次洗價是因為自動洗價所導致。

- 回傳值為0表示為成交洗價觸發，或是使用在其他腳本上。

當參數為"FilterMode"時，可以取得XS選股的模式：

- 回傳值為1表示XS選股。

- 回傳值為2表示XS選股回溯。

- 回傳值為3表示XS選股回測（進場）。

當參數為"TradeMode"時，可以交易策略目前執行的K棒是否處於資料讀取區間：

- 回傳值為0表示目前執行的K棒處理資料讀取區間，所以交易指令不會執行。

- 回傳值為1表示目前執行的K棒處理策略部位計算區間或是即時區間，交易指令將會執行。

當參數為"AT_EnableTrade"時，可以取得目前交易策略是否有啟動帳號：

- 回傳值為0表示回測或即時區間但沒有設定交易帳號。

- 回傳值為1表示即時區間且有設定交易帳號。

當參數為"AT_BID"時，可以取得券商的字串代碼：

- 回傳值為空白字串表示策略沒有設定交易帳號或是在回測。

- 回傳值為SYSTRADE表示策略帳號為模擬交易帳號。

- 回傳值為SYSCAMPUS表示策略帳號為校園模擬競賽。

- 其他券商會回傳各自對應的代碼。

當參數為"AT_AccType"時，可以取得策略運作的業務類別:

- 回傳值為1表示業務類別為證券。

- 回傳值為2表示業務類別為期貨。

- 回傳值為3表示業務類別為複委託。

- 回傳值為0表示策略沒有設定交易帳號或是在回測。

當參數為"AT_AID"時，可以取得目前策略運作的帳號:

- 回傳值為空白字串表示策略沒有設定交易帳號或是在回測。

- 回傳值為券商代碼加上交易帳號組成的字串。

關於AT的EnableTrade、BID、AccType以及AID的進一步說明，可以參考自動交易語法 取得「交易帳號」使用說明

範例：

```xs
value1 = getinfo("IsRealTime"); //若value1為1，則代表目前計算的是即時資料
plot1(value1);
```

## GetSymbolFieldStartOffset（判斷欄位初始點）

**語法**：判斷欄位初始點
欄位筆數 = GetSymbolFieldStartOffset("ID", "欄位名稱")
欄位筆數 = GetSymbolFieldStartOffset("ID", "欄位名稱","頻率")
回傳目前最新一筆欄位與此欄位的第一筆資料間的欄位筆數。
如果無此欄位，或是欄位的初始點超過目前bar的位置，則回-1。
※如果不傳頻率的話，則讀取目前執行頻率的對應欄位。
※僅支援「選股」腳本類型。

GetSymbolFieldStartOffset是GetFieldStartOffset語法的延伸，在取得欄位相關資料時可以指定商品，透過這個函數可以在腳本中取得其他商品的欄位筆數。

以下是一個簡單的範例：

```xs
Value1 = GetSymbolFieldStartOffset("1101.TW", "月營收");　// value1 為取得目前腳本執行頻率的台泥(1101)目前最新一筆月營收欄位與月營收欄位第一筆資料間的欄位筆數。
Value2 = GetSymbolFieldStartOffset("1101.TW", "月營收", "M");　// value2 為取得月頻率的台泥(1101)目前最新一筆月營收欄位與月營收欄位第一筆資料間的欄位筆數。
```

詳細的語法說明可以參考 GetFieldStartOffset函數。

## GetSymbolGroup（抓取目前執行商品的相關商品清單）

**語法**：用來取得 執行商品/指定商品 支援的相關商品清單。
Group: myGroup();
myGroup = GetSymbolGroup("權證");
myGroup = GetSymbolGroup("TSE23.TW", "成分股");

GetSymbolGroup 可用來取得系統內建的商品清單 。

第一個參數指定要取得清單的商品，例如範例中的 TSE23.TW 。 若未指定商品，則預設取得目前執行商品的清單 （ 前提是該清單存在 ） 。

第二個參數指定所需的清單類型，例如範例中的 成分股 ，此參數為必填 。

可參考商品清單功能。

## GetTBMode（取得自定指標繪圖模式）

**語法**：取得自定指標的繪圖模式
回傳數值= GetTBMode

取得自定指標的繪圖模式。
回傳數值如下

- SetTBMode(1) 同v5.62行為，腳本資料計算筆數為資料讀取筆數加畫面上的K棒筆數，使用者拉動畫面會進行重算。

- SetTBMode(0) 預設值，腳本資料計算筆數為全部資料，整個數列只算一次，拉動畫面不會重算。

範例:

```xs
Input: Period(200, "EMA");
Input: TB(1);
SetTBMode(TB);//指定自定指標的繪圖模式，可以變更參數比較一下計算值的差異
Plot1(EMA(Close, Period), "EMA");
Plot2(GetTBMode);//取得自定指標的繪圖模式
```

## GetTotalBar（讀取總額資料）

**語法**：回傳目前腳本計算所使用的資料筆數
回傳數值= GetTotalBar

回傳目前腳本計算所使用的資料筆數，為一固定常數。

關於執行筆數以及最大引用筆數的說明，請參考資料讀取範圍與腳本執行的關係。

## GroupSize（取得Group的大小）

**語法**：回傳指定Group中包含的商品數量。
Input: myGroup(Group);
Value1 = GroupSize(myGroup);

GroupSize函數會回傳商品清單包含的數量，可以此數值避免取用到超出陣列範圍的資料而導致錯誤。

## IsFirstCall（特定執行時機點）

**語法**：回傳目前計算的K棒（currentbar）是否為事件的第一次洗價
傳入事件字串：" "、"Bar"、"Date"、"Realtime"、"RealBar"
回傳布林值=IsFirstCall

isfirstcall("")：此次執行的第一次洗價

isfirstcall("Bar")：此根 Bar 的第一次洗價

isfirstcall("Date")：此交易日的第一次洗價

isfirstcall("Realtime")：此交易日進入即時洗價區間的第一次洗價

isfirstcall("RealBar")：此交易日進入即時洗價區間，首次產生成交事件後的第一次洗價(通常會與"Realtime"一致；若是在揭示未成交K棒時，遇到暫緩開盤或開盤後沒有成交事件，兩者就會產生差異)

詳細說明與範例請參考：

https://www.xq.com.tw/learn/xspractice/isfirstcall/

## IsLastBar（判斷是否為最新的K棒）

**語法**：回傳目前計算的K棒（currentbar）是否為最新的K棒
回傳布林值=IsLastBar

當目前計算的K棒為最新的K棒時，回傳True；其他狀況則回傳False。

## IsSessionFirstBar（判斷是否為當日第一根K棒）

**語法**：回傳目前計算的K棒（currentbar）是否為當日第一根K棒
回傳布林值=IsSessionFirstBar

當目前計算的K棒為當日第一根K棒時，回傳True；其他狀況則回傳False。

## IsSessionLastBar（判斷是否為當日最後一根K棒）

**語法**：回傳目前計算的K棒（currentbar）是否為當日最後一根K棒
回傳布林值=IsSessionLastBar

當目前計算的K棒為當日最後一根K棒時，回傳True；其他狀況則回傳False。

## MaxBarsBack（回傳腳本所設定的最大引用筆數）

**語法**：取得腳本執行時所設定的最大引用筆數
Value1 = MaxBarsBack

回傳目前腳本計算所使用的資料引用筆數，為一固定常數。

關於資料讀取範圍以及最大引用筆數的定義，請參考資料讀取範圍與腳本執行的關係。

## NoPlot（清除某個指標序列的數值）

**語法**：清除指定的指標序列目前這根K棒上面的數值
NoPlot(指標繪圖序列編號)
指標繪圖序列編號從1到999

在指標腳本內我們會使用Plot函數來產生不同的數值序列，每一個數值序列有一個編號，從1到999。

如果在某些情形底下我們希望某個序列這一點的值不要畫的話，則可以使用NoPlot的語法來做清除的動作。

以下我們先看一個範例:

```xs
Value1 = Close - Close[1];
Plot1(Value1);
```

在上面這個腳本內，我們先計算先後兩筆K棒的差值，然後把差值畫在Plot1上面。

如果我們希望只有上漲時才畫的話，那則可以改成這樣子的寫法:

```xs
Value1 = Close - Close[1];
Plot1(Value1);
If Value1 <= 0 Then NoPlot(1);
```

上述範例內使用NoPlot函數，指定序列1在Value1 <= 0 的時候不要畫圖。

## OutputField（設定選股輸出欄位）

**語法**：指定選股的輸出欄位
OutputField(輸出序號, 數值)
OutputField(輸出序號, 數值, 小數位數)
OutputField(輸出序號, 數值, 小數位數, 輸出欄位名稱)
OutputField1(數值)
OutputField1(數值, 小數位數)
OutputField1(數值, 小數位數, 輸出欄位名稱)

選股腳本預設只會顯示被選到的商品的商品名稱，成交，漲幅，成交量這幾個欄位。如果有需要在選股結果內輸出更多的欄位的話，則可以透過OutputField函數來新增欄位。

OutputField的語法可以傳入至多四個參數:

- 第一個參數為輸出序號，從1到99，用來指定輸出欄位的順序

- 第二個參數為要輸出的數值

- 第三個參數指定輸出時數值的小數點位數，可以不傳

- 從5.60版之後增加第四個參數，可以傳入輸出欄位的標題。如果不傳的話則預設的欄位標題為"欄位" + 序號。

以下是簡單的範例:

```xs
OutputField(1, GetField("月營收年增率","M"));
OutputField(2, GetField("月營收月增率","M"), 1);
OutputField(3, GetField("月營收月增率","M"), 1, "月營收月增率");
```

以上的範例在執行後會多產生三個欄位，第一個欄位為"欄位1"，內容為月營收年增率。第二個欄位為"欄位2"，內容為月營收年增率轉成一位小數點。第三個欄位為"月營收年增率"，內容與第二個欄位相同。

OutputField指令也可以在函數名稱之後直接加上序號，例如OutputField1, OutputField2等。如果函數名稱內就包含序號的話，則就不需要傳入序號參數。

上述的範例可以改寫為:

```xs
OutputField1(GetField("月營收年增率","M"));
OutputField2(GetField("月營收月增率","M"), 1);
OutputField3(GetField("月營收月增率","M"), 1, "月營收月增率");
```

OutputField指令內所設定的欄位標題也可以透過SetOutputName函數來指定。

OutputField 也可以使用 order 來指定選股結果區的欄位數值上/下排序，請參考連結說明使用。

## Playsound（播放音效）

**語法**：播放指定的音訊檔案

在執行該行腳本時，播放設定的音訊檔案

若同一次腳本運算中執行了複數個 PlaySound 函數，只會撥放最後執行的音訊檔案。

在指定檔案時，若沒有指定絕對路徑的話，會從預設資料夾 C:\SysJust\XQ2005\User\Sound 搜尋符合的檔案。

範例:

```xs
PlaySound("GML.wav");
PlaySound("C:\SysJust\XQ2005\User\Sound\GML.wav");
```

## Plot（產生圖形上的繪圖序列）

**語法**：產生指標腳本的繪圖序列語法：
Plot(輸出序號，指標數值)
Plot(輸出序號，指標數值，繪圖序列名稱)
Plot(輸出序號，指標數值，繪圖序列名稱，checkbox:=1)
Plot1(指標數值)
Plot1(指標數值，繪圖序列名稱)
Plot1(指標數值，繪圖序列名稱，checkbox:=1)

在指標腳本內必須使用Plot函數來產生繪圖數列。

每個指標腳本可以產生至多999個繪圖數列，實際使用時必須在Plot之後加上指定的繪圖序列編號，例如**Plot1**, **Plot2**, 到**Plot999**。

Plot函數可以傳入三個參數

- 第一個參數是指標的數值

- 第二個參數是這個繪圖序列的名稱，可以不用傳。如果不傳的話，則繪圖序列的名稱為 "Plot"加上這個序列的編號

- 第三個參數為「是否開啟下拉式選單」提供給使用者勾選顯示指標。可以不用傳，如果不傳的話，則不會有下拉式選單提供選擇。checkbox:=1 為預設顯示指標；checkbox:=0 為預設「不」顯示指標。

**範例#1**

```xs
Plot1(Average(Close, 5));
Plot2(Close, "收盤價");
```

在範例#1 內輸出兩個繪圖數列，第一個數列為收盤價的五日平均值，圖形名稱為 "Plot1"，第二個數列為收盤價(Close)，圖形名稱為 "收盤價"。

Plot1到Plot99除了可以是一個函數之外，也可以在腳本內被當成數列來引用。

**範例#2**

```xs
Plot1(Average(Close, 5));
Plot2(Close, "收盤價");
Value1 = Plot2 - Plot1;
Plot3(Value1, "差值");
```

在範例#2 內Value1的數值是繪圖數列2(Plot2)與繪圖數列1(Plot1)的相減值，然後把這個差值畫在Plot3上面。

**範例#3**

```xs
//checkbox:=1，為預設顯示指標。
//checkbox:=0，為預設「不」顯示指標。
plot1(open,"開盤價",checkbox:=0);
plot2(high,"最高價",checkbox:=0);
plot3(low,"最低價",checkbox:=0);
plot4(close,"收盤價",checkbox:=1);//預設繪製出「收盤價」指標
```

在範例#3 中，有使用到 checkbox 參數，故將此XS指標腳本加入指標後的技術分析副圖，在滑鼠點選下拉式選單圖示如下：

## PlotFill（產生圖形上的繪圖序列）

**語法**：PlotFill(序列編號, vFrom, vTo);
PlotFill(序列編號, vFrom, vTo, "序列名稱");

第一個參數是設定序列編號，會是 1~999 的數值，與目前 Plot 的序列編號相同。

第二個和第三個參數分別是當根 K 棒要填色的開始和結束點。 第四個參數是設定序列的名稱，為選填的參數。若沒有設定的話預設會是 " Plot "+序列編號。

此函數能夠在線圖上指定區域填色的功能，例如 KD 指標的超買超賣區間，讓使用者能夠更簡單的辨識指標間的範圍。

詳細說明可參考：如何運用函數繪製填色區塊 文章。

## PlotK（產生圖形上的繪圖序列）

**語法**：在腳本運算的橫軸位置上畫出K棒。
PlotK(序列編號, vOpen, vHigh, vLow, vClose)
PlotK(序列編號, vOpen, vHigh, vLow, vClose, "序列名稱")

序列編號是1~999的數值，與目前XS Plot的序列編號相同。
序列名稱是非必需的參數，如果不傳的話，預設的序列名稱為"Plot"+序列編號，例如”Plot2”。
vOpen, vHigh, vLow, vClose 對應的是K棒的開高低收。

平均K線 (Heikin-Ashi) 範例：

```xs
var: ha_open(0), ha_high(0), ha_low(0), ha_close(0);

if currentbar = 1 then
  ha_open = (open + close) / 2
else
  ha_open = (open[1] + close[1]) / 2;

ha_close = (open + high + low + close) / 4;
ha_high = maxlist(high, ha_open, ha_close);
ha_low = minlist(low, ha_open, ha_close);

PlotK(1, ha_open, ha_high, ha_low, ha_close, "平均K線");
```

## PlotLine（指標趨勢線）

**語法**：繪製直線。
PlotLine(序列編號, x1, y1, x2, y2)
PlotLine(序列編號, x1, y1, x2, y2, "序列名稱")

大家好，今天來跟大家介紹一個XS指標的新功能：PlotLine，用來繪製直線。

請參考：PlotLine語法的介紹 文章

## Print（輸出執行結果）

**語法**：將文字/數值輸出到XSScript編輯器的執行畫面跟檔案內
Print(數值1, 數值2, 數值3, ...)
Print(指定檔案,數值1, 數值2, 數值3, ...) ← 交易腳本必須用此法才能列印到檔案。
※執行選股與執行回測時，Print檔案加總超過 100M 就不會印出。

Print函數可以傳入多個參數，使用逗號分隔，參數可以是文字或是數值。每個Print函數會產生一行的輸出，內容為傳入的參數的文字或是數值，每個參數之間有一個空白。

範例:

```xs
Print("Date=", NumToStr(Date, 0), "Close=", NumToStr(Close, 2));
```

把上述指標腳本放入技術分析內，執行時可以在XSScript編輯器的執行畫面內看到輸出，每一筆bar寫出一筆紀錄

Print函數的執行結果除了在XSScript編輯器內可以看到之外，另外也會產生一個文字檔案。

檔案的輸出位置是在**XQ安裝目錄**底下的**XS\Print**子目錄內，檔案名稱預設為策略名稱加上商品名稱，檔名為**.log**。以上述為例輸出的檔案名稱為 C:\SysJust\XQ2005\XS\Print\Print範例_2330.TW.log

策略名稱也就是代表雷達名稱、選股策略名稱、指標名稱或自動交易策略名稱。

使用者也可以利用File指令來指定輸出的目錄或是檔名，交易腳本必須用此法才能列印到檔案。

以下的範例會把輸出檔案寫在"d:\print"這個目錄內：

```xs
Print(file("d:\print\"), "Date=", NumToStr(Date, 0), "Close=", NumToStr(Close, 2));
```

---

如果需要避開重覆Print在同一個檔案，可以運用File指令搭配[StartTime]參數，讓每次執行的Print檔案可以分開不同目錄，檔案維護上比較方便。

以下的範例會把輸出資料分開到不同檔案：

```xs
Print(file("[StrategyName]_[Symbol]_[StartTime].log"), "Date=", NumToStr(Date, 0), "Close=", NumToStr(Close, 2));
```

請參考File指令，以及教學文章。

## RaiseRunTimeError（產生錯誤中斷）

**語法**：用來中斷執行中的程式
RaiseRunTimeError(錯誤訊息)

當腳本遇到任何重大錯誤時，可以使用RaiseRunTimeError函數來終止腳本的執行。

舉例而言:

```xs
if q_CurrentShareCapital < 100000000{100,000,000股*10 = 10億} then RaiseRunTimeError("市值小於10億踢除");
```

上述是一個警示腳本，透過 q_CurrentShareCapital 欄位來判斷商品的股本是否小於10億，如果小於10億是的話則中斷執行。

與下列程式比較:

```xs
if q_CurrentShareCapital < 100000000{100,000,000股*10 = 10億} then return;
```

請注意如果是使用return指令的話，則執行的這一筆bar雖然會被跳出，可是當還有新的K棒時，程式還是會繼續執行，如果判斷是否要跳出的邏輯比較複雜的話，可能會有一些效率上的影響。如果已經確定腳本不需要再執行的話，可以使用RaiseRuntimeError，比較有效率，而且執行的畫面上也可以看到錯誤訊息，方便使用者掌握腳本的狀態。

## SetAlign（設定資料對位方式）

**語法**：根據欄位屬性，指定腳本執行時的資料對位計算方式
SetAlign("籌碼",資料對位計算方式)
SetAlign("營收財報",資料對位計算方式)

SetAlign可以根據欄位屬性，指定腳本執行時的資料對位計算方式。

說明資料的對位定義
無論是資料欄位或選股欄位，皆會在欄位可用頻率的K棒生成後，將對應時間的歷史資料標記在此根K棒上，舉例來說：

資料欄位 "外盤量" 的可用頻率為分鐘、日、還原日，因此當GetField("外盤量",”10”)[n]時，可以想像在距離最新10分K之前的第n根10分K上，有一筆"外盤量"的資料標記在上面。

至於最新K棒尚未結束之前，GetField("外盤量",”10”)[0]都會不斷被更新至最新10分K的標記當中。

在對資料與K棒之間的標記關係，有了理解之後，就要來說明資料的對位方式，有以下兩種：

**1. 絕對對位：根據資料名義上的所屬期別來標記對位。**

例如 "大戶持股張數" 最快每周更新一次，那資料就會標記在當周的第一根K棒； "每股現金流量" 最快每季更新一次，那資料就會標記在當季的第一根K棒（標記更新後的持續區間，都會取得期初標記的資料，直到標記再次被更新為止）。

**2. 公布日對位：根據資料何時能被XS取得來標記對位**（不一定等於資料被公司公布的時間，因為第一手資料公布後，上游的資料源會接收、整理後再轉給XQ，接著再轉成XS可以取得的格式）。

例如 "每股現金流量" 第一季的資料在4/16首次可以被XS取得、第二季的資料在7/13首次可以被XS取得。那4/16會標記第一季的資料；7/13的K棒才會標記第二季的資料（4/16~7/12之間的K棒，會取得的是第一季的資料）。

SetAlign的使用

- **指標**、**警示**、**自動交易腳本**的範例如下：

```xs
```
SetAlign("籌碼", 0);   //指標腳本的預設值是「絕對對位」
SetAlign("營收財報", 0); //指標腳本的預設值是「絕對對位」

SetAlign("籌碼", 1);   //警示、自動交易腳本的預設值是「公布日對位」
SetAlign("營收財報", 1); //警示、自動交易腳本的預設值是「公布日對位」
```
```

- **選股腳本**則不在SetAlign的支援範圍：
選股欄位中，除了籌碼欄位是絕對對位以外，其他欄位都是公佈日對位。

## SetBackBar（設定最大引用筆數）

**語法**：腳本執行時，設置指定頻率的最大引用筆數
SetBackBar(最大引用筆數)
SetBackBar(最大引用筆數, "頻率")
如果不傳頻率的話，則指定目前執行頻率的最大引用筆數。

腳本執行時，設置指定頻率的最大引用資料範圍。

詳細介紹可以參考設置指定頻率引用筆數的應用。

關於資料讀取範圍以及最大引用筆數的定義，請參考資料讀取範圍與腳本執行的關係。

## SetBarBack（設定最大引用筆數）

**語法**：腳本執行時，設置指定頻率的最大引用筆數
SetBarBack(最大引用筆數)
SetBarBack(最大引用筆數, "頻率")
如果不傳頻率的話，則指定目前執行頻率的最大引用筆數。

腳本執行時，設置指定頻率的最大引用資料範圍。

詳細介紹可以參考設置指定頻率引用筆數的應用。

關於資料讀取範圍以及最大引用筆數的定義，請參考資料讀取範圍與腳本執行的關係。

## SetBarFreq（指定腳本支援的頻率）

**語法**：指定這個腳本可以支援的頻率(只可使用在選股腳本內)
SetBarFreq(支援頻率1, 支援頻率2, 支援頻率3, ...)
可以傳入多個頻率字串

SetBarFreq可以傳入多個頻率字串，使用逗號分隔，用來指定選股腳本可以使用的頻率。

頻率參數的格式如下

- 日線: "D"，

- 還原日線: "AD"，

- 周線: "W"，

- 還原周線: "AW"，

- 月線: "M"，

- 還原月線: "AM"，

- 季線: "Q"，

- 半年線: "H"，

- 年線: "Y"

範例:

```xs
SetBarFreq("Q", "Y"); // 指定選股腳本只能執行在季線/年線的頻率上面
```

由於選股腳本內可能會同時運用到多種不同欄位的頻率，而不同頻率的欄位又有可能因為資料公佈的時間差而產生期別上的差異。為了幫助使用者選到合適的執行頻率，XS選股程式在執行時會先分析這個腳本內所使用到的所有欄位的頻率，然後列出可以挑選的頻率。如果使用者希望可以更精確的指定頻率的話，則可以使用SetBarFreq這個函數。

## SetBarMode（設定函數計算方式）

**語法**：指定腳本執行時的函數計算方式
SetBarMode(函數計算方式)

SetBarMode可以指定函數的計算方式，分別為(0),(1),(2)

對於Setbarmode 0,1,2 三種計算方式解釋:

```xs
SetBarMode(0); //Auto，預設值
```

由系統判定是simple函數 或是 series 函數

```xs
SetBarMode(1);  //指定為simple函數
```

Simple型態是指，例如average 這類函數計算方式，今期所計算的平均數與前一期的平均數為個別獨立運用，不會相互有關係
例如:平均數average
(1,2,3,4,5)/5 = 3 ；(2,3,4,5,6)/5 = 4
兩者計算的結果無關聯

```xs
SetBarMode(2);  //指定為series函數
```

Series 型態是指，例如MACD,RSI 指標，屬於連續性的數值，今期所計算的值會引用到前期的數值來做運算。

例如RSI指標計算「期間內絕對漲幅」的公式為
UP t = UP t-1 + 1 / N ( Ut – UP t-1) ，
(N 為平滑平均天數， t 為當日值， t-1為前一日值)
當期值t會使用到前期的(t-1) 進行運算

## SetFirstBarDate（設定資料開始日期）

**語法**：指定腳本執行時第一筆資料的日期(不支援交易腳本)
SetFirstBarDate(資料開始日期)

關於資料讀取範圍的定義，請參考資料讀取範圍與腳本執行的關係。

SetFirstBarDate 函數用於控制腳本執行時，所使用的第一個資料的日期，從而確定資料讀取的起始範圍。

語法為 SetFirstBarDate(YYYYMMDD)，其中 YYYYMMDD 是起始日期的年、月、日，且必須為合理有效的日期。

需要注意的是，SetFirstBarDate **不支援交易腳本**。

**如果在腳本中多次使用 SetFirstBarDate 函數，並設定了不同的日期：**

- 將會採用其中最早（最小值）的日期作為最終的資料開始日期。

     若設定的日期不是合理有效的日期，該行的 SetFirstBarDate 將被視為編譯失敗。

**如果在腳本中同時存在數個 SetTotalBar 和 SetFirstBarDate，並設定了不同的數值時：**

- 系統將分別根據兩者被多次使用時的規則，決定接下來各自採用哪一個 SetTotalBar 與 SetFirstBarDate 做比較。

- 接著採用兩者當中，最後一個成功完成編譯的函數設定。

     若其中一個函數因參數無效（例如 SetTotalBar 的資料讀取筆數為負數，或 SetFirstBarDate 的日期不合理）而編譯失敗，則只有另一個成功編譯的函數設定會被採用。

## SetInputName（設定輸入參數的名稱）

**語法**：設定輸入參數(Input)的顯示名稱
SetInputName(序號, 顯示名稱)
SetInputName1(顯示名稱)

在XS語法內可以使用Input語法來設定腳本輸入的參數。

```xs
Input: Length(10);

Plot1(Average(Close, Length));
```

例如上面範例內定義了一個輸入參數，名稱為Length，初始值為10。在腳本內可以直接使用**Length**這個變數，而在腳本執行時則可以利用參數設定畫面來動態修改**Length**的數值，以便讓程式的設計更有彈性。

如果希望在設定畫面上可以看到中文名稱，而不是英文的變數名稱的話，則可以使用SetInputName這個函數。

```xs
Input: Length(10);

SetInputName(1, "天期");
Plot1(Average(Close, Length));
```

SetInputName必須傳入兩個參數

- 第一個參數是參數的序號，從1開始，

- 第二個參數是參數的顯示名稱

以下是指標設定的畫面，標示處內可以看到透過SetInputName所指定的參數的名稱

SetInputField指令也可以在函數名稱之後直接加上序號，例如SetInputName1, SetInputName2等。如果函數名稱內就包含序號的話，則就不需要傳入序號參數。

上面的範例可以改寫成:

```xs
Input: Length(10);

SetInputName1("天期");
Plot1(Average(Close, Length));
```

在XQ 5.60版之後，為了讓這個動作更簡單，使用者可以直接在Input語法內指定輸入參數的顯示名稱，上面的範例可以改寫成:

```xs
Input: Length(10, "天期");

Plot1(Average(Close, Length));
```

新的Input的語法可以讓程式變的更短，而且由於顯示名稱跟Input可以寫在同一行內，使用者不需要再去記憶每個Input的序號，建議大家以後直接使用Input語法來指定輸入參數的顯示名稱。

## SetOutputName（設定選股輸出欄位標題）

**語法**：指定選股的輸出欄位標題
SetOutputName(序號, 欄位標題)
SetOutputName1(欄位標題)

在XS語法內可以使用OutputField指令來產生選股時的輸出欄位。

預設的輸出欄位的標題為 "欄位"加上"序號"，例如"欄位1", "欄位2"等。為了讓輸出報表更清楚，可以使用SetOutputName指令來設定輸出欄位的名稱。

SetOutputName必須傳入兩個參數:

- 第一個參數是欄位的序號，從1到99，

- 第二個參數是欄位的名稱

例如:

```xs
OutputField1(GetField("月營收年增率","M"));
SetOutputName(1, "月營收年增率");
```

在上面範例內指定第一個輸出欄位的標題為"月營收年增率"。

SetOutputField指令也可以在函數名稱之後直接加上序號，例如SetOutputName1, SetOutputName2等。如果函數名稱內就包含序號的話，則就不需要傳入序號參數。

上面的範例可以改寫成:

```xs
OutputField1(GetField("月營收年增率","M"));
SetOutputName1("月營收年增率");
```

在XQ 5.60版之後，OutputField指令也增加了可以直接傳入欄位標題的功能。

## SetPlotLabel（設定繪圖標記名稱）

**語法**：設定繪圖序列的名稱
SetPlotLabel(繪圖序列編號，繪圖序列名稱)

SetPlotLabel傳入兩個參數

- 第一個參數是繪圖序列的編號，可以從1到99，

- 第二個參數則是這個序列的名稱，為一個字串值

這個函數可以用來指定這個繪圖序列的名稱，跟Plot函數的第二個參數是類似的。

兩者最大的差異是，在Plot函數內的第二個參數目前只支援固定的字串，而SetPlotLabel的第二個參數則可以是一個字串相關的敘述式，使用上比較有彈性。

舉例而言:

```xs
Input: Period(10);

Plot1(Average(Close, Period));
SetPlotLabel(1, Text("天期(", NumToStr(Period, 0), ")"));
```

在上述範例內我們希望指標圖形上面可以看到平均線的天期，例如如果天期是5的話，我們希望指標序列的名稱是"天期(5)"，而如果天期是10的話，則我們希望指標序列的名稱是"天期(10)"。

由於天期是透過Input語法傳入的，數值可以動態被修改，沒有辦法寫成一個固定的字串，所以我們使用SetPlotLabel，搭配Text函數以及NumToStr函數來組出天期的字串。

## SetRemoveOutlier（排除離群值）

**語法**：排除Rank語法中的離群值商品，被排除的商品不會進入排行。
SetRemoveOutlier("zscore", value:=3)
傳入兩個參數：
- 第一個參數為排除離群值的方式，有 "zscore" 和 "IQR"。
- 第二個參數為排除離群值的範圍，zscore預設為3，IQR預設為1.5，此數值需大於0。

此語法會讓離群值商品在排行前就被排除，也不會被納入計算其他屬性，例如 avgvalue。

此語法需寫在 rank 語法內，且每一個rank只能有一個。

此語法必須在rank內的最上層，不能夠放在 if 或 for 等邏輯判斷內。

以下是簡單範例：

```xs
Rank myRank Begin
    RetVal = HVolatility(Close,20);
    SetRemoveOutlier("zscore", value:=3);
    end;
```

此範例會用波動率進行排行，但會先排除掉 zscore 絕對值大於3的商品。

## SetTBMode（設定自定指標繪圖模式）

**語法**：指定自定指標的繪圖模式
SetTBMode(繪圖模式)

指定自定指標的繪圖模式。
支援模式的如下

- SetTBMode(1) 同v5.62行為，腳本資料計算筆數為資料讀取筆數加畫面上的K棒筆數，使用者拉動畫面會進行重算。

- SetTBMode(0) 預設值，腳本資料計算筆數為全部資料，整個數列只算一次，拉動畫面不會重算。

範例:

```xs
Input: Period(200, "EMA");
SetTBMode(1);//指定自定指標的繪圖模式，可以變更參數比較一下計算值的差異
Plot1(EMA(Close, Period), "EMA");
```

## SetTotalBar（設定資料讀取筆數）

**語法**：指定腳本執行時的資料讀取範圍
SetTotalBar(資料讀取筆數)

關於**資料讀取範圍**的定義，請參考資料讀取範圍與腳本執行的關係。

SetTotalBar 用於設定腳本執行時，讀取的歷史K棒數量。

SetTotalBar 設定的資料讀取筆數必須為**非負整數**。當腳本引用 SetTotalBar 並指定一個數值時，系統會預先提供指定數值的K棒，並從這些K棒的第一根 (編號為1) 開始執行腳本。

不同腳本類型的規則：

- 指標腳本： 將繪製的歷史 K 棒數量，不包含即時的 K 棒。

- 選股腳本： 判斷目前K棒是否滿足選股條件之前，將執行的 K 棒數量。

- 警示腳本： 開始接收即時價格更新並觸發警示訊號之前，將執行的 K 棒數量，不包含即時的 K 棒。

- 自動交易腳本：(策略部位計算起點之前，或)開始接收即時價格更新並觸發警示訊號之前，將執行的 K 棒數量，不包含即時的 K 棒。

**如果在腳本中多次使用 SetTotalBar ，並設定了不同的數值：**

- 將會採用其中編譯成功的最大數值作為最終的K棒總數。

     若設定的數值不是非負整數，該行的SetTotalBar將被視為編譯失敗。

**如果在腳本中同時存在數個 SetTotalBar 和 SetFirstBarDate ，並設定了不同的數值時：**

- 系統將分別根據兩者被多次使用時的規則，決定接下來各自採用哪一個 SetTotalBar 與 SetFirstBarDate 做比較。

- 接著採用兩者當中，最後一個成功完成編譯的函數設定。

     若其中一個函數因參數無效（例如 SetTotalBar 的資料讀取筆數為負數，或 SetFirstBarDate 的日期不合理）而編譯失敗，則只有另一個成功編譯的函數設定會被採用。

## SymbolExchange（目前執行商品的交易所編碼）

**語法**：目前執行商品的交易所編碼
回傳代碼 = SymbolExchange

SymbolExchange函數回傳目前執行商品的交易所編碼，例如 "TW"。

當回傳值為"TW"時，表示商品屬於台灣證券交易所（上市&上櫃）。
當回傳值為"TE"時，表示商品屬於台灣興櫃。
當回傳值為"TF"時，表示商品屬於台灣期貨交易所。
當回傳值為"FS"時，表示商品屬於國際指數。
當回傳值為"FX"時，表示商品屬於外匯。
當回傳值為"HK"時，表示商品屬於香港交易所。
當回傳值為"SH"時，表示商品屬於上海交易所。
當回傳值為"SZ"時，表示商品屬於深圳交易所。
當回傳值為"KS"時，表示商品屬於韓股。
當回傳值為"JP"時，表示商品屬於日股。
當回傳值為"US"時，表示商品屬於美股。
當回傳值為"SG"時，表示商品屬於新加坡。

範例:

```xs
If SymbolExchange = "TW" then
begin
    // 目前執行的商品為台股商品
end;
```

## SymbolType（目前執行腳本的商品類型）

**語法**：回傳目前執行腳本的商品類型
回傳代碼 = SymbolType

SymbolType函數回傳目前執行腳本的商品類型。

當回傳值為1時，表示商品是指數。

當回傳值為2時，表示商品是股票。

當回傳值為3時，表示商品是期貨。

當回傳值為4時，表示商品是權證。

當回傳值為5時，表示商品是選擇權。

當回傳值為6時，表示商品是可轉債。

當回傳值為7時，表示商品是特別股。

範例:

```xs
If SymbolType = 3 then
begin
    // 目前執行的商品為期貨
end;
```
