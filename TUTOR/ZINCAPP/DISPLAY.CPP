//	DISPLAY.CPP (ZINCAPP) - This file contains the "Display" options.
//	COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//  May be freely copied, used and distributed.

#include <ui_win.hpp>
#include "zincapp.hpp"

void CONTROL_WINDOW::OptionDisplay(EVENT_TYPE item)
{
	// Set up the default event.
	UI_EVENT event(S_RESET_DISPLAY, TDM_NONE);

	// Decide on the new display type.
	if (item == MSG_25x40_MODE)
		event.rawCode = TDM_25x40;
	else if (item == MSG_25x80_MODE)
		event.rawCode = TDM_25x80;
	else if (item == MSG_43x80_MODE)
		event.rawCode = TDM_43x80;
	
	// Send a message to reset the display.
	// (Code resides in main program loop).
	eventManager->Put(event);
}

