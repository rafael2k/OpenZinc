//	WORLD.CPP (WORLD) - Shows how to broadcast messages to all windows.
//	COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//	May be freely copied, used and distributed.

#include <ui_win.hpp>


#include "world.hpp"

// This user function add a new world window to the window manager.
EVENT_TYPE AddWorldWindow(UI_WINDOW_OBJECT *object, UI_EVENT &, EVENT_TYPE ccode)
{
	if (ccode == L_SELECT)
		*object->windowManager + new WORLD_WINDOW;

	return(ccode);
}

EVENT_TYPE WORLD_WINDOW_MANAGER::Event(const UI_EVENT &event)
{
	// Switch on the event type.
	EVENT_TYPE ccode = event.type;
	switch(ccode)
	{
	case STOP_WORLD:
	case E_TIMER:
		{
			// These messages are sent to all windows attached to the windowManager.
			for (UI_WINDOW_OBJECT *win = windowManager->First(); win; win = win->Next())
				win->Event(event);
		}
		break;

	case TOGGLE_DEVICE_STATE:
		{
			// This message toggles the state of the UID_TIMER.
			ZIL_DEVICE_STATE clockState = eventManager->DeviceState(E_TIMER, D_STATE);
			eventManager->DeviceState(E_TIMER, (clockState == D_ON) ? D_OFF : D_ON);
		}
		break;

	default:
		// Send event information to the window manager.
		ccode = UI_WINDOW_MANAGER::Event(event);
	}

	return(ccode);
}

WORLD_WINDOW::WORLD_WINDOW() : UIW_WINDOW("WORLD_WINDOW", UI_WINDOW_OBJECT::defaultStorage)
{
	worldField = new WORLD_BITMAP(170, 25, 64, 64);
	*this + worldField;
	radioBtn = Get("ON_OFF");
}

EVENT_TYPE WORLD_WINDOW::Event(const UI_EVENT &event)
{
	EVENT_TYPE ccode = event.type;
	// Switch on the event type.
	switch(ccode)
	{
	case E_TIMER:
		// Update the rotating world if the on/off button is selected.
		if (FlagSet(radioBtn->woStatus, WOS_SELECTED))
			worldField->Event(UI_EVENT(S_DISPLAY_ACTIVE, 0, worldField->trueRegion));
		break;

	case STOP_WORLD:
		// Turn off updating of the rotating world by deselecting the on/off button.
		radioBtn->woStatus &= ~WOS_SELECTED;
		radioBtn->Information(I_CHANGED_STATUS, ZIL_NULLP(void));
		break;
	
	default:
		ccode = UIW_WINDOW::Event(event);
	}

	return(ccode);
}

WORLD_BITMAP::WORLD_BITMAP(int _left, int _top, int _width, int _height)
	: UI_WINDOW_OBJECT(_left, _top, _width, _height, WOF_NON_SELECTABLE, WOAF_NO_FLAGS)
{
	woStatus |= WOS_OWNERDRAW | WOS_GRAPHICS;
	numberOfBitmaps = 15;
	currentBitmap = 0;
}

EVENT_TYPE WORLD_BITMAP::DrawItem(const UI_EVENT &, EVENT_TYPE ccode)
{
	// Extract the region information.
	UI_REGION wRegion = trueRegion;
	display->VirtualGet(screenID, wRegion);

	UI_WINDOW_OBJECT::defaultStorage->ChDir("~UI_BITMAP");

	ZIL_ICHAR worldBitmapName[10];
	sprintf(worldBitmapName, "WORLD_%i", currentBitmap % numberOfBitmaps);
	currentBitmap++;

	ZIL_STORAGE_OBJECT_READ_ONLY bitmap(*UI_WINDOW_OBJECT::defaultStorage, worldBitmapName, ID_BITMAP_IMAGE);
	if (!bitmap.objectError)
	{
		ZIL_UINT16 width, height;
		bitmap.Load(&width);
		bitmap.Load(&height);

		ZIL_UINT8 *array = new ZIL_UINT8[width * height];
		bitmap.Load(array, sizeof(ZIL_UINT8), width * height);
		Information(I_SET_BITMAP_ARRAY, array);

		display->Bitmap(screenID, wRegion.left, wRegion.top, width, height, array, ZIL_NULLP(UI_PALETTE));
		delete array;
	}

	display->VirtualPut(screenID);
	woStatus &= ~WOS_REDISPLAY;

	return(ccode);
}

EVENT_TYPE WORLD_BITMAP::Event(const UI_EVENT &event)
{
	EVENT_TYPE ccode = UI_WINDOW_OBJECT::Event(event);

	if (ccode == S_CHANGED || ccode == S_CREATE)
		RegisterObject("WORLD_BITMAP");

	return(ccode);
}

int UI_APPLICATION::Main()
{
	// The UI_APPLICATION constructor automatically initializes the
	// display, eventManager, and windowManager variables.

	// Install the new window manager.
	delete windowManager;
	windowManager = new WORLD_WINDOW_MANAGER(display, eventManager);

	// This line fixes linkers that don't look for main in the .LIBs.
	UI_APPLICATION::LinkMain();
	// Make sure the display is installed correctly and not text mode.
	if (!display || !display->installed)
	{
		delete display;
		return(0);
	}

	*eventManager + new UID_TIMER(D_ON, 500, TMR_QUEUE_EVENTS);
		
	UI_WINDOW_OBJECT::defaultStorage = new ZIL_STORAGE_READ_ONLY("p_world.dat");

	// Check to see if the default storage was allocated.
	if (UI_WINDOW_OBJECT::defaultStorage->storageError)
	{
		delete UI_WINDOW_OBJECT::defaultStorage;
		return(-1);
	}

	UIW_WINDOW *menuWindow = new UIW_WINDOW("MENU_WINDOW", UI_WINDOW_OBJECT::defaultStorage);
	*windowManager + menuWindow;

	// If the main window is closed then close the entire application.
	windowManager->screenID = menuWindow->screenID;
	
	// Process user responses.
	UI_APPLICATION::Control();

	delete UI_WINDOW_OBJECT::defaultStorage;

	return(0);
}

//-------------------------------------------------------------------
//-- Designer generated tables. -------------------------------------
//-------------------------------------------------------------------
void z_jump_dummy(void) { }   // Bug fix for broken linkers.

static ZIL_ICHAR _AddWorldWindow[] = { 'A','d','d','W','o','r','l','d','W','i','n','d','o','w',0 };

static UI_ITEM _userTable[] =
{
	{ 0, (EVENT_TYPE*)ZIL_VOIDF(AddWorldWindow), _AddWorldWindow, 0 },
	{ ID_END, ZIL_NULLP(void), ZIL_NULLP(ZIL_ICHAR), 0 }
};
UI_ITEM *UI_WINDOW_OBJECT::userTable = _userTable;

static UI_ITEM _objectTable[] =
{
	{ ID_BORDER, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_BORDER::New), UIW_BORDER::_className, 0 },
	{ ID_BUTTON, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_BUTTON::New), UIW_BUTTON::_className, 0 },
	{ ID_ICON, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_ICON::New), UIW_ICON::_className, 0 },
	{ ID_MAXIMIZE_BUTTON, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_MAXIMIZE_BUTTON::New), UIW_MAXIMIZE_BUTTON::_className, 0 },
	{ ID_MINIMIZE_BUTTON, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_MINIMIZE_BUTTON::New), UIW_MINIMIZE_BUTTON::_className, 0 },
	{ ID_POP_UP_ITEM, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_POP_UP_ITEM::New), UIW_POP_UP_ITEM::_className, 0 },
	{ ID_POP_UP_MENU, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_POP_UP_MENU::New), UIW_POP_UP_MENU::_className, 0 },
	{ ID_PULL_DOWN_ITEM, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_PULL_DOWN_ITEM::New), UIW_PULL_DOWN_ITEM::_className, 0 },
	{ ID_PULL_DOWN_MENU, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_PULL_DOWN_MENU::New), UIW_PULL_DOWN_MENU::_className, 0 },
	{ ID_SYSTEM_BUTTON, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_SYSTEM_BUTTON::New), UIW_SYSTEM_BUTTON::_className, 0 },
	{ ID_TEXT, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_TEXT::New), UIW_TEXT::_className, 0 },
	{ ID_TITLE, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_TITLE::New), UIW_TITLE::_className, 0 },
	{ ID_WINDOW, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_WINDOW::New), UIW_WINDOW::_className, 0 },
	{ ID_END, ZIL_NULLP(void), ZIL_NULLP(ZIL_ICHAR), 0 }
};
UI_ITEM *UI_WINDOW_OBJECT::objectTable = _objectTable;
//-------------------------------------------------------------------
//-- End of designer generated tables. ------------------------------
//-------------------------------------------------------------------
