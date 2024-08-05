//	Zinc Interface Library - LANG_NL.CPP
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
	// Language definitions for DUTCH (NL).
	static ZIL_ICHAR ZIL_FARDATA isoLanguageName[] = { 'n','l',0 };
#endif

#if defined(ZIL_UTIME_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA DAY_STRINGS[] =
{
	{ "", 0xffff, { 0 } },
	{ "Zondag", ZIL_DAY_1, { 0 } },
	{ "Maandag", ZIL_DAY_2, { 0 } },
	{ "Dinsdag", ZIL_DAY_3, { 0 } },
	{ "Woensdag", ZIL_DAY_4, { 0 } },
	{ "Donderdag", ZIL_DAY_5, { 0 } },
	{ "Vrijdag", ZIL_DAY_6, { 0 } },
	{ "Zaterdag", ZIL_DAY_7, { 0 } },
	{ "Zo", ZIL_SHDAY_1, { 0 } },
	{ "Ma", ZIL_SHDAY_2, { 0 } },
	{ "Di", ZIL_SHDAY_3, { 0 } },
	{ "Wo", ZIL_SHDAY_4, { 0 } },
	{ "Do", ZIL_SHDAY_5, { 0 } },
	{ "Vr", ZIL_SHDAY_6, { 0 } },
	{ "Za", ZIL_SHDAY_7, { 0 } },
	{ "Zon.", ZIL_ABDAY_1, { 0 } },
	{ "Maan.", ZIL_ABDAY_2, { 0 } },
	{ "Dins.", ZIL_ABDAY_3, { 0 } },
	{ "Woens.", ZIL_ABDAY_4, { 0 } },
	{ "Dond.", ZIL_ABDAY_5, { 0 } },
	{ "Vrij.", ZIL_ABDAY_6, { 0 } },
	{ "Zat.", ZIL_ABDAY_7, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA MONTH_STRINGS[] =
{
	{ "", 0xffff, { 0 } },
	{ "januari", ZIL_MON_1, { 0 }  },
	{ "februari", ZIL_MON_2, { 0 }  },
	{ "maart", ZIL_MON_3, { 0 }  },
	{ "april", ZIL_MON_4, { 0 }  },
	{ "mei", ZIL_MON_5, { 0 }  },
	{ "juni", ZIL_MON_6, { 0 }  },
	{ "juli", ZIL_MON_7, { 0 }  },
	{ "augustus", ZIL_MON_8, { 0 }  },
	{ "september", ZIL_MON_9, { 0 }  },
	{ "oktober", ZIL_MON_10, { 0 } },
	{ "november", ZIL_MON_11, { 0 } },
	{ "december", ZIL_MON_12, { 0 } },
	{ "jan", ZIL_SHMON_1, { 0 }  },
	{ "feb", ZIL_SHMON_2, { 0 }  },
	{ "mrt", ZIL_SHMON_3, { 0 }  },
	{ "apr", ZIL_SHMON_4, { 0 }  },
	{ "mei", ZIL_SHMON_5, { 0 }  },
	{ "jun", ZIL_SHMON_6, { 0 }  },
	{ "jul", ZIL_SHMON_7, { 0 }  },
	{ "aug", ZIL_SHMON_8, { 0 }  },
	{ "sep", ZIL_SHMON_9, { 0 }  },
	{ "okt", ZIL_SHMON_10, { 0 } },
	{ "nov", ZIL_SHMON_11, { 0 } },
	{ "dec", ZIL_SHMON_12, { 0 } },
	{ "jan.", ZIL_ABMON_1, { 0 }  },
	{ "feb.", ZIL_ABMON_2, { 0 }  },
	{ "mrt.", ZIL_ABMON_3, { 0 }  },
	{ "apr.", ZIL_ABMON_4, { 0 }  },
	{ "mei", ZIL_ABMON_5, { 0 }  },
	{ "jun.", ZIL_ABMON_6, { 0 }  },
	{ "jul.", ZIL_ABMON_7, { 0 }  },
	{ "aug.", ZIL_ABMON_8, { 0 }  },
	{ "sept.", ZIL_ABMON_9, { 0 }  },
	{ "okt.", ZIL_ABMON_10, { 0 } },
	{ "nov.", ZIL_ABMON_11, { 0 } },
	{ "dec.", ZIL_ABMON_12, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA TIME_STRINGS[] =
{
	{ "", 0xffff, { 0 } },
	{ "vm", ZIL_AM, { 0 } },
	{ "nm", ZIL_PM, { 0 } },
	{ "xxxx", ZIL_TZ, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_UIW_BIGNUM_DATA) || defined(ZIL_UIW_INT_DATA) || defined(ZIL_UIW_REAL_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "Het getal %s is ongeldig.", NMI_INVALID, { 0 } },
	{ "Het getal %s valt niet in het bereik %s.", NMI_OUT_OF_RANGE, { 0 } },
	{ "Het getal %s is kleiner dan %s.", NMI_LESS_THAN_RANGE, { 0 } },
	{ "Het getal %s is groter dan %s.", NMI_GREATER_THAN_RANGE, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_UIW_DATE_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "De datum %s heeft een foutief formaat.", DTI_INVALID, { 0 } },
	{ "De datum %s heeft een dubbelzinnige maandnaam.", DTI_AMBIGUOUS, { 0 } },
	{ "De datum %s heeft een ongeldige maandnaam.", DTI_INVALID_NAME, { 0 } },
	{ "Een datumwaarde moet worden ingevuld.", DTI_VALUE_MISSING, { 0 } },
	{ "De datum %s valt niet in het bereik %s.", DTI_OUT_OF_RANGE, { 0 } },
	{ "De datum %s valt voor %s.", DTI_LESS_THAN_RANGE, { 0 } },
	{ "De datum %s valt na %s.", DTI_GREATER_THAN_RANGE, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_UIW_TIME_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "De tijd %s heeft een ongeldig formaat.", TMI_INVALID, { 0 } },
	{ "Een tijdwaarde moet ingevuld worden.", TMI_VALUE_MISSING, { 0 } },
	{ "De tijd %s valt niet in het bereik %s.", TMI_OUT_OF_RANGE, { 0 } },
	{ "De tijd %s valt voor %s.", TMI_LESS_THAN_RANGE, { 0 } },
	{ "De tijd %s valt na %s.", TMI_GREATER_THAN_RANGE, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_UI_ERROR_SYSTEM_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "Fout", MSG_TITLE, { 0 } },
	{ "&OK", MSG_OK, { 0 } },
	{ "A&nnuleer", MSG_CANCEL, { 0 } },
	{ "ASTERISK", MSG_ICONNAME, { 0 } },
	{ "&Verplaatsen", MSG_MOVE, { 0 } },
	{ "&Afsluiten\tAlt+F4", MSG_CLOSE, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_UI_HELP_SYSTEM_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "Help onderwerp", MSG_HELP_TOPIC, { 0 } },
	{ "Help index", MSG_HELP_INDEX, { 0 } },
	{ "Toon onderwerp", MSG_SHOW_TOPIC, { 0 } },
	{ "Toon index", MSG_SHOW_INDEX, { 0 } },
	{ "Selectoer onderwerp", MSG_MESSAGE1, { 0 } },
	{ "Typ oon woord of solecteer er oon van de lijst.", MSG_MESSAGE2, { 0 } },
	{ "Sluiten", MSG_CLOSE, { 0 } },
	{ "Help Informatie", MSG_ICONTITLE, { 0 } },
	{ "QUESTION", MSG_ICONNAME, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_UIW_SYSTEM_BUTTON_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "&Herstellen", MNIF_RESTORE, { 0 } }, // S_RESTORE
	{ "&Verplaatsen", MNIF_MOVE, { 0 } },  // S_MOVE
	{ "&Grootte wijzigen", MNIF_SIZE, { 0 } },  // S_SIZE
	{ "Mi&nimaliseren", MNIF_MINIMIZE, { 0 } }, // S_MINIMIZE
	{ "Ma&ximaliseren", MNIF_MAXIMIZE, { 0 } }, // S_MAXIMIZE
	{ "", MNIF_SEPARATOR, { 0 } },
	{ "&Afsluiten", MNIF_CLOSE, { 0 } }, // S_CLOSE
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_UIW_WINDOW_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "ERROR", 0xffff, { 0 } },
	{ "Onbekend window object.", ZIL_UNK_OBJ, { 0 } },
	{ "Object %s werd niet gevonden.", ZIL_NO_OBJ, { 0 } },
	{ "Bestand %s werd niet gevonden.", ZIL_NO_FILE, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_ZAF_MESSAGE_WINDOW_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "&OK", ZIL_MSG_OK, { 0 }},
	{ "&Ja", ZIL_MSG_YES, { 0 } },
	{ "&Nee", ZIL_MSG_NO, { 0 } },
	{ "&Afbreken", ZIL_MSG_ABORT, { 0 } },
	{ "&Opnieuw", ZIL_MSG_RETRY, { 0 } },
	{ "&Negeren", ZIL_MSG_IGNORE, { 0 } },
	{ "&Terug", ZIL_MSG_CANCEL, { 0 } },
	{ "&Hulp", ZIL_MSG_HELP, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif
