//	WORD2.HPP (WORD) - Dictionary tutorial, adding Zinc Interface Library.
//	COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//  May be freely copied, used and distributed.

#if defined(ZIL_MACINTOSH) || defined(ZIL_NEXTSTEP)
ZIL_ICHAR *strdup(const ZIL_ICHAR *srcString)
{
	if (!srcString)
		return (ZIL_NULLP(ZIL_ICHAR));
	ZIL_ICHAR *destString = new ZIL_ICHAR[strlen(srcString) + 1];
	strcpy(destString, srcString);
	return (destString);
}
#endif

class _WORD : public UI_ELEMENT
{
public:
	char *string;

	_WORD(const char *_string) { string = strdup(_string); }
	~_WORD(void) { if (string) delete string; }

	_WORD *Next(void) { return ((_WORD *)next); }
};

class D_WORD : public UI_ELEMENT
{
public:
	char *string;
	char *definition;
	UI_LIST antonymList;
	UI_LIST synonymList;

	D_WORD(FILE *file);
	~D_WORD(void) { if (string) delete string; if (definition) delete definition; }

	D_WORD *Next(void) { return ((D_WORD *)next); }
};

class DICTIONARY : public UI_LIST
{
public:
	int opened;

	DICTIONARY(char *name);

	static int FindWord(void *element, void *matchData)
		{ return(ZIL_INTERNATIONAL::stricmp(((D_WORD *)element)->string, (char *)matchData)); }
	D_WORD *First(void) { return ((D_WORD *)first); }
	D_WORD *Get(const char *word) { return((D_WORD *)UI_LIST::Get(DICTIONARY::FindWord, (void *)word)); }
};

class DICTIONARY_WINDOW : public UIW_WINDOW
{
public:
	DICTIONARY_WINDOW(void);
	~DICTIONARY_WINDOW(void) { if (dictionary) delete dictionary; };

	int dictionaryOpened;

private:
	DICTIONARY *dictionary;
	UIW_STRING *inputField;
	UIW_TEXT *definitionField;
	UIW_STRING *antonymField;
	UIW_STRING *synonymField;

	static EVENT_TYPE LookUpWord(UI_WINDOW_OBJECT *object,
		UI_EVENT &event, EVENT_TYPE ccode);
};
