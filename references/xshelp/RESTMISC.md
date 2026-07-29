# 其他 - 搜尋API補遺（RESTMISC）

> 來源：https://xshelp.xq.com.tw/XSHelp/rest 全面掃描（站內搜尋 API；官網分類選單無此分類）

## 撮合狀態（q_MarketState）

**語法**：此欄位會回傳目前的市場狀態。

以下為各種回傳值代表的意義：

- 0 = 正常交易

- 2 = 暫停交易

- 3 = 延緩收盤

- 4 = 開盤前試搓

- 5 = 開盤前試搓/不允許刪改單 (期交所)

- 6 = 收盤前試搓

- 7 = 暫緩開盤

- 8 = 暫停交易後開始試搓(證交所/期交所)

- 9 = 暫停交易後開始試搓/不允許刪改單 (期交所)

## 暫緩撮合狀態（q_CircuitBreakState）

**語法**：此欄位會回傳目前市場是否處於盤中價格穩定措施。

回傳值代表的意義：

0 = 無

1 = 暫緩搓合且趨跌

2 = 暫緩搓合且趨漲

證交所價格穩定措施的流程:

如果盤中發生價格穩定措施時，此時q_MarketState = 0，而q_CircuitBreakState會是1 或 2。

接下來q_MarketState會變成8，此時可以抓到試搓價格。

等到價格穩定措施結束後，q_MarketState 和CircuitBreakState 會變回0，商品恢復正常交易。

如果是開盤時/收盤時發生價格穩定措施的話，則q_MarketState會是7 或 3。

## 試搓成交價（q_SimulatedTradePrice）

**語法**：試搓成交價格。

此欄位會回傳試搓的成交價格。

## 試搓成交日期（q_SimulatedTradeDate）

**語法**：試搓成交日期，格式為YYYYMMDD。

此欄位會回傳試搓的成交日期，格式為YYYYMMDD。

## 試搓成交時間（q_SimulatedTradeTime）

**語法**：試搓成交時間，格式為HHMMSS。

此欄位會回傳試搓的成交時間，格式為HHMMSS。

## 試搓成交量（q_SimulatedTradeVolume）

**語法**：試搓成交數量(單位: 張/口)。

此欄位會回傳試搓的成交數量。
