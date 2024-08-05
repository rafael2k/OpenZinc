//	CPPATH.CPP - Recursively copy directories.
//	COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//	May be freely copied, used and distributed.

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include <ctype.h>
#include <errno.h>

#include "ui_gen.hpp"

#define LENGTHOF(x)	(sizeof(x)/sizeof((x)[0]))

ZIL_STORAGE_READ_ONLY *src;
ZIL_STORAGE *dst;

ZIL_ICHAR dot[2] = { '.', 0 };
ZIL_ICHAR dotdot[3] = { '.', '.', 0 };

class ZIL_STORAGE_SUPPORT : public ZIL_INTERNATIONAL
{
public:
	static void CopyDir(void);
};

struct nameOfFile
{
	ZIL_ICHAR *name;
};

nameOfFile names[83] =
{
	{"HELP_TQ2_REF_D_TKSEQ"},
	{"HELP_TQ2_REF_D_TKSIG"},
	{"HELP_TQ2_REF_D_USDO"},
	{"HELP_TQ2_TECH_CONTACT"},
	{"HELP_TQ2_TECH_CONTEL"},
	{"HELP_TQ2_VER"},
	{"HELP_TQ3_BCR3"},
	{"HELP_TQ3_BCR5"},
	{"HELP_TQ3_BCR6"},
	{"HELP_TQ3_CCLASS"},
	{"HELP_TQ3_CCNA"},
	{"HELP_TQ3_CIC"},
	{"HELP_TQ3_COIN_EA"},
	{"HELP_TQ3_ICSC"},
	{"HELP_TQ3_ICSC_CONTACT"},
	{"HELP_TQ3_ICSC_TEL"},
	{"HELP_TQ3_INTER"},
	{"HELP_TQ3_INTRA"},
	{"HELP_TQ3_PON"},
	{"HELP_TQ3_TECH_CONTACT"},
	{"HELP_TQ3_TECH_CONT_TEL"},
	{"HELP_TQ3_TECH_CON_TEL"},
	{"HELP_TQ3_VER"},
	{"HELP_TSR1_1004_1"},
	{"HELP_TSR1_1004_EML_A"},
	{"HELP_TSR1_1004_EML_Z"},
	{"HELP_TSR1_ACTL"},
	{"HELP_TSR1_ADT"},
	{"HELP_TSR1_BAL_1"},
	{"HELP_TSR1_CCNA"},
	{"HELP_TSR1_CITY"},
	{"HELP_TSR1_CKR"},
	{"HELP_TSR1_CMN"},
	{"HELP_TSR1_CMN_1"},
	{"HELP_TSR1_CNT"},
	{"HELP_TSR1_CNT_1"},
	{"HELP_TSR1_DCC"},
	{"HELP_TSR1_DPB"},
	{"HELP_TSR1_DTSD"},
	{"HELP_TSR1_D_TSENT"},
	{"HELP_TSR1_ECAN"},
	{"HELP_TSR1_ECCKT"},
	{"HELP_TSR1_ECO"},
	{"HELP_TSR1_EDD"},
	{"HELP_TSR1_FETL"},
	{"HELP_TSR1_FLOOR"},
	{"HELP_TSR1_FRS"},
	{"HELP_TSR1_GAS"},
	{"HELP_TSR1_GAS_1"},
	{"HELP_TSR1_ICSC"},
	{"HELP_TSR1_IC_MCO"},
	{"HELP_TSR1_IDT"},
	{"HELP_TSR1_IMN"},
	{"HELP_TSR1_NVT"},
	{"HELP_TSR1_OTH"},
	{"HELP_TSR1_PON"},
	{"HELP_TSR1_REMARKS"},
	{"HELP_TSR1_RHJ"},
	{"HELP_TSR1_ROOM"},
	{"HELP_TSR1_ROTL"},
	{"HELP_TSR1_ROTY"},
	{"HELP_TSR1_SCN"},
	{"HELP_TSR1_ST"},
	{"HELP_TSR1_STREET"},
	{"HELP_TSR1_TACT"},
	{"HELP_TSR1_TBAN"},
	{"HELP_TSR1_TCHAT"},
	{"HELP_TSR1_TCONTEL"},
	{"HELP_TSR1_TCON_TEL"},
	{"HELP_TSR1_TESTCON"},
	{"HELP_TSR1_VER"},
	{"HELP_TSR1_ZIP"},
	{"HELP_TSR2_1004_TAL"},
	{"HELP_TSR2_1004_TML"},
	{"HELP_TSR2_1004_TTL"},
	{"HELP_TSR2_2804_TAL"},
	{"HELP_TSR2_2804_TML"},
	{"HELP_TSR2_2804_TTL"},
	{"HELP_TSR2_404_TAL"},
	{"HELP_TSR2_404_TML"},
	{"HELP_TSR2_404_TTL"},
	{"HELP_TSR2_BAL_ERL_A"},
	{"HELP_TSR2_BAL_ERL_Z"}
};

void ZIL_STORAGE_SUPPORT::CopyDir(void)
{
	ZIL_STORAGE_DIRECTORY *dir = src->OpenDir(dot);

	for (int i = 0; i < 83; i++)
	{
			ZIL_STORAGE_OBJECT_READ_ONLY *sobj =
				new ZIL_STORAGE_OBJECT_READ_ONLY(*src, names[i].name, 0);
			ZIL_STORAGE_OBJECT *dobj =
				new ZIL_STORAGE_OBJECT(*dst, names[i].name, sobj->objectID, UIS_CREATE|UIS_READWRITE);
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
	delete dir;
}

static void usage(void)
{
	printf("usage: cppath <filename> <objectpath> <filename> <objectpath>\n");
	exit(1);
}

int main(int argc, char **argv)
{
	// Construct ZIL_INTERNATIONAL::defaultCharMap for broken linkers.
	ZIL_INTERNATIONAL::DefaultI18nInitialize();

	ZIL_STORAGE_READ_ONLY::cacheSize = 240;
	argc--; argv++;
//	if (argc != 4) usage();
	ZIL_ICHAR *fileName = *argv;
	src = new ZIL_STORAGE_READ_ONLY("isi.dat");
	if (src->storageError != 0) {
		errno = src->storageError;
		perror(*argv);
		exit(2);
	}
//	argv++;

	ZIL_ICHAR *dirName = "UI_HELP";

printf("dirName = %s\n", dirName);
	if (src->ChDir(dirName) < 0)
	{
printf("Bad dir ");		
		errno = ENOENT;
		perror(dirName);
		exit(2);
	}
//	argv++;
//	fileName = *argv;
	dst = new ZIL_STORAGE("newisi.dat", UIS_READWRITE|UIS_OPENCREATE);
	if (dst->storageError != 0) {
		errno = src->storageError;
		perror(*argv);
		delete src;
		delete dst;
		exit(2);
	}
//	argv++;
//		dirName = *argv;
//	dst->MkDir(dirName);
	if (dst->ChDir("UI_HELP") < 0)
	{
printf("no new directory\n");
		errno = ENOENT;
		perror(dirName);
		exit(2);
	}
	ZIL_STORAGE_SUPPORT::CopyDir();
	delete src;
	dst->Save(1);
	delete dst;
	return 0;
}
