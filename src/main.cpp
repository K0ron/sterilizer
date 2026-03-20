#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QTimer>
#include <QDir>
#include <QDebug>

#include "core/sterilizer.h"

int main(int argc, char *argv[])

{
    QGuiApplication app(argc, argv);
    
    qDebug() << "QRC /qml contents:" << QDir(":/qml").entryList();

    Sterilizer sterilizer;
    
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("sterilizer", &sterilizer);

    engine.load(QUrl(QStringLiteral("qrc:/qml/Main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    QTimer tick;
    QObject::connect(&tick, &QTimer::timeout, &sterilizer, &Sterilizer::update);
    tick.start(100);
  
    return app.exec();
}
