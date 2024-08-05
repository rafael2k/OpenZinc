#define INCL_WINSTDBOOK
#define INCL_WINDIALOGS
#include <ui_win.hpp>

const EVENT_TYPE TOGGLE_PAGE_2 = 10000;
const EVENT_TYPE TOGGLE_PAGE_3 = 10001;

class WINDOW : public UIW_WINDOW
{
public:
	WINDOW();
	virtual ~WINDOW() {}
	virtual EVENT_TYPE Event(const UI_EVENT &event);

protected:
	UIW_NOTEBOOK *notebook;
	UI_WINDOW_OBJECT *page2, *page3;
};

WINDOW::WINDOW() : UIW_WINDOW("p_main.dat~WINDOW")
{
	notebook = (UIW_NOTEBOOK *)Get("NOTEBOOK");
	page2 = notebook->Get("PAGE_2");
	page2->userFlags = 1;
	page3 = notebook->Get("PAGE_3");
	page3->userFlags = 2;

	windowManager->Center(this);
}

EVENT_TYPE WINDOW::Event(const UI_EVENT &event)
{
	EVENT_TYPE ccode = event.type;
	switch(ccode)
	{
	case TOGGLE_PAGE_2:
	{
		UI_WINDOW_OBJECT *object;

		object = (UI_WINDOW_OBJECT *)notebook->Information(I_GET_STRINGID_OBJECT, "FIELD_4097");
		object->woFlags ^= WOF_NON_SELECTABLE;
		if (object->IsNonselectable())
			object->Information(I_SET_TEXT, "Unavailable");
		else
			object->Information(I_SET_TEXT, "Page 2");
		object->Information(I_CHANGED_FLAGS, ZIL_NULLP(void));
	}
	break;

	case TOGGLE_PAGE_3:
	{
		UI_WINDOW_OBJECT *object;

#if defined(ZIL_OS2)
		int pageIndex = 0;
		ULONG pageID = (ULONG)WinSendMsg(notebook->screenID, BKM_QUERYPAGEID,
			(MPARAM)NULL, MPFROM2SHORT(BKA_FIRST, BKA_FIRST));
		while(pageIndex < 3)
		{
			pageIndex++;
			pageID = (ULONG)WinSendMsg(notebook->screenID, BKM_QUERYPAGEID,
			(MPARAM)pageID, MPFROM2SHORT(BKA_NEXT, BKA_NEXT));
		}

		WinSendMsg(pageID, WM_ENABLE, (MPARAM)FALSE, (MPARAM)0);
#else
		object = (UI_WINDOW_OBJECT *)notebook->Information(I_GET_STRINGID_OBJECT, "FIELD_4098");
		object->woFlags ^= WOF_NON_SELECTABLE;
		object->Information(I_CHANGED_FLAGS, ZIL_NULLP(void));
#endif
	}
	break;

	default:
		ccode = UIW_WINDOW::Event(event);
	}
	return (ccode);
}

UI_APPLICATION::Main()
{
	WINDOW *win = new WINDOW;

	*windowManager + win;

	Control();

	return (0);
}
