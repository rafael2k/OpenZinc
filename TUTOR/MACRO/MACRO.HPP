//	MACRO.HPP (MACRO) - Macro tutorial program definitions.
//	COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//  May be freely copied, used and distributed.

const ZIL_DEVICE_TYPE E_MACRO	= 89;		// Make sure we are last to be Polled.

struct MACRO_PAIR
{
	ZIL_RAW_CODE rawCode;
	ZIL_ICHAR *macro;
};

class MACRO_HANDLER : public UI_DEVICE
{
public:
	MACRO_HANDLER(MACRO_PAIR *_macroTable) : UI_DEVICE(E_MACRO, D_OFF),
		macroTable(_macroTable) { installed = TRUE; }
	EVENT_TYPE Event(const UI_EVENT &event);

private:
	MACRO_PAIR *macroTable;
	MACRO_PAIR *currentMacro;
	int offset;

	void Poll(void);
};
