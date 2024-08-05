//	PROGRESS.CPP
//	COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasent Grove, Utah USA
//	May be freely copied, used and distributed.

#include <ui_win.hpp>
#include "progress.hpp"

int UI_APPLICATION::Main(void)
{
	LinkMain();
	
	MY_WINDOW *window = new MY_WINDOW(0, 0, 50, 7);
	*windowManager	+ window;

	Control();
	return (0);
}

MY_WINDOW::MY_WINDOW(int left, int top, int width, int height) :
	UIW_WINDOW(left, top, width, height)
{
	*this
		+ new UIW_BORDER
		+ new UIW_SYSTEM_BUTTON(SYF_GENERIC)
		+ new UIW_TITLE("Process Bar")
		+ new UIW_BUTTON(9, 4, 12, "&Start",
			BTF_NO_TOGGLE | BTF_AUTO_SIZE | BTF_SEND_MESSAGE,
			WOF_JUSTIFY_CENTER, ZIL_NULLF(ZIL_USER_FUNCTION),
			START_PROCESS)
		+ new UIW_BUTTON(28, 4, 12, "&Cancel",
			BTF_NO_TOGGLE | BTF_AUTO_SIZE | BTF_SEND_MESSAGE,
			WOF_JUSTIFY_CENTER, ZIL_NULLF(ZIL_USER_FUNCTION),
			CANCEL_PROCESS)
		+ (processBox = new PROCESS_BOX(50, 40, 245, 1));
	windowManager->Center(this);
}

EVENT_TYPE MY_WINDOW::Event(const UI_EVENT &event)
{
	EVENT_TYPE ccode = event.type;

	switch (ccode)
	{
	case START_PROCESS:
	case CANCEL_PROCESS:
		processBox->Event(event);
		break;

	default:
		ccode = UIW_WINDOW::Event(event);
		break;
	}
	return (ccode);
}

PROCESS_BOX::PROCESS_BOX(int left, int top, int width, int height) :
	UI_WINDOW_OBJECT(left, top, width, height, WOF_PIXEL, WOAF_NON_CURRENT)
{
	woStatus |= WOS_OWNERDRAW;
	halt = incrementor = 0;
	fullValue = 100;
	state = process = 1;
}

EVENT_TYPE PROCESS_BOX::Event(const UI_EVENT &event)
{
	EVENT_TYPE ccode = event.type;

	switch (ccode)
	{
	// Registers the class with the OS.
	case S_CREATE:
		ccode = UI_WINDOW_OBJECT::Event(event);
		RegisterObject("PROCESS_BOX");
		break;

	case START_PROCESS:
		if (state == process)
		{
			// Used to kill time.
			for (int k = 0; k < 32000; k++);
			incrementor++;

			UI_WINDOW_OBJECT::Event(UI_EVENT(S_DISPLAY_ACTIVE, 0, trueRegion));
			if (incrementor < fullValue)
				eventManager->Put(START_PROCESS);
			else
				state = halt;
		}
		break;

	case CANCEL_PROCESS:
		state = halt;
		break;

	default:
		ccode = UI_WINDOW_OBJECT::Event(event);
		break;
	}
	return (ccode);
}

EVENT_TYPE PROCESS_BOX::DrawItem(const UI_EVENT &, EVENT_TYPE)
{
	UI_REGION drawRegion = trueRegion;
	int completion;

	display->VirtualGet(screenID, drawRegion);

	display->Rectangle(screenID, drawRegion, &whitePalette);

	// Calculates the percentage value to add to the process box display.
	completion = (drawRegion.right - drawRegion.left) *
		(incrementor / fullValue);
	display->Rectangle(screenID, drawRegion.left, drawRegion.top,
		drawRegion.left + completion, drawRegion.bottom, &bluePalette,
		1, TRUE);

	display->VirtualPut(screenID);
	return (TRUE);
}
