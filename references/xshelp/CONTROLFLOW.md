# 關鍵字 - 流程控制（CONTROLFLOW）

> 來源：https://xshelp.xq.com.tw/XSHelp/lists?a=CONTROLFLOW（官方 XSHelp，自動爬取）

## 流程控制總覽

在腳本撰寫的過程當中，我們可能會使用到一些比較複雜的邏輯進行運算。簡單的條列陳述沒有辦法達到這個需求，這時候我們就會需要一些流程控制的語法來幫忙。

**條件判斷**

條件判斷是最常使用的一種流程控制，會依執行的順序依序判斷，符合後即條出。XSscript提供以下三種條件判斷式：

If Then Else

Switch Case Default

Once

**迴圈**

另一種流程控制是迴圈。迴圈用在計算或比較需要重複執行的情況，例如計算過去10期的值，就可以利用迴圈來完成。XSscript提供以下三種條件判斷式：

For To (DownTo)

While

Repeat Until

**中斷**

在執行的過程中，為了提升效率，可以控制電腦跳過某些計算不執行。就可以用中斷語法來達成。

Break：跳出迴圈

Return：跳出腳本

Ret（RetVal）

**多行語法**

Begin End

XSscript的執行是一行為單位（用分號“;”結尾）。所以在流程控制中，通常都會搭配Begin…End使用。Begin…End可以讓我們用多行的陳述式進行運算，而非原先僅能使用單行陳述式。

**數列關係**

Cross Over（Cross Above）：判斷是否黃金交叉

Cross Under（Cross Below）：判斷是否死亡交叉

**邏輯判斷**

Not：取得相反值

And：判斷條件是否同時成立

Or：判斷是否有任一條件成立

XOR：計算差集

## IF / THEN / ELSE

使用**IF**/**THEN**/**ELSE**這三個語法來判斷某個條件成立時該執行那個動作，不成立時又該執行那個動作。

如果只需要判斷某個條件成立時該執行那個動作，則使用以下的語法:

```xs
If Close > Open Then Ret = 1;
```

在上述範例內如果Close值大於Open值的話則 Ret 變數的數值會被設定為1。

如果當條件成立時需要執行多個指令的話，則使用**Begin**/**End**的語法來包圍所需要執行的指令。

```xs
If Close > Open Then
Begin
	Value1 = Close - Open;
	Value2 = High - Low;
End;
```

如果條件成立時跟不成立時都需要執行不同的指令的話，則可以加入 **ELSE**語法來定義條件不成立時該執行的動作。

```xs
If Close > Open Then
	Value1 = Close - Open
Else
	Value1 = Open - Close;
```

在上述範例內當Close的數值不大於Open的數值時，程式會執行Else內的語法。以這個例子為例，Value1的數值就是這根bar的實體高度。

同樣的，Else之後也可以使用Begin/End語法來定義多個指令，範例如下:

```xs
If Close > Open Then
Begin
	Value1 = Close - Open;
	Value2 = High - Low;
End
Else
Begin
	Value1 = Open - Close;
	Value2 = High - Low;
End;
```

Else後面也可以接if，用else if來進行多層次的條件判斷，從腳本上至下依序縮小判斷範圍，範例如下:

```xs
if value1 < 0 then
	value2 = 1
else if value1 < 10 then //等同於if  0 <= value1 and value1 < 10
	value2 = 2
else if value1 < 20 then //等同於if  0 <= value1 and value1 < 10
	value2 = 3
else  //等同於if  20<= value1
	value2 = 4;
```

## Switch / Case / Default

**Switch**語法是用來判斷某個變數的值是否符合某些運算式，同時定義符合時的執行指令。

語法如下：

```xs
Switch (變數)
Begin
  Case 運算式1:
     符合運算式1時所執行的指定;
  Case 運算式2:
     符合運算式2時所執行的指定;
  Default:
     都不符合時所執行的指令;
End;
```

在**Switch**語法內必須傳入一個變數，同時使用**Case**語法定義各種不同的運算式，以及當這個運算式符合時要執行的指令。同時也可以使用**Default**語法來定義當所有的Case都不符合時所需要執行的指令。

以下是一個範例:

```xs
Value1 =DayOfMonth(date);
Switch (value1)
Begin
  Case 1:   // value1=1時執行這段程式碼
		print(Text("今天的日期是",numtoStr(date,0),
		"。是",numtoStr(DayOfMonth(date),0),"日")
		,"value1=1時執行這段程式碼");

  Case 2:   // value1=2時執行這段程式碼
		print(Text("今天的日期是",numtoStr(date,0),
		"。是",numtoStr(DayOfMonth(date),0),"日"),
		"value1=2時執行這段程式碼");

  Case 3:   // value1=3時執行這段程式碼
		print(Text("今天的日期是",numtoStr(date,0),
		"。是",numtoStr(DayOfMonth(date),0),"日"),
		"value1=3時執行這段程式碼");

  Case 4:   // value1=4時執行這段程式碼
		print(Text("今天的日期是",numtoStr(date,0),
		"。是",numtoStr(DayOfMonth(date),0),"日"),
		"value1=4時執行這段程式碼");

  Case 5:   // value1=5時執行這段程式碼
		print(Text("今天的日期是",numtoStr(date,0),
		"。是",numtoStr(DayOfMonth(date),0),"日"),
		"value1=5時執行這段程式碼");

  Case 6 to 20: // value1= 6 ~ 20 時執行這段程式碼
		print(Text("今天的日期是",numtoStr(date,0),
		"。是",numtoStr(DayOfMonth(date),0),"日"),
		"value1=6~20時執行這段程式碼");

  Default:  // 其他情形都執行這段程式碼
		print(Text("今天的日期是",numtoStr(date,0),
		"。是",numtoStr(DayOfMonth(date),0),"日"),
		"其他情形都執行這段程式碼");
End;
```

在上述範例內這個變數為**Value1**，然後使用**Case**語法一一檢查**Value1**是否為1，2，3，4，5，620同時也使用**Default**語法定義當**Value1**不是1，2，3，4，5，620時所需要執行的指令。

由於DayOfMonth這個函數會計算出今天為幾日(如果是01日的話則回1，02日則回2，03日則回3)，所以以上的範例：

- 在 01 日會印出「今天的日期是19941101。是1日 value1=1時執行這段程式碼」

- 在 02 日會印出「今天的日期是19941102。是2日 value1=2時執行這段程式碼」

- 在 03 日會印出「今天的日期是19941103。是3日 value1=3時執行這段程式碼」

- 在 04 日會印出「今天的日期是19941104。是4日 value1=4時執行這段程式碼」

- 在 05 日會印出「今天的日期是19941105。是5日 value1=5時執行這段程式碼」

- 在 06 ~ 20 日會印出「今天的日期是19941107。是7日 value1=6~20時執行這段程式碼 」

- 在 21 ~ 月底會印出「今天的日期是19941121。是21日 其他情形都執行這段程式碼 」

## Once

**Once**語法用來定義某些**只需要執行一次的程式碼**。

舉例而言：

```xs
Once(High = Highest(High, 5))
Begin
    HighDate = Date;
    HighPrice = High;
End;
```

**Once**語法之後必須填入一個判斷式，以上例而言，這個判斷式是 **High = Highest(High, 5)**，在判斷式之後，可以填入當判斷式成立時要執行的指令，如果有多行指令的話則可以使用**Begin/End**來包圍。

所以上面這個範例執行的邏輯是，當創5日新高時，執行HighDate = Date，以及HighPrice = High這兩個指令，**而且一旦出現創5日新高的情形之後，就不再執行HighDate = Date, 以及HighPrice = High這兩個指令**。

如果要達到同樣的目的，也可以使用IF指令，搭配一個紀錄是否曾經執行過的變數：

```xs
Var: FirstTime(False);
If High = Highest(High, 5) And Not FirstTime Then
Begin
    HighDate = Date;
    HighPrice = High;
    FirstTime = True;
End;
```

在上述範例內，程式使用**FirstTime**這個變數來紀錄這個IF狀態是否曾經發生過，以確保只會執行一次。

可是由於系統會根據執行的設定方式在每一筆bar甚至每一筆tick更新時都會執行完整的程式碼，所以如果是使用If的寫法的話，每一次執行時還是會去判斷 High是否等於Highest(High, 5)！反之，如果是使用Once的寫法的話，一旦Once的運算式成立之後，未來不管執行任意bar，系統都會**自動跳過Once的判斷式以及程式碼**。由於在這個例子內，IF內所需要執行的指令比較複雜且費時，所以就可以使用**Once**的語法來提升執行的速度。

## For To / DownTo

**For**語法是用來定義一段迴圈的執行邏輯。

**For**迴圈語法內必須使用一個變數，指定這個變數的**初始值**跟**結束值**，同時指定這個迴圈內要執行的指令:

```xs
For 變數 = 初始值 to 結束值
  執行的指令;
```

如果要執行的指定超過一行的話則使用**Begin/End**語法來包裝需要執行的指定

```xs
For 變數 = 初始值 to 結束值
Begin
  執行的指令1;
  執行的指令2;
End;
```

迴圈內的指令總共會被執行**(結束值 -  初始值 + 1)**次，在期間每次執行時，變數的值會從**初始值**一一遞增到**結束值**為止。

以下是一個實例:

```xs
SumValue = 0;
For i = 0 to 4
Begin
	SumValue = SumValue + Close[i];
End;
AvgValue = SumValue / 5;
```

上述的範例是一個累加的用法，透過For迴圈總共執行了5次(4 - 0 + 1)，第一次執行時i = 0(初始值), 第二次執行時i = 1(遞增), 最後一次執行時i = 4(結束值)。所以執行完For迴圈後SumValue的數值是最近５期Close欄位的累加值，把SumValue的值除以5之後就可以得到Close值的平均數值。

如果迴圈的控制方式希望是從初始值一直減少直到結束值為止的話，則可以使用**DownTo**指令。

```xs
SumValue = 0;
For i = 4 downto 0
Begin
	SumValue = SumValue + Close[i];
End;
AvgValue = SumValue / 5;
```

上述範例執行的結果與先前相同，唯一的差異是**DownTo**語法，所以迴圈執行的方式是第一次i = 4, 第二次 i = 3(遞減), 第三次 i = 2, 第四次 i = 1, 最後一次 i = 0。

一般而言迴圈的執行次數是透過初始值跟結束值來控制的，可是如果需要在執行過程內**提前跳出**的話，則可以使用**Break**指令。

系統內還提供不同的迴圈控制方式，請參考**Repeat/Until**以及 **While**。

## While

**While**語法是用來定義一段迴圈的執行邏輯。語法如下：

```xs
While 判斷式
  執行的指令;
```

當判斷式成立時，While迴圈會重複的執行，一直到判斷式回傳False為止。

如果在迴圈內需要執行多個指令的話，則可以使用**Begin/End**的方式來包圍。

```xs
While 判斷式
Begin
  執行的指令1;
  執行的指令2;
End;
```

以下是一個範例:

```xs
SumValue = 0;
While i < 5
  Begin
    SumValue = SumValue + Close[i];
    i = i + 1;
  End;
AvgValue = SumValue / 5;
```

上述範例內While的迴圈會一直執行，直到 i 的數值 >= 5時才會停止。每次執行時SumValue會累加前幾期的Close數值，同時變數i 會每次加1。以這個範例而言，SumValue的數值會變成是最近５期收盤價的加總，最後算出AvgValue為最近５期的平均收盤價。

系統內還提供不同的迴圈控制方式，請參考**Repeat/Until**以及 **For**。

## Repeat / Until

**Repeat/Until**的語法是用來定義一段迴圈的執行邏輯。，語法如下:

```xs
Repeat
  執行的指令;
Until 判斷式;
```

程式會不斷的執行Repeat之後的指令，一直到Until後續的判斷式變成True值時才會離開迴圈。

如果迴圈內需要執行的指令超過一個的話，則可以使用**Begin/End**來包圍:

```xs
Repeat
  Begin
    執行的指令1;
    執行的指令2;
  End;
Until 判斷式;
```

以下是一個範例:

```xs
SumValue = 0;
Repeat
  Begin
    SumValue = SumValue + Close[i];
    i = i + 1;
  End;
Until i = 4;
AvgValue = SumValue / 5;
```

上述範例內Repeat的迴圈會一直執行，每次執行時SumValue會累加前幾期的Close數值，同時變數 i 會每次加1。這個迴圈會一直跑到 i = 4 的時候才會離開。以這個範例而言，SumValue的數值會變成是最近５期收盤價的加總，最後算出AvgValue為最近５期的平均收盤價。

系統內還提供不同的迴圈控制方式，請參考**While** 以及 **For**。

## Break

**Break**指令的用處是控制迴圈執行時跳出迴圈的時機點，一般是用在**For**迴圈或是**While**迴圈內。

以下是**For**迴圈的範例:

```xs
i = 0;
For i = 0 to 10
Begin
	If Close[i] < 20 Then Break;
End;
```

一般而言上面的迴圈會執行11次(從I = 0 到 10)。可是在執行過程內，如果某一期的Close欄位值比20小的話，就會馬上跳出 For 迴圈。

## Return

**Return**指令用來中斷正在執行的腳本。當程式遇到這個指令時，執行將會中斷。

```xs
If CurrentTime < 123000 Then Return;

If Close > Close[1] and Close = High Then Ret = 1;
```

上述範例利用CurrentTime來判斷執行時間，如果是在12:30之前的話則不做任何動作(腳本直接中斷，等待下一根bar)。在12:30過後如果收盤價創當日新高的話則觸發。

## Ret

**Ret**是一個系統的內建變數，他的數值會決定警示腳本以及選股腳本執行結果。

當警示腳本以及選股腳本在每根bar重新執行時 **Ret**的數值會被設定為0，當這根bar結束完成時如果**Ret**的數值不是0的話，則會產生觸發訊號(警示腳本)，或是選取這檔商品(選股腳本)。

以下是一個範例，在收盤價大於五日平均值時把**Ret**的數值設為1，用來觸發警示或是選取這個商品。

```xs
If Close > Average(Close, 5) Then Ret = 1;
```

## Begin / End

**Begin** / **End** 語法用在 **If**, **While**, **For** 等控制指令內。當需要輸入超過一行的程式碼時，就必須使用**Begin**/**End**來把程式碼包圍起來。

```xs
If Close >= Close[1] Then ret = 1;  // 計算漲跌
```

上述範例內當Close >= Close[1]時因為只需要執行一行指令，所以可以把指令直接寫出來。

可是在以下的範例內，由於當Close >= Close[1]時我們希望要執行兩個指令，所以透過**Begin**/**End**把這兩個指令包圍起來。

```xs
If Close >= Close[1] Then
Begin
   Value1 = Close - Close[1];  // 計算漲跌
   Value2 = Value1 / Close[1]; // 計算漲跌幅
End;
```

## Cross Above / Cross Below

**Cross**相關的語法共有兩種：

- **Cross Above** 或是 **Cross Over** 是用來檢查目前的欄位數值是否**向上穿越**某個欄位的前期數值。

- **Cross Below** 或是 **Cross Under** 則是用來檢查目前的欄位數值是否**向下跌破**某個欄位的前期數值。

以下是**向上穿越**均線的寫法：

```xs
If Close Cross Above Average(Close, 5) Then ret = 1;
```

當這一期的Close欄位大於等於近5期的平均值(Average(Close,5))且前一期的Close欄位小於前一期的近5期的平均值的話，則ret會被設定成1。

以下則是**向下跌破均線**的寫法：

```xs
If Close Cross Below Average(Close, 5) Then ret = 1;
```

如果這一期的Close欄位小於等於近5期的平均值(Average(Close,5))且前一期的Close欄位大於前一期的近5期的平均值的話，則ret會被設定成1。

**Cross**也可以寫成**Crosses**。

## NOT

**NOT**語法回傳運算式的相反值。

請看以下的範例程式:

```xs
If Close > Close[1] Then Ret = 1;
```

這個例子會在Close值大於Close的前期值時設定Ret為1。

如果使用者希望的是在Close值 **不是** 大於Close的前期值時才設定Ret為1的話，則可以寫成:

```xs
If Not (Close > Close[1]) Then Ret = 1;
```

上述的範例會在Close值 **不是** 大於Close的前期值時設定Ret為1。

## AND

**AND**語法用來檢查運算式是否**同時成立**。

```xs
If Close >= Close[1] And Volume >= Volume[1] Then ret = 1;
```

在上述範例內如果close欄位 >= 前期值 **而且同時** volume欄位 >= 前期值的話，則ret會被設定成1。

請參考OR語法。

## OR

**OR**語法用來檢查運算式**是否有任一個成立**。

```xs
If Close >= Close[1] Or Close >= Close[2] Then ret = 1;
```

在上述範例內如果Close欄位 >= 前期值 **或是** Close欄位 >= 前兩期值的話，則ret會被設定成1。

請參考AND語法。

## XOR

XOR運算式是用來計算兩個邏輯數值的差集。

運算方式如下：

- True XOR True 傳回False

- True XOR False 傳回True

- False XOR True 傳回True

- False XOR False 傳回False
