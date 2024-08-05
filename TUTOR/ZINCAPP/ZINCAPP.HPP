//	ZINCAPP.HPP (ZINCAPP) - This file contains the zinc application control and class definitions.
//	COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//  May be freely copied, used and distributed.

// Display options.
const EVENT_TYPE MSG_DISPLAY			= 10001;
const EVENT_TYPE MSG_25x40_MODE			= 10002;
const EVENT_TYPE MSG_25x80_MODE			= 10003;
const EVENT_TYPE MSG_43x80_MODE			= 10004;
const EVENT_TYPE MSG_GRAPHICS_MODE		= 10005;
const EVENT_TYPE MSG_WINDOWS_MODE		= 10006;

// Window options.
const EVENT_TYPE MSG_WINDOW				= 10100;
const EVENT_TYPE MSG_GENERIC_WINDOW		= 10101;
const EVENT_TYPE MSG_DATE_WINDOW		= 10102;
const EVENT_TYPE MSG_TIME_WINDOW		= 10103;
const EVENT_TYPE MSG_NUMBER_WINDOW		= 10104;
const EVENT_TYPE MSG_STRING_WINDOW		= 10105;
const EVENT_TYPE MSG_TEXT_WINDOW		= 10106;
const EVENT_TYPE MSG_MENU_WINDOW		= 10107;
const EVENT_TYPE MSG_LIST_WINDOW		= 10108;
const EVENT_TYPE MSG_ICON_WINDOW		= 10109;
const EVENT_TYPE MSG_BUTTON_WINDOW		= 10110;
const EVENT_TYPE MSG_TOOL_BAR_WINDOW	= 10111;
const EVENT_TYPE MSG_COMBO_BOX_WINDOW	= 10112;

// Event options.
const EVENT_TYPE MSG_EVENT				= 10200;
const EVENT_TYPE MSG_EVENT_MONITOR		= 10201;

// Help options.
const EVENT_TYPE MSG_HELP				= 10300;
const EVENT_TYPE MSG_HELP_KEYBOARD		= 10302;
const EVENT_TYPE MSG_HELP_MOUSE			= 10303;
const EVENT_TYPE MSG_HELP_COMMANDS		= 10304;
const EVENT_TYPE MSG_HELP_PROCEDURES	= 10305;
const EVENT_TYPE MSG_HELP_OBJECTS		= 10306;
const EVENT_TYPE MSG_HELP_HELP			= 10307;
const EVENT_TYPE MSG_HELP_ZINCAPP		= 10308;

// Highest and lowest messages for ZINCAPP.
const EVENT_TYPE MSG_FIRST				= 10000;
const EVENT_TYPE MSG_LAST				= 20000;

class ZINCAPP_WINDOW_MANAGER : public UI_WINDOW_MANAGER
{
public:
	ZINCAPP_WINDOW_MANAGER(UI_DISPLAY *display, UI_EVENT_MANAGER *eventManager) :
		UI_WINDOW_MANAGER(display, eventManager, ZINCAPP_WINDOW_MANAGER::ExitFunction) { }
	virtual EVENT_TYPE Event(const UI_EVENT &event);

private:
	static EVENT_TYPE ExitFunction(UI_DISPLAY *display,
		UI_EVENT_MANAGER *eventManager, UI_WINDOW_MANAGER *windowManager);
};

class CONTROL_WINDOW : public UIW_WINDOW
{
public:
	CONTROL_WINDOW(void);
	virtual EVENT_TYPE Event(const UI_EVENT &event);

protected:
	void OptionDisplay(EVENT_TYPE item);
	void OptionEvent(EVENT_TYPE item);
	void OptionHelp(EVENT_TYPE item);
	void OptionWindow(EVENT_TYPE item);

	UI_DEVICE *EventMonitor(void);
};

class EVENT_MONITOR : public UIW_WINDOW
{
public:
	EVENT_MONITOR(void);
	EVENT_TYPE Event(const UI_EVENT &event);

private:
#if defined(ZIL_MSDOS)
	UIW_PROMPT *keyboard[3];
	UI_EVENT kEvent;
	UIW_PROMPT *mouse[3];
	UI_EVENT mEvent;
#elif defined(ZIL_MSWINDOWS)
	UIW_PROMPT *windowsMessage[5];
	MSG wMsg;
#elif defined(ZIL_OS2)
	UIW_PROMPT *windowsMessage[5];
	QMSG oMsg;
#elif defined(ZIL_MOTIF)
	UIW_PROMPT *motifMessage[3];
	XEvent xEvt;
#elif defined(ZIL_MACINTOSH)
	UIW_PROMPT *macintoshMessage[5];
	EventRecord mEvent;
#endif
	UIW_PROMPT *system;
	UI_EVENT sEvent;
};
