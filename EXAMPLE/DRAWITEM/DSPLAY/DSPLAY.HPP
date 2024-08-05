//	DSPLAY.CPP (DSPLAY) - Example program using UI_DISPLAY.
//	COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//	May be freely copied, used and distributed.

class DISPLAY_WINDOW : public UIW_WINDOW
{
public:
	DISPLAY_WINDOW(int left, int top, int width, int height, WOF_FLAGS woFlags = WOF_BORDER);

	virtual EVENT_TYPE DrawItem(const UI_EVENT &event, EVENT_TYPE ccode);
};


