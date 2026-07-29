# 內建函數 - 字串函數（STRINGFUNC）

> 來源：https://xshelp.xq.com.tw/XSHelp/lists?a=STRINGFUNC（官方 XSHelp，自動爬取）

## InStr（查詢字串是否包含某個子字串）

**語法**：回傳某個字串是否是另一個字串的一部分。
比對位置 = InStr(原始字串, 比對字串);
比對位置 = InStr(字串1, 字串2, 比對開始位置);
- 回傳比對字串位於原始字串的位置，如果不存在的話則回0。
- 第三個參數可以指定比對的開始位置，預設是從第一個位置開始找起。

這個函數可以傳入參個參數：

- 第一個參數是原始字串。

- 第二個參數是欲比對的字串。

- 第三個參數可以指定比對開始的位置。

如果欲比對的字串是原始字串的一部份的話，則回傳這個字串位於原始字串的位置。反之則回傳0。

```xs
Value1 = InStr("abcdefg", "bc");  // Value1 = 2
Value2 = InStr("abcdefg", "xyz"); // Value2 = 0
Value3 = InStr("Hello Hello", "Hello", 6);  //Value3 = 7
```

在上述範例內，"bc"是"abcdefg"的一部份，所以Value1的值會是"bc"位於"abcdefg"內的位置，第2個字元。而"xzy"並不是"abcdefg"的一部份，所以Value2 = 0。
Value3 則是因為指定要從第6個位置開始找起，所以會找到第二個Hello，故回7。

## LeftStr（取字串的左邊子字串）

**語法**：回傳字串的左邊子字串
子字串 = LeftStr(原始字串，字元長度)

這個函數傳入兩個參數：

- 第一個參數是原始字串

- 第二個參數是欲取出的字元個數

回傳值是從原始字串左邊開始長度為第二個參數的子字串。

```xs
Var: str1("");

str1 = LeftStr("abcdefg", 3);  // str1 = "abc"
```

在上面範例內，str1是"abcdefg"從左邊算起長度為3的子字串，"abc"。

請參考 RightStr函數 以及 MidStr函數。

## LowerStr（把字串改成小寫）

**語法**：把字串的每個英文字元轉成小寫
回傳字串 = LowerStr(原始字串)

範例如下:

```xs
Var: str1("");

str1 = LowerStr("ABCDEFG");  // str1 = "abcdefg"
```

請參考UpperStr函數

## MidStr（取字串內部的一個子字串）

**語法**：回傳字串內從指定位置開始的子字串。
子字串 = MidStr(原始字串，指定位置，子字串長度)

這個函數傳入三個參數：

- 第一個參數是原始字串

- 第二個參數是欲取出的子字串的起始位置

- 第三個參數是欲取出的子字串的字元長度

範例:

```xs
Var: str1(""), str2("");

str1 = MidStr("abcdefg", 1, 3);  // str1 = "abc"
str2 = MidStr("abcdefg", 2, 3);  // str1 = "bcd"
```

在上面範例內，str1是"abcdefg"這個字串第一個位置開始長度為3的子字串, "abc"，而str2則是"abcdefg"這個字串第二個位置開始長度為3的子字串, "bcd"。

請參考 LeftStr函數 以及 RightStr函數。

## NumToStr（把數值轉成字串）

**語法**：回傳數值的字串形式，同時可以指定顯示的小數位數。
回傳字串 = NumToStr(數值，小數位數)

NumToStr回傳的字串會依照指定的小數位數來處理，如果實際數值的小數位數**大於**指定的小數位數的話，則採用四捨五入的方式來計算，如果實際數值的小數位數**小於**指定的小數位數的話，則在小數位數後面補0。

舉例說明:

```xs
Var: Str1(""), Str2(""), Str3("");

Value1 = 144.5;

Str1 = NumToStr(Value1, 0);  // Str1 = "145"
Str2 = NumToStr(Value1, 1);  // Str2 = "144.5"
Str3 = NumToStr(Value2, 2);  // Str3 = "144.50"
```

在上例內，Str1的字串值是144.5四捨五入後換算的結果 "145"，而Str3的字串值則在小數位數1之後補0，以確保有兩位小數 "144.50"。

請參考StrToNum函數。

## RightStr（取字串的右邊子字串）

**語法**：回傳字串的右邊子字串
子字串 = RightStr(原始字串，字元長度)

這個函數傳入兩個參數：

- 第一個參數是原始字串

- 第二個參數是欲取出的字元個數

回傳值是從原始字串右邊開始長度為第二個參數的子字串。

```xs
Var: str1("");

str1 = RightStr("abcdefg", 3);  // str1 = "efg"
```

在上面範例內，str1是"abcdefg"從右邊算起長度為3的子字串，"efg"。

請參考 LeftStr函數 以及 MidStr函數。

## StrCompare（字串比較）

**語法**：比較字串是否相同
數值 = StrCompare(字串1, 字串2)
數值 = StrCompare(字串1, 字串2, 不區分大小寫)
傳入二個以上參數:
- 第一個參數是字串1。
- 第二個參數是字串2。
- 第三個參數是選用參數，True表示不區分大小寫，False代表區分大小寫，預設為不區分大小寫。

比較二個字串是否相同
當回傳值為 0 時，表示字串1和字串2一樣。
當回傳值為 1 時，表示字串1順序大於字串2。
當回傳值為 -1 時，表示字串1順序小於字串2。

```xs
//預設為不區分大小寫，所以下列二種得到的結果是一樣的
if StrCompare(symbol,"2330.tw") = 0 then plot1(1) else plot1(0);
if StrCompare(symbol,"2330.TW") = 0 then plot2(1) else plot2(0);
//假設主商品是台積電，當區分為大小寫時，plot3會是0、plot4會是1
if StrCompare(symbol,"2330.tw",false) = 0 then plot3(1) else plot3(0);
if StrCompare(symbol,"2330.TW",false) = 0 then plot4(1) else plot4(0);
```

## StrEndWith（判斷第一個字串的結尾是否與第二個字串的完整內容相同）

**語法**：condition1 = StrEndWith(字串1, 字串2);
condition1 = StrEndWith(字串1, 字串2, 比對方式);

- 傳入兩個字串，判斷第一個字串的結尾是否與第二個字串的完整內容相同。
- 回傳布林值。
- 預設的比對方式是不分大小寫，可以傳入第三個參數指定比對的方式，True表示不區分大小寫。

此函數可以用來比較傳入的第一個字串結尾字母是否和第二個字串相同。
預設的比對方是不區分字母大小寫，但可以透過傳入第三個參數來改變。

範例：

```xs
condition1 = StrEndWith(“ABCDEFG”, “DEFG”);
//回傳 True。

condition1 = StrEndWith(“ABCDEFG”, “ABC”);
//回傳 False。

condition1 = StrEndWith(“ABCDEFG”, “defg”)
//回傳 True。(預設是不區分大小寫)

condition1 = StrEndWith(“ABCDEFG”, “defg”, false);
//回傳 False。
```

## StrLen（回傳字串長度）

**語法**：回傳字串的長度
字串長度 = StrLen(字串)

範例如下:

```xs
Value1 = StrLen("abcdefg");  // Value1 = 7
```

## StrSplit（將一個字串依照指定的分隔字串切割成多個子字串）

**語法**：value1 = StrSplit(字串, 分隔字元, 輸出陣列);

- 把一個字串依照指定的分隔字串切割成多個子字串。
- 需傳入三個參數，第一個參數是要切割的字串，第二個參數是分隔字串，第三個參數是一個一維的字串陣列。
- 切割後的子字串會依序放入輸出陣列內，如果陣列的大小已經固定，則至多只會放入這麼多個子字串，如果陣列是動態陣列，則當陣列空間不夠時，系統會自動調整陣列的大小，以便放入所以切割出來的子字串。
- 回傳值為切割得到的子字串的個數。

此函數可以把第一個字串參數用第二個字串參數切割後放入的第三個參數陣列中。

範例：

```xs
Array: tokens[](""), tokens2[3]("");

value1 = StrSplit("A,B,C,D,E", ",", tokens);
value2 = StrSplit("A,B,C;D,E", ",", tokens2);
```

value1 會是5。
tokens因為是動態陣列，所以會被自動調整成5個元素的大小。
tokens[1] = "A", tokens[2] = "B", tokens[3]="C", tokens[4]="D", tokens[5]="E"。

因為tokens2的大小已經固定，所以value2會是3。
tokens2[1] = "A", tokens2[2] = "B", tokens2[3] = "C;D"。

## StrStartWith（判斷第一個字串的開頭是否與第二個字串的完整內容相同）

**語法**：condition1 = StrStartWith(字串1, 字串2);
condition1 = StrStartWith(字串1, 字串2, 比對方式);

- 傳入兩個字串, 判斷第一個字串的開頭是否與第二個字串的完整內容相同。
- 回傳布林值。
- 預設的比對方式是不分大小寫，可以傳入第三個參數指定比對的方式，True表示不區分大小寫。

此函數可以用來比較傳入的第一個字串開頭字母是否和第二個字串相同。
預設的比對方是不區分字母大小寫，但可以透過傳入第三個參數來改變。

範例：

```xs
condition1 = StrStartWith(“ABCDEFG”, “ABC”);
//回傳 True。

condition1 = StrStartWith(“ABCDEFG”, “DEF”);
//回傳 False。

condition1 = StrStartWith(“ABCDEFG”, “abc”);
//回傳 True。(預設是不區分大小寫)

condition1 = StrStartWith(“ABCDEFG”, “abc”, false);
//回傳 False。
```

## StrToNum（把字串轉成數值）

**語法**：將傳入的字串轉成數值後回傳
回傳數值 = StrToNum(字串)

範例：

```xs
Value1 = StrToNum("123.45");  // Value1 = 123.45
```

請參考NumToStr函數。

## StrTrim（去除字串開頭及結尾的空白後回傳字串）

**語法**：str1 = StrTrim(字串);
str1 = StrTrim(字串, 選項);

- 傳入字串後，去除這個字串開頭以及結尾的空白後回傳字串。
- 預設是刪除空白。
- 可以傳入第二個參數選項，指定刪除的範圍。
- 選項是一個數字，0 = 頭尾都刪除(如同預設)， 1 = 只去除開頭的空白，2 = 只去除結尾的空白。

此函數可以用來刪除字串中的開頭和結尾的空白字元，預設是將開頭與結尾的空白都刪除，但可以透過傳入參數的方式來指定只刪除開頭或結尾。

範例：

```xs
str1 = StrTrim("  hello world ");
//回傳的字串會是"hello world"。

str1 = StrTrim("  hello world ", 0);
//回傳的字串會是 "hello world"。

str1 = StrTrim("  hello world ", 1);
//回傳的字會是 "hello world "。

str1 = StrTrim("  hello world ", 2);
//回傳的字串會是"  hello world"。
```

## Text（將多個參數組成一個字串）

**語法**：傳入多個參數，回傳由這些參數連結而成的一個字串
回傳字串 = Text(參數1, 參數2, 參數3, ...)

Text函數可以傳入多個參數，使用逗號分隔。函數執行完成後會把這些參數一一轉成對應的字串後再將這些字串連結成一個大字串後回傳。

舉例:

```xs
Variables: str("");

str = Text("Close=", 10);
```

上述範例執行之後 str變數的值會變成 "Close=10"。

這個函數可以搭配Print函數來控制印出來的結果。

## UpperStr（把字串改成大寫）

**語法**：把字串的每個英文字元轉成大寫
回傳字串 = UpperStr(原始字串)

範例如下:

```xs
Var: str1("");

str1 = UpperStr("abcdefg");  // str1 = "ABCDEFG"
```

請參考LowerStr函數
