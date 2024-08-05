//  SPREAD.HPP (SPREAD) - Using UIW_TABLE as a spread sheet.
//  COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//  Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//  May be freely copied, used and distributed.

const ZIL_COMPLEX_OBJECTID ID_SPREAD_SHEET		= 5000;
const ZIL_COMPLEX_OBJECTID ID_SPREAD_SHEET_CELL	= 5001;

const ZIL_USER_EVENT S_CALCULATE = 10000;
const ZIL_USER_EVENT S_SAVE		 = 10001;

struct CELL_DATA
{
	char *text;
	int value;
};

CELL_DATA _initData[] =
{
	{ "\"X\"", 0 },
	{ "1", 0 },
	{ "2", 0 },
	{ "3", 0 },
	{ "4", 0 },
	{ "5", 0 },
	{ "6", 0 },
	{ "7", 0 },
	{ "8", 0 },
	{ "9", 0 },
	{ "10", 0 },
	{ "1", 0 },
	{ "A1 * B0", 0 },
	{ "A1 * C0", 0 },
	{ "A1 * D0", 0 },
	{ "A1 * E0", 0 },
	{ "A1 * F0", 0 },
	{ "A1 * G0", 0 },
	{ "A1 * H0", 0 },
	{ "A1 * I0", 0 },
	{ "A1 * J0", 0 },
	{ "A1 * K0", 0 },
	{ "2", 0 },
	{ "A2 * B0", 0 },
	{ "A2 * C0", 0 },
	{ "A2 * D0", 0 },
	{ "A2 * E0", 0 },
	{ "A2 * F0", 0 },
	{ "A2 * G0", 0 },
	{ "A2 * H0", 0 },
	{ "A2 * I0", 0 },
	{ "A2 * J0", 0 },
	{ "A2 * K0", 0 },
	{ "3", 0 },
	{ "A3 * B0", 0 },
	{ "A3 * C0", 0 },
	{ "A3 * D0", 0 },
	{ "A3 * E0", 0 },
	{ "A3 * F0", 0 },
	{ "A3 * G0", 0 },
	{ "A3 * H0", 0 },
	{ "A3 * I0", 0 },
	{ "A3 * J0", 0 },
	{ "A3 * K0", 0 },
	{ "4", 0 },
	{ "A4 * B0", 0 },
	{ "A4 * C0", 0 },
	{ "A4 * D0", 0 },
	{ "A4 * E0", 0 },
	{ "A4 * F0", 0 },
	{ "A4 * G0", 0 },
	{ "A4 * H0", 0 },
	{ "A4 * I0", 0 },
	{ "A4 * J0", 0 },
	{ "A4 * K0", 0 },
	{ "5", 0 },
	{ "A5 * B0", 0 },
	{ "A5 * C0", 0 },
	{ "A5 * D0", 0 },
	{ "A5 * E0", 0 },
	{ "A5 * F0", 0 },
	{ "A5 * G0", 0 },
	{ "A5 * H0", 0 },
	{ "A5 * I0", 0 },
	{ "A5 * J0", 0 },
	{ "A5 * K0", 0 },
	{ "6", 0 },
	{ "A6 * B0", 0 },
	{ "A6 * C0", 0 },
	{ "A6 * D0", 0 },
	{ "A6 * E0", 0 },
	{ "A6 * F0", 0 },
	{ "A6 * G0", 0 },
	{ "A6 * H0", 0 },
	{ "A6 * I0", 0 },
	{ "A6 * J0", 0 },
	{ "A6 * K0", 0 },
	{ "7", 0 },
	{ "A7 * B0", 0 },
	{ "A7 * C0", 0 },
	{ "A7 * D0", 0 },
	{ "A7 * E0", 0 },
	{ "A7 * F0", 0 },
	{ "A7 * G0", 0 },
	{ "A7 * H0", 0 },
	{ "A7 * I0", 0 },
	{ "A7 * J0", 0 },
	{ "A7 * K0", 0 },
	{ "8", 0 },
	{ "A8 * B0", 0 },
	{ "A8 * C0", 0 },
	{ "A8 * D0", 0 },
	{ "A8 * E0", 0 },
	{ "A8 * F0", 0 },
	{ "A8 * G0", 0 },
	{ "A8 * H0", 0 },
	{ "A8 * I0", 0 },
	{ "A8 * J0", 0 },
	{ "A8 * K0", 0 },
	{ "9", 0 },
	{ "A9 * B0", 0 },
	{ "A9 * C0", 0 },
	{ "A9 * D0", 0 },
	{ "A9 * E0", 0 },
	{ "A9 * F0", 0 },
	{ "A9 * G0", 0 },
	{ "A9 * H0", 0 },
	{ "A9 * I0", 0 },
	{ "A9 * J0", 0 },
	{ "A9 * K0", 0 },
	{ "10", 0 },
	{ "A10 * B0", 0 },
	{ "A10 * C0", 0 },
	{ "A10 * D0", 0 },
	{ "A10 * E0", 0 },
	{ "A10 * F0", 0 },
	{ "A10 * G0", 0 },
	{ "A10 * H0", 0 },
	{ "A10 * I0", 0 },
	{ "A10 * J0", 0 },
	{ "A10 * K0", 0 }
};

class SPREAD_SHEET : public UIW_TABLE
{
public:
	SPREAD_SHEET(void);
	virtual ~SPREAD_SHEET();

	virtual EVENT_TYPE Event(const UI_EVENT &event);

#if defined(ZIL_LOAD)
	virtual ZIL_NEW_FUNCTION NewFunction(void) { return (SPREAD_SHEET::New); }
	static UI_WINDOW_OBJECT *New(const char *name,
		ZIL_STORAGE_READ_ONLY *file = ZIL_NULLP(ZIL_STORAGE_READ_ONLY),
		ZIL_STORAGE_OBJECT_READ_ONLY *object = ZIL_NULLP(ZIL_STORAGE_OBJECT_READ_ONLY),
		UI_ITEM *objectTable = ZIL_NULLP(UI_ITEM),
		UI_ITEM *userTable = ZIL_NULLP(UI_ITEM))
		{ return (new SPREAD_SHEET(name, file, object, objectTable, userTable)); }
	SPREAD_SHEET(const char *name, ZIL_STORAGE_READ_ONLY *file = ZIL_NULLP(ZIL_STORAGE_READ_ONLY),
		ZIL_STORAGE_OBJECT_READ_ONLY *object = ZIL_NULLP(ZIL_STORAGE_OBJECT_READ_ONLY),
		UI_ITEM *objectTable = ZIL_NULLP(UI_ITEM),
		UI_ITEM *userTable = ZIL_NULLP(UI_ITEM));
	virtual void Load(const char *name, ZIL_STORAGE_READ_ONLY *file,
		ZIL_STORAGE_OBJECT_READ_ONLY *object, UI_ITEM *objectTable, UI_ITEM *userTable);
#endif
#if defined(ZIL_STORE)
	virtual void Store(const char *name,
		ZIL_STORAGE *file = ZIL_NULLP(ZIL_STORAGE),
		ZIL_STORAGE_OBJECT *object = ZIL_NULLP(ZIL_STORAGE_OBJECT),
		UI_ITEM *objectTable = ZIL_NULLP(UI_ITEM),
		UI_ITEM *userTable = ZIL_NULLP(UI_ITEM));
#endif

protected:

};

class SPREAD_SHEET_CELL : public UIW_TABLE_RECORD
{
public:
	SPREAD_SHEET_CELL(void);
	virtual ~SPREAD_SHEET_CELL();

	virtual EVENT_TYPE Event(const UI_EVENT &event);

#if defined(ZIL_LOAD)
	virtual ZIL_NEW_FUNCTION NewFunction(void) { return (SPREAD_SHEET_CELL::New); }
	static UI_WINDOW_OBJECT *New(const char *name,
		ZIL_STORAGE_READ_ONLY *file = ZIL_NULLP(ZIL_STORAGE_READ_ONLY),
		ZIL_STORAGE_OBJECT_READ_ONLY *object = ZIL_NULLP(ZIL_STORAGE_OBJECT_READ_ONLY),
		UI_ITEM *objectTable = ZIL_NULLP(UI_ITEM),
		UI_ITEM *userTable = ZIL_NULLP(UI_ITEM))
		{ return (new SPREAD_SHEET_CELL(name, file, object, objectTable, userTable)); }
	SPREAD_SHEET_CELL(const char *name, ZIL_STORAGE_READ_ONLY *file = ZIL_NULLP(ZIL_STORAGE_READ_ONLY),
		ZIL_STORAGE_OBJECT_READ_ONLY *object = ZIL_NULLP(ZIL_STORAGE_OBJECT_READ_ONLY),
		UI_ITEM *objectTable = ZIL_NULLP(UI_ITEM),
		UI_ITEM *userTable = ZIL_NULLP(UI_ITEM));
#endif

protected:
	UIW_STRING *dataField;
};
