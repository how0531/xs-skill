# TradingView 熱門策略 → 台指期 XS 交易腳本

從 TradingView 上長期高人氣的策略中，挑選四個**適合台指期特性**（波動大、可雙向操作、日盤 08:45–13:45）的策略，依本 skill 的交易腳本規範（`references/script-types/trading.md`）轉寫為 XQ 可執行的 XS 自動交易腳本。

> ⚠️ **免責聲明**：本目錄所有腳本僅供程式教學與語法示範，不構成任何投資建議。
> 實際上線前務必先在 XQ 完成回測與模擬交易，並自行調整參數與風控。

## 策略總覽

| 檔案 | 策略 | TradingView 來源 | 型態 | 建議頻率 | 建議商品 |
|---|---|---|---|---|---|
| `01-supertrend-trend.xs` | SuperTrend 趨勢跟蹤 | [Supertrend 官方說明](https://www.tradingview.com/support/solutions/43000634738-supertrend/)、[社群腳本區](https://www.tradingview.com/scripts/supertrend/) | 波段・多空互換 | 15/30/60 分 | FITX*1.TF / FITXN*1.TF |
| `02-opening-range-breakout.xs` | 開盤區間突破（ORB）當沖 | [Opening Range Breakout 腳本區](https://www.tradingview.com/scripts/openrangebreakout/) | 當沖・不留倉 | 1/5 分 | FITX*1.TF（限日盤） |
| `03-donchian-channel-breakout.xs` | Donchian 通道突破（海龜） | TradingView 內建 Channel Break Out 策略、[Donchian 腳本區](https://www.tradingview.com/scripts/donchian/) | 波段・多空 | 60 分 / 日線 | FITX*1.TF / FITXN*1.TF |
| `04-rsi-mean-reversion.xs` | RSI 均值回歸 | TradingView 內建 RSI Strategy、[RSI 腳本區](https://www.tradingview.com/scripts/relativestrengthindex/) | 波段・逆勢 | 30/60 分 | FITX*1.TF / FITXN*1.TF |

四個策略刻意涵蓋不同型態：**趨勢跟蹤**（SuperTrend）、**日內突破**（ORB）、**中期突破**（Donchian）、**逆勢回歸**（RSI），彼此邏輯相關性低，方便組合或比較回測。

## PineScript → XS 語法對照

轉寫時的主要語法置換（XS 語法源自 PowerLanguage，與 PineScript 不相容，不可混用）：

| PineScript（TradingView） | XS（XQ） |
|---|---|
| `strategy.entry("L", strategy.long)` | `SetPosition(口數, market)` |
| `strategy.entry("S", strategy.short)` | `SetPosition(-口數, market)` |
| `strategy.close()` / `strategy.exit()` | `SetPosition(0, market)` |
| `strategy.position_size` | `Position`（策略部位）／`Filled`（實際成交部位） |
| `strategy.position_avg_price` | `FilledAvgPrice` |
| `ta.atr(len)` | `ATR(期數)` |
| `ta.rsi(close, len)` | `RSI(Close, 期數)` |
| `ta.highest(high, len)` / `ta.lowest(low, len)` | `Highest(High, 期數)` / `Lowest(Low, 期數)` |
| `ta.crossover(a, b)` / `ta.crossunder(a, b)` | `a cross above b` / `a cross below b` |
| `==`（相等比較） | `=` |
| `!=` | `<>` |
| `var float x = 0`（跨 bar 保值） | `var: intrabarpersist _x(0);` |
| `session.isfirstbar_regular` | `Date <> Date[1]` |
| 每行免分號 | 每句以 `;` 結尾，分支包 `begin/end` |

其他轉寫要點：

- **期貨只判斷 `position`**，不需要股票的 `filled = position` 同步檢查；但取 `FilledAvgPrice` 前仍先確認 `filled` 同向，避免拿到未成交前的空值。
- **停損一律用 `High`/`Low` 觸價判斷**，不用 `Close`（收盤價停損會錯過盤中急殺，見 `references/anti-patterns.md` #20）。
- **跨洗價要保值的狀態變數**（區間高低、旗標、K 棒控制權）一律 `intrabarpersist`（#12、#31）。
- **同一根 K 棒防重複進出**用 `_ControlBar <> CurrentBar` 控制權機制（`trading.md` §8 範本）。

## 使用方式

1. 在 XQ 全球贏家開啟「XS 編輯器」，新增**交易**類腳本，貼上 `.xs` 檔內容並編譯。
2. 到「自動交易中心」新增策略，商品選台指期近月（連續月代碼 `FITX*1.TF`；要含夜盤用 `FITXN*1.TF`），頻率依各腳本頭部建議設定。
3. 回測時建議勾選「**觸發即判斷成交**」，避免模擬逐筆洗價的撮合偏差導致回測過度樂觀（`trading.md` §13）。
4. 先以小口數（或模擬帳號）驗證行為，再逐步放大。

## 台指期專屬注意事項

- **當沖腳本（ORB）請掛日盤商品**：全日盤的夜盤跨日會干擾 `Date <> Date[1]` 每日歸零與開盤區間統計（夜盤日期陷阱見 `references/anti-patterns.md` #30）。
- **波段腳本會留倉**：監控連續月合約時，結算日需處理轉倉——`Position`/`Filled` 在合約切換後仍保留舊值，正確的「13:29 記錄 → 15:00 重建」兩段式寫法見 `references/script-types/trading.md` §12。
- **合約規格**：大台每點 200 元、小台（MTX）每點 50 元、微台（TMF）每點 10 元。腳本邏輯與口數參數通用，測試時可先掛小台/微台降低風險。
