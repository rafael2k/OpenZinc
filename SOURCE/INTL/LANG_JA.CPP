//	Zinc Interface Library - LANG_JA.CPP
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
#	define langCodeset	CP_OTHER
#	define langCodesetName	"IBM_932"
	// Language definitions for JAPANESE (JA).
	static ZIL_ICHAR ZIL_FARDATA isoLanguageName[] = { 'j','a',0 };
#endif

#if defined(ZIL_UTIME_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA DAY_STRINGS[] =
{
	{ "", 0xffff, { 0 } },
	{ "���j��",	ZIL_DAY_1, { 0 } },
	{ "���j��",	ZIL_DAY_2, { 0 } },
	{ "�Ηj��",	ZIL_DAY_3, { 0 } },
	{ "���j��",	ZIL_DAY_4, { 0 } },
	{ "�ؗj��",	ZIL_DAY_5, { 0 } },
	{ "��j��",	ZIL_DAY_6, { 0 } },
	{ "�y�j��",	ZIL_DAY_7, { 0 } },
	{ "��", ZIL_SHDAY_1, { 0 } },
	{ "��", ZIL_SHDAY_2, { 0 } },
	{ "��", ZIL_SHDAY_3, { 0 } },
	{ "��", ZIL_SHDAY_4, { 0 } },
	{ "��", ZIL_SHDAY_5, { 0 } },
	{ "��", ZIL_SHDAY_6, { 0 } },
	{ "�y", ZIL_SHDAY_7, { 0 } },
	{ "��", ZIL_ABDAY_1, { 0 } },
	{ "��", ZIL_ABDAY_2, { 0 } },
	{ "��", ZIL_ABDAY_3, { 0 } },
	{ "��", ZIL_ABDAY_4, { 0 } },
	{ "��", ZIL_ABDAY_5, { 0 } },
	{ "��", ZIL_ABDAY_6, { 0 } },
	{ "�y", ZIL_ABDAY_7, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA MONTH_STRINGS[] =
{
	{ "", 0xffff, { 0 } },
	{ "�P��",	ZIL_MON_1, { 0 }  },
	{ "�Q��",	ZIL_MON_2, { 0 }  },
	{ "�R��",	ZIL_MON_3, { 0 }  },
	{ "�S��",	ZIL_MON_4, { 0 }  },
	{ "�T��",	ZIL_MON_5, { 0 }  },
	{ "�U��",	ZIL_MON_6, { 0 }  },
	{ "�V��",	ZIL_MON_7, { 0 }  },
	{ "�W��",	ZIL_MON_8, { 0 }  },
	{ "�X��",	ZIL_MON_9, { 0 }  },
	{ "�P�O��",	ZIL_MON_10, { 0 } },
	{ "�P�P��",	ZIL_MON_11, { 0 } },
	{ "�P�Q��",	ZIL_MON_12, { 0 } },
	{ "1��",	ZIL_SHMON_1, { 0 }  },
	{ "2��",	ZIL_SHMON_2, { 0 }  },
	{ "3��",	ZIL_SHMON_3, { 0 }  },
	{ "4��",	ZIL_SHMON_4, { 0 }  },
	{ "5��",	ZIL_SHMON_5, { 0 }  },
	{ "6��",	ZIL_SHMON_6, { 0 }  },
	{ "7��",	ZIL_SHMON_7, { 0 }  },
	{ "8��",	ZIL_SHMON_8, { 0 }  },
	{ "9��",	ZIL_SHMON_9, { 0 }  },
	{ "10��",	ZIL_SHMON_10, { 0 } },
	{ "11��",	ZIL_SHMON_11, { 0 } },
	{ "12��",	ZIL_SHMON_12, { 0 } },
	{ "1��",	ZIL_ABMON_1, { 0 }  },
	{ "2��",	ZIL_ABMON_2, { 0 }  },
	{ "3��",	ZIL_ABMON_3, { 0 }  },
	{ "4��",	ZIL_ABMON_4, { 0 }  },
	{ "5��",	ZIL_ABMON_5, { 0 }  },
	{ "6��",	ZIL_ABMON_6, { 0 }  },
	{ "7��",	ZIL_ABMON_7, { 0 }  },
	{ "8��",	ZIL_ABMON_8, { 0 }  },
	{ "9��",	ZIL_ABMON_9, { 0 }  },
	{ "10��",	ZIL_ABMON_10, { 0 } },
	{ "11��",	ZIL_ABMON_11, { 0 } },
	{ "12��",	ZIL_ABMON_12, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA TIME_STRINGS[] =
{
	{ "", 0xffff, { 0 } },
	{ "A.M.", ZIL_AM, { 0 } },
	{ "P.M.", ZIL_PM, { 0 } },
	{ "xxxx", ZIL_TZ, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_UIW_BIGNUM_DATA) || defined(ZIL_UIW_INT_DATA) || defined(ZIL_UIW_REAL_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "���l %s �͕s���Ȓl�ł��D", NMI_INVALID, { 0 } },
	{ "���l %s �́A%s �͈̔͊O�ł��D", NMI_OUT_OF_RANGE, { 0 } },
	{ "���l %s �́A%s ��菬���߂��܂��D", NMI_LESS_THAN_RANGE, { 0 } },
	{ "���l %s �́A%s ���傫�߂��܂��D", NMI_GREATER_THAN_RANGE, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_UIW_DATE_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "���t %s �́A�s���ȃt�H�[�}�b�g�ł��D", DTI_INVALID, { 0 } },
	{ "���t %s �̌������m�ł͂���܂���D", DTI_AMBIGUOUS, { 0 } },
	{ "���t %s �̌�������������܂���D", DTI_INVALID_NAME, { 0 } },
	{ "���t����͂��Ă��������D", DTI_VALUE_MISSING, { 0 } },
	{ "���t %s �́A%s �͈̔͊O�ł��D", DTI_OUT_OF_RANGE, { 0 } },
	{ "���t %s �́A%s ���O�ł��D", DTI_LESS_THAN_RANGE, { 0 } },
	{ "���t %s �́A%s ����ł��D", DTI_GREATER_THAN_RANGE, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_UIW_TIME_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "���� %s �́A�s���ȃt�H�[�}�b�g�ł��D", TMI_INVALID, { 0 } },
	{ "��������͂��Ă��������D", TMI_VALUE_MISSING, { 0 } },
	{ "���� %s �́A %s �͈̔͊O�ł��D", TMI_OUT_OF_RANGE, { 0 } },
	{ "���� %s �́A%s ���O�ł��D", TMI_LESS_THAN_RANGE, { 0 } },
	{ "���� %s �́A%s ����ł��D", TMI_GREATER_THAN_RANGE, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_UI_ERROR_SYSTEM_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "�G���[", MSG_TITLE, { 0 } },
	{ "&OK", MSG_OK, { 0 } },
	{ "���(&C)", MSG_CANCEL, { 0 } },
	{ "ASTERISK", MSG_ICONNAME, { 0 } },
	{ "�ړ�(&M)", MSG_MOVE, { 0 } },
	{ "����(&C)\tAlt+F4", MSG_CLOSE, { 0 } },
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
	{ "�w���v���", MSG_ICONTITLE, { 0 } },
	{ "QUESTION", MSG_ICONNAME, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_UIW_SYSTEM_BUTTON_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "���̑傫���ɖ߂�(&R)", MNIF_RESTORE, { 0 } },	// S_RESTORE
	{ "�ړ�(&M)", MNIF_MOVE, { 0 } },		// S_MOVE
	{ "�T�C�Y�ύX(&S)", MNIF_SIZE, { 0 } },		// S_SIZE
	{ "�A�C�R����(&N)", MNIF_MINIMIZE, { 0 } },	// S_MINIMIZE
	{ "�ő�\\��(&X)", MNIF_MAXIMIZE, { 0 } },	// S_MAXIMIZE
	{ "", MNIF_SEPARATOR, { 0 } },
	{ "����(&C)", MNIF_CLOSE, { 0 } },	 // S_CLOSE
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_UIW_WINDOW_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "ERROR", 0xffff, { 0 } },
	{ "���m�̃E�B���h�E �I�u�W�F�N�g�ł��D", ZIL_UNK_OBJ, { 0 } },
	{ "�I�u�W�F�N�g %s ��������܂���D", ZIL_NO_OBJ, { 0 } },
	{ "�t�@�C�� %s ��������܂���D", ZIL_NO_FILE, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif

#if defined(ZIL_ZAF_MESSAGE_WINDOW_DATA)
static ZIL_PRIVATE_LANGUAGE_ELEMENT ZIL_FARDATA STRINGS[] =
{
	{ "����(&O)", ZIL_MSG_OK, { 0 }},
	{ "�͂�(&Y)", ZIL_MSG_YES, { 0 } },
	{ "������(&N)", ZIL_MSG_NO, { 0 } },
	{ "���~����(&A)", ZIL_MSG_ABORT, { 0 } },
	{ "�����x(&R)", ZIL_MSG_RETRY, { 0 } },
	{ "��������(&I)", ZIL_MSG_IGNORE, { 0 } },
	{ "������(&C)", ZIL_MSG_CANCEL, { 0 } },
	{ "�w���v(&H)", ZIL_MSG_HELP, { 0 } },
	{ ZIL_NULLP(char), 0xffff, { 0 } }
};
#endif
