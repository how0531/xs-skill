# -*- coding: utf-8 -*-
"""
從 references/source/XScript_實戰範例寶典_下.md 抽取 622 場景並依主題重新整理，
產出 references/examples-index.md 取代原本的失效索引。

分類規則優先序（一個場景命中第一條就停止）：
1. 函數類腳本（自訂函數示範）
2. 警示腳本（Tick / 即時 / 警示 / 雷達）
3. 交易策略（停損/停利/進出場/部位/當沖/波段）
4. 指標類（指標 / 畫 / plot / 圖）
   - 內部再分：趨勢通道 / 動能 / 波動 / 籌碼自製 / 市場結構 / 其他
5. 選股類
   - 內部再分：籌碼 / 營收財報 / 價值評估 / 技術突破 / 盤整反轉 / 量價 / 其他
6. 工具/其他
"""
import re
import json
import sys
from pathlib import Path

SRC = Path('references/source/XScript_實戰範例寶典_下.md')
OUT = Path('references/examples-index.md')

content = SRC.read_text(encoding='utf-8')

# 抽取場景
scenes = []  # list of (num, title, source_url)
pat_scene = re.compile(r'^## 場景 (\d+)：(.+?)$', re.MULTILINE)
pat_url = re.compile(r'\[([^\]]+)\]\((https?://[^)]+xstrader[^)]+)\)')

for m in pat_scene.finditer(content):
    num = int(m.group(1))
    title = m.group(2).strip()
    if ' — ' in title:
        title = title.split(' — ')[0]
    title = title.replace('\\', '')

    # 找出該場景區塊內的「來源」URL（從 ## 起到下一個 ## 為止）
    block_start = m.end()
    next_m = pat_scene.search(content, block_start)
    block = content[block_start:next_m.start() if next_m else len(content)]
    url_match = pat_url.search(block)
    source_url = url_match.group(2) if url_match else ''

    scenes.append((num, title, source_url))


def has_any(s, kws):
    return any(k in s for k in kws)


def classify(num, title):
    t = title

    # 1. 函數示範
    if has_any(t, ['自訂函數', '函數寫法', '自製函數', '函數示範']):
        return ('函數', '自訂函數')

    # 2. 警示
    if has_any(t, ['警示', '雷達', '即時', 'Tick', 'tick']):
        return ('警示', '策略雷達')

    # 3. 交易策略 (明確談部位/停損/出場)
    if has_any(t, ['停損', '停利', '加碼', '減碼', '當沖', '波段', '進場', '出場', '回測']) and not has_any(t, ['指標']):
        return ('交易', '進出場停損停利')
    if has_any(t, ['交易策略', '自動交易', '部位', 'setposition']):
        return ('交易', '策略架構')

    # 4. 指標 (出現「指標」「畫」「圖」字眼)
    is_indicator = has_any(t, ['指標', '畫', '示意圖']) or t.endswith('圖')
    if is_indicator:
        if has_any(t, ['均線', '趨勢', '通道', '唐奇安', '線性迴歸', '斜率', '排列', '多空趨勢']):
            return ('指標', '趨勢與通道')
        if has_any(t, ['KD', 'RSI', 'MACD', 'DMI', '動能', '動量', 'MTM', '威廉', 'PercentR']):
            return ('指標', '動能與超買超賣')
        if has_any(t, ['波動', '標準差', 'ATR', '布林', 'BollingerBand', '震幅', '振幅']):
            return ('指標', '波動與通道寬度')
        if has_any(t, ['籌碼', '融資', '融券', '外資', '主力', '法人', '量能', '大單', '內外盤', '主動']):
            return ('指標', '籌碼與量能')
        if has_any(t, ['大盤', '類股', '輪動', '領先', '同步', '成分股', '產業', '族群', '相對強弱', '相關']):
            return ('指標', '大盤與類股')
        return ('指標', '其他自製指標')

    # 5. 選股
    if has_any(t, ['外資', '投信', '主力', '融資', '融券', '法人', '大戶', '散戶', '券商', '官股', '集保', '質設', '董監', '內部人', '借券', '當沖張數', '主力買賣超']):
        return ('選股', '籌碼面')
    if has_any(t, ['營收', 'EPS', '本益比', '股利', '殖利率', 'ROE', 'roa', '淨值', '股東權益', '財報', '毛利', '營業利益', '稅後淨利', '現金流', 'PB', 'PE', '營業現金流']):
        return ('選股', '營收與財報')
    if has_any(t, ['估值', '便宜', '折價', '價值', 'PEG', '葛拉罕', '巴菲特', '彼得林區', '低估', 'Buffett', 'Lynch', '葛拉漢', '深度價值']):
        return ('選股', '價值評估')
    if has_any(t, ['創新高', '創高', '突破', '黃金交叉', '穿越', '跨越', '新高', '創', '黃金']):
        return ('選股', '創高與突破')
    if has_any(t, ['死亡交叉', '跌破', '空方', '翻空', '走弱', '殺盤', '崩跌', '收黑']):
        return ('選股', '空方與下跌')
    if has_any(t, ['盤整', '底部', '低檔', '反彈', '反轉', '築底', '止跌', '打底', '抄底', '回升', '回穩', '見底']):
        return ('選股', '盤整與反轉')
    if has_any(t, ['量', '價量', '爆量', '成交量', '價', '漲幅', '跌幅', '漲停', '跌停', '上漲', '下跌', '收盤']):
        return ('選股', '量價與漲跌')
    if has_any(t, ['月營收', '累計營收', '營收年增率', '營收月增率']):
        return ('選股', '營收與財報')
    if has_any(t, ['趨勢', '上升', '上昇', '下降', '走勢', '攻擊', '橫盤', '走高', '走低']):
        return ('選股', '趨勢判斷')
    if has_any(t, ['儀表板', '績效', '看盤', '函數', '工具', '指南', '心得', '說明']):
        return ('工具與心得', '雜項')

    return ('選股', '其他主題策略')


from collections import defaultdict
buckets = defaultdict(lambda: defaultdict(list))
for num, title, url in scenes:
    cat, sub = classify(num, title)
    buckets[cat][sub].append((num, title, url))

# 統計
stats_path = Path('/tmp/index-stats.txt')
with stats_path.open('w', encoding='utf-8') as f:
    total = 0
    for cat, subs in buckets.items():
        cat_total = sum(len(v) for v in subs.values())
        total += cat_total
        f.write(f'{cat}: {cat_total}\n')
        for sub, items in subs.items():
            f.write(f'  {sub}: {len(items)}\n')
    f.write(f'TOTAL: {total}\n')

# 產出 markdown
PRIMARY_ORDER = ['選股', '指標', '交易', '警示', '函數', '工具與心得']
SUB_ORDER = {
    '選股': ['籌碼面', '營收與財報', '價值評估', '創高與突破', '空方與下跌', '盤整與反轉', '量價與漲跌', '趨勢判斷', '其他主題策略'],
    '指標': ['趨勢與通道', '動能與超買超賣', '波動與通道寬度', '籌碼與量能', '大盤與類股', '其他自製指標'],
    '交易': ['策略架構', '進出場停損停利'],
    '警示': ['策略雷達'],
    '函數': ['自訂函數'],
    '工具與心得': ['雜項'],
}

lines = []
lines.append('# XScript 實戰範例索引（場景 620–1241）')
lines.append('')
lines.append('> 索引整理自 [www.xq.com.tw/xstrader/](https://www.xq.com.tw/xstrader/) 的 **622 個官方場景**（原始檔位於 `references/source/XScript_實戰範例寶典_下.md`，共 21K+ 行、594 KB）。')
lines.append('')
lines.append(f'**總場景數**：{len(scenes)} 個（場景 {scenes[0][0]} ~ {scenes[-1][0]}）')
lines.append('')
lines.append('## 使用方式')
lines.append('')
lines.append('1. **找對應主題** → 從下方分類找到場景編號')
lines.append('2. **讀完整腳本** → 用 grep/Read 在 `references/source/XScript_實戰範例寶典_下.md` 內搜尋 `## 場景 N：` 取得完整程式碼')
lines.append('3. **看原始說明** → 點擊「來源」連結看 xstrader 原文敘述')
lines.append('')
lines.append('> **提示**：分類為自動標籤，僅作快速導航；場景內容常常同時涉及多主題（例如「籌碼+技術突破」），找不到時請直接 grep 關鍵字。')
lines.append('')
lines.append('## 外部範例庫（200+ .xs 檔案）')
lines.append('')
lines.append('進階使用者可至官方 XScript Preset 庫挖更完整的範例集：')
lines.append('')
lines.append('- [how0531/XScript_Preset](https://github.com/how0531/XScript_Preset) — 200+ 個 `.xs` 範例檔')
lines.append('  - `指標/XQ技術指標/` — KD / MACD / RSI / DMI 等經典指標的官方版')
lines.append('  - `指標/跨頻率指標/` — `分鐘與日KD.xs`、`週KD.xs` 等跨頻率範例')
lines.append('  - `自動交易/0-基本語法/` — `01-SetPosition.xs`、`03-Filled.xs`、`05-FilledAvgPrice以及停損停利範例.xs`（**初學必讀**）')
lines.append('  - `自動交易/常見技術分析/` — 均線交叉、KD、MACD、布林通道等策略')
lines.append('  - `選股/00.語法範例/` — `_基本範例.xs`、`月營收創N期新高.xs`、`本益比小於X倍.xs`')
lines.append('  - `選股/04.價量選股/`、`/06.籌碼選股/`、`/07.月營收選股/`、`/08.財報選股/`、`/10.價值投資/`、`/11.選股機器人/`')
lines.append('  - `警示/!語法範例/`、`/1.籌碼監控/`、`/3.出場常用警示/`')
lines.append('  - `函數/技術指標/`、`/跨頻率/`、`/期權相關/`、`/統計分析/`')
lines.append('- [sysjust-xq/XS_Blocks](https://github.com/sysjust-xq/XS_Blocks) — XQ 官方「量化積木」（使用者指定積木時才用）')
lines.append('')
lines.append('---')
lines.append('')

for cat in PRIMARY_ORDER:
    if cat not in buckets:
        continue
    cat_total = sum(len(v) for v in buckets[cat].values())
    lines.append(f'## {cat}（{cat_total} 個場景）')
    lines.append('')
    for sub in SUB_ORDER.get(cat, []):
        items = buckets[cat].get(sub)
        if not items:
            continue
        lines.append(f'### {sub}（{len(items)}）')
        lines.append('')
        for num, title, url in sorted(items):
            if url:
                lines.append(f'- **場景 {num}**：[{title}]({url})')
            else:
                lines.append(f'- **場景 {num}**：{title}')
        lines.append('')

lines.append('---')
lines.append('')
lines.append('## 常見需求 → 起點建議')
lines.append('')
lines.append('| 需求 | 看哪些場景 |')
lines.append('|---|---|')
lines.append('| 月營收選股 | 「選股 > 營收與財報」整段，特別是場景 621、622、630-661、668、800、869 |')
lines.append('| 葛拉罕價值投資 | 場景 629（流動資產減負債 vs 總市值） |')
lines.append('| 布林通道（指標+選股） | 場景 628、688、722-727、870、871 |')
lines.append('| 唐奇安通道 | 場景 1127-1129 |')
lines.append('| 多空趨勢（自製） | 場景 1130、1131 |')
lines.append('| 跨頻率（分鐘 vs 日 vs 週） | 場景 873-880 |')
lines.append('| 大盤抄底 | 場景 683、684、706、748-750 |')
lines.append('| 類股輪動 / sector trade | 場景 870-872 |')
lines.append('| 自製大盤多空函數 | 場景 748-750 |')
lines.append('| 籌碼異常（融資/外資/主力） | 場景 1133、1134、758-770 |')
lines.append('| 個股儀表板 | 場景 717、718、743 |')
lines.append('| 排行語法 rank | 場景 800 附近（搜「排行」/「rank」） |')
lines.append('')
lines.append('---')
lines.append('')
lines.append('## 也可參考')
lines.append('')
lines.append('- `references/master-guide.md` — 程序性規則：撰寫流程、可行性預審、look-ahead bias、註解風格、資源宣告')
lines.append('- `references/cheatsheet.md` — 純查表：函數分類、欄位命名、頻率商品相容、常用片段')
lines.append('- `references/anti-patterns.md` — 26 條踩雷對照與重構案例（含頻率切換、欄位正名、變數命名片段衝突）')
lines.append('- `references/script-types/*.md` — 五種腳本類別的專屬規範')
lines.append('')

OUT.write_text('\n'.join(lines), encoding='utf-8')
print(f'Wrote {OUT} ({OUT.stat().st_size} bytes)', file=sys.stderr)
