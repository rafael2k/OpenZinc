//	WORD2.CPP (WORD) - Dictionary tutorial, adding Zinc Interface Library.
//	COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//  May be freely copied, used and distributed.

#include <stdio.h>
#include <string.h>
#include <ui_win.hpp>
#include "word2.hpp"

int UI_APPLICATION::Main(void)
{
	// The UI_APPLICATION constructor automatically initializes the 
	// display, eventManager, and windowManager variables.

	// This line fixes linkers that don't look for main in the .LIBs.
	UI_APPLICATION::LinkMain();

	// Initialize the error system.
	UI_WINDOW_OBJECT::errorSystem = new UI_ERROR_SYSTEM;

	// Create the dictionary window.
	DICTIONARY_WINDOW *dictionary = new DICTIONARY_WINDOW();

	// If the dictionary was opened, add it to the window manager.
	if (dictionary->dictionaryOpened)
		*windowManager + dictionary;
	else
	{
		UI_WINDOW_OBJECT::errorSystem->ReportError(windowManager, WOS_NO_STATUS,
			"The dictionary file 'WORD.DCT' could not be found.");
		delete dictionary;
	}

	// Process user responses.
	UI_APPLICATION::Control();

	// Clean up.
	delete UI_WINDOW_OBJECT::errorSystem;

	return (0);
}

DICTIONARY_WINDOW::DICTIONARY_WINDOW(void) : UIW_WINDOW(20, 4, 41, 14)
{
	// Create the dictionary.
	dictionary = new DICTIONARY("word.dct");

	// Set the dictionaryOpened flag.
	dictionaryOpened = dictionary->opened;

	if (dictionaryOpened)
	{
		// Create the window fields.
		inputField = new UIW_STRING(17, 1, 20, "", 40, STF_NO_FLAGS,
			WOF_BORDER | WOF_AUTO_CLEAR, DICTIONARY_WINDOW::LookUpWord);
		definitionField = new UIW_TEXT(17, 3, 20, 4,"",	100, WNF_NO_FLAGS,
			WOF_BORDER);
		antonymField = new UIW_STRING(17, 8, 20, "", 50, WNF_NO_FLAGS,
			WOF_BORDER);
		synonymField = new UIW_STRING(17, 10, 20, "", 50, WNF_NO_FLAGS,
			WOF_BORDER);

		*this
			+ new UIW_BORDER
			+ new UIW_MAXIMIZE_BUTTON
			+ new UIW_MINIMIZE_BUTTON
			+ new UIW_SYSTEM_BUTTON(SYF_GENERIC)
			+ new UIW_TITLE("Dictionary")
			+ new UIW_PROMPT(2, 1, "Enter a word:  ")
			+ inputField
			+ new UIW_PROMPT(2, 3, "Definition:  ")
			+ definitionField
			+ new UIW_PROMPT(2, 8, "Antonyms:  ")
			+ antonymField
			+ new UIW_PROMPT(2, 10, "Synonyms:  ")
			+ synonymField;
	}
}

EVENT_TYPE DICTIONARY_WINDOW::LookUpWord(UI_WINDOW_OBJECT *object, UI_EVENT &, EVENT_TYPE ccode)
{
	EVENT_TYPE errorCode = 0;

	// Return if just entering.
	if (ccode != L_SELECT)
		return errorCode;

	// Get a pointer to the parent window.
	DICTIONARY_WINDOW *dictionaryWindow = (DICTIONARY_WINDOW *)object->parent;

	// See if the word is in the dictionary.
	const char *text = ((UIW_STRING *)dictionaryWindow->inputField)->DataGet();
	D_WORD *entry = dictionaryWindow->dictionary->Get(text);

	// If the word entry was not found then report the error.
	if (!entry)
	{
		errorSystem->ReportError(dictionaryWindow->windowManager, WOS_NO_STATUS,
			"That word was not found in the dictionary.");

		// Clear the existing word data.
		dictionaryWindow->definitionField->DataSet("");
		dictionaryWindow->antonymField->DataSet("");
		dictionaryWindow->synonymField->DataSet("");

		// Set the error Code.
		errorCode = -1;
	}
	else
	{
		// Display the word information on the window.
		dictionaryWindow->definitionField->DataSet(entry->definition);

		char buffer[1024];
		strcpy(buffer, "");
		_WORD *word;
		for (word = (_WORD *)entry->antonymList.First(); word;
			word = (_WORD *)word->Next())
		{
			strcat(buffer, word->string);
			if (word->Next())
				strcat(buffer, ", ");
		}
		dictionaryWindow->antonymField->DataSet(buffer, sizeof(buffer));

		strcpy(buffer, "");
		for (word = (_WORD *)entry->synonymList.First(); word;
			word = word->Next())
		{
			strcat(buffer, word->string);
			if (word->Next())
				strcat(buffer, ", ");
		}
		dictionaryWindow->synonymField->DataSet(buffer, sizeof(buffer));
	}

	return errorCode;
}

DICTIONARY::DICTIONARY(char *fileName) : UI_LIST()
{
	// Open the dictionary file and read in the words.
	FILE *file = fopen(fileName, "r");
	if (file)
	{
		opened = TRUE;
		while (!feof(file))
			Add(new D_WORD(file));
	}
	else
		opened = FALSE;
	fclose(file);
}

D_WORD::D_WORD(FILE *file) : antonymList(), synonymList()
{
	char token[64];

	// Read the word.
	char a_word[64];
	fscanf(file, "%s", a_word);
	if (!strcmp("word:", a_word))
		fscanf(file, "%s", a_word);
	string = strdup(a_word);

	// Read the definition.
	char a_definition[1024];
	fscanf(file, "%s", a_definition);	// The '-' character.
	fscanf(file, "%s", a_definition);
	for (fscanf(file, "%s", token); strcmp("synonyms:", token);
		fscanf(file, "%s", token))
	{
		strcat(a_definition, " ");
		strcat(a_definition, token);
	}
	definition = strdup(a_definition);

	// Read in the synonyms.
	for (fscanf(file, "%s", token); strcmp("antonyms:", token);
		fscanf(file, "%s", token))
		synonymList.Add(new _WORD(token));

	// Read in the antonyms.
	for (fscanf(file, "%s", token); !feof(file) && strcmp("word:", token);
		fscanf(file, "%s", token))
		antonymList.Add(new _WORD(token));
}
