#!/bin/bash

# 检查是否为纯 IPv6 环境（无 IPv4）
echo "🔍 正在检查是否为纯 IPv6 网络..."
IPV4_CHECK=$(ip -4 addr | grep inet | grep -v "127.0.0.1")

if [ -z "$IPV4_CHECK" ]; then
    echo "🌐 检测结果：您的服务器为纯 IPv6 环境"
    echo "为确保后续正常联网，请先为该机器添加 IPv4 网络"
    echo ""
    read -p "👉 按下 Enter 开始安装 WARP 以添加 IPv4 网络（跳转至 WARP脚本）..." _

    echo ""
    echo -e "\033[1;32m✅ 即将进入 WARP 安装脚本，请按如下顺序手动操作：\033[0m"
    echo -e "\033[1;36m👉 选择 2（使用Warp服务(全局)）→ 2（中文语言）→ 2（非全局）→ 1（免费账户）→ 2（IPv6优先）\033[0m"
    echo ""

    # 安装 curl
    if ! command -v curl > /dev/null 2>&1; then
        echo "🔧 未检测到 curl，尝试自动安装..."
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
            centos|rhel|rocky|almalinux)
                yum install -y curl && INSTALL_SUCCESS=true
                ;;
            alpine)
                apk add curl && INSTALL_SUCCESS=true
                ;;
            arch)
                pacman -Sy --noconfirm curl && INSTALL_SUCCESS=true
                ;;
            *)
                if command -v apt >/dev/null; then apt update && apt install -y curl && INSTALL_SUCCESS=true; fi
                if command -v yum >/dev/null && [ "$INSTALL_SUCCESS" = false ]; then yum install -y curl && INSTALL_SUCCESS=true; fi
                if command -v apk >/dev/null && [ "$INSTALL_SUCCESS" = false ]; then apk add curl && INSTALL_SUCCESS=true; fi
                if command -v pacman >/dev/null && [ "$INSTALL_SUCCESS" = false ]; then pacman -Sy --noconfirm curl && INSTALL_SUCCESS=true; fi
                ;;
        esac

        if [ "$INSTALL_SUCCESS" = false ]; then
            echo "❌ 无法安装 curl，请手动安装后重试"
            exit 1
        fi
    else
        echo "✅ curl 已安装"
    fi

    # 执行 WARP 脚本
    bash <(curl -Ls https://raw.githubusercontent.com/Lynn-Becky/v6_only/main/v4.sh) || {
        echo "❌ 无法下载或执行 WARP 脚本，退出"
        exit 1
    }

    echo ""
    echo "✅ WARP 脚本已退出，等待 5 秒后重新检测网络状态..."
    sleep 5
fi

# 判断网络环境
echo "正在检测网络状态..."
ping -c 2 -W 2 google.com > /dev/null 2>&1
if [ $? -eq 0 ]; then
    LOCATION="foreign"
    echo "✅ 网络通畅，判定为国外机器"
else
    LOCATION="china"
    echo "⚠️ 无法连接 Google，判定为国内机器"
fi

# 检测 curl
if ! command -v curl > /dev/null 2>&1; then
    echo "❌ curl 未安装"
    exit 1
fi

# 下载 reinstall.sh
echo "正在下载 reinstall.sh..."
if [ "$LOCATION" = "foreign" ]; then
    curl -O https://raw.githubusercontent.com/bin456789/reinstall/main/reinstall.sh || \
    wget -O reinstall.sh https://raw.githubusercontent.com/bin456789/reinstall/main/reinstall.sh
else
    curl -O https://cnb.cool/bin456789/reinstall/-/git/raw/main/reinstall.sh || \
    wget -O reinstall.sh https://cnb.cool/bin456789/reinstall/-/git/raw/main/reinstall.sh
fi

chmod +x reinstall.sh

# 系统选择
echo ""
echo "请选择需要安装的系统："
echo "1. Windows Server 2012"
echo "2. Windows Server 2016"
echo "3. Windows Server 2019"
echo "4. Windows Server 2022(对接Cloudflare R2高速下载+正式版系统)"
echo "5. Windows Server 2025"
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
       ISO_URL="https://wsinstall.079idc.net/zh-cn_windows_server_2022_updated_sep_2024_x64_dvd_cab4e960.iso"
       ;;
    5) SYS_NAME="Windows Server 2025 SERVERSTANDARD"
       ISO_URL="https://software-static.download.prss.microsoft.com/dbazure/998969d5-f34g-4e03-ac9d-1f9786c66749/26100.32230.260111-0550.lt_release_svc_refresh_SERVER_EVAL_x64FRE_zh-cn.iso"
       ;;
    *)
       echo "❌ 无效选项"
       exit 1
       ;;
esac

# 密码输入（为空自动生成）
read -s -p "请输入系统密码（留空自动生成）: " SYS_PASSWORD
echo ""

if [ -z "$SYS_PASSWORD" ]; then
    echo "⚠️ 未输入密码，正在自动生成强密码..."

    RANDOM_UPPER=$(tr -dc 'A-Z' < /dev/urandom | head -c 2)
    RANDOM_LOWER=$(tr -dc 'a-z' < /dev/urandom | head -c 2)
    RANDOM_NUM=$(tr -dc '0-9' < /dev/urandom | head -c 2)
    RANDOM_SPECIAL=$(tr -dc '!@#$%^&*()_+=' < /dev/urandom | head -c 2)

    SYS_PASSWORD="${RANDOM_UPPER}${RANDOM_LOWER}${RANDOM_NUM}${RANDOM_SPECIAL}"
    SYS_PASSWORD=$(echo "$SYS_PASSWORD" | fold -w1 | shuf | tr -d '\n')

    echo ""
    echo "✅ 自动生成密码: $SYS_PASSWORD"
else
    echo "✅ 使用用户输入密码"
fi

# RDP端口
read -p "请输入远程桌面端口号（默认3389）: " RDP_PORT
if [ -z "$RDP_PORT" ]; then
    RDP_PORT=3389
fi

echo ""
echo "========七九网络-自助系统重装服务========"
echo "即将安装系统："
echo "系统版本: $SYS_NAME"
echo "账号: Administrator"
echo "密码: $SYS_PASSWORD"
echo "远程端口: $RDP_PORT"
echo "======省心更省力:)尽在079idc.net======="
read -p "确认无误按 Enter 开始安装..." _

# 执行安装
bash reinstall.sh windows \
    --image-name "$SYS_NAME" \
    --iso "$ISO_URL" \
    --password "$SYS_PASSWORD" \
    --rdp-port "$RDP_PORT"

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ 初步安装完成，10 秒后重启..."
    sleep 10
    reboot
else
    echo "❌ 安装失败"
    exit 1
fi
