#ifndef KLOGGR_HPP
#define KLOGGR_HPP

#include <QtWidgets/QtWidgets>
#include <QtQml>

class Kloggr : public QObject {
	Q_OBJECT

	Q_ENUMS(State)

	Q_PROPERTY (int width READ getWidth WRITE setWidth)
	Q_PROPERTY (int height READ getHeight WRITE setHeight)

	Q_PROPERTY(State state READ getState WRITE setState NOTIFY stateChanged)

public:
	enum State {
		Playing, Paused, Dead, MainMenu
	};

	Kloggr();

	// Getters
	int getWidth() const;
	int getHeight() const;
	State getState() const;

	// Setters
	void setWidth(int w);
	void setHeight(int h);
	void setState(State new_state);

private:
	int width;
	int height;
	State state;

signals:
	void stateChanged(State);
};

#endif // KLOGGR_HPP
