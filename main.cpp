#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include <QTranslator>
#include <QLocale>

int main(int argc, char *argv[])
{
	QGuiApplication app(argc, argv);
	app.setOrganizationName("Creahoof");
	app.setOrganizationDomain("Kloggr");
	app.setApplicationName("Kloggr");

	QString locale = QLocale::system().name();
	QTranslator translator;

	if (translator.load(locale, ":/translations")) {
		app.installTranslator(&translator);
	}

	QQmlApplicationEngine engine;
	engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

	return app.exec();
}
