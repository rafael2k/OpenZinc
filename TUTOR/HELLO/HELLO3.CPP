//	HELLO3.CPP (HELLO) - Using windows created with Zinc Designer.
//	COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//  May be freely copied, used and distributed.

#include <ui_win.hpp>

#define USE_HELP_CONTEXTS
#include "hello.hpp"

static EVENT_TYPE ExitFunction(UI_DISPLAY *, UI_EVENT_MANAGER *,
	UI_WINDOW_MANAGER *)
{
	ZAF_MESSAGE_WINDOW *window = new ZAF_MESSAGE_WINDOW("Hello Universe Tutorial",
		UIW_ICON::_asteriskIconName, ZIL_MSG_OK | ZIL_MSG_CANCEL, ZIL_MSG_OK,
		"This will close the Hello Universe application.");

	EVENT_TYPE ccode = S_CONTINUE;

	// Get user response.
	if (window->Control() == ZIL_DLG_OK)
		ccode = L_EXIT;

	// Control() removes window from the Window Manager but doesn't delete it.
	delete window;

	return (ccode);
}

int UI_APPLICATION::Main(void)
{
	// The UI_APPLICATION constructor automatically initializes the 
	// display, eventManager, and windowManager variables.

	// This line fixes linkers that don't look for main in the .LIBs.
	UI_APPLICATION::LinkMain();

	// Redirect the window manager's exit function.
	windowManager->exitFunction = ExitFunction;

 	// Initialize the help and error systems and persistant object table.
	UI_WINDOW_OBJECT::errorSystem = new UI_ERROR_SYSTEM;
	UI_WINDOW_OBJECT::helpSystem = new UI_HELP_SYSTEM("hello.dat",
		windowManager, HELP_GENERAL);
	UI_WINDOW_OBJECT::defaultStorage = new ZIL_STORAGE_READ_ONLY("hello.dat");

	// Check to see if the default storage was allocated.
	if (UI_WINDOW_OBJECT::defaultStorage->storageError)
	{
		UI_WINDOW_OBJECT::errorSystem->ReportError(windowManager, WOS_NO_STATUS,
			"ERROR: Unable to open or find the file \"hello.dat\".");
		delete UI_WINDOW_OBJECT::defaultStorage;
		delete UI_WINDOW_OBJECT::helpSystem;
		delete UI_WINDOW_OBJECT::errorSystem;
		return (0);
	}

	// Add the two windows to the window manager.
	UI_WINDOW_OBJECT *window1 = UI_WINDOW_OBJECT::New("hello.dat~HELLO_UNIVERSE_WINDOW");
	UI_WINDOW_OBJECT *window2 = UI_WINDOW_OBJECT::New("hello.dat~UNIVERSE_INFORMATION_WINDOW");
	*windowManager
		+ window1
		+ window2;

	// This line assigns the exit function to be called before the main
	// window is closed.  It MUST be after the window is added to 
	// windowManager.
	windowManager->screenID = window1->screenID;

	// Process user responses.
	UI_APPLICATION::Control();

	// Clean up.
	delete UI_WINDOW_OBJECT::defaultStorage;
	delete UI_WINDOW_OBJECT::helpSystem;
	delete UI_WINDOW_OBJECT::errorSystem;

	return (0);
}

