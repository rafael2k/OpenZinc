//	CONTROL.CPP (ZINCAPP) - This file contains the main control functions.
//	COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//  May be freely copied, used and distributed.

#define USE_RAW_KEYS
#include <ui_win.hpp>
#include "zincapp.hpp"

EVENT_TYPE About(UI_WINDOW_OBJECT *object, UI_EVENT &, EVENT_TYPE ccode)
{
	if (ccode != L_SELECT)
		return (ccode);

	// Compute the window region.
	UI_DISPLAY *display = object->display;
	int width = 42;
	int height = display->isText ? 7 : 6;
	int left = (display->columns / display->cellWidth - width) / 2;
	int top = (display->lines / display->cellHeight - height) / 2;

	ZIL_ICHAR *message = "Zinc Application 4.1";
	UIW_WINDOW *window = new UIW_WINDOW(left, top, width, height, WOF_NO_FLAGS, WOAF_MODAL | WOAF_NO_SIZE);
	*window
		+ new UIW_BORDER
		+ &(*new UIW_SYSTEM_BUTTON
			+ new UIW_POP_UP_ITEM("&Move", MNIF_MOVE)
			+ new UIW_POP_UP_ITEM("&Close\tAlt+F4", MNIF_CLOSE))
		+ new UIW_TITLE("About...");
	if (display->isText)
		*window
			+ new UIW_PROMPT(2, 1, message);
	else
		*window
			+ new UIW_ICON(3, 1, "minIcon")
			+ new UIW_PROMPT(10, 1, message);
	*window
		+ new UIW_BUTTON(15, height - 3, 10, "~OK",
			BTF_NO_TOGGLE | BTF_AUTO_SIZE | BTF_SEND_MESSAGE | BTF_DEFAULT_BUTTON,
			WOF_JUSTIFY_CENTER, ZIL_NULLF(ZIL_USER_FUNCTION), S_CLOSE);
	object->windowManager->Add(window);
	return (ccode);
}

EVENT_TYPE ZINCAPP_WINDOW_MANAGER::Event(const UI_EVENT &event)
{
	// Allow the base window manager to process the event.
	EVENT_TYPE ccode = UI_WINDOW_MANAGER::Event(event);

	// Send the event to any event monitor windows.
	for (UI_WINDOW_OBJECT *object = First(); object; object = object->Next())
		if (object->userFlags == MSG_EVENT_MONITOR && event.type != S_RESET_DISPLAY)
		{
			UI_EVENT tEvent(event.type, 0xFFFF);
			tEvent.data = (void *)&event;
			object->Event(tEvent);
		}

	// Return the control code.
	return (ccode);
}


EVENT_TYPE Message(UI_WINDOW_OBJECT *object, UI_EVENT &event, EVENT_TYPE ccode)
{
	if (ccode == L_SELECT)
	{
		for (UI_WINDOW_OBJECT *tObject = object->windowManager->First();
			tObject && FlagSet(tObject->woAdvancedFlags, WOAF_TEMPORARY);
			tObject = tObject->Next())
			object->eventManager->Put(UI_EVENT(S_CLOSE_TEMPORARY, 0));
		event.type = ((UIW_POP_UP_ITEM *)object)->value;
		object->eventManager->Put(event);
	}
	return (ccode);
}

CONTROL_WINDOW::CONTROL_WINDOW(void) :
	UIW_WINDOW(0, 0, 76, 6, WOF_NO_FLAGS, WOAF_LOCKED)
{
	// Control menu items.
	static UI_ITEM controlItems[] =
	{
		{ S_REDISPLAY,			(EVENT_TYPE*)ZIL_VOIDF(Message),	"&Refresh\tShift+F6",	MNIF_NO_FLAGS },
		{ 0,					ZIL_VOIDF(0),			"",						MNIF_NO_FLAGS },	// item separator
		{ L_EXIT_FUNCTION,		(EVENT_TYPE*)ZIL_VOIDF(Message),	"E&xit\tAlt+F4",		MNIF_NO_FLAGS },
		{ 0, 0, 0, 0 }	// End of array.
	};

	// Display menu items (some are only selectable in DOS).
#if defined(ZIL_MSDOS)
	static UI_ITEM displayItems[] =
	{
		{ MSG_25x40_MODE,		(EVENT_TYPE*)ZIL_VOIDF(Message),	"&1-25x40 text mode",	MNIF_NO_FLAGS },
		{ MSG_25x80_MODE,		(EVENT_TYPE*)ZIL_VOIDF(Message),	"&2-25x80 text mode",	MNIF_NO_FLAGS },
		{ MSG_43x80_MODE,		(EVENT_TYPE*)ZIL_VOIDF(Message),	"&3-(43/50)x80 text mode", MNIF_NO_FLAGS },
		{ MSG_GRAPHICS_MODE,	(EVENT_TYPE*)ZIL_VOIDF(Message),	"&4-Graphics mode",		MNIF_NO_FLAGS },
		{ 0, 0, 0, 0 }	// End of array.
	};
#endif

	// Event menu items.
	static UI_ITEM eventItems[] =
	{
		{ MSG_EVENT_MONITOR,	(EVENT_TYPE*)ZIL_VOIDF(Message),	"&Event monitor",		MNIF_NO_FLAGS },
		{ 0, 0, 0, 0 }	// End of array.
	};

	// Help menu items.	
	static UI_ITEM helpItems[] =
	{
		{ MSG_HELP_KEYBOARD,	(EVENT_TYPE*)ZIL_VOIDF(Message),	"&Keyboard",			MNIF_NO_FLAGS },
		{ MSG_HELP_MOUSE,		(EVENT_TYPE*)ZIL_VOIDF(Message),	"&Mouse",				MNIF_NO_FLAGS },
		{ MSG_HELP_COMMANDS,	(EVENT_TYPE*)ZIL_VOIDF(Message),	"&Commands",			MNIF_NO_FLAGS },
		{ MSG_HELP_PROCEDURES,	(EVENT_TYPE*)ZIL_VOIDF(Message),	"&Procedures",			MNIF_NO_FLAGS },
		{ MSG_HELP_OBJECTS,		(EVENT_TYPE*)ZIL_VOIDF(Message),	"&Objects",				MNIF_NO_FLAGS },
		{ MSG_HELP_HELP,		(EVENT_TYPE*)ZIL_VOIDF(Message),	"&Using help",			MNIF_NO_FLAGS },
		{ 0,					ZIL_VOIDF(0),		"",						MNIF_SEPARATOR },
		{ MSG_HELP_ZINCAPP,		(EVENT_TYPE*)ZIL_VOIDF(About),	"&About ZincApp...",	MNIF_ABOUT },
		{ 0, 0, 0, 0 }	// End of array.
	};


	// Create the objects submenu.
	UIW_POP_UP_ITEM *controlObjects = new UIW_POP_UP_ITEM("&Control objects");
	*controlObjects
		+ new UIW_POP_UP_ITEM("&Button window...", MNIF_NO_FLAGS, BTF_NO_FLAGS, WOF_NO_FLAGS, Message, MSG_BUTTON_WINDOW)
		+ new UIW_POP_UP_ITEM("&Generic window...", MNIF_NO_FLAGS, BTF_NO_FLAGS, WOF_NO_FLAGS, Message, MSG_GENERIC_WINDOW)
		+ new UIW_POP_UP_ITEM("&Icon window...", MNIF_NO_FLAGS, BTF_NO_FLAGS, WOF_NO_FLAGS, Message, MSG_ICON_WINDOW);
	UIW_POP_UP_ITEM *inputObjects = new UIW_POP_UP_ITEM("&Input objects");
	*inputObjects
		+ new UIW_POP_UP_ITEM("&Date window...", MNIF_NO_FLAGS, BTF_NO_FLAGS, WOF_NO_FLAGS, Message, MSG_DATE_WINDOW)
		+ new UIW_POP_UP_ITEM("&Number window...", MNIF_NO_FLAGS, BTF_NO_FLAGS, WOF_NO_FLAGS, Message, MSG_NUMBER_WINDOW)
		+ new UIW_POP_UP_ITEM("&String window...", MNIF_NO_FLAGS, BTF_NO_FLAGS, WOF_NO_FLAGS, Message, MSG_STRING_WINDOW)
		+ new UIW_POP_UP_ITEM("&Text window...", MNIF_NO_FLAGS, BTF_NO_FLAGS, WOF_NO_FLAGS, Message, MSG_TEXT_WINDOW)
		+ new UIW_POP_UP_ITEM("T&ime window...", MNIF_NO_FLAGS, BTF_NO_FLAGS, WOF_NO_FLAGS, Message, MSG_TIME_WINDOW);
	UIW_POP_UP_ITEM *selectObjects = new UIW_POP_UP_ITEM("&Selection objects");
	*selectObjects
		+ new UIW_POP_UP_ITEM("&Combo Box window...", MNIF_NO_FLAGS, BTF_NO_FLAGS, WOF_NO_FLAGS, Message, MSG_COMBO_BOX_WINDOW)
		+ new UIW_POP_UP_ITEM("&List window...", MNIF_NO_FLAGS, BTF_NO_FLAGS, WOF_NO_FLAGS, Message, MSG_LIST_WINDOW)
		+ new UIW_POP_UP_ITEM("&Menu window...", MNIF_NO_FLAGS, BTF_NO_FLAGS, WOF_NO_FLAGS, Message, MSG_MENU_WINDOW)
		+ new UIW_POP_UP_ITEM("&Tool Bar window...", MNIF_NO_FLAGS, BTF_NO_FLAGS, WOF_NO_FLAGS, Message, MSG_TOOL_BAR_WINDOW);

	// Attach the menu and support objects to the control window.
	*this
		+ new UIW_BORDER
		+ new UIW_MAXIMIZE_BUTTON
		+ new UIW_MINIMIZE_BUTTON
		+ new UIW_TITLE("Zinc Application")
		+ &(*new UIW_PULL_DOWN_MENU
			+ new UIW_PULL_DOWN_ITEM("&Control", WNF_NO_FLAGS, controlItems)
#if defined(ZIL_MSDOS)
			+ new UIW_PULL_DOWN_ITEM("&Display", WNF_NO_FLAGS, displayItems)
#endif
			+ &(*new UIW_PULL_DOWN_ITEM("&Window", WNF_NO_FLAGS)
				+ controlObjects
				+ inputObjects
				+ selectObjects)
			+ new UIW_PULL_DOWN_ITEM("&Event", WNF_NO_FLAGS, eventItems)
			+ new UIW_PULL_DOWN_ITEM("&Help", WNF_NO_FLAGS, helpItems))
		+ new UIW_ICON(0, 0, "minIcon", "Zincapp", ICF_MINIMIZE_OBJECT);
}

EVENT_TYPE CONTROL_WINDOW::Event(const UI_EVENT &event)
{
	// Check for an accelerator key.
	EVENT_TYPE ccode = event.type;
	if (ccode == L_EXIT_FUNCTION)
		eventManager->Put(UI_EVENT(L_EXIT_FUNCTION, 0));

	// Define the set of accelerator keys.
	static UI_EVENT_MAP acceleratorTable[] =
	{
#if defined(ZIL_MSDOS)
		{ ID_WINDOW_OBJECT,	S_REDISPLAY,		E_KEY,		SHIFT_F6,	S_SHIFT },
		{ ID_WINDOW_OBJECT,	L_EXIT_FUNCTION,	E_KEY,		ALT_F4,		S_ALT },
#elif defined(ZIL_MSWINDOWS)
		{ ID_WINDOW_OBJECT,	S_REDISPLAY,		WM_KEYDOWN,	SHIFT_F6,	0 },
		{ ID_WINDOW_OBJECT,	L_EXIT_FUNCTION,	WM_KEYDOWN,	ALT_F4,		0 },
#elif defined(ZIL_OS2)
		{ ID_WINDOW_OBJECT, 	S_REDISPLAY,		WM_CHAR,	SHIFT_F6, 	KC_KEYUP },
#elif defined(ZIL_MACINTOSH)
		{ ID_WINDOW_OBJECT,	S_REDISPLAY,		keyDown,	F6,		S_SHIFT },
		{ ID_WINDOW_OBJECT,	L_EXIT_FUNCTION,	keyDown,	F4,		S_OPT },
#elif defined(ZIL_MOTIF)
		{ ID_WINDOW_OBJECT,	S_REDISPLAY,		KeyPress,	XK_F6,		ShiftMask },
		{ ID_WINDOW_OBJECT,	L_EXIT_FUNCTION,	KeyPress,	XK_F4,		Mod1Mask },
#endif
		{ ID_END, 0, 0, 0, 0 }	// End of array.
	};

	// Process only if ccode designates the device type (i.e., the
	// event was not contained in event.type and needs to be mapped).
	if (ccode >= E_DEVICE_FIRST && ccode <= E_DEVICE_LAST)
	{
		EVENT_TYPE acceleratorCode = UI_EVENT_MAP::MapEvent(acceleratorTable,
			event);

		// Process only if we found the event in the acceleratorTable.
		if (acceleratorCode <= S_SYSTEM_LAST || acceleratorCode >= L_LOGICAL_FIRST)
		{
			eventManager->Put(UI_EVENT(acceleratorCode));	// Put the accelarator key
			return (acceleratorCode);
		}
	}
		
	// Process the event according to its type.
	if (ccode >= MSG_LAST || ccode <= MSG_FIRST)
		ccode = UIW_WINDOW::Event(event);	// Not a MSG event.
	else if (ccode >= MSG_HELP)
		OptionHelp(event.type);				// Help menu option selected.
	else if (ccode >= MSG_EVENT)
		OptionEvent(event.type);			// Event menu option selected.
	else if (ccode >= MSG_WINDOW)
		OptionWindow(event.type);			// Window menu option selected.
	else if (ccode >= MSG_DISPLAY)
		OptionDisplay(event.type);			// Display menu option selected.
	else
		ccode = S_UNKNOWN;

	// Return the control code.
	return (ccode);
}

EVENT_TYPE ZINCAPP_WINDOW_MANAGER::ExitFunction(UI_DISPLAY *display,
	UI_EVENT_MANAGER *, UI_WINDOW_MANAGER *windowManager)
{
	// Compute the window region.
	int width = 48;
	int height = display->isText ? 7 : 6;
	int left = (display->columns / display->cellWidth - width) / 2;
	int top = (display->lines / display->cellHeight - height) / 2;

	// Create the exit window.
	ZIL_ICHAR *message = "This will close the ZincApp tutorial.";
	UIW_WINDOW *window = new UIW_WINDOW(left, top, width, height,
		WOF_NO_FLAGS, WOAF_MODAL | WOAF_NO_SIZE);
	*window
		+ new UIW_BORDER
		+ &(*new UIW_SYSTEM_BUTTON
			+ new UIW_POP_UP_ITEM("&Move", MNIF_MOVE)
			+ new UIW_POP_UP_ITEM("&Close\tAlt+F4", MNIF_CLOSE))
		+ new UIW_TITLE("Zinc Application");
	if (display->isText)
		*window
			+ new UIW_PROMPT(2, 1, message);
	else
		*window
			+ new UIW_ICON(2, 1, "ASTERISK")
			+ new UIW_PROMPT(10, 1, message);
	*window
		+ new UIW_BUTTON(10, height - 3, 10, "~OK",
			BTF_NO_TOGGLE | BTF_AUTO_SIZE | BTF_SEND_MESSAGE | BTF_DEFAULT_BUTTON,
			WOF_JUSTIFY_CENTER, ZIL_NULLF(ZIL_USER_FUNCTION), L_EXIT)
		+ new UIW_BUTTON(25, height - 3, 10, "~Cancel",
			BTF_NO_TOGGLE | BTF_AUTO_SIZE | BTF_SEND_MESSAGE,
			WOF_JUSTIFY_CENTER, ZIL_NULLF(ZIL_USER_FUNCTION), S_CLOSE);
	*windowManager + window;
	return (S_CONTINUE);
}
