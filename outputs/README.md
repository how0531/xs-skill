# outputs — 定稿產出

| 檔案 | 說明 |
|---|---|
| `txf_dual_green_strategy.xs` | 台指期「雙陽開泰策略 V3.93」的 XS 自動交易腳本版（由 PineScript v6 轉寫） |

## txf_dual_green_strategy.xs

**類別**：交易腳本（自動交易）　**頻率**：分鐘　**商品**：台指期／小台（全日盤）

### 訊號時序（與原策略的對應）

原策略用 `barstate.isconfirmed` 在 K 棒收盤確認訊號，再於次根 K 棒開盤成交。XS 版採等效寫法：

- 進場條件全部改讀「已收盤的前一根 K 棒」（`[1]` 起算），並用 `IsFirstCall("Bar")` 讓每根 K 棒只評估一次，於該根開盤送市價單。
- 出場（止損觸價、移動止盈、時段強平）每次洗價都檢查，用當下 `High`／`Low` 觸價判斷，對應原策略停損單的盤中成交。

### 逐項對應

| 原策略機制 | XS 版寫法 |
|---|---|
| `strategy.entry` / `strategy.close_all` | `SetPosition(口數, Market, label:="…")`，平倉 `SetPosition(0, …)` |
| `strategy.exit(stop=…)` | 自行維護 `_StopPrice`，用 `Low <= _StopPrice`（空單 `High >= _StopPrice`）觸價 |
| `strategy.exit(trail_points, trail_offset)` | 自行維護 `_PeakPrice`，浮盈達觸發點數後以 `峰值 −(峰值−成本)×回吐%` 為出場價 |
| `strategy.closedtrades.*` 迴圈統計 | 出場當下自行判定盈虧（觸發價 vs `_EntryPrice`）並更新阻斷計數 |
| `syminfo.mintick` | 台指期最小跳動為 1 點，直接以點數計算 |
| `math.max` / `math.min` / `math.abs` | `MaxList` / `MinList` / `AbsValue` |
| `ta.sma` / `ta.ema` / `ta.wma` | `Average` / `XAverage` / `WMA` |
| `ta.rma(src, n)` | `XAverage(src, 2n−1)`（平滑係數同為 1/n） |
| `ta.hma(src, n)` | `WMA(2×WMA(n/2) − WMA(n), sqrt(n))` 手工組合 |
| `input.source(close)` | XS 無此參數型別，改為 `_Src = Close;` 單點修改 |
| 時間戳重疊法判斷禁止時段 | 以 `CurrentTime` 判斷「當下時刻」是否落在時段內 |
| `dayofweek(time, tz)` | `DayOfWeek(Date)`（0 = 星期日） |

### 未移植的部分

| 原策略功能 | 原因 |
|---|---|
| `plot` 均線／止損線、`label.new` 止盈止損標籤、`table` 資訊面板 | XS 自動交易腳本無圖表輸出；需要看圖請另寫指標腳本 |
| `alert_message = "buy"/"sell"/"close"` | XQ 自動交易直接送單，無需 webhook 訊息；改用 `label:=` 標記交易指令 |
| `daily_wins` / `daily_losses` 每日勝負統計 | 原策略僅供面板顯示，未參與交易決策 |
| `strategy.cancel_all()` | XS 版一律市價單，無未成交委託需撤銷 |

### 已知行為差異

1. **禁止時段判斷改為「時刻」而非「K 棒重疊」**：原策略只要 K 棒與禁止時段有重疊就整根不開倉，XS 版判斷送單當下時刻是否在時段內。分鐘線下差異最多一根 K 棒。
2. **尾盤時段與 08:45 判斷用 `CurrentTime`**，原策略用 `time_close`（K 棒結束時間），非 1 分鐘頻率下起訖點會差一個 K 棒間隔。
3. **止盈後冷靜期以 K 棒編號計算**：嚴格模式需距上次止盈 ≥ 2 根、寬鬆模式 ≥ 1 根，語意與原策略一致，但兩平台的 bar 計數起點不同，實際落點可能相差一根。
4. **同一次洗價只會送出一個交易指令**（XS 平台規則），故出場與進場不會在同一次洗價同時發生；程式已將出場優先於進場。
5. **進場加上 `Filled = 0` 條件**：避開平倉委託尚未回報的真空期。若採用「交易帳號庫存部位整合」讓策略帶入既有部位，需自行確認此條件不會擋掉進場。

### 上線前建議

- 先在 XQ 編輯器編譯一次，確認參數 UI 與資料引用筆數無誤。
- 用回測驗證出場價位與原策略落差是否可接受，再切實盤。
- `SetBarBack` 以均線最長期數 ×4＋60 估算；若把均線期數調到很大，回測報「引用筆數不足」時再往上加。
