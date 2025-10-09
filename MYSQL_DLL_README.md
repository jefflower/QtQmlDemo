# MySQL DLL 下载说明

## Windows环境MySQL驱动文件

在Windows上运行Qt QML Demo需要以下MySQL相关文件：

### 1. libmysql.dll - MySQL客户端库

**从仓库获取（推荐）：**
- GitHub Actions会直接使用仓库中的 `dependencies/mysql/libmysql.dll`
- 编译后的Windows包已包含此文件
- 如果您是首次设置，需要将DLL添加到仓库（见下方）

**手动下载地址：**

**方式一：MySQL Connector/C 6.1.11 (推荐，兼容Windows 7)**
- 官方下载页面: https://dev.mysql.com/downloads/connector/c/
- 直接下载链接: https://dev.mysql.com/get/Downloads/Connector-C/mysql-connector-c-6.1.11-winx64.zip
- 下载后解压，找到 `lib/libmysql.dll`
- 将 `libmysql.dll` 复制到程序目录

**方式二：MariaDB Connector/C (备选)**
- 官方下载页面: https://mariadb.com/downloads/connectors/connectors-data-access/c-connector/
- 下载对应架构的安装包
- 安装后找到 `libmariadb.dll`（可重命名为libmysql.dll）

**如何将DLL添加到仓库：**
1. 下载上述任一版本的MySQL客户端库
2. 解压后找到 `lib/libmysql.dll` (约1-2MB)
3. 复制到项目的 `dependencies/mysql/` 目录
4. 提交到git仓库：
   ```bash
   git add dependencies/mysql/libmysql.dll
   git commit -m "build: 添加MySQL客户端库 libmysql.dll"
   git push
   ```
5. GitHub Actions会自动使用此文件进行编译

### 2. qsqlmysql.dll - Qt MySQL插件

**位置：**
- 已包含在Qt 5.15.2安装中
- 路径: `Qt\5.15.2\mingw81_64\plugins\sqldrivers\qsqlmysql.dll`
- GitHub Actions会自动复制到 `deploy\sqldrivers\` 目录

**如果缺失：**
- 下载完整的Qt 5.15.2 MinGW版本
- 或使用Qt Maintenance Tool安装SQL模块

## 文件结构

部署后的文件结构应该是：

```
QtQmlDemo/
├── QtQmlDemo.exe
├── libmysql.dll           ← MySQL客户端库
├── Qt5Core.dll
├── Qt5Gui.dll
├── Qt5Sql.dll            ← Qt SQL模块
├── Qt5Network.dll
├── ...其他Qt DLL
└── sqldrivers/
    └── qsqlmysql.dll      ← Qt MySQL驱动插件
```

## 验证安装

运行程序后：
1. 如果显示"Driver not loaded"，说明缺少 `libmysql.dll` 或 `qsqlmysql.dll`
2. 检查上述两个文件是否在正确位置
3. 确保文件版本与Qt版本匹配（64位对应64位）

## 常见问题

### Q: 提示"libmysql.dll not found"
A: 下载MySQL Connector/C，将libmysql.dll放到程序目录

### Q: 提示"QMYSQL driver not loaded"
A:
1. 检查 `sqldrivers\qsqlmysql.dll` 是否存在
2. 确保 `libmysql.dll` 在程序目录或系统PATH中

### Q: 应该下载32位还是64位？
A: 使用64位版本（winx64），匹配Qt 5.15.2 mingw81_64

## 备用下载源

如果官方下载较慢，可以尝试：

**MySQL Connector/C 6.1.11:**
- 镜像站: https://downloads.mysql.com/archives/c-c/
- 选择版本: 6.1.11
- 操作系统: Microsoft Windows
- 架构: Windows (x86, 64-bit)

## 技术支持

遇到问题请在GitHub提issue，并提供：
- 错误信息截图
- 程序目录文件列表
- Windows版本信息
