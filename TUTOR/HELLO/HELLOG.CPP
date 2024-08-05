//	HELLOG.CPP (HELLO) - Generate the HELLO.DAT windows.
//	COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//  May be freely copied, used and distributed.

#include <ui_win.hpp>

#define USE_HELP_CONTEXTS
#include "hello.hpp"

static UIW_WINDOW *HelloWindow1(void)
{
	// Create the Hello Universe! window.
	UIW_WINDOW *window = UIW_WINDOW::Generic(2, 2, 40, 6, "Hello Window",
		ZIL_NULLP(UI_WINDOW_OBJECT), WOF_NO_FLAGS, WOAF_NO_FLAGS, HELP_HELLO_UNIVERSE);

	*window
		+ new UIW_TEXT(0, 0, 0, 0, "Hello, Universe!", 256,
			WNF_NO_FLAGS, WOF_NON_FIELD_REGION);

	// Return a pointer to the window.
	return (window);
}

static UIW_WINDOW *HelloWindow2(void)
{
	// Create the universe information window.
	UIW_WINDOW *window = UIW_WINDOW::Generic(5, 5, 52, 12, "Universe Information Window",
		ZIL_NULLP(UI_WINDOW_OBJECT), WOF_NO_FLAGS, WOAF_NO_SIZE, HELP_UNIVERSE_INFORMATION);

	int answerValue = 42;

	// Add the window objects to the window.
	*window
		+ new UIW_PROMPT(2, 1, "Age:")
		+ new UIW_STRING(14, 1, 35, "Really old.", 50)

		+ new UIW_PROMPT(2, 2, "Weight:")
		+ new UIW_STRING(14, 2, 35, "Really heavy.", 50)

		+ new UIW_PROMPT(2, 3, "Size:")
		+ new UIW_STRING(14, 3, 35, "Really big.", 50)

		+ new UIW_PROMPT(2, 4, "The Answer:")
		+ new UIW_INTEGER(14, 4, 35, &answerValue, "42..42")

		+ &(*new UIW_TEXT(2, 6, 47, 4,
			"The universe is very complicated and not very well understood "
			"(at least not by this programmer). The above statistics should "
			"therefore be taken as approximations. The answer given above "
			"is generally thought to be correct. The problem, of course, is "
			"that nobody knows what the question is.",
			2048, WNF_NO_FLAGS, WOF_BORDER)
			+ new UIW_SCROLL_BAR(0, 0, 0, 0, SBF_VERTICAL));

	// Return a pointer to the window.
	return (window);
}

int UI_APPLICATION::Main(void)
{
	// The UI_APPLICATION constructor automatically initializes the 
	// display, eventManager, and windowManager variables.

	// This line fixes linkers that don't look for main in the .LIBs.
	UI_APPLICATION::LinkMain();

	//Initialize default storage so can get icons.
	UI_WINDOW_OBJECT::defaultStorage = new ZIL_STORAGE_READ_ONLY("zil_icon.dat");

	// Add two windows to the hello.dat object file as window resources.
	UIW_WINDOW *window1 = HelloWindow1();
	window1->Store("hello.dat~HELLO_UNIVERSE_WINDOW", ZIL_NULLP(ZIL_STORAGE),
		ZIL_NULLP(ZIL_STORAGE_OBJECT), ZIL_NULLP(UI_ITEM), ZIL_NULLP(UI_ITEM));

	UIW_WINDOW *window2 = HelloWindow2();
	window2->Store("hello.dat~UNIVERSE_INFORMATION_WINDOW", ZIL_NULLP(ZIL_STORAGE),
		ZIL_NULLP(ZIL_STORAGE_OBJECT), ZIL_NULLP(UI_ITEM), ZIL_NULLP(UI_ITEM));

	// Inform the user that the program actually did something.
	ZAF_MESSAGE_WINDOW *messageWindow = new ZAF_MESSAGE_WINDOW("Hello Universe Tutorial",
		UIW_ICON::_asteriskIconName, ZIL_MSG_OK, ZIL_MSG_OK,
		"The windows HELLO_UNIVERSE_WINDOW\r\n"
		"and UNIVERSE_INFORMATION_WINDOW\r\n"
		"have been written to the \"hello.dat\" file.\r\n"
		"Select <OK> to exit.");

	// Display the window and get user response.
	messageWindow->Control();

	// ZAF_MESSAGE_WINDOW::Control() removes window from the Window Manager 
	// but doesn't delete it.
	delete messageWindow;

	// Clean up.
	delete window2;
	delete window1;
	delete UI_WINDOW_OBJECT::defaultStorage;

	return (0);
}
