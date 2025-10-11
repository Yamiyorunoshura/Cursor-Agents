# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.4.0] - 2025-10-11

### Added
- 新增 Commiter Agent 語義分析能力，能夠理解專案性質並判斷變更的實際意義
- 新增變更重要性分析原則（Change significance analysis principles），指導 AI 過濾無意義的變更
- 新增無意義變更過濾機制，自動識別並排除與專案核心功能無關的檔案更新
- 新增範例 5，展示如何過濾外部工作流程和內部筆記等無關變更

### Changed
- 擴充 Commiter Agent 步驟 2，加入專案性質理解和語義分析流程
- 改進範例 3，從簡單文檔更新改為展示 AI/prompt 專案的功能變更判定邏輯
- 更新技能列表，新增「語義分析能力」以區分措辭改進和功能性變更

### Improved
- 提升 Commiter Agent 對 AI/prompt 專案的理解能力，能正確判斷提示詞變更是否為功能性變更
- 改進提交訊息和 CHANGELOG 的準確性，避免將無關變更納入提交記錄

## [1.3.0] - 2025-10-11

### Added
- 新增 Commiter Agent 多種專案版本文件格式支援（Cargo.toml、package.json、pyproject.toml、go.mod、*.lock）
- 新增版本文件自動檢測邏輯，依優先順序掃描並使用第一個檢測到的版本文件
- 新增專案名稱提取邏輯，支援從 Cargo.toml、package.json、*.lock 檔名或目錄名稱提取
- 新增版本文件一致性更新機制，確保所有檢測到的版本文件同步更新

### Changed
- 更新 Commiter Agent 版本提取策略，從單一 *.lock 文件擴展為多格式支援
- 更新 DoD 檢查清單，新增「所有檢測到的版本文件已一致更新」驗證項
- 改進步驟 3 說明，從「更新 *.lock 文件」改為「更新所有檢測到的版本文件」
- 更新範例說明，將「Lock file」改為「Version file」以反映新的多格式支援

### Fixed
- 修復 Prompt Reviewer Agent 步驟 4 說明文字（移除「JSON」字樣）

## [1.2.0] - 2025-10-09

### Added
- 新增 Prompt Reviewer Agent 上下文連貫性檢查功能 (Context-Coherence-Guidance)
- 新增角色定位檢查能力，驗證目標對象是否明確針對 LLM 而非用戶
- 新增內容連貫性分析，確保各區塊內容與定義目的一致
- 新增相關性檢查，識別與主要目的無關的內容
- 新增誤導性表達檢測，避免 LLM 誤解或混淆

### Changed
- 更新 Prompt Reviewer Agent 評分權重機制，將「上下文連貫性」列為高權重維度 (weight ×2)
- 改進 Prompt Reviewer Agent 破壞性優化定義，明確上下文問題的分類標準
- 更新範例以展示上下文連貫性檢查的實際應用

## [1.1.0] - 2025-10-08

### Improved
- 優化 Commiter Agent 版本規則說明，改用表格格式提升可讀性
- 細化 Commiter Agent 脫敏規則說明，針對不同使用場景提供明確指引
- 改進 Commiter Agent 衝突處理流程，新增詳細的中止與通知機制
- 精簡 Initer Agent 文檔，移除冗餘內容並調整區塊順序
- 新增 Prompt Optimiser Agent 錯誤處理區塊，涵蓋報告文件、原始文件、執行錯誤處理
- 改進 Prompt Optimiser Agent 非破壞性定義，明確順序調整的範圍限制
- 更新 Prompt Reviewer Agent 工具使用說明，提升步驟描述的準確性

### Changed
- Commiter Agent 步驟 3 新增版本號更新說明（*.lock 文件）
- Initer Agent 約束 5 改進文件覆蓋保護說明
- Prompt Optimiser Agent 約束 1 新增 token 限制量化指標（>50 tokens）

## [1.0.0] - 2025-10-08

### Changed
- 重構所有命令文件架構，提升可讀性與可維護性
- 新增 **Goal** 區塊：明確定義每個 Agent 的核心目標
- 簡化 **Steps** 區塊：從詳細執行步驟改為目標導向的高層描述
- 新增 **Example** 區塊：每個命令文件添加 3 個實例範例，提升理解與應用
- Prompt Reviewer 輸出格式從 JSON 改為 Markdown，提升可讀性
- Prompt Optimiser 和 Prompt Reviewer 的報告格式統一為 .md 文件

### Improved
- 優化約束描述：更清晰的異常處理原則與策略說明
- 改進文檔結構：目標導向的步驟描述，降低學習曲線
- 增強實例參考：提供真實場景範例，加速上手時間

## [0.4.2] - 2025-10-06

### Fixed
- 修復 Prompt Reviewer Agent 理解確認階段（Step 0）遺漏讀取輸入文件的步驟

## [0.4.1] - 2025-10-06

### Fixed
- 修復 install.py 在 curl | python3 環境下無法進行互動式輸入的問題（現支援 /dev/tty）
- 改進 install.py 的用戶體驗，提供更清晰的選項提示與錯誤處理

### Changed
- 新增 Commiter Agent 處理長 diff 的策略文檔（4 種策略：臨時文件、無分頁、分段、組合）
- 移除 install.sh，完全採用 Python 安裝腳本（install.py）

## [0.4.0] - 2025-10-06

### Added
- 新增 Python 安裝腳本 (`install.py`)，支援並行下載功能（預設 10 個並行連線）
- 新增 Prompt Reviewer Agent 理解確認階段（Step 0），在建立審查標準前先確認對 prompt 的理解
- 新增 Prompt Optimiser Agent 修改確認階段（Step 2），展示所有修改並由用戶確認後再執行
- 新增 Commiter Agent 版本更新規則，明確主要/次要/修補版本的 README.md 更新邏輯

### Changed
- 改進安裝體驗：Python 腳本支援 `--workers` 參數自訂並行連線數
- 改進 Prompt Optimiser 工作流程：所有修改（破壞性/非破壞性）統一展示並確認
- 改進 Commiter 輸入項目：新增 `*.lock` 文件作為版本號來源
- 更新 README.md 安裝說明：Python 安裝為推薦方式（方法一），Bash 安裝為傳統方式（方法二）

### Features
- **Python 安裝器**: 並行下載、互動式選單、環境變數支援、自訂路徑安裝
- **Prompt Reviewer**: 理解確認機制，確保審查標準符合 prompt 實際意圖
- **Prompt Optimiser**: 修改前確認機制，提供完整的修改對比和影響評估

## [0.3.3] - 2025-10-05

### Changed
- 增強 Prompt Reviewer Agent 的 non_issues 保留機制，確保生成新報告時保留並合併舊報告的所有 non_issues
- 在步驟說明中明確規範歷史參照時的 non_issues 處理邏輯

### Added
- 新增完整的 JSON 審查報告格式範例於 `[Example]` 區塊

## [0.3.2] - 2025-10-05

### Changed
- 將所有命令文件從繁體中文翻譯為英文，提升國際化支援
- 更新 .gitignore，新增 reports/ 目錄至忽略清單

### Files Updated
- commands/sunnycore_commiter.md (English version)
- commands/sunnycore_initer.md (English version)
- commands/sunnycore_prompt-optimiser.md (English version)
- commands/sunnycore_prompt-reviewer.md (English version)

## [0.3.1] - 2025-10-04

### Changed
- 更新 Prompt Reviewer Agent 輸入說明，新增「舊審查報告（若有）」選項以支援迭代審查

## [0.3.0] - 2025-10-04

### Changed
- 重構命令文件架構：將規則內容直接整合到命令文件中，不再依賴外部 rules 目錄
- 簡化使用方式：用戶現在只需引用 commands 文件即可使用 Agent，無需分別管理 commands 和 rules
- 簡化安裝流程：移除 rules 目錄的下載與安裝邏輯

### Removed
- 刪除 `rules/` 目錄及其下所有 .mdc 規則文件（已整合至 commands 文件）

## [0.2.3] - 2025-10-04

### Added
- 命令文件支援雙路徑規則載入（專案內 `{root}/.cursor/rules/` 或全域 `~/.cursor/rules/`）

### Changed
- 更新所有命令文件（commiter、initer、prompt-optimiser、prompt-reviewer），支援全域規則檔案路徑

## [0.2.2] - 2025-10-04

### Added
- 新增 Initer Agent 分支保護規則設定功能
- 新增 4 種分支保護規則等級（基礎、標準、嚴格、自訂）
- 新增分支保護規則設定階段（步驟4），支援互動式配置

### Changed
- 擴展 Initer Agent 輸出項目，新增分支保護規則設定
- 更新 Initer Agent DoD，加入分支保護規則驗證項

## [0.2.1] - 2025-10-04

### Added
- 新增 GitHub API 整合，動態獲取目錄內容
- 新增 `download_directory` 函數實現自動化目錄下載

### Changed
- 重構 install.sh 下載邏輯，從固定文件列表改為動態獲取
- 改進 `download_rules` 和 `download_commands` 函數，使用新的動態下載機制
- 簡化 README.md 安裝說明，強調安裝腳本的互動式體驗
- 移除 install.sh 安裝完成後的使用指南輸出，減少冗餘資訊

## [0.2.0] - 2025-10-04

### Added
- 新增 Initer Agent 規則（專案初始化管理）
- 新增 `sunnycore_initer` 命令文件

### Changed
- 改進 install.sh 安裝流程，移除互動式確認，改為自動移除舊版本
- 優化安裝體驗，減少用戶手動操作步驟

### Features
- **Initer**: 自動化專案初始化、文檔模板生成、GitHub 倉庫創建、License 選擇

## [0.1.0] - 2025-10-04

### Added
- 初始化專案結構
- 新增 Prompt Reviewer Agent 規則（審查提示詞）
- 新增 Prompt Optimiser Agent 規則（優化提示詞）
- 新增 Commiter Agent 規則（項目管理與提交）
- 新增命令文件以快速調用各 Agent
- 新增安裝腳本（install.sh）支援自動安裝
- 新增完整的專案文檔（README.md）
- 新增版本鎖定文件（cursor-agents.lock）
- 新增 .gitignore 檔案

### Features
- **Prompt Reviewer**: 5-8 審查維度、加權評分機制、完整證據追溯
- **Prompt Optimiser**: 非破壞性/破壞性優化分離、互動式確認、優化追溯
- **Commiter**: Conventional Commits 格式、Keep a Changelog 格式、敏感資訊檢測、主分支隔離策略

[0.1.0]: https://github.com/Yamiyorunoshura/Cursor-Agents/releases/tag/v0.1.0

