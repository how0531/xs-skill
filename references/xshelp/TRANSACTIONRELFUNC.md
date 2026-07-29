# 系統函數 - 交易相關（TRANSACTIONRELFUNC）

> 來源：https://xshelp.xq.com.tw/XSHelp/lists?a=TRANSACTIONRELFUNC（官方 XSHelp，自動爬取）

## calcvwapdistribution（計算過去N日的VWAP分布）

**語法**：計算過去N日的VWAP分佈。
calcvwapdistribution(計算天數，開始時間，結束時間，一個array)

計算過去N日的VWAP分佈

請傳入

- 計算天數

- 開始時間, 例如091000

- 結束時間, 例如095900 (請注意請以1分K的Time為基準)

- 一個array, 用來儲存上述指定區間內每分鐘的累積成交量分佈%,

- CalcVWAPDistribution會自動設定array的大小,

- array[1]是從開始時間後第1分鐘的累計成交量%, array[2]是從開始時間到後第2分鐘的累計成交量%, etc.

- 請注意這是一個累積的數值, 例如array[1] = 2.5, array[2] = 5.4, array[3] = 7.0, ... array[最後一個]=100.0,

## EnterMarketCloseTime（判斷是否已經進入收盤階段）

**語法**：回傳布林值。
判斷是否已經進入收盤階段：用來判斷不再進場 or 平倉當日部位。
使用時須傳入N，代表在最後可以送單前N分鐘就認定進入收盤階段，
例如如果傳1，而且是台股的話, 那在13:24:00就會回傳True，代表已經進入收盤階段。
※請注意：這個函數只支援台股, 以及台灣期貨市場內的常用商品, 也不考慮部分外匯期貨 or 其他市場期貨, 例如東証指。

可至 XQ 系統的 XScrip 編輯器，開啟「系統-交易相關」資料夾底下的 EnterMarketCloseTime 函數腳本，查看詳細函數語法撰寫邏輯。
