# -*- coding: utf-8 -*-
"""
從 references/source/XScript_實戰範例寶典_下.md 抽取 622 個場景並依主題分類。
產出：
- /tmp/scenes-categorized.json （供後續腳本使用）
- 印出各類別統計
"""
import re
import json
import sys

SRC = 'references/source/XScript_實戰範例寶典_下.md'

with open(SRC, 'r', encoding='utf-8') as f:
    content = f.read()

pattern = r'^## 場景 (\d+)：(.+?)$'
scenes = []
for m in re.finditer(pattern, content, re.MULTILINE):
    num = int(m.group(1))
    title = m.group(2).strip()
    if ' — ' in title:
        title = title.split(' — ')[0]
    scenes.append((num, title))

print(f'Total: {len(scenes)} scenes, range {scenes[0][0]}-{scenes[-1][0]}', file=sys.stderr)

categories = {
    '選股_籌碼': [],
    '選股_營收財報': [],
    '選股_價值評估': [],
    '選股_技術突破': [],
    '選股_盤整反轉': [],
    '選股_其他': [],
    '指標_趨勢通道': [],
    '指標_動能': [],
    '指標_波動': [],
    '指標_籌碼自製': [],
    '指標_市場結構': [],
    '指標_其他': [],
    '交易_策略': [],
    '警示_策略雷達': [],
    '其他': [],
}

def has_any(s, kws):
    return any(k in s for k in kws)

for num, title in scenes:
    # Indicator first (talks about 指標/畫圖)
    is_indicator = has_any(title, ['指標', '畫'])
    if is_indicator:
        if has_any(title, ['均線', '趨勢', '通道', '唐奇安', '線性迴歸', '斜率']):
            categories['指標_趨勢通道'].append((num, title))
        elif has_any(title, ['KD', 'RSI', 'MACD', '動能', '動量', 'MTM', '威廉']):
            categories['指標_動能'].append((num, title))
        elif has_any(title, ['波動', '標準差', 'ATR', '布林']):
            categories['指標_波動'].append((num, title))
        elif has_any(title, ['籌碼', '融資', '外資', '主力', '法人', '量能']):
            categories['指標_籌碼自製'].append((num, title))
        elif has_any(title, ['大盤', '類股', '輪動', '領先', '同步', '成分股', '產業']):
            categories['指標_市場結構'].append((num, title))
        else:
            categories['指標_其他'].append((num, title))
        continue

    # Trading / strategy
    if has_any(title, ['交易策略', '當沖', '波段', '停損', '停利', '加碼', '減碼', '進場', '出場']):
        categories['交易_策略'].append((num, title))
        continue
    # Alert
    if has_any(title, ['警示', '雷達', 'Tick', '即時']):
        categories['警示_策略雷達'].append((num, title))
        continue

    # Stock picker buckets
    if has_any(title, ['外資', '投信', '主力', '融資', '融券', '法人', '大戶', '散戶', '券商', '官股', '集保', '質押', '質設', '董監', '內部人', '借券']):
        categories['選股_籌碼'].append((num, title))
    elif has_any(title, ['營收', '月營收', '累計營收', 'EPS', '本益比', '股利', '殖利率', 'ROE', 'roa', '淨值', '股東權益', '財報', '毛利', '營業利益', '稅後淨利', '現金流']):
        categories['選股_營收財報'].append((num, title))
    elif has_any(title, ['估值', '便宜', '折價', '價值', 'PEG', '葛拉罕', '巴菲特', '彼得林區', '低估', 'Buffett', 'Lynch', '葛拉漢']):
        categories['選股_價值評估'].append((num, title))
    elif has_any(title, ['創新高', '創高', '突破', '黃金交叉', '穿越', '跨越']):
        categories['選股_技術突破'].append((num, title))
    elif has_any(title, ['盤整', '底部', '低檔', '反彈', '反轉', '築底', '止跌', '打底']):
        categories['選股_盤整反轉'].append((num, title))
    elif has_any(title, ['選股', '股票', '挑出', '挑選', '篩選', '找出', '尋找']):
        categories['選股_其他'].append((num, title))
    else:
        categories['其他'].append((num, title))

stats = {k: len(v) for k, v in categories.items()}
total = sum(stats.values())
print(f'TOTAL_CATEGORIZED: {total}', file=sys.stderr)
for k, n in stats.items():
    print(f'  {k}: {n}', file=sys.stderr)

with open('/tmp/scenes-categorized.json', 'w', encoding='utf-8') as f:
    json.dump(categories, f, ensure_ascii=False, indent=1)

print('OK', file=sys.stderr)
