// Include the appropriate directives.
#include <ui_win.hpp>
#include "movie3.hpp"

int UI_APPLICATION::Main(void)
{
	// Fix linkers that don't look for main in the .LIBs.
	UI_APPLICATION::LinkMain();

	// Provide a general storage module.
	UI_WINDOW_OBJECT::defaultStorage = new ZIL_STORAGE_READ_ONLY("p_movie3.dat");

	// Check to see if the default storage was allocated.
	if (UI_WINDOW_OBJECT::defaultStorage->storageError)
	{
		delete UI_WINDOW_OBJECT::defaultStorage;
		return(-1);
	}

	// Add the control windows.
	*windowManager + new MOVIE_CONTROL;
	windowManager->screenID = windowManager->First()->screenID;

	// Process user responses.
	UI_APPLICATION::Control();

	// Clean up and return success.
	delete UI_WINDOW_OBJECT::defaultStorage;
	return (0);
}

// ----- MOVIE_CONTROL -----------------------------------------------------

MOVIE_CONTROL::MOVIE_CONTROL(void) :
	UIW_WINDOW("MOVIE_CONTROL", defaultStorage)
{
	// Center the window at the top of the screen.
	windowManager->Center(this);
	relative.bottom = relative.Height() - 1;
	relative.top = 0;
}

EVENT_TYPE MOVIE_CONTROL::Event(const UI_EVENT &event)
{
	// Check for special requests.
	EVENT_TYPE ccode = event.type;
	if (ccode == OPT_MOVIE_CREATE)
		ccode = MovieCreate(event);
	else if (ccode == OPT_MOVIE_DELETE)
		ccode = MovieDelete(event);
	else if (ccode == OPT_MOVIE_LOAD)
		ccode = MovieLoad(event);
	else if (ccode == OPT_MOVIE_STORE)
		ccode = MovieStore(event);
	else
		ccode = UIW_WINDOW::Event(event);
	return (ccode);
}

EVENT_TYPE MOVIE_CONTROL::MovieCreate(const UI_EVENT &event)
{
	*windowManager + new UIW_WINDOW("MOVIE_INFORMATION", defaultStorage);
	return (event.type);
}

EVENT_TYPE MOVIE_CONTROL::MovieDelete(const UI_EVENT &event)
{
	*windowManager + new UIW_WINDOW("MOVIE_SELECTION", defaultStorage);
	return (event.type);
}

EVENT_TYPE MOVIE_CONTROL::MovieLoad(const UI_EVENT &event)
{
	*windowManager + new UIW_WINDOW("MOVIE_SELECTION", defaultStorage);
	return (event.type);
}

EVENT_TYPE MOVIE_CONTROL::MovieStore(const UI_EVENT &event)
{
	return (event.type);
}

