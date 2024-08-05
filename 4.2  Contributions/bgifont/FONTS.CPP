#include <ui_win.hpp>
#include <graphics.h>
#include <stdio.h>

class PROMPT : public UIW_PROMPT
{
public:
	PROMPT(int left, int top, ZIL_ICHAR *text, WOF_FLAGS woFlags = WOF_NO_FLAGS) :
		UIW_PROMPT(left, top, text, woFlags) {}
	EVENT_TYPE Event(const UI_EVENT &event);
};

const int FNT_NEW_FONT = 5;			// Placement for the new font.
void LoadFont(UI_DISPLAY *_display);	// Function to load the new font.

UI_BGI_DISPLAY::BGIFONT BGIFont;

UI_APPLICATION::Main()
{
	UI_BGI_DISPLAY::BGIFONT BGIFont =
		{
			0,		// font
			0,		// char size
			1,		// multX
			1,		// divX
			1,		// multY
			1,		// divY
			32,	// maxWidth
			38		// maxHeight
		};

	BGIFont.font = installuserfont("simp.fnt");
//	BGIFont.font = installuserfont("goth.fnt");

	UI_BGI_DISPLAY::fontTable[FNT_NEW_FONT] = BGIFont;
	settextstyle(BGIFont.font, HORIZ_DIR, 1);

	ZIL_ICHAR *text = "The quick brown fox jumped over the lazy dog.";

	UIW_WINDOW *fontWindow = UIW_WINDOW::Generic(35, 0, 60, 15, "Fonts Example");

	PROMPT *prompt = new PROMPT(2, 1, "New Font: ");
	prompt->Font(FNT_NEW_FONT);
	UIW_TEXT *textObj = new UIW_TEXT(2, 3, 54, 7, text, 100, WNF_NO_FLAGS);
	textObj->Font(FNT_NEW_FONT);

	*fontWindow
		+ prompt
		+ textObj;

	windowManager->Center(fontWindow);
	*windowManager + fontWindow;

	Control();

	return(0);
}

EVENT_TYPE PROMPT::Event(const UI_EVENT &event)
{
	EVENT_TYPE ccode = event.type;

	switch (ccode)
	{
	case S_CREATE:
	case S_CHANGED:
		ccode = UIW_PROMPT::Event(event);
		trueRegion.bottom += trueRegion.bottom - trueRegion.top;
		trueRegion.right += trueRegion.right - trueRegion.left;
		break;

	default:
		ccode = UIW_PROMPT::Event(event);
		break;
	}
	return (ccode);
}


