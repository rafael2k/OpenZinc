//	Zinc Interface Library - LANG_DE.CPP
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
	// Language definitions for German (DE).
	static ZIL_ICHAR ZIL_FARDATA isoLanguageName[] = { 'd','e',0 };
#endif

#if defined(ZIL_UTIME_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA DAY_STRINGS[] =
{
	{ "", 0xffff, { 0 } },
	{ "Sonntag",	ZIL_DAY_1, { 0 } },
	{ "Montag",	ZIL_DAY_2, { 0 } },
	{ "Dienstag",	ZIL_DAY_3, { 0 } },
	{ "Mittwoch",	ZIL_DAY_4, { 0 } },
	{ "Donnerstag",	ZIL_DAY_5, { 0 } },
	{ "Freitag",	ZIL_DAY_6, { 0 } },
	{ "Samstag",	ZIL_DAY_7, { 0 } },
	{ "Son",	ZIL_SHDAY_1, { 0 } },
	{ "Mon",	ZIL_SHDAY_2, { 0 } },
	{ "Die",	ZIL_SHDAY_3, { 0 } },
	{ "Mit",	ZIL_SHDAY_4, { 0 } },
	{ "Don",	ZIL_SHDAY_5, { 0 } },
	{ "Fre",	ZIL_SHDAY_6, { 0 } },
	{ "Sam",	ZIL_SHDAY_7, { 0 } },
	{ "So.",	ZIL_ABDAY_1, { 0 } },
	{ "Mo.",	ZIL_ABDAY_2, { 0 } },
	{ "Di.",	ZIL_ABDAY_3, { 0 } },
	{ "Mi.",	ZIL_ABDAY_4, { 0 } },
	{ "Do.",	ZIL_ABDAY_5, { 0 } },
	{ "Fr.",	ZIL_ABDAY_6, { 0 } },
	{ "Sa.",	ZIL_ABDAY_7, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA MONTH_STRINGS[] =
{
	{ "", 0xffff, { 0 } },
	{ "Januar",	ZIL_MON_1, { 0 }  },
	{ "Februar",	ZIL_MON_2, { 0 }  },
	{ "M\344rz",	ZIL_MON_3, { 0 }  },
	{ "April",	ZIL_MON_4, { 0 }  },
	{ "Mai",	ZIL_MON_5, { 0 }  },
	{ "Juni",	ZIL_MON_6, { 0 }  },
	{ "Juli",	ZIL_MON_7, { 0 }  },
	{ "August",	ZIL_MON_8, { 0 }  },
	{ "September",	ZIL_MON_9, { 0 }  },
	{ "Oktober",	ZIL_MON_10, { 0 } },
	{ "November",	ZIL_MON_11, { 0 } },
	{ "Dezember",	ZIL_MON_12, { 0 } },
	{ "Jan",	ZIL_SHMON_1, { 0 }  },
	{ "Feb",	ZIL_SHMON_2, { 0 }  },
	{ "M\344r",	ZIL_SHMON_3, { 0 }  },
	{ "Apr",	ZIL_SHMON_4, { 0 }  },
	{ "Mai",	ZIL_SHMON_5, { 0 }  },
	{ "Jun",	ZIL_SHMON_6, { 0 }  },
	{ "Jul",	ZIL_SHMON_7, { 0 }  },
	{ "Aug",	ZIL_SHMON_8, { 0 }  },
	{ "Sep",	ZIL_SHMON_9, { 0 }  },
	{ "Okt",	ZIL_SHMON_10, { 0 } },
	{ "Nov",	ZIL_SHMON_11, { 0 } },
	{ "Dez",	ZIL_SHMON_12, { 0 } },
	{ "Jan.",	ZIL_ABMON_1, { 0 }  },
	{ "Feb.",	ZIL_ABMON_2, { 0 }  },
	{ "M\344rz",	ZIL_ABMON_3, { 0 }  },
	{ "Apr.",	ZIL_ABMON_4, { 0 }  },
	{ "Mai",	ZIL_ABMON_5, { 0 }  },
	{ "Juni",	ZIL_ABMON_6, { 0 }  },
	{ "Juli",	ZIL_ABMON_7, { 0 }  },
	{ "Aug.",	ZIL_ABMON_8, { 0 }  },
	{ "Sept.",	ZIL_ABMON_9, { 0 }  },
	{ "Okt.",	ZIL_ABMON_10, { 0 } },
	{ "Nov.",	ZIL_ABMON_11, { 0 } },
	{ "Dez.",	ZIL_ABMON_12, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA TIME_STRINGS[] =
{
	{ "", 0xffff, { 0 } },
	{ "vorm.", ZIL_AM, { 0 } },
	{ "nachm.", ZIL_PM, { 0 } },
	{ "xxxx", ZIL_TZ, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_UIW_BIGNUM_DATA) || defined(ZIL_UIW_INT_DATA) || defined(ZIL_UIW_REAL_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "Die Zahl %s ist ung\374ltig.", NMI_INVALID, { 0 } },
	{ "Die Zahl %s ist nicht im Bereich %s.", NMI_OUT_OF_RANGE, { 0 } },
	{ "Die Zahl %s ist kleiner als %s.", NMI_LESS_THAN_RANGE, { 0 } },
	{ "Die Zahl %s ist gr\366\337er als %s.", NMI_GREATER_THAN_RANGE, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_UIW_DATE_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "Das Datum %s ist in einem ung\374ltigen Format angegeben.", DTI_INVALID, { 0 } },
	{ "Das Datum %s enth\344lt keinen eindeutigen Monatsnamen.", DTI_AMBIGUOUS, { 0 } },
	{ "Das Datum %s enth\344lt einen ung\374ltigen Monatsnamen.", DTI_INVALID_NAME, { 0 } },
	{ "Es mu\337 ein Datum angegeben werden.", DTI_VALUE_MISSING, { 0 } },
	{ "Das Datum %s ist nicht im Bereich %s.", DTI_OUT_OF_RANGE, { 0 } },
	{ "Das Datum %s ist vor dem %s.", DTI_LESS_THAN_RANGE, { 0 } },
	{ "Das Datum %s ist nach dem %s.", DTI_GREATER_THAN_RANGE, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_UIW_TIME_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "Die Uhrzeit %s ist in einem ung\374ltigen Format angegeben.", TMI_INVALID, { 0 } },
	{ "Es mu\337 eine Uhrzeit angegeben werden.", TMI_VALUE_MISSING, { 0 } },
	{ "Die Uhrzeit %s ist nicht im Bereich %s.", TMI_OUT_OF_RANGE, { 0 } },
	{ "Die Uhrzeit %s ist vor %s.", TMI_LESS_THAN_RANGE, { 0 } },
	{ "Die Uhrzeit %s ist nach %s.", TMI_GREATER_THAN_RANGE, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_UI_ERROR_SYSTEM_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "Fehler", MSG_TITLE, { 0 } },
	{ "&OK", MSG_OK, { 0 } },
	{ "&Abbrechen", MSG_CANCEL, { 0 } },
	{ "ASTERISK", MSG_ICONNAME, { 0 } },
	{ "&Verschieben", MSG_MOVE, { 0 } },
	{ "&Beenden\tAlt+F4", MSG_CLOSE, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_UI_HELP_SYSTEM_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "Hilfe Thema", MSG_HELP_TOPIC, { 0 } },
	{ "Hilfe Index", MSG_HELP_INDEX, { 0 } },
	{ "Thema anzeigen", MSG_SHOW_TOPIC, { 0 } },
	{ "Index anzeigen", MSG_SHOW_INDEX, { 0 } },
	{ "Markieren Sie ein Thema", MSG_MESSAGE1, { 0 } },
	{ "Geben Sie ein Wort ein, order markieren Sie eines in der Liste.", MSG_MESSAGE2, { 0 } },
	{ "Schlie\337en", MSG_CLOSE, { 0 } },
	{ "Hilfe Informationen", MSG_ICONTITLE, { 0 } },
	{ "QUESTION", MSG_ICONNAME, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_UIW_SYSTEM_BUTTON_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "&Wiederherstellen", MNIF_RESTORE, { 0 } },	// S_RESTORE
	{ "&Verschieben", MNIF_MOVE, { 0 } },		// S_MOVE
	{ "&Gr\366\337e", MNIF_SIZE, { 0 } },		// S_SIZE
	{ "S&ymbol", MNIF_MINIMIZE, { 0 } },	// S_MINIMIZE
	{ "&Vollbild", MNIF_MAXIMIZE, { 0 } },	// S_MAXIMIZE
	{ "", MNIF_SEPARATOR, { 0 } },
	{ "&Beenden", MNIF_CLOSE, { 0 } },	// S_CLOSE
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_UIW_WINDOW_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "FEHLER", 0xffff, { 0 } },
	{ "Unbekanntes Fenster-Objekt.", ZIL_UNK_OBJ, { 0 } },
	{ "Objekt %s wurde nicht gefunden.", ZIL_NO_OBJ, { 0 } },
	{ "Datei %s wurde nicht gefunden.", ZIL_NO_FILE, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_ZAF_MESSAGE_WINDOW_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "&OK", ZIL_MSG_OK, { 0 }},
	{ "&Ja", ZIL_MSG_YES, { 0 } },
	{ "&Nein", ZIL_MSG_NO, { 0 } },
	{ "&Abbruch", ZIL_MSG_ABORT, { 0 } },
	{ "&Wiederholen", ZIL_MSG_RETRY, { 0 } },
	{ "&Ignorieren", ZIL_MSG_IGNORE, { 0 } },
	{ "&Beenden", ZIL_MSG_CANCEL, { 0 } },
	{ "&Hilfe", ZIL_MSG_HELP, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif
