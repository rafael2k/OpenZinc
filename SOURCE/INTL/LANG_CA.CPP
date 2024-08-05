//	Zinc Interface Library - LANG_CA.CPP
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
	// Language definitions for CATALAN (CA).
	static ZIL_ICHAR ZIL_FARDATA isoLanguageName[] = { 'c','a',0 };
#endif

#if defined(ZIL_UTIME_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA DAY_STRINGS[] =
{
	{ "", 0xffff, { 0 } },
	{ "Diumenge",	ZIL_DAY_1, { 0 } },
	{ "Dilluns",	ZIL_DAY_2, { 0 } },
	{ "Dimarts",	ZIL_DAY_3, { 0 } },
	{ "Dimecres",	ZIL_DAY_4, { 0 } },
	{ "Dijous",	ZIL_DAY_5, { 0 } },
	{ "Divendres",	ZIL_DAY_6, { 0 } },
	{ "Dissabte",	ZIL_DAY_7, { 0 } },
	{ "Diu",	ZIL_SHDAY_1, { 0 } },
	{ "Dill",	ZIL_SHDAY_2, { 0 } },
	{ "Dima",	ZIL_SHDAY_3, { 0 } },
	{ "Dime",	ZIL_SHDAY_4, { 0 } },
	{ "Dij",	ZIL_SHDAY_5, { 0 } },
	{ "Div",	ZIL_SHDAY_6, { 0 } },
	{ "Dis",	ZIL_SHDAY_7, { 0 } },
	{ "Dium.",	ZIL_ABDAY_1, { 0 } },
	{ "Dill.",	ZIL_ABDAY_2, { 0 } },
	{ "Dimar.",	ZIL_ABDAY_3, { 0 } },
	{ "Dimecr.",	ZIL_ABDAY_4, { 0 } },
	{ "Dijous.",	ZIL_ABDAY_5, { 0 } },
	{ "Diven.",	ZIL_ABDAY_6, { 0 } },
	{ "Dissab.",	ZIL_ABDAY_7, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA MONTH_STRINGS[] =
{
	{ "", 0xffff, { 0 } },
	{ "Gener",	ZIL_MON_1, { 0 }  },
	{ "Febrer",	ZIL_MON_2, { 0 }  },
	{ "Mar\347",	ZIL_MON_3, { 0 }  },
	{ "Abril",	ZIL_MON_4, { 0 }  },
	{ "Maig",	ZIL_MON_5, { 0 }  },
	{ "Juny",	ZIL_MON_6, { 0 }  },
	{ "Juliol",	ZIL_MON_7, { 0 }  },
	{ "Agost",	ZIL_MON_8, { 0 }  },
	{ "Setembre",	ZIL_MON_9, { 0 }  },
	{ "Octubre",	ZIL_MON_10, { 0 } },
	{ "Novembre",	ZIL_MON_11, { 0 } },
	{ "Desembre",	ZIL_MON_12, { 0 } },
	{ "Gen",	ZIL_SHMON_1, { 0 }  },
	{ "Feb",	ZIL_SHMON_2, { 0 }  },
	{ "Mar",	ZIL_SHMON_3, { 0 }  },
	{ "Abr",	ZIL_SHMON_4, { 0 }  },
	{ "Mai",	ZIL_SHMON_5, { 0 }  },
	{ "Jun",	ZIL_SHMON_6, { 0 }  },
	{ "Jul",	ZIL_SHMON_7, { 0 }  },
	{ "Ago",	ZIL_SHMON_8, { 0 }  },
	{ "Set",	ZIL_SHMON_9, { 0 }  },
	{ "Oct",	ZIL_SHMON_10, { 0 } },
	{ "Nov",	ZIL_SHMON_11, { 0 } },
	{ "Des",	ZIL_SHMON_12, { 0 } },
	{ "Gen.",	ZIL_ABMON_1, { 0 }  },
	{ "Feb.",	ZIL_ABMON_2, { 0 }  },
	{ "Mar\347.",	ZIL_ABMON_3, { 0 }  },
	{ "Abr.",	ZIL_ABMON_4, { 0 }  },
	{ "Mai.",	ZIL_ABMON_5, { 0 }  },
	{ "Jun.",	ZIL_ABMON_6, { 0 }  },
	{ "Jul.",	ZIL_ABMON_7, { 0 }  },
	{ "Ago.",	ZIL_ABMON_8, { 0 }  },
	{ "Set.",	ZIL_ABMON_9, { 0 }  },
	{ "Oct.",	ZIL_ABMON_10, { 0 } },
	{ "Nov.",	ZIL_ABMON_11, { 0 } },
	{ "Des.",	ZIL_ABMON_12, { 0 } },
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
	{ "El n\372mero %s no \351s v\341lid.", NMI_INVALID, { 0 } },
	{ "El n\372mero %s no est\341 dintre del rang %s.", NMI_OUT_OF_RANGE, { 0 } },
	{ "El n\372mero %s \351s inferior a %s.", NMI_LESS_THAN_RANGE, { 0 } },
	{ "El n\372mero %s \351s superior a %s.", NMI_GREATER_THAN_RANGE, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_UIW_DATE_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "La data %s no \351s un format v\341lid.", DTI_INVALID, { 0 } },
	{ "El nom del mes de la data %s es ambig\374u.", DTI_AMBIGUOUS, { 0 } },
	{ "El nom del mes de la data %s no \351s v\341lid.", DTI_INVALID_NAME, { 0 } },
	{ "S'ha de introduir un valor de data.", DTI_VALUE_MISSING, { 0 } },
	{ "La data %s no est\341 dintre del rang %s.", DTI_OUT_OF_RANGE, { 0 } },
	{ "La data %s \351s anterior a %s.", DTI_LESS_THAN_RANGE, { 0 } },
	{ "La data %s \351s posterior a %s.", DTI_GREATER_THAN_RANGE, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_UIW_TIME_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "L'hora %s no \351s en un format v\340lid.", TMI_INVALID, { 0 } },
	{ "S'ha de introduir un valor d'hora.", TMI_VALUE_MISSING, { 0 } },
	{ "L'hora %s no est\341 dintre del rang %s.", TMI_OUT_OF_RANGE, { 0 } },
	{ "L'hora %s \351s anterior a %s.", TMI_LESS_THAN_RANGE, { 0 } },
	{ "L'hora %s \351s posterior a %s.", TMI_GREATER_THAN_RANGE, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_UI_ERROR_SYSTEM_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "Error", MSG_TITLE, { 0 } },
	{ "&Acceptar", MSG_OK, { 0 } },
	{ "&Cancelar", MSG_CANCEL, { 0 } },
	{ "ASTERISK", MSG_ICONNAME, { 0 } },
	{ "&Moure", MSG_MOVE, { 0 } },
	{ "&Tancar\tAlt+F4", MSG_CLOSE, { 0 } },
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
	{ "Informaci\363 d'ajuda", MSG_ICONTITLE, { 0 } },
	{ "QUESTION", MSG_ICONNAME, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_UIW_SYSTEM_BUTTON_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "&Restaurar", MNIF_RESTORE, { 0 } },	// S_RESTORE
	{ "&Moure", MNIF_MOVE, { 0 } },		// S_MOVE
	{ "&Tamany", MNIF_SIZE, { 0 } },		// S_SIZE
	{ "Mi&nimitzar", MNIF_MINIMIZE, { 0 } },	// S_MINIMIZE
	{ "Ma&ximitzar", MNIF_MAXIMIZE, { 0 } },	// S_MAXIMIZE
	{ "", MNIF_SEPARATOR, { 0 } },
	{ "&Tancar", MNIF_CLOSE, { 0 } },	// S_CLOSE
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_UIW_WINDOW_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "ERROR", 0xffff, { 0 } },
	{ "Window object desconegut.", ZIL_UNK_OBJ, { 0 } },
	{ "No s'ha trobat l'objecte %s.", ZIL_NO_OBJ, { 0 } },
	{ "No s'ha trobat el fitxer %s.", ZIL_NO_FILE, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_ZAF_MESSAGE_WINDOW_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "&OK", ZIL_MSG_OK, { 0 }},
	{ "&Si", ZIL_MSG_YES, { 0 } },
	{ "&No", ZIL_MSG_NO, { 0 } },
	{ "&Abortar", ZIL_MSG_ABORT, { 0 } },
	{ "&Tornar-hi", ZIL_MSG_RETRY, { 0 } },
	{ "&Ignorar", ZIL_MSG_IGNORE, { 0 } },
	{ "&Cancel.lar", ZIL_MSG_CANCEL, { 0 } },
	{ "&Ajuda", ZIL_MSG_HELP, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif
