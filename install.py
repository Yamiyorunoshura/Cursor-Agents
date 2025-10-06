#!/usr/bin/env python3
"""
Cursor AI Agents 安裝腳本 (Python 版本)
用途：從 GitHub 下載最新版本並安裝至 Cursor 配置目錄

使用方法：
  全域安裝（預設）：
    python3 install.py
  或：curl -fsSL https://raw.githubusercontent.com/Yamiyorunoshura/Cursor-Agents/main/install.py | python3

  專案安裝（當前目錄）：
    python3 install.py project
  或：INSTALL_MODE=project python3 install.py

  自訂路徑安裝：
    python3 install.py /custom/path
  或：INSTALL_PATH=/custom/path python3 install.py
"""

import os
import sys
import json
import shutil
import argparse
from pathlib import Path
from typing import List, Optional, Tuple
from concurrent.futures import ThreadPoolExecutor, as_completed
from urllib.request import urlopen, Request
from urllib.error import URLError, HTTPError

# 啟用 Windows 終端顏色支持
if sys.platform == 'win32':
    try:
        import ctypes
        kernel32 = ctypes.windll.kernel32
        kernel32.SetConsoleMode(kernel32.GetStdHandle(-11), 7)
    except Exception:
        pass  # 如果失敗，繼續執行但顏色可能不會顯示

# 顏色定義
class Colors:
    RED = '\033[0;31m'
    GREEN = '\033[0;32m'
    YELLOW = '\033[1;33m'
    BLUE = '\033[0;34m'
    NC = '\033[0m'  # No Color

# 遠端倉庫 URL
REPO_URL = "https://github.com/Yamiyorunoshura/Cursor-Agents"
RAW_URL = f"{REPO_URL}/raw/main"
API_URL = "https://api.github.com/repos/Yamiyorunoshura/Cursor-Agents/contents"

# 安裝路徑變數
cursor_dir = ""
commands_dir = ""
install_mode = ""


def log_info(message: str) -> None:
    """輸出資訊訊息"""
    print(f"{Colors.BLUE}[INFO]{Colors.NC} {message}")


def log_success(message: str) -> None:
    """輸出成功訊息"""
    print(f"{Colors.GREEN}[SUCCESS]{Colors.NC} {message}")


def log_warning(message: str) -> None:
    """輸出警告訊息"""
    print(f"{Colors.YELLOW}[WARNING]{Colors.NC} {message}")


def log_error(message: str) -> None:
    """輸出錯誤訊息"""
    print(f"{Colors.RED}[ERROR]{Colors.NC} {message}")


def check_dependencies() -> None:
    """檢查必要工具"""
    log_info("檢查系統依賴...")
    
    # Python 內建 urllib，不需要額外的下載工具
    
    # 檢查 git 是否安裝
    if not shutil.which('git'):
        log_warning("git 未安裝，建議安裝 git 以便後續更新")
    
    log_success("系統依賴檢查完成")


def determine_install_path(args: argparse.Namespace) -> Tuple[str, str, str]:
    """決定安裝路徑"""
    global cursor_dir, commands_dir, install_mode
    
    log_info("決定安裝路徑...")
    
    # 優先級 1: 檢查命令行參數
    if args.path:
        if args.path in ['project', 'local']:
            install_mode = 'project'
        elif args.path == 'global':
            install_mode = 'global'
        else:
            # 假設是自訂路徑
            cursor_dir = args.path
            install_mode = 'custom'
    
    # 優先級 2: 檢查環境變數 INSTALL_PATH
    if not cursor_dir and os.environ.get('INSTALL_PATH'):
        cursor_dir = os.environ['INSTALL_PATH']
        install_mode = 'custom'
    
    # 優先級 3: 檢查環境變數 INSTALL_MODE
    if not install_mode and os.environ.get('INSTALL_MODE'):
        mode = os.environ['INSTALL_MODE']
        if mode in ['project', 'local']:
            install_mode = 'project'
        elif mode == 'global':
            install_mode = 'global'
    
    # 優先級 4: 互動式選擇
    if not install_mode and not cursor_dir:
        if sys.stdin.isatty():
            print()
            log_info("請選擇安裝模式：")
            print("  1) 全域安裝（安裝到 ~/.cursor/，對所有專案生效）")
            print("  2) 專案安裝（安裝到當前目錄 ./.cursor/，只對當前專案生效）")
            print("  3) 自訂路徑")
            print()
            
            try:
                choice = input("請輸入選項 [1-3] (預設: 1): ").strip() or '1'
                
                if choice == '1':
                    install_mode = 'global'
                elif choice == '2':
                    install_mode = 'project'
                elif choice == '3':
                    cursor_dir = input("請輸入安裝路徑: ").strip()
                    install_mode = 'custom'
                else:
                    log_warning("無效選項，使用預設值（全域安裝）")
                    install_mode = 'global'
            except (EOFError, KeyboardInterrupt):
                log_warning("\n無法讀取用戶輸入，使用預設值（全域安裝）")
                install_mode = 'global'
        else:
            log_info("無法進行互動式選擇，使用預設值（全域安裝）")
            install_mode = 'global'
    
    # 根據模式設定實際路徑
    if install_mode == 'global':
        cursor_dir = str(Path.home() / '.cursor')
        log_info("安裝模式：全域安裝")
    elif install_mode == 'project':
        cursor_dir = str(Path.cwd() / '.cursor')
        log_info("安裝模式：專案安裝")
    elif install_mode == 'custom':
        # 展開 ~ 符號
        cursor_dir = str(Path(cursor_dir).expanduser())
        log_info("安裝模式：自訂路徑")
    else:
        cursor_dir = str(Path.home() / '.cursor')
        log_info("安裝模式：全域安裝（預設）")
    
    commands_dir = str(Path(cursor_dir) / 'commands')
    
    print()
    log_success("安裝路徑已確定：")
    print(f"  - 主目錄: {cursor_dir}")
    print(f"  - 命令文件: {commands_dir}")
    print()
    
    return cursor_dir, commands_dir, install_mode


def create_directories() -> None:
    """創建目錄結構"""
    log_info("創建目錄結構...")
    
    Path(commands_dir).mkdir(parents=True, exist_ok=True)
    
    log_success("目錄結構創建完成")


def download_file(url: str, dest: str) -> Tuple[bool, str]:
    """下載單個文件（用於並行執行）"""
    filename = os.path.basename(dest)
    
    try:
        req = Request(url)
        req.add_header('User-Agent', 'Cursor-Agents-Installer/1.0')
        
        with urlopen(req, timeout=30) as response:
            content = response.read()
        
        with open(dest, 'wb') as f:
            f.write(content)
        
        return True, filename
    except (URLError, HTTPError) as e:
        return False, f"{filename} (錯誤: {e})"
    except Exception as e:
        return False, f"{filename} (錯誤: {e})"


def download_directory(dir_name: str, dest_dir: str, max_workers: int = 5) -> bool:
    """下載整個目錄的所有文件（並行下載）"""
    log_info(f"獲取 {dir_name} 目錄內容...")
    
    try:
        # 使用 GitHub API 獲取目錄內容
        api_url = f"{API_URL}/{dir_name}?ref=main"
        req = Request(api_url)
        req.add_header('User-Agent', 'Cursor-Agents-Installer/1.0')
        
        with urlopen(req, timeout=30) as response:
            api_response = response.read().decode('utf-8')
        
        # 解析 JSON
        data = json.loads(api_response)
        
        if not data or data == "null" or data == []:
            log_warning(f"{dir_name} 目錄中沒有找到文件或目錄不存在")
            return True
        
        # 提取所有文件的下載 URL
        download_tasks = []
        for item in data:
            if item.get('type') == 'file' and item.get('download_url'):
                url = item['download_url']
                filename = os.path.basename(url)
                dest_path = os.path.join(dest_dir, filename)
                download_tasks.append((url, dest_path))
        
        if not download_tasks:
            log_warning(f"{dir_name} 目錄中沒有找到可下載的文件")
            return True
        
        # 並行下載所有文件
        log_info(f"開始並行下載 {len(download_tasks)} 個文件（最多 {max_workers} 個並行連線）...")
        
        success_count = 0
        failed_files = []
        
        with ThreadPoolExecutor(max_workers=max_workers) as executor:
            # 提交所有下載任務
            future_to_task = {
                executor.submit(download_file, url, dest): (url, dest) 
                for url, dest in download_tasks
            }
            
            # 收集結果
            for future in as_completed(future_to_task):
                success, result = future.result()
                if success:
                    log_success(f"{result} 下載完成")
                    success_count += 1
                else:
                    log_error(f"{result} 下載失敗")
                    failed_files.append(result)
        
        if failed_files:
            log_error(f"以下文件下載失敗：{', '.join(failed_files)}")
            return False
        
        log_success(f"{dir_name} 目錄下載完成（共 {success_count} 個文件）")
        return True
        
    except json.JSONDecodeError as e:
        log_error(f"JSON 解析錯誤: {e}")
        return False
    except (URLError, HTTPError) as e:
        log_error(f"無法獲取 {dir_name} 目錄內容: {e}")
        return False
    except Exception as e:
        log_error(f"下載過程中發生錯誤: {e}")
        return False


def download_commands() -> bool:
    """下載所有命令文件"""
    log_info("下載命令文件...")
    if not download_directory("commands", commands_dir):
        return False
    log_success("命令文件下載完成")
    return True


def download_lock_file() -> bool:
    """下載版本鎖定文件"""
    log_info("下載版本鎖定文件...")
    
    lock_file_path = os.path.join(cursor_dir, "cursor-agents.lock")
    success, result = download_file(f"{RAW_URL}/cursor-agents.lock", lock_file_path)
    
    if not success:
        log_error(f"版本鎖定文件下載失敗: {result}")
        return False
    
    log_success("版本鎖定文件下載完成")
    return True


def show_usage() -> None:
    """顯示使用說明"""
    print()
    log_success("==========================================")
    log_success("  Cursor AI Agents 安裝完成！")
    log_success("==========================================")
    print()
    log_info("安裝位置：")
    print(f"  - 命令文件: {commands_dir}")
    print()
    
    if install_mode == 'project':
        log_warning("您使用了專案安裝模式，Agent 命令只會在當前專案中生效")
        log_info("如需在其他專案中使用，請重新執行安裝腳本")
        print()
    elif install_mode == 'global':
        log_info("您使用了全域安裝模式，Agent 命令將對所有 Cursor 專案生效")
        print()


def check_existing_installation() -> None:
    """檢查是否已安裝並移除舊版本"""
    commands_path = Path(commands_dir)
    
    if commands_path.exists() and any(commands_path.iterdir()):
        log_warning("檢測到已存在的安裝")
        log_info("正在移除舊版本...")
        
        # 移除舊的命令文件
        if commands_path.exists():
            shutil.rmtree(commands_path)
            log_success("已移除舊的命令文件")
        
        # 移除舊的版本鎖定文件
        lock_file = Path(cursor_dir) / "cursor-agents.lock"
        if lock_file.exists():
            lock_file.unlink()
            log_success("已移除舊的版本鎖定文件")
        
        log_success("舊版本已完全移除")


def main():
    """主函數"""
    global cursor_dir, commands_dir, install_mode
    
    # 設定命令行參數解析
    parser = argparse.ArgumentParser(
        description='Cursor AI Agents 安裝程式',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=__doc__
    )
    parser.add_argument(
        'path',
        nargs='?',
        help='安裝模式或路徑 (global/project/自訂路徑)'
    )
    parser.add_argument(
        '-w', '--workers',
        type=int,
        default=10,
        help='並行下載的最大連線數（預設: 10）'
    )
    
    args = parser.parse_args()
    
    print()
    log_info("==========================================")
    log_info("  Cursor AI Agents 安裝程式 (Python)")
    log_info("==========================================")
    print()
    
    try:
        check_dependencies()
        cursor_dir, commands_dir, install_mode = determine_install_path(args)
        check_existing_installation()
        create_directories()
        
        # 並行下載
        if not download_commands():
            sys.exit(1)
        
        if not download_lock_file():
            sys.exit(1)
        
        show_usage()
        
    except KeyboardInterrupt:
        print()
        log_warning("安裝已被用戶中斷")
        sys.exit(1)
    except Exception as e:
        log_error(f"安裝過程中發生錯誤: {e}")
        sys.exit(1)


if __name__ == '__main__':
    main()

