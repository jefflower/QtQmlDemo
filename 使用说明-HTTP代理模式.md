# 医保数据处理工具 - HTTP代理模式使用说明

## 问题解决方案

由于macOS上Qt默认不包含MySQL驱动，我们采用了**HTTP代理模式**：

- Qt应用程序 → HTTP → Python代理服务 → MySQL数据库

这种方案的优点：
- ✅ 无需编译Qt MySQL驱动
- ✅ 部署简单快速
- ✅ 易于调试和维护
- ✅ 可以轻松切换到其他数据库

## 快速开始（3步）

### 步骤1: 安装Python依赖

```bash
# 安装Python包（如果尚未安装）
pip3 install flask flask-cors pymysql
```

### 步骤2: 启动数据库代理服务

```bash
# 在一个终端窗口中启动代理服务
python3 database_proxy.py
```

你应该看到类似的输出：
```
==================================================
数据库代理服务启动中...
数据库: 220.195.4.143:33306/microhis_hsd
服务地址: http://localhost:8000
==================================================
✓ 数据库连接测试成功
 * Serving Flask app 'database_proxy'
 * Running on http://0.0.0.0:8000
```

### 步骤3: 运行Qt应用程序

```bash
# 在另一个终端窗口中运行Qt应用
cd build_test
./QtQmlDemo
```

## 详细使用说明

### 1. 启动代理服务

代理服务是一个Python Flask应用，负责处理所有数据库操作。

**配置数据库连接**（如需修改）：

编辑 `database_proxy.py` 文件，修改 `DB_CONFIG` 部分：

```python
DB_CONFIG = {
    'host': '220.195.4.143',      # 数据库地址
    'port': 33306,                # 数据库端口
    'user': 'root',               # 用户名
    'password': 'his@2024',       # 密码
    'database': 'microhis_hsd',   # 数据库名
    'charset': 'utf8mb4'
}
```

### 2. 使用Qt应用

1. 点击"医保处理"标签页
2. 查看数据库连接状态（应显示绿色"已连接"）
3. 输入时间范围
4. 点击"开始执行"

### 3. 查看日志

**代理服务日志**（在运行代理服务的终端）：
```
[INFO] 查询日期 2025-01-15: 找到 25 条记录
[INFO] 127.0.0.1 - - [09/Oct/2025 17:00:00] "POST /query_visits_by_date HTTP/1.1" 200 -
```

**Qt应用日志**（在界面的"执行日志"区域）：
```
[17:00:00] 正在处理 张三 132438195606273439
[17:00:01] 查询结果为 236021 脱贫人口低保对象
[17:00:01] 更新visit数据
```

## API接口说明

代理服务提供以下HTTP接口：

### 1. 测试连接
```
GET http://localhost:8000/test
```

### 2. 查询就诊记录
```
POST http://localhost:8000/query_visits_by_date
Content-Type: application/json

{
  "date": "2025-01-15"
}
```

### 3. 更新社保分组代码
```
POST http://localhost:8000/update_visit_group_code
Content-Type: application/json

{
  "visitId": 12345,
  "groupCode": "236021"  # 可以为null
}
```

### 4. 健康检查
```
GET http://localhost:8000/health
```

## 故障排查

### 问题1: 数据库连接失败

**现象**：代理服务启动时显示"数据库连接测试失败"

**解决方案**：
1. 检查数据库服务器是否可访问：`ping 220.195.4.143`
2. 检查端口是否开放：`telnet 220.195.4.143 33306`
3. 验证用户名和密码是否正确
4. 确认 `hip_mpi.decrypt_data()` 函数存在且有权限

### 问题2: Qt应用显示"未连接"

**现象**：Qt应用界面显示红色"未连接"状态

**解决方案**：
1. 确认代理服务是否正在运行（查看8000端口）
2. 测试代理服务：`curl http://localhost:8000/health`
3. 检查防火墙设置

### 问题3: pip install失败

**现象**：安装Python依赖时报错

**解决方案**：
```bash
# 使用国内镜像源
pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple flask flask-cors pymysql
```

### 问题4: 处理速度慢

**现象**：每条记录处理耗时较长

**调优方案**：
1. 减少延迟时间：编辑 `src/medicaldataprocessor.cpp`，将 `QTimer::singleShot(100, ...)` 改为 `QTimer::singleShot(50, ...)`
2. 增加代理服务worker数（生产环境）：
   ```bash
   gunicorn -w 4 -b 0.0.0.0:8000 database_proxy:app
   ```

## 生产环境部署

### 使用Gunicorn（推荐）

```bash
# 安装gunicorn
pip3 install gunicorn

# 启动服务（4个worker进程）
gunicorn -w 4 -b 0.0.0.0:8000 database_proxy:app
```

### 后台运行

```bash
# 使用nohup后台运行
nohup python3 database_proxy.py > proxy.log 2>&1 &

# 查看进程
ps aux | grep database_proxy

# 停止服务
kill <PID>
```

### 使用systemd（Linux）

创建 `/etc/systemd/system/medical-proxy.service`：

```ini
[Unit]
Description=Medical Database Proxy Service
After=network.target

[Service]
Type=simple
User=your_user
WorkingDirectory=/path/to/QtQmlDemo
ExecStart=/usr/bin/python3 database_proxy.py
Restart=always

[Install]
WantedBy=multi-user.target
```

启动服务：
```bash
sudo systemctl enable medical-proxy
sudo systemctl start medical-proxy
sudo systemctl status medical-proxy
```

## 性能指标

在标准网络环境下的性能参考：

- **每条记录处理时间**: ~200ms
  - 医保接口调用: ~100ms
  - 数据库查询+更新: ~50ms
  - Qt应用延迟: 100ms

- **日处理能力**:
  - 单线程: ~18,000条/小时
  - 4 workers: ~60,000条/小时

## 恢复到直接MySQL连接（可选）

如果将来要使用Qt的原生MySQL驱动，可以恢复原始版本：

```bash
# 恢复原始的DatabaseManager
cp src/databasemanager_direct.cpp.bak src/databasemanager.cpp

# 重新编译
cd build_test && make
```

## 架构图

```
┌──────────────────┐
│   Qt Application │
│   (QtQmlDemo)    │
└────────┬─────────┘
         │ HTTP (localhost:8000)
         │
┌────────▼─────────┐
│  Python Proxy    │
│  (Flask Server)  │
└────────┬─────────┘
         │ MySQL Protocol
         │
┌────────▼─────────┐
│  MySQL Database  │
│  220.195.4.143   │
└──────────────────┘
```

## 技术支持

如遇到问题：

1. 查看代理服务日志
2. 查看Qt应用控制台输出
3. 使用curl测试API接口
4. 检查网络连接和防火墙设置

## 文件清单

- `database_proxy.py` - Python数据库代理服务
- `src/databasemanager.cpp` - HTTP版本的数据库管理器
- `src/databasemanager_direct.cpp.bak` - 原始MySQL直连版本（备份）
- `build-mysql-plugin.sh` - MySQL插件编译脚本（备用方案）

---

**最后更新**: 2025-10-09
