#include <ui_win.hpp>

class WINDOW : public UIW_WINDOW
{
public:
	WINDOW();
};

WINDOW::WINDOW() : UIW_WINDOW("p_main.dat~WINDOW")
{
	windowManager->Center(this);
}

UI_APPLICATION::Main()
{
   WINDOW *win = new WINDOW;

	*windowManager	+ win;

	Control();

	return(0);
}
