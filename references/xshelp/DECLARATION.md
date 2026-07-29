# 關鍵字 - 宣告（DECLARATION）

> 來源：https://xshelp.xq.com.tw/XSHelp/lists?a=DECLARATION（官方 XSHelp，自動爬取）

## 宣告總覽

宣告是在腳本中引入變數使用。變數是用來存放計算後的數值，方便重複使用或增加腳本的可讀性。

變數需要先經過宣告的程序後才能使用，並且在宣告的同時也需要指定變數的類型、名稱或初始值等變數的屬性。

在XSscript中，一共有下列宣告變數的語法：

**宣告變數**

Var（Variable、Variables、Vars）

IntrabarPersist

**宣告陣列**

Array（Arrays）

**宣告輸入**

Input（Inputs）

inputkind（inputkind）

**宣告數值輸入（函數）**

Numeric

NumericSimple

NumericSeries

NumericRef

NumericArray

NumericArrayRef

**宣告字串輸入（函數）**

String

StringSimple

StringSeries

StringRef

StringArray

StringArrayRef

**宣告布林輸入（函數）**

TrueFalse

TrueFalseSimple

TrueFalseSeries

TrueFalseRef

TrueFalseArray

TrueFalseArrayRef

## Var

**Var**語法用來宣告變數，並且給定變數的預設值。

系統會根據**Var**語法內給定的預設值的型態來決定變數的類型。目前系統提供以下三種變數類型:

- 數值，例如 10, 5.3,

- 字串, 例如 "String"，

- 邏輯值, 例如 True, False

語法如下:

```xs
Var: SumValue(0);
Var: StrValue("");
Var: Flag(True);
```

在上述的範例內宣告了三個變數:

- **SumValue**是一個數值變數，初始值為0，

- **StrValue**是一個字串變數，初始值為"" (空白字串)，

- **Flag**是一個邏輯變數，初始值為True

多個變數也可以在同一行內宣告，例如可以把上述範例寫成:

```xs
Var: SumValue(0), StrValue(""), Flag(True);
```

除了**Var**語法之外，也可以使用**Vars**語法，**Variable**語法，或是**Variables**語法來宣告變數，範例如下：

```xs
Vars: SumValue(0);
Variable: StrValue("");
Variables: Flag(True);
```

## IntrabarPersist

**IntrabarPersist**語法用來控制變數數值在執行時的變化邏輯。

在程式執行時，變數的數值會自動延續前一筆bar最後的計算值。

以下是一個簡單的示意圖，說明變數的數值在執行時的變化情形。

注意到在上圖內變數的數值都會從上一筆執行後的結果延續到下一筆bar。

如果上述的腳本被設定成逐筆洗價的話(也就是說同一筆bar可能執行很多次)，則變數的數值變化情形如下:

請注意，雖然第二筆bar因為價位變化的關係被執行了兩次，可是每次執行時，Counter變數的數值還是都會先變成上一筆bar最後執行的結果(1)之後才開始執行第二筆bar。(圖示內紅色標記處)。所以雖然第二筆bar執行了兩次，Counter在離開第二筆bar的時候的數值還是為2。

這個行為是為了要保證逐筆洗價時最後算出來的數值只跟這一筆bar的價位有關，而不是跟這一筆bar被執行了多少次有關。
可是在某些情境底下可能需要保留最後一次計算後的數值(不管是否有換bar)，此時就可以使用**IntrabarPersist**的語法:

```xs
input: atVolume(100); setinputname(1,"大單門檻");

variable: intrabarpersist Xtime(0);         //計數器

Volumestamp = q_DailyVolume;

if Date > date[1] then Xtime = 0; // 開盤那根要歸0次數

if q_tickvolume > 100 then Xtime += 1; // 量夠大就加1次

if Xtime > 10  then
begin
	ret = 1;
	Xtime = 0;
end;
```

上述範例是一個警示腳本，使用日線頻率，逐筆洗價模式來執行。我們希望當大單(目前定義成單筆成交量 > 100張)的個數超過10之後就觸發。由於是日線模式，所以每次重新執行時 XTime都會變成0，無法實際統計發生大單的次數。

解決方式則是把XTime設為IntrabarPersist．一旦這樣設定之後，XTime的數值就不會因為重新執行這根bar而被還原，也因此可以正確的統計到在當日出現大單的個數。

## Array

**Array** 語法用來宣告一個陣列變數，同時設定陣列的大小以及陣列內儲存數值的資料型態(也可以寫成**Arrays**)。

所謂陣列就是一個可以儲存**多個數值**的變數，陣列內儲存數值的個數，以及數值的資料型態可以透過Array語法來定義。

系統提供兩種控制陣列數值個數的方式。第一種方式是固定個數，語法如下:

```xs
Array: NumArray[10](0);
Array: StrArray[10]("");
Array: BoolArray[10](True);
```

在以上的範例設定了三個陣列變數：

- NumArray，這是一個數值陣列，總共有10個數值，每個數值的初始值都是0，

- StrArray，這是一個字串陣列，總共有10個數值，每個數值的初始值都是""，

- BoolArray，這是一個布林值陣列，總共有10個數值，每個數值的初始值都是True

以下是NumArray在宣告後的示意圖。

如果要存取NumArray的話，則使用以下的語法：

```xs
NumArray[1] = 5;
Value1 = NumArray[1];
```

在中括弧[]內傳入的數值稱之為**索引值**，索引值的範圍由1開始，一直到陣列宣告的最大個數。

如果陣列的大小無法預先知道的話，則可以使用第二種語法來宣告陣列：

```xs
Array: NumArray[](0);
Array: StrArray[]("");
Array: BoolArray[](True);
```

請注意在上述語法內並未指定陣列的個數 ([] 內並沒有任何數值)。此時陣列已經被宣告，也已經定義這個陣列內可以存放的資料的格式，可以此時陣列還不可以被使用。

等到程式知道陣列的實際所需大小時，程式必須透過 Array_SetMaxIndex　函數來設定陣列的大小。

```xs
Var: Count(0);
Array: NumArray[](0);

If High > Highest(High,20)[1] Then Count = Count + 1;

Array_SetMaxIndex(NumArray, Count);
NumArray[Count] = High;
```

在上述範例內每當創近20期新高時 (High > Highest(High,20)[1])，NumArray就會多存放當時的新高價。由於無法預先知道所需要儲存的個數，所以使用上述語法來動態設定陣列的大小。

以上所定義的陣列變數都是屬於一維陣列，也就是說一個陣列變數內有多個數值，使用時像序列般的方式來存取。如果需要陣列內的數值可以以類似矩陣的方式來存取的話，則可以以下列語法來宣告二維陣列。

```xs
Array: NumArray[10,2](0);
```

在上例內，中括弧[]內有兩個數值，分別是10跟2。透過這樣子的語法我們宣告了一個二維陣列，他的內容如下:

我們可以想像一個二維陣列就好像是一個Excel的表格一樣。中括弧內的第一個數值宣告這個表格的行數，第二個數字則是宣告表格的欄數。

當需要存取二維陣列時、我們使用以下的語法:

```xs
NumArray[5,1] = 10;
Value1 = NumArray[1,2];
```

存取時需要傳入兩個索引值，索引值的範圍是從１開始，不能超過陣列的行數跟欄數。

※ Array 維度最多 9 個。元素數量最多 7000。例如：Array:LimitArray[a,b,c,d,e,f,g,h,i];
　則 (a+1) * (b+1) * (c+1) * (d+1) * (e+1) * (f+1) * (g+1) * (h+1) * (i+1) 所得到的元素值最多為 7000 個。

## Input

**Input**語法用來宣告腳本參數的名稱以及資料類型(也可以寫成**Inputs**)。

**Input**的語法依照腳本類型而有差異。

如果是指標腳本，警示腳本，或是選股腳本的話，則使用以下語法。以下是一個指標的範例：

```xs
Input: Length(10);

Plot1(Average(Close, Length));
```

在上述的指標範例內宣告了一個名為**Length**的參數，用來存放計算收盤價平均值的天期。這個參數的預設值為10，資料類型為數字。

一旦宣告之後，程式內則可以像變數 Var一樣的使用這個參數。可是跟變數不同的是，使用者在使用這個腳本時，可以透過參數設定的畫面來動態控制這個參數的數值。以下是設定指標時的參數設定畫面:

由於使用者可以在引用腳本時動態控制參數的數值，腳本的應用上會更有彈性。

在上面的參數設定畫面內看到參數名稱顯示為**Length**，也就是Input語法內設定的變數名稱。如果希望畫面上看到的參數名稱是中文的話，則可以在Input語法內傳入參數名稱:

以下是修改後的範例:

```xs
Input: Length(10, "天期");

Plot1(Average(Close, Length));
```

底下是設定參數畫面:

注意到畫面上出現的參數名稱已經變成 "天期"了。這樣子的作法可以讓腳本的使用上更為清楚。

Input語法如果應用在函數腳本內的話，則必須使用不同的語法:

```xs
Input: Price(NumericSeries);
Input: Length(NumericSimple);

Value1 = Summation(Price, Length) / Length;
```

在上述範例內宣告了兩個參數，第一個參數叫做**Price**，他的資料格式是一個數字序列，第二個參數叫做**Length**，他的資料格式是一個數字(不是序列)。

```xs
Input: Price(NumericSeries,"價格");
Input: Length(NumericSimple,"天期");
```

在上述範例內宣告了兩個參數，第一個參數叫做**Price**，他的資料格式是一個數字序列，且參數名稱為**價格**；第二個參數叫做**Length**，他的資料格式是一個數字(不是序列)，且參數名稱為**天期**。

```xs
Input: Price(close,NumericSeries,"價格");
Input: Length(10,NumericSimple,"天期");
```

在上述範例內宣告了兩個參數，第一個參數叫做**Price**，預設值為**Close**，他的資料格式是一個數字序列，參數名稱為**價格**；第二個參數叫做**Length**，預設值為**10**，他的資料格式是一個數字(不是序列)，參數名稱為**天期**。

關於函數所支援的各種不同的參數類型，請參考以下章節:

- Numeric

- NumericSimple

- NumericSeries

- NumericRef

- NumericArray

- NumericArrayRef

- String

- StringSimple

- StringSeries

- StringRef

- StringArray

- StringArrayRef

- TrueFalse

- TrueFalseSimple

- TrueFalseSeries

- TrueFalseRef

- TrueFalseArray

- TrueFalseArrayRef

## inputkind

input宣告的時候，可以使用 **inputkind** 這個命名參數(named parameter)，用來控制系統參數設定的介面(UI)。再搭配 Dict 、 DateRange 或 SymbolPrice 函數來產生對應的內容。

Dict 產生選項的範例如下：

```xs
input: IndexPomUnit(1, "大盤融資單位", inputkind:=Dict(["金額",1],["張數",2]));
```

在上述的範例內宣告了一個名為 IndexPomUnit 的參數，用來存放計算大盤融資的數值，不過此數值的單位有**金額**與**張數**兩種，故可以使用 inputkind 搭配 Dict 函數，就能在介面設定單位為金額或者張數，此範例預設單位為金額。

也可以改寫成以下範例，使用字串型態的方式來撰寫相關程式碼：

```xs
input: IndexPomUnit("Amount", "大盤融資單位", inputkind:=Dict(["金額","Amount"],["張數","Sheets"]));
```

DateRange 產生日期範圍選項的範例如下：

```xs
input:FdifferenceDate(20180301,"外資買賣超查詢日期",inputkind:=daterange(20160301,20190301,"D"));
//daterange(最小查詢日期,最大查詢日期,"支援日/週/月/季/半年/年頻率")
```

在上述的範例內宣告了一個名為 FdifferenceDate 的參數，用來存放外資買賣超查詢日期的數值，就能方便在介面上勾選日曆選項使用，此範例預設查詢日期為2018年03月01日。

SymbolPrice 產生 Open、High、Low、Close 四個選項的範例如下：

```xs
input:OHLC_Opti(200,"價格：",inputkind:=SymbolPrice());
```

在上述的範例中，宣告了一個名為 OHLC_Opti 的參數，用來存放價格的數值，就能方便在介面上勾選  Open、High、Low、Close 四個選項使用。

## Numeric

(僅適用於函數腳本內)

**Numeric**語法是用來定義函數腳本的參數為數值型態。

```xs
Input: Price(Numeric);
Input: Length(Numeric);

Value1 = Summation(Price, Length) / Length;
```

假設上例是一個名稱為**MyFunction**的函數, 在此**Price**參數跟**Length**參數都被定義成**Numeric**, 表示使用這個函數的腳本必須傳遞數值型態的參數，否則腳本編譯時會產生錯誤。

以下是使用這個函數的腳本的範例:

```xs
Value1 = MyFunction(Close, 5);
```

在上例內呼叫MyFunction時傳入了**Close**(收盤價序列)，以及數值5。

**Numeric**型態還有以下兩個變形:

- **NumericSeries**: 表示傳入的數值為一個序列，例如傳入**Close**(收盤價序列),

- **NumericSimple**: 表示傳入的數值為一個單一數值，例如 **5**

這兩種變形的用意是要幫忙系統可以更精確的處理腳本跟函數之間的運作關係。所以上述MyFunction可以被改寫成:

```xs
Input: Price(NumericSeries);
Input: Length(NumericSimple);

Value1 = Summation(Price, Length) / Length;
```

在這個函數內，由於**Price**是被當成序列來使用(計算加總時會用到前期值)，所以可以宣告成**NumericSeries**。而**Length**因為只會用到當下的數值，所以可以宣告成**NumericSimple**。

目前XS系統內，只要是數值參數，腳本內可以混用**Numeric**, **NumericSimple**, 以及 **NumericSeries** 這三種宣告方式，不影響腳本執行的結果。

## NumericRef

(僅適用於函數腳本內)

**NumericRef**語法用來定義函數腳本的參數為數值型態，並且可以從函數內修改呼叫者傳入的數值。

當一個函數變數被宣告成**Numeric**時，在函數內對這個數值的修改並不會影響呼叫者端傳入的變數，這個行為稱之為 Call By Value。

如果有需要從函數內可以更改呼叫者端的變數的話，則可以使用**NumericRef**的語法，此時的行為會變成Call By Reference。

```xs
// MACD function
//  Input: Price序列, FastLength, SlowLength, MACDLength
//  Output: DifValue, MACDValue, OscValue
//
Input: Price(numericseries);
Input: FastLength(numericsimple);
Input: SlowLength(numericsimple);
Input: MACDLength(numericsimple);

Input: DifValue(numericref);
Input: MACDValue(numericref);
Input: OscValue(numericref);

DifValue = XAverage(price, FastLength) - XAverage(price, SlowLength);
MACDValue = XAverage(DifValue, MACDLength) ;
OscValue = DifValue - MACDValue;
```

在上述MACD函數內，呼叫者端傳入了價格序列(**Price**), 短天期(**FastLength**), 長天期(**SlowLength**)，以及MACD的天期(**MACDLength**)，函數內要算出**DIF**的數值, **MACD**的數值, 以及**OSC**的數值。由於總共有三個數值需要回傳，所以利用**NumericRef**的方式來完成。

呼叫者端的程式碼範例如下：

```xs
input: FastLength(12), SlowLength(26), MACDLength(9);
variable: difValue(0), macdValue(0), oscValue(0);

MACD(Close, FastLength, SlowLength, MACDLength, difValue, macdValue, oscValue);

Ret = difValue Crosses Above macdValue;
```

注意到當呼叫完**MACD**函數後, **difValue**, **macdValue**, 以及 **oscValue**的數值都會從MACD函數內回傳。

## NumericArray

(僅適用於函數腳本內)

**NumericArray**語法用來定義函數腳本的參數為數值陣列型態。

```xs
Input: MyNumericArray[X](NumericArray);

For Value1 = 1 to X
  Value2 = Value2 + MyNumericArray[Value1];
```

**NumericArray**與**Numeric**最大的差異是在Input語法內陣列變數名稱之後還需要定義*[陣列大小變數]。在上例內[X]*就宣告了一個變數**X**，他的數值會是傳入的陣列的大小(陣列內有多少數值)。

透過這個機制，函數內就可以知道傳入的陣列的大小，然後利用這個資訊來正確的判斷可以讀取哪些數值。
上述範例內使用一個 For迴圈來加總傳入陣列的每個數值，迴圈的範圍是從1開始，直到**X**結束。

如果需要傳入的陣列是二維的，則語法如下:

```xs
Input: MyNumericArray[X,Y](NumericArray);
```

在上例內中括弧內必須填入兩個變數(**X**, **Y**)，這兩個變數的數值將會分別是傳入的陣列的行數跟欄數。

## NumericArrayRef

(僅適用於函數腳本內)

**NumericArrayRef**語法用來定義函數腳本的參數為數值陣列型態，並且可以從函數內修改呼叫者傳入的數值陣列。

```xs
Input: MyNumericArray[X](NumericArrayRef);
```

**NumericArrayRef**可以視為**NumericArray**以及**NumericRef**的綜合體。請參考以上兩種語法的說明。

## String

(僅適用於函數腳本內)

**String**語法用來定義函數腳本的參數為字串型態。

```xs
Input: MyString(String);
```

**String**型態也有兩種變形:

- **StringSeries**: 代表傳入的是一個字串序列，

- **StringSimple**: 代表傳入的是一個字串的單一值

相關的語法請參考**Numeric**

## StringRef

(僅適用於函數腳本內)

**StringRef**語法用來定義函數腳本的參數為字串型態，並可以從函數內修改呼叫者傳入的數值。

```xs
Input: MyString(StringRef);
```

關於從函數內回傳數值的行為，請參考 **NumericRef**

## StringArray

(僅適用於函數腳本內)

**StringArray**語法用來定義函數腳本的參數為字串陣列型態。

```xs
Input: MyStringArray[X](StringArray);
```

相關的語法請參考**NumericArray**

## StringArrayRef

(僅適用於函數腳本內)

**StringArrayRef**語法用來定義函數腳本的參數為字串陣列型態，並且可以從函數內修改呼叫者傳入的字串陣列。

```xs
Input: MyStringArray[X](StringArrayRef);
```

**StringArrayRef**可以視為**StringArray**以及**StringRef**的綜合體。請參考以上兩種語法的說明。

## TrueFalse

(僅適用於函數腳本內)

**TrueFalse**語法用來定義函數腳本的參數為邏輯值型態(**TRUE** 或是 **FALSE**)。

```xs
Input: MyFlag(TrueFalse);
```

**TrueFalse**型態也有兩種變形:

- **TrueFalseSeries**: 代表傳入的是一個邏輯值序列，

- **TrueFalseSimple**: 代表傳入的是一個邏輯值的單一值

相關的語法請參考**Numeric**

## TrueFalseRef

(僅適用於函數腳本內)

**TrueFalseRef**語法用來定義函數腳本的參數為邏輯值型態，並可以從函數內修改呼叫者傳入的數值。

```xs
Input: MyFlag(TrueFalseRef);
```

關於從函數內回傳數值的行為，請參考 **NumericRef**

## TrueFalseArray

(僅適用於函數腳本內)

**TrueFalseArray**語法用來定義函數腳本的參數為邏輯值陣列型態。

```xs
Input: MyFlagArray[X](TrueFalseArray);
```

相關的語法請參考**NumericArray**

## TrueFalseArrayRef

(僅適用於函數腳本內)

**TrueFalseArrayRef**語法用來定義函數腳本的參數為邏輯值陣列型態，並且可以從函數內修改呼叫者傳入的邏輯值陣列。

```xs
Input: MyFlagArray[X](TrueFalseArrayRef);
```

**TrueFalseArrayRef**可以視為**TrueFalseArray**以及**TrueFalseRef**的綜合體。請參考以上兩種語法的說明。
