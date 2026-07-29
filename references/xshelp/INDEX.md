# XSHelp 官方文件索引

> 來源：https://xshelp.xq.com.tw/XSHelp/ ；重跑 `python scripts/crawl_xshelp.py` 可更新（有快取，全新抓取先刪 references/xshelp/.cache）

| 分類 | 檔案 | 項目數 | 內容 |
|---|---|---|---|
| 關鍵字-忽略字 | SKIPWORD.md | 1 | 忽略字總覽 |
| 關鍵字-常數 | CONSTANT.md | 1 | 常數總覽 |
| 關鍵字-流程控制 | CONTROLFLOW.md | 16 | 流程控制總覽、IF / THEN / ELSE、Switch / Case / Default、Once、For To / DownTo、While、Repeat / Until、Break …共16項 |
| 關鍵字-宣告 | DECLARATION.md | 18 | 宣告總覽、Var、IntrabarPersist、Array、Input、inputkind、Numeric、NumericRef …共18項 |
| 內建函數-一般函數 | GENERALFUNC.md | 47 | BarAdjusted、BarFreq、BarInterval、CallFunction、CurrentBar、DataAlign、ExecOffset、File …共47項 |
| 內建函數-時間函數 | TIMEFUNC.md | 13 | CurrentTime、CurrentTimeMS、EncodeTime、FormatTime、Hour、MilliSecond、Minute、Second …共13項 |
| 內建函數-日期函數 | DATEFUNC.md | 16 | CurrentDate、DateAdd、DateDiff、DateToJulian、DateToString、DateValue、DayOfMonth、DayOfWeek …共16項 |
| 內建函數-字串函數 | STRINGFUNC.md | 15 | InStr、LeftStr、LowerStr、MidStr、NumToStr、RightStr、StrCompare、StrEndWith …共15項 |
| 內建函數-數學函數 | NUMBERFUNC.md | 37 | AbsValue、ArcCosine、ArcSine、ArcTangent、AvgList、Ceiling、Combination、Cos …共37項 |
| 內建函數-欄位函數 | FIELDFUNC.md | 17 | CheckField、CheckSymbolField、GetField、GetFieldDate、GetfieldFiscalQ、GetfieldFiscalY、GetFieldPublishDate、GetQuote …共17項 |
| 內建函數-陣列函數 | ARRAYFUNC.md | 9 | Array_Compare、Array_Copy、Array_GetMaxIndex、Array_GetType、Array_SetMaxIndex、Array_SetValRange、Array_Sort、Array_Sort2d …共9項 |
| 內建函數-交易函數 | TRANSACTIONFUNC.md | 28 | AddSpread、Alert、Buy、CancelAllOrders、Cover、DefaultBuyPrice、DefaultSellPrice、Filled …共28項 |
| 系統函數-價格取得 | PRICEGETFUNC.md | 33 | AvgPrice、CloseD、CloseH、CloseM、CloseQ、CloseW、CloseY、FastHighest …共33項 |
| 系統函數-價格計算 | PRICECULFUNC.md | 13 | Average、AvgDeviation、DwLimit、EMA、Range、RateOfChange、SimpleHighestBar、SimpleLowestBar …共13項 |
| 系統函數-價格關係 | PRICERELFUNC.md | 25 | Extremes、ExtremesArray、FastHighestBar、FastLowestBar、HighDays、HighestArray、HighestBar、LowDays …共25項 |
| 系統函數-技術指標 | TECHINDEXFUNC.md | 53 | ACC、ADI、ADO、AR、ATR、Bias、BiasDiff、BollingerBand …共53項 |
| 系統函數-日期相關 | DATERELFUNC.md | 10 | angleprice、BarsLast、DaysToExpiration、DownTrend、formatMQY、GetLastTradeDate、LastDayOfMonth、NDaysAngle …共10項 |
| 系統函數-交易相關 | TRANSACTIONRELFUNC.md | 2 | calcvwapdistribution、EnterMarketCloseTime |
| 系統函數-統計分析 | STATSFUNC.md | 6 | CoefficientR、Correlation、Covariance、RSquare、StandardDev、VariancePS |
| 系統函數-趨勢分析 | TRENDFUNC.md | 12 | Angle、LinearReg、LinearRegAngle、LinearRegSlope、SwingHigh、SwingHighBar、SwingLow、SwingLowBar …共12項 |
| 系統函數-邏輯判斷 | LOGICFUNC.md | 13 | AverageIF、CountIf、CountIfARow、CrossOver、CrossUnder、DateTime、Filter、GetBarOffsetForYears …共13項 |
| 系統函數-期權相關 | FUTUREFUNC.md | 12 | blackscholesmodel、BSDelta、BSGamma、BSPrice、BSTheta、BSVega、DaysToExpirationTF、HVolatility …共12項 |
| 系統函數-跨頻率 | FREQUENCYFUNC.md | 29 | xf_CrossOver、xf_CrossUnder、xf_DirectionMovement、xf_EMA、xf_GetBoolean、xf_GetCurrentBar、xf_GetDTValue、xf_GetValue …共29項 |
| 系統函數-Array函數 | ARRAYSYSFUNC.md | 4 | ArrayLinearRegSlope、ArrayMASeries、ArraySeries、ArrayXDaySeries |
| 系統函數-量能相關 | VOLUMERELFUNC.md | 4 | DiffBidAskVolumeLxL、DiffBidAskVolumeXL、DiffTradeVolumeAtAskBid、DiffUpDownVolume |
| 系統函數-量化因子 | QUANTFACTOR.md | 51 | 10日內破低次數、10日內跌幅超過5%天數、120日賣出動能(Kiosotto)、150日買進動能(Kiosotto)、20日內破低次數、52週動能、52週動能_最高價、Andean Oscillator多頭(20) …共51項 |
| 報價欄位-常用 | QOFTEN.md | 12 | 成交、成交時間、估計量、昨量、參考價、最低(日)、最高(日)、單量 …共12項 |
| 報價欄位-價格 | QPRICE.md | 23 | 一月前收盤價、一年前收盤價、一週前收盤價、三月前收盤價、內外盤、去年收盤價、成交、均價 …共23項 |
| 報價欄位-量能 | QVOLUME.md | 27 | 內盤量、外盤量、成交比重、成交均量、成交金額(元)、估計量、委買均、委賣均 …共27項 |
| 報價欄位-財務 | QFINANCE.md | 10 | 毛利率、每股盈餘、每股淨值、每股營收、股東權益報酬率、財報期別、營收月份、營收年增率 …共10項 |
| 報價欄位-市場統計 | QMARKET.md | 4 | 下跌家數、上漲家數、跌停家數、漲停家數 |
| 報價欄位-期權 | QOPTION.md | 28 | Delta、Gamma、RHO、Theta、Vega、內含值、有效槓桿、到期日 …共28項 |
| 報價欄位-五檔統計 | QFIVE.md | 28 | 委比、委買、委買1、委買2、委買3、委買4、委買5、委買賣差 …共28項 |
| 資料欄位-常用 | TOFTEN.md | 17 | 內盤量、日期、外盤量、成交金額(元)、成交量、收盤價、估計量、均價 …共17項 |
| 資料欄位-價格 | TPRICE.md | 14 | 內外盤、收盤價、均價、投資建議目標價、參考價、基差、強弱指標、最低價 …共14項 |
| 資料欄位-量能 | TVOLUME.md | 69 | GDP比例、下跌量、上漲量、內盤成交次數、內盤均量、內盤量、外盤成交次數、外盤均量 …共69項 |
| 資料欄位-籌碼 | TCHIP.md | 156 | CB剩餘張數、大戶持股人數、大戶持股比例、大戶持股張數、內部人持股、內部人持股比例、內部人持股張數、內部人持股異動 …共156項 |
| 資料欄位-基本 | TBASIC.md | 9 | 月營收、本益比、投資建議評級、股本(元)、股本(億)、財報股本(億)、殖利率、發行張數(張) …共9項 |
| 資料欄位-事件 | TEVENT.md | 29 | 法說會日期、股東會日期、庫藏股結束日期、庫藏股開始日期、除息日期、除息年度、除息值、除權日期 …共29項 |
| 資料欄位-市場統計 | TMARKET.md | 18 | TW50KD多空家數、TW50MTM多空家數、TW50上昇趨勢家數、TW50大戶買賣力、TW50大單成交次數、TW50大單買進金額、TW50均線多空家數、TW50紅K家數 …共18項 |
| 資料欄位-期權 | TOPTION.md | 61 | Delta、Gamma、RHO、Theta、Vega、十大交易人未沖銷買口、十大交易人未沖銷賣口、十大法人未沖銷買口 …共61項 |
| 選股欄位-常用 | FOFTEN.md | 19 | 月營收、主力買賣超張數、本益比、成交金額(億)、成交量、收盤價、均價、每股稅後淨利(元) …共19項 |
| 選股欄位-價格 | FPRICE.md | 27 | Jensen、SHARPE、Treynor、下游股價指標、上游股價指標、月平均收益率、本益比、同業股價指標 …共27項 |
| 選股欄位-量能 | FVOLUME.md | 61 | 下跌量、上漲量、內外盤比、內盤成交次數、內盤均量、內盤量、外盤成交次數、外盤均量 …共61項 |
| 選股欄位-籌碼 | FCHIP.md | 119 | CB剩餘張數、ETF規模、大戶持股人數、大戶持股比例、大戶持股張數、內部人持股、內部人持股比例、內部人持股張數 …共119項 |
| 選股欄位-基本 | FBASIC.md | 34 | 公司成立日期、公司風格、公司掛牌日期、公司類別、公積配股、月營收、月營收月增率、月營收年增率 …共34項 |
| 選股欄位-財務 | FFINANCE.md | 212 | (存貨+應收帳款)／營收、10年年化報酬率、1年年化報酬率、1年夏普指數、3年年化報酬率、5年年化報酬率、EPS法說公佈值、EPS預估值 …共212項 |
| 選股欄位-事件 | FEVENT.md | 35 | 下一次董監改選年、日期、法說會日期、股利年度、股東會日期、庫藏股結束日期、庫藏股開始日期、除息日期 …共35項 |

總計 1497 項。查特定函數/欄位：先 grep 本目錄 `^## 名稱`，再 Read 該檔對應段落。