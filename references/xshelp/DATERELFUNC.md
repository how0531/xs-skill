# 系統函數 - 日期相關（DATERELFUNC）

> 來源：https://xshelp.xq.com.tw/XSHelp/lists?a=DATERELFUNC（官方 XSHelp，自動爬取）

## angleprice（用N期至今的角度來計算趨勢線價格）

**語法**：傳回「N期至今的角度的趨勢線價格」
回傳數值=Angleprice(期數,角度)
傳入二個參數:
- 第一個參數是期數。
- 第二個參數是角度。

用前N期到現在的角度，運算出趨勢線的價格。

範例：

```xs
value1 = angleprice(5,0);
plot1(value1); //Value1為前五期的開盤價，因為第二個參數是0度，所以會等於前五期的開盤價。
```

更多的資訊，請參考常用語法匯總

## BarsLast（上次條件成立距今期數）

**語法**：取得上一次條件成立到當前的K棒數
回傳數值=BarsLast(條件數列)

計算目前K棒與上次條件成立K棒的期數差。例如，上次KD黃金交叉是幾天前。

回傳值為0表示條件成立當期，回傳值為1表示前1期條件成立，依此類推。

範例：

```xs
value1 = average(C,5);
value2 = average(C,20);
value3 = barslast(value1 cross over value2);       //計算上次5日均線和20日均線黃金交叉的期數差
value4 = low[value3];       //取得上次均線黃金交叉時的最低價做為支撐價
plot1(value4);       //繪製支撐價的連線
```

## DaysToExpiration（離到期日天數）

**語法**：計算台股指數類期貨商品的到期天數。
回傳數值=DaysToExpiration(商品月份,商品年份)
傳入二個參數:
- 第一個參數是商品月份。
- 第二個參數是商品年份。

台股指數類期貨商品的到期日期為該月的第三個星期三。此函數會計算特定合約距當期K棒的天數。

回傳值為1，表示當天為結算日。回傳值小於1，表示該合約已到期。

範例：

```xs
value1 = DaysToExpiration(month(date),year(date));
if value1 <= 1 then begin
	value2 = dateadd(date,"M",1);
	value2 = encodedate(year(value2),month(value2),1);
	value1 = DaysToExpiration(month(value2),year(value2));
end;
plot1(value1); //繪製最新的台股指數類期貨到期天數的連線
```

注意，此函數並無調整因放假而導致的到期日異動。

## DownTrend（判斷數列是否為趨勢向下）

**語法**：判斷某個序列是否趨勢向下。
回傳布林值=DownTrend(數列,期數)
傳入二個參數:
- 第一個參數是數列，可以是GetField("欄位名稱")。
- 第二個參數是期數。

計算序列資料是否趨勢向下。回傳布林值。
若為趨勢向上，則回傳「True」
若不為趨勢向上，則回傳「False」

## formatMQY（日期）

**語法**：依目前資料頻率取得代表日期字串。
回傳字串=formatMQY(參考日期)
傳入一個參數:
- 第一個參數是日期，格式為YYYYMMDD的數值。

formatMQY回傳的字串為：

- 當頻率為年時，回傳格式為YYYY的字串；例如：2015。

- 當頻率為季時，回傳格式為YYYYQQ的字串；例如：2015Q1。

- 當頻率為月時，回傳格式為YYYYMM的字串；例如：201501。

- 當其他頻率時，回傳格式為YYYYMMDD的字串；例如：20150103。

範例：

```xs
var: string1("");
string1 = formatMQY(date); //將日期轉換為MQY格式的字串
print(date," ",string1);
```

## GetLastTradeDate（取得台灣期交所指數期貨的到期日）

**語法**：取得台股指數類期貨商品的到期日期（該月第三個星期三）。
回傳數值=GetLastTradeDate(商品月份,商品年份)
傳入二個參數:
- 第一個參數是商品月份。
- 第二個參數是商品年份。

依台灣期貨交易所規定台股指數類期貨商品的到期日期為該月的第三個星期三。

函數回傳值的格式為8碼數字: **YYYYMMDD**。

範例：

```xs
value1 = GetLastTradeDate(7,2015); //取得台股指數類期貨2015年7月合約的到期日
```

注意，此函數並無調整因放假而導致的到期日異動。

## LastDayOfMonth（月的最後一個日曆天）

**語法**：取得指定月份的天數。
回傳數值=LastDayOfMonth(月份)
傳入一個參數:
- 第一個參數是月份，1為1月、2為2月...依此類推。

傳回指定月份的天數。

例如：一月有31天、二月只有28天、四月有30天。

範例：

```xs
value1 = LastDayOfMonth(month(date)); //取得當月的天數
```

## NDaysAngle（計算股價N日走勢的角度）

**語法**：計算股價N期走勢的角度
回傳數值=NDaysAngle(期數)

計算股價N期走勢的角度。回傳數值。
若為上漲趨勢，則回傳「0 ~ 90」度
若為下跌趨勢，則回傳「0 ~ -90」度

範例：
input:_Length(10,"期數");        //計算10期走勢的角度
plot1(NDaysAngle(_Length),"走勢角度");

## NthDayofMonth（自開始日算的第N個星期序數(周日、周一…)發生日期）

**語法**：取得指定日期後第N個星期幾的日期。
回傳數值=NthDayOfMonth(參考日期,第幾個,星期幾)
傳入三個參數:
- 第一個參數是日期，格式為YYYYMMDD的數值。
- 第二個參數是第幾個，可以是正數(表示往後找), 也可以是負數(表示往前找)。
- 第三個參數是星期幾：0為星期日，1為星期一，2為星期二，3為星期三，4為星期四，5為星期五，6為星期六

NthDayOfMonth回傳的數值是YYYYMMDD的日期格式。

範例：

```xs
value1 = NthDayOfMonth(date,3,1)); //取得未來第3個星期一的日期
```

## UpTrend（判斷某個序列是否趨勢朝上）

**語法**：判斷某個數列是否趨勢向上。
回傳布林值=UpTrend(數列,期數)
傳入二個參數:
- 第一個參數是數列，可以是GetField("欄位名稱")。
- 第二個參數是期數。

計算序列資料是否趨勢向上。回傳布林值。
若為趨勢向上，則回傳「True」
若不為趨勢向上，則回傳「False」
