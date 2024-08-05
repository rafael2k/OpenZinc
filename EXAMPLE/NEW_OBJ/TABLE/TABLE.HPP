//	TABLE.HPP (TABLE) - Using a table
//	COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//  May be freely copied, used and distributed.

const ZIL_USER_EVENT S_ADD_RECORD		= 10000;
const ZIL_USER_EVENT S_DELETE_RECORD	= 10001;
const ZIL_USER_EVENT S_CALCULATE_TOTALS	= 10002;

struct SALE_RECORD
{
	ZIL_IBIGNUM price;
	WOS_STATUS shipped;
	ZIL_ICHAR date[20];
	ZIL_ICHAR item[32];
};

SALE_RECORD _saleData[10] =
{
	{ 255,	WOS_SELECTED,	"August 10, 1994",	"340 Meg IDE Hard Drive" },
	{ 39,	WOS_SELECTED,	"August 10, 1994",	"3.5\" 1.44 Meg Floppy" },
	{ 96,	WOS_SELECTED,	"August 11, 1994",	"14.4 BPS Fax Modem" },
	{ 670,	WOS_SELECTED,	"August 14, 1994",	"Laser Printer" },
	{ 1199,	WOS_SELECTED,	"August 15, 1994",	"PENTIUM 90Mhz Motherboard" },
	{ 107,	WOS_SELECTED,	"August 15, 1994",	"Tower Case w/ Power" },
	{ 279,	WOS_SELECTED,	"August 15, 1994",	"14\" 1024x768 Monitor" },
	{ 11,	WOS_SELECTED,	"August 16, 1994",	"AT I/O Card 2S/1P/1G" },
	{ 299,	WOS_SELECTED,	"August 16, 1994",	"8 Meg RAM 60ns" },
	{ 99,	WOS_SELECTED,	"August 17, 1994",	"OS/2 2.1" }
};

class TABLE_WINDOW : public UIW_WINDOW
{
public:
	TABLE_WINDOW(int left, int top, int width, int height);
	virtual ~TABLE_WINDOW();

	virtual EVENT_TYPE Event(const UI_EVENT &event);

protected:
	UIW_TABLE *table;
	UIW_BIGNUM *totalField;
};
