# 內建函數 - 陣列函數（ARRAYFUNC）

> 來源：https://xshelp.xq.com.tw/XSHelp/lists?a=ARRAYFUNC（官方 XSHelp，自動爬取）

## Array_Compare（比較陣列內元素）

**語法**：比較陣列A跟陣列B內的元素
Array_Compare(陣列A, 陣列A開始比對的位置, 陣列B, 陣列B開始比對的位置, 比對的個數)
如果陣列A比較大則回傳1，如果陣列B比較大則回傳-1，如果相同的話則回傳0，例外情形回傳-2

比對執行的方式如下:

- 先比較 **陣列A[比對開始位置]** 跟 **陣列B[比對開始位置]** 這兩個數值，如果陣列A的值比較大的話則回傳1，如果陣列B的值比較大的話則回傳-1，否則繼續比對兩個陣列的下一個數值(**陣列A[比對開始位置+1]** 與 **陣列B[比對開始位置+1]**)。

- 同樣的，如果陣列A的值比較大的話則回傳1，如果陣列B的值比較大的話則回傳-1，否則繼續比對下去直到比對個數超過為止。

- 如果比到最後都是一樣的話，則回傳0。

- 如果比對的範圍超過Array的大小的話，則回傳-2。

舉例:

```xs
Array: arrA[5](0); // 宣告arrA是一個有5個元素的陣列，初始值都是0
Array: arrB[5](0); // 宣告arrB是一個有5個元素的陣列，初始值都是0
Array: arrC[5](0); // 宣告arrC是一個有5個元素的陣列，初始值都是0

arrA[1] = 0;  arrA[2] = 10; arrA[3] = 20; arrA[4] = 30; arrA[5] = 40;
arrB[1] = 0;  arrB[2] = 0;  arrB[3] = 10; arrB[4] = 20; arrB[5] = 30;
arrC[1] = 0;  arrC[2] = 20; arrC[3] = 30; arrC[4] = 40; arrC[5] = 50;

Value1 = Array_Compare(arrA, 1, arrB, 1, 3); // 範例1: Value1 = 1
Value2 = Array_Compare(arrA, 1, arrC, 1, 3); // 範例2: Value2 = -1
Value3 = Array_Compare(arrA, 1, arrB, 2, 3); // 範例3: Value3 = 0
Value4 = Array_Compare(arrA, 1, arrB, 1, 8); // 範例4: Value4 = -2
```

第一個範例比對arrA的第一個位置開始的三個數字跟arrB的第一個位置開始的三個數字，也就是比對 (arrA[1], arrA[2], arrA[3])這三個數字與 (arrB[1], arrB[2], arrB[3])這三個數字的差異。其中 arrA的三個數字分別為 (0, 10, 20), 而 arrB的三個數字分別為 (0, 0, 10)。比對時兩邊的第一個數字是相同的(都是0)，而第二個數字 arrA的10 > arrB的0，所以回傳1。

第二個範例比對arrA的第一個位置開始的三個數字跟arrC的第一個位置開始的三個數字，也就是比對 (arrA[1], arrA[2], arrA[3])這三個數字與 (arrC[1], arrC[2], arrC[3])這三個數字的差異。其中 arrA的三個數字分別為 (0, 10, 20), 而 arrC的三個數字分別為 (0, 20, 30)。比對時兩邊的第一個數字是相同的(都是0)，而第二個數字 arrA的10 < arrC的20，所以回傳-1。

第三個範例比對arrA的第一個位置開始的三個數字跟arrB的第二個位置開始的三個數字，也就是比對 (arrA[1], arrA[2], arrA[3])這三個數字與 (arrB[2], arrB[3], arrB[4])這三個數字的差異。其中 arrA的三個數字分別為 (0, 10, 20), 而 arrB的三個數字分別為 (0, 10, 20)。由於這三個數字都一樣，所以回傳0。

第四個範例內，從第一個位置開始比，總共比8個，可是陣列內只有5個元素，超過範圍，於是回傳-2。

## Array_Copy（複製陣列的元素）

**語法**：把陣列A的元素複製到陣列B內
Array_Copy(陣列A, 陣列A開始複製的位置, 陣列B, 陣列B開始儲存複製資料的位置, 複製的個數)
如果成功則回傳0，否則回傳小於0的錯誤碼

請參考以下範例:

```xs
Array: arrA[5](0); // 宣告arrA是一個有5個元素的陣列，初始值都是0
Array: arrB[5](0); // 宣告arrB是一個有5個元素的陣列，初始值都是0
Array: arrC[5](0); // 宣告arrC是一個有5個元素的陣列，初始值都是0

arrA[1] = 1;  arrA[2] = 2; arrA[3] = 3; arrA[4] = 4; arrA[5] = 5;

Array_Copy(arrA, 1, arrB, 1, 5); // 執行後 arrB = [1, 2, 3, 4, 5]
Array_Copy(arrA, 1, arrC, 2, 3); // 執行後 arrC = [0, 1, 2, 3, 0]
```

第一個範例內，指定從arrA的第一個位置開始複製到arrB的第一個位置，總共複製5個元素，所以執行完成後arrB的內容會是[1, 2, 3, 4, 5]，剛好跟arrA的數值完全一樣。

第二個範例內，指定從arrA的第一個位置開始複製到arrC的第二個位置，總共複製3個元素，也就是說:

- arrA[1] 複製到 arrC[2]

- arrA[2] 複製到 arrC[3]

- arrA[3] 複製到 arrC[4]

所以執行完成後 arrC的內容會是 [0, 1, 2, 3, 0]，注意到arrC的初始值為0，所以沒有被複製到的位置還是保留初始值。

## Array_GetMaxIndex（取得陣列內的元素個數）

**語法**：取得陣列內的元素個數
元素個數 = Array_GetMaxIndex(陣列變數)

回傳陣列內的元素個數。

```xs
Array: arrA[5](0); // 宣告arrA是一個有5個元素的陣列，初始值都是0

Value1 = Array_GetMaxIndex(arrA);  // Value1 = 5
```

我們可以利用這個函數來動態取得陣列的大小，讓程式更容易維護：

```xs
Array: arrA[5](0); // 宣告arrA是一個有5個元素的陣列，初始值都是0
Var: I(0);

For I = 1 To Array_GetMaxIndex(arrA)
Begin
  arrA[I] = arrA[I] + 1;
End;
```

在上述範例內雖然我們已經知道arrA的大小為5，可是我們還是可以利用 Array_GetMaxIndex 來取得 arrA 的大小。未來程式如果有需要調整arrA的大小時，程式內迴圈的程式碼可以不需要修改，方便程式的維護。

## Array_GetType（取得陣列資料類型）

**語法**：回傳陣列的資料類型
資料類型 = Array_GetType(陣列)
回傳數值如果是2，表示為邏輯值True/False陣列，如果是3，表示為字串陣列，如果是7，則表示為數值陣列

請看下列範例程式跟註解說明:

```xs
Array: arrNumber[5](0);
Array: arrString[5]("");
Array: arrBoolean[5](true);

Value1 = Array_GetType(arrNumber);  // Value1 = 7
Value2 = Array_GetType(arrString);     // Value2 = 3
Value3 = Array_GetType(arrBoolean); // Value3 = 2
```

## Array_SetMaxIndex（重設陣列大小）

**語法**：重新設定陣列的大小
僅支援一維陣列
Array_SetMaxIndex(陣列，陣列內的元素個數)

設定動態陣列的大小。

```xs
Var: Count(0);
Array: NumArray[](0);

If High > Highest(High,20)[1] Then Count = Count + 1;

Array_SetMaxIndex(NumArray, Count);
NumArray[Count] = High;
```

在上述範例內，我們希望可以儲存破20期新高的所有價格。由於執行過程內可能會發生多次創新高的情形，所以我們使用陣列來儲存這些創新高的價位。又由於無法知道創新高的出現次數，所以程式使用動態陣列來儲存這些價格。在上面的範例內，Count就是目前已經創新高的個數，而當又出現創新高的情形時，程式就使用Array_SetMaxIndex來擴充陣列的大小。

## Array_SetValRange（重設陣列值）

**語法**：把陣列內某段元素改成指定的數值
Array_SetValRange(陣列，開始位置，結束位置，新設定的數值)

Array_SetValRange需要傳入四個參數:

- 第一個參數是陣列變數，

- 第二個參數是設定數值的開始位置，位置從1開始，

- 第三個參數是設定數值的結束位置，位置從1開始，

- 第四個參數是要設定的數值

執行時，從這個陣列的開始位置一直到結束位置的每個元素的數值都會被改成為新設定的數值。

```xs
Array: arr[5](0); // 宣告arrA是一個有5個元素的陣列，初始值都是0

arr[1] = 1;  arr[2] = 2; arr[3] = 3; arr[4] = 4; arr[5] = 5;

Array_SetValRange(arr, 1, 3, 0); // arr[1] = 0, arr[2] = 0, arr[3] = 0, arr[4] = 4, arr[5] = 5
```

在上例內呼叫Array_SetValRange，位置從1到3，新設定的數值為0。所以執行結束後arr[1], arr[2], arr[3]的數值都會被改成0，而arr[4]跟arr[5]的值則維持不變。

## Array_Sort（陣列排序）

**語法**：把陣列內的某段元素進行排序。
Array_Sort(陣列，執行排序的開始位置，執行排序的結束位置，排序的順序)
排序的順序如果是true的話則由小排到大，如果是false的話則由大排到小

Array_Sort需要傳入四個參數:

- 第一個參數是要排序的陣列變數，

- 第二個參數是這個陣列內執行排序的開始位置。位置從1開始，

- 第三個參數是這個陣列內執行排序的結束位置。位置從1開始，

- 第四個參數決定排序的順序，如果是**true**的話，則由小排到大，如果是**false**的話，則由大排到小，

執行後這個陣列內指定範圍內元素將會依照指定的排序方式重新排列。

舉例:

```xs
Array: arr[5](0); // 宣告arrA是一個有5個元素的陣列，初始值都是0

arr[1] = 1;  arr[2] = 3; arr[3] = 5; arr[4] = 2; arr[5] = 4;

Array_Sort(arr, 1, 5, true);   // arr = [1, 2, 3, 4, 5]
Array_Sort(arr, 1, 5, false);  // arr = [5, 4, 3, 2, 1]
```

上例內第一次呼叫Array_Sort時，傳入的順序是true，所以會從小排到大，執行完成後arr的內容變成
[1, 2, 3, 4, 5]。

第二次呼叫Array_Sort時，傳入的順序是false，所以會從大排到小，執行完成後arr的內容變成[5, 4, 3, 2, 1]。

## Array_Sort2d（二維陣列排序）

**語法**：把二維陣列內的某段元素進行排序。
Array_Sort2d(陣列，執行排序的開始位置，執行排序的結束位置，排序的比較欄位，排序的順序)
排序的順序如果是true的話則由小排到大，如果是false的話則由大排到小

Array_Sort2d需要傳入五個參數:

- 第一個參數是要排序的二維陣列變數，

- 第二個參數是這個陣列內執行排序的開始位置。位置從1開始，

- 第三個參數是這個陣列內執行排序的結束位置。位置從1開始，

- 第四個參數是決定排序的基準位置。位置從1開始，

- 第五個參數決定排序的順序，如果是**true**的話，則由小排到大，如果是**false**的話，則由大排到小，

執行後這個陣列內指定範圍內元素將會依照指定的排序方式重新排列。

舉例:

```xs
Array: datum[15, 6](0); // 宣告datum是一個有15（列）6（行）的二維陣列，初始值都是0
var:i(0);

for i = 1 to 15 begin
   datum[i, 1] = time[i];
   datum[i, 2] = open[i];
   datum[i, 3] = high[i];
   datum[i, 4] = low[i];
   datum[i, 5] = close[i];
   datum[i, 6] = volume[i];
end;

array_sort2d(datum, 1, 15, 6, true); //datum = [最小volume, 次小volume, ... 最大volume]
array_sort2d(datum, 1, 15, 6, false); //datum = [最大volume, 次大volume, ... 最小volume]
```

上例內第一次呼叫array_sort2d時，傳入的順序是true，所以會從小排到大，執行後datum的內容以第六行排序，排序後同列的資料會以第六行為基準一起移動。

第二次呼叫array_sort2d時，傳入的順序是false，所以會從大排到小，執行後datum的內容以第六行排序，排序後同列的資料會以第六行為基準一起移動。

## Array_Sum（取得陣列內元素的加總）

**語法**：回傳陣列內元素的加總數值
加總數值 = Array_Sum(陣列, 開始位置, 結束位置)

Array_Sum除了要傳入陣列變數之外，尚須傳入要進行加總的開始位置跟結束位置。

舉例:

```xs
Array: arr[5](0); // 宣告arrA是一個有5個元素的陣列，初始值都是0

arr[1] = 1;  arr[2] = 2; arr[3] = 3; arr[4] = 4; arr[5] = 5;

Value1 = Array_Sum(arr, 1, 5); // Value1 = 15 (1 + 2 + 3 + 4 + 5)
Value2 = Array_Sum(arr, 1, 3); // Value2 = 6 (1 + 2 + 3)
```

上例內Value1是arr這個陣列從第一個元素加總到第五個元素的數值，也就是等於arr[1] + arr[2] + arr[3] + arr[4] + arr[5] = 15，而Value2則是從第一個元素到第三個元素的加總 (1 + 2 + 3 = 6)。
