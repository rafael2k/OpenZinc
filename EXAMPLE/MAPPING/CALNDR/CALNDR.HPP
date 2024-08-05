//	CALENDAR.HPP (CALENDAR) - Calendar example.
//	COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//  May be freely copied, used and distributed.

#ifdef USE_HELP_CONTEXTS
const UI_HELP_CONTEXT GENERAL_HELP                     = 0x0001; // General Help
const UI_HELP_CONTEXT CALENDAR_HELP                    = 0x0002; // Calendar Help
#endif

// Calendar identification and internal messages.
const int ID_CALENDAR				= 10000;
const int L_PREVIOUS_MONTH			= 10001;
const int L_NEXT_MONTH				= 10002;
const int L_CURRENT_MONTH			= 10003;
const int L_NEW_MONTH				= 10004;


class ZIL_EXPORT_CLASS DAYS_OF_MONTH : public UI_WINDOW_OBJECT
{
public:
	ZIL_DATE date;

	DAYS_OF_MONTH(void);

	virtual EVENT_TYPE DrawItem(const UI_EVENT &event, EVENT_TYPE ccode);
	virtual EVENT_TYPE Event(const UI_EVENT &event);

private:
	int xLength, yLength;
	static UI_PALETTE dayPalette, currentPalette, linePalette, whitePalette;
};

// Palettes used by DAYS_OF_MONTH.
UI_PALETTE DAYS_OF_MONTH::dayPalette = { ' ', attrib(RED, WHITE),
	attrib(MONO_BLACK, MONO_BLACK), PTN_SOLID_FILL, RED, WHITE,
	BW_BLACK, BW_BLACK, GS_BLACK, GS_BLACK };

UI_PALETTE DAYS_OF_MONTH::currentPalette = { ' ', attrib(GREEN, WHITE),
	attrib(MONO_BLACK, MONO_BLACK), PTN_SOLID_FILL, GREEN, WHITE,
	BW_BLACK, BW_BLACK, GS_BLACK, GS_BLACK };

UI_PALETTE DAYS_OF_MONTH::linePalette = { ' ', attrib(DARKGRAY, WHITE),
	attrib(MONO_BLACK, MONO_BLACK), PTN_SOLID_FILL, DARKGRAY, WHITE,
	BW_BLACK, BW_BLACK, GS_BLACK, GS_BLACK };

UI_PALETTE DAYS_OF_MONTH::whitePalette = { ' ', attrib(WHITE, WHITE),
	attrib(MONO_HIGH, MONO_HIGH), PTN_SOLID_FILL, WHITE, WHITE,
	BW_WHITE, BW_WHITE, GS_WHITE, GS_WHITE };

class ZIL_EXPORT_CLASS CALENDAR : public UIW_WINDOW
{
public:
	CALENDAR(void);
	virtual EVENT_TYPE Event(const UI_EVENT &event);

private:
   	ZIL_DATE date;
	int day, month, year;
	UIW_TITLE *calendarTitle;
	DAYS_OF_MONTH *daysOfMonth;
	static UI_EVENT_MAP calendarEvent[];
};

