#!/bin/bash

# 部署精简版 Docker 镜像脚本（适用于 Zeabur 部署）
# 使用方法: ./deploy-lite.sh [镜像名称] [标签]
# 示例: ./deploy-lite.sh myusername/web-admin latest
# 注意: 构建完成后会自动推送到 Docker Registry

set -e

# 默认镜像名称和标签
IMAGE_NAME="${1:-web-admin}"
TAG="${2:-latest}"

# 颜色输出
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  构建并推送 Docker 镜像（Zeabur 部署）${NC}"
echo -e "${BLUE}========================================${NC}"
echo -e "镜像名称: ${GREEN}${IMAGE_NAME}${NC}"
echo -e "标签: ${GREEN}${TAG}${NC}"
echo -e "平台: ${GREEN}linux/amd64${NC} (Zeabur 兼容)"
echo ""

# 检查 Dockerfile.lite 是否存在
if [ ! -f "Dockerfile.lite" ]; then
    echo -e "${RED}错误: Dockerfile.lite 不存在${NC}"
    exit 1
fi

# 检查是否已登录 Docker
if ! docker info | grep -q "Username"; then
    echo -e "${YELLOW}提示: 请先登录 Docker Hub${NC}"
    echo -e "${YELLOW}运行: docker login${NC}"
    echo ""
    read -p "是否现在登录? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        docker login
    else
        echo -e "${RED}取消构建${NC}"
        exit 1
    fi
fi

# 构建镜像（指定 linux/amd64 平台，适合 Zeabur）
echo -e "${BLUE}开始构建 Docker 镜像（linux/amd64）...${NC}"
echo -e "${YELLOW}注意: 在 Mac 上构建 Linux 镜像，可能需要一些时间${NC}"
echo ""

docker build -f Dockerfile.lite \
    --platform linux/amd64 \
    -t "${IMAGE_NAME}:${TAG}" \
    -t "${IMAGE_NAME}:latest" \
    .

echo ""
echo -e "${GREEN}✓ 镜像构建完成！${NC}"

# 自动推送到 registry
echo ""
echo -e "${BLUE}推送到 Docker Registry...${NC}"
docker push "${IMAGE_NAME}:${TAG}"
docker push "${IMAGE_NAME}:latest"
echo -e "${GREEN}✓ 镜像推送完成！${NC}"

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Zeabur 部署说明${NC}"
echo -e "${BLUE}========================================${NC}"
echo -e "1. 在 Zeabur 中创建新服务"
echo -e "2. 选择 Docker 镜像"
echo -e "3. 输入镜像地址: ${GREEN}${IMAGE_NAME}:${TAG}${NC}"
echo -e "   或使用: ${GREEN}${IMAGE_NAME}:latest${NC}"
echo -e "4. 配置端口: ${GREEN}2053${NC}"
echo -e "5. 配置环境变量（如需要）"
echo ""
echo -e "${GREEN}部署完成！${NC}"

