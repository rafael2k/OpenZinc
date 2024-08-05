#include <ui_win.hpp>
#include "mgr.hpp"

EVENT_TYPE WINDOW_MANAGER::Event(const UI_EVENT &event)
{
	EVENT_TYPE ccode = event.type;
	switch (ccode)
	{
	default:
		ccode = UI_WINDOW_MANAGER::Event(event);
	}
	return (ccode);
}
