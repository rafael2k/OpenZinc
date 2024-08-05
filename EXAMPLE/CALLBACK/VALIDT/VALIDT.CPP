//	VALIDATE.CPP (VALIDATE) - Validate example program.
//	COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//  May be freely copied, used and distributed.

#include "validt.hpp"

// Constructor.
VALIDATE::VALIDATE(int left, int top, int helpContext) :
	UIW_WINDOW(left, top, 40, 12, WOF_NO_FLAGS, WOAF_NO_FLAGS, helpContext)
{
	//  Initialize the value for the UIW_NUMERIC fields.
	ZIL_BIGNUM value;

	*this
		+ new UIW_BORDER
		+ new UIW_MAXIMIZE_BUTTON
		+ new UIW_MINIMIZE_BUTTON
		+ UIW_SYSTEM_BUTTON::Generic()
		+ new UIW_TITLE("Validate Numeric Function")
		+ new UIW_PROMPT(3, 0, "Accepted Input Range is 0 - 999", WOF_NO_FLAGS)
		+ new UIW_PROMPT(3, 2, "Input A", WOF_NO_FLAGS)
		+ (inputA = new UIW_BIGNUM(13, 2, 10, &value, "0..999",
			NMF_DECIMAL(0), WOF_AUTO_CLEAR | WOF_BORDER, VALIDATE::CallCompute))
		+ new UIW_PROMPT(25, 2, "Range Edit", WOF_NO_FLAGS)
		+ new UIW_PROMPT(6, 3, "+", WOF_NO_FLAGS)
		+ new UIW_PROMPT(3, 4, "Input B", WOF_NO_FLAGS)
		+ (inputB = new UIW_BIGNUM(13, 4, 10, &value, ZIL_NULLP(ZIL_ICHAR),
			NMF_DECIMAL(0), WOF_AUTO_CLEAR | WOF_BORDER, VALIDATE::Validation))
		+ new UIW_PROMPT(25, 4, "Val. Function", WOF_NO_FLAGS)
	 	+ new UIW_PROMPT(6, 5, "+", WOF_NO_FLAGS)
		+ new UIW_PROMPT(3, 6, "Input C", WOF_NO_FLAGS)
		+ (inputC = new UIW_BIGNUM(13, 6, 10, &value, ZIL_NULLP(ZIL_ICHAR),
			NMF_DECIMAL(0), WOF_AUTO_CLEAR | WOF_BORDER, VALIDATE::Validation))
		+ new UIW_PROMPT(25, 6, "Val. Function", WOF_NO_FLAGS)
		+ new UIW_PROMPT(6, 7, "=", WOF_NO_FLAGS)
		+ new UIW_PROMPT(13, 7, "__________", WOF_NO_FLAGS)
		+ new UIW_PROMPT(3, 8, "Input D", WOF_NO_FLAGS)
		+ (totalField = new UIW_BIGNUM(13, 8, 10, &value, ZIL_NULLP(ZIL_ICHAR),
			NMF_DECIMAL(0), WOF_BORDER | WOF_VIEW_ONLY));

		totalField->woAdvancedFlags |= WOAF_NON_CURRENT;
}

EVENT_TYPE VALIDATE::CallCompute(UI_WINDOW_OBJECT *object, UI_EVENT &,
	EVENT_TYPE ccode)
{
	if (ccode == S_CURRENT)
		return (0);

	// Validate with the range passed into the constructor.
	if (((UIW_BIGNUM *)object)->Validate(TRUE) == 0)
		((VALIDATE *)object->parent)->ComputeTotal();
	else
		return (-1);

	return (0);
}

void VALIDATE::ComputeTotal(void)
{
	ZIL_BIGNUM *bignum;
    ZIL_IBIGNUM totalValue = 0, value;						   	
	bignum = inputA->DataGet();
	bignum->Export(&value);
	totalValue += value;

	bignum = inputB->DataGet(); 
	bignum->Export(&value);
	totalValue += value;

	bignum = inputC->DataGet();
	bignum->Export(&value);
	totalValue += value;

	bignum = totalField->DataGet();
	bignum->Import(totalValue);
	totalField->DataSet(bignum);
}

//	Note that MemberValidate is the desired processing validate function 
//	called by the dummy function Validation.	The dummy validate function is
//  used to satisfy C++ code requirements. (For explanation, see comments 
//	preceeding the function Validation.)
EVENT_TYPE VALIDATE::MemberValidate(UI_WINDOW_OBJECT *object, UI_EVENT &, 
   EVENT_TYPE ccode)
{
	if (ccode == S_CURRENT)
		return (0);

	// Make sure the value entered is not outside the absolute range of ZIL_BIGNUM.
	if (object->Validate(FALSE) == NMI_OUT_OF_RANGE)
	{
		errorSystem->ReportError(totalField->windowManager, "Validate Error",
			WOS_NO_STATUS, "The value entered is too large. "
			"It must be in the range 0 through 999. "
			"This error window is created in the validate function.");
		return (S_ERROR);
	}

	ZIL_BIGNUM *bignum = ((UIW_BIGNUM *)object)->DataGet();
	ZIL_IBIGNUM value;
	bignum->Export(&value);
		
	//  All fields are edited in this range test.  However, if a range
	//  test in UIW_BIGNUM failed, the error system would have
	//  been called without this member function being called.
	if (value >=  0 && value <= 999)
	{
		ComputeTotal();
		return (0);
	}
	else
	{
		errorSystem->ReportError(totalField->windowManager, "Validate Error",
			WOS_NO_STATUS, "%d is not valid. "
			"The value must be in the range 0 through 999. "
			"This error window is created in the validate function.", value);

		value = 0;
		bignum->Import(value);
		((UIW_BIGNUM *)object)->DataSet(bignum);
		return (S_ERROR);
	}
}

int UI_APPLICATION::Main(void)
{
	// The UI_APPLICATION constructor automatically initializes the 
	// display, eventManager, and windowManager variables.

	// This line fixes linkers that don't look for main in the .LIBs.
	UI_APPLICATION::LinkMain();

	// Add validate window to the window manager.
	*windowManager
		+ new VALIDATE(0, 0, NO_HELP_CONTEXT);

	// Initialize the error window system.
	UI_WINDOW_OBJECT::errorSystem = new UI_ERROR_SYSTEM;
	
	// Process user responses.
	UI_APPLICATION::Control();

	// Clean up.
	delete UI_WINDOW_OBJECT::errorSystem;

	return (0);
}
