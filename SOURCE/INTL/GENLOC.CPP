//	Zinc Interface Library - GENLOC.CPP
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


#include <stdio.h>
#include <string.h>
#include <ui_win.hpp>

#if defined(ZIL_MACINTOSH)
#	include <console.h>
#endif

#define VERSION	"3.60"

class LOCALE_SERVICES : public ZIL_INTERNATIONAL
{
public:
	static void CopyDirectory(ZIL_STORAGE *dst, ZIL_STORAGE *src);
	static void PrintISOCodes(void);
};

main(int argc, char *argv[])
{
#if defined(ZIL_MACINTOSH)
	argc = ccommand(&argv);
#endif

	// Display version.
	char exeName[32];
	ZIL_STORAGE::StripFullPath(argv[0], ZIL_NULLP(ZIL_ICHAR), exeName);
	ZIL_INTERNATIONAL::strlwr(exeName);
	printf("\n%s Version %s Copyright (C) 1991-1995 Zinc Software Incorporated.\n", exeName, VERSION);

	// Create the path elements.
	ZIL_STORAGE::searchPath = new UI_PATH(argv[0], TRUE);

	// Check for special requests
	if (argc > 1 && !strcmp(argv[1], "/?"))
	{
		printf("\n");
		LOCALE_SERVICES::PrintISOCodes();
		return (1);
	}

	// Make sure there is a specified text file and iso-code.
	if (argc < 3)
	{
		printf("\nusage: %s [/?] <filename> <iso-code> \n", exeName);
		return (1);
	}

	// Make sure the <filename> and <iso-code> are valid.
	char *dstFileName = argv[1];
	ZIL_STORAGE *dstFile = new ZIL_STORAGE(dstFileName, UIS_READWRITE);

	char *isoCode = argv[2];
	char srcFileName[32];
	sprintf(srcFileName, "locale._%s", isoCode);
	ZIL_STORAGE *srcFile = new ZIL_STORAGE(srcFileName, UIS_READ);

	if (!dstFile->storageError && !srcFile->storageError)
	{
		srcFile->ChDir("~UI_INTERNATIONAL");
		dstFile->MkDir("~UI_INTERNATIONAL");
		dstFile->ChDir("~UI_INTERNATIONAL");
		LOCALE_SERVICES::CopyDirectory(dstFile, srcFile);
		dstFile->Save();
		printf("\nDone!\n"); // Print a status line.
	}
	else
	{
		if (srcFile->storageError)
			printf("\nError! Unable to read locale file \"%s\".\n", srcFileName);
		if (dstFile->storageError)
			printf("\nError! Unable to read destination file \"%s\".\n", dstFileName);
		return (1);
	}

	delete srcFile;
	delete dstFile;

	return (0);
}

// ----- LOCALE_SERVICES ----------------------------------------------------

ZIL_ICHAR star[2] = { '*', 0 };
ZIL_ICHAR dot[2] = { '.', 0 };
ZIL_ICHAR dotdot[3] = { '.', '.', 0 };

void LOCALE_SERVICES::CopyDirectory(ZIL_STORAGE *dstFile, ZIL_STORAGE *srcFile)
{
	// Print a status line.
	printf(".");

	ZIL_STORAGE_OBJECT *o = new ZIL_STORAGE_OBJECT(*srcFile, dot, 0, 0);
	if (o->objectError != 0)
	{
		delete o;
		return;
	}
	ZIL_STATS_INFO *s = o->Stats();
	int dirlen = (int)s->size;;
	ZIL_ICHAR *objs = new ZIL_ICHAR[dirlen];
	ZIL_ICHAR *ptr = objs;
	delete o;

	for (ZIL_ICHAR *entry = srcFile->FindFirstObject(star); entry; entry = srcFile->FindNextObject())
	{
		if ((strcmp(entry, dot) == 0 || strcmp(entry, dotdot) == 0))
			continue;
		strcpy(ptr, entry);
		ptr += strlen(ptr) + 1;
	}
	*ptr = '\0';
	for (ptr = objs; *ptr; ptr += strlen(ptr)+1)
	{
		if (srcFile->ChDir(ptr) >= 0)
		{
			dstFile->MkDir(ptr);
			dstFile->ChDir(ptr);
			CopyDirectory(dstFile, srcFile);
			srcFile->ChDir(dotdot);
			dstFile->ChDir(dotdot);
		}
		else
		{
			ZIL_STORAGE_OBJECT *sobj =
				new ZIL_STORAGE_OBJECT(*srcFile, ptr, 0, UIS_READ);
			ZIL_STORAGE_OBJECT *dobj =
				new ZIL_STORAGE_OBJECT(*dstFile, ptr, sobj->objectID, UIS_CREATE|UIS_READWRITE);
			char *buff = new char[16384];
			int len;

			while ((len = sobj->Load(buff, 16384, 1)) > 0)
				dobj->Store(buff, len, 1);

#if __BORLANDC__ >= 300 || defined(_IBM_RS6000) || defined(ZIL_MACINTOSH)
			delete []buff;
#else
			delete [16384]buff;
#endif
			delete sobj;
			delete dobj;
		}
	}
#if __BORLANDC__ >= 300 || defined(_IBM_RS6000) || defined(ZIL_MACINTOSH)
	delete []objs;
#else
	delete [dirlen]objs;
#endif
}

void LOCALE_SERVICES::PrintISOCodes(void)
{
	static char *isoTable[] =
	{
		"AT = Austria",
		"CA = Canada",
		"CN = China",
		"DE = Germany",
		"DK = Denmark",
		"ES = Spain",
		"FI = Finland",
		"FR = France",
		"GB = United Kingdom",
		"GR = Greece",
		"IT = Italy",
		"JP = Japan",
		"KR = Korea, Republic of",
		"MX = Mexico",
		"NL = Netherlands",
		"SE = Sweden",
		"TW = Taiwan",
		"US = United States",
		ZIL_NULLP(char)
	};

	// Compute the total options (for printf statements).
	for (int halfWay = 0; isoTable[halfWay]; halfWay++) 
		;
	halfWay = (halfWay + 1) / 2;

	// Print the options in two column format.
	printf("Supported ISO locale codes:\n");
	for (int i = 0; i < halfWay; i++)
	{
		printf("  %2d) %-30s", i + 1, isoTable[i]);
		if (isoTable[halfWay + i])
			printf("  %2d) %-30s\n", halfWay + i + 1, isoTable[halfWay + i]);
		else
			printf("\n");
	}
}

