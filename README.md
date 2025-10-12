# Cursor & Codex AI Agents - 提示詞工程專案

專為 Cursor IDE 設計並擴充支援 Codex CLI 的 AI Agent 規則集，提供專業的提示詞審查、優化與項目管理功能。

## 📖 專案簡介

本專案包含四個專業的 AI Agent，協助開發者進行提示詞工程與項目管理：

### 🤖 四大核心 Agent

1. **Prompt Reviewer** - 提示詞審查工程師
   - 深度語義理解與批判性思維
   - 多維度審查標準（結構完整性、表達清晰度、約束有效性、上下文連貫性等）
   - 上下文連貫性分析（角色定位、內容一致性、相關性檢查）
   - 產出 Markdown 格式審查報告與優化建議
   - 支援破壞性/非破壞性優化識別
   - 提供實例參考，加速理解審查流程

2. **Prompt Optimiser** - 提示詞優化工程師
   - 根據 Markdown 審查報告進行優化
   - 保持原意與風格，避免冗長內容
   - 互動式確認破壞性優化
   - 完整的優化追溯與證據記錄
   - 提供實例參考，展示優化決策過程

3. **Commiter** - 專業項目管理員
   - 符合 Conventional Commits 規範的 commit message
   - 自動更新 CHANGELOG.md（Keep a Changelog 格式）
   - 智能判斷是否更新 README.md（基於版本變更類型）
   - 支援多種專案版本文件格式（Cargo.toml、package.json、pyproject.toml、*.lock 等）
   - 自動檢測版本文件並同步更新所有版本號
   - 敏感資訊檢測與脫敏處理
   - 支援主分支/非主分支不同流程
   - 提供實例參考，展示分支策略與版本管理

4. **Initer** - 專案初始化管理員
   - 自動化專案初始化流程
   - 生成專業文檔模板（README.md、CHANGELOG.md）
   - 支援多種 License 類型選擇（MIT、Apache 2.0、GPL-3.0 等）
   - 自動建立 GitHub 遠端倉庫並推送
   - 根據專案類型生成對應的 .gitignore
   - 支援分支保護規則設定（基礎、標準、嚴格、自訂 4 種等級）
   - 提供實例參考，展示不同初始化場景

## 🚀 快速開始

### 安裝

#### 方法一：Python 安裝（推薦，支援並行下載）

使用以下命令一鍵安裝，腳本會先讓你選擇要安裝的 CLI 類型（Cursor 或 Codex），並提供互動式選單讓你設定安裝模式：

```bash
# 使用 curl 下載並執行
curl -fsSL https://raw.githubusercontent.com/Yamiyorunoshura/Cursor-Agents/main/install.py | python3

# 或直接下載後執行
curl -fsSL https://raw.githubusercontent.com/Yamiyorunoshura/Cursor-Agents/main/install.py -o install.py
python3 install.py

# 指定並行下載連線數（預設 10）
python3 install.py --workers 20
```

#### 方法二：Bash 安裝（傳統方式）

```bash
curl -fsSL https://raw.githubusercontent.com/Yamiyorunoshura/Cursor-Agents/main/install.sh | bash
```

#### 安裝模式說明

- **全域安裝**（推薦）：Cursor 安裝到 `~/.cursor/commands/`，Codex 安裝到 `~/.codex/prompts/`
- **專案／工作區安裝**：Cursor 安裝到當前專案的 `.cursor/commands/`，Codex 安裝到 `.codex/prompts/`（適合團隊協作或單一工作區）
- **自訂路徑**：安裝到指定路徑，腳本會自動建立對應的 `.cursor/commands/` 或 `.codex/prompts/` 子目錄

#### 進階用法

```bash
# 直接指定安裝模式（無需互動）
python3 install.py global           # 全域安裝
python3 install.py project          # 專案／工作區安裝
python3 install.py /custom/path     # 自訂路徑安裝

# 指定 CLI 類型
python3 install.py --cli codex      # 直接安裝到 Codex CLI
python3 install.py --cli cursor     # 強制使用 Cursor CLI（預設值）

# 使用環境變數
INSTALL_MODE=project python3 install.py
INSTALL_PATH=/custom/path python3 install.py
INSTALL_CLI=codex python3 install.py
```

> 💡 提示：Python 版本支援並行下載，安裝速度更快！腳本會自動提供互動式選單讓你選擇 CLI 類型與安裝模式。

### 使用方法

預設情境下，在 Cursor IDE 中將以下文件拖入對話框即可啟用對應的 Agent；若採用 Codex CLI，請改用 `@prompts/...` 路徑：

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
- 可選設定分支保護規則（防止強制推送、要求 PR 審查等）

## 📁 專案結構

```
cursor-agents/
├── commands/                    # AI Agent 命令文件（包含完整規則）
│   ├── sunnycore_commiter.md
│   ├── sunnycore_initer.md
│   ├── sunnycore_prompt-optimiser.md
│   └── sunnycore_prompt-reviewer.md
├── cursor-agents.lock           # 版本鎖定文件
├── install.py                   # Python 安裝腳本（推薦，支援並行下載）
├── install.sh                   # Bash 安裝腳本（傳統方式）
├── .gitignore
├── CHANGELOG.md
├── LICENSE
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
- ✅ 上下文連貫性檢查（角色定位、內容一致性、相關性、誤導檢測）
- ✅ 0-5 分評分機制（加權計算，上下文連貫性為高權重維度）
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
- ✅ 多種版本文件格式支援（Cargo.toml、package.json、pyproject.toml、*.lock）
- ✅ 自動檢測並同步更新所有版本文件
- ✅ 主分支隔離策略（自動建立版本分支）
- ✅ 敏感資訊檢測與脫敏
- ✅ 完整的驗證機制（最多重試 3 次）
- ✅ 語義分析能力（理解專案性質，判斷變更的實際意義）
- ✅ 智能變更過濾（自動排除與專案核心功能無關的檔案更新）

### Initer
- ✅ 自動化專案初始化流程
- ✅ 多種 License 支援（MIT、Apache 2.0、GPL-3.0、BSD-3-Clause、Unlicense）
- ✅ 根據專案類型生成 .gitignore（Node.js、Python、Java、Go、Rust、React、Vue、通用）
- ✅ GitHub CLI 整合（自動建立遠端倉庫）
- ✅ 分支保護規則設定（4 種等級：基礎、標準、嚴格、自訂）
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
