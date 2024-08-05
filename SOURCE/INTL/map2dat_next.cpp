//	Zinc Interface Library - MAP2DAT.CPP
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


#include <string.h>
#include <ui_gen.hpp>

class MAP_CHARS
{
public:
	ZIL_UINT8 *from;
	ZIL_UINT8 *to;
	char *name;
};

#if !defined(MAP_NAME)

#include <stdio.h>
#if defined(ZIL_MACINTOSH)
#	include <console.h>
#endif
#define VERSION	"4.00"

typedef MAP_CHARS *(*MAP_FUNCTION)(void);

extern MAP_CHARS *_437_Initialize(void);
extern MAP_CHARS *_737_Initialize(void);
extern MAP_CHARS *_850_Initialize(void);
extern MAP_CHARS *_852_Initialize(void);
extern MAP_CHARS *_855_Initialize(void);
extern MAP_CHARS *_857_Initialize(void);
extern MAP_CHARS *_860_Initialize(void);
extern MAP_CHARS *_861_Initialize(void);
extern MAP_CHARS *_863_Initialize(void);
extern MAP_CHARS *_865_Initialize(void);
extern MAP_CHARS *_866_Initialize(void);
extern MAP_CHARS *_869_Initialize(void);
extern MAP_CHARS *_1250_Initialize(void);
extern MAP_CHARS *_1251_Initialize(void);
extern MAP_CHARS *_1252_Initialize(void);
extern MAP_CHARS *_1253_Initialize(void);
extern MAP_CHARS *_1254_Initialize(void);
extern MAP_CHARS *_1255_Initialize(void);
extern MAP_CHARS *_1256_Initialize(void);
extern MAP_CHARS *_MAC_Initialize(void);
extern MAP_CHARS *_NeXT_Initialize(void);

MAP_FUNCTION Initialize[] =
{
	_437_Initialize,
	_737_Initialize,
	_850_Initialize,
	_852_Initialize,
	_855_Initialize,
	_857_Initialize,
	_860_Initialize,
	_861_Initialize,
	_863_Initialize,
	_865_Initialize,
	_866_Initialize,
	_869_Initialize,
	_1250_Initialize,
	_1251_Initialize,
	_1252_Initialize,
	_1253_Initialize,
	_1254_Initialize,
	_1255_Initialize,
	_1256_Initialize,
	_MAC_Initialize,
	_NeXT_Initialize,
	NULL
};

static ZIL_ICHAR _pathRoot[] =
{
	ZIL_DIRECTORY_SEPARATOR,
	'Z','I','L','_','I','N','T','E','R','N','A','T','I','O','N','A','L',
	0
};
static ZIL_ICHAR _pathMap[] =
{
	'I','S','O',
	0
};

int main(int argc, char *argv[])
{
#if defined(ZIL_MACINTOSH)
	argc = ccommand(&argv);
#endif
	// Display version.
	printf("Version %s Copyright (C) 1991-1995 Zinc Software Incorporated.\n\n", VERSION);
	if (argc != 2)
	{
		printf("Usage: map2dat <filename>\n");
		return (1);
	}
	ZIL_STORAGE *storage = new ZIL_STORAGE(argv[1], UIS_OPENCREATE | UIS_READWRITE);
	storage->MkDir(_pathRoot);
	storage->ChDir(_pathRoot);
	storage->MkDir(_pathMap);
	storage->ChDir(_pathMap);
	for (int i = 0; Initialize[i]; i++)
	{
		MAP_CHARS *tmp = (Initialize[i])();
		storage->MkDir(tmp->name);
		storage->ChDir(tmp->name);
		ZIL_STORAGE_OBJECT *obj = new ZIL_STORAGE_OBJECT(*storage, "toHardware", ID_END, UIS_CREATE|UIS_READWRITE);
		obj->Store((ZIL_UINT8)0);
		obj->Store((ZIL_UINT8)255);
		obj->Store(tmp->to, sizeof(ZIL_UINT8), 256);
		delete obj;
		obj = new ZIL_STORAGE_OBJECT(*storage, "toISO", ID_END, UIS_CREATE|UIS_READWRITE);
		obj->Store((ZIL_UINT8)0);
		obj->Store((ZIL_UINT8)255);
		obj->Store(tmp->from, sizeof(ZIL_UINT8), 256);
		delete obj;
		delete tmp;
		storage->ChDir("..");
	}
	storage->Save();
	delete storage;
	return (0);
}

#else

#define str(s)		#s
#define xstr(s)		str(s)
#define append(a,b,c)	a##b##c
#define FILENAME(x)	append(map, x,.cpp)
#define FUNCTIONNAME(x)	append(_, x, _Initialize)

#undef ZIL_MSDOS
#undef ZIL_MSWINDOWS
#undef ZIL_OS2
#undef ZIL_MACINTOSH
#if defined (ZIL_MOTIF)
#	if (MAP_NAME == MAC)
#		include "mapmac.cpp"
#	elif (MAP_NAME == NeXT)
#		include "mapnext.cpp"
#	else
#		include xstr(FILENAME(MAP_NAME))
#	endif
#else
#	include xstr(FILENAME(MAP_NAME))
#endif

MAP_CHARS *FUNCTIONNAME(MAP_NAME)(void)
{
	MAP_CHARS *tmp = new MAP_CHARS;
	tmp->name = _MapName;
	tmp->to = _ISOToLocal;
	tmp->from = _LocalToISO;
	return tmp;
}
#endif
