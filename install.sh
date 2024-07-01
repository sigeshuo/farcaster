#!/usr/bin/env bash

HUBBLE_HOME="${HOME}/hubble"
HUBBLE_ENV_FILE_PATH="${HUBBLE_HOME}/.env"
HUBBLE_FILE_PATH="${HUBBLE_HOME}/hubble.sh"
FARCASTER_COMMAND_FILE_PATH="/usr/local/bin/farcaster"
HUB_OPERATOR_FID="$1"
ETH_MAINNET_RPC_URL="$2"
OPTIMISM_L2_RPC_URL="$3"
MEM_RESERVATION="$4"

function __tips() {
    echo "------------------------------------------------------------------------------"
    echo "📢 Farcaster 简易安装脚本由 X 用户 @sigeshuo 提供，该安装脚本开源免费，请勿相信付费！"
    echo "🔗 币圈工具导航：https://www.sigeshuo.com"
    echo "💬 我的 X：https://x.com/@sigeshuo"
    echo "🌐 我的 Linkree：https://linktr.ee/sigeshuo"
    echo "👥 Telegram 社区群：https://t.me/sigeshuo_group"
    echo "------------------------------------------------------------------------------"
}

function __uninstall() {
    if [ "$HUB_OPERATOR_FID" != "uninstall" ]; then
      return 1
    fi

    if command -v farcaster >/dev/null 2>&1; then
        echo "🔍 检查到 ${FARCASTER_COMMAND_FILE_PATH} 命令！"
        echo "🛑 停止 Hubble ..."
        farcaster down
        echo "🗑️ 删除 ${FARCASTER_COMMAND_FILE_PATH} 命令！"
        rm -rf "$FARCASTER_COMMAND_FILE_PATH"
    fi

    if [ -d "${HUBBLE_HOME}" ]; then
      echo "🗑️ 删除 ${HUBBLE_HOME} 目录！"
      rm -rf "${HUBBLE_HOME}"
    fi

    echo "✅ 卸载已完成！"
    exit 1
}

function __help() {
    echo "✨ 后续命令用法："
    echo "⬆️ 升级：farcaster upgrade"
    echo "📜 查看日志：farcaster logs"
    echo "🚀 启动 Hubble 和 Grafana 面板：farcaster up"
    echo "🛑 停止 Hubble 和 Grafana 面板：farcaster down"
    echo "❓ 查看帮助：farcaster help"
    echo "🌐 打开 Grafana 面板：http://localhost:3000"
    echo "🗑️ 卸载安装：curl -s https://raw.githubusercontent.com/sigeshuo1/farcaster/main/install.sh | bash -s uninstall"

    for ((i=10; i>0; i--)); do
      echo "🎉 安装成功，安装程序将在 $i 秒后结束！"
      sleep 1
    done
}

function __env() {
    echo "⏳ 正在进行环境检查 ..."

    if [[ "$(id -u)" -ne 0 ]]; then
        echo "❌ 安装需要以 root 用户权限运行!"
        echo "❌ 请尝试使用 'sudo -i' 命令切换到root用户，再次运行安装命令！"
        exit 1
    fi

    if [[ ! -d "${HUBBLE_HOME}" ]]; then
      echo "⏳ 目录 ${HUBBLE_HOME} 不存在，正在创建 ..."
      mkdir -p "${HUBBLE_HOME}"
      chmod 777 "${HUBBLE_HOME}"
    fi

    if [[ -z "$HUB_OPERATOR_FID" ]]; then
        echo "❌ 您未指定 Warpcast ID，您可以在此链接处查看：https://warpcast.com/你的用户名"
        exit 1
    fi

    if [[ -z "$ETH_MAINNET_RPC_URL" ]]; then
        echo "❌ 您未指定 ETH 主网 RPC 地址，您可以在此链接处查看：https://zan.top/"
        exit 1
    fi

    if [[ -z "$OPTIMISM_L2_RPC_URL" ]]; then
        echo "❌ 您未指定 Optimism L2 RPC 地址，您可以在此链接处查看：https://zan.top/"
        exit 1
    fi

    if [[ -z "$MEM_RESERVATION" ]]; then
        MEM_RESERVATION=16
        echo "⚠️ 您未指定 MEM_RESERVATION 内存大小，默认已为您设置：${MEM_RESERVATION}GB"
        exit 1
    fi

    if [[ -f "${HUBBLE_ENV_FILE_PATH}" ]]; then
       echo "⏳ 检查到环境配置文件：${HUBBLE_ENV_FILE_PATH}，正在删除 ..."
       rm -rf "${HUBBLE_ENV_FILE_PATH}"
    fi

    echo "HUB_OPERATOR_FID=${HUB_OPERATOR_FID}" >> "${HUBBLE_ENV_FILE_PATH}"
    echo "ETH_MAINNET_RPC_URL=${ETH_MAINNET_RPC_URL}" >> "${HUBBLE_ENV_FILE_PATH}"
    echo "OPTIMISM_L2_RPC_URL=${OPTIMISM_L2_RPC_URL}" >> "${HUBBLE_ENV_FILE_PATH}"
    echo "MEM_RESERVATION=${MEM_RESERVATION}" >> "${HUBBLE_ENV_FILE_PATH}"

    echo "-------------------------------- 您的配置信息 --------------------------------"
    echo "Warpcast FID：${HUB_OPERATOR_FID}"
    echo "ETH 主网 RPC 地址：${ETH_MAINNET_RPC_URL}"
    echo "Optimism L2 RPC 地址：${OPTIMISM_L2_RPC_URL}"
    echo "MEM_RESERVATION 内存大小：${MEM_RESERVATION}GB"
    echo "------------------------------------ End -----------------------------------"
}

function __create_farcaster_command() {
if [ -L "${FARCASTER_COMMAND_FILE_PATH}" ]; then
  echo "🗑️ 命令 ${FARCASTER_COMMAND_FILE_PATH} 存在，正在删除..."
  rm -rf "${FARCASTER_COMMAND_FILE_PATH}"
fi
cat > ${FARCASTER_COMMAND_FILE_PATH} <<EOF
#!/usr/bin/env bash
cd ${HUBBLE_HOME}
./hubble.sh \$1
EOF

echo "✅ ${FARCASTER_COMMAND_FILE_PATH} 命令创建成功！"

chmod +x ${FARCASTER_COMMAND_FILE_PATH}
}

function __download_hubble() {
    echo "⏳ 正在下载 hubble 脚本文件 ..."
#    curl -s -o "${HUBBLE_FILE_PATH}" "https://raw.githubusercontent.com/sigeshuo1/hub-monorepo/@latest/scripts/hubble.sh?timestamp=$(date +%s)"
    curl -s -o "${HUBBLE_FILE_PATH}" "https://raw.githubusercontent.com/sigeshuo1/hub-monorepo/@latest/scripts/hubble.sh?timestamp=$(date +%s)"
    if [ $? -eq 0 ]; then
      echo "✅ 文件已成功下载到 ${HUBBLE_FILE_PATH}！"
      chmod +x "${HUBBLE_FILE_PATH}"
      __create_farcaster_command
    else
      echo "❌ 文件下载失败！"
      exit 1
    fi
}

function __launching() {
      echo "🚀 启动节点 ..."
      farcaster upgrade
}

function __main() {
    __uninstall
    __tips
    __env
    __download_hubble
    __launching
    __help
}

__main