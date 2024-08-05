// ----- MOVIE_CONTROL -----------------------------------------------------

// class definition
class MOVIE_CONTROL : public UIW_WINDOW
{
public:
	static ZIL_STORAGE *_dataFile;
	static ZIL_ICHAR _movieName[64];
	MOVIE_CONTROL(void);
	~MOVIE_CONTROL(void);
	virtual EVENT_TYPE Event(const UI_EVENT &event);
	virtual void *Information(ZIL_INFO_REQUEST request, void *data, ZIL_OBJECTID objectID = ID_DEFAULT);

private:
	static EVENT_TYPE Exit(UI_DISPLAY *, UI_EVENT_MANAGER *, UI_WINDOW_MANAGER *windowManager);
	EVENT_TYPE MovieCreate(const UI_EVENT &event);
	EVENT_TYPE MovieDelete(const UI_EVENT &event);
	EVENT_TYPE MovieLoad(const UI_EVENT &event);
	EVENT_TYPE MovieStore(const UI_EVENT &event);
};

// class identification
const ZIL_USER_OBJECTID ID_MOVIE_CONTROL  		= 10000;

// class messages
const ZIL_USER_EVENT OPT_HELP					= 10000;
const ZIL_USER_EVENT OPT_MOVIE_CREATE			= 10001;
const ZIL_USER_EVENT OPT_MOVIE_DELETE			= 10002;
const ZIL_USER_EVENT OPT_MOVIE_LOAD				= 10003;
const ZIL_USER_EVENT OPT_MOVIE_STORE			= 10004;
const ZIL_USER_EVENT OPT_MOVIE_OK				= 10005;
const ZIL_USER_EVENT OPT_RESET_SELECTION		= 10006;

// class information
const INFO_REQUEST I_UPDATE_STATUS				= 10000;

// ----- MOVIE_SELECTION ----------------------------------------------------

class MOVIE_SELECTION : public UIW_WINDOW
{
public:
	MOVIE_SELECTION(ZIL_STORAGE_READ_ONLY *file, ZIL_USER_EVENT request);
	virtual EVENT_TYPE Event(const UI_EVENT &event);

private:
	ZIL_USER_EVENT request;
};

// class identification
const ZIL_USER_OBJECTID ID_MOVIE_SELECTION		= 10001;

// ----- MOVIE_INFORMATION --------------------------------------------------

class MOVIE_INFORMATION : public UIW_WINDOW
{
public:
	MOVIE_INFORMATION(ZIL_ICHAR *name = ZIL_NULLP(ZIL_ICHAR));
	virtual EVENT_TYPE Event(const UI_EVENT &event);
	virtual void Load(const ZIL_ICHAR *name, ZIL_STORAGE_READ_ONLY *file,
		ZIL_STORAGE_OBJECT_READ_ONLY *object = ZIL_NULLP(ZIL_STORAGE_OBJECT_READ_ONLY),
		UI_ITEM *objectTable = ZIL_NULLP(UI_ITEM),
		UI_ITEM *userTable = ZIL_NULLP(UI_ITEM));
	virtual void Store(const ZIL_ICHAR *name,
		ZIL_STORAGE *file = ZIL_NULLP(ZIL_STORAGE),
		ZIL_STORAGE_OBJECT *object = ZIL_NULLP(ZIL_STORAGE_OBJECT),
		UI_ITEM *objectTable = ZIL_NULLP(UI_ITEM),
		UI_ITEM *userTable = ZIL_NULLP(UI_ITEM));
};

// class identification
const ZIL_USER_OBJECTID ID_MOVIE_INFORMATION	= 10002;

