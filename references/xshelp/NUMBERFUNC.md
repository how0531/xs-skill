# 內建函數 - 數學函數（NUMBERFUNC）

> 來源：https://xshelp.xq.com.tw/XSHelp/lists?a=NUMBERFUNC（官方 XSHelp，自動爬取）

## AbsValue（取得絕對值）

**語法**：取絕對值。傳回無正負號的數值
回傳數值 = AbsValue(數值)

AbsValue函數用來計算傳入數值的**絕對值**。舉例而言：

```xs
Value1 = Abs(3);
Value2 = Abs(-3);
```

在上面範例內, Value1跟Value2的數值都是3。

以下使用AbsValue來計算兩條均線的差異，由於腳本只關心差異的大小，所以使用AbsValue函數來取得絕對值，不用考慮正負號。

```xs
Value1 = Average(Close, 5);
Value2 = Average(Close, 10);
Value3 = AbsValue(Value1 - Value2);
If Value3 <= 0.01 * Close Then Ret = 1;
```

## ArcCosine（反餘弦函數）

**語法**：計算反餘弦函數，請傳入絕對值小於 1 的數字。
角度 = ArcCosine(數值)

ArcCosine函數用來計算三角函數的反餘絃函數。

輸入數值後，算出對應的角度。

範例:

```xs
Value1 = ArcCosine(0.5);  // Value1 = 60
```

## ArcSine（反正弦函數）

**語法**：計算反正弦函數，請傳入絕對值小於 1 的數字。
角度 = ArcSine(數值)

計算三角函數的反正絃函數。
輸入數值後，算出對應的角度。

範例:

```xs
Value1 = ArcSine(0.5);  // Value1 = 30
```

## ArcTangent（反正切函數）

**語法**：計算反正切函數
角度 = ArcTangent(數值)

計算三角函數的反正切函數。

輸入數值後，算出對應的角度。

範例:

```xs
Value1 = ArcTangent(1);  // Value1 = 45
```

## AvgList（計算平均值）

**語法**：傳入數個數值，回傳這些數值的的平均值。
回傳平均值 = AvgList(數值1, 數值2, 數值3, ..)

使用AvgList時可以傳入多個數值，數值之間使用逗號分隔，例如：

```xs
Value1 = AvgList(Open, High, Low);
```

上述範例內使用AvgList來計算Typical Price ((開盤價 + 最高價 + 最低價) / 3)。

請注意: 如果要計算序列型的數值的平均值的話，則可以使用Average函數。

## Ceiling（小數無條件進位後轉成整數）

**語法**：把小數無條件進位後轉成整數
回傳數值 = Ceiling(數值)

回傳小數點無條件進位後的整數。

範例:

```xs
Value1 = Ceiling(10.0);  // Value1 = 10.0
Value2 = Ceiling(10.1);  // Value2 = 11.0
```

## Combination（計算集合可能的組合個數）

**語法**：計算從集合個數M內取出N個元素的可能組合數目
回傳數值 = Combination(集合個數M, 欲取出的個數N)

計算從N個不同數字的集合內取出M個不同數字的可能組合個數。

範例

```xs
Value1 = Combination(3, 2); // Value1 = 3
```

假設母集合有三個數字 A, B, C, 則取出任意兩個數字的可能組合數 = (A,B), (B,C), (A,C) 共三種。

請參考 Permutation函數

## Cos（餘弦函數）

**語法**：計算角度的餘弦值
餘弦值 = Cos(角度)

計算三角函數的餘絃函數。

輸入角度後回傳餘弦值。

範例:

```xs
Value1 = Cos(60);  // Value1 = 0.5
```

## Cosine（餘弦函數）

**語法**：計算角度的餘弦值
數值 = Cosine(角度)

計算三角函數的餘絃函數。與Cos函數相同。

## CoTangent（餘切函數）

**語法**：計算餘切函數。
回傳數值 = CoTangent(角度)

計算三角函數的餘切函數。

輸入角度後回傳餘切值。

範例:

```xs
Value1 = CoTangent(45);  // Value1 = 1.0
```

## ExpValue（計算自然對數的次方）

**語法**：計算自然對數次方運算後的數值
回傳數值 = ExpValue(數值)

計算自然對數次方運算後的數值。

回傳結果為 **e**(自然對數, 約等於2.718281828)的N次方。

```xs
Value1 = ExpValue(1);  // Value1 = 2.718281828
```

請參考Log函數。

## Factorial（計算數字的階乘）

**語法**：計算數字的階乘結果
回傳數值 = Factorial(數字)

階乘函數就是由1開始遞增連乘到該整數。例如3的階乘數(3!) = 1 * 2 * 3 = 6。

範例:

```xs
Value1 = Factorial(3); // Value1 = 6
```

## Floor（小數無條件捨去後轉成整數）

**語法**：把小數無條件捨去後轉成整數
回傳數值 = Floor(數值)

回傳數值的整數部分，小數點後的數字無條件捨去。

範例:

```xs
Value1 = Floor(10.5); // Value1 = 10
```

請參考 Ceiling函數 以及 Round函數

## FracPortion（回傳數值的小數部分）

**語法**：計算數值的小數部分
回傳數值 = FracPortion(數值)

範例:

```xs
Value1 = IntPortion(10.5);   // Value1 = 10
Value2 = FracPortion(10.5);  // Value2 = 0.5
```

請參考 IntPortion函數。

## IntPortion（回傳數值的整數部分）

**語法**：計算傳入數值的整數部分的數值
回傳數值 = IntPortion(數值)

範例:

```xs
Value1 = IntPortion(10.5);   // Value1 = 10
Value2 = FracPortion(10.5);  // Value2 = 0.5
```

請參考 FracPortion函數。

## Log（計算自然對數）

**語法**：取以e為底的對數值，請傳入大於0的數字。
回傳數值 = Log(數值)

回傳以**e**(自然對數)為底的對數值。

```xs
Value1 = ExpValue(1);
Value2 = Log(Value1);  // 約等於1
```

請參考ExpValue函數。

## MaxList（計算最大值）

**語法**：計算多個數值內的最大值
回傳數值 = MaxList(數值1, 數值2, 數值3, ..)

MaxList可以傳入多個數值，數值之間使用逗號分開。

以下是範例:

```xs
Value1 = Average(Close, 5);
Value2 = Average(Close, 10);
Value3 = Average(Close, 20);
If Open < MinList(Value1, Value2, Value3) And
   Close > MaxList(Value1, Value2, Value3)
Then Ret = 1;
```

在這個腳本內使用MaxList來算出5日/10日/20日均線的最大值。當開盤價低於均線且收盤價站上均線時觸發訊號。

腳本內同時使用到MinList函數，這個函數的用法類似MaxList，傳入多個數值後回傳這些數值的最小值。

## MaxList2（計算最2大值）

**語法**：計算多個數值內的最2大值
回傳數值 = MaxList2(數值1, 數值2, 數值3, ..)

MaxList2可以傳入多個數值，數值之間使用逗號分開。

範例:

```xs
Value1 = MaxList2(1, 2, 3, 4, 5);  // Value1 = 4;
```

## MinList（計算最小值）

**語法**：計算多個數值內的最小值
回傳數值 = MinList(數值1, 數值2, 數值3, ..)

MinList可以傳入多個數值，數值之間使用逗號分開。

以下是一個腳本範例:

```xs
Value1 = Average(Close, 5);
Value2 = Average(Close, 10);
Value3 = Average(Close, 20);
If Open < MinList(Value1, Value2, Value3) And
   Close > MaxList(Value1, Value2, Value3)
Then Ret = 1;
```

在這個腳本內使用MinList來算出5日/10日/20日均線的最小值。當開盤價低於均線且收盤價站上均線時觸發訊號。

腳本內同時使用到MaxList函數，這個函數的用法類似MinList，傳入多個數值後回傳這些數值的最大值。

## MinList2（計算最2小值）

**語法**：計算多個數值內的最2小值
回傳數值 = MinList2(數值1, 數值2, 數值3, ..)

MinList2可以傳入多個數值，數值之間使用逗號分開。

範例:

```xs
Value1 = MinList2(1, 2, 3, 4, 5);  // Value1 = 2;
```

## Mod（回傳兩數相除後的餘數）

**語法**：計算傳入的兩個數值相除後的餘數
餘數 = Mod(被除數，除數)

範例:

```xs
Value1 = Mod(10, 2); // Value1 = 0 (可以整除)
Value2 = Mod(10, 3); // Value2 = 1(不能整除，除完後餘1)
```

## Neg（計算數值的負絕對值）

**語法**：將輸入的數值轉成負的絕對值
回傳數值 = Neg(數值)

範例

```xs
Value1 = Neg(5);  // Value1 = -5
Value2 = Neg(-5);  // Value2 = -5
```

請參考Pos函數。

## NthMaxList（取第N大的數值）

**語法**：傳入多個數值，回傳這些數值內由大到小排名第幾的數字。
回傳數值 = NthMaxList(排名位置, 數值1, 數值2, 數值3, ..)

**排名位置**從1開始，1表示是回傳排名第一(最大)的數字，2表示回傳排名第二(次大)的數字，以下類推。在**排名位置**之後可以傳入任意個數值，使用逗號分開。

舉例:

```xs
Value1 = NthMaxList(1, 50, 50, 40, 30);  // Value1 = 50
Value2 = NthMaxList(2, 50, 50, 40, 30);  // Value2 = 50
Value3 = NthMaxList(3, 50, 50, 40, 30);  // Value3 = 40
Value4 = NthMaxList(4, 50, 50, 40, 30);  // Value4 = 30
```

上述計算 50, 50, 40, 30 這四個數字由大到小的排名數字。請注意傳入的數值內有兩個50，分居排名1跟2。

另外一個範例:

```xs
Value1 = NthMaxList(1, Close, Close[1], Close[2], Close[3], Close[4]);
Value2 = NthMaxList(5, Close, Close[1], Close[2], Close[3], Close[4]);
```

使用NthMaxList取得近5日的最高收盤價以及最低收盤。

當排名位置為1時，NthMaxList函數等同於MaxList函數。當排名位置為最後一名時，NthMaxList函數等同於MinList函數。

## NthMinList（取第N小的數值）

**語法**：傳入多個數值，回傳這些數值內由小到大排名第幾的數字。
回傳數值 = NthMinList(排名位置, 數值1, 數值2, 數值3, ..)

**排名位置**從1開始，1表示是回傳排名第一(最小)的數字，2表示回傳排名第二(次小)的數字，以下類推。在**排名位置**之後可以傳入任意個數值，使用逗號分開。

舉例:

```xs
Value1 = NthMinList(1, 50, 50, 40, 30);  // Value1 = 30
Value2 = NthMinList(2, 50, 50, 40, 30);  // Value2 = 40
Value3 = NthMinList(3, 50, 50, 40, 30);  // Value3 = 50
Value4 = NthMinList(4, 50, 50, 40, 30);  // Value4 = 50
```

上述計算 50, 50, 40, 30 這四個數字由小到大的排名數字。請注意傳入的數值內有兩個50，分居排名3跟4。

請參考 NthMaxList函數。

## Permutation（計算集合可能的排列個數）

**語法**：計算從集合個數M內取出N個元素的可能排列個數
回傳數值 = Permutation(集合個數M, 欲取出的個數N)

計算從N個不同數字的集合內取出M個不同數字的可能排列個數。

範例:

```xs
Value1 = Permutation(3, 2);  // Value1 = 6
```

假設母集合有三個數字 A, B, C, 則取出任意兩個不同數字的可能排列方式 = (A,B), (A,C), (B,A), (B,C), (C,A), (C,B) 共六種。

請參考 Combination函數

## Pos（計算數值的正數值）

**語法**：將輸入的數值轉為正數。
回傳數值 = Pos(數值)

這個函數的結果與AbsValue函數相同。

```xs
Value1 = Pos(-10);  // Value1 = 10
Value2 = Pos(10);  // Value2 = 10
```

## Power（計算數字乘冪）

**語法**：計算數字的乘冪數值
回傳數值 = Power(底數, 指數)

範例:

```xs
Value1 = Power(10, 2);  // Value1 = 10的2次方 = 100
```

## Random（回傳亂數值）

**語法**：回傳一個介於0跟傳入數值之間的隨機亂數
隨機亂數 = Random(最大亂數的範圍)

範例:

```xs
Value1 = Random(10);
```

Value1的數值會是一個介於0跟10之間的隨機數字 (0 <= Value1 And Value1 < 10)，而且每次執行時Value1的數值都會不相同。

一般而言會在計算統計相關數字時使用隨機數字來模擬可能的數值分配情境。

## Round（執行小數的四捨五入運算）

**語法**：回傳數值四捨五入後的結果，可以指定小數位數。
回傳數值 = Round(數值，小數位數)

範例:

```xs
Value1 = Round(10.547, 0); // Value1 = 11
Value2 = Round(10.547, 1); // Value1 = 10.5
Value3 = Round(10.547, 2); // Value1 = 10.55
```

請參考 Ceiling函數 以及 Floor函數

## Sign（數值的正負號）

**語法**：回傳數值的正負號
回傳數值 = Sign(數值)
如果是正數，回傳1，如果是負數，回傳-1，如果是0，則回傳0

範例:

```xs
Value1 = Sign(10);  // Value1 = 1
Value2 = Sign(-10); // Value2 = -1
Value3 = Sign(0);   // Value3 = 0
```

## Sin（正弦值）

**語法**：計算角度的正弦值
正弦值 = Sin(角度)

計算三角函數的正絃函數。

輸入角度後回傳正弦值。

範例:

```xs
Value1 = Sin(30);  // Value1 = 0.5
```

## Sine（正弦值）

**語法**：計算角度的正弦值
正弦值 = Sine(角度)

計算三角函數的正絃函數，與Sin函數相同。

## Square（計算數值的平方）

**語法**：計算傳入數值的平方
回傳數值 = Square(數值)

範例:

```xs
Value1 = Square(10);  // Value1 = 100
```

請參考 SquareRoot函數。

## SquareRoot（計算數值的平方根）

**語法**：計算傳入數值的平方根，請傳入大於0的數字。
回傳數值 = SquareRoot(數值)

範例:

```xs
Value1 = SquareRoot(100);  // Value1 = 10
```

請參考 Square函數。

## SumList（計算加總）

**語法**：傳入數個數值，回傳這些數值的的加總
回傳加總值 = SumList(數值1, 數值2, 數值3, ..)

使用SumList時可以傳入數個數值，數值之間用逗號隔開。

範例:

```xs
Value1 = SumList(Open, High, Low, Close) / 4;
```

上述範例內使用SumList來計算平均價格 ((開盤價 + 最高價 + 最低價 + 收盤價) / 4)。

請注意: 如果要計算序列型的數值的加總值的話，則可以使用Summation函數。

## Tan（正切）

**語法**：計算角度的正切值
正切值 = Tag(角度)

計算三角函數的正切函數。

輸入角度，回傳對應的正切值。

範例:

```xs
Value1 = Tan(45);  // Value1 = 1.0
```

## Tangent（正切）

**語法**：計算角度的正切值
正切值 = Tangent(角度)

計算三角函數的正切函數。與Tan函數相同。
