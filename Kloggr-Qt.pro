TEMPLATE = app

QT += qml quick widgets svg

CONFIG += console

SOURCES += main.cpp

RESOURCES += qml.qrc \
	translations.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS +=

DISTFILES += \
	android/AndroidManifest.xml \
	android/res/values/libs.xml \
	android/build.gradle \
	android/res/drawable-hdpi/icon.png \
	android/res/drawable-mdpi/icon.png \
	android/res/drawable-xhdpi/icon.png \
	android/res/drawable-xxhdpi/icon.png \
	android/res/drawable-xxxhdpi/icon.png

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
