const EVENT_TYPE MY_EVENT = 10000;

static UI_PALETTE greenPalette = 
{ 
	' ', attrib(WHITE, CYAN), attrib(MONO_HIGH, MONO_BLACK),
	PTN_SOLID_FILL, CYAN, CYAN, BW_WHITE, BW_BLACK, GS_BLACK, GS_GRAY
};

class DRAW_WINDOW : public UIW_WINDOW
{
public:
	DRAW_WINDOW();
	virtual ~DRAW_WINDOW() {}
	EVENT_TYPE DrawItem(const UI_EVENT &event, EVENT_TYPE ccode);
};

class MDI_CHILD_WINDOW : public UIW_WINDOW
{
public:
	MDI_CHILD_WINDOW();
	virtual ~MDI_CHILD_WINDOW() {}
};
