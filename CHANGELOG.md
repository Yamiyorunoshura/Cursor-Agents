# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- 支援多種安裝模式（全域/專案/自訂路徑）
- 互動式路徑選擇功能
- 支援通過環境變數 `INSTALL_MODE` 和 `INSTALL_PATH` 指定安裝方式
- 支援命令行參數指定安裝模式
- 安裝模式對比表格說明

### Changed
- 改進安裝腳本，支援 `curl | bash` 時通過環境變數控制安裝行為
- 更新 README.md，詳細說明四種安裝方式

### Fixed
- 修復通過 pipe 執行時無法互動的問題（使用 /dev/tty）

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

