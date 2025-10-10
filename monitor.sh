#!/bin/bash
# 医保数据处理监控脚本

clear
echo "======================================"
echo "   医保数据处理实时监控"
echo "======================================"
echo ""

# 检查代理服务状态
echo "📡 代理服务状态:"
PID=$(ps aux | grep "database_proxy.py" | grep -v grep | awk '{print $2}')
if [ -z "$PID" ]; then
    echo "   ❌ 未运行"
else
    echo "   ✅ 运行中 (PID: $PID)"

    # 显示最近的处理记录
    echo ""
    echo "📊 最近处理的记录:"
    echo "--------------------------------------"

    # 使用curl查询健康状态
    HEALTH=$(curl -s http://localhost:8000/health 2>/dev/null)
    if [ $? -eq 0 ]; then
        echo "   代理服务健康: ✅"
    else
        echo "   代理服务异常: ❌"
    fi
fi

echo ""
echo "======================================"
echo "💡 使用提示:"
echo "   - Qt应用日志显示在界面的'执行日志'区域"
echo "   - 代理服务日志可通过此脚本查看"
echo "   - 如果界面日志不显示，请检查控制台输出"
echo "======================================"
echo ""

# 显示当前处理进度
echo "🔄 查询当前状态..."
echo ""

# 这里可以添加更多监控逻辑
echo "按任意键退出..."
read -n 1
