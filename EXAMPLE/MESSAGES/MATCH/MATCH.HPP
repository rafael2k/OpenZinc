//  MATCH.HPP (MATCH) - Concentration program.
//  COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//  Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//  May be freely copied, used and distributed.

const EVENT_TYPE TOGGLE_BITMAP 		= 10000;
const EVENT_TYPE NEW_GAME 			= 10001;
const EVENT_TYPE UPDATE_BUTTON 		= 10002;
const EVENT_TYPE CLEAR_BUTTON 		= 10003;

const int MAXBITMAPS				= 18;
const int MAXBUTTONS				= 36;

class MATCH_BUTTON : public UIW_BUTTON
{
public:
	ZIL_ICHAR *bitmapOne;
	ZIL_ICHAR *bitmapTwo;

	MATCH_BUTTON(int left, int top, int width, BTF_FLAGS btFlags = BTF_NO_FLAGS,
		WOF_FLAGS woFlags = WOF_NO_FLAGS, EVENT_TYPE value = 0,
		ZIL_ICHAR *_bitmapOne = ZIL_NULLP(ZIL_ICHAR), ZIL_ICHAR *_bitmapTwo = ZIL_NULLP(ZIL_ICHAR));
	virtual ~MATCH_BUTTON(void) { };
	void SetBitmap(ZIL_ICHAR *name);
};

class MATCH_WINDOW : public UIW_WINDOW
{
public:
	MATCH_WINDOW(int left, int top, int width, int height);
	virtual ~MATCH_WINDOW(void) { };
	virtual EVENT_TYPE Event(const UI_EVENT &event);
	void Jumble(void);

protected:
	UIW_POP_UP_ITEM *newItem;
	UIW_WINDOW *buttonWindow;
	MATCH_BUTTON *choiceOne, *choiceTwo;
	EVENT_TYPE updateType;
};
