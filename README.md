# Windows Server 一键重装脚本

这是一个用于 **快速重装 Windows Server 系统** 的 Shell 脚本，支持安装以下系统版本：

- Windows Server 2012
- Windows Server 2016
- Windows Server 2019
- Windows Server 2022
- Windows Server 2025

本脚本基于 [reinstall 项目](https://github.com/bin456789/reinstall) 实现自动化重装流程。

## 📦 功能特色

- 自动判断国内/国外网络环境，选择最佳下载源
- 自动检测并安装 `curl`
- 提供系统版本选择菜单
- 自动下载所选系统镜像并安装
- 自定义设置 Administrator 密码
- 默认安装标准桌面体验版
- 全自动、无人值守

## 🚀 使用方法

```bash
wget https://yourdomain.com/start.sh -O start.sh
chmod +x start.sh
./start.sh
或者使用 curl：

bash
复制
编辑
curl -O https://yourdomain.com/start.sh
chmod +x start.sh
./start.sh
⚠️ 请使用 root 权限运行脚本，否则可能无法安装依赖或下载文件。

📥 脚本说明
运行后你将看到一个菜单，选择要安装的 Windows Server 版本，并输入 Administrator 密码，确认后脚本会自动进行下载并安装系统，重装完成后你可以通过远程桌面使用新系统。

📚 依赖说明
ping（用于判断网络环境）

curl 或 wget（至少需要其一）

网络需通畅，支持 HTTP/HTTPS 请求

🧩 本项目使用的核心组件
本项目调用了开源项目 bin456789/reinstall，用于实际的系统部署与安装逻辑。

该项目遵循 GPL-3.0 开源许可证，详情请参考其 LICENSE 文件。

📝 License
本脚本本身与其依赖的 reinstall 项目共同遵循：

GNU General Public License v3.0 (GPL-3.0)

你可以自由使用、修改、分发，但请保留原始作者署名及开源协议声明。

❤️ 致谢
感谢 bin456789 提供的重装核心项目支持。
