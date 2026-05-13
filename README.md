# xs-skill

[Claude Code](https://docs.claude.com/en/docs/claude-code) Skill — 撰寫、修改、除錯 [XQ 全球贏家](https://www.xq.com.tw/) 平台的 **XScript（XS）程式碼**。

涵蓋五大腳本類別：**指標**、**交易（自動交易/當沖/波段）**、**警示（策略雷達）**、**選股（選股中心）**、**函數**。內含完整撰寫規範、常見錯誤對照、200+ 官方範例索引、欄位/函數速查。

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
├── SKILL.md                          ← 主入口（撰寫流程 + 自我檢查清單）
└── references/
    ├── master-guide.md               ← 完整撰寫主指引
    ├── cheatsheet.md                 ← 語法速查表（含 179 個內建函數、216 個系統函數分類）
    ├── anti-patterns.md              ← 20 條常見錯誤對照表
    ├── api-index.md                  ← API 速查索引
    ├── examples-index.md             ← 200+ 官方範例索引
    └── script-types/
        ├── indicator.md              ← 指標腳本專屬規範
        ├── trading.md                ← 交易腳本專屬規範（含當沖、波段、選擇權範例）
        ├── alert.md                  ← 警示腳本專屬規範（含 Tick 處理、ReadTicks）
        ├── stock-picker.md           ← 選股腳本專屬規範（含 rank 排行語法）
        └── function.md               ← 函數腳本專屬規範（含 NumericRef 機制）
```

---

## 重點功能

- ✅ **強制檢核流程** — 接到需求先做頻率限制、商品支援、跨頻率/跨商品、逐筆洗價、張數轉換五項可行性預審
- ✅ **禁用語法守門** — 自動攔截 `MarketPosition` / `Buy` / `Sell` / `BarsSinceEntry` / `MINVAL` / `NewDay` / `==` 等 MultiCharts/PineScript 語法
- ✅ **Look-ahead Bias 防呆** — 盤中盤後資料的 `[0]` vs `[1]` 黑名單
- ✅ **欄位精確比對** — `GetField` 字串必須與官方標籤位元級匹配，包含括號單位
- ✅ **股票雙重部位同步檢查** — `Filled = Position` 才能執行部位異動，避免委託真空期重複下單

---

## 相關資源

- **XS 官方語法手冊**：<https://xshelp.xq.com.tw/XSHelp/>
- **XScript Preset 官方範例集**：<https://github.com/how0531/XScript_Preset>（200+ 個 .xs 範例）
- **量化積木 XS_Blocks**：<https://github.com/sysjust-xq/XS_Blocks/>
- **XQ 全球贏家**：<https://www.xq.com.tw/>

---

## License

[MIT](LICENSE) © how0531
