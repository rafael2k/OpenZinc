// Include the appropriate directives.
#include <ui_win.hpp>

int UI_APPLICATION::Main(void)
{
	// Fix linkers that don't look for main in the .LIBs.
	UI_APPLICATION::LinkMain();

	// Open general storage file which contains windows.
	UI_WINDOW_OBJECT::defaultStorage = new ZIL_STORAGE_READ_ONLY("p_movie1.dat");

	// Check to see if the default storage was allocated.
	if (UI_WINDOW_OBJECT::defaultStorage->storageError)
	{
		delete UI_WINDOW_OBJECT::defaultStorage;
		return(-1);
	}

	// Add the control windows.
	*windowManager + new UIW_WINDOW("p_movie1.dat~MOVIE_CONTROL");

	// Process user responses.
	UI_APPLICATION::Control();

	// Clean up and return success.
	delete UI_WINDOW_OBJECT::defaultStorage;
	return (0);
}

