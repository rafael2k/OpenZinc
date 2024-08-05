const EVENT_TYPE REFRESH   = 10000;
const EVENT_TYPE RETURN_WINDOW = 10001;

const ZIL_INFO_REQUEST I_SET_CURRENT_RECORD = 20000;

const ZIL_USER_OBJECTID ID_LIST_TABLE_RECORD = 3501;

static UI_PALETTE hilightPalette =
{
	' ', attrib(BLACK, CYAN), attrib(MONO_BLACK, MONO_HIGH),
	PTN_SOLID_FILL, BLACK, CYAN, BW_BLACK, BW_WHITE, GS_BLACK, GS_WHITE
};

static UI_PALETTE whitePalette =
{
	' ', attrib(BLACK, CYAN), attrib(MONO_BLACK, MONO_HIGH),
	PTN_SOLID_FILL, BLACK, WHITE, BW_BLACK, BW_WHITE, GS_BLACK, GS_WHITE
};

class ZIL_EXPORT_CLASS LIST_TABLE_RECORD : public UIW_TABLE_RECORD
{
public:
	virtual ~LIST_TABLE_RECORD();
	LIST_TABLE_RECORD(int width, int height,
		ZIL_USER_FUNCTION userFunction = ZIL_NULLF(ZIL_USER_FUNCTION),
		WOF_FLAGS woFlags = WOF_NO_FLAGS);

	virtual EVENT_TYPE DrawItem(const UI_EVENT &event, EVENT_TYPE ccode);
	virtual EVENT_TYPE Event(const UI_EVENT &event);

#if defined(ZIL_LOAD)
	virtual ZIL_NEW_FUNCTION NewFunction(void) { return (LIST_TABLE_RECORD::New); }
	static UI_WINDOW_OBJECT *New(const char *name,
		ZIL_STORAGE_READ_ONLY *file = ZIL_NULLP(ZIL_STORAGE_READ_ONLY),
		ZIL_STORAGE_OBJECT_READ_ONLY *object = ZIL_NULLP(ZIL_STORAGE_OBJECT_READ_ONLY),
		UI_ITEM *objectTable = ZIL_NULLP(UI_ITEM),
		UI_ITEM *userTable = ZIL_NULLP(UI_ITEM))
		{ return (new LIST_TABLE_RECORD(name, file, object, objectTable, userTable)); }
	LIST_TABLE_RECORD(const char *name, ZIL_STORAGE_READ_ONLY *file = ZIL_NULLP(ZIL_STORAGE_READ_ONLY),
		ZIL_STORAGE_OBJECT_READ_ONLY *object = ZIL_NULLP(ZIL_STORAGE_OBJECT_READ_ONLY),
		UI_ITEM *objectTable = ZIL_NULLP(UI_ITEM),
		UI_ITEM *userTable = ZIL_NULLP(UI_ITEM));
#endif

protected:
	ZIL_ICHAR listText[150];
};

class LIST_TABLE : public UIW_TABLE
{
public:
	virtual ~LIST_TABLE();

#if defined(ZIL_LOAD)
	virtual ZIL_NEW_FUNCTION NewFunction(void) { return (LIST_TABLE::New); }
	static UI_WINDOW_OBJECT *New(const char *name,
		ZIL_STORAGE_READ_ONLY *file = ZIL_NULLP(ZIL_STORAGE_READ_ONLY),
		ZIL_STORAGE_OBJECT_READ_ONLY *object = ZIL_NULLP(ZIL_STORAGE_OBJECT_READ_ONLY),
		UI_ITEM *objectTable = ZIL_NULLP(UI_ITEM),
		UI_ITEM *userTable = ZIL_NULLP(UI_ITEM))
		{ return (new LIST_TABLE(name, file, object, objectTable, userTable)); }
	LIST_TABLE(const char *name, ZIL_STORAGE_READ_ONLY *file = ZIL_NULLP(ZIL_STORAGE_READ_ONLY),
		ZIL_STORAGE_OBJECT_READ_ONLY *object = ZIL_NULLP(ZIL_STORAGE_OBJECT_READ_ONLY),
		UI_ITEM *objectTable = ZIL_NULLP(UI_ITEM),
		UI_ITEM *userTable = ZIL_NULLP(UI_ITEM));
#endif
};

class WINDOW : public UIW_WINDOW
{
public:
	WINDOW(int left, int top, int width, int height);
	virtual ~WINDOW() {}
	EVENT_TYPE Event(const UI_EVENT &event);

protected:
	UIW_TABLE *table;
};

class WINDOW_MANAGER : public UI_WINDOW_MANAGER
{
public:
	WINDOW_MANAGER(UI_DISPLAY *display, UI_EVENT_MANAGER *eventManager) :
		UI_WINDOW_MANAGER(display, eventManager) { }
 	~WINDOW_MANAGER() { }
	EVENT_TYPE Event(const UI_EVENT &event);

protected:
	UI_WINDOW_OBJECT *listWindow;
};
