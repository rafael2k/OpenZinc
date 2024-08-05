// PALMAP.HPP (PALMAP) - Palette mapping example.
// COPYRIGHT (C) 1990-1995.  All Rights Reserved.
// Zinc Software Incorporated.  Pleasant Grove, Utah  USA
// May be freely copied, used and distributed.


static UI_PALETTE_MAP paletteOne[] =
{
	{ ID_BUTTON, PM_CURRENT,
		{ ' ', attrib(BLUE, LIGHTGREEN), attrib(MONO_BLACK, MONO_HIGH),
		PTN_SOLID_FILL, BLUE, LIGHTGREEN, BW_BLACK, BW_WHITE, GS_BLACK, GS_WHITE } },
	{ ID_BUTTON, PM_ANY,
		{ ' ', attrib(BLUE, RED), attrib(MONO_BLACK, MONO_HIGH),
		PTN_SOLID_FILL, BLUE, RED, BW_BLACK, BW_WHITE, GS_BLACK, GS_WHITE } },
	{ ID_WINDOW, PM_ANY,
		{ ' ', attrib(BLACK, BROWN), attrib(MONO_BLACK, MONO_HIGH),
		PTN_SOLID_FILL, BLACK, BROWN, BW_BLACK, BW_WHITE, GS_BLACK, GS_WHITE } },
	// End of array.
	{ ID_END, 0, { 0, 0, 0, 0, 0, 0 } }
};


static UI_PALETTE_MAP paletteTwo[] =
{
	{ ID_WINDOW_OBJECT, PM_CURRENT,
		{ ' ', attrib(BLUE, WHITE), attrib(MONO_NORMAL, MONO_BLACK),
		PTN_SOLID_FILL, BLUE, WHITE, BW_BLACK, BW_WHITE, GS_BLACK, GS_GRAY } },
	{ ID_WINDOW_OBJECT, PM_ANY,
		{ ' ', attrib(LIGHTGRAY, WHITE), attrib(MONO_NORMAL, MONO_BLACK),
		PTN_SOLID_FILL, LIGHTGRAY, WHITE, BW_BLACK, BW_WHITE, GS_BLACK, GS_GRAY } },

	// ID_OUTLINE for border of strings
	{ ID_OUTLINE, PM_CURRENT,
		{ ' ', attrib(DARKGRAY, LIGHTCYAN), attrib(MONO_NORMAL, MONO_BLACK),
		PTN_SOLID_FILL, DARKGRAY, LIGHTCYAN, BW_BLACK, BW_WHITE, GS_BLACK, GS_GRAY } },
	{ ID_OUTLINE,PM_ANY,
		{ ' ', attrib(LIGHTGRAY, LIGHTCYAN), attrib(MONO_NORMAL, MONO_BLACK),
		PTN_SOLID_FILL, LIGHTGRAY, LIGHTCYAN, BW_BLACK, BW_WHITE, GS_BLACK, GS_GRAY } },
	{ ID_TITLE,PM_ANY,
		{ ' ', attrib(RED, YELLOW), attrib(MONO_NORMAL, MONO_BLACK),
		PTN_SOLID_FILL, RED, YELLOW, BW_BLACK, BW_WHITE, GS_BLACK, GS_GRAY } },
	// Can only have one state entry (PM_ANY) for ID_WINDOW
	{ ID_WINDOW, PM_ANY,
		{ ' ', attrib(BLACK, LIGHTGRAY), attrib(MONO_BLACK, MONO_HIGH),
		PTN_SOLID_FILL, BLACK, LIGHTGRAY, BW_BLACK, BW_WHITE, GS_BLACK, GS_WHITE } },
	// End of array.
	{ ID_END, 0, { 0, 0, 0, 0, 0, 0 } }
};

static UI_PALETTE_MAP paletteThree[] =
{
	// ID_OUTLINE for outside of border
	{ ID_OUTLINE,PM_ANY,
		{ ' ', attrib(BLUE, LIGHTCYAN), attrib(MONO_NORMAL, MONO_BLACK),
		PTN_SOLID_FILL, BLUE, LIGHTCYAN, BW_BLACK, BW_WHITE, GS_BLACK, GS_GRAY } },
	{ ID_BORDER,PM_ANY,
		{ ' ', attrib(RED, LIGHTCYAN), attrib(MONO_NORMAL, MONO_BLACK),
		PTN_SOLID_FILL, RED, LIGHTCYAN, BW_BLACK, BW_WHITE, GS_BLACK, GS_GRAY } },
	// End of array.
	{ ID_END, 0, { 0, 0, 0, 0, 0, 0 } }
};

