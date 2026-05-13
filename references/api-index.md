# XS 官方文件速查索引 (API Reference)

> 本索引列出 XS 各類函數/欄位的分類概觀。離線速查請看 `cheatsheet.md` §14；完整官方說明請查線上手冊。

## 🌐 線上資源 (Online Resources)

### [XS 官方語法手冊 (Online Help)](https://xshelp.xq.com.tw/XSHelp/)

**用途：** 查看最新的函數說明、版本更新與詳細用法。包含完整範例與參數說明。

---

## 📖 核心函數庫

### 內建函數 (Built-in Functions)

**用途：** 查詢所有 XS 內建函數的語法與範例。

- **交易函數**：`SetPosition`, `Buy`, `Sell`, `Cover` ...
- **陣列函數**：`Array_Sum`, `Array_Sort` ...
- **數學與統計**：`Average`, `Summation`, `Highest` ...
- **繪圖函數**：`Plot1`, `Plot2` ...

### 系統函數 (System Functions)

**用途：** 查詢系統層級的運算與資訊取得函數。

- **跨頻率引用**：`xf_GetValue`, `xfMin_MACD` ...
- **邏輯判斷**：`TrueAll`, `CrossOver`, `Bias` ...
- **量能分析**：`DiffUpDownVolume` ...

---

## 📊 資料與欄位 (Data Fields)

### 資料欄位大全 (Data Fields)

**用途：** `GetField()` 通用欄位查閱。

- **期權欄位**：隱含波動率, Delta, Gamma
- **市場統計**：漲停家數, 上漲家數
- **基本資料**：股本, 市值 ...

### 報價欄位 (Quote Fields)

**用途：** `GetQuote()` 專用欄位查閱 (主要用於警示與交易腳本)。

- **五檔報價**：`BestAsk1`, `BestBid1`, `SumAskSize` ...
- **即時籌碼**：`外資買賣超`, `主力買賣超` ...

### 選股欄位 (Selection Fields)

**用途：** 選股腳本專用欄位查閱。

- **財務數據**：`營業利益率`, `每股盈餘` ...
- **公司事件**：`除權息日期`, `股東會日期` ...
- **籌碼面**：`三大法人買賣超` ...

---

## 🛠️ 語法與進階應用

### 關鍵字與流程控制 (Keywords)

**用途：** 基礎語法結構查詢。

- **邏輯運算**：`AND`, `OR`, `NOT`, `XOR`
- **流程控制**：`If...Then`, `For...Next`, `While`, `Begin...End`
- **訊號判斷**：`Cross Over` (黃金交叉), `Cross Below` (死亡交叉)

### 進階語法運用 (Advanced Patterns)

**用途：** 特殊語法與實戰範例。

- **Rank 排行語法**：如何在選股腳本中使用 `Rank` 物件進行排序篩選。
- **進階範例解說**。

---

## 📎 本地速查資源

- `references/cheatsheet.md` §14 函數分類速查索引（內建函數 179 個、系統函數 216 個）
- `references/cheatsheet.md` §15 常見陷阱（AvgPrice vs GetField、plot vs PlotK、intrabarpersist 等）
- `references/cheatsheet.md` §16 領域專用欄位速查（報價 132 / 資料 371 / 選股 508 欄位分類）
- `references/anti-patterns.md` 20 條常見錯誤對照表
- `references/examples-index.md` 官方範例索引（200+ 個）
