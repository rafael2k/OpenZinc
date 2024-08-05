// Following is the revised translation of the Frenc texts for ZINC 4
// Prepared by Michele DELSOL - Micro Sigma, Paris
//    CompuserveID : 100126.3521@compuserve.com

// Zinc Interface Library - LANG_FR.CPP
// COPYRIGHT (C) 1990-1995.  All Rights Reserved.
// Zinc Software Incorporated.  Pleasant Grove, Utah  USA

//   = \352
//   = \364
//   = \351
//   = \340
//   = \373

// In error statements, the %1%s is the data, the %2%s is the range.
// NOTE: '&' is the hotkey specifier.

#if defined(ZIL_LANGUAGE_DATA)
#	define langCodeset	CP_ISO8859_1
	// Language definitions for FRENCH (FR).
	static ZIL_ICHAR ZIL_FARDATA isoLanguageName[] = { 'f','r',0 };
#endif

#if defined(ZIL_UTIME_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA DAY_STRINGS[] =
{
	{ "", 0xffff, { 0 } },
	{ "Dimanche", ZIL_DAY_1, { 0 } },
	{ "Lundi", ZIL_DAY_2, { 0 } },
	{ "Mardi", ZIL_DAY_3, { 0 } },
	{ "Mercredi", ZIL_DAY_4, { 0 } },
	{ "Jeudi", ZIL_DAY_5, { 0 } },
	{ "Vendredi", ZIL_DAY_6, { 0 } },
	{ "Samedi", ZIL_DAY_7, { 0 } },
	{ "Dim", ZIL_SHDAY_1, { 0 } },
	{ "Lun", ZIL_SHDAY_2, { 0 } },
	{ "Mar", ZIL_SHDAY_3, { 0 } },
	{ "Mer", ZIL_SHDAY_4, { 0 } },
	{ "Jeu", ZIL_SHDAY_5, { 0 } },
	{ "Ven", ZIL_SHDAY_6, { 0 } },
	{ "Sam", ZIL_SHDAY_7, { 0 } },
	{ "Dim.", ZIL_ABDAY_1, { 0 } },
	{ "Lun.", ZIL_ABDAY_2, { 0 } },
	{ "Mar.", ZIL_ABDAY_3, { 0 } },
	{ "Merc.", ZIL_ABDAY_4, { 0 } },
	{ "Jeu.", ZIL_ABDAY_5, { 0 } },
	{ "Vend.", ZIL_ABDAY_6, { 0 } },
	{ "Sam.", ZIL_ABDAY_7, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA MONTH_STRINGS[] =
{
	{ "", 0xffff, { 0 } },
	{ "Janvier", ZIL_MON_1, { 0 }  },
	{ "F\351vrier", ZIL_MON_2, { 0 }  },
	{ "Mars", ZIL_MON_3, { 0 }  },
	{ "Avril", ZIL_MON_4, { 0 }  },
	{ "Mai", ZIL_MON_5, { 0 }  },
	{ "Juin", ZIL_MON_6, { 0 }  },
	{ "Juillet", ZIL_MON_7, { 0 }  },
	{ "Ao\373t", ZIL_MON_8, { 0 }  },
	{ "Septembre", ZIL_MON_9, { 0 }  },
	{ "Octobre", ZIL_MON_10, { 0 } },
	{ "Novembre", ZIL_MON_11, { 0 } },
	{ "D\351cembre", ZIL_MON_12, { 0 } },
	{ "Jan", ZIL_SHMON_1, { 0 }  },
	{ "F\351v", ZIL_SHMON_2, { 0 }  },
	{ "Mar", ZIL_SHMON_3, { 0 }  },
	{ "Avr", ZIL_SHMON_4, { 0 }  },
	{ "Mai", ZIL_SHMON_5, { 0 }  },
	{ "Juin", ZIL_SHMON_6, { 0 }  }, // 4 letters otherwise Juin & Juillet same.
	{ "Juil", ZIL_SHMON_7, { 0 }  }, // 4 letters otherwise Juin & Juillet same.
	{ "Ao\373", ZIL_SHMON_8, { 0 }  },
	{ "Sep", ZIL_SHMON_9, { 0 }  },
	{ "Oct", ZIL_SHMON_10, { 0 } },
	{ "Nov", ZIL_SHMON_11, { 0 } },
	{ "D\351c", ZIL_SHMON_12, { 0 } },
	{ "Jan.", ZIL_ABMON_1, { 0 }  },
	{ "F\351v.", ZIL_ABMON_2, { 0 }  },
	{ "Mars", ZIL_ABMON_3, { 0 }  },
	{ "Avr.", ZIL_ABMON_4, { 0 }  },
	{ "Mai", ZIL_ABMON_5, { 0 }  },
	{ "Juin", ZIL_ABMON_6, { 0 }  },
	{ "Juil.", ZIL_ABMON_7, { 0 }  },
	{ "Ao\373t", ZIL_ABMON_8, { 0 }  },
	{ "Sept.", ZIL_ABMON_9, { 0 }  },
	{ "Oct.", ZIL_ABMON_10, { 0 } },
	{ "Nov.", ZIL_ABMON_11, { 0 } },
	{ "D\351c.", ZIL_ABMON_12, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA TIME_STRINGS[] =
{
	{ "", 0xffff, { 0 } },
	{ "a.m.", ZIL_AM, { 0 } }, // Please note the French do not use A.M. nor P.M.
	{ "p.m.", ZIL_PM, { 0 } },
	{ "xxxx", ZIL_TZ, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_UIW_BIGNUM_DATA) || defined(ZIL_UIW_INT_DATA) || defined(ZIL_UIW_REAL_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "Le nombre %s n'est pas valable.", NMI_INVALID, { 0 } },
	{ "Le nombre %s n'est pas dans l'intervalle %s.", NMI_OUT_OF_RANGE, { 0 } },
	{ "Le nombre %s est inf\351rieur \340 %s.", NMI_LESS_THAN_RANGE, { 0 }},
	{ "Le nombre %s est sup\351rieur \340 %s.", NMI_GREATER_THAN_RANGE, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_UIW_DATE_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "La date %s n'est pas dans un format valable.", DTI_INVALID, { 0 } },
	{ "La date %s a un nom de mois ambigu.", DTI_AMBIGUOUS, { 0 } },
	{ "La date %s n'a pas un nom de mois valable.", DTI_INVALID_NAME, { 0 } },
	{ "Une valeur doit \352tre introduite pour la date.", DTI_VALUE_MISSING, { 0 } },
	{ "La date %s n'est pas dans l'intervalle %s.", DTI_OUT_OF_RANGE, { 0 } },
	{ "La date %s est inf\351rieure \340 %s.", DTI_LESS_THAN_RANGE, { 0 } },
	{ "La date %s est sup\351rieure \340 %s.", DTI_GREATER_THAN_RANGE, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_UIW_TIME_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "Le temps %s ne correspond pas \340 un format valable.", TMI_INVALID, { 0 } },
	{ "Une valeur doit \352tre introduite pour le temps.", TMI_VALUE_MISSING, { 0 } },
	{ "La temps %s n'est pas dans l'intervalle %s.", TMI_OUT_OF_RANGE, { 0 } },
	{ "Le temps %s est inf\351rieur \340 %s.", TMI_LESS_THAN_RANGE, { 0 } },
	{ "Le temps %s est sup\351rieur \340 %s.", TMI_GREATER_THAN_RANGE, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_UI_ERROR_SYSTEM_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "&Erreur", MSG_TITLE, { 0 } },
	{ "&OK", MSG_OK, { 0 } },
	{ "&Annuler", MSG_CANCEL, { 0 } },
	{ "As&terisque", MSG_ICONNAME, { 0 } },
	{ "&D\351placer", MSG_MOVE, { 0 } },
	{ "&Fermer\tAlt+F4", MSG_CLOSE, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_UI_HELP_SYSTEM_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "Th\351me de l'Aide", MSG_HELP_TOPIC, { 0 } },
	{ "Indexe de l'Aide", MSG_HELP_INDEX, { 0 } },
	{ "Affichez un Th\351me", MSG_SHOW_TOPIC, { 0 } },
	{ "Affichez un Indexe", MSG_SHOW_INDEX, { 0 } },
	{ "Choisissez un Th\351me", MSG_MESSAGE1, { 0 } },
	{ "Tapez un mot, ou choisissez en un de la liste.", MSG_MESSAGE2, { 0 } },
	{ "&Fermez", MSG_CLOSE, { 0 } },
	{ "Information sur l'Aide", MSG_ICONTITLE, { 0 } },
	{ "QUESTION", MSG_ICONNAME, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_UIW_SYSTEM_BUTTON_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "&R\351tablir", MNIF_RESTORE, { 0 } }, // S_RESTORE
	{ "D\351&placer", MNIF_MOVE, { 0 } },  // S_MOVE
	{ "&Dimensionner", MNIF_SIZE, { 0 } },  // S_SIZE
	{ "Mi&nimiser", MNIF_MINIMIZE, { 0 } }, // S_MINIMIZE
	{ "Ma&ximiser", MNIF_MAXIMIZE, { 0 } }, // S_MAXIMIZE
	{ "", MNIF_SEPARATOR, { 0 } },
	{ "&Fermer", MNIF_CLOSE, { 0 } }, // S_CLOSE
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_UIW_WINDOW_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "ERREUR", 0xffff, { 0 } },
	{ "Objet de fen\352tre inconnu.", ZIL_UNK_OBJ, { 0 } },
	{ "Objet %s pas trouv\351.", ZIL_NO_OBJ, { 0 } },
	{ "Fichier %s pas trouv\351.", ZIL_NO_FILE, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_ZAF_MESSAGE_WINDOW_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "&OK", ZIL_MSG_OK, { 0 }},
	{ "&Oui", ZIL_MSG_YES, { 0 } },
	{ "&Non", ZIL_MSG_NO, { 0 } },
	{ "&Avorter", ZIL_MSG_ABORT, { 0 } },
	{ "&R\351essayer", ZIL_MSG_RETRY, { 0 } },
	{ "&Ignorer", ZIL_MSG_IGNORE, { 0 } },
	{ "A&nnuler", ZIL_MSG_CANCEL, { 0 } },
	{ "Ai&de", ZIL_MSG_HELP, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif
