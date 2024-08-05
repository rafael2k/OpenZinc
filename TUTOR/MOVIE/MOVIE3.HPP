// ----- MOVIE_CONTROL -----------------------------------------------------

// class definition
class MOVIE_CONTROL : public UIW_WINDOW
{
public:
	MOVIE_CONTROL(void);
	virtual EVENT_TYPE Event(const UI_EVENT &event);

private:
	EVENT_TYPE MovieCreate(const UI_EVENT &event);
	EVENT_TYPE MovieDelete(const UI_EVENT &event);
	EVENT_TYPE MovieLoad(const UI_EVENT &event);
	EVENT_TYPE MovieStore(const UI_EVENT &event);
};

// class messages
const ZIL_USER_EVENT OPT_HELP					= 10000;
const ZIL_USER_EVENT OPT_MOVIE_CREATE			= 10001;
const ZIL_USER_EVENT OPT_MOVIE_DELETE			= 10002;
const ZIL_USER_EVENT OPT_MOVIE_LOAD				= 10003;
const ZIL_USER_EVENT OPT_MOVIE_STORE			= 10004;

