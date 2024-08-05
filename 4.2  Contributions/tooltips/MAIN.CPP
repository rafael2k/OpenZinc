#include <ui_win.hpp>
#include <stdio.h>
#include "manager.hpp"
#define USE_MESSAGE_TABLE
#include "p_main.hpp"

class WINDOW : public UIW_WINDOW
{
public:
	WINDOW();
	virtual ~WINDOW();
	virtual EVENT_TYPE Event(const UI_EVENT &event);

protected:
	UI_WINDOW_OBJECT *CheckOverlap(void);
	UI_POSITION lastMousePos;
	ZIL_LANGUAGE *nameMsgTable;
	UI_WINDOW_OBJECT *prevObj;
	UI_WINDOW_OBJECT *statusString;
	UIW_TOOL_BAR *toolBar;
};

WINDOW::WINDOW() : UIW_WINDOW("p_main.dat~WINDOW")
{
	nameMsgTable = new ZIL_LANGUAGE("MESSAGE_TABLE", UI_WINDOW_OBJECT::defaultStorage);
	statusString = Get("STATUS_STRING");
	toolBar = (UIW_TOOL_BAR *)Get("TOOL_BAR");

	windowManager->Center(this);
}

WINDOW::~WINDOW()
{
	delete nameMsgTable;
}

UI_WINDOW_OBJECT *WINDOW::CheckOverlap(void)
{
	UI_WINDOW_OBJECT *object;

 	for (object = toolBar->First(); object; object = object->Next())
		if (object->trueRegion.Overlap(lastMousePos))
			break;

	return(object);
}

EVENT_TYPE WINDOW::Event(const UI_EVENT &event)
{
	EVENT_TYPE ccode = event.type;
	switch(ccode)
	{
	case UPDATE_TOOLTIPS_HELP:
	{
		// Check to see if the mouse overlaps an object on the toolbar.
		UI_WINDOW_OBJECT *object = CheckOverlap();

		if (!object)
		{
			prevObj = ZIL_NULLP(UI_WINDOW_OBJECT);
			statusString->Information(I_SET_TEXT, "");
			break;
		}

		if (prevObj != object)
		{
			EVENT_TYPE objectValue;
			object->Information(I_GET_VALUE, &objectValue);
			ZIL_NUMBERID messageValue = objectValue - MESSAGE_MASK;

			// Load the status message.
			ZIL_ICHAR *statusMessage = nameMsgTable->GetMessage(messageValue);
			statusString->Information(I_SET_TEXT, statusMessage);
			prevObj = object;
		}
	}
	break;

	case UPDATE_MOUSE_INFO:
		lastMousePos = event.position;
	break;

	default:
		ccode = UIW_WINDOW::Event(event);
	}
	return (ccode);
}

UI_APPLICATION::Main()
{
	delete windowManager;
	windowManager = new WINDOW_MANAGER(display, eventManager);

	*eventManager + new UID_TIMER(D_ON, 250, TMR_QUEUE_EVENTS);

	UI_WINDOW_OBJECT::defaultStorage = new ZIL_STORAGE_READ_ONLY("p_main.dat");

	WINDOW *win = new WINDOW;

	*windowManager + win;

	Control();

	delete UI_WINDOW_OBJECT::defaultStorage;
	return (0);
}
