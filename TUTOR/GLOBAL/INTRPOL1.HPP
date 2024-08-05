// INTRPOL1.HPP (INTERPOL) - Working with locales
// COPYRIGHT (C) 1990-1995.  All Rights Reserved.
// Zinc Software Incorporated.  Pleasant Grove, Utah  USA
// May be freely copied, used and distributed.

const int GERMANY       = 0;
const int UNITED_STATES = 1;
const int FRANCE        = 2;

const ZIL_USER_EVENT LOCALE_FIRST       = 10000;
const ZIL_USER_EVENT GERMAN_LOC         = 10000;
const ZIL_USER_EVENT US_LOC             = 10001;
const ZIL_USER_EVENT FRANCE_LOC         = 10002;
const ZIL_USER_EVENT LOCALE_LAST        = 10010;


class REPORT_WINDOW : public UIW_WINDOW
{
public:
	REPORT_WINDOW(ZIL_ICHAR *name);
	EVENT_TYPE Event(const UI_EVENT &event);

protected:
	void ConvertAmount(EVENT_TYPE ccode);

private:
	UI_WINDOW_OBJECT *amountField;
	ZIL_ICHAR *currentLocaleName;
};

