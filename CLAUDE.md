# CLAUDE.md — 維護本 repo 時的指引

> 這份檔案寫給「**在這個 repo 裡工作、維護這個 skill 的 Claude**」，
> 不是 skill 的內容本身。skill 內容的入口是 `SKILL.md`。

## 這是什麼

`xs-skill` 是一個 **Claude Code Skill**（領域知識庫），教 Claude 撰寫 XQ 平台的
XScript（XS）程式碼。它**沒有可執行的產品程式碼**，本體是一組 Markdown 規範文件，
外加三支重建索引／測試用的 Python 腳本。改動幾乎都是改 Markdown。

## 目錄與職責

| 路徑 | 職責 | 編輯原則 |
|---|---|---|
| `SKILL.md` | 主入口：撰寫流程、自我檢查清單、frontmatter 觸發詞 | 手動維護 |
| `references/master-guide.md` | 程序性規則（怎麼做） | 手動維護 |
| `references/cheatsheet.md` | 純查表（是什麼） | 手動維護 |
| `references/anti-patterns.md` | 31 條 ❌→✅ 錯誤對照 | 手動維護，新增條目見下方同步點 |
| `references/script-types/*.md` | 五類腳本（指標/交易/警示/選股/函數）專屬規範 | 手動維護 |
| `references/examples-index.md` | 622 場景索引 | **自動生成，禁止手改**（見下方） |
| `references/xshelp/*.md`（除 DIGEST） | 官方 XSHelp 全站鏡像（48 分類 / 1497 項） | **爬蟲生成，禁止手改**：改內容請重跑 `scripts/crawl_xshelp.py` |
| `references/xshelp/DIGEST.md` | 全量精讀摘要（445 條限制/陷阱） | 由精讀代理批次生成；小幅修正可手改，大改建議重跑精讀流程 |
| `references/source/*.md` | 原始來源，供 grep 查單一場景 | 唯讀為主 |
| `evals/` | 行為測試（evals.json + assertions.md） | 手動維護 |
| `scripts/*.py` | 維護工具 | 手動維護 |

## 自動生成檔（不要手改）

`references/examples-index.md` 由 `scripts/build-examples-index.py` 從
`references/source/XScript_實戰範例寶典_下.md` 生成。要改索引，請改**生成器或來源**
再重跑，**不要直接編輯產出檔**（手改會在下次重跑時被覆蓋）：

```bash
python3 scripts/build-examples-index.py
git diff references/examples-index.md   # 確認改動如預期
```

## 同步點（最容易製造不一致的地方）

**anti-patterns 的「條數」散落在多處**。新增／刪除一條 anti-pattern 時，務必同步更新：

- `references/anti-patterns.md`（本體，標題 `## N.`）
- `SKILL.md`（References 導覽表 + frontmatter 描述）
- `README.md`（簡介段 + 內容結構樹，共 2 處）
- `references/master-guide.md`（資源導航）
- `references/cheatsheet.md`（也可參考段）
- `scripts/build-examples-index.py`（產生 `examples-index.md` footer 的那行字串）

改完條數後重跑生成器，並用 `grep -rn "[0-9]\+ 條" .` 抽查是否還有漏網的舊數字。

## 已知的內容陷阱

- `XScript_實戰範例寶典_上.md`（早期 Gem prompt）**已於 2026-07-29 刪除** — 其命名規範
  與本 skill 相反、且含多個錯誤欄位名（股價自由現金流比、月頻「營收年增率」等）。
  如需考古請查 git 歷史，**不要**把它的規則抄回任何文件。
- `XScript_Preset` 範例集在 **GitHub**（<https://github.com/how0531/XScript_Preset>），
  **不在本 repo**。文件中引用範例時一律指向 GitHub，不要寫 `references/xscript_preset/...`
  這種不存在的本地路徑。

## 驗證

無法在本機編譯 XS。但每次新增／修改文件裡的 XS 程式碼範例時，請用 skill 自己的規則
自我檢查（這些是範本，Claude 會直接模仿）：

- input/var 加 `_` 前綴、無重複宣告
- 相等與賦值都用 `=`（無 `==`）
- 每句 `;` 結尾、`if-else` 用 `begin/end`
- 欄位字串含單位後綴、頻率切換正名正確（月頻「月營收年增率」vs 季年頻「營收成長率」）
- 欄位/函數名有疑義時以 `references/xshelp/`（官方鏡像）為準：`grep -rn "^## 名稱" references/xshelp/`

兩支可重跑的腳本：

```bash
python3 scripts/build-examples-index.py            # 重建場景索引
python3 scripts/write-eval-metadata.py [WORKSPACE]  # 產出 eval metadata（路徑可帶參數或用 XS_EVAL_WORKSPACE）
```
