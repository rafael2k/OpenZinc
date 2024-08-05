//	WINDOW.CPP (ZINCAPP) - This file contains the "Window" options.
//	COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//  May be freely copied, used and distributed.

#include <ui_win.hpp>

#include "zincapp.hpp"

void CONTROL_WINDOW::OptionWindow(EVENT_TYPE item)
{
	// Get the specified window.
	UI_WINDOW_OBJECT *object = ZIL_NULLP(UI_WINDOW_OBJECT);
	switch(item)
	{
#if defined(ZIL_NEXTSTEP)
	case MSG_DATE_WINDOW:
		object = new UIW_WINDOW("support.dat~WINDOW_DATE");
		break;

	case MSG_GENERIC_WINDOW:
		object = new UIW_WINDOW("support.dat~WINDOW_GENERIC");
		break;

	case MSG_ICON_WINDOW:
		object = new UIW_WINDOW("support.dat~WINDOW_ICON");
		break;

	case MSG_LIST_WINDOW:
		object = new UIW_WINDOW("support.dat~WINDOW_LIST");
		break;

	case MSG_COMBO_BOX_WINDOW:
		object = new UIW_WINDOW("support.dat~WINDOW_COMBO_BOX");
		break;

	case MSG_MENU_WINDOW:
		object = new UIW_WINDOW("support.dat~WINDOW_MENU");
		break;

	case MSG_NUMBER_WINDOW:
		object = new UIW_WINDOW("support.dat~WINDOW_NUMBER");
		break;

	case MSG_STRING_WINDOW:
		object = new UIW_WINDOW("support.dat~WINDOW_STRING");
		break;

	case MSG_TEXT_WINDOW:
		object = new UIW_WINDOW("support.dat~WINDOW_TEXT");
		break;

	case MSG_TIME_WINDOW:
		object = new UIW_WINDOW("support.dat~WINDOW_TIME");
		break;

	case MSG_BUTTON_WINDOW:
		object = new UIW_WINDOW("support.dat~WINDOW_BUTTON");
		break;

	case MSG_TOOL_BAR_WINDOW:
		object = new UIW_WINDOW("support.dat~WINDOW_TOOL_BAR");
		break;
#else

	case MSG_DATE_WINDOW:
		object = UIW_WINDOW::New("support.dat~WINDOW_DATE");
		break;

	case MSG_GENERIC_WINDOW:
		object = UIW_WINDOW::New("support.dat~WINDOW_GENERIC");
		break;

	case MSG_ICON_WINDOW:
		object = UIW_WINDOW::New("support.dat~WINDOW_ICON");
		break;

	case MSG_LIST_WINDOW:
		object = UIW_WINDOW::New("support.dat~WINDOW_LIST");
		break;

	case MSG_COMBO_BOX_WINDOW:
		object = UIW_WINDOW::New("support.dat~WINDOW_COMBO_BOX");
		break;

	case MSG_MENU_WINDOW:
		object = UIW_WINDOW::New("support.dat~WINDOW_MENU");
		break;

	case MSG_NUMBER_WINDOW:
		object = UIW_WINDOW::New("support.dat~WINDOW_NUMBER");
		break;

	case MSG_STRING_WINDOW:
		object = UIW_WINDOW::New("support.dat~WINDOW_STRING");
		break;

	case MSG_TEXT_WINDOW:
		object = UIW_WINDOW::New("support.dat~WINDOW_TEXT");
		break;

	case MSG_TIME_WINDOW:
		object = UIW_WINDOW::New("support.dat~WINDOW_TIME");
		break;

	case MSG_BUTTON_WINDOW:
		object = UIW_WINDOW::New("support.dat~WINDOW_BUTTON");
		break;

	case MSG_TOOL_BAR_WINDOW:
		object = UIW_WINDOW::New("support.dat~WINDOW_TOOL_BAR");
		break;
#endif
	}

	// Add the window object to the window manager.
	if (object)
		*windowManager + object;
}
