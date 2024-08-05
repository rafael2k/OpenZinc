//	PERIODIC.CPP - A table of Zinc objects
//	COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//  May be freely copied, used and distributed.

#include <ui_win.hpp>
#include "period.hpp"

int UI_APPLICATION::Main(void)
{
	// The UI_APPLICATION constructor automatically initializes the 
	// display, eventManager, and windowManager variables.

	// This line fixes linkers that don't look for main in the .LIBs.
	UI_APPLICATION::LinkMain();

	UI_WINDOW_OBJECT::errorSystem = new UI_ERROR_SYSTEM;

	UI_WINDOW_OBJECT::defaultStorage = new ZIL_STORAGE_READ_ONLY("p_period.dat");

	// Check to see if the default storage was allocated.
	if (UI_WINDOW_OBJECT::defaultStorage->storageError)
	{
		UI_WINDOW_OBJECT::errorSystem->ReportError(windowManager, WOS_NO_STATUS,
			"ERROR: Unable to open or find the file \"p_period.dat\".");
		delete UI_WINDOW_OBJECT::defaultStorage;
		delete UI_WINDOW_OBJECT::errorSystem;
		return (0);
	}

	// Add the two windows to the window manager.
	UI_WINDOW_OBJECT *window = UI_WINDOW_OBJECT::New("MAIN_PERIODIC", UI_WINDOW_OBJECT::defaultStorage);
	*windowManager
		+ window;

	// Process user responses.
	UI_APPLICATION::Control();

	// Clean up.
	delete UI_WINDOW_OBJECT::defaultStorage;
	delete UI_WINDOW_OBJECT::errorSystem;

	return (0);
}

