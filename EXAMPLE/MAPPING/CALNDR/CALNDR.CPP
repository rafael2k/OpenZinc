//	CALENDAR.CPP (CALENDAR) - Calendar example.
//	COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//  May be freely copied, used and distributed.


#define USE_RAW_KEYS
#define USE_HELP_CONTEXTS
#if !defined(__MWERKS__)
extern "C"
{
#endif
	#include <string.h>
#if !defined(__MWERKS__)
}
#endif
#include <ui_win.hpp>

#include "calndr.hpp"

// ----- UI_APPLICATION::Main -----------------------------------------------

int UI_APPLICATION::Main(void)
{
	// The UI_APPLICATION constructor automatically initializes the 
	// display, eventManager, and windowManager variables.

	// This line fixes linkers that don't look for main in the .LIBs.
	UI_APPLICATION::LinkMain();

	UI_WINDOW_OBJECT::defaultStorage = new ZIL_STORAGE_READ_ONLY("p_calndr.dat");

	// Check to see if the default storage was allocated.
	if (UI_WINDOW_OBJECT::defaultStorage->storageError)
	{
		delete UI_WINDOW_OBJECT::defaultStorage;
		return(-1);
	}

	// Initialize the help system.
	UI_WINDOW_OBJECT::helpSystem = new UI_HELP_SYSTEM("p_calndr.dat", windowManager, GENERAL_HELP);

	// Create and present the calendar window.
	CALENDAR *calendar = new CALENDAR;
	windowManager->Center(calendar);
	*windowManager + calendar;
	windowManager->screenID = calendar->screenID;

	// Process user responses.
	UI_APPLICATION::Control();

	// Clean up.
	delete UI_WINDOW_OBJECT::helpSystem;
	delete UI_WINDOW_OBJECT::defaultStorage;

	return (0);
}

// ----- DAYS_OF_MONTH ------------------------------------------------------


DAYS_OF_MONTH::DAYS_OF_MONTH(void) :
	UI_WINDOW_OBJECT(0, 0, 0, 0, WOF_NON_FIELD_REGION | WOF_NON_SELECTABLE, WOAF_NO_FLAGS)
{
	woStatus |= WOS_OWNERDRAW;
}

EVENT_TYPE DAYS_OF_MONTH::Event(const UI_EVENT &event)
{
	// Default to the base class event.
	EVENT_TYPE ccode = UI_WINDOW_OBJECT::Event(event);

	// Check for a create or size message.
	if (event.type == S_CREATE || event.type == S_CHANGED)
	{
		// Determine the month table coordinates.
		trueRegion -= display->cellWidth; 
		xLength = trueRegion.Width();
		yLength = trueRegion.Height() - display->cellHeight;

		// Register the object with operating system's API.
		if (event.type == S_CREATE)
			RegisterObject("DAYS_OF_MONTH");
	}

	// Return the control code.
	return (ccode);
}

EVENT_TYPE DAYS_OF_MONTH::DrawItem(const UI_EVENT &, EVENT_TYPE )
{
    // Get the current day.
	int year, month, currentDay;
	date.Export(&year, &month, &currentDay);

	// Find the starting day.
	date.Import(year, month, 1);
	int startingDay = date.DayOfWeek();

	// Set the date information.
	date.Import(year, month, currentDay);
   	int monthDays = date.DaysInMonth();
	int weeksInMonth = (startingDay + monthDays - 1) / 7;
	if ((startingDay + monthDays - 1) % 7)
		weeksInMonth++;
	 
	// Change the cellWidth and cellHeight values.
   	int cellWidth = xLength / 7;
   	int cellHeight = (yLength - 1) / weeksInMonth;
   	if (cellHeight == 0)
   		cellHeight++;

   	int i, top = 1;
	int left = startingDay;

	// Compute the calendar region (center of the window).
	UI_REGION region = trueRegion;
   	int offset = (region.right - region.left) % 7;
	if (!display->isText)
	{
   		region.left += offset / 2;
   		region.right -= offset / 2;
	}
	region.top += display->cellHeight;
	if (!display->isText)
	{
   		offset = (region.bottom - region.top) % 7;
		region.top += offset / 2;
		region.bottom -= offset /2;
	}

	// Virtualize the display.
	display->VirtualGet(screenID, trueRegion);

	// Draw the calendar grid.
	display->Rectangle(screenID, trueRegion, &whitePalette, 1, TRUE);
	if (yLength > weeksInMonth + 1 && xLength >= 28)
		display->Rectangle(screenID, region, &linePalette);
    if (!display->isText)
	{
   		for (int line = region.top, y = 1; y < weeksInMonth; ++y)
			display->Line(screenID, region.left, line + cellHeight * y, region.right, line + cellHeight * y, &linePalette);
   		for (int column = region.left, x = 1; x < 7; ++x)
			display->Line(screenID, column + x * cellWidth, region.top, column + x* cellWidth, region.bottom, &linePalette);
	}
	else if (yLength <= weeksInMonth)
		region.top--;

	// Draw the days of the week.
	int middle = cellWidth / 2;
	for (i = 0; i < 7; i++)
	{
		const ZIL_LANGUAGE *myLanguage = ZIL_LANGUAGE_MANAGER::UseLanguage(ZIL_UTIME::_dayName);
		ZIL_ICHAR *string = myLanguage->GetMessage(i + ZIL_SHDAY_1);
		int column = region.left + i * cellWidth + middle - display->TextWidth(string) / 2 + 1;
		int line = region.top - display->TextHeight(string);
		display->Text(screenID, column, line, string, &linePalette, -1, FALSE, FALSE, &clip);
	}

	// Print the days of the month.
	char string[3];
	for (i = 1; i <= monthDays; i++)
	{
		ZIL_DATE today;
		itoa(i, string, 10);
		int column = region.left + left * cellWidth - middle - display->TextWidth(string) / 2;
		int line = region.top + top * cellHeight - cellHeight / 2 - display->TextHeight(string) / 2;
		if (date == today && i == currentDay)
			display->Text(screenID, column, line, string, &currentPalette, -1, FALSE, FALSE, &clip);
		else
			display->Text(screenID, column, line, string, &dayPalette, -1, FALSE, FALSE, &clip);
		if (left % 7 == 0)
		{
			left = 1;
			top++;
		}
		else
			left++;
	}

	// Restore the display.
	display->VirtualPut(screenID);
	return (TRUE);
}

EVENT_TYPE Message(UI_WINDOW_OBJECT *object, UI_EVENT &, EVENT_TYPE ccode)
{
	// Check for a user select.
	if (ccode != L_SELECT)
		return (0);

	// Send a message to either close the window or retreive a new date.
	EVENT_TYPE value;
	object->Information(I_GET_VALUE, &value);
	if (value == L_CURRENT_MONTH)
	{
		object->eventManager->Put(S_CLOSE);
		object->eventManager->Put(L_CURRENT_MONTH);
	}
	else
		object->eventManager->Put(value);
	return (S_CONTINUE);
}

// ----- CALENDAR -----------------------------------------------------------

UI_EVENT_MAP CALENDAR::calendarEvent[] =
{
#if defined(ZIL_MSDOS)
	{ ID_CALENDAR,	L_NEW_MONTH,		E_KEY, 		F2 },
   	{ ID_CALENDAR,	L_PREVIOUS_MONTH,	E_KEY, 		WHITE_PGUP },
	{ ID_CALENDAR,	L_PREVIOUS_MONTH,	E_KEY, 		GRAY_PGUP },
	{ ID_CALENDAR,	L_NEXT_MONTH,		E_KEY, 		GRAY_PGDN },
	{ ID_CALENDAR,	L_NEXT_MONTH,		E_KEY, 		WHITE_PGDN },
#elif defined(ZIL_MSWINDOWS)
	{ ID_CALENDAR,	L_NEW_MONTH,		WM_KEYDOWN,	F2 },
   	{ ID_CALENDAR,	L_PREVIOUS_MONTH,	WM_KEYDOWN, WHITE_PGUP },
	{ ID_CALENDAR,	L_PREVIOUS_MONTH,	WM_KEYDOWN, GRAY_PGUP },
	{ ID_CALENDAR,	L_NEXT_MONTH,		WM_KEYDOWN, GRAY_PGDN },
	{ ID_CALENDAR,	L_NEXT_MONTH,		WM_KEYDOWN, WHITE_PGDN },
#elif defined(ZIL_OS2)
	{ ID_CALENDAR,	L_NEW_MONTH,		WM_CHAR,	F2,			KC_KEYUP },
   	{ ID_CALENDAR,	L_PREVIOUS_MONTH,	WM_CHAR,    WHITE_PGUP,	KC_KEYUP },
	{ ID_CALENDAR,	L_PREVIOUS_MONTH,	WM_CHAR,    GRAY_PGUP,	KC_KEYUP },
	{ ID_CALENDAR,	L_NEXT_MONTH,		WM_CHAR,    GRAY_PGDN,	KC_KEYUP },
	{ ID_CALENDAR,	L_NEXT_MONTH,		WM_CHAR,    WHITE_PGDN,	KC_KEYUP },
#elif defined(ZIL_MOTIF)
	{ ID_CALENDAR,	L_NEW_MONTH,		KeyPress,	F2 },
#elif defined(ZIL_CURSES)
	{ ID_CALENDAR,	L_NEW_MONTH,		E_KEY, 		F2 },
   	{ ID_CALENDAR,	L_PREVIOUS_MONTH,	E_KEY, 		KEY_PPAGE },
	{ ID_CALENDAR,	L_NEXT_MONTH,		E_KEY, 		KEY_NPAGE },
#elif defined(ZIL_MACINTOSH)
	{ ID_CALENDAR,	L_NEW_MONTH,		keyDown, 	F2 },
   	{ ID_CALENDAR,	L_PREVIOUS_MONTH,	keyDown, 	GRAY_PGUP },
   	{ ID_CALENDAR,	L_PREVIOUS_MONTH,	keyDown, 	WHITE_PGUP },
	{ ID_CALENDAR,	L_NEXT_MONTH,		keyDown, 	GRAY_PGDN },
	{ ID_CALENDAR,	L_NEXT_MONTH,		keyDown, 	WHITE_PGDN },
#endif

	// End of array.
	{ ID_END, 0, 0, 0 }
};

CALENDAR::CALENDAR(void) :
	UIW_WINDOW(0, 0, 60, 16, WOF_NO_FLAGS, WOAF_NO_FLAGS, CALENDAR_HELP)
{
	// Assign IDs for both a calendar and window.
	windowID[0] = ID_CALENDAR;
	windowID[1] = ID_WINDOW;


	// Create and set the days-of-month object.
	const ZIL_LANGUAGE *myLanguage = ZIL_LANGUAGE_MANAGER::UseLanguage(ZIL_UTIME::_monthName);
	static char dateString[20];
	date.Export(&year, &month, &day, 0);
	sprintf(dateString, "%s %d", myLanguage->GetMessage(month - 1 + ZIL_MON_1), year);
	daysOfMonth = new DAYS_OF_MONTH;
	daysOfMonth->date = date;

	// Create the calendar title.
	calendarTitle = new UIW_TITLE(dateString, WOF_JUSTIFY_CENTER);

	// Attach all the objects to the window.
	*this
		+ new UIW_BORDER
		+ new UIW_MAXIMIZE_BUTTON
		+ new UIW_MINIMIZE_BUTTON
		+ new UIW_SYSTEM_BUTTON(SYF_GENERIC)
  		+ calendarTitle
		+ &(*new UIW_PULL_DOWN_MENU
			+ &(*new UIW_PULL_DOWN_ITEM("&Calendar")
				+ new UIW_POP_UP_ITEM("&View", MNIF_NO_FLAGS, BTF_NO_3D, WOF_NO_FLAGS, Message, L_NEW_MONTH)
				+ new UIW_POP_UP_ITEM("&Next", MNIF_NO_FLAGS, BTF_NO_3D, WOF_NO_FLAGS, Message, L_NEXT_MONTH)
				+ new UIW_POP_UP_ITEM("&Previous", MNIF_NO_FLAGS, BTF_NO_3D, WOF_NO_FLAGS, Message, L_PREVIOUS_MONTH)
		  		+ new UIW_POP_UP_ITEM("&Help", MNIF_NO_FLAGS, BTF_NO_3D, WOF_NO_FLAGS, Message, L_HELP)
				+ new UIW_POP_UP_ITEM("", MNIF_SEPARATOR)
				+ new UIW_POP_UP_ITEM("&Exit", MNIF_SEND_MESSAGE, BTF_NO_3D, WOF_NO_FLAGS, ZIL_NULLF(ZIL_USER_FUNCTION), L_EXIT)))
		+ daysOfMonth
		+ new UIW_ICON (0, 0, "CALNDR", "Calendar", ICF_MINIMIZE_OBJECT, WOF_NO_FLAGS);
}

EVENT_TYPE CALENDAR::Event(const UI_EVENT &event)
{
	// Switch on the event type.
	EVENT_TYPE ccode = UI_EVENT_MAP::MapEvent(calendarEvent, event, ID_CALENDAR);
	switch (ccode)
	{
	case L_NEW_MONTH:
		{
		int windowHeight = display->isText ? 7 : 6;
		UIW_WINDOW *window = new UIW_WINDOW(0, 0, 30, windowHeight, WOF_BORDER, WOAF_MODAL);
		*window
			+ new UIW_BORDER
			+ new UIW_TITLE("View Month")
			+ new UIW_PROMPT(2, 1, "New Date: ")
			+ new UIW_DATE(12, 1, 15, &date, "1700-1-1..", DTF_NO_FLAGS,
				WOF_NO_ALLOCATE_DATA | WOF_AUTO_CLEAR | WOF_BORDER)
			+ new UIW_BUTTON(3, 3, 8, "&OK", BTF_NO_TOGGLE | BTF_DEFAULT_BUTTON,
				WOF_JUSTIFY_CENTER, Message, L_CURRENT_MONTH)
			+ new UIW_BUTTON(18, 3, 8, "&Cancel", BTF_NO_TOGGLE | BTF_SEND_MESSAGE,
				WOF_JUSTIFY_CENTER, ZIL_NULLF(ZIL_USER_FUNCTION), S_CLOSE);
		windowManager->Center(window);
		windowManager->Add(window);
		}
		break;

	case L_NEXT_MONTH:
	case L_PREVIOUS_MONTH:
		if (ccode == L_NEXT_MONTH && (++month > 12))
		{
			month = 1;
			++year;
		}
		else if (ccode == L_PREVIOUS_MONTH && (--month < 1))
		{
			month = 12;
			--year;
		}
		date.Import(year, month, 1);
		// Continue to L_CURRENT_MONTH.

	case L_CURRENT_MONTH:
		{
		date.Export(&year, &month, ZIL_NULLP(int), 0);
		char title[20];

		// Setup the new date with only the month and the year.
		// This is done to setup the title string.
		date.Import(year, month, 1);

		// Get the month and year string for the title.
		const ZIL_LANGUAGE *myLanguage = ZIL_LANGUAGE_MANAGER::UseLanguage(ZIL_UTIME::_monthName);
		sprintf(title, "%s %d", myLanguage->GetMessage(month - 1 + ZIL_MON_1), year);

		// Reset the date to the current date.
		date.Import(year, month, day);

		// Change the title to show new month.
		calendarTitle->DataSet(title);
		daysOfMonth->date = date;
	  
		daysOfMonth->Event(S_REDISPLAY);
		break;
		}

	default:
		// Call the window event to process other events.
		ccode = UIW_WINDOW::Event(event);
		break;
	}

	// Return the control code.
	return (ccode);
}
