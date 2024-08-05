//	COORDS.CPP (COORDS) - Simple coordinate demonstration program.
//	COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//	May be freely copied, used and distributed.

#include <ui_win.hpp>

int UI_APPLICATION::Main()
{
	UI_APPLICATION::LinkMain();

	UIW_WINDOW *win1 = UIW_WINDOW::Generic(1,10,30,5,"Cell based Window");
	UIW_WINDOW *win2 = UIW_WINDOW::Generic(350,100,300,50,"Mini-Cell based Window",
		ZIL_NULLP(UI_WINDOW_OBJECT), WOF_MINICELL);
	UIW_WINDOW *win3 = UIW_WINDOW::Generic(1,1,250,150,"Pixel based Window");

	win3->woStatus |= WOS_GRAPHICS;

	*windowManager
		+ win1
		+ win2
		+ win3;

	Control();

	return (0);
}
