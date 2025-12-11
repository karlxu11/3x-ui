#!/bin/bash
# modify-3x-ui.sh

echo "=== 开始修改3x-ui源码 ==="

# 备份原始代码
cp -r . ../3x-ui-backup

# 替换所有标识字符串
echo ">>> 替换标识字符串..."
find . -type f \( -name "*.go" -o -name "*.json" -o -name "*.yaml" -o -name "*.md" -o -name "*.js" -o -name "*.vue" -o -name "*.html" \) ! -path "./.git/*" -exec sed -i \
    -e 's/x-ui/sys-bot/g' \
    -e 's/X-UI/SYS-BOT/g' \
    -e 's/xray/sys-kernel-service/g' \
    -e 's/Xray/SYS-KERNEL-SERVICE/g' \
    -e 's/v2ray/sys-network-daemon/g' \
    -e 's/V2Ray/SYS-NETWORK-DAEMON/g' \
    -e 's/trojan/sys-security-module/g' \
    -e 's/Trojan/SYS-SECURITY-MODULE/g' \
    {} + 2>/dev/null || true

# 替换文件路径
echo ">>> 替换文件路径..."
find . -type f \( -name "*.go" -o -name "*.json" \) ! -path "./.git/*" -exec sed -i \
    -e 's|bin/xray|bin/sys-kernel-service|g' \
    -e 's|/usr/local/x-ui|/usr/local/sys-bot|g' \
    -e 's|/etc/x-ui|/etc/sys-bot|g' \
    -e 's|xray-linux-amd64|sys-kernel-service|g' \
    {} + 2>/dev/null || true

# 修改包名和导入路径（需要谨慎）
echo ">>> 修改包结构..."
if [ -f "go.mod" ]; then
    sed -i 's|module github.com/MHSanaei/3x-ui|module github.com/你的用户名/sys-bot|g' go.mod
    # 修改导入路径
    find . -name "*.go" -type f -exec sed -i 's|github.com/MHSanaei/3x-ui|github.com/你的用户名/sys-bot|g' {} +
fi

echo ">>> 验证修改..."
grep -r "sys-bot" . --include="*.go" | head -5
grep -r "sys-kernel-service" . --include="*.go" | head -5

echo "=== 3x-ui修改完成 ==="
