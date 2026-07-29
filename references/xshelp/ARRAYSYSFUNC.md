# 系統函數 - Array函數（ARRAYSYSFUNC）

> 來源：https://xshelp.xq.com.tw/XSHelp/lists?a=ARRAYSYSFUNC（官方 XSHelp，自動爬取）

## ArrayLinearRegSlope（傳回陣列來計算的線性迴歸斜率）

**語法**：利用陣列來計算的線性迴歸的斜率。
回傳陣列=ArrayLinearRegSlope(陣列,期數)
傳入二個參數:
- 第一個參數是陣列。
- 第二個參數是期數。

利用最小平方法計算線性迴歸的斜率。

## ArrayMASeries（將均線數值序列轉成陣列）

**語法**：將均線數值序列轉成陣列。
回傳陣列=ArrayMASeries(數列,數列期數,陣列)
傳入三個參數:
- 第一個參數是數列。
- 第二個參數是數列期數。
- 第三個參數是陣列。

將某個數值序列的均線轉成陣列型態。

## ArraySeries（將數值序列轉成陣列）

**語法**：將數值序列轉成陣列。
回傳陣列=ArraySeries(數列,數列期數,陣列)
傳入三個參數:
- 第一個參數是數列。
- 第二個參數是數列期數。
- 第三個參數是陣列。

將某個數值序列轉成陣列型態。

## ArrayXDaySeries（以陣列儲存跨頻率的序列值）

**語法**：以陣列儲存跨頻率的序列值。
回傳陣列=ArrayXDaySeries(序列,最大引用筆數,陣列)
傳入三個參數:
- 第一個參數是序列。
- 第二個參數是最大引用筆數。
- 第三個參數是陣列。

以Array儲存跨頻率的序列值，傳入一個序列。

範例：

```xs
Array: CloseArray[](0);
ArrayXDaySeries(GetField("收盤價","D"),SBB_length,_DayValue);
```
