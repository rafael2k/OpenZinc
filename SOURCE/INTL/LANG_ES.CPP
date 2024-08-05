//	Zinc Interface Library - LANG_ES.CPP
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
	// Language definitions for SPAINISH (ES).
	static ZIL_ICHAR ZIL_FARDATA isoLanguageName[] = { 'e','s',0 };
#endif

#if defined(ZIL_UTIME_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA DAY_STRINGS[] =
{
	{ "", 0xffff, { 0 } },
	{ "Domingo",	ZIL_DAY_1, { 0 } },
	{ "Lunes",	ZIL_DAY_2, { 0 } },
	{ "Martes",	ZIL_DAY_3, { 0 } },
	{ "Mi\351rcoles",	ZIL_DAY_4, { 0 } },
	{ "Jueves",	ZIL_DAY_5, { 0 } },
	{ "Viernes",	ZIL_DAY_6, { 0 } },
	{ "S\341bado",	ZIL_DAY_7, { 0 } },
	{ "Dom",	ZIL_SHDAY_1, { 0 } },
	{ "Lun",	ZIL_SHDAY_2, { 0 } },
	{ "Mar",	ZIL_SHDAY_3, { 0 } },
	{ "Mi\351",	ZIL_SHDAY_4, { 0 } },
	{ "Jue",	ZIL_SHDAY_5, { 0 } },
	{ "Vie",	ZIL_SHDAY_6, { 0 } },
	{ "S\341b",	ZIL_SHDAY_7, { 0 } },
	{ "Dom.",	ZIL_ABDAY_1, { 0 } },
	{ "Lun.",	ZIL_ABDAY_2, { 0 } },
	{ "Mar.",	ZIL_ABDAY_3, { 0 } },
	{ "Mier.",	ZIL_ABDAY_4, { 0 } },
	{ "Juev.",	ZIL_ABDAY_5, { 0 } },
	{ "Vier.",	ZIL_ABDAY_6, { 0 } },
	{ "Sab.",	ZIL_ABDAY_7, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA MONTH_STRINGS[] =
{
	{ "", 0xffff, { 0 } },
	{ "Enero",	ZIL_MON_1, { 0 }  },
	{ "Febrero",	ZIL_MON_2, { 0 }  },
	{ "Marzo",	ZIL_MON_3, { 0 }  },
	{ "Abril",	ZIL_MON_4, { 0 }  },
	{ "Mayo",	ZIL_MON_5, { 0 }  },
	{ "Junio",	ZIL_MON_6, { 0 }  },
	{ "Julio",	ZIL_MON_7, { 0 }  },
	{ "Agosto",	ZIL_MON_8, { 0 }  },
	{ "Septiembre",	ZIL_MON_9, { 0 }  },
	{ "Octubre",	ZIL_MON_10, { 0 } },
	{ "Noviembre",	ZIL_MON_11, { 0 } },
	{ "Diciembre",	ZIL_MON_12, { 0 } },
	{ "Ene",	ZIL_SHMON_1, { 0 }  },
	{ "Feb",	ZIL_SHMON_2, { 0 }  },
	{ "Mar",	ZIL_SHMON_3, { 0 }  },
	{ "Abr",	ZIL_SHMON_4, { 0 }  },
	{ "May",	ZIL_SHMON_5, { 0 }  },
	{ "Jun",	ZIL_SHMON_6, { 0 }  },
	{ "Jul",	ZIL_SHMON_7, { 0 }  },
	{ "Ago",	ZIL_SHMON_8, { 0 }  },
	{ "Sep",	ZIL_SHMON_9, { 0 }  },
	{ "Oct",	ZIL_SHMON_10, { 0 } },
	{ "Nov",	ZIL_SHMON_11, { 0 } },
	{ "Dic",	ZIL_SHMON_12, { 0 } },
	{ "Ene.",	ZIL_ABMON_1, { 0 }  },
	{ "Feb.",	ZIL_ABMON_2, { 0 }  },
	{ "Mar.",	ZIL_ABMON_3, { 0 }  },
	{ "Abr.",	ZIL_ABMON_4, { 0 }  },
	{ "May.",	ZIL_ABMON_5, { 0 }  },
	{ "Jun.",	ZIL_ABMON_6, { 0 }  },
	{ "Jul.",	ZIL_ABMON_7, { 0 }  },
	{ "Ago.",	ZIL_ABMON_8, { 0 }  },
	{ "Sept.",	ZIL_ABMON_9, { 0 }  },
	{ "Oct.",	ZIL_ABMON_10, { 0 } },
	{ "Nov.",	ZIL_ABMON_11, { 0 } },
	{ "Dic.",	ZIL_ABMON_12, { 0 } },
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
	{ "El n\372mero %s no es v\341lido.", NMI_INVALID, { 0 } },
	{ "El n\372mero %s no est\341 dentro del rango %s.", NMI_OUT_OF_RANGE, { 0 } },
	{ "El n\372mero %s es menor que %s.", NMI_LESS_THAN_RANGE, { 0 } },
	{ "El n\372mero %s es mayor que %s.", NMI_GREATER_THAN_RANGE, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_UIW_DATE_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "La fecha %s no est\341 en un formato v\341lido.", DTI_INVALID, { 0 } },
	{ "El nombre del mes en la fecha %s es ambiguo.", DTI_AMBIGUOUS, { 0 } },
	{ "El nombre del mes en la fecha %s no es v\341lido.", DTI_INVALID_NAME, { 0 } },
	{ "Debe introducir un valor de fecha.", DTI_VALUE_MISSING, { 0 } },
	{ "La fecha %s no est\341 dentro del rango %s.", DTI_OUT_OF_RANGE, { 0 } },
	{ "La fecha %s es anterior a %s.", DTI_LESS_THAN_RANGE, { 0 } },
	{ "La fecha %s es posterior a %s.", DTI_GREATER_THAN_RANGE, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_UIW_TIME_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "La hora %s no est\341 en un formato v\341lido.", TMI_INVALID, { 0 } },
	{ "Debe introducir un valor de hora.", TMI_VALUE_MISSING, { 0 } },
	{ "La hora %s no est\341 dentro del rango %s.", TMI_OUT_OF_RANGE, { 0 } },
	{ "La hora %s es anterior a %s.", TMI_LESS_THAN_RANGE, { 0 } },
	{ "La hora %s es posterior a %s.", TMI_GREATER_THAN_RANGE, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_UI_ERROR_SYSTEM_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "Error", MSG_TITLE, { 0 } },
	{ "&Aceptar", MSG_OK, { 0 } },
	{ "&Cancelar", MSG_CANCEL, { 0 } },
	{ "ASTERISK", MSG_ICONNAME, { 0 } },
	{ "&Mover", MSG_MOVE, { 0 } },
	{ "&Cerrar\tAlt+F4", MSG_CLOSE, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_UI_HELP_SYSTEM_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "Elemento de la ayuda", MSG_HELP_TOPIC, { 0 } },
	{ "Indice de la ayuda", MSG_HELP_INDEX, { 0 } },
	{ "Ver un elemento", MSG_SHOW_TOPIC, { 0 } },
	{ "Ver indice", MSG_SHOW_INDEX, { 0 } },
	{ "Seleccione un Elemento", MSG_MESSAGE1, { 0 } },
	{ "Teclee una palabra, o selecci\363nela de la lista.", MSG_MESSAGE2, { 0 } },
	{ "Cerrar", MSG_CLOSE, { 0 } },
	{ "Informaci\363n de Ayuda", MSG_ICONTITLE, { 0 } },
	{ "QUESTION", MSG_ICONNAME, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_UIW_SYSTEM_BUTTON_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "&Restaurar", MNIF_RESTORE, { 0 } },	// S_RESTORE
	{ "&Mover", MNIF_MOVE, { 0 } },		// S_MOVE
	{ "&Tama\361o", MNIF_SIZE, { 0 } },		// S_SIZE
	{ "Mi&nimizar", MNIF_MINIMIZE, { 0 } },	// S_MINIMIZE
	{ "Ma&ximizar", MNIF_MAXIMIZE, { 0 } },	// S_MAXIMIZE
	{ "", MNIF_SEPARATOR, { 0 } },
	{ "&Cerrar", MNIF_CLOSE, { 0 } },	// S_CLOSE
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_UIW_WINDOW_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "ERROR", 0xffff, { 0 } },
	{ "Window object desconocido.", ZIL_UNK_OBJ, { 0 } },
	{ "No se ha encontrado el objeto %s.", ZIL_NO_OBJ, { 0 } },
	{ "No se ha encontrado el archivo %s.", ZIL_NO_FILE, { 0 } },
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
	{ "&Repetir", ZIL_MSG_RETRY, { 0 } },
	{ "&Ignorar", ZIL_MSG_IGNORE, { 0 } },
	{ "&Cancelar", ZIL_MSG_CANCEL, { 0 } },
	{ "&Ayuda", ZIL_MSG_HELP, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif
