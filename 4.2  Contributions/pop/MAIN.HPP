#include "ui_win.hpp"

class WINDOW : public UIW_WINDOW
{
public:
	WINDOW();
	~WINDOW();
	virtual EVENT_TYPE Event(const UI_EVENT &event);
	void ConvertToOSPosition(UI_WINDOW_OBJECT *object, UI_POSITION &destination);

protected:
	UIW_POP_UP_MENU *menu;
	void CreatePopupMenu(UI_POSITION &mousePos);
};
