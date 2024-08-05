//	DISPLAY.CPP (DISPLAY) - Example demonstrating the UI_DISPLAY classes.
//	COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//  May be freely copied, used and distributed.

#include <stdio.h>
#include <ui_evt.hpp>

static UI_PALETTE linePalette =
	{ '\260', attrib(LIGHTGRAY, LIGHTGRAY), attrib(MONO_DIM, MONO_DIM),
	PTN_SOLID_FILL, LIGHTGRAY, LIGHTGRAY, BW_WHITE, BW_WHITE, GS_WHITE, GS_WHITE };

static UI_PALETTE barPalette =
	{ '\260', attrib(YELLOW, RED), attrib(MONO_DIM, MONO_BLACK),
	PTN_SOLID_FILL, YELLOW, RED, BW_BLACK, BW_WHITE, GS_BLACK, GS_WHITE };

class BOX : public UI_ELEMENT
{
public:
	UI_DISPLAY *display;
	UI_REGION region;

	BOX(UI_DISPLAY *_display) : display(_display) {}

	void Move(const UI_REGION &current)
		{ region = current; }
	void Draw()
		{ display->Rectangle(ID_SCREEN, region, &linePalette); }
	void Erase()
		{ display->Rectangle(ID_SCREEN, region, display->backgroundPalette); }
};

main()
{
	// Initialize the display (compiler dependent).
#if defined(GFX_DISPLAY) || defined(__SC__) || (defined(DOS16M) && !defined(_MSC_VER))
	UI_DISPLAY *display = new UI_GRAPHICS_DISPLAY;
#elif defined(__BCPLUSPLUS__) | defined(__TCPLUSPLUS__)
	UI_DISPLAY *display = new UI_BGI_DISPLAY;
#elif defined(__ZTC__) 
	UI_DISPLAY *display = new UI_FG_DISPLAY;
#elif defined(_MSC_VER)
	UI_DISPLAY *display = new UI_MSC_DISPLAY;
#elif defined(__WATCOMC__)
	UI_DISPLAY *display = new UI_WCC_DISPLAY;
#endif

	// Exit the program if no graphics capability.
	if (!display->installed)
	{
		delete display;
		printf("ERROR: Initialization of the graphics display failed.\n"
				"The probable cause for this error is that graphics drivers\n"
				"or font files could not be located at run-time.\n");
		return (0);
	}

	// Initialize the event manager.
	UI_EVENT_MANAGER *eventManager = new UI_EVENT_MANAGER(display);
	*eventManager
		+ new UID_KEYBOARD;
	
	// Set up a region that is 15 pixiels from each side.
	UI_REGION edge;
	edge.top = 1;
	edge.left = 2;
	edge.right = display->columns - 2;
	edge.bottom = display->lines - 1;

	// Set up the starting positions and increments.
	UI_REGION current;
	current.left = display->columns / 2 - display->cellWidth;
	current.right = display->columns / 2 + display->cellWidth;
	current.top = current.bottom = display->lines / 2;
	int xIncrement = display->cellWidth;
	int yIncrement = display->cellHeight;

	// Set up a region for the bar graph.
	UI_REGION graph;
	graph.left = display->columns / 2 - 7 * display->cellWidth;
	graph.right = display->columns / 2 + 7 * display->cellWidth;
	graph.top = 2 * display->cellHeight;
	graph.bottom = 9 * display->cellHeight;

	// Define the region so that other calls will not overwrite this region.
	display->RegionDefine(-2, graph);  // Screen ID is negative for user defined regions.

	// Display the bar graph.
	UI_REGION bar;
	bar.bottom = 7 * display->cellHeight;
	int count = 0;
	for (int i = graph.left + display->cellWidth; i < graph.right - display->cellWidth; i += 2 * display->cellWidth)
	{
		bar.top = 7 * display->cellHeight - count * display->cellHeight;
		bar.left = i;
		bar.right = i + display->cellWidth - 1;
		display->Rectangle(-2, bar, &barPalette, 1, TRUE);
		++count;
	}

	// Display the graph title.
	ZIL_ICHAR text[] = "1994 Sales";
	int top = 8 * display->cellHeight + 1;
	int left = (display->columns - display->TextWidth(text)) / 2;
	display->Text(-2, left, top, text, &barPalette, -1, TRUE);

	UI_LIST list;
	BOX *line;

	// Wait for user response.
	UI_EVENT event;
	event.type = 0;		// Needed if Q_NO_BLOCK is used.
	do
	{
		// Erase the fifth line.
		if (list.Count() > 4)
		{
			line = (BOX *)list.First();
			list - line;
			line->Erase();
		}
		else
			line = new BOX(display);

		// Increment and draw the line.
		if (current.left - xIncrement < edge.left || current.right +
			xIncrement > edge.right || current.left - xIncrement * 2 > current.right )
			xIncrement = - xIncrement ;
		if (current.top - yIncrement < edge.top || current.bottom +
			yIncrement > edge.bottom || current.top - yIncrement * 2 > current.bottom)
			yIncrement = - yIncrement;
		current.left -= xIncrement;
		current.right += xIncrement;
		current.top -= yIncrement;
		current.bottom += yIncrement;

		line->Move(current);

		list + line;
		line->Draw();

		// Get input from the user.
		eventManager->Get(event, Q_NO_BLOCK | Q_POLL | Q_DESTROY | Q_BEGIN);

	} while (event.type != E_KEY);

	// Clean up.
	delete eventManager;
	delete display;

	return (0);
}
