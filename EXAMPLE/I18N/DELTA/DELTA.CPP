//	DELTA.CPP (DELTA) - Load a normal/delta resource.
//	COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//	May be freely copied, used and distributed.

#include <ui_win.hpp>
#define RESOURCE_NAME	"NUMBER"
#define PATH_NAME	"string"
//#define PATH_NAME	ZIL_NULLP(ZIL_ICHAR)
#define FILE_NAME	"p_delta.dat"

#define DO_DELTA
#if defined(DO_DELTA)

int UI_APPLICATION::Main(void)
{
	UI_APPLICATION::LinkMain();

	ZIL_STORAGE_READ_ONLY *file = new ZIL_STORAGE_READ_ONLY(FILE_NAME);

	// Check to see if the storage was allocated.
	if (file->storageError)
	{
		delete file;
		return(-1);
	}

	UI_WINDOW_OBJECT *window = (argc > 1 ?
		new UIW_WINDOW(RESOURCE_NAME, RESOURCE_NAME, PATH_NAME, file, file) :
		new UIW_WINDOW(RESOURCE_NAME, file));
	*windowManager + window;
	Control();
	delete file;
	return (0);
}

void z_jump_dummy(void) { }   // Bug fix for broken linkers.

static UI_ITEM _objectTable[] =
{
	// Uncomment the objects below that are used in your application.
	// Zinc Designer generates the necessary table below to link in.
	{ ID_BORDER, 			(UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_BORDER::New), 			UIW_BORDER::_className, 			0 },
	{ ID_BUTTON, 			(UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_BUTTON::New), 			UIW_BUTTON::_className, 			0 },
	{ ID_DATE, 				(UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_DATE::New),				UIW_DATE::_className, 				0 },
	{ ID_SYSTEM_BUTTON, 	(UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_SYSTEM_BUTTON::New), 		UIW_SYSTEM_BUTTON::_className, 		0 },
	{ ID_TIME, 				(UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_TIME::New), 				UIW_TIME::_className, 				0 },
	{ ID_TITLE, 			(UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_TITLE::New), 				UIW_TITLE::_className, 				0 },
	{ ID_WINDOW, 			(UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_WINDOW::New), 			UIW_WINDOW::_className, 			0 },
	{ ID_END, 				ZIL_NULLP(void), 						ZIL_NULLP(ZIL_ICHAR), 					0 }
};
UI_ITEM *UI_WINDOW_OBJECT::objectTable = _objectTable;

static UI_ITEM _userTable[] =
{
	{ ID_END, ZIL_NULLP(void), ZIL_NULLP(ZIL_ICHAR), 0 }
};
UI_ITEM *UI_WINDOW_OBJECT::userTable = _userTable;

#else
//	Generate the P_DELTA.DAT windows.

int UI_APPLICATION::Main(void)
{
	UIW_DATE *date;
	UIW_TIME *time;
	UIW_TITLE *title;

	UI_APPLICATION::LinkMain();
	ZIL_STORAGE *file = new ZIL_STORAGE(FILE_NAME, UIS_CREATE|UIS_READWRITE);

	UIW_WINDOW *window = new UIW_WINDOW(5, 5, 15, 4);
	*window
		+ new UIW_BORDER
		+ new UIW_SYSTEM_BUTTON(SYF_GENERIC)
		+ (title = new UIW_TITLE("Number"))
		+ (date = new UIW_DATE(1, 0, 12, ZIL_NULLP(ZIL_DATE)))
		+ (time = new UIW_TIME(1, 1, 7, ZIL_NULLP(ZIL_TIME), ZIL_NULLP(ZIL_ICHAR), TMF_TWENTY_FOUR_HOUR))
	;
	// Store the window
	window->Store(RESOURCE_NAME, file);

	// Modify the window
	window->relative.right += 15;
	window->trueRegion.right += 15;
	title->Information(I_SET_TEXT, "String");

	date->relative.right += 15;
	date->trueRegion.right += 15;
	DTF_FLAGS dtFlags = DTF_ALPHA_MONTH | DTF_DAY_OF_WEEK;
	date->Information(I_SET_FLAGS, &dtFlags);

	TMF_FLAGS tmFlags = TMF_TWENTY_FOUR_HOUR;
	time->Information(I_CLEAR_FLAGS, &tmFlags);
	tmFlags = TMF_TWELVE_HOUR;
	time->Information(I_SET_FLAGS, &tmFlags);
	time->relative.right += 3;
	time->trueRegion.right += 3;
	// Delta store the window
	window->DeltaStore(RESOURCE_NAME, RESOURCE_NAME, PATH_NAME, file, file);

	file->Save();
	delete file;

	return (0);
}
#endif
