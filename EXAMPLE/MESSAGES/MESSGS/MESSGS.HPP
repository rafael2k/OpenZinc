//  MESSGS.HPP (MESSGS) - User defined message handling.
//	COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//  Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//  May be freely copied, used and distributed.

// User defined event type.
const EVENT_TYPE U_SET = 12001;

// MY_WINDOW is derived from UIW_WINDOW that understands U_SET event.
class ZIL_EXPORT_CLASS MY_WINDOW : public UIW_WINDOW
{
public:
	MY_WINDOW(int left, int top, int width, int height, ZIL_ICHAR *name);

	virtual EVENT_TYPE Event(const UI_EVENT &event);
};
