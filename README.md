# Windows Server 一键重装脚本

这是一个用于 **快速重装 Windows Server 系统** 的 Shell 脚本，支持安装以下系统版本：

- Windows Server 2012  
- Windows Server 2016  
- Windows Server 2019  
- Windows Server 2022  
- Windows Server 2025  

本脚本基于 [reinstall 项目](https://github.com/bin456789/reinstall) 实现自动化重装流程。

---

## 📦 功能特色

- 自动判断国内/国外网络环境，选择最佳下载源
- 自动检测并安装 `curl`
- 提供系统版本选择菜单
- 自动下载所选系统镜像并安装
- 自定义设置 Administrator 密码
- 默认安装标准桌面体验版
- 全自动、无人值守安装

---

## 🚀 使用方法

### 一键运行命令

```bash
wget https://github.com/mirror2008/wsinstall/raw/main/wsinstall.sh -O wsinstall.sh
chmod +x wsinstall.sh
./wsinstall.sh
或者使用 curl：
curl -O https://github.com/mirror2008/wsinstall/raw/main/wsinstall.sh
chmod +x wsinstall.sh
./wsinstall.sh

---
⚠️ 请使用 root 权限运行脚本，否则可能无法安装依赖或执行安装。

🧩 脚本说明
自动检测是否可以访问 google.com，判断是否为国内/国外环境；

若未安装 curl，脚本会自动尝试使用适合的包管理器安装；

自动从 GitHub 或 GitLab 下载核心 reinstall.sh；

用户选择所需安装的 Windows Server 版本；

输入密码后脚本将执行安装。

📚 依赖组件
ping

curl 或 wget（至少需一个）

Bash 终端环境

正常网络连接

🧠 本项目使用的核心组件
本脚本调用了开源项目：bin456789/reinstall

该项目基于 GPL-3.0 开源许可证，详情请参考其 LICENSE 文件

📝 License
本项目遵循：

GNU General Public License v3.0 (GPL-3.0)

您可以自由复制、修改、发布，但必须保留原始作者署名和开源协议声明。

❤️ 致谢
特别感谢项目 reinstall 提供的强大系统部署支持！
