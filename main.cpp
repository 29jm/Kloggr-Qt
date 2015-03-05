#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQml>

int main(int argc, char *argv[])
{
	QGuiApplication app(argc, argv);
	app.setOrganizationName("Creahoof");
	app.setOrganizationDomain("Kloggr");
	app.setApplicationName("Kloggr");

	QQmlApplicationEngine engine;
	engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

	return app.exec();
}
