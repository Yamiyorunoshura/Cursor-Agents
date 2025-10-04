# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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

