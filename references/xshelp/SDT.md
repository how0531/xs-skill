# 內建函數 - SDT共享資料表（SDT）

> 來源：https://xshelp.xq.com.tw/XSHelp/rest?a=SDT（站內搜尋 API；此家族不在官網分類選單、單頁已損壞）

## SDT_Average（取得SDT行平均值）

**語法**：取得SDT中指定行的數值平均。
回傳數值=SDT_Average(column)
傳入一個參數：
- 第一個參數column：要計算平均的直行，可傳入 1~100 的數字，或直行名稱字串。

回傳SDT指定直行的平均值。

統計前會嘗試將直行值轉為數值，無法轉換的列以 0 計算後納入平均。

## SDT_Average_L（取得SDT行平均值）

**語法**：取得SDT中指定行的數值平均。
回傳數值=SDT_Average_L(column)
傳入一個參數：
- 第一個參數column：要計算平均的直行，可傳入 1~100 的數字，或直行名稱字串。

回傳SDT指定直行的平均值。

統計前會嘗試將直行值轉為數值，無法轉換的列以 0 計算後納入平均。

## SDT_GetKeys（取得SDT所有的key）

**語法**：取得SDT所有的key。
SDT_GetKeys(output_key_array)
傳入一個參數：
- 第一個參數output_key_array：一維字串陣列(輸出用)，函數會將目前所有 key 填入此陣列。

將 SDT 內目前存在的 key 寫入傳入的字串陣列，供腳本逐一取出查詢。

取回的 key 沒有順序保證(存入順序不等於取回順序)；若需依序處理，請改用 SDT_SortKey / SDT_Sort。

## SDT_GetKeys_L（取得SDT所有的key）

**語法**：取得SDT所有的key。
SDT_GetKeys_L(output_key_array)
傳入一個參數：
- 第一個參數output_key_array：一維字串陣列(輸出用)，函數會將目前所有 key 填入此陣列。

將 SDT 內目前存在的 key 寫入傳入的字串陣列，供腳本逐一取出查詢。

取回的 key 沒有順序保證(存入順序不等於取回順序)；若需依序處理，請改用 SDT_SortKey / SDT_Sort。

## SDT_GetString（讀取SDT字串欄位）

**語法**：取得SDT中指定欄位的字串。
回傳字串=SDT_GetString(key, column, default:="")
傳入三個參數(default為選填)：
- 第一個參數key：要讀取的資料列鍵值，字串，大小寫不分。
- 第二個參數column：要讀取的直行，可傳入 1~100 的數字，或直行名稱字串。
- 第三個參數default(選填)：當 key 或 column 不存在時要回傳的預設值，預設為空字串。

回傳SDT指定key列、column行的字串。

若找不到key或column，回傳 default(未指定時為空字串)。

若欄位實際存放的是數值，會自動轉為字串 (例如 12 轉成 "12"，轉換樣式由系統決定)。

## SDT_GetString_L（讀取SDT字串欄位）

**語法**：取得SDT中指定欄位的字串。
回傳字串=SDT_GetString_L(key, column, default:="")
傳入三個參數(default為選填)：
- 第一個參數key：要讀取的資料列鍵值，字串，大小寫不分。
- 第二個參數column：要讀取的直行，可傳入 1~100 的數字，或直行名稱字串。
- 第三個參數default(選填)：當 key 或 column 不存在時要回傳的預設值，預設為空字串。

回傳SDT指定key列、column行的字串。

若找不到key或column，回傳 default(未指定時為空字串)。

若欄位實際存放的是數值，會自動轉為字串 (例如 12 轉成 "12"，轉換樣式由系統決定)。

## SDT_GetValue（讀取SDT數值欄位）

**語法**：取得SDT中指定欄位的數值。
回傳數值=SDT_GetValue(key, column, default:=0)
傳入三個參數(default為選填)：
- 第一個參數key：要讀取的資料列鍵值，字串，可為商品代碼或任意字串，大小寫不分。
- 第二個參數column：要讀取的直行，可傳入 1~100 的數字，或直行名稱字串。
- 第三個參數default(選填)：當 key 或 column 不存在時要回傳的預設值，預設為 0。

回傳SDT指定key列、column行的數值。

若找不到key或column，回傳 default(未指定時為 0)。

若欄位實際存放的是字串，會嘗試自動轉為數值 (例如 "1" 轉成 1)，無法轉換則回傳 0。

## SDT_GetValue_L（讀取SDT數值欄位）

**語法**：取得SDT中指定欄位的數值。
回傳數值=SDT_GetValue_L(key, column, default:=0)
傳入三個參數(default為選填)：
- 第一個參數key：要讀取的資料列鍵值，字串，可為商品代碼或任意字串，大小寫不分。
- 第二個參數column：要讀取的直行，可傳入 1~100 的數字，或直行名稱字串。
- 第三個參數default(選填)：當 key 或 column 不存在時要回傳的預設值，預設為 0。

回傳SDT指定key列、column行的數值。

若找不到key或column，回傳 default(未指定時為 0)。

若欄位實際存放的是字串，會嘗試自動轉為數值 (例如 "1" 轉成 1)，無法轉換則回傳 0。

## SDT_HasKey（檢查字串是否存在SDT key 中）

**語法**：判斷傳入的字串是否包含在SDT的key中。
回傳布林值=SDT_HasKey(key)
傳入一個參數：
- 第一個參數key：要檢查的資料列鍵值，字串，大小寫不分。

檢查 SDT 內是否存在指定的key。

存在回傳 True，不存在回傳 False。

## SDT_HasKey_L（檢查字串是否存在SDT key 中）

**語法**：判斷傳入的字串是否包含在SDT的key中。
回傳布林值=SDT_HasKey_L(key)
傳入一個參數：
- 第一個參數key：要檢查的資料列鍵值，字串，大小寫不分。

檢查 SDT 內是否存在指定的key。

存在回傳 True，不存在回傳 False。

## SDT_Max（取得SDT行的最大值與對應key）

**語法**：取得SDT中指定行的最大值以及對應key。
回傳數值=SDT_Max(column)
回傳數值=SDT_Max(column, output_key)
傳入一至兩個參數：
- 第一個參數column：要取最大值的直行，可傳入 1~100 的數字，或直行名稱字串。
- 第二個參數output_key(選填)：字串變數(輸出用)，用以取回最大值所在列的 key。

回傳SDT指定直行的最大值；若傳入output_key，會一併將最大值所在列的 key 寫入該變數。

無法轉為數值的列會被略過；若有多個 key 同為最大值，output_key回傳字串排序較小的 key。

## SDT_Max_L（取得SDT行的最大值與對應key）

**語法**：取得SDT中指定行的最大值以及對應key。
回傳數值=SDT_Max_L(column)
回傳數值=SDT_Max_L(column, output_key)
傳入一至兩個參數：
- 第一個參數column：要取最大值的直行，可傳入 1~100 的數字，或直行名稱字串。
- 第二個參數output_key(選填)：字串變數(輸出用)，用以取回最大值所在列的 key。

回傳SDT指定直行的最大值；若傳入output_key，會一併將最大值所在列的 key 寫入該變數。

無法轉為數值的列會被略過；若有多個 key 同為最大值，output_key回傳字串排序較小的 key。

## SDT_Median（取得SDT行的中位數與對應key）

**語法**：取得SDT中指定行的中位數以及對應key。
回傳數值=SDT_Median(column)
回傳數值=SDT_Median(column, output_key)
傳入一至兩個參數：
- 第一個參數column：要取中位數的直行，可傳入 1~100 的數字，或直行名稱字串。
- 第二個參數output_key(選填)：字串變數(輸出用)，用以取回中位數所在列的 key。

回傳SDT指定直行的中位數；若傳入output_key，會一併將該列的 key 寫入該變數。

無法轉為數值的列會被略過後再計算中位數。

## SDT_Median_L（取得SDT行的中位數與對應key）

**語法**：取得SDT中指定行的中位數以及對應key。
回傳數值=SDT_Median_L(column)
回傳數值=SDT_Median_L(column, output_key)
傳入一至兩個參數：
- 第一個參數column：要取中位數的直行，可傳入 1~100 的數字，或直行名稱字串。
- 第二個參數output_key(選填)：字串變數(輸出用)，用以取回中位數所在列的 key。

回傳SDT指定直行的中位數；若傳入output_key，會一併將該列的 key 寫入該變數。

無法轉為數值的列會被略過後再計算中位數。

## SDT_Min（取得SDT行的最小值與對應key）

**語法**：取得SDT中指定行的最小值以及對應key。
回傳數值=SDT_Min(column)
回傳數值=SDT_Min(column, output_key)
傳入一至兩個參數：
- 第一個參數column：要取最小值的直行，可傳入 1~100 的數字，或直行名稱字串。
- 第二個參數output_key(選填)：字串變數(輸出用)，用以取回最小值所在列的 key。

回傳SDT指定直行的最小值；若傳入output_key，會一併將最小值所在列的 key 寫入該變數。

無法轉為數值的列會被略過；若有多個 key 同為最小值，output_key回傳字串排序較小的 key。

## SDT_Min_L（取得SDT行的最小值與對應key）

**語法**：取得SDT中指定行的最小值以及對應key。
回傳數值=SDT_Min_L(column)
回傳數值=SDT_Min_L(column, output_key)
傳入一至兩個參數：
- 第一個參數column：要取最小值的直行，可傳入 1~100 的數字，或直行名稱字串。
- 第二個參數output_key(選填)：字串變數(輸出用)，用以取回最小值所在列的 key。

回傳SDT指定直行的最小值；若傳入output_key，會一併將最小值所在列的 key 寫入該變數。

無法轉為數值的列會被略過；若有多個 key 同為最小值，output_key回傳字串排序較小的 key。

## SDT_RemoveAll（清空整個 SDT）

**語法**：將整個SDT移除。
SDT_RemoveAll()

一次移除此 SDT 內的所有資料(清空整張表)。

## SDT_RemoveAll_L（清空整個 SDT）

**語法**：將整個SDT移除。
SDT_RemoveAll_L()

一次移除此 SDT 內的所有資料(清空整張表)。

## SDT_RemoveKey（移除指定SDT key）

**語法**：移除指定的SDT key及該列的資料。
SDT_RemoveKey(key)
傳入一個參數：
- 第一個參數key：要移除的資料列鍵值，字串，大小寫不分。

移除SDT指定key所對應的整列資料，包含key一併移除。

## SDT_RemoveKey_L（移除指定SDT key）

**語法**：移除指定的SDT key及該列的資料。
SDT_RemoveKey_L(key)
傳入一個參數：
- 第一個參數key：要移除的資料列鍵值，字串，大小寫不分。

移除SDT指定key所對應的整列資料，包含key一併移除。

## SDT_SetColumnName（設定SDT直行名稱）

**語法**：命名或修改SDT指定行的名稱。
SDT_SetColumnName(column_num, column_name)
傳入兩個參數：
- 第一個參數column_num：要命名的直行序號(數字)。
- 第二個參數：該直行的新名稱(字串)。

將SDT中第column_num行的名稱設定或修改為column_name。

適用於初次以 SDT_SetValue / SDT_SetString 未指定欄名，或需修改既有欄名時。

## SDT_SetColumnName_L（設定SDT直行名稱）

**語法**：命名或修改SDT指定行的名稱。
SDT_SetColumnName_L(column_num, column_name)
傳入兩個參數：
- 第一個參數column_num：要命名的直行序號(數字)。
- 第二個參數column_name：該直行的新名稱(字串)。

將SDT中第column_num行的名稱設定或修改為column_name。

適用於初次以 SDT_SetValue / SDT_SetString 未指定欄名，或需修改既有欄名時。

## SDT_SetString（寫入SDT字串欄位）

**語法**：寫入SDT中指定欄位的字串。
SDT_SetString(key, column, value)
傳入三個參數：
- 第一個參數key：要寫入的資料列鍵值，字串，大小寫不分。
- 第二個參數column：要寫入的直行，可傳入 1~100 的數字，或直行名稱字串。
- 第三個參數value：要寫入的字串。

將字串value寫入SDT指定的key列，column行。

若column為字串且不存在，會在最後一行之後新增該行。

若column傳數字且大於現有行數，會一併補齊中間的空白欄，例如目前有1 ~ 5行，若傳入10則會建立6~10行。

欄號超過 100 或直行總數超過 100 時回傳錯誤。

## SDT_SetString_L（寫入SDT字串欄位）

**語法**：寫入SDT中指定欄位的字串。
SDT_SetString_L(key, column, value)
傳入三個參數：
- 第一個參數key：要寫入的資料列鍵值，字串，大小寫不分。
- 第二個參數column：要寫入的直行，可傳入 1~100 的數字，或直行名稱字串。
- 第三個參數value：要寫入的字串。

將字串value寫入SDT指定的key列，column行。

若column為字串且不存在，會在最後一行之後新增該行。

若column傳數字且大於現有行數，會一併補齊中間的空白欄，例如目前有1 ~ 5行，若傳入10則會建立6~10行。

欄號超過 100 或直行總數超過 100 時回傳錯誤。

## SDT_SetStringIf（SDT條件寫入字串）

**語法**：若SDT指定欄位條件符合的話則寫入字串。
回傳布林值=SDT_SetStringIf(key, column, newvalue, oldvalue)
傳入四個參數：
- 第一個參數key：要寫入的資料列鍵值，字串，大小寫不分。
- 第二個參數column：要寫入的直行，可傳入 1~100 的數字，或直行名稱字串。
- 第三個參數newvalue：欲寫入的新字串。
- 第四個參數oldvalue：預期的目前字串，用以比對。

只有在目前SDT指定欄位字串等於oldvalue時，才會將其覆寫為newvalue並回傳 True；否則不寫入並回傳 False。

此函數可用以確保同一時間點只有一個商品/策略能成功寫入。

## SDT_SetStringIf_L（SDT條件寫入字串）

**語法**：若SDT指定欄位條件符合的話則寫入字串。
回傳布林值=SDT_SetStringIf_L(key, column, newvalue, oldvalue)
傳入四個參數：
- 第一個參數key：要寫入的資料列鍵值，字串，大小寫不分。
- 第二個參數column：要寫入的直行，可傳入 1~100 的數字，或直行名稱字串。
- 第三個參數newvalue：欲寫入的新字串。
- 第四個參數oldvalue：預期的目前字串，用以比對。

只有在目前SDT指定欄位字串等於oldvalue時，才會將其覆寫為newvalue並回傳 True；否則不寫入並回傳 False。

此函數可用以確保同一時間點只有一個商品/策略能成功寫入。

## SDT_SetValue（寫入SDT數值欄位）

**語法**：寫入SDT中指定欄位的數值。
SDT_SetValue(key, column, value)
傳入三個參數：
- 第一個參數key：要寫入的資料列鍵值，字串，大小寫不分。
- 第二個參數column：要寫入的直行，可傳入 1~100 的數字，或直行名稱字串。
- 第三個參數value：要寫入的數值。

將數值value寫入SDT指定的 key列、column行。

若column為字串且不存在，會在最後一行之後新增該行。

若column傳數字且大於現有行數，會一併補齊中間的空白欄，例如目前有1 ~ 5行，若傳入10則會建立6~10行。

欄號超過 100 或直行總數超過 100 時回傳錯誤。

## SDT_SetValue_L（寫入SDT數值欄位）

**語法**：寫入SDT中指定欄位的數值。
SDT_SetValue_L(key, column, value)
傳入三個參數：
- 第一個參數key：要寫入的資料列鍵值，字串，大小寫不分。
- 第二個參數column：要寫入的直行，可傳入 1~100 的數字，或直行名稱字串。
- 第三個參數value：要寫入的數值。

將數值value寫入SDT指定的 key列、column行。

若column為字串且不存在，會在最後一行之後新增該行。

若column傳數字且大於現有行數，會一併補齊中間的空白欄，例如目前有1 ~ 5行，若傳入10則會建立6~10行。

欄號超過 100 或直行總數超過 100 時回傳錯誤。

## SDT_SetValueIf（SDT條件寫入數值）

**語法**：若SDT指定欄位條件符合的話則寫入數值。
回傳布林值=SDT_SetValueIf(key, column, newvalue, oldvalue)
傳入四個參數：
- 第一個參數key：要寫入的資料列鍵值，字串，大小寫不分。
- 第二個參數column：要寫入的直行，可傳入 1~100 的數字，或直行名稱字串。
- 第三個參數newvalue：欲寫入的新數值。
- 第四個參數oldvalue：預期的目前數值，用以比對。

只有在目前SDT指定欄位數值等於oldvalue時，才會將其覆寫為newvalue並回傳 True；否則不寫入並回傳 False。

此函數可用以確保同一時間點只有一個商品/策略能成功寫入。

## SDT_SetValueIf_L（SDT條件寫入數值）

**語法**：若SDT指定欄位條件符合的話則寫入數值。
回傳布林值=SDT_SetValueIf_L(key, column, newvalue, oldvalue)
傳入四個參數：
- 第一個參數key：要寫入的資料列鍵值，字串，大小寫不分。
- 第二個參數column：要寫入的直行，可傳入 1~100 的數字，或直行名稱字串。
- 第三個參數newvalue：欲寫入的新數值。
- 第四個參數oldvalue：預期的目前數值，用以比對。

只有在目前SDT指定欄位數值等於oldvalue時，才會將其覆寫為newvalue並回傳 True；否則不寫入並回傳 False。

此函數可用以確保同一時間點只有一個商品/策略能成功寫入。

## SDT_Sort（依SDT指定行的數值排序）

**語法**：取得依照SDT指定行的數值排序後的key陣列。
SDT_Sort(column, sorted_key_array, order:=-1)
傳入三個參數(order為選填)：
- 第一個參數column：作為排序依據的直行，可傳入 1~100 的數字，或直行名稱字串。
- 第二個參數sorted_key_array：一維字串陣列(輸出用)，用以接收排序後的 key。
- 第三個參數order(選填)：排序方向，-1 為由小到大(預設)，1 為由大到小。

依SDT指定直行的數值作排序，並將排序後的 key 寫入傳入的字串陣列。

欄位值會先轉為數值再排序，無法轉換的列會排在陣列最後面。

## SDT_Sort_L（依SDT指定行的數值排序）

**語法**：取得依照SDT指定行的數值排序後的key陣列。
SDT_Sort_L(column, sorted_key_array, order:=-1)
傳入三個參數(order為選填)：
- 第一個參數column：作為排序依據的直行，可傳入 1~100 的數字，或直行名稱字串。
- 第二個參數sorted_key_array：一維字串陣列(輸出用)，用以接收排序後的 key。
- 第三個參數order(選填)：排序方向，-1 為由小到大(預設)，1 為由大到小。

依SDT指定直行的數值作排序，並將排序後的 key 寫入傳入的字串陣列。

欄位值會先轉為數值再排序，無法轉換的列會排在陣列最後面。

## SDT_SortKey（依SDT key排序）

**語法**：取得依照SDT key排序的陣列。
SDT_SortKey(sorted_key_array, order:=-1)
傳入兩個參數(order為選填)：
- 第一個參數sorted_key_array：一維字串陣列(輸出用)，用以接收排序後的 key。
- 第二個參數order(選填)：排序方向，-1 為由小到大(預設)，1 為由大到小。

依SDT的 key 排序，並將排序後的 key 寫入傳入的字串陣列。

可用來在腳本中依序讀取各列資訊。

## SDT_SortKey_L（依SDT key排序）

**語法**：取得依照SDT key排序的陣列。
SDT_SortKey_L(sorted_key_array, order:=-1)
傳入兩個參數(order為選填)：
- 第一個參數sorted_key_array：一維字串陣列(輸出用)，用以接收排序後的 key。
- 第二個參數order(選填)：排序方向，-1 為由小到大(預設)，1 為由大到小。

依SDT的 key 排序，並將排序後的 key 寫入傳入的字串陣列。

可用來在腳本中依序讀取各列資訊。

## SDT_SortString（依SDT指定行字串排序）

**語法**：取得依照SDT指定行的字串排序後的key陣列。
SDT_SortString(column, sorted_key_array, order:=-1)
傳入三個參數(order為選填)：
- 第一個參數column：作為排序依據的直行，可傳入 1~100 的數字，或直行名稱字串。
- 第二個參數sorted_key_array：一維字串陣列(輸出用)，用以接收排序後的 key。
- 第三個參數order(選填)：排序方向，-1 為由小到大(預設)，1 為由大到小。

依SDT指定直行的字串作排序，並將排序後的 key 寫入傳入的字串陣列。

欄位值會先轉為字串再排序，無法轉換的列會排在結果最後面。

## SDT_SortString_L（依SDT指定行字串排序）

**語法**：取得依照SDT指定行的字串排序後的key陣列。
SDT_SortString_L(column, sorted_key_array, order:=-1)
傳入三個參數(order為選填)：
- 第一個參數column：作為排序依據的直行，可傳入 1~100 的數字，或直行名稱字串。
- 第二個參數sorted_key_array：一維字串陣列(輸出用)，用以接收排序後的 key。
- 第三個參數order(選填)：排序方向，-1 為由小到大(預設)，1 為由大到小。

依SDT指定直行的字串作排序，並將排序後的 key 寫入傳入的字串陣列。

欄位值會先轉為字串再排序，無法轉換的列會排在結果最後面。

## SDT_Sum（取得SDT行加總）

**語法**：取得SDT中指定行的數值加總。
回傳數值=SDT_Sum(column)
傳入一個參數：
- 第一個參數column：要加總的直行，可傳入 1~100 的數字，或直行名稱字串。

回傳SDT中指定直行所有列的數值總和。

統計前會嘗試將直行值轉為數值，無法轉換的列以 0 計算。

## SDT_Sum_L（取得SDT行加總）

**語法**：取得SDT中指定行的數值加總。
回傳數值=SDT_Sum_L(column)
傳入一個參數：
- 第一個參數column：要加總的直行，可傳入 1~100 的數字，或直行名稱字串。

回傳SDT中指定直行所有列的數值總和。

統計前會嘗試將直行值轉為數值，無法轉換的列以 0 計算。
