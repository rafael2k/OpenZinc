//  MATCH.CPP (MATCH) - Concentration program.
//  COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//  Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//  May be freely copied, used and distributed.


#include <time.h>
#include <stdlib.h>
#include <ui_win.hpp>


#include "match.hpp"

static ZIL_ICHAR *bitmapName[] =
{
	"barney_rubble", "bear", "butterfly2", "cookie", "crayons", "dog",
	"dynamite", "earth", "flintstone2", "golf", "hamburger", "hilda",
	"hobbes", "jetfighter", "knife", "rabbit", "thumper", "zinclogo"
};

MATCH_BUTTON::MATCH_BUTTON(int left, int top, int width, BTF_FLAGS btFlags,
	WOF_FLAGS woFlags, EVENT_TYPE value, ZIL_ICHAR *_bitmapOne, ZIL_ICHAR *_bitmapTwo) :
	UIW_BUTTON(left, top, width, ZIL_NULLP(ZIL_ICHAR), btFlags, woFlags, ZIL_NULLF(ZIL_USER_FUNCTION),
	value, _bitmapOne),	bitmapOne(_bitmapOne), bitmapTwo(_bitmapTwo)
{
}

void MATCH_BUTTON::SetBitmap(ZIL_ICHAR *name)
{
	defaultStorage->ChDir("~UI_BITMAP");

	ZIL_STORAGE_OBJECT_READ_ONLY bitmap(*defaultStorage, name, ID_BITMAP_IMAGE);

	if (!bitmap.objectError)
	{
		ZIL_INT16 _value;

		bitmap.Load(&_value);
		int width = _value;

		bitmap.Load(&_value);
		int height = _value;

		ZIL_UINT8 *array = new ZIL_UINT8[width * height];
		bitmap.Load(array, sizeof (ZIL_UINT8), width * height);
		Information(I_SET_BITMAP_ARRAY, array);
		delete array;
	}
}

MATCH_WINDOW::MATCH_WINDOW(int left, int top, int width, int height) :
	UIW_WINDOW(left, top, width, height, WOF_NO_FLAGS, WOAF_NO_SIZE),
	choiceOne(ZIL_NULLP(MATCH_BUTTON)), choiceTwo(ZIL_NULLP(MATCH_BUTTON))
{
	*this
		+ new UIW_BORDER
		+ new UIW_MINIMIZE_BUTTON
		+ new UIW_SYSTEM_BUTTON(SYF_GENERIC)
		+ new UIW_TITLE("Zinc Concentration");
	
	buttonWindow = new UIW_WINDOW(0, 0, 0, 0, WOF_NON_FIELD_REGION);

	*this
		+ &(*new UIW_PULL_DOWN_MENU()
			+ &(*new UIW_PULL_DOWN_ITEM("&Game")
				+ new UIW_POP_UP_ITEM("&New", MNIF_SEND_MESSAGE, BTF_NO_3D,
					WOF_NO_FLAGS, ZIL_NULLF(ZIL_USER_FUNCTION), NEW_GAME)
				+ new UIW_POP_UP_ITEM("", MNIF_SEPARATOR)
				+ new UIW_POP_UP_ITEM("E&xit", MNIF_SEND_MESSAGE, BTF_NO_3D,
					WOF_NO_FLAGS, ZIL_NULLF(ZIL_USER_FUNCTION), L_EXIT)))
		+ buttonWindow
		+ new UIW_ICON(0, 0, "MATCH", "MATCH", ICF_MINIMIZE_OBJECT,
			WOF_JUSTIFY_CENTER);

	Jumble();
}

void MATCH_WINDOW::Jumble(void)
{
	UI_LIST list;
	int i, j;
	int randCount = MAXBUTTONS;
	MATCH_BUTTON *button;

	// Create a temporary list of buttons to be jumbled.
	for (i = 0; i < 2; i++)
		for (j = 0; j < MAXBITMAPS; j++)
		{
			list + new MATCH_BUTTON(0, 0, 4, BTF_AUTO_SIZE | BTF_NO_TOGGLE |
				BTF_NO_3D |	BTF_SEND_MESSAGE, WOF_JUSTIFY_CENTER, TOGGLE_BITMAP,
				"zinc_spiral", bitmapName[j]);
		}
			
	// Randomly pick from the list and add the buttons to the window.
	struct tm *sTime;
	time_t lTime;
	time(&lTime);
	sTime = localtime(&lTime);
	int seed = sTime->tm_sec;
	srand(seed);
	
	const int bitmapWidth = 32,
		bitmapHeight = 32;
	const int hSpace = 10,
		vSpace = 10;
	for (i = 0; i < 6; i++)
		for (j = 1; j < 7; j++)
		{
			int index = (rand() & 0x7FFF) / (32767 / randCount--);
			button = (MATCH_BUTTON *)list.Get(index);
			list - button;

			// Notify the button that its relative coordinates are in pixels.
			button->woStatus |= WOS_GRAPHICS;
			button->relative.left = i * bitmapWidth + (i + 1) * hSpace;
			button->relative.top = j * bitmapHeight + j * vSpace;
			button->relative.right = button->relative.left + bitmapWidth;
			button->relative.bottom = button->relative.top;
			*buttonWindow + button;
		}
}

EVENT_TYPE MATCH_WINDOW::Event(const UI_EVENT &event)
{
	EVENT_TYPE ccode = event.type;
	switch (ccode)
	{
	case TOGGLE_BITMAP:
		{
		MATCH_BUTTON *selection = (MATCH_BUTTON *)event.windowObject;

		if (!choiceOne)
			choiceOne = selection;
		else if (!choiceTwo && selection != choiceOne)
		{
			choiceTwo = selection;

			// Check to see if the two selected buttons have matching bitmaps.
			if (!strcmp(choiceOne->bitmapTwo, choiceTwo->bitmapTwo))
			{
				// Set 'updateType' for clearing the matching buttons.
				updateType = CLEAR_BUTTON;
			}
			else
			{
				// Audio indication that buttons don't match.
				errorSystem->Beep();

				// Set 'updateType' for restoring the buttons.
				updateType = UPDATE_BUTTON;
			}

			// Start Update timer. See E_TIMER case.
			// (Clears or restores buttons after .5 seconds)
			eventManager->DeviceState(E_TIMER, D_ON);
		}
		else
			break;

		// Reveal button image.
		selection->SetBitmap(selection->bitmapTwo);
		selection->Event(UI_EVENT(S_REDISPLAY));
		}
		break;
		
	case NEW_GAME:
		choiceOne = choiceTwo = ZIL_NULLP(MATCH_BUTTON);
		buttonWindow->Destroy();
		Jumble();
		buttonWindow->Event(UI_EVENT(S_REDISPLAY));
		break;

	case UPDATE_BUTTON:
		{
	  	MATCH_BUTTON *button = (MATCH_BUTTON *)event.windowObject;
		button->SetBitmap(button->bitmapOne);
		button->Event(UI_EVENT(S_REDISPLAY));
		}
		break;

	case CLEAR_BUTTON:
		{
	  	MATCH_BUTTON *button = (MATCH_BUTTON *)event.windowObject;
		UI_REGION region = button->trueRegion;
		*buttonWindow - button;
		delete button;
		UI_EVENT updateEvent(S_DISPLAY_ACTIVE, 0, region);
		buttonWindow->Event(updateEvent);
		}
		break;

	case E_TIMER:
		// Stop Update timer.
		eventManager->DeviceState(E_TIMER, D_OFF);

		if (choiceOne && choiceTwo)
		{
			// Update Selected Buttons.
			UI_EVENT updateEvent(updateType);
			updateEvent.windowObject = choiceOne;
			Event(updateEvent);
			updateEvent.windowObject = choiceTwo;
			Event(updateEvent);

			// Clear selection pointers.
			choiceOne = choiceTwo = ZIL_NULLP(MATCH_BUTTON);

			// Make sure there is a current button.
			if (!buttonWindow->Current() && buttonWindow->First())
				buttonWindow->Add(buttonWindow->First());
		}
		break;

	default:
		ccode = UIW_WINDOW::Event(event);
	}

	return (ccode);
}

int UI_APPLICATION::Main()
{
	// The UI_APPLICATION constructor automatically initializes the
	// display, eventManager, and windowManager variables.

	// This line fixes linkers that don't look for main in the .LIBs.
	UI_APPLICATION::LinkMain();
	
	// Set up the default storage.
	UI_WINDOW_OBJECT::defaultStorage = new ZIL_STORAGE_READ_ONLY("p_match.dat");

 	// Check to see if the program should stop before it begins.
	if (display->isText || UI_WINDOW_OBJECT::defaultStorage->storageError)
	{
		delete UI_WINDOW_OBJECT::defaultStorage;
		return(-1);
	}

	// Initialize the error system.
	UI_WINDOW_OBJECT::errorSystem = new UI_ERROR_SYSTEM;

	// Add timer device used for creating delays.
	*eventManager + new UID_TIMER(D_OFF, 500, TMR_QUEUE_EVENTS);

	// Create the main window using pixel coordinates and center it on the display.
	MATCH_WINDOW *match = new MATCH_WINDOW(0, 0, 270, 320);
	match->woStatus |= WOS_GRAPHICS;
	windowManager->Center(match);

	// Add the window to the window manager.
	*windowManager + match;

	// Main event loop.
	Control();

	// Clean up.
	delete UI_WINDOW_OBJECT::errorSystem;
	delete UI_WINDOW_OBJECT::defaultStorage;

	return (0);
}
