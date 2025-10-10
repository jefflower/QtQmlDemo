#!/bin/bash
# 实时查看代理服务日志

echo "正在监控代理服务日志..."
echo "================================"
echo ""

# 查找Python进程
PID=$(ps aux | grep "database_proxy.py" | grep -v grep | awk '{print $2}')

if [ -z "$PID" ]; then
    echo "错误: 代理服务未运行"
    echo "请先启动代理服务: python3 database_proxy.py"
    exit 1
fi

echo "代理服务进程ID: $PID"
echo "按 Ctrl+C 停止监控"
echo "================================"
echo ""

# 持续监控日志（从当前时间开始）
tail -f /dev/null &
TAIL_PID=$!

# 监控进程输出
while true; do
    sleep 1
done

# 清理
trap "kill $TAIL_PID 2>/dev/null; exit" INT TERM
