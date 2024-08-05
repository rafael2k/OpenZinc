//	I18N.CPP (I18N) - Simple text change in a window.
//	COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//	May be freely copied, used and distributed.

#include <ui_win.hpp>

class I18N_WINDOW : public UIW_WINDOW
{
public:
	static ZIL_ICHAR _className[];

	I18N_WINDOW(void);
	~I18N_WINDOW(void);

	const ZIL_LANGUAGE *myLanguage;
};
const int I18N_TITLE = 1;
const int I18N_PROMPT1 = 2;
const int I18N_PROMPT2 = 3;
const int I18N_PROMPT3 = 4;

ZIL_ICHAR I18N_WINDOW::_className[] = "I18N_WINDOW";

I18N_WINDOW::I18N_WINDOW() :
	UIW_WINDOW(5, 5, 40, 5)
{
	// Find my strings
	myLanguage = ZIL_LANGUAGE_MANAGER::UseLanguage(_className);
	Add(new UIW_BORDER);
	Add(new UIW_MAXIMIZE_BUTTON);
	Add(new UIW_MINIMIZE_BUTTON);
	Add(new UIW_SYSTEM_BUTTON(SYF_GENERIC));
	// Now use my strings
	Add(new UIW_TITLE(myLanguage->GetMessage(I18N_TITLE)));
	Add(new UIW_PROMPT(1, 0, 10, myLanguage->GetMessage(I18N_PROMPT1)));
	Add(new UIW_PROMPT(1, 1, 10, myLanguage->GetMessage(I18N_PROMPT2)));
	Add(new UIW_PROMPT(1, 2, 10, myLanguage->GetMessage(I18N_PROMPT3)));
}

I18N_WINDOW::~I18N_WINDOW()
{
	ZIL_LANGUAGE_MANAGER::FreeLanguage(myLanguage);
}

static ZIL_PRIVATE_LANGUAGE_ELEMENT ENGLISH_STRINGS[] =
{
	{ "English", I18N_TITLE, "" },
	{ "Name", I18N_PROMPT1, "" },
	{ "Rank", I18N_PROMPT2, "" },
	{ "Serial Number", I18N_PROMPT3, "" },
	{ ZIL_NULLP(char), 0xffff, "" }
};

static ZIL_PRIVATE_LANGUAGE_ELEMENT PIG_LATIN_STRINGS[] =
{
	{ "Igpay Atinlay", I18N_TITLE, "" },
	{ "Amenay", I18N_PROMPT1, "" },
	{ "Ankray", I18N_PROMPT2, "" },
	{ "Erialsay Umbernay", I18N_PROMPT3, "" },
	{ ZIL_NULLP(char), 0xffff, "" }
};

static ZIL_PRIVATE_LANGUAGE_ELEMENT BUTTON_STRINGS[] =
{
	{ "Estore&ray", MNIF_RESTORE, "" },
	{ "Ove&may", MNIF_MOVE, "" },
	{ "Ize&say", MNIF_SIZE, "" },
	{ "I&nimizemay", MNIF_MINIMIZE, "" },
	{ "A&ximizemay", MNIF_MAXIMIZE, "" },
	{ "", MNIF_SEPARATOR, "" },
	{ "Lose&cay", MNIF_CLOSE, "" },
	{ ZIL_NULLP(char), 0xffff, "" }
};

int UI_APPLICATION::Main(void)
{
	UI_APPLICATION::LinkMain();

	if (argc <= 1)
		// Set up the strings for I18N_WINDOW
		ZIL_LANGUAGE_MANAGER::SetLanguage(I18N_WINDOW::_className, ENGLISH_STRINGS);
	else
	{
		ZIL_LANGUAGE_MANAGER::SetLanguage(I18N_WINDOW::_className, PIG_LATIN_STRINGS);
		// The next line may not really change the system button strings
		ZIL_LANGUAGE_MANAGER::SetLanguage(UIW_SYSTEM_BUTTON::_className, BUTTON_STRINGS);
	}

	*windowManager + new I18N_WINDOW();

	UI_APPLICATION::Control();

	return (0);
}
