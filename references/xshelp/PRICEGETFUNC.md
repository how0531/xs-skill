# 系統函數 - 價格取得（PRICEGETFUNC）

> 來源：https://xshelp.xq.com.tw/XSHelp/lists?a=PRICEGETFUNC（官方 XSHelp，自動爬取）

## AvgPrice（平均價）

**語法**：取得利用K棒的開高低收所計算出的平均價格。
回傳數值=AvgPrice
---
※請注意：AvgPrice 與 getfield("AvgPrice") 是不同的數值，
getfield("AvgPrice") 是今日的平均成交價，也就是「當日每筆的成交金額加總／當日成交量」

計算公式：

平均價格 = (當期開盤價 + 當期最高價 + 當期最低價 + 當期收盤價)/4

範例：

```xs
plot1(avgprice);    //繪製當天平均價格的連線
plot2(avgprice[1]); //繪製前一天平均價格的連線
```

## CloseD（日收盤價）

**語法**：取得日線的收盤價。
僅限使用於日線以下之頻率。
回傳數值=CloseD(期別)
傳入一個參數:
- 第一個參數是期別，和序列引用定義相同，0表當期、1表前一期...依此類推。

當使用頻率小於日線時，用CloseD可以找到某期的日收盤價。

範例：

```xs
plot1(CloseD(0)); //繪製當日收盤價的連線
plot2(CloseD(1)); //繪製前一日收盤價的連線
```

相關的函數包含:

- OpenD, OpenW, OpenM, OpenQ, OpenH, OpenY

- HighD, HighW, HighM, HighQ, HighH, HighY

- LowD, LowW, LowM, LowQ, LowH, LowY

- CloseD, CloseW, CloseM, CloseQ, CloseH, CloseY

## CloseH（半年收盤價）

**語法**：取得半年線的收盤價。
僅限使用於半年線以下之頻率。
數值=CloseH(期別)
傳入一個參數:
- 第一個參數是期別，和序列引用定義相同，0表當期、1表前一期...依此類推。

當使用頻率小於半年線時，用CloseH可以找到某期的半年收盤價。

範例：

```xs
plot1(CloseH(0)); //繪製當期半年線收盤價的連線
```

相關的函數包含:

- OpenD, OpenW, OpenM, OpenQ, OpenH, OpenY

- HighD, HighW, HighM, HighQ, HighH, HighY

- LowD, LowW, LowM, LowQ, LowH, LowY

- CloseD, CloseW, CloseM, CloseQ, CloseH, CloseY

## CloseM（月收盤價）

**語法**：取得月線的收盤價。
僅限使用於月線以下之頻率。
回傳數值=CloseM(期別)
傳入一個參數:
- 第一個參數是期別，和序列引用定義相同，0表當期、1表前一期...依此類推。

當使用頻率小於月線時，用CloseM可以找到某期的月收盤價。

範例：

```xs
plot1(CloseM(0)); //繪製當月收盤價的連線
plot2(CloseM(1)); //繪製前一月收盤價的連線
```

相關的函數包含:

- OpenD, OpenW, OpenM, OpenQ, OpenH, OpenY

- HighD, HighW, HighM, HighQ, HighH, HighY

- LowD, LowW, LowM, LowQ, LowH, LowY

- CloseD, CloseW, CloseM, CloseQ, CloseH, CloseY

## CloseQ（季收盤價）

**語法**：取得季線的收盤價。
僅限使用於季線以下之頻率。
回傳數值=CloseQ(期別)
傳入一個參數:
- 第一個參數是期別，和序列引用定義相同，0表當期、1表前一期...依此類推。

當使用頻率小於季線時，用CloseQ可以找到某期的季收盤價。

範例：

```xs
plot1(CloseQ(0)); //繪製當季收盤價的連線
plot2(CloseQ(1)); //繪製前一季收盤價的連線
```

相關的函數包含:

- OpenD, OpenW, OpenM, OpenQ, OpenH, OpenY

- HighD, HighW, HighM, HighQ, HighH, HighY

- LowD, LowW, LowM, LowQ, LowH, LowY

- CloseD, CloseW, CloseM, CloseQ, CloseH, CloseY

## CloseW（週收盤價）

**語法**：取得週線的收盤價。
僅限使用於週線以下之頻率。
回傳數值=CloseW(期別)
傳入一個參數:
- 第一個參數是期別，和序列引用定義相同，0表當期、1表前一期...依此類推。

當使用頻率小於週線時，用CloseW可以找到某期的週收盤價。

範例：

```xs
plot1(CloseW(0)); //繪製當週收盤價的連線
plot2(CloseW(1)); //繪製前一週收盤價的連線
```

相關的函數包含:

- OpenD, OpenW, OpenM, OpenQ, OpenH, OpenY

- HighD, HighW, HighM, HighQ, HighH, HighY

- LowD, LowW, LowM, LowQ, LowH, LowY

- CloseD, CloseW, CloseM, CloseQ, CloseH, CloseY

## CloseY（年收盤價）

**語法**：取得年線的收盤價。
僅限使用於年線以下之頻率。
回傳數值=CloseY(期別)
傳入一個參數:
- 第一個參數是期別，和序列引用定義相同，0表當期、1表前一期...依此類推。

當使用頻率小於年線時，用CloseY可以找到某期的年收盤價。

範例：

```xs
plot1(CloseY(0)); //繪製當年收盤價的連線
plot2(CloseY(1)); //繪製前一年收盤價的連線
```

相關的函數包含:

- OpenD, OpenW, OpenM, OpenQ, OpenH, OpenY

- HighD, HighW, HighM, HighQ, HighH, HighY

- LowD, LowW, LowM, LowQ, LowH, LowY

- CloseD, CloseW, CloseM, CloseQ, CloseH, CloseY

## FastHighest（區間最大值）

**語法**：計算序列資料的最大值。
回傳數值=FastHighest(數列,期數)
傳入二個參數:
- 第一個參數是數列，通常是開高低收的價格數列。
- 第二個參數是期數。

以最新一筆資料為基準點，輸入要計算的期數，然後計算過去期數的極大值。

FastHighest函數為Highest函數的快速計算版本。

在運算極值的時候，會用 For 迴圈往前抓到極值紀錄後，之後執行腳本就會用當下的序列資料與紀錄極值相比，若大於紀錄極值則更新輸出極值與輸出極值的相對K棒位置。因為不會每根 K 棒都用 For 迴圈往前抓極值，所以腳本運行會更加快速。

範例：

```xs
plot1(FastHighest(high,5));    //繪製5期最高價的最大值的連線
```

## FastLowest（區間最小值）

**語法**：計算序列資料的最小值。
回傳數值=FastLowest(數列,期數)
傳入二個參數:
- 第一個參數是數列，通常是開高低收的價格數列。
- 第二個參數是期數。

以最新一筆資料為基準點，輸入要計算的期數，然後計算過去期數的極小值。

FastLowest函數為Lowest函數的快速計算版本。

在運算極值的時候，會用 For 迴圈往前抓到極值紀錄後，之後執行腳本就會用當下的序列資料與紀錄極值相比，若大於紀錄極值則更新輸出極值與輸出極值的相對K棒位置。因為不會每根 K 棒都用 For 迴圈往前抓極值，所以腳本運行會更加快速。

範例：

```xs
plot1(FastLowest(low,5));    //繪製5期最低價的最小值的連線
```

## HighD（日最高價）

**語法**：取得日線的最高價。
僅限使用於日線以下之頻率。
回傳數值=HighD(期別)
傳入一個參數:
- 第一個參數是期別，和序列引用定義相同，0表當期、1表前一期...依此類推。

當使用頻率小於日線時，用HighD可以找到某期的日最高價。

範例：

```xs
plot1(HighD(0)); //繪製當日最高價的連線
plot2(HighD(1)); //繪製前一日最高價的連線
```

相關的函數包含:

- OpenD, OpenW, OpenM, OpenQ, OpenH, OpenY

- HighD, HighW, HighM, HighQ, HighH, HighY

- LowD, LowW, LowM, LowQ, LowH, LowY

- CloseD, CloseW, CloseM, CloseQ, CloseH, CloseY

## Highest（區間最大值）

**語法**：計算序列資料的最大值。
回傳數值=Highest(數列,期數)
傳入二個參數:
- 第一個參數是數列，通常是開高低收的價格數列。
- 第二個參數是期數。

以最新一筆資料為基準點，輸入要計算的期數，然後計算過去期數的極大值。

Highest函數與FastHighest函數的運算方式一致，都是用 Extremes 函數抓極大值。

範例：

```xs
plot1(Highest(high,5));    //繪製5期最高價的最大值的連線
```

## HighH（半年最高價）

**語法**：取得半年線的最高價。
僅限使用於半年線以下之頻率。
回傳數值=HighH(期別)
傳入一個參數:
- 第一個參數是期別，和序列引用定義相同，0表當期、1表前一期...依此類推。

當使用頻率小於半年線時，用HighH可以找到某期的半年最高價。

範例：

```xs
plot1(HighH(0)); //繪製當期半年線最高價的連線
```

## HighM（月最高價）

**語法**：取得月線的最高價。
僅限使用於月線以下之頻率。
回傳數值=HighM(期別)
傳入一個參數:
- 第一個參數是期別，和序列引用定義相同，0表當期、1表前一期...依此類推。

當使用頻率小於月線時，用HighM可以找到某期的月最高價。

範例：

```xs
plot1(HighM(0)); //繪製當月最高價的連線
plot2(HighM(1)); //繪製前一月最高價的連線
```

相關的函數包含:

- OpenD, OpenW, OpenM, OpenQ, OpenH, OpenY

- HighD, HighW, HighM, HighQ, HighH, HighY

- LowD, LowW, LowM, LowQ, LowH, LowY

- CloseD, CloseW, CloseM, CloseQ, CloseH, CloseY

## HighQ（季最高價）

**語法**：取得季線的最高價。
僅限使用於季線以下之頻率。
回傳數值=HighQ(期別)
傳入一個參數:
- 第一個參數是期別，和序列引用定義相同，0表當期、1表前一期...依此類推。

當使用頻率小於季線時，用HighQ可以找到某期的季最高價。

範例：

```xs
plot1(HighQ(0)); //繪製當季最高價的連線
plot2(HighQ(1)); //繪製前一季最高價的連線
```

相關的函數包含:

- OpenD, OpenW, OpenM, OpenQ, OpenH, OpenY

- HighD, HighW, HighM, HighQ, HighH, HighY

- LowD, LowW, LowM, LowQ, LowH, LowY

- CloseD, CloseW, CloseM, CloseQ, CloseH, CloseY

## HighW（週最高價）

**語法**：取得週線的最高價。
僅限使用於週線以下之頻率。
回傳數值=HighW(期別)
傳入一個參數:
- 第一個參數是期別，和序列引用定義相同，0表當期、1表前一期...依此類推。

當使用頻率小於週線時，用HighW可以找到某期的週最高價。

範例：

```xs
plot1(HighW(0)); //繪製當週最高價的連線
plot2(HighW(1)); //繪製前一週最高價的連線
```

相關的函數包含:

- OpenD, OpenW, OpenM, OpenQ, OpenH, OpenY

- HighD, HighW, HighM, HighQ, HighH, HighY

- LowD, LowW, LowM, LowQ, LowH, LowY

- CloseD, CloseW, CloseM, CloseQ, CloseH, CloseY

## HighY（年最高價）

**語法**：取得年線的最高價。
僅限使用於年線以下之頻率。
回傳數值=HighY(期別)
傳入一個參數:
- 第一個參數是期別，和序列引用定義相同，0表當期、1表前一期...依此類推。

當使用頻率小於年線時，用HighY可以找到某期的年最高價。

範例：

```xs
plot1(HighY(0)); //繪製當年最高價的連線
plot2(HighY(1)); //繪製前一年最高價的連線
```

相關的函數包含:

- OpenD, OpenW, OpenM, OpenQ, OpenH, OpenY

- HighD, HighW, HighM, HighQ, HighH, HighY

- LowD, LowW, LowM, LowQ, LowH, LowY

- CloseD, CloseW, CloseM, CloseQ, CloseH, CloseY

## LowD（日最低價）

**語法**：取得日線的最低價。
僅限使用於日線以下之頻率。
回傳數值=LowD(期別)
傳入一個參數:
- 第一個參數是期別，和序列引用定義相同，0表當期、1表前一期...依此類推。

當使用頻率小於日線時，用LowD可以找到某期的日最低價。

範例：

```xs
plot1(LowD(0)); //繪製當日最低價的連線
plot2(LowD(1)); //繪製前一日最低價的連線
```

相關的函數包含:

- OpenD, OpenW, OpenM, OpenQ, OpenH, OpenY

- HighD, HighW, HighM, HighQ, HighH, HighY

- LowD, LowW, LowM, LowQ, LowH, LowY

- CloseD, CloseW, CloseM, CloseQ, CloseH, CloseY

## Lowest（區間最小值）

**語法**：計算序列資料的最小值。
回傳數值=Lowest(數列,期數)
傳入二個參數:
- 第一個參數是數列，通常是開高低收的價格數列。
- 第二個參數是期數。

以最新一筆資料為基準點，輸入要計算的期數，然後計算過去期數的極小值。

Lowest函數與FastLowest函數的運算方式一致，都是用 Extremes 函數抓極小值。

範例：

```xs
plot1(Lowest(low,5));    //繪製5期最低價的最小值的連線
```

## LowH（半年最低價）

**語法**：取得半年線的最低價。
僅限使用於半年線以下之頻率。
回傳數值=LowH(期別)
傳入一個參數:
- 第一個參數是期別，和序列引用定義相同，0表當期、1表前一期...依此類推。

當使用頻率小於半年線時，用LowH可以找到某期的半年最低價。

範例：

```xs
plot1(LowH(0)); //繪製當期半年線最低價的連線
```

相關的函數包含:

- OpenD, OpenW, OpenM, OpenQ, OpenH, OpenY

- HighD, HighW, HighM, HighQ, HighH, HighY

- LowD, LowW, LowM, LowQ, LowH, LowY

- CloseD, CloseW, CloseM, CloseQ, CloseH, CloseY

## LowM（月最低價）

**語法**：取得月線的最低價。
僅限使用於月線以下之頻率。
回傳數值=LowM(期別)
傳入一個參數:
- 第一個參數是期別，和序列引用定義相同，0表當期、1表前一期...依此類推。

當使用頻率小於月線時，用LowM可以找到某期的月最低價。

範例：

```xs
plot1(LowM(0)); //繪製當月最低價的連線
plot2(LowM(1)); //繪製前一月最低價的連線
```

相關的函數包含:

- OpenD, OpenW, OpenM, OpenQ, OpenH, OpenY

- HighD, HighW, HighM, HighQ, HighH, HighY

- LowD, LowW, LowM, LowQ, LowH, LowY

- CloseD, CloseW, CloseM, CloseQ, CloseH, CloseY

## LowQ（季最低價）

**語法**：取得季線的最低價。
僅限使用於季線以下之頻率。
回傳數值=LowQ(期別)
傳入一個參數:
- 第一個參數是期別，和序列引用定義相同，0表當期、1表前一期...依此類推。

當使用頻率小於季線時，用LowQ可以找到某期的季最低價。

範例：

```xs
plot1(LowQ(0)); //繪製當季最低價的連線
plot2(LowQ(1)); //繪製前一季最低價的連線
```

相關的函數包含:

- OpenD, OpenW, OpenM, OpenQ, OpenH, OpenY

- HighD, HighW, HighM, HighQ, HighH, HighY

- LowD, LowW, LowM, LowQ, LowH, LowY

- CloseD, CloseW, CloseM, CloseQ, CloseH, CloseY

## LowW（週最低價）

**語法**：取得週線的最低價。
僅限使用於週線以下之頻率。
回傳數值=LowW(期別)
傳入一個參數:
- 第一個參數是期別，和序列引用定義相同，0表當期、1表前一期...依此類推。

當使用頻率小於週線時，用LowW可以找到某期的週最低價。

範例：

```xs
plot1(LowW(0)); //繪製當週最低價的連線
plot2(LowW(1)); //繪製前一週最低價的連線
```

相關的函數包含:

- OpenD, OpenW, OpenM, OpenQ, OpenH, OpenY

- HighD, HighW, HighM, HighQ, HighH, HighY

- LowD, LowW, LowM, LowQ, LowH, LowY

- CloseD, CloseW, CloseM, CloseQ, CloseH, CloseY

## LowY（年最低價）

**語法**：取得年線的最低價。
僅限使用於年線以下之頻率。
回傳數值=LowY(期別)
傳入一個參數:
- 第一個參數是期別，和序列引用定義相同，0表當期、1表前一期...依此類推。

當使用頻率小於年線時，用LowY可以找到某期的年最低價。

範例：

```xs
plot1(LowY(0)); //繪製當年最低價的連線
plot2(LowY(1)); //繪製前一年最低價的連線
```

相關的函數包含:

- OpenD, OpenW, OpenM, OpenQ, OpenH, OpenY

- HighD, HighW, HighM, HighQ, HighH, HighY

- LowD, LowW, LowM, LowQ, LowH, LowY

- CloseD, CloseW, CloseM, CloseQ, CloseH, CloseY

## OpenD（日開盤價）

**語法**：取得日線的開盤價。
僅限使用於日線以下之頻率。
回傳數值=OpenD(期別)
傳入一個參數:
- 第一個參數是期別，和序列引用定義相同，0表當期、1表前一期...依此類推。

當使用頻率小於日線時，用OpenD可以找到某期的日開盤價。

範例：

```xs
plot1(OpenD(0)); //繪製當日開盤價的連線
plot2(OpenD(1)); //繪製前一日開盤價的連線
```

相關的函數包含:

- OpenD, OpenW, OpenM, OpenQ, OpenH, OpenY

- HighD, HighW, HighM, HighQ, HighH, HighY

- LowD, LowW, LowM, LowQ, LowH, LowY

- CloseD, CloseW, CloseM, CloseQ, CloseH, CloseY

## OpenH（半年開盤價）

**語法**：取得半年線的開盤價。
僅限使用於半年線以下之頻率。
回傳數值=OpenH(期別)
傳入一個參數:
- 第一個參數是期別，和序列引用定義相同，0表當期、1表前一期...依此類推。

當使用頻率小於半年線時，用OpenH可以找到某期的半年開盤價。

範例：

```xs
plot1(OpenH(0)); //繪製當期半年線開盤價的連線
```

相關的函數包含:

- OpenD, OpenW, OpenM, OpenQ, OpenH, OpenY

- HighD, HighW, HighM, HighQ, HighH, HighY

- LowD, LowW, LowM, LowQ, LowH, LowY

- CloseD, CloseW, CloseM, CloseQ, CloseH, CloseY

## OpenM（月開盤價）

**語法**：取得月線的開盤價。
僅限使用於月線以下之頻率。
回傳數值=OpenM(期別)
傳入一個參數:
- 第一個參數是期別，和序列引用定義相同，0表當期、1表前一期...依此類推。

當使用頻率小於月線時，用OpenM可以找到某期的月開盤價。

範例：

```xs
plot1(OpenM(0)); //繪製當月開盤價的連線
plot2(OpenM(1)); //繪製前一月開盤價的連線
```

相關的函數包含:

- OpenD, OpenW, OpenM, OpenQ, OpenH, OpenY

- HighD, HighW, HighM, HighQ, HighH, HighY

- LowD, LowW, LowM, LowQ, LowH, LowY

- CloseD, CloseW, CloseM, CloseQ, CloseH, CloseY

## OpenQ（季開盤價）

**語法**：取得季線的開盤價。
僅限使用於季線以下之頻率。
回傳數值=OpenQ(期別)
傳入一個參數:
- 第一個參數是期別，和序列引用定義相同，0表當期、1表前一期...依此類推。

當使用頻率小於季線時，用OpenQ可以找到某期的季開盤價。

範例：

```xs
plot1(OpenQ(0)); //繪製當季開盤價的連線
plot2(OpenQ(1)); //繪製前一季開盤價的連線
```

相關的函數包含:

- OpenD, OpenW, OpenM, OpenQ, OpenH, OpenY

- HighD, HighW, HighM, HighQ, HighH, HighY

- LowD, LowW, LowM, LowQ, LowH, LowY

- CloseD, CloseW, CloseM, CloseQ, CloseH, CloseY

## OpenW（週開盤價）

**語法**：取得週線的開盤價。
僅限使用於週線以下之頻率。
回傳數值=OpenW(期別)
傳入一個參數:
- 第一個參數是期別，和序列引用定義相同，0表當期、1表前一期...依此類推。

當使用頻率小於週線時，用OpenW可以找到某期的週開盤價。

範例：

```xs
plot1(OpenW(0)); //繪製當週開盤價的連線
plot2(OpenW(1)); //繪製前一週開盤價的連線
```

相關的函數包含:

- OpenD, OpenW, OpenM, OpenQ, OpenH, OpenY

- HighD, HighW, HighM, HighQ, HighH, HighY

- LowD, LowW, LowM, LowQ, LowH, LowY

- CloseD, CloseW, CloseM, CloseQ, CloseH, CloseY

## OpenY（年開盤價）

**語法**：取得年線的開盤價。
僅限使用於年線以下之頻率。
回傳數值=OpenY(期別)
傳入一個參數:
- 第一個參數是期別，和序列引用定義相同，0表當期、1表前一期...依此類推。

當使用頻率小於年線時，用OpenY可以找到某期的年開盤價。

範例：

```xs
plot1(OpenY(0)); //繪製當年開盤價的連線
plot2(OpenY(1)); //繪製前一年開盤價的連線
```

相關的函數包含:

- OpenD, OpenW, OpenM, OpenQ, OpenH, OpenY

- HighD, HighW, HighM, HighQ, HighH, HighY

- LowD, LowW, LowM, LowQ, LowH, LowY

- CloseD, CloseW, CloseM, CloseQ, CloseH, CloseY

## TrueHigh（真實區間高點）

**語法**：取得價格真實區間(TrueRange)的高點。
回傳數值=TrueHigh

計算方法為比較當根K棒的高點與前根K棒的收盤價，取數值較大者。

範例：

```xs
plot1(TrueHigh);    //繪製當期真實區間高點的連線
plot2(TrueHigh[1]); //繪製前一期真實區間高點的連線
```

請參考 TrueLow函數以及TrueRange函數。

## TrueLow（真實區間低點）

**語法**：取得價格真實區間(TrueRange)的低點。
回傳數值=TrueLow

計算方法為比較當根K棒的低點與前根K棒的收盤價，取數值較小者。

範例：

```xs
plot1(TrueLow);    //繪製當期真實區間低點的連線
plot2(TrueLow[1]); //繪製前一期真實區間低點的連線
```

請參考 TrueHigh函數以及TrueRange函數。

## TypicalPrice（典型價）

**語法**：傳回技術分析的典型價。
回傳數值=TypicalPrice

計算公式：

典型價 = (當期最高價 + 當期最低價 + 當期收盤價)/3

範例：

```xs
plot1(TypicalPrice);    //繪製當期典型價的連線
plot2(TypicalPrice[1]); //繪製前一期典型價的連線
```

## WeightedClose（加權平均價）

**語法**：計算技術分析的加權平均收盤價。
回傳數值=WeightedClose

加權平均價給予收盤價較大的權重，著名的MACD指標即是利用加權平均價做計算。

計算公式：

WeightedClose = (當期最高價 + 當期最低價 + 2*當期收盤價)/4

範例：

```xs
plot1(WeightedClose);    //繪製當期加權平均收盤價的連線
plot2(WeightedClose[1]); //繪製前一期加權平均收盤價的連線
```
