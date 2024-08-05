//	BROWSE.CPP - Recursively list directories and objects.
//	COPYRIGHT (C) 1990-1994.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//	May be freely copied, used and distributed.

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include <ctype.h>

#if defined(sun) || defined(_IBM_RS6000) || defined(macintosh) || defined(__DECCXX)
#	include <errno.h>
#endif

#include "ui_gen.hpp"
#if defined(ZIL_MACINTOSH)
#	include <console.h>
#	define Z_STORE "::z_store.hpp"
#else
#	define Z_STORE "z_store.hpp"
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
		printf("\tBlocks");
		for (int i=0; i < LENGTHOF(inode.direct) && inode.direct[i]; i++)
		{
			printf("%6d", inode.direct[i]);
			if ((i+1) % 10 == 0)
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
//	directoryEntry *current = dir->ReadDir();
	{
		if (!eflag && (ZIL_INTERNATIONAL::strcmp(current->stringID, dot) == 0 ||
			       ZIL_INTERNATIONAL::strcmp(current->stringID, dotdot) == 0))
			continue;
//			return;
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
//			ListDir(f, spaces+INDENT);
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
