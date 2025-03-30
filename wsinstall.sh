#!/bin/bash

# 判断是否为国外机器
echo "正在检测网络状态..."
ping -c 2 -W 2 google.com > /dev/null 2>&1
if [ $? -eq 0 ]; then
    LOCATION="foreign"
    echo "✅ 网络通畅，判定为国外机器"
else
    LOCATION="china"
    echo "⚠️ 无法连接 Google，判定为国内机器"
fi

# 检测是否安装 curl
echo "正在检测 curl 是否安装..."
if ! command -v curl > /dev/null 2>&1; then
    echo "未检测到 curl，尝试安装中..."

    OS=""
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
    elif [ -f /etc/redhat-release ]; then
        OS="centos"
    fi

    INSTALL_SUCCESS=false

    case "$OS" in
        debian|ubuntu)
            apt update && apt install -y curl && INSTALL_SUCCESS=true
            ;;
        centos|rhel)
            yum install -y curl && INSTALL_SUCCESS=true
            ;;
        alpine)
            apk add curl && INSTALL_SUCCESS=true
            ;;
        *)
            echo "未知系统，尝试使用通用方式安装 curl..."
            if command -v apt >/dev/null; then apt update && apt install -y curl && INSTALL_SUCCESS=true; fi
            if command -v yum >/dev/null && [ "$INSTALL_SUCCESS" = false ]; then yum install -y curl && INSTALL_SUCCESS=true; fi
            if command -v apk >/dev/null && [ "$INSTALL_SUCCESS" = false ]; then apk add curl && INSTALL_SUCCESS=true; fi
            ;;
    esac

    if [ "$INSTALL_SUCCESS" = false ]; then
        echo "❌ 无法自动安装 curl，请手动安装 curl 后重新运行本程序"
        exit 1
    fi
else
    echo "✅ curl 已安装"
fi

# 下载 reinstall.sh
echo "正在下载 reinstall.sh..."
if [ "$LOCATION" = "foreign" ]; then
    curl -O https://raw.githubusercontent.com/bin456789/reinstall/main/reinstall.sh || wget -O reinstall.sh https://raw.githubusercontent.com/bin456789/reinstall/main/reinstall.sh
else
    curl -O https://gitlab.com/bin456789/reinstall/-/raw/main/reinstall.sh || wget -O reinstall.sh https://gitlab.com/bin456789/reinstall/-/raw/main/reinstall.sh
fi

chmod 777 reinstall.sh

# 选择系统版本
echo ""
echo "请选择需要安装的系统："
echo "1. Windows Server 2012"
echo "2. Windows Server 2016"
echo "3. Windows Server 2019"
echo "4. Windows Server 2022"
echo "5. Windows Server 2025"
echo ""
echo "提示：安装的系统默认为【标准带桌面体验版】"
read -p "请输入选项数字 (1-5): " SYS_OPTION

case "$SYS_OPTION" in
    1) SYS_NAME="Windows Server 2012 R2 SERVERSTANDARD"
       ISO_URL="https://download.microsoft.com/download/D/6/7/D675380B-0028-46B3-B47F-A0646E859F76/9600.17050.WINBLUE_REFRESH.140317-1640_X64FRE_SERVER_EVAL_ZH-CN-IR3_SSS_X64FREE_ZH-CN_DV9.ISO"
       ;;
    2) SYS_NAME="Windows Server 2016 SERVERSTANDARD"
       ISO_URL="https://download.microsoft.com/download/B/5/F/B5F1A996-B590-45FD-BA99-DE7E745A0882/14393.0.161119-1705.RS1_REFRESH_SERVER_EVAL_X64FRE_ZH-CN.ISO"
       ;;
    3) SYS_NAME="Windows Server 2019 SERVERSTANDARD"
       ISO_URL="https://software-static.download.prss.microsoft.com/dbazure/988969d5-f34g-4e03-ac9d-1f9786c66749/17763.3650.221105-1748.rs5_release_svc_refresh_SERVER_EVAL_x64FRE_zh-cn.iso"
       ;;
    4) SYS_NAME="Windows Server 2022 SERVERSTANDARD"
       ISO_URL="https://software-static.download.prss.microsoft.com/dbazure/988969d5-f34g-4e03-ac9d-1f9786c66756/20348.1787.230607-0640.fe_release_svc_refresh_SERVER_EVAL_x64FRE_zh-cn.iso"
       ;;
    5) SYS_NAME="Windows Server 2025 SERVERSTANDARD"
       ISO_URL="https://software-static.download.prss.microsoft.com/dbazure/888969d5-f34g-4e03-ac9d-1f9786c66749/26100.1742.240906-0331.ge_release_svc_refresh_SERVER_EVAL_x64FRE_zh-cn.iso"
       ;;
    *)
       echo "❌ 无效选项，退出"
       exit 1
       ;;
esac

# 用户输入密码
read -p "请输入系统密码（Administrator 登录密码）: " SYS_PASSWORD
if [ -z "$SYS_PASSWORD" ]; then
    echo "❌ 密码不能为空，退出"
    exit 1
fi

# 用户输入远程桌面端口号
read -p "请输入远程桌面端口号（默认3389，直接按 Enter 使用默认）: " RDP_PORT
if [ -z "$RDP_PORT" ]; then
    RDP_PORT=3389
fi

# 显示安装信息确认
echo ""
echo "即将安装的系统如下："
echo "系统版本: $SYS_NAME"
echo "账号: Administrator"
echo "密码: $SYS_PASSWORD"
echo "远程端口: $RDP_PORT"
read -p "请确认无误后按 Enter 开始安装..."

# 执行安装命令
bash reinstall.sh windows \
    --image-name "$SYS_NAME" \
    --iso "$ISO_URL" \
    --password "$SYS_PASSWORD" \
    --rdp-port "$RDP_PORT"

# 安装结果提示并自动重启
if [ $? -eq 0 ]; then
    echo ""
    echo "✅ 初步安装已完毕，10 秒后将自动重启以继续系统安装..."
    sleep 10
    reboot
else
    echo "❌ reinstall.sh 执行失败，请检查上方输出信息排查错误"
    exit 1
fi
