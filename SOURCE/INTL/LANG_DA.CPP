//	Zinc Interface Library - LANG_DA.CPP
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


// In error statements, the %1%s is the data, the %2%s is the range.
// NOTE: '&' is the hotkey specifier.

#if defined(ZIL_LANGUAGE_DATA)
#	define langCodeset	CP_ISO8859_1
	// Language definitions for Danish (DA).
	static ZIL_ICHAR ZIL_FARDATA isoLanguageName[] = { 'd','a',0 };
#endif

#if defined(ZIL_UTIME_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA DAY_STRINGS[] =
{
	{ "", 0xffff, { 0 } },
	{ "s\370ndag",	ZIL_DAY_1, { 0 } },
	{ "mandag",	ZIL_DAY_2, { 0 } },
	{ "tirsdag",	ZIL_DAY_3, { 0 } },
	{ "onsdag",	ZIL_DAY_4, { 0 } },
	{ "torsdag",	ZIL_DAY_5, { 0 } },
	{ "fredag",	ZIL_DAY_6, { 0 } },
	{ "l\370rdag",	ZIL_DAY_7, { 0 } },
	{ "s\370n",	ZIL_SHDAY_1, { 0 } },
	{ "man",	ZIL_SHDAY_2, { 0 } },
	{ "tir",	ZIL_SHDAY_3, { 0 } },
	{ "ons",	ZIL_SHDAY_4, { 0 } },
	{ "tor",	ZIL_SHDAY_5, { 0 } },
	{ "fre",	ZIL_SHDAY_6, { 0 } },
	{ "l\370r",	ZIL_SHDAY_7, { 0 } },
	{ "s\370n.",	ZIL_ABDAY_1, { 0 } },
	{ "man.",	ZIL_ABDAY_2, { 0 } },
	{ "tir.",	ZIL_ABDAY_3, { 0 } },
	{ "ons.",	ZIL_ABDAY_4, { 0 } },
	{ "tor.",	ZIL_ABDAY_5, { 0 } },
	{ "fre.",	ZIL_ABDAY_6, { 0 } },
	{ "l\370r.",	ZIL_ABDAY_7, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA MONTH_STRINGS[] =
{
	{ "", 0xffff, { 0 } },
	{ "januar",	ZIL_MON_1, { 0 }  },
	{ "februar",	ZIL_MON_2, { 0 }  },
	{ "marts",	ZIL_MON_3, { 0 }  },
	{ "april",	ZIL_MON_4, { 0 }  },
	{ "maj",	ZIL_MON_5, { 0 }  },
	{ "juni",	ZIL_MON_6, { 0 }  },
	{ "juli",	ZIL_MON_7, { 0 }  },
	{ "august",	ZIL_MON_8, { 0 }  },
	{ "september",	ZIL_MON_9, { 0 }  },
	{ "oktober",	ZIL_MON_10, { 0 } },
	{ "november",	ZIL_MON_11, { 0 } },
	{ "december",	ZIL_MON_12, { 0 } },
	{ "jan",	ZIL_SHMON_1, { 0 }  },
	{ "feb",	ZIL_SHMON_2, { 0 }  },
	{ "mar",	ZIL_SHMON_3, { 0 }  },
	{ "apr",	ZIL_SHMON_4, { 0 }  },
	{ "maj",	ZIL_SHMON_5, { 0 }  },
	{ "jun",	ZIL_SHMON_6, { 0 }  },
	{ "jul",	ZIL_SHMON_7, { 0 }  },
	{ "aug",	ZIL_SHMON_8, { 0 }  },
	{ "sep",	ZIL_SHMON_9, { 0 }  },
	{ "okt",	ZIL_SHMON_10, { 0 } },
	{ "nov",	ZIL_SHMON_11, { 0 } },
	{ "dec",	ZIL_SHMON_12, { 0 } },
	{ "jan.",	ZIL_ABMON_1, { 0 }  },
	{ "feb.",	ZIL_ABMON_2, { 0 }  },
	{ "mar.",	ZIL_ABMON_3, { 0 }  },
	{ "apr.",	ZIL_ABMON_4, { 0 }  },
	{ "maj",	ZIL_ABMON_5, { 0 }  },
	{ "jun.",	ZIL_ABMON_6, { 0 }  },
	{ "jul.",	ZIL_ABMON_7, { 0 }  },
	{ "aug.",	ZIL_ABMON_8, { 0 }  },
	{ "sep.",	ZIL_ABMON_9, { 0 }  },
	{ "okt.",	ZIL_ABMON_10, { 0 } },
	{ "nov.",	ZIL_ABMON_11, { 0 } },
	{ "dec.",	ZIL_ABMON_12, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA TIME_STRINGS[] =
{
	{ "", 0xffff, { 0 } },
	{ "a.m.", ZIL_AM, { 0 } },
	{ "p.m.", ZIL_PM, { 0 } },
	{ "xxxx", ZIL_TZ, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_UIW_BIGNUM_DATA) || defined(ZIL_UIW_INT_DATA) || defined(ZIL_UIW_REAL_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "Tallet %s er ugyldigt.", NMI_INVALID, { 0 } },
	{ "Tallet %s er ikke indenfor det tilladte interval: %s.", NMI_OUT_OF_RANGE, { 0 } },
//	{ "The number %s is less than %s.", NMI_LESS_THAN_RANGE, { 0 } },
//	{ "The number %s is greater than %s.", NMI_GREATER_THAN_RANGE, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_UIW_DATE_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "Datoen %s har et ugyldigt format.", DTI_INVALID, { 0 } },
	{ "Datoen %s har et flertydigt m\345nedsnavn.", DTI_AMBIGUOUS, { 0 } },
	{ "Datoen %s har et ugyldigt m\345nedsnavn.", DTI_INVALID_NAME, { 0 } },
	{ "Dato skal indtastes.", DTI_VALUE_MISSING, { 0 } },
	{ "Datoen %s er ikke indenfor det tilladte interval: %s.", DTI_OUT_OF_RANGE, { 0 } },
//	{ "The date %s is before %s.", DTI_LESS_THAN_RANGE, { 0 } },
//	{ "The date %s is after %s.", DTI_GREATER_THAN_RANGE, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_UIW_TIME_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "Tidspunktet %s har et ugyldigt format.", TMI_INVALID, { 0 } },
	{ "Et tidspunkt skal indtastes.", TMI_VALUE_MISSING, { 0 } },
	{ "Tidspunktet %s er ikke indenfor det tilladte interval: %s.", TMI_OUT_OF_RANGE, { 0 } },
//	{ "The time %s is before %s.", TMI_LESS_THAN_RANGE, { 0 } },
//	{ "The time %s is after %s.", TMI_GREATER_THAN_RANGE, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_UI_ERROR_SYSTEM_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "Fejl", MSG_TITLE, { 0 } },
	{ "&OK", MSG_OK, { 0 } },
	{ "&Fortryd", MSG_CANCEL, { 0 } },
	{ "ASTERISK", MSG_ICONNAME, { 0 } },
	{ "&Flyt", MSG_MOVE, { 0 } },
	{ "&Luk\tAlt+F4", MSG_CLOSE, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_UI_HELP_SYSTEM_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "Help Topic", MSG_HELP_TOPIC, { 0 } },
	{ "Help Index", MSG_HELP_INDEX, { 0 } },
	{ "Show Topic", MSG_SHOW_TOPIC, { 0 } },
	{ "Show Index", MSG_SHOW_INDEX, { 0 } },
	{ "Select A Topic", MSG_MESSAGE1, { 0 } },
	{ "Type a word, or select one from the list.", MSG_MESSAGE2, { 0 } },
	{ "Close", MSG_CLOSE, { 0 } },
	{ "Hj\346lp.", MSG_ICONTITLE, { 0 } },
	{ "QUESTION", MSG_ICONNAME, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_UIW_SYSTEM_BUTTON_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "&Gendan", MNIF_RESTORE, { 0 } },	// S_RESTORE
	{ "&Flyt", MNIF_MOVE, { 0 } },		// S_MOVE
	{ "Tilpas &st\370rrelse", MNIF_SIZE, { 0 } },		// S_SIZE
	{ "Mi&nimer", MNIF_MINIMIZE, { 0 } },	// S_MINIMIZE
	{ "Ma&ksimer", MNIF_MAXIMIZE, { 0 } },	// S_MAXIMIZE
	{ "", MNIF_SEPARATOR, { 0 } },
	{ "&Luk", MNIF_CLOSE, { 0 } },	// S_CLOSE
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_UIW_WINDOW_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "ERROR", 0xffff, { 0 } },
	{ "Ukendt vindues-objekt.", ZIL_UNK_OBJ, { 0 } },
	{ "Objektet %s findes ikke.", ZIL_NO_OBJ, { 0 } },
	{ "Filen %s findes ikke.", ZIL_NO_FILE, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_ZAF_MESSAGE_WINDOW_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "&OK", ZIL_MSG_OK, { 0 }},
	{ "&Yes", ZIL_MSG_YES, { 0 } },
	{ "&No", ZIL_MSG_NO, { 0 } },
	{ "&Abort", ZIL_MSG_ABORT, { 0 } },
	{ "&Retry", ZIL_MSG_RETRY, { 0 } },
	{ "&Ignore", ZIL_MSG_IGNORE, { 0 } },
	{ "&Cancel", ZIL_MSG_CANCEL, { 0 } },
	{ "&Help", ZIL_MSG_HELP, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif
