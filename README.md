# Cursor AI Agents - 提示詞工程專案

專為 Cursor IDE 設計的 AI Agent 規則集，提供專業的提示詞審查、優化與項目管理功能。

## 📖 專案簡介

本專案包含四個專業的 AI Agent，協助開發者進行提示詞工程與項目管理：

### 🤖 四大核心 Agent

1. **Prompt Reviewer** - 提示詞審查工程師
   - 深度語義理解與批判性思維
   - 多維度審查標準（結構完整性、表達清晰度、約束有效性等）
   - 產出 JSON 格式審查報告與優化建議
   - 支援破壞性/非破壞性優化識別

2. **Prompt Optimiser** - 提示詞優化工程師
   - 根據審查報告進行非破壞性優化
   - 保持原意與風格，避免冗長內容
   - 互動式確認破壞性優化
   - 完整的優化追溯與證據記錄

3. **Commiter** - 專業項目管理員
   - 符合 Conventional Commits 規範的 commit message
   - 自動更新 CHANGELOG.md（Keep a Changelog 格式）
   - 智能判斷是否更新 README.md
   - 敏感資訊檢測與脫敏處理
   - 支援主分支/非主分支不同流程

4. **Initer** - 專案初始化管理員
   - 自動化專案初始化流程
   - 生成專業文檔模板（README.md、CHANGELOG.md）
   - 支援多種 License 類型選擇（MIT、Apache 2.0、GPL-3.0 等）
   - 自動建立 GitHub 遠端倉庫並推送
   - 根據專案類型生成對應的 .gitignore

## 🚀 快速開始

### 安裝

Cursor AI Agents 支援多種安裝模式：

| 安裝模式 | 安裝路徑 | 適用場景 |
|---------|---------|---------|
| **全域安裝** | `~/.cursor/` | 所有 Cursor 專案共用（推薦） |
| **專案安裝** | `./.cursor/` | 只對當前專案生效（團隊協作） |
| **自訂路徑** | 自訂 | 特殊需求 |

#### 方式一：全域安裝（推薦）

安裝到 `~/.cursor/`，對所有 Cursor 專案生效：

```bash
curl -fsSL https://raw.githubusercontent.com/Yamiyorunoshura/Cursor-Agents/main/install.sh | bash
```

#### 方式二：專案安裝

安裝到當前專案的 `.cursor/`，只對當前專案生效：

```bash
curl -fsSL https://raw.githubusercontent.com/Yamiyorunoshura/Cursor-Agents/main/install.sh | INSTALL_MODE=project bash
```

#### 方式三：自訂路徑安裝

安裝到指定路徑：

```bash
curl -fsSL https://raw.githubusercontent.com/Yamiyorunoshura/Cursor-Agents/main/install.sh | INSTALL_PATH=/your/custom/path bash
```

#### 方式四：互動式安裝

下載腳本後執行，可以通過選單選擇安裝模式：

```bash
curl -fsSL https://raw.githubusercontent.com/Yamiyorunoshura/Cursor-Agents/main/install.sh -o install.sh
bash install.sh
```

或從源碼安裝：

```bash
git clone https://github.com/Yamiyorunoshura/Cursor-Agents.git
cd Cursor-Agents
./install.sh
```

### 使用方法

在 Cursor IDE 中，將以下文件拖入對話框以啟用對應的 Agent：

#### 1. 審查提示詞
```
@commands/sunnycore_prompt-reviewer.md
```
然後附加要審查的提示詞文件。

#### 2. 優化提示詞
```
@commands/sunnycore_prompt-optimiser.md
```
確保已有審查報告（位於 `reports/` 目錄）。

#### 3. 提交變更
```
@commands/sunnycore_commiter.md
```
在暫存變更後執行此命令，Agent 會自動：
- 分析 git diff
- 更新 CHANGELOG.md 和 README.md（如需要）
- 生成符合規範的 commit message
- 執行 commit 與 push 操作

#### 4. 初始化專案
```
@commands/sunnycore_initer.md
```
執行此命令可初始化新專案，Agent 會：
- 引導收集專案資訊（名稱、描述、類型、License）
- 創建專業文檔模板（README.md、CHANGELOG.md）
- 生成 .gitignore 和 LICENSE 檔案
- 執行 initial commit
- 建立 GitHub 遠端倉庫並推送

## 📁 專案結構

```
cursor-agents/
├── commands/                    # 快速調用指令
│   ├── sunnycore_commiter.md
│   ├── sunnycore_initer.md
│   ├── sunnycore_prompt-optimiser.md
│   └── sunnycore_prompt-reviewer.md
├── rules/                       # AI Agent 完整規則定義
│   ├── sunnycore_commiter.mdc
│   ├── sunnycore_initer.mdc
│   ├── sunnycore_prompt-optimiser.mdc
│   └── sunnycore_prompt-reviewer.mdc
├── cursor-agents.lock           # 版本鎖定文件
├── .gitignore
├── CHANGELOG.md
└── README.md
```

## ⚙️ 版本管理

本專案使用 `cursor-agents.lock` 文件管理版本號。Commiter Agent 會根據此文件自動建立版本分支。

## 🔒 安全性

所有 Agent 皆內建敏感資訊檢測機制：
- API keys、tokens、密碼
- 個人識別資訊（PII）
- 內部路徑、IP 位址、資料庫連線字串

檢測到敏感資訊時會自動脫敏或要求用戶確認。

## 📋 核心特性

### Prompt Reviewer
- ✅ 5-8 個審查維度，每維度 3-5 個審查項目
- ✅ 0-5 分評分機制（加權計算）
- ✅ 完整的證據追溯（區塊名稱 + 行號）
- ✅ 支援「非問題」標注與歷史參照
- ✅ 結構化推理（sequentialthinking）

### Prompt Optimiser
- ✅ 非破壞性優化（不改變原意）
- ✅ 破壞性優化需用戶確認
- ✅ 長度限制（增幅 <10%）
- ✅ 完整的優化追溯（report_item_id + line_range）
- ✅ 保持原風格與專業術語

### Commiter
- ✅ Conventional Commits 格式
- ✅ Keep a Changelog v1.0.0 格式
- ✅ 主分支隔離策略（自動建立版本分支）
- ✅ 敏感資訊檢測與脫敏
- ✅ 完整的驗證機制（最多重試 3 次）

### Initer
- ✅ 自動化專案初始化流程
- ✅ 多種 License 支援（MIT、Apache 2.0、GPL-3.0、BSD-3-Clause、Unlicense）
- ✅ 根據專案類型生成 .gitignore（Node.js、Python、Java、Go、Rust、React、Vue、通用）
- ✅ GitHub CLI 整合（自動建立遠端倉庫）
- ✅ 檔案覆蓋保護機制

## 🛠️ 工具整合

所有 Agent 皆支援以下工具：
- **todo_write** - 任務追蹤與進度管理
- **sequentialthinking** - 結構化推理（1-8 步）

## 📝 授權

Apache License 2.0

## 🤝 貢獻

歡迎提交 Issue 或 Pull Request！

## 📮 聯絡方式

如有任何問題或建議，請透過 GitHub Issues 聯繫我們。

