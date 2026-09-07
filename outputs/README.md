# outputs — 定稿產出

| 檔案 | 說明 |
|---|---|
| `txf_dual_green_strategy.xs` | 台指期「雙陽開泰策略 V3.93」的 XS 自動交易腳本版（由 PineScript v6 轉寫） |
| `txf_dual_grid_dca_strategy.xs` | 台指期「雙向網格策略 V1.31（微台版）」的 XS 自動交易腳本版（由 PineScript v6 轉寫） |

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

---

## txf_dual_grid_dca_strategy.xs

**類別**：交易腳本（自動交易）　**頻率**：分鐘　**商品**：微台／小台／台指期

### 兩處必須改架構的地方

**1. 網格掛單改為觸價加碼。** 原策略在首倉成交當下，一次掛出 `Long_1`～`Long_8` 共 8 張限價單等待成交。XS 的 `SetPosition` 管的是「目標部位」，且官方明定「至多只會保留一筆尚未完成成交的委託」，無法同時維持多筆網格限價單。改寫方式：每次洗價掃描各層網格價位，找出目前價格已觸及的最深一層，一次 `SetPosition` 補到對應口數（可跨層）。

| 影響 | 說明 |
|---|---|
| 成交價 | 原策略每層在網格價限價成交；XS 版在觸價當下以市價成交。急殺跨多層時，XS 版的平均成本會比原策略差 |
| 跨層補倉 | 已用「補到目標口數」而非逐層加，單次洗價即可跨越多層，不會落後行情 |
| 撤單 | 原策略平倉後需 `strategy.cancel_all()` 清掉未成交網格單；XS 版全走市價，無殘單需要處理 |

**2. 360 分鐘頻率不支援。** XS 官方 `GetField` 頻率代碼為 1／2／3／5／10／15／20／30／45／60／90／120／135／180／240 分鐘，沒有 360。已把通道取價頻率做成參數 `_ChanFreq`，預設 **240 分鐘**（最接近的支援值）。要更保守可改 180，更貼近日內節奏可改 120 或 60。

> 註：原策略的 `ta.ema(ma_high_data, 200)` 是在**圖表主頻**上對 360 分鐘高低價序列做平滑，不是在 360 分鐘頻率上做 200 期平滑。XS 版沿用同一層級：`XAverage(GetField("最高價", 頻率), 期數)`，平滑同樣發生在主頻。

### 逐項對應

| 原策略機制 | XS 版寫法 |
|---|---|
| `strategy.entry(qty=...)` 首倉 | `SetPosition(口數, Market, label:="首倉做多／做空")` |
| `strategy.entry(limit=...)` 網格加倉 | 觸價後 `SetPosition(目標口數, Market, label:="網格加碼…")` |
| `strategy.exit(stop=, limit=)` | 自行以 `Low`／`High` 觸價判斷，`SetPosition(0, Market, …)` 平倉 |
| `strategy.position_avg_price` | `FilledAvgPrice` |
| `strategy.opentrades` | `IntPortion(AbsValue(Filled) / 每次口數)` |
| `get_cumulative_offset()` 等比級數 | `for` 迴圈逐層累加間距，天然涵蓋乘數＝1 的情形，不需除法 |
| `ta.sma` / `ta.ema` | `Average` / `XAverage` |
| `ta.crossover(macd, signal)` | `(_Macd[1] > _MacdSignal[1]) and (_Macd[2] <= _MacdSignal[2])` |
| `request.security(…, '360', high)` | `GetField("最高價", 頻率參數)` |
| `math.pow` / `math.floor` / `math.abs` | `Power` / `IntPortion` / `AbsValue` |
| `input.source(high)` | XS 無此參數型別，直接寫死「最高價」／「最低價」 |
| 止損反手排程 `pending_reverse_*_bar` | `intrabarpersist _PendingRevLong／_PendingRevShort` 存 K 棒編號 |

### 未移植的部分

| 原策略功能 | 原因 |
|---|---|
| `plot` 均線、平均成本、止盈止損線、三條網格線 | XS 自動交易腳本無圖表輸出 |
| `label.new` 首多／加多／止盈止損標籤 | 同上；交易紀錄改由 `SetPosition` 的 `label` 呈現 |
| `commission_value`、`initial_capital`、`margin_long/short` | 屬 XQ 回測與帳戶設定，不寫在腳本內 |
| `pyramiding=50` | XS 無此概念，總部位直接由 `SetPosition` 控制，上限改由「最大總持倉口數上限」參數把關 |
| `strategy.cancel_all()` | XS 版全走市價，無未成交網格單 |

### 已知行為差異

1. **加碼成交價**：見上表，急殺跨層時平均成本會比原策略差。這是 XS 無多筆掛單機制的必然結果。
2. **訊號延遲一根**：原策略 `process_orders_on_close=true`，訊號 K 收盤即成交；XS 版在下一根 K 棒開盤成交。
3. **出場優先序**：同一次洗價只能送出一個交易指令，程式已排定「止損 → 止盈 → 網格加碼 → 首倉進場」的優先序。
4. **止損反手不受指標條件限制**：與原策略一致，止損平倉的下一根 K 棒無條件反向開倉；止盈平倉不觸發。
5. **`SetBarBack(150, _ChanFreq)` 傳入變數頻率字串**：若 XQ 編譯此行報錯，改成字面值（例如 `SetBarBack(150, "240");`）即可。

### 上線前建議

- 先在 XQ 編輯器編譯一次，確認參數 UI 與跨頻率取價正常。
- 回測時特別比對「加碼層數與平均成本」，這是與原策略差異最大的一段。
- 全局止損預設 2500 點，配合最大 10 口，單筆最差情境的曝險請自行換算契約乘數後確認可承受。
