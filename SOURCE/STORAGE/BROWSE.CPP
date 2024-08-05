//	BROWSE.CPP - Recursively list directories and objects.
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

#if defined(sun) || defined(_IBM_RS6000) || defined(macintosh) || defined(__DECCXX) || defined(__NeXT__) || defined (__linux__)
#	include <errno.h>
#endif

#include "ui_gen.hpp"
#if defined(ZIL_MACINTOSH)
#	include <console.h>
#	define Z_STORE "::z_store.hpp"
#else
#	define Z_STORE "../z_store.hpp"
#endif
#include Z_STORE

#define LENGTHOF(x)	(sizeof(x)/sizeof((x)[0]))
#define INDENT		4

static int cflag = 0;
static int eflag = 0;

class ZIL_STORAGE_SUPPORT
{
public:
	static void PrintInfo(ZIL_STORAGE_READ_ONLY *f, ZIL_STATS_INFO *s, ZIL_ICHAR *name, int spaces);
};

void ZIL_STORAGE_SUPPORT::PrintInfo(ZIL_STORAGE_READ_ONLY *f, ZIL_STATS_INFO *s, ZIL_ICHAR *name, int spaces)
{
	if (eflag) {
		printf("%4d ", s->inum);
		printf("%c ", FlagSet(s->useCount, ZIL_DIRECTORY_TAG) ? 'd' : '-');
		printf("%4d ", s->useCount & ~ZIL_DIRECTORY_TAG);
	}
#if defined(ZIL_MACINTOSH)
	char *buff = cflag ? ctime((unsigned long *)&s->createTime) :
			     ctime((unsigned long *)&s->modifyTime);
#elif defined(__alpha)
	char *buff = cflag ? ctime((ZIL_INT32 *)&s->createTime) :
			     ctime((ZIL_INT32 *)&s->modifyTime);
#else
	char *buff = cflag ? ctime((time_t *)&s->createTime) :
			     ctime((time_t *)&s->modifyTime);
#endif
	buff[24] = '\0';
	printf("%s ", &buff[4]);
	printf("%7ld ", s->size);
	printf("%*s", eflag ? spaces : spaces+INDENT, "");
#if defined(ZIL_UNICODE)
	int uni = 0;
	for (int i=0; name[i]; i++)
		uni |= (name[i] >= 256);
	printf("%c ", (uni ? 'U' : ' '));
	for (i=0; name[i]; i++)
		printf("%c", name[i]);
#else
	printf("%-10s", name);
#endif
	printf("\n");
	if (eflag)
	{
		struct inode inode;
		f->RWInode(s->inum, &inode, ZIL_IREAD);
		printf("\tsize 0x%08x  create 0x%08x  modify 0x%08x\n", inode.size, inode.createTime, inode.modifyTime);
		printf("\tfragblk 0x%04x  usage 0x%04x  fragInd 0x%04x\n", inode.fragmentBlock, inode.useCount, inode.fragmentIndex);

		printf("\tBlocks");
		for (int i = 0; 1; )
		{
			printf("%6d", inode.direct[i]);
		if (i >= LENGTHOF(inode.direct) || inode.direct[i] == 0) break;
			i++;
			if (i % 10 == 0)
				printf("\n\t      ");
		}
		printf("\n");
		if (inode.sIndirect)
			printf("\tSBlock%6d\n", inode.sIndirect);
		if (inode.dIndirect)
			printf("\tDBlock%6d\n", inode.dIndirect);
	}
}

ZIL_ICHAR dot[2] = { '.', 0 };
ZIL_ICHAR dotdot[3] = { '.', '.', 0 };

void ListDir(ZIL_STORAGE_READ_ONLY *f, int spaces)
{
	ZIL_STORAGE_DIRECTORY *dir = f->OpenDir(dot);
	
	for (directoryEntry *current = dir->ReadDir(); current; current = dir->ReadDir())
	{
		if (!eflag && (ZIL_INTERNATIONAL::strcmp(current->stringID, dot) == 0 ||
			       ZIL_INTERNATIONAL::strcmp(current->stringID, dotdot) == 0))
			continue;
		ZIL_STORAGE_OBJECT_READ_ONLY *o =
			new ZIL_STORAGE_OBJECT_READ_ONLY(*f, current->stringID, 0);
		ZIL_STATS_INFO *s = o->Stats();
		ZIL_STORAGE_SUPPORT::PrintInfo(f, s, current->stringID, spaces);
		delete o;

		if (FlagSet(s->useCount, ZIL_DIRECTORY_TAG) &&
		    (ZIL_INTERNATIONAL::strcmp(current->stringID, dot) != 0 &&
		     ZIL_INTERNATIONAL::strcmp(current->stringID, dotdot) != 0))
		{
			f->ChDir(current->stringID);
			ListDir(f, spaces+INDENT);
			f->ChDir(dotdot);
		}
	}
	delete dir;
}

static void usage(void)
{
	printf("usage: browse [-ce] <filename>\n");
	exit(1);
}

static ZIL_ICHAR rootStr[] = { 'R', 'O', 'O', 'T', 0 };

int main(int argc, char **argv)
{
#if defined(ZIL_MACINTOSH)
	argc = ccommand(&argv);
#endif

	// Construct ZIL_INTERNATIONAL::defaultCharMap for broken linkers.
	ZIL_INTERNATIONAL::DefaultI18nInitialize();

	argc--; argv++;
	if (argc <= 0) usage();
	if (**argv == '-') {
		(*argv)++;
		while (**argv) {
			if (**argv == 'c') cflag = 1;
			else if (**argv == 'e') eflag = 1;
			else usage();
			(*argv)++;
		}
		argc--; argv++;
	}
	if (argc != 1)
		usage();
#if defined(ZIL_UNICODE)
	ZIL_ICHAR *fileName = ZIL_INTERNATIONAL::ISOtoUNICODE(*argv);
#else
	ZIL_ICHAR *fileName = *argv;
#endif
	ZIL_STORAGE_READ_ONLY *f = new ZIL_STORAGE_READ_ONLY(fileName);
	if (f->storageError != 0) {
		errno = f->storageError;
		perror(*argv);
		exit(2);
	}
	if (!eflag) {
		ZIL_STORAGE_OBJECT_READ_ONLY *o = new ZIL_STORAGE_OBJECT_READ_ONLY(*f, dot, 0);
		ZIL_STATS_INFO *s = o->Stats();
		ZIL_STORAGE_SUPPORT::PrintInfo(f, s, rootStr, -INDENT);
		delete o;
	}
	ListDir(f, 0);
	delete f;
	return 0;
}
