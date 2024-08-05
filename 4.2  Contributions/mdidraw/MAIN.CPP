#include <ui_win.hpp>
#include "main.hpp"

DRAW_WINDOW::DRAW_WINDOW() : UIW_WINDOW(0, 0, 0, 0, WOF_NON_FIELD_REGION)
{
	woStatus |= WOS_OWNERDRAW;
}

EVENT_TYPE DRAW_WINDOW::DrawItem(const UI_EVENT &event, EVENT_TYPE ccode)
{
	UI_REGION region = trueRegion;
	display->VirtualGet(screenID, region);

	display->Rectangle(screenID, region, &greenPalette, 0, TRUE, FALSE, &clip);

	display->VirtualPut(screenID);
	return (TRUE);
}

MDI_CHILD_WINDOW::MDI_CHILD_WINDOW() : UIW_WINDOW(2, 2, 50, 10,
	WOF_NO_FLAGS, WOAF_MDI_OBJECT)
{
	*this
		+ new UIW_BORDER
		+ new UIW_MAXIMIZE_BUTTON
		+ new UIW_MINIMIZE_BUTTON
		+ new UIW_SYSTEM_BUTTON(SYF_GENERIC)
		+ new UIW_TITLE("Child Window")
		+ new DRAW_WINDOW;
		;

}

UI_APPLICATION::Main()
{
	UIW_WINDOW *mdiParent = UIW_WINDOW::Generic(0, 0, 70, 15, "MDI Parent",
		ZIL_NULLP(UI_WINDOW_OBJECT), WOF_NO_FLAGS, WOAF_MDI_OBJECT);

	MDI_CHILD_WINDOW *mdiChild = new MDI_CHILD_WINDOW;

	*mdiParent 
		+ &(*new UIW_PULL_DOWN_MENU
			+ &(*new UIW_PULL_DOWN_ITEM("Options")
				+ new UIW_POP_UP_ITEM("Exit", MNIF_SEND_MESSAGE,
					BTF_NO_3D, WOF_NO_FLAGS, ZIL_NULLF(ZIL_USER_FUNCTION), S_CLOSE)
				)
			)
		+ mdiChild;
	*windowManager + mdiParent;

	Control();

	return (0);
}
