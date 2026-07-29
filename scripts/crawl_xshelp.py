# -*- coding: utf-8 -*-
"""XSHelp 官方文件爬蟲：https://xshelp.xq.com.tw/XSHelp/

爬取全部分類（函數/欄位/關鍵字）→ 每分類一個 markdown 檔 + INDEX.md
輸出到 skill 的 references/xshelp/。原始 HTML 快取在 --cache 目錄，重跑可續傳。

用法：
    python crawl_xshelp.py                      # 全站爬取
    python crawl_xshelp.py --only GENERALFUNC   # 只爬單一分類（測試用）
"""
import argparse
import html
import io
import json
import os
import re
import sys
import time
import urllib.parse
import urllib.request
from concurrent.futures import ThreadPoolExecutor

BASE = "https://xshelp.xq.com.tw"
SKILL_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT_DIR = os.path.join(SKILL_DIR, "references", "xshelp")
UA = {"User-Agent": "Mozilla/5.0 (xs-skill doc sync)"}


def fetch(url, cache_dir, key):
    """抓一頁，快取到本地檔；已存在就直接讀。"""
    path = os.path.join(cache_dir, key)
    if os.path.exists(path) and os.path.getsize(path) > 0:
        return io.open(path, encoding="utf-8").read()
    req = urllib.request.Request(url, headers=UA)
    for attempt in range(3):
        try:
            with urllib.request.urlopen(req, timeout=30) as r:
                text = r.read().decode("utf-8")
            break
        except Exception:
            if attempt == 2:
                raise
            time.sleep(2 * (attempt + 1))
    with io.open(path, "w", encoding="utf-8") as f:
        f.write(text)
    time.sleep(0.1)  # 禮貌延遲
    return text


def parse_menu(index_html):
    """從首頁 cssmenu 解析：回傳 [(section中文, 分類code, 分類中文)]，保留官網順序。"""
    m = re.search(r'<div id="cssmenu">.*?</div>', index_html, re.S)
    menu = m.group(0)
    out, section = [], None
    for mm in re.finditer(
        r'<span>([^<]+)</span>|<a href="/XSHelp/lists\?a=([A-Z0-9]+)">([^<]+)</a>', menu
    ):
        if mm.group(1):
            section = mm.group(1).strip()
        else:
            out.append((section, mm.group(2), mm.group(3).strip()))
    return out


def parse_list(list_html):
    """清單頁 → [(HelpName, 中文名, 語法摘要)]。表格每列：連結+中文名+語法。"""
    items = []
    # 每個項目是一個 <tr>；第一欄 a 連結，之後兩欄
    for row in re.findall(r"<tr[^>]*>(.*?)</tr>", list_html, re.S):
        a = re.search(r'href="/XSHelp/\?HelpName=([^&"]+)&(?:amp;)?group=[A-Z0-9]+"[^>]*>([^<]*)</a>', row)
        if not a:
            continue
        name = urllib.parse.unquote(a.group(1))
        tds = re.findall(r"<td[^>]*>(.*?)</td>", row, re.S)
        texts = [html.unescape(re.sub(r"<[^>]+>", " ", td)).strip() for td in tds]
        texts = [re.sub(r"\s+", " ", t) for t in texts]
        cname = texts[1] if len(texts) > 1 else ""
        syntax = texts[2] if len(texts) > 2 else ""
        items.append((name, cname, syntax))
    return items


def html_to_md(fragment):
    """把 content-txt 內的 HTML 轉成 markdown（夠用就好）。"""
    t = fragment
    # 注意：這裡「不可」先 unescape，否則程式碼中的 <= 會被後面的標籤剝除 regex 吃掉；
    # entity 留到函數最後的 html.unescape 統一還原
    t = re.sub(r"<pre><code[^>]*>(.*?)</code></pre>",
               lambda m: "\n```xs\n" + m.group(1).strip() + "\n```\n",
               t, flags=re.S)
    t = re.sub(r"<br\s*/?>", "\n", t)
    t = re.sub(r"<li[^>]*>", "\n- ", t)
    t = re.sub(r"</(p|ul|ol|div|table|tr)>", "\n", t)
    t = re.sub(r"<hr\s*/?>", "\n---\n", t)
    t = re.sub(r"</td>", " | ", t)
    t = re.sub(r"<(strong|b)>", "**", t)
    t = re.sub(r"</(strong|b)>", "**", t)
    t = re.sub(r"<[^>]+>", "", t)
    t = html.unescape(t)
    t = re.sub(r"[ \t]+\n", "\n", t)
    t = re.sub(r"\n{3,}", "\n\n", t)
    return t.strip()


def parse_detail(detail_html):
    """單頁 → {syntax, desc}（markdown）。"""
    m = re.search(
        r'<div class="fnc-title">.*?</div>\s*</div>\s*<!-- XSHighlight -->|'
        r'<div class="content-txt">\s*<div class="fnc-title">(.*?)</div>\s*</div>\s*<!--',
        detail_html, re.S)
    # 直接抓各區塊，較穩
    def block(cls):
        mm = re.search(r'<div class="%s">(.*?)</div>\s*(?:<div class="section-title">|</div>\s*<!--)' % cls,
                       detail_html, re.S)
        return html_to_md(mm.group(1)) if mm else ""
    syntax = block("syntax")
    # desc 區塊可能含巢狀 div，改用貪婪到 XSHighlight 註解前
    mm = re.search(r'<div class="desc">(.*?)</div>\s*</div>\s*<!-- XSHighlight -->', detail_html, re.S)
    desc = html_to_md(mm.group(1)) if mm else ""
    return syntax, desc


def parse_article(page_html):
    """文章式頁面（關鍵字類）→ (標題, markdown 內文)。"""
    mm = re.search(r'<div class="keyword_title">(.*?)</div>', page_html, re.S)
    title = html.unescape(re.sub(r"<[^>]+>", "", mm.group(1))).strip() if mm else ""
    mb = re.search(r'<div class="keyword_title">.*?</div>(.*?)</div>\s*<!-- XSHighlight -->',
                   page_html, re.S)
    body = html_to_md(mb.group(1)) if mb else ""
    return title, body


def crawl_keyword_category(section, code, cname, cache_dir, list_html):
    """關鍵字類（SKIPWORD/CONSTANT/CONTROLFLOW/DECLARATION）：
    清單頁本身是導覽文章，內含 api?a=X 與 article?a=X 子頁連結。"""
    overview_title, overview = parse_article(list_html)
    links, seen = [], set()
    for m in re.finditer(r'href="(?:/XSHelp/)?(api|article)\?([^"]+)"', list_html):
        kind, qs = m.group(1), html.unescape(m.group(2))
        a = urllib.parse.parse_qs(qs).get("a", [""])[0]
        if not a or a.lower() in seen:
            continue
        seen.add(a.lower())
        links.append((kind, qs, a))
    results = [{"name": f"{cname}總覽", "cname": "", "syntax": "", "desc": overview}]
    for kind, qs, a in links:
        key = "kw_%s_%s.html" % (code, re.sub(r"[^\w\-]", "_", a))
        try:
            page = fetch(f"{BASE}/XSHelp/{kind}?{qs}", cache_dir, key)
            if 'class="fnc-title"' in page:
                syntax, desc = parse_detail(page)
                title = a
            else:
                title, desc = parse_article(page)
                title, syntax = title or a, ""
            results.append({"name": title, "cname": "", "syntax": syntax, "desc": desc})
        except Exception as e:
            print(f"  [WARN] {code}/{a}: {e}", flush=True)
    return {"section": section, "code": code, "cname": cname, "items": results}


def crawl_sdt(cache_dir):
    """SDT 共享資料表函數家族：不在官網分類選單、單頁也損壞（redirect 到 Emptys），
    唯一完整來源是站內搜尋的 rest API（回傳 desc+fulldesc）。"""
    text = fetch(f"{BASE}/XSHelp/rest?a=SDT", cache_dir, "rest_SDT.json")
    items = []
    for it in json.loads(text):
        if not it["name"].upper().startswith("SDT_"):
            continue
        items.append({
            "name": it["name"],
            "cname": it.get("abbrev") or "",
            "syntax": html_to_md(it.get("desc") or ""),
            "desc": html_to_md((it.get("fulldesc") or "").replace("\r\n", "\n\n")),
        })
    items.sort(key=lambda x: x["name"].lower())
    return {"section": "內建函數", "code": "SDT", "cname": "SDT共享資料表",
            "items": items}


# rest API 全面掃描用查詢詞：字母+數字抓英文名/ename，常用中文字抓純中文條目
SWEEP_TERMS = (list("abcdefghijklmnopqrstuvwxyz0123456789")
               + list("價量率數日時買賣成交均指股金額比委盤期週月年外資主力融券現沖幅家淨值營收益稅債資產週轉息"))

# rest 條目的 father → 鏡像分類 code（欄位類走 categoryid 對映）
FATHER_ROUTE = {"屬性欄位": "ATTRFIELD", "宣告": "DECLARATION", "流程控制": "CONTROLFLOW",
                "忽略字": "SKIPWORD", "常數": "CONSTANT"}


def rest_item(it):
    return {"name": it["name"], "cname": it.get("abbrev") or "",
            "syntax": html_to_md(it.get("desc") or ""),
            "desc": html_to_md((it.get("fulldesc") or "").replace("\r\n", "\n\n"))}


def sweep_rest(cats, cache_dir):
    """官網搜尋 rest API 全面掃描：找出分類選單漏掉的條目，補進對應分類。
    新增分類：ATTRFIELD（屬性欄位=GetSymbolInfo 商品資訊欄位，選單完全沒有）。"""
    union = {}
    for t in SWEEP_TERMS:
        key = "rest_sweep_%s.json" % re.sub(r"[^\w]", "_", t)
        try:
            for it in json.loads(fetch(f"{BASE}/XSHelp/rest?a={urllib.parse.quote(t)}", cache_dir, key)):
                union[it["id"]] = it
        except Exception as e:
            print(f"  [WARN] sweep {t}: {e}", flush=True)
    have = {i["name"].strip().lower() for c in cats for i in c["items"]}
    # categoryid → code 對映（由已入庫條目投票）
    cid_map = {}
    for it in union.values():
        if it["name"].strip().lower() in have and it.get("categoryid"):
            for c in cats:
                if any(i["name"].strip().lower() == it["name"].strip().lower() for i in c["items"]):
                    cid_map.setdefault(it["categoryid"], c["code"])
                    break
    added, attr_items = {}, []
    for it in sorted(union.values(), key=lambda x: (x["name"] or "").lower()):
        if not it["name"] or it["name"].strip().lower() in have:
            continue
        have.add(it["name"].strip().lower())
        code = FATHER_ROUTE.get(it.get("father") or "") or cid_map.get(it.get("categoryid"))
        if code == "ATTRFIELD":
            attr_items.append(rest_item(it))
            continue
        target = next((c for c in cats if c["code"] == code), None)
        if target is None:  # 對不到分類 → 收進 RESTMISC
            target = next((c for c in cats if c["code"] == "RESTMISC"), None)
            if target is None:
                target = {"section": "其他", "code": "RESTMISC", "cname": "搜尋API補遺", "items": []}
                cats.append(target)
        target["items"].append(rest_item(it))
        added[target["code"]] = added.get(target["code"], 0) + 1
    if attr_items:
        cats.append({"section": "屬性欄位", "code": "ATTRFIELD",
                     "cname": "商品資訊欄位(GetSymbolInfo)", "items": attr_items})
        added["ATTRFIELD"] = len(attr_items)
    print("rest 掃描補入：", added, flush=True)


def crawl_category(section, code, cname, cache_dir):
    if code == "SDT":
        return crawl_sdt(cache_dir)
    list_html = fetch(f"{BASE}/XSHelp/lists?a={code}", cache_dir, f"list_{code}.html")
    items = parse_list(list_html)
    if not items and 'class="keyword_title"' in list_html:
        return crawl_keyword_category(section, code, cname, cache_dir, list_html)
    results = []
    for name, item_cname, syntax_summary in items:
        q = urllib.parse.quote(name)
        key = "page_%s_%s.html" % (code, re.sub(r"[^\w\-]", "_", name))
        try:
            page = fetch(f"{BASE}/XSHelp/?HelpName={q}&group={code}", cache_dir, key)
            syntax, desc = parse_detail(page)
        except Exception as e:
            print(f"  [WARN] {code}/{name}: {e}", flush=True)
            syntax, desc = syntax_summary, ""
        results.append({"name": name, "cname": item_cname, "syntax": syntax or syntax_summary, "desc": desc})
    return {"section": section, "code": code, "cname": cname, "items": results}


def write_category_md(cat):
    if cat["code"] == "SDT":
        src = f"{BASE}/XSHelp/rest?a=SDT（站內搜尋 API；此家族不在官網分類選單、單頁已損壞）"
    elif cat["code"] in ("ATTRFIELD", "RESTMISC"):
        src = f"{BASE}/XSHelp/rest 全面掃描（站內搜尋 API；官網分類選單無此分類）"
    else:
        src = f"{BASE}/XSHelp/lists?a={cat['code']}（官方 XSHelp，自動爬取）"
    lines = [
        f"# {cat['section']} - {cat['cname']}（{cat['code']}）",
        "",
        f"> 來源：{src}",
        "",
    ]
    for it in cat["items"]:
        title = it["name"] if it["name"] == it["cname"] or not it["cname"] else f"{it['name']}（{it['cname']}）"
        lines.append(f"## {title}")
        lines.append("")
        if it["syntax"]:
            lines.append("**語法**：" + it["syntax"])
            lines.append("")
        if it["desc"]:
            lines.append(it["desc"])
            lines.append("")
    path = os.path.join(OUT_DIR, f"{cat['code']}.md")
    with io.open(path, "w", encoding="utf-8", newline="\n") as f:
        f.write("\n".join(lines))
    return path


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--only", help="只爬指定分類 code")
    ap.add_argument("--cache", default=os.path.join(OUT_DIR, ".cache"))
    args = ap.parse_args()

    os.makedirs(OUT_DIR, exist_ok=True)
    os.makedirs(args.cache, exist_ok=True)

    index_html = fetch(f"{BASE}/XSHelp/", args.cache, "index.html")
    menu = parse_menu(index_html)
    # SDT 家族不在選單，經 rest API 補抓；插在內建函數（TRANSACTIONFUNC）之後
    ins = next((i + 1 for i, (_, c, _) in enumerate(menu) if c == "TRANSACTIONFUNC"), len(menu))
    menu.insert(ins, ("內建函數", "SDT", "SDT共享資料表"))
    if args.only:
        menu = [m for m in menu if m[1] == args.only]
    print(f"共 {len(menu)} 個分類", flush=True)

    cats = []
    with ThreadPoolExecutor(max_workers=4) as ex:
        futs = {ex.submit(crawl_category, s, c, n, args.cache): (c, n) for s, c, n in menu}
        for fut in futs:
            pass
        done = 0
        for (c, n), fut in [(v, k) for k, v in futs.items()]:
            cat = fut.result()
            cats.append(cat)
            done += 1
            print(f"[{done}/{len(menu)}] {c} {n}: {len(cat['items'])} 項", flush=True)

    # 依官網選單順序輸出
    order = {c: i for i, (_, c, _) in enumerate(menu)}
    cats.sort(key=lambda x: order[x["code"]])

    if not args.only:
        sweep_rest(cats, args.cache)  # 補選單外條目（屬性欄位、關鍵字全字典、試搓欄位等）

    idx = ["# XSHelp 官方文件索引", "",
           f"> 來源：{BASE}/XSHelp/ ；重跑 `python scripts/crawl_xshelp.py` 可更新（有快取，全新抓取先刪 references/xshelp/.cache）",
           "", "| 分類 | 檔案 | 項目數 | 內容 |", "|---|---|---|---|"]
    total = 0
    for cat in cats:
        write_category_md(cat)
        names = "、".join(it["name"] for it in cat["items"][:8])
        more = f" …共{len(cat['items'])}項" if len(cat["items"]) > 8 else ""
        idx.append(f"| {cat['section']}-{cat['cname']} | {cat['code']}.md | {len(cat['items'])} | {names}{more} |")
        total += len(cat["items"])
    idx.append("")
    idx.append(f"總計 {total} 項。查特定函數/欄位：先 grep 本目錄 `^## 名稱`，再 Read 該檔對應段落。")
    with io.open(os.path.join(OUT_DIR, "INDEX.md"), "w", encoding="utf-8", newline="\n") as f:
        f.write("\n".join(idx))
    with io.open(os.path.join(OUT_DIR, ".meta.json"), "w", encoding="utf-8") as f:
        json.dump({"total": total, "categories": len(cats)}, f, ensure_ascii=False)
    print(f"完成：{len(cats)} 分類 / {total} 項 → {OUT_DIR}", flush=True)


if __name__ == "__main__":
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    main()
