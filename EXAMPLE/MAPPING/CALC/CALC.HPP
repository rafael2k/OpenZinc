//	CALC.HPP (CALC) - Sample calculator
//	COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//  May be freely copied, used and distributed.

#if defined(ZIL_MSDOS)
const ZIL_RAW_CODE ALT_EQUAL = 0x8300;
const ZIL_RAW_CODE ALT_WHITE_DIVIDE = 0x3500;
#elif defined(ZIL_MSWINDOWS)
const ZIL_RAW_CODE ALT_EQUAL = 0x083D;
const ZIL_RAW_CODE ALT_WHITE_DIVIDE = 0x3500;
#elif defined(ZIL_OS2)
const ZIL_RAW_CODE ALT_EQUAL = 0x0D000008;
const ZIL_RAW_CODE ALT_WHITE_DIVIDE = 0x35000008;
#endif

// Definition of the calculator class.
class CALCULATOR : public UIW_WINDOW
{
public:
	CALCULATOR(int left, int top, char *title);

private:
	UIW_STRING *numberField;
	UIW_PROMPT *memField;
	ZIL_ICHAR buff[20];
	double operand1;
	double operand2;
	int operatorLast;
	ZIL_UINT8 operation;
	double decimal;
	double memory;

	static EVENT_TYPE ButtonFunction(UI_WINDOW_OBJECT *button, UI_EVENT &event, EVENT_TYPE ccode);
	void Display(UI_WINDOW_OBJECT *button);
};
