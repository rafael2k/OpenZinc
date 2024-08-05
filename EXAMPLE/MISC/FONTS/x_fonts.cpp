//	FONTS.CPP (FONTS) - Shows how to	load a new font into the font table.
//	COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//	May be freely copied, used and distributed.

#include <ui_win.hpp>
#include "fonts.hpp"

void LoadFont(UI_DISPLAY *_display)
{
	UI_XT_DISPLAY *display = (UI_XT_DISPLAY *)_display;
	typedef struct
	{
		char *italicSmallFont;
		char *italicBigFont;
	} AppData;

	#define XmNitalicBigFont	"italicBigFont"
	#define XmCItalicBigFont	"ItalicBigFont"

	static XtResource resources[] = 
	{
		XmNitalicBigFont,
		XmCItalicBigFont,
		XmRString,
		sizeof(char *),
		XtOffsetOf(AppData, italicBigFont),
		XmRString,
	// If font string is not found in X resource file then this font will be used.
		(XtPointer)"-*-helvetica-bold-o-*--14-*-iso8859-1"
	};

	AppData appData;
	XtGetApplicationResources(display->topShell, (XtPointer)&appData, resources,
		XtNumber(resources), ZIL_NULLP(Arg), 0);

	display->fontTable[FNT_NEW_FONT].fontStruct 
		= XLoadQueryFont(display->xDisplay, appData.italicBigFont);

	display->fontTable[FNT_NEW_FONT].fontList =
		XmFontListCreate(display->fontTable[FNT_NEW_FONT].fontStruct,
		XmSTRING_DEFAULT_CHARSET);
}
