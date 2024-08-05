//	PROCESS.HPP
//	COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasent Grove, Utah USA
//	May be freely copied, used and distributed.

#include <ui_win.hpp>

const ZIL_USER_EVENT START_PROCESS = 10000;
const ZIL_USER_EVENT CANCEL_PROCESS = 10001;

// Color palette definitions for process bar forground.
static UI_PALETTE bluePalette = { ' ', attrib(BLUE, BLUE),
	attrib(MONO_BLACK, MONO_BLACK), PTN_SOLID_FILL, BLACK, BLUE,
	BW_WHITE, BW_WHITE, GS_GRAY, GS_GRAY };

// Color palette definitions for process bar background.
static UI_PALETTE whitePalette = { ' ', attrib(WHITE, WHITE),
	attrib(MONO_BLACK, MONO_BLACK), PTN_SOLID_FILL, BLACK, WHITE,
	BW_WHITE, BW_WHITE, GS_GRAY, GS_GRAY };

class PROCESS_BOX : public UI_WINDOW_OBJECT
{
public:
	PROCESS_BOX(int left, int top, int width, int height);
	EVENT_TYPE Event(const UI_EVENT &event);
	EVENT_TYPE DrawItem(const UI_EVENT &event, EVENT_TYPE ccode);

protected:
	// Stores the event state.
	int state;

	// Event state's
	int process;
	int halt;

	// used together to calculate the percentage.
	float incrementor;				
	float fullValue;
};

class MY_WINDOW : public UIW_WINDOW
{
public:
	MY_WINDOW(int left, int top, int width, int height);
	EVENT_TYPE Event(const UI_EVENT &event);

protected:
	PROCESS_BOX *processBox;
};
