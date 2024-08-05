#include <ui_win.hpp>
#include "main.hpp"
#include "p_main.hpp"

const	ZIL_ICHAR _resourceFile[] = "p_main.dat";


VIEW_WIN::VIEW_WIN(void) : UIW_WINDOW("VIEW_WINDOW", defaultStorage)
{
   i1 = new UIW_IMAGE(2, 2, 40, 10, "strange",
							-1, IMF_AUTO_SIZE, WOF_BORDER);

   i2 = new UIW_IMAGE(2, 2, 40, 10, "strange1",
							-1, IMF_NO_FLAGS, WOF_BORDER);

   imageNumber = 1;
   
};


VIEW_WIN::~VIEW_WIN(void)
{
   if (imageNumber == 1)
      delete i2;
   else
      delete i1;
   
};


EVENT_TYPE VIEW_WIN::Event(const UI_EVENT &event)
{
	EVENT_TYPE ccode = event.type;
	switch (ccode)
	{
	case U_LEFT_ARROW:
	case U_RIGHT_ARROW:
	{
		UI_WINDOW_OBJECT *firstObject = First();
		if (firstObject->SearchID() == ID_IMAGE)
		{
			*this - firstObject;
			firstObject = First();	// get the new first object
		}
		if (imageNumber == 1)
		{
			this->UI_LIST::Add(firstObject, i2); // Add the image before the first object.
			i2->parent = this;
			i2->Event((UI_EVENT)S_INITIALIZE);
			i2->Event((UI_EVENT)S_CREATE);
			imageNumber = 2;
		}
		else
		{
			this->UI_LIST::Add(firstObject, i1); // Add the image before the first object.
			i1->parent = this;
			i1->Event((UI_EVENT)S_INITIALIZE);
			i1->Event((UI_EVENT)S_CREATE);
			imageNumber = 1;
		}

      // redisplay the window after the change
      Event(S_CHANGED);
		Event(S_REDISPLAY);

		break;
	}

	default:
	{
		// Let the base window process all other events.
		ccode = UIW_WINDOW::Event(event);
		break;
	}

	} // end of switch

	return (ccode);
}


/*--------------------------------------------------------------------*/
int UI_APPLICATION::Main(void)
{
	// The UI_APPLICATION constructor automatically initializes the
	// display, eventManager, and windowManager variables.

	// This line fixes linkers that don't look for main in the .LIBs.
	UI_APPLICATION::LinkMain();

	// Initialize the default storage.
	UI_WINDOW_OBJECT::defaultStorage = new ZIL_STORAGE_READ_ONLY(_resourceFile);
	if (!UI_WINDOW_OBJECT::defaultStorage)
		return (0);	// Exit the program.

	UIW_WINDOW *vwin = new VIEW_WIN();
	*windowManager + vwin;
	vwin->Event(UI_EVENT(U_LEFT_ARROW));

	// Wait for user response.
	Control();

	// Clean up.
	delete UI_WINDOW_OBJECT::defaultStorage;

	return (0);
}


