#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQml>

#include "Kloggr.hpp"

int main(int argc, char *argv[])
{
	QGuiApplication app(argc, argv);

	qmlRegisterType<Kloggr>("Kloggr", 1, 0, "Kloggr");

	QQmlApplicationEngine engine;
	engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

	return app.exec();
}
