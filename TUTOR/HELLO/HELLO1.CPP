//	HELLO.CPP (HELLO)
//	COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//  May be freely copied, used and distributed.

#include <ui_win.hpp>

int UI_APPLICATION::Main(void)
{
	LinkMain();

	UIW_WINDOW *window = UIW_WINDOW::Generic(2, 2, 40, 6, "Hello Window");

	*window
		+ new UIW_TEXT(0, 0, 0, 0, "Hello, Universe!", 256,
			WNF_NO_FLAGS, WOF_NON_FIELD_REGION);

	*windowManager
		+ window;

	Control();

	return (0);
}

