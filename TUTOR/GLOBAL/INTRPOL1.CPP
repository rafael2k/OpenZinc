// INTRPOL1.CPP (INTERPOL) - Working with locales
// COPYRIGHT (C) 1990-1995.  All Rights Reserved.
// Zinc Software Incorporated.  Pleasant Grove, Utah  USA
// May be freely copied, used and distributed.

#include <ui_win.hpp>
#include "intrpol1.hpp"
#include "ipolwin1.hpp"

// Create static strings used in application.
static ZIL_ICHAR _USLocaleString[] = { 'U','S', 0 };
static ZIL_ICHAR _DELocaleString[] = { 'D','E', 0 };
static ZIL_ICHAR _FRLocaleString[] = { 'F','R', 0 };
static ZIL_ICHAR _amountFieldName[] = { 'A','M','O','U','N','T','_','F','I','E','L','D', 0 };
static ZIL_ICHAR _convertBoxName[] = { 'C','O','N','V','E','R','S','I','O','N','S', 0 };
static ZIL_ICHAR _fileName[] = { 'i','p','o','l','w','i','n','1','.','d','a','t', 0 };
static ZIL_ICHAR _windowName[] = { 'R','E','P','O','R','T','_','W','I','N','D','O','W', 0 };

// Table for exchange rates and to identify locales.
static struct EXCHANGE
{
	int country;
	ZIL_ICHAR *ISOLocaleName;
	ZIL_RBIGNUM exchangeRate;
}_exchange[] =
{
	{ GERMANY,          _DELocaleString,    1.5290 },
	{ UNITED_STATES,    _USLocaleString,    1.0 },
	{ FRANCE,           _FRLocaleString,    5.2370 },
	{ -1, ZIL_NULLP(ZIL_ICHAR), 1.0 }
};

// Call persistent constructor to load window.
REPORT_WINDOW::REPORT_WINDOW(ZIL_ICHAR *name) :
 	UIW_WINDOW(name, UI_WINDOW_OBJECT::defaultStorage)	
{
	// Get pointer to the amount field.
	amountField = Get(_amountFieldName);

	// Get default system locale name.  localeManager is a global library
	// variable that contains all the ZIL_LOCALE objects.
	currentLocaleName = localeManager.defaultName;

	// Locate the entry in the EXCHANGE structure for the default locale.
	int currentLocale = -1;
	for (int i = 0; _exchange[i].ISOLocaleName; ++i)
	{
		if (strcmp(_exchange[i].ISOLocaleName, currentLocaleName) == 0)
			currentLocale = i;
	}

	// If system locale doesn't correspond to one supported by the
	// application, then set the amount field to a default locale.
	if (currentLocale == -1)
	{
		currentLocale = 0;
		currentLocaleName = _exchange[currentLocale].ISOLocaleName;
		ConvertAmount(_exchange[currentLocale].country + LOCALE_FIRST);
	}

	// Set locale combo box to match the current locale setting.
	UI_WINDOW_OBJECT *object, *conversions;
	conversions = Get(_convertBoxName);
	for (conversions->Information(I_GET_FIRST, &object); object; object = object->Next())
	{
		EVENT_TYPE value;
		object->Information(I_GET_VALUE, &value);
		if (value == _exchange[currentLocale].country + LOCALE_FIRST)
		{
			// Add the combo box entry to make it current in the combo box.
			UI_EVENT addEvent;
			addEvent.type = S_ADD_OBJECT;
			addEvent.data = object;
			conversions->Event(addEvent);
		}
	}
}

void REPORT_WINDOW::ConvertAmount(EVENT_TYPE ccode)
{
	int currentLocale, newLocale;
	ZIL_RBIGNUM currentAmount, newAmount;

	// Determine which entries correspond to the current locale and the 
	// locale being switched to.
	for (int i = 0; _exchange[i].ISOLocaleName; ++i)
	{
		if (_exchange[i].country + LOCALE_FIRST == ccode)
			newLocale = i;
		if (strcmp(_exchange[i].ISOLocaleName, currentLocaleName) == 0)
			currentLocale = i;
	}

	// Get the amount field's ZIL_BIGNUM so we can set its value and locale.
	ZIL_BIGNUM *amount;
	amount = (ZIL_BIGNUM *)amountField->Information(I_GET_VALUE, ZIL_NULLP(void));

	// Get the current value.
	amount->Export(&currentAmount);

	// Convert the amount;
	newAmount = currentAmount * _exchange[newLocale].exchangeRate /
		_exchange[currentLocale].exchangeRate;

	// Set the new amount.
	amount->Import(newAmount);

	// Set the new locale.
	amount->SetLocale(_exchange[newLocale].ISOLocaleName);
	currentLocaleName = _exchange[newLocale].ISOLocaleName;

	// Update the amount field on the screen.
	amountField->Information(I_SET_VALUE, amount);
}

EVENT_TYPE REPORT_WINDOW::Event(const UI_EVENT &event)
{
	// Get the logical event.
	EVENT_TYPE ccode = LogicalEvent(event);

	// Check to see if the event is one of ours.
	if (ccode >= LOCALE_FIRST && ccode <= LOCALE_LAST)
		ConvertAmount(ccode);
	// If it's not our event, pass it to the UIW_WINDOW base class.
	else
		ccode = UIW_WINDOW::Event(event);

	return (ccode);
}

int UI_APPLICATION::Main(void)
{
	// The UI_APPLICATION constructor automatically initializes the
	// display, eventManager, and windowManager variables.

	// This line fixes linkers that don't look for main in the .LIBs.
	UI_APPLICATION::LinkMain();

	// Create derived window.
	UI_WINDOW_OBJECT::defaultStorage = new ZIL_STORAGE_READ_ONLY(_fileName);

	// Check to see if the default storage was allocated.
	if (UI_WINDOW_OBJECT::defaultStorage->storageError)
	{
		delete UI_WINDOW_OBJECT::defaultStorage;
		return(-1);
	}

	UIW_WINDOW *window = new REPORT_WINDOW(_windowName);

	// Add window to the window manager.
	*windowManager
		+ window;

	// Process user responses.
	UI_APPLICATION::Control();

	// Clean up.
	delete UI_WINDOW_OBJECT::defaultStorage;

	return (0);
}
