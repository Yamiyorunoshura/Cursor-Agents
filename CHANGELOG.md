# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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

