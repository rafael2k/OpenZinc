//	ZDUMP.CPP - Raw dump Zinc objects.
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
#include <ctype.h>

#include "ui_gen.hpp"
#if defined(ZIL_MACINTOSH)
#	include <console.h>
#endif

#define LENGTHOF(x)	(sizeof(x)/sizeof((x)[0]))

static void Dump(ZIL_STORAGE_OBJECT_READ_ONLY *o)
{
	int i, j, k;
	ZIL_UINT8 buff[16];

	j = 0;
	while ((k = o->Load(buff, sizeof(buff[0]), LENGTHOF(buff))) > 0) {
		printf("%04x  ", j);
		for (i=0; i < LENGTHOF(buff); i++) {
			if (i == (LENGTHOF(buff) >> 1)) printf("  ");
			if (i < k)
				printf("%02x ", buff[i]);
			else
				printf("   ");
		}
		printf("   |");
		for (i=0; i < LENGTHOF(buff); i++) {
			if (i == (LENGTHOF(buff) >> 1)) printf("|");
			if (i < k && isprint(buff[i]))
				printf("%c", buff[i]);
			else	
				printf(" ");
		}
		printf("|\n");
		j += LENGTHOF(buff);
	}
}

static void usage(void)
{
	printf("usage: zdump <filename> <objectname>\n");
	exit(0);
}

int main(int argc, char **argv)
{
#if defined(ZIL_MACINTOSH)
	argc = ccommand(&argv);
#endif

	// Construct ZIL_INTERNATIONAL::defaultCharMap for broken linkers.
	ZIL_INTERNATIONAL::DefaultI18nInitialize();

#if 0
	if (argc != 4) usage();
	ZIL_STORAGE_READ_ONLY *f = new ZIL_STORAGE_READ_ONLY(argv[1]);
	f->ChDir(argv[2]);
	ZIL_STORAGE_OBJECT_READ_ONLY *o = new ZIL_STORAGE_OBJECT_READ_ONLY(*f, argv[3], 0);
#else
	if (argc != 3)
		usage();
#if defined(ZIL_UNICODE)
	ZIL_ICHAR *fileName = ZIL_INTERNATIONAL::ISOtoUNICODE(argv[1]);
	ZIL_ICHAR *objName = ZIL_INTERNATIONAL::ISOtoUNICODE(argv[2]);
#else
	ZIL_ICHAR *fileName = argv[1];
	ZIL_ICHAR *objName = argv[2];
#endif
	ZIL_STORAGE_READ_ONLY *f = new ZIL_STORAGE_READ_ONLY(fileName);
	ZIL_STORAGE_OBJECT_READ_ONLY *o = new ZIL_STORAGE_OBJECT_READ_ONLY(*f, objName, 0);
#endif
	Dump(o);
	delete o;
	delete f;
	return 0;
}
