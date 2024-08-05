//	ANALOG.CPP (ANALOG) - Analog clock example.
//	COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//  May be freely copied, used and distributed.

#include "analog.hpp"


EVENT_TYPE ANALOG_FACE::DrawItem(const UI_EVENT &, EVENT_TYPE )
{
	// Redisplay the clock face and second hand.
	int hour, minute, second;
	((CLOCK *)parent)->time.Export(ZIL_NULLP(int), ZIL_NULLP(int), ZIL_NULLP(int),
		&hour, &minute, &second, ZIL_NULLP(int));

	display->VirtualGet(screenID, trueRegion);

	if (!display->isText)
	{
		Face();
		UpdateMinutes(hour, minute, FALSE);
		UpdateSeconds(second, FALSE);
	}

	display->VirtualPut(screenID);
	return (TRUE);
}

EVENT_TYPE ANALOG_FACE::Event(const UI_EVENT &event)
{
	// Translate the event into a logical event.
	EVENT_TYPE ccode = UI_WINDOW_OBJECT::LogicalEvent(event, ID_WINDOW_OBJECT);

	// Switch on the event.
	switch (ccode)
	{
	case S_INITIALIZE:
		UI_WINDOW_OBJECT::Event(event);
		break;

	case S_CREATE:
	case S_CHANGED:
		// Set clock object size to be maximum size allowed (uses WOF_NON_FIELD_REGION flag).
		UI_WINDOW_OBJECT::Event(event);

		// Set up center coords., clock hand lengths, and circle radius.
		xCenter = (trueRegion.left + trueRegion.right) / 2;
		yCenter = (trueRegion.top + trueRegion.bottom) / 2;
		xRadius = (trueRegion.right - trueRegion.left) / 15;
		yRadius = (trueRegion.bottom - trueRegion.top) / 15;
		xLength = (trueRegion.right - trueRegion.left) / 2 - xRadius;
		yLength = (trueRegion.bottom - trueRegion.top) / 2 - yRadius;

		woStatus |= WOS_OWNERDRAW;

		if (ccode == S_CREATE)
			RegisterObject("ANALOG_FACE");
		break;

	default:
		// Let the base class process all other events.
		ccode = UI_WINDOW_OBJECT::Event(event);
		break;
	}
 	return (ccode);
}

void ANALOG_FACE::Face(void)
{
	// Return if no display area.
	if (trueRegion.left >= trueRegion.right || trueRegion.top >= trueRegion.bottom)
		return;

	// Fill in clock background.
	// Note that the coordinates are calculated based on the clocks
	// coordinates found in UI_REGION trueRegion.
	display->VirtualGet(screenID, trueRegion);
	// Unoptimized initialization because of HP compiler bug.
	int poly1[8];
	poly1[0] = trueRegion.left; poly1[1] = trueRegion.top; poly1[2] = trueRegion.right;
	poly1[3] = trueRegion.top; poly1[4] = trueRegion.left; poly1[5] = trueRegion.bottom + 1;
	poly1[6] = trueRegion.left; poly1[7] = trueRegion.top;

	int poly2[8];
	poly2[0] = trueRegion.left; poly2[1] = trueRegion.bottom + 1; poly2[2] = trueRegion.right;
	poly2[3] = trueRegion.top; poly2[4] = trueRegion.right; poly2[5] = trueRegion.bottom + 1;
	poly2[6] = trueRegion.left; poly2[7] = trueRegion.bottom + 1;

	display->Polygon(screenID, 4, poly1, &grayPalette, TRUE);
	display->Polygon(screenID, 4, poly2, &blackPalette, TRUE);
	display->Ellipse(screenID, xCenter, yCenter, 0, 360, xRadius, yRadius, &cyanPalette, TRUE);
	int x = xRadius / 2;
	int y = yRadius / 2;
	int poly3[8];
	poly3[0] = xCenter - x; poly3[1] = yCenter - y; poly3[2] = xCenter + x;
	poly3[3] = yCenter - y; poly3[4] = xCenter - x; poly3[5] = yCenter + y;
	poly3[6] = xCenter + x; poly3[7] = yCenter + y;

	display->Polygon(screenID, 4, poly3, &yellowPalette);

	// Add tick marks.
	x /= 2;
	y /= 2;
	display->Ellipse(screenID, xCenter, yCenter - yLength + y, 0, 360, x, y, &yellowPalette, TRUE);
	display->Ellipse(screenID, xCenter + xLength - x, yCenter, 0, 360, x, y, &yellowPalette, TRUE);
	display->Ellipse(screenID, xCenter, yCenter + yLength - y, 0, 360, x, y, &yellowPalette, TRUE);
	display->Ellipse(screenID, xCenter - xLength + x, yCenter, 0, 360, x, y, &yellowPalette, TRUE);
	display->VirtualPut(screenID);
}

void ANALOG_FACE::UpdateMinutes(int hour, int minute, int handsXOR)
{
	// Return if no display area.
	if (trueRegion.left >= trueRegion.right || trueRegion.top >= trueRegion.bottom)
		return;

	// Remove old hands if they exist.
	display->VirtualGet(screenID, trueRegion);
	if (handsXOR)
	{
		display->Polygon(screenID, 5, minuteHand, &cyanPalette, FALSE, TRUE);
		display->Polygon(screenID, 5, hourHand, &cyanPalette, FALSE, TRUE);
	}

	// Compute and draw the minute hand.
	long x1, y1;
	long poly4[10];
	poly4[0] = 0; poly4[1] = 0; poly4[2] = -3; poly4[3] = 20; poly4[4] = 0;
	poly4[5] = 100; poly4[6] = 3; poly4[7] = 20; poly4[8] = 0; poly4[9] = 0;

	int cosRad = (15 + minute) % 60;
	int i;
	for (i= 0; i < 10; i+=2)
	{
		x1 = (poly4[i] * psuedoSin[ cosRad ] +
			poly4[i+1] * psuedoSin[ minute ]) * xLength /  1000000L;
		minuteHand[i] = xCenter + (int)x1;
		y1 = (poly4[i] * psuedoSin[ minute ] -
			poly4[i+1] * psuedoSin[ cosRad ] ) * yLength / 1000000L;
		minuteHand[i+1] = yCenter + (int)y1;
	}
	display->Polygon(screenID, 5, minuteHand, &cyanPalette, FALSE, TRUE);

	// Compute and draw the hour hand.
	int sinRad = (hour * 5) % 60 + minute / 12;
	cosRad = (15 + sinRad) % 60;
	long poly5[10];
	poly5[0] = 0; poly5[1] = 0; poly5[2] = -3; poly5[3] = 20; poly5[4] = 0;
	poly5[5] = 50; poly5[6] = 3; poly5[7] = 20; poly5[8] = 0; poly5[9] = 0;

	for (i = 0; i < 10; i+=2)
	{
		x1 = (poly5[i] * psuedoSin[ cosRad ] +
			poly5[i+1] * psuedoSin[ sinRad ]) * xLength /  1000000L;
		hourHand[i] = xCenter + (int)x1;
		y1 = (poly5[i] * psuedoSin[ sinRad ] -
			poly5[i+1] * psuedoSin[ cosRad ] ) * yLength / 1000000L;
		hourHand[i+1] = yCenter + (int)y1;
	}
	display->Polygon(screenID, 5, hourHand, &cyanPalette, FALSE, TRUE);
	display->VirtualPut(screenID);
}

void ANALOG_FACE::UpdateSeconds(int second, int handsXOR)
{
	// Return if no display area.
	if (trueRegion.left >= trueRegion.right || trueRegion.top >= trueRegion.bottom)
		return;

	// Remove old hands if they exist.
	display->VirtualGet(screenID, trueRegion);
	if (handsXOR)
		display->Line(screenID, xCenter, yCenter, xSecondHand, ySecondHand, &cyanPalette, 1, TRUE);

	// Compute and draw the second hand.
	xSecondHand = (int)(xCenter + 1L * psuedoSin[ second ] * xLength /  10000L);
	ySecondHand = (int)(yCenter - 1L * psuedoSin[ (second + 15) % 60 ] * yLength / 10000L);
	display->Line(screenID, xCenter, yCenter, xSecondHand, ySecondHand, &cyanPalette, 1, TRUE);
	display->VirtualPut(screenID);
}

CLOCK::CLOCK(int left, int top, int width, int height) :
	UIW_WINDOW(left, top, width, height, WOF_NO_FLAGS, WOAF_NO_DESTROY),
	analogFace(ZIL_NULLP(ANALOG_FACE)), digitalClock(ZIL_NULLP(UIW_TIME))
{
	if (display->isText)
	{
		// Create digital clock object.
		ZIL_TIME systemTime;
		digitalClock = new UIW_TIME(0, 0, 18, &systemTime, ZIL_NULLP(ZIL_ICHAR), TMF_SECONDS,
			WOF_NON_SELECTABLE);
	}
	else
	{
		// Create analog clock object.
		analogFace = new ANALOG_FACE();
	}

	// Add the window objects to the window.
	*this
		+ new UIW_BORDER
		+ new UIW_MAXIMIZE_BUTTON
		+ new UIW_MINIMIZE_BUTTON
		+ UIW_SYSTEM_BUTTON::Generic()
		+ new UIW_TITLE("Analog", WOF_JUSTIFY_CENTER);

	if (display->isText)
		*this + digitalClock;
	else
		*this + analogFace;
}

EVENT_TYPE CLOCK::Event(const UI_EVENT &event)
{
	EVENT_TYPE ccode = event.type;

	// Switch on the event type.
	switch (event.type)
	{
	case E_TIMER:
		{
		int hour, minute, second;
		int oldHour, oldMinute, oldSecond;

		UI_EVENT event;

		// Get the current time.
		ZIL_UTIME newTime;
		newTime.Export(ZIL_NULLP(int), ZIL_NULLP(int), ZIL_NULLP(int),
			&hour, &minute, &second, ZIL_NULLP(int));

		// Check to see if the time has changed.
		time.Export(ZIL_NULLP(int), ZIL_NULLP(int), ZIL_NULLP(int),
			&oldHour, &oldMinute, &oldSecond, ZIL_NULLP(int));
		if (display->isText)
		{
			// Update the digital clock.
			if (oldSecond != second || oldMinute != minute)
			{
				ZIL_TIME setTime;
				digitalClock->DataSet(&setTime);
			}
		}
		else
		{
			// Update the second hand (and minute hand if needed).
			if (oldMinute != minute || oldHour != hour)
				analogFace->UpdateMinutes(hour, minute, TRUE);
			analogFace->UpdateSeconds(second, TRUE);
		}

		time.Import();
		}
		break;

	default:
		// Process window messages.
		ccode = UIW_WINDOW::Event(event);
	}

	return (ccode);
}

int UI_APPLICATION::Main(void)
{
	// The UI_APPLICATION constructor automatically initializes the 
	// display, eventManager, and windowManager variables.

	// This line fixes linkers that don't look for main in the .LIBs.
	UI_APPLICATION::LinkMain();

	// Add a timer device to the event manager.
	UID_TIMER *timer = new UID_TIMER(D_ON, 1000);
	*eventManager + timer;

	// Create the clock.
	CLOCK *clock = new CLOCK(0, 0, 34, 12);
	windowManager->Center(clock);

	// Tell the timer to notify the clock with E_TIMER events.
	UI_EVENT event(S_ADD_OBJECT);
	event.windowObject = clock;
	timer->Event(event);

	// Put the clock on the screen.
	*windowManager + clock;

	UI_APPLICATION::Control();

	*windowManager - clock;
	delete clock;

	return (0);
}
