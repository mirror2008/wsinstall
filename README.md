
# Windows Server 一键重装脚本

这是一个用于 **快速重装 Windows Server 系统** 的 Shell 脚本，支持安装以下系统版本：

- Windows Server 2012  
- Windows Server 2016  
- Windows Server 2019  (已对接高速微软云下载+正式版系统)
- Windows Server 2022  (已对接高速微软云下载+正式版系统)
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

🚀 **[七九网络免费网盘 · 提供高速下载源](https://pan.079idc.net)**  
为系统镜像、ISO、备份文件提供稳定直连下载存储服务  
适合 VPS 初始化 / 重装 / 批量部署场景  
长期可用，不玩限速、不搞花活

☁️ **[七九网络 · 079IDC 高性价比 BGP 云服务器](https://079idc.net)**  
BGP 多线接入，南北互通，国内外访问均衡  
KVM 架构 · 性能真实不虚标  
适合建站、代理、业务部署、长期跑服务  
线路干净，价格克制，运维不折腾

---

## 🚀 使用方法

### 一键运行命令（推荐）

#### 🏠 国内服务器请使用：

```bash
wget https://gitee.com/yanda2008/wsinstall/raw/main/wsinstall.sh -O wsinstall.sh
chmod +x wsinstall.sh
./wsinstall.sh
```

#### 🌏 海外服务器请使用：

```bash
wget https://github.com/mirror2008/wsinstall/raw/main/wsinstall.sh -O wsinstall.sh
chmod +x wsinstall.sh
./wsinstall.sh
```

或者使用 `curl`：

#### 🏠 国内服务器：

```bash
curl -O https://gitee.com/yanda2008/wsinstall/raw/main/wsinstall.sh
chmod +x wsinstall.sh
./wsinstall.sh
```

#### 🌏 海外服务器：

```bash
curl -O https://github.com/mirror2008/wsinstall/raw/main/wsinstall.sh
chmod +x wsinstall.sh
./wsinstall.sh
```

⚠️ **请务必使用 `root` 权限运行脚本**，否则可能无法安装依赖或成功执行系统安装！

⚠️ **请务必使用 观看 关于 Evaluation（测试版）激活方案**，否则可能导致系统测试许可证到期后每隔一小时重启！

⚠️ **关于远程桌面账户被锁定的处理方法（重要）**，否则可能导致账户被锁定无法远程。
---

## 🧩 脚本说明

- 自动检测是否可以访问 `google.com`，智能判断是国内还是国外网络；
- 自动安装 `curl`（若未安装）；
- 根据网络环境从 Gitee / GitHub 下载核心脚本 `reinstall.sh`；
- 用户可交互式选择需要安装的 Windows Server 系统版本；
- 输入密码后，自动开始安装流程，全程无人值守。

---

## 📚 依赖组件

- `ping`
- `curl` 或 `wget`（至少需要一个）
- Bash 终端环境
- 正常的公网网络连接

---

## 🔐 关于 Evaluation（测试版）激活方案

由于微软只公开提供 Evaluation（试用）版本的 ISO 镜像，该版本 **默认限制使用 180 天**，到期后会出现**每小时自动重启**等骚操作，非常影响使用体验。

所以我们可以通过开源工具 **Microsoft Activation Scripts (MAS)** 将其转换为正式版并激活：

### ✅ 步骤如下：

1. 打开 PowerShell（**以管理员身份运行！**）  
2. 执行以下命令启动 MAS 工具：

   ```powershell
   irm https://get.activated.win | iex
   ```

3. 在弹出的菜单中选择：

   - `[7] Change Windows Edition`（更改版本）  
   - 然后选择 `[2] ServerStandard`（转换为正式版标准版）  
   - 接着选择 `[1] Continue`，等待转换完成后，系统会自动重启  

4. 重启后，再次打开 PowerShell（管理员身份），再次执行：

   ```powershell
   irm https://get.activated.win | iex
   ```

5. 然后选择：

   - `[3] Activation - Windows`  
   - 再选择 `[1] Activate`，等待激活完成即可  

💡 激活完成后系统就变成了正式版，**无限期使用无压力！**

---
🔓 关于远程桌面账户被锁定的处理方法（重要）

在系统重装完成并通过远程桌面（RDP）首次登录时，
如果由于 多次输入错误密码，可能会触发 Windows 默认的 账户锁定策略，导致无法继续登录。

✅ 永久解决方法（推荐）

请通过 云服务商后台 / VNC / KVM 控制台 登录服务器，
以管理员身份运行 PowerShell，执行以下命令：

net accounts /lockoutthreshold:0

📌 命令说明

将 账户锁定阈值 设置为 0

表示：永久关闭账户锁定机制

之后即使多次远程登录失败，也不会再锁定账户

等价于以下 GUI 操作：

本地安全策略 → 账户策略 → 账户锁定策略 → 账户锁定阈值 = 0


⚠️ 安全提醒：
若服务器直接暴露在公网，建议配合 防火墙 IP 白名单 / 修改 RDP 端口 / VPN 使用，以防止暴力破解。
## 🧠 核心组件来源

本脚本调用了开源项目：[bin456789/reinstall](https://github.com/bin456789/reinstall)

该项目基于 GPL-3.0 开源许可证，详情请参考其 [LICENSE 文件](https://github.com/bin456789/reinstall/blob/main/LICENSE)

---

## 📝 License

本项目遵循以下开源协议：

**GNU General Public License v3.0 (GPL-3.0)**  
您可以自由复制、修改、发布，但必须保留原始作者署名和开源协议说明。

---

## ❤️ 致谢

特别感谢 [reinstall 项目](https://github.com/bin456789/reinstall) 提供的强大系统部署支持！

也感谢 MAS 项目的作者，提供了便捷且稳定的激活方案，让 Evaluation 用户也能无痛转正式！

