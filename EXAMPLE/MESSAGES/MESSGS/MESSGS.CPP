//  MESSGS.CPP (MESSGS) - User defined message handling.
//	COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//  Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//  May be freely copied, used and distributed.

#include <string.h>
#include <ui_win.hpp>
#include "messgs.hpp"

MY_WINDOW::MY_WINDOW(int left, int top, int width, int height, ZIL_ICHAR *name) :
	UIW_WINDOW(left, top, width, height)
{
	*this
		+ new UIW_BORDER
		+ new UIW_MAXIMIZE_BUTTON
		+ new UIW_MINIMIZE_BUTTON
		+ new UIW_SYSTEM_BUTTON(SYF_GENERIC)
  		+ new UIW_TITLE(name);
}

// Event function for MY_WINDOW that understands U_SET event.
EVENT_TYPE MY_WINDOW::Event(const UI_EVENT &event)
{
	EVENT_TYPE ccode = event.type;

	if (event.type == U_SET)
	{
		((UI_WINDOW_OBJECT *)userObject)->Information(I_SET_TEXT, event.data, ID_BUTTON);
		delete event.data;

		// Leave message to redisplay button after setting its text.
		((UI_WINDOW_OBJECT *)userObject)->Event(UI_EVENT(S_REDISPLAY));
	}
	else
		ccode = UIW_WINDOW::Event(event);

	return (ccode);
}

EVENT_TYPE LeaveMessage(UI_WINDOW_OBJECT *object, UI_EVENT &event, EVENT_TYPE ccode)
{
	if (ccode != L_SELECT)
		return (ccode);

	// Leave a message to close current window;
	event.type = S_CLOSE;
	object->eventManager->Put(event);

	// Leave a User Defined message for current object to DataSet itself.
	event.type = U_SET;
	event.data = object->strdup((ZIL_ICHAR *)object->Information(I_GET_TEXT, ZIL_NULLP(void), ID_BUTTON));
	object->eventManager->Put(event);

	return (ccode);
}

// User Function for buttons that will receive message.
EVENT_TYPE UserFunction(UI_WINDOW_OBJECT *object, UI_EVENT &, EVENT_TYPE ccode)
{
	if (ccode != L_SELECT)
		return (ccode);

	object->parent->userObject = object;

	// Create a list of buttons with possible entries in them.
	UIW_VT_LIST *list = new UIW_VT_LIST(0, 0, 0, 0, ZIL_NULLF(ZIL_COMPARE_FUNCTION),
		WNF_NO_WRAP | WNF_CONTINUE_SELECT, WOF_NON_FIELD_REGION);
	*list
		+ new UIW_BUTTON(0, 0, 10, "Option 1", BTF_NO_3D | BTF_NO_TOGGLE, WOF_JUSTIFY_CENTER, LeaveMessage)
		+ new UIW_BUTTON(0, 0, 10, "Option 2", BTF_NO_3D | BTF_NO_TOGGLE, WOF_JUSTIFY_CENTER, LeaveMessage)
		+ new UIW_BUTTON(0, 0, 10, "Option 3", BTF_NO_3D | BTF_NO_TOGGLE, WOF_JUSTIFY_CENTER, LeaveMessage)
		+ new UIW_BUTTON(0, 0, 10, "Option 4", BTF_NO_3D | BTF_NO_TOGGLE, WOF_JUSTIFY_CENTER, LeaveMessage)
		+ new UIW_BUTTON(0, 0, 10, "Option 5", BTF_NO_3D | BTF_NO_TOGGLE, WOF_JUSTIFY_CENTER, LeaveMessage)
		+ new UIW_BUTTON(0, 0, 10, "Option 6", BTF_NO_3D | BTF_NO_TOGGLE, WOF_JUSTIFY_CENTER, LeaveMessage)
		+ new UIW_BUTTON(0, 0, 10, "Option 7", BTF_NO_3D | BTF_NO_TOGGLE, WOF_JUSTIFY_CENTER, LeaveMessage)
		+ new UIW_BUTTON(0, 0, 10, "Option 8", BTF_NO_3D | BTF_NO_TOGGLE, WOF_JUSTIFY_CENTER, LeaveMessage)
		+ new UIW_BUTTON(0, 0, 10, "Option 9", BTF_NO_3D | BTF_NO_TOGGLE, WOF_JUSTIFY_CENTER, LeaveMessage)
		+ new UIW_BUTTON(0, 0, 10, "Option 10", BTF_NO_3D | BTF_NO_TOGGLE, WOF_JUSTIFY_CENTER, LeaveMessage);

	// Create a window with the list.
	UIW_WINDOW *window = new UIW_WINDOW(40, 5, 20, 14, WOF_NO_FLAGS,
		WOAF_NO_MOVE | WOAF_NO_SIZE | WOAF_MODAL);
	*window
		+ new UIW_BORDER
		+ new UIW_TITLE("Options")
		+ list;

	// Add the window to the window manager.
	*object->windowManager + window;

	return (ccode);
}

int UI_APPLICATION::Main(void)
{
	// The UI_APPLICATION constructor automatically initializes the
	// display, eventManager, and windowManager variables.

	// This line fixes linkers that don't look for main in the .LIBs.
	UI_APPLICATION::LinkMain();

	MY_WINDOW *mainWindow = new MY_WINDOW(5, 5, 22, 6, "Main");
	*mainWindow
		+ new UIW_BUTTON(1, 1, 18, "Press Me", BTF_NO_TOGGLE, WOF_JUSTIFY_CENTER, UserFunction)
		+ new UIW_BUTTON(1, 3, 18, "Press Me Too", BTF_NO_TOGGLE, WOF_JUSTIFY_CENTER, UserFunction);

	*windowManager
		+ mainWindow;

	// Process user responses.
	UI_APPLICATION::Control();

	return (0);
}
