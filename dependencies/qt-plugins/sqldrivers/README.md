# Qt MySQL Plugin (qsqlmysql.dll)

## 📥 需要文件

请下载 **qsqlmysql.dll** 并放置在此目录中。

## 什么是 qsqlmysql.dll

这是Qt的MySQL数据库驱动插件，允许Qt应用程序通过Qt SQL模块连接MySQL数据库。

## 📦 文件信息

- **文件名**: qsqlmysql.dll
- **Qt版本**: 5.15.2
- **编译器**: MinGW 8.1 64-bit
- **架构**: x64 (64位)
- **大小**: 约 30-50 KB
- **用途**: Qt SQL MySQL驱动插件

## 🔍 如何获取

### 方法一：从Qt官方安装包（推荐）

**如果您已安装Qt 5.15.2 MinGW 64位：**

1. 找到Qt安装目录，通常在：
   ```
   C:\Qt\5.15.2\mingw81_64\plugins\sqldrivers\qsqlmysql.dll
   ```

2. 复制该文件到此目录

**如果没有安装Qt：**

1. 下载Qt在线安装器：
   - https://www.qt.io/download-qt-installer

2. 运行安装器，选择：
   - Qt 5.15.2
   - MinGW 8.1.0 64-bit

3. 安装完成后，从上述路径复制文件

### 方法二：从已编译的程序包提取

如果您有其他使用Qt 5.15.2 MinGW 64位编译的程序：

1. 在其程序目录中查找 `sqldrivers\qsqlmysql.dll`
2. 复制到此目录

### 方法三：在线搜索（谨慎）

搜索关键词：
```
qsqlmysql.dll qt 5.15.2 mingw81_64 download
```

⚠️ **警告**：从非官方来源下载DLL文件存在安全风险，请确保来源可信。

## ⚠️ 重要提示

- **必须使用 Qt 5.15.2 MinGW 8.1 64位版本**
- 不要使用其他Qt版本的插件（如5.14、5.16等）
- 不要使用MSVC版本的插件
- 不要使用32位版本

## ✅ 验证

确保此目录包含以下文件：
```
dependencies/qt-plugins/sqldrivers/
├── qsqlmysql.dll     ← 必需文件
└── README.md         ← 本说明文件
```

## 🚀 提交到仓库

获取文件后：

```bash
cd /path/to/QtQmlDemo
git add dependencies/qt-plugins/sqldrivers/qsqlmysql.dll
git commit -m "build: 添加Qt MySQL驱动插件 qsqlmysql.dll"
git push
```

## 📞 获取帮助

如果无法获取此文件，请在GitHub提issue，提供：
- 您的操作系统版本
- 是否已安装Qt
- Qt安装路径（如果有）
