//	SPIN.CPP (SPIN) - Using spin control and slider
//	COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//  May be freely copied, used and distributed.

#include <ui_win.hpp>
#include "spin.hpp"

UIW_INTEGER *frameCount;

PLAYBACK_CONTROL::PLAYBACK_CONTROL(void) : UIW_STRING(0, 0, 1, "1.0 x normal",
    32, STF_NO_FLAGS, WOF_BORDER | WOF_VIEW_ONLY), rate(10)
{
}

void *PLAYBACK_CONTROL::Information(INFO_REQUEST request, void *data, ZIL_OBJECTID objectID)
{
    switch (request)
    {
    case I_DECREMENT_VALUE:
        {
        int delta = *(int *)data;
        if (rate - delta > MIN_PLAYBACK_SPEED)
        {
            // Update rate and field.
            rate -= delta;
            sprintf(buffer, "%1.1f x normal", rate / 10.0);
            DataSet(buffer);
        }
        }
        break;

    case I_INCREMENT_VALUE:
        {
        int delta = *(int *)data;
        if (rate + delta <= MAX_PLAYBACK_SPEED)
        {
            // Update rate and field.
            rate += delta;
            sprintf(buffer, "%1.1f x normal", rate / 10.0);
            DataSet(buffer);
        }
        }
        break;

    default:
        data = UIW_STRING::Information(request, data, objectID);
        break;
    }
    return (data);
}

EVENT_TYPE UpdateFrame(UI_WINDOW_OBJECT *object, UI_EVENT &, EVENT_TYPE ccode)
{
    if (ccode != L_SELECT)
        return (ccode);

    // Get frame value from the slider.
    int frame;
    object->Information(I_GET_VALUE, &frame);

    // Update the frame count field, advance the tape, etc.
    frameCount->Information(I_SET_VALUE, &frame);
	return (ccode);
}

int UI_APPLICATION::Main(void)
{
	// This line fixes linkers that don't look for main in the .LIBs.
	UI_APPLICATION::LinkMain();

    // Create initial data for frame control slider.
    int startingFrame = 0;
    UI_SCROLL_INFORMATION frames;
    frames.minimum = 0;
    frames.maximum = 300;
    frames.showing = 30;
    frames.delta   = 1;
    frames.current = startingFrame;

	// Create window and add fields.
	UIW_WINDOW *window = UIW_WINDOW::Generic(2, 2, 45, 8, "Video Editor");
    *window
        + new UIW_PROMPT(5, 1, "Playback &Speed:")
        + new UIW_SPIN_CONTROL(20, 1, 15, new PLAYBACK_CONTROL)
        + new UIW_PROMPT(5, 4, "Current &Frame:")
        + new UIW_SCROLL_BAR(5, 5, 30, 1, &frames, SBF_HORIZONTAL | SBF_SLIDER, WOF_BORDER,
                WOAF_NO_FLAGS, UpdateFrame)
        + (frameCount = new UIW_INTEGER(20, 4, 10, &startingFrame,
            ZIL_NULLP(ZIL_ICHAR), NMF_NO_FLAGS, WOF_VIEW_ONLY | WOF_BORDER));
    frameCount->woAdvancedFlags |= WOAF_NON_CURRENT;

	// Add window to the window manager.
	*windowManager
		+ window;

	// Process user responses.
	UI_APPLICATION::Control();

	return (0);
}

