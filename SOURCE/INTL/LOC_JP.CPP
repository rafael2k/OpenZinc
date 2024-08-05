//	Zinc Interface Library - LOC_JP.CPP
//	COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasant Grove, Utah  USA

/*       This file is a part of OpenZinc

          OpenZinc is free software; you can redistribute it and/or modify it under
          the terms of the GNU Lessor General Public License as published by
          the Free Software Foundation, either version 3 of the License, or (at
          your option) any later version

	OpenZinc is distributed in the hope that it will be useful, but WITHOUT
          ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
          or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser 
          General Public License for more details.

          You should have received a copy of the GNU Lessor General Public License
	 along with OpenZinc. If not, see <http://www.gnu.org/licenses/>                          */


#define locCodeset	CP_UNICODE

// Locale definitions for JAPAN (JP).
static ZIL_ICHAR ZIL_FARDATA _defaultIsoLocaleName[] = { 'J', 'P', 0 };

#if defined(ZIL_UNICODE)
static ZIL_ICHAR ZIL_FARDATA _defaultBnumLeftParen[] = { 0xff08, 0 };
static ZIL_ICHAR ZIL_FARDATA _defaultBnumRightParen[] = { 0xff09, 0 };
#else
static ZIL_ICHAR ZIL_FARDATA _defaultBnumLeftParen[] = { '(', 0 };
static ZIL_ICHAR ZIL_FARDATA _defaultBnumRightParen[] = { ')', 0 };
#endif
static ZIL_ICHAR ZIL_FARDATA _defaultTimeStringFormat[] = { '%', 'H', ':', '%', 'M', ':', '%', 'S', 0 };
static ZIL_ICHAR ZIL_FARDATA _defaultDateStringFormat[] = { '%', 'Y', '-', '%', 'm', '-', '%', 'd', 0 };
static ZIL_ICHAR ZIL_FARDATA _defaultDateTimeStringFormat[] = { '%', 'Y', '-', '%', 'm', '-', '%', 'd', ' ', '%', 'H', ':', '%', 'M', ':', '%', 'S', 0 };
static ZIL_ICHAR ZIL_FARDATA _defaultDefDigits[] = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 0, 0, 0, 0, 0, 0, 0, 0, 0 };
static ZIL_ERA_TABLE ZIL_FARDATA eraTable[] =
{
	{ 1, 2, 2447893L, 0xffffffffL, { 0x5e73, 0x6210, 0 }, { '%','E','C','%','E','y', 0x5e74, 0 } },	// Heisei [] nen
	{ 1, 1, 2447535L, 2447892L, { 0x5e73, 0x6210, 0 }, { '%','E','C', 0x5143, 0x5e74, 0 } },	// Heisei gannen
	{ 1, 2, 2424882L, 2447534L, { 0x662D, 0x5442, 0 }, { '%','E','C','%','E','y', 0x5e74, 0 } },	// Shouwa [] nen
	{ 1, 1, 2424875L, 2424881L, { 0x662D, 0x5442, 0 }, { '%','E','C', 0x5143, 0x5e74, 0 } },	// Shouwa gannen
	{ 1, 2, 2419769L, 2424874L, { 0x5927, 0x6b63, 0 }, { '%','E','C','%','E','y', 0x5e74, 0 } },	// Taishou [] nen
	{ 1, 1, 2419614L, 2419768L, { 0x5927, 0x6b63, 0 }, { '%','E','C', 0x5143, 0x5e74, 0 } },		// Taishou gannen
	{ 1, 2, 2403699L, 2419613L, { 0x660e, 0x6cbb, 0 }, { '%','E','C','%','E','y', 0x5e74, 0 } },	// Meiji [] nen
	{ 1, 1, 2403584L, 2403698L, { 0x660e, 0x6cbb, 0 }, { '%','E','C', 0x5143, 0x5e74, 0 } },		// Meiji [] gannen
	{ 1, 1, 1721424L, 2403583L, { 0x897f, 0x66a6, 0 }, { '%','E','C','%','E','y', 0x5e74, 0 } },	// CE [] nen
	{ 0, 4713, 0L, 1721423L, { 0x7D00, 0x5143, 0x524d, 0 }, { '%','E','C','%','E','y', 0x5e74, 0 } },	// BCE [] nen
};
static ZIL_LOCALE_ELEMENT ZIL_FARDATA _defaultLocaleElement = 
{
	{ '.', 0 },	// decimalSeparator
	{ 0 },	// monDecimalSeparator
	{ ',', 0 },	// thousandsSeparator
	{ ',', 0 },	// monthousandsSeparator
	{ 0xa5, 0 },	// CurrencySymbol
	{ 3, 0 },	// grouping
	{ 3, 0 },	// monGrouping
	{ 'J','P','Y',' ',0 },	// IntCurrencySymbol
	1,		// posCurrencyPrecedes
	1,		// negCurrencyPrecedes
	0,		// fractionDigits
	0,		// intFractionDigits
	{ 0 },		// positiveSign
	1,		// posSignPreceides
	0,		// posSpaceSeparation
	{ '-', 0 },	// negativeSign
	1,		// negSignPreceides
	0,		// negSpaceSeparation
	_defaultBnumLeftParen,
	_defaultBnumRightParen,
	_defaultTimeStringFormat,
	_defaultDateStringFormat,
	_defaultDateTimeStringFormat,
	_defaultTimeStringFormat,
	_defaultDefDigits,
	_defaultDefDigits,
	{ ':', 0 },
	{ '-', 0 },
	DTF_ASIAN_FORMAT,
	TMF_TWENTY_FOUR_HOUR,
	2299160L,	// Oct 4, 1582
	11,		// to 2299171L	Oct 15, 1582
	LENGTHOF(eraTable),
	eraTable
};

#if defined(ZIL_MSDOS) || defined(ZIL_MSWINDOWS) || defined(ZIL_OS2) || defined(ZIL_CURSES)
int ZIL_LOCALE::oemCountryCode = 81;
#elif defined(ZIL_MACINTOSH)
int ZIL_LOCALE::oemCountryCode = 14;
#endif
