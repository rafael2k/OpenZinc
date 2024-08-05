//	EVENT.CPP (ZINCAPP) - This file contains the "Event" options.
//	COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//  May be freely copied, used and distributed.

#include <stdio.h>
#include <ui_win.hpp>
#include "zincapp.hpp"

void CONTROL_WINDOW::OptionEvent(EVENT_TYPE)
{
	// Create the event monitor.
	*windowManager
		+ new EVENT_MONITOR;
}

EVENT_MONITOR::EVENT_MONITOR(void) :
	UIW_WINDOW(2, 1, 38, 9)
{
	userFlags = MSG_EVENT_MONITOR;
#if defined(ZIL_MSDOS)
	kEvent.type = mEvent.type = sEvent.type = 0;
	kEvent.rawCode = mEvent.rawCode = sEvent.rawCode = 0xFFFF;
	keyboard[0] = new UIW_PROMPT(14, 1, "");
	keyboard[1] = new UIW_PROMPT(21, 1, "");
	keyboard[2] = new UIW_PROMPT(26, 1, "");
	mouse[0] = new UIW_PROMPT(14, 3, "");
	mouse[1] = new UIW_PROMPT(21, 3, "");
	mouse[2] = new UIW_PROMPT(28, 3, "");
#elif defined(ZIL_MSWINDOWS)
	wMsg.message = wMsg.wParam = wMsg.pt.x = wMsg.pt.y = -1;
	wMsg.lParam = -1;
	windowsMessage[0] = new UIW_PROMPT(15, 1, "");
	windowsMessage[1] = new UIW_PROMPT(15, 2, "");
	windowsMessage[2] = new UIW_PROMPT(15, 3, "");
	windowsMessage[3] = new UIW_PROMPT(15, 4, "");
	windowsMessage[4] = new UIW_PROMPT(20, 4, "");
#elif defined(ZIL_OS2)
	oMsg.msg = oMsg.ptl.x = oMsg.ptl.y = -1;
	oMsg.mp1 = oMsg.mp2 = 0;
	windowsMessage[0] = new UIW_PROMPT(15, 1, "");
	windowsMessage[1] = new UIW_PROMPT(15, 2, "");
	windowsMessage[2] = new UIW_PROMPT(15, 3, "");
	windowsMessage[3] = new UIW_PROMPT(15, 4, "");
	windowsMessage[4] = new UIW_PROMPT(25, 4, "");
#elif defined(ZIL_MOTIF)
	xEvt.xany.type = -1;
	xEvt.xany.serial = 0;
	xEvt.xany.window = 0;
	motifMessage[0] = new UIW_PROMPT(15, 1, "");
	motifMessage[1] = new UIW_PROMPT(15, 2, "");
	motifMessage[2] = new UIW_PROMPT(15, 3, "");
#elif defined(ZIL_MACINTOSH)
	mEvent.what = nullEvent;
	mEvent.message = -1L;
	mEvent.modifiers = 0;
	mEvent.where.h = mEvent.where.v = -1;
	macintoshMessage[0] = new UIW_PROMPT(14, 1, "");
	macintoshMessage[1] = new UIW_PROMPT(14, 2, "");
	macintoshMessage[2] = new UIW_PROMPT(14, 3, "");
	macintoshMessage[3] = new UIW_PROMPT(14, 4, "");
	macintoshMessage[4] = new UIW_PROMPT(19, 4, "");
#endif
	system = new UIW_PROMPT(14, 5, "");

	// Attach the sub-window objects to the event monitor.
	*this
		+ new UIW_BORDER
		+ new UIW_MAXIMIZE_BUTTON
		+ new UIW_MINIMIZE_BUTTON
		+ new UIW_SYSTEM_BUTTON(SYF_GENERIC)
		+ new UIW_TITLE("Event monitor")
#if defined(ZIL_MSDOS)
		+ new UIW_PROMPT(2, 1, "Last key:")
		+ keyboard[0] + keyboard[1] + keyboard[2]
		+ new UIW_PROMPT(2, 3, "Last mouse:")
		+ mouse[0] + mouse[1] + mouse[2]
#elif defined(ZIL_MSWINDOWS)
		+ new UIW_PROMPT(2, 1, "Message:")
		+ windowsMessage[0]
		+ new UIW_PROMPT(2, 2, "wParam:")
		+ windowsMessage[1]
		+ new UIW_PROMPT(2, 3, "lParam:")
		+ windowsMessage[2]
		+ new UIW_PROMPT(2, 4, "Position:")
		+ windowsMessage[3] + windowsMessage[4]
#elif defined(ZIL_OS2)
		+ new UIW_PROMPT(2, 1, "Message:")
		+ windowsMessage[0]
		+ new UIW_PROMPT(2, 2, "mp1:")
		+ windowsMessage[1]
		+ new UIW_PROMPT(2, 3, "mp2:")
		+ windowsMessage[2]
		+ new UIW_PROMPT(2, 4, "Position:")
		+ windowsMessage[3] + windowsMessage[4]
#elif defined(ZIL_MOTIF)
		+ new UIW_PROMPT(2, 1, "Event:")
		+ motifMessage[0]
		+ new UIW_PROMPT(2, 2, "Serial:")
		+ motifMessage[1]
		+ new UIW_PROMPT(2, 3, "Window:")
		+ motifMessage[2]
#elif defined(ZIL_MACINTOSH)
		+ new UIW_PROMPT(2, 1, "What:")
		+ macintoshMessage[0]
		+ new UIW_PROMPT(2, 2, "Message:")
		+ macintoshMessage[1]
		+ new UIW_PROMPT(2, 3, "Modifiers:")
		+ macintoshMessage[2]
		+ new UIW_PROMPT(2, 4, "Position:")
		+ macintoshMessage[3] + macintoshMessage[4]
#endif
		+ new UIW_PROMPT(2, 5, "Last event:")
		+ system
		+ new UIW_ICON(0, 0, "minIcon", "Event Monitor", ICF_MINIMIZE_OBJECT);
}

EVENT_TYPE EVENT_MONITOR::Event(const UI_EVENT &event)
{
	// Declare the event type/name pairs.
	static struct EVENT_PAIR
	{
		ZIL_LOGICAL_EVENT type;
		ZIL_ICHAR *name;
	} eventTable[] =
	{
		// Raw events.
		{ E_MSWINDOWS,			"MSWindows" },
		{ E_OS2,				"OS/2" },
		{ E_MOTIF,				"Motif" },
		{ E_MACINTOSH,			"Macintosh" },
		{ E_NEXTSTEP,			"NEXTSTEP" },
		{ E_KEY,				"Key" },
		{ E_MOUSE,				"Mouse" },
		{ E_CURSOR,				"Cursor" },

		// System events.
		{ S_ERROR,				"Error" },
		{ S_UNKNOWN,			"Unmapped Event" },
		{ S_NO_OBJECT,			"No Object" },
		{ S_MINIMIZE,			"Minimize" },
		{ S_MAXIMIZE,			"Maximize" },
		{ S_ALT_KEY,			"<Alt>" },
		{ S_CONTINUE,			"Continue" },
		{ S_INITIALIZE,			"Initialize" },
		{ S_CREATE,				"Create" },
		{ S_CLOSE,				"Close" },
		{ S_NON_CURRENT,		"Non-Current" },
		{ S_MOVE,				"Move" },
		{ S_REDISPLAY,			"Redisplay" },
		{ S_CLOSE_TEMPORARY,	"Close Temporary" },
		{ S_DEINITIALIZE,		"Deinitialize" },
		{ S_REGION_DEFINE,		"Region Define" },
		{ S_CASCADE,			"Cascade" },
		{ S_RESTORE,			"Restore" },
		{ S_REGISTER_OBJECT,	"Register Object" },

		{ S_POSITION,			"Position" },

		{ S_SIZE,				"Size" },
		{ S_CHANGED,			"Changed" },
		{ S_DISPLAY_ACTIVE,		"Display Active" },
		{ S_DISPLAY_INACTIVE,	"Display Inactive" },
		{ S_CURRENT,			"Current" },

		{ S_VSCROLL,			"Scroll Vertical" },
		{ S_HSCROLL,			"Scroll Horizontal" },
		{ S_VSCROLL_SET,		"Scroll Vertical Set" },
		{ S_HSCROLL_SET,		"Scroll Horizontal Set" },
		{ S_VSCROLL_CHECK,		"Scroll Vertical Check" },
		{ S_HSCROLL_CHECK,		"Scroll Horizontal Check" },

		{ S_ADD_OBJECT,			"Add Object" },
		{ S_SUBTRACT_OBJECT,	"Subtract Object" },
		{ S_OPEN_DOCUMENT,		"Open Document" },
		{ S_PRINT_DOCUMENT,		"Print Document" },
		{ S_RESET_DISPLAY,		"Reset Display" },

		// Logical events.
		{ L_EXIT,				"Exit" },
		{ L_VIEW,				"View" },
		{ L_SELECT,				"Select" },
		{ L_BEGIN_SELECT,		"Begin Select" },
		{ L_CONTINUE_SELECT,	"Continue Select" },
		{ L_END_SELECT,			"End Select" },
		{ L_BEGIN_ESCAPE,		"Begin Escape" },
		{ L_CONTINUE_ESCAPE,	"Continue Escape" },
		{ L_END_ESCAPE,			"End Escape" },
		{ L_HELP,				"Help" },
		{ L_CANCEL,				"Cancel" },
		{ L_EXIT_FUNCTION,		"Exit Function" },
		{ L_DOUBLE_CLICK,		"Double-Click" },
		{ L_MOVE,				"Move" },
		{ L_SIZE,				"Size" },

		{ L_NEXT_WINDOW,		"Next Window" },

		{ L_UP,					"Up" },
		{ L_DOWN,				"Down" },
		{ L_LEFT,				"Left" },
		{ L_RIGHT,				"Right" },
		{ L_PREVIOUS,			"Previous" },
		{ L_NEXT,				"Next" },
		{ L_FIRST,				"First" },
		{ L_TOP,				"Top" },
		{ L_LAST,				"Last" },
		{ L_BOTTOM,				"Bottom" },
		{ L_PGUP,				"Page Up" },
		{ L_PGDN,				"Page Down" },

		{ L_BEGIN_MARK,			"Begin Mark" },
		{ L_CONTINUE_MARK,		"Continue Mark" },
		{ L_END_MARK,			"End Mark" },
		{ L_CUT,				"Cut" },
		{ L_PASTE,				"Paste" },
		{ L_CUT_PASTE,			"Cut/Paste" },
		{ L_MARK,				"Mark" },
		{ L_COPY_MARK,			"Copy" },
		{ L_DELETE,				"Delete" },
		{ L_DELETE_WORD,		"Delete Word" },
		{ L_DELETE_EOL,			"Delete to End of Line" },
		{ L_INSERT_TOGGLE,		"Insert Toggle" },
		{ L_WORD_LEFT,			"Word Left" },
		{ L_WORD_RIGHT,			"Word Right" },
		{ L_BOL,				"Beginning of Line" },
		{ L_EOL,				"End of Line" },
		{ L_BACKSPACE,			"Backspace" },

		{ L_CANCEL,				"Cancel" },
		{ S_CASCADE,			"Cascade Windows" },
		{ L_RESTORE,			"Restore" },
		{ L_MOVE,				"Move" },
		{ L_SIZE,				"Size" },

		{ 0, 0 } // End of array.
	};

	// See if it is a normal event.
	if (event.rawCode != 0xFFFF)
		return (UIW_WINDOW::Event(event));

	// Check for new keyboard event.
	UI_EVENT *tEvent = (UI_EVENT *)event.data;
#if defined(ZIL_MSDOS)
	if (tEvent->type == E_KEY)
	{
		ZIL_ICHAR string[32];
		if (kEvent.rawCode != tEvent->rawCode)
		{
			sprintf(string, "%04x", tEvent->rawCode);
			keyboard[0]->Information(I_SET_TEXT, string);
		}
		if (kEvent.key.shiftState != tEvent->key.shiftState)
		{
			sprintf(string, "%02x", tEvent->key.shiftState);
			keyboard[1]->Information(I_SET_TEXT, string);
		}
		if (kEvent.key.value != tEvent->key.value)
		{
			sprintf(string, "%c", tEvent->key.value);
			keyboard[2]->Information(I_SET_TEXT, string);
		}
		kEvent = *tEvent;
	}

	// Check for new mouse event.
	else if (tEvent->type == E_MOUSE)
	{
		ZIL_ICHAR string[32];
		if (mEvent.rawCode != tEvent->rawCode)
		{
			sprintf(string, "%04x", tEvent->rawCode);
			mouse[0]->Information(I_SET_TEXT, string);
		}
		if (mEvent.position.column != tEvent->position.column)
		{
			sprintf(string, "%03d", tEvent->position.column);
			mouse[1]->Information(I_SET_TEXT, string);
		}
		if (mEvent.position.line != tEvent->position.line)
		{
			sprintf(string, "%03d", tEvent->position.line);
			mouse[2]->Information(I_SET_TEXT, string);
		}
		mEvent = *tEvent;
	}
#elif defined(ZIL_MSWINDOWS)
	if (tEvent->type == E_MSWINDOWS && tEvent->message.message != WM_PAINT)
	{
		MSG msg = tEvent->message;
		ZIL_ICHAR string[32];
		if (wMsg.message != msg.message)
		{
			sprintf(string, "%04x", msg.message);
			windowsMessage[0]->Information(I_SET_TEXT, string);
		}
		if (wMsg.wParam != msg.wParam)
		{
			sprintf(string, "%04x", msg.wParam);
			windowsMessage[1]->Information(I_SET_TEXT, string);
		}
		if (wMsg.lParam != msg.lParam)
		{
			sprintf(string, "%08x", msg.lParam);
			windowsMessage[2]->Information(I_SET_TEXT, string);
		}
		if (wMsg.pt.x != msg.pt.x)
		{
			sprintf(string, "%d", msg.pt.x);
			windowsMessage[3]->Information(I_SET_TEXT, string);
		}
		if (wMsg.pt.y != msg.pt.y)
		{
			sprintf(string, "%d", msg.pt.y);
			windowsMessage[4]->Information(I_SET_TEXT, string);
		}
		wMsg = msg;
	}
#elif defined(ZIL_OS2)
	if (tEvent->type == E_OS2 && tEvent->message.msg != WM_PAINT)
	{
		QMSG msg = tEvent->message;
		ZIL_ICHAR string[32];
		if (oMsg.msg != msg.msg)
		{
			sprintf(string, "%04x", msg.msg);
			windowsMessage[0]->Information(I_SET_TEXT, string);
		}
		if (oMsg.mp1 != msg.mp1)
		{
			sprintf(string, "%08lx", msg.mp1);
			windowsMessage[1]->Information(I_SET_TEXT, string);
		}
		if (oMsg.mp2 != msg.mp2)
		{
			sprintf(string, "%08lx", msg.mp2);
			windowsMessage[2]->Information(I_SET_TEXT, string);
		}
		if (oMsg.ptl.x != msg.ptl.x)
		{
			sprintf(string, "%d", msg.ptl.x);
			windowsMessage[3]->Information(I_SET_TEXT, string);
		}
		if (oMsg.ptl.y != msg.ptl.y)
		{
			sprintf(string, "%d", msg.ptl.y);
			windowsMessage[4]->Information(I_SET_TEXT, string);
		}
		oMsg = msg;
	}
#elif defined(ZIL_MOTIF)
	if (tEvent->type == E_MOTIF && tEvent->message.type != Expose
			&& tEvent->message.type != DestroyNotify
			&& tEvent->message.type != UnmapNotify
			&& tEvent->message.type != MapNotify)
	{
		XEvent msg = tEvent->message;
		ZIL_ICHAR string[32];
		if (xEvt.type != msg.type)
		{
			sprintf(string, "%02x", msg.type);
			motifMessage[0]->Information(I_SET_TEXT, string);
		}
		if (xEvt.xany.serial != msg.xany.serial)
		{
			sprintf(string, "%08lx", msg.xany.serial);
			motifMessage[1]->Information(I_SET_TEXT, string);
		}
		if (xEvt.xany.window != msg.xany.window)
		{
			sprintf(string, "%08x", msg.xany.window);
			motifMessage[2]->Information(I_SET_TEXT, string);
		}
		xEvt = msg;
	}
#elif defined(ZIL_MACINTOSH)
	if (tEvent->type == L_VIEW ||
		(tEvent->type == E_MACINTOSH && tEvent->message.what == updateEvt))
	{
		sEvent = *tEvent;
		return (event.type);
	}
	else if (tEvent->type == E_MACINTOSH)
	{
		EventRecord msg = tEvent->message;
		ZIL_ICHAR string[32];
		if (mEvent.what != msg.what)
		{
			sprintf(string, "%d", msg.what);
			macintoshMessage[0]->Information(I_SET_TEXT, string);
		}
		if (mEvent.message != msg.message)
		{
			sprintf(string, "%08lx", msg.message);
			macintoshMessage[1]->Information(I_SET_TEXT, string);
		}
		if (mEvent.modifiers != msg.modifiers)
		{
			sprintf(string, "%02x", msg.modifiers);
			macintoshMessage[2]->Information(I_SET_TEXT, string);
		}
		if (mEvent.where.h != msg.where.h)
		{
			sprintf(string, "%d", msg.where.h);
			macintoshMessage[3]->Information(I_SET_TEXT, string);
		}
		if (mEvent.where.v != msg.where.v)
		{
			sprintf(string, "%d", msg.where.v);
			macintoshMessage[4]->Information(I_SET_TEXT, string);
		}
		mEvent = msg;
	}
#endif

	// Check for new logical event.
	if (sEvent.type != event.type)
	{
		ZIL_ICHAR *name = "<Unknown>";
		for (int i = 0; eventTable[i].type; i++)
			if (tEvent->type == eventTable[i].type)
			{
				name = eventTable[i].name;
				break;
			}
		system->Information(I_SET_TEXT, name);
		sEvent = *tEvent;
	}

	// Return the logical event.
	return (event.type);
}
