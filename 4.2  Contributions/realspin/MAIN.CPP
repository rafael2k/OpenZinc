#include <ui_win.hpp>
#include "real.hpp"

const EVENT_TYPE MY_EVENT = 10000;

class WINDOW : public UIW_WINDOW
{
public:
	WINDOW();
	virtual ~WINDOW() {}
	virtual EVENT_TYPE Event(const UI_EVENT &event);
};

WINDOW::WINDOW() : UIW_WINDOW(0, 0, 50, 10)
{
	double value = 0.0;
	double delta = 0.01;
	SPINNER_REAL *spinObject = new SPINNER_REAL(0, 0, 0, &value, &delta);
	UIW_SPIN_CONTROL *spinner = new UIW_SPIN_CONTROL(2, 2, 25, spinObject);
	*this
		+ new UIW_BORDER
		+ new UIW_MAXIMIZE_BUTTON
		+ new UIW_MINIMIZE_BUTTON
		+ new UIW_SYSTEM_BUTTON(SYF_GENERIC)
		+ new UIW_TITLE("Window")
		+ spinner
		;

	windowManager->Center(this);
}

EVENT_TYPE WINDOW::Event(const UI_EVENT &event)
{
	EVENT_TYPE ccode = event.type;
	switch(ccode)
	{
	case MY_EVENT:
		break;

	default:
		ccode = UIW_WINDOW::Event(event);
	}
	return (ccode);
}

UI_APPLICATION::Main()
{
	WINDOW *win = new WINDOW;

	*windowManager + win;

	Control();

	return (0);
}
