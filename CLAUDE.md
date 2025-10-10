# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

这是一个Qt5/QML演示应用程序，展示C++后端与QML前端的集成。应用程序使用Material Design风格，包含主页和设置页面，演示了属性绑定、信号槽机制和实时数据更新。

**注意**: 尽管README中提到Qt6，但实际使用的是Qt5.15（见CMakeLists.txt:15）。

## 构建系统

### 技术栈
- **Qt版本**: Qt 5.12+ (实际配置为Qt 5.15)
- **构建工具**: CMake 3.16+
- **C++标准**: C++14
- **平台**: macOS, Windows, Linux

### 构建命令

```bash
# 标准构建流程
mkdir -p build && cd build
cmake ..
cmake --build .

# 运行应用程序
./QtQmlDemo  # macOS/Linux
QtQmlDemo.exe  # Windows
```

**Qt Creator用户**: 直接打开`CMakeLists.txt`文件即可配置项目。

## 核心架构

### QML资源加载机制

应用程序支持两种QML加载方式（main.cpp:40-77）：

1. **资源文件模式**（推荐）: 从`qrc:/qml/Main.qml`加载（需编译qml.qrc）
2. **文件系统模式**（开发备用）:
   - `<app_dir>/qml/Main.qml`
   - `<app_dir>/../qml/Main.qml`（开发环境）

**关键**: 如果修改QML文件但未重新编译qml.qrc，运行时可能看不到更改。

### C++/QML集成模式

#### Backend类设计模式
Backend类（src/backend.h）是与QML交互的核心，采用以下模式：

1. **Q_PROPERTY宏**: 将C++属性暴露给QML
   ```cpp
   Q_PROPERTY(QString message READ message WRITE setMessage NOTIFY messageChanged)
   ```

2. **信号槽机制**:
   - QML可调用`Q_INVOKABLE`或`public slots`方法
   - C++通过`signals`通知QML更新

3. **上下文注入**: Backend实例通过`setContextProperty`注入QML（main.cpp:38）
   ```cpp
   engine.rootContext()->setContextProperty("backend", &backend);
   ```

#### 自动更新定时器
Backend在构造函数中启动1秒定时器（backend.cpp:12-14），自动更新时间显示，展示C++主动推送数据到QML的模式。

### QML组件结构

```
Main.qml (ApplicationWindow)
├── header: ToolBar - 顶部工具栏，显示标题和当前时间
├── Drawer - 侧边导航栏
├── SwipeView - 页面容器（支持滑动切换）
│   ├── HomePage.qml - 主功能演示页
│   └── SettingsPage.qml - 设置页
└── footer: TabBar - 底部标签栏
```

**关键绑定**: `SwipeView.currentIndex`与`TabBar.currentIndex`双向同步（Main.qml:83-110）

## 部署说明

### Windows部署
```bash
deploy.bat
```
- 自动调用`windeployqt`打包Qt依赖
- 复制MinGW运行时库
- 手动复制完整QML模块（QtQuick.2, QtQml等）
- 创建Windows 7兼容启动脚本`QtQmlDemo_Win7.bat`

**配置**: 需修改`deploy.bat`中的`QT_DIR`和`MINGW_DIR`路径

### macOS/Linux部署
```bash
./deploy.sh
```
- macOS: 使用`macdeployqt`创建.app包和DMG
- Linux: 使用`linuxdeployqt`创建AppImage

## 常见问题排查

### QML加载失败
如果遇到"Main.qml not found"错误：
1. 检查qml.qrc是否包含所有QML文件
2. 确认CMAKE_AUTORCC已启用（CMakeLists.txt:7）
3. 开发时可将qml文件夹复制到构建目录作为备用

### 资源文件热重载
开发QML时建议：
- 使用文件系统模式加载（修改main.cpp强制使用本地文件）
- 或每次修改后重新编译整个项目

### Material样式缺失
需确保链接`Qt5::QuickControls2`库（CMakeLists.txt:31）并在main.cpp中设置样式（main.cpp:31）。

## 代码规范

### 添加新的C++属性到QML
1. 在backend.h中添加Q_PROPERTY宏
2. 实现getter/setter和signal
3. 在backend.cpp中实现逻辑
4. QML中直接通过`backend.propertyName`访问

### 添加新的QML页面
1. 在qml/目录创建新的.qml文件
2. 更新qml.qrc添加文件引用
3. 在Main.qml的SwipeView中添加页面实例
4. 更新ListModel和TabBar添加导航项

### 调试技巧
- C++端使用`qDebug() << "message"`输出日志
- QML端调用`backend.logMessage()`将日志发送到C++控制台
- 启用QML调试: `export QML_IMPORT_TRACE=1`（查看模块加载）
