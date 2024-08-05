//	Zinc Interface Library - LANG2DAT.CPP
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


#define CP_ISO8859_1	1
#define CP_UNICODE	2
#define CP_OTHER	3

#include <string.h>
#include <ui_win.hpp>

#if !defined(LANGUAGE_NAME)

#include <stdio.h>
#if defined(ZIL_MACINTOSH)
#	include <console.h>
#endif
#define VERSION	"4.00"

#if defined(__BCPLUSPLUS__) | defined(__TCPLUSPLUS__)
extern unsigned _stklen = 32767;
#endif

typedef void (*LANGUAGE_FUNCTION)(ZIL_STORAGE *storage);

#if defined(ZIL_UNICODE)
	extern void _el_Initialize(ZIL_STORAGE *storage);
	extern void _ja_Initialize(ZIL_STORAGE *storage);
	extern void _ko_Initialize(ZIL_STORAGE *storage);
#else
	extern void _ca_Initialize(ZIL_STORAGE *storage);
	extern void _da_Initialize(ZIL_STORAGE *storage);
	extern void _de_Initialize(ZIL_STORAGE *storage);
	extern void _en_Initialize(ZIL_STORAGE *storage);
	extern void _es_Initialize(ZIL_STORAGE *storage);
	extern void _fi_Initialize(ZIL_STORAGE *storage);
	extern void _fr_Initialize(ZIL_STORAGE *storage);
	extern void _it_Initialize(ZIL_STORAGE *storage);
	extern void _nl_Initialize(ZIL_STORAGE *storage);
	extern void _no_Initialize(ZIL_STORAGE *storage);
	extern void _sv_Initialize(ZIL_STORAGE *storage);
#endif

LANGUAGE_FUNCTION Initialize[] = 
{
#if defined(ZIL_UNICODE)
	_el_Initialize,	// Greek
	_ja_Initialize,	// Japanese
	_ko_Initialize,	// Korean
#else
	_ca_Initialize,	// Catalan
	_da_Initialize,	// Danish
	_de_Initialize,	// German
	_en_Initialize,	// English
	_es_Initialize,	// Spanish
	_fi_Initialize,	// Finnish
	_fr_Initialize,	// French
	_it_Initialize,	// Italian
	_nl_Initialize,	// Dutch
	_no_Initialize,	// Norwegian
	_sv_Initialize,	// Swedish
#endif
	ZIL_NULLF(LANGUAGE_FUNCTION)
};

int main(int argc, char *argv[])
{
#if defined(ZIL_MACINTOSH)
	argc = ccommand(&argv);
#endif
	ZIL_INTERNATIONAL::MachineName();
#if defined(ZIL_UNICODE)
	ZIL_ICHAR *pathName = ZIL_INTERNATIONAL::ISOtoUNICODE(argv[0]);
#else
	ZIL_ICHAR *pathName = strdup(argv[0]);
#endif
	ZIL_STORAGE_READ_ONLY::searchPath = new UI_PATH(pathName, TRUE);
	// Display version.
	printf("Version %s Copyright (C) 1991-1995 Zinc Software Incorporated.\n\n", VERSION);
	if (argc != 2)
	{
		printf("Usage: lang2dat <filename>\n");
		return (1);
	}
#if defined(ZIL_UNICODE)
	ZIL_STORAGE *storage = new ZIL_STORAGE(ZIL_INTERNATIONAL::ISOtoUNICODE(argv[1]), UIS_OPENCREATE | UIS_READWRITE);
#else
	ZIL_STORAGE *storage = new ZIL_STORAGE(argv[1], UIS_OPENCREATE | UIS_READWRITE);
#endif
	ZIL_I18N::defaultStorage = storage;
	for (int i = 0; Initialize[i]; i++)
		Initialize[i](storage);
	storage->Save();
	delete storage;
	return (0);
}

#else

#define str(s)		#s
#define xstr(s)		str(s)
#define append(a,b,c)	a##b##c
#define FILENAME(x)	append(lang_, x,.cpp)
#define FUNCTIONNAME(x)	append(_, x, _Initialize)

#define ZIL_LANGUAGE_DATA
#include xstr(FILENAME(LANGUAGE_NAME))
#undef ZIL_LANGUAGE_DATA

static ZIL_LANGUAGE *SetLanguageStrings(const ZIL_ICHAR *className, ZIL_PRIVATE_LANGUAGE_ELEMENT *defaultLanguage)
{
	ZIL_LANGUAGE *def = new ZIL_LANGUAGE;
	def->className = className;
	ZIL_INTERNATIONAL::strcpy(def->name, isoLanguageName);
//	for (int len=0; defaultLanguage[len].text; len++)
//		;
//two lines above changed to three lines below to meet current
//scoping rules for for
	int len;
	for (len=0; defaultLanguage[len].text; len++)
		;
	def->noOfElements = len;
#if (defined(ZIL_UNICODE) && (langCodeset == CP_ISO8859_1))
	def->data = new ZIL_LANGUAGE_ELEMENT[len];
	for (int i = 0; i < len; i++)
	{
		def->data[i].text = ZIL_INTERNATIONAL::ISOtoUNICODE(defaultLanguage[i].text);
		def->data[i].numberID = defaultLanguage[i].numberID;
		ZIL_INTERNATIONAL::ISOtoUNICODE(defaultLanguage[i].stringID, def->data[i].stringID);
	}
//	def->allocated = TRUE;
#elif (!defined(ZIL_UNICODE) && (langCodeset == UNICODE))
	????;
#elif (langCodeset == CP_ISO8859_1 || langCodeset == UNICODE)
	def->data = defaultLanguage;
//	def->allocated = FALSE;
#else
	def->data = new ZIL_LANGUAGE_ELEMENT[len];
	ZIL_MAP_CHARS *map = new ZIL_MAP_CHARS(ZIL_INTERNATIONAL::ISOtoUNICODE(langCodesetName), ZIL_INTERNATIONAL::machineName);
	for (int i = 0; i < len; i++)
	{
		def->data[i].text = map->UnMapText(defaultLanguage[i].text);
		def->data[i].numberID = defaultLanguage[i].numberID;
		map->UnMapText(defaultLanguage[i].stringID, def->data[i].stringID);
	}
	delete map;
//	def->allocated = TRUE;
#endif
//	def->defaults = TRUE;
	def->useCount = 0;
	return def;
}

static void Do_Utime(ZIL_STORAGE *storage)
{
#define ZIL_UTIME_DATA
#include xstr(FILENAME(LANGUAGE_NAME))
#undef ZIL_UTIME_DATA
	ZIL_LANGUAGE *tmp = SetLanguageStrings(ZIL_UTIME::_dayName, DAY_STRINGS);
	tmp->Store(storage, ZIL_NULLP(ZIL_STORAGE_OBJECT));
	tmp = SetLanguageStrings(ZIL_UTIME::_monthName, MONTH_STRINGS);
	tmp->Store(storage, ZIL_NULLP(ZIL_STORAGE_OBJECT));
	tmp = SetLanguageStrings(ZIL_UTIME::_timeName, TIME_STRINGS);
	tmp->Store(storage, ZIL_NULLP(ZIL_STORAGE_OBJECT));
	delete tmp;
}

static void Do_Bignum(ZIL_STORAGE *storage)
{
#define ZIL_UIW_BIGNUM_DATA
#include xstr(FILENAME(LANGUAGE_NAME))
#undef ZIL_UIW_BIGNUM_DATA
	ZIL_LANGUAGE *tmp = SetLanguageStrings(UIW_BIGNUM::_className, STRINGS);
	tmp->Store(storage, ZIL_NULLP(ZIL_STORAGE_OBJECT));
	delete tmp;
}

static void Do_Int(ZIL_STORAGE *storage)
{
#define ZIL_UIW_INT_DATA
#include xstr(FILENAME(LANGUAGE_NAME))
#undef ZIL_UIW_INT_DATA
	ZIL_LANGUAGE *tmp = SetLanguageStrings(UIW_INTEGER::_className, STRINGS);
	tmp->Store(storage, ZIL_NULLP(ZIL_STORAGE_OBJECT));
	delete tmp;
}

static void Do_Real(ZIL_STORAGE *storage)
{
#define ZIL_UIW_REAL_DATA
#include xstr(FILENAME(LANGUAGE_NAME))
#undef ZIL_UIW_REAL_DATA
	ZIL_LANGUAGE *tmp = SetLanguageStrings(UIW_REAL::_className, STRINGS);
	tmp->Store(storage, ZIL_NULLP(ZIL_STORAGE_OBJECT));
	delete tmp;
}

static void Do_Date(ZIL_STORAGE *storage)
{
#define ZIL_UIW_DATE_DATA
#include xstr(FILENAME(LANGUAGE_NAME))
#undef ZIL_UIW_DATE_DATA
	ZIL_LANGUAGE *tmp = SetLanguageStrings(UIW_DATE::_className, STRINGS);
	tmp->Store(storage, ZIL_NULLP(ZIL_STORAGE_OBJECT));
	delete tmp;
}

static void Do_Time(ZIL_STORAGE *storage)
{
#define ZIL_UIW_TIME_DATA
#include xstr(FILENAME(LANGUAGE_NAME))
#undef ZIL_UIW_TIME_DATA
	ZIL_LANGUAGE *tmp = SetLanguageStrings(UIW_TIME::_className, STRINGS);
	tmp->Store(storage, ZIL_NULLP(ZIL_STORAGE_OBJECT));
	delete tmp;
}

static void Do_ErrorSystem(ZIL_STORAGE *storage)
{
#define ZIL_UI_ERROR_SYSTEM_DATA
#include xstr(FILENAME(LANGUAGE_NAME))
#undef ZIL_UI_ERROR_SYSTEM_DATA
	ZIL_LANGUAGE *tmp = SetLanguageStrings(UI_ERROR_SYSTEM::_className, STRINGS);
	tmp->Store(storage, ZIL_NULLP(ZIL_STORAGE_OBJECT));
	delete tmp;
}

static void Do_HelpSystem(ZIL_STORAGE *storage)
{
#define ZIL_UI_HELP_SYSTEM_DATA
#include xstr(FILENAME(LANGUAGE_NAME))
#undef ZIL_UI_HELP_SYSTEM_DATA
	ZIL_LANGUAGE *tmp = SetLanguageStrings(UI_HELP_SYSTEM::_className, STRINGS);
	tmp->Store(storage, ZIL_NULLP(ZIL_STORAGE_OBJECT));
	delete tmp;
}

static void Do_SystemButton(ZIL_STORAGE *storage)
{
#define ZIL_UIW_SYSTEM_BUTTON_DATA
#include xstr(FILENAME(LANGUAGE_NAME))
#undef ZIL_UIW_SYSTEM_BUTTON_DATA
	ZIL_LANGUAGE *tmp = SetLanguageStrings(UIW_SYSTEM_BUTTON::_className, STRINGS);
	tmp->Store(storage, ZIL_NULLP(ZIL_STORAGE_OBJECT));
	delete tmp;
}

static void Do_Window(ZIL_STORAGE *storage)
{
#define ZIL_UIW_WINDOW_DATA
#include xstr(FILENAME(LANGUAGE_NAME))
#undef ZIL_UIW_WINDOW_DATA
	ZIL_LANGUAGE *tmp = SetLanguageStrings(UIW_WINDOW::_className, STRINGS);
	tmp->Store(storage, ZIL_NULLP(ZIL_STORAGE_OBJECT));
	delete tmp;
}

static void Do_Message_Window(ZIL_STORAGE *storage)
{
#define ZIL_ZAF_MESSAGE_WINDOW_DATA
#include xstr(FILENAME(LANGUAGE_NAME))
#undef ZIL_ZAF_MESSAGE_WINDOW_DATA
	ZIL_LANGUAGE *tmp = SetLanguageStrings(ZAF_MESSAGE_WINDOW::_className, STRINGS);
	tmp->Store(storage, ZIL_NULLP(ZIL_STORAGE_OBJECT));
	delete tmp;
}

void FUNCTIONNAME(LANGUAGE_NAME)(ZIL_STORAGE *storage)
{
	Do_Utime(storage);
	Do_Bignum(storage);
	Do_Int(storage);
	Do_Real(storage);
	Do_Date(storage);
	Do_Time(storage);
	Do_ErrorSystem(storage);
	Do_HelpSystem(storage);
	Do_SystemButton(storage);
	Do_Window(storage);
	Do_Message_Window(storage);
}
#endif
