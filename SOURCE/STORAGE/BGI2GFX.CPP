//	Zinc Interface Library - BGI2GFX.CPP
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


#include <fcntl.h>
#include <sys\stat.h>
#include <io.h>
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <conio.h>

#include <graphics.h>

#define ER_OUT_NAME	-100

#define OK                    0
#define ERROR                 -1
#define MAX_LINE              255

void write_items (int *ip,int n_items,int item_sz,int n_items_per_line,int indent_row,FILE *fp)
{
	int n_lines, j;
	unsigned char *tp;

	n_lines = (n_items + (n_items_per_line - 1)) / n_items_per_line;
	tp = (unsigned char *) ip;
	while (n_lines--)
	{
		if (!n_lines && (n_items % n_items_per_line))
		{
			n_items_per_line = n_items % n_items_per_line;
		}

		for (j = 0; j < indent_row; j++)
			fprintf (fp, "\t");

		if (item_sz == 1)
		{
			for (j = n_items_per_line; j--;)
			{
				fprintf (fp, "0x%02X", *tp++);
				if (j > 0)
					fprintf (fp, ", ");
			}
		}
		else
		{
			for (j = n_items_per_line; j--;)
			{
				fprintf (fp, "0x%04X", *ip++);
				if (j > 0)
					fprintf (fp, ", ");
			}
		}
		if (n_lines > 0)
			fprintf (fp, ",\n");
	}
}

int bgi2gfx (char *inname)
{
	FILE *fp;
	int i, row, col, offset;
	char file_name[20], font_name[20];
	int lineLen, fontHeight, charWidest, testHeight, firstScanLine, scanLines, dataRow, realHeight;
	int basePixel;
	int charwidth[256];
	int charheight[256];
	unsigned char *ScanData[256];
	unsigned offsetArray[256];

	int fontdim = 4;

	void    *fontp;			/* points to font buffer in memory */
	int      handle;			/* file handle used for I/O */
	unsigned fsize;			/* size of file (and buffer) */
	int	font_handle;

  char buffer[2];
  int font, ch, wwidth, lwidth, size;
  struct viewporttype vp;

	strcat (strcpy (font_name, inname), ".chr");
	strcat (strcpy (file_name, inname), ".cpp");

	handle = open(font_name, O_RDONLY|O_BINARY);
	if (handle == -1)
	{
		printf("ERROR: Unable to open font file '%s'.\n", font_name);
		exit(1);
	}

	/* find out size of the file */
	fsize = filelength(handle);

	/* allocate buffer */
	fontp = malloc(fsize);
	if (fontp == NULL)
	{
		printf("ERROR: Unable to allocate memory for font file '%s'.\n", font_name);
		exit(1);
	}

	/* read font into memory */
	if (read(handle, fontp, fsize) != fsize)
	{
		printf("ERROR: Unable to read font file '%s'.\n", font_name);
		exit(1);
	}
	
	/* close font file */
	close(handle);

	/* register font */
	if ((font_handle = registerfarbgifont(fontp)) == -1)
	{
		printf("ERROR: Unable to register font file '%s'.\n", font_name);
		exit(1);
	}

	for (i = 0 ; i < 256 ; i++) offsetArray[i] = 0;

	setcolor (15);
	setbkcolor (0);

	settextstyle( font_handle, HORIZ_DIR, fontdim );
	settextjustify( LEFT_TEXT, TOP_TEXT );
	testHeight = textheight("H")<<1;
	moveto( 0, (textheight("H")<<1)+2 );
	settextstyle( 0, HORIZ_DIR, 1 );
	settextjustify( LEFT_TEXT, TOP_TEXT );
	outtext ("BGI font : ");
	outtext (font_name);

	moveto (0, gety()+textheight("W")*2);

	settextstyle( font_handle, HORIZ_DIR, fontdim );

	getviewsettings( &vp );		/* read current viewport	*/
	
	wwidth = vp.right - vp.left;	/* Determine the window width	*/
	lwidth = textwidth( "H" );          /* Get average letter width     */

	buffer[1] = '\0';                   /* Terminate string             */
	ch = 0;                         /* Begin at 1st printable       */
	while( ch < 256 )		/* For each printable character */
	{
		buffer[0] = ch; 		/* Put character into a string	*/
		charwidth[ch] = textwidth (buffer);
		charheight[ch] = textheight (buffer);
		outtext( buffer );		/* send string to screen	*/
		if( (lwidth+getx()) > wwidth )	/* Are we still in window?	*/
			moveto( 0, gety()+textheight("H")+3 );
		++ch;				/* Goto the next character	*/
	}

	getch();
	lineLen = 0;
	fontHeight = textheight("Hg");
	charWidest = 0;

	realHeight = 0;
	firstScanLine = testHeight;

	for (i = 0 ; i < 256 ; i++)
	{
		buffer[0] = i;
		offsetArray[i] = lineLen;
		if (charwidth[i])
		{
			lineLen += charwidth[i];
			if (charwidth[i] > charWidest)
				charWidest = charwidth[i];
			setcolor (15);
			outtextxy (0, 0, buffer);
			for (row = testHeight ; row && row > realHeight ; row--)
			{
				for (col = 0 ; col < charwidth[i] ; col++)
				{
					if (getpixel (col, row) != 0)
					{
						if (row > realHeight)
						{
							realHeight = row;
							break;
						}
					}
				}
			}
			for (row = 0 ; row < testHeight && row < firstScanLine ; row++)
			{
				for (col = 0 ; col < charwidth[i] ; col++)
				{
					if (getpixel (col, row) != 0)
					{
						if (row < firstScanLine)
						{
							firstScanLine = row;
							break;
						}
					}
				}
			}
			setcolor (0);
			outtextxy (0, 0, buffer);
		}
	}
	fontHeight = realHeight+1;
	scanLines = realHeight - firstScanLine + 1;
	basePixel = 0;
	buffer[0] = 'H';
	setcolor (15);
	outtextxy (0, 0, buffer);
	for (row = fontHeight ; row > basePixel && row > firstScanLine ; row--)
	{
		for (col = 0 ; col < charwidth['H'] ; col++)
		{
			if (getpixel (col, row) != 0)
			{
				if (row > basePixel)
					basePixel = row;
				break;
			}
		}
	}
	setcolor (0);
	outtextxy (0, 0, buffer);

	for (i = 0 ; i < scanLines ; i++)
	{
		ScanData[i] = (unsigned char *)calloc ((lineLen+7)>>3, 1);
	}

	for (i = 0 ; i < 256 ; i++)
	{
		buffer[0] = i;
		if (charwidth[i])
		{
			setcolor (15);
			outtextxy (0, 0, buffer);
			for (dataRow = 0,row = firstScanLine ; row <= realHeight ; row++,dataRow++)
			{
				for (col = 0 ; col < charwidth[i] ; col++)
				{
					if (getpixel (col, row) != 0)
					{
						offset = offsetArray[i] + col;
						*(ScanData[dataRow]+(offset>>3)) |= (0x80 >> (offset & 0x07));
					}
				}
			}
			setcolor (0);
			outtextxy (0, 0, buffer);
		}
	}
	closegraph(); 		/* Return the system to text mode	*/

	int index = 0;
	while (file_name[index])
	{
		file_name[index] = toupper(file_name[index]);
		++index;
	}

	fp = fopen (file_name, "w");
	if (fp == NULL)
		return ER_OUT_NAME;

	fprintf (fp, "//\tZinc Interface Library - %s\n", file_name);
	fprintf (fp, "//\tCOPYRIGHT (C) 1990-1995.  All Rights Reserved.\n");
	fprintf (fp, "//\tZinc Software Incorporated.  Pleasant Grove, Utah  USA\n");
	fprintf (fp, "\n");
	fprintf (fp, "#include \"gfx.h\"\n");
	fprintf (fp, "#if defined(DOS386)\n");
	fprintf (fp, "#\tdefine _far\n");
	fprintf (fp, "#endif\n");
	fprintf (fp, "\n");
	/* first write out the 'offset table' */
	fprintf (fp, "static unsigned short _far %s_offset_table[] =\n{\n", inname);
	write_items ((int *)offsetArray, 256, 2, 8, 1, fp);
	fprintf (fp, ",\n\t0x%04X\n};\n\n\n", lineLen);

	/* now the bitmap 'data table' */
	fprintf (fp, "static unsigned char _far %s_data_table[] =\n{\n", inname);
	for (i = 0 ; i < scanLines ; )
	{
		fprintf (fp, "\n\t// Scan Line #%d.\n", i+1);
		write_items ((int *)ScanData[i], (lineLen+7)>>3, 1, 12, 1, fp);
		if (++i < scanLines)
			fprintf (fp, ",\n");
	}
	fprintf (fp, "\n};\n\n\n");

	/* finally, the FONT data structure */
	fprintf (fp, "static FONT %s =\n{\n", inname);
	fprintf (fp, "\t%s_offset_table,\n", inname);
	fprintf (fp, "\t%s_data_table,\n\n", inname);
	fprintf (fp, "\t%3d,\t\t// The number of bytes in each row of the bitmap.\n", (lineLen+7)>>3);
	fprintf (fp, "\t%3d,\t\t// The number of rows in the bitmap.\n", scanLines);
	fprintf (fp, "\t%3d,\t\t// The first character in the bitmap.\n", 0);
	fprintf (fp, "\t%3d,\t\t// The last character in the bitmap.\n", 255);
	fprintf (fp, "\t%3d,\t\t// The widest character, in bits.\n", charWidest);
	fprintf (fp, "\t%3d,\t\t// The distance from the baseline to the top of a character.\n", basePixel-firstScanLine);
	fprintf (fp, "\t%3d,\t\t// The distance from the top to the underline bar.\n", basePixel-firstScanLine+1);
	fprintf (fp, "\t%3d \t\t// The flag for a ROM resident font.\n", 0);
	fprintf (fp, "};\n\n");

	fprintf (fp, "FONT *GFX_%s_font (void)\n{\n\treturn (&%s);\n}\n",inname, inname);

	/* close files */
	fclose (fp);

	return OK;
}


int main (int argc,char *argv[])
{
	int	GraphDriver;		/* The Graphics device driver		*/
	int	GraphMode;		/* The Graphics mode value		*/
	int ErrorCode;

	if (argc < 2)
	{
		printf ("Usage - BGI2GFX <fontname>\n");
		printf ("Converts Borland BGI font file to CPP file in GFX 3.0 format.\n");
		printf ("The file type .CHR is assumed.\n");
		exit (1);
	}


	GraphDriver = DETECT; 		/* Request auto-detection	*/
	initgraph( &GraphDriver, &GraphMode, "" );
	ErrorCode = graphresult();		/* Read result of initialization*/
	if( ErrorCode != grOk )			/* Error occured during init	*/
	{
		printf("ERROR: BGI graphics error - %s.\n", grapherrormsg( ErrorCode ) );
		exit( 1 );
	}


	ErrorCode = bgi2gfx (strlwr(argv[1]));

	printf ("\n");

	switch (ErrorCode)
	{
		case OK:
			printf("Conversion complete.\n");
			break;

		case ER_OUT_NAME:
			printf("ERROR: Can't open output file name %s.cpp\n", argv[1]);
			break;

		default:
			printf("ERROR: Internal error #%d.\n", ErrorCode);
			break;
	}
	return ErrorCode;
}

