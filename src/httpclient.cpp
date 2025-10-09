#include "httpclient.h"
#include <QNetworkRequest>
#include <QJsonArray>
#include <QDateTime>
#include <QDebug>

HttpClient::HttpClient(QObject *parent)
    : QObject(parent)
    , m_manager(new QNetworkAccessManager(this))
    , m_apiUrl("http://127.0.0.1:5000/api/mi/GetPersonInfo")
{
}

HttpClient::~HttpClient()
{
}

void HttpClient::setApiUrl(const QString &url)
{
    m_apiUrl = url;
}

void HttpClient::getPersonInfo(const QString &idCertNo, const QString &patientName)
{
    m_currentIdCertNo = idCertNo;

    // 构建请求
    QNetworkRequest request;
    request.setUrl(QUrl(m_apiUrl));
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    // 构建请求体
    QJsonObject requestBody = buildRequestBody(idCertNo);
    QJsonDocument doc(requestBody);
    QByteArray data = doc.toJson(QJsonDocument::Compact);

    // 发送POST请求
    QNetworkReply *reply = m_manager->post(request, data);

    // 连接信号
    connect(reply, &QNetworkReply::finished, this, &HttpClient::onReplyFinished);

    qDebug() << "发送HTTP请求:" << m_apiUrl;
    qDebug() << "身份证号:" << idCertNo;
}

void HttpClient::onReplyFinished()
{
    QNetworkReply *reply = qobject_cast<QNetworkReply*>(sender());
    if (!reply) {
        return;
    }

    QString idCertNo = m_currentIdCertNo;

    // 检查网络错误
    if (reply->error() != QNetworkReply::NoError) {
        QString errorMsg = QString("网络错误: %1").arg(reply->errorString());
        qWarning() << errorMsg;
        emit requestFailed(errorMsg, idCertNo);
        reply->deleteLater();
        return;
    }

    // 读取响应数据
    QByteArray responseData = reply->readAll();
    reply->deleteLater();

    // 解析JSON
    QJsonParseError parseError;
    QJsonDocument doc = QJsonDocument::fromJson(responseData, &parseError);

    if (parseError.error != QJsonParseError::NoError) {
        QString errorMsg = QString("JSON解析错误: %1").arg(parseError.errorString());
        qWarning() << errorMsg;
        qWarning() << "响应数据:" << responseData;
        emit requestFailed(errorMsg, idCertNo);
        return;
    }

    if (!doc.isObject()) {
        QString errorMsg = "响应数据不是JSON对象";
        qWarning() << errorMsg;
        emit requestFailed(errorMsg, idCertNo);
        return;
    }

    QJsonObject responseObj = doc.object();

    // 发送成功信号（即使code不为0，也交给业务层处理）
    emit responseReceived(responseObj, idCertNo);

    qDebug() << "接收到HTTP响应，身份证:" << idCertNo;
}

QJsonObject HttpClient::buildRequestBody(const QString &idCertNo)
{
    // 构建card_info对象
    QJsonObject cardInfo;
    cardInfo["mdtrt_cert_type"] = "02";
    cardInfo["mdtrt_cert_no"] = idCertNo;
    cardInfo["psn_cert_type"] = "01";
    cardInfo["certno"] = idCertNo;
    cardInfo["psn_cert_no"] = idCertNo;
    cardInfo["card_sn"] = QJsonValue::Null;
    cardInfo["psn_name"] = "";
    cardInfo["age"] = "46";
    cardInfo["birthday"] = 19790125;
    cardInfo["gender"] = "1";
    cardInfo["nation"] = QJsonValue::Null;
    cardInfo["address"] = QJsonValue::Null;
    cardInfo["insuplc_admdvs"] = QJsonValue::Null;
    cardInfo["read_time"] = QDateTime::currentDateTime().toString(Qt::ISODateWithMs);
    cardInfo["extra_props"] = QJsonValue::Null;

    // 构建主请求体
    QJsonObject requestBody;
    requestBody["card_info"] = cardInfo;
    requestBody["business_type_id"] = "104";
    requestBody["medical_type"] = 11;
    requestBody["mdtrt_cert_type"] = "01";
    requestBody["psn_name"] = "";
    requestBody["psn_cert_no"] = idCertNo;
    requestBody["mdtrt_cert_no"] = idCertNo;
    requestBody["card_sn"] = "";
    requestBody["insuplc_admdvs"] = "";
    requestBody["opter"] = 0;
    requestBody["org_id"] = 130624002;
    requestBody["user_id"] = 0;

    return requestBody;
}
