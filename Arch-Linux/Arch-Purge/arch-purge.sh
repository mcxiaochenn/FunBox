#!/bin/bash

# Arch Linux 安全清理脚本
# 清理原则：只删除可安全重建的缓存/临时文件，避免触及用户数据
# 需要root权限执行系统级清理，用户级清理会自动适配当前用户
# by DeepSeek

# 退出状态检查函数
safe_clean() {
    echo -e "\n\033[1;34m[清理开始]\033[0m 正在安全清理系统..."
    
    # ====================
    # 系统级清理 (需要root)
    # ====================
    if [[ $EUID -eq 0 ]]; then
        echo -e "\n\033[1;33m[系统级清理]\033[0m"
        
        # 1. pacman包缓存 (保留当前和上一个版本)
        if command -v paccache &> /dev/null; then
            echo "-> 清理旧版本软件包缓存"
            paccache -rvk2  # 保留2个版本
            paccache -rvuk0 # 删除未安装包的缓存
        else
            echo "警告: paccache 未安装，跳过包缓存清理"
            echo "      请安装 pacman-contrib 包"
        fi
        
        # 2. 系统日志 (保留最近2周)
        echo "-> 清理系统日志(保留2周)"
        journalctl --vacuum-time=2weeks 2>/dev/null
        
        # 3. 临时文件 (安全删除)
        echo "-> 清理临时文件"
        find /tmp -mindepth 1 -user root -mtime +7 -exec rm -rf {} + 2>/dev/null
        find /var/tmp -mindepth 1 -user root -mtime +30 -exec rm -rf {} + 2>/dev/null
    else
        echo -e "\n\033[1;33m[跳过系统级清理]\033[0m 需要root权限"
    fi
    
    # ====================
    # 用户级清理
    # ====================
    echo -e "\n\033[1;33m[用户级清理]\033[0m (用户: $USER)"
    
    # 4. AUR构建文件 (yay/paru)
    declare -a aur_helpers=(yay paru)
    for helper in "${aur_helpers[@]}"; do
        cache_dir="$HOME/.cache/$helper"
        if [[ -d "$cache_dir" ]]; then
            echo "-> 清理 $helper 构建文件"
            # 安全删除：仅清除src/pkg目录，保留下载的源码
            find "$cache_dir" -maxdepth 1 -type d -name '*/*' | while read -r pkg; do
                rm -rf "$pkg"/{src,pkg} 2>/dev/null
            done
        fi
    done
    
    # 5. 用户缓存 (30天以上未访问)
    echo "-> 清理用户缓存(30天+)"
    user_cache_dir="$HOME/.cache"
    if [[ -d "$user_cache_dir" ]]; then
        # 排除重要缓存目录
        find "$user_cache_dir" -depth -type f -atime +30 \
            ! -path "*fontconfig*" \
            ! -path "*mozilla*" \
            ! -path "*chromium*" \
            ! -path "*google-chrome*" \
            ! -path "*Spotify*" \
            ! -path "*discord*" \
            -exec rm -f {} + 2>/dev/null
        
        # 删除空目录 (保留顶层结构)
        find "$user_cache_dir" -mindepth 1 -type d -empty -delete 2>/dev/null
    fi
    
    # 6. 缩略图缓存
    thumbnails_dir="$HOME/.cache/thumbnails"
    [[ -d "$thumbnails_dir" ]] && rm -rf "$thumbnails_dir" 2>/dev/null
    
    # 7. 应用日志
    echo "-> 清理应用日志"
    find "$HOME" \( -path "*.cache/*.log" -o -path "*.local/share/*.log" \) \
        -type f -mtime +30 -exec rm -f {} + 2>/dev/null
    
    # 8. 开发工具缓存
    [[ -d "$HOME/.npm/_logs" ]] && find "$HOME/.npm/_logs" -name '*.log' -mtime +30 -delete
    [[ -d "$HOME/.cache/pip" ]] && find "$HOME/.cache/pip" -type f -mtime +180 -delete
    
    echo -e "\n\033[1;32m[清理完成]\033[0m 系统垃圾已安全清除"
}

# 执行清理并处理错误
safe_clean 2>&1 | tee /tmp/arch-clean.log
exit_status=${PIPESTATUS[0]}

# 显示摘要
echo -e "\n\033[1;35m[清理摘要]\033[0m"
grep -i '清理\|跳过\|警告' /tmp/arch-clean.log | uniq

if [[ $exit_status -ne 0 ]]; then
    echo -e "\n\033[1;31m[注意] 部分操作遇到错误，请检查完整日志: /tmp/arch-clean.log\033[0m"
    exit 1
fi
