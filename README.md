# xs-skill

[Claude Code](https://docs.claude.com/en/docs/claude-code) Skill — 撰寫、修改、除錯 [XQ 全球贏家](https://www.xq.com.tw/) 平台的 **XScript（XS）程式碼**。

涵蓋五大腳本類別：**指標**、**交易（自動交易/當沖/波段）**、**警示（策略雷達）**、**選股（選股中心）**、**函數**。內含完整撰寫規範、31 條常見錯誤對照、**622 個 xstrader 實戰場景索引**、179+216 函數分類速查、報價 132+資料 500+選股 400+ 三大欄位字典。

---

## 觸發情境

只要對 Claude Code 提到下列任一情境，本 skill 會自動觸發：

- **語言/平台關鍵字**：XS、XScript、XQ、量化、自動交易、交易策略、技術指標、選股、警示、策略雷達
- **XS 內建函數**：`SetPosition`、`GetField`、`GetQuote`、`GetSymbolField`、`plot`、`PlotK`、`rank`、`retmsg`、`NumericRef`、`intrabarpersist`
- **量化主題**：回測、進出場邏輯、停損停利、台指期、選擇權希臘字母（Delta/Gamma/Theta/Vega）、月營收選股、Filled vs Position、量化積木（XS\_Blocks）
- **跨平台轉譯**：要把 PineScript / MultiCharts(PowerLanguage) 策略轉為 XQ 可執行程式碼
- **券商情境**：永豐金 / 凱基 / 兆豐 / 群益等使用 XQ 全球贏家平台寫程式單

---

## 安裝

把整個資料夾 clone 到 Claude Code 的 skill 目錄：

### macOS / Linux

```bash
git clone https://github.com/how0531/xs-skill.git ~/.claude/skills/xq-xscript
```

### Windows (PowerShell)

```powershell
git clone https://github.com/how0531/xs-skill.git "$env:USERPROFILE\.claude\skills\xq-xscript"
```

裝好後重啟 Claude Code，問一句「幫我寫一個 KD 黃金交叉的交易腳本」就會自動載入。

---

## 內容結構

```
xq-xscript/
├── SKILL.md                                 ← 主入口（撰寫流程 + 自我檢查清單）
├── README.md                                ← 本檔
├── CLAUDE.md                                ← 維護本 repo 的指引（自動生成檔、同步點、已知陷阱）
├── LICENSE / .gitignore
├── scripts/                                 ← 維護用腳本（重建索引、產 eval metadata）
│   ├── extract-scenes.py                    ← 抽取並分類場景（build-examples-index 的前身/輔助）
│   ├── build-examples-index.py             ← 由來源重建 examples-index.md（產出檔勿手改）
│   ├── crawl_xshelp.py                      ← 爬官方 XSHelp 全站 → references/xshelp/（產出檔勿手改）
│   └── write-eval-metadata.py               ← 產出各 eval 的 metadata（路徑可帶參數/環境變數）
├── evals/                                   ← 行為測試
│   ├── evals.json                           ← 9 個 eval（prompt + expected_output）
│   └── assertions.md                        ← 各 eval 的逐項 assertion
└── references/
    ├── master-guide.md                      ← **程序性規則**：撰寫流程、可行性預審、look-ahead bias 等
    ├── cheatsheet.md                        ← **純查表**：函數分類、欄位命名規則、頻率商品相容、常用片段
    ├── anti-patterns.md                     ← **錯誤對照**：31 條常見錯誤 wrong → right（含營收年增率/負債總額正名、變數命名片段衝突、部位 log 方向 vs 狀態）
    ├── examples-index.md                    ← **場景索引**：622 個實戰場景（場景 620–1241，主題分類含原始 URL）
    ├── xshelp/                              ← **官方文件鏡像**：51 分類 / 1663 項（爬蟲生成勿手改，含選單外分類 SDT/ATTRFIELD/RESTMISC）
    │   ├── INDEX.md                         ← 全站索引（分類 → 檔案 → 項目數）
    │   ├── DIGEST.md                        ← 全量精讀摘要：481 條限制/陷阱/特殊語意
    │   └── <分類>.md × 51                    ← 每分類一檔，每項含語法/說明/範例
    ├── script-types/
    │   ├── indicator.md                     ← 指標腳本規範
    │   ├── trading.md                       ← 交易腳本規範（當沖、波段、選擇權範例）
    │   ├── alert.md                         ← 警示腳本規範（Tick / ReadTicks）
    │   ├── stock-picker.md                  ← 選股腳本規範（rank 排行語法）
    │   └── function.md                      ← 函數腳本規範（NumericRef 機制）
    └── source/                              ← 來源原始文件，供 grep 查單一場景
        ├── XScript_官方語法與核心說明文件.md   ← 1538 行完整官方語法 + 三大欄位字典
        └── XScript_實戰範例寶典_下.md          ← 622 個場景的完整 XS 程式碼（21K+ 行）
```

---

## 重點功能

- ✅ **強制檢核流程** — 接到需求先做頻率限制、商品支援、跨頻率/跨商品、逐筆洗價、張數轉換五項可行性預審
- ✅ **禁用語法守門** — 自動攔截 `MarketPosition` / `Buy` / `Sell` / `BarsSinceEntry` / `MINVAL` / `NewDay` / `==` 等 MultiCharts/PineScript 語法
- ✅ **Look-ahead Bias 防呆** — 盤中盤後資料的 `[0]` vs `[1]` 黑名單
- ✅ **欄位精確比對** — `GetField` 字串必須與官方標籤位元級匹配，包含括號單位
- ✅ **欄位頻率切換**：月頻用 `"月營收年增率"`、季年用 `"營收成長率"`；`"負債總額"` 不是「總負債」 — 寫錯靜默回 0
- ✅ **股票雙重部位同步檢查** — `Filled = Position` 才能執行部位異動，避免委託真空期重複下單
- ✅ **622 個實戰場景索引** — 從 xstrader.tw 官方場景庫整理，按籌碼/營收/技術/盤整等主題分類，含原始說明連結

---

## 相關資源

- **XS 官方語法手冊**：<https://xshelp.xq.com.tw/XSHelp/>
- **XScript Preset 官方範例集**：<https://github.com/how0531/XScript_Preset>（200+ 個 .xs 範例）
- **量化積木 XS_Blocks**：<https://github.com/sysjust-xq/XS_Blocks/>
- **XQ 全球贏家**：<https://www.xq.com.tw/>

---

## License

[MIT](LICENSE) © how0531
