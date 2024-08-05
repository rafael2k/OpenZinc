//	Zinc Interface Library - LOC2DAT.CPP
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
#define CP_OTHER	2

#include <string.h>
#include <ui_gen.hpp>

#if !defined(LOCALE_NAME)

#include <stdio.h>
#if defined(ZIL_MACINTOSH)
#	include <console.h>
#endif
#define VERSION	"4.00"

typedef ZIL_LOCALE *(*LOCALE_FUNCTION)(void);

#if defined(ZIL_UNICODE)
	extern ZIL_LOCALE *_cn_Initialize(void);
	extern ZIL_LOCALE *_gr_Initialize(void);
	extern ZIL_LOCALE *_jp_Initialize(void);
	extern ZIL_LOCALE *_kr_Initialize(void);
	extern ZIL_LOCALE *_tw_Initialize(void);
#else
	extern ZIL_LOCALE *_at_Initialize(void);
	extern ZIL_LOCALE *_ca_Initialize(void);
	extern ZIL_LOCALE *_cafr_Initialize(void);
	extern ZIL_LOCALE *_de_Initialize(void);
	extern ZIL_LOCALE *_dk_Initialize(void);
	extern ZIL_LOCALE *_es_Initialize(void);
	extern ZIL_LOCALE *_fi_Initialize(void);
	extern ZIL_LOCALE *_fr_Initialize(void);
	extern ZIL_LOCALE *_gb_Initialize(void);
	extern ZIL_LOCALE *_it_Initialize(void);
	extern ZIL_LOCALE *_mx_Initialize(void);
	extern ZIL_LOCALE *_nl_Initialize(void);
	extern ZIL_LOCALE *_no_Initialize(void);
	extern ZIL_LOCALE *_se_Initialize(void);
	extern ZIL_LOCALE *_us_Initialize(void);
#endif

LOCALE_FUNCTION Initialize[] = 
{
#if defined(ZIL_UNICODE)
	_cn_Initialize,	// China
	_gr_Initialize,	// Greece
	_jp_Initialize,	// Japan
	_kr_Initialize,	// Korea, Republic of
	_tw_Initialize,	// Taiwan
#else
	_at_Initialize,	// Austria
	_ca_Initialize,	// Canada
	_cafr_Initialize,	// Canada, French
	_de_Initialize,	// Germany
	_dk_Initialize,	// Denmark
	_es_Initialize,	// Spain
	_fi_Initialize,	// Finland
	_fr_Initialize,	// France
	_gb_Initialize,	// United Kingdom
	_it_Initialize,	// Italy
	_mx_Initialize,	// Mexico
	_nl_Initialize,	// Netherlands
	_no_Initialize,	// Norway
	_se_Initialize,	// Sweden
	_us_Initialize,	// United States
#endif
	ZIL_NULLF(LOCALE_FUNCTION)
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
	ZIL_I18N::defaultStorage = new ZIL_STORAGE_READ_ONLY(ZIL_I18N::i18nName);
	// Display version.
	printf("Version %s Copyright (C) 1991-1995 Zinc Software Incorporated.\n\n", VERSION);
	if (argc != 2)
	{
		printf("Usage: loc2dat <filename>\n");
		return (1);
	}
#if defined(ZIL_UNICODE)
	ZIL_STORAGE *storage = new ZIL_STORAGE(ZIL_INTERNATIONAL::ISOtoUNICODE(argv[1]), UIS_OPENCREATE | UIS_READWRITE);
#else
	ZIL_STORAGE *storage = new ZIL_STORAGE(argv[1], UIS_OPENCREATE | UIS_READWRITE);
#endif
	for (int i = 0; Initialize[i]; i++)
	{
		ZIL_LOCALE *tmp = (Initialize[i])();
		tmp->Store(storage, ZIL_NULLP(ZIL_STORAGE_OBJECT));
		delete tmp;
	}
	storage->Save();
	delete storage;
	return (0);
}

#else

#define str(s)		#s
#define xstr(s)		str(s)
#define append(a,b,c)	a##b##c
#define FILENAME(x)	append(loc_, x,.cpp)
#define FUNCTIONNAME(x)	append(_, x, _Initialize)


#undef ZIL_MSDOS
#undef ZIL_MSWINDOWS
#undef ZIL_OS2
#undef ZIL_MACINTOSH
#define LENGTHOF(x)	(sizeof(x)/sizeof((x)[0]))
#include xstr(FILENAME(LOCALE_NAME))

ZIL_LOCALE *FUNCTIONNAME(LOCALE_NAME)(void)
{
	ZIL_LOCALE *def = new ZIL_LOCALE;
	ZIL_INTERNATIONAL::strcpy(def->name, _defaultIsoLocaleName);
	def->data = _defaultLocaleElement;
//	def->allocated = FALSE;
//	def->defaults = TRUE;
	def->useCount = 0;
	return def;
}
#endif
