//	LSTITM.CPP  (LSTITM) - List Items example program.
//  COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//	May be freely copied, used and distributed.


#include <ui_win.hpp>


#include "lstitm.hpp"

#if defined(ZIL_LINUX)

const int LARGE_COUR_FONT = 3;	// Placement for the new font.
const int SMALL_COUR_FONT = 4;	// Placement for the new font.
void LoadLargeCourierFont(UI_DISPLAY *_display);	// Function to load the new font.
void LoadSmallCourierFont(UI_DISPLAY *_display);	// Function to load the new font.

#endif

LIST_ITEM::LIST_ITEM(TRANSPORT _tType, ZIL_ICHAR *_departure, ZIL_INT32 _cost) :
	UIW_BUTTON(0, 0, 0, ZIL_NULLP(ZIL_ICHAR), BTF_NO_3D)
{
	tType = _tType;
	departure = strdup(_departure);
	cost = _cost;

#if defined(ZIL_LINUX)
	font = 4;
	woFlags &= ~WOF_JUSTIFY_CENTER;
	Information(I_CHANGED_FLAGS, ZIL_NULLP(void));
	bitmapHeight = 8;
	bitmapWidth = 16;
	bitmapArray = tImage[tType].graphic;
	SetButtonTitle();
#else
	woStatus |= WOS_OWNERDRAW;
#endif

}

LIST_ITEM::~LIST_ITEM()
{
	if(departure)
		delete departure;
}


#if defined(ZIL_LINUX)

void LIST_ITEM::SetButtonTitle()
{
	
	ZIL_ICHAR buffer[12];
	ZIL_BIGNUM formatter(cost);
	formatter.Export(buffer, NMF_CURRENCY | NMF_COMMAS);
	ZIL_ICHAR titleBuffer[30];
	strcpy(titleBuffer, "                             ");
	//copy non null terminated string to labelBuffer
	strncpy(titleBuffer, departure, strlen(departure));
	strcpy(&titleBuffer[17], buffer);
	DataSet(titleBuffer);
}	

#else

EVENT_TYPE LIST_ITEM::DrawItem(const UI_EVENT &, EVENT_TYPE ccode)
{
	UI_PALETTE *palette = LogicalPalette(ccode);

	display->VirtualGet(screenID, trueRegion);

	UI_REGION region = trueRegion;
	display->Rectangle(screenID, trueRegion, palette, 0, TRUE, FALSE, &clip);
	if (display->isText)
		display->Text(screenID, region.left + display->cellWidth,
			region.top + display->preSpace, tImage[tType].text, palette,
			-1, FALSE, FALSE, &clip);
	else
		display->Bitmap(screenID, region.left + display->cellWidth,
			region.top + display->preSpace, 16, 8, tImage[tType].graphic,
			ZIL_NULLP(UI_PALETTE), &clip);
			
	display->Text(screenID, region.left + display->cellWidth * 7,
		region.top + display->preSpace, departure, palette,
		-1, FALSE, FALSE, &clip);
	ZIL_ICHAR buffer[32];
	ZIL_BIGNUM formatter(cost);
	formatter.Export(buffer, NMF_CURRENCY | NMF_COMMAS);
	int left = region.right - display->TextWidth(buffer, screenID, font) - display->cellWidth;
	if (left < region.left + display->cellWidth * 30 - display->TextWidth(buffer, screenID, font))
		left = region.left + display->cellWidth * 30 - display->TextWidth(buffer, screenID, font);
	display->Text(screenID, left, region.top + display->preSpace, buffer,
		palette, -1, FALSE, FALSE, &clip);

	UI_WINDOW_OBJECT *object;
	for(object = this; object && FlagSet(object->woStatus, WOS_CURRENT);
		object = object->parent)
		;
	if (!object)
		DrawFocus(screenID, region, ccode);

	display->VirtualPut(screenID);

	return (TRUE);

}

#endif

int LIST_ITEM::Compare(void *p1, void *p2)
{
	LIST_ITEM *object1 = (LIST_ITEM *)p1;
	LIST_ITEM *object2 = (LIST_ITEM *)p2;

	if (object1->cost < object2->cost)
		return (-1);
	else if (object1->cost > object2->cost)
		return (1);
	else
		return (0);
}

TRANSPORT_IMAGE LIST_ITEM::tImage[5] =
{
#define _ (ZIL_UINT8)BACKGROUND
#define B (ZIL_UINT8)BLACK
	{ "Plane",
		{	_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _,
			_, _, _, _, _, _, B, B, B, B, B, _, _, _, B, B,
			_, _, _, _, B, B, B, _, _, _, _, _, _, B, B, B,
			B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, _,
			B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, _,
			_, _, _, _, B, B, B, _, _, _, _, _, _, _, _, _,
			_, _, _, _, _, _, B, B, B, B, B, _, _, _, _, _,
			_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _	}	},
	{ "Train",
		{	_, _, _, _, _, _, _, _, _, _, _, B, B, B, B, B,
			_, _, _, B, B, _, _, _, _, _, _, _, B, B, B, _,
			_, _, _, B, B, _, _, _, _, _, _, _, B, B, B, _,
			_, B, B, B, B, B, B, B, B, B, B, B, B, B, B, _,
			_, B, B, B, B, B, B, B, B, B, B, B, B, B, B, _,
			B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B,
			_, _, _, B, B, B, _, _, _, _, _, B, B, B, _, _,
			_, _, _, _, B, _, _, _, _, _, _, _, B, _, _, _	}	},
	{ "Bus",
		{	_, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B,
			_, B, _, B, _, B, _, B, _, B, _, B, _, B, _, B,
			B, B, _, B, _, B, _, B, _, B, _, B, _, B, _, B,
			B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B,
			B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B,
			B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B,
			_, _, B, B, B, _, _, _, _, _, _, _, B, B, B, _,
			_, _, _, B, _, _, _, _, _, _, _, _, _, B, _, _	}	},
	{ "Ship",
		{	_, _, _, _, _, _, B, B, _, B, B, _, _, _, _, _,
			_, _, _, _, _, _, B, B, _, B, B, _, _, _, _, _,
			_, _, _, _, _, B, B, _, B, B, _, _, _, _, _, _,
			_, _, _, _, _, B, B, _, B, B, _, _, _, _, _, _,
			B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B,
			_, B, B, B, B, B, B, B, B, B, B, B, B, B, B, _,
			_, _, B, B, B, B, B, B, B, B, B, B, B, B, _, _,
			_, _, _, B, B, B, B, B, B, B, B, B, B, _, _, _ 	}	},
	{ "Cab",
		{	_, _, _, _, _, _, _, B, _, _, _, _, _, _, _, _,
			_, _, _, _, _, B, B, B, B, B, B, B, _, _, _, _,
			_, _, _, _, _, B, _, _, B, _, _, B, _, _, _, _,
			_, B, B, B, B, B, B, B, B, B, B, B, B, B, B, _,
			_, B, B, B, B, B, B, B, B, B, B, B, B, B, B, _,
			B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B,
			_, _, _, B, B, B, _, _, _, _, _, B, B, B, _, _,
			_, _, _, _, B, _, _, _, _, _, _, _, B, _, _, _	}	},
#undef B
#undef _
};

struct LIST_DATA
{
	TRANSPORT type;
	ZIL_ICHAR *departure;
	ZIL_INT32 cost;
};

static LIST_DATA entries[] =
{
	{ PLANE,	"Chicago",			400 },
	{ BUS,		"Los Angeles",		 99 },
	{ SHIP,		"Miami",			350 },
	{ TRAIN,	"Salt Lake City",	109 },
	{ CAB,		"New York City",	500 },
	{ NO_TRANSPORT, 0, 0 }
};

int UI_APPLICATION::Main(void)
{
	// This line fixes linkers that don't look for main in the .LIBs.
	UI_APPLICATION::LinkMain();

#if defined(ZIL_LINUX)

	LoadLargeCourierFont(display);
	LoadSmallCourierFont(display);

#endif

	UIW_WINDOW *window = UIW_WINDOW::Generic(1, 1, 35, 4, "Owner-draw List Items");

	UIW_VT_LIST *list = new UIW_VT_LIST(0, 0, 0, 0, LIST_ITEM::Compare,
		WNF_BITMAP_CHILDREN, WOF_NON_FIELD_REGION);
	*list + new UIW_SCROLL_BAR(0, 0, 0, 0);

	for (LIST_DATA *entry = entries; entry->type != NO_TRANSPORT; entry++)
		*list
			+ new LIST_ITEM(entry->type, entry->departure, entry->cost);

	*window
		+ list;

	*windowManager
		+ window;

	UI_APPLICATION::Control();

	return (0);
}

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
