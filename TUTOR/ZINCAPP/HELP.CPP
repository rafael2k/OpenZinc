//	HELP.CPP (ZINCAPP) - This file contains the "Help" options.
//	COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//  May be freely copied, used and distributed.

#include <ui_win.hpp>
#include "zincapp.hpp"
#define USE_HELP_CONTEXTS
#include "support.hpp"

void CONTROL_WINDOW::OptionHelp(EVENT_TYPE item)
{
	// Declare the help message/context pairs.
	static struct HELP_PAIR
	{
		int itemValue;
		UI_HELP_CONTEXT helpContext;
	} helpTable[] =
	{
#if defined(ZIL_MSDOS)
		{ MSG_HELP_KEYBOARD,	HELP_KEYBOARD_MSDOS },
#elif defined(ZIL_MSWINDOWS)
		{ MSG_HELP_KEYBOARD,	HELP_KEYBOARD_MSWINDOWS },
#elif defined(ZIL_OS2)
		{ MSG_HELP_KEYBOARD,	HELP_KEYBOARD_OS2 },
#elif defined(ZIL_MOTIF)
		{ MSG_HELP_KEYBOARD,	HELP_KEYBOARD_MOTIF },
#elif defined(ZIL_MACINTOSH)
		{ MSG_HELP_KEYBOARD,	HELP_KEYBOARD_MACINTOSH },
#elif defined(ZIL_CURSES)
		{ MSG_HELP_KEYBOARD,	HELP_KEYBOARD_CURSES },
#endif
		{ MSG_HELP_MOUSE,		HELP_MOUSE },
		{ MSG_HELP_COMMANDS,	HELP_COMMANDS },
		{ MSG_HELP_PROCEDURES,	HELP_PROCEDURES },
		{ MSG_HELP_OBJECTS,		HELP_OBJECTS },
		{ MSG_HELP_HELP,		HELP_HELP },
		{ MSG_HELP_ZINCAPP,		HELP_GENERAL },
		{ 0, 0 }	// End of array.
	};

	// Get the help context then call the help system.
	ZIL_UINT16 helpContext = NO_HELP_CONTEXT;
	for (int i = 0; helpTable[i].itemValue; i++)
		if (item == helpTable[i].itemValue)
		{
			helpContext = helpTable[i].helpContext;
			break;
		}
	helpSystem->DisplayHelp(windowManager, helpContext);
}
