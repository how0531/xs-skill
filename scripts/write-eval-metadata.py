# -*- coding: utf-8 -*-
"""填入 evals.json 中每個 eval 的 assertions，並寫到各 eval 目錄的 eval_metadata.json

用法：
    python scripts/write-eval-metadata.py [WORKSPACE]

WORKSPACE 為輸出根目錄，內含 eval-<name>/ 子目錄；省略時可用環境變數
XS_EVAL_WORKSPACE，再省略則預設為目前目錄下的 ./eval-workspace。
"""
import json
import os
import sys
from pathlib import Path

WORKSPACE = Path(
    sys.argv[1] if len(sys.argv) > 1
    else os.environ.get('XS_EVAL_WORKSPACE', 'eval-workspace')
)

ASSERTIONS = {
    'type-ambiguous': [
        '回應反問腳本類別（明確列出 5 種類別之中至少 2 種讓使用者選）',
        '回應不包含完整的可執行 XS 程式碼塊（因類別未定不該寫）',
        '提到「警示/策略雷達」與「選股」兩個合理選項',
        '提到外資買賣超是盤後資料、有 look-ahead bias 風險',
    ],
    'selector-revenue': [
        '使用 GetField("營收年增率", "M") 而非 GetField("營收成長率", "M")',
        '使用本益比欄位篩選（如 GetField("本益比") 或同義）',
        '使用 ret = 1 觸發選股',
        '使用 OutputField 或 outputField1 等輸出顯示欄位',
        'input 與 var 有以 _ 前綴命名',
    ],
    'trading-day-trade': [
        '使用 SetPosition 而非 Buy/Sell/Short/Cover',
        '進出場有 Filled 與 Position 雙重檢查（如 Filled = Position）',
        '狀態變數使用 intrabarpersist',
        '張數計算使用 IntPortion(... / (漲停價 * 1000))，不直接除以股價',
        '含收盤前強制平倉邏輯（時間判斷或 EnterMarketCloseTime）',
        '含買賣現沖資格檢查（GetSymbolInfo 或同義）',
        '不出現 MarketPosition 或 BarsSinceEntry 等禁用語法',
    ],
    'pinescript-conv': [
        '不出現 strategy.entry 或 strategy.close',
        '不出現 Buy / Sell / Short / Cover',
        '不出現 == 雙等號',
        '使用 SetPosition(口數) 進出場',
        '使用 CrossOver / CrossUnder（或 crosses above/below）',
        '使用 XAverage 或 EMA 取代 ta.ema',
        'EMA 期數使用 input 參數而非寫死數字',
    ],
    'cross-frequency': [
        '使用 xfMin_RSI、xf_RSI 或 GetField("RSI", "D") 取得日線 RSI',
        '不把跨頻率 GetField 取值存進變數後再引用（直接在邏輯/plot 中呼叫）',
        '含 SetBarBack 或 SetTotalBar 設定足夠回溯範圍',
        '使用 plot1 或同等繪圖函數',
        '不混用 plot 與 PlotK',
    ],
    'infeasible-selector': [
        '明確說明選股不支援分鐘頻率（或同義）',
        '不交付完整的「分鐘頻率選股程式碼」假裝可以執行',
        '建議改用警示腳本（策略雷達）作為替代方案',
        '解釋技術原因（選股引擎是盤後批次、不支援分鐘回溯）',
    ],
    'lookahead-bias': [
        '外資買賣超用 GetField("外資買賣超", "D")[1] 而非 [0]',
        '說明外資資料盤後才公布、盤中取當日會 look-ahead',
        '用 ret = 1 + retmsg 推播',
        '不使用 OutputField（警示腳本不支援）',
    ],
    'field-rename': [
        '使用「負債總額」而非「總負債」',
        '使用「資產總額」而非「總資產」',
        '除法前判斷分母（資產總額）<> 0',
        '用 ret = 1 觸發選股',
        '用 OutputField 輸出顯示欄位',
    ],
    'intrabarpersist-detect-change': [
        '宣告 intrabarpersist 變數（如 _LastPos）追蹤上次值',
        '不用 position[1] / filled[1] 偵測剛變動',
        '印完 log 後立刻 _LastPos = position 同步',
        '狀態變數在每日歸零區重置',
        '方向判定用 position 對 _LastPos 前後差，不用 filled[1]',
    ],
}

PROMPTS = {
    'type-ambiguous': '我想做一個外資買超的監控，外資連續三天買超的就要通知我',
    'selector-revenue': '幫我寫個選股腳本：找出最近一個月營收成長率超過 20%，且本益比小於 15 的台股',
    'trading-day-trade': '幫我寫一個股票當沖策略：開盤後 5 分鐘內漲幅超過 2% 就進場做多，停損 1.5%、停利 3%，收盤前 10 分鐘強制平倉',
    'pinescript-conv': "幫我把這段 PineScript 轉成 XS：strategy.entry('Long', when=ta.crossover(close, ta.ema(close, 20))) ; strategy.close('Long', when=ta.crossunder(close, ta.ema(close, 20)))",
    'cross-frequency': '5 分鐘線上看日線的 RSI，幫我畫成指標',
    'infeasible-selector': '幫我寫個選股，每 1 分鐘抓出當下漲幅超過 3% 的股票',
    'lookahead-bias': '幫我寫一個策略雷達：外資今天買超超過 5000 張的股票就推播通知我',
    'field-rename': '幫我寫選股：負債比（總負債除以總資產）小於 40% 的台股',
    'intrabarpersist-detect-change': '自動交易腳本裡，我想在部位剛變動的時候印一筆 log，而且只印一次',
}

for i, name in enumerate(ASSERTIONS):
    meta = {
        'eval_id': i,
        'eval_name': name,
        'prompt': PROMPTS[name],
        'assertions': ASSERTIONS[name],
    }
    eval_dir = WORKSPACE / f'eval-{name}'
    eval_dir.mkdir(parents=True, exist_ok=True)
    (eval_dir / 'eval_metadata.json').write_text(
        json.dumps(meta, ensure_ascii=False, indent=2),
        encoding='utf-8'
    )
    print(f'  wrote eval-{name}/eval_metadata.json with {len(ASSERTIONS[name])} assertions')

print('Done')
