//	TABLE.CPP (TABLE) - Using a table
//	COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//  May be freely copied, used and distributed.

#include <ui_win.hpp>
#include "table.hpp"

void z_jump_dummy(void) { }   // Bug fix for broken linkers.


EVENT_TYPE RecordFunction(UI_WINDOW_OBJECT *object, UI_EVENT &event, EVENT_TYPE ccode)
{
	SALE_RECORD *saleRecord = (SALE_RECORD *)event.data;

	if (ccode == S_SET_DATA)
	{
		object->Get("DATE_FIELD")->Information(I_SET_TEXT, saleRecord->date);
		object->Get("ITEM_FIELD")->Information(I_SET_TEXT, saleRecord->item);
		ZIL_BIGNUM priceNum(saleRecord->price);
		object->Get("PRICE_FIELD")->Information(I_SET_VALUE, &priceNum);

		UI_WINDOW_OBJECT *shippedBox = object->Get("SHIPPED_BOX");
		if (FlagSet(saleRecord->shipped, WOS_SELECTED) != FlagSet(shippedBox->woStatus, WOS_SELECTED))
			shippedBox->Event(UI_EVENT(L_SELECT));
	}
	else if (ccode == S_NON_CURRENT || ccode == L_SELECT)
	{
		object->Get("DATE_FIELD")->Information(I_COPY_TEXT, saleRecord->date);
		object->Get("ITEM_FIELD")->Information(I_COPY_TEXT, saleRecord->item);
		saleRecord->shipped = object->Get("SHIPPED_BOX")->woStatus;

		ZIL_BIGNUM priceNum;
		object->Get("PRICE_FIELD")->Information(I_GET_VALUE, &priceNum);
		priceNum.Export(&saleRecord->price);
		object->eventManager->Put(UI_EVENT(S_CALCULATE_TOTALS));
	}
	return (ccode);
}

TABLE_WINDOW::TABLE_WINDOW(int left, int top, int width, int height) :
	UIW_WINDOW(left, top, width, height)
{
	UIW_TABLE_RECORD *tableRecord;
	UIW_DATE *dateField;
	UIW_STRING *itemField;
	UIW_BIGNUM *priceField;
	UIW_BUTTON *shippedBox;

	ZIL_DATE date;
	ZIL_BIGNUM bignum;

	*this
		+ new UIW_BORDER
		+ new UIW_MAXIMIZE_BUTTON
		+ new UIW_MINIMIZE_BUTTON
		+ new UIW_SYSTEM_BUTTON(SYF_GENERIC)
		+ new UIW_TITLE("Sales Table")
		+ &(*new UIW_PULL_DOWN_MENU()
			+ &(*new UIW_PULL_DOWN_ITEM("&File")
				+ new UIW_POP_UP_ITEM("&Insert Record", MNIF_SEND_MESSAGE, BTF_NO_3D,
					WOF_NO_FLAGS, ZIL_NULLF(ZIL_USER_FUNCTION), S_ADD_RECORD)
				+ new UIW_POP_UP_ITEM("&Delete Record", MNIF_SEND_MESSAGE, BTF_NO_3D,
					WOF_NO_FLAGS, ZIL_NULLF(ZIL_USER_FUNCTION), S_DELETE_RECORD)
				+ new UIW_POP_UP_ITEM()
				+ new UIW_POP_UP_ITEM("E&xit", MNIF_SEND_MESSAGE, BTF_NO_3D,
					WOF_NO_FLAGS, ZIL_NULLF(ZIL_USER_FUNCTION), L_EXIT)))
		+ &(*(table = new UIW_TABLE(0, 0, 0, 0, 1, sizeof(SALE_RECORD), 100, _saleData,
			10, TBLF_NO_FLAGS, WOF_NON_FIELD_REGION))
			+ &(*new UIW_TABLE_HEADER(THF_COLUMN_HEADER)
				+ &(*new UIW_TABLE_RECORD(63, 1)
					+ new UIW_PROMPT(2, 0, "Date")
					+ new UIW_PROMPT(17, 0, "Description")
					+ new UIW_PROMPT(46, 0, "Price")
					+ new UIW_PROMPT(55, 0, "Shipped")))
			+ new UIW_SCROLL_BAR(0, 0, 0, 0, SBF_VERTICAL)
			+ &(*(tableRecord = new UIW_TABLE_RECORD(63, 1, RecordFunction))
				+ (dateField = new UIW_DATE(1, 0, 14, &date, ZIL_NULLP(ZIL_ICHAR),
					DTF_ALPHA_MONTH | DTF_SHORT_MONTH, WOF_BORDER))
				+ (itemField = new UIW_STRING(16, 0, 28, "", 28))
				+ (priceField = new UIW_BIGNUM(45, 0, 10, &bignum, ZIL_NULLP(ZIL_ICHAR),
					NMF_CURRENCY | NMF_DECIMAL(2) | NMF_COMMAS, WOF_BORDER | WOF_JUSTIFY_RIGHT))
				+ (shippedBox = new UIW_BUTTON(56, 0, 3, "", BTF_CHECK_BOX))))
		+ &(*new UIW_STATUS_BAR()
			+ new UIW_PROMPT(30, 0, "Total Sales:")
			+ (totalField = new UIW_BIGNUM(43, 0, 12, &bignum, ZIL_NULLP(ZIL_ICHAR),
				NMF_CURRENCY | NMF_DECIMAL(2) | NMF_COMMAS, WOF_BORDER | WOF_JUSTIFY_RIGHT)));

	tableRecord->wnFlags |= WNF_SELECT_MULTIPLE;
	dateField->StringID("DATE_FIELD");
	itemField->StringID("ITEM_FIELD");
	priceField->StringID("PRICE_FIELD");
	shippedBox->StringID("SHIPPED_BOX");
	shippedBox->woAdvancedFlags |= WOAF_NON_CURRENT;

	eventManager->Put(UI_EVENT(S_CALCULATE_TOTALS));
}

TABLE_WINDOW::~TABLE_WINDOW()
{
}

EVENT_TYPE TABLE_WINDOW::Event(const UI_EVENT &event)
{
	EVENT_TYPE ccode = event.type;

	switch (ccode)
	{
	case S_ADD_RECORD:
		{
		int recordNum = table->CurrentRecord();
		if (recordNum == -1)
			recordNum = 0;
		SALE_RECORD saleRecord;
		ZIL_DATE().Export(saleRecord.date, DTF_ALPHA_MONTH);
		saleRecord.item[0] = '\0';
		saleRecord.price = 0;
		saleRecord.shipped = WOS_NO_STATUS;
		table->InsertRecord(recordNum, &saleRecord);
		UI_EVENT scrollEvent(S_SCROLLRANGE);
		table->ScrollEvent(scrollEvent);
		table->Event(UI_EVENT(S_REDISPLAY));
		}
		break;

	case S_DELETE_RECORD:
        int recordCount;
        table->DataGet(&recordCount);
        if (recordCount > 0)
		{
			table->DeleteRecord(table->CurrentRecord());
			UI_EVENT scrollEvent(S_SCROLLRANGE);
			table->ScrollEvent(scrollEvent);
			table->Event(UI_EVENT(S_REDISPLAY));
		}
		// Continue.

	case S_CALCULATE_TOTALS:
		{
		int records;
		SALE_RECORD *saleData = (SALE_RECORD *)table->DataGet(&records);
		ZIL_IBIGNUM total = 0;
		for (int i = 0; i < records; i++)
			total += saleData[i].price;

		ZIL_BIGNUM totalNum(total);
		if (*totalField->DataGet() != totalNum)
			totalField->DataSet(&totalNum);
		}
		break;

	default:
		ccode = UIW_WINDOW::Event(event);
	}

	return (ccode);
}

int UI_APPLICATION::Main()
{
	UI_APPLICATION::LinkMain();

	TABLE_WINDOW *tableWindow = new TABLE_WINDOW(0, 0, 66, 10);
	windowManager->Center(tableWindow);
	windowManager->Add(tableWindow);

	// Process user responses.
	UI_APPLICATION::Control();

	return (0);
}

static UI_ITEM _objectTable[] =
{
	{ ID_BIGNUM, 			(UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_BIGNUM::New), 			UIW_BIGNUM::_className, 			0 },
	{ ID_BUTTON, 			(UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_BUTTON::New), 			UIW_BUTTON::_className, 			0 },
	{ ID_DATE, 				(UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_DATE::New),				UIW_DATE::_className, 				0 },
	{ ID_PROMPT, 			(UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_PROMPT::New), 			UIW_PROMPT::_className, 			0 },
	{ ID_STRING, 			(UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_STRING::New), 			UIW_STRING::_className, 			0 },
	{ ID_TABLE_RECORD,		(UI_WINDOW_OBJECT*)ZIL_VOIDF(UIW_TABLE_RECORD::New), 		UIW_TABLE_RECORD::_className,		0 },
	{ ID_END, 				ZIL_NULLP(void), 						ZIL_NULLP(ZIL_ICHAR), 				0 }
};
UI_ITEM *UI_WINDOW_OBJECT::objectTable = _objectTable;


static UI_ITEM _userTable[] =
{
	{ ID_END, ZIL_NULLP(void), ZIL_NULLP(ZIL_ICHAR), 0 }
};
UI_ITEM *UI_WINDOW_OBJECT::userTable = _userTable;
