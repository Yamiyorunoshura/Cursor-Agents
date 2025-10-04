#!/bin/bash

# Cursor AI Agents 安裝腳本
# 用途：從 GitHub 下載最新版本並安裝至 Cursor 配置目錄
#
# 使用方法：
#   全域安裝（預設）：
#     curl -fsSL https://raw.githubusercontent.com/Yamiyorunoshura/Cursor-Agents/main/install.sh | bash
#   或：bash install.sh
#
#   專案安裝（當前目錄）：
#     curl -fsSL https://raw.githubusercontent.com/Yamiyorunoshura/Cursor-Agents/main/install.sh | INSTALL_MODE=project bash
#   或：INSTALL_MODE=project bash install.sh
#   或：bash install.sh project
#
#   自訂路徑安裝：
#     curl -fsSL https://raw.githubusercontent.com/Yamiyorunoshura/Cursor-Agents/main/install.sh | INSTALL_PATH=/custom/path bash
#   或：INSTALL_PATH=/custom/path bash install.sh
#   或：bash install.sh /custom/path

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

# 安裝路徑變數
CURSOR_DIR=""
RULES_DIR=""
COMMANDS_DIR=""
INSTALL_MODE=""

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

# 決定安裝路徑
determine_install_path() {
    log_info "決定安裝路徑..."
    
    # 優先級 1: 檢查命令行參數
    if [ -n "$1" ]; then
        if [ "$1" = "project" ] || [ "$1" = "local" ]; then
            INSTALL_MODE="project"
        elif [ "$1" = "global" ]; then
            INSTALL_MODE="global"
        else
            # 假設是自訂路徑
            CURSOR_DIR="$1"
            INSTALL_MODE="custom"
        fi
    fi
    
    # 優先級 2: 檢查環境變數 INSTALL_PATH
    if [ -z "$CURSOR_DIR" ] && [ -n "$INSTALL_PATH" ]; then
        CURSOR_DIR="$INSTALL_PATH"
        INSTALL_MODE="custom"
    fi
    
    # 優先級 3: 檢查環境變數 INSTALL_MODE
    if [ -z "$INSTALL_MODE" ] && [ -n "$INSTALL_MODE_ENV" ]; then
        INSTALL_MODE="$INSTALL_MODE_ENV"
    fi
    
    # 優先級 4: 互動式選擇（只有在可以讀取 /dev/tty 時才能互動）
    if [ -z "$INSTALL_MODE" ] && [ -z "$CURSOR_DIR" ]; then
        # 檢查是否可以互動（不是通過 pipe 執行）
        if [ -t 0 ] || [ -r /dev/tty ]; then
            echo ""
            log_info "請選擇安裝模式："
            echo "  1) 全域安裝（安裝到 ~/.cursor/，對所有專案生效）"
            echo "  2) 專案安裝（安裝到當前目錄 ./.cursor/，只對當前專案生效）"
            echo "  3) 自訂路徑"
            echo ""
            
            # 如果通過 pipe，嘗試從 /dev/tty 讀取
            if [ ! -t 0 ] && [ -r /dev/tty ]; then
                read -p "請輸入選項 [1-3] (預設: 1): " choice < /dev/tty
            else
                read -p "請輸入選項 [1-3] (預設: 1): " choice
            fi
            
            case "${choice:-1}" in
                1)
                    INSTALL_MODE="global"
                    ;;
                2)
                    INSTALL_MODE="project"
                    ;;
                3)
                    if [ ! -t 0 ] && [ -r /dev/tty ]; then
                        read -p "請輸入安裝路徑: " CURSOR_DIR < /dev/tty
                    else
                        read -p "請輸入安裝路徑: " CURSOR_DIR
                    fi
                    INSTALL_MODE="custom"
                    ;;
                *)
                    log_warning "無效選項，使用預設值（全域安裝）"
                    INSTALL_MODE="global"
                    ;;
            esac
        else
            # 無法互動時使用預設值
            INSTALL_MODE="global"
        fi
    fi
    
    # 根據模式設定實際路徑
    case "$INSTALL_MODE" in
        "global")
            CURSOR_DIR="${HOME}/.cursor"
            log_info "安裝模式：全域安裝"
            ;;
        "project")
            CURSOR_DIR="$(pwd)/.cursor"
            log_info "安裝模式：專案安裝"
            ;;
        "custom")
            # 展開 ~ 符號
            CURSOR_DIR="${CURSOR_DIR/#\~/$HOME}"
            log_info "安裝模式：自訂路徑"
            ;;
        *)
            CURSOR_DIR="${HOME}/.cursor"
            log_info "安裝模式：全域安裝（預設）"
            ;;
    esac
    
    RULES_DIR="${CURSOR_DIR}/rules"
    COMMANDS_DIR="${CURSOR_DIR}/commands"
    
    echo ""
    log_success "安裝路徑已確定："
    echo "  - 主目錄: ${CURSOR_DIR}"
    echo "  - 規則文件: ${RULES_DIR}"
    echo "  - 命令文件: ${COMMANDS_DIR}"
    echo ""
}

# 創建目錄結構
create_directories() {
    log_info "創建目錄結構..."
    
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
    
    if [ "$INSTALL_MODE" = "project" ]; then
        log_warning "您使用了專案安裝模式，Agent 規則只會在當前專案中生效"
        log_info "如需在其他專案中使用，請重新執行安裝腳本"
        echo ""
    elif [ "$INSTALL_MODE" = "global" ]; then
        log_info "您使用了全域安裝模式，Agent 規則將對所有 Cursor 專案生效"
        echo ""
    fi
    
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
    if [ -d "${RULES_DIR}" ] && [ "$(ls -A ${RULES_DIR} 2>/dev/null)" ]; then
        log_warning "檢測到已存在的安裝"
        
        # 嘗試從 /dev/tty 讀取以支援 pipe 模式
        if [ -t 0 ] || [ -r /dev/tty ]; then
            if [ ! -t 0 ] && [ -r /dev/tty ]; then
                read -p "是否覆蓋現有安裝？(y/N) " -n 1 -r < /dev/tty
            else
                read -p "是否覆蓋現有安裝？(y/N) " -n 1 -r
            fi
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                log_info "安裝已取消"
                exit 0
            fi
        else
            log_warning "無法互動確認，將覆蓋現有安裝"
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
    determine_install_path "$@"
    check_existing_installation
    create_directories
    download_rules
    download_commands
    download_lock_file
    show_usage
}

# 執行主函數，傳遞所有參數
main "$@"
