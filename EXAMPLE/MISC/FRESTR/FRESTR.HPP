//	FRESTR.HPP (FREESTOR) - Demonstrate a Free Store Exception Handler.
//	COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//  May be freely copied, used and distributed.

class MEMORY_ALLOCATION_ERROR_SYSTEM
{
public:
	MEMORY_ALLOCATION_ERROR_SYSTEM(UI_DISPLAY *_display,
		UI_EVENT_MANAGER *_eventManager, UI_WINDOW_MANAGER *_windowManager);
	~MEMORY_ALLOCATION_ERROR_SYSTEM();

	int installed;
	static void FreeStoreException(void);

private:
	static char *errorMem;
	static UIW_WINDOW *errorWindow;

	static UI_DISPLAY *display;
	static UI_EVENT_MANAGER *eventManager;
	static UI_WINDOW_MANAGER *windowManager;
};

