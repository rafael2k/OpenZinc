//	PHONBK.CPP (PHONBK) - Phone book example program.
//	COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//  May be freely copied, used and distributed.

#if !defined(__MWERKS__)
extern "C"
{
#endif
#	include <string.h>
#if !defined(__MWERKS__)
}
#endif

#include <ui_win.hpp>

#define PHONE_BOOK_NAME "phone.dat"
const ZIL_OBJECTID ID_PHONE_BOOK = 20000;

ZIL_STORAGE *_phoneBook;

EVENT_TYPE Find(UI_WINDOW_OBJECT *object, UI_EVENT &, EVENT_TYPE ccode)
{
	if (ccode != L_SELECT)
		return (ccode);

	UI_WINDOW_OBJECT *name = object->parent->Get("NAME");
	UI_WINDOW_OBJECT *address = object->parent->Get("ADDRESS");
	UI_WINDOW_OBJECT *workPhone = object->parent->Get("WORK_PHONE");
	UI_WINDOW_OBJECT *homePhone = object->parent->Get("HOME_PHONE");

	_phoneBook->ChDir("~PHONE_BOOK");
	char nameBuffer[128];
	name->Information(I_COPY_TEXT, nameBuffer);
	ZIL_INTERNATIONAL::strupr(nameBuffer);
	while (nameBuffer[strlen(nameBuffer) - 1] == ' ')
		nameBuffer[strlen(nameBuffer) - 1] = 0;
	const char *stringID = _phoneBook->FindFirstObject(nameBuffer);
	if (!stringID)
	{
		// The object was not found in the file.
		char *blank = "";
		address->Information(I_SET_TEXT, blank);
		workPhone->Information(I_SET_TEXT, blank);
		homePhone->Information(I_SET_TEXT, blank);

		// The word was not found.
		object->errorSystem->ReportError(object->windowManager, WOS_NO_STATUS,
			"That name was not found in the phone book.");
	}
	else
	{
		ZIL_STORAGE_OBJECT_READ_ONLY *entry = new ZIL_STORAGE_OBJECT_READ_ONLY(*_phoneBook, stringID, ID_PHONE_BOOK);

		// If the word was found then display the fields.
		if (!entry->objectError)
		{
			// Load the phone information.
			const int MAX_LENGTH = 256;
			char string[MAX_LENGTH];
			entry->Load(string, MAX_LENGTH);
			address->Information(I_SET_TEXT, string);
			entry->Load(string, MAX_LENGTH);
			workPhone->Information(I_SET_TEXT, string);
			entry->Load(string, MAX_LENGTH);
			homePhone->Information(I_SET_TEXT, string);
		}
		delete entry;
	}

	return (ccode);
}

EVENT_TYPE Save(UI_WINDOW_OBJECT *object, UI_EVENT &, EVENT_TYPE ccode)
{
	if (ccode != L_SELECT)
		return (ccode);

	UI_WINDOW_OBJECT *name = object->parent->Get( "NAME");
	char *string;
	name->Information(I_GET_TEXT, &string);
	if (!strcmp(string, ""))
	{
		object->errorSystem->ReportError(object->windowManager, WOS_NO_STATUS,
			"A blank phone entry cannot be saved.");
		object->Event(UI_EVENT(S_REDISPLAY, 0));
		return (ccode);
	}
	UI_WINDOW_OBJECT *address = object->parent->Get( "ADDRESS");
	UI_WINDOW_OBJECT *workPhone = object->parent->Get( "WORK_PHONE");
	UI_WINDOW_OBJECT *homePhone = object->parent->Get( "HOME_PHONE");

	// Try to find the entry.
	_phoneBook->ChDir("~");
	_phoneBook->MkDir("PHONE_BOOK");
	_phoneBook->ChDir("~PHONE_BOOK");
	
	char nameBuffer[128];
	name->Information(I_COPY_TEXT, nameBuffer);
	ZIL_INTERNATIONAL::strupr(nameBuffer);
	while (nameBuffer[strlen(nameBuffer) - 1] == ' ')
		nameBuffer[strlen(nameBuffer) - 1] = 0;
	const char *stringID = _phoneBook->FindFirstObject(nameBuffer);
	ZIL_STORAGE_OBJECT *entry;

	if (!stringID)
		entry = new ZIL_STORAGE_OBJECT(*_phoneBook, nameBuffer, ID_PHONE_BOOK, UIS_CREATE | UIS_READWRITE);
	else
		entry = new ZIL_STORAGE_OBJECT(*_phoneBook, stringID, ID_PHONE_BOOK, UIS_READWRITE);

	// If the word was found then display the fields.
	if (!entry->objectError)
	{
		// Store the phone information.
		char *string;
		address->Information(I_GET_TEXT, &string);
		entry->Store(string);
		workPhone->Information(I_GET_TEXT, &string);
		entry->Store(string);
		homePhone->Information(I_GET_TEXT, &string);
		entry->Store(string);

		// Make Name the current field
		UI_EVENT tEvent(S_ADD_OBJECT);
		tEvent.data = name;
		object->parent->Event(tEvent);
	}
	delete entry;

	return (ccode);
}

EVENT_TYPE Delete(UI_WINDOW_OBJECT *object, UI_EVENT &, EVENT_TYPE ccode)
{
	if (ccode != L_SELECT)
		return (ccode);

	UI_WINDOW_OBJECT *name = object->parent->Get( "NAME");

	_phoneBook->ChDir("~PHONE_BOOK");
	char nameBuffer[128];
	name->Information(I_COPY_TEXT, nameBuffer);
	ZIL_INTERNATIONAL::strupr(nameBuffer);
	while (nameBuffer[strlen(nameBuffer) - 1] == ' ')
		nameBuffer[strlen(nameBuffer) - 1] = 0;
	const char *stringID = _phoneBook->FindFirstObject(nameBuffer);
	if (stringID)
		_phoneBook->DestroyObject(stringID);
	else
	{
		object->errorSystem->ReportError(object->windowManager, WOS_NO_STATUS,
			"That phone entry was not found in the phone book.");
	}

	return (ccode);
}

int UI_APPLICATION::Main(void)
{
	// The UI_APPLICATION constructor automatically initializes the
	// display, eventManager, and windowManager variables.

	// This line fixes linkers that don't look for main in the .LIBs.
	UI_APPLICATION::LinkMain();

	// Initialize the error system.
	UI_WINDOW_OBJECT::errorSystem = new UI_ERROR_SYSTEM;

	// Open the phone book.
	_phoneBook = new ZIL_STORAGE(PHONE_BOOK_NAME, UIS_OPENCREATE | UIS_READWRITE);
	if (_phoneBook->storageError)
		UI_WINDOW_OBJECT::errorSystem->ReportError(windowManager, WOS_NO_STATUS,
			"Error opening %s.", PHONE_BOOK_NAME);
	else
	{
		UI_WINDOW_OBJECT::defaultStorage = new ZIL_STORAGE("p_phonbk.dat");

		// Check to see if the default storage was allocated.
		if (UI_WINDOW_OBJECT::defaultStorage->storageError)
		{
			delete UI_WINDOW_OBJECT::defaultStorage;
			return(-1);
		}

		UIW_WINDOW *win = new UIW_WINDOW("PHONE_BOOK", UI_WINDOW_OBJECT::defaultStorage);

		windowManager->Center(win);

		*windowManager + win;

		// Process user responses.
		UI_APPLICATION::Control();
	}

	// Clean up.
	_phoneBook->Save(1);
 	delete _phoneBook;
	delete UI_WINDOW_OBJECT::defaultStorage;
	delete UI_WINDOW_OBJECT::errorSystem;

	return (0);
}

void z_jump_dummy(void) { }   // Bug fix for broken linkers.

static UI_ITEM _userTable[] =
{
	{ 0, (EVENT_TYPE*)ZIL_VOIDF(Find), "Find", 0 },
	{ 0, (EVENT_TYPE*)ZIL_VOIDF(Save), "Save", 0 },
	{ 0, (EVENT_TYPE*)ZIL_VOIDF(Delete), "Delete", 0 },
	{ ID_END, ZIL_NULLP(void), ZIL_NULLP(ZIL_ICHAR), 0 }
};
UI_ITEM *UI_WINDOW_OBJECT::userTable = _userTable;

static UI_ITEM _objectTable[] =
{
	{ ID_BORDER, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_BORDER::New), UIW_BORDER::_className, 0 },
	{ ID_BUTTON, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_BUTTON::New), UIW_BUTTON::_className, 0 },
	{ ID_FORMATTED_STRING, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_FORMATTED_STRING::New), UIW_FORMATTED_STRING::_className, 0 },
	{ ID_ICON, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_ICON::New), UIW_ICON::_className, 0 },
	{ ID_MAXIMIZE_BUTTON, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_MAXIMIZE_BUTTON::New), UIW_MAXIMIZE_BUTTON::_className, 0 },
	{ ID_MINIMIZE_BUTTON, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_MINIMIZE_BUTTON::New), UIW_MINIMIZE_BUTTON::_className, 0 },
	{ ID_PROMPT, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_PROMPT::New), UIW_PROMPT::_className, 0 },
	{ ID_STRING, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_STRING::New), UIW_STRING::_className, 0 },
	{ ID_SYSTEM_BUTTON, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_SYSTEM_BUTTON::New), UIW_SYSTEM_BUTTON::_className, 0 },
	{ ID_TEXT, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_TEXT::New), UIW_TEXT::_className, 0 },
	{ ID_TITLE, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_TITLE::New), UIW_TITLE::_className, 0 },
	{ ID_WINDOW, (UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_WINDOW::New), UIW_WINDOW::_className, 0 },
	{ ID_END, ZIL_NULLP(void), ZIL_NULLP(ZIL_ICHAR), 0 }
};
UI_ITEM *UI_WINDOW_OBJECT::objectTable = _objectTable;
