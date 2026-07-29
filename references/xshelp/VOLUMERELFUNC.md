# 系統函數 - 量能相關（VOLUMERELFUNC）

> 來源：https://xshelp.xq.com.tw/XSHelp/lists?a=VOLUMERELFUNC（官方 XSHelp，自動爬取）

## DiffBidAskVolumeLxL（近15分鐘大戶買賣超）

**語法**：傳回「近15分鐘大戶買賣超」的數值
回傳數值 = DiffBidAskVolumeLxL
僅支援1分鐘頻率與台股商品。

DiffBidAskVolumeLxL為近15分鐘大戶買賣超的函數，
該函數運算出來的數值，與XS指標的「流動大戶買賣力」指標相同。

## DiffBidAskVolumeXL（近15分鐘特大單買賣超張數）

**語法**：傳回「近15分鐘特大單買賣超」的張數
回傳數值 = DiffBidAskVolumeXL
僅支援1分鐘頻率與台股商品。

DiffBidAskVolumeXL為近15分鐘特大單買賣超張數的函數。

範例：

```xs
value1 = DiffBidAskVolumeXL;
plot1(value1); //value1為近15分鐘特大單買賣超張數
```

## DiffTradeVolumeAtAskBid（分時買賣力）

**語法**：傳回「分時買賣力」的數值
回傳數值 = DiffTradeVolumeAtAskBid
僅支援分鐘與日頻率（含還原）
支援台股與期權商品。

DiffTradeVolumeAtAskBid為分時買賣力的函數，
該函數運算出來的數值，與XS指標的「分時買賣力」指標相同。

## DiffUpDownVolume（分時漲跌成交量）

**語法**：傳回「分時漲跌成交量」的數值
回傳數值 = DiffUpDownVolume
僅支援分鐘與日頻率（含還原）
支援台股與期權商品。

DiffUpDownVolume為分時漲跌成交量的函數，
該函數運算出來的數值，與XS指標的「分時漲跌成交量」指標相同。
