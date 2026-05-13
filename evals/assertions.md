# Assertions (草稿 — 待跑完所有測試後決定是否最終化)

每個 assertion 都要能客觀地對著 `response.md` 檔案內容判斷 pass/fail，並用簡短描述讓 viewer 一眼看懂。

## eval-0: type-ambiguous（外資買超監控）

**核心測試**：類別模糊（可選股 or 警示）時，新版應反問類別、舊版可能直接寫程式碼。

- `asks_about_script_type`：回應中明確列出 5 種腳本類別（指標/交易/警示/選股/函數）並反問選哪一種
- `no_xs_code_block`：回應**不包含** XS 程式碼塊（用 `if (條件) then ret=1;` 之類）— 因為類別未定就不該寫
- `mentions_alert_vs_selector`：點出「警示 (盤中)」與「選股 (盤後)」兩個合理選項
- `notes_data_lag`：若有提到外資買賣超資料盤後才更新（look-ahead bias）為加分項

## eval-1: selector-revenue（月營收成長率選股）

**核心測試**：頻率切換陷阱 — 月頻必須用「營收年增率」而非「營收成長率」。

- `uses_correct_field_for_M`：程式碼使用 `GetField("營收年增率", "M")` 而非 `GetField("營收成長率", "M")` — 後者會回 0
- `uses_pe_ratio_field`：使用 `GetField("本益比", ...)` 或同義欄位
- `has_ret_1`：使用 `ret = 1` 觸發選股
- `has_output_field`：使用 `OutputField` 或 `outputField1` 輸出顯示欄位
- `script_compiles_mentally`：邏輯結構正確（`if 條件 then ret = 1;`、無語法錯誤）

## eval-2: trading-day-trade（股票當沖）

**核心測試**：交易腳本最複雜，看是否齊集多項規範。

- `uses_setposition_not_buy`：用 `SetPosition` 而非 `Buy`/`Sell`/`Short`/`Cover`
- `double_position_check`：進場/出場有 `Filled` 與 `Position` 雙重檢查（股票必備）
- `intrabarpersist_state_vars`：狀態變數（如進場價、已進場旗標）使用 `intrabarpersist`
- `intportion_lot_sizing`：張數計算使用 `IntPortion(_Amount * 10000 / (漲停價 * 1000))`，不直接除以股價
- `forced_close_logic`：含「收盤前 N 分鐘強平」邏輯（時間 vs `_TimeExit`）
- `daytrade_eligibility_check`：含「買賣現沖」資格檢查
- `mentions_pct_change_open5min`：邏輯正確處理「開盤後 5 分鐘內漲幅 > 2%」（用日開盤價 vs 5 分鐘 K 棒）

## eval-3: pinescript-conv（PineScript → XS）

**核心測試**：禁用語法替換。

- `no_strategy_entry`：不出現 `strategy.entry` / `strategy.close`
- `no_buy_sell`：不出現 `Buy` / `Sell` / `Short` / `Cover`
- `no_double_equals`：不出現 `==`
- `uses_setposition`：使用 `SetPosition(口數)` 進出場
- `uses_crossover_function`：使用 `CrossOver` / `CrossUnder` （也接受 `crosses above` / `crosses below`）
- `uses_xs_ema`：使用 `XAverage` 或 `EMA`（不是 `ta.ema`）
- `inputs_for_period`：把 EMA 期數寫成 input 參數而非寫死 20

## eval-4: cross-frequency（5 分鐘線看日線 RSI）

**核心測試**：跨頻率正確取值與資源宣告。

- `uses_cross_freq_function`：使用 `xfMin_RSI`、`xf_RSI` 或 `GetField("RSI", "D")` 取得日線 RSI
- `no_var_for_xf`：不把跨頻率取值存進變數後再引用（會錯位）
- `setbarback_or_settotalbar`：含 `SetBarBack` 或 `SetTotalBar` 設定足夠回溯範圍
- `has_plot`：使用 `plot1` 或同等繪圖函數
- `no_plotk_mix`：沒有 plot 與 PlotK 混用

## eval-5: infeasible-selector（分鐘級選股 — 不可行）

**核心測試**：技術可行性預審 — 應拒絕並提替代方案。

- `refuses_minute_selector`：明確說明「選股不支援分鐘頻率」或同義
- `no_minute_getfield`：不寫出 `GetField(..., "1")` 之類分鐘頻率呼叫
- `suggests_alert_alternative`：建議改用「警示 / 策略雷達」做分鐘級監控
- `explains_why`：解釋原因（選股引擎是盤後批次、不支援分鐘回溯）
- `no_full_script_generated`：不交付完整的「選股程式碼」假裝可以執行
