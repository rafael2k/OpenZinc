//	MDI.CPP (MDI) - MDI - Scrolling Window example.
//	COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//  May be freely copied, used and distributed.


#include <ui_win.hpp>


#include "mdi.hpp"

int UI_APPLICATION::Main(void)
{
	// This line fixes linkers that don't look for main in the .LIBs.
	UI_APPLICATION::LinkMain();

	UI_WINDOW_OBJECT::defaultStorage = new ZIL_STORAGE("p_mdi.dat");

	// Check to see if the default storage was allocated.
	if (UI_WINDOW_OBJECT::defaultStorage->storageError)
	{
		delete UI_WINDOW_OBJECT::defaultStorage;
		return(-1);
	}

	UI_WINDOW_OBJECT::helpSystem = new UI_HELP_SYSTEM("p_mdi.dat",
		windowManager, MDI_HELP);

	MDI_FRAME_WINDOW *mdiFrame = new MDI_FRAME_WINDOW("p_mdi.dat~MDI_FRAME");
	*mdiFrame
		+ new UIW_SCROLL_BAR(0, 0, 0, 0, SBF_CORNER)
		+ new UIW_SCROLL_BAR(0, 0, 0, 0, SBF_VERTICAL)
		+ new UIW_SCROLL_BAR(0, 0, 0, 0, SBF_HORIZONTAL)
		+ new MDI_CHILD_WINDOW("p_mdi.dat~MDI_CHILD3", 3)
		+ new MDI_CHILD_WINDOW("p_mdi.dat~MDI_CHILD2", 2)
		+ new MDI_CHILD_WINDOW("p_mdi.dat~MDI_CHILD1", 1);

	*windowManager
		+ mdiFrame;

	UI_APPLICATION::Control();

	delete UI_WINDOW_OBJECT::helpSystem;
	delete UI_WINDOW_OBJECT::defaultStorage;
	return (0);
}

MDI_FRAME_WINDOW::MDI_FRAME_WINDOW(const ZIL_ICHAR *name) :	UIW_WINDOW(name)
{
	windowMenu = Get("WINDOW_MENU");
}

EVENT_TYPE MDI_FRAME_WINDOW::Event(const UI_EVENT &event)
{
	EVENT_TYPE ccode = event.type;

	// Check for a Window menu item event.
	if (ccode >= MDI_ACTIVATE_CHILD)
	{
		for (UI_WINDOW_OBJECT *childWindow = Last(); childWindow;
			childWindow = childWindow->Previous())
			if (ccode == childWindow->userFlags + MDI_ACTIVATE_CHILD)
				Add(childWindow);
		return S_CONTINUE;
	}

	switch(ccode)
	{

	case MDI_ADD_CHILD:
		{
		UI_WINDOW_OBJECT *oObject = Last();
		UI_REGION update;
		if (oObject)
			update = oObject->trueRegion;

		// Create a unique ID and title for the new child window.
		static UIF_FLAGS childID = 4;  // 3 initial children + 1.
		ZIL_ICHAR title[32];
		sprintf(title, "MDI Child %d", childID);

		// Load the default MDI child window.	
		MDI_CHILD_WINDOW *window =
			new MDI_CHILD_WINDOW("p_mdi.dat~MDI_CHILD", childID);
		window->Information(I_SET_TEXT, title);
		Add(window);

		// Create the window menu item for the new child window.
		EVENT_TYPE menuValue = childID + MDI_ACTIVATE_CHILD;
		UIW_POP_UP_ITEM *newItem =	new UIW_POP_UP_ITEM(title,	MNIF_SEND_MESSAGE,
			BTF_NO_3D, WOF_NO_FLAGS, ZIL_NULLF(ZIL_USER_FUNCTION), menuValue);
		newItem->userFlags = childID++;

		// Add the new menu item to the 'Window' menu.
		UI_EVENT addEvent(S_ADD_OBJECT);
		addEvent.windowObject =	newItem;
		windowMenu->Event(addEvent);

		// Redisplay the new added MDI child window.
		if (oObject)
			Event(UI_EVENT(S_DISPLAY_INACTIVE, 0, update));
		Event(UI_EVENT(S_DISPLAY_ACTIVE, 0, window->trueRegion));
		}
		break;

	case MDI_REMOVE_CHILD:
	case MDI_UPDATE_MENU:
		{
		UI_WINDOW_OBJECT *mdiChild;
			if (ccode == MDI_REMOVE_CHILD)
			mdiChild = Last();
		else
			mdiChild = event.windowObject;

		if (!mdiChild)
			break;

		UI_WINDOW_OBJECT *menuItem;
		windowMenu->Information(I_GET_FIRST, &menuItem);

		// Find the menu item associated with the window to remove.
		for(; menuItem; menuItem = menuItem->Next())
		{
			EVENT_TYPE value;
			menuItem->Information(I_GET_VALUE, &value);

			if (value == mdiChild->userFlags + MDI_ACTIVATE_CHILD)
			{
				// Subtract the menu item from the 'Window' menu.
				UI_EVENT sEvent(S_SUBTRACT_OBJECT);
				sEvent.windowObject = menuItem;
				windowMenu->Event(sEvent);
				delete menuItem;
				break;
			}
		}

		//	Remove the active MDI child.
		if (ccode == MDI_REMOVE_CHILD)
			eventManager->Put(UI_EVENT(S_CLOSE + S_MDICHILD_EVENT));
		}
		break;

	case MDI_PROGRAM_HELP:
		helpSystem->DisplayHelp(windowManager, MDI_HELP);
		break;

	case MDI_ABOUT_HELP:
		windowManager->Add(new UIW_WINDOW("p_mdi.dat~ABOUT"));
		break;

	default:
		ccode = UIW_WINDOW::Event(event);
	}

	return ccode;
}

MDI_CHILD_WINDOW::MDI_CHILD_WINDOW(const ZIL_ICHAR *name,
	UIF_FLAGS _userFlags) : UIW_WINDOW(name)
{
	userFlags = _userFlags;
}

EVENT_TYPE MDI_CHILD_WINDOW::Event(const UI_EVENT &event)
{
	EVENT_TYPE ccode = event.type;
	switch(ccode)
	{

	case S_DEINITIALIZE:
		{
		UI_EVENT tEvent;
		tEvent.type = MDI_UPDATE_MENU;
		tEvent.windowObject = this;
		if (parent)
			parent->Event(tEvent);
		else
			eventManager->Put(tEvent);
		}
		// Continue..

	default:
		ccode = UIW_WINDOW::Event(event);
	}

	return ccode;
}



// --------------------------------------------------------------------------
// Designer generated code.
// --------------------------------------------------------------------------
#if defined(ZIL_LINKBUG)
void z_jump_dummy(void) { }   // Bug fix for broken linkers.
#endif

static UI_ITEM _userTable[] =
{
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
	{ ID_PROMPT, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_PROMPT::New), UIW_PROMPT::_className, 0 },
	{ ID_PULL_DOWN_ITEM, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_PULL_DOWN_ITEM::New), UIW_PULL_DOWN_ITEM::_className, 0 },
	{ ID_PULL_DOWN_MENU, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_PULL_DOWN_MENU::New), UIW_PULL_DOWN_MENU::_className, 0 },
	{ ID_SCROLL_BAR, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_SCROLL_BAR::New), UIW_SCROLL_BAR::_className, 0 },
	{ ID_SYSTEM_BUTTON, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_SYSTEM_BUTTON::New), UIW_SYSTEM_BUTTON::_className, 0 },
	{ ID_TITLE, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_TITLE::New), UIW_TITLE::_className, 0 },
	{ ID_WINDOW, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_WINDOW::New), UIW_WINDOW::_className, 0 },
	{ ID_END, ZIL_NULLP(void), ZIL_NULLP(ZIL_ICHAR), 0 }
};
UI_ITEM *UI_WINDOW_OBJECT::objectTable = _objectTable;
