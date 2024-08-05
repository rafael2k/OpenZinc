//	AGENCY.CPP (AGENCY) - Simple travel agency program.
//	COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//  May be freely copied, used and distributed.

#include <ui_win.hpp>


#define USE_DERIVED_OBJECTS
#include "agency.hpp"

#if defined(ZIL_LINUX)

const int LARGE_COUR_FONT = 3;	// Placement for the new font.
const int SMALL_COUR_FONT = 4;	// Placement for the new font.
void LoadLargeCourierFont(UI_DISPLAY *_display);	// Function to load the new font.
void LoadSmallCourierFont(UI_DISPLAY *_display);	// Function to load the new font.

#endif


ITINERARY_WINDOW::ITINERARY_WINDOW(const ZIL_ICHAR *name, ZIL_STORAGE *file,
	ZIL_STORAGE_OBJECT_READ_ONLY *object, UI_ITEM *objectTable, UI_ITEM *userTable) :
	UIW_WINDOW(name, file, object, objectTable, userTable)
{
	storage = file;
	itinerary = Get("ITINERARY");
}

EVENT_TYPE ITINERARY_WINDOW::Event(const UI_EVENT &event)
{
	// Switch on the event type.
	EVENT_TYPE ccode = LogicalEvent(event);
	switch (ccode)
	{
	case CAR_EVENT:
		{
		AGENCY_WINDOW *window = new AGENCY_WINDOW("CAR_WINDOW", defaultStorage);
		windowManager->Center(window);
		*windowManager
			+ window;
		}
		break;

	case PLANE_EVENT:
		{
		AGENCY_WINDOW *window = new AGENCY_WINDOW("AIRLINE_WINDOW", defaultStorage);
		windowManager->Center(window);
		*windowManager
			+ window;
		}
		break;

	case HOTEL_EVENT:
		{
		AGENCY_WINDOW *window = new AGENCY_WINDOW("HOTEL_WINDOW", defaultStorage);
		windowManager->Center(window);
		*windowManager
			+ window;
		}
		break;

	case ADD_ITINERARY_ENTRY:
		{
		UI_EVENT tEvent(S_ADD_OBJECT);
		tEvent.windowObject = event.windowObject;
		itinerary->Event(tEvent);
		itinerary->Event(tEvent);
		itinerary->Event(UI_EVENT(S_DISPLAY_ACTIVE, 0, itinerary->trueRegion));
		Add(itinerary);
		}
		break;

	case SAVE_EVENT:
		eventManager->DeviceImage(E_MOUSE, DM_WAIT);
		Store("TRAVEL_AGENT_WINDOW", storage);
		storage->Save();
		eventManager->DeviceImage(E_MOUSE, DM_VIEW);
		break;

	case DELETE_EVENT:
		{
		// Get the current object in the vertical list and remove it.
		UI_EVENT event(S_SUBTRACT_OBJECT);
		itinerary->Information(I_GET_CURRENT, &event.windowObject);
		if (event.windowObject)
		{
			itinerary->Event(event);
			delete event.windowObject;
		
			// Set the first object to be current.
			event.type = S_ADD_OBJECT;
			itinerary->Information(I_GET_FIRST, &event.windowObject);
			if (event.windowObject)
				itinerary->Event(event);
		
			// Redisplay the vertical list.
			itinerary->Event(UI_EVENT(S_REDISPLAY));
		}
		}
		break;

	default:
		ccode = UIW_WINDOW::Event(event);
		break;
	}

	return (ccode);
}

AGENCY_BUTTON::AGENCY_BUTTON(ZIL_ICHAR *bitmapString, ZIL_ICHAR *_agencyString, ZIL_ICHAR *_dateString) :
	UIW_BUTTON(0, 0, 30, "", BTF_NO_3D | BTF_AUTO_SIZE, WOF_NO_FLAGS, ZIL_NULLF(ZIL_USER_FUNCTION), 0, bitmapString)
{

	// Copy the two strings for use on the button later.
	agencyString = strdup(_agencyString);
	dateString = strdup(_dateString);

	// Set the searchID for storage and retrieval.
	searchID = ID_AGENCY_BUTTON;
	
#if defined(ZIL_LINUX)	
	font = 3;
	SetButtonTitle();
#else
	woStatus |= WOS_OWNERDRAW;
#endif

}

AGENCY_BUTTON::AGENCY_BUTTON(const ZIL_ICHAR *name, ZIL_STORAGE_READ_ONLY *file,
	ZIL_STORAGE_OBJECT_READ_ONLY *object, UI_ITEM *objectTable, UI_ITEM *userTable) :
	UIW_BUTTON(name, file, object, objectTable, userTable)
{
	Load(name, file, object, objectTable, userTable);

#if defined(ZIL_LINUX)		
	font = 3;
	SetButtonTitle();
#else
	woStatus |= WOS_OWNERDRAW;
#endif

}

AGENCY_BUTTON::~AGENCY_BUTTON()
{
	// Cleanup the two strings before leaving.
	if (agencyString)
		delete agencyString;
	if (dateString)
		delete dateString;
}

#if defined(ZIL_LINUX)

void AGENCY_BUTTON::SetButtonTitle()
{
	ZIL_ICHAR tempBuffer[30];
	strcpy(tempBuffer, "                             ");
	strncpy(tempBuffer, agencyString, strlen(agencyString));
	strcpy(&tempBuffer[16], dateString);
	DataSet(tempBuffer);
}

#else

EVENT_TYPE AGENCY_BUTTON::DrawItem(const UI_EVENT &, EVENT_TYPE ccode)
{
	// Extract the region information.
	UI_REGION region = trueRegion;
	display->VirtualGet(screenID, region);

	UI_PALETTE *logicalPalette = LogicalPalette(ccode);
	display->Rectangle(screenID, region, logicalPalette, 0, TRUE, FALSE, &clip);

	// Format and display the agencyString, the bitmap and the dateString.
	UI_REGION tRegion;
	tRegion.top = region.top + (region.bottom - region.top) / 2 - (display->cellHeight /2) + display->preSpace;
	display->Text(screenID, region.left + display->cellWidth * 2, tRegion.top, agencyString,
		logicalPalette, -1, FALSE, FALSE, &clip);

	display->Text(screenID, region.left + display->cellWidth * 23, tRegion.top, dateString,
		logicalPalette, -1, FALSE, FALSE, &clip);

	ZIL_UINT8 *ourBitmapArray;
	Information(I_GET_BITMAP_ARRAY, &ourBitmapArray);
	display->Bitmap(screenID, region.left + display->cellWidth * 17, region.top + display->preSpace,
		bitmapWidth, bitmapHeight, ourBitmapArray, ZIL_NULLP(UI_PALETTE), &clip);

	// Draw the focus rectangle.
	UI_WINDOW_OBJECT *object = NULL;
	for (object = this; object && FlagSet(object->woStatus, WOS_CURRENT);
		object = object->parent)
			;
	if (!object)
		DrawFocus(screenID, region, ccode);

	display->VirtualPut(screenID);
	woStatus &= ~WOS_REDISPLAY;

	return(ccode);
}

#endif

void AGENCY_BUTTON::Store(const ZIL_ICHAR *name, ZIL_STORAGE *file,
	ZIL_STORAGE_OBJECT *object, UI_ITEM *objectTable, UI_ITEM *userTable)
{
	UIW_BUTTON::Store(name, file, object, objectTable, userTable);
	object->Store(agencyString);
	object->Store(dateString);
}

void AGENCY_BUTTON::Load(const ZIL_ICHAR *, ZIL_STORAGE_READ_ONLY *,
	ZIL_STORAGE_OBJECT_READ_ONLY *object, UI_ITEM *, UI_ITEM *)
{
	object->Load(&agencyString);
	object->Load(&dateString);
}


AGENCY_WINDOW::AGENCY_WINDOW(const ZIL_ICHAR *name, ZIL_STORAGE_READ_ONLY *file,
	ZIL_STORAGE_OBJECT_READ_ONLY *object, UI_ITEM *objectTable, UI_ITEM *userTable) :
	UIW_WINDOW(name, file, object, objectTable, userTable)
{
	// Get the pointers to the fields on the AGENCY_WINDOW window.
	selection = Get("SELECTION_BOX");
	dateField = Get("DATE_STRING");
}

EVENT_TYPE AGENCY_WINDOW::Event(const UI_EVENT &event)
{
	// Switch on the event type.
	EVENT_TYPE ccode = LogicalEvent(event);
	switch (ccode)
	{
	case ADD_CAR_EVENT:     // Add the car to the vertical list.
		AddItem("car");
		break;

	case ADD_HOTEL_EVENT:   // Add the hotel to the vertical list.
		AddItem("hotel");
		break;

	case ADD_PLANE_EVENT:   // Add the plane to the vertical list.
		AddItem("plane");
		break;

	default:
		ccode = UIW_WINDOW::Event(event);
	}
	return(ccode);
}

void AGENCY_WINDOW::AddItem(ZIL_ICHAR *bitmapString)
{
	ZIL_ICHAR *agencyString;
	selection->Information(I_GET_TEXT, &agencyString);

	// Get the data from the date field.
	ZIL_DATE date;
	dateField->Information(I_GET_VALUE, &date);

	// Get text of the date.
	ZIL_ICHAR dateString[256];
	date.Export(dateString, DTF_NO_FLAGS);

	// Create the button and put it in the list.
	AGENCY_BUTTON *button = new AGENCY_BUTTON(bitmapString, agencyString, dateString);

	UI_EVENT tEvent;
	tEvent.type = ADD_ITINERARY_ENTRY;
	tEvent.windowObject = button;

	// Generate an event to close the dialog window.
	eventManager->Put(UI_EVENT(S_CLOSE));
	eventManager->Put(tEvent);
}


int ListCompare(void *button1, void *button2)
{
	AGENCY_BUTTON *t1 = (AGENCY_BUTTON *)button1;
	AGENCY_BUTTON *t2 = (AGENCY_BUTTON *)button2;

	ZIL_DATE date1(t1->dateString);
	ZIL_DATE date2(t2->dateString);

	if (date1 < date2)
		return(-1);
	else if (date1 == date2)
		return(0);
	else
		return(1);
}

int UI_APPLICATION::Main(void)
{
	
#if defined(ZIL_LINUX)

	LoadLargeCourierFont(display);
	LoadSmallCourierFont(display);

#endif

	// Initialize the default storage for our application.
	ZIL_STORAGE *storage = new ZIL_STORAGE("p_agency.dat");
	UI_WINDOW_OBJECT::defaultStorage = storage;

	// Initialize the error system.
	UI_WINDOW_OBJECT::errorSystem = new UI_ERROR_SYSTEM;

	// Check to see if the default storage was allocated.
	if (UI_WINDOW_OBJECT::defaultStorage->storageError)
	{
		UI_WINDOW_OBJECT::errorSystem->ReportError(windowManager, WOS_NO_STATUS,
			"Error opening the storage file:\r\nTerminating.");
		delete UI_WINDOW_OBJECT::errorSystem;
		delete UI_WINDOW_OBJECT::defaultStorage;
		return(-1);
	}

	// Add main window to the window manager.
	ITINERARY_WINDOW *mainWindow = new ITINERARY_WINDOW("TRAVEL_AGENT_WINDOW", storage);
	windowManager->Center(mainWindow);
	*windowManager
		+ mainWindow;

	Control();

	// Cleanup a few things on our way out.
	delete UI_WINDOW_OBJECT::errorSystem;
	delete storage;

	return(0);
}


// --------------------------------------------------------------------------
// From code file generated by designer -------------------------------------
// --------------------------------------------------------------------------
#if defined(ZIL_LINKBUG)
void z_jump_dummy(void) { } // Bug fix for broken linkers.
#endif

extern int ListCompare(void *, void *);

ZIL_ICHAR _ListCompare[] = { 'L','i','s','t','C','o','m','p','a','r','e', 0 };

static UI_ITEM _userTable[] =
{
	{ 0, (int *)ZIL_VOIDF(ListCompare), _ListCompare, 0 },
	{ ID_END, ZIL_NULLP(void), ZIL_NULLP(ZIL_ICHAR), 0 }
};
UI_ITEM *UI_WINDOW_OBJECT::userTable = _userTable;

static UI_ITEM _objectTable[] =
{
	{ ID_BORDER, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_BORDER::New), UIW_BORDER::_className, 0 },
	{ ID_BUTTON, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_BUTTON::New), UIW_BUTTON::_className, 0 },
	{ ID_COMBO_BOX, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_COMBO_BOX::New), UIW_COMBO_BOX::_className, 0 },
	{ ID_DATE, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_DATE::New), UIW_DATE::_className, 0 },
	{ ID_ICON, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_ICON::New), UIW_ICON::_className, 0 },
	{ ID_MAXIMIZE_BUTTON, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_MAXIMIZE_BUTTON::New), UIW_MAXIMIZE_BUTTON::_className, 0 },
	{ ID_MINIMIZE_BUTTON, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_MINIMIZE_BUTTON::New), UIW_MINIMIZE_BUTTON::_className, 0 },
	{ ID_POP_UP_ITEM, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_POP_UP_ITEM::New), UIW_POP_UP_ITEM::_className, 0 },
	{ ID_POP_UP_MENU, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_POP_UP_MENU::New), UIW_POP_UP_MENU::_className, 0 },
	{ ID_PROMPT, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_PROMPT::New), UIW_PROMPT::_className, 0 },
	{ ID_PULL_DOWN_ITEM, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_PULL_DOWN_ITEM::New), UIW_PULL_DOWN_ITEM::_className, 0 },
	{ ID_PULL_DOWN_MENU, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_PULL_DOWN_MENU::New), UIW_PULL_DOWN_MENU::_className, 0 },
	{ ID_SCROLL_BAR, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_SCROLL_BAR::New), UIW_SCROLL_BAR::_className, 0 },
	{ ID_STRING, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_STRING::New), UIW_STRING::_className, 0 },
	{ ID_SYSTEM_BUTTON, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_SYSTEM_BUTTON::New), UIW_SYSTEM_BUTTON::_className, 0 },
	{ ID_TITLE, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_TITLE::New), UIW_TITLE::_className, 0 },
	{ ID_TOOL_BAR, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_TOOL_BAR::New), UIW_TOOL_BAR::_className, 0 },
	{ ID_VT_LIST, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_VT_LIST::New), UIW_VT_LIST::_className, 0 },
	{ ID_WINDOW, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_WINDOW::New), UIW_WINDOW::_className, 0 },
	{ ID_AGENCY_BUTTON, (UI_WINDOW_OBJECT*)ZIL_VOIDF(AGENCY_BUTTON::New), AGENCY_BUTTON::_className, 0 },
	{ ID_END, ZIL_NULLP(void), ZIL_NULLP(ZIL_ICHAR), 0 }
};
UI_ITEM *UI_WINDOW_OBJECT::objectTable = _objectTable;

#if defined(ZIL_LINUX)

void LoadLargeCourierFont(UI_DISPLAY *_display)
{
	UI_XT_DISPLAY *display = (UI_XT_DISPLAY *)_display;
	typedef struct
	{
		char *largeCourFontList;
	} AppData;
	
	#define XmNlargeCourFontList	"largeCourFontList"
	#define XmCLargeCourFontList	"LargeCourFontList"

	static XtResource resources[] =
	{
		XmNlargeCourFontList,
		XmCLargeCourFontList,
		XmRString,
		sizeof(char *),
		XtOffsetOf(AppData, largeCourFontList),
		XmRString,
		// If font string is not found in X resource file then this font will be used.
		(XtPointer)"-*-*-bold-r-*--14-*-iso8859-1"
	};

	AppData appData;
	XtGetApplicationResources(display->topShell, (XtPointer)&appData,
		resources, XtNumber(resources), ZIL_NULLP(Arg), 0);

	display->fontTable[LARGE_COUR_FONT].fontStruct
		= XLoadQueryFont(display->xDisplay, appData.largeCourFontList);

	display->fontTable[LARGE_COUR_FONT].fontList =
		XmFontListCreate(display->fontTable[LARGE_COUR_FONT].fontStruct,
			XmSTRING_DEFAULT_CHARSET);

}

void LoadSmallCourierFont(UI_DISPLAY *_display)
{
	UI_XT_DISPLAY *display = (UI_XT_DISPLAY *)_display;
	typedef struct
	{
		char *smallCourFontList;
	} AppData;
	
	#define XmNsmallCourFontList	"smallCourFontList"
	#define XmCSmallCourFontList	"SmallCourFontList"

	static XtResource resources[] =
	{
		XmNsmallCourFontList,
		XmCSmallCourFontList,
		XmRString,
		sizeof(char *),
		XtOffsetOf(AppData, smallCourFontList),
		XmRString,
		// If font string is not found in X resource file then this font will be used.
		(XtPointer)"-*-*-bold-r-*--12-*-iso8859-1"
	};

	AppData appData;
	XtGetApplicationResources(display->topShell, (XtPointer)&appData,
		resources, XtNumber(resources), ZIL_NULLP(Arg), 0);

	display->fontTable[SMALL_COUR_FONT].fontStruct
		= XLoadQueryFont(display->xDisplay, appData.smallCourFontList);

	display->fontTable[SMALL_COUR_FONT].fontList =
		XmFontListCreate(display->fontTable[SMALL_COUR_FONT].fontStruct,
			XmSTRING_DEFAULT_CHARSET);

}

#endif
