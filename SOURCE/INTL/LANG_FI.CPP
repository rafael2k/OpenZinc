//	Zinc Interface Library - LANG_FI.CPP
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
	// Language definitions for FINNISH (FI).
	static ZIL_ICHAR ZIL_FARDATA isoLanguageName[] = { 'f','i',0 };
#endif

#if defined(ZIL_UTIME_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA DAY_STRINGS[] =
{
// Translator's comment: While the first day of the week is Monday in
// Finland, Zinc uses *DAY_1 as the "Sunday" day of the week when
// calculated from the Julian day.
	{ "", 0xffff, { 0 } },
	{ "sunnuntai",  ZIL_DAY_1, { 0 } },
	{ "maanantai",  ZIL_DAY_2, { 0 } },
	{ "tiistai",    ZIL_DAY_3, { 0 } },
	{ "keskiviikko",        ZIL_DAY_4, { 0 } },
	{ "torstai",    ZIL_DAY_5, { 0 } },
	{ "perjantai",  ZIL_DAY_6, { 0 } },
	{ "lauantai",   ZIL_DAY_7, { 0 } },
	{ "sun",        ZIL_SHDAY_1, { 0 } },
	{ "maa",        ZIL_SHDAY_2, { 0 } },
	{ "tii",        ZIL_SHDAY_3, { 0 } },
	{ "kes",        ZIL_SHDAY_4, { 0 } },
	{ "tor",        ZIL_SHDAY_5, { 0 } },
	{ "per",        ZIL_SHDAY_6, { 0 } },
	{ "lau",        ZIL_SHDAY_7, { 0 } },
	{ "su", ZIL_ABDAY_1, { 0 } },
	{ "ma", ZIL_ABDAY_2, { 0 } },
	{ "ti", ZIL_ABDAY_3, { 0 } },
	{ "ke", ZIL_ABDAY_4, { 0 } },
	{ "to", ZIL_ABDAY_5, { 0 } },
	{ "pe", ZIL_ABDAY_6, { 0 } },
	{ "la", ZIL_ABDAY_7, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA MONTH_STRINGS[] =
{
	{ "", 0xffff, { 0 } },
	{ "tammikuu",   ZIL_MON_1, { 0 }  },
	{ "helmikuu",   ZIL_MON_2, { 0 }  },
	{ "maaliskuu",  ZIL_MON_3, { 0 }  },
	{ "huhtikuu",   ZIL_MON_4, { 0 }  },
	{ "toukokuu",   ZIL_MON_5, { 0 }  },
	{ "kesäkuu",    ZIL_MON_6, { 0 }  },
	{ "heinäkuu",   ZIL_MON_7, { 0 }  },
	{ "elokuu",     ZIL_MON_8, { 0 }  },
	{ "syyskuu",    ZIL_MON_9, { 0 }  },
	{ "lokakuu",    ZIL_MON_10, { 0 } },
	{ "marraskuu",  ZIL_MON_11, { 0 } },
	{ "joulukuu",   ZIL_MON_12, { 0 } },
	{ "tam",        ZIL_SHMON_1, { 0 }  },
	{ "hel",        ZIL_SHMON_2, { 0 }  },
	{ "maa",        ZIL_SHMON_3, { 0 }  },
	{ "huh",        ZIL_SHMON_4, { 0 }  },
	{ "tou",        ZIL_SHMON_5, { 0 }  },
	{ "kes",        ZIL_SHMON_6, { 0 }  },
	{ "hei",        ZIL_SHMON_7, { 0 }  },
	{ "elo",        ZIL_SHMON_8, { 0 }  },
	{ "syy",        ZIL_SHMON_9, { 0 }  },
	{ "lok",        ZIL_SHMON_10, { 0 } },
	{ "mar",        ZIL_SHMON_11, { 0 } },
	{ "jou",        ZIL_SHMON_12, { 0 } },
	{ "tammi",      ZIL_ABMON_1, { 0 }  },
	{ "helmi",      ZIL_ABMON_2, { 0 }  },
	{ "maalis",     ZIL_ABMON_3, { 0 }  },
	{ "huhti",      ZIL_ABMON_4, { 0 }  },
	{ "touko",      ZIL_ABMON_5, { 0 }  },
	{ "kesä",       ZIL_ABMON_6, { 0 }  },
	{ "heinä",      ZIL_ABMON_7, { 0 }  },
	{ "elo",        ZIL_ABMON_8, { 0 }  },
	{ "syys",       ZIL_ABMON_9, { 0 }  },
	{ "loka",       ZIL_ABMON_10, { 0 } },
	{ "marras",     ZIL_ABMON_11, { 0 } },
	{ "joulu",      ZIL_ABMON_12, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA TIME_STRINGS[] =
{
	{ "", 0xffff, { 0 } },
	{ "ap.", ZIL_AM, { 0 } },
	{ "ip.", ZIL_PM, { 0 } },
	{ "xxxx", ZIL_TZ, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_UIW_BIGNUM_DATA) || defined(ZIL_UIW_INT_DATA) || defined(ZIL_UIW_REAL_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "Numero %s on virheellinen.", NMI_INVALID, { 0 } },
	{ "Numero %s ei ole alueella %s.", NMI_OUT_OF_RANGE, { 0 } },
	{ "Numero %s on pienempi kuin %s.", NMI_LESS_THAN_RANGE, { 0 } },
	{ "Numero %s on suurempi %s.", NMI_GREATER_THAN_RANGE, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_UIW_DATE_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "Päiväys %s on väärän tyyppinen.", DTI_INVALID, { 0 } },
	{ "Päiväyksellä %s on epäselvä kuukauden nimi.", DTI_AMBIGUOUS, { 0 } },
	{ "Päiväyksellä %s on väärä kuukauden nimi.", DTI_INVALID_NAME, { 0 } },
	{ "Päiväys täytyy syöttää.", DTI_VALUE_MISSING, { 0 } },
	{ "Päiväys %s ei ole alueella %s.", DTI_OUT_OF_RANGE, { 0 } },
	{ "Päiväys %s on aikaisemmin kuin %s.", DTI_LESS_THAN_RANGE, { 0 } },
	{ "Päiväys %s on myöhemmin kuin %s.", DTI_GREATER_THAN_RANGE, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif
		
#if defined(ZIL_UIW_TIME_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "Aika %s on väärän tyyppinen.", TMI_INVALID, { 0 } },
	{ "Aika täytyy syöttää.", TMI_VALUE_MISSING, { 0 } },
	{ "Aika %s ei ole alueella %s.", TMI_OUT_OF_RANGE, { 0 } },
	{ "Aika %s on aikaisemmin kuin %s.", TMI_LESS_THAN_RANGE, { 0 } },
	{ "Aika %s on myöhemmin kuin %s.", TMI_GREATER_THAN_RANGE, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_UI_ERROR_SYSTEM_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "Virhe", MSG_TITLE, { 0 } },
	{ "&OK", MSG_OK, { 0 } },
	{ "&Peruuta", MSG_CANCEL, { 0 } },
	{ "ASTERISK", MSG_ICONNAME, { 0 } },
	{ "Sii&rrä", MSG_MOVE, { 0 } },
	{ "&Sulje\tAlt+F4", MSG_CLOSE, { 0 } },
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
	{ "Ohjetietoja", MSG_ICONTITLE, { 0 } },
	{ "QUESTION", MSG_ICONNAME, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_UIW_SYSTEM_BUTTON_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "&Palauta", MNIF_RESTORE, { 0 } },       // S_RESTORE
	{ "Sii&rrä", MNIF_MOVE, { 0 } },           // S_MOVE
	{ "&Muuta kokoa", MNIF_SIZE, { 0 } },      // S_SIZE
	{ "P&ienennä", MNIF_MINIMIZE, { 0 } },     // S_MINIMIZE
	{ "S&uurenna", MNIF_MAXIMIZE, { 0 } },     // S_MAXIMIZE
	{ "", MNIF_SEPARATOR, { 0 } },
	{ "&Sulje", MNIF_CLOSE, { 0 } },           // S_CLOSE
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_UIW_WINDOW_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "Virhe", 0xffff, { 0 } },
	{ "Tuntematon ikkunaolio.", ZIL_UNK_OBJ, { 0 } },
	{ "Olio %s ei löytynyt.", ZIL_NO_OBJ, { 0 } },
	{ "Tiedosto %s ei löytynyt.", ZIL_NO_FILE, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_ZAF_MESSAGE_WINDOW_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "&OK", ZIL_MSG_OK, { 0 }},
	{ "&Kyllä", ZIL_MSG_YES, { 0 } },
	{ "&Ei", ZIL_MSG_NO, { 0 } },
	{ "&Hylkää", ZIL_MSG_ABORT, { 0 } },
	{ "&Uudelleen", ZIL_MSG_RETRY, { 0 } },
	{ "&Ohita", ZIL_MSG_IGNORE, { 0 } },
	{ "&Peruuta", ZIL_MSG_CANCEL, { 0 } },
	{ "Oh&je", ZIL_MSG_HELP, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif
