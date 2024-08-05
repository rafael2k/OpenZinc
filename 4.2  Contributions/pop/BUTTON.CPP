#include <ui_win.hpp>
#include "main.hpp"
#include "button.hpp"

extern EVENT_TYPE PopupMenuFunction(UI_WINDOW_OBJECT *, UI_EVENT &, EVENT_TYPE);

BUTTON::BUTTON(int left, int top, int width, ZIL_ICHAR *text, 
		BTF_FLAGS btFlags, WOF_FLAGS woFlags,
		ZIL_USER_FUNCTION userFunction, EVENT_TYPE value) :
	UIW_BUTTON(left, top, width, text, btFlags, woFlags, userFunction, value)
{
}

BUTTON::~BUTTON()
{
}

EVENT_TYPE BUTTON::Event(const UI_EVENT &event)
{
	EVENT_TYPE ccode = event.InputType();
	if (ccode == E_MOUSE)
	{
		// Mouse used.
		if (event.rawCode == (M_RIGHT | M_RIGHT_CHANGE))
		{	// Right mouse button pressed.
			// Get the position.
			UI_POSITION mousePos = event.position;

			// Convert the relative coordinates to screen.
			WINDOW *parentWin = (WINDOW *)Root();
			parentWin->ConvertToOSPosition(this, mousePos);

			// Create the menu at the mouse position.
			CreatePopupMenu(mousePos);
		}
		else
			ccode = UIW_BUTTON::Event(event);
	}
	else 
	{
		// Normal switch statement.
		ccode = event.type;
		switch(ccode)
		{
			case MY_EVENT:
				// Event from clicking in the menu.
				UI_ERROR_SYSTEM::Beep();

				// Subtract the menu from the window manager.
				*windowManager - menu;

				// Delete the menu explicitly because the no-destroy
				// flag is set.
				delete menu;
				break;

			default:
				ccode = UIW_BUTTON::Event(event);
		}
	}
	return (ccode);
}

void BUTTON::CreatePopupMenu(UI_POSITION &mousePos)
{
	int left = mousePos.column;
	int top = mousePos.line;

	// The temporary flag allows the window manager to remove 
	// the menu but I need to destroy it so the no-destroy flag
	// is set.  Both of these flags need to be used when using
	// the pop-up-menu attached to a window manager.
	menu = new UIW_POP_UP_MENU(left, top, WNF_CONTINUE_SELECT,
		WOF_BORDER | WOF_PIXEL, WOAF_TEMPORARY | WOAF_NO_DESTROY);
	*menu
		+ new UIW_POP_UP_ITEM("Button Popup Menu.")
		+ new UIW_POP_UP_ITEM("", MNIF_SEPARATOR)
		+ new UIW_POP_UP_ITEM("Send Event", MNIF_SEND_MESSAGE, 
			BTF_SEND_MESSAGE | BTF_NO_3D, WOF_NO_FLAGS, ZIL_NULLF(ZIL_USER_FUNCTION), MY_EVENT)
		+ new UIW_POP_UP_ITEM("Send Event", MNIF_SEND_MESSAGE, 
			BTF_SEND_MESSAGE | BTF_NO_3D, WOF_NO_FLAGS, ZIL_NULLF(ZIL_USER_FUNCTION), MY_EVENT)

		+ &(*new UIW_POP_UP_ITEM("More Options", MNIF_NO_FLAGS, 
			BTF_NO_3D, WOF_NO_FLAGS, ZIL_NULLF(ZIL_USER_FUNCTION))
			+ new UIW_POP_UP_ITEM("Call Function", MNIF_NO_FLAGS, 
				BTF_NO_3D, WOF_NO_FLAGS, PopupMenuFunction, MY_EVENT)
			+ new UIW_POP_UP_ITEM("Call Function", MNIF_NO_FLAGS, 
				BTF_NO_3D, WOF_NO_FLAGS, PopupMenuFunction, MY_EVENT)
			)
		;

	*windowManager + menu;
}


