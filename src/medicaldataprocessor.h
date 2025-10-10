#ifndef MEDICALDATAPROCESSOR_H
#define MEDICALDATAPROCESSOR_H

#include <QObject>
#include <QString>
#include <QStringList>
#include <QList>
#include <QDate>
#include "databasemanager.h"
#include "httpclient.h"

class MedicalDataProcessor : public QObject
{
    Q_OBJECT

    // QML可访问的属性
    Q_PROPERTY(QString progressText READ progressText NOTIFY progressTextChanged)
    Q_PROPERTY(QString logText READ logText NOTIFY logTextChanged)
    Q_PROPERTY(bool isProcessing READ isProcessing NOTIFY isProcessingChanged)
    Q_PROPERTY(bool dbConnected READ dbConnected NOTIFY dbConnectedChanged)

    Q_PROPERTY(int totalDays READ totalDays NOTIFY totalDaysChanged)
    Q_PROPERTY(int currentDay READ currentDay NOTIFY currentDayChanged)
    Q_PROPERTY(int totalRecords READ totalRecords NOTIFY totalRecordsChanged)
    Q_PROPERTY(int processedRecords READ processedRecords NOTIFY processedRecordsChanged)
    Q_PROPERTY(int successCount READ successCount NOTIFY successCountChanged)
    Q_PROPERTY(int failCount READ failCount NOTIFY failCountChanged)

    Q_PROPERTY(QString currentPatientName READ currentPatientName NOTIFY currentPatientNameChanged)
    Q_PROPERTY(QString currentIdCertNo READ currentIdCertNo NOTIFY currentIdCertNoChanged)

public:
    explicit MedicalDataProcessor(QObject *parent = nullptr);
    ~MedicalDataProcessor();

    // 属性getter
    QString progressText() const { return m_progressText; }
    QString logText() const { return m_logText; }
    bool isProcessing() const { return m_isProcessing; }
    bool dbConnected() const { return m_dbConnected; }

    int totalDays() const { return m_totalDays; }
    int currentDay() const { return m_currentDay; }
    int totalRecords() const { return m_totalRecords; }
    int processedRecords() const { return m_processedRecords; }
    int successCount() const { return m_successCount; }
    int failCount() const { return m_failCount; }

    QString currentPatientName() const { return m_currentPatientName; }
    QString currentIdCertNo() const { return m_currentIdCertNo; }

    // QML可调用的方法
    Q_INVOKABLE void startProcess(const QString &startTime, const QString &endTime);
    Q_INVOKABLE void stopProcess();
    Q_INVOKABLE bool testDatabaseConnection();
    Q_INVOKABLE void clearLog();

    // SQL模板配置
    Q_INVOKABLE QString getQuerySqlTemplate();
    Q_INVOKABLE void setQuerySqlTemplate(const QString &sqlTemplate);
    Q_INVOKABLE QString getDefaultQuerySqlTemplate();

signals:
    void progressTextChanged();
    void logTextChanged();
    void isProcessingChanged();
    void dbConnectedChanged();

    void totalDaysChanged();
    void currentDayChanged();
    void totalRecordsChanged();
    void processedRecordsChanged();
    void successCountChanged();
    void failCountChanged();

    void currentPatientNameChanged();
    void currentIdCertNoChanged();

    void processCompleted();
    void errorOccurred(const QString &error);

private slots:
    // 内部槽函数
    void processNextDay();
    void processNextRecord();
    void onHttpResponse(const QJsonObject &response, const QString &idCertNo);
    void onHttpError(const QString &error, const QString &idCertNo);

private:
    // 辅助方法
    void appendLog(const QString &message);
    void setProgressText(const QString &text);
    void setProcessing(bool processing);
    void setDbConnected(bool connected);

    QStringList splitDateRange(const QString &startTime, const QString &endTime);
    QString extractPsnIdetType(const QJsonObject &response);

    // 成员变量
    DatabaseManager *m_dbManager;
    HttpClient *m_httpClient;

    QString m_progressText;
    QString m_logText;
    bool m_isProcessing;
    bool m_dbConnected;

    // 处理状态
    QStringList m_daysList;
    QList<VisitRecord> m_currentDayRecords;
    int m_currentDayIndex;
    int m_currentRecordIndex;

    // 统计信息
    int m_totalDays;
    int m_currentDay;
    int m_totalRecords;
    int m_processedRecords;
    int m_successCount;
    int m_failCount;

    // 当前处理的患者信息
    QString m_currentPatientName;
    QString m_currentIdCertNo;

    // 当前处理的记录（用于回调时识别）
    VisitRecord m_currentRecord;
};

#endif // MEDICALDATAPROCESSOR_H
