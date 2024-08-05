//  GMGR.CPP (GMGR) - Using geometry management
//  COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//  Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//  May be freely copied, used and distributed.

#include <ui_win.hpp>

//	BasicGMWindow creates a window that shows the use of simple Geometry
//	management.  It shows four buttons, each of which is attached to a
//	corner of the window.  It also has a stretching text object attached
//	to all edges of the parent, with offsets.
UIW_WINDOW *BasicGMWindow(void)
{
	UIW_BUTTON *upperLeft;		// Stays in top left.
	UIW_BUTTON *upperRight;		// Stays in top right.
	UIW_BUTTON *lowerLeft;		// Stays in bottom left.
	UIW_BUTTON *lowerRight;		// Stays in bottom right.
	UIW_TEXT *text;				// Stays in middle and stretches.
	char *textString = "This text window is attached on all four edges "
		"and has a minimum and maximum size.";

	UI_GEOMETRY_MANAGER *geometryManager = new UI_GEOMETRY_MANAGER();

	UIW_WINDOW *window = &(*UIW_WINDOW::Generic(1, 1, 35, 8,
			"Basic Geometry Managment")
		+ geometryManager
		+ (upperLeft = new UIW_BUTTON(0, 0, 12, "Upper Left", BTF_NO_TOGGLE))
		+ (upperRight = new UIW_BUTTON(0, 0, 12, "Upper Right", BTF_NO_TOGGLE))
		+ (lowerLeft = new UIW_BUTTON(0, 0, 12, "Lower Left", BTF_NO_TOGGLE))
		+ (lowerRight = new UIW_BUTTON(0, 0, 12, "Lower Right", BTF_NO_TOGGLE))
		+ (text = new UIW_TEXT(0, 0, 10, 1, textString, 256, WNF_NO_FLAGS))
		);
	
	*geometryManager
		// Attach upperLeft to parent's top and left, etc.
		+ new UI_ATTACHMENT(upperLeft, ATCF_TOP)
		+ new UI_ATTACHMENT(upperLeft, ATCF_LEFT)

		// When the object and offset are the same, you can combine attachments.
		+ new UI_ATTACHMENT(upperRight, ATCF_TOP | ATCF_RIGHT)
		+ new UI_ATTACHMENT(lowerLeft, ATCF_BOTTOM | ATCF_LEFT)
		+ new UI_ATTACHMENT(lowerRight, ATCF_BOTTOM | ATCF_RIGHT)

		// Attach text 3 cellWidths from parent's sides.
		// Since we are fixing opposite sides of text, specify ATCF_STRETCH.
		+ new UI_ATTACHMENT(text, ATCF_LEFT | ATCF_RIGHT | ATCF_STRETCH, 3)

		// Attach text 3 cellHeights from parent's top and bottom.
		+ new UI_ATTACHMENT(text, ATCF_TOP | ATCF_BOTTOM | ATCF_STRETCH, 2)

		// Force text's with between 20 and 50, and height between 1 and 8.
		+ new UI_DIMENSION_CONSTRAINT(text, DNCF_WIDTH, 20, 50)
		+ new UI_DIMENSION_CONSTRAINT(text, DNCF_HEIGHT, 1, 8)
		;
	return window;
}

UIW_WINDOW *TieGMWindow(void)
{
	UIW_BUTTON *upperLeft;		//	Stays in top left.
	UIW_BUTTON *leftTie1;		//	My left stays by upperLeft's right.
	UIW_BUTTON *leftTie2;		//	My left stays by leftTie1's right.
	UIW_BUTTON *lowerRight;		//	Stays in bottom right.
	UIW_BUTTON *rightTie1;		//	My right stays by lowerRight's left.
	UIW_BUTTON *rightTie2;		//	My right stays by rightTie1's left.

	UI_GEOMETRY_MANAGER *geometryManager = new UI_GEOMETRY_MANAGER();

	UIW_WINDOW *window = &(*UIW_WINDOW::Generic(40, 1, 35, 8,
			"Tie Geometry Managment")
		+ geometryManager
		+ (upperLeft = new UIW_BUTTON(0, 0, 12, "Upper Left"))
		+ (lowerRight = new UIW_BUTTON(0, 0, 12, "Lower Right"))
		+ (leftTie1 = new UIW_BUTTON(0, 0, 8, "Tie Left"))
		+ (leftTie2 = new UIW_BUTTON(0, 0, 8, "Tie Left"))
		+ (rightTie1 = new UIW_BUTTON(0, 0, 8, "Tie Right"))
		+ (rightTie2 = new UIW_BUTTON(0, 0, 8, "Tie Right"))
		);
	
	*geometryManager
		// Attach upperLeft's top and left 1 cell from parent's edges.
		+ new UI_ATTACHMENT(upperLeft, ATCF_TOP | ATCF_LEFT, 1)

		// Force leftTie1's top to be the same as upperLeft's.
		+ new UI_ATTACHMENT(leftTie1, upperLeft, ATCF_TOP)

		// Force leftTie1's left to be 1 cell from upperLeft's right.
		+ new UI_ATTACHMENT(leftTie1, upperLeft, ATCF_LEFT | ATCF_OPPOSITE, 1)

		// Force leftTie2's top to be the same as upperLeft's.
		+ new UI_ATTACHMENT(leftTie2, upperLeft, ATCF_TOP)

		// Force leftTie2's left to be 1 cell from leftTie1's right.
		+ new UI_ATTACHMENT(leftTie2, leftTie1, ATCF_LEFT | ATCF_OPPOSITE, 1)

		// These attachments are similar to those above.
		+ new UI_ATTACHMENT(lowerRight, ATCF_BOTTOM | ATCF_RIGHT, 1)
		+ new UI_ATTACHMENT(rightTie1, lowerRight, ATCF_TOP)
		+ new UI_ATTACHMENT(rightTie1, lowerRight,
			ATCF_RIGHT | ATCF_OPPOSITE, 1)
		+ new UI_ATTACHMENT(rightTie2, rightTie1, ATCF_TOP)
		+ new UI_ATTACHMENT(rightTie2, rightTie1,
			ATCF_RIGHT | ATCF_OPPOSITE, 1)
		;
	return window;
}

//	This window shows the use of opposite attachments, where, for example,
//	an object's top is attached to another object's bottom.
UIW_WINDOW *OppositeGMWindow(void)
{
	UIW_BUTTON *upperLeft;	// My bottom right offset from parent's top left.
	UIW_BUTTON *upperRight;	// My bottom left offset from parent's top right.
	UIW_BUTTON *lowerLeft;	// My top right offset from parent's bottom left.
	UIW_BUTTON *lowerRight;	// My top left offset from parent's bottom right.

	UI_GEOMETRY_MANAGER *geometryManager = new UI_GEOMETRY_MANAGER();

	UIW_WINDOW *window = &(*UIW_WINDOW::Generic(1, 12, 38, 8,
			"Opposite Geometry Management")
		+ geometryManager
		+ (upperRight = new UIW_BUTTON(0, 0, 13, "Opposite UR"))
		+ (upperLeft = new UIW_BUTTON(0, 0, 15, "Opposite UL"))
		+ (lowerRight = new UIW_BUTTON(0, 0, 15, "Opposite LR"))
		+ (lowerLeft = new UIW_BUTTON(0, 0, 13, "Opposite LL"))
		);

	*geometryManager
		+ new UI_ATTACHMENT(upperLeft, ATCF_BOTTOM | ATCF_OPPOSITE, 2)
		+ new UI_ATTACHMENT(upperLeft, ATCF_RIGHT | ATCF_OPPOSITE, 18)
		+ new UI_ATTACHMENT(upperRight, ATCF_BOTTOM | ATCF_OPPOSITE, 2)
		+ new UI_ATTACHMENT(upperRight, ATCF_LEFT | ATCF_OPPOSITE, 18)
		+ new UI_ATTACHMENT(lowerLeft, ATCF_TOP | ATCF_OPPOSITE, 2)
		+ new UI_ATTACHMENT(lowerLeft, ATCF_RIGHT | ATCF_OPPOSITE, 18)
		+ new UI_ATTACHMENT(lowerRight, ATCF_TOP | ATCF_OPPOSITE, 2)
		+ new UI_ATTACHMENT(lowerRight, ATCF_LEFT | ATCF_OPPOSITE, 18)
		;
	return window;
}

UIW_WINDOW *RelativeGMWindow(void)
{
	UIW_BUTTON *upperLeft;	// I grow as needed.
	UIW_BUTTON *upperRight;	
	UIW_BUTTON *lowerLeft;
	UIW_BUTTON *lowerRight;	// I grow as needed.
	UIW_BUTTON *center;		// I always stay in center.

	UI_GEOMETRY_MANAGER *geometryManager = new UI_GEOMETRY_MANAGER();

	UIW_WINDOW *window = &(*UIW_WINDOW::Generic(40, 12, 38, 8,
			"Relative Geometry Management")
		+ geometryManager
		+ (upperLeft = new UIW_BUTTON(0, 0, 15, "Relative UL", BTF_NO_TOGGLE))
		+ (upperRight = new UIW_BUTTON(0, 0, 15, "Relative UR", BTF_NO_TOGGLE))
		+ (lowerLeft = new UIW_BUTTON(0, 0, 15, "Relative LL", BTF_NO_TOGGLE))
		+ (lowerRight = new UIW_BUTTON(0, 0, 15, "Relative LR", BTF_NO_TOGGLE))
		+ (center = new UIW_BUTTON(0, 0, 15, "Center", BTF_NO_TOGGLE))
		);

	*geometryManager
		+ new UI_RELATIVE_CONSTRAINT(upperLeft, RLCF_LEFT | RLCF_TOP, 10)
		+ new UI_RELATIVE_CONSTRAINT(upperLeft,
			RLCF_RIGHT | RLCF_BOTTOM | RLCF_STRETCH, 40)
		+ new UI_RELATIVE_CONSTRAINT(upperRight, RLCF_RIGHT, 90)
		+ new UI_RELATIVE_CONSTRAINT(upperRight, RLCF_TOP, 10)
		+ new UI_RELATIVE_CONSTRAINT(lowerLeft, RLCF_LEFT, 10)
		+ new UI_RELATIVE_CONSTRAINT(lowerLeft, RLCF_BOTTOM, 90)
		+ new UI_RELATIVE_CONSTRAINT(lowerRight, RLCF_LEFT | RLCF_TOP, 60)
		+ new UI_RELATIVE_CONSTRAINT(lowerRight,
			RLCF_RIGHT | RLCF_BOTTOM | RLCF_STRETCH, 90)
		+ new UI_RELATIVE_CONSTRAINT(center, RLCF_LEFT | RLCF_TOP | RLCF_STRETCH, 40)
		+ new UI_RELATIVE_CONSTRAINT(center, RLCF_RIGHT | RLCF_BOTTOM | RLCF_STRETCH, 60)
		;
	return window;
}

UIW_WINDOW *CenterGMWindow(void)
{
	UIW_BUTTON *upperLeft;
	UIW_BUTTON *upperRight;	
	UIW_BUTTON *lowerLeft;
	UIW_BUTTON *lowerLeft1;
	UIW_BUTTON *lowerRight;
	UIW_BUTTON *lowerRight1;
	UIW_BUTTON *center;

	UI_GEOMETRY_MANAGER *geometryManager = new UI_GEOMETRY_MANAGER();

	UIW_WINDOW *window = &(*UIW_WINDOW::Generic(20, 6, 38, 8,
			"Center Geometry Management")
		+ geometryManager
		+ (upperLeft = new UIW_BUTTON(0, 0, 8, "UL", BTF_NO_TOGGLE))
		+ (upperRight = new UIW_BUTTON(0, 0, 8, "UR", BTF_NO_TOGGLE))
		+ (lowerLeft = new UIW_BUTTON(0, 0, 8, "LL", BTF_NO_TOGGLE))
		+ (lowerLeft1 = new UIW_BUTTON(0, 0, 8, "LLC", BTF_NO_TOGGLE))
		+ (lowerRight = new UIW_BUTTON(0, 0, 8, "LR", BTF_NO_TOGGLE))
		+ (lowerRight1 = new UIW_BUTTON(0, 0, 8, "LRC", BTF_NO_TOGGLE))
		+ (center = new UIW_BUTTON(0, 0, 15, "Center", BTF_NO_TOGGLE))
		);

	*geometryManager
		+ new UI_RELATIVE_CONSTRAINT(upperLeft, RLCF_VERTICAL_CENTER | RLCF_HORIZONTAL_CENTER, 15)
		+ new UI_RELATIVE_CONSTRAINT(upperRight, RLCF_VERTICAL_CENTER, 15)
		+ new UI_RELATIVE_CONSTRAINT(upperRight, RLCF_HORIZONTAL_CENTER, 85)
		+ new UI_RELATIVE_CONSTRAINT(lowerLeft, RLCF_VERTICAL_CENTER, 85)
		+ new UI_RELATIVE_CONSTRAINT(lowerLeft, RLCF_HORIZONTAL_CENTER, 14)
		+ new UI_RELATIVE_CONSTRAINT(lowerLeft1, RLCF_VERTICAL_CENTER, 85)
		+ new UI_RELATIVE_CONSTRAINT(lowerLeft1, RLCF_HORIZONTAL_CENTER, 38)
		+ new UI_RELATIVE_CONSTRAINT(lowerRight1, RLCF_VERTICAL_CENTER, 85)
		+ new UI_RELATIVE_CONSTRAINT(lowerRight1, RLCF_HORIZONTAL_CENTER, 62)
		+ new UI_RELATIVE_CONSTRAINT(lowerRight, RLCF_VERTICAL_CENTER, 85)
		+ new UI_RELATIVE_CONSTRAINT(lowerRight, RLCF_HORIZONTAL_CENTER, 86)
		+ new UI_RELATIVE_CONSTRAINT(center, RLCF_VERTICAL_CENTER | RLCF_HORIZONTAL_CENTER, 50)
		;
	return window;
}



int UI_APPLICATION::Main()
{
	// The UI_APPLICATION constructor automatically initializes the
	// display, eventManager, and windowManager variables.

	// This line fixes linkers that don't look for main in the .LIBs.
	UI_APPLICATION::LinkMain();

	*windowManager
		+ BasicGMWindow()
		+ TieGMWindow()
		+ OppositeGMWindow()
		+ RelativeGMWindow()
		+ CenterGMWindow()
		;

	// Process user responses.
	UI_APPLICATION::Control();

	return (0);
}

