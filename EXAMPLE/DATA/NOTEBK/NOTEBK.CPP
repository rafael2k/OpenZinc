//	NOTEBK.CPP (NOTEBK) - Notebook example program.
//	COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//  May be freely copied, used and distributed.

#include <ui_win.hpp>

UIW_WINDOW *PageOne(void)
{
	// Create the first notebook page.
	UIW_WINDOW *page = new UIW_WINDOW(1, 1, 54, 8);
	*page
		+ new UIW_TITLE("General")
		+ new UIW_PROMPT(2, 1, "Name:")
		+ new UIW_STRING(17, 1, 32, "John Doe", 34)
		+ new UIW_PROMPT(2, 2, "Address:")
		+ new UIW_STRING(17, 2, 32, "405 South 100 East", 32)
		+ new UIW_STRING(17, 3, 32, "2nd Floor", 36)
		+ new UIW_PROMPT(2, 4, "City, State, ZIP:")
		+ new UIW_STRING(17, 4, 18, "Pleasant Grove", 20)
		+ new UIW_STRING(36, 4, 5, "UT", 2, STF_UPPER_CASE)
		+ new UIW_FORMATTED_STRING(42, 4, 7, "84062", "NNNNN", ".....")
		+ new UIW_PROMPT(2, 5, "Phone:")
		+ new UIW_FORMATTED_STRING(17, 5, 18, "8017858900", "LNNNLLNNNLNNNN", "(...) ...-....");
	*page
		+ new UIW_BUTTON(2, 7, 10, "&Begin", BTF_AUTO_SIZE | BTF_NO_TOGGLE | BTF_SEND_MESSAGE,
			WOF_JUSTIFY_CENTER | WOF_NON_SELECTABLE, ZIL_NULLF(ZIL_USER_FUNCTION), S_CHANGE_PAGE)
		+ new UIW_BUTTON(14, 7, 10, "&Previous", BTF_AUTO_SIZE | BTF_NO_TOGGLE | BTF_SEND_MESSAGE,
			WOF_JUSTIFY_CENTER | WOF_NON_SELECTABLE, ZIL_NULLF(ZIL_USER_FUNCTION), S_CHANGE_PAGE)
		+ new UIW_BUTTON(26, 7, 10, "&Next", BTF_AUTO_SIZE | BTF_NO_TOGGLE | BTF_SEND_MESSAGE,
			WOF_JUSTIFY_CENTER, ZIL_NULLF(ZIL_USER_FUNCTION), S_CHANGE_PAGE - 1)
		+ new UIW_BUTTON(38, 7, 10, "&End", BTF_AUTO_SIZE | BTF_NO_TOGGLE | BTF_SEND_MESSAGE,
			WOF_JUSTIFY_CENTER, ZIL_NULLF(ZIL_USER_FUNCTION), S_CHANGE_PAGE - 3);

	return (page);
}

UIW_WINDOW *PageTwo(void)
{

	// Initialize the date information.
	ZIL_DATE birthDate(1960, 3, 20);
	ZIL_DATE startDate(1990, 6, 6);
	
	// Create a combo box and set its default selection.
	UIW_COMBO_BOX *genderCombo = new UIW_COMBO_BOX(20, 4, 20, 2, ZIL_NULLF(ZIL_COMPARE_FUNCTION), WNF_NO_WRAP, 
									WOF_VIEW_ONLY);
	UIW_BUTTON *defaultGender = new UIW_BUTTON(0, 0, 20, "Male", BTF_NO_3D, WOF_NO_FLAGS);
	*genderCombo
		+ new UIW_BUTTON(0, 0, 20, "Female", BTF_NO_3D, WOF_NO_FLAGS)
		+ defaultGender;
	*genderCombo
		+ defaultGender;

	// Create the second notebook page.
	UIW_WINDOW *page = new UIW_WINDOW(1, 1, 54, 8);
	*page
		+ new UIW_TITLE("Accounting")
		+ new UIW_PROMPT(2, 1, "SSN:")
		+ new UIW_FORMATTED_STRING(20, 1, 20, "012345689", "NNNLNNLNNNN", "...-..-....")
		+ new UIW_PROMPT(2, 2, "Birthdate:")
		+ new UIW_DATE(20, 2, 20, &birthDate, "", DTF_SHORT_MONTH)
		+ new UIW_PROMPT(2, 3, "Starting date:")
		+ new UIW_DATE(20, 3, 20, &startDate, "", DTF_SHORT_MONTH)
		+ new UIW_PROMPT(2, 4, "Gender:")
		+ genderCombo
		+ new UIW_PROMPT(2, 5, "Marital status:")
		+ &(*new UIW_COMBO_BOX(20, 5, 20, 2, ZIL_NULLF(ZIL_COMPARE_FUNCTION), WNF_NO_WRAP,
			WOF_VIEW_ONLY)
			+ new UIW_BUTTON(0, 0, 20, "Married", BTF_NO_3D, WOF_NO_FLAGS)
			+ new UIW_BUTTON(0, 0, 20, "Single", BTF_NO_3D, WOF_NO_FLAGS));
	*page
		+ new UIW_BUTTON(2, 7, 10, "&Begin", BTF_AUTO_SIZE | BTF_NO_TOGGLE | BTF_SEND_MESSAGE,
			WOF_JUSTIFY_CENTER, ZIL_NULLF(ZIL_USER_FUNCTION), S_CHANGE_PAGE)
		+ new UIW_BUTTON(14, 7, 10, "&Previous", BTF_AUTO_SIZE | BTF_NO_TOGGLE | BTF_SEND_MESSAGE,
			WOF_JUSTIFY_CENTER, ZIL_NULLF(ZIL_USER_FUNCTION), S_CHANGE_PAGE)
		+ new UIW_BUTTON(26, 7, 10, "&Next", BTF_AUTO_SIZE | BTF_NO_TOGGLE | BTF_SEND_MESSAGE,
			WOF_JUSTIFY_CENTER, ZIL_NULLF(ZIL_USER_FUNCTION), S_CHANGE_PAGE - 2)
		+ new UIW_BUTTON(38, 7, 10, "&End", BTF_AUTO_SIZE | BTF_NO_TOGGLE | BTF_SEND_MESSAGE,
			WOF_JUSTIFY_CENTER, ZIL_NULLF(ZIL_USER_FUNCTION), S_CHANGE_PAGE - 3);

	return (page);
}

UIW_WINDOW *PageThree(void)
{

	// Create the third notebook page.
	UIW_WINDOW *page = new UIW_WINDOW(1, 1, 54, 8);
	*page
		+ new UIW_TITLE("Department")
		+ new UIW_PROMPT(3, 1, "Department:")
		+ &(*new UIW_VT_LIST(3, 2, 20, 3, ZIL_NULLF(ZIL_COMPARE_FUNCTION), WNF_AUTO_SELECT, WOF_BORDER)
			+ new UIW_SCROLL_BAR(0, 0, 0, 0, SBF_VERTICAL)
			+ new UIW_BUTTON(0, 0, 20, "Documentation", BTF_NO_3D, WOF_NO_FLAGS)
			+ new UIW_BUTTON(0, 0, 20, "Marketing", BTF_NO_3D, WOF_NO_FLAGS)
			+ new UIW_BUTTON(0, 0, 20, "R && D", BTF_NO_3D, WOF_NO_FLAGS)
			+ new UIW_BUTTON(0, 0, 20, "Sales", BTF_NO_3D, WOF_NO_FLAGS)
			+ new UIW_BUTTON(0, 0, 20, "Technical Support", BTF_NO_3D, WOF_NO_FLAGS));
	*page
		+ new UIW_PROMPT(3, 5, "Title:")
		+ &(*new UIW_COMBO_BOX(9, 5, 14, 3, ZIL_NULLF(ZIL_COMPARE_FUNCTION), WNF_NO_WRAP,
			WOF_VIEW_ONLY)
			+ new UIW_SCROLL_BAR(0, 0, 0, 0, SBF_VERTICAL)
			+ new UIW_STRING(0, 0, 14, "Accountant", -1, STF_NO_FLAGS, WOF_NO_FLAGS)
			+ new UIW_STRING(0, 0, 14, "Analyst", -1, STF_NO_FLAGS, WOF_NO_FLAGS)
			+ new UIW_STRING(0, 0, 14, "Consultant", -1, STF_NO_FLAGS, WOF_NO_FLAGS)
			+ new UIW_STRING(0, 0, 14, "Engineer", -1, STF_NO_FLAGS, WOF_NO_FLAGS)
			+ new UIW_STRING(0, 0, 14, "Programmer", -1, STF_NO_FLAGS, WOF_NO_FLAGS)
			+ new UIW_STRING(0, 0, 14, "Technician", -1, STF_NO_FLAGS, WOF_NO_FLAGS));
	*page
		+ new UIW_PROMPT(27, 1, "Expertise:")
		+ &(*new UIW_VT_LIST(27, 2, 20, 4, ZIL_NULLF(ZIL_COMPARE_FUNCTION), WNF_AUTO_SELECT, WOF_BORDER)
			+ new UIW_SCROLL_BAR(0, 0, 0, 0, SBF_VERTICAL)
			+ new UIW_BUTTON(0, 0, 20, "Curses", BTF_NO_3D, WOF_NO_FLAGS)
			+ new UIW_BUTTON(0, 0, 20, "DOS Text", BTF_NO_3D, WOF_NO_FLAGS)
			+ new UIW_BUTTON(0, 0, 20, "DOS Graphics", BTF_NO_3D, WOF_NO_FLAGS)
			+ new UIW_BUTTON(0, 0, 20, "Macintosh", BTF_NO_3D, WOF_NO_FLAGS)
			+ new UIW_BUTTON(0, 0, 20, "NEXTSTEP", BTF_NO_3D, WOF_NO_FLAGS)
			+ new UIW_BUTTON(0, 0, 20, "OS/2", BTF_NO_3D, WOF_NO_FLAGS)
			+ new UIW_BUTTON(0, 0, 20, "OSF/Motif", BTF_NO_3D, WOF_NO_FLAGS)
			+ new UIW_BUTTON(0, 0, 20, "Unicode", BTF_NO_3D, WOF_NO_FLAGS)
			+ new UIW_BUTTON(0, 0, 20, "Windows", BTF_NO_3D, WOF_NO_FLAGS));
	*page
		+ new UIW_BUTTON(2, 7, 10, "&Begin", BTF_AUTO_SIZE | BTF_NO_TOGGLE | BTF_SEND_MESSAGE,
			WOF_JUSTIFY_CENTER, ZIL_NULLF(ZIL_USER_FUNCTION), S_CHANGE_PAGE)
		+ new UIW_BUTTON(14, 7, 10, "&Previous", BTF_AUTO_SIZE | BTF_NO_TOGGLE | BTF_SEND_MESSAGE,
			WOF_JUSTIFY_CENTER, ZIL_NULLF(ZIL_USER_FUNCTION), S_CHANGE_PAGE - 1)
		+ new UIW_BUTTON(26, 7, 10, "&Next", BTF_AUTO_SIZE | BTF_NO_TOGGLE | BTF_SEND_MESSAGE,
			WOF_JUSTIFY_CENTER, ZIL_NULLF(ZIL_USER_FUNCTION), S_CHANGE_PAGE - 3)
		+ new UIW_BUTTON(38, 7, 10, "&End", BTF_AUTO_SIZE | BTF_NO_TOGGLE | BTF_SEND_MESSAGE,
			WOF_JUSTIFY_CENTER, ZIL_NULLF(ZIL_USER_FUNCTION), S_CHANGE_PAGE - 3);

	return (page);
}

UIW_WINDOW *PageFour(void)
{

	// Initialize the bignum information.
	ZIL_RBIGNUM value1 = 36.0;
	ZIL_RBIGNUM value2 = 60.0;
	ZIL_BIGNUM sickLeave(value1);
	ZIL_BIGNUM vacation(value2);

	// Create the fourth notebook page.
	UIW_WINDOW *page = new UIW_WINDOW(1, 1, 54, 8);
	*page
		+ new UIW_TITLE("Miscellaneous")
		+ &(*new UIW_GROUP(3, 1, 20, 5, "Health Plans", WNF_SELECT_MULTIPLE)
			+ new UIW_BUTTON(2, 1, 16, "Dental", BTF_NO_3D | BTF_CHECK_BOX, WOF_NO_FLAGS)
			+ new UIW_BUTTON(2, 2, 16, "Medical", BTF_NO_3D | BTF_CHECK_BOX, WOF_NO_FLAGS)
			+ new UIW_BUTTON(2, 3, 16, "Optical", BTF_NO_3D | BTF_CHECK_BOX, WOF_NO_FLAGS)
			+ new UIW_BUTTON(2, 4, 16, "Other", BTF_NO_3D | BTF_CHECK_BOX, WOF_NO_FLAGS))
		+ new UIW_PROMPT(27, 1, "Sick leave:")
		+ new UIW_BIGNUM(38, 1, 9, &sickLeave, "0..64", NMF_DECIMAL(1))
		+ new UIW_PROMPT(27, 2, "Vacation:")
		+ new UIW_BIGNUM(38, 2, 9, &vacation, "0..96", NMF_DECIMAL(1))
		+ &(*new UIW_GROUP(27, 3, 20, 3, "Status", WNF_AUTO_SELECT)
			+ new UIW_BUTTON(2, 1, 16, "Active", BTF_NO_3D | BTF_RADIO_BUTTON, WOF_NO_FLAGS)
			+ new UIW_BUTTON(2, 2, 16, "Inactive", BTF_NO_3D | BTF_RADIO_BUTTON, WOF_NO_FLAGS));
	*page
		+ new UIW_BUTTON(2, 7, 10, "&Begin", BTF_AUTO_SIZE | BTF_NO_TOGGLE | BTF_SEND_MESSAGE,
			WOF_JUSTIFY_CENTER, ZIL_NULLF(ZIL_USER_FUNCTION), S_CHANGE_PAGE)
		+ new UIW_BUTTON(14, 7, 10, "&Previous", BTF_AUTO_SIZE | BTF_NO_TOGGLE | BTF_SEND_MESSAGE,
			WOF_JUSTIFY_CENTER, ZIL_NULLF(ZIL_USER_FUNCTION), S_CHANGE_PAGE - 2)
		+ new UIW_BUTTON(26, 7, 10, "&Next", BTF_AUTO_SIZE | BTF_NO_TOGGLE | BTF_SEND_MESSAGE,
			WOF_JUSTIFY_CENTER | WOF_NON_SELECTABLE, ZIL_NULLF(ZIL_USER_FUNCTION), S_CHANGE_PAGE - 3)
		+ new UIW_BUTTON(38, 7, 10, "&End", BTF_AUTO_SIZE | BTF_NO_TOGGLE | BTF_SEND_MESSAGE,
			WOF_JUSTIFY_CENTER | WOF_NON_SELECTABLE, ZIL_NULLF(ZIL_USER_FUNCTION), S_CHANGE_PAGE - 3);

	return (page);
}

int UI_APPLICATION::Main(void)
{
	// The UI_APPLICATION constructor automatically initializes the 
	// display, eventManager, and windowManager variables.

	// This line fixes linkers that don't look for main in the .LIBs.
	UI_APPLICATION::LinkMain();

	// Initialize the error system.
	UI_WINDOW_OBJECT::errorSystem = new UI_ERROR_SYSTEM;

	// Create a window and a notebook.
	UIW_WINDOW *window = new UIW_WINDOW(15, 0, 54, 11, WOF_NO_FLAGS, WOAF_NO_SIZE);
	*window
		+ new UIW_BORDER
		+ new UIW_MINIMIZE_BUTTON
		+ new UIW_SYSTEM_BUTTON(SYF_GENERIC)
		+ new UIW_TITLE("Employee Record");
	UIW_NOTEBOOK *noteBook = new UIW_NOTEBOOK;

	// Add four pages (windows) to the notebook.
	*noteBook
		+ PageOne()
		+ PageTwo()
		+ PageThree()
		+ PageFour();

	// Add the notebook to the window.
	*window + noteBook;

	// Center the window and add it to the window manager.
	windowManager->Center(window);
	*windowManager
		+ window;

	// Process user responses.
	UI_APPLICATION::Control();

	// Clean up.
	delete UI_WINDOW_OBJECT::errorSystem;

	return (0);
}
