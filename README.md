# Farcaster Node

# 安装

```shell
curl -s "https://raw.githubusercontent.com/sigeshuo1/farcaster/main/install.sh" | bash -s \
你的FID \
你的ETH主网RPC地址 \
你的OP主网RPC地址 \
指定内存大小（不指定默认16G）

#示例
curl -s "https://raw.githubusercontent.com/sigeshuo1/farcaster/main/install.sh" | bash -s \
515123 \
https://api.zan.top/node/v1/eth/mainnet/a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6 \
https://api.zan.top/node/v1/opt/mainnet/a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6 \
8
```

# 卸载

```shell
curl -s https://raw.githubusercontent.com/sigeshuo1/farcaster/main/install.sh | bash -s uninstall
```

# 其它命令

```shell
#查看帮助
farcaster help
#升级
farcaster upgrade
#启动
farcaster up
#停止
farcaster down
#查看日志
farcaster logs
```