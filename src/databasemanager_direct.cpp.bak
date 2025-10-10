#include "databasemanager.h"
#include <QDebug>
#include <QUuid>

DatabaseManager::DatabaseManager(QObject *parent)
    : QObject(parent)
{
    // 生成唯一的连接名
    m_connectionName = QUuid::createUuid().toString();
}

DatabaseManager::~DatabaseManager()
{
    closeConnection();
}

bool DatabaseManager::connectToDatabase(const QString &host, int port, const QString &database,
                                       const QString &username, const QString &password)
{
    // 如果已经存在连接，先关闭
    if (m_db.isOpen()) {
        closeConnection();
    }

    // 创建数据库连接
    m_db = QSqlDatabase::addDatabase("QMYSQL", m_connectionName);
    m_db.setHostName(host);
    m_db.setPort(port);
    m_db.setDatabaseName(database);
    m_db.setUserName(username);
    m_db.setPassword(password);

    // 尝试打开连接
    if (!m_db.open()) {
        m_lastError = QString("数据库连接失败: %1").arg(m_db.lastError().text());
        qCritical() << m_lastError;
        emit errorOccurred(m_lastError);
        return false;
    }

    qDebug() << "数据库连接成功:" << host << ":" << port << "/" << database;
    return true;
}

void DatabaseManager::closeConnection()
{
    if (m_db.isOpen()) {
        m_db.close();
        qDebug() << "数据库连接已关闭";
    }

    if (QSqlDatabase::contains(m_connectionName)) {
        QSqlDatabase::removeDatabase(m_connectionName);
    }
}

bool DatabaseManager::isConnected() const
{
    return m_db.isOpen();
}

QList<VisitRecord> DatabaseManager::queryVisitsByDate(const QDate &date)
{
    QList<VisitRecord> records;

    if (!m_db.isOpen()) {
        m_lastError = "数据库未连接";
        qCritical() << m_lastError;
        emit errorOccurred(m_lastError);
        return records;
    }

    // 构造SQL查询
    QString sql = R"(
        SELECT t_visit.Visit_ID,
               t_visit.Patient_Name,
               hip_mpi.decrypt_data(t_visit_extra.IDCert_No) as IDCert_No,
               t_visit.SS_Group_Code
        FROM microhis_hsd.t_visit
        INNER JOIN microhis_hsd.t_visit_extra ON t_visit.Visit_ID = t_visit_extra.Visit_ID
        WHERE TIME_Admission >= ? AND TIME_Admission < ?
    )";

    QSqlQuery query(m_db);
    query.prepare(sql);

    // 设置查询参数（当天的开始和结束时间）
    QString startTime = date.toString("yyyy-MM-dd") + " 00:00:00";
    QString endTime = date.addDays(1).toString("yyyy-MM-dd") + " 00:00:00";

    query.addBindValue(startTime);
    query.addBindValue(endTime);

    // 执行查询
    if (!query.exec()) {
        m_lastError = QString("查询失败: %1").arg(query.lastError().text());
        qCritical() << m_lastError;
        qCritical() << "SQL:" << sql;
        qCritical() << "参数:" << startTime << "到" << endTime;
        emit errorOccurred(m_lastError);
        return records;
    }

    // 提取结果
    while (query.next()) {
        VisitRecord record;
        record.visitId = query.value(0).toInt();
        record.patientName = query.value(1).toString();
        record.idCertNo = query.value(2).toString();
        record.ssGroupCode = query.value(3).toString();
        records.append(record);
    }

    qDebug() << QString("查询到 %1 条记录 (日期: %2)")
                .arg(records.size())
                .arg(date.toString("yyyy-MM-dd"));

    return records;
}

bool DatabaseManager::updateVisitSSGroupCode(int visitId, const QString &groupCode)
{
    if (!m_db.isOpen()) {
        m_lastError = "数据库未连接";
        qCritical() << m_lastError;
        emit errorOccurred(m_lastError);
        return false;
    }

    QString sql = "UPDATE microhis_hsd.t_visit SET SS_Group_Code = ? WHERE Visit_ID = ?";

    QSqlQuery query(m_db);
    query.prepare(sql);

    // 如果groupCode为空，设置为NULL
    if (groupCode.isEmpty()) {
        query.addBindValue(QVariant(QVariant::String));
    } else {
        query.addBindValue(groupCode);
    }
    query.addBindValue(visitId);

    if (!query.exec()) {
        m_lastError = QString("更新失败: %1").arg(query.lastError().text());
        qCritical() << m_lastError;
        qCritical() << "SQL:" << sql;
        qCritical() << "参数: visitId=" << visitId << ", groupCode=" << groupCode;
        emit errorOccurred(m_lastError);
        return false;
    }

    return true;
}

QString DatabaseManager::lastError() const
{
    return m_lastError;
}
