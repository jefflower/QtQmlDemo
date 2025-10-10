#ifndef DATABASEMANAGER_H
#define DATABASEMANAGER_H

#include <QObject>
#include <QString>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QDate>
#include <QDateTime>
#include <QList>
#include <QSettings>

// 就诊记录结构
struct VisitRecord {
    int visitId;
    QString patientName;
    QString idCertNo;
    QString ssGroupCode;

    VisitRecord() : visitId(0) {}
    VisitRecord(int id, const QString &name, const QString &certNo, const QString &groupCode)
        : visitId(id), patientName(name), idCertNo(certNo), ssGroupCode(groupCode) {}
};

class DatabaseManager : public QObject
{
    Q_OBJECT

public:
    explicit DatabaseManager(QObject *parent = nullptr);
    ~DatabaseManager();

    // 连接数据库
    bool connectToDatabase(const QString &host, int port, const QString &database,
                          const QString &username, const QString &password);

    // 关闭连接
    void closeConnection();

    // 检查连接状态
    bool isConnected() const;

    // 查询指定日期的就诊记录
    QList<VisitRecord> queryVisitsByDate(const QDate &date);

    // 更新就诊记录的社保分组代码
    bool updateVisitSSGroupCode(int visitId, const QString &groupCode);

    // 获取最后的错误信息
    QString lastError() const;

    // SQL模板管理
    QString getQuerySqlTemplate() const;
    void setQuerySqlTemplate(const QString &sqlTemplate);
    QString getDefaultQuerySqlTemplate() const;

signals:
    void errorOccurred(const QString &error);

private:
    QSqlDatabase m_db;
    QString m_connectionName;
    QString m_lastError;
    QSettings m_settings;

    // 默认SQL模板
    static const QString DEFAULT_QUERY_SQL;
};

#endif // DATABASEMANAGER_H
