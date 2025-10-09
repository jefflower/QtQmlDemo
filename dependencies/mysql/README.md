# MySQL Client Library

## 📥 需要文件

请下载 **libmysql.dll** 并放置在此目录中。

## 下载地址

### 方式一：MySQL官方（推荐）

**MySQL Connector/C 6.1.11 (兼容Windows 7)**

- **官方下载页面**: https://dev.mysql.com/downloads/connector/c/
  - 选择版本: 6.1.11
  - 操作系统: Microsoft Windows
  - 架构: Windows (x86, 64-bit)

- **直接下载链接**:
  ```
  https://dev.mysql.com/get/Downloads/Connector-C/mysql-connector-c-6.1.11-winx64.zip
  ```

- **备用归档链接**:
  ```
  https://downloads.mysql.com/archives/get/p/19/file/mysql-connector-c-6.1.11-winx64.zip
  ```

### 方式二：MariaDB（备选）

如果MySQL官网无法访问，可以使用MariaDB的客户端库：

- **MariaDB Connector/C**: https://mariadb.com/downloads/connectors/connectors-data-access/c-connector/
  - 下载后文件名为 `libmariadb.dll`
  - 可重命名为 `libmysql.dll` 使用

## 📦 安装步骤

1. 下载上述链接中的zip文件
2. 解压压缩包
3. 在解压后的文件夹中找到 `lib/libmysql.dll`
4. 将 `libmysql.dll` 复制到此目录（`dependencies/mysql/`）
5. 提交到git仓库

## ✅ 验证

确保此目录包含以下文件：
```
dependencies/mysql/
├── libmysql.dll      ← 必需文件
└── README.md         ← 本说明文件
```

## 🔍 文件信息

- **文件名**: libmysql.dll
- **版本**: 6.1.11 (推荐)
- **架构**: x64 (64位)
- **大小**: 约 1-2 MB
- **用途**: MySQL客户端连接库

## ⚠️ 重要提示

- 必须使用 **64位版本** (winx64)，匹配Qt 5.15.2 mingw81_64
- 不要使用32位版本 (win32)
- 如果GitHub Actions编译失败，检查此文件是否存在

## 📞 获取帮助

如果下载遇到问题，请在GitHub提issue。
