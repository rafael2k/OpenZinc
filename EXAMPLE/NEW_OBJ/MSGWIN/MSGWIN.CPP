//	MSGWIN.CPP (MSGWIN) - Message Window Example Program
//  COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//	May be freely copied, used and distributed.

#include <ui_win.hpp>

EVENT_TYPE ExitFunction(UI_DISPLAY *, UI_EVENT_MANAGER *, UI_WINDOW_MANAGER *)
{
	ZAF_MESSAGE_WINDOW mWindow("Exit?",
		ZIL_NULLP(ZIL_ICHAR), ZIL_MSG_YES | ZIL_MSG_NO, ZIL_MSG_YES,
		"Do you really want to exit the application?");

	return (mWindow.Control() == ZIL_DLG_NO ? S_CONTINUE : L_EXIT);
}

EVENT_TYPE ValidateDate(UI_WINDOW_OBJECT *dateField, UI_EVENT &, EVENT_TYPE ccode)
{
	if (ccode != L_SELECT)
		return (0);

	dateField->woStatus &= ~WOS_CHANGED;

	ZIL_DATE date;
	dateField->Information(I_GET_VALUE, &date);

	char dateBuffer[64];
	char dayBuffer[16];
	date.Export(dateBuffer, DTF_NO_FLAGS);
	date.ZIL_UTIME::Export(dayBuffer, 16, "%a");

	ZAF_MESSAGE_WINDOW mWindow("Date",
		"CALENDAR", ZIL_MSG_OK, ZIL_MSG_OK,
		"%s is a %s", dateBuffer, dayBuffer);

	mWindow.Control();

	return (0);
}

EVENT_TYPE ValidateString(UI_WINDOW_OBJECT *stringField, UI_EVENT &, EVENT_TYPE ccode)
{
	if (ccode != S_NON_CURRENT || !FlagSet(stringField->woStatus, WOS_CHANGED))
		return (0);

	stringField->woStatus &= ~WOS_CHANGED;

	ZIL_ICHAR *pointer;
	stringField->Information(I_GET_TEXT, &pointer);

	if (*pointer && *pointer != 'A' && *pointer != 'a')
	{
		ZAF_MESSAGE_WINDOW mWindow("String",
			ZIL_NULLP(ZIL_ICHAR), ZIL_MSG_CANCEL | ZIL_MSG_IGNORE, ZIL_MSG_CANCEL,
			"%s starts with '%c' not 'A'", pointer, *pointer);
		ZIL_DIALOG_EVENT dcode = mWindow.Control();
		if (dcode == ZIL_DLG_CANCEL)
			stringField->Information(I_SET_TEXT, ZIL_INTERNATIONAL::_blankString);
	}

	return (0);
}

int UI_APPLICATION::Main(void)
{
	// This line fixes linkers that don't look for main in the .LIBs.
	UI_APPLICATION::LinkMain();

	UI_WINDOW_OBJECT::defaultStorage = new ZIL_STORAGE("p_msgwin.dat", UIS_READ);

	// Check to see if the default storage was allocated.
	if (UI_WINDOW_OBJECT::defaultStorage->storageError)
	{
		delete UI_WINDOW_OBJECT::defaultStorage;
		return(-1);
	}

	windowManager->exitFunction = ExitFunction;

	UIW_WINDOW *window = UIW_WINDOW::Generic(1, 1, 50, 5, "MSG_WIN");

	*window
		+ new UIW_PROMPT(1, 1, 23, "Find Day: ", WOF_JUSTIFY_RIGHT)
		+ new UIW_DATE(24, 1, 20, ZIL_NULLP(ZIL_DATE), ZIL_NULLP(ZIL_ICHAR),
			DTF_NO_FLAGS, WOF_BORDER, ValidateDate)
		+ new UIW_PROMPT(1, 2, 23, "Should start with 'A': ", WOF_JUSTIFY_RIGHT)
		+ new UIW_STRING(24, 2, 20, _blankString, 32, STF_NO_FLAGS,
			WOF_BORDER | WOF_AUTO_CLEAR, ValidateString);

	*windowManager
		+ window;

	windowManager->screenID = window->screenID;

	UI_APPLICATION::Control();

	delete UI_WINDOW_OBJECT::defaultStorage;
	return (0);
}
