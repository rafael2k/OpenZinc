//	FONTS.CPP (FONTS) - Shows how to	load a new font into the font table.
//	COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//	May be freely copied, used and distributed.

#include <ui_win.hpp>
#include <gfx.h>
#include "fonts.hpp"

void LoadFont(UI_DISPLAY *)
{
 	UI_GRAPHICS_DISPLAY::fontTable[FNT_NEW_FONT].font = ROM_8x14;
}
