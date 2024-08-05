//	GRAPH.HPP (GRAPH) - Extended graphics example.
//	COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasant Grove, Utah  USA
// 	May be freely copied, used and distributed.

class LINE_CHART : public UIW_WINDOW
{
public:
	LINE_CHART(int left, int top, int width, int height, WOF_FLAGS woFlags = WOF_BORDER);

	virtual EVENT_TYPE DrawItem(const UI_EVENT &event, EVENT_TYPE ccode);
};

class BAR_CHART : public UIW_WINDOW
{
public:
	BAR_CHART(int left, int top, int width, int height, WOF_FLAGS woFlags);

	virtual EVENT_TYPE DrawItem(const UI_EVENT &event, EVENT_TYPE ccode);
};

class PIE_CHART : public UIW_WINDOW
{
public:
	PIE_CHART(int left, int top, int width, int height,
		WOF_FLAGS flags = WOF_NO_FLAGS);

	virtual EVENT_TYPE DrawItem(const UI_EVENT &event, EVENT_TYPE ccode);
};

