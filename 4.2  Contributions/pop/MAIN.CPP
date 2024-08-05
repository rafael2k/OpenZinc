#include <ui_win.hpp>
#include <stdio.h>
#include "main.hpp"
#include "button.hpp"

EVENT_TYPE PopupMenuFunction(UI_WINDOW_OBJECT *object, UI_EVENT &, EVENT_TYPE ccode)
{
	if (ccode != L_SELECT)
		return (0);

	EVENT_TYPE value;
	object->Information(I_GET_VALUE, &value);
	object->eventManager->Put(value);

	return (0);
}

WINDOW::WINDOW() : UIW_WINDOW(0, 0, 65, 8)
{
	*this
		+ new UIW_BORDER
		+ new UIW_MAXIMIZE_BUTTON
		+ new UIW_MINIMIZE_BUTTON
		+ new UIW_SYSTEM_BUTTON(SYF_GENERIC)
		+ new UIW_TITLE("Window")
		+ new BUTTON(2, 2, 20, "Click Right Mouse")
		+ new UIW_BUTTON(2, 4, 20, "Button")
		+ &(*new UIW_GROUP(28, 2, 25, 3, "Group", WNF_AUTO_SELECT | WNF_NO_WRAP)
			+ new BUTTON(1, 1, 20, "Click Right Mouse", BTF_RADIO_BUTTON, WOF_NO_FLAGS)
			+ new BUTTON(1, 2, 20, "Click Right Mouse", BTF_RADIO_BUTTON, WOF_NO_FLAGS)
			)
		;

	windowManager->Center(this);
}

WINDOW::~WINDOW()
{
}

void WINDOW::ConvertToOSPosition(UI_WINDOW_OBJECT *object, UI_POSITION &destination)
{
	if (object != object->Root())
	{
#if defined(ZIL_MSWINDOWS)
		POINT pt;
		pt.x = destination.column;
		pt.y = destination.line;
		ClientToScreen(object->parent->screenID, &pt);
		destination.column = pt.x;
		destination.line = pt.y;
#elif defined(ZIL_OS2)
		POINTL ptl;
		ptl.x = destination.column;
		ptl.y = destination.line;
		WinMapWindowPoints(object->parent->screenID, HWND_DESKTOP, &ptl, 1L);
		destination.column = ptl.x;
		destination.line = ptl.y;

		// Take into account the title bar height.
		UI_WINDOW_OBJECT *title = Get("NUMID_TITLE");
		destination.line += title->relative.Height();

		// Take into account the title border width.
		UI_WINDOW_OBJECT *border = Get("NUMID_BORDER");
		destination.column += border->relative.Width();
#elif defined(ZIL_MOTIF)
		for (UI_WINDOW_OBJECT *par = object; par; par = par->parent)
		{
			destination.line += par->relative.top;
			destination.column += par->relative.left;
		}
#endif
	}
#if !defined(ZIL_MSDOS)
	else
	{
		// Take into account the title bar height.
		UI_WINDOW_OBJECT *title = Get("NUMID_TITLE");
		destination.line += title->relative.Height();

		// Take into account the title border width.
		UI_WINDOW_OBJECT *border = Get("NUMID_BORDER");
		destination.column += border->relative.Width();
#if defined(ZIL_MOTIF)
		destination.line += trueRegion.top;
		destination.column += trueRegion.left;
#endif
	}
#endif
}

EVENT_TYPE WINDOW::Event(const UI_EVENT &event)
{
	EVENT_TYPE ccode = event.InputType();
	if (ccode == E_MOUSE)
	{
		// Mouse used.
		if (event.rawCode == (M_RIGHT | M_RIGHT_CHANGE))
		{
			// Right mouse button pressed.
			// Get the position.
			UI_POSITION mousePos = event.position;

			// To account for DOS/MAC being top-down.
			for (UI_WINDOW_OBJECT *obj = First(); obj; obj = obj->Next())
			{
				if (obj->trueRegion.Overlap(mousePos))
				{
					ccode = UIW_WINDOW::Event(event);
					return (ccode);
				}
			}

			// This is only needed for Motif and Macintosh platforms.
			// It is an empty function on other OS's.
			NormalizePosition(this, event, mousePos);
			ConvertToOSPosition(this, mousePos);

			// Create the menu at the mouse position.
			CreatePopupMenu(mousePos);
		}
		else
			ccode = UIW_WINDOW::Event(event);
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
				ccode = UIW_WINDOW::Event(event);
		}
	}
	return (ccode);
}

void WINDOW::CreatePopupMenu(UI_POSITION &mousePos)
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
		+ new UIW_POP_UP_ITEM("All Items beep.")
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

UI_APPLICATION::Main()
{
	WINDOW *win = new WINDOW;

	*windowManager + win;

	Control();

	return(0);
}
