#include <stdio.h>
#include <string.h>
#include <ui_win.hpp>

#if defined (_SUNOS4)
#	include <unistd.h>
#endif

// The information file "vlist.txt" really contains fixed length records.
// The words are listed in alphabetical order and padded to 78 characters
// with spaces.  The file is formatted as a text file, so each operating 
// system has its own representation of the end-of-line.
#if defined(ZIL_MSDOS) || defined(ZIL_MSWINDOWS) || defined(ZIL_OS2) || defined(__DVX__)
#	define RECORD_LENGTH	80
#elif defined(ZIL_POSIX) || defined(ZIL_MACINTOSH)
#	define RECORD_LENGTH	79
#endif

FILE *file;
int maxRecords = 0;

void LoadRecord(int recordNumber, ZIL_ICHAR *word, ZIL_ICHAR *definition)
{
	// Check for a valid record.
	if (recordNumber > maxRecords - 1)
	{
		word[0] = 0;
		definition[0] = 0;
	}
	else
	{
		// Load the record from the file.
		long offset = RECORD_LENGTH * recordNumber;
		fseek(file, offset, SEEK_SET);
		char text[128];
		fgets(text, RECORD_LENGTH - 1, file);

		// Strip out the trailing space characters.
		text[RECORD_LENGTH - 1] = '\0';
		for (int i = RECORD_LENGTH - 2; i > 0 &&
			ZIL_INTERNATIONAL::IsSpace(text[i]); i--)
			text[i] = '\0';
		ZIL_ICHAR *delimiter = strchr(text, '-');
		if (delimiter)
		{
			if (word)
			{
				strncpy(word, text, delimiter - text - 1);
				word[delimiter - text - 1] = 0;
			}
			if (definition)
				strcpy(definition, delimiter + 2);
		}
	}
}

EVENT_TYPE RecordFunction(UI_WINDOW_OBJECT *object, UI_EVENT &event, EVENT_TYPE ccode)
{
	if (ccode == S_SET_DATA)
	{
		ZIL_ICHAR definition[80];
		LoadRecord(event.rawCode, ZIL_NULLP(ZIL_ICHAR), definition);
		object->Get("DEFINITION")->Information(I_SET_TEXT, definition);
	}
	return (ccode);
}

EVENT_TYPE RowHeaderFunc(UI_WINDOW_OBJECT *object, UI_EVENT &event, EVENT_TYPE ccode)
{
	if (ccode == S_SET_DATA)
	{
		ZIL_ICHAR word[15];
		LoadRecord(event.rawCode, word, ZIL_NULLP(ZIL_ICHAR));
		object->Get("ROW_PROMPT")->Information(I_SET_TEXT, word);
	}
	return (ccode);
}

int UI_APPLICATION::Main()
{
	UI_APPLICATION::LinkMain();

	maxRecords = 100;
	file = fopen("vlist.txt", "rb");

	UIW_WINDOW *window = UIW_WINDOW::Generic(3, 2, 53, 13, "Dictionary");
	UI_WINDOW_OBJECT *rowPrompt, *definition;
	UIW_TABLE *table = new UIW_TABLE(1, 1, 40, 10, 1, 0, 100,
		ZIL_NULLP(void), 100, TBLF_NO_FLAGS, WOF_NON_FIELD_REGION | WOF_NO_ALLOCATE_DATA);

	UIW_TABLE_HEADER *cornerHeader = new UIW_TABLE_HEADER(THF_CORNER_HEADER);
	UIW_TABLE_HEADER *colHeader = new UIW_TABLE_HEADER(THF_COLUMN_HEADER);
	UIW_TABLE_HEADER *rowHeader = new UIW_TABLE_HEADER(THF_ROW_HEADER);

	*cornerHeader
		+ &(*new UIW_TABLE_RECORD(8, 1)
			+ new UIW_PROMPT(1, 0, "Word"));

	*colHeader
		+ &(*new UIW_TABLE_RECORD(37, 1)
			+ new UIW_PROMPT(1, 0, "Definition"));

	*rowHeader
		+ &(*new UIW_TABLE_RECORD(12, 2, RowHeaderFunc)
			+ (rowPrompt = new UIW_PROMPT(1, 0, "")));

	*table
		+ new UIW_SCROLL_BAR(0, 0, 0, 0, SBF_CORNER)
		+ new UIW_SCROLL_BAR(0, 0, 0, 0, SBF_VERTICAL)
		+ new UIW_SCROLL_BAR(0, 0, 0, 0, SBF_HORIZONTAL)
		+ cornerHeader
		+ colHeader
		+ rowHeader
		+ &(*new UIW_TABLE_RECORD(37, 2, RecordFunction)
			+ (definition = new UIW_TEXT(1, 0, 35, 2, "", 80,
				WNF_NO_FLAGS, WOF_VIEW_ONLY)));

	rowPrompt->StringID("ROW_PROMPT");
	definition->StringID("DEFINITION");
	definition->woAdvancedFlags |= WOAF_NON_CURRENT;

	*window
		+ table;

	*windowManager
		+ window;

	// Process user responses.
	UI_APPLICATION::Control();

	fclose(file);

	return (0);
}
