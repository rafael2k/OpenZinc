//	CPPATH.CPP - Recursively copy directories.
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

//	May be freely copied, used and distributed.

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include <ctype.h>
#include <errno.h>

#include "ui_gen.hpp"
#if defined(ZIL_MACINTOSH)
#	include <console.h>
#endif

#define LENGTHOF(x)	(sizeof(x)/sizeof((x)[0]))

ZIL_STORAGE_READ_ONLY *src;
ZIL_STORAGE *dst;

ZIL_ICHAR dot[2] = { '.', 0 };
ZIL_ICHAR dotdot[3] = { '.', '.', 0 };

#if defined(STRIP)
	ZIL_ICHAR CPP_DIR[] = { 'U', 'I', '_', 'C', 'P', 'P', 0 };
	ZIL_ICHAR HPP_DIR[] = { 'U', 'I', '_', 'H', 'P', 'P', 0 };
#endif

class ZIL_STORAGE_SUPPORT : public ZIL_INTERNATIONAL
{
public:
	static void CopyDir(void);
};

void ZIL_STORAGE_SUPPORT::CopyDir(void)
{
	ZIL_STORAGE_DIRECTORY *dir = src->OpenDir(dot);
	
	for (directoryEntry *current = dir->ReadDir(); current; current = dir->ReadDir())
	{
		if ((strcmp(current->stringID, dot) == 0 ||
		     strcmp(current->stringID, dotdot) == 0))
			continue;
#if defined(STRIP)
		if ((strcmp(current->stringID, CPP_DIR) == 0 ||
		     strcmp(current->stringID, HPP_DIR) == 0))
			continue;
#endif
		if (src->ChDir(current->stringID) >= 0) {
			dst->MkDir(current->stringID);
			dst->ChDir(current->stringID);
			CopyDir();
			src->ChDir(dotdot);
			dst->ChDir(dotdot);
		} else {
			ZIL_STORAGE_OBJECT_READ_ONLY *sobj =
				new ZIL_STORAGE_OBJECT_READ_ONLY(*src, current->stringID, 0);
			ZIL_STORAGE_OBJECT *dobj =
				new ZIL_STORAGE_OBJECT(*dst, current->stringID, sobj->objectID, UIS_CREATE|UIS_READWRITE);
			char *buff = new char[16384];
			int len;

			while ((len = sobj->Load(buff, 16384, 1)) > 0)
				dobj->Store(buff, len, 1);

			delete []buff;
			ZIL_STATS_INFO *info = sobj->Stats();
			dobj->SetCTime(info->createTime);
			dobj->SetMTime(info->modifyTime);
			delete sobj;
			delete dobj;
		}
	}
	delete dir;
}

static void usage(void)
{
#if defined(STRIP)
	printf("usage: strip <filename>\n");
#elif defined(DOGC)
	printf("usage: gc <filename>\n");
#else
	printf("usage: cppath <filename> <objectpath> <filename> <objectpath>\n");
#endif
	exit(1);
}

int main(int argc, char **argv)
{
#if defined(ZIL_MACINTOSH)
	argc = ccommand(&argv);
#endif

	// Construct ZIL_INTERNATIONAL::defaultCharMap for broken linkers.
	ZIL_INTERNATIONAL::DefaultI18nInitialize();

	ZIL_STORAGE_READ_ONLY::cacheSize = 240;
	argc--; argv++;
#if defined(DOGC) || defined(STRIP)
	if (argc != 1) usage();
#else
	if (argc != 4) usage();
#endif
#if defined(ZIL_UNICODE)
	ZIL_ICHAR *fileName = ZIL_INTERNATIONAL::ISOtoUNICODE(*argv);
#else
	ZIL_ICHAR *fileName = *argv;
#endif
	src = new ZIL_STORAGE_READ_ONLY(fileName);
	if (src->storageError != 0) {
		errno = src->storageError;
		perror(*argv);
		exit(2);
	}
#if defined(DOGC) || defined(STRIP)
#	if defined(ZIL_UNICODE)
		fileName = ZIL_INTERNATIONAL::ISOtoUNICODE("tmp.$$$");
#	else
		fileName = "tmp.$$$";
#	endif
	dst = new ZIL_STORAGE(fileName, UIS_READWRITE|UIS_CREATE);
#else
	argv++;
#	if defined(ZIL_UNICODE)
		ZIL_ICHAR *dirName = ZIL_INTERNATIONAL::ISOtoUNICODE(*argv);
#	else
		ZIL_ICHAR *dirName = *argv;
#	endif
	if (src->ChDir(dirName) < 0)
	{
		errno = ENOENT;
		perror(*argv);
		exit(2);
	}
	argv++;
#	if defined(ZIL_UNICODE)
		fileName = ZIL_INTERNATIONAL::ISOtoUNICODE(*argv);
#	else
		fileName = *argv;
#	endif
	dst = new ZIL_STORAGE(fileName, UIS_READWRITE|UIS_OPENCREATE);
#endif
	if (dst->storageError != 0) {
		errno = src->storageError;
		perror(*argv);
		delete src;
		delete dst;
		exit(2);
	}
#if !(defined(DOGC) || defined(STRIP))
	argv++;
#	if defined(ZIL_UNICODE)
		dirName = ZIL_INTERNATIONAL::ISOtoUNICODE(*argv);
#	else
		dirName = *argv;
#	endif
	dst->MkDir(dirName);
	if (dst->ChDir(dirName) < 0)
	{
		errno = ENOENT;
		perror(*argv);
		exit(2);
	}
#endif
	ZIL_STORAGE_SUPPORT::CopyDir();
	delete src;
#if defined(DOGC) || defined(STRIP)
#	if defined(ZIL_UNICODE)
		fileName = ZIL_INTERNATIONAL::ISOtoUNICODE(*argv);
#	else
		fileName = *argv;
#	endif
	dst->SaveAs(fileName, 9);
#else
	dst->Save(1);
#endif
	delete dst;
	return 0;
}
