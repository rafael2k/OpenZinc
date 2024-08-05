// PALMAP.CPP (PALMAP) - Palette mapping example.
// COPYRIGHT (C) 1990-1995.  All Rights Reserved.
// Zinc Software Incorporated.  Pleasant Grove, Utah  USA
// May be freely copied, used and distributed.


//    note: This program is for dos only.
//          It may be run on other platforms; the results may be inconsistent.

#include <ui_win.hpp>
#include "palmap.hpp"


int UI_APPLICATION::Main(void)
{
	// The UI_APPLICATION constructor automatically initializes the
	// display, eventManager, and windowManager variables.

	// This line fixes linkers that don't look for main in the .LIBs.
	UI_APPLICATION::LinkMain();

	// Create two windows with different palettes.
	UIW_WINDOW *window1 = UIW_WINDOW::Generic(0, 0, 30, 10, "Window One");
	window1->paletteMapTable = paletteOne;

	UIW_WINDOW *window2 = UIW_WINDOW::Generic(4, 4, 30, 10, "Window Two");
	window2->paletteMapTable = paletteTwo;

	// get pointer to title and border
	window2->Get(NUMID_TITLE)->paletteMapTable = paletteTwo;
	window2->Get(NUMID_BORDER)->paletteMapTable = paletteThree;

	// Create two buttons, two strings with different palettes.
	UIW_BUTTON *button1 = new UIW_BUTTON(4, 2, 20, "Button1 ");
	UIW_BUTTON *button2 = new UIW_BUTTON(4, 4, 20, "Button2 ");
	UIW_STRING *string1 = new UIW_STRING(4, 2, 10, "String1 ");
	UIW_STRING *string2 = new UIW_STRING(4, 4, 10, "String2 ");

	// making buttons owner draw not required under dos. It is
	// done to demonstrate paletteMapping under Mac for buttons.
	button1->woStatus |= WOS_OWNERDRAW;
	button2->woStatus |= WOS_OWNERDRAW;

	button1->paletteMapTable = paletteOne;
	button2->paletteMapTable = paletteOne;
	string1->paletteMapTable = paletteTwo;
	string2->paletteMapTable = paletteTwo;

	// Add the buttons to their respective windows.
	*window1
		+ button1
		+ button2;

	*window2
		+ string1
		+ string2;

	// Add the windows to the window manager.
	*windowManager
		+ window1
		+ window2;

	// Wait for user response.
	UI_APPLICATION::Control();

	return (0);
}


