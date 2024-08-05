#define INCL_WINMLE
#include <ui_win.hpp>
#include "text.hpp"
#define USE_DERIVED_OBJECTS
#include "p_main.hpp"

// Normal destructor.
MY_TEXT::~MY_TEXT()
{
}

EVENT_TYPE MY_TEXT::Event(const UI_EVENT &event)
{
	EVENT_TYPE ccode = event.type;

	switch(ccode)
	{
#if defined(ZIL_OS2)
	case E_OS2:
	{
		if (event.message.msg == WM_CONTROL)
		{
			USHORT word = HIWORD(event.message.mp1);
			switch(word)
			{
			case MLN_VSCROLL:
			{
				UI_POSITION currentPosition;

				IPT offset = (IPT)WinSendMsg(screenID, MLM_QUERYFIRSTCHAR,
					(MPARAM)(LONG)currentPosition.line, (MPARAM)0);

				WinSendMsg(sibling->screenID, MLM_SETFIRSTCHAR, (MPARAM)offset, (MPARAM)offset);

				ccode = UIW_TEXT::Event(event);
			}
			break;

			default:
				ccode = UIW_TEXT::Event(event);
			}
		}
		else
			ccode = UIW_TEXT::Event(event);
	}
	break;
#endif

	case S_INITIALIZE:
		ccode = UIW_TEXT::Event(event);
		sibling = Root()->Get("TEXT_SIBLING");
		break;

	default:
		ccode = UIW_TEXT::Event(event);
	}
	return (ccode);
}

// ----- ZIL_PERSISTENCE ----------------------------------------------------

#if defined(ZIL_LOAD)
MY_TEXT::MY_TEXT(const char *name, ZIL_STORAGE_READ_ONLY *directory,
	ZIL_STORAGE_OBJECT_READ_ONLY *file, UI_ITEM *objectTable, UI_ITEM *userTable) :
	UIW_TEXT(name, directory, file, objectTable, userTable)
{
	searchID = ID_MY_TEXT;
}
#endif
