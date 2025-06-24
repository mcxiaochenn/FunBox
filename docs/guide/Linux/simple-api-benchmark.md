# Simple API Benchmark Tool

> 一个简单的Shell脚本，用于对API接口进行压力测试。通过并发多个curl请求来测试API的性能。


![Shell Script](https://img.shields.io/badge/Shell_Script-121011?style=for-the-badge&logo=gnu-bash&logoColor=white)
[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](../files/LICENSE)

## ⚠️ 重要法律声明与警告
:::warning
**在使用本工具前，请务必阅读并理解以下内容：**

1. **仅限合法使用**：
   - 本工具仅可用于您拥有合法权限或已获得明确授权的系统
   - **禁止**用于未经授权的系统测试或任何非法目的

2. **潜在风险**：
   - 不当使用可能导致系统崩溃、服务中断或数据丢失
   - 过度负载测试可能对目标系统造成永久性损害
   - 可能触发目标系统的安全警报或防御机制

3. **法律后果**：
   - 未经授权测试系统可能违反《计算机欺诈与滥用法案》等相关法律
   - 可能面临刑事指控、民事诉讼和巨额赔偿
   - 可能涉及侵犯隐私权、破坏计算机系统等罪名

4. **用户责任**：
   - **您必须确保拥有目标系统的明确授权**
   - 您需对使用本工具产生的所有后果负全责
   - 请遵守所有适用的地方、国家和国际法律

5. **免责声明**：
   - 开发者对工具的滥用不承担任何责任
   - 开发者不保证工具的合法性或适用性
   - 使用本工具即表示您接受所有相关风险和责任

**请负责任地使用本工具！**
:::

---

## 功能特点

- 🚀 多线程并发请求
- 🎲 支持随机内容生成（通过外部API或随机数）
- ⚙️ 支持固定内容测试
- 📊 实时输出每个请求的HTTP状态码和耗时
- 🌐 支持自定义URL（包含UUID和标题路径）
- ⏹️ 优雅退出（Ctrl+C时终止所有后台进程）
- ✅ 用户友好的交互界面
- 📝 配置摘要显示

## 使用说明

### 依赖要求

- `curl`: 用于发送HTTP请求
- `jq`: 用于解析JSON（仅在选择API随机内容时使用）
- `shuf`: 用于生成随机数（通常包含在`coreutils`包中）

在Ubuntu/Debian上安装依赖：
```bash
sudo apt-get install curl jq coreutils
```

在CentOS/RHEL上安装依赖：
```bash
sudo yum install curl jq coreutils
```
在Arch上安装依赖：
```bash
sudo yay -S curl jq coreutils
```

## 使用方法

1. 赋予脚本执行权限：
```bash
chmod +x api_benchmark.sh
```

2. 运行脚本：
```bash
./api_benchmark.sh
```

3. 按照提示输入：

- 基础URL（格式：**`http://ip:port/UUID/标题`**）

- 并发线程数

- 是否使用随机内容

    - 如果选择是，则可以选择随机内容类型：

        - API请求：通过外部API生成随机内容

        - 随机数：生成1~10000000000的随机数

- 如果选择否，则输入固定内容

## 示例

```bash
$ ./api_benchmark.sh
================================================
 Simple API Benchmark Tool v2.0
================================================
请输入基础URL（格式: http://ip:port/UUID/标题）: http://mcxiaochen.top:1145/GUYOLVBoguy687fg/测试标题
请输入并发线程数 [默认 5]: 16
是否使用随机内容？(y/n) [默认 n]: y
选择随机内容类型 (1:API请求 2:随机数) [默认 1]: 2
使用1~10000000000的随机数

============== 测试配置 ===============
目标URL: http://mcxiaochen.top:1145/GUYOLVBoguy687fg/测试标题
并发线程: 16
内容类型: 随机数
=======================================
开始性能测试... 按 Ctrl+C 停止

线程1: HTTP状态码: 200, 耗时: 0.152s
线程2: HTTP状态码: 200, 耗时: 0.138s
...
```

### 退出测试

按 **`Ctrl+C`** 终止测试，脚本会自动清理所有后台进程。

## 贡献

欢迎提交问题和拉取请求！请确保您的代码符合项目的编码风格。

## 许可证
本项目基于 MIT 许可证发布 - 详情请查看 [LICENSE](../files/LICENSE) 文件。