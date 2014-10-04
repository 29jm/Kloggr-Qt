#include "Kloggr.hpp"

Kloggr::Kloggr()
	: width(800), height(600), state(MainMenu)
{

}

// Getters
int Kloggr::getWidth() const
{
	return width;
}

int Kloggr::getHeight() const
{
	return height;
}

Kloggr::State Kloggr::getState() const
{
	return state;
}

// Setters
void Kloggr::setWidth(int w)
{
	width = w;
}

void Kloggr::setHeight(int h)
{
	height = h;
}

void Kloggr::setState(State new_state)
{
	state = new_state;
}
