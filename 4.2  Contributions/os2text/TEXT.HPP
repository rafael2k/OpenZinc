class MY_TEXT : public UIW_TEXT
{
public:
#if defined(ZIL_LOAD)
	virtual ZIL_NEW_FUNCTION NewFunction(void) { return (MY_TEXT::New); }
	static UI_WINDOW_OBJECT *New(const char *name,
		ZIL_STORAGE_READ_ONLY *file = ZIL_NULLP(ZIL_STORAGE_READ_ONLY),
		ZIL_STORAGE_OBJECT_READ_ONLY *object = ZIL_NULLP(ZIL_STORAGE_OBJECT_READ_ONLY),
		UI_ITEM *objectTable = ZIL_NULLP(UI_ITEM),
		UI_ITEM *userTable = ZIL_NULLP(UI_ITEM))
		{ return (new MY_TEXT(name, file, object, objectTable, userTable)); }
	MY_TEXT(const char *name, ZIL_STORAGE_READ_ONLY *file = ZIL_NULLP(ZIL_STORAGE_READ_ONLY),
		ZIL_STORAGE_OBJECT_READ_ONLY *object = ZIL_NULLP(ZIL_STORAGE_OBJECT_READ_ONLY),
		UI_ITEM *objectTable = ZIL_NULLP(UI_ITEM),
		UI_ITEM *userTable = ZIL_NULLP(UI_ITEM));
#endif

	virtual ~MY_TEXT();
	virtual EVENT_TYPE Event(const UI_EVENT &event);

protected:
	UI_WINDOW_OBJECT *sibling;
};
