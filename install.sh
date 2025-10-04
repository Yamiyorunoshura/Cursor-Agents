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
API_URL="https://api.github.com/repos/Yamiyorunoshura/Cursor-Agents/contents"

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
    
      
    # 優先級 4: 互動式選擇
    if [ -z "$INSTALL_MODE" ] && [ -z "$CURSOR_DIR" ]; then
        # 檢查是否可以互動
        if [ -t 0 ]; then
            # 直接在終端中執行
            echo ""
            log_info "請選擇安裝模式："
            echo "  1) 全域安裝（安裝到 ~/.cursor/，對所有專案生效）"
            echo "  2) 專案安裝（安裝到當前目錄 ./.cursor/，只對當前專案生效）"
            echo "  3) 自訂路徑"
            echo ""

            read -p "請輸入選項 [1-3] (預設: 1): " choice

            case "${choice:-1}" in
                1)
                    INSTALL_MODE="global"
                    ;;
                2)
                    INSTALL_MODE="project"
                    ;;
                3)
                    read -p "請輸入安裝路徑: " CURSOR_DIR
                    INSTALL_MODE="custom"
                    ;;
                *)
                    log_warning "無效選項，使用預設值（全域安裝）"
                    INSTALL_MODE="global"
                    ;;
            esac
        elif [ -r /dev/tty ]; then
            # 通過 pipe 執行，但可以訪問 tty（如 curl | bash）
            echo ""
            log_info "請選擇安裝模式："
            echo "  1) 全域安裝（安裝到 ~/.cursor/，對所有專案生效）"
            echo "  2) 專案安裝（安裝到當前目錄 ./.cursor/，只對當前專案生效）"
            echo "  3) 自訂路徑"
            echo ""

            # 嘗試從 /dev/tty 讀取用戶輸入
            if read choice < /dev/tty 2>/dev/null; then
                case "${choice:-1}" in
                    1)
                        INSTALL_MODE="global"
                        ;;
                    2)
                        INSTALL_MODE="project"
                        ;;
                    3)
                        echo -n "請輸入安裝路徑: " >&2
                        if read CURSOR_DIR < /dev/tty 2>/dev/null; then
                            INSTALL_MODE="custom"
                        else
                            log_warning "無法讀取路徑，使用全域安裝"
                            INSTALL_MODE="global"
                        fi
                        ;;
                    *)
                        log_warning "無效選項，使用預設值（全域安裝）"
                        INSTALL_MODE="global"
                        ;;
                esac
            else
                # 如果 /dev/tty 讀取失敗，嘗試從 stdin 讀取（可能是在某些環境下）
                log_info "嘗試從標準輸入讀取選項..."
                if read -t 5 choice 2>/dev/null; then
                    case "${choice:-1}" in
                        1)
                            INSTALL_MODE="global"
                            ;;
                        2)
                            INSTALL_MODE="project"
                            ;;
                        3)
                            read -p "請輸入安裝路徑: " -t 5 CURSOR_DIR 2>/dev/null || {
                                log_warning "無法讀取路徑，使用全域安裝"
                                INSTALL_MODE="global"
                            }
                            ;;
                        *)
                            log_warning "無效選項，使用預設值（全域安裝）"
                            INSTALL_MODE="global"
                            ;;
                    esac
                else
                    log_warning "無法讀取用戶輸入，使用預設值（全域安裝）"
                    INSTALL_MODE="global"
                fi
            fi
        else
            # 完全無法互動時使用預設值
            log_info "無法進行互動式選擇，使用預設值（全域安裝）"
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

# 下載單個文件
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

# 下載整個目錄的所有文件
download_directory() {
    local dir_name=$1
    local dest_dir=$2

    log_info "獲取 ${dir_name} 目錄內容..."

    # 使用 GitHub API 獲取目錄內容
    local api_response=$(curl -fsSL "${API_URL}/${dir_name}?ref=main")

    if [ $? -ne 0 ]; then
        log_error "無法獲取 ${dir_name} 目錄內容"
        return 1
    fi

    # 檢查 API 響應是否為空或無效
    if [ -z "$api_response" ] || [ "$api_response" = "null" ] || [ "$api_response" = "[]" ]; then
        log_warning "${dir_name} 目錄中沒有找到文件或目錄不存在"
        return 0
    fi

    # 解析 JSON 獲取所有文件的下載 URL
    local file_count=0

    # 使用 Python 或 jq 來解析 JSON（如果有的話）
    if command -v python3 &> /dev/null; then
        # 使用 Python 解析 JSON
        while IFS= read -r url; do
            if [ -n "$url" ] && [ "$url" != "null" ]; then
                local filename=$(basename "$url")
                if ! download_file "$url" "${dest_dir}/${filename}"; then
                    log_error "下載 ${filename} 失敗，停止安裝"
                    return 1
                fi
                file_count=$((file_count + 1))
            fi
        done < <(echo "$api_response" | python3 -c "
import json
import sys
try:
    data = json.load(sys.stdin)
    for item in data:
        if item.get('type') == 'file' and item.get('download_url'):
            print(item['download_url'])
except Exception as e:
    sys.exit(1)
")
    elif command -v jq &> /dev/null; then
        # 使用 jq 解析 JSON
        while IFS= read -r url; do
            if [ -n "$url" ] && [ "$url" != "null" ]; then
                local filename=$(basename "$url")
                if ! download_file "$url" "${dest_dir}/${filename}"; then
                    log_error "下載 ${filename} 失敗，停止安裝"
                    return 1
                fi
                file_count=$((file_count + 1))
            fi
        done < <(echo "$api_response" | jq -r '.[] | select(.type == "file") | .download_url')
    else
        # 備用方法：使用 grep 和 sed（改進版本）
        log_warning "未找到 python3 或 jq，使用備用解析方法"

        # 提取所有 download_url
        local urls=()
        while IFS= read -r line; do
            # 更精確的正則表達式來提取 download_url
            if [[ "$line" =~ \"download_url\"[[:space:]]*:[[:space:]]*\"([^\"]+)\" ]]; then
                local url="${BASH_REMATCH[1]}"
                if [ -n "$url" ] && [ "$url" != "null" ] && [[ "$url" =~ ^https?:// ]]; then
                    urls+=("$url")
                fi
            fi
        done <<< "$api_response"

        # 下載每個文件
        for url in "${urls[@]}"; do
            local filename=$(basename "$url")
            if ! download_file "$url" "${dest_dir}/${filename}"; then
                log_error "下載 ${filename} 失敗，停止安裝"
                return 1
            fi
            file_count=$((file_count + 1))
        done
    fi

    # 檢查解析是否成功
    if [ $file_count -eq 0 ]; then
        log_warning "${dir_name} 目錄中沒有找到可下載的文件"
        return 0
    fi

    log_success "${dir_name} 目錄下載完成（共 ${file_count} 個文件）"
    return 0
}

# 下載所有規則文件
download_rules() {
    log_info "下載 AI Agent 規則文件..."
    download_directory "rules" "${RULES_DIR}" || exit 1
    log_success "規則文件下載完成"
}

# 下載所有命令文件
download_commands() {
    log_info "下載命令文件..."
    download_directory "commands" "${COMMANDS_DIR}" || exit 1
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
}

# 檢查是否已安裝並移除舊版本
check_existing_installation() {
    if [ -d "${RULES_DIR}" ] && [ "$(ls -A ${RULES_DIR} 2>/dev/null)" ]; then
        log_warning "檢測到已存在的安裝"
        log_info "正在移除舊版本..."
        
        # 移除舊的規則文件
        if [ -d "${RULES_DIR}" ]; then
            rm -rf "${RULES_DIR}"
            log_success "已移除舊的規則文件"
        fi
        
        # 移除舊的命令文件
        if [ -d "${COMMANDS_DIR}" ]; then
            rm -rf "${COMMANDS_DIR}"
            log_success "已移除舊的命令文件"
        fi
        
        # 移除舊的版本鎖定文件
        if [ -f "${CURSOR_DIR}/cursor-agents.lock" ]; then
            rm -f "${CURSOR_DIR}/cursor-agents.lock"
            log_success "已移除舊的版本鎖定文件"
        fi
        
        log_success "舊版本已完全移除"
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
