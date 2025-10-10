#include "medicaldataprocessor.h"
#include <QDateTime>
#include <QTimer>
#include <QJsonArray>
#include <QDebug>

MedicalDataProcessor::MedicalDataProcessor(QObject *parent)
    : QObject(parent)
    , m_dbManager(new DatabaseManager(this))
    , m_httpClient(new HttpClient(this))
    , m_isProcessing(false)
    , m_dbConnected(false)
    , m_currentDayIndex(0)
    , m_currentRecordIndex(0)
    , m_totalDays(0)
    , m_currentDay(0)
    , m_totalRecords(0)
    , m_processedRecords(0)
    , m_successCount(0)
    , m_failCount(0)
{
    // 连接HTTP客户端信号
    connect(m_httpClient, &HttpClient::responseReceived,
            this, &MedicalDataProcessor::onHttpResponse);
    connect(m_httpClient, &HttpClient::requestFailed,
            this, &MedicalDataProcessor::onHttpError);

    // 自动连接数据库
    bool connected = m_dbManager->connectToDatabase(
        "220.195.4.143",
        33306,
        "microhis_hsd",
        "root",
        "his@2024"
    );

    setDbConnected(connected);

    if (connected) {
        appendLog("数据库连接成功");
    } else {
        appendLog("数据库连接失败: " + m_dbManager->lastError());
    }
}

MedicalDataProcessor::~MedicalDataProcessor()
{
}

void MedicalDataProcessor::startProcess(const QString &startTime, const QString &endTime)
{
    if (m_isProcessing) {
        appendLog("已有任务正在执行中");
        return;
    }

    if (!m_dbConnected) {
        appendLog("错误: 数据库未连接");
        emit errorOccurred("数据库未连接");
        return;
    }

    // 重置状态
    m_currentDayIndex = 0;
    m_currentRecordIndex = 0;
    m_totalRecords = 0;
    m_processedRecords = 0;
    m_successCount = 0;
    m_failCount = 0;
    m_currentDayRecords.clear();
    m_currentPatientName.clear();
    m_currentIdCertNo.clear();

    // 拆分时间范围
    m_daysList = splitDateRange(startTime, endTime);
    m_totalDays = m_daysList.size();
    m_currentDay = 0;

    emit totalDaysChanged();
    emit currentDayChanged();
    emit totalRecordsChanged();
    emit processedRecordsChanged();
    emit successCountChanged();
    emit failCountChanged();

    if (m_daysList.isEmpty()) {
        appendLog("错误: 时间范围无效");
        emit errorOccurred("时间范围无效");
        return;
    }

    appendLog(QString("===== 开始处理 ====="));
    appendLog(QString("时间范围: %1 到 %2").arg(startTime).arg(endTime));
    appendLog(QString("共 %1 天需要处理").arg(m_totalDays));
    appendLog("");

    setProcessing(true);

    // 开始处理第一天
    processNextDay();
}

void MedicalDataProcessor::stopProcess()
{
    if (!m_isProcessing) {
        return;
    }

    appendLog("");
    appendLog("===== 处理已停止 =====");
    setProgressText("处理已停止");
    setProcessing(false);
}

bool MedicalDataProcessor::testDatabaseConnection()
{
    bool connected = m_dbManager->connectToDatabase(
        "220.195.4.143",
        33306,
        "microhis_hsd",
        "root",
        "his@2024"
    );

    setDbConnected(connected);

    if (connected) {
        appendLog("数据库连接测试成功");
        return true;
    } else {
        appendLog("数据库连接测试失败: " + m_dbManager->lastError());
        return false;
    }
}

void MedicalDataProcessor::clearLog()
{
    m_logText.clear();
    emit logTextChanged();
}

void MedicalDataProcessor::processNextDay()
{
    if (!m_isProcessing) {
        return;
    }

    // 检查是否所有天都处理完成
    if (m_currentDayIndex >= m_daysList.size()) {
        // 全部完成
        appendLog("");
        appendLog("===== 处理完成 =====");
        appendLog(QString("总计处理: %1 天, %2 条记录")
                    .arg(m_totalDays)
                    .arg(m_processedRecords));
        appendLog(QString("成功: %1 条, 失败: %2 条")
                    .arg(m_successCount)
                    .arg(m_failCount));

        setProgressText("处理完成");
        setProcessing(false);
        emit processCompleted();
        return;
    }

    // 获取当前日期
    QString dateStr = m_daysList[m_currentDayIndex];
    QDate date = QDate::fromString(dateStr, "yyyy-MM-dd");

    m_currentDay = m_currentDayIndex + 1;
    emit currentDayChanged();

    setProgressText(QString("正在修正 %1 的数据").arg(dateStr));
    appendLog("");
    appendLog(QString("===== 处理日期: %1 (%2/%3) =====")
                .arg(dateStr)
                .arg(m_currentDay)
                .arg(m_totalDays));

    // 查询该天的记录
    m_currentDayRecords = m_dbManager->queryVisitsByDate(date);

    if (m_currentDayRecords.isEmpty()) {
        appendLog(QString("该日期没有记录，跳过"));

        // 进入下一天
        m_currentDayIndex++;
        QTimer::singleShot(100, this, &MedicalDataProcessor::processNextDay);
        return;
    }

    appendLog(QString("查询到 %1 条记录").arg(m_currentDayRecords.size()));

    // 更新总记录数
    m_totalRecords += m_currentDayRecords.size();
    emit totalRecordsChanged();

    // 重置当天的记录索引
    m_currentRecordIndex = 0;

    // 开始处理第一条记录
    processNextRecord();
}

void MedicalDataProcessor::processNextRecord()
{
    if (!m_isProcessing) {
        return;
    }

    // 检查当天是否处理完成
    if (m_currentRecordIndex >= m_currentDayRecords.size()) {
        // 当天处理完成，进入下一天
        m_currentDayIndex++;
        QTimer::singleShot(100, this, &MedicalDataProcessor::processNextDay);
        return;
    }

    // 获取当前记录
    m_currentRecord = m_currentDayRecords[m_currentRecordIndex];

    // 更新当前患者信息
    m_currentPatientName = m_currentRecord.patientName;
    m_currentIdCertNo = m_currentRecord.idCertNo;
    emit currentPatientNameChanged();
    emit currentIdCertNoChanged();

    // 添加日志
    appendLog(QString("正在处理 %1  %2")
                .arg(m_currentRecord.patientName)
                .arg(m_currentRecord.idCertNo));

    // 发起HTTP请求（异步）
    m_httpClient->getPersonInfo(m_currentRecord.idCertNo, m_currentRecord.patientName);

    // 等待 onHttpResponse 或 onHttpError 回调
}

void MedicalDataProcessor::onHttpResponse(const QJsonObject &response, const QString &idCertNo)
{
    if (!m_isProcessing) {
        return;
    }

    // 提取psn_idet_type
    QString psnIdetType = extractPsnIdetType(response);
    QString memo;

    // 如果提取成功，显示详细信息
    if (!psnIdetType.isEmpty()) {
        // 尝试获取memo
        if (response["code"].toInt() == 0) {
            QJsonArray idetinfo = response["data"].toObject()["idetinfo"].toArray();
            if (!idetinfo.isEmpty()) {
                QJsonObject lastItem = idetinfo.last().toObject();
                memo = lastItem["memo"].toString();
            }
        }
        appendLog(QString("查询结果为 %1 %2").arg(psnIdetType).arg(memo));
    } else {
        appendLog("查询结果为空，设置为NULL");
    }

    appendLog("更新visit数据");

    // 更新数据库
    bool success = m_dbManager->updateVisitSSGroupCode(
        m_currentRecord.visitId,
        psnIdetType.isEmpty() ? QString() : psnIdetType
    );

    if (success) {
        m_successCount++;
        emit successCountChanged();
    } else {
        m_failCount++;
        emit failCountChanged();
        appendLog(QString("更新失败: %1").arg(m_dbManager->lastError()));
    }

    // 更新已处理记录数
    m_processedRecords++;
    emit processedRecordsChanged();

    // 移动到下一条记录
    m_currentRecordIndex++;

    // 延迟处理下一条（避免界面卡顿，也避免接口调用过快）
    QTimer::singleShot(100, this, &MedicalDataProcessor::processNextRecord);
}

void MedicalDataProcessor::onHttpError(const QString &error, const QString &idCertNo)
{
    if (!m_isProcessing) {
        return;
    }

    appendLog(QString("接口调用失败: %1").arg(error));
    appendLog("跳过该记录，继续处理下一条");

    // 网络错误时不更新数据库，直接跳过
    m_failCount++;
    emit failCountChanged();

    m_processedRecords++;
    emit processedRecordsChanged();

    // 移动到下一条记录
    m_currentRecordIndex++;

    // 继续处理下一条
    QTimer::singleShot(100, this, &MedicalDataProcessor::processNextRecord);
}

void MedicalDataProcessor::appendLog(const QString &message)
{
    if (message.isEmpty()) {
        m_logText += "\n";
    } else {
        QString timestamp = QDateTime::currentDateTime().toString("hh:mm:ss");
        m_logText += QString("[%1] %2\n").arg(timestamp).arg(message);
    }

    emit logTextChanged();

    // 同时输出到控制台
    if (!message.isEmpty()) {
        qDebug() << message;
    }
}

void MedicalDataProcessor::setProgressText(const QString &text)
{
    if (m_progressText != text) {
        m_progressText = text;
        emit progressTextChanged();
    }
}

void MedicalDataProcessor::setProcessing(bool processing)
{
    if (m_isProcessing != processing) {
        m_isProcessing = processing;
        emit isProcessingChanged();
    }
}

void MedicalDataProcessor::setDbConnected(bool connected)
{
    if (m_dbConnected != connected) {
        m_dbConnected = connected;
        emit dbConnectedChanged();
    }
}

QStringList MedicalDataProcessor::splitDateRange(const QString &startTime, const QString &endTime)
{
    QStringList days;

    QDateTime start = QDateTime::fromString(startTime, "yyyy-MM-dd hh:mm:ss");
    QDateTime end = QDateTime::fromString(endTime, "yyyy-MM-dd hh:mm:ss");

    if (!start.isValid() || !end.isValid()) {
        qWarning() << "时间格式无效:" << startTime << "到" << endTime;
        return days;
    }

    QDate currentDate = start.date();
    QDate endDate = end.date();

    while (currentDate <= endDate) {
        days.append(currentDate.toString("yyyy-MM-dd"));
        currentDate = currentDate.addDays(1);
    }

    return days;
}

QString MedicalDataProcessor::extractPsnIdetType(const QJsonObject &response)
{
    // 检查code是否为0
    if (response["code"].toInt() != 0) {
        return QString();
    }

    // 检查data对象
    if (!response.contains("data") || !response["data"].isObject()) {
        return QString();
    }

    QJsonObject data = response["data"].toObject();

    // 检查idetinfo数组
    if (!data.contains("idetinfo") || !data["idetinfo"].isArray()) {
        return QString();
    }

    QJsonArray idetinfo = data["idetinfo"].toArray();

    // 检查数组是否为空
    if (idetinfo.isEmpty()) {
        return QString();
    }

    // 获取最后一条
    QJsonObject lastItem = idetinfo.last().toObject();

    // 提取psn_idet_type
    QString psnIdetType = lastItem["psn_idet_type"].toString();

    return psnIdetType;
}

QString MedicalDataProcessor::getQuerySqlTemplate()
{
    return m_dbManager->getQuerySqlTemplate();
}

void MedicalDataProcessor::setQuerySqlTemplate(const QString &sqlTemplate)
{
    m_dbManager->setQuerySqlTemplate(sqlTemplate);
    appendLog("SQL查询模板已更新");
}

QString MedicalDataProcessor::getDefaultQuerySqlTemplate()
{
    return m_dbManager->getDefaultQuerySqlTemplate();
}
