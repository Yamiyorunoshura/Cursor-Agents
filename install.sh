#!/bin/bash

# Cursor AI Agents 安裝腳本
# 用途：從 GitHub 下載最新版本並安裝至 Cursor 配置目錄

set -e

# 顏色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 遠端倉庫 URL
REPO_URL="https://github.com/Yamiyorunoshura/Cursor-Agents"
RAW_URL="${REPO_URL}/raw/main"

# Cursor 配置目錄
CURSOR_DIR="${HOME}/.cursor"
RULES_DIR="${CURSOR_DIR}/rules"
COMMANDS_DIR="${CURSOR_DIR}/commands"

# 輔助函數
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 檢查必要工具
check_dependencies() {
    log_info "檢查系統依賴..."
    
    if ! command -v curl &> /dev/null; then
        log_error "curl 未安裝，請先安裝 curl"
        exit 1
    fi
    
    if ! command -v git &> /dev/null; then
        log_warning "git 未安裝，建議安裝 git 以便後續更新"
    fi
    
    log_success "系統依賴檢查完成"
}

# 創建目錄結構
create_directories() {
    log_info "創建 Cursor 配置目錄..."
    
    mkdir -p "${RULES_DIR}"
    mkdir -p "${COMMANDS_DIR}"
    
    log_success "目錄結構創建完成"
}

# 下載文件
download_file() {
    local url=$1
    local dest=$2
    local filename=$(basename "$dest")
    
    log_info "下載 ${filename}..."
    
    if curl -fsSL "${url}" -o "${dest}"; then
        log_success "${filename} 下載完成"
        return 0
    else
        log_error "${filename} 下載失敗"
        return 1
    fi
}

# 下載所有規則文件
download_rules() {
    log_info "下載 AI Agent 規則文件..."
    
    local rules=(
        "sunnycore_commiter.mdc"
        "sunnycore_prompt-optimiser.mdc"
        "sunnycore_prompt-reviewer.mdc"
    )
    
    for rule in "${rules[@]}"; do
        download_file "${RAW_URL}/rules/${rule}" "${RULES_DIR}/${rule}" || exit 1
    done
    
    log_success "規則文件下載完成"
}

# 下載所有命令文件
download_commands() {
    log_info "下載命令文件..."
    
    local commands=(
        "sunnycore_commiter.md"
        "sunnycore_prompt-optimiser.md"
        "sunnycore_prompt-reviewer.md"
    )
    
    for cmd in "${commands[@]}"; do
        download_file "${RAW_URL}/commands/${cmd}" "${COMMANDS_DIR}/${cmd}" || exit 1
    done
    
    log_success "命令文件下載完成"
}

# 下載版本鎖定文件
download_lock_file() {
    log_info "下載版本鎖定文件..."
    
    download_file "${RAW_URL}/cursor-agents.lock" "${CURSOR_DIR}/cursor-agents.lock" || exit 1
    
    log_success "版本鎖定文件下載完成"
}

# 顯示使用說明
show_usage() {
    echo ""
    log_success "=========================================="
    log_success "  Cursor AI Agents 安裝完成！"
    log_success "=========================================="
    echo ""
    log_info "安裝位置："
    echo "  - 規則文件: ${RULES_DIR}"
    echo "  - 命令文件: ${COMMANDS_DIR}"
    echo ""
    log_info "使用方法："
    echo "  在 Cursor IDE 中，將以下文件拖入對話框以啟用對應的 Agent："
    echo ""
    echo "  1. 審查提示詞："
    echo "     @commands/sunnycore_prompt-reviewer.md"
    echo ""
    echo "  2. 優化提示詞："
    echo "     @commands/sunnycore_prompt-optimiser.md"
    echo ""
    echo "  3. 提交變更："
    echo "     @commands/sunnycore_commiter.md"
    echo ""
    log_info "更多資訊請訪問："
    echo "  ${REPO_URL}"
    echo ""
}

# 檢查是否已安裝
check_existing_installation() {
    if [ -d "${RULES_DIR}" ] && [ "$(ls -A ${RULES_DIR})" ]; then
        log_warning "檢測到已存在的安裝"
        read -p "是否覆蓋現有安裝？(y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "安裝已取消"
            exit 0
        fi
    fi
}

# 主函數
main() {
    echo ""
    log_info "=========================================="
    log_info "  Cursor AI Agents 安裝程式"
    log_info "=========================================="
    echo ""
    
    check_dependencies
    check_existing_installation
    create_directories
    download_rules
    download_commands
    download_lock_file
    show_usage
}

# 執行主函數
main

