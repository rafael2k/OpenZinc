			 /******************************************
			  *	Definitions for reporting GFX errors  *
			 *******************************************/

#define SET_VIEW_CLIPPING_FCN		0x8000
#define SCREEN_FCN				0x8100		/* Graphics */
#define FAST_FILL_FCN			0x8200
#define LINE_FCN				0x8300
#define DRAW_FCN				0x8400
#define PAINT_FCN				0x8500
#define GET_PIC_FCN				0x8600
#define PUT_PIC_FCN				0x8700
#define ELLIPSE_FCN				0x8800
#define CIRCLE_FCN				0x8900
#define ARC_FCN				0x8A00
#define LOCATE_FCN				0x8B00
#define OPEN_V_FCN				0x8C00
#define CLOSE_V_FCN				0x8D00
#define CLEAR_V_FCN				0x8E00
#define SWITCH_V_FCN			0x8F00
#define MOVE_V_FCN				0x9000
#define OPEN_FPIC_FCN			0x9100
#define CLOSE_FPIC_FCN			0x9200
#define GET_FPIC_FCN			0x9300
#define PUT_FPIC_FCN			0x9400
#define READ_FPIC_FCN			0x9500
#define WRITE_FPIC_FCN			0x9600
#define CREATE_FPIC_FCN			0x9700
#define DELETE_FPIC_FCN			0x9800
#define COMPRESS_FILE_FCN		0x9900
#define FOPEN_V_FCN				0x9A00
#define SET_VIDEO_PAGES_FCN		0x9B00
#define IDENTIFY_SVGA_FCN		0x9C00
#define SET_SVGA_MODE_FCN		0x9D00
#define MAP_VGA_PAL_FCN			0x9E00
#define READ_VGA_PAL_FCN 		0x9F00
#define ALLOC_GFX_DISK_MEM_FCN	0xA000
#define OPEN_BLOB_FILE_FCN		0xA100
#define CLOSE_BLOB_FILE_FCN		0xA200
#define DELETE_BLOB_ITEM_FCN		0xA300
#define GET_IMAGE_FCN			0xA400
#define READ_IMAGE_FCN			0xA500
#define ADD_FILE_FCN			0xA600
#define LOAD_BLOB_FCN			0xA700
#define SLICE_FILE_FCN			0xA800
#define SET_BLOB_NAME_FCN		0xA900
#define GET_BLOB_NAME_FCN		0xAA00
#define GET_BLOB_NAME_INDEX_FCN	0xAB00
#define INIT_BLOB_NAME_LIST_FCN	0xAC00
#define GET_BLOB_NAME_LIST_FCN	0xAD00
#define OPEN_BLOB_FONT_FCN		0xAE00
#define INIT_PIC_BLOB_FCN		0xAF00
#define GET_BLOB_INFO_FCN		0xB000
#define READ_PCX_HEADER_FCN		0xB100
#define GET_PCX_FILE_FCN			0xB200
#define PUT_PCX_FILE_FCN			0xB300
#define OPEN_PCX_FILE_FCN		0xB400
#define READ_PCX_FILE_FCN		0xB500
#define GET_MEM_PCX_IMAGE_FCN      0xB600
#define PUT_IMAGE_FCN		     0xB700
#define GET_IMAGE_SIZE_FCN	     0xB800
#define WRITE_IMAGE_FCN		     0xB900
#define FREE_PIC_FCN		     0xBA00

#define OPEN_BGI_STROKE_FONT_FCN	0x4000		/* Fonts & Menus */
#define FONT_ALIGN_FCN			0x4100
#define FONT_COLOR_FCN			0x4200
#define FONT_MAGNIFY_FCN			0x4300
#define FONT_ROTATE_FCN			0x4400
#define FONT_UNDERLINE_FCN		0x4500
#define GET_FONT_ATTR_FCN		0x4600
#define GET_FONT_HEIGHT_FCN		0x4700
#define OPEN_FONT_FCN			0x4800
#define CLOSE_FONT_FCN			0x4900
#define CURR_FONT_FCN			0x4A00
#define LINE_DIRECTION_FCN		0x4B00
#define LINE_JUSTIFY_FCN			0x4C00
#define FONT_SPACING_FCN			0x4D00
#define GET_LINE_LEN_FCN			0x4E00
#define FAST_ROM_FONT_FCN		0x4F00


#define SET_MEM_PRINTER_TYPE_FCN	0x0100		/* Printer screen dump */
#define SET_PRINTER_TYPE_FCN		0x0200
#define PRINTER_STATUS_FCN		0x0300
#define PRINT_AREA_FCN			0x0400
#define PRINT_PCX_FILE_FCN		0x0500
#define PRINT_BLOB_FILE_FCN		0x0600

		/* The following is a list of possible errors that are reported
		 * by functions. The value can be found in _gfx.err_number.
		 */

#define BAD_ARG			0x01
#define BAD_VIDEO			0x02
#define BAD_ASPECT			0x03
#define BAD_ANGLE			0x04
#define NO_DISK_SPACE		0x05
#define NO_HEAP_SPACE		0x06
#define PAINT_OVERFLOW		0x07
#define OUT_OF_VIEW 		0x08
#define BAD_VIEW_HANDLE		0x09
#define BAD_PIC_TYPE		0x0A
#define WRONG_PIC_TYPE		0x0A
#define BAD_BLOB_TYPE		0x0B 
#define BAD_BLOB_ITEM		0x0C 
#define BAD_FPIC_INDEX		0x0C 
#define BAD_BLOB_HANDLE		0x0D
#define BAD_FONT_HANDLE		0x0E
#define BAD_FILE_OPEN		0x0F
#define BAD_FILE_FORMAT		0x10
#define NOT_A_PIC_FILE		0x10
#define DUPLICATE_NAME		0x11
#define NO_MATCHING_NAMES	0x12
#define BAD_ESC_SEQ_VALUE	0x13
#define BAD_FILE_WRITE		0x14
#define BAD_FILE_READ		0x15
#define NO_BLOB_HANDLES		0x16

#define BadArg 			0x01		/* Equvalent Pas/M2 interface */
#define BadVideo			0x02
#define BadAspect			0x03
#define BadAngle			0x04
#define NoDiskSpace 		0x05
#define NoHeapSpace 		0x06
#define PaintOverflow		0x07
#define OutOfView			0x08
#define BadViewHandle		0x09
#define BadPicType			0x0A
#define BadBlobType			0x0B
#define BadBlobItem 		0x0C
#define BadBlobHandle		0x0D
#define BadFontHandle		0x0E
#define BadFileOpen			0x0F
#define BadFileFormat		0x10
#define DuplicateName		0x11
#define NoMatchingNames		0x12
#define BadEscSeqValue		0x13
#define BadFileWrite		0x14
#define BadFileRead			0x15
#define NoBlobHandles		0x16

#define OPEN_GATE			0x00

