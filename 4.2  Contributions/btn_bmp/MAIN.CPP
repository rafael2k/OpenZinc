#include <ui_win.hpp>

const ZIL_USER_EVENT MESSAGE = 10000;

class WINDOW : public UIW_WINDOW
{
public:
	WINDOW(int left, int top, int width, int heigth);
	EVENT_TYPE Event(const UI_EVENT &event);
private:
	UIW_BUTTON *button;
	UIW_BUTTON *imageButton;
};

int UI_APPLICATION::Main()
{
	LinkMain();
	WINDOW *window = new WINDOW(0, 0, 25, 4);
	*windowManager + window;
	Control();
	return (0);
}

WINDOW::WINDOW(int left, int top, int width, int heigth) :
	UIW_WINDOW(left, top, width, heigth)
{
	imageButton = new UIW_BUTTON(-20, 0, 10, "", BTF_AUTO_SIZE,
		WOF_NO_FLAGS, ZIL_NULLF(ZIL_USER_FUNCTION), 0, "softDrive");

	*this
		+ new UIW_BORDER
		+ new UIW_MAXIMIZE_BUTTON
		+ new UIW_MINIMIZE_BUTTON
		+ new UIW_SYSTEM_BUTTON(SYF_GENERIC)
		+ new UIW_TITLE("Main Window")
		+ &(*(button = new UIW_BUTTON(7, 1, 10, "",
			BTF_AUTO_SIZE | BTF_NO_TOGGLE | BTF_SEND_MESSAGE,
			WOF_NO_FLAGS, ZIL_NULLF(ZIL_USER_FUNCTION), MESSAGE, "hardDrive")));

	windowManager->Center(this);
}

EVENT_TYPE WINDOW::Event(const UI_EVENT &event)
{
	EVENT_TYPE ccode = event.type;

	switch (ccode)
	{
	case MESSAGE:
		{
		ZIL_UINT8 *bitmapArray;
		imageButton->Information(I_GET_BITMAP_ARRAY, &bitmapArray);
		button->Information(I_SET_BITMAP_ARRAY, bitmapArray);
		button->Event(S_CHANGED);
		button->Event(S_REDISPLAY);
		}
		break;

	default:
		ccode = UIW_WINDOW::Event(event);
		break;
	}
	return (ccode);
}


