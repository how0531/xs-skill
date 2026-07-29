# 系統函數 - 跨頻率（FREQUENCYFUNC）

> 來源：https://xshelp.xq.com.tw/XSHelp/lists?a=FREQUENCYFUNC（官方 XSHelp，自動爬取）

## xf_CrossOver（跨頻率向上穿越）

**語法**：判斷指定頻率的數列一是否由下往上穿越數列二，又稱黃金交叉。
回傳布林值=xf_CrossOver(頻率,數列一,數列二)
傳入三個參數:
- 第一個參數是頻率，指定傳入數列的資料期別，支援"D", "W", "M", "AD", "AW", "AM"。
- 第二個參數是目標頻率的數列一。
- 第三個參數是目標頻率的數列二。

如果出現黃金交叉傳回True，其他狀況傳回False。

範例：

```xs
condition1 = xf_CrossOver("W",Average(GetField("收盤價","W"),5),Average(GetField("收盤價","W") ,10)); //判斷週線5期均線和10期均線是否黃金交叉
```

## xf_CrossUnder（跨頻率向下跌破）

**語法**：判斷指定頻率的數列一是否由上往下穿越數列二，又稱死亡交叉。
回傳布林值=xf_CrossUnder(頻率,數列一,數列二)
傳入三個參數:
- 第一個參數是頻率，指定傳入數列的資料期別，支援"D", "W", "M", "AD", "AW", "AM"。
- 第二個參數是目標頻率的數列一。
- 第三個參數是目標頻率的數列二。

如果出現死亡交叉傳回True，其他狀況傳回False。

範例：

```xs
condition1 = xf_CrossUnder("W",Average(GetField("close","W"),5),Average(GetField("close","W") ,10) ); //判斷週線5期均線和10期均線是否死亡交叉
```

## xf_DirectionMovement（跨頻率動向指標）

**語法**：計算跨頻率DMI指標。
回傳數值=xf_DirectionMovement(頻率,期數,輸出+DI值,輸出-DI值,輸出ADX值)
傳入五個參數:
- 第一個參數是頻率，指定傳入數列的資料期別，支援"D", "W", "M", "AD", "AW", "AM"。
- 第二個參數是計算期數。
- 第三個參數是輸出計算完的+DI值。
- 第四個參數是輸出計算完的-DI值。
- 第五個參數是輸出計算完的ADX值。

xf_DirectionMovement是DirectionMovement 函數的跨頻率版本，增加了指定頻率的參數，可以計算指定頻率的DMI值。

範例：

```xs
value1 = xf_DirectionMovement("W",14,value2,value3,value4);       //計算14期的週DMI指標
plot1(value2, "週+DI");
plot2(value3, "週-DI");
plot3(value4, "週ADX");
```

## xf_EMA（計算跨頻率的XQEMA移動平均線）

**語法**：計算指定頻率的XQ指數移動平均。
回傳數值=xf_EMA(頻率,數列,期數)
傳入三個參數:
- 第一個參數是頻率，指定傳入數列的資料期別，支援"D", "W", "M", "AD", "AW", "AM"。
- 第二個參數是目標頻率的數列，通常是開高低收的價格數列。
- 第三個參數是期數。

xf_EMA是EMA函數的跨頻率版本，增加了指定頻率的參數，可以計算指定頻率的EMA值。

範例：

```xs
value1 = xf_EMA("W", Close,5); //計算週線5期收盤價的XQ EMA
```

## xf_GetBoolean（取得跨頻率的布林值）

**語法**：引用指定頻率的數值。
回傳數值=xf_GetBoolean(頻率,數列,期別)
傳入三個參數:
- 第一個參數是頻率，指定傳入數列的資料期別，支援"D", "W", "M", "AD", "AW", "AM"。
- 第二個參數是目標頻率的布林數列。
- 第三個參數是期別，相對目前而言要往前的筆數。

在同一個頻率時，我們可以直接利用**變數[3]**取得前3期的變數值。當資料頻率不同時（跨頻率），我們就需要使用xf_GetValue或xf_GetBoolean來取得之前的變數值。若變數是數值時，要用xf_GetValue；若變數是布林值時，要用xf_GetBoolean。

```xs
input:Length_W(9,"跨頻率週期數");
variable:rsv_w(0),kk_w(0),dd_w(0);
xf_stochastic("W", Length_W, 3, 3, rsv_w, kk_w, dd_w);
condition1 = xf_GetBoolean("W",xf_crossover("W", kk_w, dd_w),1);	//在日線抓周KD黃金交叉
```

相關函數：xf_GetValue。

## xf_GetCurrentBar（跨頻率的K棒編號）

**語法**：傳回指定頻率的K棒編號。
K棒編號 =  xf_GetCurrentBar(頻率)
傳入一個參數:
- 第一個參數是頻率，指定傳入數列的資料期別，支援"D", "W", "M", "AD", "AW", "AM"。

傳回指定頻率的K棒序列編號，由1開始，第一筆K棒編號為1，第二筆K棒編號為2，依序遞增。

可以使用這個函數來判斷目前腳本執行的時機點

```xs
value1 = xf_GetCurrentBar(FreqType);

if Length + 1 = 0 then Factor = 1 else Factor = 2 / (Length + 1);

if value1 = 1 then
    xf_XAverage = Series
else
    xf_XAverage = lastXAverage + Factor * (Series - lastXAverage);
```

上述範例利用xf_GetCurrentBar來判斷目前是否是第一筆K棒。如果是的話則回傳xf_XAverage的初始數值。

## xf_GetDTValue（計算指定頻率的序列值）

**語法**：計算指定頻率的序列值。
回傳數值=xf_GetDTValue(頻率,日期)
傳入二個參數:
- 第一個參數是頻率，指定傳入數列的資料期別，支援"D", "W", "M", "AD", "AW", "AM"。
- 第二個參數是日期。

經由傳入的日期判斷指定頻率的期別是否有異動

```xs
value1 = xf_getdtvalue("W",date);
if value1 <> value1[1] then plot1(1) else plot1(0);
```

上述範例利用xf_GetDTValue來判斷目前是否為新的一週。如果是的話則在圖表上顯示為1。

## xf_GetValue（取得跨頻率的數值）

**語法**：引用指定頻率的數值。
回傳數值=xf_GetValue(頻率,數列,期別)
傳入三個參數:
- 第一個參數是頻率，指定傳入數列的資料期別，支援"D", "W", "M", "AD", "AW", "AM"。
- 第二個參數是目標頻率的數列。
- 第三個參數是期別，相對目前而言要往前的筆數。

在同一個頻率時，我們可以直接利用**變數[3]**取得前3期的變數值。當資料頻率不同時（跨頻率），我們就需要使用xf_GetValue或xf_GetBoolean來取得之前的變數值。若變數是數值時，要用xf_GetValue；若變數是布林值時，要用xf_GetBoolean。

```xs
value1 = xf_WeightedClose("W");            //計算週線的加權平均價
value2 = xf_GetValue("W",value1,1);        //取得上一週的加權平均價
plot1(value2);
plot2(value1[1]);                        //可以比較一下和value2的差異
```

相關函數：xf_GetBoolean。

## xf_MACD（跨頻率指數平滑異同移動平均線）

**語法**：計算指定頻率的MACD指標值。
回傳數值=xf_MACD(頻率,數列,短期數,長期數,MACD平滑期數,輸出DIF值,輸出MACD值,輸出OSC值)
傳入八個參數:
- 第一個參數是頻率，指定傳入數列的資料期別，支援"D", "W", "M", "AD", "AW", "AM"。
- 第二個參數是目標頻率的數列，MACD通常是以加權平均收盤價（WeightedClose）來計算。
- 第三個參數是計算快速線（短期）的期數。
- 第四個參數是計算慢速線（長期）的期數。
- 第五個參數是計算MACD使用之平滑期數。
- 第六個參數是輸出計算完的DIF值。
- 第七個參數是輸出計算完的MACD值。
- 第八個參數是輸出計算完的OSC值。

xf_MACD是MACD 函數的跨頻率版本，增加了指定頻率的參數，可以計算指定頻率的MACD值。

範例：

```xs
value1 = xf_MACD("W",xf_weightedclose("W"),12,26,9,value2,value3,value4);       //計算週線MACD
plot1(value2, "週DIF");
plot2(value3, "週MACD");
plot3(value4, "週OSC");
```

## xf_PercentR（跨頻率威廉指標）

**語法**：計算指定頻率的威廉指標值。
回傳數值=xf_PercentR(頻率,期數)
傳入二個參數:
- 第一個參數是頻率，指定傳入數列的資料期別，支援"D", "W", "M", "AD", "AW", "AM"。
- 第二個參數是計算威廉指標的期數。

xf_PercentR是PercentR 函數的跨頻率版本，增加了指定頻率的參數，可以計算指定頻率的PercentR值。

範例：

```xs
value1 = xf_PercentR("W", 14) - 100;       //計算週線威廉指標
Plot1(value1, "週威廉指標");
```

## xf_RSI（跨頻率相對強弱指標）

**語法**：計算指定頻率的相對強弱指標數值。
回傳數值=xf_RSI(頻率,數列,期數)
傳入三個參數:
- 第一個參數是頻率，指定傳入數列的資料期別，支援"D", "W", "M", "AD", "AW", "AM"。
- 第二個參數是目標頻率的數列，通常是開高低收的價格數列。
- 第三個參數是期數。

xf_RSI是RSI 函數的跨頻率版本，增加了指定頻率的參數，可以計算指定頻率的RSI值。

範例：

```xs
value1 = xf_RSI("W",GetField("Close","W"),6);       //計算6期的週RSI指標
plot1(value1, "週RSI");
```

## xf_Stochastic（用來計算跨頻率KD/RSV相關指標的函數）

**語法**：計算指定頻率的KD指標。
回傳數值=xf_Stochastic(頻率,資料期數,K值平滑期數,D值平滑期數,輸出RSV值,輸出K值,輸出D值)
傳入八個參數:
- 第一個參數是頻率，指定傳入數列的資料期別，支援"D", "W", "M", "AD", "AW", "AM"。
- 第二個參數是資料期數，指定計算的區間長度。
- 第三個參數是K值平滑期數，指定計算K值所用的平滑期數。
- 第四個參數是D值平滑期數，指定計算D值所用的平滑期數。
- 第五個參數是輸出RSV值，回傳計算完的RSV值。
- 第六個參數是輸出K值，回傳計算完的K值。
- 第七個參數是輸出D值，回傳計算完的D值。

xf_Stochastic是Stochastic 函數的跨頻率版本，增加了指定頻率的參數，可以計算指定頻率的Stochastic值。

範例：

```xs
value1 = xf_Stochastic("W",9,3,3,value2,value3,value4);       //計算週KD指標
plot1(value3, "週K");
plot2(value4, "週D");
```

## xf_WeightedClose（跨頻率加權平均價）

**語法**：計算指定頻率的加權平均收盤價。
回傳數值=xf_WeightedClose(頻率)
傳入一個參數:
- 第一個參數是頻率，指定傳入數列的資料期別，支援"D", "W", "M", "AD", "AW", "AM"。

xf_WeightedClose是WeightedClose 函數的跨頻率版本，增加了指定頻率的參數，可以計算指定頻率的WeightedClose值。

範例：

```xs
plot1(xf_WeightedClose("W"));    //繪製週線加權平均收盤價的連線
```

## xf_XAverage（跨頻率指數平滑化移動平均數）

**語法**：計算指定頻率的指數移動平均。
回傳數值=xf_XAverage(頻率,數列,期數)
傳入三個參數:
- 第一個參數是頻率，指定傳入數列的資料期別，支援"D", "W", "M", "AD", "AW", "AM"。
- 第二個參數是目標頻率的數列，通常是開高低收的價格數列。
- 第三個參數是期數。

xf_XAverage是XAverage 函數的跨頻率版本，增加了指定頻率的參數，可以計算指定頻率的XAverage值。

範例：

```xs
value1 = xf_XAverage("W",GetField("Close","W"),5); //計算週線5期收盤價的指數移動平均
```

## xfMin_CrossOver（支援跨分鐘頻率的向上穿越）

**語法**：判斷指定頻率的數列一是否由下往上穿越數列二，又稱黃金交叉。
回傳布林值=xfMin_CrossOver(頻率,數列一,數列二)
傳入三個參數:
- 第一個參數是頻率，指定傳入數列的資料期別，支援"1","5","10","15","30","60","D", "W", "M", "AD", "AW", "AM"。
- 第二個參數是目標頻率的數列一。
- 第三個參數是目標頻率的數列二。
備註：商品類型僅支援台股與台期權。不支援XS選股、XS選股自訂排行與XS選股回測。

如果出現黃金交叉傳回True，其他狀況傳回False。

範例：

```xs
condition1 = xfMin_CrossOver("30",Average(GetField("收盤價","30"),5),Average(GetField("收盤價","30") ,10)); //判斷30分鐘線5期均線和10期均線是否黃金交叉
```

## xfMin_CrossUnder（支援跨分鐘頻率的向下跌破）

**語法**：判斷指定頻率的數列一是否由上往下穿越數列二，又稱死亡交叉。
回傳布林值=xfMin_CrossUnder(頻率,數列一,數列二)
傳入三個參數:
- 第一個參數是頻率，指定傳入數列的資料期別，支援"1","5","10","15","30","60","D", "W", "M", "AD", "AW", "AM"。
- 第二個參數是目標頻率的數列一。
- 第三個參數是目標頻率的數列二。
備註：商品類型僅支援台股與台期權。不支援XS選股、XS選股自訂排行與XS選股回測。

如果出現死亡交叉傳回True，其他狀況傳回False。

範例：

```xs
condition1 = xfMin_CrossUnder("30",Average(GetField("close","30"),5),Average(GetField("close","30") ,10) ); //判斷30分鐘線5期均線和10期均線是否死亡交叉
```

## xfMin_DirectionMovement（支援跨分鐘頻率的動向指標）

**語法**：計算跨頻率DMI指標。
回傳數值=xfMin_DirectionMovement(頻率,期數,輸出+DI值,輸出-DI值,輸出ADX值)
傳入五個參數:
- 第一個參數是頻率，指定傳入數列的資料期別，支援"1","5","10","15","30","60","D", "W", "M", "AD", "AW", "AM"。
- 第二個參數是計算期數。
- 第三個參數是輸出計算完的+DI值。
- 第四個參數是輸出計算完的-DI值。
- 第五個參數是輸出計算完的ADX值。
備註：商品類型僅支援台股與台期權。不支援XS選股、XS選股自訂排行與XS選股回測。

xfMin_DirectionMovement是xf_DirectionMovement 函數的跨頻率加強版本，增加了指定分鐘頻率的參數，可以計算指定分鐘頻率的DMI值。

範例：

```xs
value1 = xfMin_DirectionMovement("30",14,value2,value3,value4);       //計算14期的30分鐘線DMI指標
plot1(value2, "30分+DI");
plot2(value3, "30分週-DI");
plot3(value4, "30分ADX");
```

## xfMin_EMA（支援計算跨分鐘頻率的XQEMA移動平均線）

**語法**：計算指定頻率的XQ指數移動平均。
回傳數值=xfMin_EMA(頻率,數列,期數)
傳入三個參數:
- 第一個參數是頻率，指定傳入數列的資料期別，支援"1","5","10","15","30","60","D", "W", "M", "AD", "AW", "AM"。
- 第二個參數是目標頻率的數列，通常是開高低收的價格數列。
- 第三個參數是期數。
備註：商品類型僅支援台股與台期權。不支援XS選股、XS選股自訂排行與XS選股回測。

xfMin_EMA是xf_EMA函數的跨頻率加強版本，增加了指定分鐘頻率的參數，可以計算指定分鐘頻率的EMA值。

範例：

```xs
value1 = xfMin_EMA("30", GetField("Close", "30"),5); //計算30分鐘線5期收盤價的XQ EMA
```

## xfMin_GetBoolean（支援取得跨分鐘頻率的布林值）

**語法**：引用指定頻率的數值。
回傳數值=xfMin_GetBoolean(頻率,數列,期別)
傳入三個參數:
- 第一個參數是頻率，指定傳入數列的資料期別，支援"1","5","10","15","30","60","D", "W", "M", "AD", "AW", "AM"。
- 第二個參數是布林數列。
- 第三個參數是期別，相對目前而言要往前的筆數。
備註：商品類型僅支援台股與台期權。不支援XS選股、XS選股自訂排行與XS選股回測。

在同一個頻率時，我們可以直接利用**變數[3]**取得前3期的變數值。當資料頻率不同時（跨頻率），我們就需要使用xfMin_GetValue或xfMin_GetBoolean來取得之前的變數值。若變數是數值時，要用xfMin_GetValue；若變數是布林值時，要用xfMin_GetBoolean。支援跨分鐘頻率。

```xs
input:Length_Min(9,"跨分鐘頻率期數");
variable:rsv_w(0),kk_w(0),dd_w(0);
xfMin_stochastic("30", Length_Min, 3, 3, rsv_w, kk_w, dd_w);
condition1 = xfMin_GetBoolean("30",xfMin_crossover("30", kk_w, dd_w),1);	//在15分鐘線抓30分鐘線KD黃金交叉
```

相關函數：xfMin_GetValue。

## xfMin_GetCurrentBar（支援跨分鐘頻率的K棒編號）

**語法**：傳回指定頻率的K棒編號。
K棒編號 = xfMin_GetCurrentBar(頻率)
傳入一個參數:
- 第一個參數是頻率，指定傳入數列的資料期別，支援"1","5","10","15","30","60","D", "W", "M", "AD", "AW", "AM"。
備註：商品類型僅支援台股與台期權。不支援XS選股、XS選股自訂排行與XS選股回測。

傳回指定頻率（支援分鐘）的K棒序列編號，由1開始，第一筆K棒編號為1，第二筆K棒編號為2，依序遞增。

可以使用這個函數來判斷目前腳本執行的時機點

```xs
value1 = xfMin_GetCurrentBar(FreqType);

if Length + 1 = 0 then Factor = 1 else Factor = 2 / (Length + 1);

if value1 = 1 then
    xfMin_XAverage = Series
else
    xfMin_XAverage = lastXAverage + Factor * (Series - lastXAverage);
```

上述範例利用xfMin_GetCurrentBar來判斷目前是否是第一筆K棒。如果是的話則回傳xfMin_XAverage的初始數值。

## xfMin_GetDTValue（支援計算跨分鐘頻率的序列值）

**語法**：計算指定頻率的序列值。
回傳數值=xfMin_GetDTValue(頻率,日期)
傳入二個參數:
- 第一個參數是頻率，指定傳入數列的資料期別，支援"1","5","10","15","30","60","D", "W", "M", "AD", "AW", "AM"。
- 第二個參數是日期。
備註：商品類型僅支援台股與台期權。不支援XS選股、XS選股自訂排行與XS選股回測。

經由傳入的日期判斷指定頻率的期別是否有異動，支援指定分鐘頻率。

```xs
value1 = xfMin_getdtvalue("30",date);
if value1 <> value1[1] then plot1(1) else plot1(0);
```

上述範例利用xfMin_GetDTValue來判斷目前是否為新的30分鐘。如果是的話則在圖表上顯示為1。

## xfMin_GetValue（支援取得跨分鐘頻率的數值）

**語法**：引用指定頻率的數值。
回傳數值=xfMin_GetValue(頻率,數列,期別)
傳入三個參數:
- 第一個參數是頻率，指定傳入數列的資料期別，支援"1","5","10","15","30","60","D", "W", "M", "AD", "AW", "AM"。
- 第二個參數是目標頻率的數列。
- 第三個參數是期別，相對目前而言要往前的筆數。
備註：商品類型僅支援台股與台期權。不支援XS選股、XS選股自訂排行與XS選股回測。

在同一個頻率時，我們可以直接利用**變數[3]**取得前3期的變數值。當資料頻率不同時（跨頻率），我們就需要使用xfMin_GetValue或xfMin_GetBoolean來取得之前的變數值。若變數是數值時，要用xfMin_GetValue；若變數是布林值時，要用xfMin_GetBoolean。支援跨分鐘頻率。

```xs
value1 = xfMin_WeightedClose("30");            //計算30分鐘線的加權平均價
value2 = xfMin_GetValue("30",value1,1);        //取得上一期30分鐘線的加權平均價
plot1(value2);
plot2(value1[1]);                        //可以比較一下和value2的差異
```

相關函數：xfMin_GetBoolean。

## xfMin_MACD（支援跨分鐘頻率的指數平滑異同移動平均線）

**語法**：計算指定頻率的MACD指標值。
回傳數值=xfMin_MACD(頻率,數列,短期數,長期數,MACD平滑期數,輸出DIF值,輸出MACD值,輸出OSC值)
傳入八個參數:
- 第一個參數是頻率，指定傳入數列的資料期別，支援"1","5","10","15","30","60","D", "W", "M", "AD", "AW", "AM"。
- 第二個參數是目標頻率的數列，MACD通常是以加權平均收盤價（WeightedClose）來計算。
- 第三個參數是計算快速線（短期）的期數。
- 第四個參數是計算慢速線（長期）的期數。
- 第五個參數是計算MACD使用之平滑期數。
- 第六個參數是輸出計算完的DIF值。
- 第七個參數是輸出計算完的MACD值。
- 第八個參數是輸出計算完的OSC值。
備註：商品類型僅支援台股與台期權。不支援XS選股、XS選股自訂排行與XS選股回測。

xfMin_MACD是xf_MACD 函數的跨頻率加強版本，增加了指定分鐘頻率的參數，可以計算指定分鐘頻率的MACD值。

範例：

```xs
value1 = xfMin_MACD("30",xfMin_weightedclose("30"),12,26,9,value2,value3,value4);    //計算30分鐘線MACD
plot1(value2, "30分鐘DIF");
plot2(value3, "30分鐘MACD");
plot3(value4, "30分鐘OSC");
```

## xfmin_MTM（支援跨分鐘頻率的MTM指標）

**語法**：計算指定頻率的威廉指標值。
回傳數值=xfMin_MTM(頻率,期數)
傳入二個參數:
- 第一個參數是頻率，指定傳入數列的資料期別，支援"1","5","10","15","30","60","D", "W", "M", "AD", "AW", "AM"。
- 第二個參數是計算MTM指標的期數。
備註：商品類型僅支援台股與台期權。不支援XS選股、XS選股自訂排行與XS選股回測。

xfMin_MTM是MTM 函數的跨頻率版本，增加了指定頻率的參數，可以計算指定頻率的MTM值。

範例：

```xs
value1 = xfMin_MTM("5", 10);       //value1 = 五分鐘MTM
Plot1(value1, "5分鐘MTM");
```

## xfMin_PercentR（支援跨分鐘頻率的威廉指標）

**語法**：計算指定頻率的威廉指標值。
回傳數值=xfMin_PercentR(頻率,期數)
傳入二個參數:
- 第一個參數是頻率，指定傳入數列的資料期別，支援"1","5","10","15","30","60","D", "W", "M", "AD", "AW", "AM"。
- 第二個參數是計算威廉指標的期數。
備註：商品類型僅支援台股與台期權。不支援XS選股、XS選股自訂排行與XS選股回測。

xfMin_PercentR是xf_PercentR 函數的跨頻率加強版本，增加了指定分鐘頻率的參數，可以計算指定分鐘頻率的PercentR值。

範例：

```xs
value1 = xfMin_PercentR("30", 14) - 100;       //計算30分鐘線威廉指標
Plot1(value1, "30分鐘威廉指標");
```

## xfMin_RSI（支援跨分鐘頻率的相對強弱指標）

**語法**：計算指定頻率的相對強弱指標數值。
回傳數值=xfMin_RSI(頻率,數列,期數)
傳入三個參數:
- 第一個參數是頻率，指定傳入數列的資料期別，支援"1","5","10","15","30","60","D", "W", "M", "AD", "AW", "AM"。
- 第二個參數是目標頻率的數列，通常是開高低收的價格數列。
- 第三個參數是期數。
備註：商品類型僅支援台股與台期權。不支援XS選股、XS選股自訂排行與XS選股回測。

xfMin_RSI是xf_RSI 函數的跨頻率加強版本，增加了指定分鐘頻率的參數，可以計算指定分鐘頻率的RSI值。

範例：

```xs
value1 = xfMin_RSI("30",GetField("Close","30"),6);       //計算6期的30分鐘線RSI指標
plot1(value1, "30分RSI");
```

## xfMin_Stochastic（用來支援計算跨分鐘頻率的KD/RSV相關指標的函數）

**語法**：計算指定頻率的KD指標。
回傳數值=xfMin_Stochastic(頻率,資料期數,K值平滑期數,D值平滑期數,輸出RSV值,輸出K值,輸出D值)
傳入八個參數:
- 第一個參數是頻率，指定傳入數列的資料期別，支援"1","5","10","15","30","60","D", "W", "M", "AD", "AW", "AM"。
- 第二個參數是資料期數，指定計算的區間長度。
- 第三個參數是K值平滑期數，指定計算K值所用的平滑期數。
- 第四個參數是D值平滑期數，指定計算D值所用的平滑期數。
- 第五個參數是輸出RSV值，回傳計算完的RSV值。
- 第六個參數是輸出K值，回傳計算完的K值。
- 第七個參數是輸出D值，回傳計算完的D值。
備註：商品類型僅支援台股與台期權。不支援XS選股、XS選股自訂排行與XS選股回測。

xfMin_Stochastic是xf_Stochastic 函數的跨頻率加強版本，增加了指定分鐘頻率的參數，可以計算指定分鐘頻率的Stochastic值。

範例：

```xs
value1 = xfMin_Stochastic("30",9,3,3,value2,value3,value4);       //計算30分鐘線KD指標
plot1(value3, "30分K");
plot2(value4, "30分D");
```

## xfMin_WeightedClose（支援跨分鐘頻率的加權平均價）

**語法**：計算指定頻率的加權平均收盤價。
回傳數值=xfMin_WeightedClose(頻率)
傳入一個參數:
- 第一個參數是頻率，指定傳入數列的資料期別，支援"1","5","10","15","30","60","D", "W", "M", "AD", "AW", "AM"。
備註：商品類型僅支援台股與台期權。不支援XS選股、XS選股自訂排行與XS選股回測。

xfMin_WeightedClose是xf_WeightedClose 函數的跨頻率加強版本，增加了指定分鐘頻率的參數，可以計算指定分鐘頻率的WeightedClose值。

範例：

```xs
plot1(xfMin_WeightedClose("30"));    //繪製30分鐘線加權平均收盤價的連線
```

## xfMin_XAverage（支援跨分鐘頻率的指數平滑化移動平均數）

**語法**：計算指定頻率的指數移動平均。
回傳數值=xfMin_Xaverage(頻率,數列,期數)
傳入三個參數:
- 第一個參數是頻率，指定傳入數列的資料期別，支援"1","5","10","15","30","60","D", "W", "M", "AD", "AW", "AM"。
- 第二個參數是目標頻率的數列，通常是開高低收的價格數列。
- 第三個參數是期數。
備註：商品類型僅支援台股與台期權。不支援XS選股、XS選股自訂排行與XS選股回測。

xfMin_XAverage是xf_XAverage 函數的跨頻率加強版本，增加了指定分鐘頻率的參數，可以計算指定分鐘頻率的XAverage值。

範例：

```xs
value1 = xfMin_XAverage("30",GetField("Close","30"),5); //計算30分鐘線5期收盤價的指數移動平均
```
