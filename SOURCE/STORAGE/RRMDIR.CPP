//	RRMDIR.CPP - Recursively remove directories.
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
#include <string.h>

#include "ui_gen.hpp"
#if defined(ZIL_MACINTOSH)
#	include <console.h>
#endif

ZIL_ICHAR dot[2] = { '.', 0 };
ZIL_ICHAR dotdot[3] = { '.', '.', 0 };
ZIL_ICHAR tildechar[2] = { '~', 0 };

int RRmDir(ZIL_STORAGE *f, const ZIL_ICHAR *name)
{
	ZIL_STORAGE_DIRECTORY *dir = f->OpenDir(name);
	if (dir == ZIL_NULLP(ZIL_STORAGE_DIRECTORY))
		return -1;
	for (directoryEntry *current = dir->ReadDir();
	            current; current = dir->ReadDir())
	{
		if ((ZIL_INTERNATIONAL::strcmp(current->stringID, dot) == 0 ||
		     ZIL_INTERNATIONAL::strcmp(current->stringID, dotdot) == 0))
			continue;
		ZIL_ICHAR path[ZIL_MAXPATHLEN];
		ZIL_INTERNATIONAL::strcpy(path, name);
		ZIL_INTERNATIONAL::strcat(path, tildechar);
		ZIL_INTERNATIONAL::strcat(path, current->stringID);
		if (RRmDir(f, path) < 0)
			if (f->DestroyObject(path) < 0)
				return -1;
//		dir->RewindDir();
	}
	delete dir;
	f->RmDir(name);
	f->storageError = 0;
	return 0;
}

static void usage(void)
{
	printf("usage: rrmdir <filename> <pathname>\n");
	exit(1);
}

int main(int argc, char **argv)
{
#if defined(ZIL_MACINTOSH)
	argc = ccommand(&argv);
#endif

	// Construct ZIL_INTERNATIONAL::defaultCharMap for broken linkers.
	ZIL_INTERNATIONAL::DefaultI18nInitialize();

	if (argc != 3)
		usage();
#if defined(ZIL_UNICODE)
	ZIL_ICHAR *fileName = ZIL_INTERNATIONAL::ISOtoUNICODE(argv[1]);
	ZIL_ICHAR *objName = ZIL_INTERNATIONAL::ISOtoUNICODE(argv[2]);
#else
	ZIL_ICHAR *fileName = argv[1];
	ZIL_ICHAR *objName = argv[2];
#endif
	ZIL_STORAGE *f = new ZIL_STORAGE(fileName, UIS_READWRITE);
	if (RRmDir(f, objName) >= 0)
		f->Save(1);
	delete f;
	return 0;
}
