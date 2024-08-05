//	PRINTR.CPP (PRINTER) - Printer example.
//	COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//  May be freely copied, used and distributed.

#include <ui_win.hpp>

#include "printr.hpp"

#if defined(ZIL_MSDOS)
#	include <new.h>

#	if !(__BORLANDC__ >= 0X0500)
extern "C"
{
#	endif
#	include <stdlib.h>
#	include <stdio.h>
#	if !(__BORLANDC__ >= 0X0500)
}
#	endif

#	if defined(_MSC_VER)

int NewHandler(size_t size)
{
	printf("\nMemory is all gone.\n");
	return(0);
}
#	elif !defined(__WATCOMC__)
void NewHandler(void)
{
	printf("\nMemory is all gone.\n");
	exit(0);
}
#	endif
#endif

static UI_PALETTE _palette[] = {
	{ ' ', attrib(BLACK, BLACK), attrib(MONO_BLACK, MONO_BLACK),
		PTN_SOLID_FILL, BLACK, BLACK, BW_BLACK, BW_BLACK, GS_BLACK, GS_BLACK },
	{ ' ', attrib(BROWN, BROWN), attrib(MONO_BLACK, MONO_BLACK),
		PTN_SOLID_FILL, BROWN, BROWN, BW_BLACK, BW_BLACK, GS_BLACK, GS_BLACK },
	{ ' ', attrib(LIGHTGRAY, LIGHTGRAY), attrib(MONO_BLACK, MONO_BLACK),
		PTN_SOLID_FILL, LIGHTGRAY, LIGHTGRAY, BW_BLACK, BW_BLACK, GS_BLACK, GS_BLACK },
	{ ' ', attrib(LIGHTGREEN, LIGHTGREEN), attrib(MONO_NORMAL, MONO_BLACK),
		PTN_SOLID_FILL, LIGHTGREEN, LIGHTGREEN, BW_BLACK, BW_BLACK, GS_BLACK, GS_BLACK },
	{ ' ', attrib(LIGHTCYAN, LIGHTCYAN), attrib(MONO_NORMAL, MONO_BLACK),
		PTN_SOLID_FILL, LIGHTCYAN, LIGHTCYAN, BW_BLACK, BW_BLACK, GS_BLACK, GS_BLACK },
	{ ' ', attrib(YELLOW, YELLOW), attrib(MONO_NORMAL, MONO_BLACK),
		PTN_SOLID_FILL, YELLOW, YELLOW, BW_BLACK, BW_BLACK, GS_BLACK, GS_BLACK },
};

static ZIL_UINT8 _flagBitmap[144] =	{
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 8, 8,
	8, 8, 8, 8, 8, 0, 0, 8, 8, 8, 8, 8, 8, 8, 8, 8, 0, 0,
	0, 8, 8, 8, 7, 7, 7, 7, 8, 0, 0, 0, 0, 8, 8, 7, 0, 0,
	0, 0, 7, 0, 0, 0, 0, 8, 7, 7, 7, 7, 0, 7, 7, 7, 0, 0,
	0, 8, 7, 7, 7, 0, 7, 7, 7, 7, 0, 0, 0, 8, 8, 7, 0, 0,
	0, 0, 7, 0, 0, 0, 0, 8, 8, 8, 7, 7, 7, 7, 0, 0, 0, 0,
	0, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
};

int UI_APPLICATION::Main(void)
{
	// This line fixes linkers that don't look for main in the .LIBs.
	UI_APPLICATION::LinkMain();

#if defined(ZIL_MSDOS) && defined(_MSC_VER)
	_set_new_handler(NewHandler);
#elif defined(ZIL_MSDOS) && !defined(__WATCOMC__) && !defined(__SC__)
	extern void (*_new_handler)();
	_new_handler = NewHandler;
#endif

	UI_WINDOW_OBJECT::defaultStorage = new ZIL_STORAGE("p_printr.dat");

	// Check to see if the default storage was allocated.
	if (UI_WINDOW_OBJECT::defaultStorage->storageError)
	{
		delete UI_WINDOW_OBJECT::defaultStorage;
		return(-1);
	}

	// Create the derived help system capable of printing.
	UI_WINDOW_OBJECT::helpSystem = new UI_HELP_SYSTEM("p_printr.dat", windowManager, HELP_PRINTER);

	// Load the main window, and add the picture window.
	UIW_WINDOW *mainWindow = new UIW_WINDOW("MAIN_WINDOW", UI_WINDOW_OBJECT::defaultStorage);
	*mainWindow
		+ new DRAW_WINDOW;

	*windowManager
		+ mainWindow;

	// Assign screenID so application exits if main window is closed.
	windowManager->screenID = mainWindow->screenID;

	// Process user responses.
	UI_APPLICATION::Control();

	delete UI_WINDOW_OBJECT::helpSystem;
	delete UI_WINDOW_OBJECT::defaultStorage;
	return (0);
}

PRINT_DIALOG::PRINT_DIALOG(ZIL_ICHAR *name) : ZAF_DIALOG_WINDOW(name)
{
	psFileOption = Get("PSFILE_OPTION");
	psFileName = Get("PSFILE_NAME");
}

EVENT_TYPE PRINT_DIALOG::PrintOptions(UI_WINDOW_OBJECT *object, UI_EVENT &, EVENT_TYPE ccode)
{
	// Check for the select option.
	if (ccode != L_SELECT)
		return ccode;

	// Get the print request.
	EVENT_TYPE value = 0;
	object->Information(I_GET_VALUE, &value);
	switch (value)
	{
	case PRINT_TEXT:
		object->helpSystem->DisplayHelp(object->windowManager, PRINT_HELP);
		break;

	case PRINT_PICTURE:
	case PRINT_SCREEN:
		{
		PRINT_DIALOG dialog("p_printr.dat~PRINT_DIALOG");
		object->windowManager->Center(&dialog);
		if(dialog.Control() == ZIL_DLG_OK)
		{
			UI_WINDOW_OBJECT *picture = ZIL_NULLP(UI_WINDOW_OBJECT);
			UI_WINDOW_OBJECT *window = object->windowManager->Get("MAIN_WINDOW");
			if (window)
				picture = window->Get("DRAW_WINDOW");
			if (!window || !picture)
				break;

			UI_DISPLAY *screenDisplay = object->display;

			UI_PRINTER printer(screenDisplay);
			ZIL_PRINTER_MODE printMode = PRM_DEFAULT;
			ZIL_ICHAR *fileName = ZIL_NULLP(ZIL_ICHAR);

			// Check for Post Script option selected.
			if (FlagSet(dialog.psFileOption->woStatus, WOS_SELECTED))
			{
				dialog.psFileName->Information(I_GET_TEXT, &fileName);
				printMode = PRM_POSTSCRIPT;
			}

			if (printMode == PRM_POSTSCRIPT || (printMode == PRM_DEFAULT && printer.installed))
			{
				if (value == PRINT_PICTURE && !screenDisplay->isText &&
					printer.BeginPrintJob(printMode, fileName))
				{
					object->eventManager->DeviceState(E_MOUSE, DM_WAIT);

					// Swap the display to use the same DrawItem for printing.
					UI_WINDOW_OBJECT::display = &printer;
					printer.BeginPage();
					picture->Event(UI_EVENT(S_REDISPLAY));
					printer.EndPage();
					printer.EndPrintJob();
					UI_WINDOW_OBJECT::display = screenDisplay;
					object->eventManager->DeviceState(E_MOUSE, DM_VIEW);
				}
				else if (value == PRINT_SCREEN)
				{
					object->eventManager->DeviceState(E_MOUSE, DM_WAIT);

					// Screen Dump the main window image.
					screenDisplay->VirtualGet(window->screenID, window->trueRegion);
					printer.ScreenDump(window->screenID, window->trueRegion,
						printMode, fileName);
					screenDisplay->VirtualPut(window->screenID);
					object->eventManager->DeviceState(E_MOUSE, DM_VIEW);
				}
			}
		}
		}
		break;

	case PROGRAM_HELP:
		object->helpSystem->DisplayHelp(object->windowManager, HELP_PRINTER);
		break;

	case ABOUT_HELP:
		*object->windowManager->Add(new UIW_WINDOW("ABOUT_WINDOW", UI_WINDOW_OBJECT::defaultStorage));
		break;

	default:
		ccode = S_CONTINUE;
		break;
	}

	// Return the control code.
	return (ccode);
}

DRAW_WINDOW::DRAW_WINDOW(void) :
	UIW_WINDOW(0, 0, 400, 200, WOF_NON_FIELD_REGION, WOAF_NON_CURRENT)
{
	woStatus |= (WOS_GRAPHICS | WOS_OWNERDRAW);
	StringID("DRAW_WINDOW");
}

EVENT_TYPE DRAW_WINDOW::DrawItem(const UI_EVENT &, EVENT_TYPE)
{
	UI_REGION region = trueRegion;
	if (display->isText)
	{
		display->VirtualGet(screenID, region);
		display->Rectangle(screenID, region, &_palette[4], 0, TRUE, FALSE, &clip);
		display->VirtualPut(screenID);
		return TRUE;
	}

	int sunRadius = MinValue(region.Width() / 5, region.Height() / 5);
	int wCenter = region.Width() / 2;
	int hCenter = region.Height() / 2;
	int wOneFourth = wCenter / 2;
	int hOneFourth = hCenter / 2;
	int flagTop = MaxValue(region.top + hOneFourth - 40, region.top + 5);
	int mntPoints[16];
	mntPoints[0] = region.left + 1; mntPoints[1] = region.top + hCenter;
	mntPoints[2] =	region.left + wOneFourth; mntPoints[3] = region.top + hOneFourth;
	mntPoints[4] =	region.left + wCenter; mntPoints[5] = region.bottom - hOneFourth;
	mntPoints[6] =	region.right - wOneFourth; mntPoints[7] = region.top + hCenter;
	mntPoints[8] =	region.right - 1; mntPoints[9] = region.bottom - hOneFourth;
	mntPoints[10] = region.right - 1; mntPoints[11] = region.bottom - 15;
	mntPoints[12] = region.left + 1; mntPoints[13] = region.bottom - 15;
	mntPoints[14] = region.left + 1; mntPoints[15] = region.top + hCenter;

	display->VirtualGet(screenID, trueRegion);

	// Draw sky background.
	display->Rectangle(screenID, region.left, region.top, region.right,
		region.bottom - hOneFourth, &_palette[4], 0, TRUE, FALSE, &clip);
	display->Rectangle(screenID, region, &_palette[0], 1, FALSE, FALSE, &clip);

	// Draw sun.
	display->Ellipse(screenID, region.right  - sunRadius - 20,
		region.top + sunRadius + 20, 0, 360, sunRadius, sunRadius,
		&_palette[5], TRUE, FALSE, &clip);
	display->Ellipse(screenID, region.right  - sunRadius - 20,
		region.top + sunRadius + 20, 0, 360, sunRadius, sunRadius,
		&_palette[0], FALSE, FALSE, &clip);

	// Draw mountains and grass.
	display->Rectangle(screenID, region.left + 1, region.bottom - 15, region.right - 1,
		region.bottom - 1, &_palette[3], 0, TRUE, FALSE, &clip);
	display->Polygon(screenID, 8, mntPoints, &_palette[1], TRUE, FALSE);

	// Draw the flag.
	display->Line(screenID, region.left + wOneFourth, flagTop,
		region.left + wOneFourth, flagTop + 40, &_palette[0],
		2, FALSE, &clip);
	display->Rectangle(screenID, region.left + wOneFourth + 1, flagTop,
		region.left + wOneFourth + 25, flagTop + 20, &_palette[2], 0, TRUE, FALSE, &clip);
	display->Rectangle(screenID, region.left + wOneFourth + 1, flagTop,
		region.left + wOneFourth + 25, flagTop + 20, &_palette[0], 1, FALSE, FALSE, &clip);
	display->Bitmap(screenID, region.left + wOneFourth + 7, flagTop + 5,
		12, 12, _flagBitmap, ZIL_NULLP(UI_PALETTE), &clip);

	display->VirtualPut(screenID);
	return (TRUE);
}

EVENT_TYPE DRAW_WINDOW::Event(const UI_EVENT &event)
{
	// Take over the S_REDISPLAY messages.
	EVENT_TYPE ccode = event.type;
	if (ccode == S_REDISPLAY)
		ccode = DrawItem(event, ccode);
	else
		ccode = UIW_WINDOW::Event(event);
	return (ccode);
}

// --------------------------------------------------------------------------
// Designer generated code.
// --------------------------------------------------------------------------
#if defined(ZIL_LINKBUG)
void z_jump_dummy(void) { }   // Bug fix for broken linkers.
#endif

static UI_ITEM _userTable[] =
{
	{ 0, (EVENT_TYPE*)ZIL_VOIDF(PRINT_DIALOG::PrintOptions), "PRINT_DIALOG::PrintOptions", 0 },
	{ ID_END, ZIL_NULLP(void), ZIL_NULLP(ZIL_ICHAR), 0 }
};
UI_ITEM *UI_WINDOW_OBJECT::userTable = _userTable;

static UI_ITEM _objectTable[] =
{
	{ ID_BORDER, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_BORDER::New), UIW_BORDER::_className, 0 },
	{ ID_BUTTON, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_BUTTON::New), UIW_BUTTON::_className, 0 },
	{ ID_GROUP, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_GROUP::New), UIW_GROUP::_className, 0 },
	{ ID_ICON, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_ICON::New), UIW_ICON::_className, 0 },
	{ ID_MAXIMIZE_BUTTON, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_MAXIMIZE_BUTTON::New), UIW_MAXIMIZE_BUTTON::_className, 0 },
	{ ID_MINIMIZE_BUTTON, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_MINIMIZE_BUTTON::New), UIW_MINIMIZE_BUTTON::_className, 0 },
	{ ID_POP_UP_ITEM, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_POP_UP_ITEM::New), UIW_POP_UP_ITEM::_className, 0 },
	{ ID_POP_UP_MENU, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_POP_UP_MENU::New), UIW_POP_UP_MENU::_className, 0 },
	{ ID_PROMPT, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_PROMPT::New), UIW_PROMPT::_className, 0 },
	{ ID_PULL_DOWN_ITEM, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_PULL_DOWN_ITEM::New), UIW_PULL_DOWN_ITEM::_className, 0 },
	{ ID_PULL_DOWN_MENU, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_PULL_DOWN_MENU::New), UIW_PULL_DOWN_MENU::_className, 0 },
	{ ID_STRING, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_STRING::New), UIW_STRING::_className, 0 },
	{ ID_SYSTEM_BUTTON, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_SYSTEM_BUTTON::New), UIW_SYSTEM_BUTTON::_className, 0 },
	{ ID_TITLE, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_TITLE::New), UIW_TITLE::_className, 0 },
	{ ID_WINDOW, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_WINDOW::New), UIW_WINDOW::_className, 0 },
	{ ID_END, ZIL_NULLP(void), ZIL_NULLP(ZIL_ICHAR), 0 }
};
UI_ITEM *UI_WINDOW_OBJECT::objectTable = _objectTable;
