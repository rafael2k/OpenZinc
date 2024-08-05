#include "ui_win.hpp"

const EVENT_TYPE MY_EVENT = 10000;

class BUTTON : public UIW_BUTTON
{
public:
	BUTTON(int left, int top, int width, ZIL_ICHAR *text, 
		BTF_FLAGS btFlags = BTF_NO_TOGGLE | BTF_AUTO_SIZE, 
		WOF_FLAGS woFlags = WOF_JUSTIFY_CENTER,
		ZIL_USER_FUNCTION userFunction = ZIL_NULLF(ZIL_USER_FUNCTION),
		EVENT_TYPE value = 0);
	~BUTTON();
	virtual EVENT_TYPE Event(const UI_EVENT &event);

protected:
	UIW_POP_UP_MENU *menu;
	void CreatePopupMenu(UI_POSITION &mousePos);
};


