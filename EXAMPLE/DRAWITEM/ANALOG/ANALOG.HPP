//	ANALOG.HPP (ANALOG) - Analog clock example.
//	COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//  May be freely copied, used and distributed.

#include <ui_win.hpp>

#if defined(ZIL_MSDOS)
#	include <stdio.h>
#endif

// Color palette definitions for analog clock face.
static UI_PALETTE grayPalette = { ' ', attrib(DARKGRAY, DARKGRAY),
	attrib(MONO_BLACK, MONO_BLACK), PTN_SOLID_FILL, DARKGRAY, DARKGRAY,
	BW_WHITE, BW_WHITE, GS_GRAY, GS_GRAY };

static UI_PALETTE blackPalette = { ' ', attrib(BLACK, BLACK),
	attrib(MONO_BLACK, MONO_BLACK), PTN_SOLID_FILL, BLACK, BLACK,
	BW_BLACK, BW_BLACK, GS_BLACK, GS_BLACK };

static UI_PALETTE cyanPalette = { ' ', attrib(CYAN, CYAN),
	attrib(MONO_BLACK, MONO_BLACK), PTN_SOLID_FILL, CYAN, CYAN,
	BW_BLACK, BW_BLACK, GS_BLACK, GS_BLACK };

static UI_PALETTE yellowPalette = { ' ', attrib(YELLOW, YELLOW),
	attrib(MONO_HIGH, MONO_HIGH), PTN_SOLID_FILL, YELLOW, YELLOW,
	BW_WHITE, BW_WHITE, GS_WHITE, GS_WHITE };

// Definition of psuedoSin (used so that the floating point library is not needed).
const int psuedoSin[] = {0, 1045, 2079, 3090, 4067, 5000, 5878, 6691,
	7431, 8090,	8660, 9135, 9510, 9781, 9945, 10000, 9945, 9781, 9510,
	9135, 8660, 8090, 7431, 6691, 5878, 5000, 4067, 3090, 2079, 1045,
	0, -1045, -2079, -3090, -4067, -5000, -5878, -6691, -7431, -8090,
	-8660, -9135, -9510, -9781, -9945, -10000, -9945, -9781, -9510,
	-9135, -8660, -8090, -7431, -6691, -5878, -5000, -4067, -3090,
	-2079, -1045, 0 };

class ANALOG_FACE : public UI_WINDOW_OBJECT
{
public:
	ANALOG_FACE(void) :
		UI_WINDOW_OBJECT(0, 0, 0, 0, WOF_NON_SELECTABLE | WOF_NON_FIELD_REGION, WOAF_NO_FLAGS) { }
	~ANALOG_FACE(void) { }

	virtual EVENT_TYPE DrawItem(const UI_EVENT &event, EVENT_TYPE ccode);
	virtual EVENT_TYPE Event(const UI_EVENT &event);
	void Face(void);
	void UpdateMinutes(int hour, int minute, int handsXOR);
	void UpdateSeconds(int second, int handsXOR);

private:
	int xCenter;
	int yCenter;
	int xRadius;
	int yRadius;
	int xLength;
	int yLength;
	int xSecondHand;
	int ySecondHand;
	int minuteHand[10];
	int hourHand[10];
};

class CLOCK : public UIW_WINDOW
{
public:
	CLOCK(int left, int top, int width, int height);
	~CLOCK(void) { }

	virtual EVENT_TYPE Event(const UI_EVENT &event);
	void Poll(void);

	ZIL_UTIME time;
	ANALOG_FACE *analogFace;
	UIW_TIME *digitalClock;

private:
	int installed;
};
