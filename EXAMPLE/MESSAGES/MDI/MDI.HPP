//	MDI.HPP (MDI) - MDI - Scrolling Window example.
//	COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//  May be freely copied, used and distributed.

const EVENT_TYPE MDI_ADD_CHILD			= 20000;
const EVENT_TYPE MDI_REMOVE_CHILD		= 20001;
const EVENT_TYPE MDI_UPDATE_MENU			= 20002;
const EVENT_TYPE MDI_PROGRAM_HELP		= 20200;
const EVENT_TYPE MDI_ABOUT_HELP			= 20201;
const EVENT_TYPE MDI_ACTIVATE_CHILD		= 21000;

const UI_HELP_CONTEXT MDI_HELP         = 0x0001; // MDI Program Help

class ZIL_EXPORT_CLASS MDI_FRAME_WINDOW : public UIW_WINDOW
{
public:
	MDI_FRAME_WINDOW(const ZIL_ICHAR *name);
	virtual EVENT_TYPE Event(const UI_EVENT &event);

private:
	UI_WINDOW_OBJECT *windowMenu;
};



class ZIL_EXPORT_CLASS MDI_CHILD_WINDOW : public UIW_WINDOW
{
public:
	MDI_CHILD_WINDOW(const ZIL_ICHAR *name, UIF_FLAGS _userFlags);
	virtual EVENT_TYPE Event(const UI_EVENT &event);
};
