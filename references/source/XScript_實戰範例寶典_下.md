# XScript 實戰範例寶典（下）

自動整理自 [https://www.xq.com.tw/xstrader/](https://www.xq.com.tw/xstrader/) 本冊收錄場景 620～1241（共 622 段程式碼）

## 場景 620：估值高折價股盤整後出量 — 但這樣挑出來的股票，還不見得要馬上進場，最好是等到這檔股票落底之後才進場，所以我就用以下的腳本來挑出那些估值高折價且過去一段時間處於盤整階段，然後現在開始出量上...

來源：[估值高折價股盤整後出量](https://www.xq.com.tw/xstrader/%e4%bc%b0%e5%80%bc%e9%ab%98%e6%8a%98%e5%83%b9%e8%82%a1%e7%9b%a4%e6%95%b4%e5%be%8c%e5%87%ba%e9%87%8f/) 說明：但這樣挑出來的股票，還不見得要馬上進場，最好是等到這檔股票落底之後才進場，所以我就用以下的腳本來挑出那些估值高折價且過去一段時間處於盤整階段，然後現在開始出量上揚的標的。

Input: day(10,"日期區間");

 Input: ratioLimit(5, "區間最大漲幅%");

 

 Condition1 \= C=highest(C,day);

 //今日最高創區間最高價

 

 Condition2 \= V=highest(v,day);

 //今日成交量創區間最大量

 

 Condition3 \= highest(H,day) \< lowest(L,day)\*(1 \+ ratioLimit\*0.01);

 //今日最高價距離區間最低價漲幅尚不大

 

 Ret \= Condition1 And Condition2 And Condition3;

---

## 場景 621：夠便宜且整理結束 — 一個是關於估值及營收成長的，我寫的腳本如下

來源：[夠便宜且整理結束](https://www.xq.com.tw/xstrader/%e5%a4%a0%e4%be%bf%e5%ae%9c%e4%b8%94%e6%95%b4%e7%90%86%e7%b5%90%e6%9d%9f/) 說明：一個是關於估值及營收成長的，我寫的腳本如下

input:lowbond(0,"eps下限");

input:lowbond1(10,"累計營收yoy下限");

input:lowbond2(8,"本業本益比上限");

if getField("每股營業利益(元)", "Q")\>=lowbond

and getField("累計營收年增率", "M")\>=lowbond1

and close/(getfield("每股營業利益(元)", "Q")\*4)\<=lowbond2

then ret=1;

outputfield(1,getfield("每股營業利益(元)", "Q"),2,"本業eps ");

outputfield(2,close/(getfield("每股營業利益(元)", "Q")\*4),1,"本業本益比");

outputfield(3,getField("累計營收年增率", "M"),1,"累計營收年增率");

outputfield(4,getfielddate("每股稅後淨利(元)", "Q"),0,"財報日期");

---

## 場景 622：夠便宜且整理結束 — 在技術面則是關於整理後帶量突破的腳本

來源：[夠便宜且整理結束](https://www.xq.com.tw/xstrader/%e5%a4%a0%e4%be%bf%e5%ae%9c%e4%b8%94%e6%95%b4%e7%90%86%e7%b5%90%e6%9d%9f/) 說明：在技術面則是關於整理後帶量突破的腳本

Input: day(20,"日期區間");

 Input: ratioLimit(7, "區間最大漲幅%");

 

 Condition1 \= C=highest(C,day);

 //今日最高創區間最高價

 

 Condition2 \= V=highest(v,day);

 //今日成交量創區間最大量

 

 Condition3 \= highest(H,day) \< lowest(L,day)\*(1 \+ ratioLimit\*0.01);

 //今日最高價距離區間最低價漲幅尚不大

 

 Ret \= Condition1 And Condition2 And Condition3;

---

## 場景 623：好公司，夠便宜\~David Dreman的選股方法 — 其中所用的預估本益比腳本如下

來源：[好公司，夠便宜\~David Dreman的選股方法](https://www.xq.com.tw/xstrader/%e5%a5%bd%e5%85%ac%e5%8f%b8%ef%bc%8c%e5%a4%a0%e4%be%bf%e5%ae%9cdavid-dreman%e7%9a%84%e9%81%b8%e8%82%a1%e6%96%b9%e6%b3%95/) 說明：其中所用的預估本益比腳本如下

input:peuplimit(15,"預估本益比上限");

value3= summation(GetField("營業利益","Q"),4); //單位百萬;

value4= GetField("最新股本");//單位億;

value5= value3/(value4\*10);//每股預估EPS

if value5\>0 and close/value5\<=peuplimit

then ret=1;

---

## 場景 624：長期盤整後的資金流向轉正 — 佔大盤成交量比開始上昇

來源：[長期盤整後的資金流向轉正](https://www.xq.com.tw/xstrader/%e9%95%b7%e6%9c%9f%e7%9b%a4%e6%95%b4%e5%be%8c%e7%9a%84%e8%b3%87%e9%87%91%e6%b5%81%e5%90%91%e8%bd%89%e6%ad%a3/) 說明：佔大盤成交量比開始上昇

value1=GetField("佔全市場成交量比","D");

SetTotalBar(5);

if value1\[4\]=lowest(value1,5) and 

 value1=highest(value1,5) and 

 close crosses above average(close,5)

then ret=1;

SetOutputName1("佔全市場成交量比(%)");

OutputField1(value1);

---

## 場景 625：長期盤整後的資金流向轉正

來源：[長期盤整後的資金流向轉正](https://www.xq.com.tw/xstrader/%e9%95%b7%e6%9c%9f%e7%9b%a4%e6%95%b4%e5%be%8c%e7%9a%84%e8%b3%87%e9%87%91%e6%b5%81%e5%90%91%e8%bd%89%e6%ad%a3/) 說明：區間波動小於N%

input:n(10,"區間波動範圍%");

input:period(30,"區間長度");

if lowest(close\[1\],period)\*(1+n/100)\>highest(close\[1\],period)

then ret=1;

---

## 場景 626：長期未破底後創新高的選股策略 — 其中長時間未破底後創新高的腳本如下

來源：[長期未破底後創新高的選股策略](https://www.xq.com.tw/xstrader/%e9%95%b7%e6%9c%9f%e6%9c%aa%e7%a0%b4%e5%ba%95%e5%be%8c%e5%89%b5%e6%96%b0%e9%ab%98%e7%9a%84%e9%81%b8%e8%82%a1%e7%ad%96%e7%95%a5/) 說明：其中長時間未破底後創新高的腳本如下

input:period(90);

input:percent(25);

setinputname(1,"未破底區間");

setinputname(2,"盤整區間漲幅上限");

condition1=false;

condition2=false;

value1=lowest(low,period);

if value1=low\[period-1\]

then condition1=true;

if highest(high\[1\],period)\<=value1\*(1+percent/100)

then condition2=true;

if condition1 and condition2 and close crosses over highest(close\[1\],period)

then ret=1;

---

## 場景 627：回檔整理後的加速上漲 — 下面的腳本，就是在找大跌後動能在加速的標的

來源：[回檔整理後的加速上漲](https://www.xq.com.tw/xstrader/%e5%9b%9e%e6%aa%94%e6%95%b4%e7%90%86%e5%be%8c%e7%9a%84%e5%8a%a0%e9%80%9f%e4%b8%8a%e6%bc%b2/) 說明：下面的腳本，就是在找大跌後動能在加速的標的

input: Length(10, "天數");

value1 \= Momentum(Close, Length); 

value2 \= Momentum(value1, Length);

if value2 crosses over 0 

and close\[60\]\>close\*1.1

then ret=1;

---

## 場景 628：布林值指標翻多 — 根據這樣的邏輯，所寫的腳本如下

來源：[布林值指標翻多](https://www.xq.com.tw/xstrader/%e5%b8%83%e6%9e%97%e5%80%bc%e6%8c%87%e6%a8%99%e7%bf%bb%e5%a4%9a/) 說明：根據這樣的邏輯，所寫的腳本如下

condition1=false;

 

setbackbar(20);

input:length(20);

variable:up1(0),down1(0),mid1(0),bbandwidth(0);

up1 \= bollingerband(Close, Length, 2);

down1 \= bollingerband(Close, Length, \-2 );

mid1 \= (up1 \+ down1) / 2;

bbandwidth \= 100 \* (up1 \- down1) / mid1;

if linearregslope(up1,10)\[1\]\<0

and linearregslope(down1,10)\[1\]\>0

and bbandwidth\[1\]\*1.1\<average(bbandwidth,20)\[1\]

and close crosses over mid1

and close crosses over highest(high\[1\],2)

then ret=1;

---

## 場景 629：葛拉罕的價值投資標的 — 我寫了一個選股腳本來選符合這個條件的股票

來源：[葛拉罕的價值投資標的](https://www.xq.com.tw/xstrader/%e8%91%9b%e6%8b%89%e7%bd%95%e7%9a%84%e5%83%b9%e5%80%bc%e6%8a%95%e8%b3%87%e6%a8%99%e7%9a%84/) 說明：我寫了一個選股腳本來選符合這個條件的股票

value1=GetField("流動資產","Q");//單位是百萬

value2=GetField("負債總額","Q");//單位是百萬

value3=GetField("總市值","D");//單位是億

if 2\*(value1-value2)\>3\*value3\*100

then ret=1;

if value3\<\>0 then value4=(value1-value2)/(value3\*100);

outputfield(1,value4,2,"流動資產減負債佔總市值比");

---

## 場景 630：近幾日總收黑

來源：[近幾日總收黑](https://www.xq.com.tw/xstrader/%e8%bf%91%e5%b9%be%e6%97%a5%e7%b8%bd%e6%94%b6%e9%bb%91/) 說明：對應的腳本如下

if countif(close\<open,7)\>=5

//過去七天有五天以上收黑

and volume\*1.2\<average(volume,20)

//成交量比二十日均量減少超過兩成

then ret=1;

---

## 場景 631：跌破上昇趨勢 — 基於這樣的想法，所寫的腳本如下

來源：[跌破上昇趨勢](https://www.xq.com.tw/xstrader/%e8%b7%8c%e7%a0%b4%e4%b8%8a%e6%98%87%e8%b6%a8%e5%8b%a2/) 說明：基於這樣的想法，所寫的腳本如下

input:Length(10); setinputname(1,"上升趨勢計算期數");

input:\_Angle(30); setinputname(2,"上升趨勢角度");

settotalbar(Length \+ 3);

variable: TrendAngle(0);

variable: TrendAngleDelta(0);

if Close\< Close\[1\] and Close\[1\] \<Close\[2\] and Close\[Length\]\>0 then begin

linearreg((high/Close\[Length\]-1)\*100,Length,0,value1,TrendAngle,value3,value4);

 

TrendAngleDelta \=TrendAngle-TrendAngle\[1\];

IF TrendAngleDelta-TrendAngleDelta\[1\] \< \-10 and close \>Close\[Length\] THEN RET=1;

 

end;

---

## 場景 632：井字型死亡交叉

來源：[井字型死亡交叉](https://www.xq.com.tw/xstrader/%e4%ba%95%e5%ad%97%e5%9e%8b%e6%ad%bb%e4%ba%a1%e4%ba%a4%e5%8f%89/) 說明：對應的腳本如下

variable:a5(0),a10(0),a20(0),a30(0);

a5=average(close,5);

a10=average(close,10);

a20=average(close,20);

a30=average(close,30);

if linearregslope(a5,5)\<0

and linearregslope(a10,5)\<0

and linearregslope(a20,5)\>0

and linearregslope(a30,5)\>0

then ret=1;

---

## 場景 633：OBV指標

來源：[OBV指標](https://www.xq.com.tw/xstrader/obv%e9%80%80%e6%bd%ae%e7%a0%b4%e5%ba%95/) 說明：對應的腳本如下：

input:Length(15); setinputname(1,"計算期數");

variable: OBVolume(0),Kprice(0);

value1 \= close-close\[1\];

if close\<\> close\[1\] then 

 OBVolume \+= Volume\*(value1)/absvalue(value1);

 if close\<highest(high,Length) and

 OBVolume\[2\]=highest(OBVolume,Length) and 

 OBVolume=lowest(OBVolume,3)

 then Kprice \=L ;

 

 Ret= Close crosses under Kprice;

---

## 場景 634：MACD死亡交叉關鍵價跌破 — 根據這樣的邏輯所寫的腳本如下：

來源：[MACD死亡交叉關鍵價跌破](https://www.xq.com.tw/xstrader/macd%e6%ad%bb%e4%ba%a1%e4%ba%a4%e5%8f%89%e9%97%9c%e9%8d%b5%e5%83%b9%e8%b7%8c%e7%a0%b4/) 說明：根據這樣的邏輯所寫的腳本如下：

input: FastLength(12), SlowLength(26), MACDLength(9);

variable: difValue(0), macdValue(0), oscValue(0),Kprice(0);

SetInputName(1, "DIF短期期數");

SetInputName(2, "DIF長期期數");

SetInputName(3, "MACD期數");

MACD(weightedclose(), FastLength, SlowLength, MACDLength, difValue, macdValue, oscValue);

if difValue Crosses Below macdValue then Kprice \=L;

if Close crosses under Kprice then ret=1;

---

## 場景 635：DMI翻空

來源：[DMI翻空](https://www.xq.com.tw/xstrader/dmi%e7%bf%bb%e7%a9%ba/) 說明：以下是對應的腳本

input:Length(14); setinputname(1,"計算期數");

variable: pdi(0), ndi(0), adx\_value(0);

DirectionMovement(Length, pdi, ndi, adx\_value);

if pdi\<pdi\[1\] and ndi\>ndi\[1\] and ndi crosses over pdi then ret=1;

---

## 場景 636：DIF-MACD翻負 — 以下是這個賣出訊號的腳本

來源：[DIF-MACD翻負](https://www.xq.com.tw/xstrader/dif-macd%e7%bf%bb%e8%b2%a0/) 說明：以下是這個賣出訊號的腳本

// DIF-MACD翻負

input: FastLength(12, "DIF短期期數"), SlowLength(26, "DIF長期期數"), MACDLength(9, "MACD期數");

variable: difValue(0), macdValue(0), oscValue(0);

MACD(weightedclose(), FastLength, SlowLength, MACDLength, difValue, macdValue, oscValue);

 

if oscValue Crosses Below 0

then ret=1;

---

## 場景 637：多次到底而破

來源：[多次到底而破](https://www.xq.com.tw/xstrader/%e5%a4%9a%e6%ac%a1%e8%87%b3%e5%ba%95%e8%80%8c%e7%a0%b4/) 說明：對應的腳本如下：

input:day(100);

input:band1(4);

setinputname(1,"計算區間");

setinputname(2,"三高點之高低價差");

value1=nthlowest(1,low\[1\],day);

value2=nthlowest(3,low\[1\],day);

value4=nthlowestbar(1,low,day);

value5=nthlowestbar(3,low,day);

value6=nthlowestbar(5,low,day);

value7=absvalue(value4-value6);

value8=absvalue(value5-value6);

value9=absvalue(value4-value5);

condition1=false;

if value7\>3 and value8\>3 and value9\>3

then condition1=true;

value3=(value1-value2)/value2;

if value3\<=band1/100

and close crosses under value1

and volume\>2000

and condition1

then ret=1;

---

## 場景 638：CCI超買反轉直下 — 所以當C CI是個乖離概念，那麼我們就可以寫一個腳本，找出當CCI超過100超買之後，如果價格跌破當被超買時的股價低點，把它視為一個賣出訊號，下面就是這麼一個腳...

來源：[CCI超買反轉直下](https://www.xq.com.tw/xstrader/cci%e8%b6%85%e8%b2%b7%e5%8f%8d%e8%bd%89%e7%9b%b4%e4%b8%8b/) 說明：所以當C CI是個乖離概念，那麼我們就可以寫一個腳本，找出當CCI超過100超買之後，如果價格跌破當被超買時的股價低點，把它視為一個賣出訊號，下面就是這麼一個腳本

Input: Length(14), AvgLength(9), Overbought(100);

Variable: cciValue(0), cciMAValue(0),KPrice(0);

SetInputName(1, "期數");

SetInputName(2, "平滑期數");

SetInputName(3, "超買值");

cciValue \= CommodityChannel(Length);

cciMAValue \= Average(cciValue, AvgLength);

if cciMAValue Crosses Above OverBought then KPrice \=L;;

if Close crosses under KPrice then ret=1;

---

## 場景 639：好久沒出現的連五日上漲 — 我們可以把這個現象寫成腳本如下

來源：[好久沒出現的連五日上漲](https://www.xq.com.tw/xstrader/%e5%a5%bd%e4%b9%85%e6%b2%92%e5%87%ba%e7%8f%be%e7%9a%84%e9%80%a3%e4%ba%94%e6%97%a5%e4%b8%8a%e6%bc%b2/) 說明：我們可以把這個現象寫成腳本如下

setbarback(100);

if trueall(close\>close\[1\],5)

and barslast(trueall(close\>close\[1\],5))\[1\]\>100

then ret=1;

//40天後出場

---

## 場景 640：多方勢力壓過空方 — 根據這樣的精神，對應的腳本如下

來源：[多方勢力壓過空方](https://www.xq.com.tw/xstrader/%e5%a4%9a%e6%96%b9%e5%8b%a2%e5%8a%9b%e5%a3%93%e9%81%8e%e7%a9%ba%e6%96%b9/) 說明：根據這樣的精神，對應的腳本如下

input:day(5,"短期參數"),period(10,"長期參數");

value1=summation(high-close,period);//上檔賣壓

value2=summation(close-open,period); //多空實績

value3=summation(close-low,period);//下檔支撐

value4=summation(open-close\[1\],period);//隔夜力道

if close\<\>0

then

value5=(value2+value3+value4-value1)/close\*100;

value6=linearregslope(value5,period);

if trueall(value6\[1\]\<0,10)

and value6\>0

and value5 \<0

then ret=1;

---

## 場景 641：碗型底

來源：[碗型底](https://www.xq.com.tw/xstrader/%e7%a2%97%e5%9e%8b%e5%ba%95/) 說明：我們寫的腳本如下

input:t2(60,"敏感度(T)"),S1(true,"T=早訊號,F=晚訊號");

variable:t1(1);

value1=(H+L+O+C)/4;

value2=square(H)+square(L)+square(O)+square(C);

value14+=value2;

if value2\[t2\]\<\>0 then value14-=value2\[t2\];

value15+=value1;

if value1\[t2\]\<\>0 then value15-=value1\[t2\];

value16=(value14-t2\*4\*square(value15/t2))/(t2\*4);

value17=mtm(t2/2);

value18=wma(value17,round(t2\*0.2,0));

value19=wma(value16,round(t2\*0.2,0));

condition1=s1 and value19\<value19\[1\] and value18\>value18\[1\];

condition3=not s1 and value18 crosses over 0;

if value18 crosses under 0 then condition2=true;

if trueall(value19\>value19\[1\] and value18\<value18\[1\],t2\*0.1) then condition4=true;

if (condition1 or condition3) and condition2 and condition4

then begin

 condition2=false;

 condition4=false;

 ret=1;

end;

---

## 場景 642：趨向指標轉向多頭（ADX趨勢成形） — 要印證這樣的想法，對應的腳本如下

來源：[趨向指標轉向多頭（ADX趨勢成形）](https://www.xq.com.tw/xstrader/%e8%b6%a8%e5%90%91%e6%8c%87%e6%a8%99%e8%bd%89%e5%90%91%e5%a4%9a%e9%a0%ad%ef%bc%88adx%e8%b6%a8%e5%8b%a2%e6%88%90%e5%bd%a2%ef%bc%89/) 說明：要印證這樣的想法，對應的腳本如下

input: Length(14), Threshold(25);

variable: pdi\_value(0), ndi\_value(0), adx\_value(0);

settotalbar(maxlist(Length,6) \* 13 \+ 8);

SetInputName(1, "期數");

SetInputName(2, "穿越值");

DirectionMovement(Length, pdi\_value, ndi\_value, adx\_value);

if adx\_value Crosses Above Threshold

then ret=1;;

---

## 場景 643：價量配合良好 — 根據這樣的想法，我們可以應用以下的腳本

來源：[價量配合良好](https://www.xq.com.tw/xstrader/%e5%83%b9%e9%87%8f%e9%85%8d%e5%90%88%e8%89%af%e5%a5%bd/) 說明：根據這樣的想法，我們可以應用以下的腳本

variable:x(0),count(0);

count=0;

for x=0 to 10

begin

if close\>close\[1\]xor volume\>volume\[1\]

//價量背離

then count=count+1;

end;

if count\<=3//近十日價量背離頂多3天

then begin

if average(close,5)crosses over average(close,20)

//且五日均量突破20日均量

then ret=1;

end;

---

## 場景 644：價量都呈多頭排列 — 根據上述想法的腳本如下

來源：[價量都呈多頭排列](https://www.xq.com.tw/xstrader/%e5%83%b9%e9%87%8f%e9%83%bd%e5%91%88%e5%a4%9a%e9%a0%ad%e6%8e%92%e5%88%97/) 說明：根據上述想法的腳本如下

value1=average(close,5);

value2=average(close,20);

value3=average(close,60);

value4=average(volume,5);

value5=average(volume,20);

value6=average(volume,60);

if value1\>value2 

and value2\>value3

and value4\>value5

and value5\>value6

then ret=1;

---

## 場景 645：往上走勢超強 — 根據上述概念所寫的腳本如下

來源：[往上走勢超強](https://www.xq.com.tw/xstrader/%e5%be%80%e4%b8%8a%e8%b5%b0%e5%8b%a2%e8%b6%85%e5%bc%b7/) 說明：根據上述概念所寫的腳本如下

input:length(20,"布林值計算天數");

variable:up1(0),down1(0),mid1(0),bbandwidth(0);

up1 \= bollingerband(Close, Length, 2); 

//以上是計算布林值的上軌值

input: day(9, "日KD期間");

variable:rsv\_d(0),kk\_d(0),dd\_d(0);

stochastic(day, 3, 3, rsv\_d, kk\_d, dd\_d);

//以上是計算KD值

if kk\_d \>=80

//KD鈍化

and close crosses over up1

then ret=1;

---

## 場景 646：多頭走勢剛剛開始（濾除盤整的趨勢化操作） — 根據這樣的精神所寫的腳本如下

來源：[多頭走勢剛剛開始（濾除盤整的趨勢化操作）](https://www.xq.com.tw/xstrader/%e5%a4%9a%e9%a0%ad%e8%b5%b0%e5%8b%a2%e5%89%9b%e5%89%9b%e9%96%8b%e5%a7%8b%ef%bc%88%e6%bf%be%e9%99%a4%e7%9b%a4%e6%95%b4%e7%9a%84%e8%b6%a8%e5%8b%a2%e5%8c%96%e6%93%8d%e4%bd%9c%ef%bc%89/) 說明：根據這樣的精神所寫的腳本如下

input:n1(10);

input:n2(10);

setinputname(1,"計算區間");

setinputname(2,"短天期移動平均");

value1=absvalue(close-close\[n1-1\]);

value2=summation(range,n1);

if value1=0

 then return

else

 value3=value2/value1;

 value4=average(value3,n2);

if value4\<=10

and close crosses over average(close,10)

then ret=1;

---

## 場景 647：市場趨勢轉上 — 根據上述精神所寫的腳本如下

來源：[市場趨勢轉上](https://www.xq.com.tw/xstrader/%e5%b8%82%e5%a0%b4%e8%b6%a8%e5%8b%a2%e8%bd%89%e4%b8%8a/) 說明：根據上述精神所寫的腳本如下

value1=(highest(high,9)+lowest(low,9))/2;//轉換線

value2=(highest(high,26)+lowest(low,26))/2;//基準線

value3=(value1+value2)/2;//前移指標A

value4=(highest(high,52)+lowest(low,52))/2;//前移指標B

if close crosses over value1 

and close crosses over value2

and close crosses over maxlist(value3,value4)

then ret=1;

---

## 場景 648：百日來首次創百日新高

來源：[百日來首次創百日新高](https://www.xq.com.tw/xstrader/%e7%99%be%e6%97%a5%e4%be%86%e9%a6%96%e6%ac%a1%e5%89%b5%e7%99%be%e6%97%a5%e6%96%b0%e9%ab%98/) 說明：對應的腳本如下

input:period(100,"計算創新高區間");

if close=highest(close,period)//股價創新高

and barslast(close=highest(close,period))\[1\]

\>100

then ret=1;

---

## 場景 649：震盪走高 — 遵循這樣概念，對應的腳本如下

來源：[震盪走高](https://www.xq.com.tw/xstrader/%e9%9c%87%e7%9b%aa%e8%b5%b0%e9%ab%98/) 說明：遵循這樣概念，對應的腳本如下

value1=high-low;

value2=highest(value1,20);

if value1\>value2\[1\]

and value1\>value1\[1\]

and close=highest(close,10)

then ret=1;

---

## 場景 650：突破股價波動均勢（ATR通道突破） — 以下就是遵循上述概念所寫的腳本

來源：[突破股價波動均勢（ATR通道突破）](https://www.xq.com.tw/xstrader/%e7%aa%81%e7%a0%b4%e8%82%a1%e5%83%b9%e6%b3%a2%e5%8b%95%e5%9d%87%e5%8b%a2%ef%bc%88atr%e9%80%9a%e9%81%93%e7%aa%81%e7%a0%b4%ef%bc%89/) 說明：以下就是遵循上述概念所寫的腳本

input:period(20,"計算truerange的區間");

value1=average(truerange,period);

value2=average(close,period)+2\*value1;

if close crosses over value2

then ret=1;

---

## 場景 651：循環由下往上翻

來源：[循環由下往上翻](https://www.xq.com.tw/xstrader/%e5%be%aa%e7%92%b0%e7%94%b1%e4%b8%8b%e5%be%80%e4%b8%8a%e7%bf%bb/) 說明：以下是對應的腳本

input:period(20);

input:delta(0.5);

input:fraction(0.1);

variable:price(0);

variable:alpha(0),beta(0),gamma(0),bp(0),i(0),mean(0);

price=(h+l)/2;

beta=cosine(360/period);

gamma=1/cosine(720\*delta/period);

alpha=gamma-squareroot(gamma\*gamma-1);

bp=0.5\*(1-alpha)\*(price-price\[2\])+beta\*(1+alpha)\*bp\[1\]-alpha\*bp\[2\];

mean=average(bp,2\*period);

if mean crosses over 0

then ret=1;

---

## 場景 652：上漲天數變多 — 上述的概念可以寫成以下的腳本

來源：[上漲天數變多](https://www.xq.com.tw/xstrader/%e4%b8%8a%e6%bc%b2%e5%a4%a9%e6%95%b8%e8%ae%8a%e5%a4%9a/) 說明：上述的概念可以寫成以下的腳本

input:count1(20);

input:count2(10);

value1=countif(close\>close\[1\],count1);

value2=countif(close\>close\[1\],count2);

value3=value1-value2;

if value3 crosses over 3 then ret=1;

---

## 場景 653：ＫＤ低檔黃金交叉 — 這個策略的對應腳本如下

來源：[ＫＤ低檔黃金交叉](https://www.xq.com.tw/xstrader/%ef%bd%8b%ef%bd%84%e4%bd%8e%e6%aa%94%e9%bb%83%e9%87%91%e4%ba%a4%e5%8f%89/) 說明：這個策略的對應腳本如下

input: Length(9), RSVt(3), Kt(3), Bound(30);

SetInputName(1, "計算期數");

SetInputName(2, "RSVt權數");

SetInputName(3, "Kt權數");

setInputName(4, "邊區");

variable: rsv(0), k(0), \_d(0);

Stochastic(Length, RSVt, Kt, rsv, k, \_d);

 

if k \< Bound and k crosses over \_d 

 

then ret=1;

---

## 場景 654：盤整後價量齊揚 — 根據這樣的想法，可以寫成以下的腳本

來源：[盤整後價量齊揚](https://www.xq.com.tw/xstrader/%e7%9b%a4%e6%95%b4%e5%be%8c%e5%83%b9%e9%87%8f%e9%bd%8a%e6%8f%9a/) 說明：根據這樣的想法，可以寫成以下的腳本

input:period(20,"盤整區間");

value1=highest(high\[1\],period);

value2=lowest(low\[1\],period);

if value1\<value2\*1.05 then begin

if close \>close\[1\]\*1.005

and volume\>=average(volume,20)\*2

then ret=1;

end;

---

## 場景 655：出現攻擊仰角 — 根據這樣的想法，可以寫出以下的腳本

來源：[出現攻擊仰角](https://www.xq.com.tw/xstrader/%e5%87%ba%e7%8f%be%e6%94%bb%e6%93%8a%e4%bb%b0%e8%a7%92/) 說明：根據這樣的想法，可以寫出以下的腳本

input: period(40,"計算區間");

value1=rateofchange(close,period);

//計算區間漲跌幅

value2=arctangent(value1/period\*100);

//計算上漲的角度

if value2 crosses over 35

then ret=1;

---

## 場景 656：好久都沒有破底且創新高 — 根據這樣的概念，可以寫出以下的腳本

來源：[好久都沒有破底且創新高](https://www.xq.com.tw/xstrader/%e5%a5%bd%e4%b9%85%e9%83%bd%e6%b2%92%e6%9c%89%e7%a0%b4%e5%ba%95%e4%b8%94%e5%89%b5%e6%96%b0%e9%ab%98/) 說明：根據這樣的概念，可以寫出以下的腳本

input:period(90);

input:percent(20);

setinputname(1,"未破底區間");

setinputname(2,"盤整區間漲幅上限");

condition1=false;

condition2=false;

value1=lowest(low,period);

if value1=low\[period-1\]

then condition1=true;

if highest(high\[1\],period)\<=value1\*(1+percent/100)

then condition2=true;

if condition1 and condition2 and close crosses over highest(close\[1\],period)

then ret=1;

---

## 場景 657：突破重大壓力區 — 上述的想法，可以寫成腳本如下

來源：[突破重大壓力區](https://www.xq.com.tw/xstrader/%e7%aa%81%e7%a0%b4%e9%87%8d%e5%a4%a7%e5%a3%93%e5%8a%9b%e5%8d%80/) 說明：上述的想法，可以寫成腳本如下

condition1=false;

input:HitTimes(4,"觸頂次數");

input:RangeRatio(0.5,"頭部區範圍寬度%");

input:Length(30,"計算期數");

value2=highestbar(high\[1\],length);

variable: theHigh(0); 

theHigh \= Highest(High\[1\],Length);

//找到過去其間的最高點

variable: HighLowerBound(0); 

 HighLowerBound \= theHigh \*(100-RangeRatio)/100; 

// 設為瓶頸區間上界

variable: TouchRangeTimes(0); 

//期間中進入瓶頸區間的低點次數,每跟K棒要歸0

 

//回算在此區間中 進去瓶頸區的次數 

TouchRangeTimes \= CountIF(High\[1\] \> HighLowerBound, Length);

 

if TouchRangeTimes \>= HitTimes 

and

close crosses over thehigh

and thehigh\>close\[length+15\]\*1.05

and value2\>=15

//高點在前十五根以前

then condition1=true;

value1=barslast(condition1);

if condition1

and value1\[1\]\>5

then ret=1;

---

## 場景 658：大跌後突破短中長期平均成本 — 根據上述的推論，對應的腳本如下

來源：[大跌後突破短中長期平均成本](https://www.xq.com.tw/xstrader/%e5%a4%a7%e8%b7%8c%e5%be%8c%e7%aa%81%e7%a0%b4%e7%9f%ad%e4%b8%ad%e9%95%b7%e6%9c%9f%e5%b9%b3%e5%9d%87%e6%88%90%e6%9c%ac/) 說明：根據上述的推論，對應的腳本如下

input: s1(5,"短期均線期數");

input: s2(10,"中期均線期數");

input: s3(20,"長期均線期數");

input: Percent(2,"均線糾結區間%");

variable: shortaverage(0);

variable: midaverage(0);

variable: Longaverage(0);

shortaverage \= average(close,s1);

midaverage \= average(close,s2);

Longaverage \= average(close,s3);

value1= absvalue(shortaverage \-midaverage);

value2= absvalue(midaverage \-Longaverage);

value3= absvalue(Longaverage \-shortaverage);

value4= maxlist(value1,value2,value3);

if value4\*100 \< Percent\*Close

and linearregangle(value4,5)\<10

//均線糾結在一起

and close\*1.1\<close\[90\]

//最近90個交易日跌了超過1成

and close crosses over shortaverage

then ret=1;

---

## 場景 659：箱型突破

來源：[箱型突破](https://www.xq.com.tw/xstrader/%e7%ae%b1%e5%9e%8b%e7%aa%81%e7%a0%b4/) 說明：對應的腳本如下

input:period(40,"計算區間");

value1=highest(close\[1\],period);

value2=lowest(close\[1\],period);

if value1\<value2\*1.05

and close\>close\[2\]\*1.006

and close crosses over value1

and volume\>average(volume\[1\],20)\*1.3

then ret=1;

---

## 場景 660：日線週線的均線都黃金交叉 — 這樣的概念，對應的腳本可以如下面這樣的寫法

來源：[日線週線的均線都黃金交叉](https://www.xq.com.tw/xstrader/%e6%97%a5%e7%b7%9a%e9%80%b1%e7%b7%9a%e7%9a%84%e5%9d%87%e7%b7%9a%e9%83%bd%e9%bb%83%e9%87%91%e4%ba%a4%e5%8f%89/) 說明：這樣的概念，對應的腳本可以如下面這樣的寫法

if average(close,5)crosses over average(close,10)

and 

 xf\_CrossOver("W",Average(GetField("收盤價","W")\[1\],5)\[1\],

 Average(GetField("收盤價","W")\[1\] ,10))

 then ret=1;

---

## 場景 661：下檔有撐（三下影線完成打底） — 根據上述的理論，對應的腳本如下

來源：[下檔有撐（三下影線完成打底）](https://www.xq.com.tw/xstrader/%e4%b8%8b%e6%aa%94%e6%9c%89%e6%92%90%ef%bc%88%e4%b8%89%e4%b8%8b%e5%bd%b1%e7%b7%9a%e5%ae%8c%e6%88%90%e6%89%93%e5%ba%95%ef%bc%89/) 說明：根據上述的理論，對應的腳本如下

input: Percent(0.5,"下影線佔股價絕對百分比");

variable:Kprice(0),OCDate(0);

condition1 \= (minlist(open,close)-Low) \> absvalue(open-close)\*2; 

condition2 \= minlist(open, close) \> low\* (100 \+ Percent)/100;

if trueall( condition1 and condition2, 3\) then begin

 OCDate \= Date;

 Kprice \= average(H,3);

end;

if DateDiff(Date,OCDate) \<3 and Close crosses over Kprice then ret \= 1;

---

## 場景 662：籌碼發散的股票是長空的最佳標的嗎?

來源：[籌碼發散的股票是長空的最佳標的嗎?](https://www.xq.com.tw/xstrader/%e7%b1%8c%e7%a2%bc%e7%99%bc%e6%95%a3%e7%9a%84%e8%82%a1%e7%a5%a8%e6%98%af%e9%95%b7%e7%a9%ba%e7%9a%84%e6%9c%80%e4%bd%b3%e6%a8%99%e7%9a%84%e5%97%8e/) 說明：我寫的腳本如下:

value1=GetField("法人買賣超張數","D");

value2=GetField("買家數","D");

value3=GetField("賣家數","D");

value4=GetField("主力買賣超張數","D");

value5=GetField("融資餘額張數","D");

value6=GetField("借券餘額張數","D");

value7=GetField("關鍵券商買賣超張數","D");

value8=GetField("散戶買張","D");

value9=GetField("地緣券商買賣超張數","D");

value10=GetField("綜合前十大券商買賣超張數","D");

var:count(0);

count=0;

if value1\<0 then count=count+1;

if value2\>value3+30 then count=count+1;

if value4\<0 then count=count+1;

if GetField("散戶持股張數","W",param := 50\) \>GetField("散戶持股張數","W",param := 50)\[1\] then count=count+1;

if GetField("散戶持股人數","W",param := 50\) \>GetField("散戶持股人數","W",param := 50)\[1\] then count=count+1;

if GetField("大戶持股張數","W",param := 400)\<GetField("大戶持股張數","W",param := 400)\[1\] then count=count+1;

if GetField("大戶持股人數","W",param := 400\) \<GetField("大戶持股人數","W",param := 400)\[1\] then count=count+1;

if value5\>value5\[1\] then count=count+1;

if value6\>value6\[1\] then count=count+1;

if value7\<0 then count=count+1;

if GetField("內部人持股比例","M")\< GetField("內部人持股比例","M")\[1\] then count=count+1;

if value8\>value8\[1\] then count=count+1;

if value9\<0 then count=count+1;

if value10\<0 then count=count+1;

input:n(10,"每日符合籌碼發散的條件數");

input:days(5,"計算天數");

if countif(count\>=n,days)\>=days\*0.6 then ret=1;

---

## 場景 663：主流股蓄勢待發

來源：[主流股蓄勢待發](https://www.xq.com.tw/xstrader/%e4%b8%bb%e6%b5%81%e8%82%a1%e8%93%84%e5%8b%a2%e5%be%85%e7%99%bc/) 說明：我寫的選股腳本如下

input:days(10);

input: FastLength(12, "DIF短期期數"), SlowLength(26, "DIF長期期數"), MACDLength(9, "MACD期數");

variable: difValue(0), macdValue(0), oscValue(0),Kprice(0);

settotalbar(100);

MACD(weightedclose(), FastLength, SlowLength, MACDLength, difValue, macdValue, oscValue);

if absvalue((average(close,20)-close)/close)\*100\<2

and absvalue((average(close,60)-close)/close)\*100\<2

//收盤價離月線及季線不遠

and close=highest(close,days)

//股價創十日新高

and macdvalue\>macdvalue\[1\]

//macd上漲

and macdvalue\>0

and difvalue\>0

then ret=1;

---

## 場景 664：尋找股價已跌破7千點時股價的股票\~ getbaroffset函數使用示範

來源：[尋找股價已跌破7千點時股價的股票\~ getbaroffset函數使用示範](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e8%82%a1%e5%83%b9%e5%b7%b2%e8%b7%8c%e7%a0%b47%e5%8d%83%e9%bb%9e%e6%99%82%e8%82%a1%e5%83%b9%e7%9a%84%e8%82%a1%e7%a5%a8-getbaroffset%e5%87%bd%e6%95%b8%e4%bd%bf%e7%94%a8%e7%a4%ba/) 說明：腳本的寫法如下

input:days(20150824);

value1=getbaroffset(days);

if close\<close\[value1\] then ret=1;

value2=((close\[value1\]/close)-1)\*100;

outputfield(1,close\[value1\],2,"當時股價");

outputfield(2,value2,0,"跌幅%");

---

## 場景 665：尋找股價已跌破7千點時股價的股票\~ getbaroffset函數使用示範

來源：[尋找股價已跌破7千點時股價的股票\~ getbaroffset函數使用示範](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e8%82%a1%e5%83%b9%e5%b7%b2%e8%b7%8c%e7%a0%b47%e5%8d%83%e9%bb%9e%e6%99%82%e8%82%a1%e5%83%b9%e7%9a%84%e8%82%a1%e7%a5%a8-getbaroffset%e5%87%bd%e6%95%b8%e4%bd%bf%e7%94%a8%e7%a4%ba/) 說明：這個函數的腳本如下

Input: target(numeric);

variable: i(1);

if target \>=date then

begin

 GetBarOffset \= 0;

 return;

end;

while true

begin

 Value1 \= date\[i\];

 if Value1 \<= target then 

 begin

 GetBarOffset \= i;

 return;

 end;

 i \= i \+ 1; 

end;

---

## 場景 666：如何尋找波段的操作標的？

來源：[如何尋找波段的操作標的？](https://www.xq.com.tw/xstrader/%e5%a6%82%e4%bd%95%e5%b0%8b%e6%89%be%e6%b3%a2%e6%ae%b5%e7%9a%84%e6%93%8d%e4%bd%9c%e6%a8%99%e7%9a%84%ef%bc%9f/) 說明：籌碼被收集的中型股

input:period(10);

value1=GetField("分公司賣出家數")\[1\];

value2=GetField("分公司買進家數")\[1\]; 

 if linearregslope(value1,period)\>0

 //賣出的家數愈來愈多

 and linearregslope(value2,period)\<0

 //買進的家數愈來愈少 

 and value1\>300

 and close\*1.05\<close\[period\]

 //但這段期間股價在跌

 and close\*1.03\<close\[1\]

 //今天又跌超過3%

 then ret=1;

---

## 場景 667：如何尋找波段的操作標的？

來源：[如何尋找波段的操作標的？](https://www.xq.com.tw/xstrader/%e5%a6%82%e4%bd%95%e5%b0%8b%e6%89%be%e6%b3%a2%e6%ae%b5%e7%9a%84%e6%93%8d%e4%bd%9c%e6%a8%99%e7%9a%84%ef%bc%9f/) 說明：籌碼從散戶手裡被收集

input:ratio(200); setinputname(1,"控盤者買張除以散戶買張的比例(%)");

input:volLimit(2000); setinputname(2,"成交量下限(張)");

settotalbar(3);

value1=GetField("控盤者買張");

value2=GetField("散戶買張");

value3=value1/value2 \* 100;

if volume \> volLimit and value3 \> ratio and value3\[1\] \> ratio

then ret=1;

---

## 場景 668：如何尋找波段的操作標的？

來源：[如何尋找波段的操作標的？](https://www.xq.com.tw/xstrader/%e5%a6%82%e4%bd%95%e5%b0%8b%e6%89%be%e6%b3%a2%e6%ae%b5%e7%9a%84%e6%93%8d%e4%bd%9c%e6%a8%99%e7%9a%84%ef%bc%9f/)

input: day(30, "投信交易期間");

if GetSymbolField("TSE.TW","收盤價") \> average(GetSymbolField("TSE.TW","收盤價"),10)

and Average(Volume\[1\], 100\) \>= 1000

then begin

 

 value1 \= summation(GetField("投信買賣超")\[1\], day); 

 value2 \= summation(volume\[2\], day);

 

 

 condition1 \= value1 \< value2 \* 0.02;

 //先前投信不怎麼買這檔股票

 

 condition2 \= GetField("投信買賣超")\>= volume\[1\] \* 0.15;

 //投信開始較大買超

 

 condition3 \= H \> H\[1\];

 //買了股價有往上攻

 

 condition4 \= C \> C\[1\];

 //今天收盤有往上走

 

 condition5=close\<close\[10\]\*1.05;

 

 RET \= condition1 and condition2 and condition3 and condition4 and condition5;

 

end;

---

## 場景 669：如何尋找波段的操作標的？

來源：[如何尋找波段的操作標的？](https://www.xq.com.tw/xstrader/%e5%a6%82%e4%bd%95%e5%b0%8b%e6%89%be%e6%b3%a2%e6%ae%b5%e7%9a%84%e6%93%8d%e4%bd%9c%e6%a8%99%e7%9a%84%ef%bc%9f/) 說明：千張大戶暴增

setbarfreq("W");

settotalbar(3);

value1=GetField("大戶持股人數","W",param:=1000);

value2=GetField("散戶持股人數","W",param:=400);

if value1\>value1\[1\]

and value2\<value2\[1\]

then ret=1;

outputfield(1,value1,0,"本週大戶人數");

outputfield(2,value1\[1\],0,"上週大戶人數");

outputfield(3,value1-value1\[1\],0,"大戶增加數");

outputfield(4,value2,0,"本週散戶人數");

outputfield(5,value2\[1\],0,"上週散戶人數");

outputfield(6,value2-value2\[1\],0,"散戶減少數");

---

## 場景 670：累計營收年增率開始出現異於以往的股票 — 我寫了一個腳本來找出這樣的股票

來源：[累計營收年增率開始出現異於以往的股票](https://www.xq.com.tw/xstrader/%e7%b4%af%e8%a8%88%e7%87%9f%e6%94%b6%e5%b9%b4%e5%a2%9e%e7%8e%87%e9%96%8b%e5%a7%8b%e5%87%ba%e7%8f%be%e7%95%b0%e6%96%bc%e4%bb%a5%e5%be%80%e7%9a%84%e8%82%a1%e7%a5%a8/) 說明：我寫了一個腳本來找出這樣的股票

value1=GetField("累計營收年增率","M");

input: r1(4),r2(12);

setinputname(1,"短天期");

setinputname(2,"長天期");

if average(value1,r1) cross over average(value1,r2)+5

and value1\>10

then ret=1;

---

## 場景 671：一條公式選股術的回測報告 — 根據這樣的公式，我寫了一個函數的腳本如下

來源：[一條公式選股術的回測報告](https://www.xq.com.tw/xstrader/%e4%b8%80%e6%a2%9d%e5%85%ac%e5%bc%8f%e9%81%b8%e8%82%a1%e8%a1%93%e7%9a%84%e5%9b%9e%e6%b8%ac%e5%a0%b1%e5%91%8a/) 說明：根據這樣的公式，我寫了一個函數的腳本如下

value1=GetField("股價淨值比","D");

value2=GetField("股東權益報酬率","Q");

value3=GetField("總市值(億)","D");

if value3\>=200 then 

GVI=1/value1\*(1+value2/100)\*(1+value2/100)\*(1+value2/100)\*(1+value2/100)\*(1+value2/100)

else GVI=0;

---

## 場景 672：一條公式選股術的回測報告 — 所以我就再加上營業利益率要大於零的條件，把腳本重新改寫如下

來源：[一條公式選股術的回測報告](https://www.xq.com.tw/xstrader/%e4%b8%80%e6%a2%9d%e5%85%ac%e5%bc%8f%e9%81%b8%e8%82%a1%e8%a1%93%e7%9a%84%e5%9b%9e%e6%b8%ac%e5%a0%b1%e5%91%8a/) 說明：所以我就再加上營業利益率要大於零的條件，把腳本重新改寫如下

value1=GetField("股價淨值比","D");

value2=GetField("股東權益報酬率","Q");

value3=GetField("總市值(億)","D");

value4=GetField("營業利益率","Q");

if value3\>=200 and value4\>0 then 

GVI=1/value1\*(1+value2/100)\*(1+value2/100)\*(1+value2/100)\*(1+value2/100)\*(1+value2/100)

else GVI=0;

---

## 場景 673：籌碼分析中的券商分公司買賣數據目前在XS上的應用 — 我自己寫的腳本中我覺得還不錯用的，大致有幾個

來源：[籌碼分析中的券商分公司買賣數據目前在XS上的應用](https://www.xq.com.tw/xstrader/%e7%b1%8c%e7%a2%bc%e5%88%86%e6%9e%90%e4%b8%ad%e7%9a%84%e5%88%b8%e5%95%86%e5%88%86%e5%85%ac%e5%8f%b8%e8%b2%b7%e8%b3%a3%e8%b3%87%e6%96%99%e7%9b%ae%e5%89%8d%e5%9c%a8xs%e4%b8%8a%e7%9a%84%e6%87%89%e7%94%a8/) 說明：我自己寫的腳本中我覺得還不錯用的，大致有幾個

//跑全部股票 停損停利都是7%

value1=GetField("分公司買進家數");

value2=GetField("分公司賣出家數");

value3=value2-value1;

value4=countif(value3\>40,10);

//計算買進家數與賣出家數的差距夠大的天數

if value4\>6 

and GetSymbolField("tse.tw","收盤價","D")

\>average(GetSymbolField("tse.tw","收盤價","D"),10)

and close\[30\]\>close\*1.1

then ret=1;

---

## 場景 674：籌碼分析中的券商分公司買賣數據目前在XS上的應用 — 另外雲 端策略中心裡有個腳本我把它改成下面這個，

來源：[籌碼分析中的券商分公司買賣數據目前在XS上的應用](https://www.xq.com.tw/xstrader/%e7%b1%8c%e7%a2%bc%e5%88%86%e6%9e%90%e4%b8%ad%e7%9a%84%e5%88%b8%e5%95%86%e5%88%86%e5%85%ac%e5%8f%b8%e8%b2%b7%e8%b3%a3%e8%b3%87%e6%96%99%e7%9b%ae%e5%89%8d%e5%9c%a8xs%e4%b8%8a%e7%9a%84%e6%87%89%e7%94%a8/) 說明：另外雲 端策略中心裡有個腳本我把它改成下面這個，

// 作多, 持有期別: 20

//

input:period(20);

value1=GetField("分公司賣出家數")\[1\];

value2=GetField("分公司買進家數")\[1\]; 

 

 if linearregslope(value1,period)\>0

 //賣出的家數愈來愈多

 and linearregslope(value2,period)\<0

 //買進的家數愈來愈少 

 and value1\>200

 and average(volume,5)\>=10000

 

 then ret=1;

---

## 場景 675：移動停利的腳本寫法 — 首先，RSI低檔回昇的腳本如下

來源：[移動停利的腳本寫法](https://www.xq.com.tw/xstrader/%e7%a7%bb%e5%8b%95%e5%81%9c%e5%88%a9%e7%9a%84%e8%85%b3%e6%9c%ac%e5%af%ab%e6%b3%95/) 說明：首先，RSI低檔回昇的腳本如下

if rsi(close,12) cross over 20

then ret=1;

---

## 場景 676：移動停利的腳本寫法 — 那麼這個進場腳本的移動停利腳本寫法可以如下

來源：[移動停利的腳本寫法](https://www.xq.com.tw/xstrader/%e7%a7%bb%e5%8b%95%e5%81%9c%e5%88%a9%e7%9a%84%e8%85%b3%e6%9c%ac%e5%af%ab%e6%b3%95/) 說明：那麼這個進場腳本的移動停利腳本寫法可以如下

input:ratio(10);

//設定回檔幅度

//用condition1來代表進場的觸發條件

condition1=false;

if rsi(close,12) cross over 20

then condition1=true;

value1=barslast(condition1);

//計算上一次觸發到現在共歷經幾根bar

value2=highest(high,value1);

//計算觸發後到目前為止的最高價

if close\*(1+ratio/100)\<value2

then condition2=true

else condition2=false;

value3=barslast(condition2);

if value3 cross under value1 then ret=1;

//觸發移動停利

---

## 場景 677：以週轉率為例，介紹自訂函數及其應用 — 首先，因著週轉率的公式是成交張數除以發行張數，我們可以先自訂一個叫turnoverrate的函數，它的腳本如下

來源：[以週轉率為例，介紹自訂函數及其應用](https://www.xq.com.tw/xstrader/%e4%bb%a5%e9%80%b1%e8%bd%89%e7%8e%87%e7%82%ba%e4%be%8b%ef%bc%8c%e4%bb%8b%e7%b4%b9%e8%87%aa%e8%a8%82%e5%87%bd%e6%95%b8%e5%8f%8a%e5%85%b6%e6%87%89%e7%94%a8/) 說明：首先，因著週轉率的公式是成交張數除以發行張數，我們可以先自訂一個叫turnoverrate的函數，它的腳本如下

input:period(numericsimple);

value1=GetField("普通股股本","Q")\*10000;

value2=average(volume,period);

if value1\<\>0

then value3=value2/value1\*100;

turnoverrate=value3;

---

## 場景 678：以週轉率為例，介紹自訂函數及其應用 — 有了這個函數，上述的選股條件就很好寫了

來源：[以週轉率為例，介紹自訂函數及其應用](https://www.xq.com.tw/xstrader/%e4%bb%a5%e9%80%b1%e8%bd%89%e7%8e%87%e7%82%ba%e4%be%8b%ef%bc%8c%e4%bb%8b%e7%b4%b9%e8%87%aa%e8%a8%82%e5%87%bd%e6%95%b8%e5%8f%8a%e5%85%b6%e6%87%89%e7%94%a8/) 說明：有了這個函數，上述的選股條件就很好寫了

if turnoverrate(5)\>turnoverrate(20)

then ret=1;

outputfield(1,turnoverrate(5),1,"5日平均週轉率");

outputfield(2,turnoverrate(20),1,"20日平均週轉率");

---

## 場景 679：私房策略分享之獲利穩定公司落難時

來源：[私房策略分享之獲利穩定公司落難時](https://www.xq.com.tw/xstrader/%e7%a7%81%e6%88%bf%e7%ad%96%e7%95%a5%e5%88%86%e4%ba%ab%e4%b9%8b%e7%8d%b2%e5%88%a9%e7%a9%a9%e5%ae%9a%e5%85%ac%e5%8f%b8%e8%90%bd%e9%9b%a3%e6%99%82/) 說明：這個腳本如下

input:n(40,"下跌的幅度");

input:period(60,"計算天數");

if close\*(1+n/100)\<close\[period-1\]

then ret=1;

---

## 場景 680：私房策略分享之獲利穩定公司落難時

來源：[私房策略分享之獲利穩定公司落難時](https://www.xq.com.tw/xstrader/%e7%a7%81%e6%88%bf%e7%ad%96%e7%95%a5%e5%88%86%e4%ba%ab%e4%b9%8b%e7%8d%b2%e5%88%a9%e7%a9%a9%e5%ae%9a%e5%85%ac%e5%8f%b8%e8%90%bd%e9%9b%a3%e6%99%82/) 說明：我寫的選股腳本如下

value1=GetField("每股稅後淨利(元)","Y");

if trueall(value1\>=2,5)//過去五年每年都賺超過兩元

and highest(value1,5)\<lowest(value1,5)\*1.5//獲利的高低差距在忍受範圍

then ret=1;

outputfield(1,highest(value1,5),1,"最高EPS");

outputfield(2,lowest(value1,5),1,"最低EPS");

---

## 場景 681：上漲下跌家數在期指波段交易上的應用 — 然後把這樣的概念寫成一個畫指標的腳本

來源：[上漲下跌家數在期指波段交易上的應用](https://www.xq.com.tw/xstrader/%e4%b8%8a%e6%bc%b2%e4%b8%8b%e8%b7%8c%e5%ae%b6%e6%95%b8%e5%9c%a8%e6%9c%9f%e6%8c%87%e6%b3%a2%e6%ae%b5%e4%ba%a4%e6%98%93%e4%b8%8a%e7%9a%84%e6%87%89%e7%94%a8/) 說明：然後把這樣的概念寫成一個畫指標的腳本

input:days1(5,"短天期");

input:days2(20,"長天期");

value1=GetField("上漲家數");

value2=GetField("下跌家數");

value3=value1+value2;

if value3 \= 0 then value4 \= 0 else value4=value1/value3\*100;

value5=average(value4,days1);

value6=average(value4,days2);

value7=value5-value6;

plot1(value7,"上漲下跌家數差指標");

---

## 場景 682：從資本支出挑要作功課的標的

來源：[從資本支出挑要作功課的標的](https://www.xq.com.tw/xstrader/7412-2/) 說明：先看選股腳本

input:period(20,"計算N季");

input:lm(10,"比均值增加的幅度");

input:cm(100,"單季資本支出金額下限");

value1=GetField("資本支出金額","Q");//單位: 百萬

value2=GetField("資本支出營收比","Q");//單位：%

value3=average(value1,period);

value4=average(value2,period);

if value1\>cm//資本支出超過一定金額

and value1\>value3\*(1+lm/100)

and value2\>value4\*(1+lm/100)

then ret=1;

---

## 場景 683：大盤抄底策略 — 首先，如果要計算指數上漲下跌的角度，寫法如下

來源：[大盤抄底策略](https://www.xq.com.tw/xstrader/%e5%a4%a7%e7%9b%a4%e6%93%8d%e5%ba%95%e7%ad%96%e7%95%a5/) 說明：首先，如果要計算指數上漲下跌的角度，寫法如下

input: period(20,"計算區間");

value1=rateofchange(close,period);

//計算區間漲跌幅

value2=arctangent(value1/period\*100);

plot1(value2);

---

## 場景 684：大盤抄底策略 — 從圖上發現，當下跌角度超過60度之後，就有加速趕底，反彈在即的味道，所以可以把它改寫成抄底策略如下

來源：[大盤抄底策略](https://www.xq.com.tw/xstrader/%e5%a4%a7%e7%9b%a4%e6%93%8d%e5%ba%95%e7%ad%96%e7%95%a5/) 說明：從圖上發現，當下跌角度超過60度之後，就有加速趕底，反彈在即的味道，所以可以把它改寫成抄底策略如下

input: period(20,"計算區間");

value1=rateofchange(close,period);

//計算區間漲跌幅

value2=arctangent(value1/period\*100);

if value2 crosses over \-60

then ret=1;

---

## 場景 685：如何縮小範圍，找出有機會拉出較大漲幅的個股 — 前兩個條件在XS上用現成的選股條件可以加進去，第三項我寫了一個腳本如下

來源：[如何縮小範圍，找出有機會拉出較大漲幅的個股](https://www.xq.com.tw/xstrader/%e6%95%a3%e6%88%b6%e7%9a%8450%e9%81%93%e9%9b%a3%e9%a1%8c%e7%8b%97%e5%b0%be%e7%89%88%e4%b9%8b1%e5%a6%82%e4%bd%95%e7%b8%ae%e5%b0%8f%e7%af%84%e5%9c%8d%ef%bc%8c%e6%89%be%e5%87%ba%e6%9c%89%e6%a9%9f/) 說明：前兩個條件在XS上用現成的選股條件可以加進去，第三項我寫了一個腳本如下

value1=GetField("每股稅後淨利(元)","Y");

if trueany(value1\>=3,8)

then ret=1;

---

## 場景 686：如何縮小範圍，找出有機會拉出較大漲幅的個股 — 法本比前五十名，以下是法本比的函數

來源：[如何縮小範圍，找出有機會拉出較大漲幅的個股](https://www.xq.com.tw/xstrader/%e6%95%a3%e6%88%b6%e7%9a%8450%e9%81%93%e9%9b%a3%e9%a1%8c%e7%8b%97%e5%b0%be%e7%89%88%e4%b9%8b1%e5%a6%82%e4%bd%95%e7%b8%ae%e5%b0%8f%e7%af%84%e5%9c%8d%ef%bc%8c%e6%89%be%e5%87%ba%e6%9c%89%e6%a9%9f/) 說明：法本比前五十名，以下是法本比的函數

value1=GetField("最新股本");//單位: 億元

value2=GetField("法人買賣超張數","D");//單位:張數

input:period(numericsimple);

value3=summation(value2,period);

if value1\<\>0

then value4=value3/(value1\*10000)\*100;

ret=value4;

---

## 場景 687：如何縮小範圍，找出有機會拉出較大漲幅的個股 — 最近一個月營收創近幾年新高

來源：[如何縮小範圍，找出有機會拉出較大漲幅的個股](https://www.xq.com.tw/xstrader/%e6%95%a3%e6%88%b6%e7%9a%8450%e9%81%93%e9%9b%a3%e9%a1%8c%e7%8b%97%e5%b0%be%e7%89%88%e4%b9%8b1%e5%a6%82%e4%bd%95%e7%b8%ae%e5%b0%8f%e7%af%84%e5%9c%8d%ef%bc%8c%e6%89%be%e5%87%ba%e6%9c%89%e6%a9%9f/) 說明：最近一個月營收創近幾年新高

input:N(37, "期別"); 

value1=GetField("月營收", "M");

value2=GetField("月營收月增率","M");

value3=GetField("月營收年增率","M");

value4=GetFieldDate("月營收","M");

if value1=Highest(value1,N)

//月營收創37期新高

and trueall(value2\>0,2)

//月營收月增率近兩個月都\>0

and trueall(value3\>0,2)

//月營收年增率近兩個月都\>0

then ret=1; 

outputfield(1,value4,0,"最新月份");

---

## 場景 688：如何縮小範圍，找出有機會拉出較大漲幅的個股 — 最近一個月營收創近幾年同期新高

來源：[如何縮小範圍，找出有機會拉出較大漲幅的個股](https://www.xq.com.tw/xstrader/%e6%95%a3%e6%88%b6%e7%9a%8450%e9%81%93%e9%9b%a3%e9%a1%8c%e7%8b%97%e5%b0%be%e7%89%88%e4%b9%8b1%e5%a6%82%e4%bd%95%e7%b8%ae%e5%b0%8f%e7%af%84%e5%9c%8d%ef%bc%8c%e6%89%be%e5%87%ba%e6%9c%89%e6%a9%9f/) 說明：最近一個月營收創近幾年同期新高

array: numarray\[5\](0);

variable:x(0);

for x=1 to 5

numarray\[x\]=GetField("月營收","M")\[(x-1)\*12\];

if trueall(numarray\[1\]=highestarray(numarray\[1\],5),2) then

ret=1;

---

## 場景 689：外資買超佔股本比排行

來源：[外資買超佔股本比排行](https://www.xq.com.tw/xstrader/%e5%a4%96%e8%b3%87%e8%b2%b7%e8%b6%85%e4%bd%94%e8%82%a1%e6%9c%ac%e6%af%94%e6%8e%92%e8%a1%8c/) 說明：我寫的腳本如下

value1=GetField("最新股本");//單位: 億元

value2=GetField("外資買賣超","D");//單位:張數

input:period(numericsimple);

value3=summation(value2,period);

if value1\<\>0

then value4=value3/(value1\*10000)\*100;

ret=value4;

---

## 場景 690：尋找可能由虧轉盈的公司

來源：[尋找可能由虧轉盈的公司](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e5%8f%af%e8%83%bd%e7%94%b1%e8%99%a7%e8%bd%89%e7%9b%88%e7%9a%84%e5%85%ac%e5%8f%b8/) 說明：我寫的腳本如下

// 計算最新一期月營收的日期(mm=月份)

//

variable: mm(0);

mm \= datevalue(getfielddate("月營收","M"),"M");

// 預估最新一季的季營收(單位=億)

//

if mm=1 or mm=4 or mm=7 or mm=10

then value1=GetField("月營收","M") \* 3;

if mm=2 or mm=5 or mm=8 or mm=11

then value1=GetField("月營收","M") \* 2 \+ GetField("月營收","M")\[1\];

if mm=3 or mm=6 or mm=9 or mm=12

then value1=GetField("月營收","M")+GetField("月營收","M")\[1\]+GetField("月營收","M")\[2\];

// 預估獲利(單位=百萬) \= 季營收 \* 毛利率 \- 營業費用

//

value2 \= value1 \* GetField("營業毛利率","Q") \- GetField("營業費用","Q");

if GetField("營業利益","Q")\<0

and value2\>0 then ret=1;

outputfield(1,value2 / 100,2,"預估單季本業獲利(億)");

outputfield(2,GetField("營業利益","Q"),0,"最近一季營業利益");

---

## 場景 691：從千張大戶數增減看大戶有否落跑！ — 先前寫過兩個腳本來每週一挑出那些千張大戶變少及變多的股票

來源：[從千張大戶數增減看大戶有否落跑！](https://www.xq.com.tw/xstrader/%e5%be%9e%e5%8d%83%e5%bc%b5%e5%a4%a7%e6%88%b6%e6%95%b8%e5%a2%9e%e6%b8%9b%e7%9c%8b%e5%a4%a7%e6%88%b6%e6%9c%89%e5%90%a6%e8%90%bd%e8%b7%91%ef%bc%81/) 說明：先前寫過兩個腳本來每週一挑出那些千張大戶變少及變多的股票

value1=GetField("大戶持股人數","W",param:=1000);

value2=GetField("散戶持股人數","W");

if value1\<value1\[1\]

and value2\>value2\[1\]

then ret=1;

outputfield(1,value1,0,"本週大戶人數");

outputfield(2,value1\[1\],0,"上週大戶人數");

outputfield(3,value1-value1\[1\],0,"大戶減少數");

outputfield(4,value2,0,"本週散戶人數");

outputfield(5,value2\[1\],0,"上週散戶人數");

---

## 場景 692：從千張大戶數增減看大戶有否落跑！

來源：[從千張大戶數增減看大戶有否落跑！](https://www.xq.com.tw/xstrader/%e5%be%9e%e5%8d%83%e5%bc%b5%e5%a4%a7%e6%88%b6%e6%95%b8%e5%a2%9e%e6%b8%9b%e7%9c%8b%e5%a4%a7%e6%88%b6%e6%9c%89%e5%90%a6%e8%90%bd%e8%b7%91%ef%bc%81/) 說明：跑出來的名單

value1=GetField("大戶持股人數","W",param:=1000);

value2=GetField("散戶持股人數","W");

if value1\>value1\[1\]

and value2\<value2\[1\]

then ret=1;

outputfield(1,value1,0,"本週大戶人數");

outputfield(2,value1\[1\],0,"上週大戶人數");

outputfield(3,value1-value1\[1\],0,"大戶增加數");

outputfield(4,value2,0,"本週散戶人數");

outputfield(5,value2\[1\],0,"上週散戶人數");

---

## 場景 693：當沖佔成交易多少比重後短線明顯過熱？ — 於是我寫了以下的腳本，回測看看

來源：[當沖佔成交易多少比重後短線明顯過熱？](https://www.xq.com.tw/xstrader/%e7%95%b6%e6%b2%96%e4%bd%94%e6%88%90%e4%ba%a4%e6%98%93%e5%a4%9a%e5%b0%91%e6%af%94%e9%87%8d%e5%be%8c%e7%9f%ad%e7%b7%9a%e6%98%8e%e9%a1%af%e9%81%8e%e7%86%b1%ef%bc%9f/) 說明：於是我寫了以下的腳本，回測看看

value1=GetField("當日沖銷張數");

if volume\<\>0

then value2=value1/volume\*100;

input:deadline(70);

if value2\>=deadline

 then ret=1;

---

## 場景 694：當沖佔成交易多少比重後短線明顯過熱？ — 如果我把成交量不到1000張的股票濾掉，腳本變成如下

來源：[當沖佔成交易多少比重後短線明顯過熱？](https://www.xq.com.tw/xstrader/%e7%95%b6%e6%b2%96%e4%bd%94%e6%88%90%e4%ba%a4%e6%98%93%e5%a4%9a%e5%b0%91%e6%af%94%e9%87%8d%e5%be%8c%e7%9f%ad%e7%b7%9a%e6%98%8e%e9%a1%af%e9%81%8e%e7%86%b1%ef%bc%9f/) 說明：如果我把成交量不到1000張的股票濾掉，腳本變成如下

value1=GetField("當日沖銷張數");

if volume\<\>0

then value2=value1/volume\*100;

input:deadline(70);

if value2\>=deadline

and volume\>1000

 then ret=1;

---

## 場景 695：雲帶型指標的制作方法 — 雲帶的概念是兩條線之間的區域，這裡舉的例子，是用月線及季線來作這兩條線，畫出雲帶。腳本如下

來源：[雲帶型指標的制作方法](https://www.xq.com.tw/xstrader/%e9%9b%b2%e5%b8%b6%e5%9e%8b%e6%8c%87%e6%a8%99%e7%9a%84%e5%88%b6%e4%bd%9c%e6%96%b9%e6%b3%95/) 說明：雲帶的概念是兩條線之間的區域，這裡舉的例子，是用月線及季線來作這兩條線，畫出雲帶。腳本如下

value1=average(close,20);//月線

value2=average(close,60);//季線

if value1\>=value2

then begin

plot1(value1);

plot2(value2);

end else begin

plot3(value2);

plot4(value1);

end;

---

## 場景 696：0050溢價是底部指標嗎? — 昨天說的那位高人除了發明了四大法人之外，也教我說，如果0050溢價的話，代表有人對未來非常樂觀，在大跌時出現這種樂觀想法的，一般都不會是散戶，應該是所謂的政府相...

來源：[0050溢價是底部指標嗎?](https://www.xq.com.tw/xstrader/0050%e6%ba%a2%e5%83%b9%e6%98%af%e5%ba%95%e9%83%a8%e6%8c%87%e6%a8%99%e5%97%8e/) 說明：昨天說的那位高人除了發明了四大法人之外，也教我說，如果0050溢價的話，代表有人對未來非常樂觀，在大跌時出現這種樂觀想法的，一般都不會是散戶，應該是所謂的政府相關基金，所以我就寫了一個腳本來計算0050的溢價，

value1=GetSymbolField("0050.tw","收盤價");

value2=GetSymbolField("0050n.tw","收盤價");

value3=value1-value2;

plot1(value3,"0050溢價");

---

## 場景 697：轉強天數指標的應用 — 首先，先複習一下個股儀表板的腳本

來源：[轉強天數指標的應用](https://www.xq.com.tw/xstrader/%e8%bd%89%e5%bc%b7%e5%a4%a9%e6%95%b8%e6%8c%87%e6%a8%99%e7%9a%84%e6%87%89%e7%94%a8/) 說明：首先，先複習一下個股儀表板的腳本

condition1=false;

condition2=false;

condition3=false;

condition4=false;

condition5=false;

condition6=false;

condition7=false;

condition8=false;

condition9=false;

condition10=false;

switch(close)

begin

case \>150: value5=low\*0.9;

case \<50 : value5=low\*0.98;

default: value5=low\*0.95;

end;

//==========日KD黃金交叉================

input: Length\_D(9, "日KD期間");

input: Length\_M(5, "周KD期間");

variable:rsv\_d(0),kk\_d(0),dd\_d(0),c5(0);

 

stochastic(Length\_D, 3, 3, rsv\_d, kk\_d, dd\_d);

 

c5=barslast(kk\_d crosses over dd\_d);

if c5=0 and c5\[1\]\>20

then condition1=true; 

if condition1

then plot1(value5,"月KD高檔鈍化且日KD黃金交叉");

//============內外盤量比差====================

variable:c3(0);

value6=GetField("內盤量");//單位:元

value7=GetField("外盤量");//單位:元

if volume\<\>0 then begin

value8=value7/volume\*100;//外盤量比

value9=value6/volume\*100;//內盤量比

end;

value10=average(value8,5);

value11=average(value9,5);

value7=value10-value11+5;

c3=barslast(value7 crosses over 0);

if c3=0 and c3\[1\]\>20

then condition2=true;

if condition2

then 

plot2(value5\*0.99,"內外盤量比差");

//===========淨力指標==============

variable:c4(0);

input:period2(10,"長期參數");

value12=summation(high-close,period2);//上檔賣壓

value13=summation(close-open,period2); //多空實績

value14=summation(close-low,period2);//下檔支撐

value15=summation(open-close\[1\],period2);//隔夜力道

if close\<\>0

then

value16=(value13+value14+value15-value12)/close\*100;

 

c4=barslast( value16 crosses over \-4);

if c4=0 and c4\[1\]\>20

then condition3=true;

if condition3

then 

plot3(value5\*0.98,"淨力指標");

//===========多頭起漲前的籌碼收集================

variable:c2(0);

value1=GetField("分公司買進家數");

value2=GetField("分公司賣出家數");

value3=value2-value1;

value4=countif(value3\>20,10);

c2=barslast(value4\>6 );

if c2=0 and c2\[1\]\>20

then condition4=true;

if condition4=true

then

plot4(value5\*0.97,"籌碼收集");

//===========法人同步買超====================

variable: v1(0),v2(0),v3(0),c1(0);

v1=Getfield("外資買賣超");

v2=Getfield("投信買賣超");

v3=Getfield("自營商買賣超");

c1= barslast(maxlist2(v1,v2,v3)\>100);

if c1=0 and c1\[1\]\>20

then condition5=true;

if condition5=true

then plot5(value5\*0.96,"法人同步買超");

//========DIF-MACD翻正=============

input: FastLength(12), SlowLength(26), MACDLength(9);

variable: difValue(0), macdValue(0), oscValue(0);

MACD(weightedclose(), FastLength, SlowLength, MACDLength, difValue, macdValue, oscValue);

variable:c6(0);

c6=barslast(oscValue Crosses Above 0);

if c6=0 and c6\[1\]\>20

then condition6=true;

if condition6

then plot6(value5\*0.95,"DIF-MACD翻正");

//========資金流向======================

variable: m1(0),ma1(0),c7(0);

m1=GetField("資金流向");

ma1=average(m1,20)\*1.5;

c7=barslast(m1 crosses over ma1 and close\>close\[1\]);

if c7=0 and c7\[1\]\>20

then condition7=true;

if condition7

then plot7(value5\*0.94,"資金流向");

//=========總成交次數================

variable: t1(0),mat1(0),c8(0);

t1=GetField("總成交次數","D");

mat1=average(t1,20)\*1.5;

c8=barslast(t1 crosses over mat1 and close\>close\[1\]);

if c8=0 and c8\[1\]\>20

then condition8=true;

if condition8

then plot8(value5\*0.93,"成交次數");

//=========強弱指標==================

variable:s1(0),c9(0);

s1=GetField("強弱指標","D");

c9=barslast(trueall(s1\>0,3));

if c9=0 and c9\[1\]\>20

then condition9=true;

if condition9

then plot9(value5\*0.92,"強弱指標");

//============開盤委買================

variable:b1(0),mab1(0),c10(0);

b1=GetField("主力買張");

mab1=average(b1,10);

c10=barslast(b1 crosses over mab1);

if c10=0 and c10\[1\]\>10

then condition10=true;

if condition10

then plot10(value5\*0.91,"主力買張");

---

## 場景 698：轉強天數指標的應用 — 我自己的轉強天數指標是這麼寫的

來源：[轉強天數指標的應用](https://www.xq.com.tw/xstrader/%e8%bd%89%e5%bc%b7%e5%a4%a9%e6%95%b8%e6%8c%87%e6%a8%99%e7%9a%84%e6%87%89%e7%94%a8/) 說明：我自己的轉強天數指標是這麼寫的

input:period(20);

value1=GetField("強弱指標","D");

//個股漲跌幅減加權指數漲跌幅

value2=GetField("資金流向");

value3=countif(value1\>0 and value2\>value2\[1\],period);

plot1(value3);

---

## 場景 699：月報酬率等績效圖的寫法 — 我把計算的程式碼寫在下面，大家可以拿去改一改測試一下，自己挑定存股組合，過去十年績效會如何？（程式如果寫錯要提醒我）

來源：[月報酬率等績效圖的寫法](https://www.xq.com.tw/xstrader/%e6%88%91%e7%9a%84%e5%ae%9a%e5%ad%98%e8%82%a1%e5%90%8d%e5%96%ae/) 說明：我把計算的程式碼寫在下面，大家可以拿去改一改測試一下，自己挑定存股組合，過去十年績效會如何？（程式如果寫錯要提醒我）

value1=GetSymbolField("1215.tw","收盤價");//卜蜂

value2=GetSymbolField("3130.tw","收盤價");//一零四

value3=GetSymbolField("9941.tw","收盤價");//裕融

value4=GetSymbolField("9917.tw","收盤價");//中保

value5=GetSymbolField("5403.tw","收盤價");//中菲

value6=GetSymbolField("2207.tw","收盤價");//和泰車

value7=GetSymbolField("9943.tw","收盤價");//好樂迪

value8=value1+value2+value3+value4+value5+value6+value7;

if value8\[1\]\<\>0 then 

value9=(value8-value8\[1\])/value8\[1\]\*100;

value10=average(value9,12);

if value9\<0 and value9\[1\]\>0

then value11=value9

else if value9\<0 and value9\[1\]\<0

then value11=value9+value11\[1\]

else value11=0;

//plot1(value8,"淨值走勢圖");

//plot2(value9,"單月報酬");

//plot3(value10,"12個月報酬移動平均");

plot4(value11,"MDD");

---

## 場景 700：找出盤中有大單的腳本寫法 — 可惜我功力不好，問了公司那些聰明的腦袋才寫出以下的腳本

來源：[找出盤中有大單的腳本寫法](https://www.xq.com.tw/xstrader/%e6%89%be%e5%87%ba%e7%9b%a4%e4%b8%ad%e6%9c%89%e5%a4%a7%e5%96%ae%e7%9a%84%e8%85%b3%e6%9c%ac%e5%af%ab%e6%b3%95/) 說明：可惜我功力不好，問了公司那些聰明的腦袋才寫出以下的腳本

input:v1(500,"單筆買進金額下限");

input: LaTime(2,"大單筆數");

input:TXT("須逐筆洗價","使用限制");

variable: intrabarpersist Xtime(0);//計數器

variable: intrabarpersist V2(0);

variable: intrabarpersist XDate(0);

v2=q\_TickVolume;//單量

value2=q\_BidAskFlag;//外盤標誌為1

value3=v2\*close/10;

settotalbar(3);

if Date \> XDate then Xtime \=0; //開盤那根要歸0次數

XDate \= Date;

if value3 \>= v1 and value2=1 then Xtime+=1; //量夠大就加1次

if Xtime \> LaTime then 

begin

 ret=1;

 Xtime=0;

end;

---

## 場景 701：財務數字是領先還是落後指標？

來源：[財務數字是領先還是落後指標？](https://www.xq.com.tw/xstrader/%e8%b2%a1%e5%8b%99%e6%95%b8%e5%ad%97%e6%98%af%e9%a0%98%e5%85%88%e9%82%84%e6%98%af%e8%90%bd%e5%be%8c%e6%8c%87%e6%a8%99%ef%bc%9f/) 說明：我寫了一個腳本如下

value1=GetField("每股稅後淨利(元)","Y");

if trueany(value1\>3,8)

and trueall(value1\<0.7,4)

and trueany(value1\<0,4)

then ret=1;

---

## 場景 702：權值股多頭排列家數指標 — 我寫的指標腳本如下，大家請直接複製貼上即可，不過如果權值股有變的時候記得要換一下

來源：[權值股多頭排列家數指標](https://www.xq.com.tw/xstrader/%e6%ac%8a%e5%80%bc%e8%82%a1%e5%a4%9a%e9%a0%ad%e6%8e%92%e5%88%97%e5%ae%b6%e6%95%b8%e6%8c%87%e6%a8%99/) 說明：我寫的指標腳本如下，大家請直接複製貼上即可，不過如果權值股有變的時候記得要換一下

value1=GetSymbolField("2330.tw","收盤價");

value2=GetSymbolField("2317.tw","收盤價");

value3=GetSymbolField("6505.tw","收盤價");

value4=GetSymbolField("2412.tw","收盤價");

value5=GetSymbolField("2882.tw","收盤價");

value6=GetSymbolField("1301.tw","收盤價");

value7=GetSymbolField("1303.tw","收盤價");

value8=GetSymbolField("1326.tw","收盤價");

value9=GetSymbolField("3008.tw","收盤價");

value10=GetSymbolField("2881.tw","收盤價");

value11=GetSymbolField("2454.tw","收盤價");

value12=GetSymbolField("2891.tw","收盤價");

value13=GetSymbolField("2002.tw","收盤價");

value14=GetSymbolField("1216.tw","收盤價");

value15=GetSymbolField("2311.tw","收盤價");

value16=GetSymbolField("2886.tw","收盤價");

value17=GetSymbolField("2912.tw","收盤價");

value18=GetSymbolField("2474.tw","收盤價");

value19=GetSymbolField("2382.tw","收盤價");

value20=GetSymbolField("2408.tw","收盤價");

value21=GetSymbolField("2892.tw","收盤價");

value22=GetSymbolField("5880.tw","收盤價");

value23=GetSymbolField("2357.tw","收盤價");

value24=GetSymbolField("2884.tw","收盤價");

value25=GetSymbolField("2207.tw","收盤價");

value26=GetSymbolField("4938.tw","收盤價");

value27=GetSymbolField("2880.tw","收盤價");

value28=GetSymbolField("2303.tw","收盤價");

value29=GetSymbolField("2105.tw","收盤價");

value30=GetSymbolField("2885.tw","收盤價");

variable:count(0);

input:period(20);

count=0;

if value1\>average(value1,period) then count=count+1;

if value2\>average(value2,period) then count=count+1;

if value3\>average(value3,period) then count=count+1;

if value4\>average(value4,period) then count=count+1;

if value5\>average(value5,period) then count=count+1;

if value6\>average(value6,period) then count=count+1;

if value7\>average(value7,period) then count=count+1;

if value8\>average(value8,period) then count=count+1;

if value9\>average(value9,period) then count=count+1;

if value10\>average(value10,period) then count=count+1;

if value11\>average(value11,period) then count=count+1;

if value12\>average(value12,period) then count=count+1;

if value13\>average(value13,period) then count=count+1;

if value14\>average(value14,period) then count=count+1;

if value15\>average(value15,period) then count=count+1;

if value16\>average(value16,period) then count=count+1;

if value17\>average(value17,period) then count=count+1;

if value18\>average(value18,period) then count=count+1;

if value19\>average(value19,period) then count=count+1;

if value20\>average(value20,period) then count=count+1;

if value21\>average(value21,period) then count=count+1;

if value22\>average(value22,period) then count=count+1;

if value23\>average(value23,period) then count=count+1;

if value24\>average(value24,period) then count=count+1;

if value25\>average(value25,period) then count=count+1;

if value26\>average(value26,period) then count=count+1;

if value27\>average(value27,period) then count=count+1;

if value28\>average(value28,period) then count=count+1;

if value29\>average(value29,period) then count=count+1;

if value30\>average(value30,period) then count=count+1;

plot1(count-15);

---

## 場景 703：大漲後大戶落跑 — 我根據這個數據，寫出的腳本如下

來源：[大漲後大戶落跑](https://www.xq.com.tw/xstrader/%e5%a4%a7%e6%bc%b2%e5%be%8c%e5%a4%a7%e6%88%b6%e8%90%bd%e8%b7%91/) 說明：我根據這個數據，寫出的腳本如下

value1=GetField("大戶持股人數","W",param:=1000);

value2=GetField("散戶持股人數","W");

if value1\<value1\[1\]

and value2\>value2\[1\]

and value1\[1\]-value1\>=4

and close\> lowest(close,100)\*1.5

then ret=1;

---

## 場景 704：大漲後大戶落跑 — 可以看那些股票有千張大戶落跑，當然也可以觀察有那些股票大戶在買散戶在賣，只要把上面的腳本改一下就行

來源：[大漲後大戶落跑](https://www.xq.com.tw/xstrader/%e5%a4%a7%e6%bc%b2%e5%be%8c%e5%a4%a7%e6%88%b6%e8%90%bd%e8%b7%91/) 說明：可以看那些股票有千張大戶落跑，當然也可以觀察有那些股票大戶在買散戶在賣，只要把上面的腳本改一下就行

value1=GetField("大戶持股人數","W",param:=1000);

value2=GetField("散戶持股人數","W");

if value1\>value1\[1\]

and value2\<value2\[1\]

then ret=1;

outputfield(1,value1,0,"本週大戶人數");

outputfield(2,value1\[1\],0,"上週大戶人數");

outputfield(3,value1-value1\[1\],0,"大戶增加數");

outputfield(4,value2,0,"本週散戶人數");

outputfield(5,value2\[1\],0,"上週散戶人數");

---

## 場景 705：重獲市場垂青的低價股 — 於是我寫了以下的腳本，回測了幾個不同的比例，最後發現，如果資金流向的比例是過去60天移動平均的四倍，回測出來的勝率最高，以下是我寫的腳本

來源：[重獲市場垂青的低價股](https://www.xq.com.tw/xstrader/%e9%87%8d%e7%8d%b2%e5%b8%82%e5%a0%b4%e5%9e%82%e9%9d%92%e7%9a%84%e4%bd%8e%e5%83%b9%e8%82%a1/) 說明：於是我寫了以下的腳本，回測了幾個不同的比例，最後發現，如果資金流向的比例是過去60天移動平均的四倍，回測出來的勝率最高，以下是我寫的腳本

//所有股票

//進場後20天出場

value1=GetField("資金流向");

value2=GetField("主力買賣超張數");

if value1 crosses over average(value1,60)\*4

//資金流向明顯回昇

and trueall(value2\>200,5)

//過去五日主力都買超超過兩百張

and tselsindex(10,6)=1

//大盤外資買多於賣

and close\<40

//股價不高於40元

then ret=1;

---

## 場景 706：綜合抄底策略

來源：[綜合抄底策略](https://www.xq.com.tw/xstrader/%e7%b6%9c%e5%90%88%e6%8a%84%e5%ba%95%e7%ad%96%e7%95%a5/) 說明：我寫的腳本如下

if close\*1.4\<highest(close,60)then begin

variable:count(0);

count=0;

//之前無長紅，最近兩根長紅

input:ratio(5,"長紅的漲幅下限");

if countif(close\[5\]\>=close\[6\]\*(1+ratio/100),60)=0

and countif(close\>=close\[1\]\*(1+ratio/100),5)\>=2

then count=count+1;

//均線糾結後上漲

input: s1(5,"短期均線期數");

input: s2(10,"中期均線期數");

input: s3(20,"長期均線期數");

input: Percent(2,"均線糾結區間%");

input: Volpercent(25,"放量幅度%");

//帶量突破的量是超過最長期的均量多少%

variable: shortaverage(0);

variable: midaverage(0);

variable: Longaverage(0);

if volume \> average(volume,s3) \* (1 \+ volpercent \* 0.01)

//放量25%

and lowest(volume,s3)\<1000

//區間最低量小於一千張

and volume\>2000

//今日成交量突破2000張

then begin

shortaverage \= average(close,s1);

midaverage \= average(close,s2);

Longaverage \= average(close,s3);

value1= absvalue(shortaverage \-midaverage);

value2= absvalue(midaverage \-Longaverage);

value3= absvalue(Longaverage \-shortaverage);

value4= maxlist(value1,value2,value3);

if value4\*100 \< Percent\*Close

and linearregangle(value4,5)\<10

then count=count+1;

end;

//低檔五連陽

if trueall(close\>open,5) 

then count=count+1;

//急拉

value11=barslast(close\>=close\[1\]\*1.07);

if value11\[1\]\>50

//超過50天沒有單日上漲超過7%

and value11=0

//今天上漲超過7%

and average(volume,100)\>500

and volume\>1000

then count=count+1;

//連續跳空上漲

if countif(open \> close\[1\],5)\>=3

//過去五天有三天以上開盤比前一天收盤高

and average(volume,5)\>2000

//五日均量大於2000張

then count=count+1;

//連續多日價量回溫

input:period(5,"回溫期數");

value21=GetField("資金流向");

value22=GetField("強弱指標","D");

if countif(value21\>value21\[1\]and value22\>0,period)\>= 4

and volume\>average(volume,20)\*1.3

then count=count+1;

//主力回頭收集

input:period1(20);

value31=GetField("分公司賣出家數")\[1\];

value32=GetField("分公司買進家數")\[1\]; 

if linearregslope(value31,period1)\>0

//賣出的家數愈來愈多

and linearregslope(value32,period1)\<0

//買進的家數愈來愈少

and 

close\*1.03\<close\[1\]

//今天又跌超過3%

 

then count=count+1;

if count\>=1 then ret=1;

end;

---

## 場景 707：雞尾酒策略雷達的函數化

來源：[雞尾酒策略雷達的函數化](https://www.xq.com.tw/xstrader/%e9%9b%9e%e5%b0%be%e9%85%92%e7%ad%96%e7%95%a5%e9%9b%b7%e9%81%94%e7%9a%84%e5%87%bd%e6%95%b8%e5%8c%96/) 說明：我寫的函數腳本如下:

var:count(0);

count=0;

condition1=false;

condition2=false;

condition3=false;

condition4=false;

condition5=false;

condition6=false;

condition7=false;

//跌不下去的高殖利率股

 

condition8 \= L \= Lowest(L,20);

condition9 \= H \= Highest(H,20);

 

if GetSymbolField("tse.tw","收盤價")

\>average(GetSymbolField("tse.tw","收盤價"),60)

//大盤處於多頭市場

then begin 

 if condition9

 //股價創區間以來高點

 and TrueAll(Condition8=false,20)

 //這段區間都未破底

 and close\<close\[19\]\*1.05

 //區間股價漲幅不大

 then condition1=true;

end;

if barslast(condition1=true)\<3

then count=count+1;

//股價突破籌碼沈澱區

condition10=false; 

if v\[1\] \> 0 then value1 \= (v\[1\] \- GetField("當沖張數")\[1\])/v\[1\];

//實質成交比例

 

if value1\[1\] \>0 then value2 \= 100\*value1/value1\[1\]-100;

//實質成交比例日變動百分比

value3 \= standarddev(value2,5,1);

//實質成交比例日變動百分比的不同天期標準差

value4 \= standarddev(value2,10,1);

value5 \= standarddev(value2,20,1);

if value3 \= lowest(value3 ,20) and

 value4 \= lowest(value4 ,20) and

 value5 \= lowest(value5 ,20) 

//現在各不同天期的成交比例日變動百分比標準差都處在期間最低點

then condition10=true;

 

// 成交量判斷

 

if tselsindex(10,6)=1

and condition10 

and close crosses over highest(high\[1\],10)

then condition2=true;

if barslast(condition2=true)\<3

then count=count+1;

//投信強買發動

variable: SumForce(0), SumTotalVolume(0),Kprice(0), Kdate(0);

SumForce \= Summation(GetField("投信買賣超")\[1\], 3);

sumTotalVolume \= Summation(Volume\[1\], 3);

if SumForce \> SumTotalVolume \* 15/100 And Average(Volume\[1\], 5\) \>= 1000 then 

begin

 Kprice \=highest(avgprice\[1\],3);

 Kdate \= date\[1\];

end; 

Condition11 \= C crosses above Kprice and datediff(date, kdate) \<= 60; 

Condition12 \= Average(Volume\[1\], 5\) \>= 1000;

Condition13 \= Volume \> Average(Volume\[1\], 5\) \* 1.2;

Condition14 \= C \> C\[1\];

condition15 \= tselsindex(10,6)=1;

if Condition1 And Condition2 And Condition3 And Condition4 And condition5

then condition3=true;

if barslast(condition3=true)\<3

then count=count+1;

//爆量剛起漲

 

Condition16 \= H=highest(H,60);

 //今日最高創區間最高價

 

Condition17 \= V=highest(v,60);

 //今日成交量創區間最大量

 

Condition18 \= highest(H,60) \< lowest(L,60)\*(1 \+ 14\*0.01);

 //今日最高價距離區間最低價漲幅尚不大

 

if Condition1 And Condition2 And Condition3

and tselsindex(10,6)=1

then condition4=true;

if barslast(condition4=true)\<3

then count=count+1;

//突破糾結均線

variable: Shortaverage(0),Midaverage(0),Longaverage(0);

variable: AvgHLp(0),AvgH(0),AvgL(0);

//透過Z的時間安排來決定現在用的是那一根Bar的資料 

variable: Z(0);

if currenttime \> 180000 

or currenttime \< 083000 then 

 Z \=0 

else 

 Z=1;

Shortaverage \= average(close,5);

Midaverage \= average(close,10);

Longaverage \= average(close,20);

AvgH \= maxlist(Shortaverage,Midaverage,Longaverage);

AvgL \= minlist(Shortaverage,Midaverage,Longaverage);

if AvgL \> 0 then AvgHLp \= 100\*AvgH/AvgL \-100;

condition19 \= trueAll(AvgHLp \< 5,20);

condition20 \= V \> average(V\[1\],20)\*(1+25/100) ;

condition21 \= C \> AvgH \*(1.02) and H \> highest(H\[1\],20);

condition22 \= average(volume\[1\], 5\) \>= 1000; 

condition23 \= tselsindex(10,6)\[Z\]=1;

if condition19

and condition20 

and condition21 

and condition22

and condition23

then condition5=true;

if barslast(condition5=true)\<3

then count=count+1;

//低PB股的逆襲

if GetSymbolField("tse.tw","收盤價") \> average(GetSymbolField("tse.tw","收盤價"),10)

then begin

 if close\<12

 and H \= highest(H,20)

 and close\<lowest(low,20)\*1.07

 and highest(h,40)\>close\*1.1

 then

 condition6=true;

end;

if barslast(condition6=true)\<3

then count=count+1;

//即將鎖第一根漲停的中小型股

 

Condition24 \= Close \>= GetField("uplimit") \* (1 \- 1/100);

Condition25 \= TrueAll(Close \< GetField("uplimit"), 20);

Condition26 \= Average(Volume, 5\) \>= 1000;

Condition27 \= Close \> Highest(High\[1\], 20);

Condition28 \= Volume \>= Highest(Volume\[1\], 20);

Condition29 \= GetSymbolField("tse.tw","收盤價") \> average(GetSymbolField("tse.tw","收盤價"),10); 

if Condition24 And Condition25 And Condition26 And Condition27 And Condition28 and condition29

then condition7=true;

if barslast(condition7=true)\<3

then count=count+1;

entrycount=count;

---

## 場景 708：大跌後出現什麼K線型態可以進場？

來源：[大跌後出現什麼K線型態可以進場？](https://www.xq.com.tw/xstrader/%e5%a4%a7%e8%b7%8c%e5%be%8c%e5%87%ba%e7%8f%be%e4%bb%80%e9%ba%bck%e7%b7%9a%e5%9e%8b%e6%85%8b%e5%8f%af%e4%bb%a5%e9%80%b2%e5%a0%b4%ef%bc%9f/) 說明：我寫的腳本如下：

settotalbar(5);

condition2 \= (minlist(open,close)-Low) \> absvalue(open-close)\*3; 

condition3 \= minlist(open, close) \> low\* (100 \+ 2)/100;

if trueall( condition2 and condition3, 3\)

then bkpatterm="三長下影線";

{\[檔名:\] 紅三兵 

\[說明:\] 連續三根上漲實體K棒 

} 

 

condition1= ( close \- open ) \>(high \-low) \* 0.75;

//狀況1:實體上漲K棒

condition4= ( close\[1\] \- open\[1\] ) \>(high\[1\] \-low\[1\]) \* 0.75;

//狀況2:前一根也是實體上漲K棒

condition5= ( close\[2\] \- open\[2\] ) \>(high\[2\] \-low\[2\]) \* 0.75;

//狀況3:前前根也是實體上漲K棒

condition6= close \> close\[1\];

//狀況4: 上漲

condition7= close\[1\] \> close\[2\];//狀況5:上漲

{結果判斷} 

IF 

 condition1

 and condition4

 and condition5

 and condition6

 and condition7

THEN bkpatterm="紅三兵"; 

condition8= ( open\[2\] \- close\[2\] ) \>(high\[2\] \-low\[2\]) \* 0.75;

//狀況1:實體下跌K棒

condition9= ( close\[1\] \- open\[1\] ) \>(high\[1\] \-low\[1\]) \* 0.75;

//狀況2:實體上漲K棒

condition10= high\[1\] \< high\[2\] and low\[1\] \> low\[2\];

//狀況3:前期內包於前前期

condition11=( close \- open ) \> 0.75 \*(high \-low);

//狀況4:當期實體上漲K棒

condition12=close \> open\[2\];

//狀況5:現價突破前前期開盤價

IF condition8

 and condition9

 and condition10

 and condition11

 and condition12

THEN bkpatterm="內困三日翻紅"; 

condition13=open \= High and close \< open ;//狀況1: 開高收低留黑棒

 condition14=(high \-low) \> 2 \*(high\[1\]-low\[1\]) ;//狀況2: 波動倍增

 condition15=(close-low)\> (open-close) \*2 ;//狀況3: 下影線為實體兩倍以上

 

IF condition13

 and condition14

 and condition15

THEN bkpatterm="吊人線"; 

condition16=(open\[1\] \- close\[1\] ) \>(high\[1\] \-low\[1\])\*0.75;

//狀況1:前期出黑K棒

condition17=( close \- open ) \>(high \-low) \* 0.75;

//狀況2:當期紅棒

condition18=high \> high\[1\];

//狀況3:高過昨高

condition19=open\<low\[1\];

//狀況4:開低破昨低 

IF condition16

 and condition17

 and condition18

 and condition19

THEN bkpatterm="多頭吞噬"; 

{ 

\[檔名:\] 多頭執帶 

\[說明:\] 開在最低點一路走高收在最高點附近的K棒 

}

condition20=close\>open; 

condition21=(Close-Open)\>(high-low)\*0.9;

condition22=Close\>Close\[1\]+high\[1\]-low\[1\]; 

IF condition20

 and condition21

 and condition22

THEN bkpatterm="多頭執帶"; 

{ 

\[檔名:\] 多頭母子 

\[說明:\] 前期收長黑K棒 今期開高小幅收紅不過昨高 

} 

 

 

condition23=( open\[1\] \- close\[1\] ) \>(high\[1\] \-low\[1\])\*0.75;

//狀況1:前期出長黑K棒

condition24=close\[3\]-close\[2\]\<close\[2\]-close\[1\]; 

//狀況2:前期呈波動放大下跌

condition25=( close \- open ) \>(high \-low) \* 0.75;

//狀況3:當期紅棒

condition26=high \< high\[1\];

//狀況4:高不過昨高

condition27=low\>low\[1\];

//狀況5:低不破昨低

 

IF 

 condition23

 and condition24

 and condition25

 and condition26

 and condition27

THEN bkpatterm="多頭母子";

{ 

\[檔名:\] 多頭遭遇 

\[說明:\] 前期收黑K棒 當期開低走高紅棒嘗試反攻昨收 

}

 

condition28= (open\[1\] \- close\[1\] ) \>(high\[1\] \-low\[1\]) \* 0.75;

//狀況1:前期出黑K棒

condition29= close\[1\] \< close\[2\];

//狀況2:前期收跌

condition30= ( close \- open ) \>(high \-low) \* 0.75;

//狀況3:當期收紅K棒

condition31= open \< close\[1\] and close \< close\[1\];

//狀況4:開低且收跌

condition32= low \< low\[1\];//狀況5:破前期低點

{結果判斷} 

IF 

 condition28

 and condition29

 and condition30

 and condition31

 and condition32

THEN bkpatterm="多頭遭遇";

---

## 場景 709：大跌後出現什麼K線型態可以進場？ — 有了這個腳本，接下來的策略腳本就變的很簡單寫，例如我如果要找大跌三成後出現紅三兵的股票，就可以像下面這樣寫

來源：[大跌後出現什麼K線型態可以進場？](https://www.xq.com.tw/xstrader/%e5%a4%a7%e8%b7%8c%e5%be%8c%e5%87%ba%e7%8f%be%e4%bb%80%e9%ba%bck%e7%b7%9a%e5%9e%8b%e6%85%8b%e5%8f%af%e4%bb%a5%e9%80%b2%e5%a0%b4%ef%bc%9f/) 說明：有了這個腳本，接下來的策略腳本就變的很簡單寫，例如我如果要找大跌三成後出現紅三兵的股票，就可以像下面這樣寫

if close\*1.3\<close\[30\]

and bkpatterm="紅三兵"

then ret=1;

---

## 場景 710：用CANSLIM選股法則來說明XS選股平台的四種選股條件產生方法 — 首先我們先寫一個函數來計算出最近兩季EPS平均年增率這個值，寫法如下

來源：[用CANSLIM選股法則來說明XS選股平台的四種選股條件產生方法](https://www.xq.com.tw/xstrader/canslim%e9%81%b8%e8%82%a1%e6%b3%95%e5%89%87%e5%9c%a8xs%e4%b8%8a%e5%a6%82%e4%bd%95%e5%af%a6%e7%8f%be/) 說明：首先我們先寫一個函數來計算出最近兩季EPS平均年增率這個值，寫法如下

value1=GetField("每股稅後淨利(元)","Q");

value2=(value1/value1\[4\]-1)\*100;//年增率

value3=(value2+value2\[1\])/2;

ret=value3;

---

## 場景 711：用CANSLIM選股法則來說明XS選股平台的四種選股條件產生方法 — 符合上述兩個條件的警示腳本如下:

來源：[用CANSLIM選股法則來說明XS選股平台的四種選股條件產生方法](https://www.xq.com.tw/xstrader/canslim%e9%81%b8%e8%82%a1%e6%b3%95%e5%89%87%e5%9c%a8xs%e4%b8%8a%e5%a6%82%e4%bd%95%e5%af%a6%e7%8f%be/) 說明：符合上述兩個條件的警示腳本如下:

if high=highest(high,200)

and GetSymbolField("tse.tw","收盤價")\>

average(GetSymbolField("tse.tw","收盤價"),20)

then ret=1;

---

## 場景 712：在K線圖上標進出場點 — 首先，要在K線上標示進出場點，要用的是自訂指標的功能，所以先在XScript編輯器，新增一個自訂指標的腳本，然後開始撰寫如下的腳本

來源：[在K線圖上標進出場點](https://www.xq.com.tw/xstrader/%e5%9c%a8k%e7%b7%9a%e5%9c%96%e4%b8%8a%e6%a8%99%e9%80%b2%e5%87%ba%e5%a0%b4%e9%bb%9e/) 說明：首先，要在K線上標示進出場點，要用的是自訂指標的功能，所以先在XScript編輯器，新增一個自訂指標的腳本，然後開始撰寫如下的腳本

input:n(20,"期別");

//設定進場點標示的位置

switch(close)

begin

case \>150: value5=low\*0.9;

case \<50 : value5=low\*0.98;

default: value5=low\*0.95;

end;

//設定出場點標示的位置

switch(close)

begin

case \>150: value6=high\*1.1;

case \<50 : value6=high\*1.02;

default: value6=high\*1.05;

end;

if close=highest(close,n)

and barslast(close=highest(close,n))\[1\]\>=20

//上一個創n日新高的進場點在20天以前

then plot1(value5);

if close=lowest(close,n)

and barslast(close=lowest(close,n))\[1\]\>=20

then plot2(value6);

---

## 場景 713：關於跳空的三個策略 — 3.100日均量超過500張

來源：[關於跳空的三個策略](https://www.xq.com.tw/xstrader/%e9%97%9c%e6%96%bc%e8%b7%b3%e7%a9%ba%e7%9a%84%e4%b8%89%e5%80%8b%e7%ad%96%e7%95%a5/) 說明：3.100日均量超過500張

if open\[1\]\>close\[2\]\*1.02

and open\[1\]=low\[1\]

//前一日跳空

then begin

if close\*1.02\<=open\[1\]

//補空2%

and average(volume,100)\>500

then ret=1;

end;

---

## 場景 714：開發彼此無相關的複合策略 — 我單獨寫了一個bband的進場腳本

來源：[開發彼此無相關的複合策略](https://www.xq.com.tw/xstrader/%e9%96%8b%e7%99%bc%e5%bd%bc%e6%ad%a4%e7%84%a1%e7%9b%b8%e9%97%9c%e7%9a%84%e8%a4%87%e5%90%88%e7%ad%96%e7%95%a5/) 說明：我單獨寫了一個bband的進場腳本

setbackbar(20);

input:length(20);

variable:up1(0),down1(0),mid1(0),bbandwidth(0);

up1 \= bollingerband(Close, Length, 2);

down1 \= bollingerband(Close, Length, \-2 );

mid1 \= (up1 \+ down1) / 2;

bbandwidth \= 100 \* (up1 \- down1) / mid1;

if linearregslope(up1,10)\[1\]\<0

and linearregslope(down1,10)\[1\]\>0

and bbandwidth\[1\]\*1.1\<average(bbandwidth,20)\[1\]

and close crosses over mid1

and close crosses over highest(high\[1\],2)

then ret=1;

---

## 場景 715：開發彼此無相關的複合策略 — 勝率是48.21%，如果我加上主力前一日買超大於800張這樣的籌碼面條件，腳本如下

來源：[開發彼此無相關的複合策略](https://www.xq.com.tw/xstrader/%e9%96%8b%e7%99%bc%e5%bd%bc%e6%ad%a4%e7%84%a1%e7%9b%b8%e9%97%9c%e7%9a%84%e8%a4%87%e5%90%88%e7%ad%96%e7%95%a5/) 說明：勝率是48.21%，如果我加上主力前一日買超大於800張這樣的籌碼面條件，腳本如下

condition1=false;

condition2=false;

setbackbar(20);

input:length(20);

variable:up1(0),down1(0),mid1(0),bbandwidth(0);

up1 \= bollingerband(Close, Length, 2);

down1 \= bollingerband(Close, Length, \-2 );

mid1 \= (up1 \+ down1) / 2;

bbandwidth \= 100 \* (up1 \- down1) / mid1;

if linearregslope(up1,10)\[1\]\<0

and linearregslope(down1,10)\[1\]\>0

and bbandwidth\[1\]\*1.1\<average(bbandwidth,20)\[1\]

and close crosses over mid1

and close crosses over highest(high\[1\],2)

then condition1=true;

value1=GetField("主力買賣超張數");

if value1\[1\]\>800

and volume\>=average(volume,20)\*1.3

then condition2=true;

if condition1 and condition2 then ret=1;

---

## 場景 716：開發彼此無相關的複合策略 — 如果要說技術面與籌碼面整合的不錯的交易策略，小弟倒是可以提供一個，先來看腳本

來源：[開發彼此無相關的複合策略](https://www.xq.com.tw/xstrader/%e9%96%8b%e7%99%bc%e5%bd%bc%e6%ad%a4%e7%84%a1%e7%9b%b8%e9%97%9c%e7%9a%84%e8%a4%87%e5%90%88%e7%ad%96%e7%95%a5/) 說明：如果要說技術面與籌碼面整合的不錯的交易策略，小弟倒是可以提供一個，先來看腳本

//全部股票，出場設20天

input:period(20);

value1=GetField("分公司賣出家數")\[1\];

value2=GetField("分公司買進家數")\[1\]; 

if linearregslope(value1,period)\>0

//賣出的家數愈來愈多

and linearregslope(value2,period)\<0

//買進的家數愈來愈少

and

 close\*1.05\<close\[period\]

//但這段期間股價在跌

and 

close\*1.03\<close\[1\]

//今天又跌超過3%

and close\*1.5\<close\[100\]

and tselsindex(10,6)=1

then ret=1;

---

## 場景 717：個股儀表板step by step — 我在書裡舉了以下的例子

來源：[個股儀表板step by step](https://www.xq.com.tw/xstrader/%e5%80%8b%e8%82%a1%e5%84%80%e8%a1%a8%e6%9d%bfstep-by-step/) 說明：我在書裡舉了以下的例子

{

指標說明

個股儀表板演化的交易策略

收錄於「三週學會程式交易：打造你的第一筆自動化交易」 330頁

https://www.ipci.com.tw/books\_in.php?book\_id=724

}

condition1=false;

condition2=false;

condition3=false;

condition4=false;

condition5=false;

condition6=false;

condition7=false;

condition8=false;

condition9=false;

condition10=false;

switch(close)

begin

 case \>150: value5=low\*0.9;

 case \<50 : value5=low\*0.98;

 default: value5=low\*0.95;

end;

//==========日KD黃金交叉================

input: \_TEXT1("===============","KD參數");

input: Length\_D(9,"日KD期間");

variable:rsv\_d(0),kk\_d(0),dd\_d(0),c5(0);

stochastic(Length\_D, 3, 3, rsv\_d, kk\_d, dd\_d);

c5=barslast(kk\_d crosses over dd\_d);

if c5=0 and c5\[1\]\>20 then 

 condition1=true;

if condition1 then

 plot1(value5,"月KD高檔鈍化且日KD黃金交叉");

//============內外盤量比差====================

variable:c3(0);

value6=GetField("內盤量");//單位:元

value7=GetField("外盤量");//單位:元

if volume\<\>0 then begin

 value8=value7/volume\*100;//外盤量比

 value9=value6/volume\*100;//內盤量比

end;

value10=average(value8,5);

value11=average(value9,5);

value7=value10-value11+5;

c3=barslast(value7 crosses over 0);

if c3=0 and c3\[1\]\>20 then

 condition2=true;

if condition2 then

 plot2(value5\*0.99,"內外盤量比差");

//===========淨力指標==============

input: \_TEXT2("===============","淨力指標參數");

input:period2(10,"長期參數");

variable:c4(0);

value12=summation(high-close,period2);//上檔賣壓

value13=summation(close-open,period2); //多空實績

value14=summation(close-low,period2);//下檔支撐

value15=summation(open-close\[1\],period2);//隔夜力道

if close\<\>0 then

 value16=(value13+value14+value15-value12)/close\*100;

c4=barslast(value16 crosses over \-4);

if c4=0 and c4\[1\]\>20 then

 condition3=true;

if condition3 then

 plot3(value5\*0.98,"淨力指標");

//===========多頭起漲前的籌碼收集================

variable:c2(0);

value1=GetField("分公司買進家數");

value2=GetField("分公司賣出家數");

value3=value2-value1;

value4=countif(value3\>20,10);

c2=barslast(value4\>6);

if c2=0 and c2\[1\]\>20 then

 condition4=true;

if condition4=true then

 plot4(value5\*0.97,"籌碼收集");

//===========法人同步買超====================

variable: v1(0),v2(0),v3(0),c1(0);

v1=GetField("外資買賣超");

v2=GetField("投信買賣超");

v3=GetField("自營商買賣超");

c1= barslast(maxlist2(v1,v2,v3)\>100);

if c1=0 and c1\[1\]\>20 then

 condition5=true;

if condition5=true then

 plot5(value5\*0.96,"法人同步買超");

//========DIF-MACD 翻正=============

input: \_TEXT3("===============","MACD參數");

input: FastLength(12,"DIF短天數"), SlowLength(26, "DIF長天數"), MACDLength(9, "MACD天數");

variable: difValue(0), macdValue(0), oscValue(0);

MACD(weightedclose(), FastLength, SlowLength,MACDLength, difValue, macdValue, oscValue);

variable:c6(0);

c6=barslast(oscValue Crosses Above 0);

if c6=0 and c6\[1\]\>20 then

 condition6=true;

if condition6 then

 plot6(value5\*0.95,"DIF-MACD 翻正");

//========資金流向======================

variable: m1(0),ma1(0),c7(0);

m1=GetField("資金流向");

ma1=average(m1,20)\*1.5;

c7=barslast(m1 crosses over ma1 and close\>close\[1\]);

if c7=0 and c7\[1\]\>20 then

 condition7=true;

if condition7 then

 plot7(value5\*0.94,"資金流向");

 

//=========總成交次數================

variable: t1(0),mat1(0),c8(0);

t1=GetField("總成交次數","D");

mat1=average(t1,20)\*1.5;

c8=barslast(t1 crosses over mat1 and close\>close\[1\]);

if c8=0 and c8\[1\]\>20 then

 condition8=true;

if condition8 then 

 plot8(value5\*0.93,"成交次數");

 

//=========強弱指標==================

variable:s1(0),c9(0);

s1=GetField("強弱指標","D");

c9=barslast(trueall(s1\>0,3));

if c9=0 and c9\[1\]\>20 then

 condition9=true;

if condition9 then

 plot9(value5\*0.92,"強弱指標");

 

//============開盤委買================

variable:b1(0),mab1(0),c10(0);

b1=GetField("主力買張");

mab1=average(b1,10);

c10=barslast(b1 crosses over mab1);

if c10=0 and c10\[1\]\>10 then

 condition10=true;

if condition10 then 

 plot10(value5\*0.91,"主力買張");

---

## 場景 718：個股儀表板step by step — 根據這些步驟，舉一個更容易理解的例子，如果把移動平均線黃金交叉，動能指標突破零，9K突破9D，以及6日RSI突破12日RSI，DIF-MACD轉正視為五個不同的...

來源：[個股儀表板step by step](https://www.xq.com.tw/xstrader/%e5%80%8b%e8%82%a1%e5%84%80%e8%a1%a8%e6%9d%bfstep-by-step/) 說明：根據這些步驟，舉一個更容易理解的例子，如果把移動平均線黃金交叉，動能指標突破零，9K突破9D，以及6日RSI突破12日RSI，DIF-MACD轉正視為五個不同的進場標準，那麼包含這四個進場標準的個股儀表板就可以像下面這個腳本的寫法

//把每一個進場標準都視為一個condition，

//有多少個標準就設多少個，

//每一個condition的default值都是false。

condition1=false;

condition2=false;

condition3=false;

condition4=false;

condition5=false;

//依不同價位設置進場點的標示位置

switch(close)

begin

 case \>150: value5=low\*0.9;

 case \<50 : value5=low\*0.98;

 default: value5=low\*0.95;

end;

//開始根據進場標準，

//在condition從false變成true時

//把進場標示標在當根K棒的底下。

//用Barslast來過濾同一個訊號必須是20天來第一次出現的

//==========日KD黃金交叉================

input: \_TEXT1("===============","KD參數");

input: Length\_D(9,"日KD期間");

variable:rsv\_d(0),kk\_d(0),dd\_d(0),c1(0);

stochastic(Length\_D, 3, 3, rsv\_d, kk\_d, dd\_d);

c1=barslast(kk\_d crosses over dd\_d);

if c1=0 and c1\[1\]\>20 then 

 condition1=true;

if condition1 then

 plot1(value5,"月KD高檔鈍化且日KD黃金交叉");

//========DIF-MACD 翻正=============

input: \_TEXT3("===============","MACD參數");

input: FastLength(12,"DIF短天數"), SlowLength(26, "DIF長天數"), MACDLength(9, "MACD天數");

variable: difValue(0), macdValue(0), oscValue(0);

MACD(weightedclose(), FastLength, SlowLength,MACDLength, difValue, macdValue, oscValue);

variable:c2(0);

c2=barslast(oscValue Crosses Above 0);

if c2=0 and c2\[1\]\>20 then

 condition2=true;

if condition2 then

 plot2(value5\*0.99,"DIF-MACD 翻正");

//========移動平均線黃金交叉======================

variable: c3(0);

c3=barslast(average(close,5)cross over average(close,20));

if c3=0 and c3\[1\]\>20 then

 condition3=true;

if condition3 then

 plot3(value5\*0.98,"移動平均線黃金交叉");

 

//=========RSI黃金交叉================

variable: c4(0);

c4=barslast(RSI(close,6) crosses over rsi(close,12));

if c4=0 and c4\[1\]\>20 then

 condition4=true;

if condition4 then 

 plot4(value5\*0.97,"RSI黃金交叉");

 

//=========動能指標==================

variable:c5(0);

c5=barslast( momentum(close,10) crosses over 0);

if c5=0 and c5\[1\]\>20 then

 condition5=true;

if condition5 then

 plot5(value5\*0.96,"動能指標");

---

## 場景 719：試著用程式來描述型態之一 見底強勢回昇 — 根據上述的條件，我寫的腳本如下

來源：[試著用程式來描述型態之一 見底強勢回昇](https://www.xq.com.tw/xstrader/%e8%a9%a6%e8%91%97%e7%94%a8%e7%a8%8b%e5%bc%8f%e4%be%86%e6%8f%8f%e8%bf%b0%e5%9e%8b%e6%85%8b%e4%b9%8b%e4%b8%80/) 說明：根據上述的條件，我寫的腳本如下

input:period(25);

var:h1(0),h2(0),low1(0),low2(0),low3(0),hb1(0),hb2(0),lowb1(0)

,lowb2(0),lowb3(0);

low1=lowest(close,period);//最低點

h1=highest(close,period);//最高點

lowb1=lowestbar(close,period);//最低點所在的bar

hb1=highestbar(close,period);//最高點所在的bar

low2=swinglow(close,period,3,3,2);//第二低點

lowb2=swinglowbar(close,period,3,3,2);//第二低點所在的bar

low3=swinglow(close,period,3,3,3);//第三低點

lowb3=swinglowbar(close,period,3,3,3);//第三低點所在的bar

h2=swinghigh(close,period,3,3,2);//第二高點

hb2=swinghighbar(close,period,3,3,2);//第二高點所在的位置

value1=h1-low1;//計算最後一波下跌的長度

value2=h2-low1;//計算第一波回昇的長度

if lowb2=nthmaxlist(1,hb1,hb2,lowb1,lowb2,lowb3)

and hb1=nthmaxlist(2,hb1,hb2,lowb1,lowb2,lowb3)

and lowb1=nthmaxlist(3,hb1,hb2,lowb1,lowb2,lowb3)

and hb2=nthmaxlist(4,hb1,hb2,lowb1,lowb2,lowb3)

//設定各高低點的相對位置

and close\[60\]\>value1\*1.2

//波段大跌2成以上

and value2\>value1\*0.5

//回昇第一波要大於左頂到最低點的一半

and h2\>low2

//回昇第一波的高點要大於左底

and close cross over low2

then ret=1;

---

## 場景 720：葛拉罕留下來的投資智慧

來源：[葛拉罕留下來的投資智慧](https://www.xq.com.tw/xstrader/%e8%91%9b%e6%8b%89%e7%bd%95%e7%95%99%e4%b8%8b%e4%be%86%e7%9a%84%e6%8a%95%e8%b3%87%e6%99%ba%e6%85%a7/) 說明：我寫的腳本如下

value1=GetField("本期稅後淨利","Q")+GetField("本期稅後淨利","Q")\[1\]

\+GetField("本期稅後淨利","Q")\[2\]+GetField("本期稅後淨利","Q")\[3\];

//單位:百萬

value2=GetField("負債總額","Q");

value3=GetField("資產總額","Q");

value4=GetField("總市值","D");//單位:億

if value4\<value1\*7/100

and value3\>value2\*2

then ret=1;

outputfield(1,value1/100,0,"近四季獲利(億)");

outputfield(2,value1/100\*7,0,"獲利的七倍(億)");

outputfield(3,value4,0,"總市值");

outputfield(4,value2,0,"負債");

outputfield(5,value3,0,"資產");

---

## 場景 721：選股腳本:Z日均量低於N而連M日量大於K

來源：[選股腳本:Z日均量低於N而連M日量大於K](https://www.xq.com.tw/xstrader/%e5%b8%b8%e7%94%a8%e7%9a%84%e9%81%b8%e8%82%a1%e8%85%b3%e6%9c%ac%e4%b9%8b1z%e6%97%a5%e5%9d%87%e9%87%8f%e4%bd%8e%e6%96%bcn%e8%80%8c%e9%80%a3m%e6%97%a5%e9%87%8f%e5%a4%a7%e6%96%bck/) 說明：我寫的選股腳本如下：

input:z(20,"均量計算天期");

input:n(2000,"均量上限");

input:m(2,"近幾日天期數");

input:k(4000,"近幾日量下限");

if average(volume,z)\[m-1\]\<n

and trueall(volume\>k,m)

then ret=1;

---

## 場景 722：價值衡量九式之九

來源：[價值衡量九式之九](https://www.xq.com.tw/xstrader/%e5%83%b9%e5%80%bc%e8%a1%a1%e9%87%8f%e4%b9%9d%e5%bc%8f%e4%b9%8b%e4%b9%9d/) 說明：腳本的寫法如下:

input:m1("不符合"),m2("符合");

var:s1(""),s2(""),s3(""),s4(""),s5("");

var:count(0);

condition1=false;

condition2=false;

condition3=false;

condition4=false;

condition5=false;

count=0;

//用最近三個月營收推估的獲利殖利率高於一定水準

value1=GetField("營業利益","Q");//單位:百萬

value2=GetField("月營收","M");//單位:億

value3=GetField("營業利益率","Q");

value4=GETFIELD("月營收","M")

\+GETFIELD("月營收","M")\[1\]

\+GETFIELD("月營收","M")\[2\];

//近三個月營收

value5=value4\*value3/100;

//用最近一期營益率去估算的最近一季營業利益

value6=GetField("營業利益","Q")

\+GetField("營業利益","Q")\[1\]

\+GetField("營業利益","Q")\[2\]+value5\*100;

//前三季營業利益加上最近一季預估營業利益

value8=GetField("最新股本");//單位億

value9=value6/(value8\*100)\*10;

//估算出來的EPS

value10=value9/close\*100;

//eps/股價\*100: 預估殖利率

input:r1(7,"殖利率下限");

if value10\>r1 and value3\>0 and close\>10

then begin

condition1=true ;

s1=m2;

count=count+1;

end 

else

s1=m1;

 

//本業推估本益比低於N

input:epsl(15,"預估本益比上限");

value11= GetField("營業利益","Q")

\+GetField("營業利益","Q")\[1\]

\+GetField("營業利益","Q")\[2\]

\+GetField("營業利益","Q")\[3\];

value12= GetField("最新股本");//單位億;

value13= value11/(value12\*10);//每股預估EPS

if close/value13\<=epsl

then begin

condition2=true ;

s2=m2;

count=count+1;

end 

else

s2=m1;

//流動資產減負債超過市值N成

input:ratio(80,"佔總市值百分比%");

if (GetField("流動資產","Q")-GetField("負債總額","Q"))/100\>GetField("總市值","D")\*ratio/100

then begin

condition3=true ;

s3=m2;

count=count+1;

end 

else

s3=m1;

//股價低於N年平均股利的N倍

input:N1(16,"股利的倍數");

 

value15=(GetField("股利合計","Y")

\+GetField("股利合計","Y")\[1\]

\+GetField("股利合計","Y")\[2\]

\+GetField("股利合計","Y")\[3\]

\+GetField("股利合計","Y")\[4\])/5;

if close\<value15\*N1

then begin

condition4=true ;

s4=m2;

count=count+1;

end 

else

s4=m1;

 

//高自由現金流總市值比

input:ratio1(10,"近四季自由現金流總合佔總市值最低比率單位:%");

if (GetField("來自營運之現金流量","Q")+GetField("來自營運之現金流量","Q")\[1\]+

GetField("來自營運之現金流量","Q")\[2\]+GetField("來自營運之現金流量","Q")\[3\]-

GetField("資本支出金額","Q")-GetField("資本支出金額","Q")\[1\]

\-GetField("資本支出金額","Q")\[2\]-GetField("資本支出金額","Q")\[3\])

\>GetField("總市值","D")\*100\*ratio1/100

then begin

condition5=true ;

s5=m2;

count=count+1;

end 

else

s5=m1;

if count\>1

then ret=1;

outputfield(1,count,0,"符合條件數");

outputfield(2,value9,1,"預估EPS");

outputfield(3,s1,0,"高預估殖利率股");

outputfield(4,s2,0,"本業推估本益比低");

outputfield(5,s3,0,"流動性淨資產接近市值");

outputfield(6,s4,0,"以歷年平均股利計算之高殖利率股");

outputfield(7,s5,0,"高自由現金流總市值比");

---

## 場景 723：價值衡量九式之八 — 符合以上五個條件的選股腳本

來源：[價值衡量九式之八](https://www.xq.com.tw/xstrader/%e5%83%b9%e5%80%bc%e8%a1%a1%e9%87%8f%e4%b9%9d%e5%bc%8f%e4%b9%8b%e5%85%ab/) 說明：符合以上五個條件的選股腳本

if GetField("本益比","D") \< 15 and

 GetField("股價淨值比","D") \<2 and

 GetField("殖利率","D") \> 3 and

 GetField("營收成長率","Q") \>0 and

 GetField("營業利益","Q") \>GetField("營業利益","Q")\[1\] 

 

 then ret=1;

---

## 場景 724：價值衡量九式之七 — 要找出這樣的股票，要分兩個腳本，一個是用年線，找出過去五年營業利益超過兩億且呈上昇趨勢的股票

來源：[價值衡量九式之七](https://www.xq.com.tw/xstrader/%e5%83%b9%e5%80%bc%e8%a1%a1%e9%87%8f%e4%b9%9d%e5%bc%8f%e4%b9%8b%e4%b8%83/) 說明：要找出這樣的股票，要分兩個腳本，一個是用年線，找出過去五年營業利益超過兩億且呈上昇趨勢的股票

input:lm(200,"年營業利益下限");

value1=GetField("營業利益","Y");//百萬

if 

GetField("營業利益","Y")\>lm and 

GetField("營業利益","Y")\[1\]\>lm and 

GetField("營業利益","Y")\[2\]\>lm and

GetField("營業利益","Y")\[3\]\>lm and 

GetField("營業利益","Y")\[4\]\>lm and 

//週去五年都賺超過一億

linearregslope(value1,5)\>0

//五年的營業利益趨勢往上

then ret=1;

---

## 場景 725：價值衡量九式之七 — 另一個腳本則是拿最近一年的營業利益為基礎，來算估值

來源：[價值衡量九式之七](https://www.xq.com.tw/xstrader/%e5%83%b9%e5%80%bc%e8%a1%a1%e9%87%8f%e4%b9%9d%e5%bc%8f%e4%b9%8b%e4%b8%83/) 說明：另一個腳本則是拿最近一年的營業利益為基礎，來算估值

input:ratio(30,"折價比例%");

value1=GetField("營業利益","Y");//百萬

value2=GetField("每股淨值(元)","Y");

value3=GetField("普通股股本","Y");//單位:億

value4=value1\*5/100/value3\*10;

//用最近一年營業利益乘以五當未來五年的獲利

//算出未來五年的每股淨值增加值\]

value5=value2+value4;

//以目前的每股淨值加上上述數字即是公司內含價值

//(不考慮折舊的issue)

if close\*(1+ratio/100)\<value5

then ret=1;

outputfield(1,value5,1,"內含價值");

outputfield(2,close,2,"目前股價");

outputfield(3,1-close/value5,"折溢價情況");

---

## 場景 726：價值衡量九式之六

來源：[價值衡量九式之六](https://www.xq.com.tw/xstrader/%e5%83%b9%e5%80%bc%e8%a1%a1%e9%87%8f%e4%b9%9d%e5%bc%8f%e4%b9%8b%e5%85%ad/) 說明：我寫的腳本如下:

input:discountrate(20);

var:truevalue(0);

value1=getfield("累計營收年增率","M");

GetField("每股營業利益(元)","Q");

value3=GetField("每股營業利益(元)","Q")

\+GetField("每股營業利益(元)","Q")\[1\]

\+GetField("每股營業利益(元)","Q")\[2\]

\+GetField("每股營業利益(元)","Q")\[3\];//推估的全年EPS

if value3\>0 then begin

switch(value1)//視累計營收年增率的高低給不同本益比

begin

case\>15: truevalue=value3\*20;

//成長率超過15%給20倍本益比

case\<=0: truevalue=value3\*10;

//衰退只給十倍本益比

default: truevalue=value3\*15;

//一般就給15倍本益比

end;

if close\*(1+discountrate/100)\<truevalue

then ret=1;

outputfield(1,(truevalue-close)/close\*100,2,"折價率");

end;

---

## 場景 727：價值衡量九式之五

來源：[價值衡量九式之五](https://www.xq.com.tw/xstrader/%e5%83%b9%e5%80%bc%e8%a1%a1%e9%87%8f%e4%b9%9d%e5%bc%8f%e4%b9%8b%e4%ba%94/) 說明：我寫的腳本如下

input:r(6,"年預期報酬率單位%");

value1=(GetField("現金股利","Y")+GetField("現金股利","Y")\[1\]

\+GetField("現金股利","Y")\[2\]+GetField("現金股利","Y")\[3\]

\+GetField("現金股利","Y")\[4\])/5 ;

var: s1(0),s2(0),s3(0),s4(0);

if minlist(GetField("現金股利","Y")\[1\],GetField("現金股利","Y")\[2\],GetField("現金股利","Y")\[3\])

\>0 then begin

s1=GetField("現金股利","Y")/GetField("現金股利","Y")\[1\]-1;

s2=GetField("現金股利","Y")\[1\]/GetField("現金股利","Y")\[2\]-1;

s3=GetField("現金股利","Y")\[2\]/GetField("現金股利","Y")\[3\]-1;

s4=minlist(s1,s2,s3)\*100;

end;

if value1\>1 and r\>s4 and s4\>0then begin

value2=value1/(r-s4)\*100;

if close\<\>0 then 

value3=(value2-close)/close\*100;

if value3\>10

and GetField("現金股利","Y")\>GetField("現金股利","Y")\[1\]

then ret=1;

//outputfield(1,value3,0,"折價率");

outputfield(2,value1,1,"平均現金股利");

outputfield(3,s4,1,"近年最低股利成長率");

//outputfield(4,value2,1,"合理股價");

end;

---

## 場景 728：價值衡量九式之四 — 這個腳本就是把過去五年的平均現金股利當未來的計算基礎，但前提是最近一年的現金股利要比前一年高，然後在給定預期報酬率之後，算出合理的股價，再跟現的收盤價比，算出目...

來源：[價值衡量九式之四](https://www.xq.com.tw/xstrader/%e5%83%b9%e5%80%bc%e8%a1%a1%e9%87%8f%e4%b9%9d%e5%bc%8f%e4%b9%8b%e5%9b%9b/) 說明：這個腳本就是把過去五年的平均現金股利當未來的計算基礎，但前提是最近一年的現金股利要比前一年高，然後在給定預期報酬率之後，算出合理的股價，再跟現的收盤價比，算出目前的折價率。

input:r(6,"年預期報酬率單位%");

value1=(GetField("現金股利","Y")+GetField("現金股利","Y")\[1\]

\+GetField("現金股利","Y")\[2\]+GetField("現金股利","Y")\[3\]

\+GetField("現金股利","Y")\[4\])/5 ;

if value1\>1 then begin

value2=value1/r\*100;

if close\<\>0 then 

value3=(value2-close)/close\*100;

if value3\>10

and GetField("現金股利","Y")\>GetField("現金股利","Y")\[1\]

then ret=1;

outputfield(1,value3,0,"折價率");

outputfield(2,value1,1,"平均現金股利");

outputfield(3,value2,1,"合理股價");

end;

---

## 場景 729：價值衡量九式之三 — 綜合這四點，我寫了一個選股條件如下

來源：[價值衡量九式之三](https://www.xq.com.tw/xstrader/%e5%83%b9%e5%80%bc%e8%a1%a1%e9%87%8f%e4%b9%9d%e5%bc%8f%e4%b9%8b%e4%b8%89/) 說明：綜合這四點，我寫了一個選股條件如下

value1=GetField("總市值","D");//單位億

value2=GetField("營業收入淨額","Y");//單位百萬

value3=value1/value2\*100;

value4=GetField("營業毛利率","Q");

value5=GetField("營業費用率","Q");

value6=GetField("負債比率","Q");

if value3\<2 and value4\>15 

and value5\>30 and value6\<20

then ret=1;

outputfield(1,value3,1,"市值營收比");

outputfield(2,value4,0,"毛利率");

outputfield(3,value1,0,"總市值");

outputfield(4,value2/100,0,"年營收");

outputfield(5,value5,0,"營業費用率");

outputfield(6,value6,0,"負債比率");

---

## 場景 730：價值衡量九式之二 — 依這樣的概念，我寫了一個選股程式

來源：[價值衡量九式之二](https://www.xq.com.tw/xstrader/%e5%83%b9%e5%80%bc%e8%a1%a1%e9%87%8f%e4%b9%9d%e5%bc%8f%e4%b9%8b%e4%ba%8c/) 說明：依這樣的概念，我寫了一個選股程式

value1=GetField("股東權益報酬率","Y");

value2=GetField("股價淨值比","D");

value3=value2/(value1/100);//回本年限

input:ratio(50,"回本年限");

if value1\>0 and value3\<ratio then ret=1;

outputfield(1,value1,0,"股東權益報酬率");

outputfield(2,value2,1,"股價淨值比");

outputfield(3,value3,1,"回本年限");

---

## 場景 731：價值衡量九式之一 — 把這樣概念轉換成選股腳本，可以這麼寫

來源：[價值衡量九式之一](https://www.xq.com.tw/xstrader/9-1/) 說明：把這樣概念轉換成選股腳本，可以這麼寫

value1=GetField("總市值","D");//單位億

value2=GetField("負債總額","Q");//單位百萬

value3=GetField("現金及約當現金","Q");//單位百萬

value4=GetField("短期投資","Q");//單位百萬

value5=GetField("稅前息前折舊前淨利","Q");//單位百萬

var: pricingm1(0);

input: bl(12,"上限值");

if value5\>0 then begin

pricingm1=(value1\*100+value2-value3-value4)/value5;

if pricingm1\<bl

then ret=1;

outputfield(1,pricingm1,1,"EV/EBITDA");

outputfield(2,value1\*100+value2-value3,0,"EV");

outputfield(3,value5,0,"EBITDA");

outputfield(4,value1,0,"總市值");

outputfield(5,value2,0,"負債總額");

outputfield(6,value3,0,"現金");

outputfield(7,value4,0,"短期投資");

end;

---

## 場景 732：找出市場上每股現金最多的公司 — 接下來就是撰寫這個函數的腳本

來源：[找出市場上每股現金最多的公司](https://www.xq.com.tw/xstrader/%e6%89%be%e5%87%ba%e5%b8%82%e5%a0%b4%e4%b8%8a%e6%af%8f%e8%82%a1%e7%8f%be%e9%87%91%e6%9c%80%e5%a4%9a%e7%9a%84%e5%85%ac%e5%8f%b8/) 說明：接下來就是撰寫這個函數的腳本

value1=GetField("現金及約當現金","Q");//百萬

value2=GetField("短期投資","Q");

value3=GetField("短期借款","Q");

value4=GetField("總市值","D");

value5=(value1+value2+value3)/(value4\*100);

if value4\<\>0 then 

value6=value5/value4;

ret=value6;

---

## 場景 733：雞蛋水餃股的反彈行情 — 我寫了一個腳本專門在計算近N個月總市值增加超過M億的股票

來源：[雞蛋水餃股的反彈行情](https://www.xq.com.tw/xstrader/%e9%9b%9e%e8%9b%8b%e6%b0%b4%e9%a4%83%e8%82%a1%e7%9a%84%e5%8f%8d%e5%bd%88%e8%a1%8c%e6%83%85/) 說明：我寫了一個腳本專門在計算近N個月總市值增加超過M億的股票

value1=GetField("總市值","M");//單位:億

input:N1(24,"計算月份數");

input: addvalue(100,"總市值增加金額(單位:億");

if value1-value1\[n1-1\]\>addvalue

then ret=1;

outputfield(1,value1-value1\[n1-1\],0,"市場增加金額(億)");

---

## 場景 734：雞蛋水餃股的反彈行情 — 今天跟大家介紹的這個選股機器人上面的策略，就是衝著雞蛋水餃股而設計的交易策略

來源：[雞蛋水餃股的反彈行情](https://www.xq.com.tw/xstrader/%e9%9b%9e%e8%9b%8b%e6%b0%b4%e9%a4%83%e8%82%a1%e7%9a%84%e5%8f%8d%e5%bd%88%e8%a1%8c%e6%83%85/) 說明：今天跟大家介紹的這個選股機器人上面的策略，就是衝著雞蛋水餃股而設計的交易策略

//雞蛋水餃股

settotalbar(1600);

value1=GetField("總市值");

input:period(1500,"計算天數");

input:ratio(5,"距離低點幅度");

if value1\<lowest(value1,period)\*(1+ratio/100)

//總市值回到過去一段時間最低點

then begin

if close=highest(close,20)

//創20日新高

and close\<close\[19\]\*1.07

//距離20日前沒有漲太兇

and GetSymbolField("tse.tw","收盤價")

\>average(GetSymbolField("tse.tw","收盤價"),20)

//大盤多頭

and close \<20

//股價低於20

then ret=1;

end;

---

## 場景 735：突破繼續型態選股策略 — 根據這三個原則寫的腳本如下

來源：[突破繼續型態選股策略](https://www.xq.com.tw/xstrader/%e7%aa%81%e7%a0%b4%e7%b9%bc%e7%ba%8c%e5%9e%8b%e6%85%8b%e7%9a%84%e9%81%b8%e8%82%a1%e6%a9%9f%e5%99%a8%e4%ba%ba%e7%ad%96%e7%95%a5%e8%aa%aa%e6%98%8e/) 說明：根據這三個原則寫的腳本如下

variable:iHigh(0); iHigh=maxlist(iHigh,H);

variable:iLow(100000); iLow=minlist(iLow,L);

variable:hitlow(0),hitlowdate(0);

if iLow \= Low then //觸低次數與最後一次觸低日期

begin

hitlow+=1;

hitlowdate \=date;

end;

if DateAdd(hitlowdate,"M",1) \< Date and//如果自觸低點那天1個月後都沒有再觸低

iHigh/iLow \< 1.3 and //波動在三成以內

barslast(iHigh \= High)=0

and barslast(ihigh=high)\[1\]\>10

//超過十天沒有創新高

and average(volume,100)\>500

//來到設定日期以來最高點

and GetSymbolField("tse.tw","收盤價")

\>average(GetSymbolField("tse.tw","收盤價"),20)

then ret \=1;

---

## 場景 736：金牌定存股選股策略 — 金牌定存股這個 選股策略是由兩個腳本組成，第一個是找出金牌定存股的腳本

來源：[金牌定存股選股策略](https://www.xq.com.tw/xstrader/%e9%87%91%e7%89%8c%e5%ae%9a%e5%ad%98%e8%82%a1/) 說明：金牌定存股這個 選股策略是由兩個腳本組成，第一個是找出金牌定存股的腳本

input:lowlimit(5,"年度獲利下限(億)");

value1=GetField("本期稅後淨利","Y");//單位:百萬

value2=lowest(value1,5);//五年獲利低點

value3=average(value1,5);//五年來平均獲利

if value1/100\> lowlimit//獲利超過年度獲利下限

and value1/100\<50//獲利沒有超過五十億元

and 

value1\>value1\[1\]\*0.9

and value1\[1\]\>value1\[2\]\*0.9//年度獲利連續兩年未衰退超過一成

and value2\*1.3\>value3

//五年來獲利最差的時候比平均值沒有掉超過三成

then ret=1;

outputfield(1, value1/100, 1, "稅後淨利(億)");

---

## 場景 737：金牌定存股選股策略 — 第二個腳本則是用月線及季線來定義目前股價處在什麼位置

來源：[金牌定存股選股策略](https://www.xq.com.tw/xstrader/%e9%87%91%e7%89%8c%e5%ae%9a%e5%ad%98%e8%82%a1/) 說明：第二個腳本則是用月線及季線來定義目前股價處在什麼位置

variable:m20(0),m60(0),message("0") ;

m20=average(close,20);

m60=average(close,60);

if close \> m20 and c\< m60 and m20\<m60

then message="復甦期"

else 

if close \> m20 and c\> m60 and m20\<m60

then message="收集期" 

else 

if close \> m20 and c\> m60 and m20 \> m60

then message="多頭"

else 

if close \< m20 and c\>m60 and m20\>m60

then message="警示期"

else 

if close \< m20 and c\<m60 and m20\>m60

then message="發散期"

else 

if close \< m20 and c\<m60 and m20\<m60

then message="空頭";

 

if message\<\>message\[1\]

and message="多頭"

and message\[1\]="收集期"

and message\[2\]="收集期"

and volume\>500 and close\>10

then ret=1;

outputfield1(message);

setoutputname1("今日訊號");

outputfield2(message\[1\]);

setoutputname2("昨日訊號");

outputfield3(message\[2\]);

setoutputname3("前日訊號");

---

## 場景 738：現金總市值比高的公司 — 第一個是找現金總市值比高過0.7的公司

來源：[現金總市值比高的公司](https://www.xq.com.tw/xstrader/%e7%8f%be%e9%87%91%e7%b8%bd%e5%b8%82%e5%80%bc%e6%af%94%e9%ab%98%e7%9a%84%e5%85%ac%e5%8f%b8/) 說明：第一個是找現金總市值比高過0.7的公司

value1=GetField("現金及約當現金","Q");//單位百萬

value2=GetField("短期投資","Q");//單位百萬

value3=(value1+value2)/100;//單位億之現金及短期投資合計金額

value4=GetField("總市值","D");//單位:億

if value4\<\>0

then value5=value3/value4;

//現金總市值比;

if value5\>0.7 and value3\>3

 //現金總市值比大於0.7且現金及短投合計超過3億

then ret=1;

outputfield(1, value5, 1, "現金總市值比");

---

## 場景 739：現金總市值比高的公司 — 第二個則是常見的無量變有量

來源：[現金總市值比高的公司](https://www.xq.com.tw/xstrader/%e7%8f%be%e9%87%91%e7%b8%bd%e5%b8%82%e5%80%bc%e6%af%94%e9%ab%98%e7%9a%84%e5%85%ac%e5%8f%b8/) 說明：第二個則是常見的無量變有量

input:v1(1000,"前一根bar成交量");

input:v2(1500,"這根bar成交量");

if trueall(volume\[1\]\<=v1,10) and volume\>v2 

then ret=1;

---

## 場景 740：低PB股轉強 — 這個選股策略，是從一個警示策略改良而來，這個警示策略的腳本如下

來源：[低PB股轉強](https://www.xq.com.tw/xstrader/%e4%bd%8epb%e8%82%a1%e8%bd%89%e5%bc%b7/) 說明：這個選股策略，是從一個警示策略改良而來，這個警示策略的腳本如下

// 選股法: 普通股全部

// 作多, 持有期別=20期

//

if GetSymbolField("tse.tw","收盤價") \> average(GetSymbolField("tse.tw","收盤價"),10)

then begin

 if close\<15

 and H \= highest(H,20)

 and close\<lowest(low,20)\*1.07

 and highest(h,40)\>close\*1.1

 then

 ret=1;

end;

---

## 場景 741：那些股票外資買超的隔天上漲的機會比較大??

來源：[那些股票外資買超的隔天上漲的機會比較大??](https://www.xq.com.tw/xstrader/%e9%82%a3%e4%ba%9b%e8%82%a1%e7%a5%a8%e5%a4%96%e8%b3%87%e8%b2%b7%e8%b6%85%e7%9a%84%e9%9a%94%e5%a4%a9%e4%b8%8a%e6%bc%b2%e7%9a%84%e6%a9%9f%e6%9c%83%e6%af%94%e8%bc%83%e5%a4%a7/) 說明：於是我寫了以下的腳本

input:n(500,"樣本數");

settotalbar(n);

value1=GetField("外資買賣超","D");

variable:x1(0),y(0),c1(0),c2(0),c3(0);

if value1\[1\]\>200 

then begin

x1=1;

c1=c1+1;

//外資買超的次數

end

else x1=0;

if close\>open

then begin

y=1;

c2=c2+1;

//上漲的次數

end

else y=0;

if value1\[1\]\>200

and close\>open

then c3=c3+1;

//上漲且外資買超的次數

value2=c1/n; //外資買超的機率

value3=c2/n; //上漲的機率

value4=c3/c2;//收紅且外資買超的機率

value5=value4\*value3/value2;

if countif(value1\[1\]\>200,n)\>20

then ret=1;

outputfield(1,value5\*100,0,"外資前一日買超隔天收高的機率");

outputfield(2,c1,0,"上漲次數");

outputfield(3,c2,"外資買超次數");

outputfield(4,c3,0,"上漲且外資買超");

---

## 場景 742：那些股票外資買超的隔天上漲的機會比較大?? — 我寫了一個警示腳本如下:

來源：[那些股票外資買超的隔天上漲的機會比較大??](https://www.xq.com.tw/xstrader/%e9%82%a3%e4%ba%9b%e8%82%a1%e7%a5%a8%e5%a4%96%e8%b3%87%e8%b2%b7%e8%b6%85%e7%9a%84%e9%9a%94%e5%a4%a9%e4%b8%8a%e6%bc%b2%e7%9a%84%e6%a9%9f%e6%9c%83%e6%af%94%e8%bc%83%e5%a4%a7/) 說明：我寫了一個警示腳本如下:

value1=GetField("外資買賣超","D");

if value1\[1\]\>200 

then ret=1;

---

## 場景 743：打造個股儀表板 — 要畫出像上面的這張圖，對應腳本如下:

來源：[打造個股儀表板](https://www.xq.com.tw/xstrader/%e6%89%93%e9%80%a0%e5%80%8b%e8%82%a1%e5%84%80%e8%a1%a8%e6%9d%bf/) 說明：要畫出像上面的這張圖，對應腳本如下:

condition1=false;

condition2=false;

condition3=false;

condition4=false;

condition5=false;

condition6=false;

condition7=false;

condition8=false;

condition9=false;

condition10=false;

switch(close)

begin

case \>150: value5=low\*0.9;

case \<50 : value5=low\*0.98;

default: value5=low\*0.95;

end;

//==========日KD黃金交叉================

input: Length\_D(9, "日KD期間");

input: Length\_M(5, "周KD期間");

variable:rsv\_d(0),kk\_d(0),dd\_d(0),c5(0);

 

stochastic(Length\_D, 3, 3, rsv\_d, kk\_d, dd\_d);

 

c5=barslast(kk\_d crosses over dd\_d);

if c5=0 and c5\[1\]\>20

then condition1=true; 

if condition1

then plot1(value5,"月KD高檔鈍化且日KD黃金交叉");

//============內外盤量比差====================

var:c3(0);

value6=GetField("內盤量");//單位:元

value7=GetField("外盤量");//單位:元

if volume\<\>0 then begin

value8=value7/volume\*100;//外盤量比

value9=value6/volume\*100;//內盤量比

end;

value10=average(value8,5);

value11=average(value9,5);

value7=value10-value11+5;

c3=barslast(value7 crosses over 0);

if c3=0 and c3\[1\]\>20

then condition2=true;

if condition2

then 

plot2(value5,"內外盤量比差");

//===========淨力指標==============

var:c4(0);

input:period2(10,"長期參數");

value12=summation(high-close,period2);//上檔賣壓

value13=summation(close-open,period2); //多空實績

value14=summation(close-low,period2);//下檔支撐

value15=summation(open-close\[1\],period2);//隔夜力道

if close\<\>0

then

value16=(value13+value14+value15-value12)/close\*100;

 

c4=barslast( value16 crosses over \-4);

if c4=0 and c4\[1\]\>20

then condition3=true;

if condition3

then 

plot3(value5,"淨力指標");

//===========多頭起漲前的籌碼收集================

var:c2(0);

value1=GetField("分公司買進家數");

value2=GetField("分公司賣出家數");

value3=value2-value1;

value4=countif(value3\>20,10);

c2=barslast(value4\>6 );

if c2=0 and c2\[1\]\>20

then condition4=true;

if condition4=true

then

plot4(value5,"籌碼收集");

//===========法人同步買超====================

variable: v1(0),v2(0),v3(0),c1(0);

v1=Getfield("外資買賣超");

v2=Getfield("投信買賣超");

v3=Getfield("自營商買賣超");

c1= barslast(maxlist2(v1,v2,v3)\>100);

if c1=0 and c1\[1\]\>20

then condition5=true;

if condition5=true

then plot5(value5,"法人同步買超");

//========DIF-MACD翻正=============

input: FastLength(12), SlowLength(26), MACDLength(9);

variable: difValue(0), macdValue(0), oscValue(0);

MACD(weightedclose(), FastLength, SlowLength, MACDLength, difValue, macdValue, oscValue);

var:c6(0);

c6=barslast(oscValue Crosses Above 0);

if c6=0 and c6\[1\]\>20

then condition6=true;

if condition6

then plot6(value5,"DIF-MACD翻正");

//========資金流向======================

var: m1(0),ma1(0),c7(0);

m1=GetField("資金流向");

ma1=average(m1,20)\*1.5;

c7=barslast(m1 cross over ma1 and close\>close\[1\]);

if c7=0 and c7\[1\]\>20

then condition7=true;

if condition7

then plot7(value5,"資金流向");

//=========總成交次數================

var: t1(0),mat1(0),c8(0);

t1=GetField("總成交次數","D");

mat1=average(t1,20)\*1.5;

c8=barslast(t1 cross over mat1 and close\>close\[1\]);

if c8=0 and c8\[1\]\>20

then condition8=true;

if condition8

then plot8(value5,"成交次數");

//=========強弱指標==================

var:s1(0),c9(0);

s1=GetField("強弱指標","D");

c9=barslast(trueall(s1\>0,3));

if c9=0 and c9\[1\]\>20

then condition9=true;

if condition9

then plot9(value5,"強弱指標");

//============主力買張================

var:b1(0),mab1(0),c10(0);

b1=GetField("主力買張");

mab1=average(b1,10);

c10=barslast(b1 cross over mab1);

if c10=0 and c10\[1\]\>10

then condition10=true;

if condition10

then plot10(value5,"主力買張");

---

## 場景 744：當沖腳本2之多頭市場開盤暴量一分鐘K三連紅 — 我把這樣的精神寫成用一分鐘K在跑的腳本

來源：[當沖腳本2之多頭市場開盤暴量一分鐘K三連紅](https://www.xq.com.tw/xstrader/%e7%95%b6%e6%b2%96%e8%85%b3%e6%9c%ac2%e4%b9%8b%e5%a4%9a%e9%a0%ad%e5%b8%82%e5%a0%b4%e9%96%8b%e7%9b%a4%e6%9a%b4%e9%87%8f%e4%b8%80%e5%88%86%e9%90%98k%e4%b8%89%e9%80%a3%e7%b4%85/) 說明：我把這樣的精神寫成用一分鐘K在跑的腳本

if barfreq \<\> "Min" or Barinterval \<\>1 then

 RaiseRuntimeError("請設定頻率為1分鐘");

variable:BarNumberOfToday(0); 

if Date \<\> Date\[1\] then BarNumberOfToday=1 

else BarNumberOfToday+=1;{記錄今天的Bar數} 

if barnumberoftoday=3

//今天第三根1分鐘K，也就是開盤第三分鐘

then begin

if trueall(close\>=close\[1\],3)

//連三根K棒都是紅棒

and volume\>average(volume\[1\],3)\*2

//成交量是過去三根量平均量的兩倍以上

and close=highd(0)

//收最高

then ret=1;

end;

---

## 場景 745：當沖腳本1之五分鐘線狹幅整理後帶量突破 — 江湖傳說這種線當沖賺錢的機率大，所以我就試著寫了一個簡單的腳本來試

來源：[當沖腳本1之五分鐘線狹幅整理後帶量突破](https://www.xq.com.tw/xstrader/%e7%95%b6%e6%b2%96%e8%85%b3%e6%9c%ac1%e4%b9%8b%e4%ba%94%e5%88%86%e9%90%98%e7%b7%9a%e7%8b%b9%e5%b9%85%e6%95%b4%e7%90%86%e5%be%8c%e5%b8%b6%e9%87%8f%e7%aa%81%e7%a0%b4/) 說明：江湖傳說這種線當沖賺錢的機率大，所以我就試著寫了一個簡單的腳本來試

input:Length(100); setinputname(1,"計算期數");

input:Ratio(0.5); setinputname(2,"突破幅度%");

input:RRatio(2); setinputname(3,"盤整區間幅度%");

input:TXT1("僅適用5分鐘線"); setinputname(4,"使用限制");

settotalbar(3);

setbarback(Length);

if barfreq\<\> "Min" or barinterval \<\> 5 then return;

variable: RangeHigh(0);

variable: RangeLow(0);

RangeHigh=highest(close\[1\],length);

RangeLow=lowest(close\[1\],length);

if RangeHigh\[1\] \< RangeLow\[1\] \* (1+ RRatio/100)

then begin

if Close cross over RangeHigh\*(1+Ratio/100)

and volume\>average(volume,length)\*1.5 

and trueall(GetField("成交量","D")\>500,10)

then ret=1;

end;

---

## 場景 746：當沖腳本1之五分鐘線狹幅整理後帶量突破 — 最後po一下最終版的這個當沖腳本

來源：[當沖腳本1之五分鐘線狹幅整理後帶量突破](https://www.xq.com.tw/xstrader/%e7%95%b6%e6%b2%96%e8%85%b3%e6%9c%ac1%e4%b9%8b%e4%ba%94%e5%88%86%e9%90%98%e7%b7%9a%e7%8b%b9%e5%b9%85%e6%95%b4%e7%90%86%e5%be%8c%e5%b8%b6%e9%87%8f%e7%aa%81%e7%a0%b4/) 說明：最後po一下最終版的這個當沖腳本

input:Length(100); setinputname(1,"計算期數");

input:Ratio(0.5); setinputname(2,"突破幅度%");

input:RRatio(1.5); setinputname(3,"盤整區間幅度%");

input:TXT1("僅適用5分鐘線"); setinputname(4,"使用限制");

settotalbar(3);

setbarback(Length);

if barfreq\<\> "Min" or barinterval \<\> 5 then return;

variable: RangeHigh(0);

variable: RangeLow(0);

RangeHigh=highest(close\[1\],length);

RangeLow=lowest(close\[1\],length);

if RangeHigh\[1\] \< RangeLow\[1\] \* (1+ RRatio/100)

then begin

if Close cross over RangeHigh\*(1+Ratio/100)

and volume\>average(volume,length)\*1.5 

and trueall(GetField("成交量","D")\>500,10)

and countif(GetField("主力買賣超張數","D")\>0,10)\>=7

and GetSymbolField("tse.tw","收盤價","D")

\>GetSymbolField("tse.tw","收盤價","D")\[1\]

and GetSymbolField("tse.tw","收盤價","D")

\>average(GetSymbolField("tse.tw","收盤價","D"),5)

then ret=1;

end;

---

## 場景 747：進場點一目了然的大盤儀表板 — 我先來給大家看它的腳本

來源：[進場點一目了然的大盤儀表板](https://www.xq.com.tw/xstrader/%e9%80%b2%e5%a0%b4%e9%bb%9e%e4%b8%80%e7%9b%ae%e4%ba%86%e7%84%b6%e7%9a%84%e5%a4%a7%e7%9b%a4%e5%84%80%e8%a1%a8%e6%9d%bf/) 說明：我先來給大家看它的腳本

condition1=false;

condition2=false;

condition3=false;

condition4=false;

condition5=false;

//==========OTC佔大盤成交量比================

value1=GetSymbolField("tse.tw","成交量");

value2=GetSymbolField("otc.tw","成交量");

value3=value2/value1\*100;

value4=average(value3,5);

value5=low\*0.98;

if value4 cross over 20

then condition1=true;

if condition1

then plot1(value5,"OTC進場訊號");

//============內外盤量比差====================

value6=GetField("內盤量");//單位:元

value7=GetField("外盤量");//單位:元

value8=value7/volume\*100;//外盤量比

value9=value6/volume\*100;//內盤量比

value10=average(value8,5);

value11=average(value9,5);

value7=value10-value11+5;

if value7 cross over 0

then condition2=true;

if condition2

then 

plot2(value5,"內外盤量比差");

//===========上漲下跌家數RSI指標==============

input:period(10,"RSI計算天數");

value12=GetField("上漲家數");

value13=getfield("下跌家數");

value14=value12-value13;

value15=summation(value14,period);

value16=rsi(value15,period);

if value16 cross over 50

then condition3=true;

if condition3

then 

plot3(value5,"上漲下跌家數RSI");

//===========上漲家數突破200檔================

value17=lowest(value12,5);

value18=average(value17,15);

if value18 cross over 200

then condition4=true;

if condition4=true

then

plot4(value5,"上漲家數突破200家");

//==========上漲下跌量指標=====================

input:p1(3);

value19=GetField("上漲量");

value20=getfield("下跌量");

value21=average(value19,period);

value22=average(value20,period);

value23=value21-value22;

value24=average(value23,5);

if value24 cross over 0

then condition5=true;

if condition5=true

then

plot5(value5,"上漲量突破下跌量");

---

## 場景 748：打造自己的大盤多空函數 — 因此當我接觸到XS這個語法的時候，我在寫交易策略時，一定會把大盤的多空方向考慮進去。所以每一個我放下去跑的策略，除了個股本身的觸發條件之外，一定會加上大盤的先決...

來源：[打造自己的大盤多空函數](https://www.xq.com.tw/xstrader/%e6%89%93%e9%80%a0%e8%87%aa%e5%b7%b1%e7%9a%84%e5%a4%a7%e7%9b%a4%e5%a4%9a%e7%a9%ba%e5%87%bd%e6%95%b8/) 說明：因此當我接觸到XS這個語法的時候，我在寫交易策略時，一定會把大盤的多空方向考慮進去。所以每一個我放下去跑的策略，除了個股本身的觸發條件之外，一定會加上大盤的先決條件，例如我寫過一個整理結速的腳本如下：

input: Periods(10,"計算期數");

input: Ratio(7,"近期波動幅度%上限");

settotalbar(300);

setbarback(50);

if GetSymbolField("tse.tw","收盤價")

\>average(GetSymbolField("tse.tw","收盤價"),10)

and average(GetSymbolField("tse.tw","收盤價"),5)

\>average(GetSymbolField("tse.tw","收盤價"),20)

then begin

condition1 \= false;

if (highest(high\[1\],Periods-1) \- lowest(low\[1\],Periods-1))/close\[1\]

\<= ratio\*0.01

then condition1=true//近期波動在7%以內

else return;

if condition1

and high \= highest(high, Periods)

//最高價創波段新高

and lowest(low,periods+20)\*1.1\<lowest(low,periods)

then ret=1;

end;

---

## 場景 749：打造自己的大盤多空函數 — 這個腳本裡，我特別加了下面這一段

來源：[打造自己的大盤多空函數](https://www.xq.com.tw/xstrader/%e6%89%93%e9%80%a0%e8%87%aa%e5%b7%b1%e7%9a%84%e5%a4%a7%e7%9b%a4%e5%a4%9a%e7%a9%ba%e5%87%bd%e6%95%b8/) 說明：這個腳本裡，我特別加了下面這一段

if GetSymbolField("tse.tw","收盤價")

\>average(GetSymbolField("tse.tw","收盤價"),10)

and average(GetSymbolField("tse.tw","收盤價"),5)

\>average(GetSymbolField("tse.tw","收盤價"),20)

then begin

---

## 場景 750：打造自己的大盤多空函數 — 舉 tselsindex為例，我當切觀察到，這 幾年外資如果連續買超時大盤多頭的機率較高，所以我就寫了以下的自訂函數

來源：[打造自己的大盤多空函數](https://www.xq.com.tw/xstrader/%e6%89%93%e9%80%a0%e8%87%aa%e5%b7%b1%e7%9a%84%e5%a4%a7%e7%9b%a4%e5%a4%9a%e7%a9%ba%e5%87%bd%e6%95%b8/) 說明：舉 tselsindex為例，我當切觀察到，這 幾年外資如果連續買超時大盤多頭的機率較高，所以我就寫了以下的自訂函數

input:length1(numeric);

input:lowlimit(numeric);

 

if countif(GetSymbolField("tse.tw","外資買賣超金額","D")\>0,length1)

\>= lowlimit

then value1=1

else

value1=0;

tselsindex=value1;

---

## 場景 751：盤不錯的時候，冷門股量暴增到多少值得留意?

來源：[盤不錯的時候，冷門股量暴增到多少值得留意?](https://www.xq.com.tw/xstrader/%e7%9b%a4%e4%b8%8d%e9%8c%af%e7%9a%84%e6%99%82%e5%80%99%ef%bc%8c%e5%86%b7%e9%96%80%e8%82%a1%e9%87%8f%e6%9a%b4%e5%a2%9e%e5%88%b0%e5%a4%9a%e5%b0%91%e5%80%bc%e5%be%97%e7%95%99%e6%84%8f/) 說明：對應的腳本如下:

value1=GetField("成交金額");

if trueall(value1\[1\]\<=100000000,20)

and value1 cross over 300000000

and close \> close\[1\]

and tselsindex(10,7)=1

then ret=1;

---

## 場景 752：盤不錯的時候，冷門股量暴增到多少值得留意? — 這當中用了一個我自己寫的大盤多空函數叫作Tselsindex，它的對應腳本如下:

來源：[盤不錯的時候，冷門股量暴增到多少值得留意?](https://www.xq.com.tw/xstrader/%e7%9b%a4%e4%b8%8d%e9%8c%af%e7%9a%84%e6%99%82%e5%80%99%ef%bc%8c%e5%86%b7%e9%96%80%e8%82%a1%e9%87%8f%e6%9a%b4%e5%a2%9e%e5%88%b0%e5%a4%9a%e5%b0%91%e5%80%bc%e5%be%97%e7%95%99%e6%84%8f/) 說明：這當中用了一個我自己寫的大盤多空函數叫作Tselsindex，它的對應腳本如下:

input:length1(numeric);

input:lowlimit(numeric);

 

if countif(GetSymbolField("tse.tw","外資買賣超金額","D")\>0,length1)

\>= lowlimit

then value1=1

else

value1=0;

tselsindex=value1;

---

## 場景 753：choppy market index ，ADX及噪音指標等去盤整指標 — 我把這指標改良了一下，用在加權指數上

來源：[choppy market index ，ADX及噪音指標等去盤整指標](https://www.xq.com.tw/xstrader/%e5%a6%82%e4%bd%95%e5%88%a4%e6%96%b7%e7%8f%be%e5%9c%a8%e6%98%af%e8%b6%a8%e5%8b%a2%e9%82%84%e6%98%af%e7%9b%a4%e6%95%b4-%e4%b8%80%e5%80%8b%e9%82%84%e5%9c%a8%e7%a0%94%e7%a9%b6%e7%9a%84%e8%aa%b2/) 說明：我把這指標改良了一下，用在加權指數上

input:period(10,"計算區間");

value1=(close-close\[period-1\])/(highest(high,period)-lowest(low,period))\*100;

value2=absvalue(value1)-30;

value3=average(value2,3);

plot1(value3,"市場波動指標");

---

## 場景 754：choppy market index ，ADX及噪音指標等去盤整指標 — 這個指標先前我有介紹過，它是拿近N期的漲跌值當分母，拿近N期每天的高低差當分子，計算的腳本如下:

來源：[choppy market index ，ADX及噪音指標等去盤整指標](https://www.xq.com.tw/xstrader/%e5%a6%82%e4%bd%95%e5%88%a4%e6%96%b7%e7%8f%be%e5%9c%a8%e6%98%af%e8%b6%a8%e5%8b%a2%e9%82%84%e6%98%af%e7%9b%a4%e6%95%b4-%e4%b8%80%e5%80%8b%e9%82%84%e5%9c%a8%e7%a0%94%e7%a9%b6%e7%9a%84%e8%aa%b2/) 說明：這個指標先前我有介紹過，它是拿近N期的漲跌值當分母，拿近N期每天的高低差當分子，計算的腳本如下:

input:n1(10);

input:n2(10);

 

setinputname(1,"計算區間");

setinputname(2,"短天期移動平均");

value1=absvalue(close-close\[n1-1\]);

value2=summation(range,n1);

if value1=0

then return

else

value3=value2/value1;

value4=average(value3,n2);

 

plot1(value4,"短天期噪音指標");

---

## 場景 755：內外盤量比在預測大盤後市上的應用 — 所以我就把這5%考慮進去，把指標改寫成以下的腳本

來源：[內外盤量比在預測大盤後市上的應用](https://www.xq.com.tw/xstrader/%e5%85%a7%e5%a4%96%e7%9b%a4%e9%87%8f%e6%af%94%e5%9c%a8%e9%a0%90%e6%b8%ac%e5%a4%a7%e7%9b%a4%e5%be%8c%e5%b8%82%e4%b8%8a%e7%9a%84%e6%87%89%e7%94%a8/) 說明：所以我就把這5%考慮進去，把指標改寫成以下的腳本

value1=GetField("內盤量");//單位:元

value2=GetField("外盤量");//單位:元

value3=value2/volume\*100;//外盤量比

value4=value1/volume\*100;//內盤量比

value5=average(value3,5);

value6=average(value4,5);

value7=value5-value6+5;

plot1(value7,"內外盤量比差");

---

## 場景 756：OTC跟上市成交量比值是股市多空指標 — 於是，我寫了以下的腳本來畫圖

來源：[OTC跟上市成交量比值是股市多空指標](https://www.xq.com.tw/xstrader/otc%e8%b7%9f%e4%b8%8a%e5%b8%82%e6%88%90%e4%ba%a4%e9%87%8f%e6%af%94%e5%80%bc%e6%98%af%e8%82%a1%e5%b8%82%e5%a4%9a%e7%a9%ba%e6%8c%87%e6%a8%99/) 說明：於是，我寫了以下的腳本來畫圖

value1=GetSymbolField("tse.tw","成交量");

value2=GetSymbolField("otc.tw","成交量");

value3=value2/value1\*100;

value4=average(value3,5);

plot1(value4);

Plot2(value2);

---

## 場景 757：大跌後的急拉，後市有高點 — 因著這樣的觀察，我試著寫了一個腳本如下

來源：[大跌後的急拉，後市有高點](https://www.xq.com.tw/xstrader/%e5%a4%a7%e8%b7%8c%e5%be%8c%e7%9a%84%e6%80%a5%e6%8b%89%ef%bc%8c%e5%be%8c%e5%b8%82%e6%9c%89%e9%ab%98%e9%bb%9e/) 說明：因著這樣的觀察，我試著寫了一個腳本如下

//全部股票，停損停利俱為7%

value1=barslast(close\>=close\[1\]\*1.07);

if value1\[1\]\>50

//超過50天沒有單日上漲超過7%

and value1=0

//今天上漲超過7%

and average(volume,100)\>500

and volume\>1000

and close\[1\]\*1.25\<close\[30\]

//過去三十天跌幅超過25%

and GetSymbolField("TSE.TW","收盤價","D")

\> average(GetSymbolField("TSE.TW","收盤價","D"),10)

//目前大盤在多頭

then ret=1;

---

## 場景 758：股價領先大盤創長期新高的股票是不是值得作多? — 現在是大數據時代，一切講證據，所以我就寫了一個腳本，尋找那些加權指數沒有創200日高點，但股價卻創200日高點的股票，我寫的腳本如下:

來源：[股價領先大盤創長期新高的股票是不是值得作多?](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%83%b9%e9%a0%98%e5%85%88%e5%a4%a7%e7%9b%a4%e5%89%b5%e9%95%b7%e6%9c%9f%e6%96%b0%e9%ab%98%e7%9a%84%e8%82%a1%e7%a5%a8%e6%98%af%e4%b8%8d%e6%98%af%e5%80%bc%e5%be%97%e4%bd%9c%e5%a4%9a/) 說明：現在是大數據時代，一切講證據，所以我就寫了一個腳本，尋找那些加權指數沒有創200日高點，但股價卻創200日高點的股票，我寫的腳本如下:

input:period(200,"計算創新高區間");

value1=GetSymbolField("tse.tw","收盤價");

value2=highest(value1,period);//大盤區間高點

if value1\<value2//大盤未過新高

and close=highest(close,period)//股價創新高

and barslast(close=highest(close,period))\[1\]

\>100

and GetSymbolField("tse.tw","收盤價")\>

average(GetSymbolField("tse.tw","收盤價"),10)

and average(volume,100)\>1000

then ret=1;

---

## 場景 759：尋找止跌的訊號？ — 我把大跌後的吊人線寫成腳本如下:

來源：[尋找止跌的訊號？](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e6%ad%a2%e8%b7%8c%e7%9a%84%e8%a8%8a%e8%99%9f%ef%bc%9f/) 說明：我把大跌後的吊人線寫成腳本如下:

condition1=false;

condition2=false;

condition3=false;

if high\<= maxlist(open, close)\*1.01 

//狀況1:小紅小黑且上影線很小

then condition1=true;

if (close-low)\> (open-close)\*2 and (close-low)\>close\*0.02

//狀況2:下影線為實體兩倍以上

then condition2=true;

if highest(high,30)\>close\[1\]\*1.4

//狀況3:近30日來最高點到昨天跌幅超過40%

then condition3=true;

{結果判斷} 

IF 

 condition1

 and condition2

 and condition3

 and GetSymbolField("tse.tw","收盤價","D")

\>average(GetSymbolField("tse.tw","收盤價","D"),10)

and average(volume,100)\>1000

THEN RET=1;

---

## 場景 760：當成長股波段趨勢成形 — 我試著follow這樣的精神，寫了一個腳本如下:

來源：[當成長股波段趨勢成形](https://www.xq.com.tw/xstrader/%e7%95%b6%e6%88%90%e9%95%b7%e8%82%a1%e6%b3%a2%e6%ae%b5%e8%b6%a8%e5%8b%a2%e6%88%90%e5%bd%a2/) 說明：我試著follow這樣的精神，寫了一個腳本如下:

if GetSymbolField("TSE.TW","收盤價","d")

\>average(GetSymbolField("TSE.TW","收盤價","d"),20)

then begin

value1=rateofchange(close,6);

value2=rateofchange(close,9);

value3=value1+value2;

value4=xaverage(value3,10);

if value4 crosses over \-5

then ret=1;

end;

---

## 場景 761：等待殺過頭的中小型成長股上昇趨勢成形 — 這裡我介紹一個趨勢成形的腳本，用的是大家很常見到的DMI指標裡的ADX指標，我寫的腳本如下

來源：[等待殺過頭的中小型成長股上昇趨勢成形](https://www.xq.com.tw/xstrader/%e7%ad%89%e5%be%85%e6%ae%ba%e9%81%8e%e9%a0%ad%e7%9a%84%e4%b8%ad%e5%b0%8f%e5%9e%8b%e6%88%90%e9%95%b7%e8%82%a1%e4%b8%8a%e6%98%87%e8%b6%a8%e5%8b%a2%e6%88%90%e5%bd%a2/) 說明：這裡我介紹一個趨勢成形的腳本，用的是大家很常見到的DMI指標裡的ADX指標，我寫的腳本如下

// ADX趨勢成形

// 用有量的中小型股，5%停利，5%停損

if GetSymbolField("tse.tw","收盤價")

\> average(GetSymbolField("tse.tw","收盤價"),10) 

//大盤OK

then begin

input: Length(14,"期數"), Threshold(25,"穿越值");

variable: pdi\_value(0), ndi\_value(0), adx\_value(0);

 

DirectionMovement(Length, pdi\_value, ndi\_value, adx\_value);

if adx\_value Crosses Above Threshold

//adx趨勢成形

and pdi\_value\>ndi\_value

//+DI\>-DI

then ret=1;

end;

---

## 場景 762：等待殺過頭的中小型成長股上昇趨勢成形 — 若是我再加上以下這一行

來源：[等待殺過頭的中小型成長股上昇趨勢成形](https://www.xq.com.tw/xstrader/%e7%ad%89%e5%be%85%e6%ae%ba%e9%81%8e%e9%a0%ad%e7%9a%84%e4%b8%ad%e5%b0%8f%e5%9e%8b%e6%88%90%e9%95%b7%e8%82%a1%e4%b8%8a%e6%98%87%e8%b6%a8%e5%8b%a2%e6%88%90%e5%bd%a2/) 說明：若是我再加上以下這一行

and close \<close\[30\]

---

## 場景 763：雲端策略中心精進版之41\~投信初介入 — 我把上面的條件寫成以下的腳本

來源：[雲端策略中心精進版之41\~投信初介入](https://www.xq.com.tw/xstrader/%e9%9b%b2%e7%ab%af%e7%ad%96%e7%95%a5%e4%b8%ad%e5%bf%83%e7%b2%be%e9%80%b2%e7%89%88%e4%b9%8b41%e6%8a%95%e4%bf%a1%e5%88%9d%e4%bb%8b%e5%85%a5/) 說明：我把上面的條件寫成以下的腳本

if GetSymbolField("TSE.TW","收盤價")

\>average(GetSymbolField("TSE.TW","收盤價"),10)

then begin

input: day(30, "投信交易期間");

value1 \= summation(GetField("投信買賣超")\[1\], day); 

value2 \= summation(volume\[2\], day);

condition1 \= value1 \< value2 \* 0.02;

//先前投信不怎麼買這檔股票

condition2 \= GetField("投信買賣超")\> volume\[1\] \* 0.15;

//投信開始較大買超

condition3 \= H \> H\[1\];

//買了股價有往上攻

condition4 \= C \> C\[1\];

//今天收盤有往上走

RET \= condition1 and condition2 and condition3 and condition4;

end;

---

## 場景 764：雲端策略中心精進版之40\~大單敲進線又棒的中小型股

來源：[雲端策略中心精進版之40\~大單敲進線又棒的中小型股](https://www.xq.com.tw/xstrader/%e9%9b%b2%e7%ab%af%e7%ad%96%e7%95%a5%e4%b8%ad%e5%bf%83%e7%b2%be%e9%80%b2%e7%89%88%e4%b9%8b40%e5%a4%a7%e5%96%ae%e6%95%b2%e9%80%b2%e7%b7%9a%e5%8f%88%e6%a3%92%e7%9a%84%e4%b8%ad%e5%b0%8f%e5%9e%8b/) 說明：我寫的腳本如下

condition1=false;

condition2=false;

if getsymbolfield("tse.tw","收盤價") \> average(getsymbolfield("tse.tw","收盤價"),10)

then begin

 if linearregslope(momentum(close,10),10)\>0

 and momentum(close,10)\>0

 then condition1=true;

 //動能夠強

 value2=GetField("總成交次數","D");

 

 if value2\<\>0

 then value3=volume/value2;//單筆成交張數

 

 if average(value3,5)crosses over average(value3,20)

//單子比以往大

 and close\>=close\[1\]\*1.03

//單子漲幅超過3%

 then condition2=true;

 

 if condition1 and condition2

 then ret=1;

 

end;

---

## 場景 765：雲端策略中心精進版之39\~中小型股整理結束 — 對應寫出來的腳本如下 :

來源：[雲端策略中心精進版之39\~中小型股整理結束](https://www.xq.com.tw/xstrader/%e9%9b%b2%e7%ab%af%e7%ad%96%e7%95%a5%e4%b8%ad%e5%bf%83%e7%b2%be%e9%80%b2%e7%89%88%e4%b9%8b39%e4%b8%ad%e5%b0%8f%e5%9e%8b%e8%82%a1%e6%95%b4%e7%90%86%e7%b5%90%e6%9d%9f/) 說明：對應寫出來的腳本如下 :

input: Periods(10,"計算期數");

input: Ratio(7,"近期波動幅度%上限");

settotalbar(300);

setbarback(50);

if GetSymbolField("tse.tw","收盤價")

\>average(GetSymbolField("tse.tw","收盤價"),10)

and average(GetSymbolField("tse.tw","收盤價"),5)

\>average(GetSymbolField("tse.tw","收盤價"),20)

then begin

condition1 \= false;

if (highest(high\[1\],Periods-1) \- lowest(low\[1\],Periods-1))/close\[1\]

 \<= ratio\*0.01 

then condition1=true//近期波動在7%以內

else return;

if condition1 

and high \= highest(high, Periods)

//最高價創波段新高

and lowest(low,periods+20)\*1.1\<lowest(low,periods)

then ret=1;

end;

---

## 場景 766：雲端策略中心精進版之37\~開高後不拉回的中小型股

來源：[雲端策略中心精進版之37\~開高後不拉回的中小型股](https://www.xq.com.tw/xstrader/%e9%9b%b2%e7%ab%af%e7%ad%96%e7%95%a5%e4%b8%ad%e5%bf%83%e7%b2%be%e9%80%b2%e7%89%88%e4%b9%8b37%e9%96%8b%e9%ab%98%e5%be%8c%e4%b8%8d%e6%8b%89%e5%9b%9e%e7%9a%84%e4%b8%ad%e5%b0%8f%e5%9e%8b%e8%82%a1/) 說明：我寫的腳本如下

if GetSymbolField("tse.tw","收盤價","D")

\>average(GetSymbolField("tse.tw","收盤價","D"),10)

//大盤多頭

then begin

input:sp(2,"回檔最大幅度");

input:opl(1.5,"開高最小幅度");

input:oph(4,"開高最大幅度");

if open\>=close\[1\]\*(1+opl/100)

//開高超過一定百分比

 and close\<=close\[1\]\*(1+oph/100)

 //開高的幅度低於一定百分比

 and low\>open\*(1-sp/100)

 //回檔幅度不超過一定百分比

 and close=high

 //收最高

and close\[1\]\<close\[3\]\*1.1

//前三天漲幅不到10%

and volume\>average(volume,20)\*1.2

//成交量增加一定百分比\]

then ret=1 ;

end;

---

## 場景 767：雲端策略中心精進版之38\~火箭後拉回的中小型股

來源：[雲端策略中心精進版之38\~火箭後拉回的中小型股](https://www.xq.com.tw/xstrader/%e9%9b%b2%e7%ab%af%e7%ad%96%e7%95%a5%e4%b8%ad%e5%bf%83%e7%b2%be%e9%80%b2%e7%89%88%e4%b9%8b38%e7%81%ab%e7%ae%ad%e5%be%8c%e6%8b%89%e5%9b%9e%e7%9a%84%e4%b8%ad%e5%b0%8f%e5%9e%8b%e8%82%a1/) 說明：我寫的腳本如下

if GetSymbolField("tse.tw","收盤價","D")

 \> average(GetSymbolField("tse.tw","收盤價","D"),10)

then begin 

 if barfreq \="Min" and barinterval \=1 

 and close\[1\]/close\[2\]\>1.02

 and highest(high,250)\<=lowest(low,250)\*1.07

 then 

 ret=1;

end;

---

## 場景 768：雲端策略中心精進版之36\~即將鎖第一根漲停的中小型股 — 為了找出即將漲停的股票，我寫的腳本如下

來源：[雲端策略中心精進版之36\~即將鎖第一根漲停的中小型股](https://www.xq.com.tw/xstrader/%e9%9b%b2%e7%ab%af%e7%ad%96%e7%95%a5%e4%b8%ad%e5%bf%83%e7%b2%be%e9%80%b2%e7%89%88%e4%b9%8b36%e5%8d%b3%e5%b0%87%e9%8e%96%e7%ac%ac%e4%b8%80%e6%a0%b9%e6%bc%b2%e5%81%9c%e7%9a%84%e4%b8%ad%e5%b0%8f/) 說明：為了找出即將漲停的股票，我寫的腳本如下

if GetSymbolField("tse.tw","收盤價")

\>average(GetSymbolField("tse.tw","收盤價"),10)

then begin

input:Length(20, "過去無漲停期數");

input:Ratio(1, "差幾%漲停");

Condition1 \= Close \>= GetField("uplimit") \* (1 \- Ratio/100);

Condition2 \= TrueAll(Close \< GetField("uplimit"), Length);

Condition3 \= Average(Volume, 5\) \>= 1000;

Condition4 \= Close \> Highest(High\[1\], Length);

Condition5 \= Volume \>= Highest(Volume\[1\], Length);

ret \= Condition1 And Condition2 And Condition3 And Condition4 And Condition5; 

end;

---

## 場景 769：雲端策略中心精進版之35\~近期持續強勢股階段式上漲

來源：[雲端策略中心精進版之35\~近期持續強勢股階段式上漲](https://www.xq.com.tw/xstrader/%e9%9b%b2%e7%ab%af%e7%ad%96%e7%95%a5%e4%b8%ad%e5%bf%83%e7%b2%be%e9%80%b2%e7%89%88%e4%b9%8b35%e8%bf%91%e6%9c%9f%e6%8c%81%e7%ba%8c%e5%bc%b7%e5%8b%a2%e8%82%a1%e9%9a%8e%e6%ae%b5%e5%bc%8f%e4%b8%8a/) 說明：我寫的腳本如下

if GetSymbolField("tse.tw","收盤價","D")

\>average(GetSymbolField("tse.tw","收盤價","D"),10)

//多頭市場

and GetSymbolField("tse.tw","收盤價","D")

/ GetSymbolField("tse.tw","收盤價","D")\[2\]+0.01

\<GetField("收盤價","D")/GetField("收盤價","D")\[2\]

//前兩日比大盤明顯走強

and GetField("收盤價","D")\[1\]

\<GetField("收盤價","D")\[10\]\*1.07

//近十日沒有漲的太兇

then begin

if barfreq\<\> "Min"and barinterval\<\> 5

then raiseruntimeerror("本腳本只限五分鐘線");

if time=091500

and trueall(close\>close\[1\],3)

//開盤三根五分鐘線都是紅棒

and average(volume,3)\>average(volume,20)\*1.3

//開盤的量能明顯增加

then ret=1;

end;

---

## 場景 770：雲端策略中心精進版之35\~近期持續強勢股階段式上漲 — 最後，我在檢視回測中出現虧損的個股股價走勢，我發現那種前一天下跌的股票，今天出現紅三K的時候，尾盤收高的機會較大，所以我在腳本中加上一個條件

來源：[雲端策略中心精進版之35\~近期持續強勢股階段式上漲](https://www.xq.com.tw/xstrader/%e9%9b%b2%e7%ab%af%e7%ad%96%e7%95%a5%e4%b8%ad%e5%bf%83%e7%b2%be%e9%80%b2%e7%89%88%e4%b9%8b35%e8%bf%91%e6%9c%9f%e6%8c%81%e7%ba%8c%e5%bc%b7%e5%8b%a2%e8%82%a1%e9%9a%8e%e6%ae%b5%e5%bc%8f%e4%b8%8a/) 說明：最後，我在檢視回測中出現虧損的個股股價走勢，我發現那種前一天下跌的股票，今天出現紅三K的時候，尾盤收高的機會較大，所以我在腳本中加上一個條件

and GetField("收盤價","D")\[1\]\<GetField("收盤價","D")\[2\]

---

## 場景 771：雲端策略中心精進版之34\~多頭轉強策略 — 我先把上面說的邏輯寫成一個指標腳本

來源：[雲端策略中心精進版之34\~多頭轉強策略](https://www.xq.com.tw/xstrader/%e9%9b%b2%e7%ab%af%e7%ad%96%e7%95%a5%e4%b8%ad%e5%bf%83%e7%b2%be%e9%80%b2%e7%89%88%e4%b9%8b34%e5%a4%9a%e9%a0%ad%e8%bd%89%e5%bc%b7%e7%ad%96%e7%95%a5/) 說明：我先把上面說的邏輯寫成一個指標腳本

input:length(10); 

variable: sumUp(0), sumDown(0), up(0), down(0),RS(0);

if CurrentBar \= 1 then

begin

sumUp \= Average(maxlist(close \- close\[1\], 0), length); 

sumDown \= Average(maxlist(close\[1\] \- close, 0), length); 

end

else

begin

up \= maxlist(close \- close\[1\], 0);

down \= maxlist(close\[1\] \- close, 0);

 

sumUp \= sumUp\[1\] \+ (up \- sumUp\[1\]) / length;

sumDown \= sumDown\[1\] \+ (down \- sumDown\[1\]) / length;

end;

if sumdown\<\>0

then rs=sumup/sumdown;

plot1(rs);

---

## 場景 772：雲端策略中心精進版之34\~多頭轉強策略 — 我把這個指標改寫成策略腳本

來源：[雲端策略中心精進版之34\~多頭轉強策略](https://www.xq.com.tw/xstrader/%e9%9b%b2%e7%ab%af%e7%ad%96%e7%95%a5%e4%b8%ad%e5%bf%83%e7%b2%be%e9%80%b2%e7%89%88%e4%b9%8b34%e5%a4%9a%e9%a0%ad%e8%bd%89%e5%bc%b7%e7%ad%96%e7%95%a5/) 說明：我把這個指標改寫成策略腳本

if getsymbolfield("tse.tw","收盤價")

\>average(getsymbolfield("tse.tw","收盤價"),10)

then begin

input:length(10);

variable: sumUp(0), sumDown(0), up(0), down(0),RS(0);

if CurrentBar \= 1 then

begin

sumUp \= Average(maxlist(close \- close\[1\], 0), length);

sumDown \= Average(maxlist(close\[1\] \- close, 0), length);

end

else

begin

up \= maxlist(close \- close\[1\], 0);

down \= maxlist(close\[1\] \- close, 0);

sumUp \= sumUp\[1\] \+ (up \- sumUp\[1\]) / length;

sumDown \= sumDown\[1\] \+ (down \- sumDown\[1\]) / length;

end;

if sumdown\<\>0

then rs=sumup/sumdown;

if rs cross over 4

and close\>close\[1\]\*1.02

//最近一日漲幅超過2%

and close\<close\[5\]\*1.05

//最近五日漲幅小於5%

then ret=1;

end;

---

## 場景 773：雲端策略中心精進版之33\~低預估本益比攻勢發動 — 根據這兩個條件，我的對應腳本如下

來源：[雲端策略中心精進版之33\~低預估本益比攻勢發動](https://www.xq.com.tw/xstrader/%e9%9b%b2%e7%ab%af%e7%ad%96%e7%95%a5%e4%b8%ad%e5%bf%83%e7%b2%be%e9%80%b2%e7%89%88%e4%b9%8b33%e4%bd%8e%e9%a0%90%e4%bc%b0%e6%9c%ac%e7%9b%8a%e6%af%94%e6%94%bb%e5%8b%a2%e7%99%bc%e5%8b%95/) 說明：根據這兩個條件，我的對應腳本如下

settotalbar(700);

if getsymbolfield("tse.tw","收盤價")

\> average(getsymbolfield("tse.tw","收盤價"),10)

then begin

value4=GetField("總市值");

value5=average(value4,600);

if value4\[1\]\<value5\[1\]\*0.7

and close=highest(close,10)

then ret=1;

end;

---

## 場景 774：雲端策略中心精進版之32\~低PB股的逆襲 — 我根據上述的特徵寫的腳本如下:

來源：[雲端策略中心精進版之32\~低PB股的逆襲](https://www.xq.com.tw/xstrader/%e9%9b%b2%e7%ab%af%e7%ad%96%e7%95%a5%e4%b8%ad%e5%bf%83%e7%b2%be%e9%80%b2%e7%89%88%e4%b9%8b32%e4%bd%8epb%e8%82%a1%e7%9a%84%e9%80%86%e8%a5%b2/) 說明：我根據上述的特徵寫的腳本如下:

if GetSymbolField("tse.tw","收盤價")

 \> average(GetSymbolField("tse.tw","收盤價"),10)

then begin

 

 if close\<15

 and H \= highest(H,20)

 and close\<lowest(low,20)\*1.07

 and highest(h,40)\>close\*1.1

 then 

 ret=1;

 

end;

---

## 場景 775：雲端策略中心精進版之30\~跌破糾結均線 — 跌破糾結均線的腳本，跟突破糾結均線的腳本差不多

來源：[雲端策略中心精進版之30\~跌破糾結均線](https://www.xq.com.tw/xstrader/%e9%9b%b2%e7%ab%af%e7%ad%96%e7%95%a5%e4%b8%ad%e5%bf%83%e7%b2%be%e9%80%b2%e7%89%88%e4%b9%8b30%e8%b7%8c%e7%a0%b4%e7%b3%be%e7%b5%90%e5%9d%87%e7%b7%9a/) 說明：跌破糾結均線的腳本，跟突破糾結均線的腳本差不多

if GetSymbolField("tse.tw","收盤價")

\<average(GetSymbolField("tse.tw","收盤價"),10)

then begin

input: shortlength(5); setinputname(1,"短期均線期數");

input: midlength(10); setinputname(2,"中期均線期數");

input: Longlength(20); setinputname(3,"長期均線期數");

input: Percent(5); setinputname(4,"均線糾結區間%");

input: XLen(20); setinputname(5,"均線糾結期數");

input: Volpercent(25); setinputname(6,"放量幅度%");//帶量突破的量是超過最長期的均量多少%

variable: shortaverage(0);

variable: midaverage(0);

variable: Longaverage(0);

variable: AvgHLp(0),AvgH(0),AvgL(0);

shortaverage \= average(close,shortlength);

midaverage \= average(close,midlength);

Longaverage \= average(close,Longlength);

 

 

AvgH \= maxlist(shortaverage,midaverage,Longaverage);

AvgL \= minlist(shortaverage,midaverage,Longaverage);

if AvgL \> 0 then AvgHLp \= 100\*AvgH/AvgL \-100;

condition1 \= trueAll(AvgHLp \< Percent,XLen);

condition2 \= V \> average(V\[1\],XLen)\*(1+Volpercent/100) ;

condition3 \= average(Volume\[1\], 5\) \>= 2000;

condition4 \= C \< AvgL \*(0.98) and L \< lowest(L\[1\],XLen);

ret \= condition1 and condition2 and condition3 and condition4;

end;

---

## 場景 776：雲端策略中心精進版之29\~突破糾結均線 — 對於糾結均線突破，我寫的腳本如下

來源：[雲端策略中心精進版之29\~突破糾結均線](https://www.xq.com.tw/xstrader/%e9%9b%b2%e7%ab%af%e7%ad%96%e7%95%a5%e4%b8%ad%e5%bf%83%e7%b2%be%e9%80%b2%e7%89%88%e4%b9%8b29%e7%aa%81%e7%a0%b4%e7%b3%be%e7%b5%90%e5%9d%87%e7%b7%9a/) 說明：對於糾結均線突破，我寫的腳本如下

if GetSymbolField("tse.tw","收盤價")

\>average(GetSymbolField("tse.tw","收盤價"),10)

then begin

input: shortlength(5); setinputname(1,"短期均線期數");

input: midlength(10); setinputname(2,"中期均線期數");

input: Longlength(20); setinputname(3,"長期均線期數");

input: Percent(5); setinputname(4,"均線糾結區間%");

input: XLen(10); setinputname(5,"均線糾結期數");

input: Volpercent(25); setinputname(6,"放量幅度%");//帶量突破的量是超過最長期的均量多少%

variable: shortaverage(0);

variable: midaverage(0);

variable: Longaverage(0);

variable: AvgHLp(0),AvgH(0),AvgL(0);

shortaverage \= average(close,shortlength);

midaverage \= average(close,midlength);

Longaverage \= average(close,Longlength);

 

AvgH \= maxlist(shortaverage,midaverage,Longaverage);

AvgL \= minlist(shortaverage,midaverage,Longaverage);

if AvgL \> 0 then AvgHLp \= 100\*AvgH/AvgL \-100;

condition1 \= trueAll(AvgHLp \< Percent,XLen);

condition2 \= V \> average(V\[1\],XLen)\*(1+Volpercent/100) ;

condition3 \= C \> AvgH \*(1.02) and H \> highest(H\[1\],XLen);

condition4 \= average(volume\[1\], 5\) \>= 1000; 

ret \= condition1 and condition2 and condition3 and condition4;

end;

---

## 場景 777：雲端策略中心精進版之28\~平台整理後跌破

來源：[雲端策略中心精進版之28\~平台整理後跌破](https://www.xq.com.tw/xstrader/%e9%9b%b2%e7%ab%af%e7%ad%96%e7%95%a5%e4%b8%ad%e5%bf%83%e7%b2%be%e9%80%b2%e7%89%88%e4%b9%8b28%e5%b9%b3%e5%8f%b0%e6%95%b4%e7%90%86%e5%be%8c%e8%b7%8c%e7%a0%b4/) 說明：我寫的腳本如下

if GetSymbolField("tse.tw","收盤價")

\<average(GetSymbolField("tse.tw","收盤價"),10)

then begin

input:Period(15, "平台區間");

input:ratio(7, "整理幅度(%)");

input:ratio1(2,"各高點(低點)間的差異幅度");

var:h1(0),h2(0),L1(0),L2(0);

h1=nthhighest(1,high\[1\],period);

h2=nthhighest(4,high\[1\],period);

l1=nthlowest(1,low\[1\],period);

l2=nthlowest(4,low\[1\],period);

if (h1-l1)/l1\<=ratio/100

and (h1-h2)/h2\<=ratio1/100

and (l2-l1)/l1\<=ratio1/100

and close cross below l1

and close\[period+30\]\>l1\*1.1

then ret=1;

end;

---

## 場景 778：雲端策略中心精進版之27\~平台整理後突破

來源：[雲端策略中心精進版之27\~平台整理後突破](https://www.xq.com.tw/xstrader/%e9%9b%b2%e7%ab%af%e7%ad%96%e7%95%a5%e4%b8%ad%e5%bf%83%e7%b2%be%e9%80%b2%e7%89%88%e4%b9%8b27%e5%b9%b3%e5%8f%b0%e6%95%b4%e7%90%86%e5%be%8c%e7%aa%81%e7%a0%b4/) 說明：對應的腳本如下

if GetSymbolField("tse.tw","收盤價")

\>average(GetSymbolField("tse.tw","收盤價"),10)

then begin

 

input:Period(15, "平台區間");

input:ratio(7, "整理幅度(%)");

input:ratio1(2,"各高點(低點)間的差異幅度");

var:h1(0),h2(0),L1(0),L2(0);

h1=nthhighest(1,high\[1\],period);

h2=nthhighest(4,high\[1\],period);

l1=nthlowest(1,low\[1\],period);

l2=nthlowest(4,low\[1\],period);

if (h1-l1)/l1\<=ratio/100

and (h1-h2)/h2\<=ratio1/100

and (l2-l1)/l1\<=ratio1/100

and close cross over h1

and close\[period+30\]\*1.1\<h1

and volume\> average(volume,period)

then ret=1;

end;

---

## 場景 779：雲端策略中心精進版之26\~多次到底跌破 — 這個短空策 略的腳本寫法跟多次到頂而破很像

來源：[雲端策略中心精進版之26\~多次到底跌破](https://www.xq.com.tw/xstrader/%e9%9b%b2%e7%ab%af%e7%ad%96%e7%95%a5%e4%b8%ad%e5%bf%83%e7%b2%be%e9%80%b2%e7%89%88%e4%b9%8b26%e5%a4%9a%e6%ac%a1%e5%88%b0%e5%ba%95%e8%b7%8c%e7%a0%b4/) 說明：這個短空策 略的腳本寫法跟多次到頂而破很像

input:HitTimes(4); setinputname(1,"設定觸底次數");

input:RangeRatio(1); setinputname(2,"設定底部區範圍寬度%");

input:Length(20); setinputname(3,"計算期數");

 if GetSymbolField("tse.tw","收盤價")

\<average(GetSymbolField("tse.tw","收盤價"),10)

then begin

variable: theLow(0); 

//找到過去期間的最低點

theLow \= lowest(low\[1\],Length); 

variable: LowUpperBound(0); 

// 設為瓶頸區間上界

LowUpperBound \= theLow \*(100+RangeRatio)/100; 

variable: TouchRangeTimes(0);

//期間中進入瓶頸區間的低點次數,每根K棒要歸0

TouchRangeTimes \= CountIF(Low\[1\] \< LowUpperBound, Length);

 

Condition1 \= TouchRangeTimes \>= HitTimes;

Condition2 \= close \< theLow;

Condition3 \= Average(Volume, 5\) \>= 1000;

Ret \= Condition1 And Condition2 And Condition3;

end;

---

## 場景 780：雲端策略中心精進版之25\~多次到頂而破 — 以下的腳本，就是在描述上圖的情況

來源：[雲端策略中心精進版之25\~多次到頂而破](https://www.xq.com.tw/xstrader/%e9%9b%b2%e7%ab%af%e7%ad%96%e7%95%a5%e4%b8%ad%e5%bf%83%e7%b2%be%e9%80%b2%e7%89%88%e4%b9%8b25%e5%a4%9a%e6%ac%a1%e5%88%b0%e9%a0%82%e8%80%8c%e7%a0%b4/) 說明：以下的腳本，就是在描述上圖的情況

input:HitTimes(4,"設定觸頂次數");

input:RangeRatio(1,"設定頭部區範圍寬度%");

input:Length(40,"計算期數");

if GetSymbolField("tse.tw","收盤價")

\>average(GetSymbolField("tse.tw","收盤價"),10)

then begin

variable: theHigh(0); 

//找到過去其間的最高點

theHigh \= Highest(High\[1\],Length); 

value1=highestbar(high\[1\],length);

variable: HighLowerBound(0); 

// 設為瓶頸區間上界

HighLowerBound \= theHigh \*(100-RangeRatio)/100; 

variable: TouchRangeTimes(0); 

//回算在此區間中 進去瓶頸區的次數 

TouchRangeTimes \= CountIF(High\[1\] \> HighLowerBound, Length-value1);

 

Condition1 \= TouchRangeTimes \>= HitTimes;

Condition2 \= close \> theHigh;

condition3=close\[length\]\*1.1\<thehigh;

Ret \= Condition1 and Condition2 and condition3 ;

end;

---

## 場景 781：雲端策略中心精進版之24\~突破繼續型態 — 這種一底高過一底的繼續型態，如果高點連線的角度不大，就很值得期待，對應的腳本如下

來源：[雲端策略中心精進版之24\~突破繼續型態](https://www.xq.com.tw/xstrader/%e9%9b%b2%e7%ab%af%e7%ad%96%e7%95%a5%e4%b8%ad%e5%bf%83%e7%b2%be%e9%80%b2%e7%89%88%e4%b9%8b24%e7%aa%81%e7%a0%b4%e7%b9%bc%e7%ba%8c%e5%9e%8b%e6%85%8b/) 說明：這種一底高過一底的繼續型態，如果高點連線的角度不大，就很值得期待，對應的腳本如下

//有量的中小型股，停損停利俱為7%

if GetSymbolField("tse.tw","收盤價","D")

\>average(GetSymbolField("tse.tw","收盤價","D"),10)

then begin

//大盤多頭格局

variable:Kprice(0),BP(C);

input: Length(5);

variable: HLine(0); 

HLine \= linearregangle(H\[1\]/BP,5);

//昨日高價與今日收盤價比值之五日線性回歸

variable: LLine(0); 

LLine \= linearregangle(L\[1\]/BP,5);

//昨日低價與今日收盤價比值之五日線性回歸

if absvalue(Hline) \< 0.1 

//上切線角度小

and LLine \> 0.2

//下切線是往上昇

 then Kprice \= highest(h,Length);

 //關鍵價=區間最高價

if c crosses above Kprice

// 收盤價突破關鍵價

 then ret=1;

 end;

---

## 場景 782：雲端策略中心精進版之23\~週轉率高點買進 — 以下是我的廟會交易法腳本

來源：[雲端策略中心精進版之23\~週轉率高點買進](https://www.xq.com.tw/xstrader/%e9%9b%b2%e7%ab%af%e7%ad%96%e7%95%a5%e4%b8%ad%e5%bf%83%e7%b2%be%e9%80%b2%e7%89%88%e4%b9%8b23%e9%80%b1%e8%bd%89%e7%8e%87%e9%ab%98%e9%bb%9e%e8%b2%b7%e9%80%b2/) 說明：以下是我的廟會交易法腳本

// 回測三年

// 選股法：存股標的

// 同時進場次數 1，最大持有時間 10期， 交易費用：0.2%， 作多。

//

if getsymbolfield("tse.tw","收盤價")

\>average(getsymbolfield("tse.tw","收盤價"),10)

//大盤多頭

then begin

value1=GetField("成交金額");

value2=GetField("總成交次數","D");

if value2\>0

then value3=value1/value2;

//成交金額/總成交次數

if value3=highest(value3,200)

//創兩百天來最高點

and close\>close\[1\]\*1.025

//較前一日中長紅

and close\[2\]\<close\[12\]\*1.05

//先前漲幅不大

and volume\>2000

//成交量超過2000張

then ret=1;

end;

---

## 場景 783：雲端策略中心精進版之22\~平台三角形收斂突破 — 為了找到像圖中所顯示的這種型態，我寫的腳本如下:

來源：[雲端策略中心精進版之22\~平台三角形收斂突破](https://www.xq.com.tw/xstrader/%e9%9b%b2%e7%ab%af%e7%ad%96%e7%95%a5%e4%b8%ad%e5%bf%83%e7%b2%be%e9%80%b2%e7%89%88%e4%b9%8b22%e5%b9%b3%e5%8f%b0%e4%b8%89%e8%a7%92%e5%bd%a2%e6%94%b6%e6%96%82%e7%aa%81%e7%a0%b4/) 說明：為了找到像圖中所顯示的這種型態，我寫的腳本如下:

input:i(40);

if GetSymbolField("tse.tw","收盤價")

 \> average(GetSymbolField("tse.tw","收盤價"),10)

then begin

//大盤屬於多頭格局

value1=lowestbar(low\[1\],i);//區間最低價那根bar

value2=lowest(low\[1\],i);//區間最低價

value3=highestbar(high\[1\],i);//區間最高價那個bar

value4=highest(high\[1\],i);//區間最高價

value6=nthhighest(1,high\[1\],value3-1);

//從最高價之後的第一高價

value7=nthhighest(2,high\[1\],value3-1);

//從最高價之後的第二高價

value8=nthhighest(3,high\[1\],value3-1);

//從最高價之後的第三高價

value12=nthhighestbar(1,high\[1\],value3-1);

value13=nthhighestbar(2,high\[1\],value3-1);

value14=nthhighestbar(3,high\[1\],value3-1);

if value1-value3 \>= 10//區間上漲超過10天

and value4 \>= value2\*1.2//漲幅超過兩成

and maxlist(value6,value7,value8) \<= minlist(value6,value7,value8) \* 1.02

//整理時三個高點相差不會超過2%

and close crosses over maxlist(value6,value7,value8)

and absvalue(value12-value13) \> 1

and absvalue(value13-value14) \> 1

and volume\>=average(volume,10) \* 1.2

 then

 ret=1;

 

end;

---

## 場景 784：雲端策略中心精進版之21\~烏龜交易法則之買進訊號 — 波段作多的烏龜交易策略腳本，跟作空的腳本差不多

來源：[雲端策略中心精進版之21\~烏龜交易法則之買進訊號](https://www.xq.com.tw/xstrader/%e9%9b%b2%e7%ab%af%e7%ad%96%e7%95%a5%e4%b8%ad%e5%bf%83%e7%b2%be%e9%80%b2%e7%89%88%e4%b9%8b21%e7%83%8f%e9%be%9c%e4%ba%a4%e6%98%93%e6%b3%95%e5%89%87%e4%b9%8b%e8%b2%b7%e9%80%b2%e8%a8%8a%e8%99%9f/) 說明：波段作多的烏龜交易策略腳本，跟作空的腳本差不多

condition1=false;

condition2=false;

if getsymbolfield("tse.tw","收盤價")

\>average(getsymbolfield("tse.tw","收盤價"),10)

//大盤屬於多頭格局

then begin

if high=highest(high,100)and barslast(high=highest(high,100))\[1\]\>100

then condition1=true; 

//創百日新高且上一次發生時是在100個交易日之前

if average(volume\[1\], 5\) \>= 1000

then condition2=true;

//五日移動平均量大於千張

if condition1 and condition2

then ret=1;

end;

---

## 場景 785：雲端策略中心精進版之20\~烏龜交易法則之賣出訊號 — 我寫了以下的這個腳本來作為烏龜交易法則的應用腳本

來源：[雲端策略中心精進版之20\~烏龜交易法則之賣出訊號](https://www.xq.com.tw/xstrader/%e9%9b%b2%e7%ab%af%e7%ad%96%e7%95%a5%e4%b8%ad%e5%bf%83%e7%b2%be%e9%80%b2%e7%89%88%e4%b9%8b20%e7%83%8f%e9%be%9c%e4%ba%a4%e6%98%93%e6%b3%95%e5%89%87%e4%b9%8b%e8%b3%a3%e5%87%ba%e8%a8%8a%e8%99%9f/) 說明：我寫了以下的這個腳本來作為烏龜交易法則的應用腳本

condition1=false;

condition2=false;

if getsymbolfield("tse.tw","收盤價")

\<average(getsymbolfield("tse.tw","收盤價"),10)

//大盤屬於空頭格局

then begin

if L=lowest(L,100)and barslast(L=lowest(L,100))\[1\]\>100

then condition1=true; 

//創百日新低且上一次發生時是在100個交易日之前

if average(volume\[1\], 5\) \>= 1000

then condition2=true;

//五日移動平均量大於千張

if condition1 and condition2

then ret=1;

end;

---

## 場景 786：雲端策略中心精進版之19\~開盤反轉賣出訊號 — 為了找出這樣的股票，我寫了一個腳本如下:

來源：[雲端策略中心精進版之19\~開盤反轉賣出訊號](https://www.xq.com.tw/xstrader/%e9%9b%b2%e7%ab%af%e7%ad%96%e7%95%a5%e4%b8%ad%e5%bf%83%e7%b2%be%e9%80%b2%e7%89%88%e4%b9%8b19%e9%96%8b%e7%9b%a4%e5%8f%8d%e8%bd%89%e8%b3%a3%e5%87%ba%e8%a8%8a%e8%99%9f/) 說明：為了找出這樣的股票，我寫了一個腳本如下:

if getsymbolfield("tse.tw","收盤價")

\<average(getsymbolfield("tse.tw","收盤價"),10)

//大盤空頭

and GetField("收盤價","D")=lowest(GetField("收盤價","D"),20)

//日線創五日新低

and GetField("收盤價","D")\*1.05\>highest(GetField("收盤價","D"),20)

//收盤價距20日高點不到5%

then begin 

input: Ratio(1.5, "反轉%");

input: TimeLimit(93000, "時間限制");

variable: \_BarIndex(0), \_Open(0), \_Low(0), \_High(0), \_Volume(0);

if Date \<\> Date\[1\] then

 begin

 \_BarIndex \= 1;

 \_Open \= Open;

 \_Low \= Low;

 \_High \= High;

 \_Volume \= Volume;

 end

else

 begin

 \_Low \= minlist(\_Low, Low);

 \_High \= maxlist(\_High, High);

 \_Volume \= \_Volume \+ Volume;

 \_BarIndex \= \_BarIndex \+ 1;

 end;

Condition1 \= GetField("Open", "D") \> GetField("Close", "D")\[1\];

//開高

Condition2 \= Close \< \_High \* (1 \- Ratio/100);

//比當日高點低超過1.5%且跌破昨日收盤價

 

Condition3 \= Time \< TimeLimit;

//09:30之前

Ret \= Condition1 And Condition2 And Condition3 ;

end;

---

## 場景 787：雲端策略中心精進版之18\~暴量剛起漲 — 根據上述三條件所寫的腳本如下:

來源：[雲端策略中心精進版之18\~暴量剛起漲](https://www.xq.com.tw/xstrader/%e9%9b%b2%e7%ab%af%e7%ad%96%e7%95%a5%e4%b8%ad%e5%bf%83%e7%b2%be%e9%80%b2%e7%89%88%e4%b9%8b18%e6%9a%b4%e9%87%8f%e5%89%9b%e8%b5%b7%e6%bc%b2/) 說明：根據上述三條件所寫的腳本如下:

if getsymbolfield("tse.tw","收盤價")

\>average(getsymbolfield("tse.tw","收盤價"),10)

then begin

Input: day(100,"日期區間");

Input: ratioLimit(14, "區間最大漲幅%");

Condition1 \= H=highest(H,day);

//今日最高創區間最高價

Condition2 \= V=highest(v,day);

//今日成交量創區間最大量

Condition3 \= highest(H,day) \< lowest(L,day)\*(1 \+ ratioLimit\*0.01);

//今日最高價距離區間最低價漲幅尚不大

Ret \= Condition1 And Condition2 And Condition3;

end;

---

## 場景 788：雲端策略中心精進版之17\~開盤三連黑 — 以這張圖為思考的基準，以下是我寫的腳本

來源：[雲端策略中心精進版之17\~開盤三連黑](https://www.xq.com.tw/xstrader/%e9%9b%b2%e7%ab%af%e7%ad%96%e7%95%a5%e4%b8%ad%e5%bf%83%e7%b2%be%e9%80%b2%e7%89%88%e4%b9%8b17%e9%96%8b%e7%9b%a4%e4%b8%89%e9%80%a3%e9%bb%91/) 說明：以這張圖為思考的基準，以下是我寫的腳本

if getsymbolfield("tse.tw","收盤價")

\<average(getsymbolfield("tse.tw","收盤價"),10)

//大盤屬於空頭格局

and GetField("收盤價","D")=lowest(GetField("收盤價","D"),20)

//日線創二十日來的最低價

and GetField("收盤價","D")\*1.05\>highest(GetField("收盤價","D"),20)

//但收盤價距離20日來的最高點不超過5%

then begin

if Date \= Date\[2\] 

and Date\[2\] \> Date\[3\]

and Close \< Close\[1\]

and close\[1\] \< Close\[2\]

and Close\[2\] \< Open\[2\]

then ret=1;

end;

---

## 場景 789：雲端策略中心精進版之16\~天量後反轉 — 為了找出這樣的股票，我寫了一個腳本如下:

來源：[雲端策略中心精進版之16\~天量後反轉](https://www.xq.com.tw/xstrader/%e9%9b%b2%e7%ab%af%e7%ad%96%e7%95%a5%e4%b8%ad%e5%bf%83%e7%b2%be%e9%80%b2%e7%89%88%e4%b9%8b16%e5%a4%a9%e9%87%8f%e5%be%8c%e5%8f%8d%e8%bd%89/) 說明：為了找出這樣的股票，我寫了一個腳本如下:

Input: day(200, "計算天期");

Input: \_Dist(60, "距離"); 

variable:Maxv(0); 

MaxV \= Highest(Volume, day); 

//找出區間天量

variable:MaxH(0);

 MaxH \= Highest(High, day);

//找出區間最高價

variable:Kprice(0), Kdate(0);

if Maxv \= v and MaxH \= H then

//今量是區間高量且今日高點是區間高點 

begin

 KDate \= Date;

 Kprice \= L;

//找出區間天量天價的日期及當日最低價

end; 

if GetSymbolField("TSE.TW","收盤價")

\<average(GetSymbolField("TSE.TW","收盤價"),10)

//大盤屬於空頭格局

then begin

Condition1 \= C\[2\] crosses below KPrice

//前天收盤價跌破天量天價當天的最低價 

and C\[1\] \< KPrice 

//昨天還在天量天價當天最低價之下

and C \< KPrice

//今天也還在天量天價當天最低價之下

and Datediff(Date, KDate) \<= \_Dist;

//今天距離天量天價當天的日期差在一定範圍內

Condition2 \= Average(Volume\[1\], 5\) \>= 1000;

//昨日量五天移動平均大於1000張

Condition3 \= C \< C\[1\];

//今天收跌

condition4=lowest(low,day)\*1.4\<kprice;

//從低點上來漲幅超過四成

Ret \= Condition1 And Condition2 

And Condition3 and condition4;

end;

---

## 場景 790：雲端策略中心精進版之15\~多日價量背離跌破 — 為了找出這些價量背離的股票，我寫的腳本如下：

來源：[雲端策略中心精進版之15\~多日價量背離跌破](https://www.xq.com.tw/xstrader/%e9%9b%b2%e7%ab%af%e7%ad%96%e7%95%a5%e4%b8%ad%e5%bf%83%e7%b2%be%e9%80%b2%e7%89%88%e4%b9%8b15%e5%a4%9a%e6%97%a5%e5%83%b9%e9%87%8f%e8%83%8c%e9%9b%a2%e8%b7%8c%e7%a0%b4/) 說明：為了找出這些價量背離的股票，我寫的腳本如下：

input:Length(5, "計算期數");

input:times(3, "價量背離次數");

input:Dist(20, "距離");

variable:count(0),KPrice(0),hDate(0);

count \= CountIf(close \> close\[1\] and volume \< volume\[1\], Length);

if count \> times then begin

 hDate=Date;

 Kprice \= lowest(l,length);

end;

if GetSymbolField("TSE.TW","收盤價")

\<average(GetSymbolField("TSE.TW","收盤價"),10)

then begin

Condition1 \= Close crosses below Kprice;

Condition2 \= DateDiff(Date,hdate) \< Dist;

Ret \= Condition1 And Condition2;

end;

---

## 場景 791：雲端策略中心精進版之14\~投信強買發動 — 我把這兩個規則寫成了一個腳本

來源：[雲端策略中心精進版之14\~投信強買發動](https://www.xq.com.tw/xstrader/%e9%9b%b2%e7%ab%af%e7%ad%96%e7%95%a5%e4%b8%ad%e5%bf%83%e7%b2%be%e9%80%b2%e7%89%88%e4%b9%8b14%e6%8a%95%e4%bf%a1%e5%bc%b7%e8%b2%b7%e7%99%bc%e5%8b%95/) 說明：我把這兩個規則寫成了一個腳本

input: pastDays(3, "計算天數");

input: \_BuyRatio(15, "買超佔比例(%)");

input: \_Distance(60, "距離KPrice");

variable: SumForce(0), SumTotalVolume(0),Kprice(0), Kdate(0);

SumForce \= Summation(GetField("投信買賣超")\[1\], pastDays);

sumTotalVolume \= Summation(Volume\[1\], pastDays);

if SumForce \> SumTotalVolume \* \_BuyRatio/100 And Average(Volume\[1\], 5\) \>= 1000 then 

begin

 Kprice \=highest(avgprice\[1\],pastDays);

 Kdate \= date\[1\];

end; 

Condition1 \= C crosses above Kprice and datediff(date, kdate) \<= \_Distance; 

Condition2 \= Average(Volume\[1\], 5\) \>= 1000;

Condition3 \= Volume \> Average(Volume\[1\], 5\) \* 1.2;

Condition4 \= C \> C\[1\];

condition5=GetSymbolField("TSE.TW","收盤價","D")

\>average(GetSymbolField("TSE.TW","收盤價","D"),10);

Ret \= Condition1 And Condition2 

And Condition3 And Condition4

and condition5;

---

## 場景 792：雲端策略中心精進版之13\~炒高後無量反轉下跌 — 根據上述的特徵，我寫的對應腳本如下:

來源：[雲端策略中心精進版之13\~炒高後無量反轉下跌](https://www.xq.com.tw/xstrader/%e9%9b%b2%e7%ab%af%e7%ad%96%e7%95%a5%e4%b8%ad%e5%bf%83%e7%b2%be%e9%80%b2%e7%89%88%e4%b9%8b13%e7%82%92%e9%ab%98%e5%be%8c%e7%84%a1%e9%87%8f%e5%8f%8d%e8%bd%89%e4%b8%8b%e8%b7%8c/) 說明：根據上述的特徵，我寫的對應腳本如下:

input: Periods(120,"計算期數");

input: Ratio(50,"期間漲幅%");

 

if 

close \< close\[4\]

and close\*1.1\>highest(close,periods)

and close \>= close\[Periods\] \*(1 \+ Ratio\*0.01)

//過去半年漲幅超過五成

and average(volume\[1\],5)\*1.4 \< average(volume\[1\],20)

and GetSymbolField("tse.tw","收盤價","D")

\<average(GetSymbolField("tse.tw","收盤價","D"),10)

then ret=1;

---

## 場景 793：雲端策略中心精進版之12\~開盤五分鐘三創新高 — follow上述的條件，對應的腳本如下:

來源：[雲端策略中心精進版之12\~開盤五分鐘三創新高](https://www.xq.com.tw/xstrader/%e9%9b%b2%e7%ab%af%e7%ad%96%e7%95%a5%e4%b8%ad%e5%bf%83%e7%b2%be%e9%80%b2%e7%89%88%e4%b9%8b12%e9%96%8b%e7%9b%a4%e4%ba%94%e5%88%86%e9%90%98%e4%b8%89%e5%89%b5%e6%96%b0%e9%ab%98/) 說明：follow上述的條件，對應的腳本如下:

input: volumeRatio(0.1, "分鐘量暴量比例");

input: changeRatio(3, "最近3日最大上漲幅度");

input: averageVolume(1000, "5日均量");

variable:KBarOfDay(0), BreakHigh(false); 

KBarOfDay+=1;

if date\<\>date\[1\] then begin

 KBarOfDay=1; 

 BreakHigh \= false;

end; 

condition1 \= KBarOfDay \= 6;

//一分鐘線每天的第六根

condition2 \= Countif(High \> High\[1\] and Close \> Close\[1\] ,5) \>=3;

//近五根裡至少三根最高價比前一根高且收盤比前一根高

if KBarOfDay \= 1 

and close \> getfield("close", "d")\[1\] then BreakHigh \= true;

//開高

value1 \= average(GetField("Volume", "D")\[1\], 5);

//五日均量

condition3 \= value1 \> averageVolume;

//五日均量大於某張數 

value2 \= rateofchange(GetField("Close", "D")\[1\], 3);

condition4 \= AbsValue(value2) \< changeRatio;

//前三日漲帳幅小於一定標準

condition5 \= summation(volume, 5\) \> value1 \* volumeRatio;

//前五根一分鐘線成交量的合計大於五日均量某個比例

condition6=GetSymbolField("TSE.TW","收盤價","D")

\>average(GetSymbolField("TSE.TW","收盤價","D"),10);

//大盤屬於多頭結構

ret \= condition1 and condition2 and condition3 

and Condition4 and Condition5 and BreakHigh

and condition6;

---

## 場景 794：雲端策略中心精進版之11\~開盤反轉買進訊號 — 根據以上的描述，我寫了對應的腳本如下

來源：[雲端策略中心精進版之11\~開盤反轉買進訊號](https://www.xq.com.tw/xstrader/%e9%9b%b2%e7%ab%af%e7%ad%96%e7%95%a5%e4%b8%ad%e5%bf%83%e7%b2%be%e9%80%b2%e7%89%88%e4%b9%8b11%e9%96%8b%e7%9b%a4%e5%8f%8d%e8%bd%89%e8%b2%b7%e9%80%b2%e8%a8%8a%e8%99%9f/) 說明：根據以上的描述，我寫了對應的腳本如下

if getsymbolfield("tse.tw","收盤價")

\>average(getsymbolfield("tse.tw","收盤價"),10)

then begin

variable: \_BarIndex(0), \_Open(0), \_Low(0), \_High(0), \_Volume(0);

if Date \<\> Date\[1\] then

 begin

 \_BarIndex \= 1;

 \_Open \= Open;

 \_Low \= Low;

 \_High \= High;

 \_Volume \= Volume;

 end

else

 begin

 \_Low \= minlist(\_Low, Low);

 \_High \= maxlist(\_High, High);

 \_Volume \= \_Volume \+ Volume;

 \_BarIndex \= \_BarIndex \+ 1;

 end;

 

Condition1 \= GetField("Open", "D") \< GetField("Close", "D")\[1\];

//開低

Condition2 \= Close \> \_Low \* 1.02 and close\>GetField("收盤價","D")\[1\];

//收盤比當天低點收高2%且突破前一日高點

Condition3 \= Close\*1.2 \< GetField("Close", "D")\[20\]

//近二十日跌幅超過兩成

and close\*1.07\<getfield("close","D")\[10\];

//近十日跌幅超過7%

Condition4 \= Time \< 93000;

//時間在九點半之前

Condition5 \= Average(GetField("Volume", "D")\[1\], 5\) \>= 1000;

//五日均量大於1000張

Condition6 \= \_Volume \> GetField("Volume", "D")\[1\] \* 0.2;

//今日迄今的量大於過去五日均量的兩成

Ret \= Condition1 And Condition2 And Condition3 And Condition4 And Condition5 And Condition6;

end;

---

## 場景 795：雲端策略中心精進版之10\~天價上影線穿低賣出訊號 — 我寫了一個腳本來挑出符合上述特徵的股票

來源：[雲端策略中心精進版之10\~天價上影線穿低賣出訊號](https://www.xq.com.tw/xstrader/%e9%9b%b2%e7%ab%af%e7%ad%96%e7%95%a5%e4%b8%ad%e5%bf%83%e7%b2%be%e9%80%b2%e7%89%88%e4%b9%8b10%e5%a4%a9%e5%83%b9%e4%b8%8a%e5%bd%b1%e7%b7%9a%e7%a9%bf%e4%bd%8e%e8%b3%a3%e5%87%ba%e8%a8%8a%e8%99%9f/) 說明：我寫了一個腳本來挑出符合上述特徵的股票

if GetSymbolField("TSE.TW","收盤價")

\<average(GetSymbolField("TSE.TW","收盤價"),10)

then begin

setbackbar(255);

variable:Kprice(0);

if H \> O\*1.03 and C \<O and H \= SimpleHighest(H,255) then Kprice \= L;

//找出創一年期天價上影線當天的最低價

condition1 \= c crosses below Kprice;

//今天收盤價跌破天價當日的最低點

condition2 \= average(volume\[1\], 5\) \>= 500;

//前五日的均量有超過500張

ret \= condition1 and condition2;

end;

---

## 場景 796：雲端策略中心精進版之9\~多頭發動午餐奇襲 — 為了挑到這樣的股票，我寫了一個腳本如下:

來源：[雲端策略中心精進版之9\~多頭發動午餐奇襲](https://www.xq.com.tw/xstrader/%e9%9b%b2%e7%ab%af%e7%ad%96%e7%95%a5%e4%b8%ad%e5%bf%83%e7%b2%be%e9%80%b2%e7%89%88%e4%b9%8b9%e5%a4%9a%e9%a0%ad%e7%99%bc%e5%8b%95%e5%8d%88%e9%a4%90%e5%a5%87%e8%a5%b2/) 說明：為了挑到這樣的股票，我寫了一個腳本如下:

input: upRatio(1.5); // 高點幅度

variable: xHigh(0) ;

if barfreq \<\> "Min" then RaiseRuntimeError("請設定分鐘頻率");

if GetSymbolField("tse.tw","收盤價","d")

 \> average(GetSymbolField("tse.tw","收盤價","d"),10)

then begin

//大盤處於多頭格局

if trueall(GetField("收盤價","D")\<GetField("收盤價","D")\[1\]\*1.02,5)

then begin

//個股過去五個交易日沒有一天漲幅超過2%

 if Date \<\> Date\[1\] then xHigh \= 0;

 

 if Time \< 120000 then

 xHigh \= maxlist(xHigh, High)

 else if xHigh \> 0 then

 if Close \> xHigh and 

 Close \>= Close\[1\] \* (1 \+ upRatio/100)

//超過12點之後，最新價格超越12點之前的最高價

//而且比前一收盤價漲超過1.5%

 then ret=1; 

end;

end;

---

## 場景 797：雲端策略中心精進版之8\~籌碼沈澱突破買進訊號 — 根據上述的思維，我寫的腳本如下:

來源：[雲端策略中心精進版之8\~籌碼沈澱突破買進訊號](https://www.xq.com.tw/xstrader/%e9%9b%b2%e7%ab%af%e7%ad%96%e7%95%a5%e4%b8%ad%e5%bf%83%e7%b2%be%e9%80%b2%e7%89%88%e4%b9%8b8%e7%b1%8c%e7%a2%bc%e6%b2%88%e6%be%b1%e7%aa%81%e7%a0%b4%e8%b2%b7%e9%80%b2%e8%a8%8a%e8%99%9f/) 說明：根據上述的思維，我寫的腳本如下:

condition1=false;

if GetSymbolField("tse.tw","收盤價","D")

\>average(GetSymbolField("tse.tw","收盤價","D"),10)

then begin

//大盤處於多頭格局時

if v\[1\] \> 0 

then value1 \= (v\[1\] \- GetField("現股當沖張數")\[1\])/v\[1\];

//實質成交比例

if value1\[1\] \>0

then value2 \= 100\*value1/value1\[1\]-100;

//實質成交比例日變動百分比

if currentbar \< 1 then return;

value3 \= standarddev(value2,5,1);

//實質成交比例日變動百分比的不同天期標準差

value4 \= standarddev(value2,10,1);

value5 \= standarddev(value2,20,1);

if value3 \= lowest(value3 ,20) and 

 value4 \= lowest(value4 ,20) and 

 value5 \= lowest(value5 ,20) 

//現在各不同天期的成交比例日變動百分比標準差都處在期間最低點

then condition1=true;

if condition1 and close crosses over

highest(high\[1\],20)

then ret=1;

end;

---

## 場景 798：雲端策略中心精進版之7\~分點進出異常賣出訊號 — 跟昨天一樣，我們可以寫一個交易策略腳本如下：

來源：[雲端策略中心精進版之7\~分點進出異常賣出訊號](https://www.xq.com.tw/xstrader/%e9%9b%b2%e7%ab%af%e7%ad%96%e7%95%a5%e4%b8%ad%e5%bf%83%e7%b2%be%e9%80%b2%e7%89%88%e4%b9%8b7%e5%88%86%e9%bb%9e%e9%80%b2%e5%87%ba%e7%95%b0%e5%b8%b8%e8%b3%a3%e5%87%ba%e8%a8%8a%e8%99%9f/) 說明：跟昨天一樣，我們可以寫一個交易策略腳本如下：

input:period(10);

value1=GetField("分公司賣出家數")\[1\];

value2=GetField("分公司買進家數")\[1\]; 

if GetSymbolField("tse.tw","收盤價","D")

\<average(GetSymbolField("tse.tw","收盤價","D"),10)

then begin

if linearregslope(value1,period)\<0

//賣出的家數愈來愈少

and linearregslope(value2,period)\>0

//買進的家數愈來愈多

and value2\>300

and close\>close\[period\]\*1.05

//但這段期間股價在漲

and

close\>close\[1\]\*1.025

//今天又漲超過2.5%

then ret=1;

end;

---

## 場景 799：雲端策略中心精進版之6\~分點進出異常買進訊號 — 以下就是我根據上述四點所寫的腳本

來源：[雲端策略中心精進版之6\~分點進出異常買進訊號](https://www.xq.com.tw/xstrader/%e9%9b%b2%e7%ab%af%e7%ad%96%e7%95%a5%e4%b8%ad%e5%bf%83%e7%b2%be%e9%80%b2%e7%89%88%e4%b9%8b6%e5%88%86%e9%bb%9e%e9%80%b2%e5%87%ba%e7%95%b0%e5%b8%b8%e8%b2%b7%e9%80%b2%e8%a8%8a%e8%99%9f/) 說明：以下就是我根據上述四點所寫的腳本

input:period(10);

value1=GetField("分公司賣出家數")\[1\];

value2=GetField("分公司買進家數")\[1\]; 

if GetSymbolField("tse.tw","收盤價","D")

\>average(GetSymbolField("tse.tw","收盤價","D"),10)

then begin

if linearregslope(value1,period)\>0

//賣出的家數愈來愈多

and linearregslope(value2,period)\<0

//買進的家數愈來愈少

and value1\>300

and close\*1.05\<close\[period\]

//但這段期間股價在跌

and

close\*1.03\<close\[1\]

//今天又跌超過3%

then ret=1;

end;

---

## 場景 800：雲端策略中心精進版之5\~股價突破開盤委買大單成本區 — 為了找到符合上述情況的股票，我們寫了一個腳本如下

來源：[雲端策略中心精進版之5\~股價突破開盤委買大單成本區](https://www.xq.com.tw/xstrader/%e9%9b%b2%e7%ab%af%e7%ad%96%e7%95%a5%e4%b8%ad%e5%bf%83%e7%b2%be%e9%80%b2%e7%89%88%e4%b9%8b5%e8%82%a1%e5%83%b9%e7%aa%81%e7%a0%b4%e9%96%8b%e7%9b%a4%e5%a7%94%e8%b2%b7%e5%a4%a7%e5%96%ae%e6%88%90%e6%9c%ac/) 說明：為了找到符合上述情況的股票，我們寫了一個腳本如下

if GetSymbolField("tse.tw","收盤價","D")

\>average(GetSymbolField("tse.tw","收盤價","D"),10)

//大盤處於多頭格局

then begin

value1=GetField("開盤委買","D");

value2=GetField("開盤委賣","D");

value3=value1-value2;

//開盤委買張數減去開盤委賣張數

if trueall(value3\[1\]\<150,5)

//過去五天差距都小於150張

and value3\>=300

//今天差距超過300張

and close\<close\[3\]\*1.07

//股價比三天前漲幅不到7%

then ret=1;

end;

---

## 場景 801：雲端策略中心精進版之4\~主力偷偷收集籌碼後攻堅 — 於是，我們可以寫出像以下的腳本

來源：[雲端策略中心精進版之4\~主力偷偷收集籌碼後攻堅](https://www.xq.com.tw/xstrader/%e9%9b%b2%e7%ab%af%e7%ad%96%e7%95%a5%e4%b8%ad%e5%bf%83%e7%b2%be%e9%80%b2%e7%89%88%e4%b9%8b4%e4%b8%bb%e5%8a%9b%e5%81%b7%e5%81%b7%e6%94%b6%e9%9b%86%e7%b1%8c%e7%a2%bc%e5%be%8c%e6%94%bb%e5%a0%85/) 說明：於是，我們可以寫出像以下的腳本

input:period(10,"籌碼計算天期");

Value1=GetField("分公司買進家數","D");

value2=GetField("分公司賣出家數","D");

value3=(value2-value1);

//賣出的家數比買進家數多的部份

value4=average(close,5);

//五日移動平均

if getsymbolfield("tse.tw","收盤價")

\>average(getsymbolfield("tse.tw","收盤價"),10)

then begin

 if period\<\>0

 then begin

 if countif(value3\>30, period)/period \>0.7

 and linearregslope(value4,5)\>0

 then ret=1;

 end;

end;

---

## 場景 802：雲端策略中心精進版之3\~主力偷偷調節持股後下殺 — 要找出符合上述情況的標的，運用的腳本如下:

來源：[雲端策略中心精進版之3\~主力偷偷調節持股後下殺](https://www.xq.com.tw/xstrader/%e9%9b%b2%e7%ab%af%e7%ad%96%e7%95%a5%e4%b8%ad%e5%bf%83%e7%b2%be%e9%80%b2%e7%89%88%e4%b9%8b3%e4%b8%bb%e5%8a%9b%e5%81%b7%e5%81%b7%e8%aa%bf%e7%af%80%e6%8c%81%e8%82%a1%e5%be%8c%e4%b8%8b%e6%ae%ba/) 說明：要找出符合上述情況的標的，運用的腳本如下:

input:period(10,"籌碼計算天期");

Value1=GetField("分公司買進家數","D");

value2=GetField("分公司賣出家數","D");

value3=(value1-value2);

//買進家數減去賣出家數，代表籌碼發散的情況

value4=average(close,5);

//計算發散程度的五日移動平均

if getsymbolfield("tse.tw","收盤價")

\<average(getsymbolfield("tse.tw","收盤價"),period)

//大盤區間是下跌的

then begin

 if period\<\>0

 then begin

 if countif(value3\>10, period)/period \>0.6

//區間裡超過六成以上的日子主力都是站在出貨那一邊

 and linearregslope(value4,5)\>0

//發散程度之五日移動平均線短期趨勢是向上

 then ret=1;

 end;

end;

---

## 場景 803：雲端策略中心精進版之2\~股價領先大盤創新高 — 首先我們先來看看一個自訂指標，我稱之為相對大盤強度指標，它的寫法如下:

來源：[雲端策略中心精進版之2\~股價領先大盤創新高](https://www.xq.com.tw/xstrader/%e9%9b%b2%e7%ab%af%e7%ad%96%e7%95%a5%e4%b8%ad%e5%bf%83%e7%b2%be%e9%80%b2%e7%89%88%e4%b9%8b2%e8%82%a1%e5%83%b9%e9%a0%98%e5%85%88%e5%a4%a7%e7%9b%a4%e5%89%b5%e6%96%b0%e9%ab%98/) 說明：首先我們先來看看一個自訂指標，我稱之為相對大盤強度指標，它的寫法如下:

input: Length(20, "布林通道天數");

input: BandRange(2, "上下寬度");

variable: up(0), down(0);

value1=close/GetSymbolField("TSE.TW","收盤價");

up \= bollingerband(value1, Length, BandRange);

down=bollingerband(value1,length,-bandrange);

plot1(up,"BB上限");

plot2(down,"BB下限");

plot3(value1,"相對強度");

---

## 場景 804：雲端策略中心精進版之2\~股價領先大盤創新高 — 這個指標的概念是，把個股與加權指數的比值，跟這個比值算出來BBand的上下限，這裡 我們用的bandrange是2，也就是兩個標準差，根據統計理論，如果股價是常...

來源：[雲端策略中心精進版之2\~股價領先大盤創新高](https://www.xq.com.tw/xstrader/%e9%9b%b2%e7%ab%af%e7%ad%96%e7%95%a5%e4%b8%ad%e5%bf%83%e7%b2%be%e9%80%b2%e7%89%88%e4%b9%8b2%e8%82%a1%e5%83%b9%e9%a0%98%e5%85%88%e5%a4%a7%e7%9b%a4%e5%89%b5%e6%96%b0%e9%ab%98/) 說明：這個指標的概念是，把個股與加權指數的比值，跟這個比值算出來BBand的上下限，這裡 我們用的bandrange是2，也就是兩個標準差，根據統計理論，如果股價是常態分配的話 ，這個數字位在上下限中間的機率是95.44%，也就是說，當個股的基本面沒有太大變化 ，股價隨機伴著大盤時漲時跌時，這個比值應該會落在bband的上下限中間。 反過來說，當股價開始因為個別的因素要走自己路的時候，這個比值就會突破b...

if GetSymbolField("TSE.TW","收盤價")

\>average(GetSymbolField("TSE.TW","收盤價"),10)

then begin

input: Length(20, "布林通道天數");

input: BandRange(2, "上下寬度");

variable: up(0);

value1=close/GetSymbolField("TSE.TW","收盤價");

 

up \= bollingerband(value1, Length, BandRange);

condition1 \= trueall(value1 \>= up, 3);

condition2 \= average(GetSymbolField("TSE.TW","收盤價"),5) \> average(GetSymbolField("TSE.TW","收盤價"),20);

ret \= condition1 and condition2 ;

end;

---

## 場景 805：跌不下去的高殖利率股

來源：[跌不下去的高殖利率股](https://www.xq.com.tw/xstrader/%e8%b7%8c%e4%b8%8d%e4%b8%8b%e5%8e%bb%e7%9a%84%e9%ab%98%e6%ae%96%e5%88%a9%e7%8e%87%e8%82%a1/) 說明：其中的選股腳本如下

// 作多, 最大持有期別20

input:N(10);

condition1 \= L \= Lowest(L,N);

condition2 \= H \= Highest(H,N);

 if condition2

 //股價創區間以來高點

 and TrueAll(Condition1=false,N)

 //這段區間都未破底

 and close\<close\[N-1\]\*1.05

 and volume\>600

 //區間股價漲幅不大

 then ret=1;

---

## 場景 806：從最新公佈月營收挖寶的十個方法 — 例如我們想要挑出月營收年增率大於零的股票，我們就可以寫出以下的腳本:

來源：[從最新公佈月營收挖寶的十個方法](https://www.xq.com.tw/xstrader/%e5%be%9e%e6%9c%80%e6%96%b0%e5%85%ac%e4%bd%88%e6%9c%88%e7%87%9f%e6%94%b6%e6%8c%96%e5%af%b6%e7%9a%84%e5%8d%81%e5%80%8b%e6%96%b9%e6%b3%95/) 說明：例如我們想要挑出月營收年增率大於零的股票，我們就可以寫出以下的腳本:

value1=GetField("月營收年增率","M");

value2=GetFieldDate("月營收","M");

if value1\>0

then ret=1;

outputfield(1,value1,2,"月營收年增率");

outputfield(2,value2,0,"最新公佈的月份");

---

## 場景 807：從最新公佈月營收挖寶的十個方法 — 一，月營收創一段期間以來新高

來源：[從最新公佈月營收挖寶的十個方法](https://www.xq.com.tw/xstrader/%e5%be%9e%e6%9c%80%e6%96%b0%e5%85%ac%e4%bd%88%e6%9c%88%e7%87%9f%e6%94%b6%e6%8c%96%e5%af%b6%e7%9a%84%e5%8d%81%e5%80%8b%e6%96%b9%e6%b3%95/) 說明：一，月營收創一段期間以來新高

input:N(37, "期別"); 

value1=GetField("月營收", "M");

value2=GetField("月營收月增率","M");

value3=GetField("月營收年增率","M");

value4=GetFieldDate("月營收","M");

if value1=Highest(value1,N)

//月營收創37期新高

and trueall(value2\>0,2)

//月營收月增率近兩個月都\>0

and trueall(value3\>0,2)

//月營收年增率近兩個月都\>0

then ret=1; 

outputfield(1,value4,0,"最新月份");

---

## 場景 808：從最新公佈月營收挖寶的十個方法 — 二，月營收創一段時間以來新低

來源：[從最新公佈月營收挖寶的十個方法](https://www.xq.com.tw/xstrader/%e5%be%9e%e6%9c%80%e6%96%b0%e5%85%ac%e4%bd%88%e6%9c%88%e7%87%9f%e6%94%b6%e6%8c%96%e5%af%b6%e7%9a%84%e5%8d%81%e5%80%8b%e6%96%b9%e6%b3%95/) 說明：二，月營收創一段時間以來新低

input:N(37, "期別"); 

value1=GetField("月營收", "M");

value2=GetField("月營收月增率","M");

value3=GetField("月營收年增率","M");

value4=GetFieldDate("月營收","M");

if value1=lowest(value1,N)

//月營收創37期新低

and trueall(value2\<0,2)

//月營收月增率近兩個月都\<0

and trueall(value3\<0,2)

//月營收年增率近兩個月都\<0

then ret=1; 

outputfield(1,value4,0,"最新月份");

---

## 場景 809：從最新公佈月營收挖寶的十個方法

來源：[從最新公佈月營收挖寶的十個方法](https://www.xq.com.tw/xstrader/%e5%be%9e%e6%9c%80%e6%96%b0%e5%85%ac%e4%bd%88%e6%9c%88%e7%87%9f%e6%94%b6%e6%8c%96%e5%af%b6%e7%9a%84%e5%8d%81%e5%80%8b%e6%96%b9%e6%b3%95/) 說明：腳本的寫法如下:

value1=GetField("月營收年增率","M");

if average(value1,4) crosses over average(value1,12)

then ret=1;

---

## 場景 810：從最新公佈月營收挖寶的十個方法

來源：[從最新公佈月營收挖寶的十個方法](https://www.xq.com.tw/xstrader/%e5%be%9e%e6%9c%80%e6%96%b0%e5%85%ac%e4%bd%88%e6%9c%88%e7%87%9f%e6%94%b6%e6%8c%96%e5%af%b6%e7%9a%84%e5%8d%81%e5%80%8b%e6%96%b9%e6%b3%95/) 說明：我寫的參考腳本如下:

value1=GetField("總市值","M");//單位:億元

value2=GetField("月營收","M");//單位:億元

if value2\<\>0

then 

value3=value1/value2

else

value3=0;

if trueall(value3\>value3\[1\],3)//過去三期都上漲

and value3\[3\]\<value3\[4\]

and value3\[4\]\<value3\[5\] //之前兩期是下跌

and value2\>value2\[1\]//月營收成長

then ret=1;

outputfield(1,value3,2,"總市值/月營收");

outputfield(2,value3\[1\] ,2,"前1期值");

outputfield(3,value3\[2\],2,"前2期值");

outputfield(4,value3\[3\],2,"前3期值");

outputfield(5,value3\[4\],2,"前4期值");

---

## 場景 811：從最新公佈月營收挖寶的十個方法

來源：[從最新公佈月營收挖寶的十個方法](https://www.xq.com.tw/xstrader/%e5%be%9e%e6%9c%80%e6%96%b0%e5%85%ac%e4%bd%88%e6%9c%88%e7%87%9f%e6%94%b6%e6%8c%96%e5%af%b6%e7%9a%84%e5%8d%81%e5%80%8b%e6%96%b9%e6%b3%95/) 說明：參考的腳本如下:

value1=GetField("月營收","M");//單位:億元

value4=GetField("營業利益率","Q");

value5=GetField("最新股本");//單位:億元

condition1=false;

condition2=false;

input:peraito(12,"預估本益比上限");

if value5\<\>0

then

value6=(value1\*value4\*12)/(value5\*10);//單月營收推估的本業EPS

if value6\<\>0

then 

value7=close/value6;

if value7\<peraito and value7\>0

then ret=1;

outputfield(1,value7,0,"推估本益比");

---

## 場景 812：從最新公佈月營收挖寶的十個方法

來源：[從最新公佈月營收挖寶的十個方法](https://www.xq.com.tw/xstrader/%e5%be%9e%e6%9c%80%e6%96%b0%e5%85%ac%e4%bd%88%e6%9c%88%e7%87%9f%e6%94%b6%e6%8c%96%e5%af%b6%e7%9a%84%e5%8d%81%e5%80%8b%e6%96%b9%e6%b3%95/) 說明：參考的腳本如下:

input:period(5,"計算區間");

if trueall(GetField("月營收月增率","M")\>0,period)

then ret=1;

---

## 場景 813：從最新公佈月營收挖寶的十個方法

來源：[從最新公佈月營收挖寶的十個方法](https://www.xq.com.tw/xstrader/%e5%be%9e%e6%9c%80%e6%96%b0%e5%85%ac%e4%bd%88%e6%9c%88%e7%87%9f%e6%94%b6%e6%8c%96%e5%af%b6%e7%9a%84%e5%8d%81%e5%80%8b%e6%96%b9%e6%b3%95/) 說明：參考的腳本如下:

input:period(3,"計算區間");

if average(GetField("月營收年增率","M"),period)

\>=10

then ret=1;

---

## 場景 814：從最新公佈月營收挖寶的十個方法 — 公司的營運如果漸入佳境，愈來愈好，累計營收年增率會一個月比一個月好。

來源：[從最新公佈月營收挖寶的十個方法](https://www.xq.com.tw/xstrader/%e5%be%9e%e6%9c%80%e6%96%b0%e5%85%ac%e4%bd%88%e6%9c%88%e7%87%9f%e6%94%b6%e6%8c%96%e5%af%b6%e7%9a%84%e5%8d%81%e5%80%8b%e6%96%b9%e6%b3%95/) 說明：公司的營運如果漸入佳境，愈來愈好，累計營收年增率會一個月比一個月好。

input:period(6,"計算區間");

value1=GetField("累計營收年增率","M");

if trueall(value1\>value1\[1\],period)

then ret=1;

---

## 場景 815：從最新公佈月營收挖寶的十個方法

來源：[從最新公佈月營收挖寶的十個方法](https://www.xq.com.tw/xstrader/%e5%be%9e%e6%9c%80%e6%96%b0%e5%85%ac%e4%bd%88%e6%9c%88%e7%87%9f%e6%94%b6%e6%8c%96%e5%af%b6%e7%9a%84%e5%8d%81%e5%80%8b%e6%96%b9%e6%b3%95/) 說明：參考的腳本如下:

value1=GetField("月營收月增率","M");

value2=average(value1,36);

if value1\>10

and value1\>value2\*1.3

then ret=1;

---

## 場景 816：從最新公佈月營收挖寶的十個方法

來源：[從最新公佈月營收挖寶的十個方法](https://www.xq.com.tw/xstrader/%e5%be%9e%e6%9c%80%e6%96%b0%e5%85%ac%e4%bd%88%e6%9c%88%e7%87%9f%e6%94%b6%e6%8c%96%e5%af%b6%e7%9a%84%e5%8d%81%e5%80%8b%e6%96%b9%e6%b3%95/) 說明：參考的腳本如下:

//input:TXT("僅適用月線"); setinputname(1,"使用限制");

setbarfreq("M");

If barfreq \<\> "M" then raiseruntimeerror("頻率設定有誤");

settotalbar(23);

value1=GetField("月營收年增率","M");

value2=average(GetField("月營收年增率","M"), 3);

value3=linearregslope(value2,20);

value4=linearregslope(value2,5);

if value3 \< 0 and value4 crosses above 0

then ret=1;

---

## 場景 817：打造一個專屬的上市櫃公司健康檢查表 — 綜合以上的觀察，我試著寫了一個掛牌公司健康分數的程式腳本

來源：[打造一個專屬的上市櫃公司健康檢查表](https://www.xq.com.tw/xstrader/%e6%89%93%e9%80%a0%e4%b8%80%e5%80%8b%e5%b0%88%e5%b1%ac%e7%9a%84%e4%b8%8a%e5%b8%82%e6%ab%83%e5%85%ac%e5%8f%b8%e5%81%a5%e5%ba%b7%e6%aa%a2%e6%9f%a5%e8%a1%a8/) 說明：綜合以上的觀察，我試著寫了一個掛牌公司健康分數的程式腳本

value1=GetField("資本支出營收比","Q");

//現金流量表中固定資產(購置)/營業收入淨額\*100%

value2=GetField("資本支出金額","Q");//單位百萬

value3=GetField("股東權益報酬率","Q");

value4=GetField("長期投資","Q");//單位百萬

value5=GetField("負債比率","Q");

value6=GetField("每股營業額(元)","Q");

value7=GetField("現金及約當現金","Q");//單位百萬

value8=GetField("流動負債","Q");//單位百萬

value9=GetField("一年內到期長期負債","Q");//單位百萬

value10=GetField("應收帳款週轉率(次)","Q");

value11=GetField("投資收入／股利收入","Q");//單位百萬

value12=GetField("處分投資利得","Q");//單位百萬

value13=GetField("投資跌價損失回轉","Q");//單位百萬

value14=GetField("投資損失","Q");//單位百萬

value15=GetField("投資跌價損失","Q");//單位百萬

value16=GetField("處分投資損失","Q");//單位百萬

value17=GetField("董監持股佔股本比例","D");

value18=GetField("投信持股","D");

value19=GetField("現金股利","Y");

value20=GetField("融資餘額張數","D");

value21=GetField("融券餘額張數","D");

value22=GetField("來自營運之現金流量","Q");//單位百萬

value23=GetField("本期稅後淨利","Q");//單位百萬

value24=GetField("普通股股本","Q");//單位億

value25=GetField("短期投資","Q");

value26=value11+value12+value13-value14-value15-value16;

var:count(0);

count=0;

if linearregslope(value1,8)\>0

then count=count+1;

//1.資本支出營收比在成長

if linearregslope(value2,8)\>0

and linearregslope(GetField("營業收入淨額","Q"),12)\<0

then count=count+1;

//2.資本支出在成長但營收在衰退

if linearregslope(value3,8)\<0

then count=count+1;

//3.股東權益報酬率衰退中

if value4/(value24\*100)\*100\>40

then count=count+1;

//4.長期投資佔股本超過四成

if value5\>50

then count=count+1;

//5.負債比率超過五成

if linearregslope(value6,12)\<0

then count=count+1;

//6.每股營收持續衰退

if value7+value25\<value8+value9

then count=count+1;

//7.現金及約當現金+短期投資小於

//流動負債加一年內到期的長期負債

if linearregslope(value10,12)\<0

then count=count+1;

//8.應收帳款週轉次數在減少

if countif(value26\<0,12)\>2

then count=count+1;

//9.業外操作有超過兩季是虧錢

if value17\<15

then count=count+1;

//10.董監持股比例小於15

if value18\<500

then count=count+1;

//11.投信整體持股在500張以下

if average(value19,12)\<1

then count=count+1;

//12.現金股利長期都不到1元

if highest(value20,12)\>lowest(value20,12)\*2

and highest(value21,12)\>lowest(value21,12)\*2

then count=count+1;

//13.融資融券高低點相距超過一倍

if countif(value22\<value23,12)\>8

then count=count+1;

//14.來自營運的現金流量老是小於稅後淨利

if linearregslope(GetField("營業毛利率","Q"),12)\<0

then count=count+1;

//15.毛利率長期處於下降趨勢

if linearregslope(GetField("流動比率","Q"),12)\<0

then count=count+1;

//16.流動比例長期在下降

if linearregslope(GetField("存貨週轉率(次)","Q"),12)\<0

then count=count+1;

//17.存貨週轉率在下降

if linearregslope(GetField("存貨及應收帳款／淨值","Q"),12)\>0

then count=count+1;

//18.存貨及應收帳款佔淨值的比例在提高當中

if linearregslope(GetField("短期借款","Q"),12)\>0

then count=count+1;

//19.短期借款在增加

if linearregslope(GetField("背書保證餘額","M")+GetField("資金貸放餘額","M"),12)\>0

then count=count+1;

//20.背書保證餘額與資金貸放餘額在增加

var: score(0);

score=100-5\*count;

if value7\<2000

then begin

if score\<50

then ret=1;

end;

outputfield(1,score,0,"企業營運健康分數");

---

## 場景 818：好久以來的第一根長紅到底能不能追？ — 為了作這個測試，我先寫了一個腳本如下：

來源：[好久以來的第一根長紅到底能不能追？](https://www.xq.com.tw/xstrader/%e5%a5%bd%e4%b9%85%e4%bb%a5%e4%be%86%e7%9a%84%e7%ac%ac%e4%b8%80%e6%a0%b9%e9%95%b7%e7%b4%85%e5%88%b0%e5%ba%95%e8%83%bd%e4%b8%8d%e8%83%bd%e8%bf%bd%ef%bc%9f/) 說明：為了作這個測試，我先寫了一個腳本如下：

input:ratio(6,"長紅的漲幅下限");

input:period(40,"計算區間");

if close\>=close\[1\]\*(1+ratio/100)

and 

countif(close\[1\]\>=close\[2\]\*(1+ratio/100),period)=0

then ret=1;

---

## 場景 819：好久以來的第一根長紅到底能不能追？ — 於是我在原來的腳本加上只在大盤多頭時進場

來源：[好久以來的第一根長紅到底能不能追？](https://www.xq.com.tw/xstrader/%e5%a5%bd%e4%b9%85%e4%bb%a5%e4%be%86%e7%9a%84%e7%ac%ac%e4%b8%80%e6%a0%b9%e9%95%b7%e7%b4%85%e5%88%b0%e5%ba%95%e8%83%bd%e4%b8%8d%e8%83%bd%e8%bf%bd%ef%bc%9f/) 說明：於是我在原來的腳本加上只在大盤多頭時進場

input:ratio(6,"長紅的漲幅下限");

input:period(40,"計算區間");

if GetSymbolField("tse.tw","收盤價")

\>average(GetSymbolField("tse.tw","收盤價"),10)

then begin

if close\>=close\[1\]\*(1+ratio/100)

and 

countif(close\[1\]\>=close\[2\]\*(1+ratio/100),period)=0

then ret=1;

end;

---

## 場景 820：研究員生涯回憶之一 \~ 我們來談盈餘品質 — 我試著用XS的語法來描述這樣的公司

來源：[研究員生涯回憶之一 \~ 我們來談盈餘品質](https://www.xq.com.tw/xstrader/%e7%a0%94%e7%a9%b6%e5%93%a1%e7%94%9f%e6%b6%af%e5%9b%9e%e6%86%b6%e4%b9%8b%e4%b8%80-%e6%88%91%e5%80%91%e4%be%86%e8%ab%87%e7%9b%88%e9%a4%98%e5%93%81%e8%b3%aa/) 說明：我試著用XS的語法來描述這樣的公司

value1=GetField("營業利益","Y");

if trueall(value1\>100,5)

//週去五年都賺超過一億

and linearregslope(value1,5)\>0

//五年的營業利益趨勢往上

then ret=1;

---

## 場景 821：研究員生涯回憶之一 \~ 我們來談盈餘品質 — 接下來我們用每季的營業利益，找出那些季營業利益趨勢也是往上的，這是因為年資料是算到去年，我們還是要用今年以來的季資料，來挑出那些還維持一定盈餘品質的公司，所以我...

來源：[研究員生涯回憶之一 \~ 我們來談盈餘品質](https://www.xq.com.tw/xstrader/%e7%a0%94%e7%a9%b6%e5%93%a1%e7%94%9f%e6%b6%af%e5%9b%9e%e6%86%b6%e4%b9%8b%e4%b8%80-%e6%88%91%e5%80%91%e4%be%86%e8%ab%87%e7%9b%88%e9%a4%98%e5%93%81%e8%b3%aa/) 說明：接下來我們用每季的營業利益，找出那些季營業利益趨勢也是往上的，這是因為年資料是算到去年，我們還是要用今年以來的季資料，來挑出那些還維持一定盈餘品質的公司，所以我寫了另一個選股腳本如下

value1=GetField("營業利益","Q");

 if linearregslope(average(value1,5),5)\>0

 then ret=1;

---

## 場景 822：研究員生涯回憶之一 \~ 我們來談盈餘品質 — 要挑出這種股票，我寫了一個腳本如下:

來源：[研究員生涯回憶之一 \~ 我們來談盈餘品質](https://www.xq.com.tw/xstrader/%e7%a0%94%e7%a9%b6%e5%93%a1%e7%94%9f%e6%b6%af%e5%9b%9e%e6%86%b6%e4%b9%8b%e4%b8%80-%e6%88%91%e5%80%91%e4%be%86%e8%ab%87%e7%9b%88%e9%a4%98%e5%93%81%e8%b3%aa/) 說明：要挑出這種股票，我寫了一個腳本如下:

input:ratio(30,"折價比例%");

value1=GetField("營業利益","Y");//百萬

value2=GetField("每股淨值(元)","Y");

value3=GetField("普通股股本","Y");//單位:億

if trueall(value1\>100,5)

//週去五年都賺超過一億

and linearregslope(value1,5)\>0

//五年的營業利益趨勢往上

then begin

value4=value1\*10/100/value3\*10;

//用最近一年營業利益乘以十當未來十年的獲利

//算出未來十年的每股淨值增加值\]

value5=value2+value4;

//以目前的每股淨值加上上述數字即是公司內含價值

//(不考慮折舊的issue)

if close\*(1+ratio/100)\<value5

then ret=1;

end;

outputfield(1,value5,1,"內含價值");

outputfield(2,close,2,"目前股價");

outputfield(3,1-close/value5,"折溢價情況");

---

## 場景 823：尋找野百合的春天\~低調獲利穩定股交易策略 — 我根據他的邏輯，想把它轉成自動化交易的策略，寫了一個選股腳本及一個交易腳本。

來源：[尋找野百合的春天\~低調獲利穩定股交易策略](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e9%87%8e%e7%99%be%e5%90%88%e7%9a%84%e6%98%a5%e5%a4%a9%e4%bd%8e%e8%aa%bf%e7%8d%b2%e5%88%a9%e7%a9%a9%e5%ae%9a%e8%82%a1%e4%ba%a4%e6%98%93%e7%ad%96%e7%95%a5/) 說明：我根據他的邏輯，想把它轉成自動化交易的策略，寫了一個選股腳本及一個交易腳本。

value1=GetField("營業利益","Y");//單位:百萬

if highest(value1,3)\<lowest(value1,3)\*1.2

and value1\>200

then ret=1;

---

## 場景 824：尋找野百合的春天\~低調獲利穩定股交易策略 — 這腳本是挑出那些過去三年，每年營業利益都超過2億且波動不大的公司

來源：[尋找野百合的春天\~低調獲利穩定股交易策略](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e9%87%8e%e7%99%be%e5%90%88%e7%9a%84%e6%98%a5%e5%a4%a9%e4%bd%8e%e8%aa%bf%e7%8d%b2%e5%88%a9%e7%a9%a9%e5%ae%9a%e8%82%a1%e4%ba%a4%e6%98%93%e7%ad%96%e7%95%a5/) 說明：這腳本是挑出那些過去三年，每年營業利益都超過2億且波動不大的公司

settotalbar(700);

if getsymbolfield("tse.tw","收盤價")

\> average(getsymbolfield("tse.tw","收盤價"),10)

then begin

value4=GetField("總市值");

value5=average(value4,600);

if value4\[1\]\<value5\[1\]\*0.7

and close=highest(close,10)

then ret=1;

end;

---

## 場景 825：當好球員手感開始熱的時候\~高ROE股進入上漲軌跡時進場 — 然後我再把上述的指標改寫成以下的腳本

來源：[當好球員手感開始熱的時候\~高ROE股進入上漲軌跡時進場](https://www.xq.com.tw/xstrader/%e7%95%b6%e5%a5%bd%e7%90%83%e5%93%a1%e6%89%8b%e6%84%9f%e9%96%8b%e5%a7%8b%e7%86%b1%e7%9a%84%e6%99%82%e5%80%99%e9%ab%98roe%e8%82%a1%e9%80%b2%e5%85%a5%e4%b8%8a%e6%bc%b2%e8%bb%8c%e8%b7%a1%e6%99%82/) 說明：然後我再把上述的指標改寫成以下的腳本

input:period(12);

value1=countif(low\<lowest(low\[1\],period),period);

value2=countif(high\>highest(high\[1\],period),period);

value3=value2-value1;

if average(GetSymbolField("tse.tw","收盤價","D"),5)

\> average(GetSymbolField("tse.tw","收盤價","D"),20)

then begin

if value3 cross over 4

 

then ret=1;

end;

---

## 場景 826：這根長黑後，大跌的機率有多大? — 首先，我把這三種情況寫成腳本如下:

來源：[這根長黑後，大跌的機率有多大?](https://www.xq.com.tw/xstrader/%e9%80%99%e6%a0%b9%e9%95%b7%e9%bb%91%e5%be%8c%ef%bc%8c%e5%a4%a7%e8%b7%8c%e7%9a%84%e6%a9%9f%e7%8e%87%e6%9c%89%e5%a4%9a%e5%a4%a7/) 說明：首先，我把這三種情況寫成腳本如下:

condition1=false;

condition2=false;

condition3=false;

input:period(60);

input:days(6);

if highest(high,period)\>lowest(low,period)\*1.07

and high\*1.05\>highest(high,period)

//高點離波段最高點不遠

//波段漲幅達一定水準

then begin

//=====空頭包絡線===========

if high=highest(high,days)

//高點創近期最高價

and 

low=lowest(low,days)

//低點創區間最低價

and 

close\<close\[1\]

//收盤下跌

then condition1=true;

//====收盤收最當日最低點=========

if close=low

then condition2=true;

//====盤整後一舉跌破前幾日低點

if highest(high,days)\<lowest(low,days)\*1.05

and close cross under lowest(low\[1\],days)

then condition3=true;

if condition1 or condition2 or condition3

then ret=1;

end;

---

## 場景 827：總市值月營收比值  \~  一個看盡人情冷暖的指標 — 對於前者 ，我寫了一個腳本如下

來源：[總市值月營收比值  \~  一個看盡人情冷暖的指標](https://www.xq.com.tw/xstrader/%e7%b8%bd%e5%b8%82%e5%80%bc%e6%9c%88%e7%87%9f%e6%94%b6%e6%af%94%e5%80%bc-%e4%b8%80%e5%80%8b%e7%9c%8b%e7%9b%a1%e4%ba%ba%e6%83%85%e5%86%b7%e6%9a%96%e7%9a%84%e6%8c%87%e6%a8%99/) 說明：對於前者 ，我寫了一個腳本如下

value1=GetField("總市值","M");//單位:億元

value2=GetField("月營收","M");//單位:億元

if value2\<\>0

then 

value3=value1/value2

else

value3=0;

if trueall(value3\>value3\[1\],3)//過去三期都上漲

and value3\[3\]\<value3\[4\]

and value3\[4\]\<value3\[5\] //之前兩期是下跌

and value2\>value2\[1\]//月營收成長

then ret=1;

outputfield(1,value3,2,"總市值/月營收");

outputfield(2,value3\[1\] ,2,"前1期值");

outputfield(3,value3\[2\],2,"前2期值");

outputfield(4,value3\[3\],2,"前3期值");

outputfield(5,value3\[4\],2,"前4期值");

---

## 場景 828：總市值月營收比值  \~  一個看盡人情冷暖的指標 — 對於後者，我寫的對應腳本如下

來源：[總市值月營收比值  \~  一個看盡人情冷暖的指標](https://www.xq.com.tw/xstrader/%e7%b8%bd%e5%b8%82%e5%80%bc%e6%9c%88%e7%87%9f%e6%94%b6%e6%af%94%e5%80%bc-%e4%b8%80%e5%80%8b%e7%9c%8b%e7%9b%a1%e4%ba%ba%e6%83%85%e5%86%b7%e6%9a%96%e7%9a%84%e6%8c%87%e6%a8%99/) 說明：對於後者，我寫的對應腳本如下

input:period(60,"計算月數");

input:ratio(10,"距離低點幅度");

settotalbar(period);

value1=GetField("總市值","M");//單位:億元

value2=GetField("月營收","M");//單位:億元

if value2\<\>0

then 

value3=value1/value2

else

value3=0;

if value3\<lowest(value3,period)\*(1+ratio/100)

//總市值營收比值距離過去一段時間最低點沒有差多遠

and value3\>0

then ret=1;

outputfield(1,value3,2,"總市值/月營收");

outputfield(2,lowest(value3,period),2,"期間最低值");

outputfield(3,value3/lowest(value3,period),2,"兩者的比率");

---

## 場景 829：什麼方法才能找到會大漲，可以抱一陣子的股票? — 符合上述兩個條件的腳本如下:

來源：[什麼方法才能找到會大漲，可以抱一陣子的股票?](https://www.xq.com.tw/xstrader/%e4%bb%80%e9%ba%bc%e6%96%b9%e6%b3%95%e6%89%8d%e8%83%bd%e6%89%be%e5%88%b0%e6%9c%83%e5%a4%a7%e6%bc%b2%ef%bc%8c%e5%8f%af%e4%bb%a5%e6%8a%b1%e4%b8%80%e9%99%a3%e5%ad%90%e7%9a%84%e8%82%a1%e7%a5%a8/) 說明：符合上述兩個條件的腳本如下:

if high=highest(high,200)

and GetSymbolField("tse.tw","收盤價")\>

average(GetSymbolField("tse.tw","收盤價"),20)

then ret=1;

---

## 場景 830：以月營收為基礎而建構的三個冷門股選股策略

來源：[以月營收為基礎而建構的三個冷門股選股策略](https://www.xq.com.tw/xstrader/%e4%bb%a5%e6%9c%88%e7%87%9f%e6%94%b6%e7%82%ba%e5%9f%ba%e7%a4%8e%e8%80%8c%e5%bb%ba%e6%a7%8b%e7%9a%84%e5%b9%be%e5%80%8b%e9%81%b8%e8%82%a1%e7%ad%96%e7%95%a5/) 說明：計算的腳本如下

value1=GetField("月營收","M");//億

value2=GetField("營業利益率","Q");

value3=value1\*12\*value2/100;

value4=GetField("最新股本");//億

variable:FEPS(0);

FEPS=value3/value4\*10;

setoutputname1("用月營收預估的本業EPS");

outputfield1(FEPS, 2, "用月營收預估的本業EPS");

if feps\<\>0

then value5=close/feps;

setoutputname2("用月營收預估的本益比");

outputfield2(value5, 2, "用月營收預估的本益比");

if value5\<12 and value5\>0

then condition1=true;

input:lowlimit(20);//單位:%

setinputname(1,"成長百分比");

value6=GetField("月營收月增率","M");

value7=GetField("月營收年增率","M");

if value6\>=lowlimit

and value7\>=lowlimit

and value6\[1\]\>0

then condition2=true;

if condition1 and condition2

then ret=1;

---

## 場景 831：以月營收為基礎而建構的三個冷門股選股策略 — 這個策略是去尋找那些加速成長的公司，腳本如下:

來源：[以月營收為基礎而建構的三個冷門股選股策略](https://www.xq.com.tw/xstrader/%e4%bb%a5%e6%9c%88%e7%87%9f%e6%94%b6%e7%82%ba%e5%9f%ba%e7%a4%8e%e8%80%8c%e5%bb%ba%e6%a7%8b%e7%9a%84%e5%b9%be%e5%80%8b%e9%81%b8%e8%82%a1%e7%ad%96%e7%95%a5/) 說明：這個策略是去尋找那些加速成長的公司，腳本如下:

value1=GetField("月營收月增率","M");

value2=average(value1,36);

if value1\>10

and value1\>value2\*1.3

then ret=1;

---

## 場景 832：從細產業指數的相對強度看類股的輪動 — 如果把這個概念化成自訂指標，腳本可以像下面這樣的寫法

來源：[從細產業指數的相對強度看類股的輪動](https://www.xq.com.tw/xstrader/%e5%be%9e%e7%b4%b0%e7%94%a2%e6%a5%ad%e6%8c%87%e6%95%b8%e7%9a%84%e7%9b%b8%e5%b0%8d%e5%bc%b7%e5%ba%a6%e7%9c%8b%e9%a1%9e%e8%82%a1%e7%9a%84%e8%bc%aa%e5%8b%95/) 說明：如果把這個概念化成自訂指標，腳本可以像下面這樣的寫法

input:length(10); 

variable: sumUp(0), sumDown(0), up(0), down(0),RS(0);

if CurrentBar \= 1 then

begin

sumUp \= Average(maxlist(close \- close\[1\], 0), length); 

sumDown \= Average(maxlist(close\[1\] \- close, 0), length); 

end 

else

begin

up \= maxlist(close \- close\[1\], 0);

down \= maxlist(close\[1\] \- close, 0);

sumUp \= sumUp\[1\] \+ (up \- sumUp\[1\]) / length;

sumDown \= sumDown\[1\] \+ (down \- sumDown\[1\]) / length;

end;

if sumdown\<\>0

then rs=sumup/sumdown;

plot1(rs);

plot2(2);

---

## 場景 833：開盤開始發動攻勢的主力買超股\~交易時機策略的應用方式

來源：[開盤開始發動攻勢的主力買超股\~交易時機策略的應用方式](https://www.xq.com.tw/xstrader/%e9%96%8b%e7%9b%a4%e9%96%8b%e5%a7%8b%e7%99%bc%e5%8b%95%e6%94%bb%e5%8b%a2%e7%9a%84%e4%b8%bb%e5%8a%9b%e8%b2%b7%e8%b6%85%e8%82%a1/) 說明：例如以下的腳本

input: Length(5); setinputname(1,"計算天數");

input: limit1(20); setinputname(2,"買超佔成交量比例");

variable: r1(0), volTotal(0),ratio(0);

SetBarBack(20);

SetTotalBar(25);

r1 \= summation(GetField("主力買賣超張數"), Length);

volTotal \= summation(Volume, Length);

if voltotal\<\>0 then 

 begin

 ratio \= r1 / voltotal \* 100;

 if ratio \>= limit1 and average(volume,20) \> 500 then ret=1;

 

 setoutputname1("主力買賣超比重(%)");

 outputfield1(ratio);

 end;

---

## 場景 834：開盤開始發動攻勢的主力買超股\~交易時機策略的應用方式

來源：[開盤開始發動攻勢的主力買超股\~交易時機策略的應用方式](https://www.xq.com.tw/xstrader/%e9%96%8b%e7%9b%a4%e9%96%8b%e5%a7%8b%e7%99%bc%e5%8b%95%e6%94%bb%e5%8b%a2%e7%9a%84%e4%b8%bb%e5%8a%9b%e8%b2%b7%e8%b6%85%e8%82%a1/) 說明：開盤後一路走強

if barfreq \<\> "Min" or Barinterval \<\>1 then RaiseRuntimeError("請設定頻率為1分鐘");

input:n1(10,"開盤連續幾分鐘");

variable:BarNumberOfToday(0); 

if Date \<\> Date\[1\] then BarNumberOfToday=1 

else BarNumberOfToday+=1;{記錄今天的Bar數} 

if Date \=currentdate then begin

variable: idx(0),tTime(0);

tTime=0;

 

for idx \= 0 to n1-1

begin

if Close\[idx\] \> Close\[idx+1\] then tTime+=1;

 {推升時記1}

 end; 

value1=q\_DailyHigh;

if tTime \>=n1\*0.75

and q\_PriceChangeRatio \< 2 {漲幅仍在2%內}

and Timediff(Time,Time\[BarNumberOfToday-1\],"M") \=n1{分鐘} 

 {離開盤第1個價15分鐘內}

and close=value1//目前是今日最高價

then ret=1;

end;

---

## 場景 835：1500檔股票，今晚該研究那一檔? — 我把這樣的想法寫成一個自訂的指標，股本如下:

來源：[1500檔股票，今晚該研究那一檔?](https://www.xq.com.tw/xstrader/1500%e6%aa%94%e8%82%a1%e7%a5%a8%ef%bc%8c%e4%bb%8a%e6%99%9a%e8%a9%b2%e7%a0%94%e7%a9%b6%e9%82%a3%e4%b8%80%e6%aa%94/) 說明：我把這樣的想法寫成一個自訂的指標，股本如下:

input:period(12);

value1=countif(low\<lowest(low\[1\],period),period);

value2=countif(high\>highest(high\[1\],period),period);

value3=value2-value1;

plot1(value3);

---

## 場景 836：1500檔股票，今晚該研究那一檔? — 所以我就寫了以下這個腳本，專門來找出這一類型的股票

來源：[1500檔股票，今晚該研究那一檔?](https://www.xq.com.tw/xstrader/1500%e6%aa%94%e8%82%a1%e7%a5%a8%ef%bc%8c%e4%bb%8a%e6%99%9a%e8%a9%b2%e7%a0%94%e7%a9%b6%e9%82%a3%e4%b8%80%e6%aa%94/) 說明：所以我就寫了以下這個腳本，專門來找出這一類型的股票

input:period(12);

value1=countif(low\<lowest(low\[1\],period),period);

value2=countif(high\>highest(high\[1\],period),period);

value3=value2-value1;

if value3 cross over 3

then ret=1;

---

## 場景 837：股價突破10年線到底算不算是個好的交易訊號? — 根據這樣的條件，我寫了以下的腳本

來源：[股價突破10年線到底算不算是個好的交易訊號?](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%83%b9%e7%aa%81%e7%a0%b410%e5%b9%b4%e7%b7%9a%e5%88%b0%e5%ba%95%e7%ae%97%e4%b8%8d%e7%ae%97%e6%98%af%e5%80%8b%e5%a5%bd%e7%9a%84%e4%ba%a4%e6%98%93%e8%a8%8a%e8%99%9f/) 說明：根據這樣的條件，我寫了以下的腳本

value1=GetField("強弱指標","D");

value2=GetField("法人買賣超");

if close cross over average(GetField("收盤價","M"),120)

then begin

if barslast(close\[1\] cross over average(GetField("收盤價","M"),120))

\>200

and countif(value1\>0,5)\>=3

and countif(value2\>500,10)\>=6

and volume\>2000

then ret=1;

end;

---

## 場景 838：step by step 打造私房投資組合 — 我用以下的腳本，計算這個投資組合的最新市值，計算這個組合的總市值變化

來源：[step by step 打造私房投資組合](https://www.xq.com.tw/xstrader/step-by-step-%e6%89%93%e9%80%a0%e7%a7%81%e6%88%bf%e6%8a%95%e8%b3%87%e7%b5%84%e5%90%88/) 說明：我用以下的腳本，計算這個投資組合的最新市值，計算這個組合的總市值變化

array:x1\[22\](0);

 

x1\[1\]=GetSymbolField("1256.tw","總市值");

x1\[2\]=GetSymbolField("1476.tw","總市值");

x1\[3\]=GetSymbolField("1527.tw","總市值");

x1\[4\]=GetSymbolField("1707.tw","總市值");

x1\[5\]=GetSymbolField("2231.tw","總市值");

x1\[6\]=GetSymbolField("3008.tw","總市值");

x1\[7\]=GetSymbolField("3088.tw","總市值");

x1\[8\]=GetSymbolField("3529.tw","總市值");

x1\[9\]=GetSymbolField("3552.tw","總市值");

x1\[10\]=GetSymbolField("3570.tw","總市值");

x1\[11\]=GetSymbolField("3611.tw","總市值");

x1\[12\]=GetSymbolField("3665.tw","總市值");

x1\[13\]=GetSymbolField("4947.tw","總市值");

x1\[14\]=GetSymbolField("5306.tw","總市值");

x1\[15\]=GetSymbolField("6146.tw","總市值");

x1\[16\]=GetSymbolField("6206.tw","總市值");

x1\[17\]=GetSymbolField("6245.tw","總市值");

x1\[18\]=GetSymbolField("6279.tw","總市值");

x1\[19\]=GetSymbolField("8109.tw","總市值");

x1\[20\]=GetSymbolField("8406.tw","總市值");

x1\[21\]=GetSymbolField("8416.tw","總市值");

x1\[22\]=GetSymbolField("9951.tw","總市值");

value1=array\_sum(x1,1,22);

plot1(value1);

---

## 場景 839：那些股票除權後可以留意? — 接下來我們寫一個小腳本來找到那些股價距離高點打六折的股票

來源：[那些股票除權後可以留意?](https://www.xq.com.tw/xstrader/%e9%82%a3%e4%ba%9b%e8%82%a1%e7%a5%a8%e9%99%a4%e6%ac%8a%e5%be%8c%e5%8f%af%e4%bb%a5%e7%95%99%e6%84%8f/) 說明：接下來我們寫一個小腳本來找到那些股價距離高點打六折的股票

value1=highest(high,90);

if close \<=value1\*0.6

then ret=1;

---

## 場景 840：日週月線不同指標混搭交易策略 — 因為XS有提供了幾個跨頻率時來運用的技術指標函數，所以這個腳本就可以寫的很簡短

來源：[日週月線不同指標混搭交易策略](https://www.xq.com.tw/xstrader/%e6%97%a5%e9%80%b1%e6%9c%88%e7%b7%9a%e4%b8%8d%e5%90%8c%e6%8c%87%e6%a8%99%e6%b7%b7%e6%90%ad%e4%ba%a4%e6%98%93%e7%ad%96%e7%95%a5/) 說明：因為XS有提供了幾個跨頻率時來運用的技術指標函數，所以這個腳本就可以寫的很簡短

condition1=false;

condition2=false;

condition3=false;

input: Length(5, "計算期數");

input: RSVt(3, "RSVt權數");

input: Kt(3, "Kt權數");

input: LOWBound(30, "低檔區");

variable: rsv1(0), k1(0), \_d1(0);

xf\_Stochastic("M", Length, RSVt, Kt, rsv1, k1, \_d1);

condition1= K1\>\_D1;

 //月線KD轉強

xf\_macd("W",close,6,12,4,value1,value2,value3);

condition2=value2\>0;

//週線DIF轉正

if condition1 and condition2

and Momentum(Close, 10\) Crosses Above 0

and GetSymbolField("tse.tw","收盤價")\>

average(GetSymbolField("tse.tw","收盤價"),10)

then ret=1;

---

## 場景 841：日KD向上時的60分鐘線盤整後噴出 — 我根據這個思維，寫了以下的腳本，

來源：[日KD向上時的60分鐘線盤整後噴出](https://www.xq.com.tw/xstrader/%e6%97%a5kd%e5%90%91%e4%b8%8a%e6%99%82%e7%9a%8460%e5%88%86%e9%90%98%e7%b7%9a%e7%9b%a4%e6%95%b4%e5%be%8c%e5%99%b4%e5%87%ba/) 說明：我根據這個思維，寫了以下的腳本，

//盤整後噴出

input: Periods(15,"計算期數");

input: Ratio(3,"近期波動幅度%");

input: TXT1("僅適用60分鐘","使用限制");

var:rsv1(0),k1(0),d1(0);

xf\_stochastic("D",9, 3, 3, rsv1, k1, d1);

condition1 \= false;

if (highest(high\[1\],Periods-1) \- lowest(low\[1\],Periods-1))/close\[1\] \<= ratio\*0.01 

then condition1=true//近期波動在?%以內

else return;

if condition1 and high \= highest(high, Periods)

and GetSymbolField("tse.tw","收盤價","D")

\>average(GetSymbolField("tse.tw","收盤價","D"),10)

and volume \>=average(volume,20)\*1.3

and k1\>d1

and k1\>50

and k1\<80

then ret=1;

---

## 場景 842：每年七月總是會有表現的股票

來源：[每年七月總是會有表現的股票](https://www.xq.com.tw/xstrader/%e6%af%8f%e5%b9%b4%e4%b8%83%e6%9c%88%e7%b8%bd%e6%98%af%e6%9c%83%e6%9c%89%e8%a1%a8%e7%8f%be%e7%9a%84%e8%82%a1%e7%a5%a8/) 說明：寫選股程式找的

array:m1\[7\](0);

variable:x(0),count(0);

for x=1 to 7

begin

m1\[x\]=(close\[12\*x-1\]-close\[12\*x\])/close\[12\*x\];

end;

count=0;

for x=1 to 7

begin

if m1\[x\]\>0.02

then count=count+1;

end;

if count\>=6 and close\>5 

and average(volume,20)\>10000

then ret=1;

outputfield(1,count,0,"符合的次數");

---

## 場景 843：創區間來新高的股票是不是真的是作多的好標的? — 首先我先把多頭市場時股價領先大盤創歷史新高(且法人買進)的概念寫成以下的腳本

來源：[創區間來新高的股票是不是真的是作多的好標的?](https://www.xq.com.tw/xstrader/%e5%89%b5%e5%8d%80%e9%96%93%e4%be%86%e6%96%b0%e9%ab%98%e7%9a%84%e8%82%a1%e7%a5%a8%e6%98%af%e4%b8%8d%e6%98%af%e7%9c%9f%e7%9a%84%e6%98%af%e4%bd%9c%e5%a4%9a%e7%9a%84%e5%a5%bd%e6%a8%99%e7%9a%84/) 說明：首先我先把多頭市場時股價領先大盤創歷史新高(且法人買進)的概念寫成以下的腳本

condition1=false;

condition2=false;

condition3=false;

condition4=false;

if GetSymbolField("tse.tw","收盤價")

\>average(GetSymbolField("tse.tw","收盤價"),20)

then condition1=true;//市場處於多頭

value1=barslast(close=highest(close,100));

if close=highest(close,100) and value1\[1\]\>60

then condition2=true;//股價創近來新高

if summation(GetField("法人買賣超張數"),10)\>500

then condition3=true;//法人支持

if summation(GetField("強弱指標","D"),100)\>0

then condition4=true;//股價比大盤強

 

if condition1 and condition2 and condition3

and condition4

and volume\>1000

then ret=1;

---

## 場景 844：脫歐後的交易策略探討\~開低殺低後重新站回開盤價的隔日沖勝率 — 首先當然是先把口訣寫成一個腳本

來源：[脫歐後的交易策略探討\~開低殺低後重新站回開盤價的隔日沖勝率](https://www.xq.com.tw/xstrader/%e8%84%ab%e6%ad%90%e5%be%8c%e7%9a%84%e4%ba%a4%e6%98%93%e7%ad%96%e7%95%a5%e6%8e%a2%e8%a8%8e%e9%96%8b%e4%bd%8e%e6%ae%ba%e4%bd%8e%e5%be%8c%e9%87%8d%e6%96%b0%e7%ab%99%e5%9b%9e%e9%96%8b%e7%9b%a4%e5%83%b9/) 說明：首先當然是先把口訣寫成一個腳本

input:ratio(10,"近十日最小下跌幅度");

if open\*1.025\<close\[1\]//開盤重挫

and close\>open //收盤比開盤高

and close\*(1+ratio/100)\<close\[9\]

//近十日跌幅超過N%

and low\*1.01\<open

//開低後又殺低

then ret=1;

---

## 場景 845：外盤量異常突出的買進策略 — 根據上述的邏輯，我寫了以下的指標，

來源：[外盤量異常突出的買進策略](https://www.xq.com.tw/xstrader/%e5%a4%96%e7%9b%a4%e9%87%8f%e7%95%b0%e5%b8%b8%e7%aa%81%e5%87%ba%e7%9a%84%e8%b2%b7%e9%80%b2%e7%ad%96%e7%95%a5/) 說明：根據上述的邏輯，我寫了以下的指標，

var:bv(0),bva(0);

if volume\<\>0 then 

bv=GetField("外盤量")/volume\*100;

bva=average(bv,3);

input:length(20);

variable:up1(0),down1(0),mid1(0),bbandwidth(0);

up1 \= bollingerband(bva, Length, 1);

down1 \= bollingerband(bva, Length, \-1 );

mid1 \= (up1 \+ down1) / 2;

bbandwidth \= 100 \* (up1 \- down1) / mid1;

plot1(up1);

plot2(down1);

plot3(bva);

plot4(bbandwidth);

---

## 場景 846：當沖腳本之開高不拉回後的創新高 — 要滿足上述四個條件，我寫的腳本如下:

來源：[當沖腳本之開高不拉回後的創新高](https://www.xq.com.tw/xstrader/%e7%95%b6%e6%b2%96%e8%85%b3%e6%9c%ac%e4%b9%8b%e9%96%8b%e9%ab%98%e4%b8%8d%e6%8b%89%e5%9b%9e%e5%be%8c%e7%9a%84%e5%89%b5%e6%96%b0%e9%ab%98/) 說明：要滿足上述四個條件，我寫的腳本如下:

if barfreq \<\>"Min" or barinterval\<\> 1

then raiseruntimeerror("歹勢，本腳本只適用於1分鐘線");

var:count(0);

count=count+1;

if date\<\>date\[1\]

then count=1;

 

if GetField("開盤價","D")\> GetField("收盤價","D")\[1\]\*1.025

and count\>5

and lowest(low\[1\],count-1)\*1.015\>highest(high\[1\],count-1)

and close \=highest(high,count)

then ret=1;

---

## 場景 847：當沖腳本之開高不拉回後的創新高 — 這個策略的迷人之處在於，如果我們把同樣的邏輯用在空頭策略，我們可以寫出下面的放空腳本

來源：[當沖腳本之開高不拉回後的創新高](https://www.xq.com.tw/xstrader/%e7%95%b6%e6%b2%96%e8%85%b3%e6%9c%ac%e4%b9%8b%e9%96%8b%e9%ab%98%e4%b8%8d%e6%8b%89%e5%9b%9e%e5%be%8c%e7%9a%84%e5%89%b5%e6%96%b0%e9%ab%98/) 說明：這個策略的迷人之處在於，如果我們把同樣的邏輯用在空頭策略，我們可以寫出下面的放空腳本

if barfreq \<\>"Min" or barinterval\<\> 1

then raiseruntimeerror("歹勢，本腳本只適用於1分鐘線");

var:count(0);

count=count+1;

if date\<\>date\[1\]

then count=1;

 

if GetField("開盤價","D")\*1.025\< GetField("收盤價","D")\[1\] 

and count\>10

and lowest(low\[1\],count-1)\*1.015\>highest(high\[1\],count-1)

and close \=lowest(low,count)

then ret=1;

---

## 場景 848：定存股該不該波段操作? — 其中第四項用條列式挑不出來，所以我寫成腳本如下

來源：[定存股該不該波段操作?](https://www.xq.com.tw/xstrader/%e5%ae%9a%e5%ad%98%e8%82%a1%e8%a9%b2%e4%b8%8d%e8%a9%b2%e6%b3%a2%e6%ae%b5%e6%93%8d%e4%bd%9c/) 說明：其中第四項用條列式挑不出來，所以我寫成腳本如下

value1=GetField("營業毛利率","Q");

input:ratio(10,"毛利率單季衰退幅度上限");

input:period(10,"計算的期間，單位是季");

if trueall(value1\>value1\[1\]\*(1-ratio/100),period)

then ret=1;

---

## 場景 849：找大碗底型態的大型股 — 為了尋找這類型的股票，我寫了一個腳本如下:

來源：[找大碗底型態的大型股](https://www.xq.com.tw/xstrader/%e6%89%be%e5%a4%a7%e7%a2%97%e5%ba%95%e5%9e%8b%e6%85%8b%e7%9a%84%e5%a4%a7%e5%9e%8b%e8%82%a1/) 說明：為了尋找這類型的股票，我寫了一個腳本如下:

value1=lowestbar(low,100);

value2=lowest(low,100);

value3=highestbar(high,100);

value4=highest(high,100);

 

if value4\>value2\*1.2

and value3-value1\>15

then begin

if value1\>15

and value2\*1.05\>close\[1\]

and average(volume\[1\],15)\<5000

and close\>close\[1\]\*1.02

and volume\>average(volume\[1\],15)\*1.2

and GetSymbolField("tse.tw","收盤價")\>

average(GetSymbolField("tse.tw","收盤價"),20)

then ret=1;

end;

---

## 場景 850：周線，日線跟60分鐘線兼顧的交易策略 — 根據上述的邏輯，對應的腳本如下:

來源：[周線，日線跟60分鐘線兼顧的交易策略](https://www.xq.com.tw/xstrader/%e5%91%a8%e7%b7%9a%ef%bc%8c%e6%97%a5%e7%b7%9a%e8%b7%9f60%e5%88%86%e9%90%98%e7%b7%9a%e5%85%bc%e9%a1%a7%e7%9a%84%e4%ba%a4%e6%98%93%e7%ad%96%e7%95%a5/) 說明：根據上述的邏輯，對應的腳本如下:

//週線多頭排列

if GetField("收盤價","W")

\>=average(GetField("收盤價","W"),4)

and 

average(GetField("收盤價","W"),4)

\>=average(getfield("收盤價","w"),15)

and 

//日線動能小於0

GetField("收盤價","d")-GetField("收盤價","d")\[10\]

\<0

then begin

//60分鐘線創20小時來新高

if close=highest(high,20)

then ret=1;

end;

---

## 場景 851：從OTC與加權指數表現落差觀察大盤轉折點

來源：[從OTC與加權指數表現落差觀察大盤轉折點](https://www.xq.com.tw/xstrader/%e5%be%9eotc%e8%88%87%e5%8a%a0%e6%ac%8a%e6%8c%87%e6%95%b8%e8%a1%a8%e7%8f%be%e8%90%bd%e5%b7%ae%e8%a7%80%e5%af%9f%e5%a4%a7%e7%9b%a4%e8%bd%89%e6%8a%98%e9%bb%9e/) 說明：這個指標的腳本如下:

input:period(5,"移動平均天期");

value1=GetSymbolField("otc.tw","收盤價");

value2=rateofchange(value1,2);

value3=rateofchange(close,2);

if value2\>=0 

then value4=value2-value3

else

if value2\<0 and value2\>=value3

then value4= absvalue(value3)-absvalue(value2)

else

value4=absvalue(value2)-absvalue(value3);

value5=average(value4,5);

plot1(value5);

---

## 場景 852：有量的中小型股才是操作者的核心標的 — 是不是盤好的時候買什麼都一樣?我寫了一個腳本如下，就是當大盤週線在月線之上時，個股不需要其他條件就直接進場。

來源：[有量的中小型股才是操作者的核心標的](https://www.xq.com.tw/xstrader/%e6%9c%89%e9%87%8f%e7%9a%84%e4%b8%ad%e5%b0%8f%e5%9e%8b%e8%82%a1%e6%89%8d%e6%98%af%e6%93%8d%e4%bd%9c%e8%80%85%e7%9a%84%e6%a0%b8%e5%bf%83%e6%a8%99%e7%9a%84/) 說明：是不是盤好的時候買什麼都一樣?我寫了一個腳本如下，就是當大盤週線在月線之上時，個股不需要其他條件就直接進場。

if average(GetSymbolField("tse.tw","收盤價"),5)\>

average(GetSymbolField("tse.tw","收盤價"),20)

then ret=1;

---

## 場景 853：有量的中小型股才是操作者的核心標的

來源：[有量的中小型股才是操作者的核心標的](https://www.xq.com.tw/xstrader/%e6%9c%89%e9%87%8f%e7%9a%84%e4%b8%ad%e5%b0%8f%e5%9e%8b%e8%82%a1%e6%89%8d%e6%98%af%e6%93%8d%e4%bd%9c%e8%80%85%e7%9a%84%e6%a0%b8%e5%bf%83%e6%a8%99%e7%9a%84/) 說明：例如以下的這個腳本

condition1 \= GetField("投信持股")\[1\]\<=1000 and getField("投信買賣超")\[1\]=0;

if H\>H\[1\]

and TrueAll(condition1\[1\],60)

and GetField("投信買賣超")\[1\]\*C\>1000

and average(GetSymbolField("tse.tw","收盤價"),5)\>

average(GetSymbolField("tse.tw","收盤價"),20)

then ret=1;

---

## 場景 854：盤上成交是否真的是重要指標? — 要算盤上成交的比例，XS有內建一個欄位叫上漲量，所以我就寫了一個簡單的自訂指標腳本

來源：[盤上成交是否真的是重要指標?](https://www.xq.com.tw/xstrader/%e7%9b%a4%e4%b8%8a%e6%88%90%e4%ba%a4%e6%98%af%e5%90%a6%e7%9c%9f%e7%9a%84%e6%98%af%e9%87%8d%e8%a6%81%e6%8c%87%e6%a8%99/) 說明：要算盤上成交的比例，XS有內建一個欄位叫上漲量，所以我就寫了一個簡單的自訂指標腳本

value1=GetField("上漲量","D");

if volume\<\>0

then value2=value1/volume;

plot1(average(value2,5));

---

## 場景 855：盤上成交是否真的是重要指標? — 但寫完之後覺得這樣似乎完全沒有考慮到當天分時交易的多空拼搏，所以我又另外用一分鐘線最後是收在昨日收盤價之上與否，來決定是否把那一分鐘的成交量納入累積的盤上成交量...

來源：[盤上成交是否真的是重要指標?](https://www.xq.com.tw/xstrader/%e7%9b%a4%e4%b8%8a%e6%88%90%e4%ba%a4%e6%98%af%e5%90%a6%e7%9c%9f%e7%9a%84%e6%98%af%e9%87%8d%e8%a6%81%e6%8c%87%e6%a8%99/) 說明：但寫完之後覺得這樣似乎完全沒有考慮到當天分時交易的多空拼搏，所以我又另外用一分鐘線最後是收在昨日收盤價之上與否，來決定是否把那一分鐘的成交量納入累積的盤上成交量，根據這個原則，寫了另一個自訂指標腳本如下

array: x\[240\](0);

var:i(0);

for i=1 to 240

begin

if GetField("收盤價","1")\[i-1\]\>close\[1\]

then 

x\[i\]=GetField("成交量","1")\[i-1\]

else

x\[i\]=0;

end;

value1=array\_sum(x,1,240);

if volume\<\>0

then 

value2=value1/volume;

value3=average(value2,5);

plot1(value3);

---

## 場景 856：有沒有多空都能賺錢的交易策略?? — 於是，我寫了一個腳本如下: 用0050及00632R這兩檔ETF去跑

來源：[有沒有多空都能賺錢的交易策略??](https://www.xq.com.tw/xstrader/%e6%9c%89%e6%b2%92%e6%9c%89%e5%a4%9a%e7%a9%ba%e9%83%bd%e8%83%bd%e8%b3%ba%e9%8c%a2%e7%9a%84%e4%ba%a4%e6%98%93%e7%ad%96%e7%95%a5/) 說明：於是，我寫了一個腳本如下: 用0050及00632R這兩檔ETF去跑

if symbol="0050.TW"

then begin

if average(GetSymbolField("tse.TW","收盤價"),5)

crosses over average(GetSymbolField("tse.TW","收盤價"),20)

then ret=1;

end;

if symbol="00632R.TW"

then begin

if average(GetSymbolField("tse.TW","收盤價"),5)

crosses under average(GetSymbolField("tse.TW","收盤價"),20)

then ret=1;

end;

---

## 場景 857：從大盤上漲下跌家數的變化來預測大盤未來方向 — 當我們把上市所有個股的上漲家數及下跌家數拿來設成指標時，最直接的計算方式就是把每天上漲家數與下跌家數的差值相減，計算一段區間的總和，然後把它畫成一條指標，如果要...

來源：[從大盤上漲下跌家數的變化來預測大盤未來方向](https://www.xq.com.tw/xstrader/%e5%be%9e%e5%a4%a7%e7%9b%a4%e4%b8%8a%e6%bc%b2%e4%b8%8b%e8%b7%8c%e5%ae%b6%e6%95%b8%e7%9a%84%e8%ae%8a%e5%8c%96%e4%be%86%e9%a0%90%e6%b8%ac%e5%a4%a7%e7%9b%a4%e6%9c%aa%e4%be%86%e6%96%b9%e5%90%91/) 說明：當我們把上市所有個股的上漲家數及下跌家數拿來設成指標時，最直接的計算方式就是把每天上漲家數與下跌家數的差值相減，計算一段區間的總和，然後把它畫成一條指標，如果要寫成腳本，我的寫法如下

input:period(10,"RSI計算天數");

value1=GetField("上漲家數");

value2=getfield("下跌家數");

value3=value1-value2;

value4=summation(value3,period);

plot1(value4,"上漲下跌家數差區間總和");

---

## 場景 858：從大盤上漲下跌家數的變化來預測大盤未來方向 — 處理一個每天波動較大的時間序列，要更清晰地看出他的趨勢方向，最直接的方法就是用移動平均線來作平滑，所以我們可以把上漲下跌家數差十日總和作移動平均，我寫的腳本如下...

來源：[從大盤上漲下跌家數的變化來預測大盤未來方向](https://www.xq.com.tw/xstrader/%e5%be%9e%e5%a4%a7%e7%9b%a4%e4%b8%8a%e6%bc%b2%e4%b8%8b%e8%b7%8c%e5%ae%b6%e6%95%b8%e7%9a%84%e8%ae%8a%e5%8c%96%e4%be%86%e9%a0%90%e6%b8%ac%e5%a4%a7%e7%9b%a4%e6%9c%aa%e4%be%86%e6%96%b9%e5%90%91/) 說明：處理一個每天波動較大的時間序列，要更清晰地看出他的趨勢方向，最直接的方法就是用移動平均線來作平滑，所以我們可以把上漲下跌家數差十日總和作移動平均，我寫的腳本如下:

input:period(10,"RSI計算天數");

value1=GetField("上漲家數");

value2=getfield("下跌家數");

value3=value1-value2;

value4=summation(value3,period);

value5=average(value4,5);

plot1(value5,"上漲下跌家數差區間總和移動平均");

---

## 場景 859：從大盤上漲下跌家數的變化來預測大盤未來方向 — 這個方法是取兩條不同天期的移動平均線，來看不同天期趨勢是否都已經進入到反轉的階段，畫圖的腳本如下:

來源：[從大盤上漲下跌家數的變化來預測大盤未來方向](https://www.xq.com.tw/xstrader/%e5%be%9e%e5%a4%a7%e7%9b%a4%e4%b8%8a%e6%bc%b2%e4%b8%8b%e8%b7%8c%e5%ae%b6%e6%95%b8%e7%9a%84%e8%ae%8a%e5%8c%96%e4%be%86%e9%a0%90%e6%b8%ac%e5%a4%a7%e7%9b%a4%e6%9c%aa%e4%be%86%e6%96%b9%e5%90%91/) 說明：這個方法是取兩條不同天期的移動平均線，來看不同天期趨勢是否都已經進入到反轉的階段，畫圖的腳本如下:

input:period(10,"RSI計算天數");

value1=GetField("上漲家數");

value2=getfield("下跌家數");

value3=value1-value2;

value4=summation(value3,period);

value5=average(value4,5);

value6=average(value4,20);

plot1(value5,"上漲下跌家數差區間總和短期移動平均");

plot2(value6,"上漲下跌家數差區間總和長期移動平均");

---

## 場景 860：從大盤上漲下跌家數的變化來預測大盤未來方向 — 以上面的例子，我們可以把腳本改成下面的寫法

來源：[從大盤上漲下跌家數的變化來預測大盤未來方向](https://www.xq.com.tw/xstrader/%e5%be%9e%e5%a4%a7%e7%9b%a4%e4%b8%8a%e6%bc%b2%e4%b8%8b%e8%b7%8c%e5%ae%b6%e6%95%b8%e7%9a%84%e8%ae%8a%e5%8c%96%e4%be%86%e9%a0%90%e6%b8%ac%e5%a4%a7%e7%9b%a4%e6%9c%aa%e4%be%86%e6%96%b9%e5%90%91/) 說明：以上面的例子，我們可以把腳本改成下面的寫法

input:period(10,"RSI計算天數");

value1=GetField("上漲家數");

value2=getfield("下跌家數");

value3=value1-value2;

value4=summation(value3,period);

value5=average(value4,5);

value6=average(value4,20);

value7=value5-value6;

plot1(value7,"上漲下跌家數差區間總和長短天均線差");

---

## 場景 861：從大盤上漲下跌家數的變化來預測大盤未來方向 — 以上面的序列來說，我們也可以改寫成以下的腳本

來源：[從大盤上漲下跌家數的變化來預測大盤未來方向](https://www.xq.com.tw/xstrader/%e5%be%9e%e5%a4%a7%e7%9b%a4%e4%b8%8a%e6%bc%b2%e4%b8%8b%e8%b7%8c%e5%ae%b6%e6%95%b8%e7%9a%84%e8%ae%8a%e5%8c%96%e4%be%86%e9%a0%90%e6%b8%ac%e5%a4%a7%e7%9b%a4%e6%9c%aa%e4%be%86%e6%96%b9%e5%90%91/) 說明：以上面的序列來說，我們也可以改寫成以下的腳本

input:period(10,"RSI計算天數");

value1=GetField("上漲家數");

value2=getfield("下跌家數");

value3=value1-value2;

value4=summation(value3,period);

value5=rsi(value4,period); 

plot1(value5,"上漲下跌家數差區間總和RSI");

---

## 場景 862：從大盤上漲下跌家數的變化來預測大盤未來方向 — 要畫出上圖的腳本則如下

來源：[從大盤上漲下跌家數的變化來預測大盤未來方向](https://www.xq.com.tw/xstrader/%e5%be%9e%e5%a4%a7%e7%9b%a4%e4%b8%8a%e6%bc%b2%e4%b8%8b%e8%b7%8c%e5%ae%b6%e6%95%b8%e7%9a%84%e8%ae%8a%e5%8c%96%e4%be%86%e9%a0%90%e6%b8%ac%e5%a4%a7%e7%9b%a4%e6%9c%aa%e4%be%86%e6%96%b9%e5%90%91/) 說明：要畫出上圖的腳本則如下

input:period(10,"RSI計算天數");

value1=GetField("上漲家數");

value2=getfield("下跌家數");

value3=value1-value2;

value4=summation(value3,period);

value5=bollingerband(value4,20,2);

value6=bollingerband(value4,20,-2);

plot1(value4,"上漲下跌家數差區間總和BBand");

plot2(value5);

plot3(value6);

---

## 場景 863：一個觀察大戶在進貨還是出貨的指標 — 計算每筆成交金額的腳本可以像下面這麼寫

來源：[一個觀察大戶在進貨還是出貨的指標](https://www.xq.com.tw/xstrader/%e4%b8%80%e5%80%8b%e8%a7%80%e5%af%9f%e5%a4%a7%e6%88%b6%e5%9c%a8%e9%80%b2%e8%b2%a8%e9%82%84%e6%98%af%e5%87%ba%e8%b2%a8%e7%9a%84%e6%8c%87%e6%a8%99/) 說明：計算每筆成交金額的腳本可以像下面這麼寫

var:cp(0);

var:count(0);

count=0;

value1=GetField("總成交次數","D");

value2=GetField("成交金額");

if value1\<\>0

then value3=value2/value1

else

value3=0;

plot1(average(value3,5));

---

## 場景 864：一個觀察大戶在進貨還是出貨的指標 — 我們會發現，當每筆成交金額異於平常且股價表現也異於平常時，往往是大戶進場的癥兆，為了抓到這樣的機會，我寫了一個腳本如下:

來源：[一個觀察大戶在進貨還是出貨的指標](https://www.xq.com.tw/xstrader/%e4%b8%80%e5%80%8b%e8%a7%80%e5%af%9f%e5%a4%a7%e6%88%b6%e5%9c%a8%e9%80%b2%e8%b2%a8%e9%82%84%e6%98%af%e5%87%ba%e8%b2%a8%e7%9a%84%e6%8c%87%e6%a8%99/) 說明：我們會發現，當每筆成交金額異於平常且股價表現也異於平常時，往往是大戶進場的癥兆，為了抓到這樣的機會，我寫了一個腳本如下:

input:length(20);

variable:up1(0),down1(0),mid1(0),bbandwidth(0);

up1 \= bollingerband(Close, Length, 1);

var:cp(0);

var:count(0);

count=0;

value1=GetField("總成交次數","D");

value2=GetField("成交金額");

if value1\<\>0

then value3=value2/value1

else

value3=0;

value4=close-open;

value5=average(value3,3)\*average(value4,3);

value6=bollingerband(value5,20,2);

if getsymbolfield("tse.tw","收盤價")

\>average(getsymbolfield("tse.tw","收盤價"),10)

then begin

if close cross over up1

and value5 cross over value6

and close\<close\[10\]\*1.1

then ret=1;

end;

---

## 場景 865：開高後不拉回的中小型股 — 我寫了一個日線的腳本來尋找有上述情況的股票

來源：[開高後不拉回的中小型股](https://www.xq.com.tw/xstrader/%e9%96%8b%e9%ab%98%e5%be%8c%e4%b8%8d%e6%8b%89%e5%9b%9e%e7%9a%84%e4%b8%ad%e5%b0%8f%e5%9e%8b%e8%82%a1-2/) 說明：我寫了一個日線的腳本來尋找有上述情況的股票

input:sp(2,"回檔最大幅度");

input:opl(2,"開高最小幅度");

input:oph(4,"開高最大幅度");

 

if open\>=close\[1\]\*(1+opl/100)

 and close\<=close\[1\]\*(1+oph/100)

 and low\>open\*(1-sp/100)

 and close=high

 and close\[1\]\<close\[3\]\*1.04//前三天漲幅不到4%

and GetSymbolField("tse.tw","收盤價","D")

\>average(GetSymbolField("tse.tw","收盤價","D"),10)

and volume\>average(volume,20)\*1.2

then ret=1 ;

---

## 場景 866：私房版 台灣50的領先指標 — 如下面的腳本來描述上述的步驟

來源：[私房版 台灣50的領先指標](https://www.xq.com.tw/xstrader/%e7%a7%81%e6%88%bf%e7%89%88-%e5%8f%b0%e7%81%a350%e7%9a%84%e9%a0%98%e5%85%88%e6%8c%87%e6%a8%99/) 說明：如下面的腳本來描述上述的步驟

array:T50\[50\](0);

t50\[1\]=GetSymbolField("1101.tw","收盤價");

t50\[2\]=GetSymbolField("1102.tw","收盤價");

t50\[3\]=GetSymbolField("1216.tw","收盤價");

t50\[4\]=GetSymbolField("1301.tw","收盤價");

t50\[5\]=GetSymbolField("1303.tw","收盤價");

t50\[6\]=GetSymbolField("1326.tw","收盤價");

t50\[7\]=GetSymbolField("1402.tw","收盤價");

t50\[8\]=GetSymbolField("2002.tw","收盤價");

t50\[9\]=GetSymbolField("2105.tw","收盤價");

t50\[10\]=GetSymbolField("2207.tw","收盤價");

t50\[11\]=GetSymbolField("2301.tw","收盤價");

t50\[12\]=GetSymbolField("2303.tw","收盤價");

t50\[13\]=GetSymbolField("2308.tw","收盤價");

t50\[14\]=GetSymbolField("2311.tw","收盤價");

t50\[15\]=GetSymbolField("2317.tw","收盤價");

t50\[16\]=GetSymbolField("2324.tw","收盤價");

t50\[17\]=GetSymbolField("2325.tw","收盤價");

t50\[18\]=GetSymbolField("2330.tw","收盤價");

t50\[19\]=GetSymbolField("2354.tw","收盤價");

t50\[20\]=GetSymbolField("2357.tw","收盤價");

t50\[21\]=GetSymbolField("2382.tw","收盤價");

t50\[22\]=GetSymbolField("2395.tw","收盤價");

t50\[23\]=GetSymbolField("2408.tw","收盤價");

t50\[24\]=GetSymbolField("2409.tw","收盤價");

t50\[25\]=GetSymbolField("2412.tw","收盤價");

t50\[26\]=GetSymbolField("2454.tw","收盤價");

t50\[27\]=GetSymbolField("2474.tw","收盤價");

t50\[28\]=GetSymbolField("2633.tw","收盤價");

t50\[29\]=GetSymbolField("2801.tw","收盤價");

t50\[30\]=GetSymbolField("2823.tw","收盤價");

t50\[31\]=GetSymbolField("2880.tw","收盤價");

t50\[32\]=GetSymbolField("2881.tw","收盤價");

t50\[33\]=GetSymbolField("2882.tw","收盤價");

t50\[34\]=GetSymbolField("2883.tw","收盤價");

t50\[35\]=GetSymbolField("2884.tw","收盤價");

t50\[36\]=GetSymbolField("2885.tw","收盤價");

t50\[37\]=GetSymbolField("2886.tw","收盤價");

t50\[38\]=GetSymbolField("2887.tw","收盤價");

t50\[39\]=GetSymbolField("2890.tw","收盤價");

t50\[40\]=GetSymbolField("2891.tw","收盤價");

t50\[41\]=GetSymbolField("2892.tw","收盤價");

t50\[42\]=GetSymbolField("2912.tw","收盤價");

t50\[43\]=GetSymbolField("3008.tw","收盤價");

t50\[44\]=GetSymbolField("3045.tw","收盤價");

t50\[45\]=GetSymbolField("3481.tw","收盤價");

t50\[46\]=GetSymbolField("4904.tw","收盤價");

t50\[47\]=GetSymbolField("4938.tw","收盤價");

t50\[48\]=GetSymbolField("5880.tw","收盤價");

t50\[49\]=GetSymbolField("6505.tw","收盤價");

t50\[50\]=GetSymbolField("9904.tw","收盤價");

 

var:count(0),i(0);

count=0;

for i=1 to 50

begin

if average(t50\[i\],5)\>average(t50\[i\],20)

then count=count+1;

end;

plot1(count);

plot2(40);

plot3(10);

---

## 場景 867：多空趨勢指標 — 根據這樣的分類，我寫了一個自訂指標的腳本，計算每檔商品的多空力道差距及多頭與空頭各自力量的消長。

來源：[多空趨勢指標](https://www.xq.com.tw/xstrader/%e9%9b%99k%e6%a3%92%e5%8f%af%e4%bb%a5%e5%bb%b6%e4%bc%b8%e7%9a%84%e5%a4%9a%e7%a9%ba%e8%b6%a8%e5%8b%a2%e6%8c%87%e6%a8%99/) 說明：根據這樣的分類，我寫了一個自訂指標的腳本，計算每檔商品的多空力道差距及多頭與空頭各自力量的消長。

array:k\[22\](0);

if close\<\>0

then begin

//最近一日與前一日的多空力道總差額

k\[1\]=(open-open\[1\])/close;

k\[2\]=(high-high\[1\])/close;

k\[3\]=(low-low\[1\])/close;

k\[4\]=(close-close\[1\])/close;

//當日

k\[6\]=(high-close)/close;

k\[7\]=(high-open)/close;

k\[8\]=(open-low)/close;

k\[9\]=(close-open)/close;

k\[10\]=(close-low)/close;

k\[11\]=(open-high\[1\])/close;

k\[12\]=(open-low\[1\])/close;

k\[13\]=(open-close\[1\])/close;

k\[14\]=(high-open\[1\])/close;

k\[15\]=(high-low\[1\])/close;

k\[16\]=(high-close\[1\])/close;

k\[17\]=(low-open\[1\])/close;

k\[18\]=(low-high\[1\])/close;

k\[19\]=(low-close\[1\])/close;

k\[20\]=(close-open\[1\])/close;

k\[21\]=(close-high\[1\])/close;

k\[22\]=(close-low\[1\])/close;

end;

array: v1\[8\](0);

v1\[1\]=k\[1\]+k\[11\]+k\[12\]+k\[13\];//隔日開盤多空總力道

v1\[2\]=k\[1\]+k\[2\]+k\[3\]+k\[4\];//隔日多空總力道

v1\[3\]=k\[20\]+k\[21\]+k\[22\];//隔日收盤多空結果

v1\[4\]=k\[9\]+k\[10\]-k\[6\];//當日收盤多空結果

v1\[5\]=k\[14\]+k\[15\]+k\[16\];//多頭最大力量

v1\[6\]=(k\[17\]+k\[18\]+k\[19\])\*-1;//空頭最大力量

v1\[7\]=k\[7\]+k\[9\]+k\[10\];//當日多頭最大力量

v1\[8\]=k\[6\]+k\[8\]-k\[10\];//當日空頭最大力量

value1=v1\[1\]+v1\[2\]+v1\[3\]+v1\[4\];

value2=v1\[5\]+v1\[7\];

value3=v1\[6\]+v1\[8\];

plot1(average(value1,5),"多空淨力");

plot2(average(value2,5),"多頭總力");

plot3(average(value3,5),"空頭總力");

---

## 場景 868：把股性拿來作為過濾條件 — 我試著用計分卡的方式寫了一個衡量股性的腳本如下:

來源：[把股性拿來作為過濾條件](https://www.xq.com.tw/xstrader/%e6%8a%8a%e8%82%a1%e6%80%a7%e6%8b%bf%e4%be%86%e4%bd%9c%e7%82%ba%e9%81%8e%e6%bf%be%e6%a2%9d%e4%bb%b6/) 說明：我試著用計分卡的方式寫了一個衡量股性的腳本如下:

input:day(20);

input:ratio(10);

var:count(0),x(0);

value1=GetField("總成交次數","D");

value2=average(value1,day);

value3=GetField("強弱指標");

value5=GetField("外盤均量");

value6=average(value5,day);

value7=GetField("主動買力");

value8=average(value7,day);

value9=GetField("開盤委買");

value10=average(value9,day);

value11=GetField("資金流向");

value13=countif(value3\>1,day);

value14=average(value13,day);//比大盤強天數

value16=GetField("法人買張");

count=0;

if value1\>value2\*(1+ratio/100)

then count=count+1;

if value13\>value14\*(1+ratio/100)//比大盤強的天數

then count=count+1;

if value5\>value6\*(1+ratio/100)

then count=count+1;

if value7\>value8\*(1+ratio/100)

then count=count+1;

if value9\>value10\*(1+ratio/100)

then count=count+1;

if truerange\> average(truerange,20)//真實波動區間

then count=count+1;

if truerange\<\>0

then begin

if close\<=open

then

value15=(close-low)/truerange\*100

else

value15=(open-low)/truerange\*100;//計算承接的力道

end;

if value15\>average(value15,day)\*(1+ratio/100)

then count=count+1;

if volume\<\>0

then value17=value16/volume\*100;//法人買張佔成交量比例

if value17\>average(value17,10)\*(1+ratio/100)

then count=count+1;

if value11\>average(value11,10)\*(1+ratio/100)

then count=count+1;

x=0;

value18=summationif(close\>=close\[1\]\*1.02,x,5);

if value18\>=2 

then count=count+1;//N日來漲幅較大的天數

value19=GetField("融資買進張數");

value20=GetField("融券買進張數");

value21=(value19+value20);

value22=average(value21,day);

if value21\<value22\*0.9 //散戶作多指標

then count=count+1;

plot1(average(count,3),"股性綜合分數指標");

plot2(average(count,day),"移動平均");

---

## 場景 869：高現金股利低本益比且本業仍不差 — 寫了一個選股腳本如下：

來源：[高現金股利低本益比且本業仍不差](https://www.xq.com.tw/xstrader/%e9%ab%98%e7%8f%be%e9%87%91%e8%82%a1%e5%88%a9%e4%bd%8e%e6%9c%ac%e7%9b%8a%e6%af%94%e4%b8%94%e6%9c%ac%e6%a5%ad%e4%bb%8d%e4%b8%8d%e5%b7%ae/) 說明：寫了一個選股腳本如下：

input:peratio(17,"本益比上限倍數");

input:ratio(60,"現金股利佔股利之比重下限");

input:epsl(2,"預估本業EPS下限");

input:rate1(5,"累計營收成長率下限");

 

value1=GetField("累計營收年增率","M");//單位%

value2=GetField("現金股利佔股利比重","Y");

value3=GetField("營業利益","Q");//單位百萬;

value4=GetField("最新股本");//單位億;

value5=summation(value3,4)/(value4\*10);//每股預估EPS

if

value1\>rate1//本業持續成長

and 

value2\>ratio//主要以現金股利為主

and

value5\>EPSl//每股推估本業獲利高

and 

close/value5\<peratio//本益比低

then ret=1;

---

## 場景 870：sector trade(類股輪動操作法)初體驗 — 我從這433檔股票中，挑出18檔股票，這些股票分別是其所屬產業中的龍頭股，然後請了公司的高手高手高高手寫了以下的指標

來源：[sector trade(類股輪動操作法)初體驗](https://www.xq.com.tw/xstrader/sector-trade%e9%a1%9e%e8%82%a1%e8%bc%aa%e5%8b%95%e6%93%8d%e4%bd%9c%e6%b3%95%e5%88%9d%e9%ab%94%e9%a9%97/) 說明：我從這433檔股票中，挑出18檔股票，這些股票分別是其所屬產業中的龍頭股，然後請了公司的高手高手高高手寫了以下的指標

input: Length(20); SetInputName(1, "布林通道天數");

input: BandRange(2);SetInputName(2, "上下寬度");

input: MALength(10);SetInputName(3, "MA天期");

array:

ValueArray\[18\](0),

ratioarray\[18\](0),

uparray\[18\](0),

dnarray\[18\](0);

var:x(0);

var:si(0);// 商品所在的產業

if symbol="1101.TW" then si=1;

if symbol="1305.TW" then si=2;

if symbol="1452.TW" then si=3;

if symbol="1536.TW" then si=4;

if symbol="1460.TW" then si=5;

if symbol="1476.TW" then si=6;

if symbol="6269.TW" then si=7;

if symbol="2031.TW" then si=8;

if symbol="2014.TW" then si=9;

if symbol="2393.TW" then si=10;

if symbol="2615.TW" then si=11;

if symbol="2409.TW" then si=12;

if symbol="2882.TW" then si=13;

if symbol="6005.TW" then si=14;

if symbol="2606.TW" then si=15;

if symbol="3044.TW" then si=16;

if symbol="6244.TW" then si=17;

if symbol="9914.TW" then si=18;

if si \= 0 then return;

valuearray\[1\]=GetSymbolField("I011010.TW","收盤價");//水泥

valuearray\[2\]=GetSymbolField("I013010.TW","收盤價");//塑化原料

valuearray\[3\]=GetSymbolField("I014010.TW","收盤價");//加工絲

valuearray\[4\]=GetSymbolField("I022020.TW","收盤價");//汽車零組件

valuearray\[5\]=GetSymbolField("I014040.TW","收盤價");//織布

valuearray\[6\]=GetSymbolField("I014030.TW","收盤價");//成衣

valuearray\[7\]=GetSymbolField("I023320.TW","收盤價");//軟板

valuearray\[8\]=GetSymbolField("I020010.TW","收盤價");//不銹鋼

valuearray\[9\]=GetSymbolField("I020020.TW","收盤價");//平板鋼

valuearray\[10\]=GetSymbolField("I023060.TW","收盤價");//LED

valuearray\[11\]=GetSymbolField("I026020.TW","收盤價");//貨櫃航運

valuearray\[12\]=GetSymbolField("I023080.TW","收盤價");//面板

valuearray\[13\]=GetSymbolField("I028010.TW","收盤價");//金控

valuearray\[14\]=GetSymbolField("I028030.TW","收盤價");//證券

valuearray\[15\]=GetSymbolField("I026030.TW","收盤價");//散裝航運

valuearray\[16\]=GetSymbolField("I023230.TW","收盤價");//印刷電路板

valuearray\[17\]=GetSymbolField("I023130.TW","收盤價");//太陽能

valuearray\[18\]=GetSymbolField("I099040.TW","收盤價");//自行車

value1=GetSymbolField("TSE.TW","收盤價");

ratioarray\[si\]=valuearray\[si\]/value1;

uparray\[si\]=bollingerband(ratioarray\[si\],length,bandrange);

dnarray\[si\]=bollingerband(ratioarray\[si\],length,-1\*bandrange);

plot1(uparray\[si\], "UB");

plot2(dnarray\[si\], "DB");

plot3(ratioarray\[si\], "Ratio");

if ratioarray\[si\] cross over uparray\[si\] then

plot4(1, "穿越")

else

noplot(4);

---

## 場景 871：由市場老手的交易秘訣所衍生出來的交易策略(一) — 符合以上三個條件的腳本寫法如下:

來源：[由市場老手的交易秘訣所衍生出來的交易策略(一)](https://www.xq.com.tw/xstrader/%e7%94%b1%e5%b8%82%e5%a0%b4%e8%80%81%e6%89%8b%e7%9a%84%e4%ba%a4%e6%98%93%e7%a7%98%e8%a8%a3%e6%89%80%e8%a1%8d%e7%94%9f%e5%87%ba%e4%be%86%e7%9a%84%e4%ba%a4%e6%98%93%e7%ad%96%e7%95%a5%e4%b8%80/) 說明：符合以上三個條件的腳本寫法如下:

value1=GetSymbolField("TSE.TW","收盤價")/close;

if value1\<\>0

then value1=1/value1;

input: Length(20); SetInputName(1, "布林通道天數");

input: BandRange(2);SetInputName(2, "上下寬度");

variable: up(0), down(0), mid(0);

up \= bollingerband(value1, Length, BandRange);

if value1 cross over up 

and average(GetSymbolField("TSE.TW","收盤價"),5)\>

average(GetSymbolField("TSE.TW","收盤價"),20)

and close\<close\[2\]\*1.07

then ret=1;

---

## 場景 872：多空交易(long-short trading) — 根據上述的精神，我寫了一個畫圖的腳本如下:

來源：[多空交易(long-short trading)](https://www.xq.com.tw/xstrader/%e5%a4%9a%e7%a9%ba%e4%ba%a4%e6%98%93long-short-trading/) 說明：根據上述的精神，我寫了一個畫圖的腳本如下:

input:period1(4,"短期別");

input:period2(12,"長期別");

setbackbar(12);

settotalbar(600);

value1=GetSymbolField("2303.tw","總市值");

value2=GetField("總市值");

value3=value1/value2;

value4=average(value3,period1);

value5=average(value3,period2);

plot1(value4);

plot2(value5);

---

## 場景 873：報復性反彈 — 根據這兩個特徵，我使用XS即將上線的跨頻率語法，寫了一個用月線RSI找超跌，用日線找短線轉強的股票，腳本如下:

來源：[報復性反彈](https://www.xq.com.tw/xstrader/%e5%a0%b1%e5%be%a9%e6%80%a7%e5%8f%8d%e5%bd%88/) 說明：根據這兩個特徵，我使用XS即將上線的跨頻率語法，寫了一個用月線RSI找超跌，用日線找短線轉強的股票，腳本如下:

//先來找出月線RSI小於5的股票

input:period(6,"RSI期別");

var:x(0),up(0),down(0);

up=0;

down=0;

for x=0 to period-1

begin

if GetField("收盤價","AM")\[x\]\>GetField("收盤價","AM")\[x+1\]

//取得還原月線的收盤價 並計算RSI

then

up=up+GetField("收盤價","AM")\[x\]-GetField("收盤價","AM")\[x+1\]

else

down=down+GetField("收盤價","AM")\[x+1\]-GetField("收盤價","AM")\[x\];

end;

value1=up/(up+down)\*100;

value2=GetField("資金流向");

value3=GetField("強弱指標","D");

if value1\<=25

then begin

if countif(value3\>0,5)\>=4

or countif(value2-value2\[1\]\>0,5)\>=3

or countif(close\>=close\[1\]\*1.04,3)\>=1

then ret=1;

end;

---

## 場景 874：魚骨圖在投資決策上的實踐方式 — 所以我就試著以魚骨圖的方式，列出要符合上述三個特徵，它們各別的要素是什麼，然後把這些要素寫成腳本

來源：[魚骨圖在投資決策上的實踐方式](https://www.xq.com.tw/xstrader/%e9%ad%9a%e9%aa%a8%e5%9c%96%e5%9c%a8%e6%8a%95%e8%b3%87%e6%b1%ba%e7%ad%96%e4%b8%8a%e7%9a%84%e5%af%a6%e8%b8%90%e6%96%b9%e5%bc%8f/) 說明：所以我就試著以魚骨圖的方式，列出要符合上述三個特徵，它們各別的要素是什麼，然後把這些要素寫成腳本

//先準備需要被拿來運算的資料

value1=GetField("法人買賣超張數");

value2=GetField("主力買賣超張數");

value3=GetField("融券增減張數");

value4=q\_BoughtLotsAtOpen;//開盤委買張數

value5=q\_SoldLotsAtOpen;//開盤委賣張數

//先宣告魚骨圖的魚骨數並先為false

condition1=false;

condition2=false;

condition3=false;

//描述魚骨在什麼情況下由false變成true

if value1\[1\]\>0 and value2\[1\]\>0 and value3\[1\]\>0 

then condition1=true; //符合籌碼穩定的條件

//===============MACD \=================================

input: FastLength(12,"DIF短期期數"), SlowLength(26,"DIF長期期數");

input: MACDLength(9,"MACD期數");

variable: difValue(0), macdValue(0), oscValue(0);

MACD(weightedclose(), FastLength, SlowLength, MACDLength, difValue, macdValue, oscValue);

if oscValue \> 0 and average(close,5)\>average(close,20)

then condition2=true; //符合上昇趨勢的條件

if open \> close\[1\]\*1.015 and value4\>highest(value4\[1\],20) or value4-value5\>200

then condition3=true; //符合開盤走強

if condition1 and condition2 and condition3

then ret=1;

---

## 場景 875：檢查表在程式交易上的呈現方式 — 根據這樣的想法，我把check list的精神，轉換成程式碼，由於check list的意義在於每一個項目都要符合，所以我很簡單地用and來串連每一個條件式，下...

來源：[檢查表在程式交易上的呈現方式](https://www.xq.com.tw/xstrader/%e6%aa%a2%e6%9f%a5%e8%a1%a8%e5%9c%a8%e7%a8%8b%e5%bc%8f%e4%ba%a4%e6%98%93%e4%b8%8a%e7%9a%84%e5%91%88%e7%8f%be%e6%96%b9%e5%bc%8f/) 說明：根據這樣的想法，我把check list的精神，轉換成程式碼，由於check list的意義在於每一個項目都要符合，所以我很簡單地用and來串連每一個條件式，下面就是上述檢查表的對應程式碼

//先準備需要被拿來運算的資料

value1=GetField("法人買賣超張數","D");

value2=GetField("佔大盤成交量比","D");

value4=GetField("董監持股佔股本比例","D");

value5=GetField("外資持股比例","D");

value6=GetField("買家數","D");

value7=GetField("賣家數","D");

value8=GetField("股價淨值比","D");

value9=GetField("本益比","D");

//設計檢查表的規則

if average(value2,5)\>average(value2,10)//成交量溫和放大

and average(value1,3)\>0 //法人沒有站在賣方

and value4+value4\>30 //籌碼集中

and average(value7,3)\>average(value6,3)\*1.03//籌碼是集中不是發散

and average(close,5) \>average(close,10)//均線多頭排列

and close\>close\[1\]\*1.02//最近一天夠強

and close\[5\]\< close\*1.15//短期漲幅不算大

and value8\<3//PB沒有太高

and value9\<20//本益比不致於不合理

then ret=1;

---

## 場景 876：決策樹在程式交易上的應用 — 根據上述的思考，我把它改寫成以下的腳本:

來源：[決策樹在程式交易上的應用](https://www.xq.com.tw/xstrader/%e6%b1%ba%e7%ad%96%e6%a8%b9%e5%9c%a8%e7%a8%8b%e5%bc%8f%e4%ba%a4%e6%98%93%e4%b8%8a%e7%9a%84%e6%87%89%e7%94%a8/) 說明：根據上述的思考，我把它改寫成以下的腳本:

value1=q\_CurrentCapitalin100Million;//股本:單位億元

value2=q\_GrossMarginRate;//毛利率

value3=GetField("資金流向");

value4=GetField("強弱指標");

value5=GetField("投信買賣超");

value6=q\_RevenueYoY;//營收年增率

value7=q\_RevenueGrowth;//營收月增率

if value1\<50//股本小於50億

then begin

if value6\>9 //營收年增率兩位數成長

or value7\>9//營收月增率兩位數成長

or value2\>value2\[1\]//毛利率成長

then begin

if value4\>0//比大盤強

and value3\>average(value3,10)//資金淨入

then begin

if close\>close\[1\]\*1.02//K棒中長紅

then begin

if volume\>1000//成交量大於1000張

then begin

if close=high//創盤中新高

then ret=1;

end;

end;

end;

end;

end;

---

## 場景 877：Q指標

來源：[Q指標](https://www.xq.com.tw/xstrader/%e8%87%aa%e8%a8%82%e6%8c%87%e6%a8%99%e7%9a%84%e6%92%b0%e5%af%ab%e6%8a%80%e5%b7%a7%e4%bb%a5q%e6%8c%87%e6%a8%99%e7%82%ba%e4%be%8b/) 說明：它的計算方式如下:

input:t1(10,"計算累積價格變動的bar數");

value1=close-close\[1\];//價格變化

value2=summation(value1,t1);//累積價格變化

plot1(value2,"累積價格變化");

---

## 場景 878：Q指標 — 這時候我們最常運用的，就是長短天期移動平均線的方式，以上述的CPC指標為例，我們可以把上述的腳本改成以下的樣子

來源：[Q指標](https://www.xq.com.tw/xstrader/%e8%87%aa%e8%a8%82%e6%8c%87%e6%a8%99%e7%9a%84%e6%92%b0%e5%af%ab%e6%8a%80%e5%b7%a7%e4%bb%a5q%e6%8c%87%e6%a8%99%e7%82%ba%e4%be%8b/) 說明：這時候我們最常運用的，就是長短天期移動平均線的方式，以上述的CPC指標為例，我們可以把上述的腳本改成以下的樣子

input:t1(10,"計算累積價格變動的bar數");

input:t2(5,"短期平均天期");

input:t3(10,"長期平均天期");

value1=close-close\[1\];//價格變化

value2=summation(value1,t1);//累積價格變化

value3=average(value2,t2);//短期平均

value4=average(value2,t3);//長期平均

plot1(value3,"短期累積價格變化平均");

plot2(value4,"長期累積價格變化平均");

---

## 場景 879：Q指標 — 例如上圖，我們只要再加下面這一行

來源：[Q指標](https://www.xq.com.tw/xstrader/%e8%87%aa%e8%a8%82%e6%8c%87%e6%a8%99%e7%9a%84%e6%92%b0%e5%af%ab%e6%8a%80%e5%b7%a7%e4%bb%a5q%e6%8c%87%e6%a8%99%e7%82%ba%e4%be%8b/) 說明：例如上圖，我們只要再加下面這一行

plot3(value3-value4,"短期減長期");

---

## 場景 880：Q指標

來源：[Q指標](https://www.xq.com.tw/xstrader/%e8%87%aa%e8%a8%82%e6%8c%87%e6%a8%99%e7%9a%84%e6%92%b0%e5%af%ab%e6%8a%80%e5%b7%a7%e4%bb%a5q%e6%8c%87%e6%a8%99%e7%82%ba%e4%be%8b/) 說明：它的腳本如下:

input:t1(10,"計算累積價格變動的bar數");

input:t2(5,"計算價格累積變化量移動平均的期別");

input:t3(20,"計算雜訊的移動平均期別");

value1=close-close\[1\];//價格變化

value2=summation(value1,t1);//累積價格變化

value3=average(value2,t2);

value4=absvalue(value2-value3);//雜訊

value5=average(value4,t3);//把雜訊移動平均

variable:Qindicator(0);

if value5=0

then Qindicator=0

else

Qindicator=value3/value5\*5;

plot1(Qindicator,"趨勢值");

---

## 場景 881：那些公司可以放到觀察名單中？

來源：[那些公司可以放到觀察名單中？](https://www.xq.com.tw/xstrader/%e9%82%a3%e4%ba%9b%e5%85%ac%e5%8f%b8%e5%8f%af%e4%bb%a5%e6%94%be%e5%88%b0%e8%a7%80%e5%af%9f%e5%90%8d%e5%96%ae%e4%b8%ad%ef%bc%9f/) 說明：參考腳本如下：

value1=GetField("營業收入淨額","Y");

value2=value1-value1\[1\];

if countif(value2\>0,5)\>=3

then ret=1;

---

## 場景 882：那些公司可以放到觀察名單中？ — 二，過去三年來自營運的現金流量都大於零

來源：[那些公司可以放到觀察名單中？](https://www.xq.com.tw/xstrader/%e9%82%a3%e4%ba%9b%e5%85%ac%e5%8f%b8%e5%8f%af%e4%bb%a5%e6%94%be%e5%88%b0%e8%a7%80%e5%af%9f%e5%90%8d%e5%96%ae%e4%b8%ad%ef%bc%9f/) 說明：二，過去三年來自營運的現金流量都大於零

value1=GetField("來自營運之現金流量","Y");

if trueall(value1\>0,3)

then ret=1;

---

## 場景 883：那些公司可以放到觀察名單中？ — 三，資產報酬率達到一定的水準且沒有明顯下滑

來源：[那些公司可以放到觀察名單中？](https://www.xq.com.tw/xstrader/%e9%82%a3%e4%ba%9b%e5%85%ac%e5%8f%b8%e5%8f%af%e4%bb%a5%e6%94%be%e5%88%b0%e8%a7%80%e5%af%9f%e5%90%8d%e5%96%ae%e4%b8%ad%ef%bc%9f/) 說明：三，資產報酬率達到一定的水準且沒有明顯下滑

value1=GetField("資產報酬率","Q");

value2=average(value1,4);

value3=linearregslope(value2,5);

if value3\>0

then ret=1;

---

## 場景 884：夏季限定版選股\~旺季來臨前的選股腳本 — 根據這樣的時序結構，如果我們要以最近公佈的月營收公佈月份為基準，找出過去三年裡，未來三個月營收平均比過去三個月營收平均增加超過25%的股票，我們可以寫成以下的腳...

來源：[夏季限定版選股\~旺季來臨前的選股腳本](https://www.xq.com.tw/xstrader/%e5%a4%8f%e5%ad%a3%e9%99%90%e5%ae%9a%e7%89%88%e9%81%b8%e8%82%a1%e6%97%ba%e5%ad%a3%e4%be%86%e8%87%a8%e5%89%8d%e7%9a%84%e9%81%b8%e8%82%a1%e8%85%b3%e6%9c%ac/) 說明：根據這樣的時序結構，如果我們要以最近公佈的月營收公佈月份為基準，找出過去三年裡，未來三個月營收平均比過去三個月營收平均增加超過25%的股票，我們可以寫成以下的腳本

value1=GetField("月營收","M");//單位:億元

variable:W1(0),W2(0),W3(0),F1(0),F2(0),F3(0);

setbarfreq("M");

settotalbar(39);

W1=(value1\[12\]+value1\[13\]+value1\[14\])/3;

W2=(value1\[24\]+value1\[25\]+value1\[26\])/3;

W3=(value1\[36\]+value1\[37\]+value1\[38\])/3;

 

F1=(value1\[11\]+value1\[10\]+value1\[9\])/3;

F2=(value1\[23\]+value1\[22\]+value1\[21\])/3;

F3=(value1\[35\]+value1\[34\]+value1\[33\])/3;

 

if F1\>=W1\*1.25 and F2\>=W2\*1.25 and F3\>=W3\*1.25

then ret=1;

---

## 場景 885：大盤不錯才Trade，大盤不好別逆勢作多\~兼談跨商品的語法

來源：[大盤不錯才Trade，大盤不好別逆勢作多\~兼談跨商品的語法](https://www.xq.com.tw/xstrader/%e5%a4%a7%e7%9b%a4%e4%b8%8d%e9%8c%af%e6%89%8dtrade%ef%bc%8c%e5%a4%a7%e7%9b%a4%e4%b8%8d%e5%a5%bd%e5%88%a5%e9%80%86%e5%8b%a2%e4%bd%9c%e5%a4%9a%e5%85%bc%e8%ab%87%e8%b7%a8%e5%95%86%e5%93%81%e7%9a%84/) 說明：請看下面這個腳本

condition1=false;

condition2=false;

if momentum(close,10)cross over 0

then condition1=true;

value1=getsymbolfield("tse.tw","close","d");

if value1\>average(value1,20)

then condition2=true;

if condition1 and condition2

then ret=1;

---

## 場景 886：年收股息上百萬的定存股怎麼找？怎麼操作? — 其中的股息配發率超過一定比率，是我自己寫的選股腳本，腳本如下：

來源：[年收股息上百萬的定存股怎麼找？怎麼操作?](https://www.xq.com.tw/xstrader/%e5%b9%b4%e6%94%b6%e8%82%a1%e6%81%af%e4%b8%8a%e7%99%be%e8%90%ac%e7%9a%84%e5%ae%9a%e5%ad%98%e8%82%a1%e6%80%8e%e9%ba%bc%e6%89%be%ef%bc%9f%e6%80%8e%e9%ba%bc%e6%93%8d%e4%bd%9c/) 說明：其中的股息配發率超過一定比率，是我自己寫的選股腳本，腳本如下：

input:ratio(60,"股息配發率%");

value1=GetField("每股稅後淨利(元)","Y");

value2=GetField("現金股利","Y");

if value1\>0

then value3=value2/value1\*100;//股息配發率

if trueall(value3\>ratio,3) then ret=1;

---

## 場景 887：3月份月營收數據公佈後的選股方向 — 這個策略是去尋找那些過去月營收年增率是走下降趨勢，但最近開始轉為上昇趨勢的公司我們用的腳本如下:

來源：[3月份月營收數據公佈後的選股方向](https://www.xq.com.tw/xstrader/3%e6%9c%88%e4%bb%bd%e6%9c%88%e7%87%9f%e6%94%b6%e6%95%b8%e6%93%9a%e5%85%ac%e4%bd%88%e5%be%8c%e7%9a%84%e9%81%b8%e8%82%a1%e6%96%b9%e5%90%91/) 說明：這個策略是去尋找那些過去月營收年增率是走下降趨勢，但最近開始轉為上昇趨勢的公司我們用的腳本如下:

input:TXT("僅適用月線"); setinputname(1,"使用限制");

If barfreq \<\> "M" then raiseruntimeerror("頻率設定有誤");

setbarback(20);

settotalbar(20 \* 2 \+ 5);

value1=GetField("月營收年增率","M");

value2=average(GetField("月營收年增率","M"), 3);

value3=linearregslope(value2,20);

value4=linearregslope(value2,5);

if value3 \< 0 and value4 crosses above 0

then ret=1;

---

## 場景 888：3月份月營收數據公佈後的選股方向 — 我們用以下的腳本，來尋找那些營收年增率的短期移動平均線向上穿越長期移動平均線的股票

來源：[3月份月營收數據公佈後的選股方向](https://www.xq.com.tw/xstrader/3%e6%9c%88%e4%bb%bd%e6%9c%88%e7%87%9f%e6%94%b6%e6%95%b8%e6%93%9a%e5%85%ac%e4%bd%88%e5%be%8c%e7%9a%84%e9%81%b8%e8%82%a1%e6%96%b9%e5%90%91/) 說明：我們用以下的腳本，來尋找那些營收年增率的短期移動平均線向上穿越長期移動平均線的股票

value1=GetField("月營收年增率","M");

if average(value1,4) crosses over average(value1,12)

then ret=1;

---

## 場景 889：產業數據在XS上的應用 — 我們可以運用這個欄位，建構一個資金流向的指標如下

來源：[產業數據在XS上的應用](https://www.xq.com.tw/xstrader/%e7%94%a2%e6%a5%ad%e6%95%b8%e6%93%9a%e5%9c%a8xs%e4%b8%8a%e7%9a%84%e6%87%89%e7%94%a8/) 說明：我們可以運用這個欄位，建構一個資金流向的指標如下

input:period(5,"短期移動平均天數");

input:period1(20,"長期移動平均天數");

 

value1=GetField("資金流向");//商品成交值/對應大盤指數成交值\*100%

value2=average(value1,period);

value3=average(value1,period1);

value4= value2-value3;

 

plot1(value2,"短期移動平均");

plot2(value3,"長期移動平均");

plot3(value4,"dif");

---

## 場景 890：產業數據在XS上的應用 — 我們可以把上述的指標腳本改寫成警示腳本，尋找那些資金流向翻紅且股價上漲的細產業

來源：[產業數據在XS上的應用](https://www.xq.com.tw/xstrader/%e7%94%a2%e6%a5%ad%e6%95%b8%e6%93%9a%e5%9c%a8xs%e4%b8%8a%e7%9a%84%e6%87%89%e7%94%a8/) 說明：我們可以把上述的指標腳本改寫成警示腳本，尋找那些資金流向翻紅且股價上漲的細產業

input:short1(5),mid1(20);

setinputname(1,"短期平均");

setinputname(2,"長期平均");

value1=GetField("資金流向");

value2=average(value1,short1);

value3=average(value1,mid1);

value4=value2-value3;

value5=GetField("總市值");

if value4 cross over 0 and value5 \>value5\[5\]\*1.025

then ret=1;

---

## 場景 891：當DMI遇上VHF — DMI相關的數據，我們用了directionmovement這個函數來計算

來源：[當DMI遇上VHF](https://www.xq.com.tw/xstrader/%e7%95%b6dmi%e9%81%87%e4%b8%8avhf/) 說明：DMI相關的數據，我們用了directionmovement這個函數來計算

// DirectionMovement function (for DMI相關指標)

// Input: length

// Return: pdi\_value(+di), ndi\_value(-di), adx\_value(adx)

//

input: 

 length(numericsimple),

 pdi\_value(numericref),

 ndi\_value(numericref),

 adx\_value(numericref);

 

variable:

 padm(0), nadm(0), radx(0),

 atr(0), pdm(0), ndm(0), tr(0),

 dValue0(0), dValue1(0), dx(0),

 idx(0);

if currentbar \= 1 then

 begin

 padm \= close / 10000;

 nadm \= padm;

 atr \= padm \* 5;

 radx \= 20;

 end

else

 begin

 pdm \= maxlist(High \- High\[1\], 0);

 ndm \= maxlist(Low\[1\] \- Low, 0);

//先算出pdm及ndm

 if pdm \< ndm then

 pdm \= 0

 else 

 begin

 if pdm \> ndm then

 ndm \= 0

 else

 begin

 pdm \= 0;

 ndm \= 0;

 end; 

 end;

//那一邊的力量比較大，另一邊就以零來計算

 if Close\[1\] \> High then

 tr \= Close\[1\] \- Low

 else 

 begin

 if Close\[1\] \< Low then

 tr \= High \- Close\[1\]

 else 

 tr \= High \- Low;

 end;

//  計算true range

 padm \= padm\[1\] \+ (pdm \- padm\[1\]) / length;

 nadm \= nadm\[1\] \+ (ndm \- nadm\[1\]) / length;

 atr \= atr\[1\] \+ (tr \- atr\[1\]) / length;

 

 dValue0 \= 100 \* padm / atr;

 dValue1 \= 100 \* nadm / atr;

 

 if dValue0 \+ dValue1 \<\> 0 then

 dx \= AbsValue(100 \* (dValue0 \- dValue1) / (dValue0 \+ dValue1));

 radx \= radx\[1\] \+ (dx \- radx\[1\]) / length;

 end;

pdi\_value \= dValue0;

ndi\_value \= dValue1;

adx\_value \= radx;

---

## 場景 892：當DMI遇上VHF

來源：[當DMI遇上VHF](https://www.xq.com.tw/xstrader/%e7%95%b6dmi%e9%81%87%e4%b8%8avhf/) 說明：對應的腳本如下：

// XQ: VHF指標

//

input: Length(42);

Variable: hp(0), lp(0), numerator(0), denominator(0), \_vhf(0);

SetInputName(1, "天數");

hp \= highest(Close, Length);

lp \= lowest(Close, Length);

numerator \= hp \- lp;

denominator \= Summation(absvalue((Close \- Close\[1\])), Length);

if denominator \<\> 0 then

 \_vhf \= numerator / denominator

else

 \_vhf \= 0;

Plot1(\_vhf, "VHF");

---

## 場景 893：異同離差乖離率(DBCD)在單一國家股票型基金的應用 — 異同離差乖離率(DBCD)，它的計算方式是先算出短天期跟長天期的乖離率，再用長天期乖離率去減短天期乖離率，然後再算這個數字的移動平均值。計算的方式如下

來源：[異同離差乖離率(DBCD)在單一國家股票型基金的應用](https://www.xq.com.tw/xstrader/%e7%95%b0%e5%90%8c%e9%9b%a2%e5%b7%ae%e4%b9%96%e9%9b%a2%e7%8e%87dbcd%e5%9c%a8%e5%96%ae%e4%b8%80%e5%9c%8b%e5%ae%b6%e8%82%a1%e7%a5%a8%e5%9e%8b%e5%9f%ba%e9%87%91%e7%9a%84%e6%87%89%e7%94%a8/) 說明：異同離差乖離率(DBCD)，它的計算方式是先算出短天期跟長天期的乖離率，再用長天期乖離率去減短天期乖離率，然後再算這個數字的移動平均值。計算的方式如下

input:length1(10),length2(20),length3(14);

value1=bias(length1);

value2=bias(length2);

value3=value2-value1;

value4=average(value3,length3);

plot1(value4);

---

## 場景 894：異同離差乖離率(DBCD)在單一國家股票型基金的應用 — 上面的腳本用了bias這個函數，我們從bias這個函數的計算方式來探討DBCD這個指標的涵意

來源：[異同離差乖離率(DBCD)在單一國家股票型基金的應用](https://www.xq.com.tw/xstrader/%e7%95%b0%e5%90%8c%e9%9b%a2%e5%b7%ae%e4%b9%96%e9%9b%a2%e7%8e%87dbcd%e5%9c%a8%e5%96%ae%e4%b8%80%e5%9c%8b%e5%ae%b6%e8%82%a1%e7%a5%a8%e5%9e%8b%e5%9f%ba%e9%87%91%e7%9a%84%e6%87%89%e7%94%a8/) 說明：上面的腳本用了bias這個函數，我們從bias這個函數的計算方式來探討DBCD這個指標的涵意

// Bias function (for 乖離率相關指標)

//

input: length(numericsimple);

value1 \= Average(close, length);

Bias \= (close \- value1) \* 100 / value1;

---

## 場景 895：這個盤接下來到底會不會大跌?     \~ 建構專屬的大盤儀表板 — 首先我們來看外資，我用的腳本如下:這是去計算過去五天外資的累計買賣超及佔成交量的比例。

來源：[這個盤接下來到底會不會大跌?     \~ 建構專屬的大盤儀表板](https://www.xq.com.tw/xstrader/%e9%80%99%e5%80%8b%e7%9b%a4%e6%8e%a5%e4%b8%8b%e4%be%86%e5%88%b0%e5%ba%95%e6%9c%83%e4%b8%8d%e6%9c%83%e5%a4%a7%e8%b7%8c-%e5%bb%ba%e6%a7%8b%e5%b0%88%e5%b1%ac%e7%9a%84%e5%a4%a7%e7%9b%a4%e5%84%80/) 說明：首先我們來看外資，我用的腳本如下:這是去計算過去五天外資的累計買賣超及佔成交量的比例。

input: Length(5); setinputname(1,"計算天數");

input:TXT("僅適用日線以上"); setinputname(2,"使用限制");

variable: \_buyTotal(0), volTotal(0);

\_buyTotal \= summation(GetField("外資買賣超"), Length);

volTotal \= summation(Volume, Length);

Plot1(\_buyTotal, "累計買賣超");

Plot2(\_buyTotal \* 100 / volTotal, "比例%");

---

## 場景 896：這個盤接下來到底會不會大跌?     \~ 建構專屬的大盤儀表板 — 接下來看投信的動向，我使用的腳本如下:跟外資一樣，是去計算過去五天投信累計買賣超及佔成交量的比例。

來源：[這個盤接下來到底會不會大跌?     \~ 建構專屬的大盤儀表板](https://www.xq.com.tw/xstrader/%e9%80%99%e5%80%8b%e7%9b%a4%e6%8e%a5%e4%b8%8b%e4%be%86%e5%88%b0%e5%ba%95%e6%9c%83%e4%b8%8d%e6%9c%83%e5%a4%a7%e8%b7%8c-%e5%bb%ba%e6%a7%8b%e5%b0%88%e5%b1%ac%e7%9a%84%e5%a4%a7%e7%9b%a4%e5%84%80/) 說明：接下來看投信的動向，我使用的腳本如下:跟外資一樣，是去計算過去五天投信累計買賣超及佔成交量的比例。

input: Length(5); setinputname(1,"計算天數");

input:TXT("僅適用日線以上"); setinputname(2,"使用限制");

variable: \_buyTotal(0), volTotal(0);

\_buyTotal \= summation(GetField("投信買賣超"), Length);

volTotal \= summation(Volume, Length);

Plot1(\_buyTotal, "累計買賣超");

Plot2(\_buyTotal \* 100 / volTotal, "比例%");

---

## 場景 897：這個盤接下來到底會不會大跌?     \~ 建構專屬的大盤儀表板 — 它的算法是以一段時間的漲幅作分母，以這段時間每天的最高減最低合計值當分子，兩者相除，再把算出來的值作移動平均，它的腳本如下:

來源：[這個盤接下來到底會不會大跌?     \~ 建構專屬的大盤儀表板](https://www.xq.com.tw/xstrader/%e9%80%99%e5%80%8b%e7%9b%a4%e6%8e%a5%e4%b8%8b%e4%be%86%e5%88%b0%e5%ba%95%e6%9c%83%e4%b8%8d%e6%9c%83%e5%a4%a7%e8%b7%8c-%e5%bb%ba%e6%a7%8b%e5%b0%88%e5%b1%ac%e7%9a%84%e5%a4%a7%e7%9b%a4%e5%84%80/) 說明：它的算法是以一段時間的漲幅作分母，以這段時間每天的最高減最低合計值當分子，兩者相除，再把算出來的值作移動平均，它的腳本如下:

input:n1(5); setinputname(1,"計算天期"); 

input:n2(5); setinputname(2,"移動平均天期");

 

value1=absvalue(close-close\[n1-1\]); 

value2=summation(range,n1); 

if value1 \<\> 0 then 

begin

 value3 \= value2 / value1; 

 value4 \= average(value3,n2); 

end;

 

plot1(value4,"噪音指標");

---

## 場景 898：這個盤接下來到底會不會大跌?     \~ 建構專屬的大盤儀表板 — 我們把上述的公式改寫成以下的腳本

來源：[這個盤接下來到底會不會大跌?     \~ 建構專屬的大盤儀表板](https://www.xq.com.tw/xstrader/%e9%80%99%e5%80%8b%e7%9b%a4%e6%8e%a5%e4%b8%8b%e4%be%86%e5%88%b0%e5%ba%95%e6%9c%83%e4%b8%8d%e6%9c%83%e5%a4%a7%e8%b7%8c-%e5%bb%ba%e6%a7%8b%e5%b0%88%e5%b1%ac%e7%9a%84%e5%a4%a7%e7%9b%a4%e5%84%80/) 說明：我們把上述的公式改寫成以下的腳本

input:length(25); setinputname(1, "計算週期");

 

variable: aroon\_up(0), aroon\_down(0), aroon\_oscillator(0); 

aroon\_up \= (length-nthhighestbar(1,high,length))/length\*100; 

aroon\_down \= (length-nthlowestbar(1,low,length))/length\*100; 

aroon\_oscillator=aroon\_up-aroon\_down; 

plot1(aroon\_up,"aroon\_up"); 

plot2(aroon\_down,"aroon\_down"); 

plot3(aroon\_oscillator,"aroon\_oscillator");

---

## 場景 899：這個盤接下來到底會不會大跌?     \~ 建構專屬的大盤儀表板 — force index的腳本如下:

來源：[這個盤接下來到底會不會大跌?     \~ 建構專屬的大盤儀表板](https://www.xq.com.tw/xstrader/%e9%80%99%e5%80%8b%e7%9b%a4%e6%8e%a5%e4%b8%8b%e4%be%86%e5%88%b0%e5%ba%95%e6%9c%83%e4%b8%8d%e6%9c%83%e5%a4%a7%e8%b7%8c-%e5%bb%ba%e6%a7%8b%e5%b0%88%e5%b1%ac%e7%9a%84%e5%a4%a7%e7%9b%a4%e5%84%80/) 說明：force index的腳本如下:

input:length(10),length1(30);

variable:fis(0),fil(0);

fis=average(volume\*(close-close\[1\]),length);

fil=average(volume\*(close-close\[1\]),length1);

plot1(fis);

plot2(fil);

plot3(fis-fil);

---

## 場景 900：借券相關欄位在交易策略上的應用 — 以往我們要衡量軋空的力道，都是看融券餘額，但現在應該要再考慮到借券賣出餘額，所以我就試著用(融券餘額+借券賣出餘額)/20日成交量移動平均\*100來算出放空佔成...

來源：[借券相關欄位在交易策略上的應用](https://www.xq.com.tw/xstrader/%e5%80%9f%e5%88%b8%e7%9b%b8%e9%97%9c%e6%ac%84%e4%bd%8d%e5%9c%a8%e4%ba%a4%e6%98%93%e7%ad%96%e7%95%a5%e4%b8%8a%e7%9a%84%e6%87%89%e7%94%a8/) 說明：以往我們要衡量軋空的力道，都是看融券餘額，但現在應該要再考慮到借券賣出餘額，所以我就試著用(融券餘額+借券賣出餘額)/20日成交量移動平均\*100來算出放空佔成交均量倍數，我的想法是，如果這個數字達到一定程度的個股，基本面出現好轉時，空單回補的力量，會是股價上揚的一大助力。 這個指標的腳本如下:

value1=GetField("借券餘額張數","D");

value2=GetField("融券餘額張數","D");

if volume\<\>0

then 

value3=(value1+value2)/average(volume,20)\*100;

plot1(value3,"放空佔成交均量倍數");

---

## 場景 901：借券相關欄位在交易策略上的應用 — 因為這樣的公司不多，所以我用選股腳本來挑

來源：[借券相關欄位在交易策略上的應用](https://www.xq.com.tw/xstrader/%e5%80%9f%e5%88%b8%e7%9b%b8%e9%97%9c%e6%ac%84%e4%bd%8d%e5%9c%a8%e4%ba%a4%e6%98%93%e7%ad%96%e7%95%a5%e4%b8%8a%e7%9a%84%e6%87%89%e7%94%a8/) 說明：因為這樣的公司不多，所以我用選股腳本來挑

value1=GetField("借券賣出張數","D");

value2=GetField("外資賣張");

value3=value1-value2;

if value3\>0

then ret=1;

outputfield(1,value1,0,"借券賣出張數");

outputfield(2,value2,0,"外資賣張");

outputfield(3,value3,0,"借券賣出減外資賣張");

---

## 場景 902：借券相關欄位在交易策略上的應用 — 所以我就寫了一個自訂指標的腳本如下:

來源：[借券相關欄位在交易策略上的應用](https://www.xq.com.tw/xstrader/%e5%80%9f%e5%88%b8%e7%9b%b8%e9%97%9c%e6%ac%84%e4%bd%8d%e5%9c%a8%e4%ba%a4%e6%98%93%e7%ad%96%e7%95%a5%e4%b8%8a%e7%9a%84%e6%87%89%e7%94%a8/) 說明：所以我就寫了一個自訂指標的腳本如下:

value1=GetField("借券賣出餘額張數","D");

value2=GetField("借券餘額張數","D");

value3=value2-value1;

plot1(value3,"借券而尚未賣出餘額");

---

## 場景 903：借券相關欄位在交易策略上的應用 — 我寫了一個自訂指標來呈現還券張數的變化

來源：[借券相關欄位在交易策略上的應用](https://www.xq.com.tw/xstrader/%e5%80%9f%e5%88%b8%e7%9b%b8%e9%97%9c%e6%ac%84%e4%bd%8d%e5%9c%a8%e4%ba%a4%e6%98%93%e7%ad%96%e7%95%a5%e4%b8%8a%e7%9a%84%e6%87%89%e7%94%a8/) 說明：我寫了一個自訂指標來呈現還券張數的變化

input:period1(5,"短天期別");

input:period2(20,"長天期別");

value2=GetField("還券張數","D");

value3=average(value2,period1);

value4=average(value2,period2);

plot1(value3,"短期平均線");

plot2(value4,"長期平均線");

plot3(value3-value4,"差額");

---

## 場景 904：借券相關欄位在交易策略上的應用 — 這個自訂指標腳本跟還券張數很類似

來源：[借券相關欄位在交易策略上的應用](https://www.xq.com.tw/xstrader/%e5%80%9f%e5%88%b8%e7%9b%b8%e9%97%9c%e6%ac%84%e4%bd%8d%e5%9c%a8%e4%ba%a4%e6%98%93%e7%ad%96%e7%95%a5%e4%b8%8a%e7%9a%84%e6%87%89%e7%94%a8/) 說明：這個自訂指標腳本跟還券張數很類似

input:period1(5,"短天期別");

input:period2(20,"長天期別");

value2=GetField("借券賣出張數","D");

value3=average(value2,period1);

value4=average(value2,period2);

plot1(value3,"短期平均線");

plot2(value4,"長期平均線");

plot3(value3-value4,"差額");

---

## 場景 905：籌碼面可以拿來運算的欄位及其相關應用 — 作法上跟取得其他欄位的方法是一致的，都是運用getfield這個語法，例如我們如果想要拿”控盤者成本線”這個欄位來畫圖，腳本可以這麼寫:

來源：[籌碼面可以拿來運算的欄位及其相關應用](https://www.xq.com.tw/xstrader/%e7%b1%8c%e7%a2%bc%e9%9d%a2%e5%8f%af%e4%bb%a5%e6%8b%bf%e4%be%86%e9%81%8b%e7%ae%97%e7%9a%84%e6%ac%84%e4%bd%8d%e5%8f%8a%e5%85%b6%e7%9b%b8%e9%97%9c%e6%87%89%e7%94%a8/) 說明：作法上跟取得其他欄位的方法是一致的，都是運用getfield這個語法，例如我們如果想要拿”控盤者成本線”這個欄位來畫圖，腳本可以這麼寫:

value1=GetField("分公司買進家數");

value2=GetField("分公司賣出家數");

value3=GetField("分公司交易家數");

plot1(value1,"分公司買進家數");

plot2(value2,"分公司賣出家數");

plot3(value3,"分公司交易家數");

---

## 場景 906：籌碼面可以拿來運算的欄位及其相關應用

來源：[籌碼面可以拿來運算的欄位及其相關應用](https://www.xq.com.tw/xstrader/%e7%b1%8c%e7%a2%bc%e9%9d%a2%e5%8f%af%e4%bb%a5%e6%8b%bf%e4%be%86%e9%81%8b%e7%ae%97%e7%9a%84%e6%ac%84%e4%bd%8d%e5%8f%8a%e5%85%b6%e7%9b%b8%e9%97%9c%e6%87%89%e7%94%a8/) 說明：我設計的腳本如下:

input:period(5,"短移動平均線天期");

input:period1(20,"長移動平均線天期");

value1=GetField("主力買張");

value2=GetField("實戶買張");

value3=GetField("散戶買張");

value4=GetField("控盤者買張");

value5=GetField("法人買張");

value6=value1+value2+value3+value4+value5;

//合計的買張數當分母，這有可能超出成交量

value7=value1+value4+value5;

//主力+法人+控盤者的買張合計作為大戶的買張

if value6\<\>0

then value8=value7/value6\*100;

//計算大戶買張佔各方勢力買張的比例

value9=average(value8,period)-average(value8,period1);

if value9\>0

then 

begin

value10=value9;

value11=0;

end

else

begin 

value11=value9;

value10=0;

end;

plot1(value10);

plot2(value11);

---

## 場景 907：好公司的特徵 — 我先試著尋找那些毛利率沒啥掉的公司，所以我寫了一個腳本如下：

來源：[好公司的特徵](https://www.xq.com.tw/xstrader/%e5%a5%bd%e5%85%ac%e5%8f%b8%e7%9a%84%e7%89%b9%e5%be%b5/) 說明：我先試著尋找那些毛利率沒啥掉的公司，所以我寫了一個腳本如下：

value1=GetField("營業毛利率","Q");

input:ratio(10,"毛利率單季衰退幅度上限");

input:period(10,"計算的期間，單位是季");

if trueall(value1\>value1\[1\]\*(1-ratio/100),period)

then ret=1;

---

## 場景 908：好公司的特徵 — 若是我換另一個角度，去尋找那些營收上昇且費用在降低的股票，於是我就寫了一個腳本如下：

來源：[好公司的特徵](https://www.xq.com.tw/xstrader/%e5%a5%bd%e5%85%ac%e5%8f%b8%e7%9a%84%e7%89%b9%e5%be%b5/) 說明：若是我換另一個角度，去尋找那些營收上昇且費用在降低的股票，於是我就寫了一個腳本如下：

value1=GetField("營業收入淨額","Q");//單位百萬

value2=GetField("營業費用","Q");//單位百萬

input:period(5,"計算的季別");

input:count(2,"符合條件之最低次數");

if countif(value1\>value1\[1\]and value2\<value2\[1\],period)\>=count

then ret=1;

---

## 場景 909：好公司的特徵 — 如果把這兩個條件合在一起，腳本可以這麼寫

來源：[好公司的特徵](https://www.xq.com.tw/xstrader/%e5%a5%bd%e5%85%ac%e5%8f%b8%e7%9a%84%e7%89%b9%e5%be%b5/) 說明：如果把這兩個條件合在一起，腳本可以這麼寫

value1=GetField("營業毛利率","Q");

value2=GetField("營業收入淨額","Q");//單位百萬

value3=GetField("營業費用","Q");//單位百萬

input:ratio(10,"毛利率單季衰退幅度上限");

input:period1(10,"計算的期間，單位是季");

input:period2(5,"計算的季別");

input:count(2,"符合條件之最低次數");

if trueall(value1\>value1\[1\]\*(1-ratio/100),period1)

and 

countif(value2\>value2\[1\]and value3\<value3\[1\],period2)\>=count

then ret=1;

---

## 場景 910：設定交易策略一定要記得不能逆天而行 — 接下來我用他們都很愛用的操作策略: 開盤五分鐘線三連陽

來源：[設定交易策略一定要記得不能逆天而行](https://www.xq.com.tw/xstrader/%e8%a8%ad%e5%ae%9a%e4%ba%a4%e6%98%93%e7%ad%96%e7%95%a5%e4%b8%80%e5%ae%9a%e8%a6%81%e8%a8%98%e5%be%97%e4%b8%8d%e8%83%bd%e9%80%86%e5%a4%a9%e8%80%8c%e8%a1%8c/) 說明：接下來我用他們都很愛用的操作策略: 開盤五分鐘線三連陽

input:TXT("僅適用60分鐘線以內"); setinputname(1,"使用限制");

if barfreq \= "Min" and barinterval \<= 60 and

 (time\[2\] \= 84500 or time\[2\] \= 90000\) and

 Close \> Close\[1\] and Close\[1\] \> Close\[2\] and

 Close\[2\] \> Open\[2\] 

then ret=1;

---

## 場景 911：尋找那些創過去五年同月份營收新高的股票 — 怎麼找出這樣的公司呢？ 我寫了一個選股的腳本如下：

來源：[尋找那些創過去五年同月份營收新高的股票](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e9%82%a3%e4%ba%9b%e5%89%b5%e9%81%8e%e5%8e%bb%e4%ba%94%e5%b9%b4%e5%90%8c%e6%9c%88%e4%bb%bd%e7%87%9f%e6%94%b6%e6%96%b0%e9%ab%98%e7%9a%84%e8%82%a1%e7%a5%a8/) 說明：怎麼找出這樣的公司呢？ 我寫了一個選股的腳本如下：

array: numarray\[5\](0);

variable:x(0);

for x=1 to 5

numarray\[x\]=GetField("月營收","M")\[(x-1)\*12\];

if numarray\[1\]=highestarray(numarray\[1\],5) then

ret=1;

---

## 場景 912：尋找那些創過去五年同月份營收新高的股票 — 在這麼多檔股票中，如果我們擔心這個月營收的好表現是因為上個月出貨不及遞延到這個月造成的，那麼我們可以把條件限制的更嚴，挑那些最近兩個月的營收都創下當月五年來新高...

來源：[尋找那些創過去五年同月份營收新高的股票](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e9%82%a3%e4%ba%9b%e5%89%b5%e9%81%8e%e5%8e%bb%e4%ba%94%e5%b9%b4%e5%90%8c%e6%9c%88%e4%bb%bd%e7%87%9f%e6%94%b6%e6%96%b0%e9%ab%98%e7%9a%84%e8%82%a1%e7%a5%a8/) 說明：在這麼多檔股票中，如果我們擔心這個月營收的好表現是因為上個月出貨不及遞延到這個月造成的，那麼我們可以把條件限制的更嚴，挑那些最近兩個月的營收都創下當月五年來新高的股票，那麼腳本就可以略為修改成以下的樣子

array: numarray\[5\](0);

variable:x(0);

for x=1 to 5

numarray\[x\]=GetField("月營收","M")\[(x-1)\*12\];

if trueall(numarray\[1\]=highestarray(numarray\[1\],5),2) then

ret=1;

---

## 場景 913：現股當沖腳本的奧義

來源：[現股當沖腳本的奧義](https://www.xq.com.tw/xstrader/%e7%8f%be%e8%82%a1%e7%95%b6%e6%b2%96%e8%85%b3%e6%9c%ac%e7%9a%84%e5%a5%a7%e7%be%a9/) 說明：第一個開高後不拉回

input:Ratio(2.5); setinputname(1,"開高幅度%");

 input:aRatio(1); setinputname(2,"拉回度%上限");

 input:TXT("僅適用於15分鐘以內"); setinputname(3,"使用限制"); 

if barfreq \="Min" and barinterval \<=15 

and time \<= 091500 

and q\_DailyOpen \> q\_RefPrice \*(1+Ratio/100)

 and q\_Last \> q\_DailyHigh\* (1- aRatio/100) 

then ret=1;

---

## 場景 914：現股當沖腳本的奧義 — 第二個則是橫向盤整後的旱地拔葱

來源：[現股當沖腳本的奧義](https://www.xq.com.tw/xstrader/%e7%8f%be%e8%82%a1%e7%95%b6%e6%b2%96%e8%85%b3%e6%9c%ac%e7%9a%84%e5%a5%a7%e7%be%a9/) 說明：第二個則是橫向盤整後的旱地拔葱

if barfreq \<\> "Min" or barinterval \<\> 1 then RaiseRuntimeError("請設定頻率為1分鐘");

variable:KBarOfDay(0); if Date\<\> Date\[1\] then KBarOfDay \= 1 else KBarOfDay+=1;

input:P1(60); setinputname(1,"狹幅盤整計算期間(分鐘)");

if high \= q\_DailyHigh and {來到今日最高價}

 KBarOfDay \> 30 and {今日至少有30根K棒交易}

 TrueAll( AbsValue(Close\[1\]/Close\[2\]-1) \< 0.005,KBarOfDay-1) and{必需只有小波動}

 AbsValue( Close\[1\]/Close\[KBarOfDay-1\]-1 ) \< 0.02 {開盤到前分收K不超過2%}

then ret=1;

以下是這類股票的示意圖

---

## 場景 915：現股當沖腳本的奧義

來源：[現股當沖腳本的奧義](https://www.xq.com.tw/xstrader/%e7%8f%be%e8%82%a1%e7%95%b6%e6%b2%96%e8%85%b3%e6%9c%ac%e7%9a%84%e5%a5%a7%e7%be%a9/) 說明：第三個則是階段式向上

input:TXT1("僅適用1分鐘線"); setinputname(1,"使用限制");

input:TXT2("只於9:10判斷"); setinputname(2,"使用說明");

if barfreq \= "Min" and barinterval \= 1 and time \=91000 and

 TrueAll(close \>Close\[1\] ,10) then ret=1;

---

## 場景 916：現股當沖腳本的奧義 — 於是我用以下的腳本來選股

來源：[現股當沖腳本的奧義](https://www.xq.com.tw/xstrader/%e7%8f%be%e8%82%a1%e7%95%b6%e6%b2%96%e8%85%b3%e6%9c%ac%e7%9a%84%e5%a5%a7%e7%be%a9/) 說明：於是我用以下的腳本來選股

input:b1(1.5,"三日漲幅上限");

if volume\*close\>=30000

and close\<=close\[2\]\*(1+b1/100)

then ret=1;

---

## 場景 917：交易策略的形成過程\~以多次到頂而破 — 一開始是我師父讓我把創新高的股票用Excel整理出來，每天送給他，後來我發現，不是每檔創新高的，接下來就一定會創新高，但那些衝了幾次都沒衝過去的高點，一旦衝過去...

來源：[交易策略的形成過程\~以多次到頂而破](https://www.xq.com.tw/xstrader/%e4%ba%a4%e6%98%93%e7%ad%96%e7%95%a5%e7%9a%84%e5%bd%a2%e6%88%90%e9%81%8e%e7%a8%8b%e4%bb%a5%e5%a4%9a%e6%ac%a1%e5%88%b0%e9%a0%82%e8%80%8c%e7%a0%b4/) 說明：一開始是我師父讓我把創新高的股票用Excel整理出來，每天送給他，後來我發現，不是每檔創新高的，接下來就一定會創新高，但那些衝了幾次都沒衝過去的高點，一旦衝過去了，後面都還會漲，所以我就寫了一個多次到頂而破的交易策略，腳本如下:

input:day(100);

input:band1(4);

setinputname(1,"計算區間");

setinputname(2,"三高點之高低價差");

value1=nthhighest(1,high\[1\],day);

value2=nthhighest(3,high\[1\],day);

value4=nthhighestbar(1,high,day);

value5=nthhighestbar(3,high,day);

value6=nthhighestbar(5,high,day);

value7=absvalue(value4-value6);

value8=absvalue(value5-value6);

value9=absvalue(value4-value5);

condition1=false;

if value7\>3 and value8\>3 and value9\>3

then condition1=true;

value3=(value1-value2)/value2;

if value3\<=band1/100

and close crosses above value1

and volume\>2000

and condition1

then ret=1;

---

## 場景 918：交易策略的形成過程\~以多次到頂而破 — 後來這個腳本後來經過我同事的修改，變成以下的腳本

來源：[交易策略的形成過程\~以多次到頂而破](https://www.xq.com.tw/xstrader/%e4%ba%a4%e6%98%93%e7%ad%96%e7%95%a5%e7%9a%84%e5%bd%a2%e6%88%90%e9%81%8e%e7%a8%8b%e4%bb%a5%e5%a4%9a%e6%ac%a1%e5%88%b0%e9%a0%82%e8%80%8c%e7%a0%b4/) 說明：後來這個腳本後來經過我同事的修改，變成以下的腳本

input:HitTimes(3); setinputname(1,"設定觸頂次數");

input:RangeRatio(1); setinputname(2,"設定頭部區範圍寬度%");

input:Length(20); setinputname(3,"計算期數");

settotalbar(300);

setbarback(50);

variable: theHigh(0); theHigh \= Highest(High\[1\],Length); //找到過去其間的最高點

variable: HighLowerBound(0); HighLowerBound \= theHigh \*(100-RangeRatio)/100; // 設為瓶頸區間上界

variable: TouchRangeTimes(0); //期間中進入瓶頸區間的低點次數,每跟K棒要歸0

 

//回算在此區間中 進去瓶頸區的次數 

TouchRangeTimes \= CountIF(High\[1\] \> HighLowerBound, Length);

 

if TouchRangeTimes \>= HitTimes and ( q\_ask\> theHigh or close \> theHigh) then ret=1;

---

## 場景 919：上漲下跌家數差RSI指標 — 這個指標是我自己胡思亂想時寫出來的，先來看一下它的腳本

來源：[上漲下跌家數差RSI指標](https://www.xq.com.tw/xstrader/%e4%b8%8a%e6%bc%b2%e4%b8%8b%e8%b7%8c%e5%ae%b6%e6%95%b8%e5%b7%aersi%e6%8c%87%e6%a8%99/) 說明：這個指標是我自己胡思亂想時寫出來的，先來看一下它的腳本

input:period(10,"RSI計算天數");

value1=GetField("上漲家數");

value2=getfield("下跌家數");

value3=value1-value2;

value4=summation(value3,period);

value5=rsi(value4,period);

plot1(value5,"上漲家數RSI");

---

## 場景 920：主力，法人，公司派波段買超後的攻擊發起日 — 我試著根據這些條件寫了一個選股腳本如下:

來源：[主力，法人，公司派波段買超後的攻擊發起日](https://www.xq.com.tw/xstrader/%e4%b8%bb%e5%8a%9b%ef%bc%8c%e6%b3%95%e4%ba%ba%ef%bc%8c%e5%85%ac%e5%8f%b8%e6%b4%be%e6%b3%a2%e6%ae%b5%e8%b2%b7%e8%b6%85%e5%be%8c%e7%9a%84%e6%94%bb%e6%93%8a%e7%99%bc%e8%b5%b7%e6%97%a5/) 說明：我試著根據這些條件寫了一個選股腳本如下:

value1=GetField("法人買賣超張數");

value2=GetField("主力買賣超張數");

value3=value1+value2;

value4=GetField("內外盤比","D");//外盤量/內盤量\*100

condition1=false;

condition2=false;

condition3=false;

if countif(value3\>300,5)\>=4 or countif(value3\>300,3)\>=2

then condition1=true; 

if value3\>volume\*0.3

and value4\>50

then condition2=true;

if high\<=close\*1.02

then condition3=true;

if condition1 and condition2 and condition3

then ret=1;

---

## 場景 921：尋找那些開盤迄今外盤量的比重很高的股票 — 這個指標的腳本我附在下方

來源：[尋找那些開盤迄今外盤量的比重很高的股票](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e9%82%a3%e4%ba%9b%e9%96%8b%e7%9b%a4%e8%bf%84%e4%bb%8a%e5%a4%96%e7%9b%a4%e9%87%8f%e7%9a%84%e6%af%94%e9%87%8d%e5%be%88%e9%ab%98%e7%9a%84%e8%82%a1%e7%a5%a8/) 說明：這個指標的腳本我附在下方

value1=GetField("外盤量");

if volume\<\>0

then value2=value1/volume\*100

else

value2=50;

plot1(value2,"外盤佔比%");

---

## 場景 922：尋找那些開盤迄今外盤量的比重很高的股票 — 基於這樣的觀察，我們可以寫出一個腳本，在盤中找出累積到特定時間時，外盤量佔比超過一定比例的股票。

來源：[尋找那些開盤迄今外盤量的比重很高的股票](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e9%82%a3%e4%ba%9b%e9%96%8b%e7%9b%a4%e8%bf%84%e4%bb%8a%e5%a4%96%e7%9b%a4%e9%87%8f%e7%9a%84%e6%af%94%e9%87%8d%e5%be%88%e9%ab%98%e7%9a%84%e8%82%a1%e7%a5%a8/) 說明：基於這樣的觀察，我們可以寫出一個腳本，在盤中找出累積到特定時間時，外盤量佔比超過一定比例的股票。

input:timeline(100000,"截止時間HHmmss"); 

input:ratio(50,"外盤量佔總成交量比重%");

value1=q\_OutSize;//當日外盤量

if volume\<\>0

then begin

if currenttime\>=timeline and value1/volume\*100\>ratio and volume\>500

then ret=1;

end;

---

## 場景 923：跨頻率多重濾網交易策略的設計 — 首先，我們先寫下兩個選股腳本

來源：[跨頻率多重濾網交易策略的設計](https://www.xq.com.tw/xstrader/%e8%b7%a8%e9%a0%bb%e7%8e%87%e5%a4%9a%e9%87%8d%e6%bf%be%e7%b6%b2%e4%ba%a4%e6%98%93%e7%ad%96%e7%95%a5%e7%9a%84%e8%a8%ad%e8%a8%88/) 說明：首先，我們先寫下兩個選股腳本

input:S1(6,"天期");

value1=average(close,s1);

if close\>value1

then ret=1;

---

## 場景 924：跨頻率多重濾網交易策略的設計 — 下面這個則是KD進入超賣區

來源：[跨頻率多重濾網交易策略的設計](https://www.xq.com.tw/xstrader/%e8%b7%a8%e9%a0%bb%e7%8e%87%e5%a4%9a%e9%87%8d%e6%bf%be%e7%b6%b2%e4%ba%a4%e6%98%93%e7%ad%96%e7%95%a5%e7%9a%84%e8%a8%ad%e8%a8%88/) 說明：下面這個則是KD進入超賣區

// KD指標, K值由下往上穿越D值

//

input: Length(9), RSVt(3), Kt(3);

variable: rsv(0), k(0), \_d(0);

SetBarBack(maxlist(Length,6));

SetTotalBar(maxlist(Length,6) \* 4);

SetInputName(1, "天數");

SetInputName(2, "RSVt權數");

SetInputName(3, "Kt權數");

Stochastic(Length, RSVt, Kt, rsv, k, \_d);

IF k\<20 and \_d\<30

then ret=1;

---

## 場景 925：跨頻率多重濾網交易策略的設計 — 最後我們運用突破近期新高的腳本

來源：[跨頻率多重濾網交易策略的設計](https://www.xq.com.tw/xstrader/%e8%b7%a8%e9%a0%bb%e7%8e%87%e5%a4%9a%e9%87%8d%e6%bf%be%e7%b6%b2%e4%ba%a4%e6%98%93%e7%ad%96%e7%95%a5%e7%9a%84%e8%a8%ad%e8%a8%88/) 說明：最後我們運用突破近期新高的腳本

input: Price(close); setinputname(1,"比較價別");

input: Length(10); setinputname(2,"近期期數");

if Price \> highest(high\[1\] ,Length) then ret=1;

---

## 場景 926：主力一直在買的股票何時可以進場跟單? — 最後，為了避免被主力逢高出貨，所以我濾掉那些主力買超但十天內漲幅超過一成的股票，這個部份我是寫了一個選股的腳本如下:

來源：[主力一直在買的股票何時可以進場跟單?](https://www.xq.com.tw/xstrader/%e4%b8%bb%e5%8a%9b%e4%b8%80%e7%9b%b4%e5%9c%a8%e8%b2%b7%e7%9a%84%e8%82%a1%e7%a5%a8%e4%bd%95%e6%99%82%e5%8f%af%e4%bb%a5%e9%80%b2%e5%a0%b4%e8%b7%9f%e5%96%ae/) 說明：最後，為了避免被主力逢高出貨，所以我濾掉那些主力買超但十天內漲幅超過一成的股票，這個部份我是寫了一個選股的腳本如下:

input:period(10,"計算區間");

input:ratio(10,"最低漲跌幅");

if close\[period-1\]\<\>0

then begin

if (close/close\[period-1\]-1)\*100\<ratio

then ret=1;

end;

outputfield(1,(close/close\[period-1\]-1)\*100,1,"區間漲跌幅");

---

## 場景 927：主力一直在買的股票何時可以進場跟單? — 接下來我用符合這些條件的股票，用盤中的腳本去跑，希望找到那些主力即將開始拉昇的股票，以下的這個腳本，是我覺得不錯用的

來源：[主力一直在買的股票何時可以進場跟單?](https://www.xq.com.tw/xstrader/%e4%b8%bb%e5%8a%9b%e4%b8%80%e7%9b%b4%e5%9c%a8%e8%b2%b7%e7%9a%84%e8%82%a1%e7%a5%a8%e4%bd%95%e6%99%82%e5%8f%af%e4%bb%a5%e9%80%b2%e5%a0%b4%e8%b7%9f%e5%96%ae/) 說明：接下來我用符合這些條件的股票，用盤中的腳本去跑，希望找到那些主力即將開始拉昇的股票，以下的這個腳本，是我覺得不錯用的

if barfreq \<\> "Min" or Barinterval \<\>1 then RaiseRuntimeError("請設定頻率為1分鐘");

input:n1(10);

setinputname(1,"開盤連續幾分鐘");

variable:BarNumberOfToday(0); 

if Date \<\> Date\[1\] then BarNumberOfToday=1 

else BarNumberOfToday+=1;{記錄今天的Bar數} 

if Date \=currentdate then begin

variable: idx(0),tTime(0);

tTime=0;

 

for idx \= 0 to n1-1

begin

if Close\[idx\] \> Close\[idx+1\] then tTime+=1;

 {推升時記1}

 end; 

if tTime \>=n1\*0.6//1分鐘線大部份的時間都在上漲

and q\_PriceChangeRatio \< 5 {漲幅仍在5%內}

and Timediff(Time,Time\[BarNumberOfToday-1\],"M") \=n1{分鐘} 

 {離開盤第1個價10分鐘內}

then ret=1;

end;

---

## 場景 928：到底什麼樣的股票可以拿來當存股的標的??

來源：[到底什麼樣的股票可以拿來當存股的標的??](https://www.xq.com.tw/xstrader/%e5%88%b0%e5%ba%95%e4%bb%80%e9%ba%bc%e6%a8%a3%e7%9a%84%e8%82%a1%e7%a5%a8%e5%8f%af%e4%bb%a5%e6%8b%bf%e4%be%86%e7%95%b6%e5%ad%98%e8%82%a1%e7%9a%84%e6%a8%99%e7%9a%84/) 說明：以下是這個腳本的內容

input:p1(2,"現金股利下限");

input:period(5,"符合條件的連續年數");

condition1=false;

value1=GetField("現金股利","Y");

if trueall(value1\>=p1,period) or trueall(value1\[1\]\>=p1,period)

then condition1=true;

value2=GetField("本期稅後淨利","Q");//單位:百萬

value3=summation(value2,4);

if value3\>200

then condition2=true;

if condition1 and condition2

then ret=1;

---

## 場景 929：到底什麼樣的股票可以拿來當存股的標的?? — 接下來再從這140檔當中，濾掉那些過去幾年曾經有較大衰退的公司，所以我在上面提到的那個腳本中，再加上下面的濾網:

來源：[到底什麼樣的股票可以拿來當存股的標的??](https://www.xq.com.tw/xstrader/%e5%88%b0%e5%ba%95%e4%bb%80%e9%ba%bc%e6%a8%a3%e7%9a%84%e8%82%a1%e7%a5%a8%e5%8f%af%e4%bb%a5%e6%8b%bf%e4%be%86%e7%95%b6%e5%ad%98%e8%82%a1%e7%9a%84%e6%a8%99%e7%9a%84/) 說明：接下來再從這140檔當中，濾掉那些過去幾年曾經有較大衰退的公司，所以我在上面提到的那個腳本中，再加上下面的濾網:

condition3=false;

value4=GetField("營業利益成長率","Y");

if countif(value4\<-15,period)=0

then condition3=true;

if condition1 and condition2 and condition3

then ret=1;

---

## 場景 930：計算區間漲跌幅的自訂函數 — 先來介紹一下計算區間漲跌幅的自訂函數，我寫的腳本如下:

來源：[計算區間漲跌幅的自訂函數](https://www.xq.com.tw/xstrader/%e8%a8%88%e7%ae%97%e5%8d%80%e9%96%93%e6%bc%b2%e8%b7%8c%e5%b9%85%e7%9a%84%e8%87%aa%e8%a8%82%e5%87%bd%e6%95%b8/) 說明：先來介紹一下計算區間漲跌幅的自訂函數，我寫的腳本如下:

input:price(numericsimple);

 input:startday(numericsimple);

 input:endday(numericsimple);

 value1=getbaroffset(startday);

 value2=getbaroffset(endday);

 {if value1\>value2

 then raiseruntimeerror("起始日期不能晚於結束日期");}

 value3=(price\[value2\]/price\[value1\])-1 ;

 rangechange=value3\*100;

---

## 場景 931：計算區間漲跌幅的自訂函數 — 有了這個函數，要寫區間漲跌幅的選股腳本就容易多了:

來源：[計算區間漲跌幅的自訂函數](https://www.xq.com.tw/xstrader/%e8%a8%88%e7%ae%97%e5%8d%80%e9%96%93%e6%bc%b2%e8%b7%8c%e5%b9%85%e7%9a%84%e8%87%aa%e8%a8%82%e5%87%bd%e6%95%b8/) 說明：有了這個函數，要寫區間漲跌幅的選股腳本就容易多了:

input:startday(20150702,"區間起始日");

input:endday(20151002,"區間結束日");

input:ratio(10,"最低漲幅");

value1=rangechange(close,startday,endday);

if value1\>=ratio

then ret=1;

 

value2=GetField("最新股本");

value3=GetField("月營收年增率","M");

value4=GetField("股價淨值比","D");

outputfield(1,value1,1,"區間漲跌幅");

outputfield(2,value2,0,"股本(億)");

outputfield(3,value3,1,"月營收年增率");

outputfield(4,value4,1,"股價淨值比");

---

## 場景 932：價值型轉機股 — 當我想知道現在是什麼類型的股票在帶頭上漲時，我會用底下的腳本去跑選股:

來源：[價值型轉機股](https://www.xq.com.tw/xstrader/%e5%83%b9%e5%80%bc%e5%9e%8b%e8%bd%89%e6%a9%9f%e8%82%a1/) 說明：當我想知道現在是什麼類型的股票在帶頭上漲時，我會用底下的腳本去跑選股:

input:startdate(20160203);

input:ratio(15,"漲幅下限");

value1=getbaroffset(startdate);

if close\[value1\]\<\>0

then value2=(close-close\[value1\])/close\[value1\]\*100;

if value2\>ratio

then ret=1;

outputfield(1,value2,1,"區間漲跌幅");

outputfield(2,GetField("股價淨值比","D"),2,"股價淨值比");

outputfield(3,GetField("月營收年增率","M"),2,"月營收年增率");

outputfield(4,GetField("本益比","D"),1,"本益比");

---

## 場景 933：價值型轉機股 — 一，本益比小於 15 倍 股價淨值比小於 2 倍 殖利率大於 3%

來源：[價值型轉機股](https://www.xq.com.tw/xstrader/%e5%83%b9%e5%80%bc%e5%9e%8b%e8%bd%89%e6%a9%9f%e8%82%a1/) 說明：一，本益比小於 15 倍 股價淨值比小於 2 倍 殖利率大於 3%

{本益比小於 15 倍 股價淨值比小於 2 倍 殖利率大於 3%}

if GetField("本益比","D") \< 15 and

 GetField("股價淨值比","D") \<2 and

 GetField("殖利率","D") \> 3 and

 GetField("營收成長率","Q") \>0 

  then ret=1;

---

## 場景 934：價值型轉機股 — 二，用月營收推估的低本益比股

來源：[價值型轉機股](https://www.xq.com.tw/xstrader/%e5%83%b9%e5%80%bc%e5%9e%8b%e8%bd%89%e6%a9%9f%e8%82%a1/) 說明：二，用月營收推估的低本益比股

value1=GetField("月營收","M");//單位:億元

value2=GetField("月營收月增率","M");

value3=GetField("月營收年增率","M");

value4=GetField("營業利益率","Q");

value5=GetField("最新股本");//單位:億元

condition1=false;

condition2=false;

input:peraito(12);

setinputname(1,"預估本益比上限");

if value5\<\>0

then

value6=(value1\*value4\*12)/(value5\*10);//單月營收推估的本業EPS

if value6\<\>0

then 

value7=close/value6;

if value7\<peraito and value7\>0

then ret=1;

---

## 場景 935：價值型轉機股 — 三，每股的流動資產遠大於股價

來源：[價值型轉機股](https://www.xq.com.tw/xstrader/%e5%83%b9%e5%80%bc%e5%9e%8b%e8%bd%89%e6%a9%9f%e8%82%a1/) 說明：三，每股的流動資產遠大於股價

input:percent(20);

 setinputname(1,"每股易變現資產與股價間的落差比");

 value1=GetField("現金及約當現金","Q");//百萬;

 value2=GetField("短期投資","Q");//百萬

 value3=GetField("應收帳款及票據","Q");//百萬

 value4=GetField("長期投資","Q");//百萬

 value5=GetField("負債總額","Q");//百萬

 value6=GetField("最新股本");//單位: 億

 value7=(value1+value2+value3+value4-value5)/(value6\*10);

 if value7\>close\*(1+percent/100)

 then ret=1;

---

## 場景 936：價值型轉機股 — 四，流動性資產減負債超過市值N成

來源：[價值型轉機股](https://www.xq.com.tw/xstrader/%e5%83%b9%e5%80%bc%e5%9e%8b%e8%bd%89%e6%a9%9f%e8%82%a1/) 說明：四，流動性資產減負債超過市值N成

input:ratio(80,"佔總市值百分比%");

if (GetField("流動資產","Q")-GetField("負債總額","Q"))/100\>GetField("總市值","D")\*ratio/100

then ret=1;

---

## 場景 937：價值型轉機股 — 五，高現金總市值比的公司

來源：[價值型轉機股](https://www.xq.com.tw/xstrader/%e5%83%b9%e5%80%bc%e5%9e%8b%e8%bd%89%e6%a9%9f%e8%82%a1/) 說明：五，高現金總市值比的公司

//現金總市值比高的公司 

value1=GetField("現金及約當現金","Q");//單位百萬

value2=GetField("短期投資","Q");//單位百萬

value3=(value1+value2)/100;//單位億之現金及短期投資合計金額

value4=GetField("總市值","D");//單位:億

if value4\<\>0

then value5=value3/value4;//現金總市值比;

if value5\>0.7 and value3\>3 //現金總市值比大於0.7且現金及短投合計超過3億

then ret=1;

---

## 場景 938：價值型轉機股 — 六，高自由現金流量總市值比

來源：[價值型轉機股](https://www.xq.com.tw/xstrader/%e5%83%b9%e5%80%bc%e5%9e%8b%e8%bd%89%e6%a9%9f%e8%82%a1/) 說明：六，高自由現金流量總市值比

input:ratio(50);

 setinputname(1,"近四季自由現金流總合佔總市值最低比率單位:%");

if (GetField("來自營運之現金流量","Q")+GetField("來自營運之現金流量","Q")\[1\]+

 GetField("來自營運之現金流量","Q")\[2\]+GetField("來自營運之現金流量","Q")\[3\]-

 GetField("資本支出金額","Q")-GetField("資本支出金額","Q")\[1\]

 \-GetField("資本支出金額","Q")\[2\]-GetField("資本支出金額","Q")\[3\])

 \>GetField("總市值","D")\*100\*ratio/100

 then ret=1;

---

## 場景 939：看盤用的腳本

來源：[看盤用的腳本](https://www.xq.com.tw/xstrader/%e7%9c%8b%e7%9b%a4%e7%94%a8%e7%9a%84%e8%85%b3%e6%9c%ac/) 說明：一個用來看大勢

condition1=false;

condition2=false;

condition3=false;

if average(close,5)\>average(close,22)

then condition1=true;//週線在月線之上

if estvolume\>average(volume,20)

then condition2=true;//預估量高於20日均量

value3=q\_UpLimitSecs;//漲停家數

value4=q\_UpSecurities;//上漲家數

if value3\>15 or value4\>250

then condition3=true;//漲停夠多或上漲的夠多

if condition1 and condition2 and condition3

then ret=1;

---

## 場景 940：看盤用的腳本 — 另一個用來挑可以繼續盯著看的股票

來源：[看盤用的腳本](https://www.xq.com.tw/xstrader/%e7%9c%8b%e7%9b%a4%e7%94%a8%e7%9a%84%e8%85%b3%e6%9c%ac/) 說明：另一個用來挑可以繼續盯著看的股票

value1=q\_InSize;//內盤量

value2=q\_OutSize;//外盤量

value3=q\_SumBidSize;//總委買

value4=q\_BidAskDiff;//委買賣差(張)

value5=q\_CashDirect;//佔大盤成交比重

value6=q\_BoughtLotsAtOpen;//開盤委買張數

value7=q\_BoughtAverageAtOpen;//開盤委買均張

condition1=false;

condition2=false;

condition3=false;

condition4=false;

input:r1(1.5,"外盤量/內盤量的比值");

input:q1(1000,"外盤量-內盤量");

input:q2(300,"總委買下限");

input:q3(200,"委買賣差下限");

input:r2(20,"佔大盤成交比重成長下限");

input:q4(300,"開盤委買張數下限");

input:r3(20,"開盤委買均張成長率下限");

if value1\<\>0

then value8=value2/value1;

if time\>090500 and value8\>=r1

then condition1=true;//外盤是內盤的 1.5倍以上

if value3\>=q2 and value4\>q3

then condition2=true;//總委賣夠大且買賣差也夠大

value9=average(value5,20);

if value5\>=value9\*(1+r2/100)

then condition3=true;//佔大盤成交值比重明顯回昇

if value6\>q4 and value7\>average(value7,20)\*(1+r3/100)

then condition4=true;//開盤委買張數及均張都夠迷人

if condition1 or condition2 or condition3 or condition4

then ret=1;

---

## 場景 941：運用趨勢性指標時，透過股性做確認趨勢是否成形 — 基於上述的精神，我寫了一個腳本如下:

來源：[運用趨勢性指標時，透過股性做確認趨勢是否成形](https://www.xq.com.tw/xstrader/%e9%81%8b%e7%94%a8%e8%b6%a8%e5%8b%a2%e6%80%a7%e6%8c%87%e6%a8%99%e6%99%82%ef%bc%8c%e9%80%8f%e9%81%8e%e8%82%a1%e6%80%a7%e5%81%9a%e7%a2%ba%e8%aa%8d%e8%b6%a8%e5%8b%a2%e6%98%af%e5%90%a6%e6%88%90%e5%bd%a2/) 說明：基於上述的精神，我寫了一個腳本如下:

//先預計兩個前提假設都不存在

condition1=false;

condition2=false;

//定義趨勢明確的條件

// MACD 黃金交叉 (dif向上穿越macd)

//

input: FastLength(12, "DIF短期期數"), SlowLength(26, "DIF長期期數"), MACDLength(9, "MACD期數");

variable: difValue(0), macdValue(0), oscValue(0);

SetBarBack(maxlist(FastLength,SlowLength,6) \+ MACDLength);

SetTotalBar((maxlist(FastLength,SlowLength,6) \+ MACDLength) \* 4);

MACD(weightedclose(), FastLength, SlowLength, MACDLength, difValue, macdValue, oscValue);

if difValue Crosses Above macdValue

then condition1=true;

//定義有足夠的證據顯示股性出現轉變

input:day(66,"股性指標的移動平均天數");

input:ratio(10,"股性指標超出均值比率");

variable:count(0);

value1=q\_TotalTicks;//總成交次數

value2=average(value1,day);

value3=GetField("強弱指標");

value4=average(value3,day);

value5=GetField("外盤均量");

value6=average(value5,day);

value7=GetField("主動買力");

value8=average(value7,day);

value9=GetField("開盤委買");

value10=average(value9,day);

count=0;

if value1\>=value2\*(1+ratio/100)

then count=count+1;

if value3\>=value4\*(1+ratio/100)

then count=count+1;

if value5\>=value6\*(1+ratio/100)

then count=count+1;

if value7\>=value8\*(1+ratio/100)

then count=count+1;

if value9=value10\*(1+ratio/100)

then count=count+1;

if count \>=3 then condition2=true;

//當上昇趨勢成形且股性明顯轉變時

if condition1 and condition2

then ret=1;

---

## 場景 942：用XS寫籌碼集中度的選股策略

來源：[用XS寫籌碼集中度的選股策略](https://www.xq.com.tw/xstrader/%e7%94%a8xs%e5%af%ab%e7%b1%8c%e7%a2%bc%e9%9b%86%e4%b8%ad%e5%ba%a6%e7%9a%84%e9%81%b8%e8%82%a1%e7%ad%96%e7%95%a5/) 說明：我的函數寫法如下:

input:days(numericsimple,"計算天數");

value1=GetField("主力買賣超張數");

value2=summation(volume,days);

value3=summation(value1,days);

if value2\<\>0

then value4=value3/value2\*100;

bs=value4;

---

## 場景 943：用XS寫籌碼集中度的選股策略 — 接下來我用這個函數寫了下面這個腳本:

來源：[用XS寫籌碼集中度的選股策略](https://www.xq.com.tw/xstrader/%e7%94%a8xs%e5%af%ab%e7%b1%8c%e7%a2%bc%e9%9b%86%e4%b8%ad%e5%ba%a6%e7%9a%84%e9%81%b8%e8%82%a1%e7%ad%96%e7%95%a5/) 說明：接下來我用這個函數寫了下面這個腳本:

input:days(10,"天數");

input:ratio(5,"最低百分比");

input:percent(10,"漲幅上限");

value1=bs(days);

if close\[days-1\]\<\>0 and close\>close\[days-1\]

then value2=(close-close\[days-1\])/close\[days-1\]\*100;

if value1\>ratio and value2\<percent 

then ret=1;

outputfield(1,value1,0,"籌碼集中度");

outputfield(2,value2,1,"區間漲幅%");

---

## 場景 944：高毛利低獲利高成長的股票～選股起手式 — 為了不斷地尋找有這種可能的股票，我寫了以下的腳本

來源：[高毛利低獲利高成長的股票～選股起手式](https://www.xq.com.tw/xstrader/%e9%ab%98%e6%af%9b%e5%88%a9%e4%bd%8e%e7%8d%b2%e5%88%a9%e9%ab%98%e6%88%90%e9%95%b7%e7%9a%84%e8%82%a1%e7%a5%a8%ef%bd%9e%e9%81%b8%e8%82%a1%e8%b5%b7%e6%89%8b%e5%bc%8f/) 說明：為了不斷地尋找有這種可能的股票，我寫了以下的腳本

input:gr(45,"毛利率下限");

input:epsy(0.5,"最近一季每股稅後EPS上限");

input:gwr(10,"最近三個月營收yoy平均成長率下限");

value1=GetField("營業毛利率","Q");

value2=GetField("每股稅後淨利(元)","q");

value3=GetField("月營收年增率","M");

value4=average(value3,3);

 

if value1\>= gr 

and value2\<=epsy 

and value2\>0

and value4\>=gwr

then ret=1; 

outputfield(1,value1,0,"營業毛利率");

outputfield(2,value2,2,"最近一季EPS");

outputfield(3,value4,1,"最近三個月營收yoy平均成長率");

---

## 場景 945：急漲拉回轉強三部曲 — 現在有了XS，我試著寫了一個腳本：

來源：[急漲拉回轉強三部曲](https://www.xq.com.tw/xstrader/%e6%80%a5%e6%bc%b2%e6%8b%89%e5%9b%9e%e8%bd%89%e5%bc%b7%e4%b8%89%e9%83%a8%e6%9b%b2/) 說明：現在有了XS，我試著寫了一個腳本：

//波段高點距今一段時間

//起算點到波段高點不算長且漲幅不小

//波段高點到昨日收盤有一定的拉回幅度

//今天開高，出量且相對走強

var:period(20);//波段天期

input:up(25,"上漲幅度");

input:down(15,"上跌幅度");

value1=highest(high,period);

value2=highestbar(high,period);

value3=q\_CashDirect;//成交比重

value4=q\_OrderRatio;//委託買賣差佔總委託比

condition1=false;

condition2=false;

condition3=false;

for period=20 to 60

begin

if value1\>=close\[period-1\]\*(1+up/100)

then condition1=true;

//波段漲幅不小

if value2\>period/3

then condition2=true;

//起算點到波段高點時間不算長

if close\[1\]\<value1\*(1-down/100)and close\[1\]\>close\[period-1\]

then condition3=true;

//波段高點到昨日收盤有一定的拉回幅度

if condition1 and condition2 and condition3

and open\>=close\[1\]\*1.015//開高

and value3\>average(value3,5)//量增

and value4\>average(value4,5)//委買增

then ret=1;

end;

---

## 場景 946：大盤多空轉換點之探討系列三: MFO資金流震盪指標 — 這個指標的XS腳本如下:

來源：[大盤多空轉換點之探討系列三: MFO資金流震盪指標](https://www.xq.com.tw/xstrader/%e5%a4%a7%e7%9b%a4%e5%a4%9a%e7%a9%ba%e8%bd%89%e6%8f%9b%e9%bb%9e%e4%b9%8b%e6%8e%a2%e8%a8%8e%e7%b3%bb%e5%88%97%e4%b8%89-mfo%e8%b3%87%e9%87%91%e6%b5%81%e9%9c%87%e7%9b%aa%e6%8c%87%e6%a8%99/) 說明：這個指標的XS腳本如下:

input:period(20,"計算天期");

value1= ((high-low\[1\])-(high\[1\]-low))/((high-low\[1\])+(high\[1\]-low))\*volume;

value2= summation(value1,period)/summation(volume,period);

plot1(value2,"MFO資金流震盪指標");

---

## 場景 947：內外盤量差指標

來源：[內外盤量差指標](https://www.xq.com.tw/xstrader/%e5%a4%a7%e7%9b%a4%e5%a4%9a%e7%a9%ba%e8%bd%89%e6%8f%9b%e9%bb%9e%e4%b9%8b%e6%8e%a2%e8%a8%8e%e7%b3%bb%e5%88%97%e4%ba%8c%e5%85%a7%e5%a4%96%e7%9b%a4%e9%87%8f/) 說明：它的腳本如下:

input:period(5);

input:period1(20);

setinputname(1,"短期移動平均天數");

setinputname(2,"長期移動平均天數");

value1=GetField("內盤量");

value2=getfield("外盤量");

if value1\<\>0

then value3=value2/value1;

value4=average(value3,period);

value5=average(value3,period1);

value6=value4-value5;

plot1(value6,"長短天期差");

---

## 場景 948：大盤多空轉換點之探討系列一:  上漲的股票有沒有200檔? — 這樣的法則，是來自於我寫的一個自訂指標，它的腳本如下:

來源：[大盤多空轉換點之探討系列一:  上漲的股票有沒有200檔?](https://www.xq.com.tw/xstrader/%e5%a4%a7%e7%9b%a4%e5%a4%9a%e7%a9%ba%e8%bd%89%e6%8f%9b%e9%bb%9e%e4%b9%8b%e6%8e%a2%e8%a8%8e%e7%b3%bb%e5%88%97%e4%b8%80-%e4%b8%8a%e6%bc%b2%e7%9a%84%e8%82%a1%e7%a5%a8%e6%9c%89%e6%b2%92%e6%9c%89200/) 說明：這樣的法則，是來自於我寫的一個自訂指標，它的腳本如下:

input:shortterm(5);

input:midterm(15);

setinputname(1,"短期均線");

setinputname(2,"中期均線");

value1=GetField("上漲家數");

value2=lowest(value1,shortterm);

value3=average(value2,midterm);

 

plot1(value3,"中期均線");

plot2(200);

plot3(100);

---

## 場景 949：火箭後拉回

來源：[火箭後拉回](https://www.xq.com.tw/xstrader/%e7%81%ab%e7%ae%ad%e5%be%8c%e6%8b%89%e5%9b%9e/)

input:TXT1("僅適用1分鐘線"); setinputname(1,"使用限制");

if barfreq \="Min" and barinterval \=1 and

 close\[1\]/close\[2\]\>1.015 and //上個1分鐘線單分鐘拉超過1.5%

 q\_dailyhigh \> high and //高不過高

 Close \< q\_dailyhigh\*0.99 and //自高檔回1%

 Close \> Low\[1\]

 then ret=1;

---

## 場景 950：逢低承接的力道 — 我們怎麼找出近來低檔有撐的股票呢，請參考以下的腳本

來源：[逢低承接的力道](https://www.xq.com.tw/xstrader/%e7%9f%ad%e7%b7%9a%e6%ad%a2%e8%b7%8c%e7%9a%84%e8%a8%8a%e8%99%9f/) 說明：我們怎麼找出近來低檔有撐的股票呢，請參考以下的腳本

input:short1(5),mid1(20);

setinputname(1,"短期平均");

setinputname(2,"長期平均");

if truerange\<\>0

then begin

if close\<=open

then

value1=(close-low)/truerange\*100

else

value1=(open-low)/truerange\*100;

end;

value2=average(value1,short1);

value3=average(value2,mid1);

plot1(value2,"短期均線");

plot2(value3,"長期均線");

---

## 場景 951：散戶買進賣出比例及控盤者買賣盤

來源：[散戶買進賣出比例及控盤者買賣盤](https://www.xq.com.tw/xstrader/%e7%a0%94%e5%88%a4%e4%b8%bb%e5%8a%9b%e6%9c%89%e6%b2%92%e6%9c%89%e8%90%bd%e8%b7%91%e7%9a%84%e8%87%aa%e8%a8%82%e6%8c%87%e6%a8%99/) 說明：第一個腳本如下：

input:period(5);

value1=GetField("散戶買張");

if volume\<\>0 then 

value2=value1/volume\*100;

value3=average(value2,period);

plot1(value3,"散戶買進比例");

---

## 場景 952：散戶買進賣出比例及控盤者買賣盤

來源：[散戶買進賣出比例及控盤者買賣盤](https://www.xq.com.tw/xstrader/%e7%a0%94%e5%88%a4%e4%b8%bb%e5%8a%9b%e6%9c%89%e6%b2%92%e6%9c%89%e8%90%bd%e8%b7%91%e7%9a%84%e8%87%aa%e8%a8%82%e6%8c%87%e6%a8%99/) 說明：第二個腳本如下：

input:period(5);

value1=GetField("散戶賣張");

if volume\<\>0 then value2=value1/volume\*100;

value3=average(value2,period);

plot1(value3,"散戶賣出比例");

---

## 場景 953：散戶買進賣出比例及控盤者買賣盤

來源：[散戶買進賣出比例及控盤者買賣盤](https://www.xq.com.tw/xstrader/%e7%a0%94%e5%88%a4%e4%b8%bb%e5%8a%9b%e6%9c%89%e6%b2%92%e6%9c%89%e8%90%bd%e8%b7%91%e7%9a%84%e8%87%aa%e8%a8%82%e6%8c%87%e6%a8%99/) 說明：第三個腳本如下：

value1=GetField("控盤者買賣超張數");

 

if value1\>0 then value2=value1 else value3=value1; 

if value1\>0 then begin plot1(value2); 

noplot(value3); 

end else 

begin plot2(value3); 

noplot(value2); 

end;

---

## 場景 954：John Bogle的股票預期報酬率模型 — 根據這樣的思考，我寫了一個腳本來計算台股的預期報酬率

來源：[John Bogle的股票預期報酬率模型](https://www.xq.com.tw/xstrader/john-bogle%e7%9a%84%e8%82%a1%e7%a5%a8%e9%a0%90%e6%9c%9f%e5%a0%b1%e9%85%ac%e7%8e%87%e6%a8%a1%e5%9e%8b/) 說明：根據這樣的思考，我寫了一個腳本來計算台股的預期報酬率

input:ratio(10,"報酬率下限");

input:pe1(15,"預估市場整體本益比");

value1=GetField("累計營收年增率","M");

value2=GetField("股利合計","Y");

value3=value2\*(1+value1/100);//預估股息收益率

value4=value3/close\*100;//股利殖利率 

value6=GetField("營業利益","Q");//取得最近一季營業利益，單位百萬

value7=GetField("最新股本");//單位億

if close\<\>0 then begin 

value8=(value6\*4)/(value7\*10);//用最近一季營業利益估算的每股盈餘

value9=close/value3;//預估本益比

value5=value1+value4+pe1-value9;//預估盈餘年增率+預估股息收益率

end;

if value5\>ratio and value1\<30 and value3\>5 

then ret=1;

outputfield(1,value1,1,"累計營收年增率");

outputfield(2,value4,1,"股利殖利率");

outputfield(3,value9,1,"預估本益比");

outputfield(4,value5,1,"預估報酬率");

---

## 場景 955：透過XS選股平台制訂選股策略的流程 — 為了作到這件事，我寫了下面這個腳本

來源：[透過XS選股平台制訂選股策略的流程](https://www.xq.com.tw/xstrader/%e9%80%8f%e9%81%8exs%e9%81%b8%e8%82%a1%e5%b9%b3%e5%8f%b0%e5%88%b6%e8%a8%82%e9%81%b8%e8%82%a1%e7%ad%96%e7%95%a5%e7%9a%84%e6%b5%81%e7%a8%8b/) 說明：為了作到這件事，我寫了下面這個腳本

input:aday(20150824,"漲跌幅計算起點");

input:ratio(10,"漲跌幅過濾標準");

input:trendmark(1,"1:超過標準,2:低於標準");

value1=getbaroffset(aday);

if trendmark=1

then begin

if close\>close\[value1\]\*(1+ratio/100)

then ret=1;

end;

if trendmark=2

then begin

if close\<close\[value1\]\*(1+ratio/100)

then ret=1;

end;

if close\[value1\]\<\>0

then value2=(close-close\[value1\])/close\[value1\]\*100;

setoutputname1("起始日迄今漲跌幅%");

outputfield1(value2);

setoutputname2("股本(億)");

outputfield2(GetField("最新股本"));

outputfield(3,GetField("累計營收年增率","M"),0,"累計營收年增率");

outputfield(4,GetField("股價淨值比","D"),1,"股價淨值比");

outputfield(5,GetField("董監持股佔股本比例","D"),1,"董監持股比例");

outputfield(6,GetField("股利合計","Y"),1,"股利合計");

outputfield(7,GetField("投信持股比例","D"),1,"投信持股比例");

outputfield(8,GetField("公司掛牌日期"),0,"公司掛牌日期");

outputfield(9,GetField("營業毛利率","Q"),1,"毛利率");

outputfield(10,GetField("營業利益成長率","Q"),1,"營業利益成長率");

---

## 場景 956：關於背離的寫法 — 我就是運用這個原理，寫出以下的背離函數

來源：[關於背離的寫法](https://www.xq.com.tw/xstrader/%e9%97%9c%e6%96%bc%e8%83%8c%e9%9b%a2%e7%9a%84%e5%af%ab%e6%b3%95/) 說明：我就是運用這個原理，寫出以下的背離函數

input:price(numericsimple),index1(numericsimple),length(numericsimple);

if length\<5

then raiseruntimeerror("計算期別請超過五期");

value1=linearregslope(price,length);

value2=linearregslope(index1,length);

if value1\>0 and value2\<0

then deviate=-1

else

if value1\<0 and value2\>0

then deviate=1

else

deviate=0;

---

## 場景 957：關於背離的寫法 — 假設我們想找出收盤價下跌，但跟10日RSI上昇的股票，我們就可以運用這個函數，寫出下面這樣的腳本

來源：[關於背離的寫法](https://www.xq.com.tw/xstrader/%e9%97%9c%e6%96%bc%e8%83%8c%e9%9b%a2%e7%9a%84%e5%af%ab%e6%b3%95/) 說明：假設我們想找出收盤價下跌，但跟10日RSI上昇的股票，我們就可以運用這個函數，寫出下面這樣的腳本

value1=rsi(close,10);

if deviate(close,value1,10)=1

then ret=1;

---

## 場景 958：尋找那些跌過頭的股票 — 其中第一條是一個我自己寫的選股腳本，內容如下:

來源：[尋找那些跌過頭的股票](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e9%82%a3%e4%ba%9b%e8%b7%8c%e9%81%8e%e9%a0%ad%e7%9a%84%e8%82%a1%e7%a5%a8/) 說明：其中第一條是一個我自己寫的選股腳本，內容如下:

input:ratio(80,"佔總市值百分比%");

if (GetField("流動資產","Q")-GetField("負債總額","Q"))/100\>GetField("總市值","D")\*ratio/100

then ret=1;

---

## 場景 959：年底前投信作帳的可能標的

來源：[年底前投信作帳的可能標的](https://www.xq.com.tw/xstrader/%e5%b9%b4%e5%ba%95%e5%89%8d%e6%8a%95%e4%bf%a1%e4%bd%9c%e5%b8%b3%e7%9a%84%e5%8f%af%e8%83%bd%e6%a8%99%e7%9a%84/) 說明：這個腳本如下:

input:r1(50),day(30),r2(15),r3(5000),r4(30);

setinputname(1,"股本上限單位億");

setinputname(2,"天期");

setinputname(3,"區間買超天數");

setinputname(4,"區間合計買超張數");

setinputname(5,"漲幅上限");

value1=GetField("投信買張","D");

value2=GetField("最新股本");//單位:億

condition1=false;

condition2=false;

condition3=false;

if value2\<r1

then condition1=true;//股本小於50億元

value3=countif(value1\>50,day);

if value3\>=r2

then condition2=true;//近30天裡有超過15天買超

if summation(value1,day)\>r3

then condition3=true;//近30天合計買超超過5000張

if condition1 and condition2 and condition3

and close\<close\[day-1\]\*(1+r4/100)

then ret=1;

---

## 場景 960：平台整理後的突破與跌破 — 剛好XQ系統內建有一個專門找出這種股票的腳本，我就直接PO上來給大家參考。

來源：[平台整理後的突破與跌破](https://www.xq.com.tw/xstrader/%e5%b9%b3%e5%8f%b0%e6%95%b4%e7%90%86%e5%be%8c%e7%9a%84%e7%aa%81%e7%a0%b4%e8%88%87%e8%b7%8c%e7%a0%b4/) 說明：剛好XQ系統內建有一個專門找出這種股票的腳本，我就直接PO上來給大家參考。

input:LS(0); setinputname(1,"多空設定");

settotalbar(300);

setbarback(50);

variable:HP(0);HP \= Highest(H\[1\],20);

variable:LP(0);LP \= Lowest(L\[1\],20);

variable:MID(0); MID \= (HP+LP)/2;

variable:Q1(0); Q1 \= (HP+MID)/2;

variable:Q2(0); Q2 \= (MID+LP)/2;

variable:i(0),j(0);

j=0;

for i \= 1 to 20

begin

if (C\[i\] \> MID and C\[i+1\]\< MID) or

 (C\[i\] \< MID and C\[i+1\]\> MID) then j+=1;

end;

condition1 \= HP \> LP\*1.14 and j \>8 and average(v,20)\>200;

if LS\>0 and H \>HP and condition1 then ret=1;

if LS\<0 and L \<LP and condition1 then ret=1;

---

## 場景 961：幫手中持股設定賣出訊號出現時的通知機制

來源：[幫手中持股設定賣出訊號出現時的通知機制](https://www.xq.com.tw/xstrader/%e5%b9%ab%e6%89%8b%e4%b8%ad%e6%8c%81%e8%82%a1%e8%a8%ad%e5%ae%9a%e8%b3%a3%e5%87%ba%e8%a8%8a%e8%99%9f%e5%87%ba%e7%8f%be%e6%99%82%e7%9a%84%e9%80%9a%e7%9f%a5%e6%a9%9f%e5%88%b6/) 說明：這個腳本如下:

//DMI賣出訊號

 input:Length(14); setinputname(1,"計算期數");

 variable: pdi(0), ndi(0), adx\_value(0);

 DirectionMovement(Length, pdi, ndi, adx\_value);

 if pdi\<pdi\[1\] and ndi\>ndi\[1\] and ndi crosses over pdi

 then ret=1

 else begin

   //KD高檔死亡交叉

   input: Length1(9), RSVt(3), Kt(3), HighBound(75);

   SetInputName(1, "計算期數");

   SetInputName(2, "RSVt權數");

   SetInputName(3, "Kt權數");

   SetInputName(4, "高檔區");

   variable: rsv(0), k(0), \_d(0);

   Stochastic(Length1, RSVt, Kt, rsv, k, \_d);

   if k\>HighBound and k crosses under \_d

   then ret=1

   else begin

     //MTM由正轉負

     input: Length2(10); SetInputName(1, "期數");

     if momentum(close,Length2) crosses under 0

     then ret=1

     else begin

       //投信法人都賣超

       if Open \< Close\[1\] and Close \< Close\[1\] and

          GetField("外資買賣超")\[1\]\<0 and GetField("投信買賣超")\[1\]\<0

       then ret=1

       else begin

         //MACD出現賣出訊號

         input: FastLength(12), SlowLength(26), MACDLength(9);

         SetInputName(1, "DIF短期期數");

         SetInputName(2, "DIF長期期數");

         SetInputName(3, "MACD天數");

         variable: difValue(0), macdValue(0), oscValue(0);

         MACD(weightedclose(), FastLength, SlowLength, MACDLength, difValue, macdValue, oscValue);

         if oscValue Crosses Below 0

         then ret=1

         else begin

           //RSI高檔死亡交叉

           input: Length4(6); SetInputName(1, "短期期數");

           input: Length5(12); SetInputName(2, "長期期數");

           input: HighBound1(75); SetInputName(3, "高檔區");

           value1=RSI(close,Length4);

           value2=RSI(close,Length5);

           if value1 crosses under value2 and value1\>HighBound1

           then ret=1

           else begin

             //一舉跌破多根均線

             input: shortlength(5); setinputname(1,"短期均線期數");

             input: midlength(10); setinputname(2,"中期均線期數");

             input: Longlength(20); setinputname(3,"長期均線期數");

             variable: shortaverage(0);

             variable: midaverage(0);

             variable: Longaverage(0);

             shortaverage=Average(close,shortlength);

             midaverage=Average(close,midlength) ;

             Longaverage \= Average(close,Longlength);

             if close crosses under shortaverage and

                close crosses under midlength and

                close crosses under Longaverage

             then ret=1;

           end;

         end;

       end;

     end;

   end;

end;

---

## 場景 962：那些股票有年底作帳行情?

來源：[那些股票有年底作帳行情?](https://www.xq.com.tw/xstrader/%e9%82%a3%e4%ba%9b%e8%82%a1%e7%a5%a8%e6%9c%89%e5%b9%b4%e5%ba%95%e4%bd%9c%e5%b8%b3%e8%a1%8c%e6%83%85/) 說明：我寫的腳本如下:

value1=getbaroffset(20141201);

value2=getbaroffset(20141231);

value3=getbaroffset(20131201);

value4=getbaroffset(20131231);

value5=getbaroffset(20121201);

value6=getbaroffset(20121231);

value7=getbaroffset(20111201);

value8=getbaroffset(20111231);

input:r1(5,"最低月報酬率%");

if close\[value2\]\>close\[value1\]\*(1+r1/100)

and close\[value4\]\>close\[value3\]\*(1+r1/100)

and close\[value6\]\>close\[value5\]\*(1+r1/100)

and close\[value8\]\>close\[value7\]\*(1+r1/100)

then ret=1;

---

## 場景 963：什麼股票今天會拉漲停\~老業內的不傳之秘二 — 基本這樣的邏輯，我寫了一個腳本如下:

來源：[什麼股票今天會拉漲停\~老業內的不傳之秘二](https://www.xq.com.tw/xstrader/%e4%bb%80%e9%ba%bc%e8%82%a1%e7%a5%a8%e4%bb%8a%e5%a4%a9%e6%9c%83%e6%8b%89%e6%bc%b2%e5%81%9c%e8%80%81%e6%a5%ad%e5%85%a7%e7%9a%84%e4%b8%8d%e5%82%b3%e4%b9%8b%e7%a7%98%e4%ba%8c/) 說明：基本這樣的邏輯，我寫了一個腳本如下:

input:days(5);

input:period(20);

input:r1(20);

input:r2(10);

input:r3(2);

input:v1(1000);

setinputname(1,"短期天數");

setinputname(2,"波段天數");

setinputname(3,"波段最低跌幅");

setinputname(4,"短期最低跌幅");

setinputname(5,"本日急拉幅度");

setinputname(6,"成交量下限");

condition1=false;

condition2=false;

condition3=false;

if highest(high,period)\>=close\[1\]\*(1+r1/100)

then condition1=true;

if highest(high,days)\>=close\[1\]\*(1+r2/100)

then condition2=true;

if close\>=close\[1\]\*(1+r3/100) and volume\>=v1

then condition3=true;

if condition1 and condition2 and condition3

then ret=1;

---

## 場景 964：什麼股票今天會拉漲停\~老業內的不傳之秘一

來源：[什麼股票今天會拉漲停\~老業內的不傳之秘一](https://www.xq.com.tw/xstrader/%e4%bb%80%e9%ba%bc%e8%82%a1%e7%a5%a8%e4%bb%8a%e5%a4%a9%e6%9c%83%e6%8b%89%e6%bc%b2%e5%81%9c%e8%80%81%e6%a5%ad%e5%85%a7%e7%9a%84%e4%b8%8d%e5%82%b3%e4%b9%8b%e7%a7%98%e4%b8%80/) 說明：我寫的腳本如下:

input: stardate(20150824);//輸入計算波段漲幅的起始日期

input:ratio(30);//輸入波段上漲的最低要求漲幅

input:ratio1(7);//輸入見高點後至今的拉回最小幅度

input:ratio2(2);//輸入最新一日的最低漲幅

setinputname(1,"輸入上漲起始日");

setinputname(2,"輸入上漲最低幅度");

setinputname(3,"輸入最小拉回幅度");

setinputname(4,"今日最低漲幅");

value1=getbaroffset(stardate);//找出起始日是距今第幾根bar

value2=highest(high\[1\],value1+1);//找出波段高點

condition1=false;

condition2=false;

if value2\>=close\[value1\]\*(1+ratio/100)

then condition1=true;//波段高點跟起漲點收盤價相比要滿足最低漲幅

if value2\>=close\[1\]\*(1+ratio1/100)//現價低於高點超過一定幅度

then condition2=true;//

if nthhighestbar(1,high,10)\>=5//現在距離近10日高點超過五根

then begin

if condition1 and condition2 and close\>=close\[1\]\*(1+ratio2/100)

then ret=1;

end;

---

## 場景 965：比大盤強的天數 — 為了要找出這樣的股票，我寫了一個自訂指標叫比大盤強的天數(10天裡)，腳本如下:

來源：[比大盤強的天數](https://www.xq.com.tw/xstrader/%e8%82%a1%e6%80%a7%e7%b3%bb%e5%88%97%e4%b9%8b%e4%b8%83-%e6%af%94%e5%a4%a7%e7%9b%a4%e5%bc%b7%e7%9a%84%e5%a4%a9%e6%95%b8/) 說明：為了要找出這樣的股票，我寫了一個自訂指標叫比大盤強的天數(10天裡)，腳本如下:

INPUT:day(10);

input:period(20);

VALUE1=GetField("強弱指標");

VALUE2=COUNTIF(VALUE1\>1,day);

value3=average(value2,period);

PLOT1(VALUE2,"比大盤強的天數");

plot2(value3,"20日移動平均");

---

## 場景 966：用月營收來選股的幾種方法 — 二，以最新一個月營收去估算EPS後，用這EPS來估算出來低本益比的股票這個選股策略的腳本如下:

來源：[用月營收來選股的幾種方法](https://www.xq.com.tw/xstrader/%e7%94%a8%e6%9c%88%e7%87%9f%e6%94%b6%e4%be%86%e9%81%b8%e8%82%a1%e7%9a%84%e5%b9%be%e7%a8%ae%e6%96%b9%e6%b3%95/) 說明：二，以最新一個月營收去估算EPS後，用這EPS來估算出來低本益比的股票這個選股策略的腳本如下:

value1=GetField("月營收","M");//單位:億元

value2=GetField("月營收月增率","M");

value3=GetField("月營收年增率","M");

value4=GetField("營業利益率","Q");

value5=GetField("最新股本");//單位:億元

condition1=false;

condition2=false;

input:peraito(12);

setinputname(1,"預估本益比上限");

if value5\<\>0

then

value6=(value1\*value4\*12)/(value5\*10);//單月營收推估的本業EPS

if value6\<\>0

then

value7=close/value6;

if value7\<peraito and value7\>0

then condition1=true;//推估本益比低於10

if value3\>0 and value2\>15 and value2\[1\]\>0

then condition2=true;

if condition1 and condition2

then ret=1;

SetOutputName1("推估本益比");

OutputField1(value7);

setoutputname2("營業利益率");

outputfield2(value4);

---

## 場景 967：用月營收來選股的幾種方法 — 五，營收再起飛這個策略是去尋找那些過去月營收年增率是走下降趨勢，但最近開始轉為上昇趨勢的公司我們用的腳本如下:

來源：[用月營收來選股的幾種方法](https://www.xq.com.tw/xstrader/%e7%94%a8%e6%9c%88%e7%87%9f%e6%94%b6%e4%be%86%e9%81%b8%e8%82%a1%e7%9a%84%e5%b9%be%e7%a8%ae%e6%96%b9%e6%b3%95/) 說明：五，營收再起飛這個策略是去尋找那些過去月營收年增率是走下降趨勢，但最近開始轉為上昇趨勢的公司我們用的腳本如下:

input:TXT("僅適用月線"); setinputname(1,"使用限制");

If barfreq \<\> "M" then raiseruntimeerror("頻率設定有誤");

setbarback(20);

settotalbar(20 \* 2 \+ 5);

value1=GetField("月營收年增率","M");

value2=average(GetField("月營收年增率","M"), 3);

value3=linearregslope(value2,20);

value4=linearregslope(value2,5);

if value3 \< 0 and value4 crosses above 0

then ret=1;

---

## 場景 968：真實波動區間指標 — 真實高點的計算方式如下:

來源：[真實波動區間指標](https://www.xq.com.tw/xstrader/%e8%82%a1%e6%80%a7%e7%b3%bb%e5%88%97%e4%b9%8b%e5%85%ad%e7%9c%9f%e5%af%a6%e6%b3%a2%e5%8b%95%e5%8d%80%e9%96%93/) 說明：真實高點的計算方式如下:

if Close\[1\] \> High then TrueHigh \= Close\[1\]

else TrueHigh \= High;

---

## 場景 969：真實波動區間指標 — 真實低點的計算方式如下:

來源：[真實波動區間指標](https://www.xq.com.tw/xstrader/%e8%82%a1%e6%80%a7%e7%b3%bb%e5%88%97%e4%b9%8b%e5%85%ad%e7%9c%9f%e5%af%a6%e6%b3%a2%e5%8b%95%e5%8d%80%e9%96%93/) 說明：真實低點的計算方式如下:

if Close\[1\] \< Low then TrueLow \= Close\[1\]

else TrueLow \= Low;

---

## 場景 970：真實波動區間指標 — 根據這個公式，我也是用短中期不同的均線，來衡量一檔股票平均的波動區間到底有多大。

來源：[真實波動區間指標](https://www.xq.com.tw/xstrader/%e8%82%a1%e6%80%a7%e7%b3%bb%e5%88%97%e4%b9%8b%e5%85%ad%e7%9c%9f%e5%af%a6%e6%b3%a2%e5%8b%95%e5%8d%80%e9%96%93/) 說明：根據這個公式，我也是用短中期不同的均線，來衡量一檔股票平均的波動區間到底有多大。

input: Length1(3);

input: length2(20);

SetInputName(1, "短天數");

setinputname(2,"長天數");

value1 \= Average(TrueRange, Length1);

value2=average(truerange,length2);

Plot1(value1, "ATR");

plot2(value2);

---

## 場景 971：開盤委買張數 — 基於上述的精神，我寫了一個開盤委買的指標，其腳本如下:

來源：[開盤委買張數](https://www.xq.com.tw/xstrader/%e8%82%a1%e6%80%a7%e5%88%86%e6%9e%90%e4%b9%8b%e5%9b%9b-%e9%96%8b%e7%9b%a4%e5%a7%94%e8%b2%b7%e5%bc%b5%e6%95%b8/) 說明：基於上述的精神，我寫了一個開盤委買的指標，其腳本如下:

input:short1(3),mid1(20);

setinputname(1,"短期平均");

setinputname(2,"長期平均");

value1=GetField("開盤委買");

value2=average(value1,short1);

value3=average(value1,mid1);

plot1(value2,"短期均線");

plot2(value3,"長期均線");

---

## 場景 972：法人買張比乖離指標 — 以下是根據上述的推演所寫的自訂指標腳本:

來源：[法人買張比乖離指標](https://www.xq.com.tw/xstrader/%e8%82%a1%e6%80%a7%e7%b3%bb%e5%88%97%e4%b9%8b%e4%b8%89%e6%b3%95%e4%ba%ba%e8%b2%b7%e5%bc%b5%e4%bd%94%e6%88%90%e4%ba%a4%e9%87%8f%e6%af%94%e4%be%8b/) 說明：以下是根據上述的推演所寫的自訂指標腳本:

input:length1(5);

input:length2(20);

setinputname(1,"短天期均線天期");

setinputname(2,"長天期均線天期");

value1=GetField("法人買張");

if volume\<\>0

then value2=value1/volume\*100;//法人買張佔成交量比例

value3 \= Average(value2, length1);

value4=average(value2,length2);

plot1(value3);

plot2(value4);

---

## 場景 973：資金流向指標 — 我用這個欄位，寫了以下的一個自訂指標

來源：[資金流向指標](https://www.xq.com.tw/xstrader/%e8%82%a1%e6%80%a7%e7%b3%bb%e5%88%97%e4%b9%8b%e4%ba%8c%e8%b3%87%e9%87%91%e6%b5%81%e5%90%91/) 說明：我用這個欄位，寫了以下的一個自訂指標

input:period(3);

input:period1(15);

setinputname(1,"短期移動平均天數");

setinputname(2,"長期移動平均天數");

value1=GetField("資金流向");

value4=average(value1,period);

value5=average(value1,period1);

plot1(value4,"短期移動平均");

plot2(value5,"長期移動平均");

---

## 場景 974：N日來有幾日漲幅較大天數 — 我用以下的這個腳本做了一個自訂指標，來觀察一檔股票近日來漲幅超過一定比例的天數

來源：[N日來有幾日漲幅較大天數](https://www.xq.com.tw/xstrader/%e8%82%a1%e6%80%a7%e7%b3%bb%e5%88%97%e4%b9%8b%e4%b8%80-n%e6%97%a5%e4%be%86%e6%9c%89%e5%b9%be%e6%97%a5%e6%bc%b2%e5%b9%85%e8%bc%83%e5%a4%a7/) 說明：我用以下的這個腳本做了一個自訂指標，來觀察一檔股票近日來漲幅超過一定比例的天數

input:ratio(2);

input:period(20);

input:period1(10);

setinputname(1,"列入計算之漲幅下限");

setinputname(2,"計算區間");

setinputname(3,"移動平均天數");

SetTotalBar(100);

if close\[1\]\<\>0

then

value1=(close-close\[1\])/close\[1\]\*100;

value2=countif(value1\>=ratio,period);

plot1(value2,"漲幅大的天數");

plot2(average(value2,period1),"移動平均");

---

## 場景 975：N日來有幾日漲幅較大天數 — 基於上述的精神，我寫了一個選股腳本如下:

來源：[N日來有幾日漲幅較大天數](https://www.xq.com.tw/xstrader/%e8%82%a1%e6%80%a7%e7%b3%bb%e5%88%97%e4%b9%8b%e4%b8%80-n%e6%97%a5%e4%be%86%e6%9c%89%e5%b9%be%e6%97%a5%e6%bc%b2%e5%b9%85%e8%bc%83%e5%a4%a7/) 說明：基於上述的精神，我寫了一個選股腳本如下:

input:ratio(2);

input:period(20);

input:period1(10);

setinputname(1,"列入計算之漲幅下限");

setinputname(2,"計算區間");

setinputname(3,"移動平均天數");

if close\[1\]\<\>0

then

value1=(close-close\[1\])/close\[1\]\*100;

value2=countif(value1\>=ratio,period);

value3=average(value2,period1);

if value2 cross over value3

and volume\>=800 and close\<close\[5\]\*1.1

//成交量大於800張且近五日漲幅不到一成

then ret=1;

---

## 場景 976：紅三兵

來源：[紅三兵](https://www.xq.com.tw/xstrader/%e7%b4%85%e4%b8%89%e5%85%b5/)

{

\[檔名:\] 紅三兵 \[資料夾:\] 酒田戰法 \[適用方向\] 多

\[說明:\] 連續三根上漲實體K棒

\[資料讀取\] 10

\[最大引用\] 5

}

{判斷狀況}

condition1= ( close \- open ) \>(high \-low) \* 0.75 ;//狀況1: 實體上漲K棒

condition2= ( close\[1\] \- open\[1\] ) \>(high\[1\] \-low\[1\]) \* 0.75 ;//狀況2: 實體上漲K棒

condition3= ( close\[2\] \- open\[2\] ) \>(high\[2\] \-low\[2\]) \* 0.75 ;//狀況3: 實體上漲K棒

condition4= close \> close\[1\] ;//狀況4: 上漲

condition5= close\[1\] \> close\[2\] ;//狀況5: 上漲

{結果判斷}

IF

condition1

and condition2

and condition3

and condition4

and condition5

THEN RET=1;

---

## 場景 977：多頭遭遇

來源：[多頭遭遇](https://www.xq.com.tw/xstrader/%e5%a4%9a%e9%a0%ad%e9%81%ad%e9%81%87/)

{

\[檔名:\] 多頭遭遇 \[資料夾:\] 酒田戰法 \[適用方向\] 多

\[說明:\] 前期收黑K棒 當期開低走高紅棒嘗試反攻昨收

\[資料讀取\] 10

\[最大引用\] 5

}

{判斷狀況}

condition1= (open\[1\] \- close\[1\] ) \>(high\[1\] \-low\[1\]) \* 0.75 ;//狀況1: 前期出黑K棒

condition2= close\[1\] \< close\[2\] ;//狀況2: 前期收跌

condition3= ( close \- open ) \>(high \-low) \* 0.75 ;//狀況3: 當期收紅K棒

condition4= open \< close\[1\] and close \< close\[1\] ;//狀況4: 開低且收跌

condition5= low \< low\[1\] ;//狀況5: 破前期低點

{結果判斷}

IF

condition1

and condition2

and condition3

and condition4

and condition5

THEN RET=1;

---

## 場景 978：內困三日翻黑

來源：[內困三日翻黑](https://www.xq.com.tw/xstrader/%e5%85%a7%e5%9b%b0%e4%b8%89%e6%97%a5%e7%bf%bb%e9%bb%91/)

{

\[檔名:\] 內困三日翻黑 \[資料夾:\] 酒田戰法 \[適用方向\] 空

\[說明:\] 前兩期為長紅棒後包黑K棒 當期往下跌破紅棒開盤價

\[資料讀取\] 10

\[最大引用\] 5

}

{判斷狀況}

condition1= close\[2\] \> open\[2\] \+ high\[3\]-low\[3\] ;//狀況1: 前前期長紅棒

condition2= high\[2\] \< high\[3\] and low\[2\] \> low\[3\] ;//狀況2: 前期內包黑K棒

condition3= open \>= close\[1\] and close \< open\[2\] ;//狀況3: 開平高跌破三日低點

{結果判斷}

IF

condition1

and condition2

and condition3

THEN RET=1;

---

## 場景 979：吊人線

來源：[吊人線](https://www.xq.com.tw/xstrader/%e5%90%8a%e4%ba%ba%e7%b7%9a/)

{

\[檔名:\] 吊人 \[資料夾:\] 酒田戰法 \[適用方向\] 空

\[說明:\] 短黑棒留長下影線

\[資料讀取\] 10

\[最大引用\] 5

}

{判斷狀況}

condition1= open \= High and close \< open ;//狀況1: 開高收低留黑棒

condition2= (high \-low) \> 2 \*(high\[1\]-low\[1\]) ;//狀況2: 波動倍增

condition3= (close-low)\> (open-close) \*2 ;//狀況3: 下影線為實體兩倍以上

{結果判斷}

IF

condition1

and condition2

and condition3

THEN RET=1;

---

## 場景 980：夜星

來源：[夜星](https://www.xq.com.tw/xstrader/%e5%a4%9c%e6%98%9f/)

{

\[檔名:\] 夜星 \[資料夾:\] 酒田戰法 \[適用方向\] 空

\[說明:\] 紅棒後 開高走低守平盤

\[資料讀取\] 10

\[最大引用\] 5

}

{判斷狀況}

condition1= ( close\[2\] \- open\[2\] ) \> (high\[2\] \-low\[2\]) \* 0.75 ;//狀況1: 前前期實體紅棒

condition2= close\[2\] \> close\[3\] \+ (high\[3\]-low\[3\]) ;//狀況2: 前前期波動放大

condition3= low\[1\] \> high\[2\] and close\[1\]\>open\[1\] ;//狀況3: 前期高開收紅

condition4= open \< close\[1\] and close \< open \- (high\[1\]-low\[1\]) ;//狀況4: 當期開低收黑K棒

{結果判斷}

IF

condition1

and condition2

and condition3

and condition4

THEN RET=1;

---

## 場景 981：孕抱線 — 母子型態與「內困日」的基本假設大致相同，不過，母子僅用實體做為判斷依據，但內困日是使用最高價與最低價的限制。在多頭或空頭走勢持續了一陣子之後，出現了一個與原來趨...

來源：[孕抱線](https://www.xq.com.tw/xstrader/%e5%ad%95%e6%8a%b1%e7%b7%9a/) 說明：母子型態與「內困日」的基本假設大致相同，不過，母子僅用實體做為判斷依據，但內困日是使用最高價與最低價的限制。在多頭或空頭走勢持續了一陣子之後，出現了一個與原來趨勢相同的長日，但第二日開盤價卻與第一日的趨勢相反，而且第二日的主要交易區間皆落在前一個長日之內時，代表原來的強勢的走勢已經出現的危機，而且若第一天的成交量為近期的大量，但第二日的成交量反而明顯量縮時，投資人的不安亦隨之升高。母子或是內困日的...

{

\[檔名:\] 多頭母子 \[資料夾:\] 酒田戰法 \[適用方向\] 多

\[說明:\] 前期收長黑K棒 今期開高小幅收紅不過昨高

\[資料讀取\] 10

\[最大引用\] 5

}

{判斷狀況}

condition1= ( open\[1\] \- close\[1\] ) \>(high\[1\] \-low\[1\])\*0.75 ;//狀況1: 前期出長黑K棒

condition2= close\[1\] \< close\[2\] \- high\[2\]-low\[2\] ;//狀況2: 前期呈波動放大下跌

condition3= ( close \- open ) \>(high \-low) \* 0.75 ;//狀況3: 當期紅棒

condition4= high \< high\[1\] ;//狀況4: 高不過昨高

condition5= low\>low\[1\] ;//狀況5: 低不破昨低

{結果判斷}

IF

condition1

and condition2

and condition3

and condition4

and condition5

THEN RET=1;

---

## 場景 982：鎚頭 — 鎚子與吊人都屬於單K「反轉」型態。當鎚子出現時，若下影線愈長，其反轉的成功率愈高。只要隔日指數開高，空方回補的力道亦會增加。而吊人則是多頭市場的賣壓出現，是否足...

來源：[鎚頭](https://www.xq.com.tw/xstrader/%e9%8e%9a%e9%a0%ad/) 說明：鎚子與吊人都屬於單K「反轉」型態。當鎚子出現時，若下影線愈長，其反轉的成功率愈高。只要隔日指數開高，空方回補的力道亦會增加。而吊人則是多頭市場的賣壓出現，是否足以反轉多頭走勢，則須先後觀察隔日開盤價與收盤價來判斷。

{

\[檔名:\] 鎚頭 \[資料夾:\] 酒田戰法 \[適用方向\] 多

\[說明:\] 開盤後下跌試底,盤中拉升上攻後,收在高點留下下影線

\[資料讀取\] 10

\[最大引用\] 5

}

{判斷狀況}

condition1= close \>=high and close \> open ;//狀況1: 收高

condition2= (high \-low) \> 2 \*(high\[1\]-low\[1\]) ;//狀況2: 波動放大

condition3= (open-low) \> (close \- open) \*2 ;//狀況3: 長下影線

{結果判斷}

IF

condition1

and condition2

and condition3

THEN RET=1;

---

## 場景 983：晨星 — 4.若第三日的K線能深入第一根K線的二分之一以上時，未來反轉的趨勢會愈明顯。

來源：[晨星](https://www.xq.com.tw/xstrader/%e6%99%a8%e6%98%9f/) 說明：4.若第三日的K線能深入第一根K線的二分之一以上時，未來反轉的趨勢會愈明顯。

{

\[檔名:\] 晨星 \[資料夾:\] 酒田戰法 \[適用方向\] 多

\[說明:\] 前前期收長黑K棒 前期再開低震盪收短紅棒後 當期開高紅棒反攻起跌點

\[資料讀取\] 10

\[最大引用\] 5

}

{判斷狀況}

condition1= ( open\[2\] \- close\[2\] ) \>(high\[2\] \-low\[2\]) \* 0.75 ;//狀況1: 前前期出黑K棒

condition2= close\[2\] \< close\[3\]-(high\[3\]-low\[3\]) ;//狀況2: 跌勢擴大

condition3= ( close \- open ) \>(high \-low) \* 0.75 ;//狀況3: 當期收紅K棒

condition4= close\> close\[2\] ;//狀況4: 收復黑棒收盤價

condition5= close\[1\] \<= close\[2\] and close\[1\] \< open ;//狀況5: 前低收盤為三期低點

{結果判斷}

IF

condition1

and condition2

and condition3

and condition4

and condition5

THEN RET=1;

---

## 場景 984：自訂指標 — 在這畫面你可以開始描述你的指標計算公式，語法跟警示的腳本寫法一樣，例如我們可以設一個指標，用來計算每天收盤價與月線之間的差， 如果這個差的三天移動平均站上零，應...

來源：[自訂指標](https://www.xq.com.tw/xstrader/%e8%87%aa%e8%a8%82%e6%8c%87%e6%a8%99/) 說明：在這畫面你可以開始描述你的指標計算公式，語法跟警示的腳本寫法一樣，例如我們可以設一個指標，用來計算每天收盤價與月線之間的差， 如果這個差的三天移動平均站上零，應該就代表波段轉向多頭走勢，這個指標的腳本如下

value1=average(close,22);

value2=close-value1;

value3=average(value2,3);

plot1(value3,"月線與收盤價差三日移動平均");

---

## 場景 985：自訂指標 — 根據上述的原則，我們可以寫出一個腳本如下 :

來源：[自訂指標](https://www.xq.com.tw/xstrader/%e8%87%aa%e8%a8%82%e6%8c%87%e6%a8%99/) 說明：根據上述的原則，我們可以寫出一個腳本如下 :

variable:count1(0), count2(0), count3(0), count4(0), x1(0);

input:length(10);

count1=0;

count2=0;

count3=0;

count4=0;

for x1=0 to length-1

if o\[x1\]\>o\[x1+1\] then count1=count1+1;

 

for x1=0 to length-1

if h\[x1\]\>h\[x1+1\] then count2=count2+1;

for x1=0 to length-1

if l\[x1\]\>l\[x1+1\] then count3=count3+1;

 

for x1=0 to length-1

if c\[x1\]\>c\[x1+1\] then count4=count4+1;

 

value1=count1+count2+count3+count4;

value2=average(value1,5);

value3=average(value1,20);

Plot1(value2,"趨勢分數");

Plot2(value3,"移動平均分數");

---

## 場景 986：自訂指標 — 我們就可以運用這樣的觀察，在自訂警示腳本時，把自訂指標的腳本copy過去，然後把最後兩行plot的敘述拿掉，放上 :

來源：[自訂指標](https://www.xq.com.tw/xstrader/%e8%87%aa%e8%a8%82%e6%8c%87%e6%a8%99/) 說明：我們就可以運用這樣的觀察，在自訂警示腳本時，把自訂指標的腳本copy過去，然後把最後兩行plot的敘述拿掉，放上 :

if value2 cross over value3

then ret=1;

---

## 場景 987：自訂函數 — 按完確認後，我們會進到一個全新的腳本編輯頁面，這時候我們就可以開始編寫腳本，例如我想寫一個函數來呈現上影線佔整個K棒長度的比例， 我就可以撰寫一個叫upshad...

來源：[自訂函數](https://www.xq.com.tw/xstrader/%e8%87%aa%e8%a8%82%e5%87%bd%e6%95%b8/) 說明：按完確認後，我們會進到一個全新的腳本編輯頁面，這時候我們就可以開始編寫腳本，例如我想寫一個函數來呈現上影線佔整個K棒長度的比例， 我就可以撰寫一個叫upshadow的函數如下 :

if high\<\>low

then begin

if close\>=open

then upshadow=(high-close)/(high-low)

else upshadow=(high-open)/(high-low);

end;

---

## 場景 988：XS的時間及頻率設定 — 如果有個腳本我們希望是從早上九點到中午12點的時間才執行，我們可以像下面這麼寫 :

來源：[XS的時間及頻率設定](https://www.xq.com.tw/xstrader/xs%e7%9a%84%e6%99%82%e9%96%93%e5%8f%8a%e9%a0%bb%e7%8e%87%e8%a8%ad%e5%ae%9a/) 說明：如果有個腳本我們希望是從早上九點到中午12點的時間才執行，我們可以像下面這麼寫 :

if CurrentTime \> 090000 and CurrentTime \< 120000

Then begin

//statement

end;

---

## 場景 989：XS的時間及頻率設定 — 例如當我們用1分鐘線的腳本來尋找開盤連五分鐘都上漲的股票，我們可以這麼寫 :

來源：[XS的時間及頻率設定](https://www.xq.com.tw/xstrader/xs%e7%9a%84%e6%99%82%e9%96%93%e5%8f%8a%e9%a0%bb%e7%8e%87%e8%a8%ad%e5%ae%9a/) 說明：例如當我們用1分鐘線的腳本來尋找開盤連五分鐘都上漲的股票，我們可以這麼寫 :

input:TXT1("僅適用1分鐘線"; setinputname (1,"使用限制"); if barfreq \= "Min" and barinterval \= 1 and Date \= CurrentDate and TrueAll (close \> close \[1\], 5 )

then ret=1 ;

---

## 場景 990：忽略字 — 舉個例子，當我們要寫收盤價突破二十日移動平均時，如果要很口語化的話，可以像下面這麼寫

來源：[忽略字](https://www.xq.com.tw/xstrader/%e5%bf%bd%e7%95%a5%e5%ad%97/) 說明：舉個例子，當我們要寫收盤價突破二十日移動平均時，如果要很口語化的話，可以像下面這麼寫

if close was cross over the average(close,20)

then ret=1;

---

## 場景 991：忽略字 — 但如果是有受過訓練的程式人員，就會寫成以下的腳本

來源：[忽略字](https://www.xq.com.tw/xstrader/%e5%bf%bd%e7%95%a5%e5%ad%97/) 說明：但如果是有受過訓練的程式人員，就會寫成以下的腳本

if close cross over average(close,20)

then ret=1;

---

## 場景 992：用趨勢變化來判斷當前大盤的多空方向 — 我用一個選股腳本來做這件事

來源：[用趨勢變化來判斷當前大盤的多空方向](https://www.xq.com.tw/xstrader/%e7%94%a8%e8%b6%a8%e5%8b%a2%e8%ae%8a%e5%8c%96%e4%be%86%e5%88%a4%e6%96%b7%e7%95%b6%e5%89%8d%e5%a4%a7%e7%9b%a4%e7%9a%84%e5%a4%9a%e7%a9%ba%e6%96%b9%e5%90%91/) 說明：我用一個選股腳本來做這件事

input:Length(20); //"計算期間"

setoutputname1("趨勢訊號");

LinearReg(close, Length, 0, value1, value2, value3, value4);

//做收盤價20天線性回歸

{value1:斜率,value4:預期值}

value5=rsquare(close,value4,20);//算收盤價與線性回歸值的R平方

condition1=false;

condition2=false;

condition3=false;

condition4=false;

condition5=false;

if value1\>0 and value1\[1\]\>0 then condition1=true;

if value1\>0 and value1\[1\]\<0 then condition2=true;

if value1\<0 and value1\[1\]\<0 then condition3=true;

if value1\<0 and value1\[1\]\>0 then condition4=true;

if value5\>0.2 then condition5=true;

if condition1 and condition5

then

begin

ret=1;

outputfield1("上昇趨勢");

end;

if condition2 and condition5

then

begin

ret=1;

outputfield1("翻多");

end;

if condition3 and condition5

then

begin

ret=1;

outputfield1("下降趨勢");

end;

if condition4 and condition5

then

begin

ret=1;

outputfield1("翻空");

end;

if condition5=false

then

begin

ret=1;

outputfield1("盤整");

end;

---

## 場景 993：盤中開始暴量的低PB股 — 先前我們有介紹過預估量的函數，其腳本如下:

來源：[盤中開始暴量的低PB股](https://www.xq.com.tw/xstrader/%e7%9b%a4%e4%b8%ad%e9%96%8b%e5%a7%8b%e6%9a%b4%e9%87%8f%e7%9a%84%e4%bd%8epb%e8%82%a1/) 說明：先前我們有介紹過預估量的函數，其腳本如下:

variable:CloseTime(133000); // 收盤時間

variable: OpenMinutes(270);//一天有幾分鐘開盤

variable: MinutestoClose(270); //到收盤還有幾分鐘

variable: Length(20); //用過去幾天日資料計算

variable: AvgDayVol(0); //平均日量

variable: AvgMinVolinDay(0); //平均分鐘量

variable: LeftVol(0); //剩餘時間的估計量

variable: estVol(0); //最終估計量

AvgDayVol \= average(V,Length);

AvgMinVolinDay \= AvgDayVol/OpenMinutes; //過去這段時間每分鐘的平均量

MinutestoClose \= Timediff(CloseTime,currenttime,"M"); //現在到收盤還有幾分鐘

LeftVol \= MinutestoClose \*AvgMinVolinDay;// 剩餘時間乘上每分鐘均量 \= 盛夏時間可能有多少量

if ( barfreq \="D") then //是日線才會對

begin

if Date \=currentdate then //今天才回估量

estVol \=volume \+ LeftVol //估計量 等於 現在的日總量 加上 剩下時間估計的量

else

estVol \=v; //過去的話就直接回實際的量

end;

estvolume \=estVol;

---

## 場景 994：盤中開始暴量的低PB股 — 有了這個預估量的函數，我們就可以很容易的寫出預估量暴增的腳本

來源：[盤中開始暴量的低PB股](https://www.xq.com.tw/xstrader/%e7%9b%a4%e4%b8%ad%e9%96%8b%e5%a7%8b%e6%9a%b4%e9%87%8f%e7%9a%84%e4%bd%8epb%e8%82%a1/) 說明：有了這個預估量的函數，我們就可以很容易的寫出預估量暴增的腳本

value1=q\_InSize;//當日內盤量

value2=q\_OutSize;//當日外盤量

if estvolume \> average(volume\[1\],10)\*1.3//預估量比十日均量多出三成

and value2\>value1//外盤量比內盤量多

then ret=1;

---

## 場景 995：switch case — 範例：外資近日買超天數比例

來源：[switch case](https://www.xq.com.tw/xstrader/switch-case/) 說明：範例：外資近日買超天數比例

//1.宣告參數：利用input宣告輸入的參數。

input:day(10);//過去幾天

input:ratio(0.7);//外資買超的天數佔多少比例

//2.宣告變數，利用variable

value1=GetField("Fdifference");//外資買賣超

variable:count(0);

variable:xi(0);

for xi= 1 to day

begin

//============================================

switch(value1\[xi\])

begin

case \>0:count=count+1;

case \<0:count=count;

case 0:count=count;

end;//所有case都表達完之後，最後必須加end;來表示各種數值選項已結束

//============================================

end;

//6.設定警示條件：if.. then ret=1;

if day\<\>0 and count/day\>=ratio

then ret=1;

---

## 場景 996：begin..end — 例如若要找出前N日漲幅超過X%且今天跳空開高超過Y%的股票，我們可以寫一個腳本如下:

來源：[begin..end](https://www.xq.com.tw/xstrader/begin-end/) 說明：例如若要找出前N日漲幅超過X%且今天跳空開高超過Y%的股票，我們可以寫一個腳本如下:

//宣告參數：利用input宣告輸入的參數。

input:N(3);//前N日

input:X(10);//前n日漲幅%

input:\_Y(4);//缺口大小%

if open\>high\[1\] then //跳空開高

//用begin來呈現if 之後要執行的不只一件的事情

begin

value1=(1-close\[1\]/close\[N\])\*100;//計算前N天的漲幅

value2=(open-high\[1\])/close\*100;//計算跳空缺口的大小

 

end;

//最後用end來宣告if之後要執行程式的結束

 

if value1\>=X and value2\>=\_Y

then ret=1;

---

## 場景 997：if..then — 這一種是我們最常用也最簡單的寫法，例如我們要電腦在股票出現K棒三連陽時通知我們，我們只要寫以下的兩行腳本 :

來源：[if..then](https://www.xq.com.tw/xstrader/if-then/) 說明：這一種是我們最常用也最簡單的寫法，例如我們要電腦在股票出現K棒三連陽時通知我們，我們只要寫以下的兩行腳本 :

if trueall(close\>close\[1\],3)

then ret=1;

---

## 場景 998：if..then — 在寫成腳本時，我們就可以用if……then …….else的語法來處理如下方的敘述式

來源：[if..then](https://www.xq.com.tw/xstrader/if-then/) 說明：在寫成腳本時，我們就可以用if……then …….else的語法來處理如下方的敘述式

if Close\[1\] \> High then TrueHigh \= Close\[1\]

else TrueHigh \= High;

---

## 場景 999：if..then — 例如我們如果想找開盤就漲停或開盤跳空上漲後，不到九點十五就漲停的股票，我們可以運用以下的腳本 :

來源：[if..then](https://www.xq.com.tw/xstrader/if-then/) 說明：例如我們如果想找開盤就漲停或開盤跳空上漲後，不到九點十五就漲停的股票，我們可以運用以下的腳本 :

if open=q\_DailyUplimit then ret=1;

if open\>close\[1\]\*1.025 and close=q\_DailyUplimit and time\<091500 then ret=1;

---

## 場景 1000：那一年，我們一起尋找的超跌股。 — 不過因為研究過矽統這檔股票，所以我很好奇這市場上還有沒有矽統第二，所以我就寫了以下這個腳本

來源：[那一年，我們一起尋找的超跌股。](https://www.xq.com.tw/xstrader/%e9%82%a3%e4%b8%80%e5%b9%b4%ef%bc%8c%e6%88%91%e5%80%91%e4%b8%80%e8%b5%b7%e5%b0%8b%e6%89%be%e8%b6%85%e8%b7%8c%e8%82%a1%e3%80%82/) 說明：不過因為研究過矽統這檔股票，所以我很好奇這市場上還有沒有矽統第二，所以我就寫了以下這個腳本

input:percent(20);

setinputname(1,"每股易變現資產與股價間的落差比");

value1=GetField("現金及約當現金","Q");//百萬;

value2=GetField("短期投資","Q");//百萬

value3=GetField("應收帳款及票據","Q");//百萬

value4=GetField("長期投資","Q");//百萬

value5=GetField("負債總額","Q");//百萬

value6=GetField("最新股本");//單位: 億

value7=(value1+value2+value3+value4-value5)/(value6\*10);

if value7\>close\*(1+percent/100)

then ret=1;

outputfield1(value7);

setoutputname1("每股快速變現價值");

outputfield2(close/value7);

setoutputname2("股價與快速變現價值");

---

## 場景 1001：私房交易策略之強勢股整理結束

來源：[私房交易策略之強勢股整理結束](https://www.xq.com.tw/xstrader/%e7%a7%81%e6%88%bf%e4%ba%a4%e6%98%93%e7%ad%96%e7%95%a5%e4%b9%8b%e5%bc%b7%e5%8b%a2%e8%82%a1%e6%95%b4%e7%90%86%e7%b5%90%e6%9d%9f/) 說明：這個函數的腳本如下:

Input: target(numeric);

if barfreq \<\> "D" AND barfreq \<\> "W" AND barfreq \<\> "M" then raiseruntimeerror("只支援日/週/月頻率");

variable: i(0);

variable: target\_ym(0), date\_ym(0);

if barfreq \= "D" then

begin

 if target \>= date then

 begin

 GetBarOffset \= 0;

 return;

 end;

 i \= 1;

 GetBarOffset \= 1;

 while i \< currentbar

 begin

 if date\[i\] \<= target then return;

 i \= i \+ 1; 

 GetBarOffset \= GetBarOffset \+ 1;

 end;

end;

if barfreq \= "W" then

begin 

 target\_ym \= year(target) \* 100 \+ weekofyear(target);

 if dayofweek(target) \= 0 then target\_ym \= target\_ym \- 1;

 

 GetBarOffset \= 0;

 i \= 0;

 while i \< currentbar

 begin

 date\_ym \= year(date\[i\]) \* 100 \+ weekofyear(date\[i\]);

 if dayofweek(date\[i\]) \= 0 then date\_ym \= date\_ym \- 1;

 

 if date\_ym \<= target\_ym then return;

 i \= i \+ 1;

 GetBarOffset \= GetBarOffset \+ 1;

 end; 

end;

if barfreq \= "M" then

begin

 target\_ym \= year(target) \* 100 \+ month(target);

 

 GetBarOffset \= 0;

 i \= 0;

 while i \< currentbar

 begin

 date\_ym \= year(date\[i\]) \* 100 \+ month(date\[i\]);

 

 if date\_ym \<= target\_ym then return;

 i \= i \+ 1;

 GetBarOffset \= GetBarOffset \+ 1;

 end; 

end;

---

## 場景 1002：私房交易策略之強勢股整理結束 — 有了這個函數，我就來寫出上面所提到的這個腳本

來源：[私房交易策略之強勢股整理結束](https://www.xq.com.tw/xstrader/%e7%a7%81%e6%88%bf%e4%ba%a4%e6%98%93%e7%ad%96%e7%95%a5%e4%b9%8b%e5%bc%b7%e5%8b%a2%e8%82%a1%e6%95%b4%e7%90%86%e7%b5%90%e6%9d%9f/) 說明：有了這個函數，我就來寫出上面所提到的這個腳本

input: stardate(20150824);

input:ratio(30);

input:ratio1(7);

input:ratio2(2);

setinputname(1,"輸入上漲起始日");

setinputname(2,"輸入上漲最低幅度");

setinputname(3,"輸入最小拉回幅度");

setinputname(4,"今日最低漲幅");

value1=getbaroffset(stardate);//找出輸入的日期是在第幾根bar

value2=highest(high\[1\],value1+1);//找出這一波的最高點

condition1=false;

condition2=false;

if value2\>=close\[value1\]\*(1+ratio/100)//計算波段漲幅有沒有符合要求

then condition1=true;

if value2\>=close\[1\]\*(1+ratio1/100)//計算拉回的幅度夠不夠要求

then condition2=true;

if nthhighestbar(1,high,10)\>=5//從最高點到今天超過五根bar

then begin

if condition1 and condition2 and close\>=close\[1\]\*(1+ratio2/100)

then ret=1;

end;

---

## 場景 1003：私房交易策略介紹之旱地拔葱 — 例如我常推薦大家使用的多次到頂而破策略雷達

來源：[私房交易策略介紹之旱地拔葱](https://www.xq.com.tw/xstrader/%e7%a7%81%e6%88%bf%e4%ba%a4%e6%98%93%e7%ad%96%e7%95%a5%e4%bb%8b%e7%b4%b9%e4%b9%8b%e6%97%b1%e5%9c%b0%e6%8b%94%e8%91%b1/) 說明：例如我常推薦大家使用的多次到頂而破策略雷達

input:HitTimes(3); setinputname(1,"設定觸頂次數");

input:RangeRatio(1); setinputname(2,"設定頭部區範圍寬度%");

input:Length(20); setinputname(3,"計算期數");

variable: theHigh(0); theHigh \= Highest(High\[1\],Length); //找到過去其間的最高點

variable: HighLowerBound(0); HighLowerBound \= theHigh \*(100-RangeRatio)/100; // 設為瓶頸區間上界

variable: TouchRangeTimes(0); //期間中進入瓶頸區間的低點次數,每跟K棒要歸0

//回算在此區間中 進去瓶頸區的次數

TouchRangeTimes \= CountIF(High\[1\] \> HighLowerBound, Length);

if TouchRangeTimes \>= HitTimes and ( q\_ask\> theHigh or close \> theHigh) then ret=1;

---

## 場景 1004：私房交易策略介紹之旱地拔葱 — 後來我有寫過另一個叫股票箱突破的策略雷達

來源：[私房交易策略介紹之旱地拔葱](https://www.xq.com.tw/xstrader/%e7%a7%81%e6%88%bf%e4%ba%a4%e6%98%93%e7%ad%96%e7%95%a5%e4%bb%8b%e7%b4%b9%e4%b9%8b%e6%97%b1%e5%9c%b0%e6%8b%94%e8%91%b1/) 說明：後來我有寫過另一個叫股票箱突破的策略雷達

input:length(12);

value1=NthHighest(1,high,length);

value3=nthhighest(3,high,length);

value4=Nthlowest(1,low,length);

value5=nthlowest(3,low,length);

if

value1\[1\]\<=1.03\*value3\[1\]

and value5\[1\]\<=value4\[1\]\*1.03

and value1\[1\]\<=value4\[1\]\*1.1

and close\>value1\[1\]

then ret=1;

---

## 場景 1005：趨勢檢定器 — 於是我寫了一個腳本，在這腳本中我應用上面的這六個面象，做出一個計分器，如果每個面象近兩個交易日有任一天有明顯比以往平均值突出的數字，就加一分，然後如果總得分超過...

來源：[趨勢檢定器](https://www.xq.com.tw/xstrader/%e8%b6%a8%e5%8b%a2%e6%aa%a2%e5%ae%9a%e5%99%a8/) 說明：於是我寫了一個腳本，在這腳本中我應用上面的這六個面象，做出一個計分器，如果每個面象近兩個交易日有任一天有明顯比以往平均值突出的數字，就加一分，然後如果總得分超過4分，代表通過這個趨勢檢定器的檢定。

input:Length(10);

input:ratio(20);

input:cn(4);

setinputname(1,"移動平均天數");

setinputname(2,"超出均值比率");

setinputname(3,"最低符合條件數");

variable:count(0);

value1=GetField("總成交次數","D");

value2=GetField("佔全市場成交量比","D");

value3=GetField("內外盤比","D");

value4=GetField("外盤均量","D");

value5=GetField("主力買賣超張數","D");

value6=GetField("真實範圍波幅","D");

value7=GetField("開盤委買","D");

count=0;

if countif(value1 \>=average(value1,length)\*(1+ratio/100),2)\>0

then count=count+1;

if countif(value2 \>=average(value2,length)\*(1+ratio/100),2)\>0

then count=count+1;

if countif(value3 \>=average(value3,length)\*(1+ratio/100),2)\>0

then count=count+1;

if countif(value4 \>=average(value4,length)\*(1+ratio/100),2)\>0

then count=count+1;

if countif(value5\>0,2)\>0

then count=count+1;

if countif(value6 \>=average(value6,length)\*(1+ratio/100),2)\>0

then count=count+1;

if countif(value7 \>=average(value7,length)\*(1+ratio/100),2)\>0

then count=count+1;

if countif(volume \>=average(volume,length)\*(1+ratio/100),3)\>0

then count=count+1;

if count\>cn

then ret=1;

outputfield1(count);

setoutputname1("檢定值");

---

## 場景 1006：趨勢檢定器 — 如果我們用昨天的收盤價來跑以下這個腳本

來源：[趨勢檢定器](https://www.xq.com.tw/xstrader/%e8%b6%a8%e5%8b%a2%e6%aa%a2%e5%ae%9a%e5%99%a8/) 說明：如果我們用昨天的收盤價來跑以下這個腳本

input:Length(20); //"計算期間"

LinearReg(close, Length, 0, value1, value2, value3, value4);

//做收盤價20天線性回歸

{value1:斜率,value4:預期值}

value5=rsquare(close,value4,20);//算收盤價與線性回歸值的R平方

if value1\>0 and value5\>0.2

then ret=1;

---

## 場景 1007：從月線與季線看台股當前的漲昇架構 — 為了很快的了解到底目前有那些股票位於這六階段不同的位置，我寫了一個腳本如下: 我特別濾掉那些股價不到10元，成交量不到1000張的股票，

來源：[從月線與季線看台股當前的漲昇架構](https://www.xq.com.tw/xstrader/%e5%be%9e%e6%9c%88%e7%b7%9a%e8%88%87%e5%ad%a3%e7%b7%9a%e7%9c%8b%e5%8f%b0%e8%82%a1%e7%95%b6%e5%89%8d%e7%9a%84%e6%bc%b2%e6%98%87%e6%9e%b6%e6%a7%8b/) 說明：為了很快的了解到底目前有那些股票位於這六階段不同的位置，我寫了一個腳本如下: 我特別濾掉那些股價不到10元，成交量不到1000張的股票，

input:status(1);

setinputname(1,"1:復甦期，2:收集期，3:多頭，4:警示期，5:發散期，6:空頭");

variable:m20(0),m60(0),message("0"),userchoice("0");

m20=average(close,20);

m60=average(close,60);

if close \> m20 and c\< m60 and m20\<m60

then message="復甦期"

else

if close \> m20 and c\> m60 and m20\<m60

then message="收集期"

else

if close \> m20 and c\> m60 and m20 \> m60

then message="多頭"

else

if close \< m20 and c\>m60 and m20\>m60

then message="警示期"

else

if close \< m20 and c\<m60 and m20\>m60

then message="發散期"

else

if close \< m20 and c\<m60 and m20\<m60

then message="空頭";

switch(status)

begin

case=1 :

userchoice="復甦期";

case=2 :

userchoice="收集期";

case=3 :

userchoice="多頭";

case=4 :

userchoice="警示期";

case=5 :

userchoice="發散期";

case=6 :

userchoice="空頭";

end;

if message=userchoice

and volume\>1000 and close\>10

then ret=1;

outputfield1(message);

setoutputname1("今日訊號");

outputfield2(message\[1\]);

setoutputname2("昨日訊號");

outputfield3(message\[2\]);

setoutputname3("前日訊號");

---

## 場景 1008：從月線與季線看台股當前的漲昇架構 — 除了用這一套方法來研判大盤漲昇架構之外，我稍稍更改一下腳本如下:

來源：[從月線與季線看台股當前的漲昇架構](https://www.xq.com.tw/xstrader/%e5%be%9e%e6%9c%88%e7%b7%9a%e8%88%87%e5%ad%a3%e7%b7%9a%e7%9c%8b%e5%8f%b0%e8%82%a1%e7%95%b6%e5%89%8d%e7%9a%84%e6%bc%b2%e6%98%87%e6%9e%b6%e6%a7%8b/) 說明：除了用這一套方法來研判大盤漲昇架構之外，我稍稍更改一下腳本如下:

variable:m20(0),m60(0),message("0") ;

m20=average(close,20);

m60=average(close,60);

if close \> m20 and c\< m60 and m20\<m60

then message="復甦期"

else

if close \> m20 and c\> m60 and m20\<m60

then message="收集期"

else

if close \> m20 and c\> m60 and m20 \> m60

then message="多頭"

else

if close \< m20 and c\>m60 and m20\>m60

then message="警示期"

else

if close \< m20 and c\<m60 and m20\>m60

then message="發散期"

else

if close \< m20 and c\<m60 and m20\<m60

then message="空頭";

if message\<\>message\[1\]

and volume\>500 and close\>10

then ret=1;

outputfield1(message);

setoutputname1("今日訊號");

outputfield2(message\[1\]);

setoutputname2("昨日訊號");

outputfield3(message\[2\]);

setoutputname3("前日訊號");

---

## 場景 1009：自訂指標Step by Step — 然後它拿這兩股力量去相比，那邊強，另一邊就只能以零計算，然後再去跟這樣的力量跟真實區間相除，看向上的力量佔真實波動區間的比例是多少

來源：[自訂指標Step by Step](https://www.xq.com.tw/xstrader/%e8%87%aa%e8%a8%82%e6%8c%87%e6%a8%99step-by-step/) 說明：然後它拿這兩股力量去相比，那邊強，另一邊就只能以零計算，然後再去跟這樣的力量跟真實區間相除，看向上的力量佔真實波動區間的比例是多少

// DirectionMovement function (for DMI相關指標)

// Input: length

// Return: pdi\_value(+di), ndi\_value(-di), adx\_value(adx)

//

input:

length(numericsimple),

pdi\_value(numericref),

ndi\_value(numericref),

adx\_value(numericref);

variable:

padm(0), nadm(0), radx(0),

atr(0), pdm(0), ndm(0), tr(0),

dValue0(0), dValue1(0), dx(0),

idx(0);

if currentbar \= 1 then

begin

padm \= close / 10000;

nadm \= padm;

atr \= padm \* 5;

radx \= 20;

end

else

begin

pdm \= maxlist(High \- High\[1\], 0);

ndm \= maxlist(Low\[1\] \- Low, 0);

if pdm \< ndm then

pdm \= 0

else

begin

if pdm \> ndm then

ndm \= 0

else

begin

pdm \= 0;

ndm \= 0;

end;

end;

if Close\[1\] \> High then

tr \= Close\[1\] \- Low

else

begin

if Close\[1\] \< Low then

tr \= High \- Close\[1\]

else

tr \= High \- Low;

end;

padm \= padm\[1\] \+ (pdm \- padm\[1\]) / length;

nadm \= nadm\[1\] \+ (ndm \- nadm\[1\]) / length;

atr \= atr\[1\] \+ (tr \- atr\[1\]) / length;

dValue0 \= 100 \* padm / atr;

dValue1 \= 100 \* nadm / atr;

if dValue0 \+ dValue1 \<\> 0 then

dx \= AbsValue(100 \* (dValue0 \- dValue1) / (dValue0 \+ dValue1));

radx \= radx\[1\] \+ (dx \- radx\[1\]) / length;

end;

pdi\_value \= dValue0;

ndi\_value \= dValue1;

adx\_value \= radx;

---

## 場景 1010：自訂指標Step by Step — 所以我就寫了以下的腳本:

來源：[自訂指標Step by Step](https://www.xq.com.tw/xstrader/%e8%87%aa%e8%a8%82%e6%8c%87%e6%a8%99step-by-step/) 說明：所以我就寫了以下的腳本:

input:sd(5);

input:ld(20);

setinputname(1,"短天期");

setinputname(2,"長天期");

variable:h1(0),l1(0),nf(0),snf(0),lnf(0),dd(0);

H1=HIGH-HIGH\[1\];

L1=LOW-LOW\[1\];

if truerange\<\>0

then

begin

NF=(H1+L1)/truerange;

SNF=average(NF,sd);

lnf=average(nf,ld);

dd=snf-lnf;

end;

plot1(dd,"多空淨力");

---

## 場景 1011：紅色供應鍊可能有興趣的股票 — 根據這樣的觀察，我寫了一個腳本，專門找那些董監持股比例低，集保庫存比例高的公司，這些公司就是那種比較容易被他人下手的標的。

來源：[紅色供應鍊可能有興趣的股票](https://www.xq.com.tw/xstrader/%e7%b4%85%e8%89%b2%e4%be%9b%e6%87%89%e9%8d%8a%e5%8f%af%e8%83%bd%e6%9c%89%e8%88%88%e8%b6%a3%e7%9a%84%e8%82%a1%e7%a5%a8/) 說明：根據這樣的觀察，我寫了一個腳本，專門找那些董監持股比例低，集保庫存比例高的公司，這些公司就是那種比較容易被他人下手的標的。

//大股東持股不高

//集保比例很高

input:r1(15),r2(80);

setinputname(1,"董監持股比例");

setinputname(2,"集保比例");

value1=GetField("董監持股佔股本比例","D");

value2=GetField("集保張數佔發行張數百分比","W");

if value1\<r1 and value2\>=r2 //董監持股比例小於15%且集保比例高於八成

then ret=1;

---

## 場景 1012：布林通道的奧義 — 我們來看看布林通道的公式:

來源：[布林通道的奧義](https://www.xq.com.tw/xstrader/%e5%b8%83%e6%9e%97%e9%80%9a%e9%81%93%e7%9a%84%e5%a5%a7%e7%be%a9/) 說明：我們來看看布林通道的公式:

Input: price(numericseries), length(numericsimple), \_band(numericsimple);

BollingerBand \= Average(price, length) \+ \_band \* StandardDev(price, length, 1);

---

## 場景 1013：布林通道的奧義 — 我們先來看一下標準差的公式:

來源：[布林通道的奧義](https://www.xq.com.tw/xstrader/%e5%b8%83%e6%9e%97%e9%80%9a%e9%81%93%e7%9a%84%e5%a5%a7%e7%be%a9/) 說明：我們先來看一下標準差的公式:

input: thePrice(numericseries), Length(numericsimple), DataType(numericsimple);

Value1 \= VariancePS(thePrice, Length, DataType);

if Value1 \> 0 then

StandardDev \= SquareRoot(Value1)

else

StandardDev \= 0;

---

## 場景 1014：布林通道的奧義

來源：[布林通道的奧義](https://www.xq.com.tw/xstrader/%e5%b8%83%e6%9e%97%e9%80%9a%e9%81%93%e7%9a%84%e5%a5%a7%e7%be%a9/) 說明：那什麼又是變異數呢?

input: thePrice(numericseries), Length(numericsimple), DataType(numericsimple);

variable: Period(0), sum(0), avg(0);

VariancePS \= 0;

Period \= Iff(DataType \= 1, Length, Length \- 1);

if Period \> 0 then

begin

avg \= Average(thePrice, Length);

sum \= 0;

for Value1 \= 0 to Length \- 1

begin

sum \= sum \+ Square(thePrice\[Value1\] \- avg);

end;

VariancePS \= sum / Period;

end;

---

## 場景 1015：布林通道的奧義 — 所以根據這樣的思維，我寫了以下的腳本送給我朋友

來源：[布林通道的奧義](https://www.xq.com.tw/xstrader/%e5%b8%83%e6%9e%97%e9%80%9a%e9%81%93%e7%9a%84%e5%a5%a7%e7%be%a9/) 說明：所以根據這樣的思維，我寫了以下的腳本送給我朋友

input:length(20);

variable:up1(0),down1(0),mid1(0),bbandwidth(0);

up1 \= bollingerband(Close, Length, 2);

down1 \= bollingerband(Close, Length, \-2);

mid1 \= (up1 \+ down1) / 2;

bbandwidth \= 100 \* (up1 \- down1) / mid1;

if bbandwidth crosses above 5 and close \> up1 and close\> up1\[1\]

and average(close,20)\>average(close,20)\[1\]

then ret=1;

---

## 場景 1016：月營收推估的低本益比股 — 根據這個邏輯，我寫了以下的這個腳本:

來源：[月營收推估的低本益比股](https://www.xq.com.tw/xstrader/%e7%95%b6%e6%96%b0%e7%9a%84%e6%9c%88%e7%87%9f%e6%94%b6%e5%85%ac%e4%bd%88%e6%99%82%ef%bc%8c%e5%bf%ab%e9%80%9f%e9%81%b8%e8%82%a1%e7%9a%84%e6%96%b9%e6%b3%95/) 說明：根據這個邏輯，我寫了以下的這個腳本:

value1=GetField("月營收","M");//單位:億元

value3=GetField("本期稅後淨利","Q");//單位百萬

value4=GetField("營業利益率","Q");

value5=GetField("最新股本");//單位:億元

condition1=false;

condition2=false;

input:peraito(12,"預估本益比上限");

if value5\<\>0

then

value6=(value1\*value4\*12)/(value5\*100)\*10;//單月營收推估的本業EPS

if value6\<\>0

then 

value7=close/value6;

if value7\<peraito and value7\>0

and value3\>200

then ret=1;

outputfield(1,value7,2,"推估本益比");

outputfield(2,value6,2,"EPS");

outputfield(3,value1,2,"月營收");

outputfield(4,value4,2,"營業利益率");

outputfield(5,value5,2,"最新股本");

---

## 場景 1017：為自己的觀察名單標上交易訊號 — 大家如果對於多空分數很陌生，我把腳本再貼一次

來源：[為自己的觀察名單標上交易訊號](https://www.xq.com.tw/xstrader/%e7%82%ba%e8%87%aa%e5%b7%b1%e7%9a%84%e8%a7%80%e5%af%9f%e5%90%8d%e5%96%ae%e6%a8%99%e4%b8%8a%e4%ba%a4%e6%98%93%e8%a8%8a%e8%99%9f/) 說明：大家如果對於多空分數很陌生，我把腳本再貼一次

// 利用多種指標, 計算多空分數

//

variable: count(0);

// 每次計算都要reset

count \= 0;

//------------------ Arron指標 \-------------------//

variable: arron\_up(0),arron\_down(0),arron\_oscillator(0);//arron oscillator

arron\_up=(25-nthhighestbar(1,high,25))/25\*100;

arron\_down=(25-nthlowestbar(1,low,25))/25\*100;

arron\_oscillator=arron\_up-arron\_down;

if arron\_up \> arron\_down and arron\_up \> 70 and arron\_oscillator \> 50

then count=count+1;

//------------------ 隨機漫步指標 \---------------//

variable: RWIH(0),RWIL(0);

value1 \= standarddev(close,10,1);

value2 \= average(truerange,10);

if value1 \<\> 0 and value2 \<\> 0 then

begin

RWIH=(high-low\[9\])/value2\*value1;

RWIL=(high\[9\]-low)/value2\*value1;

end;

if RWIH \> RWIL

then count=count+1;

//------------------ 順勢指標 \-------------------//

variable:bp1(0),abp1(0);

if truerange \<\> 0 then

bp1=(close-close\[1\])/truerange\*100;//順勢指標

abp1=average(bp1,10);

if abp1 \> 0

then count=count+1;

//---------- CMO錢德動量擺動指標 \----------------//

variable:SU(0),SD(0),CMO1(0), SUSUM(0), SDSUM(0);

if close \>= close\[1\] then

SU=CLOSE-CLOSE\[1\]+SU\[1\]

else

SU=SU\[1\];

if close \< close\[1\] then

SD=CLOSE\[1\]-CLOSE+SD\[1\]

else

SD=SD\[1\];

SUSUM \= summation(SU,9);

SDSUM \= summation(sd,9);

if (SUSUM+SDSUM) \<\> 0 then

cmo1=(SUSUM-SDSUM)/(SUSUM+SDSUM)\*100;

if linearregslope(cmo1,5) \> 0

then count=count+1;

//------------------ RSI指標 \-------------------//

variable: rsiShort(0), rsiLong(0);

rsiShort=rsi(close,5);

rsiLong=rsi(close,10);

if rsiShort \> rsiLong and rsiShort \< 90

then count=count+1;

//----------------- MACD指標 \-------------------//

variable: Dif\_val(0), MACD\_val(0), Osc\_val(0);

MACD(Close, 12, 26, 9, Dif\_val, MACD\_val, Osc\_val);

if osc\_val \> 0

then count=count+1;

//----------------- MTM指標 \-------------------//

if mtm(10) \> 0

then count=count+1;

//----------------- KD指標 \--------------------//

variable:rsv1(0),k1(0),d1(0);

stochastic(9,3,3,rsv1,k1,d1);

if k1 \> d1 and k1 \< 80

then count=count+1;

//----------------- DMI指標 \-------------------//

variable:pdi\_value(0),ndi\_value(0),adx\_value(0);

DirectionMovement(14,pdi\_value,ndi\_value,adx\_value);

if pdi\_value \> ndi\_value

then count=count+1;

//----------------- AR指標 \-------------------//

variable: arValue(0);

arValue \= ar(26);

if linearregslope(arValue,5) \> 0

then count=count+1;

//----------------- ACC指標 \-----------------//

if acc(10) \> 0

then count=count+1;

//----------------- TRIX指標 \----------------//

if trix(close,9) \> trix(close,15)

then count=count+1;

//----------------- SAR指標 \----------------//

if close \> SAR(0.02, 0.02, 0.2)

then count=count+1;

//----------------- 均線指標 \----------------//

if average(close,5) \> average(close,12)

then count=count+1;

// Return value

//

TechScore \= count;

---

## 場景 1018：為自己的觀察名單標上交易訊號 — 根據上述的語法結構，我就寫了多空分數的交易訊號腳本如下:

來源：[為自己的觀察名單標上交易訊號](https://www.xq.com.tw/xstrader/%e7%82%ba%e8%87%aa%e5%b7%b1%e7%9a%84%e8%a7%80%e5%af%9f%e5%90%8d%e5%96%ae%e6%a8%99%e4%b8%8a%e4%ba%a4%e6%98%93%e8%a8%8a%e8%99%9f/) 說明：根據上述的語法結構，我就寫了多空分數的交易訊號腳本如下:

setoutputname1("多空分數交易訊號");

value1 \= techscore();

value2 \= average(value1, 10);

Value3 \= CountIF(value2 crosses above 5,5);

value4=CountIF(value2 crosses below 10,5);

if value3 \>1 then

begin

ret \= 1 ;

outputfield1("買進");

end

else

if value2 \>5 and value2 \>average(value2,5)

then begin

ret=1 ;

outputfield1("持有");

end

else

if value2 \>=10

then begin

ret=1 ;

outputfield1("過熱");

end

else

if value4\>1

then begin

ret=1;

outputfield1("賣出");

end

else

if value2 \>5 and value2 \<average(value2,5) then begin

ret=1;

outputfield1("觀望");

end

else

if value2\<=5

then begin

ret=1;

outputfield1("超賣");

end;

---

## 場景 1019：為自己的觀察名單標上交易訊號

來源：[為自己的觀察名單標上交易訊號](https://www.xq.com.tw/xstrader/%e7%82%ba%e8%87%aa%e5%b7%b1%e7%9a%84%e8%a7%80%e5%af%9f%e5%90%8d%e5%96%ae%e6%a8%99%e4%b8%8a%e4%ba%a4%e6%98%93%e8%a8%8a%e8%99%9f/) 說明：例如我們可以寫出

setoutputname2("RSI交易訊號");

IF RSI cross over 20

then begin

ret=1;

outputfield2("買進");

end;

---

## 場景 1020：什麼時候起就不能當死多頭? — 於是，我用xs寫了一個指標，腳本如下:

來源：[什麼時候起就不能當死多頭?](https://www.xq.com.tw/xstrader/%e4%bb%80%e9%ba%bc%e6%99%82%e5%80%99%e8%b5%b7%e5%b0%b1%e4%b8%8d%e8%83%bd%e7%95%b6%e6%ad%bb%e5%a4%9a%e9%a0%ad/) 說明：於是，我用xs寫了一個指標，腳本如下:

input:shortterm(5);

input:midterm(20);

setinputname(1,"短期均線");

setinputname(2,"中期均線");

value1=GetField("上漲家數");

value2=lowest(value1,shortterm);

value3=average(value2,midterm);

plot1(value3,"中期均線");

---

## 場景 1021：在投資操作上，我犯過最大的三個錯誤\! — 步驟一: 撰寫出場 “交易”腳本。

來源：[在投資操作上，我犯過最大的三個錯誤\!](https://www.xq.com.tw/xstrader/%e5%9c%a8%e6%8a%95%e8%b3%87%e6%93%8d%e4%bd%9c%e4%b8%8a%ef%bc%8c%e6%88%91%e7%8a%af%e9%81%8e%e6%9c%80%e5%a4%a7%e7%9a%84%e4%b8%89%e5%80%8b%e9%8c%af%e8%aa%a4/) 說明：步驟一: 撰寫出場 “交易”腳本。

var: exit\_long\_condition(false); { 多單全部出場 }

{ 範例:跌破10日均線時賣出全部}

exit\_long\_condition \= c\< Average(Close, 10);

if Position \> 0 and exit\_long\_condition then begin

SetPosition(0);

end;

---

## 場景 1022：尋找cash rich and cash in的公司 — 我寫了一個選股的腳本來找這些公司，腳本如下:

來源：[尋找cash rich and cash in的公司](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%becash-rich-and-cash-in%e7%9a%84%e5%85%ac%e5%8f%b8/) 說明：我寫了一個選股的腳本來找這些公司，腳本如下:

value1=GetField("現金及約當現金","Q");//單位百萬

value2=GetField("短期投資","Q");//單位百萬

value3=GetField("短期借款","Q");//單位百萬

value4=(value1+value2-value3)/100;//單位億之現金及短期投資合計金額

input: lowlimit(50);

setinputname(1,"償債後現金及短投最少金額");

if value4\>=lowlimit

then ret=1;

setoutputname1("償債後現金及短投金額(億)");

outputfield1(value4);

---

## 場景 1023：從細產業資金流向看類股輪動 — 為了尋找資金在各細產業間的流動狀況，我寫了一個資金流向指標，腳本如下:

來源：[從細產業資金流向看類股輪動](https://www.xq.com.tw/xstrader/%e5%be%9e%e7%b4%b0%e7%94%a2%e6%a5%ad%e8%b3%87%e9%87%91%e6%b5%81%e5%90%91%e7%9c%8b%e9%a1%9e%e8%82%a1%e8%bc%aa%e5%8b%95/) 說明：為了尋找資金在各細產業間的流動狀況，我寫了一個資金流向指標，腳本如下:

input:short1(5),mid1(12);

setinputname(1,"短期平均");

setinputname(2,"長期平均");

value1=GetField("資金流向");

value2=average(value1,20);

value3=value1-value2;

value4=average(value3,short1);

value5=average(value3,mid1);

plot1(value4,"短期均線");

plot2(value5,"長期均線");

---

## 場景 1024：景氣循環股的選股策略 — 因此，我寫了一個腳本，用來尋找那些PB跌到歷年低點區且低於0.8的景氣循環股

來源：[景氣循環股的選股策略](https://www.xq.com.tw/xstrader/%e6%99%af%e6%b0%a3%e5%be%aa%e7%92%b0%e8%82%a1%e7%9a%84%e9%81%b8%e8%82%a1%e7%ad%96%e7%95%a5/) 說明：因此，我寫了一個腳本，用來尋找那些PB跌到歷年低點區且低於0.8的景氣循環股

value1=GetField("股價淨值比","Y");

value2=lowest(value1,4);

if value1\<value2\*1.2 and value1\<=0.8

then ret=1;

setoutputname(1,"股價淨值比");

outputfield1(value1);

---

## 場景 1025：建構專屬的大盤多空檢查表

來源：[建構專屬的大盤多空檢查表](https://www.xq.com.tw/xstrader/%e5%bb%ba%e6%a7%8b%e5%b0%88%e5%b1%ac%e7%9a%84%e5%a4%a7%e7%9b%a4%e5%a4%9a%e7%a9%ba%e6%aa%a2%e6%9f%a5%e8%a1%a8/) 說明：它的腳本如下:

input: length(23); setinputname(1, "天期");

input: period(8); setinputname(2, "平均");

variable:DTM(0),DBM(0),STM(0),SBM(0),ADTM(0),ADTMMA(0);

if open \> open\[1\] then

DTM \= maxlist(high-open,open-open\[1\])

else

DTM \= 0;

if open \< open\[1\] then

DBM \= open-low

else

DBM \= 0;

STM \= Summation(DTM,length);

SBM \= Summation(DBM,length);

if STM \> SBM then

ADTM \= (STM-SBM)/STM

else　if STM \< SBM then

ADTM \= (STM-SBM)/SBM

else

ADTM \= 0;

ADTMMA \= average(ADTM,period);

plot1(ADTM, "ADTM");

plot2(ADTMMA, "ADTM移動平均");

---

## 場景 1026：建構專屬的大盤多空檢查表 — 4.Zero Lag Heikin-Ashi多空指標

來源：[建構專屬的大盤多空檢查表](https://www.xq.com.tw/xstrader/%e5%bb%ba%e6%a7%8b%e5%b0%88%e5%b1%ac%e7%9a%84%e5%a4%a7%e7%9b%a4%e5%a4%9a%e7%a9%ba%e6%aa%a2%e6%9f%a5%e8%a1%a8/) 說明：4.Zero Lag Heikin-Ashi多空指標

input: Length(14);

variable: price(0), haO(0), haC(0), haMax(0), haMin(0), TEMA1(0), TEMA2(0), EMA(0), ZeroLagHA(0);

price \= (close+open+high+low)/4;

haO \= (haO\[1\]+price)/2;

haMax \= maxlist(high, haO);

hamin \= minlist(low, haO);

haC \= (price+haO+haMax+haMin)/4;

EMA \= xaverage(haC, Length);

TEMA1 \= 3\*EMA-3\*xaverage(EMA, Length)+xaverage(xaverage(EMA, Length), Length);

EMA \= xaverage(TEMA1, Length);

TEMA2 \= 3\*EMA-3\*xaverage(EMA, Length)+xaverage(xaverage(EMA, Length), Length);

ZeroLagHA \= 2\*TEMA1-TEMA2;

value1=zerolagha-average(c,20);

plot1(ZeroLagHA, "Zero Lag HeikinAshi");

plot2(average(C,20),"Average");

plot3(value1,"多空指標");

---

## 場景 1027：R平方語法的介紹 — 我們可以寫一個選股腳本如下:

來源：[R平方語法的介紹](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e7%9b%ae%e5%89%8d%e8%b6%a8%e5%8b%a2%e9%82%84%e5%90%91%e4%b8%8a%e7%9a%84%e8%82%a1%e7%a5%a8/) 說明：我們可以寫一個選股腳本如下:

input:Length(20); //"計算期間"

LinearReg(close, Length, 0, value1, value2, value3, value4);

//做收盤價20天線性回歸

{value1:斜率,value4:預期值}

value5=rsquare(close,value4,20);//算收盤價與線性回歸值的R平方

if value1\>0 and value5\>0.2

then ret=1;

---

## 場景 1028：如何確認大盤到底了? — 我用XS寫了一個符合這種概念的選股腳本如下:

來源：[如何確認大盤到底了?](https://www.xq.com.tw/xstrader/%e5%a6%82%e4%bd%95%e7%a2%ba%e8%aa%8d%e5%a4%a7%e7%9b%a4%e5%88%b0%e5%ba%95%e4%ba%86/) 說明：我用XS寫了一個符合這種概念的選股腳本如下:

input:Leng1(5),Leng2(20),Leng3(60);

variable: ma1(0), ma2(0), ma3(0);

SetInputName(1,"短均線");

SetInputName(2,"中均線");

SetInputName(3,"長均線");

setbarback(maxlist(Leng1,Leng2,Leng3));

settotalbar(maxlist(Leng1,Leng2,Leng3)+3);

ma1 \= average(close, Leng1);

ma2 \= average(close, Leng2);

ma3 \= average(close, Leng3);

condition1 \= close \> ma1;

condition2 \= ma1 \> ma2;

condition3 \= ma2 \> ma3;

if condition1 and condition2 and condition3 then

ret \= 1;

SetOutputName1("短均線");

OutputField1(ma1);

SetOutputName2("中均線");

OutputField2(ma2);

SetOutputName3("長均線");

OutputField3(ma3);

---

## 場景 1029：跌回起漲點的股票要怎麼找? — 下面的這個腳本可以拿來運用

來源：[跌回起漲點的股票要怎麼找?](https://www.xq.com.tw/xstrader/%e8%b7%8c%e5%9b%9e%e8%b5%b7%e6%bc%b2%e9%bb%9e%e7%9a%84%e8%82%a1%e7%a5%a8%e8%a6%81%e6%80%8e%e9%ba%bc%e6%89%be/) 說明：下面的這個腳本可以拿來運用

input:period(100);

setinputname(1,"計算區間");

value1=lowest(low,period);

value2=lowestbar(low,period);

value3=highest(high,period);

value4=highestbar(high,period);

if

value2\>value4//有上漲過

and

value3\>value1\*1.3//漲幅超過三成

and

close\>value1 //股價比起漲點高

and

close\<=value1\*1.05//目前股價跌回起漲點附近

then ret=1;

---

## 場景 1030：反彈的計算語法 — 我寫了一個腳本，可以用來計算那些股票反彈低於或高於多少%，腳本如下:

來源：[反彈的計算語法](https://www.xq.com.tw/xstrader/%e9%97%9c%e6%96%bc%e6%90%b6%e5%8f%8d%e5%bd%88%ef%bc%8c%e6%88%91%e5%80%91%e8%a9%b2%e7%9f%a5%e9%81%93%e7%9a%84%e4%ba%8b/) 說明：我寫了一個腳本，可以用來計算那些股票反彈低於或高於多少%，腳本如下:

input:period(100);

input:ratio(0.382);

input:percent(30);

setinputname(1,"計算區間");

setinputname(2,"反彈標準");

value1=highest(high,period);

value2=lowest(low,period);

value4=highestbar(high,period);

value5=lowestbar(low,period);

value3=value2+(value1-value2)\*ratio;

if value4\>value5

and close\>value3

and (value1-value2)/value2\*100\>percent

and volume\>1000

then ret=1;

---

## 場景 1031：那些股票如果財報不如預期賣壓及拉回幅度會比較重 — 所以我用XS寫了一個選股法，列出投信買的張數，用五日均量來算，三天都砍不掉的股票，另外我加了股本小於100億的過濾機制，我寫的腳本如下:

來源：[那些股票如果財報不如預期賣壓及拉回幅度會比較重](https://www.xq.com.tw/xstrader/%e6%ae%ba%e7%9b%a4%e7%b8%bd%e5%9c%a8%e8%b2%a1%e5%a0%b1%e5%85%ac%e4%bd%88%e5%be%8c%e9%81%bf%e9%96%8b%e5%9c%b0%e9%9b%b7%e7%9a%84%e5%8d%81%e7%a8%ae%e6%96%b9%e6%b3%95%e4%b9%8b%e4%b8%80/) 說明：所以我用XS寫了一個選股法，列出投信買的張數，用五日均量來算，三天都砍不掉的股票，另外我加了股本小於100億的過濾機制，我寫的腳本如下:

value1=GetField("投信持股","D");

value2=GetField("外資持股","D");

value3= average(volume,5);

if value3\*3\<value1 and volume\>=1000

then ret=1;

if value3\<\>0

then value4=value1/value3;

setoutputname1("投信持股張數");

outputfield1(value1);

setoutputname2("五日均量");

outputfield2(value3,5);

setoutputname3("外資持股張數");

outputfield3(value2);

setoutputname4("投信持股五日均量比");

outputfield4(value4);

---

## 場景 1032：找出在財報公佈前可能要先避開的公司

來源：[找出在財報公佈前可能要先避開的公司](https://www.xq.com.tw/xstrader/%e6%89%be%e5%87%ba%e5%9c%a8%e8%b2%a1%e5%a0%b1%e5%85%ac%e4%bd%88%e5%89%8d%e5%8f%af%e8%83%bd%e8%a6%81%e5%85%88%e9%81%bf%e9%96%8b%e7%9a%84%e5%85%ac%e5%8f%b8/) 說明：我用XS寫了一個腳本

input:PER(30);

setinputname(1,"推估本益比");

value1=GetField("月營收","M");//單位:億元

value2=GetField("營業毛利率","Q");//單位:%

value3=GetField("營業費用","Q");//單位:百萬

value10=GetField("最新股本");

value4=GetField("月營收","M")+GetField("月營收","M")\[1\]+GetField("月營收","M")\[2\];//最近三個月的營收總和

value5=value4\*(value2/100)-(value3/100);//營收\*毛利率-營業費用

value6=value5\*4/value10\*10;//以最近一季的本業獲利來估算全年每股獲利

if value6\<\>0

then value7=close/value6;

if value7\>PER

then ret=1;

SetOutputName1("最近三個月營收總和");

OutputField1(value4);

SetOutputName2("營業毛利");

OutputField2(value4\*value2/100);

SetOutputName3("營業費用");

OutputField3(value3);

SetOutputName4("預估EPS");

OutputField4(value6);

SetOutputName4("推估本益比");

OutputField4(value7);

---

## 場景 1033：找出在財報公佈前可能要先避開的公司 — 所以我們再寫以下的腳本，來算出本益獲利佔八成以上的公司

來源：[找出在財報公佈前可能要先避開的公司](https://www.xq.com.tw/xstrader/%e6%89%be%e5%87%ba%e5%9c%a8%e8%b2%a1%e5%a0%b1%e5%85%ac%e4%bd%88%e5%89%8d%e5%8f%af%e8%83%bd%e8%a6%81%e5%85%88%e9%81%bf%e9%96%8b%e7%9a%84%e5%85%ac%e5%8f%b8/) 說明：所以我們再寫以下的腳本，來算出本益獲利佔八成以上的公司

value1=GetField("營業利益","Q");//單位百萬

value2=GetField("稅前淨利","Q");//單位百萬

if value2\>0

then begin

if value1/value2\*100\>80

then ret=1;

end;

---

## 場景 1034：以股價越過整數關卡為例介紹intportion這個函數 — 為了在盤中就找出這樣的股票，我寫了一個腳本如下:

來源：[以股價越過整數關卡為例介紹intportion這個函數](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%83%b9%e8%b6%8a%e9%81%8e%e6%95%b4%e6%95%b8%e9%97%9c%e5%8d%a1/) 說明：為了在盤中就找出這樣的股票，我寫了一個腳本如下:

input:period(10);

setinputname(1,"維持原價位區間的天數");

value1=intportion(close/10);

if trueall(value1\[1\]=value1\[2\],period)

and value1\>value1\[1\] and value1\<10

then ret=1;

---

## 場景 1035：主力作多成本線 — 以下就是這個指標的腳本

來源：[主力作多成本線](https://www.xq.com.tw/xstrader/%e4%b8%bb%e5%8a%9b%e4%bd%9c%e5%a4%9a%e6%88%90%e6%9c%ac%e7%b7%9a/) 說明：以下就是這個指標的腳本

input:period(40);

value1=GetField("主力買張");

value2=(o+h+l+c)/4;

value3=value1\*value2;//做多金額

if summation(value1,period)\<\>0

then value4=summation(value3,period)/summation(value1,period);

plot1(value4,"主力作多成本線");

---

## 場景 1036：潛龍昇天 — 以下就是符合潛龍飛天概念的腳本

來源：[潛龍昇天](https://www.xq.com.tw/xstrader/%e6%bd%9b%e9%be%8d%e9%a3%9b%e5%a4%a9/) 說明：以下就是符合潛龍飛天概念的腳本

input:StartDate(20150301);

input:LowMonth(3);

if currentbar \=1 and date \< startdate then raiseruntimeerror("日期不夠遠");

variable:iHigh(0); iHigh=maxlist(iHigh,H);

variable:iLow(100000); iLow=minlist(iLow,L);

variable:hitlow(0),hitlowdate(0);

if iLow \= Low then //觸低次觸與最後一次觸低日期

begin

hitlow+=1;

hitlowdate \=date;

end;

if DateAdd(hitlowdate,"M",3) \< Date and//如果自觸低點那天三個月後都沒有再觸低

iHigh/iLow \< 1.3 and //波動在三成以內

iHigh \= High then

//來到設定日期以來最高點

ret \=1;

---

## 場景 1037：尋找底部到了的領先指標

來源：[尋找底部到了的領先指標](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e5%ba%95%e9%83%a8%e5%88%b0%e4%ba%86%e7%9a%84%e9%a0%98%e5%85%88%e6%8c%87%e6%a8%99/) 說明：它的腳本如下:

input:period1(5);

value1=GetField("上漲家數");

value2=GetField("下跌家數");

value3=GetField("漲停家數");

value4=GetField("跌停家數");

value5=value1+value3\*2-(value2+value4\*2);

value6=average(value5,period1);

plot1(value6,"移動平均");

---

## 場景 1038：今天走強且會量增超過三成，且短期未漲的股票\~預估量函數的應用 — 以下是我寫的一個簡單的腳本:

來源：[今天走強且會量增超過三成，且短期未漲的股票\~預估量函數的應用](https://www.xq.com.tw/xstrader/%e4%bb%8a%e5%a4%a9%e8%b5%b0%e5%bc%b7%e4%b8%94%e6%9c%83%e9%87%8f%e5%a2%9e%e8%b6%85%e9%81%8e%e4%b8%89%e6%88%90%ef%bc%8c%e4%b8%94%e7%9f%ad%e6%9c%9f%e6%9c%aa%e6%bc%b2%e7%9a%84%e8%82%a1%e7%a5%a8%e9%a0%90/) 說明：以下是我寫的一個簡單的腳本:

input:pratio(2);//股價上漲的幅度

input:vratio(30);//預估成交量比五日均量增加的幅度

if estvolume\>=average(volume,5)\*(1+vratio/100)//預估量大於五日均量N%

and close\>close\[1\]\*(1+pratio/100)//今日股價上漲N%

and close\>low\[4\]\*1.05//股價距離近五日低點不到5%

then ret=1;

---

## 場景 1039：預估量函數的介紹 — 我們可以寫一個選股腳本如下:

來源：[預估量函數的介紹](https://www.xq.com.tw/xstrader/%e9%82%a3%e4%ba%9b%e8%82%a1%e7%a5%a8%e4%b8%ad%e9%95%b7%e7%b4%85%e4%b9%8b%e5%be%8c%e9%82%84%e6%9c%83%e7%ba%8c%e6%bc%b2/) 說明：我們可以寫一個選股腳本如下:

if close\>=close\[1\]\*1.03 and volume\>500

then ret=1;

---

## 場景 1040：預估量函數的介紹 — 然後接下來，我們要寫一個腳本，在盤中來確認那些股票成交量有比前一天高，要寫這個腳本，我們得先寫一個腳本來預估今天的成交量，這個腳本如下:

來源：[預估量函數的介紹](https://www.xq.com.tw/xstrader/%e9%82%a3%e4%ba%9b%e8%82%a1%e7%a5%a8%e4%b8%ad%e9%95%b7%e7%b4%85%e4%b9%8b%e5%be%8c%e9%82%84%e6%9c%83%e7%ba%8c%e6%bc%b2/) 說明：然後接下來，我們要寫一個腳本，在盤中來確認那些股票成交量有比前一天高，要寫這個腳本，我們得先寫一個腳本來預估今天的成交量，這個腳本如下:

variable:CloseTime(133000); // 收盤時間

variable: OpenMinutes(270);//一天有幾分鐘開盤

variable: MinutestoClose(270); //到收盤還有幾分鐘

variable: Length(20); //用過去幾天日資料計算

variable: AvgDayVol(0); //平均日量

variable: AvgMinVolinDay(0); //平均分鐘量

variable: LeftVol(0); //剩餘時間的估計量

variable: estVol(0); //最終估計量

AvgDayVol \= average(V,Length);

AvgMinVolinDay \= AvgDayVol/OpenMinutes; //過去這段時間每分鐘的平均量

MinutestoClose \= Timediff(CloseTime,currenttime,"M"); //現在到收盤還有幾分鐘

LeftVol \= MinutestoClose \*AvgMinVolinDay;// 剩餘時間乘上每分鐘均量 \= 盛夏時間可能有多少量

if ( barfreq \="D") then //是日線才會對

begin

if Date \=currentdate then //今天才回估量

estVol \=volume \+ LeftVol //估計量 等於 現在的日總量 加上 剩下時間估計的量

else

estVol \=v; //過去的話就直接回實際的量

end;

estvolume \=estVol;

---

## 場景 1041：預估量函數的介紹 — 有了estvolume這個函數，寫法就很簡單

來源：[預估量函數的介紹](https://www.xq.com.tw/xstrader/%e9%82%a3%e4%ba%9b%e8%82%a1%e7%a5%a8%e4%b8%ad%e9%95%b7%e7%b4%85%e4%b9%8b%e5%be%8c%e9%82%84%e6%9c%83%e7%ba%8c%e6%bc%b2/) 說明：有了estvolume這個函數，寫法就很簡單

value1=q\_InSize;//當日內盤量

value2=q\_OutSize;//當日外盤量

if estvolume \> volume\[1\]

and value2\>value1

then ret=1;

---

## 場景 1042：除權行情的檢討腳本該怎麼寫 — 我們公司的高手高手高高手寫了一個函數來解決這個問題，函數的腳本如下:

來源：[除權行情的檢討腳本該怎麼寫](https://www.xq.com.tw/xstrader/%e9%99%a4%e6%ac%8a%e8%a1%8c%e6%83%85%e7%9a%84%e6%aa%a2%e8%a8%8e%e8%85%b3%e6%9c%ac%e8%a9%b2%e6%80%8e%e9%ba%bc%e5%af%ab/) 說明：我們公司的高手高手高高手寫了一個函數來解決這個問題，函數的腳本如下:

Input: target(numeric);

variable: i(1);

if target \> date then

begin

GetBarOffset \= 0;

return;

end;

while true

begin

Value1 \= date\[i\];

if Value1 \<= target then

begin

GetBarOffset \= i;

return;

end;

i \= i \+ 1;

end;

---

## 場景 1043：除權行情的檢討腳本該怎麼寫 — 運用這個函數，可以寫出下面這個腳本來找出特定日期之後，到現在個股的漲跌幅

來源：[除權行情的檢討腳本該怎麼寫](https://www.xq.com.tw/xstrader/%e9%99%a4%e6%ac%8a%e8%a1%8c%e6%83%85%e7%9a%84%e6%aa%a2%e8%a8%8e%e8%85%b3%e6%9c%ac%e8%a9%b2%e6%80%8e%e9%ba%bc%e5%af%ab/) 說明：運用這個函數，可以寫出下面這個腳本來找出特定日期之後，到現在個股的漲跌幅

Input: type(1);

SetInputName(1, "1:股東會,2:除息日,3:法說日");

Input: dist(20);

SetInputName(2, "事件發生在最近幾日");

Input: ratio(1);

SetInputName(3, "上漲%");

switch(type)

begin

case 1:

Value1 \= GetField("股東會日期");

case 3:

Value1 \= GetField("法說會日期");

case 2:

Value1 \= GetField("除息日期");

end;

If datediff(Date, Value1) \>= 0 and datediff(Date, Value1) \<= dist then

begin

// 計算今日到'Value1'那一天的漲跌幅

//

Value2 \= GetBarOffset(Value1);

Value3 \= RateOfChange(Close, Value2);

if Value3 \>= ratio Then Ret \= 1;

end;

OutputField(1, Value1); setoutputname(1, "發生日期");

OutputField(2, Value2); setoutputname(2, "距離今日幾天");

outputfield(3, Value3); setoutputname(3, "區間漲幅(%)");

---

## 場景 1044：Print語法調整 — 例如，我們想輸出成交價至D:\\Print下，可以這樣寫：

來源：[Print語法調整](https://www.xq.com.tw/xstrader/print%e8%aa%9e%e6%b3%95%e8%aa%bf%e6%95%b4/) 說明：例如，我們想輸出成交價至D:\\Print下，可以這樣寫：

print(file("d:\\print\\"),date,symbol,close);

---

## 場景 1045：Print語法調整 — 例如，我們想把檔案名稱改為“商品代碼.log”，可以這樣寫：

來源：[Print語法調整](https://www.xq.com.tw/xstrader/print%e8%aa%9e%e6%b3%95%e8%aa%bf%e6%95%b4/) 說明：例如，我們想把檔案名稱改為“商品代碼.log”，可以這樣寫：

print(file("\[Symbol\].log"),date,symbol,close);

---

## 場景 1046：Print語法調整 — 如果我們想按商品代碼來整理數據，可以這樣寫：

來源：[Print語法調整](https://www.xq.com.tw/xstrader/print%e8%aa%9e%e6%b3%95%e8%aa%bf%e6%95%b4/) 說明：如果我們想按商品代碼來整理數據，可以這樣寫：

print(file("d:\\print\\\[Symbol\]\\"),date,symbol,close);

---

## 場景 1047：Print語法調整 — 或者是，我們想把所有數據都輸出到同一個檔print.log中，可以這樣寫：

來源：[Print語法調整](https://www.xq.com.tw/xstrader/print%e8%aa%9e%e6%b3%95%e8%aa%bf%e6%95%b4/) 說明：或者是，我們想把所有數據都輸出到同一個檔print.log中，可以這樣寫：

print(file("d:\\print\\print.log"),date,symbol,close);

---

## 場景 1048：投信作帳的標的 — 根據這些條件，我寫成了以下的腳本

來源：[投信作帳的標的](https://www.xq.com.tw/xstrader/%e6%8a%95%e4%bf%a1%e4%bd%9c%e5%b8%b3%e7%9a%84%e6%a8%99%e7%9a%84/) 說明：根據這些條件，我寫成了以下的腳本

input:r1(50),days(30),r2(15),r3(5000),r4(30);

setinputname(1,"股本上限單位億");

setinputname(2,"天期");

setinputname(3,"區間合計買超張數");

setinputname(4,"區間漲幅上限%");

value1=GetField("投信買張","D");

value2=GetField("最新股本");//單位:億

condition1=false;

condition2=false;

condition3=false;

SetTotalBar(100);

if value2\<r1

then condition1=true;//股本小於50億元

value3=countif(value1\>50,days);

if value3\>=r2

then condition2=true;//近30天裡有超過15天買超

if summation(value1,days)\>r3

then condition3=true;//近30天合計買超超過5000張

if condition1 and condition2 and condition3

and close\<close\[days-1\]\*(1+r4/100)

then ret=1;

---

## 場景 1049：當多空勢力懸殊時 — 怎麼才能在盤中挑到這種委買與委賣張數對比很懸殊的股票呢？我寫了一個腳本如下：

來源：[當多空勢力懸殊時](https://www.xq.com.tw/xstrader/%e7%95%b6%e5%a4%9a%e7%a9%ba%e5%8b%a2%e5%8a%9b%e6%87%b8%e6%ae%8a%e6%99%82/) 說明：怎麼才能在盤中挑到這種委買與委賣張數對比很懸殊的股票呢？我寫了一個腳本如下：

input:v1(2000),v2(500),v3(1500),v4(400),v5(100);

setinputname(1,"委買五檔總金額(萬)");

setinputname(2,"委賣五檔總金額(萬)");

setinputname(3,"委買委賣總差額(萬)");

setinputname(4,"單一價位委買金額下限");

setinputname(5,"單一價位委賣金額上限");

variable:bidtv(0),asktv(0),tb(0),ta(0),b1(0),b2(0),b3(0),b4(0),b5(0),s1(0),s2(0),s3(0),s4(0),s5(0);

condition1=false;

condition2=false;

condition3=false;

bidtv=q\_SumBidSize;//總委買

asktv=q\_SumAskSize;//總委賣

value1=q\_BestBidSize1;//委買一

value2=q\_BestBidSize2;

value3=q\_bestbidsize3;

value4=q\_bestbidsize4;

value5=q\_bestbidsize5;

value6=q\_bestasksize1;//委賣一

value7=q\_bestasksize2;

value8=q\_bestasksize3;

value9=q\_bestasksize4;

value10=q\_bestasksize5;

tb=bidtv\*close/10;

ta=asktv\*close/10;

if tb\>v1 and ta\<v2 and tb-ta\>v3

then condition1=true;

b1=value1\*close/10;

b2=value2\*close/10;

b3=value3\*close/10;

b4=value4\*close/10;

b5=value5\*close/10;

s1=value6\*close/10;

s2=value7\*close/10;

s3=value8\*close/10;

s4=value9\*close/10;

s5=value10\*close/10;

if b1\>v4 and b2\>v4 and b3\>v4 and b4\>v4 and b5\>v4

then condition2=true;

if s1\<v5 and s2\<v5 and s3\<v5 and s4\<v5 and s5\<v5

then condition3=true;

if close\<\>q\_DailyUplimit

then begin

if condition1 or (condition2 and condition3)

then ret=1;

end;

---

## 場景 1050：修正式價量指標VPT(Volume price trend) — 這樣計算出來的指標，在盤整時整條線會很貼近水平線，只有在漲跌趨勢很明確時才會上漲或是下跌，所以如果拿它跟它自身的一定週期移動平均線來對照，我們可以看到非常明確的...

來源：[修正式價量指標VPT(Volume price trend)](https://www.xq.com.tw/xstrader/%e4%bf%ae%e6%ad%a3%e5%bc%8f%e5%83%b9%e9%87%8f%e6%8c%87%e6%a8%99vptvolume-price-trend/) 說明：這樣計算出來的指標，在盤整時整條線會很貼近水平線，只有在漲跌趨勢很明確時才會上漲或是下跌，所以如果拿它跟它自身的一定週期移動平均線來對照，我們可以看到非常明確的進出場訊號。我把上述的概念及算法用XS語法寫的指標如下:移動平均線的天期就勞煩各位自己調整了

input:days(10);

setinputname(1,"移動平均線天數");

var:tvp(0),mpc(0);

mpc=(open+high+low+close)/4;

if mpc\[1\]\<\>0

then

tvp=tvp\[1\]+(mpc-mpc\[1\])/mpc\[1\]\*volume

else

tvp=tvp\[1\];

value1=average(tvp,days);

plot1(tvp,"修正型價量指標");

plot2(value1,"移動平均");

---

## 場景 1051：改良版的移動平均線\~四大力道線 — 根據這樣的想法，我寫了一個指標，這個指標的寫法如下:

來源：[改良版的移動平均線\~四大力道線](https://www.xq.com.tw/xstrader/%e6%94%b9%e8%89%af%e7%89%88%e7%9a%84%e7%a7%bb%e5%8b%95%e5%b9%b3%e5%9d%87%e7%b7%9a%e5%9b%9b%e5%a4%a7%e5%8a%9b%e9%81%93%e7%b7%9a/) 說明：根據這樣的想法，我寫了一個指標，這個指標的寫法如下:

input:days(10),period(20);

setinputname(1,"短期參數");

setinputname(2,"長期參數");

value1=summation(high-close,period);//上檔賣壓

value2=summation(close-open,period); //多空實績

value3=summation(close-low,period);//下檔支撐

value4=summation(open-close\[1\],period);//隔夜力道

if close\<\>0

then

value5=(value2+value3+value4-value1)/close;

value6=average(value5,days);

plot1(value5,"四大力道線");

plot2(value6,"移動平均線");

---

## 場景 1052：尋找可能斷頭的股票 — 我用XS寫了一個選股腳本，專門尋找那些可能有斷頭危機的股票，腳本如下:

來源：[尋找可能斷頭的股票](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e5%8f%af%e8%83%bd%e6%96%b7%e9%a0%ad%e7%9a%84%e8%82%a1%e7%a5%a8/) 說明：我用XS寫了一個選股腳本，專門尋找那些可能有斷頭危機的股票，腳本如下:

input:period(30);//波段的天期

setinputname(1,"波段天期");

SetTotalBar(100);

value1=GetField("融資餘額張數","D");//取得最新融資餘額張數

value2=nthhighestbar(1,close,period);//找出波段最高點落在那一根bar

if value1\>average(volume,5)//融資餘額大於五日均量

and value1\[value2\]\>10000//波段高點的融資餘額超過一萬張

and close\*1.2\<=close\[value2\]//波段高點迄今跌幅超過兩成

then ret=1;

---

## 場景 1053：盤感好的股票 — 我根據他的說法，寫了一個即時的腳本如下:

來源：[盤感好的股票](https://www.xq.com.tw/xstrader/%e7%9b%a4%e6%84%9f%e5%a5%bd%e7%9a%84%e8%82%a1%e7%a5%a8/) 說明：我根據他的說法，寫了一個即時的腳本如下:

value1=q\_AvgLongUnits;//委買均張

value2=q\_AvgShortUnits;//委賣均張

value3=q\_InSize;//當日內盤量

value4=q\_OutSize;//當日外盤量

value5=q\_BestBidSize;//委買張數

value6=q\_BestAskSize;//委賣張數

value9=q\_BestBidSize1;//委買一張數

value10=q\_BestAskSize1;//委賣一張數

value11=q\_BestBidSize2;

value12=q\_BestAskSize2;

value13=q\_BestBidSize3;

value14=q\_BestAskSize3;

value15=q\_BestBidSize4;

value16=q\_BestAskSize4;

value17=q\_BestBidSize5;

value18=q\_BestAskSize5;

condition1=false;

condition2=false;

if value1-value2\>1 and value4\>value3 and value5-value6\>200

then condition1=true;

if minlist(value9,value11,value13,value15,value17)\>50

and maxlist(value10,value12,value14,value16,value18)\<30

then condition2=true;

if condition1 and condition2 then ret=1;

---

## 場景 1054：短線交易比例 — 基於這樣的觀察，我寫了一個指標:

來源：[短線交易比例](https://www.xq.com.tw/xstrader/%e7%9f%ad%e7%b7%9a%e9%81%8e%e7%86%b1%e7%9a%84%e6%8c%87%e6%a8%99/) 說明：基於這樣的觀察，我寫了一個指標:

input:p1(5);

setinputname(1,"移動平均線天期");

value1=GetField("融資買進張數");

value2=GetField("現股當沖張數");

value3=GetField("資券互抵張數");

value4=value1+value2+value3;

if volume\>0

then value5=value4/volume;

value6=average(value5,p1);

plot1(value5,"短線交易比例");

plot2(value6,"移動平均線");

---

## 場景 1055：短線交易比例 — 基於這樣的指標，我寫了一個選出短線過熱股票的選股腳本

來源：[短線交易比例](https://www.xq.com.tw/xstrader/%e7%9f%ad%e7%b7%9a%e9%81%8e%e7%86%b1%e7%9a%84%e6%8c%87%e6%a8%99/) 說明：基於這樣的指標，我寫了一個選出短線過熱股票的選股腳本

input:p1(5),p2(20),p3(15);

setinputname(1,"成交量比前一天多?%");

setinputname(2,"漲幅計算區間");

setinputname(3,"區間漲幅下限");

settotalbar(100);

value1=GetField("融資買進張數");

value2=GetField("現股當沖張數");

value3=GetField("資券互抵張數");

value4=value1+value2+value3;

if volume\>0

then value5=value4/volume;

if volume\>volume\[1\]\*(1+p1/100)

and value5\>=0.59

and close\>close\[p2-1\]\*(1+p3/100)

then ret=1;

---

## 場景 1056：靜極思動 — 根據這些條件，對應的腳本如下

來源：[靜極思動](https://www.xq.com.tw/xstrader/%e9%9d%9c%e6%a5%b5%e6%80%9d%e5%8b%95/) 說明：根據這些條件，對應的腳本如下

input:r1(3),r2(15),r3(5);

setinputname(1,"短天期均量及真實波動區間的長度");

setinputname(2,"長天期均量及真實波動區間的長度");

settotalbar(100);

if average(truerange,r1) \>= average(truerange,r2)\*1.02

and average(volume,r1)\>=average(volume,r2)\*1.2

and high\>=highest(high\[1\],r3)

and close\<=close\[r3\]\*1.1

and volume\>500

then ret=1;

---

## 場景 1057：WVAD威廉變異離散量 — 以下是根據這樣的理論所寫出來的腳本

來源：[WVAD威廉變異離散量](https://www.xq.com.tw/xstrader/wvad%e5%a8%81%e5%bb%89%e8%ae%8a%e7%95%b0%e9%9b%a2%e6%95%a3%e9%87%8f/) 說明：以下是根據這樣的理論所寫出來的腳本

input:length(5);

variable:wvad(0);

value1=close-open;

value2=high-low;

if high\<\>low

then value3=value1/value2\*volume

else

value3=value3\[1\];

wvad=summation(value3,length);

plot1(wvad,"威廉變異離散量");

plot2(0);

---

## 場景 1058：Q指標

來源：[Q指標](https://www.xq.com.tw/xstrader/q%e6%8c%87%e6%a8%99/) 說明：對應的腳本如下:

input:t1(10);

input:t2(5);

input:t3(20);

setinputname(1,"計算累積價格變動的bar數");

setinputname(2,"計算價格累積變化量移動平均的期別");

setinputname(3,"計算雜訊的移動平均期別");

value1=close-close\[1\];//價格變化

value2=summation(value1,t1);//累積價格變化

value3=average(value2,t2);

value4=absvalue(value2-value3);//雜訊

value5=average(value4,t3);//把雜訊移動平均

variable:Qindicator(0);

if value5=0

then Qindicator=0

else

Qindicator=value3/value5\*5;

plot1(Qindicator,"趨勢值");

---

## 場景 1059：KO克林格成交量擺動指標 — 克林格成交量擺動指標Klinger Oscillator, KO是一個與成交量又關的股票技術指標，它是由Stephen J. Klinger所發明的。以下介紹一...

來源：[KO克林格成交量擺動指標](https://www.xq.com.tw/xstrader/ko%e5%85%8b%e6%9e%97%e6%a0%bc%e6%88%90%e4%ba%a4%e9%87%8f%e6%93%ba%e5%8b%95%e6%8c%87%e6%a8%99/) 說明：克林格成交量擺動指標Klinger Oscillator, KO是一個與成交量又關的股票技術指標，它是由Stephen J. Klinger所發明的。以下介紹一下這個技術指標的計算方法和它在股票交易中的使用方法。克林格成交量擺動指標Klinger Oscillator的計算方法 ：首先，計算股票在每個交易日的平均價格=（收盤價+最高價+最低價）/3如果，平均交易價格高於前一日的平均交易價格，那麼當...

value1=(close+high+low)/3;

variable:v1(0);

if value1\>=value1\[1\]

then v1=volume

else v1=volume\*(-1);

value2=average(v1,34);

value3=average(v1,55);

value4=value2-value3;

value6=average(value4,3);

value5=average(value4,13);

plot1(value6);

plot2(value5);

---

## 場景 1060：％B指標 — %B這個指標，是從佈林值演化過來的，我們要了解%B指標前，先來溫習一下佈林通道(BBand)

來源：[％B指標](https://www.xq.com.tw/xstrader/%ef%bc%85b%e6%8c%87%e6%a8%99/) 說明：%B這個指標，是從佈林值演化過來的，我們要了解%B指標前，先來溫習一下佈林通道(BBand)

Input: price(numericseries), length(numericsimple), \_band(numericsimple);

BollingerBand \= Average(price, length) \+ \_band \* StandardDev(price, length, 1);

---

## 場景 1061：％B指標

來源：[％B指標](https://www.xq.com.tw/xstrader/%ef%bc%85b%e6%8c%87%e6%a8%99/) 說明：以下就是%B的腳本

input: Length(20);	SetInputName(1, "布林通道天數");

input: BandRange(2);SetInputName(2, "上下寬度");

input: MALength(10);SetInputName(3, "MA天期");

variable: up(0), down(0), mid(0);

up \= bollingerband(Close, Length, BandRange);

down \= bollingerband(Close, Length, \-1 \* BandRange);

if up \- down \= 0 then value1 \= 0 else value1 \= (close \- down) \* 100 / (up \- down);

value2 \= average(value1, MALength);

Plot1(value1, "%b");

Plot2(value2, "%b平均");

---

## 場景 1062：DKX多空線 — 以下是DKX多空線的腳本

來源：[DKX多空線](https://www.xq.com.tw/xstrader/dkx%e5%a4%9a%e7%a9%ba%e7%b7%9a/) 說明：以下是DKX多空線的腳本

variable:MID(0),midsum(0),DKX(0),DKXMA(0);

input:length(10);

MID=(close\*3+open+high+low)/6;

variable:r1(0);

midsum=0;

for r1=0 to 19 begin

midsum=(20-r1)\*mid\[r1\]+midsum;

end;

DKX=midsum/210;

dkxma=average(dkx,length);

plot1(close,"收盤價");

plot2(dkxma,"dkx的移動平均線");

---

## 場景 1063：KST確認指標 — KST確認指標是把短中長期的變動率ROC給與不同權重，用來判斷趨勢，精准掌握轉折買賣點。腳本如下：

來源：[KST確認指標](https://www.xq.com.tw/xstrader/kst%e7%a2%ba%e8%aa%8d%e6%8c%87%e6%a8%99/) 說明：KST確認指標是把短中長期的變動率ROC給與不同權重，用來判斷趨勢，精准掌握轉折買賣點。腳本如下：

variable:kst(0);

value1=average(rateofchange(close,12),10);

value2=average(rateofchange(close,20),10);

value3=average(rateofchange(close,30),8);

value4=average(rateofchange(close,40),15);

kst=value1+value2\*2+value3\*3+value4\*4;

plot1(kst,"KST確認指標");

---

## 場景 1064：ALF亞歷山大過濾指標 — 這指標很簡單算，但卻出乎意料之外的好用它的算法就是拿今天的收盤價去除以十天前的收盤價大於一就代表這十天作多的都賺錢，小於一就代表這十天作多的都被套牢。

來源：[ALF亞歷山大過濾指標](https://www.xq.com.tw/xstrader/alf%e4%ba%9e%e6%ad%b7%e5%b1%b1%e5%a4%a7%e9%81%8e%e6%bf%be%e6%8c%87%e6%a8%99/) 說明：這指標很簡單算，但卻出乎意料之外的好用它的算法就是拿今天的收盤價去除以十天前的收盤價大於一就代表這十天作多的都賺錢，小於一就代表這十天作多的都被套牢。

input: length(10); setinputname(1, "天期");

Value1 \= close / close\[length-1\];

plot1(Value1, "亞歷山大過濾指標");

---

## 場景 1065：尋找大盤短期多空方向的指標 — 我看盤看了 25年，兩個最大的心得是1.大家很習慣樂觀時更樂觀，悲觀時更悲觀，追漲又殺跌。2.大家很愛比價，有人帶頭拉，同類的就有人追，有人帶頭殺，同類的就很難...

來源：[尋找大盤短期多空方向的指標](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e5%a4%a7%e7%9b%a4%e7%9f%ad%e6%9c%9f%e5%a4%9a%e7%a9%ba%e6%96%b9%e5%90%91%e7%9a%84%e6%8c%87%e6%a8%99/) 說明：我看盤看了 25年，兩個最大的心得是1.大家很習慣樂觀時更樂觀，悲觀時更悲觀，追漲又殺跌。2.大家很愛比價，有人帶頭拉，同類的就有人追，有人帶頭殺，同類的就很難撐得住。基於這兩個原理，我用XS寫了一個很簡單的指標，透過漲跌家數及漲跌停家數的變化，來尋找大盤的多空轉折點我的腳本如下:

input:period1(5),period2(15);

value1=GetField("上漲家數");

value2=GetField("下跌家數");

value3=GetField("漲停家數");

value4=GetField("跌停家數");

value5=value1+value3\*2-(value2+value4\*2);

//(上漲家數+漲停家數\*2)-(下跌家數+下跌家數\*2)

value6=average(value5,period1);//短天期平均

value7=average(value5,period2);//長天期平均

plot1(value6,"短天期");

plot2(value7,"長天期");

---

## 場景 1066：尋找那些先前大漲過，最近在休息的股票 — 來尋找那些先前大漲過，最近在休息的股票正所謂春江水暖鴨先知，一檔股票如果兩天可以漲一成，代表有人真金白銀地押在這檔股票上，而且還願意追高，這種情況往往是有人知道...

來源：[尋找那些先前大漲過，最近在休息的股票](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e9%82%a3%e4%ba%9b%e5%85%88%e5%89%8d%e5%a4%a7%e6%bc%b2%e9%81%8e%ef%bc%8c%e6%9c%80%e8%bf%91%e5%9c%a8%e4%bc%91%e6%81%af%e7%9a%84%e8%82%a1%e7%a5%a8/) 說明：來尋找那些先前大漲過，最近在休息的股票正所謂春江水暖鴨先知，一檔股票如果兩天可以漲一成，代表有人真金白銀地押在這檔股票上，而且還願意追高，這種情況往往是有人知道了公司不為人知的利多，率先佈局。但代誌不見得像這些有消息的人想的那麼簡單，有時候盤不好，或者短線獲利及解套的賣壓湧現，造成股價上去又下來，春鴨反而被套牢。但如果春鴨掌握的消息是正確的，後來隨著消息面的更廣為人知，就會有更多的買盤進場，如果這...

condition1=false;

settotalbar(100);

if countif(close\>close\[2\]\*1.1,20)=1

then condition1=true;//過去二十天內有一次兩天漲超過10%

if close\*1.05\<highest(close,20)//現在股價比20天來的低點低至少5%

and trueall(close\<=close\[1\],2)//這兩天股價都持平或收黑

and highest(close,20)=highest(close,60)//近二十天來的高點跟近六十天來的高點一樣高，代表不是一路下跌的走勢，上次的急拉不是跌深反彈

and condition1

then ret=1;

---

## 場景 1067：大盤多空對策訊號 — 如果符合條件就加一分，然後每天歸零，重新計算，最後再取十日移動平均。在語法上，寫法大致如下:

來源：[大盤多空對策訊號](https://www.xq.com.tw/xstrader/%e5%a4%a7%e7%9b%a4%e5%a4%9a%e7%a9%ba%e5%b0%8d%e7%ad%96%e8%a8%8a%e8%99%9f/) 說明：如果符合條件就加一分，然後每天歸零，重新計算，最後再取十日移動平均。在語法上，寫法大致如下:

input:P1(30);setinputname(1,"先前法人未接觸天數");

variable: XData(0),YData(0),ZData(0),Z(0);

if currenttime \> 180000 or currenttime \< 083000 then Z \=0 else Z=1;

XData \= GetField("外資買賣超")\[Z\];

YData \= GetField("投信買賣超")\[Z\];

ZData \= GetField("自營商買賣超")\[Z\];

value6=GetField("上漲量");

value7=GetField("外盤量");

variable:count(0);

if date\<\>date\[1\]

then count=0;

if xdata\>0

then count=count+1;

if ydata\>0

then count=count+1;

if zdata\>0

then count=count+1;

if value4-value4\[1\]\<20000

then count=count+1;

if value5-value5\[1\]\>20000

then count=count+1;

if value6/volume\>0.00001

then count=count+1;

if value7/volume\>0.5

then count=count+1;

value8=rsi(close,5);

value9=rsi(close,10);

if value8\>value9 and value8\<90

then count=count+1;

variable: Dif\_val(0), MACD\_val(0), Osc\_val(0);

MACD(Close, 12, 26, 9, Dif\_val, MACD\_val, Osc\_val);

if osc\_val\>0

then count=count+1;

value10=mtm(10);

if value10\>0

then count=count+1;

variable:rsv1(0),k1(0),d1(0);

stochastic(9,3,3,rsv1,k1,d1);

if k1\>d1 and k1\<80

then count=count+1;

variable:pdi\_value(0),ndi\_value(0),adx\_value(0);

DirectionMovement(14,pdi\_value,ndi\_value,adx\_value);

if pdi\_value\>ndi\_value

then count=count+1;

value12=GetField("主力買賣超張數");

value13=average(value12,5);

if value13\>0

then count=count+1;

value14=ar(26);

value15=linearregslope(value14,5);

if value15\>0

then count=count+1;

value16=acc(10);

if value16\>0

then count=count+1;

value17=trix(close,9);

value18=trix(close,15);

if value17\>value18

then count=count+1;

value19=SAR(0.02, 0.02, 0.2);

if close\>value19

then count=count+1;

if average(close,5)\>average(close,12)

then count=count+1;

value11=average(count,10);

plot1(value11);

---

## 場景 1068：GetField — 您只要選取其中一個欄位按插入鍵，系統就自動把這個欄位帶到您的腳本中，因此，您就不需要去記那個欄位的英文名字是什麼。例如我們如果要取得今日的外資買賣超，我們的寫法...

來源：[GetField](https://www.xq.com.tw/xstrader/getfield/) 說明：您只要選取其中一個欄位按插入鍵，系統就自動把這個欄位帶到您的腳本中，因此，您就不需要去記那個欄位的英文名字是什麼。例如我們如果要取得今日的外資買賣超，我們的寫法可以如下 :

value1=Getfield("外資買賣超"); 其單位是張數

---

## 場景 1069：GetField — 如果我們要取得前一日的外資買賣超，其寫法跟我們要取得前一日的收盤價是一樣的，也就是用中括號裡寫個1就可以，所以其寫法如下 :

來源：[GetField](https://www.xq.com.tw/xstrader/getfield/) 說明：如果我們要取得前一日的外資買賣超，其寫法跟我們要取得前一日的收盤價是一樣的，也就是用中括號裡寫個1就可以，所以其寫法如下 :

value1=Getfield("外資買賣超")\[1\];

---

## 場景 1070：GetField — 這麼多的欄位，在使用上，XScript建議的語法如下:

來源：[GetField](https://www.xq.com.tw/xstrader/getfield/) 說明：這麼多的欄位，在使用上，XScript建議的語法如下:

Value1=getfield(“tradevalue”)\[1\]

---

## 場景 1071：GetField

來源：[GetField](https://www.xq.com.tw/xstrader/getfield/)

value1=getfield(“成交金額”)\[1\]

---

## 場景 1072：GetField — 舉個例子，如果要找前一日主力買超創120天來新高，且近三日主力都買超，成交量過500張，且今天上漲超過3%的股票，就可以寫成腳本如下

來源：[GetField](https://www.xq.com.tw/xstrader/getfield/) 說明：舉個例子，如果要找前一日主力買超創120天來新高，且近三日主力都買超，成交量過500張，且今天上漲超過3%的股票，就可以寫成腳本如下

value1=GetField("主力買賣超張數")\[1\];

if value1=highest(value1,120)

and trueall(value1\>0,3)

and volume\>500

and close\>close\[1\]\*1.03

then ret=1;

---

## 場景 1073：變數 — 什麼是變數?我們用input來指定一個參數的值，這個值被指定後就不會變，例如我們寫一個腳本如下 :

來源：[變數](https://www.xq.com.tw/xstrader/%e8%ae%8a%e6%95%b8/) 說明：什麼是變數?我們用input來指定一個參數的值，這個值被指定後就不會變，例如我們寫一個腳本如下 :

Input:days(10);

If (close –close\[days\])/close\[days\] \> 0.1

Then ret=1;

---

## 場景 1074：變數

來源：[變數](https://www.xq.com.tw/xstrader/%e8%ae%8a%e6%95%b8/)

Var:range(0);

Range=high-low;

---

## 場景 1075：變數 — 接下來我們就可以把變數拿來作為腳本中很重要的一個元素，例如上面我們提到的最近三天震盪一天比一天大的陳述，就可以寫成 :

來源：[變數](https://www.xq.com.tw/xstrader/%e8%ae%8a%e6%95%b8/) 說明：接下來我們就可以把變數拿來作為腳本中很重要的一個元素，例如上面我們提到的最近三天震盪一天比一天大的陳述，就可以寫成 :

Var:range(0);

Range=high-low;

Range\>range\[1\] and range\[1\]\>range\[2\] and range\[2\]\>rnage\[3\];

---

## 場景 1076：變數 — 先前我們已經學到用 :Variable:變數名稱(0);這樣的方式來宣告這個變數的資料格式是數字，如果您不想花力氣作宣告，系統也提供了不需要事先宣告的變數供您使...

來源：[變數](https://www.xq.com.tw/xstrader/%e8%ae%8a%e6%95%b8/) 說明：先前我們已經學到用 :Variable:變數名稱(0);這樣的方式來宣告這個變數的資料格式是數字，如果您不想花力氣作宣告，系統也提供了不需要事先宣告的變數供您使用， 這些變數的名稱是從value1到value99共99個不必宣告就能使用的變數因此，你可以用AV20這個變數來代表收盤價的二十期移動平均，你可以這麼寫 :

VAR:AV20(0);

av20=average(close,20);

---

## 場景 1077：變數 — 如果圖個方便，又不怕記不得變數代表的意思，也可以寫成 :

來源：[變數](https://www.xq.com.tw/xstrader/%e8%ae%8a%e6%95%b8/) 說明：如果圖個方便，又不怕記不得變數代表的意思，也可以寫成 :

value1=average(close,20);

---

## 場景 1078：變數 — 要宣告時間變數時，由於XS中的時間跟日期，分別是六位數及八位數的數字，所以電腦一開始並無法從你的宣告中知道這個變數代表的是時間還是數字， 一開始會把它當數字，但...

來源：[變數](https://www.xq.com.tw/xstrader/%e8%ae%8a%e6%95%b8/) 說明：要宣告時間變數時，由於XS中的時間跟日期，分別是六位數及八位數的數字，所以電腦一開始並無法從你的宣告中知道這個變數代表的是時間還是數字， 一開始會把它當數字，但當你拿這變數來用在時間函數上時，電腦會把它拿視為時間。所以如果您寫出以下的腳本 :

Var:x1(090000);

Var:x2(20131115);

Value1=x1+x2

If time\>090000

Then print(value1);

---

## 場景 1079：變數 — 變數與參數的差異作為一個初學者，我們常會不知道何時用input來宣告參數，何時用variable來宣告變數。最直接的判斷方式，就是它的功用是什麼? 如果是用來指...

來源：[變數](https://www.xq.com.tw/xstrader/%e8%ae%8a%e6%95%b8/) 說明：變數與參數的差異作為一個初學者，我們常會不知道何時用input來宣告參數，何時用variable來宣告變數。最直接的判斷方式，就是它的功用是什麼? 如果是用來指定一個絕對值，並且希望這個絕對值在您想要更動時， 不必進到腳本改動很多個地方(同一個值)，那麼你需要的是用input來宣告參數。但如果你需要的是用它來代表一串運算的結果，當運算結果改變時，這數值也會跟著改變，純粹是為了撰寫腳本時方便， 那麼...

Input: X1(10); 設定X1這個參數的預設值是10

Input: X3(5); 設定X3這個參數的預設值是5

Var: X2(0); 設定一個變數X2，預設值是0

Var: X4(0); 設定一個變數X4，預設值是 0

X2=average(close,X1); 指定X2是以X1為天期的收盤價移動平均值

X4=average(close,X3); 指定X4是以X3為天期的收盤價移動平均值

If X4 cross over X2 then ret=1; 不同天期腳本出現黃金交叉時就觸發警示

---

## 場景 1080：參數

來源：[參數](https://www.xq.com.tw/xstrader/%e5%8f%83%e6%95%b8/)

If Open/High\[1\]\> 1+1/100

then ret=1;

---

## 場景 1081：參數 — 但很可能改天我們會希望跳空上漲2%才通知我們，這時候怎麼辦呢? 我們可以把跳空上漲的百分比設成一個可以快速調整的參數， 使用者需要調整百分比時，只要更改這個數字...

來源：[參數](https://www.xq.com.tw/xstrader/%e5%8f%83%e6%95%b8/) 說明：但很可能改天我們會希望跳空上漲2%才通知我們，這時候怎麼辦呢? 我們可以把跳空上漲的百分比設成一個可以快速調整的參數， 使用者需要調整百分比時，只要更改這個數字即可，不必再進到腳本去修改數據。例如上面的例子，就可以改寫成 :

input:no1(1);

If Open/Close\[1\]\> 1+no1/100

then ret=1;

---

## 場景 1082：函數 — 當我們有了開高低收成交量這些回傳值可以使用，也知道如何叫出時間序列上的每一根K棒來為我們利用來作運算之後， 很自然的，我們就可以計算出一個商品的其他有意義的數值...

來源：[函數](https://www.xq.com.tw/xstrader/%e5%87%bd%e6%95%b8/) 說明：當我們有了開高低收成交量這些回傳值可以使用，也知道如何叫出時間序列上的每一根K棒來為我們利用來作運算之後， 很自然的，我們就可以計算出一個商品的其他有意義的數值。例如 我們要計算五日移動平均，我們可以用以下腳本來表示 :

(close+close\[1\]+close\[2\]+close\[3\]+close\[4\])/5

---

## 場景 1083：函數 — 所以如果要寫一個腳本是當股價突破五日移動平均時，請電腦通知我們，我們可以寫出以下的腳本 :

來源：[函數](https://www.xq.com.tw/xstrader/%e5%87%bd%e6%95%b8/) 說明：所以如果要寫一個腳本是當股價突破五日移動平均時，請電腦通知我們，我們可以寫出以下的腳本 :

If close\[1\]\<(close\[1\]+close\[2\]+close\[3\]+close\[4\]+close\[5\])/5 and close\>(close+close\[1\]+close\[2\]+close\[3\]+close\[4\])/5

Then ret=1;

---

## 場景 1084：函數 — 所以在xscript上，我們加入一種叫作函數 的語法，這種語法讓我們可以把經常要計算的方法，用一個函數來表示， 例如5日收盤價的移動平均數我們可以直接寫成 av...

來源：[函數](https://www.xq.com.tw/xstrader/%e5%87%bd%e6%95%b8/) 說明：所以在xscript上，我們加入一種叫作函數 的語法，這種語法讓我們可以把經常要計算的方法，用一個函數來表示， 例如5日收盤價的移動平均數我們可以直接寫成 average(close,5)這樣上面的例子我們就可以改寫成 :

If average (close,5) \[1\] \> close\[1\] and close \> average (close,5)

Then ret=1;

---

## 場景 1085：函數 — 其次，XS也把大家常用的指標做成函數，例如我們常用RSI，XS就也它預設成函數，所以如果你需要的是六日RSI突破十二日RSI，你只要直接寫 :

來源：[函數](https://www.xq.com.tw/xstrader/%e5%87%bd%e6%95%b8/) 說明：其次，XS也把大家常用的指標做成函數，例如我們常用RSI，XS就也它預設成函數，所以如果你需要的是六日RSI突破十二日RSI，你只要直接寫 :

RSI (close,6) cross over RSI (close,12)

---

## 場景 1086：函數 — 黃金交叉的意思是有兩條線，當A線的前一個點比B線的前一個點低，但A 線的最近一點比B線的最近一點高，我們就稱為黃金交叉， 而其相反的情況就是死亡交叉，由於這兩種...

來源：[函數](https://www.xq.com.tw/xstrader/%e5%87%bd%e6%95%b8/) 說明：黃金交叉的意思是有兩條線，當A線的前一個點比B線的前一個點低，但A 線的最近一點比B線的最近一點高，我們就稱為黃金交叉， 而其相反的情況就是死亡交叉，由於這兩種情況使用者實在太常用了，因此XS乾脆把這兩個都寫成預設的函數， 這種函數就是我們常說的黃金交叉及死亡交叉，這兩個函數的名稱分別為crossover 及crossunder。在語法上如果A crossover B，代表A\[1\]\<B\[1\]and...

RSI(close,6) crossover RSI(close,12)

---

## 場景 1087：函數 — 有了這兩個函數之後，當我們要寫兩個數值出現黃金交叉時，我們只要寫 A Crossover B就是A對 B出現黃金交叉， 相反的，當 A Crossunder B...

來源：[函數](https://www.xq.com.tw/xstrader/%e5%87%bd%e6%95%b8/) 說明：有了這兩個函數之後，當我們要寫兩個數值出現黃金交叉時，我們只要寫 A Crossover B就是A對 B出現黃金交叉， 相反的，當 A Crossunder B代表的就是A對B出現死亡交叉。Crossunder與 Crossover串聯起來的這個述敘是一個邏輯判斷式，電腦會去判斷它是true還是false。例如我們想要電腦在個股突破五日均線時發出警示，我們可以寫一個腳本如下:

If close crossover average(close,5)

Then ret=1;

---

## 場景 1088：輸出語法 — 例如我們想知道電腦今天有沒有把最新成交的數據送進來，我們就可以寫出以下的腳本 :

來源：[輸出語法](https://www.xq.com.tw/xstrader/%e8%bc%b8%e5%87%ba%e8%aa%9e%e6%b3%95/) 說明：例如我們想知道電腦今天有沒有把最新成交的數據送進來，我們就可以寫出以下的腳本 :

Print(CurrentDate,Open,High,Low) // 輸出 日期 開盤價 最高價 最低價

---

## 場景 1089：輸出語法 — 這個語法是在raiseruntimeerror這個字的後面加一個小括號，然後把想要輸出的文字用雙引號寫下來， 放在括號裡，當條件符合的時候，電腦會輸出雙引號通知...

來源：[輸出語法](https://www.xq.com.tw/xstrader/%e8%bc%b8%e5%87%ba%e8%aa%9e%e6%b3%95/) 說明：這個語法是在raiseruntimeerror這個字的後面加一個小括號，然後把想要輸出的文字用雙引號寫下來， 放在括號裡，當條件符合的時候，電腦會輸出雙引號通知使用者。例如當我們要寫一個只適用在一分鐘線的腳本時，我們第一行可以像下面這樣寫 :

if barfreq \<\> "Min" or barinterval \<\> 1 then RaiseRunTimeError ("請設定頻率為1分鐘");

---

## 場景 1090：常數 — 這一行的陳述式就變成不只跳空開高，而且最少要開高1%，在這邊，我們的腳本引用了兩個阿拉伯數字，一個是”1”，一個是”100”， 這兩個數字，不管open是多少，...

來源：[常數](https://www.xq.com.tw/xstrader/%e5%b8%b8%e6%95%b8/) 說明：這一行的陳述式就變成不只跳空開高，而且最少要開高1%，在這邊，我們的腳本引用了兩個阿拉伯數字，一個是”1”，一個是”100”， 這兩個數字，不管open是多少，也不管high是多少，1就是1，100就是100，這樣的數字我們稱之為常數 。Djscript讀得懂的常數除了阿拉伯數字之外， 另外就是true 跟false 這兩個邏輯上常被拿來使用的字詞。所以學到這邊，我們可以用回傳值、運算子、符號及常...

(High-low)/(high\[1\]-low\[1\])\>1

---

## 場景 1091：標點符號 — 到這邊已經學會基本的程式交易語法內容了，我們不妨試著寫出幾個腳本例如 以下的這個 :

來源：[標點符號](https://www.xq.com.tw/xstrader/%e6%a8%99%e9%bb%9e%e7%ac%a6%e8%99%9f/) 說明：到這邊已經學會基本的程式交易語法內容了，我們不妨試著寫出幾個腳本例如 以下的這個 :

volume \> volume\[1\] and

volume\[1\] \> volume\[2\] and

close \< close\[1\] and

close\[1\] \< close\[2\] and

close \< open and

close\[1\] \< open\[1\] and

close\[2\] \< open\[2\]

---

## 場景 1092：標點符號 — 這樣的寫法要表達的是 :1. 前日量小於昨日，而昨日小於今日2. 收盤價是今日小於昨日，且昨日小於前日3. 今日收黑，昨日收黑且前日亦收黑再例如以下的這個腳本 ...

來源：[標點符號](https://www.xq.com.tw/xstrader/%e6%a8%99%e9%bb%9e%e7%ac%a6%e8%99%9f/) 說明：這樣的寫法要表達的是 :1. 前日量小於昨日，而昨日小於今日2. 收盤價是今日小於昨日，且昨日小於前日3. 今日收黑，昨日收黑且前日亦收黑再例如以下的這個腳本 :

Close=open and close=high

And (high-low)\>(high\[1\]-low\[1\]\*2

---

## 場景 1093：運算子 — 關係運算子是在呈現兩個數字之間的關係，Xscript中可以拿來運用的關係運算子， 都是大家很熟悉的大於(\>)，等於(=)，小於(\<)，大於等於(\>=)，小於等於...

來源：[運算子](https://www.xq.com.tw/xstrader/%e9%81%8b%e7%ae%97%e5%ad%90/) 說明：關係運算子是在呈現兩個數字之間的關係，Xscript中可以拿來運用的關係運算子， 都是大家很熟悉的大於(\>)，等於(=)，小於(\<)，大於等於(\>=)，小於等於(\<=)，不等於(\<\>)共六種。在這邊要特別說明的是，關係運算式的兩端各都只能是一個代表數值的文字或數值， 所以我們可以寫

close\>close\[1\] and close\[1\]\>close\[2\]

---

## 場景 1094：運算子

來源：[運算子](https://www.xq.com.tw/xstrader/%e9%81%8b%e7%ae%97%e5%ad%90/) 說明：但我們不能寫

close\>close\[1\]\>close\[2\]

---

## 場景 1095：XS語法的基本結構 — 各位可以參考上圖，我們可以用這樣的語法，讓電腦清楚的知道，我們所指的是那一根bar的那一個值。於是，如果要讓電腦找出今天價量齊揚的股票時，我們可以這麼寫 :

來源：[XS語法的基本結構](https://www.xq.com.tw/xstrader/xs%e8%aa%9e%e6%b3%95%e7%9a%84%e5%9f%ba%e6%9c%ac%e7%b5%90%e6%a7%8b/) 說明：各位可以參考上圖，我們可以用這樣的語法，讓電腦清楚的知道，我們所指的是那一根bar的那一個值。於是，如果要讓電腦找出今天價量齊揚的股票時，我們可以這麼寫 :

close\>close\[1\] //今天的收盤價比前一天的收盤價高

And volume\>volume\[1\] //今天的成交量比前一天的成交量大

---

## 場景 1096：XS語法的基本結構 — 又例如，如果要讓電腦找到今天漲幅超過五%且成交量比前一天多超過一千張的股票，那我們可以這麼寫 :

來源：[XS語法的基本結構](https://www.xq.com.tw/xstrader/xs%e8%aa%9e%e6%b3%95%e7%9a%84%e5%9f%ba%e6%9c%ac%e7%b5%90%e6%a7%8b/) 說明：又例如，如果要讓電腦找到今天漲幅超過五%且成交量比前一天多超過一千張的股票，那我們可以這麼寫 :

close\>close\[1\]\*1.05

And volume-volume\[1\]\>1000

---

## 場景 1097：XS語法的基本結構 — 例如 : 我們在尋找紅三兵股票時，必須遵循三個原則 :1. 最近三天都上漲2. 三天的K線實體部份都要是紅色的，也就是說三天的收盤價都高於開盤價3. 實體紅棒的...

來源：[XS語法的基本結構](https://www.xq.com.tw/xstrader/xs%e8%aa%9e%e6%b3%95%e7%9a%84%e5%9f%ba%e6%9c%ac%e7%b5%90%e6%a7%8b/) 說明：例如 : 我們在尋找紅三兵股票時，必須遵循三個原則 :1. 最近三天都上漲2. 三天的K線實體部份都要是紅色的，也就是說三天的收盤價都高於開盤價3. 實體紅棒的部份一天比一天長那麼要讓電腦知道我們要找的是紅三兵的股票時，我們可以列出三個敘述

close\[2\] \> close\[3\] and close\[1\] \> close\[2\] and close \> close\[1\]

close\[2\] \> open\[2\] and close\[1\] \> open\[1\] and close \> open

close\[2\]-open\[2\] \< close\[1\]-open\[1\] and close\[1\]-open\[1\] \< close-open

---

## 場景 1098：XS語法的基本結構 — 又例如 : 我們如果要寫一紅包三黑，我們必須遵循以下幾個規則1. 前三根K棒都是黑色的2. 最後一根是長紅棒3. 最後一根的收盤價比前三根的高點還高我們可以把上...

來源：[XS語法的基本結構](https://www.xq.com.tw/xstrader/xs%e8%aa%9e%e6%b3%95%e7%9a%84%e5%9f%ba%e6%9c%ac%e7%b5%90%e6%a7%8b/) 說明：又例如 : 我們如果要寫一紅包三黑，我們必須遵循以下幾個規則1. 前三根K棒都是黑色的2. 最後一根是長紅棒3. 最後一根的收盤價比前三根的高點還高我們可以把上面的這些規則改寫成以下電腦看得懂的敘述

close\[3\]\< open\[3\] and close\[2\]\< open\[2\] and close\[1\]\< open\[1\]

close\>open

close\> high\[3\]

---

## 場景 1099：XS語法的基本結構 — 透過這樣的語法約定，我們可以把每一根K線上的每一個開高低收成交量的值都拿來用，如果我們要表達價漲量增，我們可以寫

來源：[XS語法的基本結構](https://www.xq.com.tw/xstrader/xs%e8%aa%9e%e6%b3%95%e7%9a%84%e5%9f%ba%e6%9c%ac%e7%b5%90%e6%a7%8b/) 說明：透過這樣的語法約定，我們可以把每一根K線上的每一個開高低收成交量的值都拿來用，如果我們要表達價漲量增，我們可以寫

close\>close\[1\] and volume\>volume\[1\]

---

## 場景 1100：多空六大階段指標 — 於是我寫了一個指標的腳本

來源：[多空六大階段指標](https://www.xq.com.tw/xstrader/%e5%a4%9a%e7%a9%ba%e5%85%ad%e5%a4%a7%e9%9a%8e%e6%ae%b5%e6%8c%87%e6%a8%99/) 說明：於是我寫了一個指標的腳本

var:m50(0),m200(0);

m50=average(close,50);

m200=average(close,200);

if close \> m50 and c\< m200 and m50\<m200

then value1=10

else value1=0;

if close \> m50 and c\> m200 and m50\<m200

then value2=20

else value2=0;

if close \> m50 and c\> m200 and m50 \> m200

then value3=30

else value3=0;

if close \< m50 and c\>m200 and m50\>m200

then value4=-10

else value4=0;

if close \< m50 and cm200

then value5=-20

else value5=0;

if close \< m50 and c then value6=-30

else value6=0;

plot1(value1,"復甦期");

plot2(value2,"收集期");

plot3(value3,"多頭");

plot4(value4,"警示期");

plot5(value5,"發散期");

plot6(value6,"空頭");

---

## 場景 1101：每個月賺八萬元的交易策略怎麼寫? — 我根據了他上述的選股及進場條件，試著寫了一個XS的選股腳本如下:

來源：[每個月賺八萬元的交易策略怎麼寫?](https://www.xq.com.tw/xstrader/%e6%af%8f%e5%80%8b%e6%9c%88%e8%b3%ba%e5%85%ab%e8%90%ac%e5%85%83%e7%9a%84%e4%ba%a4%e6%98%93%e7%ad%96%e7%95%a5%e6%80%8e%e9%ba%bc%e5%af%ab/) 說明：我根據了他上述的選股及進場條件，試著寫了一個XS的選股腳本如下:

value1=GetField("營業利益","Q");//單位百萬

value2=GetField("稅前淨利","Q");//單位百萬

value3=GetField("來自營運之現金流量","Q");//單位百萬

value4=GetField("資本支出金額","Q");//單位百萬

value5=GetField("利息支出","Q");//單位百萬

value6=GetField("所得稅費用","Q");//單位百萬

condition1=false;

condition2=false;

condition3=false;

if value2\>0

then begin

if value1/value2\*100\>80

then condition1=true; //本業獲利佔八成以上

end;

if value3-value4-value5-value6\>0 //自由現金流量大於零

then condition2=true;

value7=GetField("利息保障倍數","Y");

value8=GetField("股東權益報酬率","Y");//單位%

value9=GetField("營業利益率","Q");//單位%

value10=GetField("本益比","D");

value11=GetField("殖利率","D");

value12=GetField("每股淨值(元)","Q");

value13=value12\*value8/8;//獲利能力比率

if value7\>20 and value8\>8 and value9\>0 and value10\<12

and value11\>6 and close\<value13

then condition3=true;

if condition1 and condition2 and condition3

then ret=1;

---

## 場景 1102：合理的本益比跟盈餘品質與成長力有關 — “為啥這兩檔股票EPS一模一樣，但股價差這麼多?”經常被問到這樣的問題。扣掉那些人為炒作的因素，我的經驗是盈餘愈穩定的，以及盈餘成長能見度愈高的，可以享有的合理...

來源：[合理的本益比跟盈餘品質與成長力有關](https://www.xq.com.tw/xstrader/%e5%90%88%e7%90%86%e7%9a%84%e6%9c%ac%e7%9b%8a%e6%af%94%e8%b7%9f%e7%9b%88%e9%a4%98%e5%93%81%e8%b3%aa%e8%88%87%e6%88%90%e9%95%b7%e5%8a%9b%e6%9c%89%e9%97%9c-2/) 說明：“為啥這兩檔股票EPS一模一樣，但股價差這麼多?”經常被問到這樣的問題。扣掉那些人為炒作的因素，我的經驗是盈餘愈穩定的，以及盈餘成長能見度愈高的，可以享有的合理本益比就愈高。相反的，那些今年大賺，明年大虧的公司，以及那些數年來盈餘數字都未見成長的公司，市場給的本益比就比較低。現在有了XS，我們可以用敘述式來呈現這兩個概念，例如我們如果要找那些盈餘品質不錯，過去五年營業利益成長率都沒有衰退超過5%的...

value1=GetField("營業利益成長率","Y");

if trueall(value1\>-0.05,5) then ret=1;

---

## 場景 1103：合理的本益比跟盈餘品質與成長力有關 — 如果我們要找連續五年營收都比前一年成長的公司我們可以這麼寫

來源：[合理的本益比跟盈餘品質與成長力有關](https://www.xq.com.tw/xstrader/%e5%90%88%e7%90%86%e7%9a%84%e6%9c%ac%e7%9b%8a%e6%af%94%e8%b7%9f%e7%9b%88%e9%a4%98%e5%93%81%e8%b3%aa%e8%88%87%e6%88%90%e9%95%b7%e5%8a%9b%e6%9c%89%e9%97%9c-2/) 說明：如果我們要找連續五年營收都比前一年成長的公司我們可以這麼寫

value2=GetField("營收成長率","Y");

if trueall(value2\>0,5)

then ret=1;

---

## 場景 1104：策略型交易結構‬ — 在操作一個策略的時候,有個關鍵的進場點和出場點,可是即時選股沒有\!今天使用者可能看到一檔股票從即時選股裡面跳出來說創20日新高了\! 點進去技術分析一看\! 已經是...

來源：[策略型交易結構‬](https://www.xq.com.tw/xstrader/%e7%ad%96%e7%95%a5%e5%9e%8b%e4%ba%a4%e6%98%93%e7%b5%90%e6%a7%8b%e2%80%ac/) 說明：在操作一個策略的時候,有個關鍵的進場點和出場點,可是即時選股沒有\!今天使用者可能看到一檔股票從即時選股裡面跳出來說創20日新高了\! 點進去技術分析一看\! 已經是第5天創20日新高\!\! 最近一個星期每天都在創新高\! 這樣的股票,投資人是否敢進場實在是一個大問號? 如果不是一個進場的良好依據,那這樣的即時選股對策略化交易而言會存在多少意義呢?策略化的交易結構沒有這個問題\! 怎麼說呢? 因為在系統設計的...

var:SPosition(0);

if SPosition \= 0 then {當策略沒部位的時候做的事A}

begin{A}

if Close \> Highest(High\[1\],20) then {股價創20日新高}

begin

SPosition \= 1; {策略部位變成多單}

retmsg \="多單進場"; {設定策略的進場訊息}

ret \=1; {策略觸發}

end;

end{A}

else

if SPosition \=1 then {當策略為多單部位的時候做的事B}

begin{B}

if Close \< Lowest(Low\[1\],10) then {股價創10日新低}

begin

SPosition \= 0; {策略部位由多單變為空手}

retmsg \="多單出場"; {設定策略的進場訊息}

ret \=1; {策略觸發}

end;

end{B};

---

## 場景 1105：選股結果之OutputFiled語法應用 — 選股功能中包含了一樣非常好用工具,叫做OutputFiled\!我們只要把計算出來的結果,用這個函數去印出來,然後排序,就可以看到市場上這個值的分布情況\!除了把我...

來源：[選股結果之OutputFiled語法應用](https://www.xq.com.tw/xstrader/%e9%81%b8%e8%82%a1%e7%b5%90%e6%9e%9c%e4%b9%8boutputfiled%e8%aa%9e%e6%b3%95%e6%87%89%e7%94%a8/) 說明：選股功能中包含了一樣非常好用工具,叫做OutputFiled\!我們只要把計算出來的結果,用這個函數去印出來,然後排序,就可以看到市場上這個值的分布情況\!除了把我們預像的值設成一個門檻,讓有符合的股票挑出來以外,這樣的表列方法,不僅可以知道市場上的股票多空位置,也可以很快速掌握到大盤動向\!

var:i(0),HDay(0);

for i \= 1 to 255

begin

if C\> H\[i\] then HDay+=1;

end;

setoutputname1("HighDay");

outputfield1(Hday);

ret=1;

---

## 場景 1106：第一時間抓住反轉契機 — 利用警示腳本我們可以把買進和停損訊號寫在一起\!

來源：[第一時間抓住反轉契機](https://www.xq.com.tw/xstrader/%e7%ac%ac%e4%b8%80%e6%99%82%e9%96%93%e6%8a%93%e4%bd%8f%e5%8f%8d%e8%bd%89%e5%a5%91%e6%a9%9f/) 說明：利用警示腳本我們可以把買進和停損訊號寫在一起\!

input:Length(20); setinputname(1,"下降趨勢計算期數");

input:Rate(150); setinputname(2,"反轉率%");

variable: Factor(0),xStopLossPoint(0);

if currentbar= 1 then Factor \= 100/Close; {先標準化股價}

if close \> open and close \< close\[length\] then

begin

value1 \= linearregslope(high\*Factor,Length);

value2 \= linearregslope(high\*Factor,3);

if value1 \< 0 and value2-value1 \> Rate\*0.01 then begin

retmsg="搶反彈進場點"; {加上策略觸發時提示的訊息}

ret=1;

xStopLossPoint \= Lowest(L,Length); {記下當時的V底低點}

end;

end;

if C \< xStopLossPoint and C\[1\] \> xStopLossPoint then

begin

retmsg="搶反彈最後停損點跌破"; {加上策略觸發時提示的訊息:這裡是多單賣出的提示\!}

ret=1;

end;

---

## 場景 1107：糾結均線突破 — 當股價收斂到一個程度,所有的均線都會相當靠近並且落在一個小範圍內\!這就是均線糾結: 換句話說,可以是多空不明的收斂狀態\! 當股價只要有一些事件引起的風吹草動\! ...

來源：[糾結均線突破](https://www.xq.com.tw/xstrader/%e7%b3%be%e7%b5%90%e5%9d%87%e7%b7%9a%e7%aa%81%e7%a0%b4-2/) 說明：當股價收斂到一個程度,所有的均線都會相當靠近並且落在一個小範圍內\!這就是均線糾結: 換句話說,可以是多空不明的收斂狀態\! 當股價只要有一些事件引起的風吹草動\! 股價就會立即表態,往阻力最小的那邊跑去\!\!這個現象可以被應用在多方, 也可以被應用在空方. 一但股價發生均線糾結的時候,就主動監控\! 當股價往上發動穿越時,立刻以多方訊號通知\!\!在警示腳本裡 我們需要算出短中長期的均線價格,依照慣用的原則,...

input: shortlength(5); setinputname(1,"短期均線期數");

input: midlength(10); setinputname(2,"中期均線期數");

input: Longlength(20); setinputname(3,"長期均線期數");

input: Percent(2); setinputname(4,"均線糾結區間%");

input: Volpercent(25); setinputname(5,"放量幅度%");//帶量突破的量是超過最長期的均量多少%

variable: shortaverage(0);

variable: midaverage(0);

variable: Longaverage(0);

variable:Kprice(0);

if volume \> average(volume,Longlength) \* (1 \+ volpercent \* 0.01) then

begin

shortaverage \= average(close,shortlength);

midaverage \= average(close,midlength);

Longaverage \= average(close,Longlength);

if Close crosses over maxlist(shortaverage,midaverage,Longaverage) then

begin

value1= absvalue(shortaverage \-midaverage);

value2= absvalue(midaverage \-Longaverage);

value3= absvalue(Longaverage \-shortaverage);

if maxlist(value1,value2,value3)\*100 \< Percent\*Close then Kprice=H;

end;

end;

ret= C crosses above Kprice;

---

## 場景 1108：大漲後的天量收黑 — 警示腳本的寫法如下,資料讀取設250,表示是一年來最大量,設成750就會去抓3年來的最大量,最大引用1即可\!

來源：[大漲後的天量收黑](https://www.xq.com.tw/xstrader/%e5%a4%a7%e6%bc%b2%e5%be%8c%e7%9a%84%e5%a4%a9%e9%87%8f%e6%94%b6%e9%bb%91/) 說明：警示腳本的寫法如下,資料讀取設250,表示是一年來最大量,設成750就會去抓3年來的最大量,最大引用1即可\!

variable:Maxv(0); MaxV= maxlist(Maxv,V);

variable:MaxH(0); MaxH= maxlist(MaxH,H);

variable:Kprice(0);

if Maxv \= V and MaxH \= H then Kprice \= L;

ret= C crosses below KPrice ;

---

## 場景 1109：價量背離很難救\! — 在XS裡寫起來不用太複雜

來源：[價量背離很難救\!](https://www.xq.com.tw/xstrader/%e5%83%b9%e9%87%8f%e8%83%8c%e9%9b%a2%e5%be%88%e9%9b%a3%e6%95%91/) 說明：在XS裡寫起來不用太複雜

variable:count(0),KPrice(0),hDate(0); //設變數

count \= CountIf(close \> close\[1\] and volume \< volume\[1\], 5);

//計算5期內價量背離的次數

if count \> 3 then begin //如果發升三次以上

hDate=Date; //記錄日期

Kprice \= lowest(l,length);//記錄關鍵價格

end;

ret= Close crosses below Kprice and DateDiff(Date,hdate) \< 5 ;

//最後如果在價量背離發生的5天內價格跌破關鍵價時,發出訊號

---

## 場景 1110：從開盤看關鍵轉折點 — 每檔股票所統計的張數會因為股價和熱絡度不同會有很大的差異,但當我們把兩個數值相除後就可以標準化這事了\!\!

來源：[從開盤看關鍵轉折點](https://www.xq.com.tw/xstrader/%e5%be%9e%e9%96%8b%e7%9b%a4%e7%9c%8b%e9%97%9c%e9%8d%b5%e8%bd%89%e6%8a%98%e9%bb%9e/) 說明：每檔股票所統計的張數會因為股價和熱絡度不同會有很大的差異,但當我們把兩個數值相除後就可以標準化這事了\!\!

variable:IORatio(0),z(1);

IORatio=GetField("開盤委買")\[z\]/GetField("開盤委賣")\[z\]-1;

variable:iHigh(0),iLow(10000);

if IORatio \> 0.5 and GetField("開盤委買")\[z\] \= highest(GetField("開盤委買")\[z\],20) then

begin

iHigh \= H;

end

else if IORatio \< \-0.5 and GetField("開盤委賣")\[z\] \= highest(GetField("開盤委賣")\[z\],20) then

begin

iLow \= L;

end;

if LS\>0 and H \> iHigh and C\[1\] if LSiLow then ret=1;

---

## 場景 1111：合併多重訊號到單一警示retmsg的應用 — 我們把多空合併後,腳本可以這樣寫 {資料讀取400 最大引用10,適用1MIN}

來源：[合併多重訊號到單一警示retmsg的應用](https://www.xq.com.tw/xstrader/%e5%90%88%e4%bd%b5%e5%a4%9a%e9%87%8d%e8%a8%8a%e8%99%9f%e5%88%b0%e5%96%ae%e4%b8%80%e8%ad%a6%e7%a4%baretmsg%e7%9a%84%e6%87%89%e7%94%a8/) 說明：我們把多空合併後,腳本可以這樣寫 {資料讀取400 最大引用10,適用1MIN}

variable:Xhigh(0),XLow(100000);

if Date xHigh \=maxlist(H,xHigh);

xLow \= minlist(L,XLow);

end;

if V \> TimeDiff(currenttime,time,"S")\*25 then begin

if L \< XLow then begin retmsg \="破昨低觸空"; ret=1; end;

if H \< xHigh then begin retmsg \="過昨高觸多"; ret=1; end;

end;

---

## 場景 1112：Larry Williams 短線交易秘訣 — Larry Williams的著名著作”短線交易密訣”中提到一個非常重要的概念:當收盤上漲時,價格若處於強勢波動率收斂,當股價再創短其新高時,就是非常理想的進場...

來源：[Larry Williams 短線交易秘訣](https://www.xq.com.tw/xstrader/larry-williams-%e7%9f%ad%e7%b7%9a%e4%ba%a4%e6%98%93%e7%a7%98%e8%a8%a3/) 說明：Larry Williams的著名著作”短線交易密訣”中提到一個非常重要的概念:當收盤上漲時,價格若處於強勢波動率收斂,當股價再創短其新高時,就是非常理想的進場點, 反之則為空點\!這樣的概念可能有點抽象,讓我們來情境試想:有一檔股票正在漲,昨天的波動率假設是2,今天又上漲了,而且今天收盤價和最低價的距離只有不到1,這表示往下去的力道已經收斂掉了,當這樣的情況出現,如果股價突然衝過這兩天的高點,那就...

vars: \_MarketPosition(0);

Condition1 \= Close \> Close\[1\] and (Close-Low) \<= 0.5\*(High\[1\]-Low\[1\]);

Condition2 \= Close \< Close\[1\] and (High-Close) \<= 0.5\*(High\[1\]-Low\[1\]);

{整個策略非常單純,上面兩行僅判斷波動率,下面則是部位判斷與停損點的設定}

if \_MarketPosition \< 1 then begin if condition1\[1\] and C \> maxlist(H\[1\],H\[2\]) then

begin

plot4(C\*1.01 ,"作多");

plot5(C\*1.02);plot6(C\*1.03);plot7(C\*1.04);

plot8(C\*1.05);plot9(C\*1.06);plot10(C\*1.07);

\_MarketPosition=1;

value1 \=minlist(L\[1\],L\[2\]);

end;

if C cross over value2 and \_MarketPosition=-1 then

begin

plot4(C\*1.01 ,"回補");

\_MarketPosition=0;

end;

end

else if \_MarketPosition \>-1 then

begin

if condition2\[1\] and C \< minlist(L\[1\],L\[2\]) then

begin

plot11(C\*0.99 ,"作空");

plot12(C\*0.98);plot13(C\*0.97);plot14(C\*0.96);

plot15(C\*0.95);plot16(C\*0.94);plot17(C\*0.93);

\_MarketPosition=-1;

value2 \= maxlist(H\[1\],H\[2\]) ;

end;

if C cross under value1 and \_MarketPosition=1 then

begin

plot3(C\*1.01 ,"出場");

\_MarketPosition=0;

end;

end;

---

## 場景 1113：Larry Williams 短線交易秘訣 — 可以從圖裡面看得到這個點容易成為決勝點\!\!改成警示的話腳本會變成下面,跑出來的結果各位可以參考對照是不是有這樣的現象\!\!

來源：[Larry Williams 短線交易秘訣](https://www.xq.com.tw/xstrader/larry-williams-%e7%9f%ad%e7%b7%9a%e4%ba%a4%e6%98%93%e7%a7%98%e8%a8%a3/) 說明：可以從圖裡面看得到這個點容易成為決勝點\!\!改成警示的話腳本會變成下面,跑出來的結果各位可以參考對照是不是有這樣的現象\!\!

vars: \_MarketPosition(0);

Condition1 \= Close \> Close\[1\] and (Close-Low) \<= 0.5\*(High\[1\]-Low\[1\]);

Condition2 \= Close \< Close\[1\] and (High-Close) \<= 0.5\*(High\[1\]-Low\[1\]);

if \_MarketPosition \< 1 then

begin

if condition1\[1\] and C \> maxlist(H\[1\],H\[2\]) then

begin

ret=1;

value1 \=minlist(L\[1\],L\[2\]);

end;

if C cross over value2 and \_MarketPosition=-1 then

begin

\_MarketPosition=0;

end;

end

else if \_MarketPosition \>-1 then

begin

if condition2\[1\] and C \< minlist(L\[1\],L\[2\]) then

begin

\_MarketPosition=-1;

value2 \= maxlist(H\[1\],H\[2\]) ;

end;

if C cross under value1 and \_MarketPosition=1 then

begin

\_MarketPosition=0;

end;

end;

---

## 場景 1114：先進指標Zero Lag HeikinAshi

來源：[先進指標Zero Lag HeikinAshi](https://www.xq.com.tw/xstrader/%e5%85%88%e9%80%b2%e6%8c%87%e6%a8%99zero-lag-heikinashi/) 說明：我們看一下腳本:

input: Length(14);

variable: price(0), haO(0), haC(0), haMax(0), haMin(0), TEMA1(0), TEMA2(0), EMA(0), ZeroLagHA(0);

price \= (close+open+high+low)/4;

haO \= (haO\[1\]+price)/2;

haMax \= maxlist(high, haO);

hamin \= minlist(low, haO);

haC \= (price+haO+haMax+haMin)/4;

EMA \= xaverage(haC, Length);

TEMA1 \= 3\*EMA-3\*xaverage(EMA, Length)+xaverage(xaverage(EMA, Length), Length);

EMA \= xaverage(TEMA1, Length);

TEMA2 \= 3\*EMA-3\*xaverage(EMA, Length)+xaverage(xaverage(EMA, Length), Length);

ZeroLagHA \= 2\*TEMA1-TEMA2;

plot1(ZeroLagHA, "Zero Lag HeikinAshi");

plot2(average(C,20),"Average");

---

## 場景 1115：Mass index — 當然這兩條線對於每檔股票可能值不儘相同,我們可以用常見的值先設定,再看股性調整\!

來源：[Mass index](https://www.xq.com.tw/xstrader/mass-index/) 說明：當然這兩條線對於每檔股票可能值不儘相同,我們可以用常見的值先設定,再看股性調整\!

inputs: SLength( 9 ), SigmaLen( 25 ), vThreshold( 27 ),InverseThre( 26.5 ) ;

variables: MI1(0),MI2(0),MIR(0),MIV(0);

MI1 \= XAverage( Range, SLength ) ;

MI2 \= XAverage( MI1, SLength ) ;

if MI2 \> 0 then MIR \=MI1/MI2 else MIR=0;

if SigmaLen \> CurrentBar then MIV \+= MIR else MIV \= MIV \+ MIR \-MIR\[SigmaLen\];

Plot1( MIV, "Mass Index" ) ;

Plot2( vThreshold, "擴張警戒" ) ;

Plot3( InverseThre, "盤整反轉" ) ;

---

## 場景 1116：主力法人成本價格的判斷 — XS裡提供了每日成交金額的資料,只要使用

來源：[主力法人成本價格的判斷](https://www.xq.com.tw/xstrader/%e4%b8%bb%e5%8a%9b%e6%b3%95%e4%ba%ba%e6%88%90%e6%9c%ac%e5%83%b9%e6%a0%bc%e7%9a%84%e5%88%a4%e6%96%b7/) 說明：XS裡提供了每日成交金額的資料,只要使用

var:DayAvgPrice(0);DayAvgPrice \= GetField("成交金額")/v/1000;

---

## 場景 1117：典型反轉訊號 — 當指數或股價處在高檔時,跑得快是一個很重要的反射機制,跑得對則是一種藝術\!我們今天把市場上常用的底部V型反轉拉高,看看高檔倒V型反轉要怎麼做?\!如果要成為倒V,...

來源：[典型反轉訊號](https://www.xq.com.tw/xstrader/%e5%85%b8%e5%9e%8b%e5%8f%8d%e8%bd%89%e8%a8%8a%e8%99%9f/) 說明：當指數或股價處在高檔時,跑得快是一個很重要的反射機制,跑得對則是一種藝術\!我們今天把市場上常用的底部V型反轉拉高,看看高檔倒V型反轉要怎麼做?\!如果要成為倒V, 那中間那天的高點勢必要高於左右兩邊,再來就是強度要夠的話,中間那天的高點,至少要比左右低點大上一定幅度,這邊就設定為5%腳本可以這樣表達

condition1= H\[1\] \> H\[2\] and H\[1\] \> H and H\[1\] \> L\[2\]\*1.05 and H\[1\] \> L\*1.05;

//當這樣的情況發生的時候,我們把左右兩邊的最低價平均一下,當做是一個關鍵價

if condition1 then value1 \= (L+L\[2\])/2;

//當股價跌破這個價格的時候,就是反轉的訊號\! 這是標準型策略的作法\!

{警示} if Close cross under value1 then ret=1;

---

## 場景 1118：典型反轉訊號 — 這樣我們就完成一個型態辨識型的策略了\!如果要畫在圖上就可以改成:

來源：[典型反轉訊號](https://www.xq.com.tw/xstrader/%e5%85%b8%e5%9e%8b%e5%8f%8d%e8%bd%89%e8%a8%8a%e8%99%9f/) 說明：這樣我們就完成一個型態辨識型的策略了\!如果要畫在圖上就可以改成:

{指標} plot1(Value1,"高檔反轉線");

---

## 場景 1119：突破投信成本線 — 那我們這些小散戶怎麼從中獲利呢? 當然要從最簡單的方法下手,之前有提到過策略的標準作法: 找到一個關鍵價, 等市價突破這個價的時候,買進\!\! 就這樣,我們要先找...

來源：[突破投信成本線](https://www.xq.com.tw/xstrader/976/) 說明：那我們這些小散戶怎麼從中獲利呢? 當然要從最簡單的方法下手,之前有提到過策略的標準作法: 找到一個關鍵價, 等市價突破這個價的時候,買進\!\! 就這樣,我們要先找到投信的短期進場成本價當關鍵價,盤中有突破就來通知一下,我們就可以很開心的搭順風車了\!\!

input: pastDays(3); setinputname(1,"計算天數");

input: \_BuyRatio(10); setinputname(2,"買超佔比例(%)");

variable: SumAm(0),SumForce(0), SumTotalVolume(0),APrice(0),AVGP(0),Kprice(0),QDate(0);

APrice \= GetField("成交金額")\[1\] / V\[1\]/1000;

SumAm \= Summation(GetField("投信買賣超")\[1\]\*APrice, pastDays);

SumForce \= Summation(GetField("投信買賣超")\[1\], pastDays);

sumTotalVolume \= Summation(Volume\[1\], pastDays);

if SumAm \> 30000 and SumForce \> SumTotalVolume \* \_BuyRatio/100 then

begin

Kprice \=highest(avgprice,pastDays);

QDate=Date;

end;

if DateDiff(Date,QDate) \< pastDays+5 and C \> Kprice and C\[1\] \< Kprice then ret=1;

---

## 場景 1120：凱特納通道 — 腳本如下: 請記得把plot3設到第2座標軸,而plot1,plot2設為點

來源：[凱特納通道](https://www.xq.com.tw/xstrader/%e5%88%a9%e7%94%a8%e5%87%b1%e7%89%b9%e7%b4%8d%e9%80%9a%e9%81%93%e5%92%8c%e6%88%90%e4%ba%a4%e9%87%8f%e8%bf%bd%e8%b9%a4%e4%ba%a4%e6%98%93%e8%b6%a8%e5%8b%a2%e7%9a%84%e7%a9%a9%e5%ae%9a%e6%80%a7/) 說明：腳本如下: 請記得把plot3設到第2座標軸,而plot1,plot2設為點

var:Periods(13);

var:Price(0); Price \= (C+H+l)/3;

var:Center(0);Center \= average(Price,Periods);

var:KTop(0); Ktop \= Center \+ average(H-L,Periods);

var:KBot(0); KBot \= Center \- average(H-L,Periods);

variable: Length(10),pdi(0), ndi(0), adx\_value(0);

DirectionMovement(Length, pdi, ndi, adx\_value);

if adx\_value \> adx\_value\[1\] and C \> average(C,8) then plot1(C,"ADX Rising");

if adx\_value \> adx\_value\[1\] and C \< average(C,8) then plot2(C,"ADX Falling");

var:VolumeOsc(0);

VolumeOsc \= (average(v,1)-average(V,20))/average(V,20);

plot3(VolumeOsc,"VolumeOsc");

plot4(Center,"Center");

plot5(KTop,"KTop");

plot6(KBot,"KBot");

---

## 場景 1121：尋找具有領先預測性的交易策略 — 運用這樣的概念，我寫了一個指標，這指標在計算十天之內有多少天成交值佔大盤比重在增加且比大盤強，然後取五日平均我發現當這數字從一以下向上而股價還在橫向整理時，後市...

來源：[尋找具有領先預測性的交易策略](https://www.xq.com.tw/xstrader/%e5%be%9e%e7%9b%b8%e5%b0%8d%e7%9a%84%e8%a7%92%e5%ba%a6%e5%b0%8b%e6%89%be%e7%9c%9f%e6%ad%a3%e5%83%b9%e9%87%8f%e9%bd%8a%e6%8f%9a%e7%9a%84%e8%82%a1%e7%a5%a8-3/) 說明：運用這樣的概念，我寫了一個指標，這指標在計算十天之內有多少天成交值佔大盤比重在增加且比大盤強，然後取五日平均我發現當這數字從一以下向上而股價還在橫向整理時，後市出現長紅的機率頗高(如附圖一)這個指標的腳本如下:

input:sp(10);

setinputname(1,"短計算區間");

value1=GetField("資金流向");

value2=GetField("強弱指標");

var:count1(0) ;

count1=countif(value2\>0and value1\>value1\[1\],sp);

value3=average(count1,5);

plot1(value3,"短期價量齊揚天數");

---

## 場景 1122：尋找具有領先預測性的交易策略 — 這樣的概念，我們可以改寫成策略雷達的腳本

來源：[尋找具有領先預測性的交易策略](https://www.xq.com.tw/xstrader/%e5%be%9e%e7%9b%b8%e5%b0%8d%e7%9a%84%e8%a7%92%e5%ba%a6%e5%b0%8b%e6%89%be%e7%9c%9f%e6%ad%a3%e5%83%b9%e9%87%8f%e9%bd%8a%e6%8f%9a%e7%9a%84%e8%82%a1%e7%a5%a8-3/) 說明：這樣的概念，我們可以改寫成策略雷達的腳本

input:sp(10);

setinputname(1,"短計算區間");

value1=GetField("資金流向");

value2=GetField("強弱指標");

var:count1(0) ;

count1=countif(value2\>0and value1\>value1\[1\],sp);

value3=average(count1/SP\*100,5);

if (highest(close,5)-lowest(close,5))\<close\*1.07

and value3 cross over 35

then ret=1;

---

## 場景 1123：主動買力指標 — 這個指標的腳本很單純，我附在下面

來源：[主動買力指標](https://www.xq.com.tw/xstrader/961/) 說明：這個指標的腳本很單純，我附在下面

input:PS(5);

setinputname(1,"計算區間");

value1=GetField("主動買力");

value2=GetField("主動性交易比重");

if value2 \<\> 0

then value3=value1/value2;

value4=average(value3,ps);

plot1(value4,"主動買力比重短期移動平均");

---

## 場景 1124：主動買力指標 — 我們可以把這個腳本改成警示策略只要加個警示的條件例如

來源：[主動買力指標](https://www.xq.com.tw/xstrader/961/) 說明：我們可以把這個腳本改成警示策略只要加個警示的條件例如

if value4 crossover 50

and volume\>3000

and volume\>average(volume,5)

then ret=1;

---

## 場景 1125：波動率通道 — 有許多方法會被用來衡量波動率,常見的像是ATR(平均真實區間),如果波動率高,ATR就會變大。今天我們使用的觀念則是用典型價,即最高價,最低價,收盤價這三個價位...

來源：[波動率通道](https://www.xq.com.tw/xstrader/%e6%b3%a2%e5%8b%95%e7%8e%87%e9%80%9a%e9%81%93/) 說明：有許多方法會被用來衡量波動率,常見的像是ATR(平均真實區間),如果波動率高,ATR就會變大。今天我們使用的觀念則是用典型價,即最高價,最低價,收盤價這三個價位的平均,拿來和最低點比較,如果典型價上漲,就用今天典型價減去昨低,反之則用昨天典型價減今低。使用這個差值,來繪製一個波動率通道,然後用這個通到的上下緣來當做買賣訊號。

variable: avg(8),vperiod(13),devfact(3.55),LbandAdj(0.9);

variable:DevHigh(0),DevLow(0);

variable:aTypical(0),dev(0),medianavg(0),typ(0),XMA(0);

if currentbar\>=2 then begin{必需要2根K 才能開始}

typ \= typicalprice;

{典型價}

aTypical \= iff(typ \>typ\[1\],typ-Low\[1\],typ\[1\]-Low);

{IFF 第1個是判斷式,如果成立了,用第1個算式的結果,不然就用第2個算式的結果}

dev \= devfact\*average(atypical,vperiod);

{計算平均值的3.55倍做為通道基值}

DevHigh \=Xaverage(dev,avg);

DevLow \=DevHigh \*LbandAdj;

{計算通道上緣與下緣的邊界}

medianavg \= Xaverage(typ,avg);

XMA \= Xaverage(medianavg,avg);

{用指數平均兩次平滑典型價}

plot1(XMA+DevHigh,"多方線");

plot2(XMA-DevLow,"空方線");

plot3(XMA,"中線");

{畫出通道圖}

end;

{如果需要在圖上標記買賣訊號,可以加下列}

if C cross over XMA \+ DevHigh then

begin {以下繪點}

plot4(C\*1.01,"多");plot5(C\*1.02,"多");plot6(C\*1.03,"多");

plot7(C\*1.04,"多");plot8(C\*1.05,"多");plot9(C\*1.06,"多");

plot10(C\*1.07,"多");

end;

if C cross under XMA \-DevLow then

begin {以下繪點}

plot11(C\*0.99,"空");plot12(C\*0.98,"空");plot13(C\*0.97,"空");

plot14(C\*0.96,"空");plot15(C\*0.95,"空");plot16(C\*0.94,"空");

plot17(C\*0.93,"空");

end;

---

## 場景 1126：波動率通道 — 各位可以試看看,如果要做成即時的警示,可以用下面的版本

來源：[波動率通道](https://www.xq.com.tw/xstrader/%e6%b3%a2%e5%8b%95%e7%8e%87%e9%80%9a%e9%81%93/) 說明：各位可以試看看,如果要做成即時的警示,可以用下面的版本

variable: avg(8),vperiod(13),devfact(3.55),LbandAdj(0.9);

variable:DevHigh(0),DevLow(0);

variable:aTypical(0),dev(0),medianavg(0),typ(0),XMA(0);

if currentbar typ \= typicalprice();

aTypical \= iff(typ \>typ\[1\],typ-Low\[1\],typ\[1\]-Low);

dev \= devfact\*average(atypical,vperiod);

DevHigh \=Xaverage(dev,avg);

DevLow \=DevHigh \*LbandAdj;

medianavg \= Xaverage(typ,avg);

XMA \= Xaverage(medianavg,avg);

if C cross over XMA \+ DevHigh then ret=1; {多方}

---

## 場景 1127：唐奇安通道 — 可以用以下的腳本畫出指標圖:

來源：[唐奇安通道](https://www.xq.com.tw/xstrader/%e5%94%90%e5%a5%87%e5%ae%89%e9%80%9a%e9%81%93/) 說明：可以用以下的腳本畫出指標圖:

input:Period(13);

plot1(Highest(H\[1\], period),"通道上緣");

plot2(Lowest(L\[1\], period),"通道下緣" );

plot3((Highest(H, period)+Lowest(L, period))/2,"通道中線");

---

## 場景 1128：唐奇安通道

來源：[唐奇安通道](https://www.xq.com.tw/xstrader/%e5%94%90%e5%a5%87%e5%ae%89%e9%80%9a%e9%81%93/) 說明：警示則可以寫成

input:Period(13);

if H \= Highest(H, period) then ret \=1;{作多}

if L \= Lowest(L,period) then ret=1;{作空}

---

## 場景 1129：唐奇安通道 — 我們先看一下加上買賣點指標畫在圖上的情況,腳本加上

來源：[唐奇安通道](https://www.xq.com.tw/xstrader/%e5%94%90%e5%a5%87%e5%ae%89%e9%80%9a%e9%81%93/) 說明：我們先看一下加上買賣點指標畫在圖上的情況,腳本加上

if C \> value1\[1\] then begin

plot4(C\*1.01 ,"作多");plot5(C\*1.02);plot6(C\*1.03);plot7(C\*1.04);

end;

if C \< value2\[1\] then begin

plot11(C\*0.99 ,"作空");plot12(C\*0.98);plot13(C\*0.97);plot14(C\*0.96);

plot15(C\*0.95);plot16(C\*0.94);plot17(C\*0.93);

end;

---

## 場景 1130：多空趨勢指標 — 我們先建立一個趨勢函數:LongShortTrend 腳本如下:

來源：[多空趨勢指標](https://www.xq.com.tw/xstrader/%e5%a4%9a%e7%a9%ba%e8%b6%a8%e5%8b%a2%e6%8c%87%e6%a8%99/) 說明：我們先建立一個趨勢函數:LongShortTrend 腳本如下:

input: ATRLength(NumericSimple), ATRMult(NumericSimple), Strength(NumericSimple), sTrend(NumericRef);

var:mATR(0), avg(0), mLower(0), Upper(0), trend(1), flag(0), flagh(0), xTrend(0),HighLow(0);

HighLow \= Highest(High, ATRLength) \- Lowest(Low, ATRLength);

mATR \= XAverage(HighLow, ATRLength);

avg \= (XAverage(high, Strength) \+ XAverage(low, Strength))/2;

Upper \= avg \+ mATR;

mLower \= avg \- mATR;

if c \> Upper\[1\] and c \> Highest(High, Strength)\[1\] then trend \= 1

else if c \< mLower\[1\] and c \< Lowest(Low, Strength)\[1\] then trend \= \-1;

if trend \< 0 and trend\[1\] \> 0 then flag=1 else flag=0;

if trend \> 0 and trend\[1\] \< 0 then flagh \= 1 else flagh \= 0;

if trend \> 0 and mLower \< mLower\[1\] then mLower=mLower\[1\];

if trend \< 0 and Upper \> Upper\[1\] then Upper=Upper\[1\];

if flag \= 1 then Upper \= avg \+ mATR;

if flagh \= 1 then mLower \= avg \- mATR;

if trend \= 1 then xTrend \= mLower else xTrend \= Upper;

LongShortTrend \= xTrend;

sTrend \= trend;

---

## 場景 1131：多空趨勢指標 — 從這個函數很明顯可以看出,我們用高低點價差的均值和高低中價均值去做了一個通道,畫出指標腳本用下面腳本

來源：[多空趨勢指標](https://www.xq.com.tw/xstrader/%e5%a4%9a%e7%a9%ba%e8%b6%a8%e5%8b%a2%e6%8c%87%e6%a8%99/) 說明：從這個函數很明顯可以看出,我們用高低點價差的均值和高低中價均值去做了一個通道,畫出指標腳本用下面腳本

input: Length(9), Multi(1), Strength(9);

variable: strend(0),LS(0);

LS \= LongShortTrend(Length, Multi, Strength, strend);

if strend \= 1 then Plot1(LS,"Trend\_Up") else Plot2(LS,"Trend\_Down");

if C cross above LS then

begin

plot4(C\*1.01 ,"作多");

plot5(C\*1.02);plot6(C\*1.03);plot7(C\*1.04);

plot8(C\*1.05);plot9(C\*1.06);plot10(C\*1.07);

end;

if C cross below LS then

begin

plot11(C\*0.99 ,"作空");

plot12(C\*0.98);plot13(C\*0.97);plot14(C\*0.96);

plot15(C\*0.95);plot16(C\*0.94);plot17(C\*0.93);

end;

---

## 場景 1132：多空點數指標 — 今天把一個很簡單的概念做成指標:

來源：[多空點數指標](https://www.xq.com.tw/xstrader/%e5%a4%9a%e7%a9%ba%e9%bb%9e%e6%95%b8%e6%8c%87%e6%a8%99/) 說明：今天把一個很簡單的概念做成指標:

var:i(0),Lscore(0),Sscore(0);Lscore=0;Sscore=0;

for i \= 1 to 100

begin

if C\> H\[i\] then Lscore+= i else if C \< L\[i\] then Sscore+= i;

end;

plot1(Lscore,"多方點數");

plot2(Sscore ,"空方點數");

---

## 場景 1133：融資異常變化指標

來源：[融資異常變化指標](https://www.xq.com.tw/xstrader/%e8%9e%8d%e8%b3%87%e7%95%b0%e5%b8%b8%e8%ae%8a%e5%8c%96%e6%8c%87%e6%a8%99/) 說明：我們看一下腳本:

input:CDay(3),XRario(0.25),InDec(1);

setinputname(1,"計算日數");

setinputname(2,"佔比異常門檻");

setinputname(3,"參數:1=增異常,-1=減異常");

variable:i(1),XData(0),XDataAmount(0),XAmount(0),KeyPrice(0),xLower(0);

XData \= GetField("融資增減張數")\[i\];

XDataAmount \= Summation(GetField("成交金額")\[i\]/Volume\[i\]\*XData,CDay);

XAmount \=Summation(GetField("成交金額")\[i\],CDay);

if InDec \>=1 then begin

if XDataAmount/ XAmount \> XRario then begin plot1(XDataAmount/ XAmount,"增加"); KeyPrice \=H; end;

end else begin

if XDataAmount\*-1/ XAmount \> XRario then begin plot2(XDataAmount/ XAmount,"減少"); KeyPrice=L;end;

end;

if KeyPrice \= 0 then Keyprice \=C;

plot3(C,"收盤價");

plot4(KeyPrice,"關鍵價");

---

## 場景 1134：籌碼沈澱指標

來源：[籌碼沈澱指標](https://www.xq.com.tw/xstrader/931/) 說明：我們看一下腳本:

value1 \=GetField("成交金額")- GetField("成交金額")/v\*GetField("當沖張數");

if value1\[1\] \>0 then value2 \= 100\*value1/value1\[1\]-100;

if currentbar \< 1 then return;

value3 \= standarddev(value2,5,1);

value4 \= standarddev(value2,10,1);

value5 \= standarddev(value2,20,1);

plot1(value3,"5日籌碼標準差");

plot2(value4,"10日籌碼標準差");

plot3(value5,"20日籌碼標準差");

if value3 \= lowest(value3 ,20) and

value4 \= lowest(value4 ,20) and

value5 \= lowest(value5 ,20) then

begin

value10 \= highest(high,20);

value11 \= lowest(low,20);

plot4(maxlist(value3,value4,value5),"籌碼沉澱門坎");

end;

if value10 \= 0 then value10 \=c;

if value11 \= 0 then value11 \=c;

plot5(value10,"籌碼沉澱區上界");

plot6(value11,"籌碼沉澱區下界");

---

## 場景 1135：多方維持線

來源：[多方維持線](https://www.xq.com.tw/xstrader/%e5%a4%9a%e6%96%b9%e7%b6%ad%e6%8c%81%e7%b7%9a/) 說明：我們先來看腳本:

var:p1(20),Posit(0);

var:iLow(low); ilow \= minlist(l,ilow);

value1 \= highest(h,p1); if value1 \>value1\[1\] then ilow \=h;

if Lowest(l,p1) \=ilow then value2 \= ilow;

if value2 \> value2\[1\] then value3 \= value2;

plot1( value3,"多方維持線");

condition1 \= trueall(c\>value3,3);

condition2 \= trueall(c\<value3,3);

if condition1 and condition1\[1\]=false and Posit= \-1 then begin

posit=-1;plot11(C\*0.99 ,"作空");

plot12(C\*0.98);plot13(C\*0.97);plot14(C\*0.96);

plot15(C\*0.95);plot16(C\*0.94);plot17(C\*0.93);

end;

---

## 場景 1136：波動率指標 — 此我們設計了一個指標,可以衡量這檔股票的股價活潑程度:

來源：[波動率指標](https://www.xq.com.tw/xstrader/918/) 說明：此我們設計了一個指標,可以衡量這檔股票的股價活潑程度:

value1= 100\*(average(H/L-1,20)+standarddev(H/L-1,20,1)\*3);

value2 \= value1- average(value1,10);

plot1(value1,"波動指標");

if value2\> 0 then plot2(value2,"波動放大");

if value2\<= 0 then plot3(value2,"波動縮小");

---

## 場景 1137：在評價低檔區，等待大風吹起的股票 — 然後，我就用XS寫了以下的腳本去跑

來源：[在評價低檔區，等待大風吹起的股票](https://www.xq.com.tw/xstrader/%e5%9c%a8%e8%a9%95%e5%83%b9%e4%bd%8e%e6%aa%94%e5%8d%80%ef%bc%8c%e7%ad%89%e5%be%85%e5%a4%a7%e9%a2%a8%e5%90%b9%e8%b5%b7%e7%9a%84%e8%82%a1%e7%a5%a8/) 說明：然後，我就用XS寫了以下的腳本去跑

input:length(36);

input:ratio(10);

setinputname(1,"計算的月數");

setinputname(2,"股價不超過每股淨值低點的百分比");

if barfreq\<\>"M"

then return;

value1=q\_NetValuePerShare;//每股淨值

value2=q\_CurrentROE;//股東報酬率

if value1\<\>0

then value3=low/value1

else value3=0;

value4=nthlowest(1,value3,length);

if value3\<value4\*(1+ratio/100) and value2\>0

then ret=1;

---

## 場景 1138：黑棒吞噬紅棒

來源：[黑棒吞噬紅棒](https://www.xq.com.tw/xstrader/%e9%bb%91%e6%a3%92%e5%90%9e%e5%99%ac%e7%b4%85%e6%a3%92/) 說明：這次測試腳本如下:

var:Days(60);

if h \=highest(h,20) and C\<C\[1\] and C\[1\] \> O\[1\] and C\[1\] \>C\[2\] and

Ch\[1\] and L\<l\[1\] then condition1 \= true else condition1 \=false; 

if currentbar \=1 then print("點數@日期,當日,5日後,10日後,20日後,40日後,60日後"); 

if condition1\[Days\] and C\[Days\]\>8000 then

print(numtostr(C\[Days\],2),"@",numtostr(date\[Days\],0),",1,",C\[Days-5\]/C\[Days\]

,",",C\[Days-10\]/C\[Days\],",",C\[Days-20\]/C\[Days\],",",C\[Days-40\]/C\[Days\],",",C\[0\]/C\[Days\]);

---

## 場景 1139：外盤成交比例指標 — 今天來跟大家介紹一個我用了一陣子，覺得效果還不錯的指標\~外盤成交比例指標。這個指標的算法是把每天的外盤量當分子，內盤量加上外盤量當分母，算出一個比例，然後再分別...

來源：[外盤成交比例指標](https://www.xq.com.tw/xstrader/%e5%a4%96%e7%9b%a4%e6%88%90%e4%ba%a4%e6%af%94%e4%be%8b%e6%8c%87%e6%a8%99/) 說明：今天來跟大家介紹一個我用了一陣子，覺得效果還不錯的指標\~外盤成交比例指標。這個指標的算法是把每天的外盤量當分子，內盤量加上外盤量當分母，算出一個比例，然後再分別取五日及十二日的移動平均，具體的腳本如下:

input:short1(5),mid1(12);

setinputname(1,"短期平均");

setinputname(2,"長期平均");

value1=GetField("內盤量");//內盤量

value2=GetField("外盤量");//外盤量

value3=value1+value2;

if value3\<\>0

then value4=value2/value3\*100;

value5=average(value4,short1);

value6=average(value4,mid1);

plot1(value5,"短期均線");

plot2(value6,"長期均線");

---

## 場景 1140：股價漲超過月線多遠得停利? — 可以利用下面腳本來觀察擺盪的變化:

來源：[股價漲超過月線多遠得停利?](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%83%b9%e6%bc%b2%e8%b6%85%e9%81%8e%e6%9c%88%e7%b7%9a%e5%a4%9a%e9%81%a0%e5%be%97%e5%81%9c%e5%88%a9/) 說明：可以利用下面腳本來觀察擺盪的變化:

plot1(100\*h/average(c,20)-100,"擺盪%");

---

## 場景 1141：站上月線第四天還未跌破的才能買 — 我們可以用下面的腳本找到一些5成信心站上均線確立的個股:

來源：[站上月線第四天還未跌破的才能買](https://www.xq.com.tw/xstrader/%e7%ab%99%e4%b8%8a%e6%9c%88%e7%b7%9a%e7%ac%ac%e5%9b%9b%e5%a4%a9%e9%82%84%e6%9c%aa%e8%b7%8c%e7%a0%b4%e7%9a%84%e6%89%8d%e8%83%bd%e8%b2%b7/) 說明：我們可以用下面的腳本找到一些5成信心站上均線確立的個股:

value1 \= average(c,20);

if C\[3\] cross over value1\[3\] and TrueAll( C \> Value1,3) then ret=1;

---

## 場景 1142：盤整後開高不拉回 — 後記: 本法極不適合不停損的人 ，切勿嚐試。

來源：[盤整後開高不拉回](https://www.xq.com.tw/xstrader/%e7%9b%a4%e6%95%b4%e5%be%8c%e9%96%8b%e9%ab%98%e4%b8%8d%e6%8b%89%e5%9b%9e/) 說明：後記: 本法極不適合不停損的人 ，切勿嚐試。

input:sp(1);

input:opl(2);

input:oph(4);

setinputname(1,"回檔最大幅度");

setinputname(2,"開高最小幅度");

setinputname(3,"開高最大幅度");

if time\>0905

then

begin

if open\>=close\[1\]\*(1+opl/100)

and close\<=close\[1\]\*(1+oph/100)

and low\>open\*(1-sp/100)

and close=high

and close\[1\]\<close\[3\]\*1.04//前三天漲幅不到4%

then ret=1;

end;

---

## 場景 1143：個股VIX恐慌指數 — XQ全球贏家也在期權指標提供VIX(恐慌指數)讓投資人使用。而這樣的指標是不是適合每種商品使用呢?如果要讓其他商品使用卻沒有對應的選擇權序列那又該怎辦呢?技術分...

來源：[個股VIX恐慌指數](https://www.xq.com.tw/xstrader/%e5%80%8b%e8%82%a1vix%e6%81%90%e6%85%8c%e6%8c%87%e6%95%b8/) 說明：XQ全球贏家也在期權指標提供VIX(恐慌指數)讓投資人使用。而這樣的指標是不是適合每種商品使用呢?如果要讓其他商品使用卻沒有對應的選擇權序列那又該怎辦呢?技術分析大師Larry Williams發明的VIX的替代用指數，使用開高低收來模擬出交易人的恐慌程度Script如下

value1 \= (Highest(Close,22) \- Low)/(Highest(Close,22))\*100;

plot1(value1,"WVF");

---

## 場景 1144：交易活躍度指標 — 這個指標的邏輯是這樣，上述五項如果超過季平均三成，就算一分，所以總分是五分，腳本如下，附圖是我用這指標來看一些個股時的對應圖，我覺得還不錯用，可以幫我濾一些假訊...

來源：[交易活躍度指標](https://www.xq.com.tw/xstrader/%e4%ba%a4%e6%98%93%e7%95%b0%e5%b8%b8%e6%b4%bb%e8%ba%8d%e6%8c%87%e6%a8%99/) 說明：這個指標的邏輯是這樣，上述五項如果超過季平均三成，就算一分，所以總分是五分，腳本如下，附圖是我用這指標來看一些個股時的對應圖，我覺得還不錯用，可以幫我濾一些假訊號

input:days(66);

input:ratio(10);

setinputname(1,"移動平均天數");

setinputname(2,"超出均值比率");

var:count(0);

value1=GetField("當日總成交筆數");

value2=average(value1,days);

value3=GetField("強弱指標");

value4=average(value3,days);

value5=GetField("外盤均量");

value6=average(value5,days);

value7=GetField("主動買力");

value8=average(value7,days);

value9=GetField("開盤委買");

value10=average(value9,days);

count=0;

if value1\>=value2\*(1+ratio/100)

then count=count+1;

if value3\>=value4\*(1+ratio/100)

then count=count+1;

if value5\>=value6\*(1+ratio/100)

then count=count+1;

if value7\>=value8\*(1+ratio/100)

then count=count+1;

if value9=value10\*(1+ratio/100)

then count=count+1;

plot1(count,"交易活躍度指標");

---

## 場景 1145：當沖策略之反常必有妖 — 在系統內建警示腳本裡，當沖交易型這個目錄中，有一個”突破波動範圍”的腳本，今天來介紹這個簡單的腳本，它的程式碼如下:

來源：[當沖策略之反常必有妖](https://www.xq.com.tw/xstrader/847/) 說明：在系統內建警示腳本裡，當沖交易型這個目錄中，有一個”突破波動範圍”的腳本，今天來介紹這個簡單的腳本，它的程式碼如下:

input:Length(20); setinputname(1,"高低計算期數");

variable:HighLow(0);

HighLow=high-low;

if HighLow\>highest(HighLow\[1\],Length) then ret=1;

---

## 場景 1146：從今天開盤起算的語法

來源：[從今天開盤起算的語法](https://www.xq.com.tw/xstrader/%e5%be%9e%e4%bb%8a%e5%a4%a9%e9%96%8b%e7%9b%a4%e8%b5%b7%e7%ae%97%e7%9a%84%e8%aa%9e%e6%b3%95/) 說明：請看以下的語法

if date\[1\] \<\> date then

begin

---

## 場景 1147：用週線反轉來確認主流股漲勢結束 — 以前不會有腳本，像這樣的反轉策略只能用目視判斷現在有了XS，我就直接寫了一個腳本如下了

來源：[用週線反轉來確認主流股漲勢結束](https://www.xq.com.tw/xstrader/835/) 說明：以前不會有腳本，像這樣的反轉策略只能用目視判斷現在有了XS，我就直接寫了一個腳本如下了

input:rate1(5);

input:rate2(3);

setinputname(1,"先前週線漲幅");

setinputname(2,"本週低點跌幅");

if high\[2\]\>=close\[3\]\*(1+rate1/100) and low \< close\[1\]\*(1-rate2/100)

then ret=1;

---

## 場景 1148：開盤後漲多跌少 — 各位可以參考附圖，這是昨天漲停的股票不同的分時走勢圖，各位可以發現，有的一開就漲停，有的是開高後整理後再拉一波，有的是先開高然後直接就攻上去，有的是階梯式向上。...

來源：[開盤後漲多跌少](https://www.xq.com.tw/xstrader/%e9%96%8b%e7%9b%a4%e5%be%8c%e6%bc%b2%e5%a4%9a%e8%b7%8c%e5%b0%91/) 說明：各位可以參考附圖，這是昨天漲停的股票不同的分時走勢圖，各位可以發現，有的一開就漲停，有的是開高後整理後再拉一波，有的是先開高然後直接就攻上去，有的是階梯式向上。型態雖有不同，但相同的是，漲的比較多，跌的比較小所以大內高手再給我的兩個腳本一個是開盤後m根bar中有n根上漲

input:RisingBars(5); setinputname(1,"開盤起至少上漲期數");

input:ContBars(10); setinputname(2,"第幾根K棒時提醒");

variable:KBarOfDay(0); KBarOfDay+=1; if date\<\>date\[1\] then KBarOfDay=1; //計算每天日內的Bar序數

if Date \= CurrentDate and ContBars \= KBarOfDay and //今天開盤起算到現

countif(close\>close\[1\] and close \> open,KBarOfDay) //收漲計算(包含開盤第一根是要漲)

\>=RisingBars

then ret=1;

---

## 場景 1149：開盤後漲多跌少 — 另一個是開盤後上漲的bar佔了幾成

來源：[開盤後漲多跌少](https://www.xq.com.tw/xstrader/%e9%96%8b%e7%9b%a4%e5%be%8c%e6%bc%b2%e5%a4%9a%e8%b7%8c%e5%b0%91/) 說明：另一個是開盤後上漲的bar佔了幾成

nput:RisingBarsPercents(0.5); setinputname(1,"開盤起至少上漲期數比例");

input:ContBars(10); setinputname(2,"第幾根K棒時提醒");

variable:KBarOfDay(0); KBarOfDay+=1; if date\<\>date\[1\] then KBarOfDay=1; //計算每天日內的Bar序數

if Date \= CurrentDate and KBarOfDay \>2 and //今天至少要有3根Bar

ContBars \= KBarOfDay and //今天開盤起算到現在第幾跟觸發

countif(close\>close\[1\] and close \> open,KBarOfDay)/KBarOfDay //收漲比例(包含開盤第一根是要漲)

\>=RisingBarsPercents

then ret=1;

---

## 場景 1150：尋找趨勢反轉的股票 — 坦白說，我個人比較喜歡挑的是強勢股，這種大跌過的，除非底打的很紮實，不然這種短線的上漲都可能只是反彈，不過朋友堅持V型反轉的也不少，所以我只好試著寫了下面這個腳...

來源：[尋找趨勢反轉的股票](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e8%b6%a8%e5%8b%a2%e5%8f%8d%e8%bd%89%e7%9a%84%e8%82%a1%e7%a5%a8/) 說明：坦白說，我個人比較喜歡挑的是強勢股，這種大跌過的，除非底打的很紮實，不然這種短線的上漲都可能只是反彈，不過朋友堅持V型反轉的也不少，所以我只好試著寫了下面這個腳本來試看看

variable: pvt(0);

If CurrentBar \= 1 then

pvt \= 0

else

pvt \= pvt\[1\] \+ (close \- close\[1\])/close\[1\] \* Volume;

input:Length(20); setinputname(1,"下降趨勢計算期數");

value1 \= linearregslope(PVT,Length);

value2 \= linearregslope(PVT,5);

IF value1 \< 0 and value2\> 0 AND VOLUME\>1000 then ret=1;

---

## 場景 1151：投信開始押的冷門股 — 所以我寫了一個小小的腳本如下

來源：[投信開始押的冷門股](https://www.xq.com.tw/xstrader/%e6%8a%95%e4%bf%a1%e9%96%8b%e5%a7%8b%e6%8a%bc%e7%9a%84%e5%86%b7%e9%96%80%e8%82%a1/) 說明：所以我寫了一個小小的腳本如下

value1=GetField("投信買張");

value2=lowest(close,10);//十日最低價

if value1\>volume\*0.1//投信買張超過成交量一成

and volume\>1000//成交量大於1000張

and close\<value2\*1.1//收盤價距離近十日低點沒有漲超過一成

then ret=1;

---

## 場景 1152：不明買盤指標 — 我把這指標稱為不明買盤指標腳本如下:

來源：[不明買盤指標](https://www.xq.com.tw/xstrader/%e4%b8%8d%e6%98%8e%e8%b2%b7%e7%9b%a4%e6%8c%87%e6%a8%99/) 說明：我把這指標稱為不明買盤指標腳本如下:

input:period(3);

setinputname(1,"均線期間");

value1=GetField("法人買張");

value2=GetField("當日沖銷張數");

value3=GetField("散戶買張");

value4=volume-value1-value2-value3;

value5=value4/volume;

value6=average(value5,period);

plot1(value6,"不明買盤比例");

---

## 場景 1153：MA再平均指標 — 我把這個數字當成一個自訂指標，腳本如下:

來源：[MA再平均指標](https://www.xq.com.tw/xstrader/809/) 說明：我把這個數字當成一個自訂指標，腳本如下:

value1=average(close,5);

value2=average(value1,5);

value3=value1-value2;

value4=summation(value3,10);

plot1(value4);

---

## 場景 1154：adaptive price zone

來源：[adaptive price zone](https://www.xq.com.tw/xstrader/adaptive-price-zone/) 說明：這指標的公式如下:

input: Length(14), BandPct(2.0);

variable: DSEMA(0), UpBand(0), DownBand(0), RangeEMA(0), period(0), var0(0);

period \= squareroot(Length);

DSEMA \= xaverage(xaverage(close, period), period);

RangeEMA \= xaverage(xaverage(high-low, period), period);

UpBand \= DSEMA \+ BandPct\*RangeEMA;

DownBand \= DSEMA \- BandPct\*RangeEMA;

Plot1(UpBand, "Upperband");

Plot2(close, "Close");

Plot3(DownBand, "BottomBand");

---

## 場景 1155：Arron oscillator — 我用xs的自設指標根據這個公司寫了一個腳本

來源：[Arron oscillator](https://www.xq.com.tw/xstrader/arron-oscillator/) 說明：我用xs的自設指標根據這個公司寫了一個腳本

input:length(25);

variable: arron\_up(0),arron\_down(0),arron\_oscillator(0);

arron\_up=(length-nthhighestbar(1,high,length))/length\*100;

arron\_down=(length-nthlowestbar(1,low,length))/length\*100;

arron\_oscillator=arron\_up-arron\_down;

plot1(arron\_up,"arron\_up");

plot2(arron\_down,"arron\_down");

plot3(arron\_oscillator,"arron\_oscillator");

---

## 場景 1156：築底指標 — 築底指標的算法很簡單，以過去125天上漲的天數當分子，下跌的天數當分母，算出來的數字再取不同天期的移動平均。其腳本如下:

來源：[築底指標](https://www.xq.com.tw/xstrader/%e7%af%89%e5%ba%95%e6%8c%87%e6%a8%99-2/) 說明：築底指標的算法很簡單，以過去125天上漲的天數當分子，下跌的天數當分母，算出來的數字再取不同天期的移動平均。其腳本如下:

input:period(125),length1(5),length2(20);

variable:zd(0),zdma1(0),zdma2(0);

zd=countif(close\>=close\[1\],period)/countif(close\<close\[1\],period);

zdma1=average(zd,length1);

zdma2=average(zd,length2);

plot1(zdma1,"短天期築底指標");

plot2(zdma2,"長天期築底指標");

---

## 場景 1157：BBand width — XQ裡有一個技術指標叫BBand width 這是BBand的一個衍生指標。我們先來看一下bband的公式

來源：[BBand width](https://www.xq.com.tw/xstrader/bband-width/) 說明：XQ裡有一個技術指標叫BBand width 這是BBand的一個衍生指標。我們先來看一下bband的公式

Input: price(numericseries), length(numericsimple), \_band(numericsimple);

BollingerBand \= Average(price, length) \+ \_band \* StandardDev(price, length, 1);

---

## 場景 1158：BBand width — 理解了bband的概念後，我們再來看bband width的概念是什麼? 根據公式

來源：[BBand width](https://www.xq.com.tw/xstrader/bband-width/) 說明：理解了bband的概念後，我們再來看bband width的概念是什麼? 根據公式

up \= bollingerband(Close, Length, UpperBand);

down \= bollingerband(Close, Length, \-1 \* LowerBand);

mid \= (up \+ down) / 2;

bbandwidth \= 100 \* (up \- down) / mid;

---

## 場景 1159：DMI — 我們回顧一下DMI的公式

來源：[DMI](https://www.xq.com.tw/xstrader/787/) 說明：我們回顧一下DMI的公式

var:+di(0),-di(0)

pdm \= maxlist(High \- High\[1\], 0);

ndm \= maxlist(Low\[1\] \- Low, 0);

if pdm \< ndm then

pdm \= 0

else

begin

if pdm \> ndm then

ndm \= 0

else

begin

pdm \= 0;

ndm \= 0;

end;

end;

//這樣算出來pdm 跟ndm，再算出padm及nadm

padm \= padm\[1\] \+ (pdm \- padm\[1\]) / length;

nadm \= nadm\[1\] \+ (ndm \- nadm\[1\]) / length;

\+DI=padm/truerange

\-DI=nadm/truerange

plot1(+di,"+di");

plot2(-di,"-di");

---

## 場景 1160：散戶作多指標 — 從這樣的例子，我想說的是，每檔股票的股性不一樣，而且會隨著參與份子的變化而轉變，我們很難用一個交易策略放諸四海而皆準，也許我們可以思考，像全身健康檢查一樣，我們...

來源：[散戶作多指標](https://www.xq.com.tw/xstrader/%e6%95%a3%e6%88%b6%e4%bd%9c%e5%a4%9a%e6%8c%87%e6%a8%99/) 說明：從這樣的例子，我想說的是，每檔股票的股性不一樣，而且會隨著參與份子的變化而轉變，我們很難用一個交易策略放諸四海而皆準，也許我們可以思考，像全身健康檢查一樣，我們用多個不同的指標，去偵測一個商品不同的面向，包括趨勢，動能，量能，震盪，籌碼的發散或收斂等等，然後我們也有一個個股的多空體檢表，經由長期的追蹤，綜合各項的指標，我們才能比較掌握得住商品的多空脈動。

input:period(10);

value1=GetField("融資買進張數");

value2=GetField("融券買進張數");

value3=(value1+value2)/volume;

value4=average(value3,period);

plot1(value4,"散戶作多指標");

---

## 場景 1161：十二點之後跌破今天多次觸及但未跌破的低檔區 — 最後囉嗦一句，十二點以後作當沖真的要藝高人膽大的才能做，好處是有前面三小時的走勢資料做參考，這是屬於比較進階的當沖手法，初學者要多看少作， 或是用小小部位先練功...

來源：[十二點之後跌破今天多次觸及但未跌破的低檔區](https://www.xq.com.tw/xstrader/763/) 說明：最後囉嗦一句，十二點以後作當沖真的要藝高人膽大的才能做，好處是有前面三小時的走勢資料做參考，這是屬於比較進階的當沖手法，初學者要多看少作， 或是用小小部位先練功夫就好。

if Date\<\> Date\[1\] then KBarOfDay \= 1

else KBarOfDay+=1;

variable:TouchLowCounter(0),HLRatio12(0),tLow(0);

if Time \> 93000 and Low \= lowest(Low,KBarOfDay-1)

then TouchLowCounter+=1;

{9:30以後觸低次數}

if Time \<120000 then

begin

HLRatio12 \= ((q\_DailyHigh-q\_DailyLow)/q\_RefPrice)\*100;

{12:00以前高低點波幅}

tLow \= q\_DailyLow;

{記下低點}

end;

if date=currentdate and Time \> 120000

and touchLowcounter \> 3

{今日 12:00之後多次觸及低點}

and HLRatio12 \<2 and tLow \> q\_RefPrice \*0.98

{波幅在2%內且12:00前還沒跌超過2%}

and Low \= q\_DailyLow {來到今日低點時觸發}

then ret=1;

---

## 場景 1162：開高後破平盤，反彈站不回平盤 — 以下附上公司高手針對這個策略所寫的腳本

來源：[開高後破平盤，反彈站不回平盤](https://www.xq.com.tw/xstrader/%e9%96%8b%e9%ab%98%e5%be%8c%e7%a0%b4%e5%b9%b3%e7%9b%a4%ef%bc%8c%e5%8f%8d%e5%bd%88%e7%ab%99%e4%b8%8d%e5%9b%9e%e5%b9%b3%e7%9b%a4/) 說明：以下附上公司高手針對這個策略所寫的腳本

if barfreq \<\> "Tick" then RaiseRuntimeError("請設定頻率為TICK");

variable:BarNumberOfToday(0); if Date \<\> Date\[1\] then

BarNumberOfToday=1 else BarNumberOfToday+=1;{記錄今天的Bar數}

if date=currentdate and date\[10\] \=Date and {今日曾經大漲}

Close \> Close\[10\]\*1.015 then condition1=true else condition1=false;

if condition1 and close\[1\] \>= q\_RefPrice and close \< q\_RefPrice then

condition2 \=true else condition2 \=false;

{大漲後曾跌破平盤}

if condition2 and close \= q\_RefPrice then condition3 \=true

else condition3 \=false;

{跌破後曾回到平盤}

if q\_Last \= q\_DailyLow and condition3 {來到今低且前面各種狀況皆成立}

then ret=1;

---

## 場景 1163：整日價量背離後尾盤開殺 — 以下是高手寫的腳本，特別是價量背離這一段，寫的極精采，在其他地方也用得到。

來源：[整日價量背離後尾盤開殺](https://www.xq.com.tw/xstrader/%e6%95%b4%e6%97%a5%e5%83%b9%e9%87%8f%e8%83%8c%e9%9b%a2%e5%be%8c%e5%b0%be%e7%9b%a4%e9%96%8b%e6%ae%ba/) 說明：以下是高手寫的腳本，特別是價量背離這一段，寫的極精采，在其他地方也用得到。

if barfreq \<\> "Min" then RaiseRuntimeError("請設定頻率為分鐘");

var:PV(0),NV(0);

{計算價量背離定義之正向量與負向量}

if Date \<\> Date\[1\] then

if Close \> Close\[1\] then PV=volume else if Close \< Close\[1\] then NV=Volume

else

if Close \> Close\[1\] then PV+=volume else if Close \< Close\[1\] then NV+=Volume;

if currenttime \> 123000 and {12:30以後}

q\_last \< q\_DailyHigh \*0.98 and Close \< q\_RefPrice and Close\[1\] \>= q\_RefPrice and

{從高點往下跌2%破平盤}

NV \> PV \*3 {價量背離}

then ret=1;

---

## 場景 1164：跌停後一直 沒有鎖住 — 這種型態很特別，通常開盤沒多久會跌停都是因為突發性利空，或是有人受不了開始大倒貨，正常的情況下這種股票會跌停鎖住，但如果跌停很長時間鎖不住， 代表當日恐慌性賣壓...

來源：[跌停後一直 沒有鎖住](https://www.xq.com.tw/xstrader/%e8%b7%8c%e5%81%9c%e5%be%8c%e4%b8%80%e7%9b%b4-%e6%b2%92%e6%9c%89%e9%8e%96%e4%bd%8f/) 說明：這種型態很特別，通常開盤沒多久會跌停都是因為突發性利空，或是有人受不了開始大倒貨，正常的情況下這種股票會跌停鎖住，但如果跌停很長時間鎖不住， 代表當日恐慌性賣壓已經被消耗殆盡。如果出現這種情況，很容易多頭一點火就往上走。我常說盤下的股票作多當沖是比較有利頭的這一類型就是很典型的一種。在找這類股票的過程中，打不下去是很重要的一點，賣壓要愈來愈輕是另一點。參考的腳本如下:

if barfreq \<\> "Min" or Barinterval \<\>1 then RaiseRuntimeError("請設定頻率為1分鐘");

variable:BarNumberOfToday(0); if Date \<\> Date\[1\] then BarNumberOfToday=1 else BarNumberOfToday+=1;{記錄今天的Bar數}

if Date \<\> CurrentDate then return;{計算日為今天才繼續}

variable: LowCount(0),LowLimit(q\_DailyDownlimit);

if TimeDiff(Time,Time\[BarNumberOfToday-1\],"M") \< 30 and {開盤30分鐘內}

Low \= q\_DailyDownlimit then LowCount+=1; {記錄觸跌停次數}

if BarNumberOfToday \> 60 and LowCount \>1 and TrueAll(close \> LowLimit,60) then ret=1;

{ 開盤60根BAR(分鐘)後,曾跌停,且連續60分鐘未再跌停,觸發}

---

## 場景 1165：噪音指標

來源：[噪音指標](https://www.xq.com.tw/xstrader/%e5%99%aa%e9%9f%b3%e6%8c%87%e6%a8%99/) 說明：它的腳本如下:

input:n1(5);

input:n2(5);

setinputname(1,"計算區間");

setinputname(2,"短天期移動平均");

value1=absvalue(close-close\[n1-1\]);

value2=summation(range,n1);

if value1=0

then return

else

value3=value2/value1;

value4=average(value3,n2);

plot1(value4,"短天期噪音指標");

---

## 場景 1166：移動平均線再平均指標 — 我把這個數字當成一個自訂指標，腳本如下:

來源：[移動平均線再平均指標](https://www.xq.com.tw/xstrader/%e7%a7%bb%e5%8b%95%e5%b9%b3%e5%9d%87%e7%b7%9a%e5%86%8d%e5%b9%b3%e5%9d%87%e6%8c%87%e6%a8%99/) 說明：我把這個數字當成一個自訂指標，腳本如下:

value1=average(close,5);

value2=average(value1,5);

value3=value1-value2;

value4=summation(value3,10);

plot1(value4);

---

## 場景 1167：隨機漫步指標。 — 所以我們用今天的最高價去減區間最低價如果大於波動範圍乘上標準差(相除大於一) ，代表上升趨勢成形，如果是今天最低價跌的幅度大於波動範圍乘上標準差，代表下跌趨勢成...

來源：[隨機漫步指標。](https://www.xq.com.tw/xstrader/738/) 說明：所以我們用今天的最高價去減區間最低價如果大於波動範圍乘上標準差(相除大於一) ，代表上升趨勢成形，如果是今天最低價跌的幅度大於波動範圍乘上標準差，代表下跌趨勢成形，我們可以根據這樣的原則，畫出兩條線，內來判斷上漲或是下跌的趨勢是否成形。畫線的腳本如下:

variable:RWIH(0),RWIL(0);

input:length(10);

value1=standarddev(close,length,1);

value4=average(truerange,length);

RWIH=(high-low\[length-1\])/value4\*value1;

RWIL=(high\[length-1\]-low)/value4\*value1;

plot1(RWIH);

plot2(RWIL);

---

## 場景 1168：15分鐘線的突破盤整區 — 常用15分鐘線做短線進場點的分析工具，開放現股當沖後，也就試著寫了一個腳本試試看這個腳本是透過15分鐘線，尋找那些突破近期盤整價位區的股票。

來源：[15分鐘線的突破盤整區](https://www.xq.com.tw/xstrader/15%e5%88%86%e9%90%98%e7%b7%9a%e7%9a%84%e7%aa%81%e7%a0%b4%e7%9b%a4%e6%95%b4%e5%8d%80/) 說明：常用15分鐘線做短線進場點的分析工具，開放現股當沖後，也就試著寫了一個腳本試試看這個腳本是透過15分鐘線，尋找那些突破近期盤整價位區的股票。

input:bars(100);

input:band(2);

setinputname(1,"計算區間");

setinputname(2,"三高點之高低價差");

value1=nthhighest(1,high\[1\],bars);

value2=nthhighest(3,high\[1\],bars);

value3=(value1-value2)/value2;

if value3\<=band/100

and close cross over value1

then ret=1;

---

## 場景 1169：在盤中尋找不只一個法人在買進的股票 — 那麼我們要怎麼在盤中就抓到這種股價呈階梯式上漲的股票呢?我有用XS寫了一個腳本如下:

來源：[在盤中尋找不只一個法人在買進的股票](https://www.xq.com.tw/xstrader/%e5%9c%a8%e7%9b%a4%e4%b8%ad%e5%b0%8b%e6%89%be%e4%b8%8d%e5%8f%aa%e4%b8%80%e5%80%8b%e6%b3%95%e4%ba%ba%e5%9c%a8%e8%b2%b7%e9%80%b2%e7%9a%84%e8%82%a1%e7%a5%a8/) 說明：那麼我們要怎麼在盤中就抓到這種股價呈階梯式上漲的股票呢?我有用XS寫了一個腳本如下:

input:TXT1("僅適用5分鐘線"); setinputname(1,"使用限制");

input:TXT2("只於9:10判斷"); setinputname(2,"使用說明");

input:period(6);setinputname(3,"統計的五分鐘線bar數");

input:count1(4);setinputname(4,"向上的階梯數");

if barfreq \= "Min" and barinterval \= 5 and time\>091500

then begin

if countif(high\>high\[1\]and low\>low\[1\] ,period)\>=count1

and close\*1.01\>highest(high,period) then ret=1;

end;

---

## 場景 1170：多日價量背離 — 以前老市場常說，會買股票的徒弟，會賣股票的才是師傅。這些年，我也算認識了不少人，明牌之類的，多少會聽到一些，長期下來，我發現，我可以存活下來，是因為我那如野獸般...

來源：[多日價量背離](https://www.xq.com.tw/xstrader/694/) 說明：以前老市場常說，會買股票的徒弟，會賣股票的才是師傅。這些年，我也算認識了不少人，明牌之類的，多少會聽到一些，長期下來，我發現，我可以存活下來，是因為我那如野獸般可以聞到危險的嗅覺，一覺得不對勁，我就殺光持股，雖然常常砍早了，但至少躲過了每一次的大回檔。我一直覺得挑股票我不見得多厲害，但砍股票倒是蠻有自信，所以這次的語法交易平台一完工，我就先把我會什麼會砍股票的想法寫成警示腳本，大家一起來培養如野獸...

input:Length(5); setinputname(1,"計算期數");

input:times(3);setinputname(2,"價量背離次數");

input:TXT("建議使用日線"); setinputname(3,"使用說明");

variable:count(0);

count \= CountIf(close \> close\[1\] and volume times then

ret \= 1;

---

## 場景 1171：主力出貨 — 什麼時候該把持股賣出之5主力出貨通常有幾個特徵(用在10分鐘線)1.下跌時幅度比上漲時大，也就是黑K棒較多，紅K棒較少。2.下跌時有量，上漲時量縮3.下跌時走勢...

來源：[主力出貨](https://www.xq.com.tw/xstrader/%e4%b8%bb%e5%8a%9b%e5%87%ba%e8%b2%a8/) 說明：什麼時候該把持股賣出之5主力出貨通常有幾個特徵(用在10分鐘線)1.下跌時幅度比上漲時大，也就是黑K棒較多，紅K棒較少。2.下跌時有量，上漲時量縮3.下跌時走勢較陡。也就是黑K棒較長，紅K棒較短特別是如果把大盤的走勢考慮進出之後，這檔股票走的特別的弱勢，而且又是一大段的漲勢之後，那就很有可能是主力在出貨。另外，如何分辨主力出貨還是主力洗盤?我個人的經驗是，主力洗盤是通常走逆勢，大盤漲時他故意壓著讓...

input:RatioThre(1.5); setinputname(1,"下跌量上漲量比");

variable: upvolume(0);//累計上漲量

variable: downvolume(0);//累計下跌量

variable: uprange(0);//累計上漲值

variable: downrange(0);//累計下跌值

variable: DUratio(0);//下跌量上漲量比

if date\[1\] date then

begin

downvolume \=0; upvolume \=0;

uprange \=0; downrange=0;

if close \> open then

begin

upvolume \= volume;

uprange \= close \-open;

end

else

if close \< open then

begin

downvolume \= volume;

downrange \= open \-close;

end

else

if close close\[1\] then

begin

upvolume \= volume;

uprange \= close \-close\[1\];

end;

end;//如果前一個跟Bar跟目前的bar日期不同 今天第一根起算

if date\[1\] \= date then //還在同一天

begin

if close \> close\[1\] then

begin

upvolume \+= volume;

uprange \+= close \-close\[1\];

end

else

if close 0 then DUratio \= downvolume/upvolume else DUratio=1;

end;

if DUratio crosses over RatioThre and uprange crosses under downrange then ret=1;

---

## 場景 1172：盤中可以找出那檔股票有大單在敲進的腳本 — 盤中可以找出那檔股票有大單在敲進的腳本幾天前跑去朋友的看盤室泡茶聊天，朋友眼睛還是一直盯著電視牆左右上下不停的看，於是我們有了以下的對話。我:你在忙著找什麼?友...

來源：[盤中可以找出那檔股票有大單在敲進的腳本](https://www.xq.com.tw/xstrader/%e7%9b%a4%e4%b8%ad%e5%8f%af%e4%bb%a5%e6%89%be%e5%87%ba%e9%82%a3%e6%aa%94%e8%82%a1%e7%a5%a8%e6%9c%89%e5%a4%a7%e5%96%ae%e5%9c%a8%e6%95%b2%e9%80%b2%e7%9a%84%e8%85%b3%e6%9c%ac-2/) 說明：盤中可以找出那檔股票有大單在敲進的腳本幾天前跑去朋友的看盤室泡茶聊天，朋友眼睛還是一直盯著電視牆左右上下不停的看，於是我們有了以下的對話。我:你在忙著找什麼?友:在找外盤不斷有大單敲進的股票。我:多大的金額叫大單?友:單筆成交金額超過500萬我:每檔股價差那麼多，電視牆揭露的是張數，你怎麼知道有沒有超過500萬?友:我自己會換算，這看久了就很直覺(得意)我:可是現在股票有1400檔，你的電視牆裝不...

input: BigBuy(500); setinputname(1,"大戶買單(萬)");

input: BigBuyTimes(10); setinputname(2,"大戶買進次數");

input:TXT("須逐筆洗價"); setinputname(3,"使用限制:");

variable: intrabarpersist Xtime(0);//計數器

variable: intrabarpersist Volumestamp(0);

Volumestamp \=q\_DailyVolume;

if Date currentdate or Volumestamp \= Volumestamp\[1\] then Xtime \=0; //開盤那根要歸0次數

if q\_tickvolume\*q\_Last \> BigBuy\*10 and q\_BidAskFlag=1 then Xtime+=1; //量夠大就加1次

if Xtime \> BigBuyTimes then ret=1;

---

## 場景 1173：主力可能出貨的股票 — 如何知道公司派，主力是不是在出貨?這問題，被問了好幾次，只要盤在跌，就常被問。我的邏輯是這樣的，如果有一檔股票1.成交量不算小2.近期股價下跌3.收盤價離區間低...

來源：[主力可能出貨的股票](https://www.xq.com.tw/xstrader/%e4%b8%bb%e5%8a%9b%e5%8f%af%e8%83%bd%e5%87%ba%e8%b2%a8%e7%9a%84%e8%82%a1%e7%a5%a8/) 說明：如何知道公司派，主力是不是在出貨?這問題，被問了好幾次，只要盤在跌，就常被問。我的邏輯是這樣的，如果有一檔股票1.成交量不算小2.近期股價下跌3.收盤價離區間低點很近4.法人沒有大賣超5.融資沒有減少6.融券沒有增加這樣代表股票在跌，但法人及散戶都沒有怎麼在賣，這樣應該就可以推估說這檔股票的賣盤極可能是來自主力或公司派。根據這樣的精神，我請公司的高手寫了以下的一個腳本:

input:Peroid(5);setinputname(1,"近期偏弱期間");

input:Rate1(500);setinputname(2,"法人及散戶合計賣出上限");

input:Rate2(8000);setinputname(3,"成交量下限");

input:Ratio(1); setinputname(4,"接近低點幅度");

input:Type(1);setinputname(5,"盤中用1,收盤出資料後用0");

if Close\< Close\[Peroid\] and {近期股價累計為下跌}

Close Rate2 {偏弱期間均量大於成交量下限}

then

begin

value1= GetField("法人持股")\[Type\] \- GetField("法人持股")\[Peroid+Type\] ; {期間法人累計買賣超}

value2= GetField("融資餘額張數")\[Type\] \- GetField("融資餘額張數")\[Peroid+Type\] ; {期間融資累計增減}

value3= GetField("融券餘額張數")\[Type\] \- GetField("融券餘額張數")\[Peroid+Type\];{期間融券累計增減}

if value1 \+ value2 \-value3 \> Rate1\*-1 then ret=1;

end;

---

## 場景 1174：法人買進比重大的非權值股。 — 今天來介紹一個很簡單的腳本\~法人買進比重大的非權值股。以前還在管基金的時候，每次覺得盤要掛了的時候，我會做三件事1.把漲太多，籌碼亂，業績會受全球景氣影響，客人...

來源：[法人買進比重大的非權值股。](https://www.xq.com.tw/xstrader/%e6%b3%95%e4%ba%ba%e8%b2%b7%e9%80%b2%e6%af%94%e9%87%8d%e5%a4%a7%e7%9a%84%e9%9d%9e%e6%ac%8a%e5%80%bc%e8%82%a1%e3%80%82/) 說明：今天來介紹一個很簡單的腳本\~法人買進比重大的非權值股。以前還在管基金的時候，每次覺得盤要掛了的時候，我會做三件事1.把漲太多，籌碼亂，業績會受全球景氣影響，客人贖回各基金都會砍的股票先獲利了結。2.開始買一些貝他低，有流動性的牛皮績優股，當年最常買的是亞泥，中華電3.挑一些基本面長期看好，盤再差抱著也安心的股票，等盤大跌時進去收。這幾天盤大跌後反彈，我想知道一下在這樣震盪的盤面中，法人有沒有在趁機...

value1=GetField("法人買張");

input:period(3);

input:ratio(3);

input:bline(2000);

setinputname(1,"計算天數");

setinputname(2,"佔成交量成數");

setinputname(3,"法人合計買超最低量");

value2=summation(value1,period);

value3=summation(volume,period);

value4=value2/value3;

if value4\*10\>ratio and value1\>0 and value2\>bline

then ret=1;

---

## 場景 1175：在開盤十五分鐘內找到今天可能漲停的股票 — 我阿媽的妹妹有句千古名言:”不管賺多少，看到自己有的股票漲停板就是爽”。但1400多檔中，怎麼找到今天會漲停的股票?根據我自己的經驗，大家搶著上車的股票，漲停的...

來源：[在開盤十五分鐘內找到今天可能漲停的股票](https://www.xq.com.tw/xstrader/%e5%9c%a8%e9%96%8b%e7%9b%a4%e5%8d%81%e4%ba%94%e5%88%86%e9%90%98%e5%85%a7%e6%89%be%e5%88%b0%e4%bb%8a%e5%a4%a9%e5%8f%af%e8%83%bd%e6%bc%b2%e5%81%9c%e7%9a%84%e8%82%a1%e7%a5%a8/) 說明：我阿媽的妹妹有句千古名言:”不管賺多少，看到自己有的股票漲停板就是爽”。但1400多檔中，怎麼找到今天會漲停的股票?根據我自己的經驗，大家搶著上車的股票，漲停的機率就大，如果主力自己在規劃的，就得看主力今天心情如何了。那麼大家搶著上車的股票，有什麼特徵呢?我看到的是一開盤追價就很踴躍。因著這個特徵，常常是開盤5到15分鐘之內，大部份的時間都是上漲的，所以我請了公司高手中的高高手，寫了下面這個腳本，...

input:contRise(5); setinputname(1,"開盤起連漲期數");

variable:KBarOfDay(0);

KBarOfDay+=1;

if date\<\>date\[1\] then KBarOfDay=1; //計算每天日內的Bar序數

if Date \= CurrentDate //今天開盤起算

and contRise \= countif(close\>close\[1\] and close \> open,KBarOfDay) //收漲計算(包含開盤第一根是要漲)

and contRise \= KBarOfDay //今天有幾根棒就漲幾根

then ret=1;

---

## 場景 1176：外盤量佔比指標 — 各位可以參考附圖，我們以最近跌的頗深，但波段漲幅有三成的矽品為例，我們可以發現，當外盤量佔比呈上升趨勢時，股價就算回檔，還是會再創新高，但相反的，股價雖然在高檔...

來源：[外盤量佔比指標](https://www.xq.com.tw/xstrader/%e5%a4%96%e7%9b%a4%e9%87%8f%e4%bd%94%e6%af%94%e6%8c%87%e6%a8%99/) 說明：各位可以參考附圖，我們以最近跌的頗深，但波段漲幅有三成的矽品為例，我們可以發現，當外盤量佔比呈上升趨勢時，股價就算回檔，還是會再創新高，但相反的，股價雖然在高檔盤旋，但這指標的數值一再破底，那就代表追價乏力，一檔股票漲多後出現追價乏力，拉回修正的壓力就會變大這個指標的腳本很簡單，我附在下方

input:period(20);

setinputname(1,"平均數天期");

value2=GetField("外盤量");//日的外盤量

value4=value2/volume;

value5=average(value4,period);

plot1(value4,"外盤佔比");

plot2(value5,"外盤佔比平均值");

---

## 場景 1177：只要有心，人人都可以成為小虎隊 — 跟朋友聊起了虎尾幫的操作手法，回家後寫了一個腳本，並且請公司的高手修改如下:

來源：[只要有心，人人都可以成為小虎隊](https://www.xq.com.tw/xstrader/%e5%8f%aa%e8%a6%81%e6%9c%89%e5%bf%83%ef%bc%8c%e4%ba%ba%e4%ba%ba%e9%83%bd%e5%8f%af%e4%bb%a5%e6%88%90%e7%82%ba%e5%b0%8f%e8%99%8e%e9%9a%8a-2/) 說明：跟朋友聊起了虎尾幫的操作手法，回家後寫了一個腳本，並且請公司的高手修改如下:

if barfreq "D" then return ; {只在日線可用}

input:sp(1); setinputname(1,"當日回檔最大幅度");

input:opl(2); setinputname(2,"開高最小幅度");

input:oph(4); setinputname(3,"開高最大幅度");

if currenttime \> 100000 and currentdate \=date {今天10點過後開始判斷}

then begin

if open \>= close\[1\] \* (1 \+ opl/100) and {開高在昨收的之上%下限}

close open \* (1 \- sp/100) //and {低點離開盤價%}

close \= high {收在最高點}

then ret=1;

end;

---

## 場景 1178：開盤五分鐘不回頭 — 在我過往trading的經驗裡，開盤前十五分鐘是一個很重要的指標，開盤八法中有開盤五分鐘線連三紅今天收高機率大的說法，我觀察到，如果一檔股票開盤持續十到十五分鐘...

來源：[開盤五分鐘不回頭](https://www.xq.com.tw/xstrader/%e9%96%8b%e7%9b%a4%e4%ba%94%e5%88%86%e9%90%98%e4%b8%8d%e5%9b%9e%e9%a0%ad/) 說明：在我過往trading的經驗裡，開盤前十五分鐘是一個很重要的指標，開盤八法中有開盤五分鐘線連三紅今天收高機率大的說法，我觀察到，如果一檔股票開盤持續十到十五分鐘都是外盤在成交，且一路緩步上攻，那就代表今天的追價買盤很積極，有可能是有特定的新勢力進場買股票，當然這種情況必須排除那些報上有好消息的股票，也必須排除那些一開盤就跳空大漲的，因為這兩種對當沖者可能都沒有差價可賺。我用xs寫了一個腳本，專門找...

if barfreq \= "Min" and barinterval \= 60 and

(time\[4\] \= 84500 or time\[4\] \= 90000\)

then begin

if trueall(close\>=close\[1\],5)

and trueall(close=high,5)

then ret=1;

end;

---

## 場景 1179：狹長整理後的突破 — 今天來介我個人最喜歡的當沖型態，這種型態通常出現在主力洗盤結束前，開盤時會以平高或平低盤開出，然後就在平盤附近一直橫盤，特別是如果今天盤勢不差時，這種盤法會讓短...

來源：[狹長整理後的突破](https://www.xq.com.tw/xstrader/%e7%8b%b9%e9%95%b7%e6%95%b4%e7%90%86%e5%be%8c%e7%9a%84%e7%aa%81%e7%a0%b4-2/) 說明：今天來介我個人最喜歡的當沖型態，這種型態通常出現在主力洗盤結束前，開盤時會以平高或平低盤開出，然後就在平盤附近一直橫盤，特別是如果今天盤勢不差時，這種盤法會讓短多換股操作，等到洗的差不多時，有可能會往下打一下，這是最後洗盤，也可能不打直接拉，這種股票一突破今天最高點就得進場，然後以今天的最低點當停損點。我請高手同事寫了一個用一分鐘線來找這種股票的腳本

if barfreq "Min" or barinterval 1 then RaiseRuntimeError("請設定頻率為1分鐘");

variable:KBarOfDay(0); if Date \<\> Date\[1\] then KBarOfDay \= 1 else KBarOfDay+=1;

input:P1(60); setinputname(1,"狹幅盤整計算期間(分鐘)");

if high \= q\_DailyHigh and {來到今日最高價}

KBarOfDay \> 30 and {今日至少有30根K棒交易}

TrueAll( AbsValue(Close\[1\]/Close\[2\]-1) \< 0.005,KBarOfDay-1) and{必需只有小波動}

AbsValue( Close\[1\]/Close\[KBarOfDay-1\]-1 ) \< 0.02

then ret=1;

---

## 場景 1180：尋找漲速在加快的股票 — 加權指數連漲了四天，讓我又想到當年在自營，被叫去參加學習之旅，認識的一個大戶(一大早起床遙想過去，我是老人無誤)，那位老兄可能錢賺多了，說話有點臭屁，他說股價的...

來源：[尋找漲速在加快的股票](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e6%bc%b2%e9%80%9f%e5%9c%a8%e5%8a%a0%e5%bf%ab%e7%9a%84%e8%82%a1%e7%a5%a8-2/) 說明：加權指數連漲了四天，讓我又想到當年在自營，被叫去參加學習之旅，認識的一個大戶(一大早起床遙想過去，我是老人無誤)，那位老兄可能錢賺多了，說話有點臭屁，他說股價的波動就像一部跑車，漲幅就是車速，成交量就是油門，要挑就要挑那種正在加速，油門一路催下去的股票，也就是連績三天漲幅一天比一天多，成交量也一天比一天多的股票，我拍他馬屁說，日本酒田戰法裡有個紅三兵，跟他的想法類似，他還吐槽我說，不一定要每天都收...

value1=(close-close\[1\])/close\[1\];

if value1\>value1\[1\]and value1\[1\]\>value1\[2\]

and trueall(value1\>0,3)

and trueall(volume\>volume\[1\],3)

and value1\<0.04

then ret=1;

---

## 場景 1181：大跌但主力大買超的股票 — 昨天台股成了外資提款機。這種時候，我個人會去找一些市場上不合理的地方，例如昨天大跌但主力卻買超的股票。 因為理論上昨天外資大賣，大部份的股票也大跌，但如果這時候...

來源：[大跌但主力大買超的股票](https://www.xq.com.tw/xstrader/%e5%a4%a7%e8%b7%8c%e4%bd%86%e4%b8%bb%e5%8a%9b%e5%a4%a7%e8%b2%b7%e8%b6%85%e7%9a%84%e8%82%a1%e7%a5%a8/) 說明：昨天台股成了外資提款機。這種時候，我個人會去找一些市場上不合理的地方，例如昨天大跌但主力卻買超的股票。 因為理論上昨天外資大賣，大部份的股票也大跌，但如果這時候主力出現買超，那會不會代表主力在趁利空吸納市場籌碼?於是，我寫了一個很簡單的腳本

value1=GetField("主力買賣超張數");

if value1\>0 and close\[1\]\>close\*1.02

then ret=1;

---

## 場景 1182：從連續數日的開盤委買張數，找有轉機的股票 — 以前在券商工作時，分公司常介紹些隱藏在民間的操盤公司給我們這些自營部的小鬼們認識，其中有位老杯有個獨門絕技\~挑開盤委買大增的小型股。他的邏輯是，開盤委買代表有人...

來源：[從連續數日的開盤委買張數，找有轉機的股票](https://www.xq.com.tw/xstrader/%e5%be%9e%e9%80%a3%e7%ba%8c%e6%95%b8%e6%97%a5%e7%9a%84%e9%96%8b%e7%9b%a4%e5%a7%94%e8%b2%b7%e5%bc%b5%e6%95%b8%ef%bc%8c%e6%89%be%e6%9c%89%e8%bd%89%e6%a9%9f%e7%9a%84%e8%82%a1%e7%a5%a8/) 說明：以前在券商工作時，分公司常介紹些隱藏在民間的操盤公司給我們這些自營部的小鬼們認識，其中有位老杯有個獨門絕技\~挑開盤委買大增的小型股。他的邏輯是，開盤委買代表有人經過一天的資訊消化及作完功課之後，決定買進某檔個股，如果這種人一夕暴增，而且這檔股票先前都在下跌或是盤整，那就代表這檔股票出現轉機。這次XQ改版把個股的開盤委買張數放進來讓我們可以拿來運算，我立馬寫了下面這個小程式

value1=GetField("開盤委買");

value2=average(value1,20);

value3=average(value1,5);

plot1(value2);

plot2(value3);

---

## 場景 1183：什麼樣的股票當天比較容易漲停板? — 昨天大盤漲的比較多，我試著拿比較多的樣本來印證一個古老的傳說\~開盤後十到三十分鐘內的分鐘k棒大多上漲的股票，尾盤收高的機率較大。這個傳說的理論是說，開盤後，上漲...

來源：[什麼樣的股票當天比較容易漲停板?](https://www.xq.com.tw/xstrader/%e4%bb%80%e9%ba%bc%e6%a8%a3%e7%9a%84%e8%82%a1%e7%a5%a8%e7%95%b6%e5%a4%a9%e6%af%94%e8%bc%83%e5%ae%b9%e6%98%93%e6%bc%b2%e5%81%9c%e6%9d%bf/) 說明：昨天大盤漲的比較多，我試著拿比較多的樣本來印證一個古老的傳說\~開盤後十到三十分鐘內的分鐘k棒大多上漲的股票，尾盤收高的機率較大。這個傳說的理論是說，開盤後，上漲比例高的股票，如果有一定的成交量，代表今天的買氣是佔上風。我找了昨天漲停的股票來看，扣除那些一開盤就拉上去的股票之外，後來才拉漲停的股票，確實有不少有這樣的現象。(見附圖)於是我翻出以前請公司高手寫的腳本，這個腳本適用於1分鐘到五分鐘K線，...

input:RisingbarsPercents(0.7); setinputname(1,"開盤起至少上漲期數比例");

input:ContBars(10); setinputname(2,"第幾根K棒時提醒");

variable:KBarOfDay(0); KBarOfDay+=1; if datedate\[1\] then KBarOfDay=1; //計算每天日內的Bar序數

if Date \= CurrentDate and KBarOfDay \>2 and //今天至少要有3根Bar

ContBars \= KBarOfDay and //今天開盤起算到現在第幾跟觸發

countif(close\>close\[1\] and close \> open,KBarOfDay)/KBarOfDay //收漲比例(包含開盤第一根是要漲)

\>=RisingBarsPercents

then ret=1;

---

## 場景 1184：私房交易策略之第一根長紅收最高

來源：[私房交易策略之第一根長紅收最高](https://www.xq.com.tw/xstrader/%e4%bb%80%e9%ba%bc%e8%82%a1%e7%a5%a8%e9%9a%94%e5%a4%a9%e6%9c%83%e9%96%8b%e9%ab%98/) 說明：我寫的選股腳本如下:

input:period(10);

input:percent(12);

setinputname(1,"計算漲跌幅區間");

setinputname(2,"漲跌幅上限");

if close\>=close\[1\]\*1.05

and close\*1.01\>high and close\<close\[period-1\]\*(1+percent/100)

then ret=1;

---

## 場景 1185：多頭重新啟動最佳進場點 — 從波浪理論來看,一個健康的上升走勢是:創新高,回檔,創新高。假設一檔股票是處在這樣的上升循環中,那這檔股票的價格,一定會穿越前波高點減去N%所畫出的一條線,我們...

來源：[多頭重新啟動最佳進場點](https://www.xq.com.tw/xstrader/%e5%a4%9a%e9%a0%ad%e9%87%8d%e6%96%b0%e5%95%9f%e5%8b%95%e6%9c%80%e4%bd%b3%e9%80%b2%e5%a0%b4%e9%bb%9e/) 說明：從波浪理論來看,一個健康的上升走勢是:創新高,回檔,創新高。假設一檔股票是處在這樣的上升循環中,那這檔股票的價格,一定會穿越前波高點減去N%所畫出的一條線,我們把這條線稱為”重新啟動線”。這條線的決定N%,通常設定在1個漲停板內是最為安全,因為只要再漲約7%就能創新高,整個波浪就相當明確\!\!當然,如果回檔天數太久,整個短期波浪的結構看起來就會顯得鬆散,所以還必需加個條件讓股價穿越重新啟動線的時間能...

var:iHigh(0); iHigh= maxlist(h,iHigh);

plot1(iHigh\*0.95,"重新發動線");

---

## 場景 1186：多頭重新啟動最佳進場點 — 警示:資料讀取61 最大引用1

來源：[多頭重新啟動最佳進場點](https://www.xq.com.tw/xstrader/%e5%a4%9a%e9%a0%ad%e9%87%8d%e6%96%b0%e5%95%9f%e5%8b%95%e6%9c%80%e4%bd%b3%e9%80%b2%e5%a0%b4%e9%bb%9e/) 說明：警示:資料讀取61 最大引用1

var:iHigh(0); iHigh= maxlist(h,iHigh);

var:iDate(0),StayHigh(true);

if iHigh \= High then iDate= Date;

if L \< iHigh\*0.85 then StayHigh \=false;

if StayHigh and DateDiff(Date,iDate)100 then ret=1;

---

## 場景 1187：Larry Williams 短線決勝關鍵點 — Larry Williams的著名著作”短線交易密訣”中提到一個非常重要的概念:當收盤上漲時,價格若處於強勢波動率收斂,當股價再創短期新高時,就是非常理想的進場...

來源：[Larry Williams 短線決勝關鍵點](https://www.xq.com.tw/xstrader/larry-williams-%e7%9f%ad%e7%b7%9a%e6%b1%ba%e5%8b%9d%e9%97%9c%e9%8d%b5%e9%bb%9e/) 說明：Larry Williams的著名著作”短線交易密訣”中提到一個非常重要的概念:當收盤上漲時,價格若處於強勢波動率收斂,當股價再創短期新高時,就是非常理想的進場點, 反之則為空點\!這樣的概念可能有點抽象,讓我們來情境試想:有一檔股票正在漲,昨天的波動率假設是2,今天又上漲了,而且今天收盤價和最低價的距離只有不到1,這表示往下去的力道已經收斂掉了,當這樣的情況出現,如果股價突然衝過這兩天的高點,那就...

vars: \_MarketPosition(0);

Condition1 \= Close \> Close\[1\] and (Close-Low) \<= 0.5\*(High\[1\]-Low\[1\]);

Condition2 \= Close \< Close\[1\] and (High-Close) \<= 0.5\*(High\[1\]-Low\[1\]);

{整個策略非常單純,上面兩行僅判斷波動率,下面則是部位判斷與停損點的設定}

if \_MarketPosition maxlist(H\[1\],H\[2\]) then

begin

plot4(C\*1.01 ,"作多");

plot5(C\*1.02);plot6(C\*1.03);plot7(C\*1.04);

plot8(C\*1.05);plot9(C\*1.06);plot10(C\*1.07);

\_MarketPosition=1;

value1 \=minlist(L\[1\],L\[2\]);

end;

if C cross over value2 and \_MarketPosition=-1 then

begin

plot4(C\*1.01 ,"回補");

\_MarketPosition=0;

end;

end

else if \_MarketPosition \>-1 then

begin

if condition2\[1\] and C Close\[1\] and (Close-Low) \<= 0.5\*(High\[1\]-Low\[1\]);

Condition2 \= Close \< Close\[1\] and (High-Close) \<= 0.5\*(High\[1\]-Low\[1\]);

if \_MarketPosition maxlist(H\[1\],H\[2\]) then

begin

ret=1;

value1 \=minlist(L\[1\],L\[2\]);

end;

if C cross over value2 and \_MarketPosition=-1 then

begin

\_MarketPosition=0;

end;

end

else if \_MarketPosition \>-1 then

begin

if condition2\[1\] and C \< minlist(L\[1\],L\[2\]) then

begin

\_MarketPosition=-1;

value2 \= maxlist(H\[1\],H\[2\]) ;

end;

if C cross under value1 and \_MarketPosition=1 then

begin

\_MarketPosition=0;

end;

end;

---

## 場景 1188：價量齊揚 — 在多頭緩起步的時候,經常會考慮的的一種常見型態就是”價量齊揚”\!大部份的時候,都是看到了某檔股票上漲,然後回去找那檔股票是否曾經發生這樣的情況? 而又總是在模陵...

來源：[價量齊揚](https://www.xq.com.tw/xstrader/%e5%83%b9%e9%87%8f%e9%bd%8a%e6%8f%9a/) 說明：在多頭緩起步的時候,經常會考慮的的一種常見型態就是”價量齊揚”\!大部份的時候,都是看到了某檔股票上漲,然後回去找那檔股票是否曾經發生這樣的情況? 而又總是在模陵兩可的情況下對股票做出判斷,導致每次的標準不一,而難以做出最適當的應對方法\!這樣其實是非常可惜的\! 當在做股票研究時,可能發現到的一些蛛絲馬跡和現象,常會因為這樣沒有一個完整的方法而錯失了千載難逢的好策略\! 所以我們需要像在實驗室裡一樣,準...

var:PriceGrad(false),VolGrad(false);

input:P1(3),P2(1.5);

setinputname(1,"期數");

setinputname(2,"放量上限倍");

PriceGrad \= TrueAll(H\>H\[1\] and L\>L\[1\] and C\>C\[1\] and C\>O ,P1);

VolGrad \= TrueAll(V\> V\[1\] and V\<V\[1\]\*P2 ,P1);

if PriceGrad and VolGrad then ret=1;

---

## 場景 1189：主力成本線 — 在外資或是主要控盤者的操作方法裡,有個相當重要的下單法,叫做冰山單\!意思是,雖然你看到了小小一塊,其實隱藏了非常大的一個部位在裡面\!這要怎麼做到呢? 其實就是把...

來源：[主力成本線](https://www.xq.com.tw/xstrader/%e4%b8%bb%e5%8a%9b%e6%88%90%e6%9c%ac%e7%b7%9a/) 說明：在外資或是主要控盤者的操作方法裡,有個相當重要的下單法,叫做冰山單\!意思是,雖然你看到了小小一塊,其實隱藏了非常大的一個部位在裡面\!這要怎麼做到呢? 其實就是把單子拆的很散,讓一般人著實看不出來\! 如果今天某大券商要買1000張台積電,使用了這個方法,在盤中每10秒都掛2張買進,不僅不容易被發現,如果間隔時間和單量都會小幅變動,那真的是很難猜得出來是不是有大戶在收,特別在這種大單很容易被狙擊的行情...

var:DayAvgPrice(0);DayAvgPrice \= GetField("成交金額")/v/1000;

---

## 場景 1190：下殺反彈創新高 — 在短期搶股票的招式裡有一招,在股市高手圈普遍被使用,尤其是在跌深後再出現重大利空的時候,特別容易有效\!狀況是這樣,當市場跌了很久,有一天所有利空齊發,今天開盤前...

來源：[下殺反彈創新高](https://www.xq.com.tw/xstrader/%e4%b8%8b%e6%ae%ba%e5%8f%8d%e5%bd%88%e5%89%b5%e6%96%b0%e9%ab%98/) 說明：在短期搶股票的招式裡有一招,在股市高手圈普遍被使用,尤其是在跌深後再出現重大利空的時候,特別容易有效\!狀況是這樣,當市場跌了很久,有一天所有利空齊發,今天開盤前大家都在挫著等的時候,盤開出來了,開小低,大家想說,快啊\! 有好價格,開始丟股票\!\! 一陣下殺後,突然出現買盤一路拉升,還拉過平盤價\!讓K棒由原本的黑K變為紅K\! 這時候眼尖的人很快發現這機會就會先卡位進場,只要指數回穩,馬上就會再拉升衝高...

RET= CurrentTime \< 93000 and O C\[1\]\*0.96 and Low O and C \=H and Volume \> V\[1\] \*TimeDiff(CurrentTime,90000,"M")/270;

---

## 場景 1191：漲多後的長上影線 — ‪\#‎上影線的高度決定回檔的深度‬\!我們看台苯的走勢,在1月9日這天發生了超大幅振盪\!創下一年新高價的上影線就像東京鐵塔一樣站在股價高點\! 根據策略理論我們必需...

來源：[漲多後的長上影線](https://www.xq.com.tw/xstrader/%e6%bc%b2%e5%a4%9a%e5%be%8c%e7%9a%84%e9%95%b7%e4%b8%8a%e5%bd%b1%e7%b7%9a/) 說明：‪\#‎上影線的高度決定回檔的深度‬\!我們看台苯的走勢,在1月9日這天發生了超大幅振盪\!創下一年新高價的上影線就像東京鐵塔一樣站在股價高點\! 根據策略理論我們必需把這天的低點記下來,而非直接賣出\! 記下了這個低點當做空方關鍵價以後,三天內果然就穿價跌破,這時觸發的空方訊號就得特別注意\!小型急漲股的反轉更是明顯,行情是來的快,去的也快\!\!警示的腳本可以這樣寫

variable:Kprice(0);

if H\>O\*1.03 and C \<O and H \= Highest(H,255) then Kprice \= L;

ret= c crosses below Kprice;

---

## 場景 1192：小型股開高不拉回 — XS在加入選股中心這個新的選股功能之後，我們終於可以先用一些財報相關的欄位篩選出特定的族群，然後再用策略雷達，讓電腦在這些特定族群盤中出現某些特定走勢時，發出訊...

來源：[小型股開高不拉回](https://www.xq.com.tw/xstrader/%e5%b0%8f%e5%9e%8b%e8%82%a1%e9%96%8b%e9%ab%98%e4%b8%8d%e6%8b%89%e5%9b%9e/) 說明：XS在加入選股中心這個新的選股功能之後，我們終於可以先用一些財報相關的欄位篩選出特定的族群，然後再用策略雷達，讓電腦在這些特定族群盤中出現某些特定走勢時，發出訊號來通知我們。未來我會陸續舉例跟大家報告選股中心+策略雷達可以帶給我們在操作上什麼樣的便利與應用。今天先跟大家介紹”開高後不拉回的中小型股” 這樣的組合這個策略的概念如下:“反常必有妖” ，平常沒啥人留意的中小型股，如果突然開高，一般代表有...

input:sp(1,"回檔最大幅度");

input:opl(2,"開高最小幅度");

if time\>0905//時間超過九點零五分

then

begin

if open\>=close\[1\]\*(1+opl/100)//開高超過最小幅度

and close\>open\*(1-sp/100)//股價拉回幅度有限

and close=high//目前在今日最高點

and close\[1\]\<close\[3\]\*1.04//前三天漲幅不到4%

then ret=1;

end;

---

## 場景 1193：合理的本益比跟盈餘品質與成長力有關 — “為啥這兩檔股票EPS一模一樣，但股價差這麼多?”經常被問到這樣的問題。扣掉那些人為炒作的因素，我的經驗是盈餘愈穩定的，以及盈餘成長能見度愈高的，可以享有的合理...

來源：[合理的本益比跟盈餘品質與成長力有關](https://www.xq.com.tw/xstrader/%e5%90%88%e7%90%86%e7%9a%84%e6%9c%ac%e7%9b%8a%e6%af%94%e8%b7%9f%e7%9b%88%e9%a4%98%e5%93%81%e8%b3%aa%e8%88%87%e6%88%90%e9%95%b7%e5%8a%9b%e6%9c%89%e9%97%9c/) 說明：“為啥這兩檔股票EPS一模一樣，但股價差這麼多?”經常被問到這樣的問題。扣掉那些人為炒作的因素，我的經驗是盈餘愈穩定的，以及盈餘成長能見度愈高的，可以享有的合理本益比就愈高。相反的，那些今年大賺，明年大虧的公司，以及那些數年來盈餘數字都未見成長的公司，市場給的本益比就比較低。現在有了XS，我們可以用敘述式來呈現這兩個概念，例如我們如果要找那些盈餘品質不錯，過去五年營業利益成長率都沒有衰退超過5%的...

value1=GetField("營業利益成長率","Y");

if trueall(value1\>-0.05,5) then ret=1;

---

## 場景 1194：合理的本益比跟盈餘品質與成長力有關 — 如果我們要找連續五年營收都比前一年成長的公司我們可以這麼寫

來源：[合理的本益比跟盈餘品質與成長力有關](https://www.xq.com.tw/xstrader/%e5%90%88%e7%90%86%e7%9a%84%e6%9c%ac%e7%9b%8a%e6%af%94%e8%b7%9f%e7%9b%88%e9%a4%98%e5%93%81%e8%b3%aa%e8%88%87%e6%88%90%e9%95%b7%e5%8a%9b%e6%9c%89%e9%97%9c/) 說明：如果我們要找連續五年營收都比前一年成長的公司我們可以這麼寫

value2=GetField("營收成長率","Y");

if trueall(value2\>0,5)

then ret=1;

---

## 場景 1195：從預估量方向預測未來漲跌 — 一直以來都有個困擾,今天看著大盤個預估量上上下下,好像有點感覺,可是又不確定該怎麼用?大盤上漲的時候,今天預估量是不是也跟著上升? 還是反而下降了,使得漲勢停滯...

來源：[從預估量方向預測未來漲跌](https://www.xq.com.tw/xstrader/%e5%be%9e%e9%a0%90%e4%bc%b0%e9%87%8f%e6%96%b9%e5%90%91%e9%a0%90%e6%b8%ac%e6%9c%aa%e4%be%86%e6%bc%b2%e8%b7%8c/) 說明：一直以來都有個困擾,今天看著大盤個預估量上上下下,好像有點感覺,可是又不確定該怎麼用?大盤上漲的時候,今天預估量是不是也跟著上升? 還是反而下降了,使得漲勢停滯不前?還好現在有XS\!終於有了個解決的方法,除了可以統計今天一整天的預估量變化,還可以清楚看出來盤勢的動能強弱與否\!先下載這個檔按匯入XQ後我們就可以開工囉\![https://www.dropbox.com/s/hs1mxyp5rqcgvnn](https://www.dropbox.com/s/hs1mxyp5rqcgvnn)...

var:cVol(0),bil(100000000);

if DateDate\[1\] then cVol \= V else cVol \+=V;

plot1(cVol/bil,"累計成交量(億)");

plot2(cVol\*prevolumex(time)/bil,"預估成交量(億)");

---

## 場景 1196：預估個股的成交量 — 要預估個股的成交量,比起預估一群股票的總成交量難很多\!特定個股的成交因為會受到某些力量的推動,使得在預估上更加困難,所以我們只能選擇一個比較圓滑的方式來做\!預估...

來源：[預估個股的成交量](https://www.xq.com.tw/xstrader/%e9%a0%90%e4%bc%b0%e5%80%8b%e8%82%a1%e7%9a%84%e6%88%90%e4%ba%a4%e9%87%8f/) 說明：要預估個股的成交量,比起預估一群股票的總成交量難很多\!特定個股的成交因為會受到某些力量的推動,使得在預估上更加困難,所以我們只能選擇一個比較圓滑的方式來做\!預估出來的值當然和演算計算方法有著絕對的關係,不同人寫出來的當然預估值可能會有極大的差異\! 我們在這邊提供一個概念簡單的方式讓大家比較能快速了解\!\!預估通常的做法就是拿過去一段時間的資料來做未來的預測,這段期間的長短也成為了預估值的關鍵因素\! ...

var:cVol(0),barCount(0),DayBarCount(0),PV(0);

if Date=Date\[1\] then begin cVol \= V; 

 barCount=1; 

 end else begin cVol+=v; 

 barCount+=1; 

 end;

DayBarCount \= maxlist(DayBarCount,barCount);

PV \= cVol \+ (DayBarCount-barCount)\*average(v,1350);

plot1(PV,"個股成交量預估");

---

## 場景 1197：預估漲跌幅%\! — 這裡很重要的一件事: 這種預估方法是利用歷史資料統計出來的結果,有點像是天氣預報一樣,不可能出現今天收盤就是會漲個幾%的這種情況\!呈現的概念會是: 降雨0 mm...

來源：[預估漲跌幅%\!](https://www.xq.com.tw/xstrader/%e9%a0%90%e4%bc%b0%e6%bc%b2%e8%b7%8c%e5%b9%85/) 說明：這裡很重要的一件事: 這種預估方法是利用歷史資料統計出來的結果,有點像是天氣預報一樣,不可能出現今天收盤就是會漲個幾%的這種情況\!呈現的概念會是: 降雨0 mm 機率是 80%, 降雨100mm以內機率是20%,這樣我們就能推斷出來說:喔\~ 今天很有可能會是個大晴天,如果有雨,也只是飄一點點\!這樣一來至少我們就知道說應該是不用帶雨傘出門\!但是,絕對不是說,今天不會下雨ㄟ\! 這就是預測原理,各位看官...

array:Run\[15,15\](0);

var: xLevel(0),i(0),sumx(0),qLevel(0),MaxCount(0);

if C\[0\]/C\[1\]-1 \< \-0.06 then xLevel \= 0 else

if C\[0\]/C\[1\]-1 \< \-0.05 then xLevel \= 1 else

if C\[0\]/C\[1\]-1 \< \-0.04 then xLevel \= 2 else

if C\[0\]/C\[1\]-1 \< \-0.03 then xLevel \= 3 else

if C\[0\]/C\[1\]-1 \< \-0.02 then xLevel \= 4 else

if C\[0\]/C\[1\]-1 \< \-0.01 then xLevel \= 5 else

if C\[0\]/C\[1\]-1 \< 0.00 then xLevel \= 6 else

if C\[0\]/C\[1\]-1 \< 0.01 then xLevel \= 7 else

if C\[0\]/C\[1\]-1 \< 0.02 then xLevel \= 8 else

if C\[0\]/C\[1\]-1 \< 0.03 then xLevel \= 9 else

if C\[0\]/C\[1\]-1 \< 0.04 then xLevel \= 10 else

if C\[0\]/C\[1\]-1 \< 0.05 then xLevel \= 11 else

if C\[0\]/C\[1\]-1 \< 0.06 then xLevel \= 12 else xLevel \=13;

Run\[xLevel\[1\],xLevel\]+=1;

sumx=0; MaxCount=0; qLevel=-1;

for i \= 0 to 13

begin

sumx+=Run\[xLevel\[1\],i\];

MaxCount \=MaxList(Run\[xLevel\[1\],i\],MaxCount);

if MaxCount \= Run\[xLevel\[1\],i\] then qLevel \=i;

end;

Plot1 (100\*Run\[xLevel\[1\], 0 \]/sumx,"下跌超過 6%機率");

Plot2 (100\*Run\[xLevel\[1\], 1 \]/sumx,"下跌5\~ 6%機率");

Plot3 (100\*Run\[xLevel\[1\], 2 \]/sumx,"下跌4\~ 5%機率");

Plot4 (100\*Run\[xLevel\[1\], 3 \]/sumx,"下跌3\~ 4%機率");

Plot5 (100\*Run\[xLevel\[1\], 4 \]/sumx,"下跌2\~ 3%機率");

Plot6 (100\*Run\[xLevel\[1\], 5 \]/sumx,"下跌1\~ 2%機率");

Plot7 (100\*Run\[xLevel\[1\], 6 \]/sumx,"下跌0\~ 1%機率");

Plot8 (100\*Run\[xLevel\[1\], 7 \]/sumx,"上漲0\~ 1%機率");

Plot9 (100\*Run\[xLevel\[1\], 8 \]/sumx,"上漲1\~ 2%機率");

Plot10 (100\*Run\[xLevel\[1\], 9 \]/sumx,"上漲2\~ 3%機率");

Plot11 (100\*Run\[xLevel\[1\], 10 \]/sumx,"上漲3\~ 4%機率");

Plot12 (100\*Run\[xLevel\[1\], 11 \]/sumx,"上漲4\~ 5%機率");

Plot13 (100\*Run\[xLevel\[1\], 12 \]/sumx,"上漲5\~ 6%機率");

Plot14 (100\*Run\[xLevel\[1\], 13 \]/sumx,"上漲6\~ 以上機率");

---

## 場景 1198：布林通道指標 — 前兩天看到了週刊上一個成功的投資故事，故事的主角先前不管透過基本面，技術面，在股票操作上一直都是虧錢，後來他覺得採取科學的精神，透過統計學常態分配的原理，用兩個...

來源：[布林通道指標](https://www.xq.com.tw/xstrader/%e5%b8%83%e6%9e%97%e9%80%9a%e9%81%93%e6%8c%87%e6%a8%99/) 說明：前兩天看到了週刊上一個成功的投資故事，故事的主角先前不管透過基本面，技術面，在股票操作上一直都是虧錢，後來他覺得採取科學的精神，透過統計學常態分配的原理，用兩個標準差做為他進出的依據，他的邏輯是股價的波動也是一種常態分配，有95%的機率股價會落在平均值加減兩個標準差的區間裡，所以如果股價突破兩個標準差，就算是超漲，可以獲利了結，跌破兩個標準差，那就是超跌，應該逢低承接。他說自從他改成使用這種統計上...

Input: price(numericseries), length(numericsimple), \_band(numericsimple);

BollingerBand \= Average(price, length) \+ \_band \* StandardDev(price, length, 1);

---

## 場景 1199：布林通道指標 — 意思是說BolingerBand是移動平均加上N個標準差。然後我們用以下的腳本在畫布林軌道線

來源：[布林通道指標](https://www.xq.com.tw/xstrader/%e5%b8%83%e6%9e%97%e9%80%9a%e9%81%93%e6%8c%87%e6%a8%99/) 說明：意思是說BolingerBand是移動平均加上N個標準差。然後我們用以下的腳本在畫布林軌道線

input: Length(20), UpperBand(2), LowerBand(2);

variable: up(0), down(0), mid(0);

SetInputName(1, "天數");

SetInputName(2, "上");

SetInputName(3, "下");

up \= bollingerband(Close, Length, UpperBand);

down \= bollingerband(Close, Length, \-1 \* LowerBand);

mid \= (up \+ down) / 2;

---

## 場景 1200：粒子學說指標 — 我們都知道空氣中存在著氧分子和氮分子,這些分子其實是存在空間中的小粒子,雖然看不到,不過會因為地點,氣溫和高度的不同,使得分子中蘊含不同的能量,我們呼吸起來的感...

來源：[粒子學說指標](https://www.xq.com.tw/xstrader/%e7%b2%92%e5%ad%90%e5%ad%b8%e8%aa%aa%e6%8c%87%e6%a8%99/) 說明：我們都知道空氣中存在著氧分子和氮分子,這些分子其實是存在空間中的小粒子,雖然看不到,不過會因為地點,氣溫和高度的不同,使得分子中蘊含不同的能量,我們呼吸起來的感覺也就不一樣！就好像在喜馬拉雅山上呼吸起來特別困難,因為空間中的氧粒子密度低\!嘗試著把這樣的概念應用到時間序列裡,我們把最近的100根K棒拿來當做是個股最近一段時間的”狀態”表徵,然後建立起一套評估標準,看看這檔股票的”活力”是不是足夠\!1...

var:Dirt(0); Dirt \= CountIf(C\>C\[1\],100);

var:Heat(0); Heat \= countif( GetField("成交金額") \> average(GetField("成交金額"),100),100);

var:Vola(0); Vola \= CountIf( (H-L)\> average(H-L,100),100);

var:Eng(0); Eng \= Dirt+Heat+Vola-150;

---

## 場景 1201：粒子學說指標

來源：[粒子學說指標](https://www.xq.com.tw/xstrader/%e7%b2%92%e5%ad%90%e5%ad%b8%e8%aa%aa%e6%8c%87%e6%a8%99/)

//指標

plot1(Dirt,"方向度");

plot2(Heat,"熱絡度");

plot3(Vola,"波動度");

plot4( Eng,"能量");

---

## 場景 1202：原子激態法找即將爆發個股 — 幾天前交易所宣布新制,放寬台灣普通股漲跌幅限制,大家該不該因此對行情有所期待呢? 答案很明顯\!我們知道加權指數成份股中1成的股票經常佔全部8成的成交量,而這1成...

來源：[原子激態法找即將爆發個股](https://www.xq.com.tw/xstrader/%e5%8e%9f%e5%ad%90%e6%bf%80%e6%85%8b%e6%b3%95/) 說明：幾天前交易所宣布新制,放寬台灣普通股漲跌幅限制,大家該不該因此對行情有所期待呢? 答案很明顯\!我們知道加權指數成份股中1成的股票經常佔全部8成的成交量,而這1成的股票,大多都是大型股,一整年都不知道會不會看到一次漲停板或跌停板? 而其它冷門的股票漲跌停出現時相對的風險也會大大提高\!對於一個投資者而言,獲利是來自股價波動,而不是股價限制,不然的話,去做美股就好了,因為如果照這個理論,只要沒有漲跌停限...

variable:Dv(0),;

if date Date\[1\] then begin Dv=v; end else begin

if date \= currentdate and time 0.05 and

(dv+v)\*1000/q\_CurrentShareCapital \> 2/1000 and

v\*1000/ q\_CurrentShareCapital \> 2/10000 then ret=1;

dv+=v;

end;

---

## 場景 1203：多方強力發動首選‬ — 我們都知道開盤價是一個很好的多空力參考價\! 而要怎麼利用的方法我們之前也提過很多不同類型\!今天要介紹的是一個短期多方強力發動的典型,屬於快速賺到價差的短進短出法...

來源：[多方強力發動首選‬](https://www.xq.com.tw/xstrader/508/) 說明：我們都知道開盤價是一個很好的多空力參考價\! 而要怎麼利用的方法我們之前也提過很多不同類型\!今天要介紹的是一個短期多方強力發動的典型,屬於快速賺到價差的短進短出法,使用上最好是能搭配XQTrade讓訊號跳出來以後能快速下單,這樣才比較能迎刃有餘的抓到每個機會\!這個警示腳本如下 請搭配日線

var:High3(0),High5(0);

High3 \= highest(high\[1\],3);

High5 \= highest(high\[1\],5);

condition1= Close \> Open and Open \> High3 and Close \>High5;

if condition1 \=true and condition1\[1\] \=false and volume \>100 then ret=1;

---

## 場景 1204：歷史沈降法 — 有的時候就是需要等待\! 但是聰明的人不會讓等待成為空白\!以前在實驗室常常會有這樣的需求,做液態層析時,得把原始的樣本品倒入一個管柱裡面,然後開始漫常的等待\!這個...

來源：[歷史沈降法](https://www.xq.com.tw/xstrader/%e6%ad%b7%e5%8f%b2%e6%b2%88%e9%99%8d%e6%b3%95/) 說明：有的時候就是需要等待\! 但是聰明的人不會讓等待成為空白\!以前在實驗室常常會有這樣的需求,做液態層析時,得把原始的樣本品倒入一個管柱裡面,然後開始漫常的等待\!這個樣品會從管柱的頂端慢慢往下流,最下面拿個杯子接我們要的東西\! 通常做完一輪都要好幾個小時\!這時候如果就在管子前面等待,真的很悶\! 所以通常都會找點事情做,譬如說再開一個管子來做,這樣事情就會變得有效率一些\!\!這有點像買股票,看好了某一檔個股...

variable:NewHigh(false); Newhigh= C \>highest(h\[1\],20);

---

## 場景 1205：歷史沈降法 — 再來就是當創新高後我們才去算看看是不是粒子沉降了\! 這裡我們把每天的平均高低點差當做是沉降的標準,差很大就是還浮很高,差越小就是沉很低了\! 加上第一步的條件和成...

來源：[歷史沈降法](https://www.xq.com.tw/xstrader/%e6%ad%b7%e5%8f%b2%e6%b2%88%e9%99%8d%e6%b3%95/) 說明：再來就是當創新高後我們才去算看看是不是粒子沉降了\! 這裡我們把每天的平均高低點差當做是沉降的標準,差很大就是還浮很高,差越小就是沉很低了\! 加上第一步的條件和成交量至少一百張:

if newhigh and volume\>100 and

average(h\[1\]-L\[1\],3) \< average(h\[1\]-L\[1\],5) and

average(h\[1\]-L\[1\],5) \< average(h\[1\]-L\[1\],10) and

average(h\[1\]-L\[1\],10) \< average(h\[1\]-L\[1\],20) then ret=1;

---

## 場景 1206：積極勁道指標 — 我照著這個想法寫了一個腳本如下:

來源：[積極勁道指標](https://www.xq.com.tw/xstrader/%e7%a9%8d%e6%a5%b5%e5%8b%81%e9%81%93%e6%8c%87%e6%a8%99/) 說明：我照著這個想法寫了一個腳本如下:

input:days(13);

value1=GetField("外盤量");

value6=getfield("內盤量");

value2=volume\*(close-close\[1\]);

if value6\<\>0

then value7=(value1/value6)\*volume\*(close-close\[1\]);

value4=average(value2,days);

value5=average(value7,days);

plot1(value4,"勁道指標");

plot2(value5,"積極勁道指標");

---

## 場景 1207：xslope速度指標 — 就可以找出現在股價的速度了\!\! Xslope 正的就是上漲,負的就是下跌 這個linearregslope 就是讓我們找出這一段期間的股價變化趨勢 第一個輸入是...

來源：[xslope速度指標](https://www.xq.com.tw/xstrader/495/) 說明：就可以找出現在股價的速度了\!\! Xslope 正的就是上漲,負的就是下跌 這個linearregslope 就是讓我們找出這一段期間的股價變化趨勢 第一個輸入是 資料 .用(H+L)/(H+L)\[20\] ,是現在高低點平均除上20期前的高低點平均,這樣所有股票都會被標準化而不會有難以判斷的情況 第二個輸入是期數,我們利用最近20期(日)來看\! 我們先利用指標來作圖

plot1(Xslope,"方向速度" );

plot2(Xslope-Xslope\[1\],"速度變化");

---

## 場景 1208：F-Score選股法 — 在價值投資界，有位叫Joseph D. Piotroski 的老兄，他寫過一篇文章，文章的題目叫作Value Investing: The Use of His...

來源：[F-Score選股法](https://www.xq.com.tw/xstrader/f-score%e9%81%b8%e8%82%a1%e6%b3%95/) 說明：在價值投資界，有位叫Joseph D. Piotroski 的老兄，他寫過一篇文章，文章的題目叫作Value Investing: The Use of Historical Financial Statement Information to Separate Winners from Losers中文我是翻成”價值投資之透過財報分辨出贏家及輸家”。在這篇文章中他用財報的一些指標，採取計分卡的方...

value1=GetField("資產報酬率","Q");

value2=GetField("來自營運之現金流量","Q");//單位百萬

value3=GetField("本期稅後淨利","Q");//單位百萬

value5=GetField("負債比率","Q");

value6=GetField("流動比率","Q");

value7=GetField("現金增資佔股本比重","y");

value8=GetField("營業毛利率","Q");

value9=GetField("總資產週轉率(次)","Q");

var:score(0);

score=0;

if value1\>0 then score=score+1;

if value1-value1\[3\]\>0 then score=score+1;

if value2\>0 then score=score+1;

if value3\>value2 then score=score+1;

if value5value6\[3\] then score=score+1;

if value7value8\[3\] then score=score+1;

if value9\>value9\[3\] then score=score+1;

if score\>=8

then ret=1;

---

## 場景 1209：什麼股票? 什麼前提下漲停的股票還可以留意? — 我試著寫了一個腳本來符合上述的描述

來源：[什麼股票? 什麼前提下漲停的股票還可以留意?](https://www.xq.com.tw/xstrader/%e7%ac%ac%e4%b8%80%e6%a0%b9%e6%bc%b2%e5%81%9c%e7%9a%84%e7%ad%96%e7%95%a5/) 說明：我試著寫了一個腳本來符合上述的描述

{先列出需要用到的參數與變數}

input:Length(180);

variable:i(0),R1(0),R2(0),D1(0),D2(0);R1=0;R2=0;

{過去一段時間以來}

for i \= Length downto 1

begin

{有漲停的日子就記1,記下最後漲停的日期}

if C\[i-1\] \=uplimit(C\[i\]) then begin R1 \+=1; D1= Date\[i-1\]; end;

{有跌停的日子就記1,記下最後跌停的日期}

if C\[i-1\] \= dwlimit(C\[i\]) then begin R2 \+=1; D2 \=Date\[i-1\]; end;

end;

{漲停的日子要比跌停的多 }

condition1 \= R1-R2 \> 0;

{距離上次漲停不能太久, }

condition2 \= DateDiff(Date,D1) \<= 10;

{上次漲停跟上上次漲停之間隔的要夠久}

condition3=datediff(d1,d1\[1\])\>30;

if condition1 and condition2 and condition3  

then ret=1;

---

## 場景 1210：尋找波動放大的股票 — 買賣股票常常會遇到一個大問題\! 就是:我買的股票怎麼都不會動?\!我們用一個很熟悉的概念來看,當物體是靜止的時候,要將它推動必需要抵消掉最大靜磨擦力所產生的反作用...

來源：[尋找波動放大的股票](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e6%b3%a2%e5%8b%95%e6%94%be%e5%a4%a7%e7%9a%84%e8%82%a1%e7%a5%a8/) 說明：買賣股票常常會遇到一個大問題\! 就是:我買的股票怎麼都不會動?\!我們用一個很熟悉的概念來看,當物體是靜止的時候,要將它推動必需要抵消掉最大靜磨擦力所產生的反作用力才能夠讓物體開始移動,而當物體開始移動,這時摩擦力會變小,我們只需要克服一個動態摩擦力就能夠讓物體運動了\!在股價的運動上也很類似,當股價是在一個小幅波動類似靜止的狀態時,要去推動他所消耗的力量是很大的,所以許多剛開始發動的股票,一定都會噴...

value1 \= highest(h,20)/ lowest(l,20);

value2 \= highest(h,60) / lowest(l,60);

value3 \= highest(h,180) / lowest(l,180);

outputfield1(value1);setoutputname1("月波動");

outputfield2(value2);setoutputname2("季波動");

outputfield3(value3);setoutputname3("半年波動");

if value1\>1.15 and {月波動在15%以上}

value3\> value2 and value2 \>value1 and {波動放大要穩定}

C\>C\[20\] and C\>C\[60\] and C\>C\[180\] and {明確多頭趨勢}

C\> 10 and V\>100 then ret=1;

---

## 場景 1211：追蹤熱門股 — 買股票有兩個基本模式,一是長時間慢慢買進績優的冷門股,等到有一天冷門股爆發成為了熱門股,股價波動大幅增加,就可以伺機出個好價錢,歡喜豐收\!這種方法還算不錯,唯一...

來源：[追蹤熱門股](https://www.xq.com.tw/xstrader/%e8%bf%bd%e8%b9%a4%e7%86%b1%e9%96%80%e8%82%a1/) 說明：買股票有兩個基本模式,一是長時間慢慢買進績優的冷門股,等到有一天冷門股爆發成為了熱門股,股價波動大幅增加,就可以伺機出個好價錢,歡喜豐收\!這種方法還算不錯,唯一的缺點是整個操作的週期會非常長,甚至可能會超過一年\!\!所以會有第二種方法,就是專門交易那些已經成為熱門股的標的\! 我們都知道成交量會推動價格,熱門的股票,才會有獲利的契機\! 當然這方法也不是沒缺點,因為在成為熱門股之前,價格可能已經推升了一...

if v\>100 and {量要足}

GetField("資金流向") \> 0.001 and {要佔交易所總成交值的千分之一以上}

GetField("資金流向") \> GetField("資金流向")\[1\]\*3 {資金流突然大增為三倍}

then ret=1;

---

## 場景 1212：月賺八萬選股法 — 每個月賺八萬元的交易策略怎麼寫?今周刊最近有一篇很紅的文章，寫的是一位投資部落客的故事，連結如下:[http://www.businesstoday.com.tw](http://www.businesstoday.com.tw)...

來源：[月賺八萬選股法](https://www.xq.com.tw/xstrader/%e6%9c%88%e8%b3%ba%e5%85%ab%e8%90%ac%e9%81%b8%e8%82%a1%e6%b3%95/) 說明：每個月賺八萬元的交易策略怎麼寫?今周刊最近有一篇很紅的文章，寫的是一位投資部落客的故事，連結如下:[http://www.businesstoday.com.tw/article-content-80402-114064這位高人，他的做法是長期投資高股息的個股，選對標的，定期追蹤。文章中有提到他的決策流程1.從年報中挑出好股票。所謂的好股票，他列了五個條件a.本業獲利占比在八成以上b.自由現金流量大](http://www.businesstoday.com.tw/article-content-80402-114064這位高人，他的做法是長期投資高股息的個股，選對標的，定期追蹤。文章中有提到他的決策流程1.從年報中挑出好股票。所謂的好股票，他列了五個條件a.本業獲利占比在八成以上b.自由現金流量大)...

value1=GetField("營業利益","Q");//單位百萬

value2=GetField("稅前淨利","Q");//單位百萬

value3=GetField("來自營運之現金流量","Q");//單位百萬

value4=GetField("資本支出金額","Q");//單位百萬

value5=GetField("利息支出","Q");//單位百萬

value6=GetField("所得稅費用","Q");//單位百萬

condition1=false;

condition2=false;

condition3=false;

if value2\>0

then begin

if value1/value2\*100\>80

then condition1=true; //本業獲利佔八成以上

end;

if value3-value4-value5-value6\>0 //自由現金流量大於零

then condition2=true;

value7=GetField("利息保障倍數","Y");

value8=GetField("股東權益報酬率","Y");//單位%

value9=GetField("營業利益率","Q");//單位%

value10=GetField("本益比","D");

value11=GetField("殖利率","D");

value12=GetField("每股淨值(元)","Q");

value13=value12\*value8/8;//獲利能力比率

if value7\>20 and value8\>8 and value9\>0 and value10\<12 and value11\>6 and close\<value13

then condition3=true;

if condition1 and condition2 and condition3

then ret=1;

---

## 場景 1213：波動分析指標 — 市場裡賺錢的機會看似很多,真正能夠抓得到的卻很少\! 但是透過特定的工具,把好不容易發生的機會逮住,以適當的商品操作,就能夠有超額的暴利\!\!每天行情波動時大時小,...

來源：[波動分析指標](https://www.xq.com.tw/xstrader/475/) 說明：市場裡賺錢的機會看似很多,真正能夠抓得到的卻很少\! 但是透過特定的工具,把好不容易發生的機會逮住,以適當的商品操作,就能夠有超額的暴利\!\!每天行情波動時大時小,看到後來真的會很懶神\!為了讓我們的操作能發揮最大的效果,一定要分配一筆專門用來博10倍的資金就擺在那,搭配上XS每日定時啟動,一但發生立刻通知進場\!\!要怎麼做呢? 先說一下原理: 市場就像個橡皮球一樣,有壓縮有膨脹,如果經過不斷擠壓,壓縮到...

var: xHL(0);

xHL \=highest(H,20)-Lowest(L,20);

---

## 場景 1214：波動分析指標

來源：[波動分析指標](https://www.xq.com.tw/xstrader/475/)

plot1(xHL,"月區間" );

plot2(average(C,20)\*0.035,"月均低限" );

plot3(200,"x冷凍線");

---

## 場景 1215：跳島除權策略 — 用XS寫選股腳本，一共有四個選股條件，其中本業預估EPS，我是用最近四季的營業利益加總當作稅後盈餘，所以跟真正的稅後盈餘會有落差。計算的腳本如下:

來源：[跳島除權策略](https://www.xq.com.tw/xstrader/%e8%b7%b3%e5%b3%b6%e9%99%a4%e6%ac%8a%e7%ad%96%e7%95%a5/) 說明：用XS寫選股腳本，一共有四個選股條件，其中本業預估EPS，我是用最近四季的營業利益加總當作稅後盈餘，所以跟真正的稅後盈餘會有落差。計算的腳本如下:

input:epsl(3);

setinputname(1,"預估EPS下限");

value3= summation(GetField("營業利益","Q"),4); //單位百萬;

value4= GetField("最新股本");//單位億;

value5= value3/(value4\*10);//每股預估EPS

if value5\>=epsl

then ret=1;

---

## 場景 1216：如何找出新一季可能虧錢的公司 — 如何提前知道像威盛這種財報出來會虧到大跌的公司。3/16日威盛公佈去年每股虧了3.18元，從隔日起，股價跌到現在跌了兩成。讓我們不禁想問，有沒有辦法事先知道一家...

來源：[如何找出新一季可能虧錢的公司](https://www.xq.com.tw/xstrader/%e5%a6%82%e4%bd%95%e6%89%be%e5%87%ba%e6%96%b0%e4%b8%80%e5%ad%a3%e5%8f%af%e8%83%bd%e8%99%a7%e9%8c%a2%e7%9a%84%e5%85%ac%e5%8f%b8/) 說明：如何提前知道像威盛這種財報出來會虧到大跌的公司。3/16日威盛公佈去年每股虧了3.18元，從隔日起，股價跌到現在跌了兩成。讓我們不禁想問，有沒有辦法事先知道一家公司即將公佈的數字不大妙?我說的可不是去當駭客之類的，而是我們算數字時常用的:用已知推算未知。什麼是已知呢?1.我們知道財報期間的月營收。2.我們知道一家公司的平均毛利率3.我們知道一家公司的每季平均營業費用4.我們知道一家公司業外損益對稅...

value1=GetField("月營收","M");//單位:億

value2=value1\[2\]+value1\[3\]+value1\[4\];//當季月營收合計

value3=GetField("營業毛利率","Q");

value4=GetField("營業費用","Q");//單位:百萬

value5=GetField("營業外收入合計","Y");//單位:百萬

value6=GetField("營業外支出合計","Y");//單位:百萬

value7=GetField("最新股本");//單位:億

value8=(value5-value6)/(value7\*10);//業外淨損益佔EPS

if value2\*value3/100-value4/100\<0 and value8\<0.5

then ret=1;

---

## 場景 1217：如何確定上漲趨勢已然成立 ? — 每次踫到一檔股票從盤整中奮起時，我們經常會想要去追高，但卻經常性的愛到最高點，隔天就消風收黑，於是，我們開始透過一些方式，來過濾那些只是一日行情的股票，我們常用...

來源：[如何確定上漲趨勢已然成立 ?](https://www.xq.com.tw/xstrader/467/) 說明：每次踫到一檔股票從盤整中奮起時，我們經常會想要去追高，但卻經常性的愛到最高點，隔天就消風收黑，於是，我們開始透過一些方式，來過濾那些只是一日行情的股票，我們常用的過濾器有移動平均線黃金交叉，有成交量是否暴增，有前幾日有無籌碼被收集等等方法。今天要跟大家介紹一個比較另類的方法，那就是檢視目前股價是不是保持在六個月以來的前25%中。這個概念如下圖一，我們把近六個月來的股價分成三塊，中間五成算是盤整，上...

input:CountMonth(6); setinputname(1,"計算月數");

variable:pHigh(0),pLow(100000);

if CurrentDate \< DateAdd(Date,"M",CountMonth) then

begin

pHigh \= maxlist(h,pHigh);

pLow \= minlist(l,pLow);

end

else

begin

pHigh \=C;

pLow=C;

end;

array:PlotX\[100\](0);

variable:i(0);

for i \= 0 to 99

begin

PlotX\[i\] \= pHigh-(pHigh-pLow)\*i/100;

end;

plot1(plotx\[ 0\]);

plot2(plotx\[ 1\]);

plot3(plotx\[ 2\]);

plot4(plotx\[ 3\]);

plot5(plotx\[ 4\]);

plot6(plotx\[ 5\]);

plot7(plotx\[ 6\]);

plot8(plotx\[ 7\]);

plot9(plotx\[ 8\]);

plot10(plotx\[ 9\]);

plot11(plotx\[ 10\]);

plot12(plotx\[ 11\]);

plot13(plotx\[ 12\]);

plot14(plotx\[ 13\]);

plot15(plotx\[ 14\]);

plot16(plotx\[ 15\]);

plot17(plotx\[ 16\]);

plot18(plotx\[ 17\]);

plot19(plotx\[ 18\]);

plot20(plotx\[ 19\]);

plot21(plotx\[ 20\]);

plot22(plotx\[ 21\]);

plot23(plotx\[ 22\]);

plot24(plotx\[ 23\]);

plot25(plotx\[ 24\]);

plot75(plotx\[ 74\]);

plot76(plotx\[ 75\]);

plot77(plotx\[ 76\]);

plot78(plotx\[ 77\]);

plot79(plotx\[ 78\]);

plot80(plotx\[ 79\]);

plot81(plotx\[ 80\]);

plot82(plotx\[ 81\]);

plot83(plotx\[ 82\]);

plot84(plotx\[ 83\]);

plot85(plotx\[ 84\]);

plot86(plotx\[ 85\]);

plot87(plotx\[ 86\]);

plot88(plotx\[ 87\]);

plot89(plotx\[ 88\]);

plot90(plotx\[ 89\]);

plot91(plotx\[ 90\]);

plot92(plotx\[ 91\]);

plot93(plotx\[ 92\]);

plot94(plotx\[ 93\]);

plot95(plotx\[ 94\]);

plot96(plotx\[ 95\]);

plot97(plotx\[ 96\]);

plot98(plotx\[ 97\]);

plot99(plotx\[ 98\]);

plot100(plotx\[ 99\]);

---

## 場景 1218：Runscore指標 — 如果能買到一檔三個月爆衝個兩三倍的股票,日子真的天天都很開心\!用XS來找,輕鬆又不用煩惱會漏掉\!\!股票就是一陣一陣的,當投資持有期間的打算可能落在一季,最好還是...

來源：[Runscore指標](https://www.xq.com.tw/xstrader/runscore%e6%8c%87%e6%a8%99/) 說明：如果能買到一檔三個月爆衝個兩三倍的股票,日子真的天天都很開心\!用XS來找,輕鬆又不用煩惱會漏掉\!\!股票就是一陣一陣的,當投資持有期間的打算可能落在一季,最好還是用一季的資料來找股票\!\! 如果看得是年線,只是用來做當沖,難免是有些浪費\!我們就來看看這腳本怎麼寫\!

input:QDate(20140630);

//先設定一個季結束的日子

variable:RunScore(0),vs(0),i(0);

if date \> QDate then begin

if C\>C\[1\] then RunScore+=1; //收漲加1分

if H\>H\[1\] then RunScore+=1;// 漲過昨高加1分

if C\>H\[1\] then RunScore+=1;//收過昨高加1分

if C\<C\[1\] then RunScore-=1;//收跌扣1分

if L\<L\[1\] then RunScore-=1;//破昨低扣1分

if C\<L\[1\] then RunScore-=1;//收破昨低扣1分

vs \+=v; i+=1;

end;

---

## 場景 1219：尋找趨勢是否成形的指標\~動量指標 — 用程式找剛轉強的個股不難，難就難在我們不知道這只是盤整中的反彈，還是另一個多頭趨勢的開始。我昨天看書時看到一個公式動量=質量X速度X方向以前我學到的技術分析，通...

來源：[尋找趨勢是否成形的指標\~動量指標](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e8%b6%a8%e5%8b%a2%e6%98%af%e5%90%a6%e6%88%90%e5%bd%a2%e7%9a%84%e6%8c%87%e6%a8%99%e5%8b%95%e9%87%8f%e6%8c%87%e6%a8%99/) 說明：用程式找剛轉強的個股不難，難就難在我們不知道這只是盤整中的反彈，還是另一個多頭趨勢的開始。我昨天看書時看到一個公式動量=質量X速度X方向以前我學到的技術分析，通常是用價格變動的幅度來衡量動能，也就是上面公司中的速度，倒是沒有同時考慮質量，速度及方向。這給了我一個靈感。於是我寫了以下的腳本

value1=GetField("內盤量");

value2=GetField("外盤量");

value3=(high+low)/2;//計算當天波動的平均價位

if value2\>value1

then value4=value3\*(value2-value1)//質量就是內外盤差乘均價

else

value4=value3\*(value1-value2);

if close\>=close\[1\](方向是往上)

then

begin

value5=(close-close\[1\])/close\[1\]\*value4;//質量乘以速度

value6=0;

end

else(方向是往下)

begin

value5=0;

value6=(close\[1\]-close)/close\[1\]\*value4;

end;

value8=average(value5,2);

value9=average(value6,2);

value10=value8-value9;

plot1(value10,"動能差");

---

## 場景 1220：尋找沈寂已久的股票 — 三國演義開場話說:天下大勢，分久必合，合久必分\! 意即世道循環,更迭有秩\!\! 而市場同趣說: 世間股票沉久必噴,噴久必沉\! 沒有永遠都沉默的股票,也不會有噴無止...

來源：[尋找沈寂已久的股票](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e6%b2%88%e5%af%82%e5%b7%b2%e4%b9%85%e7%9a%84%e8%82%a1%e7%a5%a8/) 說明：三國演義開場話說:天下大勢，分久必合，合久必分\! 意即世道循環,更迭有秩\!\! 而市場同趣說: 世間股票沉久必噴,噴久必沉\! 沒有永遠都沉默的股票,也不會有噴無止境之股\!今天要利用這個原理,想辦法找到市場中沉靜最久之股,當這些股一但表態,勢必會引起一陣波瀾\!先來看選股腳本

var:i(0),Day(0),maxH(0),minL(0);

input:RX(7),Len(255);

maxH \= high;

minL \= Low;

Day \= 0;

for i \= 1 to Len 

begin 

　　maxH \= maxlist(high\[i\], maxH);

　　minL \= minlist(low\[i\],  minL);

　　if maxH/minL \>= 1+(RX/100) then i \= Len;

　　Day \+= 1;

end;

outputfield1(day);

ret=1;

---

## 場景 1221：高手們的選股法則之持續成長的好公司 — 看書時常看到一些高手們列出自己私房的選股條件，昨天看到一則報導，那位高手列出來的條件如下:1.公司上市超過三年2.過去四年不曾虧過錢3.總市值大於五十億台幣4....

來源：[高手們的選股法則之持續成長的好公司](https://www.xq.com.tw/xstrader/%e9%ab%98%e6%89%8b%e5%80%91%e7%9a%84%e9%81%b8%e8%82%a1%e6%b3%95%e5%89%87%e4%b9%8b%e6%8c%81%e7%ba%8c%e6%88%90%e9%95%b7%e7%9a%84%e5%a5%bd%e5%85%ac%e5%8f%b8/) 說明：看書時常看到一些高手們列出自己私房的選股條件，昨天看到一則報導，那位高手列出來的條件如下:1.公司上市超過三年2.過去四年不曾虧過錢3.總市值大於五十億台幣4.營業利益率一年多來不曾大幅下滑5.連續三個月營收年增率都大於零我用XS的選股預設條件去設，發現第四點必須寫腳本才能設出選 股條件，所以我就寫了以下的腳本:

value1=GetField("營業利益率","Q");

input:r1(5);

input:p1(5);

setinputname(1,"營業利益率QOQ最大衰退幅度");

setinputname(2,"計算的季期數");

if trueall(value1\*(1+r1/100)\>value1\[1\],p1)

then ret=1;

---

## 場景 1222：什麼是真*創新高\!\! — 什麼是真*創新高\!\!我們利用跳空開高計分來判斷\! 股價每天開高開低的意義是非常大的,不僅因為這開第一盤的量通常都會特別大,主力也可以用來測試市場的溫度\!\!我們用...

來源：[什麼是真\*創新高\!\!](https://www.xq.com.tw/xstrader/%e4%bb%80%e9%ba%bc%e6%98%af%e7%9c%9f%e5%89%b5%e6%96%b0%e9%ab%98/) 說明：什麼是真\*創新高\!\!我們利用跳空開高計分來判斷\! 股價每天開高開低的意義是非常大的,不僅因為這開第一盤的量通常都會特別大,主力也可以用來測試市場的溫度\!\!我們用腳本這樣寫

var: OH(0),OS(0),OM(0),HH(false);;

if O \> C\[1\] then OH \= intportion(100\*O/C\[1\]-100);

//我們把跳空開高的百分比取整數計,這樣一來0.XX %的就都變成0而被去掉

OS \= summation( OH,20); //開高整數的20天總和

OM \= (highest(OS,20)+Lowest(OS,20))/2; //計算20天來的高低中線

if H \> Highest(H\[1\],20) then HH \=true else HH \= false; //如果是創新高就記TRUE

if OS \> OM and HH and TrueAll(HH\[1\]=false,10) then //開高整數的總和要在中線之上,然後是10天來第一次創新高

plot1(L,"真\*創新高"); { 在警示腳本 改為ret=1; }

plot2(OS,"跳高");

plot3(OM,"跳高中線");

plot4(OS-OM ,"隱多態");

---

## 場景 1223：如何研判上昇趨勢是很明確的? — 我們作順勢操作的人，最怕踫上假突破，所以我們總是花了很多的力氣，在確認上昇趨勢是否已然成形。今天來介紹一個架構，這個架構分成兩階段1.先透過一個主條件來定義上昇...

來源：[如何研判上昇趨勢是很明確的?](https://www.xq.com.tw/xstrader/%e5%a6%82%e4%bd%95%e7%a0%94%e5%88%a4%e4%b8%8a%e6%98%87%e8%b6%a8%e5%8b%a2%e6%98%af%e5%be%88%e6%98%8e%e7%a2%ba%e7%9a%84/) 說明：我們作順勢操作的人，最怕踫上假突破，所以我們總是花了很多的力氣，在確認上昇趨勢是否已然成形。今天來介紹一個架構，這個架構分成兩階段1.先透過一個主條件來定義上昇趨勢。例如均線多頭排列啦，趨勢線向上啦。2.再透過幾個其他輔助判斷標準來研判這樣的上昇趨勢能否確立。例如波動區間變大，成交量大增之類的。以下是我寫的範例，我用日線1.以股價近五日內突破五日均線且這五日內五日均線突破20日均線，做為趨勢是否成...

if barfreq"d" then return;//只用於日線

if countif(close crosses above average(close,5),5)\>0

and countif(average(close,5) crosses above average(close,20),5)\>0

then begin// 近五日內股價突破五日線 且五日線突破20日線

value1=q\_CashDirect;//即時資金流向

value2=q\_TotalTicks;//總成交筆數

value3=GetField("強弱指標");

if value1\>average(value1,20)//佔大盤成交量比例大於月平均

and value2\>average(value2,20) //總成交筆數大於月平均

and value3\>average(value3,20)//相對大盤強弱度大於月平均

then ret=1;

end;

---

## 場景 1224：暴量脫離區間盤整區 — 暴量脫離區間盤整區， 根據以往的經驗，這種走勢代表的應該不會只是一日行情。腳本如下:

來源：[暴量脫離區間盤整區](https://www.xq.com.tw/xstrader/%e6%9a%b4%e9%87%8f%e8%84%ab%e9%9b%a2%e5%8d%80%e9%96%93%e7%9b%a4%e6%95%b4%e5%8d%80/) 說明：暴量脫離區間盤整區， 根據以往的經驗，這種走勢代表的應該不會只是一日行情。腳本如下:

input: VLength(20); setinputname(1,"均量期數");

input: volpercent(30); setinputname(2,"爆量增幅%");

input: r1(10); setinputname(3,"區間高低差%");

input: period(30); setinputname(4,"盤整最小天數");

if Close cross above highest(high\[1\],period)//股價突破盤整區間

and

Volume \>= average(volume,VLength) \*(1+ volpercent/100)//暴量

and

highest(high,period)\<=lowest(low,period)\*(1+r1/100)//先前區間盤整

then ret=1;

---

## 場景 1225：尋找噴出後休息再上攻的股票 — 假設是這樣,當股價強了一段時間以後,一定會休息\! 休息以後再攻就會上\!\!我們要做的就是找出休息再上攻的那個點,這樣贏面才大\!看一下腳本怎麼寫

來源：[尋找噴出後休息再上攻的股票](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e5%99%b4%e5%87%ba%e5%be%8c%e4%bc%91%e6%81%af%e5%86%8d%e4%b8%8a%e6%94%bb%e7%9a%84%e8%82%a1%e7%a5%a8/) 說明：假設是這樣,當股價強了一段時間以後,一定會休息\! 休息以後再攻就會上\!\!我們要做的就是找出休息再上攻的那個點,這樣贏面才大\!看一下腳本怎麼寫

var: WX(average(H/L,5));

if nthhighestbar(1,H,20) \<= 5 and // 離最高價不超過5根BAR,休息5天內

H-L O\[1\]\*WX ,5) and //5天內有大漲果

average(C,20)\> average(C,60) // 多頭趨勢

then ret=1;

---

## 場景 1226：開盤n分鐘內，每根bar都是收紅的股票 — 腳本如下，請各位自行取用

來源：[開盤n分鐘內，每根bar都是收紅的股票](https://www.xq.com.tw/xstrader/%e9%96%8b%e7%9b%a4n%e5%88%86%e9%90%98%e5%85%a7%ef%bc%8c%e6%af%8f%e6%a0%b9bar%e9%83%bd%e6%98%af%e6%94%b6%e7%b4%85%e7%9a%84%e8%82%a1%e7%a5%a8/) 說明：腳本如下，請各位自行取用

input:contRise(5); setinputname(1,"開盤起連漲期數");

variable:intrabarpersist KBarOfDay(0);

KBarOfDay+=1;

if date\<\>date\[1\] then KBarOfDay=1; //計算每天日內的Bar序數

if Date \= CurrentDate //今天開盤起算

and contRise \= countif(close\>close\[1\] and close \> open,KBarOfDay) //收漲計算(包含開盤第一根是要漲)

and contRise \= KBarOfDay //今天有幾根棒就漲幾根

then ret=1;

---

## 場景 1227：尋找趨勢是否成形的指標之動量指標

來源：[尋找趨勢是否成形的指標之動量指標](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e8%b6%a8%e5%8b%a2%e6%98%af%e5%90%a6%e6%88%90%e5%bd%a2%e7%9a%84%e6%8c%87%e6%a8%99%e4%b9%8b%e5%8b%95%e9%87%8f%e6%8c%87%e6%a8%99/) 說明：於是我寫了以下的腳本

value1=GetField("內盤量");

value2=GetField("外盤量");

value3=(high+low)/2;//計算當天波動的平均價位

if value2\>value1

then value4=value3\*(value2-value1)//質量就是內外盤差乘均價

else

value4=value3\*(value1-value2);

if close\>=close\[1\](方向是往上)

then

begin

value5=(close-close\[1\])/close\[1\]\*value4;//質量乘以速度

value6=0;

end

else(方向是往下)

begin

value5=0;

value6=(close\[1\]-close)/close\[1\]\*value4;

end;

value8=average(value5,2);

value9=average(value6,2);

value10=value8-value9;

plot1(value10,"動能差");

---

## 場景 1228：尋找一段區間內漲跌幅度限縮在特定比例內的股票

來源：[尋找一段區間內漲跌幅度限縮在特定比例內的股票](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e4%b8%80%e6%ae%b5%e5%8d%80%e9%96%93%e5%85%a7%e6%bc%b2%e8%b7%8c%e5%b9%85%e5%ba%a6%e9%99%90%e7%b8%ae%e5%9c%a8%e7%89%b9%e5%ae%9a%e6%af%94%e4%be%8b%e5%85%a7%e7%9a%84%e8%82%a1%e7%a5%a8/) 說明：先來看選股腳本

var:i(0),Day(0);

input:RX(7),Len(255);

for i \= 1 to Len begin if Highest(H,i)/Lowest(L,i) \< 1+(RX/100) then Day \=i;end;

outputfield1(day);

ret=1;

---

## 場景 1229：低本益比的定存股 — 這其中，本業推估本益比的計算說明如下:

來源：[低本益比的定存股](https://www.xq.com.tw/xstrader/%e4%bd%8e%e6%9c%ac%e7%9b%8a%e6%af%94%e7%9a%84%e5%ae%9a%e5%ad%98%e8%82%a1/) 說明：這其中，本業推估本益比的計算說明如下:

input:epsl(10);

setinputname(1,"預估本益比上限");

value3= summation(GetField("營業利益","Q"),4); //單位百萬;

value4= GetField("最新股本");//單位億;

value5= value3/(value4\*10);//每股預估EPS

if close/value5\<=epsl

then ret=1;

---

## 場景 1230：波段操作的價值型標準 — 我寫了一個符合這個腳本的邏輯如下:

來源：[波段操作的價值型標準](https://www.xq.com.tw/xstrader/%e6%b3%a2%e6%ae%b5%e6%93%8d%e4%bd%9c%e7%9a%84%e5%83%b9%e5%80%bc%e5%9e%8b%e6%a8%99%e6%ba%96/) 說明：我寫了一個符合這個腳本的邏輯如下:

input:N1(5);

input:N2(16);

setinputname(1,"股利平均的年數");

setinputname(2,"股利的倍數");

value1=GetField("股利合計","Y");

value2=average(value1,N1);

if close\<value2\*N2

then ret=1;

---

## 場景 1231：現金股利跳島戰術 — 基於這樣的思維，我寫了一個選股策略如下:

來源：[現金股利跳島戰術](https://www.xq.com.tw/xstrader/%e7%8f%be%e9%87%91%e8%82%a1%e5%88%a9%e8%b7%b3%e5%b3%b6%e6%88%b0%e8%a1%93/) 說明：基於這樣的思維，我寫了一個選股策略如下:

input:peratio(17);

input:ratio(60);

input:epsl(5);

input:rate1(5);

setinputname(1,"本益比上限倍數");

setinputname(2,"現金股利佔股利之比重下限");

setinputname(3,"預估本益EPS下限");

setinputname(4,"累計營收成長率下限");

value1=GetField("累計營收年增率","M");//單位%

value2=GetField("現金股利佔股利比重","Y");

value3=GetField("營業利益","Q");//單位百萬;

value4=GetField("最新股本");//單位億;

value5=value3\*4/(value4\*10);//每股預估EPS

if

value1\>rate1//本業持續成長

and

value2\>ratio//主要以現金股利為主

and

value5\>EPSl//每股推估本業獲利大於三元

and

value5/close\<peratio//本益比低於17倍

then ret=1;

---

## 場景 1232：上昇趨勢分數。 — 腳本如下，有興趣的朋友可以參考

來源：[上昇趨勢分數。](https://www.xq.com.tw/xstrader/%e4%b8%8a%e6%98%87%e8%b6%a8%e5%8b%a2%e5%88%86%e6%95%b8%e3%80%82/) 說明：腳本如下，有興趣的朋友可以參考

variable: count1(0),count2(0),count3(0),count4(0),x1(0);

input:length(10);

count1=0;

count2=0;

count3=0;

count4=0;

for x1=0 to length-1

if h\[x1\]\>h\[x1+1\]

then count1=count1+1;

for x1=0 to length-1

if o\[x1\]\>o\[x1+1\]

then count2=count2+1;

for x1=0 to length-1

if low\[x1\]\>low\[x1+1\]

then count3=count3+1;

for x1=0 to length-1

if close\[x1\]\>close\[x1+1\]

then count4=count4+1;

value1=count1+count2+count3+count4;

value2=average(value1,5);

value3=average(value1,20);

plot1(value2,"趨勢分數");

plot2(value3,"移動平均分數");

---

## 場景 1233：從”相對”的角度尋找真正價量齊揚的股票 — 從”相對”的角度尋找真正價量齊揚的股票這次XS新增了不少可以拿來運算的獨特欄位，其中有兩個是跟大盤對應的，一個叫資金流向，一個叫強弱指標，前者是成交值跟大盤成交...

來源：[從”相對”的角度尋找真正價量齊揚的股票](https://www.xq.com.tw/xstrader/%e5%be%9e%e7%9b%b8%e5%b0%8d%e7%9a%84%e8%a7%92%e5%ba%a6%e5%b0%8b%e6%89%be%e7%9c%9f%e6%ad%a3%e5%83%b9%e9%87%8f%e9%bd%8a%e6%8f%9a%e7%9a%84%e8%82%a1%e7%a5%a8/) 說明：從”相對”的角度尋找真正價量齊揚的股票這次XS新增了不少可以拿來運算的獨特欄位，其中有兩個是跟大盤對應的，一個叫資金流向，一個叫強弱指標，前者是成交值跟大盤成交值的比值，後者則是個股漲跌幅與大盤漲跌幅的相對闗係。我們常說要找價量齊揚的股票，但如果考慮到相對的概念，我們要找的其實是成交量佔大盤的比重在增加，而且股價跟大盤對應的強度在增強。運用這樣的概念，我寫了一個指標，這指標在計算十天之內有多少天成...

input:sp(10);

setinputname(1,"短計算區間");

value1=GetField("資金流向");

value2=GetField("強弱指標");

var:count1(0) ;

count1=countif(value2\>0and value1\>value1\[1\],sp);

value3=average(count1,5);

plot1(value3,"短期價量齊揚天數");

---

## 場景 1234：開高後不拉回的中小型股 — 策略雷達:開高不拉回，這個策略有幾個條件1.開高超過2%，但沒有開超過4%。2.開高後到了九點五分之後拉回幅度不超過1%。3.過去三天股價漲幅沒有超過4%4.現...

來源：[開高後不拉回的中小型股](https://www.xq.com.tw/xstrader/%e9%96%8b%e9%ab%98%e5%be%8c%e4%b8%8d%e6%8b%89%e5%9b%9e%e7%9a%84%e4%b8%ad%e5%b0%8f%e5%9e%8b%e8%82%a1/) 說明：策略雷達:開高不拉回，這個策略有幾個條件1.開高超過2%，但沒有開超過4%。2.開高後到了九點五分之後拉回幅度不超過1%。3.過去三天股價漲幅沒有超過4%4.現在股價突破開盤價達今日最高價根據上述的篩選原則，其對應的腳本如下:

input:sp(1);

input:opl(2);

input:oph(4);

setinputname(1,"回檔最大幅度");

setinputname(2,"開高最小幅度");

setinputname(3,"開高最大幅度");

if time\>0905

then

begin

if open\>=close\[1\]\*(1+opl/100)

and close\<=close\[1\]\*(1+oph/100)

and low\>open\*(1-sp/100)

and close=high

and close\[1\]\<close\[3\]\*1.04//前三天漲幅不到4%

then ret=1;

end;

---

## 場景 1235：把籌碼面跟技術面的數據放在一起選股 — 以下這簡單的腳本就是找出過去五天有一天多空判斷分數突破五的股票

來源：[把籌碼面跟技術面的數據放在一起選股](https://www.xq.com.tw/xstrader/%e6%8a%8a%e7%b1%8c%e7%a2%bc%e9%9d%a2%e8%b7%9f%e6%8a%80%e8%a1%93%e9%9d%a2%e7%9a%84%e6%95%b8%e6%93%9a%e6%94%be%e5%9c%a8%e4%b8%80%e8%b5%b7%e9%81%b8%e8%82%a1/) 說明：以下這簡單的腳本就是找出過去五天有一天多空判斷分數突破五的股票

value1 \= techscore();

value2 \= average(value1, 10);

Value3 \= CountIF(value2 crosses above 5,5);

if value3 \>=1 then ret \= 1;

以下的腳本就是找出連續兩天籌碼被收集的股票

value1=GetField("分公司買進家數","D");

value2=GetField("分公司賣出家數","D");

value3=value2-value1;

if trueall(value3\>30,2)

then ret=1;

---

## 場景 1236：多日價量背離 — 繼前面兩個腳本之後，第三個腳本我想向大家報告的是連續多日價量背離。

來源：[多日價量背離](https://www.xq.com.tw/xstrader/%e5%a4%9a%e6%97%a5%e5%83%b9%e9%87%8f%e8%83%8c%e9%9b%a2/) 說明：繼前面兩個腳本之後，第三個腳本我想向大家報告的是連續多日價量背離。

input:Length(5); setinputname(1,"計算期數");

input:times(3);setinputname(2,"價量背離次數");

input:TXT("建議使用日線"); setinputname(3,"使用說明");

variable:count(0);

count \= CountIf(close \> close\[1\] and volume \< volume\[1\], Length);

if count \> times then

ret \= 1;

---

## 場景 1237：盤中突破區間 — 盤中突破區間這個腳本，其內容如下:

來源：[盤中突破區間](https://www.xq.com.tw/xstrader/%e7%9b%a4%e4%b8%ad%e7%aa%81%e7%a0%b4%e5%8d%80%e9%96%93/) 說明：盤中突破區間這個腳本，其內容如下:

input: timeline(100000); setinputname(1,"時間切算點");

input:TXT1("限用分鐘線"); setinputname(2,"使用限制");

input:TXT2("高點自開盤起算"); setinputname(3,"使用說明");

if barfreq\<\> "Min" then return;

variable:RangeHigh(0);

if date \<\> date\[1\] then RangeHigh \= 0;

if Time \< timeline then RangeHigh \= maxlist(RangeHigh,high)

else if time \>= timeline and RangeHigh \> 0 and Close \> RangeHigh then ret=1 ;

---

## 場景 1238：盤中可以找出那檔股票有大單在敲進的腳本 — 回家後，想了一下，寫了一個腳本，請我們公司的高手改了一下，腳本如下:

來源：[盤中可以找出那檔股票有大單在敲進的腳本](https://www.xq.com.tw/xstrader/%e7%9b%a4%e4%b8%ad%e5%8f%af%e4%bb%a5%e6%89%be%e5%87%ba%e9%82%a3%e6%aa%94%e8%82%a1%e7%a5%a8%e6%9c%89%e5%a4%a7%e5%96%ae%e5%9c%a8%e6%95%b2%e9%80%b2%e7%9a%84%e8%85%b3%e6%9c%ac/) 說明：回家後，想了一下，寫了一個腳本，請我們公司的高手改了一下，腳本如下:

input: BigBuy(500); setinputname(1,"大戶買單(萬)");

input: BigBuyTimes(10); setinputname(2,"大戶買進次數");

input:TXT("須逐筆洗價"); setinputname(3,"使用限制:");

variable: intrabarpersist Xtime(0);//計數器

variable: intrabarpersist Volumestamp(0);

Volumestamp \=q\_DailyVolume;

if Date \<\> currentdate or Volumestamp \= Volumestamp\[1\] then Xtime \=0; //開盤那根要歸0次數

if q\_tickvolume\*q\_Last \> BigBuy\*10 and q\_BidAskFlag=1 then Xtime+=1; //量夠大就加1次

if Xtime \> BigBuyTimes then ret=1;

---

## 場景 1239：如何知道公司派，主力是不是在出貨 — 根據這樣的精神，我請公司的高手寫了以下的一個腳本:

來源：[如何知道公司派，主力是不是在出貨](https://www.xq.com.tw/xstrader/%e5%a6%82%e4%bd%95%e7%9f%a5%e9%81%93%e5%85%ac%e5%8f%b8%e6%b4%be%ef%bc%8c%e4%b8%bb%e5%8a%9b%e6%98%af%e4%b8%8d%e6%98%af%e5%9c%a8%e5%87%ba%e8%b2%a8/) 說明：根據這樣的精神，我請公司的高手寫了以下的一個腳本:

input:Peroid(5);setinputname(1,"近期偏弱期間");

input:Rate1(500);setinputname(2,"法人及散戶合計賣出上限");

input:Rate2(8000);setinputname(3,"成交量下限");

input:Ratio(1); setinputname(4,"接近低點幅度");

input:Type(1);setinputname(5,"盤中用1,收盤出資料後用0");

if Close\< Close\[Peroid\] and {近期股價累計為下跌}

Close \< Lowest(Low,Peroid)\* (1+Ratio/100) and {接近期間低點}

Average(Volume,Peroid) \> Rate2 {偏弱期間均量大於成交量下限}

then

begin

value1= GetField("法人持股")\[Type\] \- GetField("法人持股")\[Peroid+Type\] ; {期間法人累計買賣超}

value2= GetField("融資餘額張數")\[Type\] \- GetField("融資餘額張數")\[Peroid+Type\] ; {期間融資累計增減}

value3= GetField("融券餘額張數")\[Type\] \- GetField("融券餘額張數")\[Peroid+Type\];{期間融券累計增減}

if value1 \+ value2 \-value3 \> Rate1\*-1 then ret=1;

end;

---

## 場景 1240：買進比重大的非權值股。 — 這幾天盤大跌後反彈，我想知道一下在這樣震盪的盤面中，法人有沒有在趁機佈局一些股票。所以我寫了以下的這個腳本

來源：[買進比重大的非權值股。](https://www.xq.com.tw/xstrader/%e8%b2%b7%e9%80%b2%e6%af%94%e9%87%8d%e5%a4%a7%e7%9a%84%e9%9d%9e%e6%ac%8a%e5%80%bc%e8%82%a1%e3%80%82/) 說明：這幾天盤大跌後反彈，我想知道一下在這樣震盪的盤面中，法人有沒有在趁機佈局一些股票。所以我寫了以下的這個腳本

value1=GetField("法人買張");

input:period(3);

input:ratio(3);

input:bline(2000);

setinputname(1,"計算天數");

setinputname(2,"佔成交量成數");

setinputname(3,"法人合計買超最低量");

value2=summation(value1,period);

value3=summation(volume,period);

value4=value2/value3;

if value4\*10\>ratio and value1\>0 and value2\>bline

then ret=1;

---

## 場景 1241：只要有心，人人都可以成為小虎隊 — 跟朋友聊起了虎尾幫的操作手法，回家後寫了一個腳本，並且請公司的高手修改如下:

來源：[只要有心，人人都可以成為小虎隊](https://www.xq.com.tw/xstrader/%e5%8f%aa%e8%a6%81%e6%9c%89%e5%bf%83%ef%bc%8c%e4%ba%ba%e4%ba%ba%e9%83%bd%e5%8f%af%e4%bb%a5%e6%88%90%e7%82%ba%e5%b0%8f%e8%99%8e%e9%9a%8a/) 說明：跟朋友聊起了虎尾幫的操作手法，回家後寫了一個腳本，並且請公司的高手修改如下:

if barfreq \<\> "D" then return ; {只在日線可用}

input:sp(1); setinputname(1,"當日回檔最大幅度");

input:opl(2); setinputname(2,"開高最小幅度");

input:oph(4); setinputname(3,"開高最大幅度");

if currenttime \> 100000 and currentdate \=date {今天10點過後開始判斷}

then begin

if open \>= close\[1\] \* (1 \+ opl/100) and {開高在昨收的之上%下限}

close \<= close\[1\] \* (1 \+ oph/100) and {開高在昨收的之上%上限}

low \> open \* (1 \- sp/100) //and {低點離開盤價%}

close \= high {收在最高點}

then ret=1;

end;

---

