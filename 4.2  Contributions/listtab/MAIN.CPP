#include <ui_win.hpp>
#include "mgr.hpp"

WINDOW::WINDOW(int left, int top, int width, int height) :
	UIW_WINDOW(left, top, width, height)
{
	UIW_BUTTON *button = new UIW_BUTTON(42, 2, 12, "Refresh",
			BTF_SEND_MESSAGE | BTF_AUTO_SIZE | BTF_NO_TOGGLE,
			WOF_JUSTIFY_CENTER, ZIL_NULLF(ZIL_USER_FUNCTION), REFRESH);
	button->woAdvancedFlags |= WOAF_NON_CURRENT;

	table = new UIW_TABLE(3, 1, 27, 7);
	*table
		+ new UIW_SCROLL_BAR(0, 0, 0, 0, SBF_CORNER)
		+ new UIW_SCROLL_BAR(0, 0, 0, 0, SBF_VERTICAL)
		+ new UIW_SCROLL_BAR(0, 0, 0, 0, SBF_HORIZONTAL)
		+ new LIST_TABLE_RECORD(277, 7,
			ZIL_NULLF(ZIL_USER_FUNCTION), WOF_MINICELL)
		;
	table->DataSet(ZIL_NULLP(void), 1000, 1000);

	*this
		+ new UIW_BORDER
		+ new UIW_MAXIMIZE_BUTTON
		+ new UIW_MINIMIZE_BUTTON
		+ new UIW_SYSTEM_BUTTON(SYF_GENERIC)
		+ new UIW_TITLE("Window")
		+ table
		+ button
		;

	StringID("LIST_WINDOW");
	windowManager->Center(this);
}

EVENT_TYPE WINDOW::Event(const UI_EVENT &event)
{
	EVENT_TYPE ccode = event.type;
	switch(ccode)
	{
	case REFRESH:
		table->SetCurrent(0);
		break;

	default:
		ccode = UIW_WINDOW::Event(event);
	}
	return (ccode);
}

UI_APPLICATION::Main()
{
	delete windowManager;
	windowManager = new WINDOW_MANAGER(display, eventManager);

	WINDOW *win = new WINDOW(0, 0, 60, 10);

	*windowManager + win;

	Control();

	return (0);
}
