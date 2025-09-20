# Qt QML Demo Application

一个展示Qt6与QML集成的示例应用程序，演示了C++后端与QML前端的交互。

## 功能特点

- **C++/QML集成**: 展示如何在QML中使用C++对象和信号槽
- **Material Design**: 使用Qt Quick Controls 2的Material主题
- **响应式界面**: 包含导航抽屉、标签页和滑动视图
- **实时数据绑定**: C++属性与QML界面的双向绑定
- **主题切换**: 支持亮色、暗色和系统主题
- **计数器演示**: 展示数据状态管理
- **文本处理**: 演示C++函数调用和信号发送

## 项目结构

```
QtQmlDemo/
├── CMakeLists.txt       # CMake构建配置
├── src/
│   ├── main.cpp        # 程序入口
│   ├── backend.h       # C++后端类头文件
│   └── backend.cpp     # C++后端类实现
├── qml/
│   ├── Main.qml        # 主窗口
│   ├── HomePage.qml    # 主页面
│   └── SettingsPage.qml # 设置页面
└── resources/
    └── logo.png        # 应用图标
```

## 构建要求

- Qt 6.2或更高版本
- CMake 3.16或更高版本
- C++17编译器

## 编译和运行

### 使用CMake

```bash
cd QtQmlDemo
mkdir build && cd build
cmake ..
cmake --build .
./QtQmlDemo
```

### 使用Qt Creator

1. 打开Qt Creator
2. 选择"文件" -> "打开文件或项目"
3. 选择`CMakeLists.txt`文件
4. 配置项目并运行

## 主要组件说明

### Backend类
- 提供QML可访问的属性和方法
- 管理应用程序的业务逻辑
- 发送信号通知QML界面更新

### QML界面
- **Main.qml**: 应用程序主窗口，包含导航结构
- **HomePage.qml**: 展示主要功能演示
- **SettingsPage.qml**: 提供主题和设置选项

## 许可证

MIT License