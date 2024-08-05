//	SPY.HPP (SPY) - An event monitor example program.
//	COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//  May be freely copied, used and distributed.

#include <ui_win.hpp>

// This MUST be greater than the length of the formatted string sent to ttyWindow->Printf() !!!!!
const int MAX_TTY_STRING_LENGTH = 80;

class TTY_ELEMENT : public UIW_PROMPT
{
	friend class TTY_WINDOW;
public:
	void DataSet(TTY_ELEMENT *element) { UIW_PROMPT::DataSet((char *)element->DataGet()); }
	void DataSet(char *string) { UIW_PROMPT::DataSet(string); }
	virtual EVENT_TYPE Event(const UI_EVENT &event);

	TTY_ELEMENT *Next(void) { return (TTY_ELEMENT *)next; }
	TTY_ELEMENT *Previous(void) { return (TTY_ELEMENT *)previous; }

private:
	int height;

	TTY_ELEMENT(int left, int top, int width, int _height);
};

class TTY_WINDOW : public UIW_WINDOW
{
public:
	TTY_WINDOW(void);

	EVENT_TYPE Event(const UI_EVENT &event);
	void Printf(char *format, ...);

	TTY_ELEMENT *Current(void) { return (TTY_ELEMENT *)current; }
	TTY_ELEMENT *First(void) { return (TTY_ELEMENT *)first; }
	TTY_ELEMENT *Last(void) { return (TTY_ELEMENT *)last; }

private:
	int numberShowing;
	int newList;
};

class SPY : public UI_DEVICE
{
public:
	SPY(UI_WINDOW_MANAGER *_windowManager);
	~SPY(void) { delete spyWindow; }

	EVENT_TYPE Event(const UI_EVENT &event);

protected:
	void Poll(void);

private:
	UI_WINDOW_MANAGER *windowManager;
	UIW_WINDOW *spyWindow;
	TTY_WINDOW *ttyWindow;
};
