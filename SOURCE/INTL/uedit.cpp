#define USE_RAW_KEYS
#include <ui_win.hpp>
#include <uedit.hpp>

#define MSG_OFFSET  	6000
#define MSG_TITLE		0
#define MSG_ICONNAME	1
#define MSG_ICONTITLE	2
#define MSG_INDEX		3
#define MSG_CLEAR		4
#define MSG_HELP		5

static UI_ITEM _messageTable[] =
{
	{ MSG_TITLE,				ZIL_NULLP(void), ZIL_NULLP(ZIL_ICHAR), 0 },
	{ MSG_ICONNAME,				ZIL_NULLP(void), ZIL_NULLP(ZIL_ICHAR), 0 },
	{ MSG_ICONTITLE,			ZIL_NULLP(void), ZIL_NULLP(ZIL_ICHAR), 0 },
	{ MSG_INDEX,				ZIL_NULLP(void), ZIL_NULLP(ZIL_ICHAR), 0 },
	{ MSG_OFFSET + MSG_CLEAR,	ZIL_NULLP(void), ZIL_NULLP(ZIL_ICHAR), 0 },
	{ MSG_OFFSET + MSG_HELP, 	ZIL_NULLP(void), ZIL_NULLP(ZIL_ICHAR), 0 },
	{ 0,						ZIL_NULLP(void), ZIL_NULLP(ZIL_ICHAR), 0 }
};

// ----- UIW_UNICODE_BUTTON -------------------------------------------------

UIW_UNICODE_BUTTON::UIW_UNICODE_BUTTON(int column, int line, int width, int itemID) :
	UIW_BUTTON(column, line, width, _messageTable[itemID].text,
	BTF_NO_TOGGLE | BTF_SEND_MESSAGE, WOF_JUSTIFY_CENTER,
	ZIL_NULLF(ZIL_USER_FUNCTION), _messageTable[itemID].value)
{
	woAdvancedFlags |= WOAF_NON_CURRENT;
}

EVENT_TYPE UIW_UNICODE_BUTTON::Event(const UI_EVENT &event)
{
	// Switch on the event type.
	if (event.type == S_CREATE || event.type == S_SIZE)
	{
		UI_WINDOW_OBJECT::Event(event);
		int height = relative.Height();
		relative.bottom = clip.Height() - display->cellWidth;
		relative.top = relative.bottom - height + 1;
	}
	return (UIW_BUTTON::Event(event));
}

// ----- UIW_HEX_INTEGER ----------------------------------------------------

static ZIL_ICHAR _xFormat[] = { '%','x', 0 };

UIW_HEX_INTEGER::UIW_HEX_INTEGER(int left, int top, int width) :
	UIW_STRING(left, top, width, ZIL_NULLP(ZIL_ICHAR), 1024)
{
	sprintf(text, _xFormat, 0);
}

EVENT_TYPE UIW_HEX_INTEGER::Event(const UI_EVENT &event)
{
	// Check for Zinc specific messages.
	EVENT_TYPE ccode = LogicalEvent(event, ID_STRING);
	switch (ccode)
	{
	case L_SELECT:
		if (!FlagSet(woStatus, WOS_INTERNAL_ACTION))
		{
			UIW_STRING::DataGet();
			int tableIndex = (ZIL_ICHAR)strtol(text, ZIL_NULLP(ZIL_ICHAR *), 0x10);
			ccode = UIW_STRING::Event(event);
			sprintf(text, _xFormat, tableIndex);
			UIW_STRING::DataSet(text);
			parent->Information(SET_INDEX, &tableIndex);
			eventManager->Put(L_PREVIOUS);
		}
		else
			ccode = UIW_STRING::Event(event);
		break;

	case S_REDISPLAY:
		if (!FlagSet(woStatus, WOS_INTERNAL_ACTION))
		{
			woStatus |= WOS_INTERNAL_ACTION;
			UIW_STRING::DataGet();
			int tableIndex; parent->Information(GET_INDEX, &tableIndex);
			sprintf(text, _xFormat, tableIndex);
			UIW_STRING::DataSet(text);
			woStatus &= ~WOS_INTERNAL_ACTION;
		}
		ccode = UIW_STRING::Event(event);
		break;

	default:
		ccode = UIW_STRING::Event(event);
		break;
	}

	// Return the control code.
	return (ccode);
}

// ----- UIW_HEX_BUTTON -----------------------------------------------------

UIW_HEX_BUTTON::UIW_HEX_BUTTON(int left, int top, int width, EVENT_TYPE _value) :
	UIW_BUTTON(left, top, width, ZIL_NULLP(ZIL_ICHAR), BTF_NO_TOGGLE | BTF_SEND_MESSAGE,
	WOF_JUSTIFY_CENTER, ZIL_NULLF(ZIL_USER_FUNCTION), _value)
{
	static ZIL_UINT8 _decBitmap[27] =
	{
		5, 5,
		BACKGROUND,	BACKGROUND,	BACKGROUND,	BACKGROUND,	BACKGROUND,
		BACKGROUND,	BACKGROUND,	BACKGROUND,	BACKGROUND,	BACKGROUND,
		BLACK,		BLACK,		BLACK,		BLACK,		BLACK,
		BACKGROUND,	BACKGROUND,	BACKGROUND,	BACKGROUND,	BACKGROUND,
		BACKGROUND,	BACKGROUND,	BACKGROUND,	BACKGROUND,	BACKGROUND
	};
	static ZIL_UINT8 _incBitmap[27] =
	{
		5, 5,
		BACKGROUND,	BACKGROUND,	BLACK,		BACKGROUND,	BACKGROUND,
		BACKGROUND,	BACKGROUND,	BLACK,		BACKGROUND,	BACKGROUND,
		BLACK,		BLACK,		BLACK,		BLACK,		BLACK,
		BACKGROUND,	BACKGROUND,	BLACK,		BACKGROUND,	BACKGROUND,
		BACKGROUND,	BACKGROUND,	BLACK,		BACKGROUND,	BACKGROUND
	};
	
	btFlags |= BTF_STATIC_BITMAPARRAY;
	woAdvancedFlags |= WOAF_NON_CURRENT;

	bitmapArray = (_value == DECREMENT_INDEX) ? _decBitmap : _incBitmap;
	bitmapWidth = bitmapArray[0];
	bitmapHeight = bitmapArray[0];
	bitmapArray = &bitmapArray[2];
}

EVENT_TYPE UIW_HEX_BUTTON::Event(const UI_EVENT &event)
{
	// Switch on the event type.
	if (event.type == S_CREATE || event.type == S_SIZE)
	{
		UI_WINDOW_OBJECT::Event(event);
		int height = (display->cellHeight - display->preSpace - display->postSpace) / 2;
		if (value == DECREMENT_INDEX)
			relative.bottom = relative.top + height;
		else if (value == INCREMENT_INDEX)
			relative.top = relative.bottom - height + 1;
	}
	return (UIW_BUTTON::Event(event));
}

// ----- UIW_UNICODE_STRING -------------------------------------------------

UIW_UNICODE_STRING::UIW_UNICODE_STRING(int left, int top, int width) :
	UIW_STRING(left, top, width, ZIL_NULLP(ZIL_ICHAR), 100)
{
}

EVENT_TYPE UIW_UNICODE_STRING::Event(const UI_EVENT &event)
{
	// Check for Zinc specific messages.
	EVENT_TYPE ccode = LogicalEvent(event, ID_STRING);
	switch (ccode)
	{
	case S_CREATE:
	case S_SIZE:
		UI_WINDOW_OBJECT::Event(event);
		relative.right = clip.Width() - display->cellWidth;
		ccode = UIW_STRING::Event(event);
		break;

	case L_SELECT:
		if (!FlagSet(woStatus, WOS_INTERNAL_ACTION))
		{
			UIW_STRING::DataGet();
			HexToChar(text);
			ccode = UIW_STRING::Event(event);
			UIW_STRING::DataSet(text);
		}
		else
			ccode = UIW_STRING::Event(event);
		break;

	default:
		ccode = UIW_STRING::Event(event);
		break;
	}

	// Return the control code.
	return (ccode);
}

void UIW_UNICODE_STRING::HexToChar(ZIL_ICHAR *text)
{
	const int HEX_RADIX = 0x10;
	static const ZIL_ICHAR HEX_INDEX[] = { '0','x', 0 };
#if defined(ZIL_UNICODE)
	const int MAX_HEX_LENGTH = 6;
#else
	const int MAX_HEX_LENGTH = 4;
#endif

	ZIL_ICHAR sValue[MAX_HEX_LENGTH+1];
	ZIL_ICHAR *start = strstr(text, HEX_INDEX);
	while (start)
	{
		strncpy(sValue, start, MAX_HEX_LENGTH);
		for (int i = 2; i < MAX_HEX_LENGTH; i++)
			if (!IsXDigit(sValue[i]))
				break;
		sValue[i] = '\0';
		*start = (ZIL_ICHAR)strtoul(sValue, ZIL_NULLP(ZIL_ICHAR), HEX_RADIX);
		strcpy(start + 1, start + strlen(sValue));
		start = strstr(start, HEX_INDEX);
	}
}

// ----- UIW_FONT_WINDOW ----------------------------------------------------

UIW_FONT_WINDOW::UIW_FONT_WINDOW(int left, int top, int width, int height) :
	UI_WINDOW_OBJECT(left, top, width, height, WOF_NO_FLAGS, WOAF_NO_FLAGS)
{
	woFlags |= WOF_BORDER;
	woStatus |= WOS_OWNERDRAW;
	woAdvancedFlags |= WOAF_NON_CURRENT;
}

EVENT_TYPE UIW_FONT_WINDOW::DrawItem(const UI_EVENT &, EVENT_TYPE )
{
	static ZIL_ICHAR _text[16] = { '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F' };
	int i, j;
	UI_REGION region = trueRegion;
	display->VirtualGet(screenID, region);
	display->Rectangle(screenID, region, lastPalette, 0, TRUE);

	UI_PALETTE *darkLine = &display->colorMap[BLACK];
	UI_PALETTE *lightLine = &display->colorMap[LIGHTGRAY];

	cellHeight = (region.Height() - display->cellWidth) / 17;
	cellWidth = (region.Width() - display->cellWidth) / 17;
	int column = region.left + cellHeight + 1;
	int line = region.top + cellHeight + 1;
	int _textXOffset = cellWidth / 2 - display->cellWidth;
	int _textYOffset = 0;
	for (i = 0; i < 16; i++, column += cellWidth, line += cellHeight)
	{
		display->Text(screenID, column + _textXOffset, region.top, &_text[i], lightLine, 1, FALSE);
		display->Text(screenID, region.left, line + _textYOffset, &_text[i], lightLine, 1, FALSE);
	}
	region.left += cellHeight, region.top += cellHeight;

	display->Rectangle(screenID, region, darkLine, 1); --region;
	active = region;

	int tableIndex; parent->Information(GET_INDEX, &tableIndex);
	for (i = 0, line = region.top + cellHeight - 1; i < 16; i++, line += cellHeight)
	{
		ZIL_ICHAR value = (tableIndex << 8) + i;
		display->Line(screenID, region.left, line, region.right, line, lightLine, 1);
		line -= cellHeight - 1;
		for (j = 0, column = region.left; j < 16; j++, column += cellWidth, value += 0x10)
			display->Text(screenID, column + _textXOffset, line + _textYOffset, &value, darkLine, 1, FALSE);
		line += cellHeight - 1;
	}
	for (j = 0, column = region.left + cellWidth - 1; j < 16; j++, column += cellWidth)
		display->Line(screenID, column, region.top, column, region.bottom, lightLine, 1);

	display->VirtualPut(screenID);
	return (TRUE);
}

EVENT_TYPE UIW_FONT_WINDOW::Event(const UI_EVENT &event)
{
	// Switch on the event type.
	EVENT_TYPE ccode = LogicalEvent(event, ID_WINDOW);
	if (event.InputType() == E_MOUSE && event.rawCode == M_LEFT_CHANGE)
		ccode = L_END_SELECT;
	switch (ccode)
	{
	case L_END_SELECT:
		{
		UI_WINDOW_OBJECT::Event(event);
		UI_POSITION position = event.position;
#if defined(ZIL_MSWINDOWS) || defined(ZIL_OS2)
		position.column += trueRegion.left;
		position.line += trueRegion.top;
#endif
		if (active.Overlap(position))
		{
			int column = (position.column - active.left) / cellWidth;
			int line = (position.line - active.top) / cellHeight;
			int tableIndex; parent->Information(GET_INDEX, &tableIndex);
			UI_EVENT keyEvent(E_KEY);
			keyEvent.rawCode = (tableIndex << 8) + (column << 4) + line;
			keyEvent.key.value = keyEvent.rawCode;
			keyEvent.key.shiftState = 0;
			eventManager->Put(keyEvent);
		}
		}
		break;

	case L_BEGIN_SELECT:
	case L_CONTINUE_SELECT:
		ccode = UI_WINDOW_OBJECT::Event(event);
		break;

	case S_CREATE:
	case S_SIZE:
		UI_WINDOW_OBJECT::Event(event);
		relative.left = display->cellWidth;
		relative.right = clip.Width() - display->cellWidth;
		relative.bottom = clip.Height() - display->cellHeight - display->cellWidth;
		ccode = UI_WINDOW_OBJECT::Event(event);
		UI_WINDOW_OBJECT::Event(S_REGISTER_OBJECT);
		break;

	default:
		ccode = UI_WINDOW_OBJECT::Event(event);
		break;
	}

	// Return the control code.
	return (ccode);
}

void *UIW_FONT_WINDOW::Information(ZIL_INFO_REQUEST request, void *data, OBJECTID objectID)
{
	// Switch on the request.
	switch (request)
	{
	default:
		data = UI_WINDOW_OBJECT::Information(request, data, objectID);
		break;
	}

	// Return the information.
	return (data);
}

// ----- UIW_UNICODE_EDITOR -------------------------------------------------

#if defined(ZIL_UNICODE)
	static int MIN_CELL_HEIGHT = 20;
	static int MIN_CELL_WIDTH = 70;
#else
	static int MIN_CELL_HEIGHT = 16;
	static int MIN_CELL_WIDTH = 70;
#endif

UIW_UNICODE_EDITOR::UIW_UNICODE_EDITOR(void) :
	UIW_WINDOW(0, 0, MIN_CELL_WIDTH, MIN_CELL_HEIGHT),
	tableIndex(0x00)
{
	if (!_messageTable[MSG_TITLE].text)
	{
#if defined(ZIL_UNICODE)
		_messageTable[MSG_TITLE].text = ISOtoUNICODE("Unicode Editor");
		_messageTable[MSG_ICONNAME].text = ISOtoUNICODE("uedit");
		_messageTable[MSG_ICONTITLE].text = ISOtoUNICODE("Unicode Editor");
		_messageTable[MSG_INDEX].text = ISOtoUNICODE("table index (0..FF):");
		_messageTable[MSG_CLEAR].text = ISOtoUNICODE("C~lear");
		_messageTable[MSG_HELP].text = ISOtoUNICODE("~Help");
#else
		_messageTable[MSG_TITLE].text = "Unicode Editor";
		_messageTable[MSG_ICONNAME].text = "uedit";
		_messageTable[MSG_ICONTITLE].text = "Unicode Editor";
		_messageTable[MSG_INDEX].text = "table index (0..FF):";
		_messageTable[MSG_CLEAR].text = "C~lear";
		_messageTable[MSG_HELP].text = "~Help";
#endif
	}

	woAdvancedFlags |= WOAF_LOCKED;
	*this
		+ new UIW_BORDER
		+ new UIW_MAXIMIZE_BUTTON
		+ new UIW_MINIMIZE_BUTTON
		+ new UIW_SYSTEM_BUTTON(SYF_GENERIC)
		+ new UIW_TITLE(_messageTable[MSG_TITLE].text)
		+ new UIW_ICON(0, 0, _messageTable[MSG_ICONNAME].text,
			_messageTable[MSG_ICONTITLE].text, ICF_MINIMIZE_OBJECT,
			WOF_SUPPORT_OBJECT | WOF_JUSTIFY_CENTER)
		+ (stringField = new UIW_UNICODE_STRING(4, 1, 40))
		+ new UIW_PROMPT(4, 2, _messageTable[MSG_INDEX].text)
		+ (hexField = new UIW_HEX_INTEGER(25, 2, 10))
		+ new UIW_HEX_BUTTON(36, 2, 3, DECREMENT_INDEX)
		+ new UIW_HEX_BUTTON(36, 2, 3, INCREMENT_INDEX)
		+ (fontField = new UIW_FONT_WINDOW(1, 3, 40, 4))
		+ new UIW_UNICODE_BUTTON(4, 7, 12, MSG_CLEAR)
		+ new UIW_UNICODE_BUTTON(17, 7, 12, MSG_HELP);

	if (windowManager)
		windowManager->Center(this);
}

EVENT_TYPE UIW_UNICODE_EDITOR::Event(const UI_EVENT &event)
{
	// Check for non editor-events.
	EVENT_TYPE ccode = event.type;
	if ((ccode == S_CREATE || ccode == S_SIZE) && !FlagSet(woStatus, WOS_MINIMIZED))
	{
		int MIN_HEIGHT = MIN_CELL_HEIGHT * display->cellHeight;
		int MIN_WIDTH = MIN_CELL_WIDTH * display->cellWidth;

		if (relative.Height() < MIN_HEIGHT)
			relative.bottom = relative.top + MIN_HEIGHT - 1;
		if (relative.Width() < MIN_WIDTH)
			relative.right = relative.left + MIN_WIDTH - 1;
		return (UIW_WINDOW::Event(event));
	}
	else if (ccode == INCREMENT_INDEX || ccode == DECREMENT_INDEX)
	{
		Information(ccode, ZIL_NULLP(void));
		return (S_CONTINUE);
	}
	else if (ccode < MSG_OFFSET)
		return (UIW_WINDOW::Event(event));

	// Switch on the event type.
	ccode -= MSG_OFFSET;
	switch (ccode)
	{
	case MSG_CLEAR:
		stringField->Information(I_SET_TEXT, _blankString);
		break;

	case MSG_HELP:
		break;
	}
	return (ccode);
}

void *UIW_UNICODE_EDITOR::Information(ZIL_INFO_REQUEST request, void *data, OBJECTID objectID)
{
	// Switch on the request.
	switch (request)
	{
	case GET_INDEX:
		*(int *)data = tableIndex;
		break;

	case SET_INDEX:
	case INCREMENT_INDEX:
	case DECREMENT_INDEX:
		// The index can only be changed for unicode character sets.
#if defined(ZIL_UNICODE)
		if (request == SET_INDEX && tableIndex != *(int *)data)
			tableIndex = *(int *)data;
		else if (request == DECREMENT_INDEX && tableIndex > 0x00)
			tableIndex--;
		else if (request == INCREMENT_INDEX && tableIndex < 0xFF)
			tableIndex++;
		else
			break;
		hexField->Event(S_REDISPLAY);
		fontField->Event(S_REDISPLAY);
#endif
		break;

	default:
		data = UIW_WINDOW::Information(request, data, objectID);
		break;
	}

	// Return the information.
	return (data);
}

