//	MACRO.CPP (MACRO) - Macro tutorial program.
//	COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//  May be freely copied, used and distributed.

#define USE_RAW_KEYS
#include <ui_win.hpp>
#include "macro.hpp"

EVENT_TYPE MACRO_HANDLER::Event(const UI_EVENT &)
{
	// Return the device state.
	return (state);
}

void MACRO_HANDLER::Poll(void)
{
	// See if any events are in the event manager's input queue.
	UI_EVENT event;
	static int emptyQueue = TRUE;
	if (emptyQueue)
		emptyQueue = eventManager->Get(event, Q_BEGIN | Q_NO_DESTROY | Q_NO_BLOCK | Q_NO_POLL);

	// Check for environment specific keyboard events.
#if defined(ZIL_MSWINDOWS)
	if (!emptyQueue && event.type == E_MSWINDOWS && event.message.message == WM_KEYDOWN)
	{
		event.type = E_KEY;
		event.rawCode = event.message.wParam;
	}
#elif defined(ZIL_OS2)
	if (!emptyQueue && event.type == E_OS2 && event.message.msg == WM_CHAR
		&& !FlagSet(LOWORD(event.message.mp1), KC_KEYUP))
	{
		event.type = E_KEY;
	}
#elif defined(ZIL_MOTIF)
	if (!emptyQueue && event.type == E_MOTIF && event.message.type == KeyPress)
		event.type = E_KEY;
#elif defined(ZIL_MACINTOSH)
	if (!emptyQueue && event.type == E_MACINTOSH && event.message.what == keyDown)
		event.type = E_KEY;
#elif defined(ZIL_NEXTSTEP)
	if (!emptyQueue && event.type == E_NEXTSTEP && event.message.type == NX_KEYDOWN)
		event.type = E_KEY;
#endif

	// See if the event is a macro key.
	if (state == D_OFF && !emptyQueue && event.type == E_KEY)
	{
		for (int i = 0; macroTable[i].rawCode && !emptyQueue; i++)
			if (event.rawCode == macroTable[i].rawCode)
			{
				// Turn off all other devices while we feed the macro.
				eventManager->DeviceState(E_DEVICE, D_OFF);
				eventManager->Get(event, Q_BEGIN | Q_NO_POLL);
				currentMacro = &macroTable[i];
				offset = 0;
				state = D_ON;
				// Set emptyQueue to be TRUE so we go to the next step.
				emptyQueue = TRUE;
				break;
			}
	}
	else
		emptyQueue = TRUE;

	// Put macro information into the input queue.
	if (state == D_ON && emptyQueue)
	{
		event.type = E_KEY;
		event.rawCode = currentMacro->macro[offset];
		event.key.value = currentMacro->macro[offset];
		event.key.shiftState = 0;
		eventManager->Put(event, Q_END);
		if (!currentMacro->macro[++offset])
		{
			eventManager->DeviceState(E_DEVICE, D_ON);
			state = D_OFF;
		}
	}
}

int UI_APPLICATION::Main(void)
{
	// The UI_APPLICATION constructor automatically initializes the 
	// display, eventManager, and windowManager variables.

	// This line fixes linkers that don't look for main in the .LIBs.
	UI_APPLICATION::LinkMain();

	// Initialize the macro handler.
	static MACRO_PAIR macroTable[] =
	{
		{ F5, "Macro #1." },
		{ F6, "Macro #2." },
		{ F7, "Macro #3." },
		{ F8, "Macro #4." },
		{ 0, ZIL_NULLP(ZIL_ICHAR) }
	};
	
	*eventManager
		+ new MACRO_HANDLER(macroTable);
	
	// Add a generic window with a textfield to the window manager.
	*windowManager
		+ &(*UIW_WINDOW::Generic(10, 5, 50, 10, "Text Window")
			+ &(*new UIW_TEXT(0, 0, 0, 0, "", 10240, WNF_NO_FLAGS, WOF_NON_FIELD_REGION)
				+ new UIW_SCROLL_BAR(0, 0, 0, 0, SBF_VERTICAL)));

	// Process user responses.
	UI_APPLICATION::Control();

	return (0);
}
