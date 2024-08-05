//	Zinc Interface Library - MAKEMAP.CPP
//	COPYRIGHT (C) 1995.  All Rights Reserved.
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


#define VERSION	"4.00"

#include <ctype.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <ui_gen.hpp>

#define TABLE_ENTRY_SIZE	2
#define SPAN_ENTRY_SIZE		sizeof(spanEntry)
#define PAGESIZE		256

#define EMPTY_UNICODE		0xFFFD		// replacement character
#define EMPTY_HARDWARE		0x0000

#if defined(DOS386)
#	define MAXTABLE		65536
#	define VALUE_IN(a, x)	(a)[x]
	typedef uint16 *ARRAY_TYPE;
#else
#	define MAXTABLE		65536L
#	define SIZES		8192
#	define VALUE_IN(a, x)	(a)[(int)((x)/SIZES)][(int)((x)%SIZES)]
	typedef ZIL_UINT16 **ARRAY_TYPE;
#endif

static ARRAY_TYPE toHardware, toUnicode;

typedef struct
{
	ZIL_UINT16 minChar;
	ZIL_UINT16 maxChar;
} spanEntry;

typedef struct
{
	ZIL_UINT16 defaultChar;
	ZIL_UINT16 spanSize;
} headerEntry;

typedef struct
{
	ZIL_UINT8 min;
	ZIL_UINT8 max;
} leadinEntry;

typedef struct {
	ZIL_UINT16 replaceUnicode;
	ZIL_UINT16 replaceHardware;
	int leadinCount;
	leadinEntry leadins[30];
} mapHeader;

static mapHeader header = { EMPTY_UNICODE, EMPTY_HARDWARE, 0 };

static int numSpans;
static spanEntry spanArray[10240];
static int no_warnings = FALSE;
static int verbose = FALSE;

static void PrintBuffer(const char *prompt, ZIL_UINT16 *buff, int n)
{
	if (verbose)
	{
		printf(prompt);
		for (int j=0; j < n/2; j++)
			printf("%6d", buff[j]);
		printf("\n%*s", strlen(prompt), "");
		for (j=n/2; j < n; j++)
			printf("%6d", buff[j]);
		printf("\n");
	}
}

static void CountBits(ARRAY_TYPE table, ZIL_UINT16 empty)
{
	{
	ZIL_UINT16 counts[16] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };

	for (long i = 0; i < MAXTABLE; i++)
		if (VALUE_IN(table, i) != empty)
		{
			for (int j=0; j < 16; j++)
				if (((i >> 1*(15-j)) & 0x1) != 0)
					counts[j]++;
		}
	PrintBuffer("# counts = ", counts, 16);
	}
#if 0
	{
	int counts[16] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };

	for (long i = 0; i < MAXTABLE; i++)
		if (VALUE_IN(table, i) != empty)
			for (int j=0; j < 16; j++)
				if ((VALUE_IN(table, i) & (1 << (15-j))) != 0)
					counts[j]++;
	PrintBuffer("# counts = ", counts, 16);
	}
#endif
}

static long MeasureGaps(int k)
{
	long dsize = 0;
	ZIL_UINT16 dmin = (ZIL_UINT16)(MAXTABLE-1);
	ZIL_UINT16 dmax = 0;
	int dminmin, dminmax, dmaxmin, dmaxmax;
	long gsize = 0;
	ZIL_UINT16 gmin = (ZIL_UINT16)(MAXTABLE-1);
	ZIL_UINT16 gmax = 0;
	int gminmin, gminmax, gmaxmin, gmaxmax;
	for (int i = 0; i < k; i++)
	{
		ZIL_UINT16 tmp = spanArray[i].maxChar - spanArray[i].minChar + 1;
		dsize += tmp;
		if (tmp < dmin)
			dmin = tmp,
				dminmin = spanArray[i].minChar,
				dminmax = spanArray[i].maxChar;
		if (tmp > dmax)
			dmax = tmp,
				dmaxmin = spanArray[i].minChar,
				dmaxmax = spanArray[i].maxChar;

		if (i == 0)
			continue;

		tmp = spanArray[i].minChar - spanArray[i-1].maxChar - 1;
		gsize += tmp;
		if (tmp < gmin)
			gmin = tmp,
				gminmin = spanArray[i-1].maxChar,
				gminmax = spanArray[i].minChar;
		if (tmp > gmax)
			gmax = tmp,
				gmaxmin = spanArray[i-1].maxChar,
				gmaxmax = spanArray[i].minChar;
	}
	if (verbose)
	{
		printf("min, max, ave  Data = %3d(0x%04x-0x%04x)  %3d(0x%04x-0x%04x)  %3d\n",
		       dmin, dminmin, dminmax, dmax, dmaxmin, dmaxmax, dsize/k);
		printf("               Gaps = %3d(0x%04x-0x%04x)  %3d(0x%04x-0x%04x)  %3d\n",
		       gmin, gminmin, gminmax, gmax, gmaxmin, gmaxmax, (k == 1 ? 0 : gsize/(k-1)));
	}
	return (dsize * TABLE_ENTRY_SIZE);
}

#if defined(PRINTSPANS)
static void PrintSpans(int k)
{
	if (verbose)
		for (int i = 0; i < k; i++)
			if (spanArray[i].minChar >= 0x4000)
				printf("\tmin, max = 0x%x  0x%x\n", spanArray[i].minChar, spanArray[i].maxChar);
}
#endif

static void Partition(ARRAY_TYPE table, ZIL_UINT16 empty)
{
	numSpans = 0;
	for (long j=0; j < MAXTABLE; j++)
		if (VALUE_IN(table, j) != empty)
			numSpans++;
	if (verbose)
		printf("# Entries = %d\n", numSpans);
	long i = 0;
	numSpans = 0;
	do {
		while (i < MAXTABLE && VALUE_IN(table, i) == empty)
			i++;
		j = i;
		while (i < MAXTABLE && VALUE_IN(table, i) != empty)
			i++;
		if (i != j)
		{
			spanArray[numSpans].minChar = (ZIL_UINT16)j;
			spanArray[numSpans].maxChar = (ZIL_UINT16)(i - 1);
			numSpans++;
		}
	} while (i < MAXTABLE);
	if (verbose)
	{
		printf("# of spans before optimize = %d\n", numSpans);
		printf("min, max entry  %d  %d\n", spanArray[numSpans-1].minChar, spanArray[0].maxChar);
		printf("min, max entry  0x%x  0x%x\n", spanArray[numSpans-1].minChar, spanArray[0].maxChar);
	}
#if defined(PRINTSPANS)
	PrintSpans(numSpans);
#endif
	MeasureGaps(numSpans);
	// optimize by putting small holes with adjacent
	// areas and combine filled areas
	j = 0;
	for (i = 1; i < numSpans; i++)
	{
		if (spanArray[(int)i].minChar - spanArray[(int)j].maxChar - 1 <= SPAN_ENTRY_SIZE / TABLE_ENTRY_SIZE)
		{
			spanArray[(int)j].maxChar = spanArray[(int)i].maxChar;
		}
		else
		{
			j++;
			spanArray[(int)j] = spanArray[(int)i];
		}
	}
	numSpans = (int)(j + 1);
	if (verbose)
		printf("# of spans after optimize = %d\n", numSpans);
#if defined(PRINTSPANS)
	PrintSpans(numSpans);
#endif
	long dsize = MeasureGaps(numSpans);
	long size2 = SPAN_ENTRY_SIZE * numSpans + sizeof(headerEntry);
	if (verbose)
	{
		printf("Table + Span = size := %5ld + %5ld = %5ld\n",
		       dsize, size2, dsize+size2);
		printf("# of spans = %4d\n", numSpans);
	}
}

static void Initialize(void)
{
#if defined(DOS386)
	toHardware = new ZIL_UINT16[MAXTABLE];
	toUnicode  = new ZIL_UINT16[MAXTABLE];
#else
	toHardware = new ZIL_UINT16 *[(int)(MAXTABLE / SIZES)];
	toUnicode  = new ZIL_UINT16 *[(int)(MAXTABLE / SIZES)];
	for (int j=0; j < MAXTABLE / SIZES; j++)
	{
		toHardware[j] = new ZIL_UINT16[SIZES];
		toUnicode[j]  = new ZIL_UINT16[SIZES];
	}
#endif
	for (long i=0; i < MAXTABLE; i++)
	{
		VALUE_IN(toHardware, i) = EMPTY_HARDWARE;
		VALUE_IN(toUnicode, i) = EMPTY_UNICODE;
	}
}

static int hardwarePos = 1,
	unicodePos = 2;
static int saveOk = 1;

#define REPLACE	1
#define LEADIN	2
#define SHIFT	3
#define MAP	4

static void Warning(const char *fmt, ...)
{
	va_list args;
 	va_start(args, fmt);
	vfprintf(stdout, fmt, args);
	va_end(args);
}

static void Error(const char *fmt, ...)
{
	va_list args;
 	va_start(args, fmt);
	vfprintf(stderr, fmt, args);
	va_end(args);
	saveOk = 0;
}

static void ParseBuffer(FILE *input)
{
	char buff[1024];
	char *ptr;
	ZIL_UINT16 a, b, i1, i2;
	int doing = 0;

	int count = (hardwarePos < unicodePos ? unicodePos : hardwarePos);
	for (;;)
	{
		fgets(buff, sizeof(buff), input);
	if (feof(input)) break;
		ptr = buff;
		int i;
		if (isalpha(*ptr))
		{
			if (strncmp(ptr, "REPLACE", 7) == 0)
				doing = REPLACE;
			else if (strncmp(ptr, "LEADIN", 6) == 0)
				doing = LEADIN;
			else if (strncmp(ptr, "SHIFT", 5) == 0)
				doing = SHIFT;
			else if (strncmp(ptr, "MAP", 3) == 0)
				doing = MAP;
			else if (strncmp(ptr, "NO_WARNINGS", 11) == 0)
				no_warnings = TRUE;
			else
			{
				Error("Unrecognized (%s) keyword\n", ptr);
				doing = 0;
			}
			goto NEXT;
		}
		for (i=1; i <= count; i++)
		{
			while (isspace(*ptr))		// skip space
				ptr++;
			if (*ptr == '#')		// check comment
				goto NEXT;
			if (i == 1)
				i1 = (ZIL_UINT16)strtoul(ptr, NULL, 0);
			if (i == 2)
				i2 = (ZIL_UINT16)strtoul(ptr, NULL, 0);
			if (i == hardwarePos)
			{
				if (*ptr == '*')	// check not-mapped
					goto NEXT;
				a = (ZIL_UINT16)strtoul(ptr, &ptr, 0);
			}
			else if (i == unicodePos)
			{
				if (*ptr == '*')	// check not-mapped
					goto NEXT;
				b = (ZIL_UINT16)strtoul(ptr, &ptr, 0);
			}
			else
				while (!isspace(*ptr))
					ptr++;
		}
		switch (doing)
		{
		case REPLACE:
			header.replaceUnicode = b;
			header.replaceHardware = a;
			break;
		case LEADIN:
			if (header.leadinCount >= 0)
			{
				header.leadins[header.leadinCount].min = i1;
				header.leadins[header.leadinCount].max = i2;
				header.leadinCount++;
			}
			else
				Error("Error, LEADIN defined after a SHIFT\n");
			break;
		case SHIFT:
			if (header.leadinCount == 0)
			{
				header.leadins[0].min = i1;
				header.leadins[0].max = i2;
				header.leadinCount = -1;
			}
			else
				Error("Error, SHIFT defined after a LEADIN or SHIFT\n");
		case MAP:
			if (VALUE_IN(toHardware, b) != EMPTY_HARDWARE && !no_warnings)
				Warning("Warning, Unicode 0x%x value already used\n", b);
			if (VALUE_IN(toUnicode, a) != EMPTY_UNICODE && !no_warnings)
				Warning("Warning, hardware 0x%x value already used\n", a);
			VALUE_IN(toHardware, b) = a;
			VALUE_IN(toUnicode, a) = b;
			break;
		}
	NEXT: ;
	}
	if (header.leadinCount == 0)
		Error("SHIFT or LEADIN must be defined\n");
}

void ChangeToDirectory(ZIL_STORAGE *file, const char *newName)
{
	file->MkDir("ZIL_INTERNATIONAL");
	file->ChDir("ZIL_INTERNATIONAL");
	file->MkDir("UNICODE");
	file->ChDir("UNICODE");
	file->MkDir(newName);
	file->ChDir(newName);
}

void usage(void)
{
	printf("usage: makemap deffile [ hardware-pos unicode-pos ] [ file directory ]\n");
	printf("       makemap -l file object1 object2\n");
	exit(1);
}

int main(int argc, char **argv)
{
	ZIL_STORAGE *table = NULL;
	FILE *F;

	printf("Version %s Copyright (C) 1991-1995 Zinc Software Incorporated.\n\n", VERSION);
	Initialize();
	argv++; argc--;
	if (argc < 1)
		usage();
	if (strcmp(*argv, "-l") == 0)
	{
		argv++; argc--;
		if (argc <= 0)
			usage();
		table = new ZIL_STORAGE(*argv);
		if (table->storageError != 0)
			usage();
		argv++; argc--;
		if (argc != 2)
			usage();
		ChangeToDirectory(table, *argv);
		char newName[128];
		strcpy(newName, "..~");
		strcat(newName, argv[1]);
		table->MkDir(newName);
		if (table->storageError != 0)
			printf("Error = %d\n", table->storageError);
		for (char *entry = table->FindFirstObject("*"); entry; entry = table->FindNextObject())
		{
			if ((strcmp(entry, ".") != 0 && strcmp(entry, "..") != 0))
			{
				strcpy(newName, "..~");
				strcat(newName, argv[1]);
				strcat(newName, "~");
				strcat(newName, entry);
				table->Link(entry, newName);
				if (table->storageError != 0)
					printf("Error1 = %d\n", table->storageError);
			}
		}
		table->storageError = 0;
		table->Save();
		delete table;
		return 0;
	}
	F = fopen(*argv, "r");
	if (F == NULL)
		usage();
	argv++; argc--;
	if (argc == 4 || (argc == 2 && isdigit(**argv)))
	{
		if (!isdigit(**argv))
			usage();
		hardwarePos = atoi(*argv);
		argv++; argc--;
		if (!isdigit(**argv))
			usage();
		unicodePos = atoi(*argv);
		argv++; argc--;
	}
	ParseBuffer(F);
	fclose(F);
	if (verbose)
		printf("To Hardware Table:\n");
	CountBits(toHardware, EMPTY_HARDWARE);
	Partition(toHardware, EMPTY_HARDWARE);
	if (argc != 2 && argc != 0)
		usage();
	if (argc == 2 && saveOk)
	{
		table = new ZIL_STORAGE(*argv, UIS_OPENCREATE|UIS_READWRITE);
		argv++;
		ChangeToDirectory(table, *argv);
		ZIL_STORAGE_OBJECT *map =
			new ZIL_STORAGE_OBJECT(*table, "Mapping", ID_END, UIS_CREATE|UIS_READWRITE);
		map->Store((ZIL_UINT16)header.leadinCount);
		if (header.leadinCount < 0)		// mark for shift stuff
			header.leadinCount = 1;
		for (int i=0; i < header.leadinCount; i++)
		{
			map->Store(header.leadins[i].min);
			map->Store(header.leadins[i].max);
		}
		delete map;

		map = new ZIL_STORAGE_OBJECT(*table, "toHardware", ID_END, UIS_CREATE|UIS_READWRITE);
		map->Store(header.replaceHardware);	// Default char
		map->Store((ZIL_UINT16)numSpans);		// Entries
		for (i=0; i < numSpans; i++)
		{
			map->Store(spanArray[i].minChar);
			map->Store(spanArray[i].maxChar);
		}
		for (i=0; i < numSpans; i++)
			for (long j=spanArray[i].minChar; j <= spanArray[i].maxChar; j++)
{
if (VALUE_IN(toHardware, j) == 0x334f ||
    VALUE_IN(toHardware, j) == 0xdb33)
printf("hardware %ld\n", j, VALUE_IN(toHardware, j));
if (j == 0x334f ||
    j == 0xdb33)
printf("unicode %ld\n", j, VALUE_IN(toHardware, j));
				if (VALUE_IN(toHardware, j) == EMPTY_HARDWARE)
					map->Store(header.replaceHardware);
				else
					map->Store(VALUE_IN(toHardware, j));
}
		delete map;
	}
	if (verbose)
		printf("\nTo Unicode Table:\n");
	CountBits(toUnicode, EMPTY_UNICODE);
	Partition(toUnicode, EMPTY_UNICODE);
	if (argc == 2 && saveOk)
	{
		ZIL_STORAGE_OBJECT *map =
			new ZIL_STORAGE_OBJECT(*table, "toUnicode", 0, UIS_CREATE|UIS_READWRITE);
		map->Store(header.replaceUnicode);	// Default char
		map->Store((ZIL_UINT16)numSpans);	// Entries
		for (int i=0; i < numSpans; i++)
		{
			map->Store(spanArray[i].minChar);
			map->Store(spanArray[i].maxChar);
		}
		for (i=0; i < numSpans; i++)
			for (long j=spanArray[i].minChar; j <= spanArray[i].maxChar; j++)
				if (VALUE_IN(toUnicode, j) == EMPTY_HARDWARE)
					map->Store(header.replaceUnicode);
				else
					map->Store(VALUE_IN(toUnicode, j));
		delete map;
		table->Save();
		delete table;
	}
	return 0;
}
