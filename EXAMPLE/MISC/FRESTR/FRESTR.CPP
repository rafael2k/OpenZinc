//	FRESTR.CPP (FREESTOR) - Demonstrate a Free Store Exception Handler.
//	COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//  May be freely copied, used and distributed.

#include <stdio.h>
#include <stdlib.h>
#include <new.h>

#include <ui_win.hpp>
#include "frestr.hpp"

#if !defined(ZIL_MSDOS)
int UI_APPLICATION::Main(void)
{
	LinkMain();

	// Inform the user that the program is for DOS only.
	ZAF_MESSAGE_WINDOW *messageWindow = new ZAF_MESSAGE_WINDOW("FRESTR",
		UIW_ICON::_asteriskIconName, ZIL_MSG_OK, ZIL_MSG_OK,
		"The FRESTR example is for DOS only. "
		"Select <OK> to exit.");

	// Display the window and get user response.
	messageWindow->Control();

	// ZAF_MESSAGE_WINDOW::Control() removes window from the Window Manager
	// but doesn't delete it.
	delete messageWindow;

	return (0);
}
#else

#	if defined(__BORLANDC__)
void NewHandler(void)
{
	MEMORY_ALLOCATION_ERROR_SYSTEM::FreeStoreException();
}
#	else
int NewHandler(size_t size)
{
	MEMORY_ALLOCATION_ERROR_SYSTEM::FreeStoreException();
	return (0);
}
#   endif

// Static variable definitions.
char * MEMORY_ALLOCATION_ERROR_SYSTEM::errorMem;
UIW_WINDOW *MEMORY_ALLOCATION_ERROR_SYSTEM::errorWindow = ZIL_NULLP(UIW_WINDOW);

UI_DISPLAY *MEMORY_ALLOCATION_ERROR_SYSTEM::display;
UI_EVENT_MANAGER *MEMORY_ALLOCATION_ERROR_SYSTEM::eventManager;
UI_WINDOW_MANAGER *MEMORY_ALLOCATION_ERROR_SYSTEM::windowManager;

static UI_PALETTE_MAP _memErrorPalette[] =
{
	{ ID_WINDOW_OBJECT, PM_ANY,
		{ ' ', attrib(WHITE, RED), attrib(MONO_BLACK, MONO_NORMAL),
		PTN_SOLID_FILL, WHITE, RED, BW_BLACK, BW_WHITE, GS_BLACK, GS_WHITE } },
	{ ID_END, 0, { 0, 0, 0, 0, 0, 0 } }
};

MEMORY_ALLOCATION_ERROR_SYSTEM::MEMORY_ALLOCATION_ERROR_SYSTEM(UI_DISPLAY *_display,
	UI_EVENT_MANAGER *_eventManager, UI_WINDOW_MANAGER *_windowManager)
{
	installed = FALSE;
	if (!errorWindow)
	{
		// Hold on to these for clean-up.
		display = _display;
		eventManager = _eventManager;
		windowManager = _windowManager;

		// Set up the errorWindow here just in case a
		// Free store exception is encountered.
		int x = ((display->columns / display->cellWidth) - 50) / 2;
		errorWindow = new UIW_WINDOW(x, 1, 50, 8, WOF_NO_FLAGS,
			WOAF_MODAL | WOAF_LOCKED);
		UIW_TITLE *title = new UIW_TITLE("Out of Memory");
		title->paletteMapTable = _memErrorPalette;
		*errorWindow
			+ new UIW_BORDER
			+ title
			+ new UIW_TEXT(0, 0, 1, 1,
				"The system is out of memory.  Press any key to exit to DOS.",
				256, WNF_NO_FLAGS, WOF_NON_FIELD_REGION | WOF_NON_SELECTABLE);
   	
		// Request some memory that will be required to add the error to the
		// _windowManager and get an event.  6000 is an arbitrary value.
		errorMem = new char[6000];

		if (errorMem)
		{
			// Reset the free store exception handler to the handler in this file.
#   if defined(__BORLANDC__)
			extern void (*_new_handler)();
			_new_handler = NewHandler;
#   else
			_set_new_handler(NewHandler);
#   endif
			installed = TRUE;
		}
	}
}

MEMORY_ALLOCATION_ERROR_SYSTEM::~MEMORY_ALLOCATION_ERROR_SYSTEM()
{
	delete errorMem;
	delete errorWindow;
}

// This is the actual FreeStoreException handler.
void MEMORY_ALLOCATION_ERROR_SYSTEM::FreeStoreException(void)
{
	// Free up the space needed to be able to add the error window.
	delete errorMem;

	// add the error window.
	*windowManager
		+ errorWindow;

	// Wait for an event to initiate the exit sequence.
	UI_EVENT event;
	eventManager->Get(event, Q_NORMAL);

	// Emergency clean up and exit.
	delete windowManager;
	delete eventManager;
	delete display;

	exit(0);
}

int UI_APPLICATION::Main(void)
{
	// The UI_APPLICATION constructor automatically initializes the
	// display, eventManager, and windowManager variables.

	// This line fixes linkers that don't look for main in the .LIBs.
	UI_APPLICATION::LinkMain();

	// Set up the Free Store Exception handler.
	MEMORY_ALLOCATION_ERROR_SYSTEM *memErrorSystem =
		new MEMORY_ALLOCATION_ERROR_SYSTEM(display, eventManager, windowManager);
	if (!memErrorSystem->installed)
	{
		delete memErrorSystem;
		delete windowManager;
		delete eventManager;
		delete display;
		printf("Not enough memory to install memory error handler.");
	}

	int centerX = display->columns / display->cellWidth / 2;
	*windowManager
		+ &(* new UIW_WINDOW(centerX - 30, 1, 60, 8,
		WOF_NO_FLAGS, WOAF_NO_MOVE | WOAF_NO_SIZE | WOAF_DIALOG_OBJECT)
			+ new UIW_BORDER
			+ new UIW_TEXT(0, 0, 0, 0,
				"This is a test of the Free Store Exception Handler. "
				"When the new operator fails, a NULL is usually returned. "
				"For this example a \"new handler\" is called instead. This "
				"handler takes control, notifies the user, and does clean up "
				"and exit. It may take a few hundred windows to use up all of "
				"memory. Be patient and watch.", 512,
				WNF_NO_FLAGS, WOF_VIEW_ONLY | WOF_NON_FIELD_REGION));

	// Now add windows until a Free Store Exception error is found.
	int i = 0;

	// Wait for user response.
	UI_EVENT event;
	EVENT_TYPE ccode;
	do
	{
		// Get input from the user.
		ccode = eventManager->Get(event, Q_NO_BLOCK);
		if (!ccode)
			ccode = windowManager->Event(event);
		else
		{
			i++;
			*windowManager
				+ &(*new UIW_WINDOW(centerX - 20, 11, 40, 7,
					WOF_NO_FLAGS, WOAF_NO_SIZE | WOAF_NO_MOVE | WOAF_DIALOG_OBJECT)
					+ new UIW_BORDER
					+ new UIW_TITLE("Memory Test Window")
					+ new UIW_INTEGER(15, 2, 8, &i));
		}
	} while (ccode != L_EXIT && ccode != S_NO_OBJECT);

	// Clean up.
	delete memErrorSystem;

	return (0);
}
#endif
