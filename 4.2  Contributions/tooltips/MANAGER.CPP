#include <ui_win.hpp>
#include "manager.hpp"

WINDOW_MANAGER::WINDOW_MANAGER(UI_DISPLAY *display, UI_EVENT_MANAGER *eventManager) :
	UI_WINDOW_MANAGER(display, eventManager)
{
}

EVENT_TYPE WINDOW_MANAGER::Event(const UI_EVENT &event)
{
	// Switch on the event type.
	EVENT_TYPE ccode = event.type;
	if (event.InputType() == E_MOUSE)
	{
		UI_WINDOW_OBJECT *firstWindow = First();
		UI_EVENT tempEvent(UPDATE_MOUSE_INFO);
		tempEvent.position = event.position;
		if (firstWindow)
		{
			NormalizePosition(firstWindow, event, tempEvent.position);
			firstWindow->Event(tempEvent);
		}
	}

	switch(ccode)
	{
	case E_TIMER:
		// Send the event to the current window.
		if (First())
			First()->Event(UPDATE_TOOLTIPS_HELP);
		break;

	default:
		// Send event information to the window manager.
		ccode = UI_WINDOW_MANAGER::Event(event);
	}

	return (ccode);
}
