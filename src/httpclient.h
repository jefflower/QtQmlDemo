#ifndef HTTPCLIENT_H
#define HTTPCLIENT_H

#include <QObject>
#include <QString>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonObject>
#include <QJsonDocument>

class HttpClient : public QObject
{
    Q_OBJECT

public:
    explicit HttpClient(QObject *parent = nullptr);
    ~HttpClient();

    // 设置API URL
    void setApiUrl(const QString &url);

    // 获取人员信息
    void getPersonInfo(const QString &idCertNo, const QString &patientName = "");

signals:
    // 响应成功
    void responseReceived(const QJsonObject &response, const QString &idCertNo);

    // 请求失败
    void requestFailed(const QString &error, const QString &idCertNo);

private slots:
    void onReplyFinished();

private:
    QNetworkAccessManager *m_manager;
    QString m_apiUrl;
    QString m_currentIdCertNo;  // 当前请求的身份证号，用于回调时识别

    // 构建请求体
    QJsonObject buildRequestBody(const QString &idCertNo);
};

#endif // HTTPCLIENT_H
