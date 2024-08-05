//  SPREAD.CPP (SPREAD) - Using UIW_TABLE as a spread sheet.
//  COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//  Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//  May be freely copied, used and distributed.

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <ui_win.hpp>
#include "spread.hpp"

#define COLUMNS		26
#define ROWS	 		100
#define FIELD_LENGTH	64

EVENT_TYPE HeaderCallback(UI_WINDOW_OBJECT *object, UI_EVENT &event, EVENT_TYPE ccode)
{
	if (ccode == S_SET_DATA)
	{
		char text[8];
		THF_FLAGS thFlags;
		object->parent->Information(I_GET_FLAGS, &thFlags);
		if (FlagSet(thFlags, THF_COLUMN_HEADER))
			object->sprintf(text, "%c", 'A' + event.rawCode);
		else
			object->sprintf(text, "%d", event.rawCode);
		object->Get("HEADER_PROMPT")->Information(I_SET_TEXT, text);
	}
	return (ccode);
}

SPREAD_SHEET::SPREAD_SHEET(void) :
	UIW_TABLE(0, 0, 0, 0, COLUMNS, sizeof(CELL_DATA), ROWS * COLUMNS,
		ZIL_NULLP(void), ROWS * COLUMNS, TBLF_GRID, WOF_NON_FIELD_REGION)
{
	searchID = ID_SPREAD_SHEET;

	UIW_PROMPT *columnHeaderPrompt;
	UIW_PROMPT *rowHeaderPrompt;

	*this
		+ new UIW_TABLE_HEADER(THF_CORNER_HEADER)
		+ &(*new UIW_TABLE_HEADER(THF_COLUMN_HEADER | THF_GRID)
			+ &(*new UIW_TABLE_RECORD(10, 1, HeaderCallback)
				+ (columnHeaderPrompt = new UIW_PROMPT(5, 0, ""))))
		+ &(*new UIW_TABLE_HEADER(THF_ROW_HEADER | THF_GRID)
			+ &(*new UIW_TABLE_RECORD(5, 1, HeaderCallback)
				+ (rowHeaderPrompt = new UIW_PROMPT(2, 0, ""))))
		+ new UIW_SCROLL_BAR(0, 0, 0, 0, SBF_CORNER)
		+ new UIW_SCROLL_BAR(0, 0, 0, 0, SBF_VERTICAL)
		+ new UIW_SCROLL_BAR(0, 0, 0, 0, SBF_HORIZONTAL)
		+ new SPREAD_SHEET_CELL();

	columnHeaderPrompt->StringID("HEADER_PROMPT");
	rowHeaderPrompt->StringID("HEADER_PROMPT");

	CELL_DATA *cell = (CELL_DATA *)data;
	for (int y = 0; y < 11; y++)
		for (int x = 0; x < 11; x++)
	{
		int i = y * COLUMNS + x;
		cell[i].text = new char[FIELD_LENGTH];
		strcpy(cell[i].text, _initData[y * 11 + x].text);
		cell[i].value = _initData[y * 11 + x].value;
	}
	Event(UI_EVENT(S_CALCULATE));
}

SPREAD_SHEET::~SPREAD_SHEET()
{
	CELL_DATA *cell = (CELL_DATA *)data;
	for (int y = 0; y < ROWS; y++)
		for (int x = 0; x < COLUMNS; x++)
	{
		int i = y * COLUMNS + x;
		delete cell[i].text;
	}
}

EVENT_TYPE SPREAD_SHEET::Event(const UI_EVENT &event)
{
	EVENT_TYPE ccode = event.type;

	switch (ccode)
	{
	case S_SAVE:
		eventManager->DeviceImage(E_MOUSE, DM_WAIT);
		parent->Store("p_spread.dat~SPREAD_SHEET");
		eventManager->DeviceImage(E_MOUSE, DM_VIEW);
		break;

	case S_CALCULATE:
		{
		CELL_DATA *cell = (CELL_DATA *)data;

		for (int i = 0; i < ROWS * COLUMNS; i++)
		{
			int newValue;
			if (cell[i].text && *cell[i].text != '\"')
			{
				newValue = 0;
				int operation = 0, needValue = TRUE;
				char textBuffer[FIELD_LENGTH];
				strcpy(textBuffer, cell[i].text);
				char *token = strtok(textBuffer, " ");
				while (token)
				{
					if (needValue)
					{
						int value = 0;
						if (isdigit(token[0]))
							value = atoi(token);
						else if (isalpha(token[0]) && isdigit(token[1]))
						{
							int column = toupper(token[0]) - 'A';
							int row = atoi(&token[1]);
							int cellIndex = row * COLUMNS + column;
							if (cellIndex < ROWS * COLUMNS)
								value = cell[cellIndex].value;
						}
						if (operation)
						{
							switch (operation)
							{
							case '*': newValue *= value; break;
							case '+': newValue += value; break;
							case '-': newValue -= value; break;
							case '/':
								if (value)
									newValue /= value;
								else
									newValue = 0;
								break;
							}
							operation = 0;
						}
						else
							newValue = value;
						needValue = FALSE;
					}
					else if (!operation && strchr("*/+-", token[0]))
					{
						operation = token[0];
						needValue = TRUE;
					}
					token = strtok(ZIL_NULLP(char), " ");
				}
			}
			else
				newValue = 0;

			if (newValue != cell[i].value)
			{
				cell[i].value = newValue;
				if (screenID && i != currentRecord)
					DrawRecord(i);
			}
		}
		}
		break;

	default:
		ccode = UIW_TABLE::Event(event);
	}

	return (ccode);
}

SPREAD_SHEET_CELL::SPREAD_SHEET_CELL(void) :
	UIW_TABLE_RECORD(10, 1)
{
	searchID = ID_SPREAD_SHEET_CELL;

	dataField = new UIW_STRING(0, 0, 0, "", FIELD_LENGTH, STF_NO_FLAGS,
		WOF_NON_FIELD_REGION | WOF_AUTO_CLEAR);
	dataField->StringID("DATA_FIELD");
	Add(dataField);
}

SPREAD_SHEET_CELL::~SPREAD_SHEET_CELL()
{
}

EVENT_TYPE SPREAD_SHEET_CELL::Event(const UI_EVENT &event)
{
	EVENT_TYPE ccode = LogicalEvent(event);

	switch (ccode)
	{
	case S_SET_DATA:
		{
		UIW_TABLE_RECORD::Event(event);

		CELL_DATA *cellData = (CELL_DATA *)data;
		if (cellData->text && *cellData->text)
		{
			if (editMode)
				dataField->DataSet(cellData->text);
			else
			{
				char textBuffer[FIELD_LENGTH];

				if (*cellData->text == '\"')
				{
					sprintf(textBuffer, "%s", &cellData->text[1]);
					textBuffer[strlen(textBuffer) - 1] = 0;
				}
				else
					sprintf(textBuffer, "%d", cellData->value);
				dataField->DataSet(textBuffer);
			}
		}
		else
			dataField->DataSet("");
		}
		break;

	case L_SELECT:
	case S_NON_CURRENT:
		{
		CELL_DATA *cellData = (CELL_DATA *)data;

		if (editMode)
		{
			char *newText = dataField->DataGet();
			if (*newText && !cellData->text)
				cellData->text = new char[FIELD_LENGTH];
			if (cellData->text)
				strcpy(cellData->text, newText);
			parent->Event(UI_EVENT(S_CALCULATE));
		}
		UIW_TABLE_RECORD::Event(event);

		if (ccode == L_SELECT)
		{
			if (cellData->text && *cellData->text)
			{
				if (editMode)
					dataField->DataSet(cellData->text);
				else
				{
					char textBuffer[FIELD_LENGTH];
					if (*cellData->text == '\"')
					{
						sprintf(textBuffer, "%s", &cellData->text[1]);
						textBuffer[strlen(textBuffer) - 1] = 0;
					}
					else
						sprintf(textBuffer, "%d", cellData->value);
					dataField->DataSet(textBuffer);
				}
			}
			else
				dataField->DataSet("");
		}
		}
		break;

	case S_CURRENT:
	case L_BEGIN_SELECT:
		{
		int alreadyEditable = editMode;
		UIW_TABLE_RECORD::Event(event);
		CELL_DATA *cellData = (CELL_DATA *)data;

		if (cellData->text && *cellData->text)
		{
			if (editMode)
			{
				// Do not DataSet if simply selecting with the mouse.
				if (ccode == S_CURRENT || !alreadyEditable)
					dataField->DataSet(cellData->text);
			}
			else
			{
				char textBuffer[FIELD_LENGTH];
				if (*cellData->text == '\"')
				{
					sprintf(textBuffer, "%s", &cellData->text[1]);
					textBuffer[strlen(textBuffer) - 1] = 0;
				}
				else
					sprintf(textBuffer, "%d", cellData->value);
				dataField->DataSet(textBuffer);
			}
		}
		else
			dataField->DataSet("");
		}
		break;

	default:
		ccode = UIW_TABLE_RECORD::Event(event);
	}

	return (ccode);
}

int UI_APPLICATION::Main()
{
	UI_APPLICATION::LinkMain();

	UIW_WINDOW *window = UIW_WINDOW::Generic(0, 0, 50, 15, "Spread Sheet");
	*window
		+ &(*new UIW_PULL_DOWN_MENU()
			+ &(*new UIW_PULL_DOWN_ITEM("&File")
				+ new UIW_POP_UP_ITEM("&Save", MNIF_SEND_MESSAGE, BTF_NO_3D,
					WOF_NO_FLAGS, ZIL_NULLF(ZIL_USER_FUNCTION), S_SAVE)
				+ new UIW_POP_UP_ITEM()
				+ new UIW_POP_UP_ITEM("E&xit", MNIF_SEND_MESSAGE, BTF_NO_3D,
					WOF_NO_FLAGS, ZIL_NULLF(ZIL_USER_FUNCTION), L_EXIT)));

	window->Add(new SPREAD_SHEET());

	windowManager->Center(window);
	windowManager->Add(window);

	// Process user responses.
	UI_APPLICATION::Control();

	return (0);
}

#if defined(ZIL_LOAD)
SPREAD_SHEET_CELL::SPREAD_SHEET_CELL(const char *name, ZIL_STORAGE_READ_ONLY *directory,
	ZIL_STORAGE_OBJECT_READ_ONLY *file, UI_ITEM *objectTable, UI_ITEM *userTable) :
	UIW_TABLE_RECORD(name, directory, file, objectTable, userTable)
{
	dataField = (UIW_STRING *)Get("DATA_FIELD");
}

SPREAD_SHEET::SPREAD_SHEET(const char *name, ZIL_STORAGE_READ_ONLY *directory,
	ZIL_STORAGE_OBJECT_READ_ONLY *file, UI_ITEM *objectTable, UI_ITEM *userTable) :
	UIW_TABLE(name, directory, file, objectTable, userTable)
{
	records = maxRecords = ROWS * COLUMNS;
	DataSet(data, records, maxRecords);
}

void SPREAD_SHEET::Load(const char *name, ZIL_STORAGE_READ_ONLY *directory,
	ZIL_STORAGE_OBJECT_READ_ONLY *file, UI_ITEM *objectTable, UI_ITEM *userTable)
{
	UIW_TABLE::Load(name, directory, file, objectTable, userTable);
}
#endif

#if defined(ZIL_STORE)
void SPREAD_SHEET::Store(const char *name, ZIL_STORAGE *directory,
	ZIL_STORAGE_OBJECT *file, UI_ITEM *objectTable, UI_ITEM *userTable)
{
	UIW_TABLE::Store(name, directory, file, objectTable, userTable);
}
#endif

void z_jump_dummy(void) { } // Bug fix for broken linkers.

static UI_ITEM _objectTable[] =
{
	{ ID_BORDER, 			(UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_BORDER::New), 			UIW_BORDER::_className, 			0 },
	{ ID_MAXIMIZE_BUTTON, 	(UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_MAXIMIZE_BUTTON::New), 	UIW_MAXIMIZE_BUTTON::_className, 	0 },
	{ ID_MINIMIZE_BUTTON, 	(UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_MINIMIZE_BUTTON::New), 	UIW_MINIMIZE_BUTTON::_className, 	0 },
	{ ID_POP_UP_ITEM, 		(UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_POP_UP_ITEM::New), 		UIW_POP_UP_ITEM::_className, 		0 },
	{ ID_POP_UP_MENU, 		(UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_POP_UP_MENU::New), 		UIW_POP_UP_MENU::_className, 		0 },
	{ ID_PROMPT, 			(UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_PROMPT::New), 			UIW_PROMPT::_className, 			0 },
	{ ID_PULL_DOWN_ITEM, 	(UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_PULL_DOWN_ITEM::New), 	UIW_PULL_DOWN_ITEM::_className, 	0 },
	{ ID_PULL_DOWN_MENU, 	(UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_PULL_DOWN_MENU::New), 	UIW_PULL_DOWN_MENU::_className, 	0 },
	{ ID_SCROLL_BAR, 		(UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_SCROLL_BAR::New), 		UIW_SCROLL_BAR::_className, 		0 },
	{ ID_STRING, 			(UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_STRING::New), 			UIW_STRING::_className, 			0 },
	{ ID_SYSTEM_BUTTON, 	(UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_SYSTEM_BUTTON::New), 		UIW_SYSTEM_BUTTON::_className, 		0 },
	{ ID_TABLE, 			(UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_TABLE::New), 				UIW_TABLE::_className, 				0 },
	{ ID_TABLE_HEADER, 		(UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_TABLE_HEADER::New), 			UIW_TABLE_HEADER::_className, 				0 },
	{ ID_TABLE_RECORD, 		(UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_TABLE_RECORD::New), 			UIW_TABLE_RECORD::_className, 				0 },
	{ ID_TITLE, 			(UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_TITLE::New), 				UIW_TITLE::_className, 				0 },
	{ ID_WINDOW, 			(UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_WINDOW::New), 			UIW_WINDOW::_className, 			0 },
	{ ID_SPREAD_SHEET,		(UI_WINDOW_OBJECT*)ZIL_VOIDF(SPREAD_SHEET::New), 			UIW_TABLE::_className,				0 },
	{ ID_SPREAD_SHEET_CELL,	(UI_WINDOW_OBJECT*)ZIL_VOIDF(SPREAD_SHEET_CELL::New), 		UIW_TABLE_RECORD::_className,		0 },
	{ ID_END, 				ZIL_NULLP(void), 						ZIL_NULLP(char), 	   			0 }
};
UI_ITEM *UI_WINDOW_OBJECT::objectTable = _objectTable;

static UI_ITEM _userTable[] =
{
	{ ID_END, ZIL_NULLP(void), ZIL_NULLP(char), 0 }
};
UI_ITEM *UI_WINDOW_OBJECT::userTable = _userTable;
