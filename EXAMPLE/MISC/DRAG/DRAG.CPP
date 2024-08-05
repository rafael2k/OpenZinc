//	DRAG.CPP (DRAG) - Using drag and drop
//	COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//  May be freely copied, used and distributed.

#include <ui_win.hpp>

int UI_APPLICATION::Main(void)
{
	// This line fixes linkers that don't look for main in the .LIBs.
	UI_APPLICATION::LinkMain();

	// Create window.
	UIW_WINDOW *window = UIW_WINDOW::Generic(2, 2, 40, 16, "Files");

	// Create source list and add scroll bar.
	UIW_VT_LIST *sourceList = new UIW_VT_LIST(2, 2, 15, 5, ZIL_NULLF(ZIL_COMPARE_FUNCTION),
		WNF_SELECT_MULTIPLE, WOF_BORDER, WOAF_ACCEPTS_DROP | WOAF_MOVE_DRAG_OBJECT);
	*sourceList + new UIW_SCROLL_BAR(0, 0, 0, 0);

	// Create target list and add scroll bar.
	UIW_VT_LIST *targetList = new UIW_VT_LIST(20, 2, 15, 5, ZIL_NULLF(ZIL_COMPARE_FUNCTION),
		WNF_SELECT_MULTIPLE, WOF_BORDER, WOAF_ACCEPTS_DROP | WOAF_MOVE_DRAG_OBJECT);
	*targetList + new UIW_SCROLL_BAR(0, 0, 0, 0);

	// Create file rename group.
	UIW_GROUP *renameGroup = new UIW_GROUP(2, 7, 33, 3, "Rename");
	UIW_STRING *originalName = new UIW_STRING(15, 1, 15, "File1.txt", 20);
	UIW_STRING *newName = new UIW_STRING(15, 2, 15, "", 20);
	originalName->woAdvancedFlags |= WOAF_COPY_DRAG_OBJECT;
	newName->woAdvancedFlags |= WOAF_ACCEPTS_DROP;

	*renameGroup
		+ new UIW_PROMPT(1, 1, "Original name:")
		+ originalName
		+ new UIW_PROMPT(1, 2, "New name:")
		+ newName;

	// Add source files to source list.
	for (int i =0; i<10; ++i)
	{
		ZIL_ICHAR buffer[16];
		sprintf(buffer, "File%d", i);
		*sourceList + new UIW_STRING(0, 0, 15, buffer, 20);
	}

	// Add fields to window.
    *window
		+ new UIW_PROMPT(2, 1, "&Files:")
		+ sourceList
		+ new UIW_PROMPT(20, 1, "&Delete Files:")
		+ targetList
		+ renameGroup
		+ &(*new UIW_TEXT(2, 10, 33, 4, "This is a somewhat contrived example "
		  "to demonstrate drag and drop operations.  No operations are "
		  "actually performed on any disk files.  You can move files from "
		  "list to list, depending on which ones you want to \"delete.\" "
		  "You can also copy the filename from the original filename field "
		  "to the new filename field if only minor name changes are required.",
			512, WNF_NO_FLAGS, WOF_VIEW_ONLY | WOF_BORDER)
			+ new UIW_SCROLL_BAR(0, 0, 0, 0));

	// Add window to the window manager.
	*windowManager
		+ window;

	// Process user responses.
	UI_APPLICATION::Control();

	return (0);
}

