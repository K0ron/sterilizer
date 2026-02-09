#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QTimer>
#include <QDir>
#include <QDebug>

#include "core/sterilizer.h"

int main(int argc, char *argv[])

{
    qDebug() << "QRC /qml contents:" << QDir(":/qml").entryList();
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    Sterilizer sterilizer;
    engine.rootContext()->setContextProperty("sterilizer", &sterilizer);

    QTimer tick;
    QObject::connect(&tick, &QTimer::timeout, &sterilizer, &Sterilizer::update);
    tick.start(100);

    engine.load(QUrl(QStringLiteral("qrc:/qml/Main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
