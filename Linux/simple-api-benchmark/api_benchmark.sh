#!/bin/bash

# Simple API Benchmark Tool
# Version: 2.0
# Author: Your Name
# License: MIT

# 函数：生成随机内容
generate_random_content() {
    local content_type=$1
    
    if [ "$content_type" == "api" ]; then
        # 调用外部API生成随机内容
        curl -s "https://random-data-api.com/api/v2/users" | jq -r '.uid' | tr -d '\n'
    else
        # 生成1~10000000000的随机数
        shuf -i 1-10000000000 -n 1
    fi
}

# 清理函数：终止所有后台进程
cleanup() {
    echo -e "\n终止测试..."
    kill $(jobs -p) 2>/dev/null
    wait $(jobs -p) 2>/dev/null
    echo "所有测试线程已停止"
    exit 0
}

# 捕获Ctrl+C信号
trap cleanup SIGINT

# 显示标题
echo "================================================"
echo " Simple API Benchmark Tool v2.0"
echo "================================================"

# 提示用户输入基础URL（包含UUID和标题）
read -p "请输入基础URL（格式: http://ip:port/UUID/标题）: " base_url

# 改进的URL验证（支持中文编码）
if [[ ! "$base_url" =~ ^http://[^/]+/[^/]+/[^/]+$ ]]; then
    # 尝试处理以斜杠结尾的URL
    if [[ "$base_url" =~ ^http://[^/]+/[^/]+/[^/]+/$ ]]; then
        base_url=${base_url%/}
    else
        echo "错误：URL格式应为 http://ip:port/UUID/标题"
        echo "示例: http://192.168.1.100:8080/550e8400-e29b-41d4-a716-446655440000/测试标题"
        exit 1
    fi
fi

# 提示用户输入线程数
read -p "请输入并发线程数 [默认 5]: " threads
threads=${threads:-5}

# 验证线程数为正整数
if ! [[ "$threads" =~ ^[1-9][0-9]*$ ]]; then
    echo "错误：线程数必须是大于0的整数"
    exit 1
fi

# 询问是否使用随机内容
read -p "是否使用随机内容？(y/n) [默认 n]: " use_random
use_random=${use_random:-n}

if [[ "$use_random" == "y" || "$use_random" == "Y" ]]; then
    # 选择随机内容类型
    read -p "选择随机内容类型 (1:API请求 2:随机数) [默认 1]: " random_type
    random_type=${random_type:-1}
    
    if [[ "$random_type" == "1" ]]; then
        content_type="api"
        echo "使用API请求生成随机内容"
    else
        content_type="number"
        echo "使用1~10000000000的随机数"
    fi
else
    # 输入固定内容
    read -p "请输入固定内容 [默认 test]: " fixed_content
    fixed_content=${fixed_content:-test}
fi

# 显示配置摘要
echo ""
echo "============== 测试配置 ==============="
echo "目标URL: $base_url"
echo "并发线程: $threads"
if [[ "$use_random" == "y" || "$use_random" == "Y" ]]; then
    echo "内容类型: $([ "$content_type" == "api" ] && echo "API随机" || echo "随机数")"
else
    echo "内容类型: 固定内容 ($fixed_content)"
fi
echo "======================================="
echo "开始性能测试... 按 Ctrl+C 停止"
echo ""

# 单个线程的请求函数
run_requests() {
    local thread_id=$1
    
    while true; do
        # 构建最终URL
        if [[ "$use_random" == "y" || "$use_random" == "Y" ]]; then
            content=$(generate_random_content "$content_type")
            full_url="${base_url}/${content}"
        else
            full_url="${base_url}/${fixed_content}"
        fi
        
        # 执行curl请求
        curl -s -o /dev/null -w "线程$thread_id: HTTP状态码: %{http_code}, 耗时: %{time_total}s\n" "$full_url"
    done
}

# 启动指定数量的线程
for ((i=1; i<=threads; i++)); do
    run_requests "$i" &  # 后台运行请求函数
done

# 等待所有后台任务完成
wait