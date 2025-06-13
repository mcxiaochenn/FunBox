# Arch-Purge 🧹

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

> 安全清理 Arch Linux 垃圾文件的智能脚本 | 遵循 **「宁可遗漏，绝不误删」** 原则

## 功能特性 ✨

- 🛡️ **安全第一**：自动排除配置文件、用户数据及关键缓存
- 🧠 **智能识别**：针对 Arch Linux 特有文件结构优化
- 📦 **多工具支持**：原生适配 `pacman`/`yay`/`paru` 等包管理器
- ⏳ **时间策略**：保留近期文件（可配置保留周期）
- 📊 **日志记录**：详细操作记录保存在 `/tmp/arch-clean.log`

## 清理内容 🗑️

| 类别                | 清理策略                          |
|---------------------|----------------------------------|
| 软件包缓存          | 保留当前+前1个版本 (`paccache`)  |
| AUR 构建文件        | 清除 `src/` 和 `pkg/` 目录       |
| 系统日志            | 保留最近2周 (`journalctl`)       |
| 临时文件            | `/tmp`(7天+), `/var/tmp`(30天+)  |
| 用户缓存            | 30天未访问（排除浏览器等）       |
| 开发工具缓存        | npm/pip 旧日志(180天+)           |

## 安装教程

### 通过curl安装
```bash
sudo curl -L https://github.com/mcxiaochenn/FunBox/raw/refs/heads/main/Arch-Linux/Arch-Purge/arch-purge.sh -o /usr/local/bin/arch-purge
sudo chmod +x /usr/local/bin/arch-purge
```

### 手动运行

1. 克隆仓库：
```bash
git clone https://github.com/mcxiaochenn/FunBox.git
```

2. 运行脚本：
```bash
cd Arch-Linux/Arch-Purge
chmod +x arch-purge.sh
./arch-purge.sh
```

## 使用方法


### 基础命令

```bash
# 普通用户模式（仅用户空间）
arch-purge

# 完整清理模式（需要root）
sudo arch-purge
```

### 查看日志

```bash
less /tmp/arch-clean.log
```

## 卸载方法

```bash
sudo rm /usr/local/bin/arch-purge
```

## 常见问题

Q: 如何确认哪些文件会被删除？

A: 首次运行时添加 --dry-run 参数（需自行实现）

Q: 清理后如何查看恢复了多少空间？

A: 使用如下指令

```bash
df -h  # 查看磁盘空间变化
```

## 贡献指南

> 如果你发现项目的任何问题欢迎提出贡献。

1. Fork 本仓库

2. 创建新分支 (**git checkout -b feat/xxx**)

3. 提交更改 (**git commit -am 'Add feature'**)

4. 推送分支 (**git push origin feat/xxx**)

5. 新建 Pull Request