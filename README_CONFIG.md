# Qt QML Demo - 医保数据批量处理工具

## 📋 目录
1. [项目概述](#项目概述)
2. [系统要求](#系统要求)
3. [GitHub Actions 编译](#github-actions-编译)
4. [本地开发和编译](#本地开发和编译)
5. [使用说明](#使用说明)
6. [常见问题](#常见问题)

## 项目概述

这是一个基于Qt 5.15和QML的医保数据批量处理工具，主要功能包括：
- 直接连接MySQL数据库（使用Qt SQL模块）
- 批量查询和处理医保就诊记录
- 调用医保接口获取人员信息
- 更新数据库记录

## 系统要求

- Windows 7/10/11 或 macOS 10.14+ 或 Linux
- MySQL客户端库（libmysqlclient）
- 无需Python环境

## GitHub Actions 编译

### Windows可执行程序

项目配置了GitHub Actions自动编译Windows版本，每次push到main分支时自动触发。

**编译环境：**
- Windows Server 2022
- Qt 5.15.2 with MinGW 8.1
- 包含所有必要的DLL和MySQL驱动

**下载编译产物：**
1. 进入项目的GitHub仓库
2. 点击"Actions"标签
3. 选择最新的successful workflow run
4. 下载"QtQmlDemo-Win7-Build-XXX"压缩包
5. 解压到任意目录即可使用

**Windows 7兼容性：**
- 包含`QtQmlDemo_Win7.bat`启动脚本
- 使用软件渲染模式，兼容Windows 7系统

## 本地开发和编译

### macOS

```bash
# 安装依赖
brew install qt@5 mysql-client

# 配置环境变量
export Qt5_DIR=/opt/homebrew/opt/qt@5/lib/cmake/Qt5

# 创建build目录
mkdir -p build && cd build

# 配置CMake
cmake .. -DCMAKE_BUILD_TYPE=Release

# 编译
cmake --build . -j4

# 运行
./QtQmlDemo
```

### Linux

```bash
# 安装Qt5和MySQL客户端
sudo apt-get install qt5-default qtdeclarative5-dev \
    qml-module-qtquick-controls2 qml-module-qtquick-layouts \
    libqt5sql5-mysql libmysqlclient-dev

# 编译
mkdir -p build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
cmake --build . -j4

# 运行
./QtQmlDemo
```

### Windows (MinGW)

```cmd
rem 设置Qt路径
set Qt5_DIR=C:\Qt\5.15.2\mingw81_64
set PATH=%Qt5_DIR%\bin;C:\Qt\Tools\mingw810_64\bin;%PATH%

rem 编译
mkdir build
cd build
cmake .. -G "MinGW Makefiles" -DCMAKE_BUILD_TYPE=Release
mingw32-make -j4

rem 运行
QtQmlDemo.exe
```

## 使用说明

### 启动应用程序

**Windows:**
```bash
QtQmlDemo.exe
# 或使用Windows 7兼容模式
QtQmlDemo_Win7.bat
```

**macOS/Linux:**
```bash
./QtQmlDemo
```

### 配置数据库连接

应用程序会直接连接到MySQL数据库：
- 主机: 220.195.4.143
- 端口: 33306
- 数据库: microhis_hsd

### 处理数据

1. 切换到"医保处理"页面
2. 设置时间范围（默认为上个月）
3. 点击"开始执行"开始批量处理
4. 查看实时进度和日志

## 常见问题

### 1. Windows上缺少DLL

**现象：** 启动时提示缺少Qt5XXX.dll或MySQL相关DLL

**解决方案：**
- 使用GitHub Actions编译的完整包，包含所有必需DLL
- 或使用windeployqt工具：
  ```cmd
  windeployqt --qmldir qml --quick QtQmlDemo.exe
  ```

### 2. 数据库连接失败

**现象：** 显示"数据库未连接"或连接错误

**可能原因：**
1. MySQL服务器不可访问
2. 网络防火墙阻止连接
3. 数据库凭证错误
4. 缺少MySQL客户端库

**解决方案：**
1. 检查MySQL服务器是否运行
2. 验证网络连接和防火墙设置
3. 确认数据库用户名和密码
4. 确保安装了MySQL客户端库（libmysqlclient）

### 3. 缺少MySQL驱动

**现象：** 启动时提示"QMYSQL driver not loaded"

**解决方案：**

**Windows:**
- 确保libmysql.dll在程序目录或系统PATH中
- 检查Qt插件目录下有qsqlmysql.dll

**Linux:**
```bash
sudo apt-get install libqt5sql5-mysql
```

**macOS:**
```bash
brew install mysql-client
# 可能需要创建符号链接
ln -s /opt/homebrew/opt/mysql-client/lib/libmysqlclient.dylib /usr/local/lib/
```

## 技术架构

```
┌─────────────────┐
│   Qt QML UI     │  (用户界面)
└────────┬────────┘
         │ Qt SQL
         ↓
┌─────────────────┐
│ DatabaseManager │  (数据访问层)
│   (Qt C++)      │  - QSqlDatabase
└────────┬────────┘  - QSqlQuery
         │ MySQL Protocol
         ↓
┌─────────────────┐
│  MySQL Database │  (数据库)
└─────────────────┘
```

## 更新日志

### v2.0.0 (2025-10-09)
- ✅ **移除Python依赖** - 使用Qt SQL模块直接连接MySQL
- ✅ **简化部署** - 无需安装Python环境和依赖包
- ✅ **提升性能** - 直接数据库连接，减少HTTP开销
- ✅ **移除代理设置** - 不再需要配置代理服务

### v1.2.0 (2025-10-09)
- ✅ 代理设置移到医保处理页面
- ✅ 自动重启功能
- ✅ database_proxy.py支持命令行参数

### v1.1.0 (2025-01-09)
- ✅ 添加可配置的代理服务端口
- ✅ 新增Settings页面配置区域

### v1.0.0 (2025-01-08)
- 🎉 初始版本发布

## 许可证

[MIT License]

## 联系方式

如有问题或建议，请在GitHub提issue。
