//	CALC.CPP (CALC) - Sample calculator
//	COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//  May be freely copied, used and distributed.

extern "C"
{
#if !defined(__MWERKS__)
#	include <string.h>
#endif
#include <stdio.h>
}
#define USE_RAW_KEYS
#include <ui_win.hpp>
#include "calc.hpp"


#if defined(ZIL_MSDOS) || defined(ZIL_OS2) || defined(ZIL_MSWINDOWS)
static UI_EVENT_MAP hotKeyMapTable[] =
{
	// ID_WINDOW_OBJECT.
	{ ID_WINDOW_OBJECT, 	HOT_KEY_SYSTEM,		E_KEY, 		ALT_SPACE,				0 },
	{ ID_WINDOW_OBJECT, 	HOT_KEY_MINIMIZE,	E_KEY, 		ALT_F9,					0 },
	{ ID_WINDOW_OBJECT, 	HOT_KEY_MAXIMIZE,	E_KEY, 		ALT_F10,				0 },

	{ ID_WINDOW_OBJECT, 	'+',				E_KEY, 		ALT_GRAY_PLUS,			0 },
	{ ID_WINDOW_OBJECT, 	'+',				E_KEY, 		ALT_WHITE_PLUS, 		S_SHIFT },
	{ ID_WINDOW_OBJECT, 	'-',				E_KEY, 		ALT_GRAY_MINUS,			0 },
	{ ID_WINDOW_OBJECT, 	'-',				E_KEY, 		ALT_WHITE_MINUS,		0 },
	{ ID_WINDOW_OBJECT, 	'*',				E_KEY, 		ALT_GRAY_MULTIPLY,		0 },
	{ ID_WINDOW_OBJECT, 	'*',				E_KEY, 		ALT_8, 					S_SHIFT },
	{ ID_WINDOW_OBJECT, 	'/',				E_KEY, 		ALT_GRAY_DIVIDE,		0 },
	{ ID_WINDOW_OBJECT, 	'/',				E_KEY, 		ALT_WHITE_DIVIDE,		0 },
	{ ID_WINDOW_OBJECT, 	'.',				E_KEY, 		ALT_PERIOD,				0 },
	{ ID_WINDOW_OBJECT, 	'=',				E_KEY, 		ALT_EQUAL,				0 },

	{ ID_WINDOW_OBJECT, 	'c',				E_KEY, 		ALT_C,					0 },
	{ ID_WINDOW_OBJECT, 	'e',				E_KEY, 		ALT_E,					0 },
	{ ID_WINDOW_OBJECT, 	'p',				E_KEY, 		ALT_P,					0 },
	{ ID_WINDOW_OBJECT, 	'm',				E_KEY, 		ALT_M,					0 },
	{ ID_WINDOW_OBJECT, 	'r',				E_KEY, 		ALT_R,					0 },
	{ ID_WINDOW_OBJECT, 	's',				E_KEY, 		ALT_S,					0 },

	{ ID_WINDOW_OBJECT, 	'1',				E_KEY, 		ALT_1,					0 },
	{ ID_WINDOW_OBJECT, 	'2',				E_KEY, 		ALT_2,					0 },
	{ ID_WINDOW_OBJECT, 	'3',				E_KEY, 		ALT_3,					0 },
	{ ID_WINDOW_OBJECT, 	'4',				E_KEY, 		ALT_4,					0 },
	{ ID_WINDOW_OBJECT, 	'5',				E_KEY, 		ALT_5,					0 },
	{ ID_WINDOW_OBJECT, 	'6',				E_KEY, 		ALT_6,					0 },
	{ ID_WINDOW_OBJECT, 	'7',				E_KEY, 		ALT_7,					0 },
	{ ID_WINDOW_OBJECT, 	'8',				E_KEY, 		ALT_8,					0 },
	{ ID_WINDOW_OBJECT, 	'9',				E_KEY, 		ALT_9,					0 },
	{ ID_WINDOW_OBJECT, 	'0',				E_KEY, 		ALT_0,					0 },

	// End of array.
	{ ID_END, 0, 0, 0, 0 }
};
#elif defined(ZIL_MOTIF) || defined(ZIL_MACINTOSH) || defined(ZIL_NEXTSTEP)
static UI_EVENT_MAP hotKeyMapTable[] =
{
	// End of array.
	{ ID_END, 0, 0, 0 }
};
#elif defined(ZIL_CURSES)
static UI_EVENT_MAP hotKeyMapTable[] =
{
	// ID_WINDOW_OBJECT.
	{ ID_WINDOW_OBJECT, 	HOT_KEY_SYSTEM,		E_KEY, 		' ', S_ALT },
	{ ID_WINDOW_OBJECT, 	HOT_KEY_MINIMIZE,	E_KEY, 		F9, S_ALT },
	{ ID_WINDOW_OBJECT, 	HOT_KEY_MAXIMIZE,	E_KEY, 		F10, S_ALT },

	{ ID_WINDOW_OBJECT, 	'+',				E_KEY, 		'+', S_ALT },
	{ ID_WINDOW_OBJECT, 	'-',				E_KEY, 		'-', S_ALT },
	{ ID_WINDOW_OBJECT, 	'*',				E_KEY, 		'*', S_ALT },
	{ ID_WINDOW_OBJECT, 	'/',				E_KEY, 		'/', S_ALT },
	{ ID_WINDOW_OBJECT, 	'.',				E_KEY, 		'.', S_ALT },
	{ ID_WINDOW_OBJECT, 	'=',				E_KEY, 		'=', S_ALT },

	{ ID_WINDOW_OBJECT, 	'c',				E_KEY, 		'c', S_ALT },
	{ ID_WINDOW_OBJECT, 	'e',				E_KEY, 		'e', S_ALT },
	{ ID_WINDOW_OBJECT, 	'p',				E_KEY, 		'p', S_ALT },
	{ ID_WINDOW_OBJECT, 	'm',				E_KEY, 		'm', S_ALT },
	{ ID_WINDOW_OBJECT, 	'r',				E_KEY, 		'r', S_ALT },
	{ ID_WINDOW_OBJECT, 	's',				E_KEY, 		's', S_ALT },

	{ ID_WINDOW_OBJECT, 	'1',				E_KEY, 		'1', S_ALT },
	{ ID_WINDOW_OBJECT, 	'2',				E_KEY, 		'2', S_ALT },
	{ ID_WINDOW_OBJECT, 	'3',				E_KEY, 		'3', S_ALT },
	{ ID_WINDOW_OBJECT, 	'4',				E_KEY, 		'4', S_ALT },
	{ ID_WINDOW_OBJECT, 	'5',				E_KEY, 		'5', S_ALT },
	{ ID_WINDOW_OBJECT, 	'6',				E_KEY, 		'6', S_ALT },
	{ ID_WINDOW_OBJECT, 	'7',				E_KEY, 		'7', S_ALT },
	{ ID_WINDOW_OBJECT, 	'8',				E_KEY, 		'8', S_ALT },
	{ ID_WINDOW_OBJECT, 	'9',				E_KEY, 		'9', S_ALT },
	{ ID_WINDOW_OBJECT, 	'0',				E_KEY, 		'0', S_ALT },

	// End of array.
	{ ID_END, 0, 0, 0 }
};
#endif

CALCULATOR::CALCULATOR(int left, int top, char *title) :
	UIW_WINDOW(left, top, 25, 11, WOF_NO_FLAGS, WOAF_NO_SIZE | WOAF_NORMAL_HOT_KEYS)
{
	
	// Read in the icon from storage
	ZIL_STORAGE_READ_ONLY storage("p_calc.dat");
	UI_WINDOW_OBJECT::defaultStorage = &storage;

	// Initialize the calculator values.
	operand1 = 0.0;
	operand2 = 0.0;
	operatorLast = TRUE;
	operation = '=';
	decimal = 0.0;
	memory = 0.0;

	// Create the memory and number display fields.
	memField = new UIW_PROMPT(1, 1, 3, " ", WOF_JUSTIFY_CENTER);
	
	strcpy(buff, "0");
	numberField = new UIW_STRING(4, 1, 17, buff, sizeof(buff) - 1, STF_NO_FLAGS,
		WOF_BORDER | WOF_JUSTIFY_RIGHT | WOF_VIEW_ONLY | WOF_NO_ALLOCATE_DATA);
	numberField->woAdvancedFlags |= WOAF_NON_CURRENT;
	
   	// Add the buttons and other objects.
	*this
		+ new UIW_BORDER
		+ new UIW_MINIMIZE_BUTTON

		+ &(*new UIW_SYSTEM_BUTTON
			+ new UIW_POP_UP_ITEM("~Restore", MNIF_RESTORE, BTF_NO_TOGGLE, WOF_NO_FLAGS, 0)
			+ new UIW_POP_UP_ITEM("~Move", MNIF_MOVE, BTF_NO_TOGGLE, WOF_NO_FLAGS, 0)
			+ new UIW_POP_UP_ITEM("Mi~nimize", MNIF_MINIMIZE, BTF_NO_TOGGLE, WOF_NO_FLAGS, 0)
			+ new UIW_POP_UP_ITEM
			+ new UIW_POP_UP_ITEM("~Close", MNIF_CLOSE, BTF_NO_TOGGLE, WOF_NO_FLAGS, 0))
		+ new UIW_TITLE(title, WOF_JUSTIFY_CENTER)
		+ memField
		+ numberField;
	*this
		+ new UIW_BUTTON(2, 3, 4, "~C", BTF_NO_TOGGLE, WOF_JUSTIFY_CENTER, CALCULATOR::ButtonFunction)
	  	+ new UIW_BUTTON(6, 3, 4, "C~E", BTF_NO_TOGGLE, WOF_JUSTIFY_CENTER, CALCULATOR::ButtonFunction)
		+ new UIW_BUTTON(2, 4, 4, "~MC", BTF_NO_TOGGLE, WOF_JUSTIFY_CENTER, CALCULATOR::ButtonFunction)
		+ new UIW_BUTTON(6, 4, 4, "~7", BTF_NO_TOGGLE, WOF_JUSTIFY_CENTER, CALCULATOR::ButtonFunction)
		+ new UIW_BUTTON(10, 4, 4, "~8", BTF_NO_TOGGLE, WOF_JUSTIFY_CENTER, CALCULATOR::ButtonFunction)
		+ new UIW_BUTTON(14, 4, 4, "~9", BTF_NO_TOGGLE, WOF_JUSTIFY_CENTER, CALCULATOR::ButtonFunction)
		+ new UIW_BUTTON(18, 4, 4, "~/", BTF_NO_TOGGLE, WOF_JUSTIFY_CENTER, CALCULATOR::ButtonFunction);
	*this
		+ new UIW_BUTTON(2, 5, 4, "M~R", BTF_NO_TOGGLE, WOF_JUSTIFY_CENTER, CALCULATOR::ButtonFunction)
		+ new UIW_BUTTON(6, 5, 4, "~4", BTF_NO_TOGGLE, WOF_JUSTIFY_CENTER, CALCULATOR::ButtonFunction)
		+ new UIW_BUTTON(10, 5, 4, "~5", BTF_NO_TOGGLE, WOF_JUSTIFY_CENTER, CALCULATOR::ButtonFunction)
		+ new UIW_BUTTON(14, 5, 4, "~6", BTF_NO_TOGGLE, WOF_JUSTIFY_CENTER, CALCULATOR::ButtonFunction)
		+ new UIW_BUTTON(18, 5, 4, "~-", BTF_NO_TOGGLE, WOF_JUSTIFY_CENTER, CALCULATOR::ButtonFunction);
	*this
		+ new UIW_BUTTON(2, 6, 4, "M~S", BTF_NO_TOGGLE, WOF_JUSTIFY_CENTER, CALCULATOR::ButtonFunction)
		+ new UIW_BUTTON(6, 6, 4, "~1", BTF_NO_TOGGLE, WOF_JUSTIFY_CENTER, CALCULATOR::ButtonFunction)
		+ new UIW_BUTTON(10, 6, 4, "~2", BTF_NO_TOGGLE, WOF_JUSTIFY_CENTER, CALCULATOR::ButtonFunction)
		+ new UIW_BUTTON(14, 6, 4, "~3", BTF_NO_TOGGLE, WOF_JUSTIFY_CENTER, CALCULATOR::ButtonFunction)
		+ new UIW_BUTTON(18, 6, 4, "~*", BTF_NO_TOGGLE, WOF_JUSTIFY_CENTER, CALCULATOR::ButtonFunction);
	*this
		+ new UIW_BUTTON(2, 7, 4, "M~P", BTF_NO_TOGGLE, WOF_JUSTIFY_CENTER, CALCULATOR::ButtonFunction)
		+ new UIW_BUTTON(6, 7, 4, "~.", BTF_NO_TOGGLE, WOF_JUSTIFY_CENTER, CALCULATOR::ButtonFunction)
		+ new UIW_BUTTON(10, 7, 4, "~0", BTF_NO_TOGGLE, WOF_JUSTIFY_CENTER, CALCULATOR::ButtonFunction)
		+ new UIW_BUTTON(14, 7, 4, "~=", BTF_NO_TOGGLE, WOF_JUSTIFY_CENTER, CALCULATOR::ButtonFunction)
		+ new UIW_BUTTON(18, 7, 4, "~+", BTF_NO_TOGGLE, WOF_JUSTIFY_CENTER, CALCULATOR::ButtonFunction)
		+ new UIW_ICON (0, 0, "calc", "Calculator", ICF_MINIMIZE_OBJECT, WOF_NO_FLAGS);
}

EVENT_TYPE CALCULATOR::ButtonFunction(UI_WINDOW_OBJECT *button, UI_EVENT &, EVENT_TYPE ccode)
{
	if (ccode != L_SELECT)
		return 0;
	
	CALCULATOR *calculator = (CALCULATOR *)button->parent;
	calculator->Display(button);
	return S_CONTINUE;
}

void CALCULATOR::Display(UI_WINDOW_OBJECT *button)
{
	// Switch on the button value.
	char ch = button->HotKey();
	switch (ch)
	{
	// Clear the calculator.
	case 'C' :
	case 'c' :
		decimal =
			operand1 =
			operand2 = 0.0;
		operation = '=';	
		strcpy(buff, "0");
		numberField->DataSet(buff);
		break;

	case 'E' :
	case 'e' :
		operand2 = 0.0;
		strcpy(buff, "0");
		numberField->DataSet(buff);
		break;

	// Memory operations.
	case 'M' :
	case 'm' :
		memory = 0.0;
		memField->DataSet(" ");
		break;
		
	case 'R' :
	case 'r' :
		decimal = 0.0;
		operatorLast = FALSE;
		operand1 = operand2;
		operand2 = memory;
		sprintf(buff, "%lg", operand2);
		numberField->DataSet(buff);
		operand1 = 0.0;
		operatorLast = TRUE;
		break;

   	case 'S' :
   	case 's' :
		memory = operand2;
		memField->DataSet("M");
		operand1 = 0.0;
		operatorLast = TRUE;
		break;

	case 'P' :
	case 'p' :
		memory += operand2;
		memField->DataSet("M");
		operand1 = 0.0;
		operatorLast = TRUE;
		break;

	// Operations.
	case '/' :
	case '*' :
	case '-' :
	case '+' :
	case '=' :
		if (operation != '=' && !operatorLast)
		{
			switch (operation)
			{
			case '/' :
				if (operand2 != 0.0)
					operand2 = operand1 / operand2;
				else
					operand2 = 0.0;
				break;

			case '*' :
				operand2 *= operand1;
				break;

			case '-' :
				operand2 = operand1 - operand2;
				break;

			case '+' :
				operand2 += operand1;
				break;

			}
			operand1 = 0.0;
			sprintf(buff, "%lg", operand2);
			numberField->DataSet(buff);
		}
		decimal = 0.0;
		operatorLast = TRUE;
		operation = button->HotKey();
		break;

	// Decimal placed.
	case '.' :
		if (decimal == 0.0)
		{
			decimal = .1;
			strcat(buff, ".");
		}
		if (operatorLast)
		{
			operatorLast = FALSE;
			operand1 = operand2;
			operand2 = 0.0;
			strcpy(buff, "0.");
		}
		numberField->DataSet(buff);
		break;

	// Digit pressed.
	default:
		if (operatorLast)
		{
			operatorLast = FALSE;
			operand1 = operand2;
			operand2 = 0.0;
			buff[0] = 0;
		}
		if (decimal == 0.0 )
			operand2 = operand2 * 10 + button->HotKey() - '0';
		else if (decimal > 0.0000001)
		{
			operand2 = operand2 + (button->HotKey() - '0') * decimal;
			decimal /= 10.0;
		}
		buff[strlen(buff)+1] = 0;
		buff[strlen(buff)] = ch;
		numberField->DataSet(buff);
		break;
	}
}

int UI_APPLICATION::Main(void)
{
	// The UI_APPLICATION constructor automatically initializes the
	// display, eventManager, and windowManager variables.

	// This line fixes linkers that don't look for main in the .LIBs.
	UI_APPLICATION::LinkMain();

	// Set up the hotkey table
	extern UI_EVENT_MAP *_hotKeyMapTable;
	_hotKeyMapTable = hotKeyMapTable;

	// Create a window in the screen center.
	int left = display->columns / display->cellWidth / 2 - 13;
	int top = display->lines / display->cellHeight / 2 - 5;
	
	*windowManager + new CALCULATOR(left, top, "Calculator");

	// Process user responses.
	UI_APPLICATION::Control();

	return (0);
}

#if defined(ZIL_LINKBUG)
void z_jump_dummy(void) { }   // Bug fix for broken linkers.
#endif

static UI_ITEM _userTable[] =
{
	{ ID_END, ZIL_NULLP(void), ZIL_NULLP(ZIL_ICHAR), 0 }
};
UI_ITEM *UI_WINDOW_OBJECT::userTable = _userTable;

static UI_ITEM _objectTable[] =
{
	{ ID_ICON, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_ICON::New), "ICON", 0 },
	{ ID_END, ZIL_NULLP(void), ZIL_NULLP(ZIL_ICHAR), 0 }
};
UI_ITEM *UI_WINDOW_OBJECT::objectTable = _objectTable;
