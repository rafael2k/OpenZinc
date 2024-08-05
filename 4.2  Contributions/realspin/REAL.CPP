#include <ui_win.hpp>
#include "real.hpp"

#define MAX_LENGTH	64

SPINNER_REAL::SPINNER_REAL(int left, int top, int width, double *value, double *delta,
	const ZIL_ICHAR *range, NMF_FLAGS nmFlags, WOF_FLAGS woFlags,
 	ZIL_USER_FUNCTION userFunction) :
		UIW_REAL(left, top, width, value, range, nmFlags, woFlags, userFunction)
{
	realDelta = *delta;
}

void *SPINNER_REAL::Information(ZIL_INFO_REQUEST request, void *data, ZIL_OBJECTID objectID)
{
	// Switch on the request.
	switch (request)
	{
	case I_DECREMENT_VALUE:
		// Decrement the integer value.
		ValueDecrement(realDelta);
		break;

	case I_INCREMENT_VALUE:
		// Increment the integer value.
		ValueIncrement(realDelta);
		break;

		break;

	default:
		data = UIW_REAL::Information(request, data, objectID);
		break;
	}

	// Return the information.
	return (data);
}

void SPINNER_REAL::ValueDecrement(double delta)
{
	// Decrement the real value.
	ZIL_ICHAR *stringNumber = (ZIL_ICHAR *)UIW_REAL::Information(I_GET_TEXT, ZIL_NULLP(void));
	double tNumber = atof(stringNumber);
	double originalNum = tNumber;
	tNumber -= delta;
	Format(stringNumber, tNumber, nmFlags);
	UIW_REAL::Information(I_SET_TEXT, stringNumber);
	if (Validate(FALSE) == NMI_OK)
		*number = tNumber;
	else
	{
		double nextRangeMax, max;
		int wrap = TRUE;

		ZIL_ICHAR *tRange = range;
		ZIL_ICHAR minNumber[MAX_LENGTH], maxNumber[MAX_LENGTH];
		tRange = ParseRange(tRange, minNumber, maxNumber);
		double rangeMax = atof(maxNumber);

		nextRangeMax = max = rangeMax;

		while (tRange)
		{
			tRange = ParseRange(tRange, minNumber, maxNumber);
			rangeMax = atof(maxNumber);

			if (!maxNumber[0])
				wrap = FALSE;
			else
			{
				// Find the largest allowed value.
				if (rangeMax > max)
					max = rangeMax;

				// Find the maximum value less than the current value.
				if (rangeMax > nextRangeMax && rangeMax < originalNum)
					nextRangeMax = rangeMax;
				else if (nextRangeMax > originalNum && rangeMax < nextRangeMax)
					nextRangeMax = rangeMax;
			}
		}

		// If can go lower, then do so.
		if (nextRangeMax < originalNum)
			*number = nextRangeMax;
		// Otherwise, we are off the bottom of the ranges and need to wrap.
		else if (wrap && parent && parent->Inherited(ID_SPIN_CONTROL))
		{
			WNF_FLAGS wnFlags;
			parent->Information(I_GET_FLAGS, &wnFlags, ID_WINDOW);
			if (!FlagSet(wnFlags, WNF_NO_WRAP))
				*number = max;
		}

		Format(stringNumber, *number, nmFlags);
		UIW_REAL::Information(I_SET_TEXT, stringNumber);
	}
}

void SPINNER_REAL::ValueIncrement(double delta)
{
	// Increment the integer value.
	ZIL_ICHAR *stringNumber = (ZIL_ICHAR *)UIW_REAL::Information(I_GET_TEXT, ZIL_NULLP(void));
	double tNumber = atof(stringNumber);
	double originalNum = tNumber;
	tNumber += delta;
	Format(stringNumber, tNumber, nmFlags);
	UIW_REAL::Information(I_SET_TEXT, stringNumber);
	if (Validate(FALSE) == NMI_OK)
		*number = tNumber;
	else
	{
		double nextRangeMin, min;
		int wrap = TRUE;

		ZIL_ICHAR *tRange = range;
		ZIL_ICHAR minNumber[MAX_LENGTH], maxNumber[MAX_LENGTH];
		tRange = ParseRange(tRange, minNumber, maxNumber);
		double rangeMin = atof(minNumber);

		nextRangeMin = min = rangeMin;

		while (tRange)
		{
			tRange = ParseRange(tRange, minNumber, maxNumber);
			rangeMin = atof(minNumber);

			if (!minNumber[0])
				wrap = FALSE;
			else
			{
				// Find the smallest allowed value.
				if (rangeMin < min)
					min = rangeMin;

				// Find the minimum value greater than the current value.
				if (rangeMin < nextRangeMin && rangeMin > originalNum)
					nextRangeMin = rangeMin;
				else if (nextRangeMin < originalNum && rangeMin > nextRangeMin)
					nextRangeMin = rangeMin;
			}
		}

		// If can go higher, then do so.
		if (nextRangeMin > originalNum)
			*number = nextRangeMin;
		// Otherwise, we are off the top of the ranges and need to wrap.
		else if (wrap && parent && parent->Inherited(ID_SPIN_CONTROL))
		{
			WNF_FLAGS wnFlags;
			parent->Information(I_GET_FLAGS, &wnFlags, ID_WINDOW);
			if (!FlagSet(wnFlags, WNF_NO_WRAP))
				*number = min;
		}

		Format(stringNumber, *number, nmFlags);
		UIW_REAL::Information(I_SET_TEXT, stringNumber);
	}
}
