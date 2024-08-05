//	PRINTR.HPP (PRINTER) - Printer example.
//	COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//  May be freely copied, used and distributed.

const UI_HELP_CONTEXT HELP_PRINTER		= 0x0001;
const UI_HELP_CONTEXT PRINT_HELP		= 0x1000;

const ZIL_LOGICAL_FONT FNT_FIXED_FONT	= 0x0003;

const EVENT_TYPE PRINT_PICTURE			= 12000;
const EVENT_TYPE PRINT_SCREEN			= 12001;
const EVENT_TYPE PRINT_TEXT				= 12002;
const EVENT_TYPE PROGRAM_HELP			= 12010;
const EVENT_TYPE ABOUT_HELP 			= 12011;

class ZIL_EXPORT_CLASS DRAW_WINDOW : public UIW_WINDOW
{
public:
	DRAW_WINDOW(void);
	EVENT_TYPE DrawItem(const UI_EVENT &event, EVENT_TYPE ccode);
	EVENT_TYPE Event(const UI_EVENT &event);
};

class ZIL_EXPORT_CLASS PRINT_DIALOG : public ZAF_DIALOG_WINDOW
{
public:
	PRINT_DIALOG(ZIL_ICHAR *name);
	static EVENT_TYPE PrintOptions(UI_WINDOW_OBJECT *, UI_EVENT &, EVENT_TYPE);

	UI_WINDOW_OBJECT *psFileOption;
	UI_WINDOW_OBJECT *psFileName;
};
