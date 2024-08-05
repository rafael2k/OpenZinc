//	WORLD.HPP (WORLD) - Shows how to broadcast messages to all windows.
//	COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//	May be freely copied, used and distributed.

const EVENT_TYPE STOP_WORLD          = 10001;
const EVENT_TYPE TOGGLE_DEVICE_STATE = 10002;

class ZIL_EXPORT_CLASS WORLD_WINDOW_MANAGER : public UI_WINDOW_MANAGER
{
public:
	WORLD_WINDOW_MANAGER(UI_DISPLAY *display, UI_EVENT_MANAGER *eventManager) :
		UI_WINDOW_MANAGER(display, eventManager) { }
 	~WORLD_WINDOW_MANAGER() { }
	EVENT_TYPE Event(const UI_EVENT &event);
};

class ZIL_EXPORT_CLASS WORLD_BITMAP : public UI_WINDOW_OBJECT
{
public:
	WORLD_BITMAP(int _left, int _top, int _width, int _height);
 	~WORLD_BITMAP() { }
	EVENT_TYPE DrawItem(const UI_EVENT &event, EVENT_TYPE ccode);
	EVENT_TYPE Event(const UI_EVENT &event);
private:
	int currentBitmap;
	int numberOfBitmaps;
};

class ZIL_EXPORT_CLASS WORLD_WINDOW : public UIW_WINDOW
{
public:
	WORLD_WINDOW();
	virtual ~WORLD_WINDOW() { }
	virtual EVENT_TYPE Event(const UI_EVENT &event);

private:
	UI_WINDOW_OBJECT *radioBtn;
	WORLD_BITMAP *worldField;
};

