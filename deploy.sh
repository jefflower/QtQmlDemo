#!/bin/bash

# macOS/Linux部署脚本

echo "==================================="
echo "Qt Application Deployment Script"
echo "==================================="
echo

# 检查构建目录
if [ ! -f "build/QtQmlDemo" ]; then
    echo "ERROR: QtQmlDemo not found in build directory"
    echo "Please build the project first:"
    echo "  mkdir build && cd build"
    echo "  cmake .."
    echo "  make"
    exit 1
fi

# 创建部署目录
rm -rf deploy
mkdir -p deploy

# 复制可执行文件
cp build/QtQmlDemo deploy/

# macOS特定部署
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Deploying for macOS..."

    # 查找Qt路径
    QT_DIR=$(qmake -query QT_INSTALL_PREFIX 2>/dev/null)

    if [ -z "$QT_DIR" ]; then
        echo "Qt not found in PATH. Please set QT_DIR environment variable"
        exit 1
    fi

    # 使用macdeployqt（如果可用）
    if command -v macdeployqt &> /dev/null; then
        macdeployqt deploy/QtQmlDemo -qmldir=qml -dmg
        echo "DMG package created"
    else
        echo "macdeployqt not found. Manual deployment required."
    fi
fi

# Linux特定部署
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Deploying for Linux..."

    # 创建AppImage（如果linuxdeployqt可用）
    if command -v linuxdeployqt &> /dev/null; then
        linuxdeployqt deploy/QtQmlDemo -qmldir=qml -appimage
        echo "AppImage created"
    else
        echo "linuxdeployqt not found."
        echo "You can install it from: https://github.com/probonopd/linuxdeployqt"

        # 手动复制必要的Qt库
        echo "Copying Qt libraries manually..."
        ldd build/QtQmlDemo | grep -i qt | awk '{print $3}' | xargs -I {} cp {} deploy/
    fi
fi

echo
echo "==================================="
echo "Deployment Complete!"
echo "==================================="
echo "Deployed files in deploy/"
ls -la deploy/

echo
echo "To run: ./deploy/QtQmlDemo"