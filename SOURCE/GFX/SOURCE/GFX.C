#define ZINC_OEM    1
#define INCLUDE_BUILD_FILES 1

	   /**************************************************************/
	   /*  Copyright C Source, Inc. 1987 - 1993  All Rights Reserved */
	   /*      C Source Incorporated. Lee's Summit, Missouri USA     */
	   /**************************************************************/

		/*  The first screen of declarations are only used for compiling
		 *  this code as a single module.
		 *
		 *  If you recompile this whole file as a unit for a compiler
		 *  other than Microsoft C, change the next line to:
		 *  #define  NEAR
		 */

#define NEAR 
#include "gfxg_src.h"

			/********************************************
			 *		THE SOURCE CODE BEGINS HERE	    *
			 ********************************************/

/*^ GFXG_C.C */

/*~ INIT_GFX.C */

INT NEAR _gfx_chip_type = 0;
INT NEAR _gfx_truncate_val = 0;

		/* The structure for pattern line and fill */
GFX_PAT NEAR _gfx_pat = {DFLT, DFLT, DFLT};

		/* The structure for recording figure's coordinates */
GFX_COOR NEAR _gfx_coor ISTAT_ARR_0;

		/* The structure for recording the default video aspect ratio */
ICOOR NEAR _gfx_video_aspect_ratio = {3, 4};

Int_FCN _get_int_pt(int *);

		/*  This is the central structure used by most GFX Graphics
		 *  functions.  It is only paritially initialized.
		 */

#if defined (M_I86) && !defined (__ZTC__) && (__MSC32__ == 0)
GFX_STATUS near _gfx =
#else
GFX_STATUS _gfx =
#endif
			  { UNDEFINED_GFX,	/* graphics mode info */
			    0,			/* card_monitor type */
			    0,			/* bios mode */
			    0,			/* active display page */
			    0,			/* active write page */
			    0,			/* error number */
			    0,			/* show error number */
			    0,			/* x-res */
			    0,			/* y-res */
		    0xFFFF,			/* original bios mode */

			    0,			/* # of colors */
			    0,			/* monochrome card screen base */
			    0,			/* dummy */

			    0,			/* view number */
			    0,			/* color palette */
			   80,			/* bytes per row */
			    0,			/* last video row */
			    0,			/* color flags */
			    0,			/* background color */
			    7,			/* foreground color */
			    0,			/* font handle */
			    0,			/* use auto-scaling? */
			    0,			/* auto-scaling factor */
			    0,			/* view's byte offset */
			    0,			/* view's byte width */
			    0,			/* # of rows in view */
			    0,			/* view's pel width */

			    0,0,			/* min x,y */
			    0,0,			/* max x,y */
			    0,0,			/* current point */
			    0,0,			/* integer logical coordinates */
			  0.0,0.0,		/* floating point logical coordinates */
			    0,0,			/* x,y origin */
			    1,1,			/* x & y coordinate direction */
			    0,0,			/* view's x scaling factors */
			    1,1,			/* view's y scaling factors */
			  0.0,0.0,		/* view's floating point x,y scale */
		   _get_int_pt};		/* view's function for getting a point */

#if (PROT_MODE_SYS == PMODE_32)
GFX_PM _gfx_pm;
#endif

DMEM_HANDLE _view_cb[MAX_VIEWS] = { (DMEM_HANDLE) &(_gfx.bkgnd) };

INT (_pascal *DRAW_flt_fcn)(INT, TEXT *, INT, INT, INT) ISTAT_0;
void (_pascal *sg_dbl_val)(INT, INT *, INT *) ISTAT_0;
void (_pascal *rs_flog)(void) ISTAT_0;
INT (_pascal *_gfx_vec)(INT, INT *) ISTAT_0;
INT _gfx_vec_rtn ISTAT_0;
SAFE_MALLOC_LINK NEAR _gfx_safe_malloc ISTAT_ARR_0;

	/*  no_init() is called to display the message and drop out if a
	 *  graphics drawing function is called before proper initialization.
	 */
void AFdecl _gfx_no_init(void)
{

_gfx_puts("Sorry, you must set a graphics mode\n");
exit(1);
}

	/*  These arrays contain the maximium resolution for various video
	 *  resolutions.  Thes last two that are left to zero are set by
	 *  SET_VIDEO_RESOLUTION for non-standard resolutions.
	 */
LOCAL INT_FAR max_x[] = {319, 639, 719, 639, 319, 639, 639, 639, 639, 639, 0, 0};
LOCAL INT_FAR max_y[] = {199, 199, 347, 399, 199, 199, 349, 349, 479, 479, 0, 0};

#if defined (USE_PAS_M2)
	void SetVideoResolution(INT res_x, INT res_y)
#elif defined (USE_UPPER_C)
	void SET_VIDEO_RESOLUTION(INT res_x, INT res_y)
#elif defined (USE_LOWER_C)
	void set_video_resolution(INT res_x, INT res_y)
#endif
{
max_x[10] = max_x[11] = res_x - 1;
max_y[10] = max_y[11] = res_y - 1;
}

	/*  The next three items are used for implementing logical colors.
	 *  color_table[][] is a two dimensional array where the first row
	 *  has the 4 color palette, the second is two color and the last is 16
	 *  colors.  _gfx_color_table will be set to point at the appropriate
	 *  row in color_table depending on the current video mode.
	 *  color_table_index[] translates between a bios mode # and a row of
	 *  the color_table[][] array.
	 */

TINY *_gfx_color_table ISTAT_0;
LOCAL TINY color_table_index[] = {0, 1, 1, 1, 2, 2, 1, 2, 1, 2, 1, 2};
LOCAL TINY color_table[][16] = {{0, 1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3},
						  {0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
						  {0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15}
						 } ;

	 /*	gfx_mode[] is a translation table to get the proper value for
	  *	_gfx.gfx_mode.  These defined constants can be found in GFXG_SRC.H
	  */

LOCAL UINT cga_gfx_modes[] = {MED_RES, HIGH_RES, HERCULES, HERCULES};

	/* The next two arrays hold hardware constants of the current video mode.
	 */

LOCAL UINT screen_base[] = { CGA_MEM, CGA_MEM, MDA_MEM, CGA_MEM, EGA_MEM };

LOCAL UINT last_video_row[] = { 0x4000 - 80, 0x4000 - 80, 0x8000 - 90,
						  0x8000 - 80, 0xFFFF
						};


	/* The next items are used to maintain compatability with how
	 * autoscaling was done in GFX Graphics Ver 1.0
	 */

LOCAL INT orig_scale = -1;
LOCAL INT xlat_orig_scale[] = {1, 1, 2, 6, 3};
LOCAL TINY xlat_res[] = {0, 0, 0, 0, 0, 0, 1, 0, 3, 2};


	/*  INIT_GFX_STRUCT initializes members of the _gfx structure depending
	 *  on the 'bios_nmbr' argument.  It is pretty much a bunch of table
	 *  lookups and assignments.
	 */

#if defined (USE_PAS_M2)
	void InitGFXStruct(INT bios_nmbr)
#elif defined (USE_UPPER_C)
	void INIT_GFX_STRUCT(INT bios_nmbr)
#elif defined (USE_LOWER_C)
	void init_GFX_struct(INT bios_nmbr)
#endif
{
FAST INT index;
INT l_index;
VIEW *view;

#if (PROT_MODE_SYS == PMODE_32)
if (_gfx_pm.extender == 0)
	_gfx32_init_pmode();
#elif (LINK_TO_PASCAL == 1)
void _gfx_init_pascal(void);
_gfx_init_pascal();
#endif

if (bios_nmbr < 2) then bios_nmbr += VGA_COLOR + 1;
_gfx.bios_mode = bios_nmbr & 0x1FF;
if (bios_nmbr >= EGA_MED_RES) {
	index = 4;
	if ((bios_nmbr & SVGA_256_RES) OR (bios_nmbr == 0x13)) {
		l_index = (bios_nmbr == 0x13) ? 0 : 11;
		_gfx.gfx_mode = _256_COLOR;
		_gfx.n_colors = 256;
		}
	else {
		if (bios_nmbr > 0x12) then bios_nmbr = 0x13 + (bios_nmbr & 1);
		l_index = bios_nmbr - EGA_MED_RES + index;
		if (bios_nmbr & 1) {
			_gfx.gfx_mode = E_RES_MONO;
			_gfx.n_colors = 2;
			}
		else {
			_gfx.gfx_mode = E_RES_COLOR;
			_gfx.n_colors = 16;
			}
		}
	_gfx.card_monitor |= (bios_nmbr >= 0x12) ? VGA_CARD : EGA_CARD;
	}
else {
	l_index = index = (INT)xlat_res[bios_nmbr];
	_gfx.gfx_mode = (INT) cga_gfx_modes[index];
	_gfx.n_colors = (bios_nmbr == MED_RES_COLOR) ? 4 : 2;
	}

_gfx.sys_flags = 0;
_gfx_force_on_planes();
_gfx_color_table = color_table[color_table_index[l_index]];
_gfx.max_x = _gfx.view_lr_x = max_x[l_index];
_gfx.max_y = _gfx.view_lr_y = max_y[l_index];
_gfx_set_screen_base(screen_base[index]);
_gfx.last_video_row = last_video_row[index];

if (bios_nmbr == EGA_MED_RES)
	_gfx.bytes_per_row = 40;
else if (bios_nmbr > EGA_MED_RES)
	_gfx.bytes_per_row = (_gfx.view_lr_x + 1) / ((_gfx.n_colors == 256) ? 1 : 8);
else
	_gfx.bytes_per_row = (_gfx.bios_mode == HERC_GFX) ? 90 : 80;

if ((INT)_gfx.xlat_scale < 0)
	orig_scale = xlat_orig_scale[-(INT)_gfx.xlat_scale] - 1;
_gfx.xlat_scale = _gfx.x_org = _gfx.y_org = 0;
_gfx.scale.x_denom = _gfx.scale.x_num = _gfx.screen_x_res = _gfx.view_lr_x + 1;
_gfx.scale.y_denom = _gfx.scale.y_num = _gfx.screen_y_res = _gfx.view_lr_y + 1;
if ((orig_scale >= 0) AND (orig_scale != l_index)) {
	_gfx.scale.x_denom = max_x[orig_scale] + 1;
	_gfx.scale.y_denom = max_y[orig_scale] + 1;
	_gfx.xlat_scale = 1;
	}
_gfx.get_pt = _get_int_pt;
view = (VIEW *) &(_gfx.bkgnd);
if (_view_cb[0] AND ((VIEW *)_view_cb[0] != view)) {
	* (VIEW *)_gfx_deref_mc(_view_cb[0]) = *view;
	_gfx_unlock_mc(_view_cb[0]);
	}
alloc_GFX_workspace(0, (VOID_FAR *) 0);
}

Void_FCN _gfx_force_on_planes(void)
{
if ((_gfx.gfx_mode & 0xFF) == 4)
	_gfx.sys_flags |= MULTI_PLANAR;
}

Void_FCN _gfx_force_off_planes(void)
{
_gfx.sys_flags &= ~MULTI_PLANAR;
}

GFX_GATE_PRO;

#if defined (USE_PAS_M2)
	void SetFillSolid(INT fill_color)
#elif defined (USE_UPPER_C)
	void SET_FILL_SOLID(INT fill_color)
#elif defined (USE_LOWER_C)
	void set_fill_solid(INT fill_color)
#endif
{

GFX_GATE_CLOSE
if ((_gfx.n_colors < 256) AND (fill_color != DFLT))
	fill_color = _gfx_color_table[fill_color];
_gfx_pat.fill.init_solid_color = fill_color;
GFX_GATE_OPEN
}

	/*  _gfx_get_color() is the central color translation function.	It is
	 *  called by every high level function receiving a (logical) color as
	 *  an argument, and it decides if a) the drawing routine should XOR ,
	 *  b) if it is a default color and c) does the actual color
	 *  translation.
	 */

INT _gfx_pen_color_flags = 0;

Int_FCN _gfx_get_color(FAST INT color)
{
IMPORT GFX_PAT NEAR _gfx_pat;

if (color == DFLT) then color = _gfx.fgnd;
if ((_gfx.color_flags = _gfx_pen_color_flags) == 0)
	_gfx.color_flags = color & COLOR_FLAGS;
if (_gfx.n_colors == 256) then color &= 0xFF;
else color = _gfx_color_table[color&0xF];
if (_gfx.color_flags & (FILL_PAT | FILL_SOLID)) {
	_gfx_pat.fill.bkgnd_color = _gfx_pat.fill.init_solid_color;
	if (_gfx.color_flags & FILL_PAT) {
		_gfx_pat.fill.bkgnd_color = _gfx_pat.fill.init_bkgnd_color;
		_gfx_pat.fill.pat_color = (_gfx_pat.fill.init_pat_color == DFLT) ?
		   color : _gfx_pat.fill.init_pat_color;
		}
	if (_gfx_pat.fill.bkgnd_color == DFLT)
		_gfx_pat.fill.bkgnd_color = color;
	_gfx_pat.fill.frame_color = color;
	}
return color;
}

	/*  _gfx_in_viewport() is called by many functions to insure that
	 *  coordinates are inside the current viewport.
	 */

Int_FCN _gfx_in_viewport(void)
{
return (inrange(_gfx.min_x, _gfx.pt_x, _gfx.max_x) AND inrange(_gfx.min_y, _gfx.pt_y, _gfx.max_y));
}


	/*  The next two arrays of text contain function names and error
	 *  descriptions.  If you aren't going to show error messages on the
	 *  screen you can cut out all the text in these items and save several
	 *  hundred bytes.	Also, these function names for the FONT functions
	 *  are here, so if you aren't using font functions you can safely delete
	 *  all names in fcn_names[] from "FONT_ALIGN" on.
	 */

#if (SHOW_ERR_TEXT == 1)
LOCAL TEXT *graphics_fcn_names[] = {
	"set_view_clipping", "screen", "fast_fill", "line", "draw", "paint",
	"get_pic", "put_pic", "ellipse", "circle", "arc", "locate",
	"open_view", "close_view", "clear_view", "switch_view", "move_view",
	"open_fpic", "close_fpic", "get_fpic", "put_fpic", "read_fpic",
	"write_fpic", "create_fpic", "delete_fpic", "compress_fpic_file",
	"open_view_file", "set_video_pages", "identify_SVGA", "set_SVGA_mode",
	"map_VGA_palette", "read_VGA_palette", "alloc_GFX_disk_mem", "open_blob_file",
	"close_blob_file", "delete_blob_item", "get_image", "read_image",
	"add_file", "load_blob", "slice_file_from_blob", "set_blob_name",
	"get_blob_name", "get_blob_name_index", "init_blob_name_list",
	"get_blob_name_list", "open_blob_font", "init_pic_blob", "get_blob_info",
	"read_PCX_header", "get_PCX_file", "put_PCX_file", "open_PCX_file",
	"read_PCX_file", "get_mem_PCX_image", "put_image", "get_image_size", 
	"write_image", "free_pic"};

LOCAL TEXT *fonts_menus_fcn_names[] = {
	  "open_bgi_stroke_font", "font_align", "font_color",
	  "font_magnify", "font_rotate", "font_underline", "get_font_attr",
	  "get_font_height", "open_font", "close_font", "curr_font",
	  "line_direction", "line_justify", "font_spacing", "get_line_len",
	  "fast_ROM_font" };

LOCAL TEXT *screen_dump_fcn_names[] = {
	  "set_mem_printer_rec", "set_disk_printer_rec",
	  "get_printer_status", "print_area", "print_PCX_file", "print_blob_file" };

LOCAL TEXT *err_types[] = {
	"", "BAD ARG", "BAD VIDEO" ,"BAD ASPECT" ,"BAD ANGLE",
	"NO DISK SPACE", "NO HEAP SPACE", "PAINT OVERFLOW",
	"OUT OF VIEW", "BAD VIEW HANDLE", "BAD PIC TYPE",
	"BAD BLOB TYPE", "BAD BLOB ITEM", "BAD BLOB HANDLE",
	"BAD FONT HANDLE", "CAN'T OPEN FILE", "BAD FILE FORMAT",
	"DUPLICATE NAME",  "NO MATCHING NAME", "BAD_ESC SEQUENCE VALUE", 
	"BAD FILE WRITE", "BAD FILE READ", "NO BLOB HANDLES"
	};

LOCAL INT err_x = 0;

LOCAL_Int_FCN _gfx_err_print(INT x, INT y, TEXT *tp)
{
INT _color, n_pels, i, fh, c, dy;

if (_gfx.card_monitor & VGA_CARD) {
	fh = 3;
	dy = 8;
	}
else {
	fh = 1;
	dy = 4;
	}
_color = (_gfx.n_colors == 2) ? 1 : 15;
for (n_pels = i = 0; tp[i] != 0; i++)
	n_pels += 8;
_gfx_fillbox(x, y-dy, x+n_pels+16, y+dy, _gfx_get_color(FILL_SOLID));
qprint(x, y, fh, _color, 0, tp, 100);
return x+n_pels;
}


LOCAL_Void_FCN _gfx_put_err(TEXT *tp)
{
INT y;

if (tp)
	err_x = _gfx_err_print(err_x, 10, tp);
else {
	_gfx_err_print(err_x, 10, "          ");
	_gfx_err_print(0, 25, "PRESS ANY KEY TO CONTINUE -- or -- '*' TO EXIT");
	err_x = 0;
	}
}

#endif


	/*  The next two functions are called by GFX functions when an error is
	 *  detected.	Depending on how things are set, they can issue a warning
	 *  on the screen and exit the program, or simply set an error code and
	 *  return NULL.  These are central routines, so if you want to change
	 *  how error reporting is done, here is where to do it.
	 */

INT (*_gfx_err_hook)(INT fcn_n, INT err_n);

Int_FCN _set_gfx_err_number(FAST INT err_code)
{
FAST INT fcn_n;
#if (SHOW_ERR_TEXT == 1)
REG_HL reg;
#endif

fcn_n = (err_code >> 8) & 0xFF;
if ((err_code &= 0xFF) != 0) then _gfx.err_number = err_code;
if (_gfx_err_hook AND !_gfx_err_hook(fcn_n, err_code)) {
	GFX_GATE_OPEN
	return 0;
	}
#if (SHOW_ERR_TEXT == 1)
if ((_gfx.show_gfx_err & DISPLAY_ERROR) AND fcn_n) {
	_gfx_put_err("WARNING: ");
	if (fcn_n >= 0x80)
		_gfx_put_err(graphics_fcn_names[fcn_n-0x80]);
	else if (fcn_n >= 0x40)
		_gfx_put_err(fonts_menus_fcn_names[fcn_n-0x40]);
	else
		_gfx_put_err(screen_dump_fcn_names[fcn_n-1]);
	_gfx_put_err("() -- ");
	if (_gfx.err_number <= (sizeof(err_types) / sizeof(TEXT *)) - 1)
		_gfx_put_err(err_types[_gfx.err_number]);
	_gfx_put_err((TEXT *) 0);
	if ((_gfx_call_dos(1, 0) & 0xFF) == '*')
		exit(1);
	}
#endif
GFX_GATE_OPEN
return NULL;
}

	/* This is a simple DOS call to write some text to the screen. */

Void_FCN _gfx_puts(FAST TEXT *tp)
{
while (*tp) {
	_gfx_call_dos(2, (INT)*tp);
	tp++;
	}
}


LOCAL WORKSPACE NEAR _gfx_workspace ISTAT_ARR_0;
typedef struct _mx {UTINY_FAR *buf_ptr;
				FAR_DMEM_HANDLE buf_mc;
				INT n_kbytes;
			    } TSPACE;

LOCAL TSPACE NEAR tspace[6] ISTAT_ARR_0;
LOCAL INT pos ISTAT_0;

Int_FCN _gfx_get_temp_workspace(UTINY_FAR **temp_buf, INT n_kbytes)
{
UTINY_FAR *buf;

if (n_kbytes <= _gfx_workspace.n_kbytes_free) {
	if (!n_kbytes)
		n_kbytes = _gfx_workspace.n_kbytes_free;
	buf = _gfx_workspace.buf + (!pos ? 0 :
	   ((_gfx_workspace.n_kbyte_buf - _gfx_workspace.n_kbytes_free) * 1024));
	tspace[pos].n_kbytes = n_kbytes;
	tspace[pos].buf_mc = (DMEM_HANDLE) 0;
	_gfx_workspace.n_kbytes_free -= n_kbytes;
	}
else {
	if (!n_kbytes) then n_kbytes = 8;
	buf = _gfx_farmalloc_mc((LONG)n_kbytes * 1024L,
	   (FAR_DMEM_HANDLE *) &tspace[pos].buf_mc);
	if (!buf)
		return NULL;
	}
*temp_buf = tspace[pos].buf_ptr = buf;
tspace[pos++].n_kbytes = n_kbytes;
return n_kbytes;
}


Void_FCN _gfx_free_temp_workspace(UTINY_FAR *buf)
{

if (buf == tspace[pos-1].buf_ptr) {
	pos--;
	if (tspace[pos].buf_mc)
		_gfx_farfree_mc(_gfx_workspace.buf_mc);
	else
		_gfx_workspace.n_kbytes_free += tspace[pos].n_kbytes;
	}
}


LOCAL_Void_PRO _gfx_free_GFX_workspace(void);

#define WS_DFLT_SZ		16

#if defined (USE_PAS_M2)
	INT AllocGFXWorkspace(INT n_kbytes, VOID_FAR *user_buf)
#elif defined (USE_UPPER_C)
	INT ALLOC_GFX_WORKSPACE(INT n_kbytes, VOID_FAR *user_buf)
#elif defined (USE_LOWER_C)
	INT alloc_GFX_workspace(INT n_kbytes, VOID_FAR *user_buf)
#endif
{

if (!n_kbytes) {
	if (_gfx_workspace.buf)
		return _gfx_workspace.n_kbyte_buf;
	n_kbytes = WS_DFLT_SZ;
	}
GFX_GATE_CLOSE
_gfx_free_GFX_workspace();
if (!user_buf) {
	_gfx_workspace.buf = _gfx_farmalloc_mc((LONG) n_kbytes * 0x400L,
	   (FAR_DMEM_HANDLE *) &(_gfx_workspace.buf_mc));
	if (!_gfx_workspace.buf)
		n_kbytes = 0;
	}
else _gfx_workspace.buf = (UTINY_FAR *)user_buf;
_gfx_workspace.n_kbytes_free = _gfx_workspace.n_kbyte_buf = n_kbytes;
GFX_GATE_OPEN
return n_kbytes;
}

#if defined (USE_PAS_M2)
	void FreeGFXWorkspace(void)
#elif defined (USE_UPPER_C)
	void FREE_GFX_WORKSPACE(void)
#elif defined (USE_LOWER_C)
	void free_GFX_workspace(void)
#endif
{

GFX_GATE_CLOSE
_gfx_free_GFX_workspace();
GFX_GATE_OPEN
}

LOCAL_Void_FCN _gfx_free_GFX_workspace(void)
{
_gfx_farfree_mc(_gfx_workspace.buf_mc);
zfill((TINY *) &_gfx_workspace, sizeof(WORKSPACE));
}

/*~ LOVUCLIP.C */

Void_FCN _gfx_set_view_clip_coor(INT set_to_viewport, VIEW *view, INT *clip_coor)
{
INT *view_coor;

view_coor = clip_coor;
switch (set_to_viewport) {

	case 0:						/* set clipping to edges of screen */
		view->min_x = view->min_y = 0;
		view->max_x = _gfx.screen_x_res - 1;
		view->max_y = _gfx.screen_y_res - 1;
		break;

	case 1:						/* set clipping to edges of viewport */
		view_coor = &(view->view_ul_x);

	default:						/* set clipping to passed coordinates */
		_gfx_move(view_coor, &(view->min_x), sizeof(INT) * 4);
		break;
	}
}

/*~ GFXSCRN.C */

	/*  This function determines what kind of video card is installed and
	 *  what type of monitor is attatched and sets the '_gfx.card_monitor'
	 *  variable approrpiately.  If it finds a card that supports both the
	 *  EGA and Hercules cards, as many of today,s EGA clones do, and a
	 *  monochrome monitor is attatced, it will set the fact that both types
	 *  of card are present.  In this case, the	SCREEN() function will
	 *  sense this and will return a NULL.	The programmer must then have
	 *  some other way of determining whether to treat the card as an EGA
	 *  card in monochrome, or as a Hercules card.  You may need to querry
	 *  your user for this information, as there is no accepted way of
	 *  distinguishing between the two possibilities.
	 */

GFX_GATE_PRO;

#if defined (USE_PAS_M2)
	UINT GetCardMonitor(void)
#elif defined (USE_UPPER_C)
	UINT GET_CARD_MONITOR(void)
#elif defined (USE_LOWER_C)
	UINT get_card_monitor(void)
#endif
{

GFX_GATE_CLOSE
if (_gfx.card_monitor == 0) then _gfx_get_card_type();
GFX_GATE_OPEN
return _gfx.card_monitor;
}

Void_FCN _gfx_get_card_type(void)
{
FAST INT toggle;
REG reg;

reg._x.ax = 0x1A00; 	/* First check for VGA */
call_crt(reg);
if ((reg._hl.al == 0x1A) AND
   ((reg._hl.bl == 7) OR (reg._hl.bl == 8) OR (reg._hl.bl == 0xB)) ) {
	if (reg._hl.bl == 7) then _gfx.card_monitor = VGA_CARD | MONO_DISPLAY;
	else _gfx.card_monitor = VGA_CARD | VGA_DISPLAY;
	return;
	}
reg._x.ax = 0x1200; 		/* now check for an EGA card */
reg._x.bx = 0xFF10;
reg._x.cx = 0xF;
call_crt(reg);
toggle = reg._hl.cl;
if (inrange(6, toggle, 0xC) AND (reg._hl.bh < 2) AND (reg._hl.bl < 4) AND !(_gfx_lpeek(0x87, 0x40) & 8)) {
	if (toggle < 9)
		_gfx.card_monitor = COLOR_DISPLAY | EGA_CARD;
	else if (toggle == 9)
		_gfx.card_monitor = EGA_DISPLAY | EGA_CARD;
	else
		_gfx.card_monitor = MONO_DISPLAY | EGA_CARD |
		  ((_gfx_check_hercules_card()) ? HERC_CARD : 0);
	}
else {
	int86(0x11, &reg, &reg);
	if ((reg._hl.al & 0x30) == 0x30)
		_gfx.card_monitor = MONO_DISPLAY |
		   ((_gfx_check_hercules_card()) ? HERC_CARD : MDA_CARD);
	else _gfx.card_monitor = COLOR_DISPLAY | CGA_CARD;
	}
}

LOCAL_Void_PRO check_for_ansi_sys(void);

LOCAL UINT last_mode = 0xFF;
LOCAL TINY xlat_ega_mode[] = {EGA_COLOR, VGA_COLOR, 50};
LOCAL UTINY_FAR xlat_mode[] = {0, 0, 0, 0, 1, 1, 2, 0, 0, 0, 0, 0, 0,
						 3, 3, 3, 3, 4, 4};

	/*  SCREEN() takes a mode, translates it into the appropriate bios video
	 *  mode, then makes a bios call to set the mode, and finally calls
	 *  INIT_GFX_STRUCT to initialize the _gfx structure.
	 */

#if defined (USE_PAS_M2)
	INT Screen(FAST INT mode)
#elif defined (USE_UPPER_C)
	INT SCREEN(FAST INT mode)
#elif defined (USE_LOWER_C)
	INT screen(FAST INT mode)
#endif
{
FAST UINT bios_mode;
INT is_mono_display;
REG_HL reg;

	/* This first clause is only executed the first time SCREEN is called.
	 */
if (last_mode == 0xFF) {
	if (!_gfx.card_monitor) then _gfx_get_card_type();
	if (!_gfx.card_monitor OR ((_gfx.card_monitor & EGA_HERC) == EGA_HERC)) {
		return _gfx_err_number(BAD_VIDEO, SCREEN_FCN);
		}
	check_for_ansi_sys();
	_gfx.xlat_scale = -_gfx.xlat_scale;
	reg.ah = 15;
	call_crt(reg);
	_gfx.orig_bios_mode = _gfx.bios_mode = (UINT) reg.al;
	_gfx.x_org = _gfx.y_org = _gfx.x_dir = _gfx.y_dir = 0;
	last_mode = (reg.al <= VGA_COLOR) ? (UINT) xlat_mode[reg.al] : 5;
	}

else if (mode == -1) {
	if (_gfx.orig_bios_mode > 256)
		mode = FORCE_BIOS_MODE + _gfx.orig_bios_mode;
	else return 0;
	}

	/* A little initialization
	 */
_gfx.bytes_per_row = 80;
bios_mode = _gfx.min_x = _gfx.min_y = 0;
if (mode == DFLT) then mode  = last_mode;
is_mono_display = ((_gfx.card_monitor & (MONO_DISPLAY | VGA_CARD)) == MONO_DISPLAY) ? 1 : 0;

	/*  The next set of of lines will try to determine the proper video
	 *  mode to use.
	 */
if ((_gfx.card_monitor & CGA_CARD) AND !(mode & FORCE_BIOS_MODE)) {
	if (mode > 2) then mode = (mode == EGA_MONO) ? 2 : 1;
	}
else if ((_gfx.card_monitor & HERC_CARD) AND (mode != 0)) then mode = 2;
else if (_gfx.card_monitor & MDA_CARD) {
	_gfx_puts("Sorry, no graphics on a Monchrome Display Card\n");
	exit(1);
	}
else if ((mode == 4) AND !(_gfx.card_monitor & VGA_CARD)) then mode = 3;
else if (mode & FORCE_BIOS_MODE) {
	bios_mode = mode & ~FORCE_BIOS_MODE;
	if (bios_mode == ATT_GFX) then mode = 6;
	else if (bios_mode <= MONO_TEXT) then mode = (UINT) xlat_mode[bios_mode];
	else {
		if (bios_mode <= EGA_COLOR) then mode = 3;
		else if (bios_mode <= VGA_COLOR) then mode = 4;
		else mode = 5;
		}
	}
else if (mode >= VGA_COLOR){
	bios_mode = mode >> 8;
	mode = (bios_mode <= EGA_COLOR) ? 3 : 4;
	}

	/*  Now we go from a logical mode # (0-6) to bios mode # and maybe set a
	 *  few more parameters.
	 */
switch (mode) {

	case 0:
		if (last_mode == 1) {
			reg.ah = 0;
			reg.al = HI_RES_BW;
			call_crt(reg);
			}
		bios_mode = (_gfx.card_monitor & MONO_DISPLAY) ? MONO_TEXT : COLOR_80_TEXT;
		_gfx_set_screen_base(CGA_MEM);
		_gfx.min_x = _gfx.min_y = 1;
		_gfx.gfx_mode = 0;
		break;

	case 1:							/* medium resolution CGA */
#if (USE_MED_RES_CODE == 1)
		bios_mode =  MED_RES_COLOR;
		break;
#endif
	case 2:							/* monochrome GFX */
		bios_mode = (_gfx.card_monitor & HERC_CARD) ? HERC_GFX : HI_RES_BW;
		break;

	case 3:							/* EGA mode (640 x 350) */
	case 4:							/* VGA mode (640 x 480) */
	case 5:							/* user defined mode EGA modes */
		if (!bios_mode)
			bios_mode = (INT) xlat_ega_mode[mode-3] - is_mono_display;

	case 6:
		break;


	default:
		return _gfx_err_number(BAD_ARG, SCREEN_FCN);
	}

last_mode = mode;
	/* Finally, set new GFX mode
	 */
if ((bios_mode != _gfx.bios_mode) AND (bios_mode != NO_MODE_CHANGE)) {

		/* If it's Hercules graphics use our function
		 */
	if (bios_mode == HERC_GFX) {
		_gfx_set_screen_base(0xB000);
		_gfx_set_herc_gfx_mode();
		}
	else {					/* Otherwise, use the BIOS */
		reg.ah = 0;
		reg.al = (UTINY) ((bios_mode == ATT_GFX) ?	0x40 : bios_mode);
		call_crt(reg);
		}
	_gfx.fgnd = 7;				/* set default colors */
	_gfx.bkgnd = 0;
	}
if (mode > 0)
	init_GFX_struct(bios_mode);	/* set up the _gfx parameters */
_gfx.bios_mode = bios_mode;
return SUCCESS;				/* Bye Bye */
}


	/*  check_for_ansi_sys() determines if ANSI.SYS is loaded.	If your
	 *  software doesn't care about ANSI.SYS (which is only useful in TEXT
	 *  mode) you can safely replace this function with a shell.
	 */

LOCAL_Void_FCN check_for_ansi_sys(void)
{
#if defined (USE_GFX_ANSI)

REG_HL reg;
INT row, col;

if (_gfx.ansi_is_loaded == 0xFF) {
	reg.ah = 3;				/* get current cursor position */
	reg.bh = 0;
	call_crt(reg);
	row = reg.dh;
	col = reg.dl;
	reg.ah = 2;				/* reset cursor to (1, 1) */
	reg.dh = 1;
	reg.dl = 1;
	call_crt(reg);
	_gfx_puts("\33[1C");          /* send ANSI code to move cursor */
	reg.ah = 3;				/* forward by one column */
	call_crt(reg); 			/* check cursor position */
	_gfx.ansi_is_loaded = YES;
	if (reg.dl > 2) {			/* too far forward ==> ansi isn't loaded */
		_gfx.ansi_is_loaded = NO;
		_gfx_puts("\b\b\b\b    ");  /* erase text on screen */
		}
	reg.ah = 2;				/* reset cursor to original position */
	reg.dh = (UTINY)row;
	reg.dl = (UTINY)col;
	call_crt(reg);
	}
#endif
}


/*~ GET_PT.C */

	/*  _get_int_pt() reads logical, and possibly relative, integer coordinates
	 *  from the stack, translates them into logical coordinates and records
	 *  them in _gfx.ilog_x & _gfx.ilog_y, and then takes the logical values
	 *  and calculates the correct physical screen coordiantes, and writes
	 *  them to _gfx.pt_x and _gfx.pt_y.
	 */


	/*  gfx_crsr is a pointer to the cursor structure.  Using a pointer lets
	 *  you control more than one graphics cursor at a time by managing this
	 *  pointer.  This is done in the Font library to manage a text cursor
	 *  that is independent of the graphics cursor.
	 */


CRSR *gfx_crsr = (CRSR *)(&_gfx.pt_x);
INT __gfx_scale_points ISTAT_0;
INT __gfx_scale_val ISTAT_0;
COOR_PT *_gfx_cpt ISTAT_0;
LOCAL INT is_abs_point = 0;

Int_FCN _get_int_pt(INT *arg)
{
FAST INT x, y;
INT jump_n_args, first_arg;

first_arg = *arg;
if (__gfx_scale_points) {
	__gfx_scale_val = _gfx_xlat_coor(FROM_LOG_TO_ABS | __gfx_scale_points, first_arg);
	__gfx_scale_points = 0;
	return 1;
	}
else if (first_arg == CURR_PT)	/* use current point */
	return 1;

else if (first_arg == STEP) {		/* a relative point? */
	x = (gfx_crsr->ilog_x += *(arg+1));
	y = (gfx_crsr->ilog_y += *(arg+2));
	jump_n_args = 3;
	}
else {						/* or an absolute point? */
	x = gfx_crsr->ilog_x = first_arg;
	y = gfx_crsr->ilog_y = *(arg+1);
	jump_n_args = 2;
	}
if (is_abs_point > 0) {
	gfx_crsr->pt_x = x;
	gfx_crsr->pt_y = y;
	}
else  {
	if (_gfx.auto_scale) {	/* scale the logical point? */
		x = _gfx_xlat_int_coor(x, _gfx.scale.x_num, _gfx.scale.x_denom);
		y = _gfx_xlat_int_coor(y, _gfx.scale.y_num, _gfx.scale.y_denom);
		}
						/* take care of the origin and axes direction */
	gfx_crsr->pt_x = _gfx.x_org + ((_gfx.x_dir < 0) ? -x : x);
	gfx_crsr->pt_y = _gfx.y_org + ((_gfx.y_dir < 0) ? -y : y);
	}
if (_gfx.sys_flags & ROTATE_SCREEN) then _gfx_rotate_coor((ICOOR *) gfx_crsr);
return jump_n_args; 		/* return the # of arguments read */
}

Void_FCN _gfx_rotate_coor(ICOOR *ic)
{
FAST INT x, y;

x = ic->x;
y = ic->y;
if (_gfx.sys_flags & ROTATE_SCREEN_90) {
	ic->x = y;
	ic->y = (_gfx.screen_y_res - 1) - x;
	}
else if (_gfx.sys_flags & ROTATE_SCREEN_270) {
	ic->x = (_gfx.screen_x_res - 1) - y;
	ic->y = x;
	}
}


Void_FCN _gfx_turn_on_abs_point(void)
{
is_abs_point++;
}

Void_FCN _gfx_turn_off_abs_point(void)
{
if (is_abs_point > 0)
	is_abs_point--;
}

Int_FCN _gfx_abs_point_val(void)
{
return is_abs_point;
}

Int_FCN _gfx_xlat_coor(INT type, FAST INT val)
{
FAST INT org;
INT dir, num, denom;

org = 0;
denom = num = dir = 1;
switch (type & (X_POINT | Y_POINT | X_DISTANCE | Y_DISTANCE)) {
	case X_POINT:
		org = _gfx.x_org;
		dir = _gfx.x_dir;

	case X_DISTANCE:
		num = _gfx.scale.x_num;
		denom = _gfx.scale.x_denom;
		break;

	case Y_POINT:
		org = _gfx.y_org;
		dir = _gfx.y_dir;

	case Y_DISTANCE:
		num = _gfx.scale.y_num;
		denom = _gfx.scale.y_denom;
		break;
	}
if (type & FROM_LOG_TO_ABS) {
	if (_gfx.auto_scale)
		val = _gfx_xlat_int_coor(val, num, denom);
	val = org + ((dir < 0) ? -val : val);
	}
else {
	val -= org;
	if (dir < 0) then val = -val;
	if (_gfx.auto_scale)
		val = _gfx_xlat_int_coor(val, denom, num);
	}
return val;
}

/*~ CPOINT.C */

GFX_GATE_PRO;

#if defined (USE_PAS_M2)
	INT AFdecl _gfx_point(INT args, ...)
#elif defined (USE_UPPER_C)
	INT POINT(INT args, ...)
#elif defined (USE_LOWER_C)
	INT AFdecl point(INT args, ...)
#endif
{
FAST INT val;

GFX_GATE_CLOSE
_gfx.get_pt(&args);
if (is_an_ega_mode()) {
	_gfx_set_w2_ega_mode();
	val = _gfx_get_pel(_gfx.pt_x, _gfx.pt_y);  /* get the point's color */
	_gfx_clean_up_ega();
	}
else val = _gfx_get_pel(_gfx.pt_x, _gfx.pt_y);	/* get the point's color */
GFX_GATE_OPEN
return val;
}


/*~ CPSET.C */

GFX_IVEC_PRO;
GFX_GATE_PRO;

#if defined (USE_PAS_M2)
	INT AFdecl _gfx_pset(INT args, ...)
#elif defined (USE_UPPER_C)
	INT PSET(INT args, ...)
#elif defined (USE_LOWER_C)
	INT AFdecl pset(INT args, ...)
#endif
{
FAST INT *arg, val;

GFX_GATE_CLOSE
arg = &args;
GFX_IVEC(VPSET, arg);
arg += _gfx.get_pt(arg);
val = _gfx_get_color(*arg);
turn_on_ega();
val = _gfx_put_pel(_gfx.pt_x, _gfx.pt_y, val);
turn_off_ega();
GFX_GATE_OPEN
return val;
}


/*~ SETCSTAK.C */

LOCAL DMEM_HANDLE stack_mc ISTAT_0;

Int_FCN _gfx_malloc_coor_stack(INT n_coor, INT coor_elem_sz, INT flags)
{
IMPORT GFX_COOR NEAR _gfx_coor;

if (!_gfx_coor.max_n) {
	_gfx_coor.sp = 0;
	_gfx_coor.stack = (INT *)_gfx_malloc_mc(n_coor * coor_elem_sz, &stack_mc);
	if (!_gfx_coor.stack) then return NULL;
	_gfx_coor.elem_sz = coor_elem_sz;
	_gfx_coor.max_n = n_coor;
	_gfx_coor.flags |= flags;
	}
return SUCCESS;
}

Void_FCN _gfx_free_coor_stack(void)
{
IMPORT GFX_COOR NEAR _gfx_coor;

_gfx_free_mc(stack_mc);
zfill(&_gfx_coor, sizeof(GFX_COOR));
}


/*~ CPAIR.C */

#define FORCE_CORNERS	1

Int_FCN _gfx_get_box_coor_pair(INT check_type_stack, INT *args, BOX_COOR *bcp)
{
FAST INT x, y;
INT n, type;

n = _gfx.get_pt(args);
x = _gfx.pt_x;
y = _gfx.pt_y;
n += _gfx.get_pt(args+n);
type = FORCE_CORNERS;
if (((check_type_stack  == _DRAW_LINE) AND (*(args+n+1) == _DRAW_LINE)) OR
   (check_type_stack == _DRAW_LINE+1))
	type = 0;
if ((x > _gfx.pt_x) AND (type == FORCE_CORNERS)) {
	bcp->x1 = _gfx.pt_x;
	bcp->x2 = x;
	}
else {
	bcp->x1 = x;
	bcp->x2 = _gfx.pt_x;
	}
if ((y > _gfx.pt_y) AND (type == FORCE_CORNERS)) {
	bcp->y1 = _gfx.pt_y;
	bcp->y2 = y;
	}
else {
	bcp->y1 = y;
	bcp->y2 = _gfx.pt_y;
	}
if (check_type_stack & CLIP_COOR_PAIR) {
	_gfx_clip_box_coor_pair(bcp);
	if (check_type_stack & SET_WIDTH_HGT) {
		bcp->x2 -= bcp->x1 - 1;
		bcp->y2 -= bcp->y1 - 1;
		}
	}
return n;
}

/*~ CLIPPAIR.C */

Void_FCN _gfx_clip_box_coor_pair(BOX_COOR *bcp)
{
if (bcp->x1 < _gfx.min_x) then bcp->x1 = _gfx.min_x;
if (bcp->y1 < _gfx.min_y) then bcp->y1 = _gfx.min_y;
if (bcp->x2 > _gfx.max_x) then bcp->x2 = _gfx.max_x;
if (bcp->y2 > _gfx.max_y) then bcp->y2 = _gfx.max_y;
}

/*~ DRAWLINE.C */

GFX_IVEC_PRO;
GFX_GATE_PRO;

#if defined (USE_PAS_M2)
	INT AFdecl _gfx_draw_line(INT arg, ...)
#elif defined (USE_UPPER_C)
	INT DRAW_LINE(INT arg, ...)
#elif defined (USE_LOWER_C)
	INT AFdecl draw_line(INT arg, ...)
#endif
{
INT *args, color, val;
BOX_COOR bc;
IMPORT GFX_PAT NEAR _gfx_pat;

GFX_GATE_CLOSE
args = &arg;
GFX_IVEC(VDRAW_LINE, args);
args += _gfx_get_box_coor_pair(_DRAW_LINE+1, args, &bc);
color = _gfx_get_color(*args);
val = _gfx_drawline(bc.x1, bc.y1, bc.x2, bc.y2, color,
  (_gfx.color_flags & LINE_PAT) ? _gfx_pat.line : SOLID_LINE_PAT, 0);
GFX_GATE_OPEN
return val;
}

/*~ BOX.C */

GFX_VVEC_PRO;
GFX_GATE_PRO;

#if defined (USE_PAS_M2)
	void AFdecl _gfx_box(INT arg)
#elif defined (USE_UPPER_C)
	void BOX(INT arg, ... )
#elif defined (USE_LOWER_C)
	void AFdecl box(INT arg, ... )
#endif
{
BOX_COOR bc;
INT n, *args;

GFX_GATE_CLOSE
args = &arg;
GFX_VVEC(VBOX, args);
n = _gfx_get_box_coor_pair(100, args, &bc);
_gfx_fillbox(bc.x1, bc.y1, bc.x2, bc.y2, _gfx_get_color(*(args+n)));
GFX_GATE_OPEN
}


Void_FCN _gfx_fillbox(FAST INT x1, FAST INT y1, INT x2, INT y2, INT color)
{
INT border, n, pattern, dy;
IMPORT GFX_PAT NEAR _gfx_pat;

if ((x1 > _gfx.max_x) OR (x2 < _gfx.min_x) OR  /* outside the viewport? */
    (y1 > _gfx.max_y) OR (y2 < _gfx.min_y))
	return;
border = NO;
dy = y2 - y1;
if (!((_gfx.color_flags & FILL_SOLID) AND (_gfx_pat.fill.pat_color == _gfx_pat.fill.bkgnd_color))
  OR !(_gfx.color_flags & XPARENT)) {
	pattern = (_gfx.color_flags & LINE_PAT) ? _gfx_pat.line : SOLID_LINE_PAT;
	_gfx_drawline(x1, y1, x2, y1, color, pattern, 0);
	if (!dy) then return;
	n = (x2 - x1 + 1) & 0xF;
	if (dy > 1)
		_gfx_drawline(x2, y1+1, x2, y2-1, color, pattern, n);
	n = (n + n + y2 - (y1+1)) & 0xF;
	_gfx_drawline(x1, y2, x2, y2, color, pattern, n);
	n = (n + y2 - (y1+1)) & 0xF;
	if (dy > 1)
		_gfx_drawline(x1, y1+1, x1, y2-1, color, pattern, n);
	border = YES;
	}

if (fill_area()) {
	if (border == YES) {
		if (((x2 - x1) < 2) OR (dy < 2))
			return;
		x1++, x2--, y1++, y2--;
		}
	if (x1 < _gfx.min_x) then x1 = _gfx.min_x;	/* clip the edges */
	if (x2 > _gfx.max_x) then x2 = _gfx.max_x;
	if (y1 < _gfx.min_y) then y1 = _gfx.min_y;
	if (y2 > _gfx.max_y) then y2 = _gfx.max_y;
	if ((x1 > x2) OR (y1 > y2))
		return;
	_gfx_pat.clip_lines = NO;
	_gfx_set_pat_frame_delta(0);
	_gfx_color_box(x1, y1, x2, y2, _gfx_pat.fill.bkgnd_color);
	}
}


/*~ COLORBOX.C */

	/* _gfx_color_box() draws a solid box, it's broken out from the above
	 * function because it is used by other routines.
	 */

Void_FCN _gfx_color_box(INT x1, INT y1, INT x2, INT y2, INT color)
{
IMPORT GFX_PAT NEAR _gfx_pat;

turn_on_ega();
if (_gfx.color_flags & FILL_PAT) {
	_gfx_pat.clip_lines = NO;
	while (y1 <= y2)
		_gfx_fill_fig_with_1_line(x1, y1++, x2, color);
	}
else
	_gfx_fast_hline(x1, y1, x2-x1+1, y2-y1+1, color);
turn_off_ega();
}


/*~ _LINES.C */

	/*  _drawline can draw a line between any two points.	This routine
	 *  spends most of its code calculating the appropriate coordinates for
	 *  a line that goes outside the VIEW.	If the line is inside the
	 *  viewport then almost no time is used for checking for clippin.
	 *
	 *  Once the proper end coordinates are known, it calls one of two
	 *  assembly routines to do the actual drawing.  The actual line
	 *  drawing routines are based on Brensenham's line drawing algorithm
	 *  and will not be explained here.
	 */

INT __gfx_clip_drawline = YES;
INT __gfx_drawline_is_clipped ISTAT_0;

LOCAL_Void_PRO record_hv_line_coor(int, int, int, int, int);
LOCAL_Int_PRO	__idiv(long, int);

Int_FCN _gfx_drawline(INT x1, INT y1, INT x2, INT y2, INT color, INT pattern, INT start_bit)
{
FAST INT adx, ady;
INT step, max_x, max_y, min_y, temp, i;
INT dir, len, d, d1, d2, flip_x_dir, mem_step, adx1, ady1;
BOX_COOR bc;
IMPORT GFX_COOR NEAR _gfx_coor;

__gfx_drawline_is_clipped = NO;
if (pattern == SOLID_LINE_PAT) {		/* is this a solid line? */
	len = 0;
	if (y1 == y2) {		/* trap for a horizontal line */
		bc.x1 = x1, bc.x2 = x2, bc.y1 = bc.y2 = y1;
		__gfx_drawline_is_clipped = _gfx_set_coor_pair((INT *) &bc);
		if ((__gfx_drawline_is_clipped < 5) OR !__gfx_clip_drawline) {
			if ((len = bc.x2-bc.x1+1) >= 1) {		/* use &y2 for Pas/M2 */
				if (!(_gfx.color_flags & XPARENT)) {
					turn_on_ega();
					_gfx_fast_hline(bc.x1, bc.y1, len, 1, color);
					turn_off_ega();
					}
				if (_gfx.color_flags & RECORD_PTS)
					record_hv_line_coor(bc.x1, bc.y1, 1, 0, len);
				}
			}
		return len;
		}
	if (x1 == x2) {		/* trap for a vertical line */
		bc.x1 = bc.x2 = x1, bc.y1 = y1, bc.y2 = y2;
		__gfx_drawline_is_clipped = _gfx_set_coor_pair((INT *) &bc);
		if ((__gfx_drawline_is_clipped < 5) OR !__gfx_clip_drawline) {
			if ((len = bc.y2-bc.y1+1) >= 1) {		/* use &y2 for Pas/M2 */
				if (!(_gfx.color_flags & XPARENT)) {
					turn_on_ega();
					_gfx_asm_vline(bc.x1, bc.y1, len, color);
					turn_off_ega();
					}
				if (_gfx.color_flags & RECORD_PTS)
					record_hv_line_coor(bc.x1, bc.y1, 0, 1, len);
				}
			}
		return len;
		}
	}
flip_x_dir = 0;
if (x2 < x1) {
	flip_x_dir = 1;
	swap(x1, x2, temp);
	swap(y1, y2, temp);
	}
adx = x2 - x1;
ady = y2 - y1;
if (_gfx.color_flags & RECORD_PTS)
	mem_step = ((adx ^ ady) < 0) ? -1 : 1;
step = (ady < 0) ? -1 : 0;
if (ady < 0) then ady = -ady;

	/* clip on x?
	 */
if (((x2 > _gfx.max_x) OR (x1 < _gfx.min_x)) AND __gfx_clip_drawline) {
	__gfx_drawline_is_clipped = YES;
	if ((x1 > _gfx.max_x) OR (x2 < _gfx.min_x)) then return 0;
	max_y = max(y1, y2);
	max_x = x2;
	adx1 = adx+1;
	ady1 = ady+1;
	if (x2 > _gfx.max_x) {
		if (adx) {
			if (y1 < y2) y2 -= __idiv((LONG)ady1 * (x2 - _gfx.max_x), adx1);
			else y2 = max_y - __idiv((LONG)ady1 * (_gfx.max_x - x1+1), adx1);
			}
		x2 = _gfx.max_x;
		}
	if (x1 < _gfx.min_x) {
		if (adx) {
			if (y1 < y2) then y1 = max_y - __idiv((LONG)ady1 * (max_x - _gfx.min_x + 1), adx1);
			else y1 -= __idiv((LONG)ady1 * (_gfx.min_x - x1), adx1);
			}
		x1 = _gfx.min_x;
		}
	if ((adx = x2 - x1) < 0) then return 0;
	ady = y2 - y1;
	if (ady < 0) then ady = -ady;
	}
max_y = max(y1, y2);
min_y = min(y1, y2);

		/* clip on y?
		 */
if (((max_y > _gfx.max_y) OR (min_y < _gfx.min_y)) AND __gfx_clip_drawline) {
	__gfx_drawline_is_clipped = YES;
	if ((min_y > _gfx.max_y) OR (max_y < _gfx.min_y)) then return 0;
	if (max_y > _gfx.max_y)	{
		i = ady ? __idiv((LONG)(adx+1) * (max_y - _gfx.max_y), ady+1) : 0;
		if (max_y == y1) {
			x1 += i;
			y1 = _gfx.max_y;
			}
		else {
			x2 -= i;
			y2 = _gfx.max_y;
			}
		}
	if (min_y < _gfx.min_y)	{
		i = ady ? __idiv((LONG)(adx+1) * (_gfx.min_y - min_y), ady+1) : 0;
		if (min_y == y1) {
			x1 += i;
			y1 = _gfx.min_y;
			}
		else {
			x2 -= i;
			y2 = _gfx.min_y;
			}
		}
	adx = x2 - x1;
	ady = y2 - y1;
	if (ady < 0) then ady = -ady;
	}
dir = 0;
if (adx < ady) {
	if (y1 > y2) then x1 = x2, y1 = y2;
	swap(adx, ady, temp);
	dir = 4;
	flip_x_dir ^= 1;
	}

if ((pattern != SOLID_LINE_PAT) AND flip_x_dir) {
	pattern = _gfx_rev_pat_order(pattern);
	start_bit = (start_bit + adx + 1) & 0xF;
	}

d1 = ady << 1;
d = d1 - adx;
d2 = (ady - adx) << 1;
if (_gfx.color_flags & RECORD_PTS) {
	if ((_gfx_coor.max_n - _gfx_coor.sp) >= adx+1) {
		_gfx_record_line_points(x1, y1, d, d1, d2, mem_step, adx+1, dir,
		   _gfx_coor.stack, _gfx_coor.sp, _gfx_coor.elem_sz);
		_gfx_coor.sp += adx+1;
		}
	}
		    /* Finally, draw the line
			*/
if (!(_gfx.color_flags & XPARENT) AND pattern) {
	turn_on_ega();
	_gfx_asm_line(x1, y1, color, d, d1, d2, step, adx+1, dir, pattern, start_bit);
	turn_off_ega();
	}
return adx+1;
}


LOCAL_Void_FCN record_hv_line_coor(FAST INT x1, FAST INT y1, INT dx, INT dy, INT n_dots)
{
INT *sp, n_elem_words;
IMPORT GFX_COOR NEAR _gfx_coor;

if ((_gfx_coor.max_n - _gfx_coor.sp) >= n_dots) {
	n_elem_words = _gfx_coor.elem_sz >> 1;
	sp = _gfx_coor.stack + (_gfx_coor.sp * n_elem_words);
	_gfx_coor.sp += n_dots;
	while (n_dots--) {
		*sp = x1;
		x1 += dx;
		*(sp+1) = y1;
		y1 += dy;
		sp += n_elem_words;
		}
	}
}


LOCAL_Int_FCN __idiv(LONG num, FAST INT denom)
{
FAST INT remainder;

if (!(num & 0xFFFF0000L)) then return _gfx_idiv((INT)num, denom);
remainder = (INT) (num % denom);
return (INT) (num/denom + (denom <= (remainder >> 1)));
}

	/*  _gfx_fast_hline() draws a horizontal line very quickly,
	 *  using assembly language routines.
	 */

Void_FCN _gfx_fast_hline(FAST INT x, INT y, FAST INT len, INT n_lines, INT color)
{

if (inrange(1, len, 7))	{	/* very short line, be safe */
	while (n_lines--)
		_gfx_asm_line(x, y++, color, -(len-1), 0, -(len-1) << 1, 0, len, 0, SOLID_LINE_PAT, 0);
		}
else _gfx_asm_hline(x, y, len, color, n_lines);	/* call assembly routine */
}


/*~ FILL_FIG.C */

LOCAL INT pat_delta = 0;

IMPORT GFX_PAT NEAR _gfx_pat;

Void_FCN _gfx_fill_fig_with_1_line(FAST INT x1, FAST INT y1, INT x2, INT fill_color)
{
INT dlx, drx, len;

dlx = drx = pat_delta;
if (_gfx_pat.clip_lines) {
	if ((x1 > _gfx.max_x) OR (x2 < _gfx.min_x)) then return;
	if (x1 < _gfx.min_x) {
		x1 = _gfx.min_x;
		dlx = 0;
		}
	if (x2 > _gfx.max_x) {
		x2 = _gfx.max_x;
		drx = 0;
		}
	}
x1 += dlx;
if ((len = x2-x1+1-drx) >= 1) {
	if (_gfx.color_flags & FILL_SOLID)
		_gfx_fast_hline(x1, y1, len, 1, fill_color);
	else
		(*_gfx_pat.line_fcn)(x1, y1, len);
	}
}

Void_FCN _gfx_set_pat_frame_delta(INT delta)
{

pat_delta = delta;
if (delta < 0) {
	pat_delta = 0;
	if (((_gfx.color_flags & (FILL_PAT + XPARENT)) == FILL_PAT) OR
	   ((_gfx.color_flags & FILL_SOLID) AND (_gfx_pat.fill.frame_color != _gfx_pat.fill.bkgnd_color)) OR
	   (_gfx.color_flags & XOR_PEL))
		pat_delta = 1;
	}
}

/*~ LINE_PAT.C */

#if defined (USE_PAS_M2)
	void SetLinePat(UINT pat)
#elif defined (USE_UPPER_C)
	void SET_LINE_PAT(UINT pat)
#elif defined (USE_LOWER_C)
	void set_line_pat(UINT pat)
#endif
{
IMPORT GFX_PAT NEAR _gfx_pat;

#if (PROT_MODE_SYS != PMODE_32)
_gfx_pat.line = pat;
#else
_gfx_pat.line = pat | (pat << 16);
#endif
}


/*~ FILL_PAT.C */

GFX_GATE_PRO;

#if defined (USE_PAS_M2)
	void SetFillPat(UTINY *pat, INT pat_color, INT bkgnd_color)
#elif defined (USE_UPPER_C)
	void SET_FILL_PAT(UTINY *pat, INT pat_color, INT bkgnd_color)
#elif defined (USE_LOWER_C)
	void set_fill_pat(UTINY *pat, INT pat_color, INT bkgnd_color)
#endif
{

GFX_GATE_CLOSE
_gfx_set_fill_pat(pat, pat_color, bkgnd_color);
GFX_GATE_OPEN
}

Void_FCN _gfx_set_fill_pat(UTINY *pat, INT pat_color, INT bkgnd_color)
{
IMPORT GFX_PAT NEAR _gfx_pat;

if (pat) {
	_gfx_pat.fill.n_bytes = (INT) (*pat);
	_gfx_pat.fill.n_rows = (INT) (*(pat+1));
	_gfx_pat.fill.bitmap = pat+2;
	_gfx_pat.fill.init_pat_color = pat_color;
	}
_gfx_pat.fill.init_bkgnd_color = bkgnd_color;
_gfx_pat.line_fcn = _gfx_pat_line;
}


	/*  _gfx_pat_line() draws a pattern line specified by the programmer.
	    The n_lines argument can also indicate that two pattern
	    lines should be drawn so many scan lines apart, by setting the
	    # scan lines in the split and ORing in the phrase SPLIT_LINES.
	 */

LOCAL INT med_res_colors[] = {0, 0x55, 0xAA, 0xFF};

Void_FCN _gfx_pat_line(INT x, INT y, INT len)
{
FAST INT n_lpels, n_rpels;
INT lmask, rmask, init_offset, n_bytes, pat_color;
UTINY *pat_ptr, new_pat[80];
IMPORT GFX_PAT NEAR _gfx_pat;
IMPORT UTINY NEAR _lbitmask[];
IMPORT UTINY NEAR _rbitmask[];

	/* Get a pointer to the desired pattern line.
	 */
pat_ptr = _gfx_pat.fill.bitmap + ((y % _gfx_pat.fill.n_rows) * _gfx_pat.fill.n_bytes);
pat_color = _gfx_pat.fill.pat_color;

	/*  The major issues handled in this big if-else is to determine how
	 *  many bytes the line will be,  get the masks for the partial bytes
	 *  at each end of the line, and the first byte in the pattern to use.
	 */
#if (USE_MED_RES_CODE == 1)
if (_gfx.gfx_mode == MED_RES) {
	_gfx_dbl_pattern(pat_ptr, new_pat, _gfx_pat.fill.n_bytes, pat_color);
	pat_ptr = new_pat;
	n_lpels = 4 - (x & 0x3);
	if (n_lpels >= len) {
		rmask = n_bytes = 0;
		lmask = _rbitmask[(4 - n_lpels) << 1] & _rbitmask[(4 - (n_lpels - len)) << 1];
		}
	else {
		n_rpels = (len - n_lpels) & 0x3;
		if (!n_rpels) then n_rpels = 4;
		n_bytes = ((len - (n_lpels + n_rpels)) >> 2) + 1;
		lmask = _rbitmask[8 - (n_lpels << 1)];
		rmask = _lbitmask[n_rpels << 1];
		}
	init_offset = (x >> 2) % (_gfx_pat.fill.n_bytes << 1);
	pat_color = med_res_colors[pat_color & 0x3];
	}
else
#endif

if (_gfx.n_colors == 256) {
	n_bytes = len;
	init_offset = x % _gfx_pat.fill.n_bytes;
	rmask = lmask = 0;
	}
else {
	n_lpels = 8 - (x & 0x7);
	if (n_lpels >= len) {
		rmask = n_bytes = 0;
		lmask = _lbitmask[8-n_lpels] & _rbitmask[8 - (n_lpels - len)];
		}
	else {
		n_rpels = (len - n_lpels) & 0x7;
		if (!n_rpels) then n_rpels = 8;
		n_bytes = ((len - (n_lpels + n_rpels)) >> 3) + 1;
		lmask = _lbitmask[8-n_lpels];
		rmask = _rbitmask[n_rpels];
		}
	init_offset = (x >> 3) % _gfx_pat.fill.n_bytes;
	}

	/*  Now that we've got the parameters, draw it!
	 */

if ((UINT)_gfx_pat.fill.init_bkgnd_color != XPARENT)
	_gfx_fast_hline(x, y, len, 1, _gfx_pat.fill.bkgnd_color);
_gfx_asm_pat_hline(x, y, pat_color, n_bytes, pat_ptr, _gfx_pat.fill.n_bytes, init_offset, rmask, lmask);
}

/*~ POLYLINE.C */

GFX_IVEC_PRO;
GFX_GATE_PRO;

#if (PROT_MODE_SYS == 32)
#define SIGN_BIT		0x80000000
#else
#define SIGN_BIT		0x8000
#endif

typedef struct _xye {int x, y, edge;} XYEREC;

LOCAL_Int_PRO xlat_point_list(int *, int, ICOOR *);

#if defined (USE_PAS_M2)
	INT AFdecl _gfx_poly_line(INT arg, ...)/* POLY_LINE(x1, y1, coor, n_points, color); */
#elif defined (USE_UPPER_C)
	INT POLY_LINE(INT arg, ...)
#elif defined (USE_LOWER_C)
	INT AFdecl poly_line(INT arg, ...)
#endif
{
FAST INT next_edge_n, n_dots;
INT i, n, *edge_list, do_line, polyline_is_clipped, n_points, edge_color;
UINT j;
INT loop_n, start_bit, y_vertex, pat, *coor, *args, fill_color;
INT step, diff, edge_n, last_diff, redraw, n_edges, orig_color_flags;
DMEM_HANDLE vertices_mc;
ICOOR *pt, *vertices;
XYEREC *xye, *xye_temp;
IMPORT INT __gfx_drawline_is_clipped, __gfx_clip_drawline;
IMPORT GFX_PAT NEAR _gfx_pat;
IMPORT GFX_COOR NEAR _gfx_coor;

GFX_GATE_CLOSE
args = &arg;
GFX_IVEC(VPOLY_LINE, args);
args += _gfx.get_pt(args);

		/* Translate the virtual coordinate list
		 * into absolute screen coordinates.
		 */

coor = *(INT **)args;
args += POINTER_ON_STACK;
n_points = *args;
edge_color = _gfx_get_color(*(args+1));

vertices = (ICOOR *)_gfx_malloc_mc(sizeof(XYEREC) * (n_points+1), &vertices_mc);
if (!vertices OR (n_points = xlat_point_list(coor, n_points, vertices)) < 2) {
	_gfx_free_mc(vertices_mc);
	GFX_GATE_OPEN
	return FAILURE;
	}

		/* If figure is to be filled, then make sure it is closed
		 */
orig_color_flags = _gfx.color_flags;
if (fill_area()) {
	fill_color = (_gfx.color_flags & FILL_PAT) ?
	 _gfx_pat.fill.pat_color : _gfx_pat.fill.bkgnd_color;
	pt = vertices + n_points;
	if (((pt-1)->x != vertices[0].x) OR ((pt-1)->y != vertices[0].y)) {
		pt->x = vertices[0].x;
		pt->y = vertices[0].y;
		pt++, n_points++;
		}
	pt->x = vertices[1].x;
	pt->y = vertices[1].y;
	_gfx.color_flags |= XPARENT;
	}

		/* loop twice -- first time to draw the polyline figure
		 * and get the total number of dots drawn, the second time to
		 * record the dots' coordinates in the _gfx_coor.stack buffer.
		 */
redraw = polyline_is_clipped = NO;
xye = (XYEREC *) 0;

REDRAW_OUTLINE:
pat = (_gfx.color_flags & LINE_PAT) ? _gfx_pat.line : SOLID_LINE_PAT;
turn_on_ega();
_gfx_force_off_planes();
for (loop_n = 1; loop_n <= 2; loop_n++) {
	pt = vertices;
	edge_n = n_dots = start_bit = 0;
	last_diff = -1000;
	for (i = 0; i < (n_points-1); i++, pt++) {
		y_vertex = (pt+1)->y;
		n = _gfx_drawline(pt->x, pt->y, (pt+1)->x, y_vertex, edge_color, pat, start_bit);
		start_bit = (start_bit+n-1)&0xF;
		if (loop_n == 1) {
			if ((_gfx.color_flags & (XPARENT | XOR_PEL)) == XOR_PEL) {
				turn_on_ega();
				_gfx_put_pel((pt+1)->x, y_vertex, edge_color);
				}
			if ((__gfx_drawline_is_clipped != 0) AND (fill_area())) {
				__gfx_clip_drawline = NO;
				n = _gfx_drawline(pt->x, pt->y, (pt+1)->x, y_vertex, 0, 0, 0);
				polyline_is_clipped = __gfx_clip_drawline = YES;
				}
			}
		else {
			diff = pt->y - y_vertex;
			if (diff | last_diff) then edge_n = i;
			for (j = n_dots; j < (UINT) _gfx_coor.sp; j++)
				xye[j].edge = edge_n;
			j = (pt+2)->y - y_vertex;
			if (j == 0) then j = SIGN_BIT;
			if ((diff ^ j) & SIGN_BIT) {
				step = -1;
				j = _gfx_coor.sp - 1;
				if (xye[j].y != y_vertex) {
					step = 1;
					j = n_dots;
					}
				while ((xye[j].y == y_vertex) AND (xye[j].edge == i)) {
					xye[j].y = 30000;
					j += step;
					}
				}
			last_diff = diff;
			}
		n_dots += n;
		}
	if (loop_n == 1) {
		if (!fill_area() OR redraw) {
			_gfx_force_on_planes();
			turn_off_ega();
			_gfx_free_mc(vertices_mc);
			GFX_GATE_OPEN
			return SUCCESS;
			}
		if (!_gfx_malloc_coor_stack(n_dots+2, sizeof(XYEREC), 0)) {
			_gfx_free_mc(vertices_mc);
			GFX_GATE_OPEN
			return NULL;
			}
		(pt+1)->y = (vertices+1)->y;
		xye = (XYEREC *) _gfx_coor.stack;
		_gfx.color_flags |= (XPARENT + RECORD_PTS);
		zfill(xye, _gfx_coor.max_n * _gfx_coor.elem_sz);
		__gfx_clip_drawline = NO;
		pat = 0;
		}
	}
__gfx_clip_drawline = YES;

			/* Sort the points for the fill
			 */
_gfx_qsort(xye, n_dots, sizeof(XYEREC));

			/* Clip the polygon's top and bottom outside of viewport.
			 */
_gfx_pat.clip_lines = NO;
if (polyline_is_clipped == YES) {
	while (xye->y < _gfx.min_y) {
		xye++;
		n_dots--;
		}
	xye_temp = xye;
	for (xye += n_dots - 1; xye->y > _gfx.max_y; xye--)
		n_dots--;
	xye = xye_temp;
	_gfx_pat.clip_lines = YES;
	}

			/* Initialize for the fill
			 */
do_line = 0;
edge_list = (INT *) (vertices + n_points);
n_edges = n_points * sizeof(INT);
zfill(edge_list, n_edges);
edge_list[xye->edge] = 1;
_gfx.color_flags = orig_color_flags;

			/* Fill it!
			 */
_gfx_set_pat_frame_delta(-1);
for (i = 0; i < (n_dots-1); i++, xye++) {
	next_edge_n = (xye+1)->edge;
	if (xye->y == (xye+1)->y) {
		if (xye->edge != next_edge_n) {
			if ((edge_list[next_edge_n] != 1) AND (do_line ^= 1) AND
			  ((xye->x+1) < (xye+1)->x) AND (xye->y <= _gfx.max_y)) {
					_gfx_fill_fig_with_1_line(xye->x, xye->y, (xye+1)->x, fill_color);
				}
			edge_list[next_edge_n] = 1;
			}
		}
	else {
		do_line = 0;
		zfill(edge_list, n_edges);
		edge_list[next_edge_n] = 1;
		}
	}
_gfx_force_on_planes();
turn_off_ega();
			/* Clean up and exit
			 */
_gfx_free_coor_stack();
if (fill_area() AND !(_gfx.color_flags & XPARENT)) {
	redraw = YES;
	goto REDRAW_OUTLINE;
	}
_gfx_free_mc(vertices_mc);
GFX_GATE_OPEN
return SUCCESS;
}

LOCAL_Int_PRO merge_horizontal_lines(ICOOR *pt, INT n_points);

LOCAL_Int_FCN xlat_point_list(INT *coor, INT n_coor_pair, ICOOR *vertices)
{
FAST INT n_points;
INT x_org, y_org;
ICOOR *pt;
CRSR save_crsr;
IMPORT CRSR *gfx_crsr;

		/* Translate the virtual coordinate list
		 * into absolute screen coordinates.
		 */
n_points = n_coor_pair;
x_org = _gfx.pt_x - _gfx.x_org;
y_org = _gfx.pt_y - _gfx.y_org;
pt = vertices;
if (_gfx.auto_scale OR (_gfx.x_org | _gfx.y_org != 0)) {
	save_crsr = *gfx_crsr;
	if (_gfx.sys_flags & ROTATE_SCREEN) {
		if (_gfx.sys_flags & ROTATE_SCREEN_270) then x_org -= _gfx.screen_x_res - 1;
		else y_org -= _gfx.screen_y_res - 1;
		}
	while (n_points--) {
		coor += _gfx.get_pt(coor);
		pt->x = _gfx.pt_x + x_org;
		pt->y = _gfx.pt_y + y_org;
		pt++;
		}
	*gfx_crsr = save_crsr;
	}
else while (n_points--) {
	if (_gfx.sys_flags & ROTATE_SCREEN) {
		if (_gfx.sys_flags & ROTATE_SCREEN_90) {
			pt->y = y_org - *coor++;
			pt->x = x_org + *coor++ ;
			}
		else {
			pt->y = y_org + *coor++;
			pt->x = x_org - *coor++ ;
			}
		}
	else {
		pt->x = x_org + *coor++;
		pt->y = y_org + *coor++;
		}
	pt++;
	}
if (fill_area())
	n_coor_pair = merge_horizontal_lines(vertices, n_coor_pair);
return n_coor_pair;
}


LOCAL_Int_FCN merge_horizontal_lines(ICOOR *pt, INT n_points)
{
FAST INT dy, n;
INT last_dy;

n = n_points;
last_dy = -1;
while (n--) {
	dy = pt->y - (pt+1)->y;
	if ((dy | last_dy) == 0) {
		_gfx_move((pt+1), pt, n*sizeof(ICOOR));
		n_points--;
		}
	else {
		pt++;
		last_dy = dy;
		}
	}
return n_points;
}


/*~ CCLS.C */

GFX_GATE_PRO;

#if defined (USE_PAS_M2)
	void Cls()
#elif defined (USE_UPPER_C)
	void CLS()
#elif defined (USE_LOWER_C)
	void cls()
#endif
{
GFX_GATE_CLOSE
_gfx_cls();
GFX_GATE_OPEN
}

Void_FCN _gfx_cls(void)
{
_gfx.color_flags = 0;
_gfx_view_cls((VIEW *) &_gfx.bkgnd, _gfx.bkgnd);
}

Void_FCN _gfx_view_cls(FAST VIEW *view, INT color)
{
#if defined(USE_GFX_TEXT)
REG_HL reg;
IMPORT _gfx_ANSI_attr;
#endif
					/* GRAPHICS MODE */
if (_gfx.gfx_mode) {
	_gfx_color_box(view->min_x, view->min_y, view->max_x, view->max_y, color);
	view->ilog_x = view->min_x + ((view->max_x - view->min_x) >> 1);
	view->ilog_y = view->min_y + ((view->max_y - view->min_y) >> 1);
	}
else {				 /* TEXT MODE */
#if defined(USE_GFX_TEXT)
	reg.ah = 6;
	reg.al = 0;
	reg.bh = _gfx_ANSI_attr;
	reg.ch = 0;
	reg.cl = 0;
	reg.dh = 24;
	reg.dl = 80;
	call_crt(reg);
#endif
	}
}

/*~ OVAL.C */

GFX_VVEC_PRO;
GFX_GATE_PRO;

#if defined (USE_PAS_M2)
	void AFdecl _gfx_oval_fcn(INT args, ...)
#elif defined (USE_UPPER_C)
	void OVAL(INT args, ...)
#elif defined (USE_LOWER_C)
	void AFdecl oval(INT args, ...)
#endif
{
GFX_GATE_CLOSE
GFX_VVEC(VOVAL, &args);
_gfx_get_oval_values_from_stack(&args, 0);
_gfx_draw_oval();
GFX_GATE_OPEN
}


/*~ CIRCLE.C */

	/*  CIRCLE is just a special case of oval(). */

GFX_VVEC_PRO;
GFX_GATE_PRO;

#if defined (USE_PAS_M2)
	void AFdecl _gfx_circle(INT args, ... )
#elif defined (USE_UPPER_C)
	void CIRCLE(INT args, ... )
#elif defined (USE_LOWER_C)
	void AFdecl circle(INT args, ... )
#endif

{

GFX_GATE_CLOSE
GFX_VVEC(VCIRCLE, &args);
_gfx_get_oval_values_from_stack(&args, IS_ROUND);
_gfx_draw_oval();
GFX_GATE_OPEN
}


/*~ LO_OVAL.C */

IMPORT GFX_PAT NEAR _gfx_pat;
IMPORT OVL NEAR _gfx_oval;

LOCAL INT last_dx[2] = {0,0}; 	/* used by no_clip_fill_oval() */
LOCAL INT last_dy[2] ISTAT_ARR_0;	/* used by no_clip_fill_oval() */
LOCAL INT last_rep ISTAT_0;		/* used by no_clip_fill_oval() */
LOCAL INT draw_frame ISTAT_0;		/* used by no_clip_fill_oval() */
LOCAL INT last_y = 0;			/* used by _gfx_general_oval() */

Void_FCN _gfx_draw_oval(void)
{
INT clip_oval;
IMPORT GFX_PAT NEAR _gfx_pat;
IMPORT GFX_COOR NEAR _gfx_coor;

if (_gfx.color_flags & LINE_PAT) {
	if (_gfx_get_arc_points()) {
		_gfx_set_quad_bounds();
		_gfx_oval.quad_mask = 0xF;
		if (_gfx_clip_quads() != OFF_SCREEN) {
			_gfx_oval.chain_arc = _gfx_general_oval;
			_gfx_draw_pat_arc_points(_gfx_pat.line, 0, _gfx_coor.sp >> 1);
			_gfx_oval.chain_arc = 0;
			}
		_gfx_free_coor_stack();
		}
	}
else {
	if ((clip_oval = _gfx_oval_is_clipped()) == OFF_SCREEN) then return;
	_gfx_set_pat_frame_delta(-1);
	if (!clip_oval) {
		if (fill_area()) {
			draw_frame = (_gfx.color_flags & XPARENT) ? NO : YES;
			last_dy[0] = _gfx_oval.y_radius;
			last_rep = 1;
			_gfx_oval.write_pix = _gfx_no_clip_fill_oval;
			}
		else _gfx_oval.write_pix = _gfx_no_clip_outline_oval;
		}
	else _gfx_oval.write_pix = _gfx_general_oval;
	_gfx_draw_curve();
	}
}


Void_FCN _gfx_no_clip_outline_oval(INT dx, INT dy)
{
_gfx_4_pel(_gfx_oval.x_center-dx, _gfx_oval.y_center-dy, dx<<1, dy<<1, _gfx_oval.color);
}


Void_FCN _gfx_no_clip_fill_oval(INT dx, INT dy)
{
FAST INT _dx, _dy;
INT x;

_dx = dx;
_dy = dy;
if (draw_frame)
	_gfx_4_pel(_gfx_oval.x_center-_dx, _gfx_oval.y_center-_dy, _dx<<1, _dy<<1, _gfx_oval.color);
if (last_dy[last_rep] != dy) {
	x = _gfx_oval.x_center - _dx;
	_dx <<= 1;
	_gfx_fill_fig_with_1_line(x, _gfx_oval.y_center-_dy, x + _dx, _gfx_pat.fill.bkgnd_color);
	if (_dy)
		_gfx_fill_fig_with_1_line(x, _gfx_oval.y_center+_dy, x + _dx, _gfx_pat.fill.bkgnd_color);
	last_dy[last_rep] = dy;
	}
last_dx[last_rep] = dx;
last_rep ^= 1;
}


	/* The call to _gfx_quick_4_pel() will draw the four points if they are
	 * all in bounds. Actually, only the upper left and lower right points
	 * are checked.  Any coordinate that is out-of-bounds is marked by
	 * a bit being set in the return.	For the upper-left point, if the
	 * x or y-coordinate is out of bounds then _MIN_X or _MIN_Y bit will
	 * be set, and likewise for the lower-right point the _MAX_X or
	 * _MAX_Y bit will be set.
	 */

#define _MIN_X		0x8
#define _MAX_X		0x4
#define _MIN_Y		0x2
#define _MAX_Y		0x1

Void_FCN _gfx_general_oval(INT dx, INT dy)
{
FAST INT ul_x, flags;
INT ul_y, lr_x, lr_y;
IMPORT GFX_PAT NEAR _gfx_pat;


flags = _gfx_quick_4_pel(_gfx_oval.x_center-dx, _gfx_oval.y_center-dy, dx<<1, dy<<1,
  _gfx_oval.color | (_gfx.color_flags & XPARENT));
if (((flags + fill_area()) == 0) OR (flags == 0xF)) then return;

ul_x = _gfx_oval.x_center-dx;
ul_y = _gfx_oval.y_center-dy;
dx <<= 1;
dy <<= 1;
lr_x = ul_x + dx;
lr_y = ul_y + dy;

if (fill_area() AND (ul_y != last_y)) {
	if (lr_x > 2) {
		if (!(flags & _MIN_Y))
			_gfx_fill_fig_with_1_line(ul_x, ul_y, lr_x, _gfx_pat.fill.bkgnd_color);
		if (!(flags & _MAX_Y) AND (dy != 0))
			_gfx_fill_fig_with_1_line(ul_x, lr_y, lr_x, _gfx_pat.fill.bkgnd_color);
		}
	last_y = ul_y;
	}

if (!(_gfx.color_flags & XPARENT) AND flags) {
	if (!(flags & (_MIN_X + _MIN_Y))) {
		if (flags & _MAX_X) then dx = 0;
		if (flags & _MAX_Y) then dy = 0;
		_gfx_4_pel(ul_x, ul_y, dx, dy, _gfx_oval.color);
		}
	else if (!(flags & (_MAX_X + _MAX_Y))) {
		if (!(flags & _MIN_X))
			_gfx_4_pel(ul_x, lr_y,	dx, 0, _gfx_oval.color);
		else if (!(flags & _MIN_Y))
			_gfx_4_pel(lr_x, ul_y,	0, dy, _gfx_oval.color);
		else
			_gfx_put_pel(lr_x, lr_y, _gfx_oval.color);
		}
	else {
		if (!(flags & (_MAX_X + _MIN_Y)))
			_gfx_put_pel(lr_x, ul_y, _gfx_oval.color);
		if (!(flags & (_MIN_X + _MAX_Y)))
			_gfx_put_pel(ul_x, lr_y, _gfx_oval.color);
		}
	}
}


/*~ ARCPTS.C */


Int_FCN _gfx_get_arc_points(void)
{
IMPORT OVL NEAR _gfx_oval;

if (!_gfx_malloc_coor_stack(_gfx_oval.x_radius+_gfx_oval.y_radius, sizeof(ICOOR), 0))
	return NULL;
_gfx_oval.write_pix = _gfx_record_arc_coor;
_gfx_draw_curve();
return SUCCESS;
}


/*~ LOPATARC.C */

IMPORT OVL NEAR _gfx_oval;

Void_FCN _gfx_draw_pat_arc_points(INT arc_pat_mask, INT start_sp, INT n_dots)
{
FAST INT n, quad_mask;
INT *sp, n_elem_words, pat_mask[4], fill_it;
IMPORT GFX_COOR NEAR _gfx_coor;

n = n_dots << 1;
pat_mask[3] = _gfx_ror_pattern(arc_pat_mask, (n-2)+12);
pat_mask[2] = _gfx_ror_pattern(arc_pat_mask, (n-1)+13);
pat_mask[1] = _gfx_ror_pattern(arc_pat_mask, ((n<<1)-3) + 14);
pat_mask[0] = _gfx_ror_pattern(arc_pat_mask, 15);
sp = _gfx_coor.stack + start_sp;
n_elem_words = _gfx_coor.elem_sz / sizeof(INT);
quad_mask = _gfx_oval.quad_mask;
fill_it = (fill_area() AND _gfx_oval.chain_arc);
turn_on_ega();
while (n_dots--) {
	if ((_gfx_oval.quad_mask = quad_mask & _gfx_arc_rot_pat_masks(pat_mask)) != 0) {
		_gfx_oval_quad_pix(*sp, *(sp+1));
		}
	if (fill_it) then (*_gfx_oval.chain_arc)(*sp, *(sp+1));
	sp += n_elem_words;
	}
turn_off_ega();
return;
}


/*~ DR_CURVE.C */

	/* This data structure keeps all relevant info for all oval functions */

OVL NEAR _gfx_oval = { 0, 0, 0, 0, 3, 4 } ;

#define MAX_ANGLE		3600

	/* All curve functions call _gfx_get_oval_values_from_stack() to take
	 * function arguments from the stack and set the _gfx_oval structure.
	 */

Void_FCN _gfx_get_oval_values_from_stack(FAST INT *args, FAST INT type)
{
IMPORT INT __gfx_scale_points, __gfx_scale_val;
IMPORT ICOOR NEAR _gfx_video_aspect_ratio;
INT temp;

args += _gfx.get_pt(args);			/* first get the (x,y) center */
_gfx_oval.x_center = _gfx.pt_x;
_gfx_oval.y_center = _gfx.pt_y;
__gfx_scale_points = X_DISTANCE;		/* now the x-radius */
args += _gfx.get_pt(args);
_gfx_oval.x_radius = abs(__gfx_scale_val);
if (type & IS_ROUND)				/* if circular, calculate y-radius */
	_gfx_oval.y_radius = _gfx_xlat_int_coor(_gfx_oval.x_radius,
	  _gfx.screen_y_res * _gfx_video_aspect_ratio.y,
	  _gfx.screen_x_res * _gfx_video_aspect_ratio.x);
else {							/* otherwise get it from the stack */
	__gfx_scale_points = Y_DISTANCE;
	args += _gfx.get_pt(args);
	_gfx_oval.y_radius = __gfx_scale_val;
	}
if (_gfx_oval.y_radius < 0)
	_gfx_oval.y_radius = -_gfx_oval.y_radius;
if (type & USES_ANGLES) {			/* get the angles */
	if ((_gfx_oval.start_angle = *args++ % MAX_ANGLE) < 0)
		_gfx_oval.start_angle += MAX_ANGLE;
	if ((_gfx_oval.angle_width = *args++ % MAX_ANGLE) < 0) {
		_gfx_oval.angle_width = -_gfx_oval.angle_width;
		_gfx_oval.start_angle = (MAX_ANGLE + _gfx_oval.start_angle -
		   _gfx_oval.angle_width) % MAX_ANGLE;
		}
	}
else {
	_gfx_oval.start_angle = 0;
	_gfx_oval.angle_width = 3600;
	_gfx_oval.x_end = _gfx_oval.x_start = _gfx_oval.x_center + _gfx_oval.x_radius;
	_gfx_oval.y_end = _gfx_oval.y_start = _gfx_oval.y_center;
	}
if (_gfx.sys_flags & ROTATE_SCREEN) {
	temp = _gfx_oval.x_radius;
	_gfx_oval.x_radius = _gfx_oval.y_radius;
	_gfx_oval.y_radius = temp;
	if (type & USES_ANGLES) {
		_gfx_oval.start_angle += (_gfx.sys_flags&ROTATE_SCREEN_90) ? 900 : 2700;
		_gfx_oval.start_angle %= MAX_ANGLE;
		}
	}
_gfx_oval.color = _gfx_get_color(*args);	/* and the color */
_gfx_oval.clip_oval = NO;
}


#define scale_aspect(val, scale)		(INT) (((long)val * (long)scale) >> 16)

Void_FCN _gfx_draw_curve(void)
{
FAST UINT x_aspect, y_aspect;
INT dx, d1x, d2x, dy, d1y, d2y, sum;

x_aspect = y_aspect = sum = dx = 0;
if (_gfx_oval.x_radius > _gfx_oval.y_radius)
	y_aspect = (unsigned int) ((0x10000L * (long) _gfx_oval.y_radius) / (long) _gfx_oval.x_radius);
else if (_gfx_oval.x_radius < _gfx_oval.y_radius)
	x_aspect = (unsigned int) ((0x10000L * (long) _gfx_oval.x_radius) / (long) _gfx_oval.y_radius);
dy = (_gfx_oval.x_radius > _gfx_oval.y_radius) ? _gfx_oval.x_radius : _gfx_oval.y_radius;
dy <<= 1;
turn_on_ega();
while (dx <= dy+1) {
	if ((dx&1) == 0) {
		d1x = d2x = dx>>1;
		d1y = d2y = (dy+1)>>1;
		if (x_aspect) {
			d1x = scale_aspect(d1x, x_aspect);
			d2y = scale_aspect(d1y, x_aspect);
			}
		else if (y_aspect) {
			d1y = scale_aspect(d1y, y_aspect);
			d2x = scale_aspect(d1x, y_aspect);
			}
		(*_gfx_oval.write_pix)(d1x, d1y);
		if ((d1x ^ d2y) | (d1y ^ d2x))
			(*_gfx_oval.write_pix)(d2y, d2x);
		}
	if ((sum += (dx++ << 1) + 1) > 0) {
		sum -= (dy << 1) - 1;
		dy--;
		}
	}
turn_off_ega();
}


Void_FCN _gfx_record_arc_coor(INT dx, INT dy)
{
IMPORT GFX_COOR NEAR _gfx_coor;

*(_gfx_coor.stack + _gfx_coor.sp) = dx;
*(_gfx_coor.stack + _gfx_coor.sp + 1) = dy;
_gfx_coor.sp += _gfx_coor.elem_sz / sizeof(INT);
if (_gfx_oval.chain_arc)
	(*_gfx_oval.chain_arc)(dx, dy);
}


Void_FCN _gfx_set_quad_bounds(void)
{
zfill(_gfx_oval.quad_bnd, sizeof(_gfx_oval.quad_bnd));
_gfx_oval.quad_bnd[0].max_x = _gfx_oval.quad_bnd[1].max_x = _gfx_oval.quad_bnd[2].max_x = _gfx_oval.quad_bnd[3].max_x = _gfx_oval.x_radius;
_gfx_oval.quad_bnd[0].max_y = _gfx_oval.quad_bnd[1].max_y = _gfx_oval.quad_bnd[2].max_y = _gfx_oval.quad_bnd[3].max_y = _gfx_oval.y_radius;
}


Void_FCN _gfx_oval_quad_pix(FAST INT dx, FAST INT dy)
{
INT x, y, mask, do_1pel;

mask = _gfx_check_pix(dx, dy, _gfx_oval.quad_mask, _gfx_oval.quad_bnd, _gfx_oval.inv_quad, _gfx_oval.clip_oval, _gfx_oval.clip_bnd);
x = _gfx_oval.x_center-dx;				/* assume dot in quad 2 */
y = _gfx_oval.y_center-dy;
dx <<= 1;
dy <<= 1;
if (mask >= 8) {
	if (mask == 0xF) {
		_gfx_4_pel(x, y,  dx, dy, _gfx_oval.color);
		return;
		}
	_gfx_put_pel(x+dx, y+dy, _gfx_oval.color); /* dot in quad 4 */
	mask -= 8;				/* draw dots in other 3 quads */
	}
do_1pel = YES;
switch (mask) {
	case 0:						/* no dots */
		return;
	case 1:						/* 1 dot quad 1 */
		x += dx;
	case 2:						/* 1 dot quad 2 */
		break;
	case 3:						/* 2 dots quad 1,2 */
		do_1pel = dy = 0;
		break;
	case 4:						/* 1 dot quad 3 */
		y += dy;
		break;
	case 5:						/* 2 dots quad 1,3 */
		_gfx_put_pel(x+dx, y, _gfx_oval.color);
		y += dy;
		break;
	case 6:						/* 2 dots quad 2,3 */
		dx = do_1pel = 0;
		break;
	case 7:						/* 3 dots quad 1,2,3 */
		_gfx_put_pel(x+dx, y, _gfx_oval.color);
		dx = do_1pel = 0;
		break;
	}
if (do_1pel == YES)
	_gfx_put_pel(x, y, _gfx_oval.color);
else
	_gfx_4_pel(x, y,  dx, dy, _gfx_oval.color);
}




/*~ PI_SLICE.C */

IMPORT INT __gfx_clip_drawline;
IMPORT GFX_PAT NEAR _gfx_pat;
IMPORT GFX_COOR NEAR _gfx_coor;
IMPORT OVL NEAR _gfx_oval;
IMPORT TINY _gfx_n_quad_table[];

LOCAL_Int_PRO	draw_edges_of_pie_slice(int, int, int);
LOCAL_Int_PRO	_gfx_low_pie_slice(INT *args, INT is_round_flag);
LOCAL_Void_PRO get_edges(void);

LOCAL ICOOR *icp ISTAT_0;
LOCAL INT lx[4] ISTAT_ARR_0;
LOCAL INT rx[4] ISTAT_ARR_0;
LOCAL INT n_edges ISTAT_0;
LOCAL INT corner_y = -1;
LOCAL INT min_corner_delta_y ISTAT_0;
LOCAL INT no_clip_quad_mask ISTAT_0;
LOCAL CLIP_REGION no_clip_quad_bnd[4] ISTAT_ARR_0;

GFX_IVEC_PRO;
GFX_GATE_PRO;

#if defined (USE_PAS_M2)
	INT AFdecl _gfx_oval_pie_slice(INT args, ...)
#elif defined (USE_UPPER_C)
	INT OVAL_PIE_SLICE(INT args, ...)
#elif defined (USE_LOWER_C)
	INT AFdecl oval_pie_slice(INT args, ...)
#endif
{
INT val;

GFX_GATE_CLOSE
GFX_IVEC(VOVAL_PIE_SLICE, &args);
val = _gfx_low_pie_slice(&args, 0);
GFX_GATE_OPEN
return val;
}

#if defined (USE_PAS_M2)
	INT AFdecl _gfx_pie_slice(INT args, ...)
#elif defined (USE_UPPER_C)
	INT PIE_SLICE(INT args, ...)
#elif defined (USE_LOWER_C)
	INT AFdecl pie_slice(INT args, ...)
#endif
{
INT val;

GFX_GATE_CLOSE
GFX_IVEC(VPIE_SLICE, &args);
val = _gfx_low_pie_slice(&args, IS_ROUND);
GFX_GATE_OPEN
return val;
}

LOCAL_Int_FCN _gfx_low_pie_slice(INT *args, INT is_round_flag)
{
FAST INT y;
INT y2, n_dots, i;

_gfx_get_oval_values_from_stack(args, USES_ANGLES+is_round_flag);
_gfx_set_arc_parameters();
if (!fill_area()) {
	if (_gfx_clip_quads() == OFF_SCREEN) then return SUCCESS;
	if ((_gfx_oval.n_quad = _gfx_n_quad_table[_gfx_oval.quad_mask & 0xF]) != 0) {
		_gfx_draw_oval_arc();
		draw_edges_of_pie_slice(_gfx_oval.color, YES, 0);
		return SUCCESS;
		}
	return FAILURE;
	}

_gfx_move(_gfx_oval.quad_bnd, no_clip_quad_bnd, sizeof(no_clip_quad_bnd));
no_clip_quad_mask = _gfx_oval.quad_mask;
if (_gfx_clip_quads() == OFF_SCREEN) then return SUCCESS;
_gfx_oval.n_quad = (INT) _gfx_n_quad_table[_gfx_oval.quad_mask & 0xF];
if (!_gfx_oval.n_quad) then return FAILURE;
_gfx_pat.clip_lines = _gfx_oval_is_clipped();
draw_edges_of_pie_slice(_gfx_oval.color, YES, 0);

n_dots = draw_edges_of_pie_slice(0, NO, 0);/* # of dots in edges */

n_dots = (_gfx_oval.x_radius+_gfx_oval.y_radius) * ((_gfx_oval.angle_width + 899) / 900) +
   max(_gfx_oval.x_radius, _gfx_oval.y_radius) * 2;
if (!_gfx_malloc_coor_stack(n_dots, sizeof(ICOOR), 0))		/* Set up dot stack */
	return FAILURE;
icp = (ICOOR *) _gfx_coor.stack;
zfill(icp, n_dots * sizeof(ICOOR));
draw_edges_of_pie_slice(0, NO, XPARENT+RECORD_PTS);	/* Set dots from edges */
_gfx_oval.write_pix = _gfx_record_arc_dots;			/* Now for the arc */
_gfx_draw_curve();

_gfx_qsort(_gfx_coor.stack, _gfx_coor.sp, sizeof(ICOOR));	/* Sort the points */
y2 = min((icp+_gfx_coor.sp-1)->y-1, _gfx.max_y);	/* Clip lowest scan lines */
for (y = icp->y; icp->y == y; icp++);
while (icp->y < _gfx.min_y)					/* Clip highest scan lines */
	icp++;
turn_on_ega();
_gfx_set_pat_frame_delta(-1);
for (y = icp->y; y <= y2; icp++, y++) {			/* Fill it 1 line at a time */
	n_edges = 0;
	get_edges();
	if (n_edges > 1) {
		if (n_edges == 3) {
			if (abs(y-_gfx_oval.y_center) < min_corner_delta_y) {
				n_edges++;
				rx[3] = rx[2], lx[3] = lx[2];
				rx[2] = rx[1], lx[2] = lx[1];
				}
			else {
				n_edges--;
				if (y == corner_y) {
					rx[0] = rx[1];
					lx[1] = lx[2];
					}
				}
			}
		for (i = 0; i < n_edges; i += 2)
			_gfx_fill_fig_with_1_line(rx[i], y, lx[i+1], _gfx_pat.fill.bkgnd_color);
		}
	}
turn_off_ega();							/* Clean up */
_gfx_free_coor_stack();
return SUCCESS;
}

LOCAL_Void_FCN get_edges(void)
{
FAST INT y;

y = icp->y;
lx[n_edges] = icp->x;
while ((icp->x+1 >= (icp+1)->x) AND (y == (icp+1)->y))
	icp++;
rx[n_edges++] = icp->x;
if ((icp+1)->y == y) {
	icp++;
	get_edges();
	}
}


Void_FCN _gfx_record_arc_dots(INT dx, INT dy)
{
FAST INT i;
INT mask, *sp;
IMPORT GFX_COOR NEAR _gfx_coor;

mask = _gfx_check_pix(dx, dy, no_clip_quad_mask, no_clip_quad_bnd, _gfx_oval.inv_quad, 0, (CLIP_REGION *) 0);
sp = _gfx_coor.stack + (_gfx_coor.sp * 2);
for (i = 8; i != 0; i >>= 1) {
	if (i & mask) {
		*sp++ = _gfx_oval.x_center + ((i & (8+1)) ? dx : -dx);
		*sp++ = _gfx_oval.y_center + ((i & (8+4)) ? dy : -dy);
		_gfx_coor.sp++;
		}
	}
_gfx_oval_quad_pix(dx, dy);
}

LOCAL_Int_FCN draw_edges_of_pie_slice(INT color, INT clip, INT flags)
{
INT n, x1, y1, x2, y2, end_angle, pat;

__gfx_clip_drawline = clip;
_gfx.color_flags |= flags;
pat = 0;
if (clip == YES)
	pat = (_gfx.color_flags & LINE_PAT) ? _gfx_pat.line : SOLID_LINE_PAT;
x1 = inrange(900, _gfx_oval.start_angle, 2700) ? -_gfx_oval.x_start : _gfx_oval.x_start;
y1 = _gfx_oval.y_center +
  ((_gfx_oval.start_angle < 1800) ? -_gfx_oval.y_start : _gfx_oval.y_start);
n = _gfx_drawline(_gfx_oval.x_center, _gfx_oval.y_center,
  _gfx_oval.x_center + x1, y1, color, pat, 0);
end_angle = (_gfx_oval.start_angle + _gfx_oval.angle_width) % 3600;
x2 = inrange(900, end_angle, 2700) ? -_gfx_oval.x_end : _gfx_oval.x_end;
y2 = _gfx_oval.y_center +
   ((end_angle < 1800) ? -_gfx_oval.y_end : _gfx_oval.y_end);
n += _gfx_drawline(_gfx_oval.x_center, _gfx_oval.y_center,
   _gfx_oval.x_center + x2, y2, color, pat, 0);
__gfx_clip_drawline = YES;
_gfx.color_flags &= ~flags;
corner_y = (x1 < x2) ? y1 : y2;
y1 = abs(y1-_gfx_oval.y_center);
y2 = abs(y2-_gfx_oval.y_center);
min_corner_delta_y = ((y1 < y2) ? y1 : y2) - 1;
return n;
}

/*~ OVAL_ARC.C */

GFX_VVEC_PRO;
GFX_GATE_PRO;

#if defined (USE_PAS_M2)
	void AFdecl _gfx_oval_arc(INT args, ...)
#elif defined (USE_UPPER_C)
	void OVAL_ARC(INT args, ...)
#elif defined (USE_LOWER_C)
	void AFdecl oval_arc(INT args, ...)
#endif
{
GFX_GATE_CLOSE
GFX_VVEC(VOVAL_ARC, &args);
_gfx_get_oval_values_from_stack(&args, USES_ANGLES);
_gfx_draw_oval_arc();
GFX_GATE_OPEN
}

/*~ CIRC_ARC.C */

GFX_VVEC_PRO;
GFX_GATE_PRO;

#if defined (USE_PAS_M2)
	void AFdecl _gfx_circle_arc(INT args, ...)
#elif defined (USE_UPPER_C)
	void CIRCLE_ARC(INT args, ...)
#elif defined (USE_LOWER_C)
	void AFdecl circle_arc(INT args, ...)
#endif
{
GFX_GATE_CLOSE
GFX_VVEC(VCIRCLE_ARC, &args);
_gfx_get_oval_values_from_stack(&args, USES_ANGLES+IS_ROUND);
_gfx_draw_oval_arc();
GFX_GATE_OPEN
}

/*~ LO_OVARC.C */

IMPORT OVL NEAR _gfx_oval;

TINY _gfx_n_quad_table[] = { 0, 1, 1, 2, 1, 2, 2, 3,
					    1, 2, 2, 3, 2, 3, 3, 4
					  };

Void_FCN _gfx_draw_oval_arc(void)
{
FAST INT i;
IMPORT GFX_PAT NEAR _gfx_pat;
IMPORT GFX_COOR NEAR _gfx_coor;

_gfx_set_arc_parameters();
if (_gfx_clip_quads() == OFF_SCREEN) then return;
if ((_gfx_oval.n_quad = _gfx_n_quad_table[_gfx_oval.quad_mask & 0xF]) != 0) {
	if (_gfx.color_flags & LINE_PAT) {
		if (_gfx_get_arc_points()) {
			_gfx_draw_pat_arc_points(_gfx_pat.line, 0, _gfx_coor.sp >> 1);
			_gfx_free_coor_stack();
			}
		return;
		}
	if (_gfx_oval.n_quad == 1) {
		for (i = 1; i < 4; i++) {
			if (_gfx_oval.quad_mask & (1<<i))
				_gfx_oval.quad_bnd[0] = _gfx_oval.quad_bnd[i];
			}
		_gfx_oval.write_pix = _gfx_arc_box_1_quad;
		}
	else _gfx_oval.write_pix = _gfx_oval_quad_pix;
	_gfx_draw_curve();
	}
}


LOCAL TINY quad_mask_table[][4] = { { 1,  3,  7, 15 },
							 { 2,  6, 14, 15 },
							 { 4, 12, 13, 15 },
							 { 8,  9, 11, 15 }
						    };

LOCAL_Void_PRO _gfx_set_arc_end_points(int end_angle);

Void_FCN _gfx_set_arc_parameters(void)
{
FAST INT end_quad, start_quad;
INT end_angle, inv_quad;

start_quad = _gfx_oval.start_angle / 900;
end_angle = _gfx_oval.start_angle + _gfx_oval.angle_width;
end_quad = (end_angle - 1) / 900;
_gfx_oval.quad_mask = quad_mask_table[start_quad][(end_quad-start_quad)&3];
end_quad &= 3;
inv_quad = _gfx_oval.inv_quad = 0;
if ((end_quad == start_quad) AND (_gfx_oval.angle_width > 1800)) {
	_gfx_oval.quad_mask = 0xF;
	_gfx_oval.inv_quad = 1 << end_quad;
	inv_quad = 1;
	}

_gfx_set_arc_end_points(end_angle);

_gfx_set_quad_bounds();
if ((start_quad & 1) ^ inv_quad) {
	_gfx_oval.quad_bnd[start_quad].min_x = _gfx_oval.x_start;
	_gfx_oval.quad_bnd[start_quad].max_y = _gfx_oval.y_start;
	}
else {
	_gfx_oval.quad_bnd[start_quad].max_x = _gfx_oval.x_start;
	_gfx_oval.quad_bnd[start_quad].min_y = _gfx_oval.y_start;
	}
if ((end_quad & 1) ^ inv_quad) {
	_gfx_oval.quad_bnd[end_quad].max_x = _gfx_oval.x_end;
	_gfx_oval.quad_bnd[end_quad].min_y = _gfx_oval.y_end;
	}
else {
	_gfx_oval.quad_bnd[end_quad].min_x = _gfx_oval.x_end;
	_gfx_oval.quad_bnd[end_quad].max_y = _gfx_oval.y_end;
	}
}


#if (USE_FLOAT)

LOCAL_Int_FCN round_abs_dbl(DBL val)
{
if (val < 0.0) then val = -val;
return (INT) (val + 0.5);
}

#define ONE_TENTH_DEGREE			(PI/1800.0)

LOCAL_Void_FCN _gfx_set_arc_end_points(INT end_angle)
{
DBL radians;

radians = _gfx_oval.start_angle * ONE_TENTH_DEGREE;
_gfx_oval.x_start = round_abs_dbl(_gfx_oval.x_radius * cos(radians));
_gfx_oval.y_start = round_abs_dbl(_gfx_oval.y_radius * sin(radians));
radians = end_angle * ONE_TENTH_DEGREE;
_gfx_oval.x_end = round_abs_dbl(_gfx_oval.x_radius * cos(radians));
_gfx_oval.y_end = round_abs_dbl(_gfx_oval.y_radius * sin(radians));
}

#else

LOCAL_Void_FCN _gfx_set_arc_end_points(INT end_angle)
{
_gfx_oval.x_start = _gfx_calc_trig_point(_gfx_oval.start_angle, _gfx_oval.x_radius, IS_COSINE);
_gfx_oval.y_start = _gfx_calc_trig_point(_gfx_oval.start_angle, _gfx_oval.y_radius, 0);
_gfx_oval.x_end = _gfx_calc_trig_point(end_angle, _gfx_oval.x_radius, IS_COSINE);
_gfx_oval.y_end = _gfx_calc_trig_point(end_angle, _gfx_oval.y_radius, 0);
}

#endif


LOCAL CLIP_REGION view_clip[4] ISTAT_ARR_0;

Int_FCN _gfx_clip_quads(void)
{
INT clip;

clip = _gfx_oval_is_clipped();
if ((clip != OFF_SCREEN) AND (clip >= 1)) {
	_gfx_oval.clip_bnd = view_clip;
	_gfx_oval.clip_oval = YES;
	zfill(view_clip, sizeof(view_clip));

	view_clip[1].max_x = view_clip[2].max_x = _gfx_oval.x_center - _gfx.min_x;
	if (view_clip[1].max_x < 0) {
		view_clip[0].min_x = view_clip[3].min_x = -view_clip[1].max_x;
		_gfx_oval.quad_mask &= ( 1 + 8 );
		}
	view_clip[3].max_x = view_clip[0].max_x = _gfx.max_x - _gfx_oval.x_center;
	if (view_clip[3].max_x < 0) {
		view_clip[1].min_x = view_clip[2].min_x = -view_clip[3].max_x;
		_gfx_oval.quad_mask &= ( 2 + 4 );
		}

	view_clip[1].max_y = view_clip[0].max_y = _gfx_oval.y_center - _gfx.min_y;
	if (view_clip[1].max_y < 0) {
		view_clip[2].min_y = view_clip[3].min_y = -view_clip[1].max_y;
		_gfx_oval.quad_mask &= ( 4 + 8 );
		}
	view_clip[3].max_y = view_clip[2].max_y = _gfx.max_y - _gfx_oval.y_center;
	if (view_clip[3].max_y < 0) {
		view_clip[1].min_y = view_clip[0].min_y = -view_clip[3].max_y;
		_gfx_oval.quad_mask &= ( 1 + 2 );
		}
	}
return clip;
}

#define _MIN_X		0x8
#define _MAX_X		0x4
#define _MIN_Y		0x2
#define _MAX_Y		0x1

Int_FCN _gfx_oval_is_clipped(void)
{
FAST INT clip;
IMPORT GFX_PAT NEAR _gfx_pat;

clip = _gfx_quick_4_pel(_gfx_oval.x_center - _gfx_oval.x_radius, _gfx_oval.y_center - _gfx_oval.y_radius,
  _gfx_oval.x_radius<<1, _gfx_oval.y_radius<<1, XPARENT);
if ((clip & (_MIN_X+_MAX_X)) == _MIN_X + _MAX_X) {
	if (((_gfx_oval.x_center + _gfx_oval.x_radius) < _gfx.min_x) OR
	  ((_gfx_oval.x_center - _gfx_oval.x_radius) > _gfx.max_x))
		clip = OFF_SCREEN;
	}
if ((clip & (_MIN_Y+_MAX_Y)) == _MIN_Y + _MAX_Y) {
	if (((_gfx_oval.y_center + _gfx_oval.y_radius) < _gfx.min_y) OR
	  ((_gfx_oval.y_center - _gfx_oval.y_radius) > _gfx.max_y))
		clip = OFF_SCREEN;
	}
_gfx_pat.clip_lines = clip;
return clip;
}


Void_FCN _gfx_arc_box_1_quad(FAST INT dx, FAST INT dy)
{

if (inrange(_gfx_oval.quad_bnd[0].min_x, dx, _gfx_oval.quad_bnd[0].max_x) AND
    inrange(_gfx_oval.quad_bnd[0].min_y, dy, _gfx_oval.quad_bnd[0].max_y)) {
	_gfx_put_pel(_gfx_oval.x_center + ((_gfx_oval.quad_mask & (8+1)) ? dx : -dx),
		    _gfx_oval.y_center + ((_gfx_oval.quad_mask & (8+4)) ? dy : -dy),
		    _gfx_oval.color);
	}
}


/*~ TRIGPNT.C */


Uint_FCN _gfx_calc_trig_point(INT angle, INT radius, INT is_cosine)
{
LONG val, factor;

val = _gfx_sin_cos(angle, (is_cosine ? IS_COSINE : 0) + USE_ABS);
factor = 100000L;
if (radius > 10000) {
	val = (val + 5) / 10;
	factor = 10000L;
	}
return (UINT) (((radius * val) + (factor>>1)) / factor);
}


/*~ SINCOS.C */

LOCAL LONG_FAR sine_table[] = {
		    0L,	1745L,   3490L,   5234L,   6976L,	 8716L,
		10453L,  12187L,  13917L,  15643L,  17365L,	19081L,
		20791L,  22495L,  24192L,  25882L,  27564L,	29237L,
		30902L,  32557L,  34202L,  35837L,  37461L,	39073L,
		40674L,  42262L,  43837L,  45399L,  46947L,	48481L,
		50000L,  51504L,  52992L,  54464L,  55919L,	57358L,
		58779L,  60182L,  61566L,  62932L,  64279L,	65606L,
		66913L,  68200L,  69466L,  70711L,  71934L,	73135L,
		74314L,  75471L,  76604L,  77715L,  78801L,	79864L,
		80902L,  81915L,  82904L,  83867L,  84805L,	85717L,
		86603L,  87462L,  88295L,  89101L,  89879L,	90631L,
		91355L,  92050L,  92718L,  93358L,  93969L,	94552L,
		95106L,  95630L,  96126L,  96593L,  97030L,	97437L,
		97815L,  98163L,  98481L,  98769L,  99027L,	99255L,
		99452L,  99619L,  99756L,  99863L,  99939L,	99985L,
	    100000L};

Long_FCN _gfx_sin_cos(FAST INT degree, INT flags)
{
FAST INT index;
INT tenth_degree, delta_index;
LONG val;

if (flags & IS_COSINE) then degree += 900;
if (degree < 0) then degree = -degree + 1800;
tenth_degree = degree % 10;
degree %= 3600;
degree /= 10;
index = degree % 90;
delta_index = 1;
if (((degree / 90) & 1) == 1) {
	index = 90 - index;
	delta_index = -1;
	}
val = sine_table[index];
val += ((sine_table[index + delta_index] - val) * tenth_degree) / 10;
return ((degree < 180) OR (flags & USE_ABS)) ? val : -val;
}


/*~ ASPECT.C */


#if defined (USE_PAS_M2)
	void SetVideoAspectRatio(INT x_aspect, INT y_aspect)
#elif defined (USE_UPPER_C)
	void SET_VIDEO_ASPECT_RATIO(INT x_aspect, INT y_aspect)
#elif defined (USE_LOWER_C)
	void set_video_aspect_ratio(INT x_aspect, INT y_aspect)
#endif
{
IMPORT ICOOR NEAR _gfx_video_aspect_ratio;

_gfx_video_aspect_ratio.x = x_aspect;
_gfx_video_aspect_ratio.y = y_aspect;
}

#if defined (USE_PAS_M2)
	void GetVideoAspectRatio(INT *x_aspect, INT *y_aspect)
#elif defined (USE_UPPER_C)
	void GET_VIDEO_ASPECT_RATIO(INT *x_aspect, INT *y_aspect)
#elif defined (USE_LOWER_C)
	void get_video_aspect_ratio(INT *x_aspect, INT *y_aspect)
#endif
{
IMPORT ICOOR NEAR _gfx_video_aspect_ratio;

*x_aspect = _gfx_video_aspect_ratio.x;
*y_aspect = _gfx_video_aspect_ratio.y;
}


/*~ GFXOPEN.C */

	/*  The next several modules provide low level file i/o functions.  All
	 *  are pretty simple, they open, close, seek and do i/o with standard
	 *  DOS calls.  Note that several of these functions do not appear to
	 *  be called from other code, but if you look in the GFXG_SRC.H header
	 *  file you'll find macros for them.
	 */

#if (USE_ALT_IO == 1)
ALT_IO _gfx_alt_io;
#endif

Int_FCN gfx_open(TEXT *file_name, INT type_open)
{
REG_X reg;

#if (VDOS386 == 1)
extern void _gfx32_set_IFX_alt_io(void);

if (!_gfx_alt_io.is_hooked)
	_gfx32_set_IFX_alt_io();
#endif

#if (USE_ALT_IO == 1)

#if (USE_GFX_IO == 1)
if (_gfx_alt_io.is_hooked AND
   !_gfx_alt_io.fcn_vec[ALT_GFX_OPEN](file_name, type_open))
	return _gfx_alt_io.rtn_val._int;
#else
_gfx_alt_io.fcn_vec[ALT_GFX_OPEN](file_name, type_open);
return _gfx_alt_io.rtn_val._int;
#endif

#endif

#if (USE_GFX_IO == 1)
reg.ax = type_open; 					/* open for create or read/write */
reg.cx = 0;							/* normal file attribute */
reg.dx = ptr_offset(file_name);			/* filename offset */
call_dosx(reg, file_name, 0);
return good_dos_call(reg) ? (INT)reg.ax : 0;
#endif
}


/*~ GFXCLOSE.C */

Int_FCN gfx_close(UINT dos_handle)
{
REG_X reg;

#if (USE_ALT_IO == 1)
IMPORT ALT_IO _gfx_alt_io;

#if (USE_GFX_IO == 1)
if (_gfx_alt_io.is_hooked AND
   !_gfx_alt_io.fcn_vec[ALT_GFX_CLOSE](dos_handle))
	return _gfx_alt_io.rtn_val._int;
#else
_gfx_alt_io.fcn_vec[ALT_GFX_CLOSE](dos_handle);
return _gfx_alt_io.rtn_val._int;
#endif

#endif

#if (USE_GFX_IO == 1)
if (dos_handle) {
	reg.ax = 0x3E00;			/* function # */
	reg.bx = dos_handle;		/* file's handle */
	call_dos(reg);				/* do it! */
	return (INT) reg.cflag;
	}
return NULL;
#endif
}

/*~ GFXDEL.C */

	/*  Delete (unlink) a file.
	 */
Int_FCN gfx_delete_file(TEXT *filename)
{
REG_X reg;

#if (USE_ALT_IO == 1)
IMPORT ALT_IO _gfx_alt_io;

#if (VDOS386 == 1)
extern void _gfx32_set_IFX_alt_io(void);

if (!_gfx_alt_io.is_hooked)
	_gfx32_set_IFX_alt_io();
#endif

#if (USE_GFX_IO == 1)
if (_gfx_alt_io.is_hooked AND
   !_gfx_alt_io.fcn_vec[ALT_GFX_DELETE_FILE](filename))
	return _gfx_alt_io.rtn_val._int;
#else
_gfx_alt_io.fcn_vec[ALT_GFX_DELETE_FILE](filename);
return _gfx_alt_io.rtn_val._int;
#endif

#endif

#if (USE_GFX_IO == 1)
reg.ax = 0x4100;
reg.dx = ptr_offset(filename);
call_dosx(reg, filename, (REG *) 0);
return reg.cflag;
#endif
}

/*~ GFXMEMIO.C */

#if (USE_VMEM_IO == 1)

IMPORT VMEMIO _gfx_vmem_io[];

Int_FCN gfx_open_mem_file(INT mem_type, UTINY_FAR *buf, LONG max_buf_size)
{
INT i;

if (mem_type & RAM_FILE) {
	for (i = 1; i < MAX_VMEM_HANDLES; i++) {
		if (!_gfx_vmem_io[i].buf_size) {
			_gfx_vmem_io[i].buf_size = max_buf_size;
			_gfx_vmem_io[i].buf = buf;
			_gfx_vmem_io[i].buf_offset = 0L;
			return i & mem_type;
			}
		}
	}
return 0;
}

Int_FCN gfx_close_mem_file(FAST INT fh)
{
FAST INT handle;

handle = fh & 0xFF;
if ((fh & RAM_FILE) AND ((UINT) handle < MAX_VMEM_HANDLES)) {
	_gfx_vmem_io[handle].buf_size = 0;
	return SUCCESS;
	}
return NULL;
}
#endif

/*~ GFX_RDWR.C */

VMEMIO _gfx_vmem_io[1] ISTAT_ARR_0;

	/*	gfx_file_io() reads or writes a block of information to a
	 *	file.  'fcn_type' contains the function # that specifes the
	 *	type of file i/o.  Two macros in GFXG_SRC.H specify 'fcn_type'
	 *	for either reading or writing a file. Note that the buffer pointed
	 *	to by bufptr is forced to be far; this will permit using far
	 *	buffers (EMS, XMS, farmaloc() etc.) for small data programs.
	 */

INT _gfx_file_write_err ISTAT_0;

Int_FCN gfx_file_io(UTINY_FAR * bufptr, UINT n_bytes, INT dos_handle, INT fcn_type)
{
UTINY_FAR *file_memptr;
FAST UINT n, io_bytes;
LONG max_bytes;
REG_X reg;
#if (PROT_MODE_SYS != PMODE_32) || (KOMPACT_32 == 1)
SREGS sregs;
#endif

#if (USE_ALT_IO == 1)
IMPORT ALT_IO _gfx_alt_io;

#if (USE_GFX_IO == 1)
if (_gfx_alt_io.is_hooked AND
   !_gfx_alt_io.fcn_vec[ALT_GFX_FILE_IO](bufptr, n_bytes, dos_handle, fcn_type))
	return _gfx_alt_io.rtn_val._int;
#else
_gfx_alt_io.fcn_vec[ALT_GFX_FILE_IO](bufptr, n_bytes, dos_handle, fcn_type);
return _gfx_alt_io.rtn_val._int;
#endif

#endif

#if (USE_VMEM_IO == 1)
if (dos_handle & RAM_FILE) {
	dos_handle &= 0xFF;
	max_bytes = _gfx_vmem_io[dos_handle].buf_size - _gfx_vmem_io[dos_handle].buf_offset;
	if ((LONG) n_bytes > max_bytes) then n_bytes = (UINT) max_bytes;
	for (n = 0; n < n_bytes; n += io_bytes) {
		io_bytes = _gfx_ptr_in_huge_buf(_gfx_vmem_io[dos_handle].buf,
		   _gfx_vmem_io[dos_handle].buf_offset, &file_memptr, n_bytes);
		if (fcn_type == 0x4000)
			_gfx_far_move(bufptr, file_memptr, io_bytes);
		else
			_gfx_far_move(file_memptr, bufptr, io_bytes);
		_gfx_vmem_io[dos_handle].buf_offset += io_bytes;
		bufptr += io_bytes;
		}
	return n_bytes;
	}
#endif

#if (USE_GFX_IO == 1)
reg.ax = fcn_type;					/* set the function # */
reg.bx = dos_handle;				/* the file handle */
reg.cx = n_bytes;					/* buffer's size */
reg.dx = ptr_offset(bufptr);
#if (PROT_MODE_SYS == PMODE_32) && (KOMPACT_32 != 1)
_gfx_call_86x(0x21, (REG *) &reg, (UTINY *) 0, (UTINY *) 0);
#else
sregs.es = sregs.ds = ptr_segment(bufptr);
int86x(0x21, (REG *) &reg, (REG *) &reg, &sregs);
#endif
_gfx_file_write_err = ((fcn_type == 0x4000) AND (reg.ax != n_bytes)) ? YES : NO;
return good_dos_call(reg) ? (INT)reg.ax : 0;  /* return # of bytes read */
#endif
}


Long_FCN gfx_huge_file_io(UTINY_FAR * bufptr, LONG buf_size, INT dos_handle, INT fcn_type)
{
INT n_bytes, n;
LONG offset;
UTINY_FAR *temp_buf;

offset = 0L;
do {
	n_bytes = (buf_size-offset > 0x4000L) ? 0x4000 : (UINT) (buf_size-offset);
	n_bytes = _gfx_ptr_in_huge_buf(bufptr, offset, &temp_buf, n_bytes);
	n = gfx_file_io(temp_buf, n_bytes, dos_handle, fcn_type);
	offset += n;
	} while ((offset < buf_size) AND (n == n_bytes));
return offset;
}

/*~ HUGEMOVE.C */

#if (PROT_MODE_SYS == PMODE_32)

Uint_FCN _gfx_huge_move(UTINY_FAR *huge_base, LONG huge_offset, 
   UTINY_FAR *small_buf, UINT n_bytes, INT dir)
{

huge_base += huge_offset;
if (dir == SMALL_TO_HUGE)
	_gfx_move(small_buf, huge_base, n_bytes);
else if (dir == HUGE_TO_SMALL)
	_gfx_move(huge_base, small_buf, n_bytes);
return n_bytes;
}

#else

Uint_FCN _gfx_huge_move(UTINY_FAR *huge_base, LONG huge_offset, 
   UTINY_FAR *small_buf, UINT n_bytes, INT dir)
{
FAST UINT i, n;
UTINY_FAR *huge_buf;

for (n = 0; n < n_bytes; n += i)  {
	i = _gfx_ptr_in_huge_buf(huge_base, huge_offset+n, &huge_buf, n_bytes-n);
	if (dir == SMALL_TO_HUGE)
		_gfx_far_move(small_buf+n, huge_buf, i);
	else if (dir == HUGE_TO_SMALL)
		_gfx_far_move(huge_buf, small_buf+n, i);
	else
		break;
	}
return n;
}

#endif

/*~ GFXLSEEK.C */

	/*  gfx_lseek() works exactly like C's lseek().  Values for 'mode' are
	 *	  a. mode == 0 ==> offset is w.r.t. beginning of file.
	 *	  b. mode == 1 ==> offset is w.r.t. current location.
	 *	  c. mode == 2 ==> offset is w.r.t end of the file.
	 *  Of course, it returns the value of the resulting file pointer.
	 */

IMPORT VMEMIO _gfx_vmem_io[];

Long_FCN gfx_lseek(FAST INT dos_handle, LONG l_offset, INT mode)
{
REG_X reg;

#if (USE_ALT_IO == 1)
IMPORT ALT_IO _gfx_alt_io;

#if (USE_GFX_IO == 1)
if (_gfx_alt_io.is_hooked AND
   !_gfx_alt_io.fcn_vec[ALT_GFX_LSEEK](dos_handle, l_offset, mode))
	return _gfx_alt_io.rtn_val._long;
#else
_gfx_alt_io.fcn_vec[ALT_GFX_LSEEK](dos_handle, l_offset, mode);
return _gfx_alt_io.rtn_val._long;
#endif

#endif

#if (USE_VMEM_IO == 1)
if (dos_handle & RAM_FILE) {
	dos_handle &= 0xFF;
	if (mode == 1)
		l_offset += _gfx_vmem_io[dos_handle].buf_offset;
	else if (mode == 2)
		l_offset = _gfx_vmem_io[dos_handle].buf_size - l_offset;
	if (l_offset < 0L)
		l_offset = 0L;
	else if (l_offset > _gfx_vmem_io[dos_handle].buf_size)
		l_offset = _gfx_vmem_io[dos_handle].buf_size;
	return (_gfx_vmem_io[dos_handle].buf_offset = l_offset);
	}
#endif

#if (USE_GFX_IO == 1)
reg.ax = 0x4200 | mode;
reg.bx = dos_handle;
reg.cx = (UINT) (l_offset >> 16);
reg.dx = (UINT)l_offset;
call_dos(reg);
l_offset = (LONG)reg.dx << 16;
return l_offset | (LONG)reg.ax;
#endif
}


/*~ NORMPTR.C */

#ifdef JUNK
void _gfx_normalize_ptr(INT ptr_sz, TINY **ptr)
{
#if (PROT_MODE_SYS == REAL_MODE)
if (ptr_sz == 4) {
#if defined (__HIGHC__)
	*(_huge char **)ptr = *(_huge char **)ptr + (ptr_sz & 0x1000);

#elif defined (__ZTC__)
LONG seg;
	seg = (LONG)(*ptr);
	seg += (seg & 0xFFF0L) << 12;
	*(UTINY_FAR **)ptr = (UTINY_FAR *) (seg & 0xFFFF000FL);
#else
	*(char huge **)ptr = *(char huge **)ptr + (ptr_sz & 0x1000);
#endif
	}
#endif
}
#endif

Uint_FCN _gfx_ptr_in_huge_buf(UTINY_FAR *buf, LONG offset, UTINY_FAR **norm_buf, UINT n_bytes)
{
LONG val;

#if (PROT_MODE_SYS == REAL_MODE) || (PROT_MODE_SYS == PMODE_16)
#if defined (__HIGHC__)
*(_huge char **)norm_buf = (_huge char *)buf + offset;

#elif defined (__ZTC__)
void _far * _pascal hugeptr_add(void _far *h1,long offset);
*norm_buf = hugeptr_add(buf, offset);

#else

*(char huge **)norm_buf = (char huge *)buf + offset;
#endif

buf = *norm_buf;
if ((offset = ptr_offset(buf) + (LONG)n_bytes) >= 0x10000L) {
	n_bytes = 0x8000;
	if ((val = 0xFFFFL - ptr_offset(buf) + 1) != 0L)
		n_bytes = (UINT) val;
	}
#endif

#if (PROT_MODE_SYS == PMODE_32)
*norm_buf = buf + offset;
#endif

return n_bytes;
}


/*~ CALL_86X.C */

	/* call_dosx() is a macro that translates into _gfx_call_86x();
	 */

#if (PROT_MODE_SYS == PMODE_32) && (KOMPACT_32 != 1)

Int_FCN _gfx_call_86x(INT int_nmbr, void *reg, UTINY * ds_buf, UTINY * es_buf)
{
return int86(int_nmbr, (REG *)reg, (REG *)reg);
}

Int_FCN _gfx_farcall_86x(INT int_nmbr, void *reg, UTINY_FAR * ds_buf, UTINY_FAR * es_buf)
{
return int86(int_nmbr, (REG *)reg, (REG *)reg);
}

#else

Int_FCN _gfx_call_86x(INT int_nmbr, void *reg, UTINY * ds_buf, UTINY * es_buf)
{

if (sizeof(char *) == sizeof(int))
	return int86(int_nmbr, (REG *)reg, (REG *)reg);
else
	return _gfx_farcall_86x(int_nmbr, reg, ds_buf, es_buf);
}


Int_FCN _gfx_farcall_86x(INT int_nmbr, void *reg, UTINY_FAR * ds_buf, UTINY_FAR * es_buf)
{
SREGS sregs;

sregs.ds = ptr_segment(ds_buf);
sregs.es = ptr_segment(es_buf);
return int86x(int_nmbr, (REG*)reg, (REG *)reg, &sregs);
}

#endif


/*~ GFX256.C */

LOCAL_Int_PRO	is_AHEAD(void);
LOCAL_Int_PRO	is_ATI(void);
LOCAL_Int_PRO	is_TSENG(void);
LOCAL_Int_PRO	is_TRIDENT(void);
LOCAL_Int_PRO	is_WD(void);
LOCAL_Int_PRO	is_HEADLAND(void);
LOCAL_Int_PRO	is_OAK(void);
LOCAL_Int_PRO	is_GENOA(void);
LOCAL_Int_PRO	is_GENOA_bios(void);
LOCAL_Int_PRO	is_S3(void);
LOCAL_Int_PRO	is_CIRRUS(void);

LOCAL_Int_PRO CIRRUS_bios_call(INT _AL, INT fcn_n);

LOCAL_Int_PRO	match_bios_string(UINT bios_offset, TEXT *id_string);
LOCAL_Int_PRO	find_bios_string(TEXT *id_string);
LOCAL_Int_PRO	write_VGA_reg(INT port_n, INT port_index, INT write_val);
LOCAL_Int_PRO	in_VGA_index(INT port_n, INT index);
LOCAL_Void_PRO out_VGA_index(INT port_n, INT index, INT val);
LOCAL_Void_PRO check_for_VESA(void);
LOCAL_Void_PRO initialize_VESA_switching(int mode_n);
LOCAL_Int_PRO	can_rw_port(INT port_n, INT index, INT val);

LOCAL INT CRTC_port = 0;

		/* The structure that holds info on Super VGA cards */
SVGA NEAR svga_card = {0};

#define N_CHIPSETS		    9	//(sizeof(is_CARD)/sizeof(is_CARD[0]))

#if defined (__HIGHC__)
LOCAL INT HC_near (_pascal *is_CARD[])(void) =
#else
LOCAL INT (_pascal _near *is_CARD[])(void) =
#endif
	{ is_ATI, is_WD, is_TSENG, is_HEADLAND,
	  is_TRIDENT, is_AHEAD, is_OAK, is_GENOA, is_S3, is_CIRRUS};

INT_FAR VESA_bios[][N_EXTD_MODES] =
  /* 6x40x2,6x48x2,8x60x1,8x60x2,1x76x1,1x76x2,1x10x1,1x10x2 */
   { {0x100, 0x101, 0x102, 0x103, 0x104, 0x105, 0x106, 0x107},	/* VESA	 */
	{0x061, 0x062, 0x054, 0x063, 0x055, 0x064, 0x000, 0x000},	/* ATI	 */
	{0x05E, 0x05F, 0x058, 0x05C, 0x05D, 0x000, 0x000, 0x000},	/* WD	 */
	{0x02F, 0x02E, 0x029, 0x030, 0x037, 0x038, 0x000, 0x000},	/* TSENG	 */
	{0x066, 0x067, 0x062, 0x069, 0x065, 0x06A, 0x000, 0x000},	/* HLAND	 */
	{0x05C, 0x05D, 0x05B, 0x05E, 0x05F, 0x062, 0x000, 0x000},	/* TRIDENT */
	{0x060, 0x061, 0x025, 0x062, 0x074, 0x063, 0x000, 0x000},	/* AHEAD	 */
	{0x000, 0x053, 0x052, 0x054, 0x056, 0x000, 0x000, 0x000},	/* OAK	 */
	{0x07E, 0x05C, 0x079, 0x05E, 0x05F, 0x000, 0x000, 0x000},	/* GENOA	 */
	{0x100, 0x101, 0x102, 0x103, 0x104, 0x105, 0x000, 0x107},	/* S3	 */
	{0x000, 0x05F, 0x058, 0x05C, 0x05D, 0x060, 0x000, 0x000}	/* CIRRUS  */
   };
					 /* x,   y,  #c  amt-of-vram */
VESA_RES	VESA_res[] =  { {640, 400, 256, 4},  {640, 480, 256,  8},
					 {800, 600,  16, 4},  {800, 600, 256,  8},
					{1024, 768,  16, 8}, {1024, 768, 256, 16},
					{1280,1024,  16, 8}, {1280,1024, 256, 20}};


LOCAL INT found_chipset = NO;

UTINY_FAR *VGA_BIOS ISTAT_0;

#if (PROT_MODE_SYS == PMODE_32)
IMPORT GFX_PM _gfx_pm;
#endif


#if defined (USE_PAS_M2)
	INT IdentifySVGA(void)
#elif defined (USE_UPPER_C)
	INT IDENTIFY_SVGA(void)
#elif defined (USE_LOWER_C)
	INT identify_SVGA(void)
#endif
{
INT i;
#if (PROT_MODE_SYS == PMODE_16)
LONG tmpptr;
#endif

#if (PROT_MODE_SYS == PMODE_32)
if (_gfx_pm.extender == 0)
	_gfx32_init_pmode();
#elif (LINK_TO_PASCAL == 1)
void _gfx_init_pascal(void);
_gfx_init_pascal();
#endif

alloc_GFX_workspace(0, (VOID_FAR *) 0);
if (!_gfx.card_monitor) then _gfx_get_card_type();
if ((_gfx.card_monitor & VGA_CARD) == 0)
	return 0;
if (CRTC_port != 0)
	return found_chipset;

#if (PROT_MODE_SYS == REAL_MODE)
if (!VGA_BIOS)
	VGA_BIOS = (UTINY_FAR *) 0xC0000000;
#endif

#if (PROT_MODE_SYS == PMODE_32)
if (_gfx_pm.extender == 0) {
	_gfx32_init_pmode();
	}
_gfx_get_temp_workspace(&VGA_BIOS, 4);
#if (KOMPACT_32 == 1)
_gfx32_farmove(0xC0000, _gfx_pm.selector.real_mem_DS, (char *) VGA_BIOS, 0x1000);
#else
_gfx32_farmove((char *)0xC0000, _gfx_pm.selector.real_mem_DS,
  (char *) VGA_BIOS, _gfx_pm.selector.prot_mem_DS, 0x1000);
#endif
#elif (PROT_MODE_SYS == PMODE_16)
tmpptr = (LONG) _gfx16_alloc_selector(0xC000, 0x8000);
VGA_BIOS = (UTINY_FAR *) (tmpptr<<16);
#endif

found_chipset = 0;
CRTC_port = (_gfx_inp(0x3CC) & 0x1) ? 0x3D4 : 0x3B4;
check_for_VESA();

for (i = 0; i <= N_CHIPSETS; i++) {
	if ((*is_CARD[i])()) {
		get_SVGA_info((INT **) 0, 0);
		found_chipset = YES;
		}
	}
if (!found_chipset AND (svga_card.VESA_is_supported)) {
#if (PROT_MODE_SYS == REAL_MODE)
	svga_card.switch_banks_with_VESA = YES;
#endif
	found_chipset = YES;
	}
#if (PROT_MODE_SYS == PMODE_32)
_gfx_free_temp_workspace(VGA_BIOS);
#elif (PROT_MODE_SYS == PMODE_16)
_gfx16_free_selector(ptr_segment(VGA_BIOS));
#endif
return found_chipset;
}

LOCAL INT found_VESA_vram ISTAT_0;
LOCAL INT found_VESA_modes[N_EXTD_MODES] ISTAT_ARR_0;

#if defined (USE_PAS_M2)
	INT GetSVGAInfo(INT **svga_modes, INT vram)
#elif defined (USE_UPPER_C)
	INT GET_SVGA_INFO(INT **svga_modes, INT vram)
#elif defined (USE_LOWER_C)
	INT get_SVGA_info(INT **svga_modes, INT vram)
#endif
{
FAST INT i;
INT_FAR *mode_list;

if (svga_modes)
	*svga_modes = svga_card.modes;
if (vram != 0)
	svga_card.vram = vram;
if (svga_card.VESA_is_supported) {
	for (i = 0; i < N_EXTD_MODES; i++)
		svga_card.modes[i] = found_VESA_modes[i];
	svga_card.vram = found_VESA_vram;
	}
else if (svga_card.bios > 0x100) {
	mode_list = VESA_bios[(svga_card.bios >> 8) - 1];
	vram = (svga_card.vram == 0) ? 4 : svga_card.vram;
	if ((svga_card.bios != ATI_BIOS) AND (svga_card.bios != CIRRUS_BIOS)) {
		for (i = 0; i < N_EXTD_MODES; i++) {
			if (VESA_res[i].vram_sz <= vram)
				svga_card.modes[i] = mode_list[i];
			else svga_card.modes[i] = 0;
			}
		}
	}
return svga_card.vram;
}

#if (PROT_MODE_SYS == REAL_MODE)
typedef struct vsi { TINY signature[4];
				 TINY version[2];
				 UTINY_FAR *oem_name;
				 TINY capabilities[4];
				 UWORD_FAR *modes;
				 UWORD vram_sz;
				 TINY extra[256-20];
			    } VESA_SYS_INFO;
#endif

LOCAL_Void_FCN check_for_VESA(void)
{
#if (PROT_MODE_SYS == REAL_MODE)
FAST INT i, vmode;
UTINY_FAR *vsi_ptr;
INT modes[50];
REG reg;
SREGS sregs;
VESA_SYS_INFO vsi;

reg._x.ax = 0x4F00;
vsi_ptr = (UTINY_FAR *) &vsi;
reg._x.di = ptr_offset(vsi_ptr);
sregs.es = ptr_segment(vsi_ptr);
_gfx_int86x(0x10, &reg, &reg, &sregs);
svga_card.VESA_is_supported = NO;
svga_card.set_mode_with_VESA = NO;
svga_card.switch_banks_with_VESA = NO;
if (reg._hl.al == 0x4F) {
	zfill(found_VESA_modes, sizeof(found_VESA_modes));
	svga_card.VESA_is_supported = YES;
	svga_card.set_mode_with_VESA = YES;
	i = vsi.vram_sz;
	found_VESA_vram = ((i == 4) OR (i == 8) OR (i == 16) OR (i == 32)) ? i : 0;
	for (i = 0; (i < 50) AND ((modes[i] = vsi.modes[i]) != -1); i++);
	for (i=0; (vmode = modes[i]) != -1; i++) {
		if ((vmode & 0x100) AND (vmode <= 0x107)) {
			reg._x.ax = 0x4F01;
			reg._x.cx = vmode;
			_gfx_int86x(0x10, &reg, &reg, &sregs);
			if (reg._x.ax == 0x4F) {
				vmode &= 0x7;
				found_VESA_modes[vmode] = vmode | 0x100;
				if (VESA_res[vmode].vram_sz > found_VESA_vram)
					found_VESA_vram = VESA_res[vmode].vram_sz;
				}
			}
		}
	}
#elif (PROT_MODE_SYS == PMODE_16)
found_VESA_vram = _gfx16_check_for_VESA(found_VESA_modes, VESA_res);
#elif (PROT_MODE_SYS == PMODE_32)
found_VESA_vram = _gfx32_check_for_VESA(found_VESA_modes, VESA_res);
#endif
}


LOCAL_Int_FCN is_AHEAD(void)
{
FAST INT val;

out_VGA_index(0x3CE, 0xF, 0x20);
val = _gfx_inp(0x3CF);
if ((val == 0x21) OR (val == 0x20)) {
	svga_card.chipset = (val == 0x20) ? AHEAD_V5000_A : AHEAD_V5000_B;
	if (match_bios_string(0x25, "AHEAD"))
		svga_card.bios = AHEAD_BIOS;
	/*svga_card.init_chipset = _gfx_init_no_open;*/
	return YES;
	}
return NO;
}


#if (PROT_MODE_SYS == PMODE_16)
#define _gfx_is_good_ATI_mode(n)	_gfx16_is_good_ATI_mode(n)
#endif

LOCAL_Int_FCN is_ATI(void)
{
FAST INT i, mode_n;

if (match_bios_string(0x31, "761295520") AND match_bios_string(0x40, "31")) {
	svga_card.bios = ATI_BIOS;
	svga_card.chipset = (*(VGA_BIOS+0x43) == '1') ? ATI_18800_1 : ATI_18800_2;
	for (i = 0; i < N_EXTD_MODES; i++) {
		svga_card.modes[i] = 0;
		mode_n = VESA_bios[(ATI_BIOS>>8) - 1][i];
		if (mode_n AND _gfx_is_good_ATI_mode(mode_n)) {
			svga_card.modes[i] = mode_n;
			if (svga_card.vram < VESA_res[i].vram_sz)
				svga_card.vram = VESA_res[i].vram_sz;
			}
		}
	_gfx_set_ATI_port(* (INT_FAR *) (VGA_BIOS+0x10));
	svga_card.init_chipset = _gfx_init_ATI_18800;
	return YES;
	}
return NO;
}


LOCAL_Int_FCN is_TSENG(void)
{
FAST INT orig_val, new_val;

orig_val = _gfx_inp(0x3CD);
new_val = orig_val & 0xC0;
_gfx_outp(0x3CD, new_val | 0x55);
if (_gfx_inp(0x3CD) == 0x55) {
	_gfx_outp(0x3CD, 0xAA);
	if (_gfx_inp(0x3CD) == 0xAA) {
		_gfx_outp(0x3CD, orig_val);
		if (match_bios_string(0x76, "Tseng Lab"))
			svga_card.bios = TSENG_BIOS;
		if (can_rw_port(CRTC_port, 0x33, 0xF)) {
			svga_card.chipset = TSENG_ET4000;
			svga_card.init_chipset = _gfx_init_TSENG_ET4000;
			new_val = in_VGA_index(CRTC_port, 0x37);
			svga_card.vram = ((new_val & 0x8) ? 4 : 1) << ((new_val-1) & 0x3);
			}
		else {
			svga_card.init_chipset = _gfx_init_TSENG_ET3000;
			svga_card.chipset = TSENG_ET3000;
			}
		return YES;
		}
	}
_gfx_outp(0x3CD, orig_val);
return NO;
}

LOCAL_Int_FCN is_TRIDENT(void)
{
FAST INT val, chipset;
INT i, is_tr;

if ((chipset = in_VGA_index(0x3C4, 0xB)) == 0)
	return NO;
is_tr = YES;
val = write_VGA_reg(0x3C4, 0xE, 0);
i = _gfx_inp(0x3C5) & 2;
_gfx_outp(0x3C5, 0xF);
if ((i == 2) AND ((_gfx_inp(0x3C5) & 2) == 0)) {
	if (chipset < 3)
		svga_card.chipset = (chipset == 1) ? TRIDENT_8800BR : TRIDENT_8800CS;
	else {
		svga_card.chipset = (chipset == 3) ? TRIDENT_8900 : TRIDENT_9000;
		svga_card.vram = 4 * ((in_VGA_index(CRTC_port, 0x1F) & 0x3) + 1);
		}
	svga_card.init_chipset = _gfx_init_TRIDENT_8800CS;
	if (find_bios_string("TRIDENT MICRO"))
		svga_card.bios = TRIDENT_BIOS;
	val ^= 2;
	}
else is_tr = NO;
_gfx_outp(0x3C5, val);
out_VGA_index(0x3C4, 0xB, chipset);
return is_tr;
}


LOCAL_Int_FCN is_WD(void)
{
FAST INT it_is_WD;
INT orig_value;

it_is_WD = NO;
orig_value = write_VGA_reg(0x3CE, 0xF, 5);
if (can_rw_port(0x3CE, 0xA, 0xF)) {
	out_VGA_index(0x3CE, 0xF, 1);
	if (!can_rw_port(0x3CE, 0x9, 0xF))
		it_is_WD = YES;
	}
if (it_is_WD) {
	if (match_bios_string(0x7D, "VGA="))
		svga_card.bios = WD_BIOS;
	svga_card.vram = 0x2 << ((in_VGA_index(0x3CE, 0xB) >> 6) & 0x3);
	svga_card.chipset = can_rw_port(CRTC_port, 0x2D, 0xF) ? WD_90C00 : WD_PVGA1A;
	svga_card.init_chipset = _gfx_init_WD;
	}
else out_VGA_index(0x3CE, 0xF, orig_value);
return it_is_WD;
}


LOCAL_Int_FCN is_HEADLAND(void)
{
INT ext, orig_val, chip_id, it_is_HEADLAND;
REG reg;

ext = write_VGA_reg(0x3C4, 6, 0xEA);	/* unlock CRTC extension */
orig_val = write_VGA_reg(CRTC_port, 0xC, 0xCC);
it_is_HEADLAND = (in_VGA_index(CRTC_port, 0x1F) == (0xEA ^ 0xCC)) ? YES : NO;
out_VGA_index(CRTC_port, 0xC, orig_val);
if (it_is_HEADLAND) {
	chip_id = in_VGA_index(0x3C4, 0x8E);
	if (chip_id >= 0x80) then svga_card.chipset = HLAND_VEGA;
	else if (chip_id >= 0x70) then svga_card.chipset = HLAND_V7VGA_1;
	else if (chip_id >= 0x50) then svga_card.chipset = HLAND_V7VGA_4;
	else svga_card.chipset = HLAND_1024i;
	svga_card.init_chipset = _gfx_init_V7VGA;
	reg._x.ax = 0x6F00;
	call_ns_crt(reg);
	if ((reg._hl.bh == 'V') AND (reg._hl.bl == '7')) {
		svga_card.bios = HLAND_BIOS;
		reg._x.ax = 0x6F07;
		call_ns_crt(reg);
		svga_card.vram = (reg._hl.ah & 0x7F) * 4;
		}
	}
if (!it_is_HEADLAND OR ((ext & 1) == 0)) /* reset CRTC ext to original value */
	out_VGA_index(0x3C4, 6, 0xAE);
return it_is_HEADLAND;
}

LOCAL char ext_reg[][3] = { {0x0E, 0x1E, YES},
					   {0x10, 0x3F,  NO},
					   {0x11, 0x77, YES},
					   {0x12, 0x0F,  NO}
					 };

LOCAL_Int_FCN is_OAK(void)
{
FAST INT i;

for (i = 0; i < 4; i++) {
	if (can_rw_port(0x3DE, ext_reg[i][0], ext_reg[i][1]) != ext_reg[i][2])
		return NO;
	}
if (find_bios_string("OAK TECH"))
	svga_card.bios = OAK_BIOS;
svga_card.chipset = OAK_OTI_067;
svga_card.vram = (in_VGA_index(0x3DE, 0xD) & 0x80) ? 8 : 0xF;
svga_card.init_chipset = _gfx_init_OAK;
return YES;
}


LOCAL_Int_FCN	is_S3(void)
{
INT val;

val = write_VGA_reg(0x3D4, 0x38, 0x48);		/* unlock S3 extension */
if (in_VGA_index(0x3D4, 0x30) != 0x81) {
	write_VGA_reg(0x3D4, 0x38, val);
	return NULL;
	}
svga_card.chipset = S3_86C911;
svga_card.vram = S3_BIOS;
svga_card.bios = 0;
svga_card.init_chipset = _gfx_init_S3;
if (!svga_card.VESA_is_supported) {
	svga_card.vram = (in_VGA_index(0x3D4, 0x36) & 0x20) ? 8 : 16;
	}
val = write_VGA_reg(0x3D4, 0x38, 0);		/* lock S3 extension */
return YES;
}

//LOCAL INT_FAR chipset_GD542X[] = { 0, 0, 5420, 5422, 5426, 5424, 5428, 0};
LOCAL INT_FAR GD5410_modes[] = {0x2D, 0x2E, 0x6A, 0x30, 0x37, 0x38, 0, 0};

LOCAL_Int_FCN is_CIRRUS(void)
{
FAST INT i, mode_n;
INT cs, found_chipset;

cs = found_chipset = 0;
i = in_VGA_index(0x3C4, 6);
if ((i == 0xF) OR (i == 0x12)) {
	out_VGA_index(0x3C4, 6, 0x0);
	if (in_VGA_index(0x3C4, 6) == 0xF) {
		out_VGA_index(0x3C4, 6, 0x12);
		if (in_VGA_index(0x3C4, 6) == 0x12) {
			found_chipset = CIRRUS_GD542X;
			svga_card.vram = 4 << ((in_VGA_index(0x3C4, 0xF) >> 3) & 0x3);
			}
		}
	}
else {
	out_VGA_index(0x3CE, 0xA, 0xEC);
	if (in_VGA_index(0x3CE, 0xA) == 1) {
		found_chipset = CIRRUS_GD5410;
		i = in_VGA_index(0x3CE, 0x9F);
		svga_card.vram = (4 << ((i >> 1) & 0x7)) << ((i >> 4) & 0x7);
		}
	}
if (found_chipset != 0) {
	if ((cs = CIRRUS_bios_call(0, 0x80)) > 0) {
		if (inrange (4, cs, 8) OR (cs == 0x10) OR (cs == 0x11)) {
			found_chipset = CIRRUS_GD5410;
			for (i = 0; i < sizeof(GD5410_modes); i++)
				VESA_bios[(CIRRUS_BIOS>>8) - 1][i] = GD5410_modes[i];
			}
		else if (inrange(0x12, cs, 0x18) OR (cs == 0x20))
			found_chipset = CIRRUS_GD542X;
		else if ((cs == 0x30) OR (cs == 0x31))
			found_chipset = CIRRUS_GD543X;
		svga_card.bios = CIRRUS_BIOS;
		svga_card.vram = CIRRUS_bios_call(0, 0x85) & 0xFF;
		for (i = 0; i < N_EXTD_MODES; i++) {
			svga_card.modes[i] = 0;
			mode_n = VESA_bios[(CIRRUS_BIOS>>8) - 1][i];
			if (mode_n AND CIRRUS_bios_call(mode_n, 0xA0) & 0x100)
				svga_card.modes[i] = mode_n;
			}
		}
	svga_card.chipset = found_chipset;
	svga_card.init_chipset = (found_chipset == CIRRUS_GD5410) ?
	   _gfx_init_CIRRUS_GD5410 : _gfx_init_CIRRUS_GD542X;
	return YES;
	}
return NO;
}

LOCAL_Int_FCN CIRRUS_bios_call(INT _AL, INT fcn_n)
{
INT ds_reg;
REG_X reg;

reg.ax = 0x1200 + _AL;
reg.bx = fcn_n;
ds_reg = _gfx_get_ds();
call_crt(reg);
_gfx_set_ds(ds_reg);
return reg.ax;
}



#ifdef JUNK
THIS WORKS FOR OAK CHIPSET -- JIM SEDARGUS

LOCAL_Int_FCN is_OAK(void)
{
FAST INT i;
INT is_OAK;

is_OAK = NO;
if (can_rw_port(0x3DE, 0x11, 0x77)) {
	is_OAK = YES;
	printf("Success on simple test for OAK chipset\n");
	}
for (i = 0; i < 4; i++) {
	if (can_rw_port(0x3DE, ext_reg[i][0], ext_reg[i][1]) != ext_reg[i][2]) {
		if (!is_OAK) then return NO;
		else printf("Failed on test #%d: port index=%d\n", i+1, ext_reg[i][0]);
		}
	}
if (find_bios_string("OAK TECH"))
	svga_card.bios = OAK_BIOS;
svga_card.chipset = OAK_OTI_067;
svga_card.vram = (in_VGA_index(0x3DE, 0xD) & 0x80) ? 8 : 0xF;
svga_card.init_chipset = _gfx_init_OAK;
return YES;
}

#endif

LOCAL_Int_FCN is_GENOA(void)
{
INT orig_val, new_val, bit;

if (is_GENOA_bios()) {
	if (can_rw_port(0x3C4, 6, 0x3F)) {
		bit = (_gfx_inp(0x3CC) & 0x20) >> 6;
		orig_val = in_VGA_index(0x3C4, 6);
		new_val = (orig_val & 0x7F) | (~bit & 0x1);
		_gfx_outp(0x3C5, new_val);
		_gfx_outp(0x3C5, new_val & ~0x40);
		if ((_gfx_inp(0x3c5) & 1) == bit) {
			svga_card.chipset = GENOA_SUPERVGA;
			}
		else svga_card.chipset = TSENG_ET3000;
		}
	svga_card.bios = GENOA_BIOS;
	return YES;
	}
return NO;
}

LOCAL_Int_FCN is_GENOA_bios(void)
{
LONG_FAR *id;

id = (LONG_FAR *) (VGA_BIOS+0x37);
return (*id == 0x66991177L) ? YES : NO;
}

LOCAL_Int_FCN can_rw_port(INT port_n, INT index, INT val)
{
INT orig_val, new_val;

orig_val = in_VGA_index(port_n++, index);
_gfx_outp(port_n, orig_val ^ val);
new_val = _gfx_inp(port_n);
_gfx_outp(port_n, orig_val);
return (new_val == (orig_val ^ val)) ? YES : NO;
}

LOCAL_Int_FCN find_bios_string(TEXT *id_string)
{
FAST INT i;

for (i = 0; i < 500; i++) {
	if (match_bios_string(i, id_string))
		return YES;
	}
return NO;
}

LOCAL_Int_FCN match_bios_string(UINT bios_offset, TEXT *id_string)
{
UTINY_FAR *bios_loc;

bios_loc = (UTINY_FAR *) (VGA_BIOS + bios_offset);
while (*id_string) {
	if (*bios_loc++ != (UTINY) *id_string++)
		return NO;
	}
return YES;
}

LOCAL_Int_FCN write_VGA_reg(INT port_n, INT port_index, INT write_val)
{
INT reg_val;

reg_val = in_VGA_index(port_n, port_index);
_gfx_outp(port_n+1, write_val);
return reg_val;
}

LOCAL_Int_FCN in_VGA_index(INT port_n, INT index)
{
_gfx_outp(port_n, index);
return _gfx_inp(port_n+1);
}

LOCAL_Void_FCN out_VGA_index(INT port_n, INT index, INT val)
{
_gfx_outp(port_n, index);
_gfx_outp(port_n+1, val);
}

LOCAL UTINY_FAR VGA16_dac[16][3] = {{00, 00, 00}, {00, 00, 42},
							 {00, 42, 00}, {00, 42, 42},
							 {42, 00, 00}, {42, 00, 42},
							 {42, 21, 00}, {42, 42, 42},
							 {21, 21, 21}, {21, 21, 63},
							 {21, 63, 21}, {21, 63, 63},
							 {63, 21, 21}, {63, 21, 63},
							 {63, 63, 21}, {63, 63, 63}};
#if defined (USE_PAS_M2)
	INT SetSVGAMode(INT VESA_mode_n)
#elif defined (USE_UPPER_C)
	INT SET_SVGA_MODE(INT VESA_mode_n)
#elif defined (USE_LOWER_C)
	INT set_SVGA_mode(INT VESA_mode_n)
#endif
{
FAST INT vmi;
INT set_screen, mode_n, force_VESA_switching;
REG reg;

set_screen = YES;
if (VESA_mode_n < 0) {
	set_screen = NO;
	VESA_mode_n = -VESA_mode_n;
	}
if (_gfx.orig_bios_mode == 0xFFFF) {
	 reg._hl.ah = 15;
	call_crt(reg);
	_gfx.orig_bios_mode = (UINT) reg._hl.al;
	}
if (!found_chipset AND !svga_card.VESA_is_supported)
	return _gfx_err_number(BAD_VIDEO, SET_SVGA_MODE_FCN);
force_VESA_switching = mode_n = 0;

if ((vmi = VESA_mode_n & 0xFF) < N_EXTD_MODES)
	mode_n = svga_card.VESA_is_supported ? VESA_bios[0][vmi] :
	   VESA_bios[(svga_card.bios>>8)-1][vmi];
if (mode_n == 0)
	return _gfx_err_number(BAD_ARG, SET_SVGA_MODE_FCN);

if ((svga_card.chipset & 0xFF00) == WD_CHIPSET)
	_gfx_WD_SVGA_bug();

if (set_screen AND svga_card.set_mode_with_VESA) {
	if ((VESA_mode_n & USE_VESA_SWITCHING) || svga_card.switch_banks_with_VESA) {
		force_VESA_switching = YES;
		VESA_mode_n &= 0x3FF;
		}
	reg._x.ax = 0x4F02;
	reg._x.bx = VESA_mode_n;
	call_ns_crt(reg);
	if (reg._hl.ah != 0)
		return _gfx_err_number(BAD_VIDEO, SET_SVGA_MODE_FCN);
	}
else if (set_screen) {
	if (svga_card.bios == HLAND_BIOS) {
		reg._x.ax = 0x6F05;
		reg._hl.bl = (UTINY) mode_n;
		}
	else reg._x.ax = mode_n;
	call_ns_crt(reg);
	}
set_video_resolution(VESA_res[vmi].max_x, VESA_res[vmi].max_y);
if (VESA_res[vmi].n_colors == 256)
	mode_n |= SVGA_256_RES;
else mode_n = 41;
init_GFX_struct(mode_n);
if (VESA_mode_n != 0x102) {
	if (force_VESA_switching)
		initialize_VESA_switching(VESA_mode_n);
	else if (svga_card.init_chipset)
		(*svga_card.init_chipset)();
#if (PROT_MODE_SYS == PMODE_32)
	_gfx32_set_video_selector(0xA000);
#endif
	if (svga_card.chipset == S3_86C911)
		_gfx.bytes_per_row = 1024;
	}
_gfx_lo_write_VGA_pal(0, 16, (UTINY_FAR *) VGA16_dac);
_gfx_put_pel(0,0,0);
return YES;
}

#if (PROT_MODE_SYS == REAL_MODE)
typedef struct vmi { UWORD mode_attributes;
				 TINY  win_A_attributes, win_B_attributes;
				 UWORD win_granularity, win_size;
				 UWORD win_A_segment, win_B_segment;
				 LONG  far_win_fcn_ptr;
				 UWORD bytes_per_scan_line;
				 UWORD Xres, Yres;
				 TINY  XcharSz, YcharSz;
				 TINY  n_planes, bits_per_pixel;
				 TINY  n_banks, mem_model, bank_size;

			    } VESA_MODE_INFO;
#endif

LOCAL_Void_FCN initialize_VESA_switching(int VESA_mode_n)
{
#if (PROT_MODE_SYS == REAL_MODE)
TINY buf[256];
REG reg;
SREGS sregs;
#if defined (__HIGHC__)
_far VESA_MODE_INFO *vmi;
vmi = (_far VESA_MODE_INFO *)buf;
#else
VESA_MODE_INFO far *vmi;
vmi = (VESA_MODE_INFO far *)buf;
#endif

reg._x.ax = 0x4F01;
reg._x.cx = VESA_mode_n;
reg._x.di = ptr_offset(vmi);
sregs.es = ptr_segment(vmi);
_gfx_int86x(0x10, &reg, &reg, &sregs);
_gfx.bytes_per_row = vmi->bytes_per_scan_line;
_gfx_init_VESA(vmi->far_win_fcn_ptr, vmi->win_granularity);
#elif (PROT_MODE_SYS == PMODE_16)
_gfx16_init_VESA_switching(VESA_mode_n);
#elif (PROT_MODE_SYS == PMODE_32)
_gfx32_initialize_VESA_switching(VESA_mode_n);
#endif
}

#if (DOS16_EXTENDER != PHAR_LAP)
void AFdecl DosRealFarCall(void) { ; }
#endif



/*~ GR_SCALE.C */

TINY grey_rgb[] = { 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 1, 1 };

#if defined (USE_PAS_M2)
	void MapVGAGreyScale(INT brightness)
#elif defined (USE_UPPER_C)
	void MAP_VGA_GREY_SCALE(INT brightness)
#elif defined (USE_LOWER_C)
	void map_VGA_grey_scale(INT brightness)
#endif
{
FAST INT c, i;
TINY rgb[96];
INT n;

c = 0;
if (brightness < 0)
	brightness = 0;
else if (brightness > 60)
	brightness = 60;
for (n = c = 0; c < 8; c++) {
	_gfx_move(grey_rgb, rgb+n, sizeof(grey_rgb));
	for (i = 0; i < sizeof(grey_rgb); i++)
		rgb[n++] += brightness + c;
	}
for (c = 0; c < 256; c += sizeof(rgb) / 3) {
	_gfx_lo_write_VGA_pal(c, sizeof(rgb) / 3, (UTINY_FAR *) rgb);
	for (i = 0; i < sizeof(rgb); i++) {
		if ((rgb[i] += sizeof(rgb) / sizeof(grey_rgb)) > 0x3F)
			rgb[i] = 0x3F;
		}
	}
_gfx_turn_on_grey_scale();
}

/*~ GREY_ON.C */

Void_FCN _gfx_turn_on_grey_scale(void)
{
REG_X reg;

reg.ax = 0x101B;
reg.bx = 0;
reg.cx = 256;
_gfx_call_86x(0x10, (REG *) &reg, (UTINY_FAR *) 0, (UTINY_FAR *) 0);
}

/*~ MPVGAPL.C */

#if defined (USE_PAS_M2)
	INT MapVGAPalette(INT first_color, INT n_colors, UTINY *palette)
#elif defined (USE_UPPER_C)
	INT MAP_VGA_PALETTE(INT first_color, INT n_colors, UTINY *palette)
#elif defined (USE_LOWER_C)
	INT map_VGA_palette(INT first_color, INT n_colors, UTINY *palette)
#endif
{

if (!inrange(0, first_color, 255) OR (n_colors+first_color > 256))
	return _gfx_err_number(BAD_ARG, MAP_VGA_PAL_FCN);
_gfx_lo_write_VGA_pal(first_color, n_colors, (UTINY_FAR *) palette);
return 1;
}


/*~ SEG2SEL.C */

Void_FCN _gfx_set_screen_base(UINT segment)
{

#if (PROT_MODE_SYS == REAL_MODE)
_gfx.screen_base = segment;

#elif (PROT_MODE_SYS == PMODE_16)
_gfx.screen_base = _gfx16_alloc_selector(segment, 0x10000L);

#elif (PROT_MODE_SYS == PMODE_32)
_gfx32_pmode_screen_base(segment);

#endif
}


/*~ LOBLOB.C */


	/*  This module contains several low level routines used by most of the
	 *  BLOB functions.
	 */

	/*  _gfx_get_new_blob_cb() searches an array of blob_cb pointers for an
	 *  opening for a new blob control block.  If it finds an open slot it
	 *  returns its index + 1 and also optinally assigns the block's address
	 *  to the pointer argument passed to the function.
	 */

BLOB_CB _gfx_blob_cb[MAX_BLOB_CB] ISTAT_ARR_0;

Int_FCN _gfx_get_new_blob_handle(BLOB_CB **new_blob_cb)
{
FAST INT i;

if (new_blob_cb)
	*new_blob_cb = (BLOB_CB *) 0;
for (i = 0; i < MAX_BLOB_CB; i++) {
	if (_gfx_blob_cb[i].fh == 0) {
		if (new_blob_cb) then *new_blob_cb = _gfx_blob_cb+i;
		return i+1;
		}
	}
return NULL;
}

Int_FCN _gfx_get_blob_cb(FAST INT blob_handle, BLOB_CB *blob_cb, INT fcn_n)
{

blob_handle--;
if ((UINT)blob_handle < MAX_BLOB_CB) {
	*blob_cb = *(_gfx_blob_cb + blob_handle);
	return 1;
	}
return _gfx_err_number(BAD_BLOB_HANDLE, fcn_n);
}


Void_FCN _gfx_free_blob_cb(INT blob_handle)
{

blob_handle--;
if ((UINT)blob_handle < MAX_BLOB_CB)
	zfill((char *) (_gfx_blob_cb + blob_handle), sizeof(BLOB_CB));
}


Void_FCN _gfx_write_blob_header(BLOB_CB *blob_cb)
{
FAST INT handle;
BLOB_HEADER blob_hdr;

if (blob_cb->flags & UPDATE_BLOB_FILE) {
	blob_hdr.signature = BLOB_SIGNATURE;
	blob_hdr.item_index_pos = blob_cb->item_index_pos;
	blob_hdr.n_index_items = blob_cb->n_index_items;
	blob_hdr.name_len = blob_cb->name_len;
	handle = blob_cb->fh;
	gfx_lseek(handle, 0L, 0);
	gfx_write(&blob_hdr, sizeof(BLOB_HEADER), handle);
	}
}

/*~ XLATCPAL.C */

Void_FCN _gfx_xlat_color_pal(UTINY_FAR *inbuf, UTINY_FAR *outbuf, INT type)
{
FAST INT i, pal_size;

if (type & PAL_16_INFO)
	pal_size = PCX_16_PAL_SZ;
else if (type & PAL_256_INFO)
	pal_size = PCX_256_PAL_SZ;
else
	pal_size = (type & 0x1FF) * 3;
if (type & PCX_TO_GFX) {
	for (i = 0; i < pal_size; i++)
		outbuf[i] = inbuf[i] >> 2;
	}
else if (type & GFX_TO_PCX) {
	for (i = 0; i < pal_size; i++)
		outbuf[i] = inbuf[i] << 2;
	}
}


/*~ INITPIC.C */

GFX_GATE_PRO;

LOCAL PIC dflt_pic = {0, ENCODE_BEST, 0, -1, 0, 0, (UTINY_FAR *)0, 0,
				  SYSTEM_RAM, PIC_SIG, PCX_SHELL, YES };

#if defined (USE_PAS_M2)
	void SetDefaultPicUserFlags(int user_flags)
#elif defined (USE_UPPER_C)
	void SET_DEFAULT_PIC_USER_FLAGS(int user_flags)
#elif defined (USE_LOWER_C)
	void set_default_pic_user_flags(int user_flags)
#endif
{
dflt_pic.encoding = user_flags & 0xF;
dflt_pic.user_flags = user_flags & 0xFFF0;
}


#if defined (USE_PAS_M2)
	PIC *GetDefaultPicStructPtr(void)
#elif defined (USE_UPPER_C)
	PIC *GET_DEFAULT_PIC_STRUCT_PTR(void)
#elif defined (USE_LOWER_C)
	PIC *get_default_pic_struct_ptr(void)
#endif
{
return &dflt_pic;
}


#if defined (USE_PAS_M2)
	INT InitPicStructForBlob(PIC *pic, INT item_index, INT blob_handle, INT flags)
#elif defined (USE_UPPER_C)
	INT INIT_PIC_STRUCT_FOR_BLOB(PIC *pic, INT item_index, INT blob_handle, INT flags)
#elif defined (USE_LOWER_C)
	INT init_pic_struct_for_blob(PIC *pic, INT item_index, INT blob_handle, INT flags)
#endif
{
INT val;

GFX_GATE_CLOSE
val = _gfx_init_pic_struct_for_blob(pic, item_index, blob_handle, flags);
GFX_GATE_OPEN
return val;
}

Int_FCN _gfx_init_pic_struct_for_blob(PIC *pic, INT item_index, INT blob_handle, INT flags)
{
BLOB_CB blob_cb;

_gfx_init_pic_struct(pic, IMAGE_BLOB);
if (!_gfx_get_blob_cb(blob_handle, &blob_cb, INIT_PIC_BLOB_FCN)) {
	pic->image_type = 0;
	return NULL;
	}
pic->blob_handle = blob_handle;
pic->item_index = item_index;
if (flags != DFLT)
	pic->user_flags = flags;
return SUCCESS;
}

#if defined (USE_PAS_M2)
	void InitPicStruct(PIC *pic, FAST INT image_type)
#elif defined (USE_UPPER_C)
	void INIT_PIC_STRUCT(PIC *pic, FAST INT image_type)
#elif defined (USE_LOWER_C)
	void init_pic_struct(PIC *pic, FAST INT image_type)
#endif
{
GFX_GATE_CLOSE
_gfx_init_pic_struct(pic, image_type);
GFX_GATE_OPEN
}

Void_FCN _gfx_init_pic_struct(PIC *pic, FAST INT image_type)
{
*pic = dflt_pic;
pic->image_type = image_type;
if (image_type == PCX_FILE)
	pic->encoding = ENCODE_PCX;
if (image_type == IMAGE_RAM)
	pic->sys_flags = 0;
else
	pic->mem_type = FILE_MEM;
}


/*~ GETPCX.C */

GFX_GATE_PRO;

/* INT get_PCX_file(INT x1, INT y1, INT x2, INT y2, TEXT *file_name, INT flags) */

#if defined (USE_PAS_M2)
	INT AFdecl _gfx_get_PCX_file(INT arg, ...)
#elif defined (USE_UPPER_C)
	INT GET_PCX_FILE(INT arg, ... )
#elif defined (USE_LOWER_C)
	INT AFdecl get_PCX_file(INT arg, ... )
#endif
{
TEXT *file_name;
INT *args;
PIC pic;

GFX_GATE_CLOSE
_gfx_init_pic_struct(&pic, PCX_FILE);
args = &arg;
args += _gfx_get_box_coor_pair(GET_PIC_DIM, args, (BOX_COOR *) &(pic.x1));
file_name = *(TEXT **)args;
args += POINTER_ON_STACK;
pic.user_flags |= *args & (SAVE_PAL | GREY_SCALE | SAVE_VIDEO_COOR);
if ((pic.file_handle = gfx_open(file_name, CREATE_FILE)) < 5)
	return _gfx_err_number(BAD_FILE_OPEN, GET_PCX_FILE_FCN+OPEN_GATE);

pic.image_size = 1L;
_gfx_set_pic_area_param(&pic);

_gfx_lo_get_image(&pic, GET_PCX_FILE_FCN);

gfx_close(pic.file_handle);
if (_gfx_file_write_err) {
	gfx_delete_file(file_name);
	return _gfx_err_number(NO_DISK_SPACE, GET_PCX_FILE_FCN+OPEN_GATE);
	}
GFX_GATE_OPEN
return YES;
}


/*~ LDPCSTRU.C */

Int_FCN _gfx_read_pic_struct(DMEM_HANDLE pic_mc, PIC *pic, INT fcn_n)
{
FAST INT rtn_val;

rtn_val = 0;
if (pic_mc) {
	*pic = *(PIC *)_gfx_deref_mc(pic_mc);
	_gfx_unlock_mc(pic_mc);
	rtn_val = (!pic->image_type OR !is_legal_pic_ptr(pic)) ? 0 : 1;
	}
return (rtn_val == 0) ? _gfx_err_number(BAD_PIC_TYPE, fcn_n) : 1;
}

Void_FCN _gfx_write_pic_struct(DMEM_HANDLE pic_mc, PIC *pic)
{
*(PIC *)_gfx_deref_mc(pic_mc) = *pic;
_gfx_unlock_mc(pic_mc);
}

/*~ GETPIC.C */

GFX_GATE_PRO;

#if defined (USE_PAS_M2)
	PIC * AFdecl _gfx_get_pic(INT arg, ...) /* GetPic(x1, y1, x2, y2); */
#elif defined (USE_UPPER_C)
	PIC *GET_PIC(INT arg, ...)
#elif defined (USE_LOWER_C)
	PIC * AFdecl get_pic(INT arg, ...)
#endif
{
PIC *pic;
BOX_COOR bc;

GFX_GATE_CLOSE
_gfx_get_box_coor_pair(GET_PIC_DIM, &arg, &bc);
_gfxx_get_pic(&bc, &pic);
GFX_GATE_OPEN
return pic;
}

Void_FCN _gfxx_get_pic(BOX_COOR *bc, PIC **picptr)
{
PIC *pic;
DMEM_HANDLE pic_mc;

*picptr = pic = (PIC *) _gfx_malloc_mc(sizeof(PIC), &pic_mc);
if (!pic) {
	_gfx_err_number(NO_HEAP_SPACE, GET_PIC_FCN);
	return;
	}
_gfx_init_pic_struct(pic, IMAGE_RAM);
*(BOX_COOR *)&(pic->x1) = *bc;
_gfx_set_pic_area_param(pic);
pic->image_offset = 0L;
pic->sys_flags |= FREE_PIC_STRUCT;
if (!_gfx_lo_get_image(pic, GET_PIC_FCN))
	_gfx_free_pic(pic);
else
	_gfx_unlock_mc(pic_mc);
return;
}

/*~ LOGETPIC.C */

Void_FCN _gfx_set_pic_area_param(PIC *pic)
{

pic->x_bytes_per_line = ( ((_gfx.n_colors == 256) ? pic->x_pels :
   ((pic->x_pels + 7) >> 3)) + 1 ) & ~1;
if ((pic->sys_flags & PCX_SHELL) AND (pic->user_flags & SAVE_PAL) AND (_gfx.n_colors == 256))
	pic->sys_flags |= SAVE_256_PCX_PAL;
if (!pic->image_size) {
	_gfx_lo_get_image_size(pic);
	pic->pal_data_size = 0;
	if (pic->sys_flags & PAL_256_INFO)
		pic->pal_data_size = PCX_256_PAL_SZ;
	else if (pic->sys_flags & PAL_16_INFO)
		pic->pal_data_size = PCX_16_PAL_SZ;
	if (pic->blob_handle) {
		pic->blob_size = pic->image_size + sizeof(PCX_HDR) +
		   ((pic->sys_flags &SAVE_256_PCX_PAL) ? PCX_256_PAL_SZ:PCX_16_PAL_SZ);
		}
	}
}


Int_FCN _gfx_lo_get_image(PIC *pic, INT fcn_n)
{
INT pal_size;
UTINY_FAR *temp_buf;
PCX_HDR pcx_hdr;

if (pic->sys_flags & PCX_SHELL) {
	_gfx_init_PCX_hdr(pic, &pcx_hdr);
	gfx_write(&pcx_hdr, sizeof(PCX_HDR), pic->file_handle);
	}
else if ((pic->mem_type == SYSTEM_RAM) AND !pic->image_buf) {
	pic->pal_data_size = 0;
	if (pic->user_flags & SAVE_PAL) {
		if (_gfx.n_colors == 256) {
			pic->sys_flags |= PAL_256_INFO;
			pic->pal_data_size = PCX_256_PAL_SZ;
			}
		else if (_gfx.n_colors == 16) {
			pic->sys_flags |= PAL_16_INFO;
			pic->pal_data_size = PCX_16_PAL_SZ;
			}
		}
	pic->ram_buf = _gfx_farmalloc_mc(pic->image_size+pic->pal_data_size,
	   (FAR_DMEM_HANDLE *) &(pic->ram_mc));
	if (!pic->ram_buf)
		return _gfx_err_number(NO_HEAP_SPACE, fcn_n);
	if (pic->pal_data_size > 0) {
		pic->pal_data = pic->ram_buf;
		_gfx_ptr_in_huge_buf(pic->ram_buf, (LONG)pic->pal_data_size,
		   &pic->image_buf, 1);
		}
	else {
		pic->pal_data = (UTINY_FAR *) 0;
		pic->image_buf = pic->ram_buf;
		}
	pic->sys_flags |= FREE_IMAGE_MEM;
	}

_gfx_move_vidram(pic, 0);

if (pic->sys_flags & (SAVE_256_PCX_PAL | PAL_256_INFO)) {
	if (pic->mem_type == SYSTEM_RAM) {
		_gfx_lo_read_VGA_pal(0, 255, pic->pal_data);
		}
	else {
		_gfx_get_temp_workspace(&temp_buf, 1);
		_gfx_lo_read_VGA_pal(0, 255, temp_buf);
		_gfx_xlat_color_pal(temp_buf, temp_buf, PAL_256_INFO+GFX_TO_PCX);
		gfx_write("\014", 1, pic->file_handle);
		gfx_write(temp_buf, PCX_256_PAL_SZ, pic->file_handle);
		_gfx_free_temp_workspace(temp_buf);
		}
	}
else if ((pic->mem_type == SYSTEM_RAM) AND (pic->sys_flags & PAL_16_INFO)) {
		;
	}
return SUCCESS;
}


Void_FCN _gfx_init_PCX_hdr(PIC *user_pic, PCX_HDR *usr_pcx_hdr)
{
UTINY pal_16[17], *ppal_16;
INT save_256_pal, i;
PIC pic;
PCX_HDR pcx_hdr;
REG_X reg;

pic = *user_pic;
zfill(&pcx_hdr, sizeof(PCX_HDR));
pcx_hdr.mfg = ZSOFT_PCX;
pcx_hdr.version = 5;
pcx_hdr.max_x = pic.x_pels - 1;
pcx_hdr.max_y = pic.y_rows - 1;
if (pic.user_flags & SAVE_VIDEO_COOR) {
	pcx_hdr.min_x	=  pic.x1;
	pcx_hdr.min_y	=  pic.y1;
	pcx_hdr.max_x +=  pic.x1;
	pcx_hdr.max_y +=  pic.y1;
	}
pcx_hdr.encoding = (UTINY) ((pic.encoding & 3) | (pic.sys_flags & ENCODE_MATTE_MASK));
pcx_hdr.bits_per_pixel = (UTINY) ((_gfx.n_colors == 256) ? 8 : 1);
pcx_hdr.hres = _gfx.screen_x_res;
pcx_hdr.vres = _gfx.screen_y_res;
pcx_hdr.n_planes = (UTINY) ((_gfx.n_colors == 16) ? 4 : 1);
pcx_hdr.bytes_per_line = pic.x_bytes_per_line;
pcx_hdr.palette_type = (pic.user_flags & GREY_SCALE) ? 1 : 0;

save_256_pal = pic.sys_flags & PAL_256_INFO;
if (pic.sys_flags & PAL_16_INFO)
	_gfx_xlat_color_pal((UTINY_FAR *) pic.pal_data,
	   (UTINY_FAR *) pcx_hdr.colormap, PAL_16_INFO+GFX_TO_PCX);
else if (pic.user_flags & SAVE_PAL) {
	if (_gfx.n_colors == 16) {
		reg.ax = 0x1009;
		ppal_16 = pal_16;
		reg.dx = ptr_offset(ppal_16);
		_gfx_call_86x(0x10, (REG *) &reg, ppal_16, ppal_16);
		for (i = 0; i < 16; i++)
			_gfx_lo_read_VGA_pal(pal_16[i], 1, (UTINY_FAR *) pcx_hdr.colormap[i]);
		_gfx_xlat_color_pal((UTINY_FAR *) pcx_hdr.colormap,
		   (UTINY_FAR *) pcx_hdr.colormap, PAL_16_INFO+GFX_TO_PCX);
		}
	else if (_gfx.n_colors == 256)
		save_256_pal = YES;
	}
else if (_gfx.n_colors <= 16)
	pcx_hdr.version = 3;

if (pic.image_type != PCX_FILE) {
	pcx_hdr.mfg = GFX_PCX;
	pcx_hdr.image_size = pic.image_size;
	if (save_256_pal)
		pcx_hdr.image_size |= 0x80000000L;
	}

*usr_pcx_hdr = pcx_hdr;
}


/*~ PUTPIC.C */

LOCAL_Int_PRO _gfx_lo_put_pic(INT *args, UINT fcn_n);
GFX_GATE_PRO;

#if defined (USE_PAS_M2)
	INT AFdecl _gfx_put_pic(INT arg, ...)
#elif defined (USE_UPPER_C)
	INT PUT_PIC(INT arg, ...)
#elif defined (USE_LOWER_C)
	INT AFdecl put_pic(INT arg, ...)  /* put_pic(x1, y1, pic, action); */
#endif
{
INT val;

GFX_GATE_CLOSE
val = _gfx_lo_put_pic(&arg, PUT_PIC_FCN);
GFX_GATE_OPEN
return val;
}

#if defined (USE_PAS_M2)
	INT AFdecl _gfx_put_image(INT arg, ...)	/* PutImage(x1, y1, pic, action); */
#elif defined (USE_UPPER_C)
	INT PUT_IMAGE(INT arg, ...)
#elif defined (USE_LOWER_C)
	INT AFdecl put_image(INT arg, ...)
#endif
{
INT val;

GFX_GATE_CLOSE
val = _gfx_lo_put_pic(&arg, PUT_IMAGE_FCN);
GFX_GATE_OPEN
return val;
}

INT _gfxx_put_pic(INT x, ...)
{
return _gfx_lo_put_pic(&x, 0);
}

LOCAL_Int_FCN _gfx_lo_put_pic(INT *args, UINT fcn_n)
{
INT action, n;
PIC pic;

args += _gfx.get_pt(args);
if (!_gfx_read_pic_struct((DMEM_HANDLE) *(PIC **)args, &pic, fcn_n))
	return NULL;
n = (fcn_n == PUT_IMAGE_FCN) ? DMEM_HANDLE_ON_STACK : POINTER_ON_STACK;
action = *(args + n);
return _gfx_lo_put_image(&pic, action, fcn_n);
}


/*~ PUTPCX.C */

GFX_GATE_PRO;

#if defined (USE_PAS_M2)
	INT AFdecl _gfx_put_PCX_file(INT arg, ...)
#elif defined (USE_UPPER_C)
	INT PUT_PCX_FILE(INT arg, ... )
#elif defined (USE_LOWER_C)
	INT AFdecl put_PCX_file(INT arg, ... )
#endif
{
INT *args, val;
PIC pic;

GFX_GATE_CLOSE
args = &arg;
args += _gfx.get_pt(args);
_gfx_init_pic_struct(&pic, PCX_FILE);
if ((pic.file_handle = gfx_open(*(TEXT **)args, OPEN_READ_FILE)) < 5)
	return _gfx_err_number(BAD_FILE_OPEN, PUT_PCX_FILE_FCN+OPEN_GATE);
val = _gfx_lo_put_image(&pic, *(args + POINTER_ON_STACK), PUT_PCX_FILE_FCN);
gfx_close(pic.file_handle);
GFX_GATE_OPEN
return val;
}


/*~ OPENPCX.C */

GFX_GATE_PRO;

#if defined (USE_PAS_M2)
	INT OpenPCXFile(TEXT *file_name, PIC *usr_pic, PCX_HDR *usr_pcx_hdr)
#elif defined (USE_UPPER_C)
	INT OPEN_PCX_FILE(TEXT *file_name, PIC *usr_pic, PCX_HDR *usr_pcx_hdr)
#elif defined (USE_LOWER_C)
	INT open_PCX_file(TEXT *file_name, PIC *usr_pic, PCX_HDR *usr_pcx_hdr)
#endif
{
INT n;

GFX_GATE_CLOSE
n = _gfx_open_PCX_file(file_name, usr_pic, usr_pcx_hdr, OPEN_PCX_FILE_FCN);
GFX_GATE_OPEN
return n;
}


Int_FCN _gfx_open_PCX_file(TEXT *file_name, PIC *usr_pic, PCX_HDR *usr_pcx_hdr, INT fcn_n)
{
INT _256_pal_exists;
PIC pic;
PCX_HDR pcx_hdr;

_gfx_init_pic_struct(&pic, PCX_FILE);
if ((pic.file_handle = gfx_open(file_name, OPEN_READ_FILE)) < 5)
	return _gfx_err_number(BAD_FILE_OPEN, fcn_n+OPEN_GATE);
if (!_gfx_load_PCX_header(pic.file_handle, &pcx_hdr, &_256_pal_exists)) {
	gfx_close(pic.file_handle);
	return _gfx_err_number(BAD_FILE_FORMAT, fcn_n+OPEN_GATE);
	}
gfx_lseek(pic.file_handle, 0L, 0);
if (usr_pcx_hdr) {
	pcx_hdr.encoding = 0;
	if (_256_pal_exists)
		pcx_hdr.encoding = (UTINY) 256;
	else if (pcx_hdr.version == 2)
		pcx_hdr.encoding = 16;
	*usr_pcx_hdr = pcx_hdr;
	}
pic.sys_flags |= FREE_HANDLE;
*(PIC *)_gfx_deref_mc((DMEM_HANDLE)usr_pic) = pic;
_gfx_unlock_mc((DMEM_HANDLE)usr_pic);
return pic.file_handle;
}


/*~ LOPUTIMG.C */

#define REMAP_256_PAL_CONVENTION_FCN	1

LOCAL INT lo_256_remap = 0;
LOCAL INT hi_256_remap = 255;

#if defined (USE_PAS_M2)
	void Reset256PalRange(INT lo, INT hi)
#elif defined (USE_UPPER_C)
	void RESET_256_PAL_RANGE(INT lo, INT hi)
#elif defined (USE_LOWER_C)
	void reset_256_pal_range(INT lo, INT hi)
#endif
{

if (lo < hi) {
	if ((lo_256_remap = lo) < 0)
		lo_256_remap = 0;
	if ((hi_256_remap = hi) > 255)
		hi_256_remap = 255;
	}
else lo_256_remap = hi_256_remap = 0;
}

LOCAL_Void_PRO reset_256_pal(UTINY_FAR *DACs, UTINY_FAR *new_DACs, UTINY *xlat_256_pal);
#define PAL_INFO	(PAL_16_INFO | PAL_256_INFO)

Int_FCN _gfx_lo_put_image(PIC *user_pic, INT action, INT fcn_n)
{
UTINY xlat_256_pal[256];
INT _256_pal, type, read_n_pal_bytes;
LONG n_bytes_read, file_base;
FAR_DMEM_HANDLE far_buf_mc;
PCX_HDR pcx_hdr;
UTINY_FAR *temp_buf;
UTINY_FAR *far_buf;
PIC pic;

pic = *user_pic;
if (action >= 0) {
	pic.user_flags |= action & ~0x7F;
	if ((action = 1+_gfx_findb("PAOXMR", 6, (char) toupper(action&0x7F))) == 7)
		return _gfx_err_number(BAD_ARG, fcn_n);
	}
if (pic.image_type == 0)
	return _gfx_err_number(BAD_PIC_TYPE, fcn_n);
if (pic.image_type == IMAGE_BLOB) {
	type = IMAGE_BLOB;
	pic.file_handle = _gfx_lseek_blob(pic.item_index, pic.blob_handle,
	   (LONG *) 0, &type, PUT_IMAGE_FCN);
	if (pic.file_handle < 1)
		return 0;
	}
far_buf_mc = NULL_DMEM_HANDLE;
pic.x1 = _gfx.pt_x;
pic.y1 = _gfx.pt_y;

if ((pic.image_type == PCX_FILE) OR (pic.image_type == IMAGE_BLOB)) {
	pic.image_size = _gfx_load_PCX_header(pic.file_handle, &pcx_hdr, &_256_pal);
	if (pic.user_flags & USE_VIDEO_COOR) {
		pic.x1 = _gfx.x_org + pcx_hdr.min_x;
		pic.y1 = _gfx.y_org + pcx_hdr.min_y;
		}
	pic.x_pels = pcx_hdr.max_x  - pcx_hdr.min_x + 1;
	pic.y_rows = pcx_hdr.max_y - pcx_hdr.min_y + 1;
	pic.x_bytes_per_line = pcx_hdr.bytes_per_line;
	pic.n_orig_colors = (pcx_hdr.bits_per_pixel == 8) ?
	   256 : (1 << pcx_hdr.n_planes);
	if (!pic.image_size OR ((UINT) pic.n_orig_colors > _gfx.n_colors))
		return NULL;
	pic.n_planes = pcx_hdr.n_planes;
	pic.encoding = pcx_hdr.encoding & 3;
	pic.sys_flags |= (pcx_hdr.encoding & ENCODE_MATTE_MASK);
	file_base = pic.image_offset = gfx_lseek(pic.file_handle, 0L, 1);
	if (!_256_pal AND (pic.n_orig_colors == 256))
		pic.user_flags |= NO_PCX_PAL;

	pic.pal_data_size = 0;
	if ((pic.user_flags & ONE_GULP) OR (action < 0)) {
		if ((action < 0) AND !(pic.user_flags & NO_PCX_PAL))  {
			if ((pcx_hdr.version == 2) AND (pic.n_planes > 1))
				pic.pal_data_size = PCX_16_PAL_SZ;
			else if (pcx_hdr.version == 5)
				pic.pal_data_size = _256_pal ? PCX_256_PAL_SZ : PCX_16_PAL_SZ;
			}
		far_buf = _gfx_farmalloc_mc(pic.image_size+pic.pal_data_size,&far_buf_mc);
		if (far_buf != (UTINY_FAR *) 0) {
			pic.mem_type = SYSTEM_RAM;
			pic.sys_flags |= FREE_IMAGE_MEM;
			pic.image_offset = 0L;
			pic.ram_buf = far_buf;
			pic.ram_mc = far_buf_mc;
			if (pic.pal_data_size != 0) {
				pic.pal_data = pic.ram_buf;
				_gfx_ptr_in_huge_buf(pic.ram_buf, pic.pal_data_size,
				   &pic.image_buf, 1);
				}
			else {
				pic.pal_data = (UTINY_FAR *) 0;
				pic.image_buf = pic.ram_buf;
				}
			n_bytes_read = gfx_huge_read(pic.image_buf, pic.image_size, 
			   pic.file_handle);
			read_n_pal_bytes = 0;
			if ((action < 0) AND (n_bytes_read == pic.image_size)) {
				if (pic.pal_data_size > 0) {
					if (pic.pal_data_size == PCX_16_PAL_SZ) {
						_gfx_far_move((UTINY_FAR *)pcx_hdr.colormap,
						   pic.pal_data, PCX_16_PAL_SZ);
						pic.sys_flags |= PAL_16_INFO;
						}
					else {
						read_n_pal_bytes = PCX_256_PAL_SZ;
						gfx_lseek(pic.file_handle, 1L, 1);
						n_bytes_read += gfx_read(pic.pal_data,
						   PCX_256_PAL_SZ, pic.file_handle);
						pic.sys_flags |= PAL_256_INFO;
						}
					_gfx_xlat_color_pal(pic.pal_data, pic.pal_data,
					   (pic.sys_flags & PAL_INFO) + PCX_TO_GFX);
					}
				if (n_bytes_read != (pic.image_size + read_n_pal_bytes)) {
					_gfx_farfree_mc(pic.ram_mc);
					return _gfx_err_number(BAD_FILE_READ, fcn_n);
					}
				pic.file_handle = 0;
				}
			}
		else if (action < 0)
			return _gfx_err_number(NO_HEAP_SPACE, fcn_n);
		}

	if ((_gfx.n_colors >= 16) AND !(pic.user_flags & NO_PCX_PAL) AND (action >= 0)) {
		_gfx_xlat_color_pal((UTINY_FAR *) pcx_hdr.colormap,
		   (UTINY_FAR *) pcx_hdr.colormap,  PAL_16_INFO+PCX_TO_GFX);
		if ((pcx_hdr.version == 2) AND (pic.n_planes > 1))
			_gfx_put_PCX_16_pal((UTINY_FAR *) pcx_hdr.colormap,
			   pic.promote_color, pic.n_orig_colors);
		else if (pcx_hdr.version >= 5) {
			_gfx_get_temp_workspace(&temp_buf, 1 + 1);
			if (_256_pal) {
				gfx_lseek(pic.file_handle, file_base+pic.image_size+1, 0);
				gfx_read(temp_buf, PCX_256_PAL_SZ, pic.file_handle);
				gfx_lseek(pic.file_handle, file_base, 0);
				_gfx_xlat_color_pal(temp_buf, temp_buf, PAL_256_INFO+PCX_TO_GFX);
				if (pic.user_flags & REMAP_256_COLOR) {
					pic.xlat_256_pal = xlat_256_pal;
					reset_256_pal(temp_buf, temp_buf+1000, xlat_256_pal);
					}
				else if (!pic.xlat_256_pal)
					_gfx_lo_write_VGA_pal(0, 256, temp_buf);
				}
			if ((pcx_hdr.palette_type == 2) AND !(pic.user_flags & NO_GREY_SCALE))
				_gfx_turn_on_grey_scale();
			if (!_256_pal)
				_gfx_put_PCX_16_pal((UTINY_FAR *) pcx_hdr.colormap,
				   pic.promote_color, pic.n_orig_colors);
			_gfx_free_temp_workspace(temp_buf);
			}
		}
	}
else if ((pic.mem_type == SYSTEM_RAM) AND !(pic.user_flags & NO_PCX_PAL)) {
	if (pic.sys_flags & PAL_16_INFO)
		_gfx_put_PCX_16_pal(pic.pal_data, pic.promote_color, pic.n_orig_colors);
	else if ((pic.sys_flags & PAL_256_INFO) AND !pic.xlat_256_pal) {
		if (pic.user_flags & REMAP_256_COLOR) {
			pic.xlat_256_pal = xlat_256_pal;
			_gfx_get_temp_workspace(&temp_buf, 1 + 1);
			reset_256_pal(pic.pal_data, temp_buf, xlat_256_pal);
			_gfx_free_temp_workspace(temp_buf);
			}
		else
			_gfx_lo_write_VGA_pal(0, 256, pic.pal_data);
		}
	}
if (pic.user_flags & CENTER_IMAGE) {
	pic.x1 -= pic.x_pels / 2;
	pic.y1 -= pic.y_rows / 2;
	}
if (action >= 0) {
	_gfx_move_vidram(&pic, action);
	_gfx_farfree_mc(far_buf_mc);
	}
else
	*user_pic = pic;
return SUCCESS;
}

#ifdef ZINC_OEM
Int_FCN _gfx_lseek_blob(INT index, INT blob_handle, LONG *file_size, INT *blob_type, INT fcn_n)
{
return index+blob_handle+(INT)*file_size+*blob_type+fcn_n;
}
#endif

LOCAL_Void_FCN reset_256_pal(UTINY_FAR *DACs, UTINY_FAR *new_DACs, UTINY *xlat_256_pal)
{
FAST INT remap_n_DACs, i;
INT offset;

_gfx_lo_read_VGA_pal(0, 256, new_DACs);
if ((remap_n_DACs = hi_256_remap - lo_256_remap + 1) > 256)
	remap_n_DACs = 256;
if (remap_n_DACs > 1) {
	offset = lo_256_remap * 3;
	_gfx_far_move(DACs+offset, new_DACs+offset, remap_n_DACs * 3);
	}
for (i = 0; i < 256; i++) {
	xlat_256_pal[i] = inrange(lo_256_remap, i, hi_256_remap) ? i :
	   (UTINY) _gfx_find_closest_point(DACs[0], DACs[1], DACs[2], new_DACs, 256);
	DACs += 3;
	}
if (remap_n_DACs > 1)
	_gfx_lo_write_VGA_pal(lo_256_remap, remap_n_DACs, new_DACs + offset);
}


Void_FCN _gfx_put_PCX_16_pal(UTINY_FAR *rgb, INT base_color, INT n_colors)
{
FAST INT dest, mask;
UTINY pal[18], *ppal;
INT c, n, i;
REG_X reg;

ppal = pal;
if (_gfx.card_monitor & EGA_CARD) {
	for (n = 0; n < 16; n++) {
		dest = 0;
		mask = 0x24;
		for (i = 0; i < 3; i++) {
			c = *rgb++;
			if (c > 0xC0)
				dest |= mask;
			else if (c > 0x80)
				dest |= mask & 38;
			else if (c > 0x40)
				dest |= mask & 0x7;
			mask >>= 1;
			}
		pal[n] = (UTINY)dest;
		}
	pal[16] = 0;
	reg.ax = 0x1002;
	reg.dx = ptr_offset(ppal);
	_gfx_farcall_86x(0x10, (REG *) &reg, (UTINY_FAR *)ppal, (UTINY_FAR *)ppal);
	}
else if (_gfx.card_monitor & VGA_CARD) {
	if (_gfx.n_colors == 16) {
		reg.ax = 0x1009;
		reg.dx = ptr_offset(ppal);
		_gfx_call_86x(0x10, (REG *) &reg, (UTINY *) 0, ppal);
		}
	else {
		if (base_color < 0) then base_color = 0;
		for (i = 0; i < n_colors; i++)
			pal[i] = (UTINY) (i + base_color);
		}
	for (i = 0; i < n_colors; i++) {
		_gfx_lo_write_VGA_pal(pal[i], 1, rgb);
		rgb += 3;
		}
	}
}


/*~ MAP256CL.C */

#if defined (USE_PAS_M2)
	void Remap256ColorTable(UTINY *color_buf, INT n_colors, UTINY *source_DACs, UTINY *dest_DACs)
#elif defined (USE_UPPER_C)
	void REMAP_256_COLOR_TABLE(UTINY *color_buf, INT n_colors, UTINY *source_DACs, UTINY *dest_DACs)
#elif defined (USE_LOWER_C)
	void remap_256_color_table(UTINY *color_buf, INT n_colors, UTINY *source_DACs, UTINY *dest_DACs)
#endif
{
FAST INT i;

for (i = 0; i < n_colors; i++) {
	color_buf[i] = (UTINY) _gfx_find_closest_point(source_DACs[0],
	  source_DACs[1], source_DACs[2], (UTINY_FAR *)dest_DACs, 256);
	source_DACs += 3;
	}
}


#ifdef ZINC_OEM
_Int _gfx_find_closest_point(INT red, INT green, INT blue, UTINY_FAR *DAC_map, INT n_DACs)
{
return red+green+blue+n_DACs+*DAC_map;
}
#endif


#ifdef JUNK

This routine has been moved to assembly language -- GFXG_ASM.ASM

Int_FCN _gfx_find_closest_point(INT red, INT green, INT blue, UTINY_FAR *DAC_map, INT n_DACs)
{
FAST INT distance, shortest_distance;
INT dr, dg, db, index, n;

shortest_distance = 30000;
for (n = 0; n < n_DACs; n++) {
	dr = red - *DAC_map++;
	dg = green - *DAC_map++;
	db = blue - *DAC_map++;
	distance = (dr*dr) + (dg*dg) + (db*db);
	if (distance < shortest_distance) {
		shortest_distance = distance;
		index = n;
		}
	}
return index;
}

#endif

/*~ RDPCXHDR.C */

GFX_GATE_PRO;

#if defined (USE_PAS_M2)
	INT ReadPCXHeader(TEXT *filename, PCX_HDR *pcx_hdr)
#elif defined (USE_UPPER_C)
	INT READ_PCX_HEADER(TEXT *filename, PCX_HDR *pcx_hdr)
#elif defined (USE_LOWER_C)
	INT read_PCX_header(TEXT *filename, PCX_HDR *pcx_hdr)
#endif
{
INT fh, rtn_val, _256_pal_exists;

GFX_GATE_CLOSE
if ((fh = gfx_open(filename, OPEN_READ_FILE)) < 5)
	return _gfx_err_number(BAD_FILE_OPEN, READ_PCX_HEADER_FCN+OPEN_GATE);
rtn_val = 0;
if (_gfx_load_PCX_header(fh, pcx_hdr, &_256_pal_exists))
	rtn_val = _256_pal_exists ? 2 : 1;
else _gfx_err_number(BAD_FILE_FORMAT, READ_PCX_HEADER_FCN);
gfx_close(fh);
GFX_GATE_OPEN
return rtn_val;
}

/*~ LDPCXHDR.C */

Long_FCN _gfx_load_PCX_header(INT fh, PCX_HDR *pcx_hdr, INT *_256_pal_exists)
{
TINY buf[2];
LONG image_size;

image_size = 0L;
*_256_pal_exists = NO;
gfx_read(pcx_hdr, sizeof(PCX_HDR), fh);
if (pcx_hdr->mfg == ZSOFT_PCX) {
	image_size = gfx_lseek(fh, 0L, 2) - sizeof(PCX_HDR);
	if ((pcx_hdr->version == 5) AND (pcx_hdr->bits_per_pixel == 8)) {
		if (gfx_lseek(fh, (LONG) -(PCX_256_PAL_SZ + 1), 2) > sizeof(PCX_HDR)) {
			gfx_read(buf, 1, fh);
			if (buf[0] == 0xC) {
				image_size -= PCX_256_PAL_SZ + 1;
				*_256_pal_exists = YES;
				}
			}
		}
	gfx_lseek(fh, (LONG) sizeof(PCX_HDR), 0);
	}
else if (pcx_hdr->mfg == GFX_PCX) {
	image_size = pcx_hdr->image_size & 0x7FFFFFFFL;
	if (pcx_hdr->image_size < 0L)
		*_256_pal_exists = YES;
	}
return image_size;
}

/*~ LDBIGFIL.C */

UtinyFarPtr_FCN _gfx_load_huge_file(INT source_fh, UTINY_FAR *far_buf,
   FAR_DMEM_HANDLE *mc, LONG *file_size, INT fcn_n)
{
LONG n_bytes_read;

n_bytes_read = 0L;
*mc = NULL_DMEM_HANDLE;
if (!far_buf AND ((far_buf = _gfx_farmalloc_mc(*file_size,
   (FAR_DMEM_HANDLE *) mc)) == (UTINY_FAR *) 0))
	_gfx_err_number(NO_HEAP_SPACE, fcn_n);
else
	n_bytes_read = gfx_huge_read(far_buf, *file_size, source_fh);
*file_size = n_bytes_read;
return far_buf;
}


/*~ FREE_PIC.C */

GFX_GATE_PRO;

#if defined (USE_PAS_M2)
	INT FreePic(PIC *user_pic)
#elif defined (USE_UPPER_C)
	INT FREE_PIC(PIC *user_pic)
#elif defined (USE_LOWER_C)
	INT free_pic(PIC *user_pic)
#endif
{
INT val;

GFX_GATE_CLOSE
val = _gfx_free_pic(user_pic);
GFX_GATE_OPEN
return val;
}

Int_FCN _gfx_free_pic(PIC *user_pic)
{
FAST INT flags;
PIC pic;

if (user_pic AND _gfx_read_pic_struct((DMEM_HANDLE) user_pic, &pic, FREE_PIC_FCN)) {
	flags = pic.sys_flags;
	if ((flags & FREE_HANDLE) AND (pic.file_handle > 0))
		gfx_close(pic.file_handle);
	if ((flags & FREE_IMAGE_MEM) AND pic.ram_mc)
		_gfx_farfree_mc(pic.ram_mc);
	if (flags & FREE_PIC_STRUCT)
		_gfx_free_mc((DMEM_HANDLE) user_pic);
	return SUCCESS;
	}
return NULL;
}


/*~ IMAGESZE.C */

GFX_GATE_PRO;

#if defined (USE_PAS_M2)		/* GetImageSize(x1, y1, x2, y2, encode) */
	LONG AFdecl _gfx_get_image_size(INT arg, ... )
#elif defined (USE_UPPER_C)
	LONG GET_IMAGE_SIZE(INT arg, ... )
#elif defined (USE_LOWER_C)
	LONG AFdecl get_image_size(INT arg, ... )
#endif
{
INT *args, encoding;
PIC pic;

GFX_GATE_CLOSE
_gfx_init_pic_struct(&pic, IMAGE_RAM);
args = &arg;
args += _gfx_get_box_coor_pair(GET_PIC_DIM, args, (BOX_COOR *) &(pic.x1));
encoding = *args;
if (encoding AND (encoding != ENCODE_BEST) AND (encoding != ENCODE_PCX) AND
   (encoding != ENCODE_RLE))
	return (LONG) _gfx_err_number(BAD_PIC_TYPE, GET_IMAGE_SIZE_FCN+OPEN_GATE);
pic.encoding = *args++ & 0x7;
_gfx_lo_get_image_size(&pic);
GFX_GATE_OPEN
return pic.image_size;
}


Int_FCN _gfx_lo_get_image_size(PIC *pic)
{
INT action;

action = GET_IMAGE_SIZE;
if (pic->encoding == ENCODE_BEST) {
	action |= GET_BEST_IMAGE_SIZE;
	pic->encoding = ENCODE_RLE;
	}
_gfx_move_vidram(pic, action);
return SUCCESS;
}


/*~ LOVIDMOV.C */

#define SHIFT_BITS			1
#define PROMOTE_COLORS		0x100
#define BUILD_MATTE_MASK		0x200
#define STRETCH_X_IMAGE		0x1000
#define STRETCH_Y_IMAGE		0x2000
#define XLAT_256_PAL		0x4000
#define MODIFY_IMAGE		(PROMOTE_COLORS+BUILD_MATTE_MASK+STRETCH_X_IMAGE+STRETCH_Y_IMAGE+XLAT_256_PAL)

struct _vcx { INT  x_bytes, y_rows, src_n_planes, dest_n_planes, action;
		    INT  dest_x_bytes, dest_n_rows, clip_top_rows;
		    INT  start_x_byte, show_x_bytes, n_pad_bytes;
		    INT  masks, shift_n_bits, encode_type;
		    INT  matte_color, n_matte_planes, base_color;
		    INT  n_image_colors, n_dest_colors, promote_colors_type;
		    INT  stretch, stretch_bits, show_offset;
		    UINT swath_dx, swath_dy;
		    INT  flags;
		    UINT buf_size;
		    LONG rle_image_size, pcx_image_size;
		    UINT AFdecl (*xlat_fcn)(UTINY_FAR *, UTINY_FAR *, INT, INT, INT);
		    UINT AFdecl (*count_rows)(UTINY_FAR *, UINT, INT, INT *, INT );
		    UTINY_FAR *buf;
		    UTINY_FAR *xlat_buf;
		    UTINY_FAR *scratch_buf;
		    UTINY_FAR *xlat_256_pal;
		  } ;

#define WRITE_PAD_BYTES		4

LOCAL struct _vcx NEAR vc ISTAT_ARR_0;

LOCAL_Uint_FCN _gfx_vidram_to_xbuf(void)
{
FAST UINT offset, x_bytes;
INT n_planes, total_x_bytes, max_x_bytes, delta, n;
UTINY_FAR *inbuf;

n_planes = vc.dest_n_planes + vc.n_matte_planes;
x_bytes = vc.x_bytes + vc.n_pad_bytes;
max_x_bytes = (x_bytes * n_planes) + 64;
total_x_bytes = x_bytes * vc.dest_n_planes;
delta = offset = total_x_bytes;
if (vc.action & GET_BEST_IMAGE_SIZE)
	delta = offset = 1024;
while (vc.y_rows AND ((offset+max_x_bytes) < vc.buf_size)) {
	inbuf = vc.buf + offset;
	_gfx_read_next_vid_line(inbuf, x_bytes);
	if (vc.flags & SHIFT_BITS)
		_gfx_shift_block(inbuf, inbuf, total_x_bytes, vc.shift_n_bits);
	if (vc.flags & BUILD_MATTE_MASK)
		_gfx_build_16_mask(inbuf, inbuf+total_x_bytes, x_bytes, vc.matte_color);
	n = (*vc.xlat_fcn)(inbuf, inbuf-delta, vc.x_bytes, vc.n_pad_bytes, n_planes);
	if (vc.action & GET_IMAGE_SIZE) {
		vc.rle_image_size += n;
		if (vc.action & GET_BEST_IMAGE_SIZE) {
			n = _gfx_pcx_compress_row(inbuf, inbuf-delta, vc.x_bytes, vc.n_pad_bytes, n_planes);
			vc.pcx_image_size += n;
			}
		}
	else offset += n;
	vc.y_rows--;
	}
return offset-delta;
}


LOCAL_Uint_FCN _gfx_xbuf_to_vidram(void)
{
FAST INT	flags, n_src_rows;
INT n_scan_x_bytes, action, dup_line, xlat_n_planes, shift_x_bytes, dest_x_bytes;
UINT swath_dx, offset;
UTINY_FAR *matte_buf;
UTINY_FAR *stretch_buf;
UTINY_FAR *show_buf;

offset = 0;
action = vc.action & 0xFF;
n_scan_x_bytes = vc.x_bytes + WRITE_PAD_BYTES;  
dest_x_bytes = vc.dest_x_bytes + WRITE_PAD_BYTES;  
xlat_n_planes = vc.src_n_planes + vc.n_matte_planes;
if ((n_src_rows = vc.y_rows) <= 0) {
	n_src_rows = -n_src_rows;
	(*vc.count_rows)(vc.buf, vc.buf_size, vc.x_bytes, &vc.y_rows, xlat_n_planes);
	if (n_src_rows > vc.y_rows)
		n_src_rows = vc.y_rows;
	}
flags = vc.flags;
if (flags & SHIFT_BITS)
	shift_x_bytes = n_scan_x_bytes * xlat_n_planes;
stretch_buf = show_buf = vc.xlat_buf;
if (flags & MODIFY_IMAGE) {
	if ((flags & (PROMOTE_COLORS+STRETCH_X_IMAGE)) == PROMOTE_COLORS+STRETCH_X_IMAGE)
	     stretch_buf = vc.scratch_buf;
	else if ((flags & (PROMOTE_COLORS+STRETCH_X_IMAGE)) != 0)
		show_buf = vc.scratch_buf;
	if (flags & BUILD_MATTE_MASK)
		matte_buf = show_buf +  (dest_x_bytes * vc.dest_n_planes);
	swath_dx = (vc.buf + vc.swath_dx) - stretch_buf;
	}
while ((offset < vc.buf_size) AND vc.dest_n_rows AND n_src_rows) {
	dup_line = 1;
	n_src_rows--;
	offset += (*vc.xlat_fcn)(vc.xlat_buf, vc.buf+offset, vc.x_bytes, WRITE_PAD_BYTES, xlat_n_planes);
	if (flags & SHIFT_BITS)
		_gfx_shift_block(vc.xlat_buf, vc.xlat_buf, shift_x_bytes, vc.shift_n_bits);
	if (flags & MODIFY_IMAGE) {
		if (flags & XLAT_256_PAL) {
			_gfx_xlat_256_colors(vc.xlat_buf, vc.xlat_256_pal, vc.x_bytes);
			}
		if (flags & PROMOTE_COLORS) {
			if ((vc.promote_colors_type == 1) AND (flags & BUILD_MATTE_MASK))
				_gfx_far_move(vc.xlat_buf, matte_buf, vc.x_bytes);
			_gfx_promote_colors(vc.xlat_buf, vc.scratch_buf, n_scan_x_bytes,
			   vc.base_color, vc.promote_colors_type);
			}
		if (flags & STRETCH_X_IMAGE) {
			_gfx_xpand_bits(stretch_buf, show_buf, swath_dx, n_scan_x_bytes, 
			   dest_x_bytes, vc.stretch_bits);
			}
		if (flags & STRETCH_Y_IMAGE) {
			if ((dup_line = vc.buf[vc.swath_dy++]) > vc.dest_n_rows)
				dup_line = vc.dest_n_rows;
			}
		if ((flags & BUILD_MATTE_MASK) AND (vc.promote_colors_type != 1))
			_gfx_build_16_mask(show_buf, matte_buf, dest_x_bytes, vc.matte_color);
		}
	while (--dup_line >= 0) {
		if (--vc.clip_top_rows < 0) {
			_gfx_move_next_vid_line(show_buf+vc.show_offset, vc.show_x_bytes,
			   dest_x_bytes, vc.masks, action);
			vc.dest_n_rows--;
			}
		}
	}
vc.y_rows -= n_src_rows;
return offset;
}

LOCAL UINT _gfx_no_modify_get_data(UTINY_FAR *inbuf, UTINY_FAR *outbuf, FAST INT move_x_bytes, INT pad_byte, INT n_planes)
{
UINT n_bytes;

if (inbuf != outbuf) {
	n_bytes = (UINT) move_x_bytes * n_planes;
	while (n_planes--) {
		_gfx_far_move(inbuf, outbuf, move_x_bytes);
		inbuf += move_x_bytes + pad_byte;
		outbuf += move_x_bytes;
		}
	}
return n_bytes;
}

LOCAL UINT AFdecl _gfx_no_modify_put_data(UTINY_FAR *outbuf, UTINY_FAR *inbuf, INT move_x_bytes, INT pad_byte, INT n_planes)
{
UINT n_bytes;

n_bytes = (UINT) move_x_bytes * n_planes;
while (n_planes--) {
	_gfx_shift_block(inbuf, outbuf, move_x_bytes+1, vc.shift_n_bits);
	inbuf += move_x_bytes;
	outbuf += move_x_bytes + pad_byte;
	}
return n_bytes;
}

#if defined (__TURBOC__)
#pragma argsused
#endif

LOCAL UINT AFdecl _gfx_no_modify_count_rows(UTINY_FAR *inbuf, UINT buf_size, INT x_bytes, INT *max_y_rows, INT n_planes)
{
FAST UINT y_rows, row_len;

y_rows = *max_y_rows;
row_len = (UINT) (x_bytes * n_planes);
if ((y_rows == 0) OR (y_rows > (buf_size / row_len))) {
	y_rows = buf_size / row_len;
	row_len *= y_rows;
	}
*max_y_rows = y_rows;
return row_len * y_rows;
}


LOCAL UINT AFdecl (*arr_xlat_fcn[][4])(UTINY_FAR *, UTINY_FAR *, INT, INT, INT) =
   {	{_gfx_no_modify_get_data, _gfx_pcx_compress_row, _gfx_rle_compress_row},
	{_gfx_no_modify_put_data, _gfx_pcx_expand_row,   _gfx_rle_expand_row} };

LOCAL UINT AFdecl (*arr_count_rows[])(UTINY_FAR *, UINT, INT, INT *, INT) =
	{_gfx_no_modify_count_rows, _gfx_pcx_count_rows, _gfx_rle_count_rows};

#define _pg256(val)		(INT) (val & 0xFFFFL), (INT) (val>>16)

	/* action: 0 = read, 0x100 = read w/matte, 0x200 = read w/ image size
	 *		 1 = Put, 2 = And, 3 = Or, 4 = Xor, 5 = Matte, 6 = Reverse
	 */

LOCAL_Int_PRO x_bytes_in_line(INT x, INT x_pels_wide, INT n_colors);
LOCAL_Int_PRO read_x_bytes(INT x, INT n_pels);

#if (KOMPACT_32 == 1)

struct _z { int   offset;
		  short seg; } xp;

UTINY_FAR *screen_base_to_far_ptr(void)
{
xp.offset = 0;
xp.seg = (short) _gfx.screen_base;
return *(UTINY_FAR **)&xp;
}

#else

#define screen_base_to_far_ptr()	(UTINY_FAR *) ((LONG)_gfx.screen_base << 16);

#endif

#define PUT_MATTE			5

Long_FCN _gfx_move_vidram(PIC *user_pic, INT action)
{
FAST UINT offset, n_bytes;
UINT buf_sz;
INT	x1, x2, x_pels, n, i, n_pels_per_byte, read_screen, n_source_rows;
INT	start_bit, end_bit, pel_byte_mask, show_n_rows;
UINT  xlat_buf_size, scratch_buf_size;
LONG count, max_buf_size;
PIC	pic;
UTINY_FAR *vid_buf;
UTINY_FAR *in_buf;
UTINY_FAR *image_buf;
IMPORT UTINY _lbitmask[];
IMPORT UTINY _rbitmask[];

pic = *user_pic;
if ((pic.x1 >= (INT)_gfx.screen_x_res) OR (pic.y1 >= (INT)_gfx.screen_y_res))
	return 0L;
if ((read_screen = !(action & 0xFF)) != 0)
	pic.stretch_y_rows = pic.stretch_x_pels = 0;
zfill(&vc, sizeof(struct _vcx));
vc.n_dest_colors = _gfx.n_colors;
vc.n_image_colors = (pic.n_orig_colors == 0) ? vc.n_dest_colors : pic.n_orig_colors;
vc.dest_n_planes = (vc.n_dest_colors == 16) ? 4 : 1;
if ((vc.src_n_planes = pic.n_planes) == 0)
	user_pic->n_planes = vc.src_n_planes = vc.dest_n_planes;
n_pels_per_byte = (vc.n_image_colors == 256) ? 1 : 8;
vc.encode_type = pic.encoding;

x1 = pic.x1;
x2 = x1 + (pic.stretch_x_pels ? pic.stretch_x_pels : pic.x_pels) - 1;
vc.dest_n_rows = vc.y_rows = pic.y_rows;
if (pic.stretch_y_rows)
	vc.dest_n_rows = pic.stretch_y_rows;

if (pic.clip_image) {
	if ((x1 > _gfx.max_x) OR (pic.y1 > _gfx.max_y) OR (x2 < _gfx.min_x) OR
	   ((pic.y1 + vc.y_rows) < _gfx.min_y)) then return 0L;
	if ((n = _gfx.min_y - pic.y1) > 0) {
		pic.y1 += n;
		vc.clip_top_rows = n;
		}
	if ((n = (pic.y1 + vc.dest_n_rows - 1) - _gfx.max_y) < 0)
		n = 0;
	vc.y_rows -= n + vc.clip_top_rows;
	vc.dest_n_rows -= n + vc.clip_top_rows;

	if (x1 < _gfx.min_x) then x1 = _gfx.min_x;
	if (x2 > _gfx.max_x) then x2 = _gfx.max_x;
	if (read_screen) then pic.x1 = x1;
	}

x_pels = x2 - x1 + 1;
_gfx_init_move_vid_line(x1, pic.y1);

pel_byte_mask = n_pels_per_byte - 1;
if ((vc.x_bytes = pic.x_bytes_per_line) == 0)
	vc.x_bytes = read_x_bytes(read_screen ? pic.x1 : 0, x_pels);
start_bit = x1 & pel_byte_mask;
end_bit = (x2 & pel_byte_mask) + 1;
if (n_pels_per_byte == 4) {
	start_bit <<= 1;
	end_bit <<= 1;
	}

if (vc.n_image_colors <= 16)
	vc.masks = (_rbitmask[start_bit] << 8) | _lbitmask[end_bit];
vc.action = action;
vc.buf_size = _gfx_get_temp_workspace(&vc.buf, 0) * 0x400;

vc.matte_color = pic.matte_color;
if ((pic.sys_flags & ENCODE_MATTE_MASK) AND (vc.n_image_colors == 16)) {
	vc.n_matte_planes = 1;
	if (vc.action != PUT_MATTE) then vc.flags |= BUILD_MATTE_MASK;
	}
else if (vc.action == PUT_MATTE) {
	if (vc.n_dest_colors == 256) then vc.masks = vc.matte_color;
	else vc.flags |= BUILD_MATTE_MASK;
	}

vid_buf = screen_base_to_far_ptr();

if (read_screen) {
	vc.xlat_fcn = arr_xlat_fcn[0][vc.encode_type];
	if ((vc.n_dest_colors < 256) AND start_bit) {
		vc.flags |= SHIFT_BITS;
		vc.shift_n_bits = -start_bit;
		/*if ((vc.n_pad_bytes = read_x_bytes(0, x_pels) - vc.x_bytes) == 0)*/
		vc.n_pad_bytes = 2;
		}
	max_buf_size = ((pic.mem_type == SYSTEM_RAM) AND pic.image_size) ?
	   pic.image_size : 0x800000L;
	for (count = 0L; (vc.y_rows > 0) AND (max_buf_size > count); count += n_bytes) {
		show_n_rows = vc.y_rows;
		n_bytes = _gfx_vidram_to_xbuf();
		pic.y_rows_moved += show_n_rows - vc.y_rows;
		if (vc.y_rows == show_n_rows) {
			pic.y_rows_moved = vc.y_rows;
			break;
			}
		if (vc.action & GET_IMAGE_SIZE) {
			if ((vc.rle_image_size < vc.pcx_image_size) OR
			   (!(vc.action & GET_BEST_IMAGE_SIZE))) {
				user_pic->image_size = vc.rle_image_size;
				}
			else {
				user_pic->encoding = ENCODE_PCX;
				user_pic->image_size = vc.pcx_image_size;
				}
			count = user_pic->image_size;
			break;
			}
		if (pic.mem_type == VIDEO_RAM) {
			if (vc.n_image_colors == 256)
				_gfx_buf_to_ptr_vram256(vc.buf, _pg256(pic.image_offset), n_bytes, 1);
			else
				_gfx_far_move(vc.buf, vid_buf + pic.image_offset, n_bytes);
			}
		else if (pic.mem_type == SYSTEM_RAM)
			_gfx_huge_move(pic.image_buf, pic.image_offset, vc.buf, 
			   n_bytes, SMALL_TO_HUGE);
		else if (pic.mem_type == FILE_MEM)
			gfx_write(vc.buf, n_bytes, pic.file_handle);
		pic.image_offset += n_bytes;
		}
	user_pic->y_rows_moved = pic.y_rows_moved;
	}
else {
	scratch_buf_size = offset = 0;
	count = pic.image_size;
	vc.xlat_fcn = arr_xlat_fcn[1][pic.encoding];
	vc.count_rows = arr_count_rows[pic.encoding];

	n_bytes = (vc.n_dest_colors == 256) ? pic.x_pels : vc.x_bytes;
	vc.dest_x_bytes = (pic.stretch_x_pels != 0) ?
	   read_x_bytes(0, pic.stretch_x_pels) : n_bytes;
	xlat_buf_size = (vc.x_bytes + 5) * (vc.src_n_planes + vc.n_matte_planes);

		/* Shift the image */
	if ((vc.n_dest_colors <= 16) AND (pic.x1 & pel_byte_mask)) {
		if (vc.encode_type != 0) then vc.flags |= SHIFT_BITS;
		vc.shift_n_bits = pic.x1 & pel_byte_mask;
		}

		/* vc.promote_colors_type: 1==(1->16), 2==(1->256), 3==(16->256) */
	if ((UINT) vc.n_image_colors < vc.n_dest_colors) {
		vc.flags |= PROMOTE_COLORS;
		if (vc.n_dest_colors == 16) then vc.promote_colors_type = 1;
		else vc.promote_colors_type = (vc.n_image_colors == 16) ? 3 : 2;
		scratch_buf_size = (vc.x_bytes + WRITE_PAD_BYTES) * ((vc.promote_colors_type == 1) ? 4 : 8);
		if ((vc.base_color = pic.promote_color) < 0)
			vc.base_color = (vc.n_image_colors == 2) ? 1 : 0;
		vc.src_n_planes = pic.n_planes;
		}

		/* Stretch the image */
	if (pic.stretch_x_pels != 0) {
		vc.flags |= STRETCH_X_IMAGE;
		vc.swath_dx = vc.buf_size -= pic.x_pels + vc.shift_n_bits + 2;
		_gfx_set_swath(vc.buf+vc.swath_dx, pic.stretch_x_pels, pic.x_pels, vc.shift_n_bits);
		if ((n_bytes = (vc.dest_x_bytes + 4) * vc.dest_n_planes) > scratch_buf_size)
			scratch_buf_size = n_bytes;
		if (vc.n_dest_colors == 256)
			vc.stretch_bits = 8;
		}
	if (pic.stretch_y_rows != 0) {
		vc.flags |= STRETCH_Y_IMAGE;
		vc.swath_dy = vc.buf_size -= pic.y_rows + 2;
		_gfx_set_swath(vc.buf + vc.swath_dy, pic.stretch_y_rows, pic.y_rows, 0);
		}

		/* Build a mask for the image */
	if (vc.flags & BUILD_MATTE_MASK) {
		n_bytes = (vc.dest_x_bytes + WRITE_PAD_BYTES) * 5;
		if (n_bytes > scratch_buf_size)
			scratch_buf_size = n_bytes;
		}

		/* Save room for And, Or, Xor or Matting */
	if ((action != 1) AND
	   ((n_bytes = ((vc.dest_x_bytes+8)*vc.dest_n_planes)*2) > scratch_buf_size))
		scratch_buf_size = n_bytes;

	if ((vc.n_image_colors == 256) AND pic.xlat_256_pal) {
		vc.xlat_256_pal = pic.xlat_256_pal;
		vc.flags |= XLAT_256_PAL;
		}

	vc.xlat_buf = vc.buf + vc.buf_size - (xlat_buf_size+scratch_buf_size+20);
	vc.scratch_buf = vc.xlat_buf + xlat_buf_size;
	vc.show_x_bytes = x_bytes_in_line(x1, x2 - x1 + 1, vc.n_dest_colors);
     vc.show_offset = x_bytes_in_line(pic.x1, x1-pic.x1+1, vc.n_dest_colors) - 1;
	n_source_rows = pic.y_rows;

	while (vc.dest_n_rows > 0) {
		n_bytes = (UINT) min(pic.image_size-(LONG)offset, vc.xlat_buf-(vc.buf+offset));
		in_buf = vc.buf + offset;
		if (pic.mem_type == VIDEO_RAM) {
			if (vc.n_image_colors == 256)
				_gfx_ptr_vram256_to_buf(_pg256(pic.image_offset), n_bytes, 1, in_buf);
			else
				_gfx_far_move(vid_buf + pic.image_offset, in_buf, n_bytes);
			}
		else if (pic.mem_type == SYSTEM_RAM)
			n_bytes = _gfx_huge_move(pic.image_buf, pic.image_offset, in_buf,
			   n_bytes, HUGE_TO_SMALL);
		else if (pic.mem_type == FILE_MEM)
			gfx_read(in_buf, n_bytes, pic.file_handle);

		pic.image_offset += n_bytes;
		n_bytes += offset;
		vc.y_rows = ((LONG)n_bytes >= pic.image_size) ? n_source_rows : -n_source_rows;
		vc.buf_size = n_bytes;
		buf_sz = _gfx_xbuf_to_vidram();
		if (vc.dest_n_rows > 0) {
			n_source_rows -= vc.y_rows;
			pic.image_size -= buf_sz;
			if ((offset = n_bytes - buf_sz) > 0)
				_gfx_far_move(vc.buf+buf_sz, vc.buf, offset);
			}
		}
	}
turn_off_ega();
_gfx_free_temp_workspace(vc.buf);
return count;
}


LOCAL_Int_FCN x_bytes_in_line(INT x, INT x_pels_wide, INT n_colors)
{
return (n_colors == 256) ?
  x_pels_wide : (((x + x_pels_wide - 1) >> 3) - (x >> 3) + 1);
}

LOCAL_Int_FCN read_x_bytes(INT x, INT n_pels)
{
return (x_bytes_in_line(x, n_pels, vc.n_dest_colors) + 1) & ~1;
}


/*~ FARMALOC.C */

#if (PROT_MODE_SYS != PMODE_32)

#if (USE_DFLT_MALLOC == YES)

#if defined(__TURBOC__) || defined(__ZTC__)
#define _farmalloc		farmalloc
#define _farfree		farfree
#elif defined (__HIGHC__)
#define _farmalloc		_halloc
#define _farfree		_hfree
#else
#define _farmalloc		halloc
#define _farfree		hfree
#endif

extern VOID_FAR *_farmalloc(long, int);
extern void _farfree(UTINY_FAR *);
#endif

#if (MOBILE_DMEM == 0)

IMPORT SAFE_MALLOC_LINK NEAR _gfx_safe_malloc;

#if (USE_DFLT_MALLOC == YES)
VOID_FAR *(*_gfx_farmalloc_vec)(LONG, INT) = _farmalloc;
void  (*_gfx_farfree_vec)(UTINY_FAR *) = _farfree;
#else
VOID_FAR *(*_gfx_farmalloc_vec)(LONG, INT);
void  (*_gfx_farfree_vec)(UTINY_FAR *);
#endif

UtinyFarPtr_FCN _gfx_farmalloc_mc(LONG n_bytes, FAR_DMEM_HANDLE *mc)
{
UTINY_FAR *ptr;

n_bytes += _gfx_safe_malloc.header_bytes;
ptr = (*_gfx_farmalloc_vec)(n_bytes, 1);
if (ptr AND _gfx_safe_malloc.header_bytes) {
	_gfx_safe_malloc.lp = (LONG_FAR *) ptr;
	_gfx_safe_malloc.malloc_safe_block(n_bytes, FARMALLOC_SIGNATURE);
	ptr = (UTINY_FAR *) _gfx_safe_malloc.lp;
	}
*mc = (FAR_DMEM_HANDLE)ptr;
return ptr;
}

Void_FCN _gfx_farfree_mc(FAR_DMEM_HANDLE mc)
{
LONG *ip;

if (mc) {
	if (_gfx_safe_malloc.header_bytes) {
		_gfx_safe_malloc.lp = (LONG_FAR *) mc;
		 _gfx_safe_malloc.free_safe_block(FARMALLOC_SIGNATURE);
		mc = (FAR_DMEM_HANDLE) _gfx_safe_malloc.lp;
		}
	(*_gfx_farfree_vec)((UTINY_FAR *) mc);
	}
}

#else

LOCAL UTINY_FAR *_dflt_deref_farmc(DMEM_HANDLE mc)
{
return (UTINY_FAR *)mc;
}

VOID_FAR *(*_gfx_farmalloc_vec)(LONG, DMEM_HANDLE *) = _farmalloc;
void  (*_gfx_farfree_vec)(DMEM_HANDLE) = _farfree;
UTINY_FAR *(*_gfx_deref_farmc_vec)(DMEM_HANDLE) =  _dflt_deref_farmc;

UtinyFarPtr_FCN _gfx_farmalloc_mc(LONG n_bytes, DMEM_HANDLE *mc)
{
UTINY_FAR *ptr;

*mc = (DMEM_HANDLE) 0;
ptr = (*_gfx_farmalloc_vec)(n_bytes, mc);
if (!*mc)
	*mc = (DMEM_HANDLE)ptr;
return ptr;
}

Void_FCN _gfx_farfree_mc(DMEM_HANDLE mc)
{
if (mc) then (*_gfx_farfree_vec)(mc);
}

UtinyFarPtr_FCN _gfx_deref_farmc(DMEM_HANDLE mc)
{
return (*_gfx_deref_farmc_vec)(mc);
}


#endif

#endif


/*~ LOMALLOC.C */

#if (MOBILE_DMEM == 0)

#if (USE_DFLT_MALLOC == YES)
extern void *malloc(UINT);
extern void  free(void *);

void *(*_gfx_malloc_vec)(UINT) = malloc;
void  (*_gfx_free_vec)(void *) = free;
#else
void *(*_gfx_malloc_vec)(UINT);
void  (*_gfx_free_vec)(void *);
#endif

IMPORT SAFE_MALLOC_LINK NEAR _gfx_safe_malloc;

CharPtr_FCN _gfx_malloc_mc(UINT n_bytes, DMEM_HANDLE *mc)
{
TINY *ptr;

n_bytes += _gfx_safe_malloc.header_bytes;
ptr = (*_gfx_malloc_vec)(n_bytes);
if (ptr AND _gfx_safe_malloc.header_bytes) {
	_gfx_safe_malloc.lp = (LONG_FAR *) ptr;
	_gfx_safe_malloc.malloc_safe_block((LONG) n_bytes, MALLOC_SIGNATURE);
	ptr = (TINY *) _gfx_safe_malloc.lp;
	}
*mc = (DMEM_HANDLE)ptr;
return ptr;
}

Void_FCN _gfx_free_mc(DMEM_HANDLE mc)
{

if (mc) {
	if (_gfx_safe_malloc.header_bytes) {
		_gfx_safe_malloc.lp = (LONG_FAR *) mc;
		_gfx_safe_malloc.free_safe_block(MALLOC_SIGNATURE);
		mc = (DMEM_HANDLE) _gfx_safe_malloc.lp;
		}
	(*_gfx_free_vec)((void *)mc);
	}
}


#else


 **********************************************************************
 * The functions _gfx_deref_mc() and _gfx_unlock_mc() are for future	*
 * use and are currently implemented as macros that do nothing useful.*
 * They are for the time when dynamic memory allocation may not		*
 * return a pointer, but rather a handle to the memory. The 		*
 * _gfx_deref_mc() function will take the handle as an argument and	*
 * return a valid pointer to the memory, and the _gfx_unloc_mc() 	*
 * function will take a handle to the memory and unlock it so the	*
 * operating system can reposition the memory where it likes.		*
 **********************************************************************

LOCAL TINY *_dflt_deref_mc(DMEM_HANDLE mc)
{
return (TINY *)mc;
}

#if defined (__TURBOC__)
#pragma argsused
#endif

LOCAL void _dflt_null_fcn(DMEM_HANDLE wc)
{ ; }

extern void *malloc(UINT);
extern void  free(void *);

#if defined (__TURBOC__)
#pragma argsused
#endif

LOCAL char *_dflt_malloc(UINT n_bytes, DMEM_HANDLE *mc)
{
return (TINY *) malloc(n_bytes);
}

LOCAL void _dflt_free(DMEM_HANDLE mc)
{
free((void *) mc);
}


TINY *(*_gfx_malloc_vec)(UINT, DMEM_HANDLE *) = _dflt_malloc;
void  (*_gfx_free_vec)(DMEM_HANDLE) = _dflt_free;
TINY *(*_gfx_deref_vec)(DMEM_HANDLE) =	_dflt_deref_mc;
void  (*_gfx_unlock_vec)(DMEM_HANDLE) = _dflt_null_fcn;

CharPtr_FCN _gfx_malloc_mc(UINT n_bytes, DMEM_HANDLE *mc)
{
TINY *ptr;

*mc = (DMEM_HANDLE) 0;
ptr = (*_gfx_malloc_vec)(n_bytes, mc);
if (!*mc)
	*mc = (DMEM_HANDLE)ptr;
return ptr;
}

Void_FCN _gfx_free_mc(DMEM_HANDLE mc)
{
if (mc) then (*_gfx_free_vec)(mc);
}


CharPtr_FCN _gfx_deref_mc(DMEM_HANDLE mc)
{
return (*_gfx_deref_vec)(mc);
}


Void_FCN _gfx_unlock_mc(DMEM_HANDLE mc)
{
(*_gfx_unlock_vec)(mc);
}

#endif


/*^ GFXF_C.C */

#include "GFXF_SRC.H"

/*~ CLOSEFNT.C */

LOCAL_Int_PRO free_font_mem(INT fh);
GFX_GATE_PRO;

#if defined (USE_PAS_M2)
	INT CloseFont(FAST INT fh)
#elif defined (USE_UPPER_C)
	INT CLOSE_FONT(FAST INT fh)
#else
	INT close_font(FAST INT fh)
#endif
{

GFX_GATE_CLOSE
if ((UINT)fh <= 3) {
	if (fh == 0) {
		for (fh = 4; fh < MAX_FONT_HANDLES; fh++)
			free_font_mem(fh);
		_gfx_curr_font(1);
		}
	}
else if (((UINT)fh < MAX_FONT_HANDLES) AND free_font_mem(fh)) {
	if (_gfx_curr_font(DFLT) == fh) then _gfx_curr_font(1);
	}
else return _gfx_err_number(BAD_FONT_HANDLE, CLOSE_FONT_FCN+OPEN_GATE);
GFX_GATE_OPEN
return SUCCESS;
}


LOCAL_Int_FCN free_font_mem(INT fh)
{
FONT *font;
IMPORT DMEM_HANDLE _gfx_loaded_fonts[];

if ((font = (FONT *)_gfx_loaded_fonts[fh]) != (FONT *) 0) {
	if ((font->flags & COMPILED_FONT) == 0)
		_gfx_free_mc((DMEM_HANDLE) font);
	_gfx_loaded_fonts[fh] = NULL_DMEM_HANDLE;
	return SUCCESS;
	}
return FAILURE;
}


/*~ FALIGN.C */

GFX_GATE_PRO;

#if defined (USE_PAS_M2)
	INT FontAlign(INT fh, INT align)
#elif defined (USE_UPPER_C)
	INT FONT_ALIGN(INT fh, INT align)
#else
	INT font_align(INT fh, INT align)
#endif
{
FONT font;

GFX_GATE_CLOSE
if (!inrange(TOP_LINE, align, BOTTOM_LINE)) 
     return _gfx_err_number(BAD_ARG, FONT_ALIGN_FCN+OPEN_GATE);
if (_gfx_get_FONT_struct(fh,&font)) {
	font.attr.align = align;
	_gfx_reflect_font_attr(fh, &font);
	GFX_GATE_OPEN
	return SUCCESS;
	}
return _gfx_err_number(BAD_FONT_HANDLE, FONT_ALIGN_FCN+OPEN_GATE);
}


/*~ FCOLOR.C */

GFX_GATE_PRO;

#if defined (USE_PAS_M2)
	INT FontColor(INT fh, INT fgnd_color, INT bkgnd_color)
#elif defined (USE_UPPER_C)
	INT FONT_COLOR(INT fh, INT fgnd_color, INT bkgnd_color)
#else
	INT font_color(INT fh, INT fgnd_color, INT bkgnd_color)
#endif
{
FONT font;

GFX_GATE_CLOSE
if (_gfx_get_FONT_struct(fh, &font)) {
	if (fgnd_color != DFLT)
		font.attr.fgnd_color = fgnd_color;
	if (bkgnd_color != DFLT)
		font.attr.bkgnd_color = ((UINT)bkgnd_color == XPARENT) ? TRANSPARENT : bkgnd_color;
	_gfx_reflect_font_attr(fh, &font);
	GFX_GATE_OPEN
	return SUCCESS;
	}
return _gfx_err_number(BAD_FONT_HANDLE, FONT_COLOR_FCN+OPEN_GATE);
}


/*~ MAGFCN.C */

#ifdef ZINC_OEM

Void_FCN _gfx_set_magnify_fcn(void)
{  }

#else

IMPORT void AFdecl (*gfx_expand_fcn)(UTINY_FAR *, int, int, int, char *, int, int);
Void_FCN _gfx_set_magnify_fcn(void)
{
gfx_expand_fcn = _gfx_xpand_char;
}

#endif


/*~ FMAGNIFY.C */

GFX_GATE_PRO;

#if defined (USE_PAS_M2)
	INT FontMagnify(INT fh, INT expand_width, INT expand_rows)
#elif defined (USE_UPPER_C)
	INT FONT_MAGNIFY(INT fh, INT expand_width, INT expand_rows)
#else
	INT font_magnify(INT fh, INT expand_width, INT expand_rows)
#endif
{
FONT font;

GFX_GATE_CLOSE
if (_gfx_get_FONT_struct(fh, &font)) {
	if (is_stroke_font(font.flags)) {
		if (expand_width < 0) then expand_width = -expand_width;
		if (expand_rows < 0) then expand_rows = -expand_rows;
		}
	else if (!inrange(1, expand_width, 8) OR !inrange(1, expand_rows, 10))
		return _gfx_err_number(BAD_ARG, FONT_MAGNIFY_FCN+OPEN_GATE);
	font.attr.expand_width = expand_width;
	font.attr.expand_rows = expand_rows;
	_gfx_reflect_font_attr(fh, &font);
	_gfx_set_magnify_fcn();
	GFX_GATE_OPEN
	return SUCCESS;
	}
return _gfx_err_number(BAD_ARG, FONT_MAGNIFY_FCN+OPEN_GATE);
}

/*~ GET_FATT.C */

LOCAL FONT_ATTR _dflt_font_attr ISTAT_ARR_0;
GFX_GATE_PRO;

#if defined (USE_PAS_M2)
     FONT_ATTR *GetFontAttr(INT fh)
#elif defined (USE_UPPER_C)
     FONT_ATTR *GET_FONT_ATTR(INT fh)
#else
     FONT_ATTR *get_font_attr(INT fh)
#endif
{
FAST FONT *fp;

GFX_GATE_CLOSE
if (!fh) {
     _gfx_get_FONT_ATTR_struct(0, &_dflt_font_attr);
	GFX_GATE_OPEN
	return &_dflt_font_attr;
	}
fp = _gfx_get_font_ptr(fh, GET_FONT_ATTR_FCN);
GFX_GATE_OPEN
return fp ? &(fp->attr) : (FONT_ATTR *) 0;
}


IMPORT DMEM_HANDLE _gfx_loaded_fonts[];

FontPtr_FCN _gfx_get_font_ptr(INT fh, INT fcn_nmbr)
{
FAST FONT *fp;

fp = (FONT *) _gfx_loaded_fonts[fh];
if (!fp OR !inrange(0, fh, MAX_FONT_HANDLES-1)) {
	_gfx_err_number(BAD_ARG, fcn_nmbr);
	return (FONT *) 0;
	}
return fp;
}


/*~ FNTATRST.C */

LOCAL FONT_ATTR dflt_font_attr  =	{ BASE_LINE, 0, _0_DEGREES,
							  7, -1, 1, 1, 1, 0, 7};

Int_FCN _gfx_get_FONT_ATTR_struct(INT fh, FONT_ATTR *attr_ptr)
{
FONT font;

if (!fh) *attr_ptr = dflt_font_attr;
else if (_gfx_get_FONT_struct(fh, &font))
	*attr_ptr = font.attr;
else return FAILURE;
return SUCCESS;
}

/*~ GETLNATT.C */

LINE_ATTR NEAR gfx_line_attr = {YES, NO, TEXT_L_TO_R, JUSTIFY_START};

#if defined (USE_PAS_M2)
	LINE_ATTR *GetLineAttr(void)
#elif defined (USE_UPPER_C)
	LINE_ATTR *GET_LINE_ATTR(void)
#else
	LINE_ATTR *get_line_attr(void)
#endif
{

return (LINE_ATTR *)(&gfx_line_attr);
}


/*~ GETFHGT.C */

GFX_GATE_PRO;

#if defined (USE_PAS_M2)
	INT GetFontHeight(INT fh)
#elif defined (USE_UPPER_C)
	INT GET_FONT_HEIGHT(INT fh)
#else
	INT get_font_height(INT fh)
#endif
{
INT val;
FONT font;

GFX_GATE_CLOSE
val = _gfx_get_FONT_struct(fh, &font) ? 
   _gfx_xlat_int_coor(font.height, font.attr.expand_rows, 
      (font.flags & STROKE_FONT) ? 100 : 1) :
   _gfx_err_number(BAD_FONT_HANDLE, GET_FONT_HEIGHT_FCN);
GFX_GATE_OPEN
return val;
}


/*~ GETLNLEN.C */

GFX_GATE_PRO;

#if defined (USE_PAS_M2)
	INT GetLineLen(INT fh, char *text, INT max_n_char)
#elif defined (USE_UPPER_C)
	INT GET_LINE_LEN(INT fh, char *text, INT max_n_char)
#else
	INT get_line_len(INT fh, char *text, INT max_n_char)
#endif
{
FAST INT delta, c;
UTINY *tp;
INT n_bits;
FONT font;

if (!(*text) OR (max_n_char < 1)) then return NULL;
GFX_GATE_CLOSE
if (!_gfx_get_FONT_struct(fh, &font))
	return _gfx_err_number(BAD_FONT_HANDLE, GET_LINE_LEN_FCN+OPEN_GATE);
if (font.flags & STROKE_FONT) 
	delta = font.text_len(fh, (UTINY *)text,  max_n_char);
else {
	delta = 0;
	tp = (UTINY *) text;
	if (font.fixed_width_char)
		n_bits = font.fixed_width_char;
	while ((max_n_char-- > 0) AND ((c = *tp++) != 0)) {
	     c -= font.lo_char;
		if (!font.fixed_width_char AND ((UINT)c <= font.hi_char)) 
	    		n_bits = font.offset_table[c+1] - font.offset_table[c];
		delta += (n_bits * font.attr.expand_width) + font.attr.h_space;
		}
	}
GFX_GATE_OPEN
return delta;
}


/*~ LN_DIR.C */

GFX_GATE_PRO;

#if defined (USE_PAS_M2)
	INT LineDirection(INT dir)
#elif defined (USE_UPPER_C)
	INT LINE_DIRECTION(INT dir)
#else
	INT line_direction(INT dir)
#endif
{
IMPORT LINE_ATTR NEAR gfx_line_attr;

GFX_GATE_CLOSE
if (dir != DFLT) {
	if (!inrange(TEXT_R_TO_L, dir, TEXT_T_TO_B))
		return _gfx_err_number(BAD_ARG, LINE_DIRECTION_FCN+OPEN_GATE);
	gfx_line_attr.text_dir = dir;
	}
GFX_GATE_OPEN
return gfx_line_attr.text_dir;
}

/*~ LN_JUST.C */

GFX_GATE_PRO;

#if defined (USE_PAS_M2)
	INT LineJustify(int justification)
#elif defined (USE_UPPER_C)
	INT LINE_JUSTIFY(int justification)
#else
	INT line_justify(int justification)
#endif
{
IMPORT LINE_ATTR NEAR gfx_line_attr;

GFX_GATE_CLOSE
if (justification != DFLT) {
	if (!inrange(JUSTIFY_START, justification, JUSTIFY_END))
		return _gfx_err_number(BAD_ARG, LINE_JUSTIFY_FCN+OPEN_GATE);
	gfx_line_attr.justify = justification;
	}
GFX_GATE_OPEN
return gfx_line_attr.justify;
}


/*~ OPEN_FNT.C */

LOCAL INT make_fast_table = NO;

struct _gem_font {WORD id, size;
			   TEXT name[32];
			   WORD lo_ade, hi_ade;
			   WORD top_dist, ascent_dist, half_dist;
			   WORD descent_dist, bottom_dist;
			   WORD widest_char, widest_cell;
			   WORD left_offset, right_offset;
			   WORD thick, underline_size, v1, v2, v3;
			   LONG horiz_table, char_offset_table, font_data;
			   WORD form_width, form_height;
			   };


#if defined (USE_PAS_M2)
	void DiskFontDefaults(INT flags)
#elif defined (USE_UPPER_C)
	void DISK_FONT_DEFAULTS(INT flags)
#else
	void disk_font_defaults(INT flags)
#endif
{
make_fast_table = (flags & FAST_FONTS) ? YES : NO;
}


GFX_GATE_PRO;

#if defined (USE_PAS_M2)
	INT OpenFont(TEXT *font_name)
#elif defined (USE_UPPER_C)
	INT OPEN_FONT(TEXT *font_name)
#else
	INT open_font(TEXT *font_name)
#endif
{
FAST INT dos_handle, val;

GFX_GATE_CLOSE
if ((dos_handle = gfx_open(font_name, OPEN_READ_FILE)) == 0)
	return _gfx_err_number(BAD_FILE_OPEN, OPEN_FONT_FCN);
val = _gfx_open_font(dos_handle, OPEN_FONT_FCN);
GFX_GATE_OPEN
return val;
}

Int_FCN _gfx_open_font(FAST INT dos_handle, INT fcn_n)
{
FONT *font;
UINT data_table_size, offset_table_size, fast_table_size, font_handle, n;
TINY *data_table;
DMEM_HANDLE font_mc;
LONG file_start;
struct _gem_font gem;

if ((font_handle = _gfx_alloc_font_handle()) == 0)  {
	gfx_close(dos_handle);
	return _gfx_err_number(BAD_FONT_HANDLE, fcn_n);
	}
file_start = gfx_lseek(dos_handle, 0L, 1);
gfx_read(&gem, sizeof(struct _gem_font), dos_handle);
offset_table_size = (gem.hi_ade - gem.lo_ade + 2) << 1;
data_table_size = gem.form_width * gem.form_height;
fast_table_size = make_fast_table ? (gem.hi_ade - gem.lo_ade + 1) : 0;
n = sizeof(FONT) + offset_table_size + data_table_size + fast_table_size;
if ((font = (FONT *)_gfx_malloc_mc(n, &font_mc)) == (FONT *) 0) {
	gfx_close(dos_handle);
	return _gfx_err_number(NO_HEAP_SPACE, fcn_n);
	}
zfill((TINY *) font, n);
font->width = (INT) gem.form_width;
font->height = gem.form_height;
font->lo_char = gem.lo_ade;
font->hi_char = gem.hi_ade;
font->widest_cell = gem.widest_cell;
font->ascent_distance = gem.ascent_dist;
font->underline_loc = gem.ascent_dist + gem.descent_dist;
font->fixed_width_char = NO;
font->attr.u_thickness = gem.underline_size;
font->offset_table = (UWORD *)(font + 1);
data_table = (TINY *)font->offset_table + offset_table_size;
font->data_table = (UTINY_FAR *) data_table;
_gfx_get_FONT_ATTR_struct(0, &(font->attr));
gfx_lseek(dos_handle, file_start+gem.char_offset_table, 0);
gfx_read(font->offset_table, offset_table_size, dos_handle);
gfx_lseek(dos_handle, file_start+gem.font_data, 0);
gfx_read(data_table, data_table_size, dos_handle);
gfx_close(dos_handle);
if (fast_table_size > 0) {
	font->fast_table =  (UTINY_FAR *) (data_table + data_table_size);
     _gfx_build_fast_table(font);
	}
_gfx_set_font_handle(font_handle, font_mc);
_gfx_unlock_mc(font_mc);
return font_handle;
}


/*~ ALLOCFH.C */

IMPORT DMEM_HANDLE _gfx_loaded_fonts[];

Int_FCN _gfx_alloc_font_handle(void)
{
FAST INT i;

for (i = 4; i < MAX_FONT_HANDLES; i++) {
	if (!_gfx_loaded_fonts[i]) then return i;
	}
return NULL;
}

Void_FCN _gfx_set_font_handle(INT font_handle, DMEM_HANDLE font_mc)
{
if (inrange(1, font_handle, MAX_FONT_HANDLES))
	_gfx_loaded_fonts[font_handle] = font_mc;
}

/*~ PRINT.C */

GFX_VVEC_PRO;
GFX_GATE_PRO;

#if defined (USE_PAS_M2)
	void AFdecl _gfx_print_font(INT arg, ...)
#elif defined (USE_UPPER_C)
	void PRINT_FONT(INT arg, ...)
#else
	void AFdecl print_font(INT arg, ...)
#endif
{
FAST INT *args;
TEXT *tp;
CRSR *save_crsr_pointer;
IMPORT FCRSR NEAR font_crsr;
IMPORT CRSR *gfx_crsr;

GFX_GATE_CLOSE
args = &arg;
GFX_VVEC(VPRINT_FONT, args);
save_crsr_pointer = gfx_crsr;
gfx_crsr = (CRSR *) (&font_crsr);
args += (*_gfx.get_pt)(args);
gfx_crsr = save_crsr_pointer;
tp = *(TEXT **)args;
args += POINTER_ON_STACK;
gfx_print_font(tp, *args);
GFX_GATE_OPEN
}


/*~ LO_PRINT.C */

FCRSR NEAR font_crsr ISTAT_ARR_0;
IMPORT FONT NEAR _gfx_font;
IMPORT INT NEAR gfx_fonts_are_loaded;
IMPORT LINE_ATTR NEAR gfx_line_attr;
IMPORT void (_pascal *rs_flog)(void);

void AFdecl (**gfx_rotate_fcns)(UTINY_FAR *, int, int, int, char *, int, int) ISTAT_0;
void AFdecl (*gfx_expand_fcn)(UTINY_FAR *, int, int, int, char *, int, int) ISTAT_0;

#define is_horizontal_run()		(text_dir < TEXT_B_TO_T)
IMPORT UTINY_FAR *extended_8x8_font_ptr;
IMPORT INT _gfx_curr_font_handle;

LOCAL INT med_res_color[] = {0, 0x55, 0xAA, 0xFF};
INT _gfx_wrt_bkgnd_color = -1;
INT _gfx_fast_char = 0;

LOCAL TINY text_dir_CCW[] = {3, 2, 0, 1};
LOCAL TINY text_dir_CW[]  = {2, 3, 1, 0};
INT _gfx_curr_font_flags ISTAT_0;

LOCAL_Int_PRO print_GEM_font(TEXT *_tp, INT max_char);

Int_FCN gfx_print_font(TEXT *_tp, INT max_char)
{
FAST INT val;

if (!*_tp) then return SUCCESS;
val = _gfx_curr_font_flags & BGI_PRINT;
if (!gfx_fonts_are_loaded AND !val)
	_gfx_init_rom_fonts();

if (_gfx_curr_font_flags AND !val) {
	_gfx_curr_font_flags = 0;
	_gfx_curr_font(_gfx_curr_font_handle);
	}
val = (_gfx_font.flags & STROKE_FONT) ? 
   _gfx_font.write_text((UTINY *)_tp, max_char) : print_GEM_font(_tp, max_char);

if (val AND gfx_line_attr.display_char) {
	if (gfx_line_attr.justify == JUSTIFY_START) {
		font_crsr.x += font_crsr.delta_x;
		font_crsr.y += font_crsr.delta_y;
		if (_gfx.xlat_scale == FLOAT_SCALE) {
			_gfx.pt_x += font_crsr.delta_x;
			_gfx.pt_y += font_crsr.delta_y;
			if (rs_flog) then (*rs_flog)();
			}
		else {
			if (font_crsr.delta_x)
				font_crsr.ilog_x += _gfx_xlat_int_coor(font_crsr.delta_x, _gfx.scale.x_denom, _gfx.scale.x_num);
			if (font_crsr.delta_y)
				font_crsr.ilog_y += _gfx_xlat_int_coor(font_crsr.delta_y, _gfx.scale.y_denom, _gfx.scale.y_num);
			}
		}
	}
return val;
}

LOCAL_Int_FCN print_GEM_font(TEXT *_tp, INT max_char)
{
FAST INT char_bit_offset, n_char_pels;
UINT screen_offset;
UTINY_FAR *char_bitmap;
UTINY *tp;
TINY *rotate_buf, *expand_buf;
DMEM_HANDLE rotate_buf_mc;
DMEM_HANDLE expand_buf_mc;
INT i, c, clip_n_top_rows, clip_n_bottom_rows, delta_top, delta_bottom;
INT pt_x, row_y, top_pad_rows, src_offset, n_dest_rows, n_source_col;
INT diff, tdiff, lpad, rpad, form_width, show_n_rows, n_char_rows, rotate_char;
INT fgnd_color, bkgnd_color, u_color, u_line, reset_x, reset_y, text_dir;
INT expand_rows, expand_width, expand_char, x, y, temp_buf_size;
UWORD *font_offset;

tp = (UTINY *)_tp;
x = font_crsr.x;
y = font_crsr.y;
reset_x = reset_y = 0;
text_dir = gfx_line_attr.text_dir;
rotate_char = _gfx_font.attr.rotate_char;
if (_gfx.sys_flags & ROTATE_SCREEN) {
	if (_gfx.sys_flags & ROTATE_SCREEN_90) {
		text_dir = text_dir_CCW[text_dir];
		rotate_char = (rotate_char + 1) & 3;
          }
	if (_gfx.sys_flags & ROTATE_SCREEN_270) {
		text_dir = text_dir_CW[text_dir];
		rotate_char = (rotate_char + 3) & 3;
		}
	}

	/*  If we need to underline or set a background color for the text,
	 *  or center or end justify it, we'll need to know how long the text
	 *  is.  Furthermore, if we need to justify the text, we'll also need
	 *  to set a new starting coordinate.
	 */

if (((gfx_line_attr.justify != JUSTIFY_START) AND gfx_line_attr.display_char) OR
 (gfx_line_attr.display_char AND ((_gfx_font.attr.bkgnd_color != TRANSPARENT) OR gfx_line_attr.display_underline))) {
	gfx_line_attr.display_char = NO;
	gfx_print_font(_tp, max_char);
	gfx_line_attr.display_char = YES;
	if (font_crsr.delta_x + font_crsr.delta_y == 0) then return SUCCESS;
	if (gfx_line_attr.justify != JUSTIFY_START) {
		reset_x = font_crsr.delta_x;
		reset_y = font_crsr.delta_y;
		if (gfx_line_attr.justify == JUSTIFY_CENTER) {
			reset_x /= 2;
			reset_y /= 2;
			}
		if (reset_x) {
			x -= reset_x;
			font_crsr.x = x + reset_x;
			font_crsr.ilog_x += _gfx_xlat_int_coor(reset_x, _gfx.scale.x_denom, _gfx.scale.x_num);
			}
		if (font_crsr.delta_y) {
			y -= reset_y;
			font_crsr.y = y + reset_y;
			font_crsr.ilog_y += _gfx_xlat_int_coor(reset_y, _gfx.scale.y_denom, _gfx.scale.y_num);
			}
		}
	}

	/* Get the alignment adjustment value */

switch (_gfx_font.attr.align) {
	case TOP_LINE:
		delta_top = 0;
		break;

	case MID_LINE:
		delta_top = _gfx_font.height / 2;
		break;

	case BASE_LINE:
		delta_top	= _gfx_font.ascent_distance;
		break;

	case BOTTOM_LINE:
		delta_top = _gfx_font.height - 1;
		break;

     case BGI_TOP_LINE:
          delta_top = _gfx_font.height - _gfx_font.ascent_distance;
          break;

     case BGI_MID_LINE:
          delta_top = (_gfx_font.height - _gfx_font.ascent_distance) / 2;
	}
delta_bottom = _gfx_font.height - (delta_top + 1);
expand_rows =	_gfx_font.attr.expand_rows;
expand_width = _gfx_font.attr.expand_width;
expand_char = (_gfx_font.attr.expand_rows + _gfx_font.attr.expand_width) - 2;

	/* Get new offsets, depending on the character's rotation */

switch (rotate_char) {
	case _0_DEGREES:
		if (!reset_y) then y -= delta_top * expand_rows;
		break;

	case _90_DEGREES:
		if (!reset_x) then x -= delta_top * expand_rows;
		goto _270;

	case _180_DEGREES:
		if (!reset_y AND (text_dir != TEXT_B_TO_T))
			y -= delta_bottom * expand_rows;
		break;

	case _270_DEGREES:
		if (!reset_x) then x -= delta_bottom * expand_rows;

_270:	expand_rows =	_gfx_font.attr.expand_width;
		expand_width = _gfx_font.attr.expand_rows;
		break;
	}

	/*  The following routines will draw the background color or underline
	 *  and only need to be called if characters are going to be written.
	 */

if (gfx_line_attr.display_char) {
/*
     _gfx_fast_char =  ((_gfx_font.fixed_width_char == 8) AND 
        (_gfx.n_colors == 16) AND is_horizontal_run() AND
        ((rotate_char + expand_char) == 0)) ? 1 : 0;
*/     
     _gfx_wrt_bkgnd_color = -1;
	if (_gfx_font.attr.bkgnd_color != TRANSPARENT) {
		bkgnd_color = _gfx_get_color(_gfx_font.attr.bkgnd_color | FILL_SOLID);
		if (_gfx_fast_char AND ((x & 7) == 0))
			_gfx_wrt_bkgnd_color = bkgnd_color;
		else {
		     _gfx_fast_char = 0;
			if (is_horizontal_run())
				_gfx_solid_box(x, y, x+(font_crsr.delta_x-1), y+(_gfx_font.height-1)*expand_rows, bkgnd_color);
			else
				_gfx_solid_box(x, y, x+(_gfx_font.height-1)*expand_width, y+(font_crsr.delta_y-1), bkgnd_color);
			}
		}

	if (gfx_line_attr.display_underline) {
		u_line = (_gfx_font.underline_loc + _gfx_font.attr.u_pos) * expand_rows;
		u_color = _gfx_get_color(_gfx_font.attr.u_color | FILL_SOLID);
		switch (rotate_char) {
			case _0_DEGREES:
			case _180_DEGREES:
				if (rotate_char == _180_DEGREES)
					u_line = -u_line;
				_gfx_solid_box(x, y+u_line, x+font_crsr.delta_x, y+u_line+_gfx_font.attr.u_thickness-1, u_color);
				break;

			case _90_DEGREES:
			case _270_DEGREES:
				if (rotate_char == _270_DEGREES)
					u_line = -u_line;
				_gfx_solid_box(x+u_line, y, x+u_line+_gfx_font.attr.u_thickness-1, y+font_crsr.delta_y, u_color);
				break;
			}
		}

	if (rotate_char OR expand_char) {
		temp_buf_size = ((_gfx_font.widest_cell + 15) / 8) * (_gfx_font.height+1);
		if (rotate_char) {
			if (!gfx_rotate_fcns) then return NULL;
			if ((rotate_char == _90_DEGREES) OR
			   (rotate_char == _270_DEGREES))
				temp_buf_size = ((_gfx_font.height + 7) / 8) * (_gfx_font.widest_cell + 1);
			temp_buf_size += 100;
		     rotate_buf = _gfx_malloc_mc(temp_buf_size, &rotate_buf_mc);
		     if (!rotate_buf_mc) then return FAILURE;
			}
		if (expand_char) {
			if (!gfx_expand_fcn) then return NULL;
			expand_buf = _gfx_malloc_mc(temp_buf_size*_gfx_font.attr.expand_rows*_gfx_font.attr.expand_width, &expand_buf_mc);
			if (!expand_buf) {
				if (rotate_char) then _gfx_free_mc(rotate_buf_mc);
				return NULL;
				}
			}
		}
	fgnd_color = _gfx_get_color(_gfx_font.attr.fgnd_color);
	screen_offset = 0xFFF0;
	turn_on_ega();
	}


	/*  Now to the heart of the matter.  This routine loops until either a
	 *  delimiting NULL is found or the maximum # of characters are written.
	 */

font_crsr.delta_x = font_crsr.delta_y = clip_n_top_rows = clip_n_bottom_rows = 0;
for (i = 0; (i < max_char) AND ((c = tp[i]) > 0); i++) {
	char_bitmap = _gfx_font.data_table;
	if ((c > 127) AND (_gfx_curr_font_handle == 1)) {
		char_bitmap = extended_8x8_font_ptr;
		c -= 128;
		}
	form_width = _gfx_font.width;
	n_char_rows = (_gfx_font.fast_table AND (_gfx_wrt_bkgnd_color < 0)) ? 
	   _gfx_font.fast_table[c-_gfx_font.lo_char] : _gfx_font.height;
	if (!inrange(_gfx_font.lo_char, (UINT) c, _gfx_font.hi_char)) then continue;
	if (!_gfx_font.fixed_width_char) {
		font_offset = _gfx_font.offset_table+(c-_gfx_font.lo_char);
		if (font_offset == 0) then continue;
		char_bit_offset = *font_offset;
		n_char_pels = *(font_offset+1) - char_bit_offset;
		}
	else {
		char_bit_offset = (c - _gfx_font.lo_char) * _gfx_font.height * _gfx_font.fixed_width_char;
		n_char_pels = _gfx_font.fixed_width_char;
		}

		/* If a character needs rotation -- do it. */

	if (rotate_char) {
		src_offset = char_bit_offset / 8;
		lpad = char_bit_offset & 7;
		rpad = top_pad_rows = (8 - ((lpad + n_char_pels) & 7)) & 7;
		char_bit_offset = 0;
		switch (rotate_char) {
			case _270_DEGREES:
				top_pad_rows = lpad;
				char_bit_offset = (8 - (_gfx_font.height & 7)) & 7;

			case _90_DEGREES:
				n_char_rows = n_char_pels;
				n_char_pels += lpad + rpad;
				n_dest_rows = n_char_pels & 0xF8;
				n_source_col = n_char_pels / 8;
				n_char_pels = _gfx_font.height;
				form_width = (_gfx_font.height + 7) / 8;
				break;

			case _180_DEGREES:
				top_pad_rows = 0;
				char_bit_offset = rpad;
				n_dest_rows = n_char_rows;
				form_width = n_source_col = (lpad + n_char_pels + 7) / 8;
				break;
			}

		if (gfx_line_attr.display_char) {
			(**(gfx_rotate_fcns+rotate_char))(_gfx_font.data_table + src_offset, _gfx_font.width, _gfx_font.height, n_source_col, rotate_buf, form_width, n_dest_rows);
			char_bitmap = (UTINY_FAR *)rotate_buf + (top_pad_rows * form_width);
			}
		}

		/* If a character needs to be expanded -- do it. */

	if (expand_char) {
		if (gfx_line_attr.display_char) {
			char_bitmap +=  char_bit_offset / 8;
			char_bit_offset &= 7;
			n_source_col = (char_bit_offset + n_char_pels + 7) / 8;
			(*gfx_expand_fcn)(char_bitmap, form_width, n_char_rows, n_source_col, expand_buf, expand_width, expand_rows);
			char_bitmap = (UTINY_FAR *)expand_buf;
			char_bit_offset *= expand_width;
			form_width = n_source_col * expand_width;
			while (char_bit_offset > 7){
				char_bit_offset -= 8;
				char_bitmap++;
				}
			}
		n_char_pels *= expand_width;
		n_char_rows *= expand_rows;
		}

	if (text_dir == TEXT_B_TO_T)
		font_crsr.delta_y -= n_char_rows + _gfx_font.attr.h_space;

	else if(text_dir ==	TEXT_R_TO_L)
		font_crsr.delta_x -= n_char_pels + _gfx_font.attr.h_space;


	if (gfx_line_attr.display_char) {

		/* calculate offset of start of row y */

		if (!is_horizontal_run() OR (screen_offset == 0xFFF0)) {
			row_y = y + font_crsr.delta_y;
			if ((clip_n_top_rows = _gfx.min_y - row_y) > 0)
				row_y += clip_n_top_rows;
			screen_offset = _gfx_set_vidram(0, row_y);
			if (_gfx.bios_mode == MED_RES_COLOR)
				fgnd_color = med_res_color[fgnd_color&0x3];
			}

			/* clip top and bottom rows */

		show_n_rows = n_char_rows;
		if (clip_n_top_rows > 0) {
			char_bitmap += form_width * clip_n_top_rows;
			show_n_rows -= clip_n_top_rows;
			}
		if ((clip_n_bottom_rows = (y + font_crsr.delta_y + show_n_rows - 1) - _gfx.max_y) > 0)
			show_n_rows -= clip_n_bottom_rows;

			/* clip left and right sides */

		pt_x = x + font_crsr.delta_x;
		diff = 0;
		if ((tdiff = (_gfx.min_x - pt_x)) > 0) {
			pt_x = _gfx.min_x;
			char_bit_offset += tdiff;
			diff = tdiff;
			}
		if ((tdiff = (pt_x + n_char_pels - diff) - (_gfx.max_x+1)) > 0)
			diff += tdiff;

			/* write out the character */

		if ((n_char_pels > diff) AND (show_n_rows > 0))
			_gfx_write_char(screen_offset, pt_x, fgnd_color, char_bit_offset, n_char_pels-diff, show_n_rows, form_width, char_bitmap);
		}

		/* move position in x or y direction */

	switch (text_dir) {

		 case TEXT_L_TO_R:
			font_crsr.delta_x += n_char_pels + _gfx_font.attr.h_space;
			break;

		case TEXT_T_TO_B:
			font_crsr.delta_y += n_char_rows + _gfx_font.attr.h_space;
			break;
		}
	}

	/* It's cleanup time. */

if (gfx_line_attr.display_char) {
	turn_off_ega();
	if (rotate_char) then _gfx_free_mc(rotate_buf_mc);
	if (expand_char) then _gfx_free_mc(expand_buf_mc);
	}
return i;
}

/*~ FAST_TBL.C */

Void_FCN _gfx_build_fast_table(FONT *font)
{
FAST INT max_lines, n;
INT i, k, n_bits, mask, c;
UINT offset;
unsigned short int *offset_table;
UTINY_FAR *fast_table;
UTINY_FAR *last_data_line;
UTINY_FAR *scan_line;
UTINY_FAR *bitmap;

if (font->fast_table) {
	offset_table = font->offset_table;
	fast_table = font->fast_table;
	last_data_line = font->data_table + ((font->height - 1) * font->width);
	for (i = font->lo_char; i <= font->hi_char; i++) {
		offset = *offset_table++;
		n_bits = *offset_table - offset;
	     scan_line = last_data_line + (offset / 8);
		for (max_lines = font->height; max_lines > 0; max_lines--) {
			bitmap = scan_line;
			scan_line -= font->width;
			c = *bitmap++;
			mask = 0x80 >> (offset & 0x7);
			for (k = 0; (k < n_bits) AND !(c & mask); k++) {
				if ((mask >>= 1) == 0) {
					mask = 0x80;       
					c = *bitmap++;
					}
				}
			if (k < n_bits) then break;
			}
		*fast_table++ = max_lines;
		}
	}
}


/*~ FASTROM.C */

IMPORT INT NEAR gfx_fonts_are_loaded;

INT font_height[] = {0, 8, 14, 16};
IMPORT INT _gfx_curr_font_handle;
IMPORT FONT NEAR _gfx_font;

#if defined (USE_PAS_M2)
	INT FastROMFont(INT fh, INT lo_char, INT hi_char)
#elif defined (USE_UPPER_C)
	INT FAST_ROM_font(INT fh, INT lo_char, INT hi_char)
#else
	INT fast_ROM_font(INT fh, INT lo_char, INT hi_char)
#endif
{
INT n_char, new_fh, data_table_size, n_rows, i, j;
FONT *font;
UTINY_FAR *tp;
DMEM_HANDLE font_mc;

if (!inrange(ROM_8x8, fh, ROM_8x16))
	return _gfx_err_number(BAD_FONT_HANDLE, FAST_ROM_FONT_FCN);
if (!gfx_fonts_are_loaded) then _gfx_init_rom_fonts();
n_rows = font_height[fh];
if ((n_char = hi_char - lo_char + 1) > 1) {
	if ((new_fh = _gfx_alloc_font_handle()) == 0) 
		return _gfx_err_number(BAD_FONT_HANDLE, FAST_ROM_FONT_FCN);
     data_table_size = n_char * n_rows;
     font = (FONT *)_gfx_malloc_mc(data_table_size + n_char, &font_mc);
	if (!font)
		return _gfx_err_number(NO_HEAP_SPACE, FAST_ROM_FONT_FCN);
	_gfx_get_FONT_struct(fh, font);
	_gfx_far_move(font->data_table, (UTINY_FAR *) (font+1), data_table_size);
	font->lo_char = lo_char;
	font->hi_char = hi_char;
	font->data_table = (UTINY_FAR *) (font+1);
	font->fast_table = font->data_table + data_table_size;
	_gfx_build_fast_table(font);
	_gfx_set_font_handle(new_fh, font_mc);
	_gfx_unlock_mc(font_mc);
	}
else {
	font = _gfx_get_font_ptr(fh, FAST_ROM_FONT_FCN);
	font->fast_table = _gfx_farmalloc_mc(256, (FAR_DMEM_HANDLE *)&font_mc);
	if (!font->fast_table)
     	return _gfx_err_number(NO_HEAP_SPACE, FAST_ROM_FONT_FCN);
	if (_gfx_curr_font_handle == fh)
		_gfx_font.fast_table = font->fast_table;
	new_fh = fh;
	n_char = 256;
	}
tp = font->data_table;
for (i = 0; i < n_char; i++) {
     for (j = n_rows; (j > 0) AND !tp[j-1]; j--) ;
	font->fast_table[i] = j;
	tp += n_rows;
	}
return new_fh;
}




/*~ SOLIDBOX.C */

Void_FCN _gfx_solid_box(INT x1, INT y1, INT x2, INT y2, INT color)
{
FAST INT temp;

if (x1 > x2) {
	temp = x2;
	x2 = x1;
	x1 = temp;
	}
if (y1 > y2) {
	temp = y2;
	y2 = y1;
	y1 = temp;
	}
if (x1 < _gfx.min_x) then x1 = _gfx.min_x;
if (x2 > _gfx.max_x) then x2 = _gfx.max_x;
if (y1 < _gfx.min_y) then y1 = _gfx.min_y;
if (y2 > _gfx.max_y) then y2 = _gfx.max_y;
if ((x1 <= x2) AND (y1 <= y2)) {
	turn_on_ega();
	_gfx_fast_hline(x1, y1, x2-x1+1, y2-y1+1, color);
	turn_off_ega();
	}
}

/*~ OPENMEMF.C */

#if (DOS16_EXTENDER == PHAR_LAP) 

typedef struct
{
	LONG base;		/* Segment linear base address */
	LONG size;		/* Size in bytes of segment */
	UINT attrib;		/* Attribute byte */
} DESC;

UINT pascal _far DosGetSegDesc(UINT, DESC *);
#endif


GFX_GATE_PRO;

#if defined (USE_PAS_M2)
	INT OpenMemFont(FONT *font)
#else
	INT open_mem_font(FONT *font)
#endif
{
INT font_handle;


#if (DOS16_EXTENDER == PHAR_LAP) 
UINT selector, data_size;
DESC desc;
REG_X reg;

GFX_GATE_CLOSE
selector = ptr_segment(font->data_table);
DosGetSegDesc(selector, &desc);
data_size = font->width * (font->height + 9);
if (desc.size < data_size) {
	reg.ax = 0x8;
	reg.bx = selector;
	reg.cx = 0;
	reg.dx = data_size;
	int86(0x31, &reg, &reg);
	}
#endif

font_handle = _gfx_alloc_font_handle();
font->flags |= COMPILED_FONT;
_gfx_get_FONT_ATTR_struct(0, &(font->attr));
_gfx_set_font_handle(font_handle, (DMEM_HANDLE) font);
GFX_GATE_OPEN
return font_handle;
}


/*~ INIROMFN.C */

#define DOUBLE_DOT_FONT			(UTINY_FAR *) 0xF000FA6E

LOCAL FONT font_8_by_8 = { (UWORD *) 0, DOUBLE_DOT_FONT, 1, 8, 0, 127, 8, 7, 13,
					   8, BASE_LINE, 0, _0_DEGREES, 7, -1, 1, 1, 1, 0, 7};

LOCAL FONT font_8_by_14 = {(UWORD *) 0, (UTINY_FAR *) 0, 1, 14, 0, 255, 8, 11, 13,
					   8, BASE_LINE, 0, _0_DEGREES, 7, -1, 1, 1, 1, 0, 7};

LOCAL FONT font_8_by_16 = {(UWORD *) 0, (UTINY_FAR *) 0, 1, 16, 0, 255, 8, 13, 15,
					   8, BASE_LINE, 0, _0_DEGREES, 7, -1, 1, 1, 1, 0, 7};

DMEM_HANDLE _gfx_loaded_fonts[MAX_FONT_HANDLES] =  { 
					NULL_DMEM_HANDLE,
					(DMEM_HANDLE) &font_8_by_8,
					(DMEM_HANDLE) &font_8_by_14,
					(DMEM_HANDLE) &font_8_by_16 };

UTINY_FAR *extended_8x8_font_ptr ISTAT_0;
INT NEAR gfx_fonts_are_loaded = NO;

IMPORT INT _gfx_curr_font_handle;

#if (PROT_MODE_SYS != PMODE_32)

Void_FCN _gfx_init_rom_fonts(void)
{
INT c;

#if (PROT_MODE_SYS == PMODE_16)
UINT seg;

seg = _gfx16_alloc_selector(0xFFA6, 0x410L);
font_8_by_8.data_table = (UTINY_FAR *) (((long)seg<<16) + 0xE);
#endif

if (gfx_fonts_are_loaded) then return;
gfx_fonts_are_loaded = YES;
extended_8x8_font_ptr = _gfx_get_rom_font_ptr(4);
if (_gfx.card_monitor & (EGA_CARD | VGA_CARD)) {
	font_8_by_14.data_table = _gfx_get_rom_font_ptr(2);
	if (_gfx.card_monitor & VGA_CARD)
		font_8_by_16.data_table = _gfx_get_rom_font_ptr(6);
	}
if ((c = _gfx_curr_font(DFLT)) <= 2) then _gfx_curr_font((c==2) ? 2 : 1);
}

#else

Void_FCN _gfx_init_rom_fonts(void)
{
gfx_fonts_are_loaded = YES;
_gfx32_init_ramrom_fonts();
_gfx_curr_font(3);
}

#endif



/*~ CURRFONT.C */


INT _gfx_curr_font_handle = 1;
IMPORT INT NEAR gfx_fonts_are_loaded;
FONT NEAR _gfx_font ISTAT_ARR_0;
LOCAL_Int_PRO _gfx_get_set_FONT_struct(INT fh, FONT *fp, INT get_FONT_struct);

GFX_IVEC_PRO;
GFX_GATE_PRO;

#if defined (USE_PAS_M2)
	INT CurrFont(INT fh)
#elif defined (USE_UPPER_C)
	INT CURR_FONT(INT fh)
#else
	INT curr_font(INT fh)
#endif
{
INT val;

GFX_GATE_CLOSE
val = _gfx_curr_font(fh);
GFX_GATE_OPEN
return val;
}

Int_FCN _gfx_curr_font(INT fh)
{

if (!gfx_fonts_are_loaded) then _gfx_init_rom_fonts();
if (fh == DFLT) then return _gfx_curr_font_handle;
GFX_IVEC(VCURR_FONT, &fh);
if (_gfx_get_FONT_struct(fh, &_gfx_font)) {
	_gfx_curr_font_handle = fh;
	return fh;
	}
return NULL;
}



Int_FCN _gfx_get_FONT_struct(INT fh, FONT *fp)
{
return _gfx_get_set_FONT_struct(fh, fp, 1);
}

Int_FCN _gfx_set_FONT_struct(INT fh, FONT *fp)
{
return _gfx_get_set_FONT_struct(fh, fp, 0);
}


LOCAL_Int_FCN _gfx_get_set_FONT_struct(INT fh, FONT *fp, INT get_FONT_struct)
{
DMEM_HANDLE font_mc;
IMPORT DMEM_HANDLE _gfx_loaded_fonts[];

if (fh == DFLT) then fh = _gfx_curr_font_handle;
else if (!fh AND get_FONT_struct) {
	*fp  = _gfx_font;
	return 1;
	}
if (!fp) then fp = &_gfx_font;
font_mc = _gfx_loaded_fonts[fh];
if (inrange (1, fh, MAX_FONT_HANDLES - 1) AND font_mc) {
	if (get_FONT_struct) then *fp = *(FONT *) _gfx_deref_mc(font_mc);
	else *(FONT *) _gfx_deref_mc(font_mc) = *fp;
	_gfx_unlock_mc(font_mc);
	return fh;
	}
return 0;
}



/*~ RFLFNATT.C */

IMPORT INT _gfx_curr_font_handle, _gfx_curr_font_flags;

Void_FCN _gfx_reflect_font_attr(INT fh, FONT *fp)
{
_gfx_set_FONT_struct(fh, fp);
if ((fh == _gfx_curr_font_handle) AND !(_gfx_curr_font_flags & DONT_REFLECT_FONT))
	_gfx_curr_font(fh);
}


/*~ GETFCRSR.C */


#if defined (USE_PAS_M2)
	void GetFontCursor(COOR_PT *cpt)
#elif defined (USE_UPPER_C)
	void GET_FONT_CURSOR(COOR_PT *cpt)
#else
	void get_font_cursor(COOR_PT *cpt)
#endif
{
IMPORT FCRSR NEAR font_crsr;

cpt->abs_x = font_crsr.x;
cpt->abs_y = font_crsr.y;
cpt->ilog_x = font_crsr.ilog_x;
cpt->ilog_y = font_crsr.ilog_y;
if (_gfx.xlat_scale == FLOAT_SCALE)
	_gfx_move(&(font_crsr.flog_x), &(cpt->flog_x), sizeof(double) * 2);
}


/*^ GFXG_C16.C */

#if (PROT_MODE_SYS == PMODE_16)

/*~ GFXG_C16.C */

#if defined(M_I86) && !defined(__WATCOMC__) && !defined(__ZTC__)
#define NEAR  near
#else 
#define NEAR  
#endif
#include "gfxg_src.h"


#if (DOS16_EXTENDER == PHAR_LAP) 
UINT pascal _far DosFreeSeg(UINT sel);
UINT pascal _far DosMapRealSeg(UINT rm_para, LONG seg_size, UTINY_FAR * selp);
UTINY_FAR * pascal _far DosRealToProt(UTINY_FAR *real_ptr);
UINT pascal _far DosAllocRealSeg(LONG n_bytes, UINT *segment, UINT *selector);
UINT pascal _far DosFreeSeg(UINT selector);
#elif (DOS16_EXTENDER == RATIONAL)
UTINY_FAR *D16SegAbsolute(LONG linear_addr, UINT seg_size);
UINT D16SegCancel(LONG linear_addr);
UTINY_FAR *D16RealPtr(UTINY_FAR *real_mode_ptr);
short   D16API d16SetMemStrat(short);
LPVOID  D16API d16GetRealAddress (LPVOID);
LPVOID  D16API d16AllocMem(WORD);
BOOL    D16API d16FreeDesc(UINT);
#elif (DOS16_EXTENDER == ZORTECH)
UTINY_FAR *ZPMProtectedPtr(UTINY_FAR *real_mode_ptr, UINT seg_size);
#endif

LOCAL_Int_PRO find_segment_in_table(UINT segment);

#define MAX_SEG_SEL		20
LOCAL UINT seg_sel_table[MAX_SEG_SEL][2];

Uint_FCN _gfx16_alloc_selector(UINT segment, LONG segment_sz)
{
INT slot;
UINT selector;
REG_X reg;
UTINY_FAR *pm_ptr;

slot = find_segment_in_table(segment);
selector = seg_sel_table[slot][1];
if (selector == 0) {
#if (DOS16_EXTENDER == PHAR_LAP)
	DosMapRealSeg(segment, segment_sz, (UTINY_FAR *) &selector);
#elif (DOS16_EXTENDER == ERGO)
	reg.ax = 0xE803;
	reg.cx = 0;
	reg.dx = segment_sz;
	reg.bx = segment << 4;
	reg.si = (segment >> 12) & 0xF;
	call_dos(reg);
	selector = reg.ax;
#elif (DOS16_EXTENDER == RATIONAL)
	if (segment_sz >= 0xFFFFL)
		segment_sz = 0L;
	pm_ptr = D16SegAbsolute((LONG) segment << 4, (UINT) segment_sz);
	selector = ptr_segment(pm_ptr);
#elif (DOS16_EXTENDER == ZORTECH)
	if (segment_sz >= 0xFFFFL)
		segment_sz = 0L;
	pm_ptr = (LONG)segment << 16;
	pm_ptr = ZPMProtectedPtr(pm_ptr, (UINT) segment_sz);
	selector = ptr_segment(pm_ptr);
#endif
	seg_sel_table[slot][0] = segment;
	seg_sel_table[slot][1] = selector;
	}
return selector;
}


Int_FCN _gfx16_free_selector(UINT selector)
{
FAST INT i;
REG_X reg;
SREGS sregs;

for (i = 0; i < MAX_SEG_SEL; i++) {
	if (seg_sel_table[i][1] == selector) {
#if (DOS16_EXTENDER == PHAR_LAP)
		DosFreeSeg(selector);
#elif (DOS16_EXTENDER == ERGO)
	     sregs.ds = sregs.es = selector;
	     reg.ax = 0x4900;
	     int86x(0x21, &reg, &reg, &sregs);
#elif (DOS16_EXTENDER == RATIONAL)
		D16SegCancel((long)selector << 16);
#endif
	     seg_sel_table[i][0] = seg_sel_table[i][1] = 0;
	     return YES;
		}
	}
return NO;
}


LOCAL_Int_FCN find_segment_in_table(UINT segment)
{
FAST INT i, seg_slot;

seg_slot = -1;
for (i = 0; i < MAX_SEG_SEL; i++) {
	if (seg_sel_table[i][0] == segment)
		return i;
	else if ((seg_slot < 0) AND (seg_sel_table[i][0] == 0))
		seg_slot = i;
	}
return seg_slot;
}

#if (DOS16_EXTENDER == PHAR_LAP)

UTINY_FAR DosRealIntr(INT intr_nmbr, REGS16 far *pr, LONG dummy, INT darg);

Void_FCN _gfx16_ns_int86x(INT int_nmbr, void *usr_reg, INT _DS, INT _ES)
{
REGS16 pregs;
REG_X *reg;

reg = usr_reg;
zfill(&pregs, sizeof(REGS16));
pregs.ax = reg->ax;
pregs.bx = reg->bx;
pregs.cx = reg->cx;
pregs.dx = reg->dx;
pregs.ds = _DS;
pregs.es = _ES;
DosRealIntr(int_nmbr, &pregs, 0L, 0);
reg->ax = pregs.ax;
reg->bx = pregs.bx;
reg->cx = pregs.cx;
reg->dx = pregs.dx;
}

Int_FCN _gfx16_alloc_real_mem(UINT n_bytes, UINT *segment, UINT *selector)
{
return DosAllocRealSeg((LONG)n_bytes, segment, selector);
}

Void_FCN _gfx16_free_real_mem(UINT selector)
{
DosFreeSeg(selector);
}

#else
#if (DOS16_EXTENDER == RATIONAL)
Int_FCN _gfx16_alloc_real_mem(UINT n_bytes, UINT *segment, UINT *selector)
{
short OldStrat;
void far *ptr;

OldStrat = d16SetMemStrat(MForceLow);
selector = d16AllocMem(n_bytes);
segment  = d16GetRealAddress(selector);
d16SetMemStrat(OldStrat);
}

Void_FCN _gfx16_free_real_mem(UINT selector)
{
d16FreeDesc(selector);
}

#endif

Void_FCN _gfx16_ns_int86x(INT int_nmbr, void *reg, INT _DS, INT _ES)
{
SREGS sregs;

segread(&sregs);
if (_DS) then sregs.ds = _DS;
if (_ES) then sregs.ds = _ES;
_gfx_int86x(int_nmbr, (REG *) reg, (REG *) reg, &sregs);
}
#endif

UtinyFarPtr_FCN _gfx16_xlat_real_to_prot(UTINY_FAR *real_mode_ptr)
{
#if (DOS16_EXTENDER == PHAR_LAP)
return DosRealToProt(real_mode_ptr);
#elif (DOS16_EXTENDER == RATIONAL)
return D16RealPtr(real_mode_ptr);
#elif (DOS16_EXTENDER == ZORTECH)
return ZPMProtectedPtr(real_mode_ptr, 0x4000);
#endif
}

/*~ VESA16.C */

IMPORT SVGA svga_card;

typedef struct vsi { TINY signature[4];
	                TINY version[2];
	                UTINY_FAR *oem_name;
	                TINY capabilities[4];
                     UWORD_FAR *modes;
                     TINY extra[256-18];
                   } VESA_SYS_INFO;

Int_FCN _gfx16_check_for_VESA(INT *VESA_modes, VESA_RES *VESA_res)
{
FAST INT i, vmode;
INT found_VESA_vram, modes[50];
REG reg;
UWORD_FAR *modes_ptr;
SREGS sregs;
VESA_SYS_INFO vsi;
UINT pm_sel, real_seg;
VESA_SYS_INFO *vsi_ptr;

reg._x.ax = 0x4F00;
reg._x.di = 0;
_gfx16_alloc_real_mem(sizeof(VESA_SYS_INFO), &real_seg, &pm_sel);
_gfx16_ns_int86x(0x10, (REG_X *) &reg, 0, real_seg);
vsi_ptr = (VESA_SYS_INFO *) ((LONG)pm_sel<<16);
vsi = *vsi_ptr;
svga_card.VESA_is_supported = NO;
svga_card.set_mode_with_VESA = NO;
svga_card.switch_banks_with_VESA = NO;
if (reg._hl.al == 0x4F) {
	zfill(VESA_modes, N_EXTD_MODES);
     svga_card.VESA_is_supported = YES;
     svga_card.set_mode_with_VESA = YES;
	found_VESA_vram = 0;
	modes_ptr = (UWORD_FAR *)_gfx16_xlat_real_to_prot((UTINY_FAR *) vsi.modes);
	for (i = 0; (i < 50) AND ((modes[i] = modes_ptr[i]) != -1); i++);
	for (i=0; (vmode = modes[i]) != -1; i++) {
		if ((vmode & 0x100) AND (vmode <= 0x107)) {
			reg._x.ax = 0x4F01;
			reg._x.cx = vmode;
			reg._x.dx = 0;
			_gfx16_ns_int86x(0x10, (REG_X *) &reg, 0, real_seg);
			if (reg._x.ax == 0x4F) {
				vmode &= 0x7;
				VESA_modes[vmode] = vmode | 0x100;
				if (VESA_res[vmode].vram_sz > found_VESA_vram)
					found_VESA_vram = VESA_res[vmode].vram_sz;
				}
			}
		}
	}
_gfx16_free_real_mem(pm_sel);
return found_VESA_vram;
}


typedef struct vmi { UWORD mode_attributes;
	                TINY  win_A_attributes, win_B_attributes;
	                UWORD win_granularity, win_size;
	                UWORD win_A_segment, win_B_segment;
	                LONG  far_win_fcn_ptr;
	                UWORD bytes_per_scan_line;
	              } VESA_MODE_INFO;  

LOCAL UTINY_FAR *rm_VESA;

Void_FCN _gfx16_init_VESA_switching(int VESA_mode_n)
{
char buf[256];
REG reg;
SREGS sregs;
UINT pm_sel, real_seg;
VESA_MODE_INFO far *vmi;
VESA_MODE_INFO *rm_vmi;

vmi = (VESA_MODE_INFO far *)buf;
reg._x.ax = 0x4F01;
reg._x.cx = VESA_mode_n;
reg._x.di = 0;
_gfx16_alloc_real_mem(sizeof(VESA_MODE_INFO), &real_seg, &pm_sel);
_gfx16_ns_int86x(0x10, (REG_X *) &reg, real_seg, real_seg);
rm_vmi = (VESA_MODE_INFO *)((LONG)pm_sel<<16);
_gfx_move(rm_vmi, vmi, sizeof(VESA_MODE_INFO));
_gfx16_free_real_mem(pm_sel);
rm_VESA = (UTINY_FAR *) vmi->far_win_fcn_ptr;
_gfx.bytes_per_row = vmi->bytes_per_scan_line;
_gfx_init_VESA(vmi->far_win_fcn_ptr, 0x100);
}


#if (DOS16_EXTENDER == PHAR_LAP) 

UTINY_FAR DosRealIntr(INT intr_nmbr, REGS16 far *pr, LONG dummy, INT darg);

Int_FCN _gfx16_is_good_ATI_mode(INT mode_n)
{
REGS16 regs16;

zfill(&regs16, sizeof(REGS16));
regs16.ax = 0x1200 + mode_n;
regs16.bx = 0x5506;
regs16.bp = 0xFFFF;
regs16.si = 0;
DosRealIntr(0x10, &regs16, 0L, 0);
return (regs16.bp == 0xFFFF) ? NO : YES;
}

#else

Int_FCN _gfx16_is_good_ATI_mode(INT mode_n)
{
return _gfx_is_good_ATI_mode(mode_n);
}

#endif


#endif

/*^ GFXG_C32.C */

#if (PROT_MODE_SYS == PMODE_32)

/*~ PM32.C */

#if defined (__ZTC__)
IMPORT unsigned short _x386_zero_base_selector;
#endif

IMPORT GFX_PM _gfx_pm;

Void_FCN _gfx32_pmode_screen_base(UINT segment)
{

if (_gfx_pm.extender == 0) {
     _gfx32_init_pmode();
     if (segment == 0xB000)
		_gfx32_set_video_selector(segment);
     }
_gfx.screen_base = _gfx_pm.selector.screen_mem_DS;
if ((_gfx_pm.extender == RATIONAL) OR (_gfx_pm.extender == ZORTECH))
	_gfx.screen_offset = segment<<4;
}


LOCAL_Void_FCN init_pmode_32(INT extender)
{
INT dseg;
REG_X reg;
unsigned short *ip;
UTINY plap_buf[512+256];

#if (VDOS386 == 1)
void _gfx32_init_vdos386(void);

_gfx32_init_vdos386();
#endif

_gfx_pm.selector.prot_mem_DS = dseg = _gfx_get_ds();
_gfx_pm.selector.prot_mem_CS = _gfx_get_cs();
#if defined (__ZTC__)
dseg = _x386_zero_base_selector;
#endif
_gfx_pm.extender = extender;
switch (extender) {
	case PHAR_LAP:
		reg.ax = 0x2526;
		reg.bx = (UINT)plap_buf;
		reg.cx = (UINT)(plap_buf+512);
		call_dosx(reg, plap_buf, plap_buf);
		ip = (unsigned short *)(plap_buf+0x100);
		_gfx_pm.selector.prot_mem_CS = *ip;
		_gfx_pm.selector.prot_mem_DS = dseg = *(ip+1);
		_gfx_pm.selector.real_mem_DS = *(ip+4);
		_gfx_pm.selector.screen_mem_DS = *(ip+5);
          break;
	
	case RATIONAL:
	case ZORTECH:
		_gfx_pm.selector.real_mem_DS = _gfx_pm.selector.screen_mem_DS = dseg;
          break;
	}
}

Void_FCN _gfx32_set_video_selector(INT video_seg)
{
unsigned short ldt[4];
REG_X reg;

if (_gfx_pm.extender == PHAR_LAP) {
	reg.ax = 0x4800;			// allocate a new selector
	reg.bx = 0;
	call_dos(reg);
	_gfx.screen_base = reg.ax;
	reg.ax = 0x2531;              // read screen selector's LDT 
	reg.bx = _gfx_pm.selector.screen_mem_DS;
	reg.dx = (UINT) ldt;
	reg.cx = 0;
	call_dosx(reg, ldt, ldt);
	ldt[0] = 0;		 		// modify it for video ram location
	ldt[3] = (ldt[3] & 0xFFF0) + 0x1;
	ldt[1] = video_seg << 4;
	ldt[2] = (ldt[2] & 0xFF00) + (video_seg >> 12);
	reg.ax = 0x2531;			// write out new selector's LDT
	reg.bx = _gfx_pm.selector.screen_mem_DS = _gfx.screen_base;
	reg.dx = (UINT) ldt;
	reg.cx = 1;
	call_dosx(reg, ldt, ldt);
     }
}

#define __PHAR__	0x50484152
#define __AIHB__	0x42484941

Void_FCN _gfx32_init_pmode(void)
{

#if (DOS32_EXTENDER != 0)
init_pmode_32(DOS32_EXTENDER);

#else

REG_X  reg;
INT i, n, hbname[3];

		/* First look for PHAR LAP */
for (i = 1; i <= 4; i++) {
	reg.ax = 0xED00;
	reg.bx = i;
	int86(0x2F, (REG *) &reg, (REG *) &reg);
	n = (reg.si << 16) | (reg.di & 0xFFFF);
	if ((reg.ax == 0xEDFF) AND (n == __PHAR__)) {
	     init_pmode_32(PHAR_LAP);
	     return;
	     }
	}

#if defined (__ZTC__)
		/* If not using Phar Lap, it must be Zortech */
init_pmode_32(ZORTECH);
return;
#endif

		/* Look for Rational System's 4G */

reg.dx = 0x78;
reg.ax = 0xFF00;
int86(0x21, (REG *) &reg, (REG *) &reg);
if (reg.ax == 0x4734FFFF) {
     init_pmode_32(RATIONAL);
     return;
     }

		/* Now ERGO */

reg.ax = 0xA1FE;
for (i = 0; i < 2; i++) {
	reg.di = (INT) hbname;
	int86(0x2F, (REG *) &reg, (REG *) &reg);
	if (hbname[0] == __AIHB__) {
		init_pmode_32(ERGO);
		return;
		}
	reg.ax = 0xFBA1;
	}
#endif
}

/*~ ALLOC32.C */

IMPORT GFX_PM _gfx_pm;

Int_FCN _gfx32_alloc_DOS_mem(INT n_bytes, MEM32 *mem)
{
INT rtn_val;
REG_X reg;
SREGS sregs;

rtn_val = 0;
if (_gfx_pm.extender == PHAR_LAP) {
	if (mem->flags & USE_DOS_PLAP_MEM) {
		reg.ax = 0x2517;
		sregs.es = sregs.ds = _gfx_pm.selector.prot_mem_DS;
		int86x(0x21, &reg, &reg, &sregs);
		if ((reg.cflag == 0) AND (reg.dx > n_bytes)) {
			mem->pm_selector = sregs.es;
			mem->pm_offset = reg.bx;
			mem->rm_segment = reg.cx >> 16;
			mem->rm_offset  = reg.cx & 0xFFFF;
			rtn_val = SUCCESS;
			}
		}
	if (rtn_val == 0) {
		reg.ax = 0x25C0;
		reg.bx = (n_bytes + 15) >> 4;
		call_dos(reg);
		if (reg.cflag == 0) {
			mem->pm_selector = _gfx_pm.selector.real_mem_DS;
			mem->pm_offset = reg.ax << 4;
			mem->rm_segment = reg.ax;
			mem->rm_offset = 0;
			mem->flags &= ~USE_DOS_PLAP_MEM;
			rtn_val = SUCCESS;
			}
		}
	}
else if (_gfx_pm.extender == RATIONAL) {
	reg.ax = 0x4800;
	reg.bx = (n_bytes + 15) >> 4;
	call_dos(reg);
	if (reg.cflag == 0) {
		mem->pm_selector = _gfx_pm.selector.real_mem_DS;
		mem->pm_offset = reg.ax << 4;
		mem->rm_segment = reg.ax;
		mem->rm_offset = 0;
		rtn_val = SUCCESS;
		}
	}
return rtn_val;
}

Void_FCN _gfx32_free_DOS_mem(MEM32 *mem)
{
REG_X reg;
SREGS sregs;

if (_gfx_pm.extender == PHAR_LAP) {
	if ((mem->flags & USE_DOS_PLAP_MEM) == 0) {
		reg.ax = 0x25C1;
		reg.cx = mem->rm_segment;
		call_dos(reg);
		}
	}
else if (_gfx_pm.extender == RATIONAL) {
	reg.ax = 0x4900;
	sregs.es = mem->rm_segment;
     int86x(0x21, &reg, &reg, &sregs);
	}
}



/*~ VESA32.C */

IMPORT GFX_PM _gfx_pm;
IMPORT SVGA NEAR svga_card;

typedef struct vsi { TINY signature[4];
	                TINY version[2];
	                INT  oem_name;
	                TINY capabilities[4];
                     INT  modes;
                     TINY extra[256-18];
                   } VESA_SYS_INFO;

LOCAL TINY dpmi_buf[0x40];

Int_FCN _gfx32_check_for_VESA(INT *VESA_modes, VESA_RES *VESA_res)
{
FAST INT vmode, val;
INT VESA_vram;
MEM32 mem;

VESA_vram = 0;
svga_card.VESA_is_supported = NO;
svga_card.set_mode_with_VESA = NO;
svga_card.switch_banks_with_VESA = NO;
mem.flags = (_gfx_pm.extender == PHAR_LAP) ? USE_DOS_PLAP_MEM : 0;
if (!_gfx32_alloc_DOS_mem(sizeof(VESA_SYS_INFO), &mem))
	return 0;
val =_gfx32_call_VESA(0x4F00, 0, mem.rm_offset, mem.rm_segment, dpmi_buf);
if (val == 0x4F) {
     svga_card.VESA_is_supported = YES;
     svga_card.set_mode_with_VESA = YES;
	for (vmode=0x100; vmode < 0x108; vmode++) {
		if (_gfx_pm.extender == PHAR_LAP)
			val =_gfx32_call_VESA(0x4F01, vmode, mem.rm_offset, mem.rm_segment, dpmi_buf);
  		if (val == 0x4F) {
			vmode &= 0x7;
			VESA_modes[vmode] = vmode | 0x100;
			if (VESA_res[vmode].vram_sz > VESA_vram)
				VESA_vram = VESA_res[vmode].vram_sz;
			}
		vmode |= 0x100;
		}
	}
_gfx32_free_DOS_mem(&mem);
return VESA_vram;
}


Void_FCN _gfx32_initialize_VESA_switching(int VESA_mode_n)
{ ; }


#endif

/*^ GFXF_C32.C */

#if (PROT_MODE_SYS == PMODE_32)

/*~ RAMROMFT.C */

/* 8x8 Font */

LOCAL UWORD rom_8x8_offset_table[] = {
	0x0	 , 0x8   , 0x10  , 0x18	, 0x20  , 0x28  , 0x30  , 0x38  ,
	0x40  , 0x48  , 0x50  , 0x58	, 0x60  , 0x68  , 0x70  , 0x78  ,
	0x80  , 0x88  , 0x90  , 0x98	, 0xa0  , 0xa8  , 0xb0  , 0xb8  ,
	0xc0  , 0xc8  , 0xd0  , 0xd8	, 0xe0  , 0xe8  , 0xf0  , 0xf8  ,
	0x100 , 0x108 , 0x110 , 0x118 , 0x120 , 0x128 , 0x130 , 0x138 ,
	0x140 , 0x148 , 0x150 , 0x158 , 0x160 , 0x168 , 0x170 , 0x178 ,
	0x180 , 0x188 , 0x190 , 0x198 , 0x1a0 , 0x1a8 , 0x1b0 , 0x1b8 ,
	0x1c0 , 0x1c8 , 0x1d0 , 0x1d8 , 0x1e0 , 0x1e8 , 0x1f0 , 0x1f8 ,
	0x200 , 0x208 , 0x210 , 0x218 , 0x220 , 0x228 , 0x230 , 0x238 ,
	0x240 , 0x248 , 0x250 , 0x258 , 0x260 , 0x268 , 0x270 , 0x278 ,
	0x280 , 0x288 , 0x290 , 0x298 , 0x2a0 , 0x2a8 , 0x2b0 , 0x2b8 ,
	0x2c0 , 0x2c8 , 0x2d0 , 0x2d8 , 0x2e0 , 0x2e8 , 0x2f0 , 0x2f8 ,
	0x300 , 0x308 , 0x310 , 0x318 , 0x320 , 0x328 , 0x330 , 0x338 ,
	0x340 , 0x348 , 0x350 , 0x358 , 0x360 , 0x368 , 0x370 , 0x378 ,
	0x380 , 0x388 , 0x390 , 0x398 , 0x3a0 , 0x3a8 , 0x3b0 , 0x3b8 ,
	0x3c0 , 0x3c8 , 0x3d0 , 0x3d8 , 0x3e0 , 0x3e8 , 0x3f0 , 0x3f8 ,
	0x400 , 0x408 , 0x410 , 0x418 , 0x420 , 0x428 , 0x430 , 0x438 ,
	0x440 , 0x448 , 0x450 , 0x458 , 0x460 , 0x468 , 0x470 , 0x478 ,
	0x480 , 0x488 , 0x490 , 0x498 , 0x4a0 , 0x4a8 , 0x4b0 , 0x4b8 ,
	0x4c0 , 0x4c8 , 0x4d0 , 0x4d8 , 0x4e0 , 0x4e8 , 0x4f0 , 0x4f8 ,
	0x500 , 0x508 , 0x510 , 0x518 , 0x520 , 0x528 , 0x530 , 0x538 ,
	0x540 , 0x548 , 0x550 , 0x558 , 0x560 , 0x568 , 0x570 , 0x578 ,
	0x580 , 0x588 , 0x590 , 0x598 , 0x5a0 , 0x5a8 , 0x5b0 , 0x5b8 ,
	0x5c0 , 0x5c8 , 0x5d0 , 0x5d8 , 0x5e0 , 0x5e8 , 0x5f0 , 0x5f8 ,
	0x600 , 0x608 , 0x610 , 0x618 , 0x620 , 0x628 , 0x630 , 0x638 ,
	0x640 , 0x648 , 0x650 , 0x658 , 0x660 , 0x668 , 0x670 , 0x678 ,
	0x680 , 0x688 , 0x690 , 0x698 , 0x6a0 , 0x6a8 , 0x6b0 , 0x6b8 ,
	0x6c0 , 0x6c8 , 0x6d0 , 0x6d8 , 0x6e0 , 0x6e8 , 0x6f0 , 0x6f8 ,
	0x700 , 0x708 , 0x710 , 0x718 , 0x720 , 0x728 , 0x730 , 0x738 ,
	0x740 , 0x748 , 0x750 , 0x758 , 0x760 , 0x768 , 0x770 , 0x778 ,
	0x780 , 0x788 , 0x790 , 0x798 , 0x7a0 , 0x7a8 , 0x7b0 , 0x7b8 ,
	0x7c0 , 0x7c8 , 0x7d0 , 0x7d8 , 0x7e0 , 0x7e8 , 0x7f0 , 0x0   ,
	0x3c00
    };


LOCAL UTINY rom_8x8_data_table[] = {

	/*******	SCAN LINE #1  ********/
	0x0 , 0x3c, 0x3c, 0x44, 0x10, 0x18, 0x18, 0x0 , 0xff, 0x0 , 0xff, 0xf ,
	0x78, 0x1f, 0x3f, 0xdb, 0xc0, 0x6 , 0x30, 0x6c, 0x7f, 0x3c, 0x0 , 0x18,
	0x30, 0x30, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x18, 0xcc, 0x36,
	0x18, 0xc2, 0x38, 0x30, 0xc , 0x30, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x2 ,
	0x7c, 0x18, 0x7c, 0x7c, 0x1c, 0xfe, 0x3c, 0xfe, 0x7c, 0x7c, 0x0 , 0x0 ,
	0xc , 0x0 , 0x30, 0x3c, 0x7c, 0x38, 0xfc, 0x3e, 0xf8, 0xfe, 0xfe, 0x3e,
	0xc6, 0x3c, 0x1e, 0xe6, 0xf0, 0xc6, 0xc6, 0x7c, 0xfc, 0x7c, 0xfc, 0x7c,
	0x7e, 0x66, 0x66, 0xc6, 0xc6, 0x66, 0xfe, 0x3c, 0x80, 0x3c, 0x18, 0x0 ,
	0x18, 0x0 , 0x60, 0x0 , 0xc , 0x0 , 0x38, 0x0 , 0xe0, 0x30, 0xc , 0xe0,
	0x70, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x10, 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0xe , 0x30, 0x70, 0x0 , 0x10, 0x3c, 0x0 , 0xe , 0x7c,
	0xc6, 0xe0, 0x38, 0x0 , 0x7c, 0xc6, 0xe0, 0x66, 0x7c, 0xe0, 0xc6, 0x38,
	0xe , 0x0 , 0x7e, 0x7c, 0x0 , 0x0 , 0x7c, 0x0 , 0x0 , 0xc6, 0xc6, 0x0 ,
	0x38, 0xc3, 0xfc, 0xc , 0xe , 0x1c, 0x0 , 0x0 , 0x0 , 0xfe, 0x38, 0x7c,
	0x18, 0x0 , 0x0 , 0xc0, 0xc0, 0x18, 0x0 , 0x0 , 0x22, 0x55, 0xdd, 0x18,
	0x18, 0x18, 0x36, 0x0 , 0x0 , 0x36, 0x36, 0x0 , 0x36, 0x36, 0x18, 0x0 ,
	0x18, 0x18, 0x0 , 0x18, 0x0 , 0x18, 0x18, 0x36, 0x36, 0x0 , 0x36, 0x0 ,
	0x36, 0x0 , 0x36, 0x18, 0x36, 0x0 , 0x0 , 0x36, 0x18, 0x0 , 0x0 , 0x36,
	0x18, 0x18, 0x0 , 0xff, 0x0 , 0xf0, 0xf , 0xff, 0x0 , 0x78, 0x0 , 0x0 ,
	0xfe, 0x0 , 0x0 , 0x0 , 0xfe, 0x38, 0x38, 0x3e, 0x0 , 0x6 , 0x38, 0x7c,
	0x0 , 0x18, 0x30, 0xc , 0xc , 0x18, 0x0 , 0x0 , 0x7c, 0x0 , 0x0 , 0x1f,
	0xd8, 0x70, 0x0 ,

	/*******	SCAN LINE #2  ********/
	0x0 , 0x42, 0x7e, 0xee, 0x38, 0x3c, 0x3c, 0x0 , 0xff, 0x7e, 0x81, 0x7 ,
	0xcc, 0x33, 0x63, 0xdb, 0xf0, 0x1e, 0x78, 0x6c, 0xdb, 0x60, 0x0 , 0x3c,
	0x78, 0x30, 0x8 , 0x20, 0x0 , 0x24, 0x10, 0xfe, 0x0 , 0x18, 0xcc, 0x6c,
	0x7e, 0xc6, 0x6c, 0x30, 0x18, 0x18, 0x6c, 0x18, 0x0 , 0x0 , 0x0 , 0x6 ,
	0xce, 0x38, 0xc6, 0xc6, 0x3c, 0xc0, 0x60, 0xc6, 0xc6, 0xc6, 0x18, 0x18,
	0x18, 0x0 , 0x18, 0x66, 0xc6, 0x6c, 0x6e, 0x62, 0x6e, 0x62, 0x62, 0x62,
	0xc6, 0x18, 0xc , 0x66, 0x60, 0xee, 0xe6, 0xc6, 0x66, 0xc6, 0x66, 0xc6,
	0x5a, 0x66, 0x66, 0xc6, 0x6c, 0x66, 0xcc, 0x30, 0xc0, 0xc , 0x3c, 0x0 ,
	0x18, 0x0 , 0x60, 0x0 , 0xc , 0x0 , 0x6c, 0x0 , 0x60, 0x0 , 0x0 , 0x60,
	0x30, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x30, 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x18, 0x30, 0x18, 0x76, 0x38, 0x66, 0xc6, 0x0 , 0xc6,
	0x0 , 0x0 , 0x38, 0x0 , 0xc6, 0x0 , 0x0 , 0x0 , 0xc6, 0x0 , 0x38, 0x38,
	0x0 , 0x0 , 0xd8, 0xc6, 0xc6, 0xe0, 0xc6, 0xe0, 0xc6, 0x38, 0x0 , 0x18,
	0x6c, 0x66, 0xc6, 0x1e, 0x0 , 0x0 , 0xe , 0xe , 0xfc, 0x0 , 0x6c, 0xc6,
	0x0 , 0x0 , 0x0 , 0xcc, 0xcc, 0x0 , 0x36, 0xd8, 0x88, 0xaa, 0x77, 0x18,
	0x18, 0x18, 0x36, 0x0 , 0x0 , 0x36, 0x36, 0x0 , 0x36, 0x36, 0x18, 0x0 ,
	0x18, 0x18, 0x0 , 0x18, 0x0 , 0x18, 0x18, 0x36, 0x36, 0x0 , 0x36, 0x0 ,
	0x36, 0x0 , 0x36, 0x18, 0x36, 0x0 , 0x0 , 0x36, 0x18, 0x0 , 0x0 , 0x36,
	0x18, 0x18, 0x0 , 0xff, 0x0 , 0xf0, 0xf , 0xff, 0x0 , 0xcc, 0xfe, 0xfe,
	0xc6, 0x7e, 0x66, 0x76, 0x38, 0x6c, 0x6c, 0x60, 0x0 , 0x7c, 0x60, 0xc6,
	0xfe, 0x18, 0x18, 0x18, 0x1e, 0x18, 0x0 , 0x76, 0xc6, 0x0 , 0x0 , 0x18,
	0x6c, 0xd8, 0x0 ,

	/*******	SCAN LINE #3  ********/
	0x0 , 0xa5, 0xdb, 0xfe, 0x7c, 0xdb, 0x7e, 0x3c, 0xc3, 0x42, 0xbd, 0x7 ,
	0xcc, 0x3f, 0x7f, 0x3c, 0xf8, 0x3e, 0xfc, 0x6c, 0xdb, 0x3c, 0x0 , 0x7e,
	0xfc, 0x30, 0xc , 0x60, 0xc0, 0x42, 0x38, 0xfe, 0x0 , 0x18, 0xcc, 0xfe,
	0xc0, 0xc , 0x38, 0x60, 0x30, 0xc , 0x38, 0x18, 0x0 , 0x0 , 0x0 , 0xc ,
	0xde, 0x18, 0x6 , 0x6 , 0x6c, 0xfc, 0xc0, 0xc , 0xc6, 0xc6, 0x18, 0x18,
	0x30, 0x7e, 0xc , 0x6 , 0xde, 0xc6, 0x66, 0xc0, 0x66, 0x60, 0x60, 0xc0,
	0xc6, 0x18, 0xc , 0x6c, 0x60, 0xfe, 0xf6, 0xc6, 0x66, 0xc6, 0x66, 0xe0,
	0x18, 0x66, 0x66, 0xc6, 0x38, 0x66, 0x18, 0x30, 0x60, 0xc , 0x66, 0x0 ,
	0xc , 0x38, 0x60, 0x7c, 0xc , 0x78, 0x60, 0x76, 0x60, 0x70, 0x1c, 0x66,
	0x30, 0xcc, 0xdc, 0x3c, 0xdc, 0x76, 0xdc, 0x78, 0x78, 0xcc, 0x66, 0xc6,
	0xcc, 0xcc, 0xfc, 0x18, 0x30, 0x18, 0xdc, 0x6c, 0xc0, 0x0 , 0x7c, 0x78,
	0x78, 0x78, 0x78, 0x7c, 0x7c, 0x7c, 0x7c, 0x38, 0x38, 0x38, 0x6c, 0x0 ,
	0xfe, 0x6c, 0xd8, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x6c, 0xc6, 0x7e,
	0x60, 0x3c, 0xfc, 0x18, 0x78, 0x38, 0x0 , 0x0 , 0x0 , 0xc6, 0x3e, 0x7c,
	0x18, 0x0 , 0x0 , 0xd8, 0xd8, 0x18, 0x6c, 0x6c, 0x22, 0x55, 0xdd, 0x18,
	0x18, 0xf8, 0x36, 0x0 , 0xf8, 0xf6, 0x36, 0xfe, 0xf6, 0x36, 0xf8, 0x0 ,
	0x18, 0x18, 0x0 , 0x18, 0x0 , 0x18, 0x1f, 0x36, 0x37, 0x3f, 0xf7, 0xff,
	0x37, 0xff, 0xf7, 0xff, 0x36, 0xff, 0x0 , 0x36, 0x1f, 0x1f, 0x0 , 0x36,
	0xff, 0x18, 0x0 , 0xff, 0x0 , 0xf0, 0xf , 0xff, 0x66, 0xf8, 0x62, 0x6c,
	0x60, 0xd8, 0x66, 0xdc, 0x6c, 0xc6, 0xc6, 0x38, 0x7e, 0xde, 0xc0, 0xc6,
	0x0 , 0x7e, 0xc , 0x30, 0x18, 0x18, 0x18, 0xdc, 0xc6, 0x0 , 0x0 , 0x18,
	0x6c, 0x30, 0x7c,

	/*******	SCAN LINE #4  ********/
	0x0 , 0x81, 0xff, 0xfe, 0xfe, 0xff, 0xff, 0x3c, 0xc3, 0x42, 0xbd, 0x7d,
	0xcc, 0x30, 0x63, 0xe7, 0xfe, 0xfe, 0x30, 0x6c, 0xdb, 0x66, 0x0 , 0x18,
	0x30, 0x30, 0xfe, 0xfe, 0xc0, 0xff, 0x7c, 0x7c, 0x0 , 0x18, 0x0 , 0x6c,
	0x7c, 0x18, 0x70, 0x0 , 0x30, 0xc , 0xfe, 0x7e, 0x0 , 0x7e, 0x0 , 0x18,
	0xf6, 0x18, 0x1c, 0x1c, 0xcc, 0x6 , 0xfc, 0x18, 0x7c, 0x7e, 0x0 , 0x0 ,
	0x60, 0x0 , 0x6 , 0xc , 0xde, 0xc6, 0x7c, 0xc0, 0x66, 0x78, 0x78, 0xc0,
	0xfe, 0x18, 0xc , 0x78, 0x60, 0xd6, 0xfe, 0xc6, 0x7c, 0xd6, 0x7c, 0x38,
	0x18, 0x66, 0x66, 0xd6, 0x38, 0x3c, 0x30, 0x30, 0x30, 0xc , 0x0 , 0x0 ,
	0x0 , 0xc , 0x7c, 0xc4, 0x7c, 0xcc, 0xf8, 0xcc, 0x7c, 0x30, 0xc , 0x6c,
	0x30, 0xfe, 0x66, 0x66, 0x66, 0xcc, 0x76, 0xc0, 0x30, 0xcc, 0x66, 0xc6,
	0x78, 0xcc, 0x18, 0x70, 0x0 , 0xe , 0x0 , 0xc6, 0x66, 0xc6, 0xc6, 0xc ,
	0xc , 0xc , 0xc , 0xc0, 0xc6, 0xc6, 0xc6, 0x18, 0x18, 0x18, 0xc6, 0x7c,
	0xc0, 0x9a, 0xfe, 0x7c, 0x7c, 0x7c, 0xc6, 0xc6, 0xc6, 0xc6, 0xc6, 0xd8,
	0xf0, 0x7e, 0xcc, 0x7e, 0xc , 0x18, 0x7c, 0xcc, 0xbc, 0xe6, 0x0 , 0x0 ,
	0x30, 0x7c, 0x7c, 0x30, 0x30, 0x18, 0xd8, 0x36, 0x88, 0xaa, 0x77, 0x18,
	0x18, 0x18, 0x36, 0x0 , 0x18, 0x6 , 0x36, 0x6 , 0x6 , 0x36, 0x18, 0x0 ,
	0x18, 0x18, 0x0 , 0x18, 0x0 , 0x18, 0x18, 0x36, 0x30, 0x30, 0x0 , 0x0 ,
	0x30, 0x0 , 0x0 , 0x0 , 0x36, 0x0 , 0x0 , 0x36, 0x18, 0x18, 0x0 , 0x36,
	0x18, 0x18, 0x0 , 0xff, 0x0 , 0xf0, 0xf , 0xff, 0xdc, 0xcc, 0x60, 0x6c,
	0x30, 0xcc, 0x66, 0x18, 0xc6, 0xfe, 0xc6, 0x66, 0xdb, 0xf6, 0xf8, 0xc6,
	0xfe, 0x18, 0x18, 0x18, 0x18, 0x18, 0x0 , 0x0 , 0x7c, 0x18, 0x0 , 0x18,
	0x6c, 0xf8, 0x7c,

	/*******	SCAN LINE #5  ********/
	0x0 , 0xbd, 0xc3, 0x7c, 0x7c, 0xdb, 0x7e, 0x3c, 0xc3, 0x42, 0xbd, 0xcc,
	0x78, 0x30, 0x63, 0xe7, 0xf8, 0x3e, 0x30, 0x6c, 0x7b, 0x66, 0xfe, 0x7e,
	0x30, 0xfc, 0xc , 0x60, 0xfe, 0x42, 0xfe, 0x38, 0x0 , 0x18, 0x0 , 0xfe,
	0x6 , 0x30, 0xde, 0x0 , 0x30, 0xc , 0x38, 0x18, 0x0 , 0x0 , 0x0 , 0x30,
	0xe6, 0x18, 0x70, 0x6 , 0xfe, 0x6 , 0xc6, 0x30, 0xc6, 0x6 , 0x0 , 0x0 ,
	0x30, 0x0 , 0xc , 0x18, 0xde, 0xfe, 0x66, 0xc0, 0x66, 0x60, 0x60, 0xce,
	0xc6, 0x18, 0xc , 0x78, 0x60, 0xc6, 0xde, 0xc6, 0x60, 0xde, 0x78, 0xe ,
	0x18, 0x66, 0x66, 0xfe, 0x6c, 0x18, 0x60, 0x30, 0x18, 0xc , 0x0 , 0x0 ,
	0x0 , 0x7c, 0x66, 0xc0, 0xcc, 0xfc, 0x60, 0xcc, 0x66, 0x30, 0xc , 0x78,
	0x30, 0xd6, 0x66, 0x66, 0x66, 0xcc, 0x60, 0x78, 0x30, 0xcc, 0x66, 0xd6,
	0x30, 0xcc, 0x30, 0x18, 0x30, 0x18, 0x0 , 0xc6, 0x3c, 0xc6, 0xfe, 0x7c,
	0x7c, 0x7c, 0x7c, 0x7c, 0xfe, 0xfe, 0xfe, 0x18, 0x18, 0x18, 0xfe, 0xc6,
	0xf8, 0x7e, 0xd8, 0xc6, 0xc6, 0xc6, 0xc6, 0xc6, 0xce, 0xc6, 0xc6, 0xd8,
	0x66, 0x18, 0xde, 0x18, 0x7c, 0x18, 0xc6, 0xcc, 0x66, 0xf6, 0x7e, 0x7c,
	0x60, 0x60, 0xc , 0x7c, 0x6c, 0x3c, 0x6c, 0x6c, 0x22, 0x55, 0xdd, 0x18,
	0xf8, 0xf8, 0xf6, 0xfe, 0xf8, 0xf6, 0x36, 0xf6, 0xfe, 0xfe, 0xf8, 0xf8,
	0x1f, 0xff, 0xff, 0x1f, 0xff, 0xff, 0x1f, 0x37, 0x3f, 0x37, 0xff, 0xf7,
	0x37, 0xff, 0xf7, 0xff, 0xff, 0xff, 0xff, 0x3f, 0x1f, 0x1f, 0x3f, 0xff,
	0xff, 0xf8, 0x1f, 0xff, 0xff, 0xf0, 0xf , 0x0 , 0xd8, 0xe6, 0x60, 0x6c,
	0x60, 0xcc, 0x66, 0x18, 0x6c, 0xc6, 0x6c, 0xc6, 0xdb, 0xe6, 0xc0, 0xc6,
	0x0 , 0x18, 0x30, 0xc , 0x18, 0x18, 0x7e, 0x76, 0x0 , 0x18, 0x18, 0xf8,
	0x0 , 0x0 , 0x7c,

	/*******	SCAN LINE #6  ********/
	0x0 , 0x99, 0xe7, 0x38, 0x38, 0x18, 0x18, 0x3c, 0xc3, 0x42, 0xbd, 0xcc,
	0x30, 0x70, 0x67, 0x3c, 0xf0, 0x1e, 0xfc, 0x0 , 0x1b, 0x3c, 0xfe, 0x3c,
	0x30, 0x78, 0x8 , 0x20, 0x0 , 0x24, 0xfe, 0x10, 0x0 , 0x0 , 0x0 , 0x6c,
	0xfc, 0x66, 0xcc, 0x0 , 0x18, 0x18, 0x6c, 0x18, 0x18, 0x0 , 0x18, 0x60,
	0xc6, 0x18, 0xc6, 0xc6, 0xc , 0xc6, 0xc6, 0x30, 0xc6, 0xc , 0x18, 0x18,
	0x18, 0x7e, 0x18, 0x0 , 0xc0, 0xc6, 0x6e, 0x62, 0x6e, 0x62, 0x60, 0x66,
	0xc6, 0x18, 0xcc, 0x6c, 0x66, 0xc6, 0xce, 0xc6, 0x60, 0x7c, 0x6c, 0xc6,
	0x18, 0x66, 0x3c, 0xfe, 0xc6, 0x18, 0xc6, 0x30, 0xc , 0xc , 0x0 , 0x0 ,
	0x0 , 0xcc, 0x66, 0xc4, 0xcc, 0xc0, 0x60, 0x7c, 0x66, 0x30, 0xcc, 0x6c,
	0x30, 0xc6, 0x66, 0x66, 0x7c, 0x7c, 0x60, 0xc , 0x34, 0xcc, 0x3c, 0xfe,
	0x78, 0x7c, 0x60, 0x18, 0x30, 0x18, 0x0 , 0xc6, 0x18, 0xce, 0xc0, 0xcc,
	0xcc, 0xcc, 0xcc, 0x18, 0xc0, 0xc0, 0xc0, 0x18, 0x18, 0x18, 0xc6, 0xfe,
	0xc0, 0xd8, 0xd8, 0xc6, 0xc6, 0xc6, 0xce, 0xce, 0x76, 0x6c, 0xc6, 0x7e,
	0xf6, 0x3c, 0xcc, 0x18, 0xcc, 0x18, 0xc6, 0xdc, 0x66, 0xce, 0x0 , 0x0 ,
	0x66, 0x60, 0xc , 0x36, 0x3c, 0x3c, 0x36, 0xd8, 0x88, 0xaa, 0x77, 0x18,
	0x18, 0x18, 0x36, 0x36, 0x18, 0x36, 0x36, 0x36, 0x0 , 0x0 , 0x0 , 0x18,
	0x0 , 0x0 , 0x18, 0x18, 0x0 , 0x18, 0x18, 0x36, 0x0 , 0x36, 0x0 , 0x36,
	0x36, 0x0 , 0x36, 0x0 , 0x0 , 0x18, 0x36, 0x0 , 0x0 , 0x18, 0x36, 0x36,
	0x18, 0x0 , 0x18, 0xff, 0xff, 0xf0, 0xf , 0x0 , 0xdc, 0xdc, 0x60, 0x6c,
	0xc6, 0xd8, 0x7c, 0x18, 0x38, 0x6c, 0x6c, 0xcc, 0x7e, 0x7c, 0x60, 0xc6,
	0xfe, 0x0 , 0x0 , 0x0 , 0x18, 0x78, 0x0 , 0xdc, 0x0 , 0x0 , 0x0 , 0x38,
	0x0 , 0x0 , 0x7c,

	/*******	SCAN LINE #7  ********/
	0x0 , 0x42, 0x7e, 0x10, 0x10, 0x3c, 0x3c, 0x0 , 0xff, 0x7e, 0x81, 0xcc,
	0xfc, 0xf0, 0xe6, 0xdb, 0xc0, 0x6 , 0x78, 0x6c, 0x1b, 0x6 , 0xfe, 0x18,
	0x30, 0x30, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x18, 0x0 , 0xd8,
	0x30, 0xc6, 0x76, 0x0 , 0xc , 0x30, 0x0 , 0x0 , 0x18, 0x0 , 0x18, 0xc0,
	0x7c, 0x7e, 0xfe, 0x7c, 0xc , 0x7c, 0x7c, 0x30, 0x7c, 0x78, 0x18, 0x18,
	0xc , 0x0 , 0x30, 0x18, 0x7c, 0xc6, 0xfc, 0x3e, 0xf8, 0xfe, 0xf0, 0x3e,
	0xc6, 0x3c, 0x78, 0xe6, 0xfe, 0xc6, 0xc6, 0x7c, 0xe0, 0x6 , 0xe6, 0x7c,
	0x3c, 0x3c, 0x18, 0xc6, 0xc6, 0x3c, 0xfe, 0x3c, 0x6 , 0x3c, 0x0 , 0x0 ,
	0x0 , 0x76, 0xdc, 0x7c, 0x76, 0x7c, 0xe0, 0xc , 0x66, 0x38, 0xcc, 0x66,
	0x38, 0xc6, 0x66, 0x3c, 0x60, 0xc , 0x60, 0x78, 0x18, 0xf6, 0x18, 0x6c,
	0xcc, 0xc , 0xfc, 0xe , 0x30, 0x70, 0x0 , 0xfe, 0xcc, 0x76, 0x7c, 0x7e,
	0x7e, 0x7e, 0x7e, 0x6c, 0x7c, 0x7c, 0x7c, 0x3c, 0x3c, 0x3c, 0xc6, 0xc6,
	0xfe, 0x6e, 0xde, 0x7c, 0x7c, 0x7c, 0x76, 0x76, 0x6 , 0x38, 0x7c, 0x18,
	0x6c, 0x18, 0xce, 0xd8, 0x7e, 0x3c, 0x7c, 0x76, 0xe6, 0xc6, 0x0 , 0x0 ,
	0x3c, 0x0 , 0x0 , 0xc , 0x7e, 0x18, 0x0 , 0x0 , 0x22, 0x55, 0xdd, 0x18,
	0x18, 0x18, 0x36, 0x36, 0x18, 0x36, 0x36, 0x36, 0x0 , 0x0 , 0x0 , 0x18,
	0x0 , 0x0 , 0x18, 0x18, 0x0 , 0x18, 0x18, 0x36, 0x0 , 0x36, 0x0 , 0x36,
	0x36, 0x0 , 0x36, 0x0 , 0x0 , 0x18, 0x36, 0x0 , 0x0 , 0x18, 0x36, 0x36,
	0x18, 0x0 , 0x18, 0xff, 0xff, 0xf0, 0xf , 0x0 , 0x66, 0xc0, 0xe0, 0x6c,
	0xfe, 0x70, 0xc0, 0x38, 0xfe, 0x38, 0xee, 0x78, 0x0 , 0xc0, 0x38, 0xc6,
	0x0 , 0x7e, 0x7e, 0x7e, 0x18, 0x30, 0x18, 0x0 , 0x0 , 0x0 , 0x0 , 0x18,
	0x0 , 0x0 , 0x0 ,

	/*******	SCAN LINE #8  ********/
	0x0 , 0x3c, 0x3c, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0xff, 0x0 , 0xff, 0x78,
	0x30, 0xe0, 0xc0, 0xdb, 0x0 , 0x0 , 0x30, 0x0 , 0x0 , 0x3c, 0x0 , 0x7e,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x30, 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x30,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0xff,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x7c, 0x0 , 0x0 , 0x78, 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0xe0, 0xe , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x7c, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x78, 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x38, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x7c, 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x70, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x3e, 0xc , 0x0 , 0x0 , 0x0 , 0x88, 0xaa, 0x77, 0x18,
	0x18, 0x18, 0x36, 0x36, 0x18, 0x36, 0x36, 0x36, 0x0 , 0x0 , 0x0 , 0x18,
	0x0 , 0x0 , 0x18, 0x18, 0x0 , 0x18, 0x18, 0x36, 0x0 , 0x36, 0x0 , 0x36,
	0x36, 0x0 , 0x36, 0x0 , 0x0 , 0x18, 0x36, 0x0 , 0x0 , 0x18, 0x36, 0x36,
	0x18, 0x0 , 0x18, 0xff, 0xff, 0xf0, 0xf , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x18, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0
    };



LOCAL UWORD rom_8x14_offset_table[] = {
	0x0	 , 0x8   , 0x10  , 0x18	, 0x20  , 0x28  , 0x30  , 0x38  ,
	0x40  , 0x48  , 0x50  , 0x58	, 0x60  , 0x68  , 0x70  , 0x78  ,
	0x80  , 0x88  , 0x90  , 0x98	, 0xa0  , 0xa8  , 0xb0  , 0xb8  ,
	0xc0  , 0xc8  , 0xd0  , 0xd8	, 0xe0  , 0xe8  , 0xf0  , 0xf8  ,
	0x100 , 0x108 , 0x110 , 0x118 , 0x120 , 0x128 , 0x130 , 0x138 ,
	0x140 , 0x148 , 0x150 , 0x158 , 0x160 , 0x168 , 0x170 , 0x178 ,
	0x180 , 0x188 , 0x190 , 0x198 , 0x1a0 , 0x1a8 , 0x1b0 , 0x1b8 ,
	0x1c0 , 0x1c8 , 0x1d0 , 0x1d8 , 0x1e0 , 0x1e8 , 0x1f0 , 0x1f8 ,
	0x200 , 0x208 , 0x210 , 0x218 , 0x220 , 0x228 , 0x230 , 0x238 ,
	0x240 , 0x248 , 0x250 , 0x258 , 0x260 , 0x268 , 0x270 , 0x278 ,
	0x280 , 0x288 , 0x290 , 0x298 , 0x2a0 , 0x2a8 , 0x2b0 , 0x2b8 ,
	0x2c0 , 0x2c8 , 0x2d0 , 0x2d8 , 0x2e0 , 0x2e8 , 0x2f0 , 0x2f8 ,
	0x300 , 0x308 , 0x310 , 0x318 , 0x320 , 0x328 , 0x330 , 0x338 ,
	0x340 , 0x348 , 0x350 , 0x358 , 0x360 , 0x368 , 0x370 , 0x378 ,
	0x380 , 0x388 , 0x390 , 0x398 , 0x3a0 , 0x3a8 , 0x3b0 , 0x3b8 ,
	0x3c0 , 0x3c8 , 0x3d0 , 0x3d8 , 0x3e0 , 0x3e8 , 0x3f0 , 0x3f8 ,
	0x400 , 0x408 , 0x410 , 0x418 , 0x420 , 0x428 , 0x430 , 0x438 ,
	0x440 , 0x448 , 0x450 , 0x458 , 0x460 , 0x468 , 0x470 , 0x478 ,
	0x480 , 0x488 , 0x490 , 0x498 , 0x4a0 , 0x4a8 , 0x4b0 , 0x4b8 ,
	0x4c0 , 0x4c8 , 0x4d0 , 0x4d8 , 0x4e0 , 0x4e8 , 0x4f0 , 0x4f8 ,
	0x500 , 0x508 , 0x510 , 0x518 , 0x520 , 0x528 , 0x530 , 0x538 ,
	0x540 , 0x548 , 0x550 , 0x558 , 0x560 , 0x568 , 0x570 , 0x578 ,
	0x580 , 0x588 , 0x590 , 0x598 , 0x5a0 , 0x5a8 , 0x5b0 , 0x5b8 ,
	0x5c0 , 0x5c8 , 0x5d0 , 0x5d8 , 0x5e0 , 0x5e8 , 0x5f0 , 0x5f8 ,
	0x600 , 0x608 , 0x610 , 0x618 , 0x620 , 0x628 , 0x630 , 0x638 ,
	0x640 , 0x648 , 0x650 , 0x658 , 0x660 , 0x668 , 0x670 , 0x678 ,
	0x680 , 0x688 , 0x690 , 0x698 , 0x6a0 , 0x6a8 , 0x6b0 , 0x6b8 ,
	0x6c0 , 0x6c8 , 0x6d0 , 0x6d8 , 0x6e0 , 0x6e8 , 0x6f0 , 0x6f8 ,
	0x700 , 0x708 , 0x710 , 0x718 , 0x720 , 0x728 , 0x730 , 0x738 ,
	0x740 , 0x748 , 0x750 , 0x758 , 0x760 , 0x768 , 0x770 , 0x778 ,
	0x780 , 0x788 , 0x790 , 0x798 , 0x7a0 , 0x7a8 , 0x7b0 , 0x7b8 ,
	0x7c0 , 0x7c8 , 0x7d0 , 0x7d8 , 0x7e0 , 0x7e8 , 0x7f0 , 0x0   ,
	0x0
    };


LOCAL UTINY rom_8x14_data_table[] = {

	/*******	SCAN LINE #1  ********/
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0xff, 0x0 , 0xff, 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x38,
	0xc , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x11, 0x55, 0xdd, 0x18,
	0x18, 0x18, 0x36, 0x0 , 0x0 , 0x36, 0x36, 0x0 , 0x36, 0x36, 0x18, 0x0 ,
	0x18, 0x18, 0x0 , 0x18, 0x0 , 0x18, 0x18, 0x36, 0x36, 0x0 , 0x36, 0x0 ,
	0x36, 0x0 , 0x36, 0x18, 0x36, 0x0 , 0x0 , 0x36, 0x18, 0x0 , 0x0 , 0x36,
	0x18, 0x18, 0x0 , 0xff, 0x0 , 0xf0, 0xf , 0xff, 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x18, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 ,

	/*******	SCAN LINE #2  ********/
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0xff, 0x0 , 0xff, 0x0 ,
	0x0 , 0x0 , 0x3e, 0x18, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x7c, 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x36, 0x0 ,
	0x18, 0x0 , 0x0 , 0xc , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x10, 0x0 ,
	0x18, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0xc , 0x30,
	0x0 , 0x60, 0x38, 0x0 , 0x30, 0x0 , 0x30, 0x0 , 0x18, 0x60, 0xc6, 0x6c,
	0x18, 0x0 , 0x7e, 0x30, 0x0 , 0x30, 0x30, 0x60, 0x0 , 0xc6, 0xc6, 0x18,
	0x0 , 0x0 , 0xfc, 0xe , 0xc , 0xc , 0xc , 0x18, 0x0 , 0x76, 0x3c, 0x38,
	0x0 , 0x0 , 0x0 , 0x60, 0x60, 0x0 , 0x0 , 0x0 , 0x44, 0xaa, 0x77, 0x18,
	0x18, 0x18, 0x36, 0x0 , 0x0 , 0x36, 0x36, 0x0 , 0x36, 0x36, 0x18, 0x0 ,
	0x18, 0x18, 0x0 , 0x18, 0x0 , 0x18, 0x18, 0x36, 0x36, 0x0 , 0x36, 0x0 ,
	0x36, 0x0 , 0x36, 0x18, 0x36, 0x0 , 0x0 , 0x36, 0x18, 0x0 , 0x0 , 0x36,
	0x18, 0x18, 0x0 , 0xff, 0x0 , 0xf0, 0xf , 0xff, 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x18, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0xd8, 0x70, 0x0 ,

	/*******	SCAN LINE #3  ********/
	0x0 , 0x7e, 0x7e, 0x0 , 0x0 , 0x0 , 0x10, 0x0 , 0xff, 0x0 , 0xff, 0x1e,
	0x3c, 0x1e, 0x36, 0xdb, 0x80, 0x2 , 0x18, 0x66, 0x7f, 0xc6, 0x0 , 0x18,
	0x18, 0x18, 0x0 , 0x0 , 0x0 , 0x0 , 0x10, 0xfe, 0x0 , 0x18, 0x36, 0x6c,
	0x18, 0x0 , 0x38, 0xc , 0xc , 0x30, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x7c, 0x18, 0x7c, 0x7c, 0xc , 0xfe, 0x7c, 0xfe, 0x7c, 0x7c, 0x0 , 0x0 ,
	0xc , 0x0 , 0x60, 0x7c, 0x7c, 0x38, 0xfc, 0x3c, 0xf8, 0xfe, 0xfe, 0x7c,
	0xc6, 0x3c, 0x3c, 0xc6, 0xf0, 0xc6, 0xc6, 0x7c, 0xfc, 0x7c, 0xfc, 0x7c,
	0x7e, 0xc6, 0xc6, 0xc6, 0xc6, 0x66, 0xfe, 0x7c, 0x0 , 0x7c, 0x38, 0x0 ,
	0x18, 0x0 , 0xe0, 0x0 , 0x1c, 0x0 , 0x1c, 0x0 , 0xe0, 0x18, 0xc , 0xe0,
	0x38, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x30, 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0xe , 0x18, 0x70, 0x76, 0x0 , 0x3c, 0xc6, 0x18, 0x78,
	0xcc, 0x30, 0x6c, 0x0 , 0x78, 0xcc, 0x18, 0x66, 0x3c, 0x30, 0xc6, 0x38,
	0x30, 0x0 , 0xd8, 0x78, 0xc6, 0x18, 0x78, 0x30, 0xc6, 0xc6, 0xc6, 0x18,
	0x38, 0x66, 0xc6, 0x1b, 0x18, 0x18, 0x18, 0x30, 0x76, 0xdc, 0x6c, 0x6c,
	0x30, 0x0 , 0x0 , 0x62, 0x62, 0x18, 0x0 , 0x0 , 0x11, 0x55, 0xdd, 0x18,
	0x18, 0x18, 0x36, 0x0 , 0x0 , 0x36, 0x36, 0x0 , 0x36, 0x36, 0x18, 0x0 ,
	0x18, 0x18, 0x0 , 0x18, 0x0 , 0x18, 0x18, 0x36, 0x36, 0x0 , 0x36, 0x0 ,
	0x36, 0x0 , 0x36, 0x18, 0x36, 0x0 , 0x0 , 0x36, 0x18, 0x0 , 0x0 , 0x36,
	0x18, 0x18, 0x0 , 0xff, 0x0 , 0xf0, 0xf , 0xff, 0x0 , 0x0 , 0xfe, 0x0 ,
	0xfe, 0x0 , 0x0 , 0x0 , 0xfe, 0x38, 0x38, 0x3e, 0x0 , 0x6 , 0x1c, 0x7c,
	0x0 , 0x0 , 0x30, 0xc , 0x0 , 0x18, 0x0 , 0x0 , 0x78, 0x0 , 0x0 , 0x0 ,
	0x6c, 0xd8, 0x0 ,

	/*******	SCAN LINE #4  ********/
	0x0 , 0x81, 0xff, 0x6c, 0x10, 0x10, 0x38, 0x0 , 0xff, 0x0 , 0xff, 0xe ,
	0x66, 0x1a, 0x3e, 0x7e, 0xe0, 0xe , 0x3c, 0x66, 0xdb, 0xc6, 0x0 , 0x3c,
	0x3c, 0x18, 0x0 , 0x0 , 0x0 , 0x0 , 0x38, 0xfe, 0x0 , 0x3c, 0x36, 0x6c,
	0x7c, 0x0 , 0x6c, 0xc , 0x18, 0x18, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x2 ,
	0xc6, 0x78, 0xc6, 0xc6, 0x1c, 0xc0, 0xc6, 0xc6, 0xc6, 0xc6, 0x0 , 0x0 ,
	0x18, 0x0 , 0x30, 0xc6, 0xc6, 0x6c, 0x66, 0x66, 0x6c, 0x66, 0x66, 0xc6,
	0xc6, 0x18, 0x18, 0xcc, 0x60, 0xc6, 0xc6, 0xc6, 0x66, 0xc6, 0x66, 0xc6,
	0x5a, 0xc6, 0xc6, 0xc6, 0xc6, 0x66, 0xc6, 0x60, 0x80, 0xc , 0x6c, 0x0 ,
	0x18, 0x0 , 0x60, 0x0 , 0xc , 0x0 , 0x36, 0x0 , 0x60, 0x18, 0xc , 0x60,
	0x18, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x30, 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x18, 0x18, 0x18, 0xdc, 0x0 , 0x66, 0xc6, 0x30, 0xcc,
	0xcc, 0x18, 0x38, 0x0 , 0xcc, 0xcc, 0xc , 0x66, 0x66, 0x18, 0x0 , 0x0 ,
	0x0 , 0x0 , 0xd8, 0xcc, 0xc6, 0xc , 0xcc, 0x18, 0xc6, 0x0 , 0x0 , 0x3c,
	0x6c, 0x66, 0xfc, 0x18, 0x30, 0x30, 0x30, 0x60, 0xdc, 0x0 , 0x6c, 0x6c,
	0x30, 0x0 , 0x0 , 0x66, 0x66, 0x18, 0x0 , 0x0 , 0x44, 0xaa, 0x77, 0x18,
	0x18, 0x18, 0x36, 0x0 , 0x0 , 0x36, 0x36, 0x0 , 0x36, 0x36, 0x18, 0x0 ,
	0x18, 0x18, 0x0 , 0x18, 0x0 , 0x18, 0x18, 0x36, 0x36, 0x0 , 0x36, 0x0 ,
	0x36, 0x0 , 0x36, 0x18, 0x36, 0x0 , 0x0 , 0x36, 0x18, 0x0 , 0x0 , 0x36,
	0x18, 0x18, 0x0 , 0xff, 0x0 , 0xf0, 0xf , 0xff, 0x0 , 0x0 , 0x66, 0x0 ,
	0xc6, 0x0 , 0x0 , 0x0 , 0x38, 0x6c, 0x6c, 0x60, 0x0 , 0xc , 0x30, 0xc6,
	0x0 , 0x0 , 0x18, 0x18, 0xc , 0x18, 0x18, 0x0 , 0xcc, 0x0 , 0x0 , 0x1f,
	0x6c, 0x30, 0x0 ,

	/*******	SCAN LINE #5  ********/
	0x0 , 0xa5, 0xdb, 0xee, 0x38, 0x38, 0x7c, 0x0 , 0xff, 0x18, 0xe7, 0x1e,
	0x66, 0x1e, 0x36, 0x3c, 0xf0, 0x3e, 0x7e, 0x66, 0xdb, 0x60, 0x0 , 0x7e,
	0x7e, 0x18, 0xc , 0x30, 0x0 , 0x24, 0x38, 0x7c, 0x0 , 0x3c, 0x14, 0x6c,
	0xc6, 0x62, 0x38, 0x18, 0x30, 0xc , 0x6c, 0x18, 0x0 , 0x0 , 0x0 , 0x6 ,
	0xce, 0x18, 0xc6, 0x6 , 0x3c, 0xc0, 0xc0, 0xc , 0xc6, 0xc6, 0xc , 0xc ,
	0x30, 0x0 , 0x18, 0xc6, 0xc6, 0xc6, 0x66, 0xc0, 0x66, 0x60, 0x60, 0xc6,
	0xc6, 0x18, 0x18, 0xd8, 0x60, 0xee, 0xe6, 0xc6, 0x66, 0xc6, 0x66, 0xc0,
	0x18, 0xc6, 0xc6, 0xd6, 0x6c, 0x66, 0x8c, 0x60, 0xc0, 0xc , 0xc6, 0x0 ,
	0xc , 0x0 , 0x60, 0x0 , 0xc , 0x0 , 0x30, 0x0 , 0x60, 0x0 , 0x0 , 0x60,
	0x18, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x30, 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x18, 0x18, 0x18, 0x0 , 0x10, 0xc0, 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x7c, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x38, 0x38,
	0xfe, 0x66, 0xd8, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x7c, 0xc6, 0x66,
	0x60, 0x3c, 0xc0, 0x18, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0xc6, 0x3e, 0x38,
	0x0 , 0x0 , 0x0 , 0x6c, 0x6c, 0x0 , 0x36, 0xd8, 0x11, 0x55, 0xdd, 0x18,
	0x18, 0x18, 0x36, 0x0 , 0x0 , 0x36, 0x36, 0x0 , 0x36, 0x36, 0x18, 0x0 ,
	0x18, 0x18, 0x0 , 0x18, 0x0 , 0x18, 0x18, 0x36, 0x36, 0x0 , 0x36, 0x0 ,
	0x36, 0x0 , 0x36, 0x18, 0x36, 0x0 , 0x0 , 0x36, 0x18, 0x0 , 0x0 , 0x36,
	0x18, 0x18, 0x0 , 0xff, 0x0 , 0xf0, 0xf , 0xff, 0x76, 0x78, 0x62, 0x0 ,
	0x62, 0x0 , 0x66, 0x0 , 0x6c, 0xc6, 0xc6, 0x30, 0x0 , 0x7c, 0x60, 0xc6,
	0x0 , 0x18, 0xc , 0x30, 0x1e, 0x18, 0x18, 0x0 , 0xcc, 0x0 , 0x0 , 0x18,
	0x6c, 0x60, 0x7e,

	/*******	SCAN LINE #6  ********/
	0x0 , 0x81, 0xff, 0xfe, 0x7c, 0x10, 0x7c, 0x18, 0xe7, 0x3c, 0xc3, 0x36,
	0x66, 0x18, 0x36, 0x66, 0xfc, 0x7e, 0x18, 0x66, 0xdb, 0x7c, 0x0 , 0x18,
	0x18, 0x18, 0xe , 0x70, 0xc0, 0x66, 0x38, 0x7c, 0x0 , 0x3c, 0x0 , 0xfe,
	0xc0, 0x66, 0x38, 0x0 , 0x30, 0xc , 0x38, 0x18, 0x0 , 0x0 , 0x0 , 0xc ,
	0xde, 0x18, 0xc , 0x6 , 0x6c, 0xc0, 0xc0, 0x18, 0xc6, 0xc6, 0xc , 0xc ,
	0x60, 0xfe, 0xc , 0xc , 0xde, 0xc6, 0x66, 0xc0, 0x66, 0x60, 0x60, 0xc0,
	0xc6, 0x18, 0x18, 0xf0, 0x60, 0xfe, 0xe6, 0xc6, 0x66, 0xc6, 0x66, 0x60,
	0x18, 0xc6, 0xc6, 0xd6, 0x38, 0x66, 0x18, 0x60, 0x60, 0xc , 0x0 , 0x0 ,
	0x0 , 0x78, 0x7c, 0x7c, 0x7c, 0x7c, 0x30, 0x76, 0x6c, 0x38, 0x1c, 0x66,
	0x18, 0x6c, 0xdc, 0x7c, 0xdc, 0x76, 0xdc, 0x7c, 0xfc, 0xcc, 0xc6, 0xc6,
	0xc6, 0xc6, 0xfe, 0x18, 0x18, 0x18, 0x0 , 0x38, 0xc0, 0xc6, 0x7c, 0x78,
	0x78, 0x78, 0x78, 0xc6, 0x7c, 0x7c, 0x7c, 0x38, 0x38, 0x38, 0x6c, 0x6c,
	0x60, 0xdb, 0xd8, 0x7c, 0x7c, 0x7c, 0xc6, 0xc6, 0xc6, 0xc6, 0xc6, 0x60,
	0x60, 0x18, 0xcc, 0x18, 0x78, 0x38, 0x7c, 0xcc, 0xbc, 0xc6, 0x0 , 0x0 ,
	0x30, 0x0 , 0x0 , 0x18, 0x18, 0x18, 0x6c, 0x6c, 0x44, 0xaa, 0x77, 0x18,
	0x18, 0xf8, 0x36, 0x0 , 0xf8, 0xf6, 0x36, 0xfe, 0xf6, 0x36, 0xf8, 0x0 ,
	0x18, 0x18, 0x0 , 0x18, 0x0 , 0x18, 0x1f, 0x36, 0x37, 0x3f, 0xf7, 0xff,
	0x37, 0xff, 0xf7, 0xff, 0x36, 0xff, 0x0 , 0x36, 0x1f, 0x1f, 0x0 , 0x36,
	0xff, 0x18, 0x0 , 0xff, 0x0 , 0xf0, 0xf , 0xff, 0xdc, 0xcc, 0x60, 0xfe,
	0x30, 0x7e, 0x66, 0x76, 0xc6, 0xc6, 0xc6, 0x3c, 0x7e, 0xde, 0x60, 0xc6,
	0xfe, 0x18, 0x6 , 0x60, 0x1a, 0x18, 0x0 , 0x76, 0x78, 0x0 , 0x0 , 0x18,
	0x6c, 0xf8, 0x7e,

	/*******	SCAN LINE #7  ********/
	0x0 , 0x81, 0xff, 0xfe, 0xfe, 0x6c, 0xfe, 0x3c, 0xc3, 0x66, 0x99, 0x78,
	0x3c, 0x18, 0x76, 0x66, 0xfe, 0xfe, 0x18, 0x66, 0x7b, 0xf6, 0x0 , 0x18,
	0x18, 0x18, 0xff, 0xfe, 0xc0, 0xff, 0x7c, 0x7c, 0x0 , 0x18, 0x0 , 0x6c,
	0x78, 0xc , 0x76, 0x0 , 0x30, 0xc , 0xfe, 0x7e, 0x0 , 0xfe, 0x0 , 0x18,
	0xf6, 0x18, 0x18, 0x3c, 0xcc, 0xfc, 0xfc, 0x30, 0x7c, 0x7e, 0x0 , 0x0 ,
	0xc0, 0x0 , 0x6 , 0x18, 0xde, 0xc6, 0x7c, 0xc0, 0x66, 0x7c, 0x7c, 0xc0,
	0xfe, 0x18, 0x18, 0xf0, 0x60, 0xd6, 0xf6, 0xc6, 0x7c, 0xc6, 0x7c, 0x38,
	0x18, 0xc6, 0xc6, 0xd6, 0x38, 0x3c, 0x30, 0x60, 0x30, 0xc , 0x0 , 0x0 ,
	0x0 , 0xc , 0x66, 0xc6, 0xcc, 0xc6, 0xfc, 0xce, 0x76, 0x18, 0xc , 0x6c,
	0x18, 0xfe, 0x66, 0xc6, 0x66, 0xcc, 0x66, 0xc6, 0x30, 0xcc, 0xc6, 0xc6,
	0x6c, 0xc6, 0x8c, 0x70, 0x0 , 0xe , 0x0 , 0x38, 0xc0, 0xc6, 0xc6, 0xc ,
	0xc , 0xc , 0xc , 0xc0, 0xc6, 0xc6, 0xc6, 0x18, 0x18, 0x18, 0xc6, 0xc6,
	0x60, 0x1b, 0xfe, 0xc6, 0xc6, 0xc6, 0xc6, 0xc6, 0xc6, 0xc6, 0xc6, 0x60,
	0xf0, 0x7e, 0xde, 0x7e, 0xc , 0x18, 0xc6, 0xcc, 0x66, 0xe6, 0x7e, 0x7c,
	0x30, 0x7e, 0x7e, 0x30, 0x36, 0x18, 0xd8, 0x36, 0x11, 0x55, 0xdd, 0x18,
	0x18, 0x18, 0x36, 0x0 , 0x18, 0x6 , 0x36, 0x6 , 0x6 , 0x36, 0x18, 0x0 ,
	0x18, 0x18, 0x0 , 0x18, 0x0 , 0x18, 0x18, 0x36, 0x30, 0x30, 0x0 , 0x0 ,
	0x30, 0x0 , 0x0 , 0x0 , 0x36, 0x0 , 0x0 , 0x36, 0x18, 0x18, 0x0 , 0x36,
	0x18, 0x18, 0x0 , 0xff, 0x0 , 0xf0, 0xf , 0xff, 0xd8, 0xd8, 0x60, 0x6c,
	0x18, 0xd8, 0x66, 0xdc, 0xc6, 0xfe, 0xc6, 0x66, 0xdb, 0xf6, 0x7c, 0xc6,
	0x0 , 0x7e, 0xc , 0x30, 0x18, 0x18, 0x7e, 0xdc, 0x0 , 0x18, 0x0 , 0x18,
	0x0 , 0x0 , 0x7e,

	/*******	SCAN LINE #8  ********/
	0x0 , 0xbd, 0xc3, 0xfe, 0x7c, 0xee, 0xfe, 0x3c, 0xc3, 0x66, 0x99, 0xcc,
	0x18, 0x18, 0xf6, 0x3c, 0xfc, 0x7e, 0x18, 0x66, 0x1b, 0xde, 0x0 , 0x7e,
	0x18, 0x18, 0xe , 0x70, 0xc0, 0x66, 0x7c, 0x38, 0x0 , 0x18, 0x0 , 0x6c,
	0x3c, 0x18, 0xf6, 0x0 , 0x30, 0xc , 0x38, 0x18, 0x0 , 0x0 , 0x0 , 0x30,
	0xe6, 0x18, 0x30, 0x6 , 0xfe, 0x6 , 0xc6, 0x30, 0xc6, 0x6 , 0x0 , 0x0 ,
	0x60, 0xfe, 0xc , 0x18, 0xde, 0xfe, 0x66, 0xc0, 0x66, 0x60, 0x60, 0xce,
	0xc6, 0x18, 0x18, 0xd8, 0x60, 0xd6, 0xde, 0xc6, 0x60, 0xc6, 0x78, 0xc ,
	0x18, 0xc6, 0xc6, 0xfe, 0x38, 0x18, 0x60, 0x60, 0x18, 0xc , 0x0 , 0x0 ,
	0x0 , 0x7c, 0x66, 0xc0, 0xcc, 0xfe, 0x30, 0xc6, 0x66, 0x18, 0xc , 0x78,
	0x18, 0xd6, 0x66, 0xc6, 0x66, 0xcc, 0x60, 0x70, 0x30, 0xcc, 0xc6, 0xd6,
	0x38, 0xc6, 0x18, 0x18, 0x18, 0x18, 0x0 , 0x6c, 0xc6, 0xc6, 0xfe, 0x7c,
	0x7c, 0x7c, 0x7c, 0xc0, 0xfe, 0xfe, 0xfe, 0x18, 0x18, 0x18, 0xfe, 0xc6,
	0x7c, 0x7f, 0xd8, 0xc6, 0xc6, 0xc6, 0xc6, 0xc6, 0xc6, 0xc6, 0xc6, 0x66,
	0x60, 0x18, 0xcc, 0x18, 0x7c, 0x18, 0xc6, 0xcc, 0x66, 0xf6, 0x0 , 0x0 ,
	0x60, 0x60, 0x6 , 0x60, 0x6e, 0x3c, 0x6c, 0x6c, 0x44, 0xaa, 0x77, 0x18,
	0xf8, 0xf8, 0xf6, 0xfe, 0xf8, 0xf6, 0x36, 0xf6, 0xfe, 0xfe, 0xf8, 0xf8,
	0x1f, 0xff, 0xff, 0x1f, 0xff, 0xff, 0x1f, 0x37, 0x3f, 0x37, 0xff, 0xf7,
	0x37, 0xff, 0xf7, 0xff, 0xff, 0xff, 0xff, 0x3f, 0x1f, 0x1f, 0x3f, 0xff,
	0xff, 0xf8, 0x1f, 0xff, 0xff, 0xf0, 0xf , 0x0 , 0xd8, 0xfc, 0x60, 0x6c,
	0x30, 0xcc, 0x66, 0x18, 0xc6, 0xc6, 0x6c, 0xc6, 0xdb, 0xe6, 0x60, 0xc6,
	0xfe, 0x18, 0x18, 0x18, 0x18, 0x18, 0x0 , 0x0 , 0x0 , 0x18, 0x18, 0x18,
	0x0 , 0x0 , 0x7e,

	/*******	SCAN LINE #9  ********/
	0x0 , 0x99, 0xe7, 0x7c, 0x38, 0x6c, 0x6c, 0x18, 0xe7, 0x3c, 0xc3, 0xcc,
	0x7e, 0x78, 0x66, 0x7e, 0xf0, 0x3e, 0x7e, 0x0 , 0x1b, 0x7c, 0xfe, 0x3c,
	0x18, 0x7e, 0xc , 0x30, 0xfe, 0x24, 0xfe, 0x38, 0x0 , 0x0 , 0x0 , 0xfe,
	0x6 , 0x30, 0xce, 0x0 , 0x30, 0xc , 0x6c, 0x18, 0xc , 0x0 , 0x0 , 0x60,
	0xc6, 0x18, 0x60, 0x6 , 0xc , 0x6 , 0xc6, 0x30, 0xc6, 0x6 , 0xc , 0xc ,
	0x30, 0x0 , 0x18, 0x0 , 0xdc, 0xc6, 0x66, 0xc0, 0x66, 0x60, 0x60, 0xc6,
	0xc6, 0x18, 0xd8, 0xcc, 0x62, 0xd6, 0xce, 0xc6, 0x60, 0xc6, 0x6c, 0x6 ,
	0x18, 0xc6, 0x6c, 0xee, 0x6c, 0x18, 0xc2, 0x60, 0xc , 0xc , 0x0 , 0x0 ,
	0x0 , 0xcc, 0x66, 0xc0, 0xcc, 0xc0, 0x30, 0xc6, 0x66, 0x18, 0xc , 0x6c,
	0x18, 0xd6, 0x66, 0xc6, 0x66, 0xcc, 0x60, 0x1c, 0x30, 0xcc, 0x6c, 0xd6,
	0x38, 0xce, 0x30, 0x18, 0x18, 0x18, 0x0 , 0x6c, 0x66, 0xc6, 0xc0, 0xcc,
	0xcc, 0xcc, 0xcc, 0xc6, 0xc0, 0xc0, 0xc0, 0x18, 0x18, 0x18, 0xc6, 0xfe,
	0x60, 0xd8, 0xd8, 0xc6, 0xc6, 0xc6, 0xc6, 0xc6, 0xce, 0xc6, 0xc6, 0x3c,
	0x66, 0x3c, 0xcc, 0x18, 0xcc, 0x18, 0xc6, 0xcc, 0x66, 0xde, 0x0 , 0x0 ,
	0xc6, 0x60, 0x6 , 0xdc, 0xde, 0x3c, 0x36, 0xd8, 0x11, 0x55, 0xdd, 0x18,
	0x18, 0x18, 0x36, 0x36, 0x18, 0x36, 0x36, 0x36, 0x0 , 0x0 , 0x0 , 0x18,
	0x0 , 0x0 , 0x18, 0x18, 0x0 , 0x18, 0x18, 0x36, 0x0 , 0x36, 0x0 , 0x36,
	0x36, 0x0 , 0x36, 0x0 , 0x0 , 0x18, 0x36, 0x0 , 0x0 , 0x18, 0x36, 0x36,
	0x18, 0x0 , 0x18, 0xff, 0xff, 0xf0, 0xf , 0x0 , 0xd8, 0xc6, 0x60, 0x6c,
	0x62, 0xcc, 0x7c, 0x18, 0x6c, 0xc6, 0x6c, 0xc6, 0x7e, 0x7c, 0x60, 0xc6,
	0x0 , 0x18, 0x30, 0xc , 0x18, 0x18, 0x18, 0x76, 0x0 , 0x0 , 0x0 , 0xd8,
	0x0 , 0x0 , 0x7e,

	/*******	SCAN LINE #10	********/
	0x0 , 0x81, 0xff, 0x38, 0x10, 0x10, 0x10, 0x0 , 0xff, 0x18, 0xe7, 0xcc,
	0x18, 0xf8, 0xe , 0xdb, 0xe0, 0xe , 0x3c, 0x66, 0x1b, 0xc , 0xfe, 0x18,
	0x18, 0x3c, 0x0 , 0x0 , 0x0 , 0x0 , 0xfe, 0x10, 0x0 , 0x18, 0x0 , 0x6c,
	0xc6, 0x66, 0xcc, 0x0 , 0x18, 0x18, 0x0 , 0x0 , 0xc , 0x0 , 0x18, 0xc0,
	0xc6, 0x18, 0xc6, 0xc6, 0xc , 0xc6, 0xc6, 0x30, 0xc6, 0xc6, 0xc , 0xc ,
	0x18, 0x0 , 0x30, 0x18, 0xc0, 0xc6, 0x66, 0x66, 0x6c, 0x66, 0x60, 0xc6,
	0xc6, 0x18, 0xd8, 0xc6, 0x66, 0xc6, 0xce, 0xc6, 0x60, 0xd6, 0x66, 0xc6,
	0x18, 0xc6, 0x38, 0xc6, 0xc6, 0x18, 0xc6, 0x60, 0x6 , 0xc , 0x0 , 0x0 ,
	0x0 , 0xdc, 0x66, 0xc6, 0xcc, 0xc6, 0x30, 0x7e, 0x66, 0x18, 0xc , 0x66,
	0x18, 0xc6, 0x66, 0xc6, 0x7c, 0x7c, 0x60, 0xc6, 0x36, 0xcc, 0x38, 0xfe,
	0x6c, 0x76, 0x62, 0x18, 0x18, 0x18, 0x0 , 0xfe, 0x3c, 0xce, 0xc6, 0xdc,
	0xdc, 0xdc, 0xdc, 0x7c, 0xc6, 0xc6, 0xc6, 0x18, 0x18, 0x18, 0xc6, 0xc6,
	0x60, 0xdf, 0xd8, 0xc6, 0xc6, 0xc6, 0xce, 0xce, 0x76, 0xc6, 0xc6, 0x18,
	0xf6, 0x18, 0xcc, 0x18, 0xdc, 0x18, 0xc6, 0xdc, 0x66, 0xce, 0x0 , 0x0 ,
	0xc6, 0x60, 0x6 , 0x36, 0x36, 0x3c, 0x0 , 0x0 , 0x44, 0xaa, 0x77, 0x18,
	0x18, 0x18, 0x36, 0x36, 0x18, 0x36, 0x36, 0x36, 0x0 , 0x0 , 0x0 , 0x18,
	0x0 , 0x0 , 0x18, 0x18, 0x0 , 0x18, 0x18, 0x36, 0x0 , 0x36, 0x0 , 0x36,
	0x36, 0x0 , 0x36, 0x0 , 0x0 , 0x18, 0x36, 0x0 , 0x0 , 0x18, 0x36, 0x36,
	0x18, 0x0 , 0x18, 0xff, 0xff, 0xf0, 0xf , 0x0 , 0xdc, 0xe6, 0x60, 0x6c,
	0xc6, 0xcc, 0x60, 0x18, 0x38, 0x6c, 0x6c, 0xcc, 0x0 , 0x60, 0x30, 0xc6,
	0xfe, 0x0 , 0x0 , 0x0 , 0x18, 0x58, 0x18, 0xdc, 0x0 , 0x0 , 0x0 , 0x78,
	0x0 , 0x0 , 0x7e,

	/*******	SCAN LINE #11	********/
	0x0 , 0x7e, 0x7e, 0x10, 0x0 , 0x38, 0x38, 0x0 , 0xff, 0x0 , 0xff, 0x78,
	0x18, 0x70, 0x1e, 0x18, 0x80, 0x2 , 0x18, 0x66, 0x1b, 0xc6, 0xfe, 0x7e,
	0x18, 0x18, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x18, 0x0 , 0x6c,
	0x7c, 0xc6, 0x76, 0x0 , 0xc , 0x30, 0x0 , 0x0 , 0xc , 0x0 , 0x18, 0x80,
	0x7c, 0x7e, 0xfe, 0x7c, 0xc , 0x7c, 0x7c, 0x30, 0x7c, 0x7c, 0x0 , 0xc ,
	0xc , 0x0 , 0x60, 0x18, 0x7e, 0xc6, 0xfc, 0x3c, 0xf8, 0xfe, 0xf0, 0x7c,
	0xc6, 0x3c, 0x70, 0xc6, 0xfe, 0xc6, 0xc6, 0x7c, 0xf0, 0x7c, 0xe6, 0x7c,
	0x3c, 0x7c, 0x10, 0xc6, 0xc6, 0x3c, 0xfe, 0x7c, 0x2 , 0x7c, 0x0 , 0x0 ,
	0x0 , 0x76, 0xfc, 0x7c, 0x7e, 0x7c, 0x78, 0x6 , 0xe6, 0x3c, 0xcc, 0xe6,
	0x3c, 0xc6, 0x66, 0x7c, 0x60, 0xc , 0xf0, 0x7c, 0x1c, 0x76, 0x10, 0x6c,
	0xc6, 0x6 , 0xfe, 0xe , 0x18, 0x70, 0x0 , 0x0 , 0x18, 0x76, 0x7c, 0x76,
	0x76, 0x76, 0x76, 0x18, 0x7c, 0x7c, 0x7c, 0x3c, 0x3c, 0x3c, 0xc6, 0xc6,
	0xfe, 0x76, 0xde, 0x7c, 0x7c, 0x7c, 0x76, 0x76, 0x6 , 0x7c, 0x7c, 0x18,
	0x6c, 0x18, 0xc6, 0x18, 0x76, 0x3c, 0x7c, 0x76, 0xe6, 0xc6, 0x0 , 0x0 ,
	0x7c, 0x0 , 0x0 , 0xc , 0x7e, 0x18, 0x0 , 0x0 , 0x11, 0x55, 0xdd, 0x18,
	0x18, 0x18, 0x36, 0x36, 0x18, 0x36, 0x36, 0x36, 0x0 , 0x0 , 0x0 , 0x18,
	0x0 , 0x0 , 0x18, 0x18, 0x0 , 0x18, 0x18, 0x36, 0x0 , 0x36, 0x0 , 0x36,
	0x36, 0x0 , 0x36, 0x0 , 0x0 , 0x18, 0x36, 0x0 , 0x0 , 0x18, 0x36, 0x36,
	0x18, 0x0 , 0x18, 0xff, 0xff, 0xf0, 0xf , 0x0 , 0x76, 0xdc, 0x60, 0x6c,
	0xfe, 0x78, 0xc0, 0x18, 0xfe, 0x38, 0xee, 0x78, 0x0 , 0xc0, 0x1c, 0xc6,
	0x0 , 0x7e, 0x7e, 0x7e, 0x18, 0x78, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x38,
	0x0 , 0x0 , 0x0 ,

	/*******	SCAN LINE #12	********/
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0xff, 0x0 , 0xff, 0x0 ,
	0x0 , 0x0 , 0xc , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0xc6, 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x18, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x18, 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x18,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x6 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0xc6, 0x0 , 0x0 , 0xcc, 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x60, 0xc , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0xc6, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0xcc, 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x6c, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0xc6, 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0xd8, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x18, 0x6 , 0x0 , 0x0 , 0x0 , 0x44, 0xaa, 0x77, 0x18,
	0x18, 0x18, 0x36, 0x36, 0x18, 0x36, 0x36, 0x36, 0x0 , 0x0 , 0x0 , 0x18,
	0x0 , 0x0 , 0x18, 0x18, 0x0 , 0x18, 0x18, 0x36, 0x0 , 0x36, 0x0 , 0x36,
	0x36, 0x0 , 0x36, 0x0 , 0x0 , 0x18, 0x36, 0x0 , 0x0 , 0x18, 0x36, 0x36,
	0x18, 0x0 , 0x18, 0xff, 0xff, 0xf0, 0xf , 0x0 , 0x0 , 0xc0, 0x0 , 0x0 ,
	0x0 , 0x0 , 0x80, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x18, 0x30, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x18,
	0x0 , 0x0 , 0x0 ,

	/*******	SCAN LINE #13	********/
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0xff, 0x0 , 0xff, 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x7c, 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x18, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0xff,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x7c, 0x0 , 0x0 , 0x78, 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0xf0, 0x1e, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x7c, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x38, 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x38, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x7c, 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x70, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x3e, 0x6 , 0x0 , 0x0 , 0x0 , 0x11, 0x55, 0xdd, 0x18,
	0x18, 0x18, 0x36, 0x36, 0x18, 0x36, 0x36, 0x36, 0x0 , 0x0 , 0x0 , 0x18,
	0x0 , 0x0 , 0x18, 0x18, 0x0 , 0x18, 0x18, 0x36, 0x0 , 0x36, 0x0 , 0x36,
	0x36, 0x0 , 0x36, 0x0 , 0x0 , 0x18, 0x36, 0x0 , 0x0 , 0x18, 0x36, 0x36,
	0x18, 0x0 , 0x18, 0xff, 0xff, 0xf0, 0xf , 0x0 , 0x0 , 0xc0, 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x18, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 ,

	/*******	SCAN LINE #14	********/
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0xff, 0x0 , 0xff, 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x44, 0xaa, 0x77, 0x18,
	0x18, 0x18, 0x36, 0x36, 0x18, 0x36, 0x36, 0x36, 0x0 , 0x0 , 0x0 , 0x18,
	0x0 , 0x0 , 0x18, 0x18, 0x0 , 0x18, 0x18, 0x36, 0x0 , 0x36, 0x0 , 0x36,
	0x36, 0x0 , 0x36, 0x0 , 0x0 , 0x18, 0x36, 0x0 , 0x0 , 0x18, 0x36, 0x36,
	0x18, 0x0 , 0x18, 0xff, 0xff, 0xf0, 0xf , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x18, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0
    };


LOCAL UWORD rom_8x16_offset_table[] = {
	0x0	 , 0x8   , 0x10  , 0x18	, 0x20  , 0x28  , 0x30  , 0x38  ,
	0x40  , 0x48  , 0x50  , 0x58	, 0x60  , 0x68  , 0x70  , 0x78  ,
	0x80  , 0x88  , 0x90  , 0x98	, 0xa0  , 0xa8  , 0xb0  , 0xb8  ,
	0xc0  , 0xc8  , 0xd0  , 0xd8	, 0xe0  , 0xe8  , 0xf0  , 0xf8  ,
	0x100 , 0x108 , 0x110 , 0x118 , 0x120 , 0x128 , 0x130 , 0x138 ,
	0x140 , 0x148 , 0x150 , 0x158 , 0x160 , 0x168 , 0x170 , 0x178 ,
	0x180 , 0x188 , 0x190 , 0x198 , 0x1a0 , 0x1a8 , 0x1b0 , 0x1b8 ,
	0x1c0 , 0x1c8 , 0x1d0 , 0x1d8 , 0x1e0 , 0x1e8 , 0x1f0 , 0x1f8 ,
	0x200 , 0x208 , 0x210 , 0x218 , 0x220 , 0x228 , 0x230 , 0x238 ,
	0x240 , 0x248 , 0x250 , 0x258 , 0x260 , 0x268 , 0x270 , 0x278 ,
	0x280 , 0x288 , 0x290 , 0x298 , 0x2a0 , 0x2a8 , 0x2b0 , 0x2b8 ,
	0x2c0 , 0x2c8 , 0x2d0 , 0x2d8 , 0x2e0 , 0x2e8 , 0x2f0 , 0x2f8 ,
	0x300 , 0x308 , 0x310 , 0x318 , 0x320 , 0x328 , 0x330 , 0x338 ,
	0x340 , 0x348 , 0x350 , 0x358 , 0x360 , 0x368 , 0x370 , 0x378 ,
	0x380 , 0x388 , 0x390 , 0x398 , 0x3a0 , 0x3a8 , 0x3b0 , 0x3b8 ,
	0x3c0 , 0x3c8 , 0x3d0 , 0x3d8 , 0x3e0 , 0x3e8 , 0x3f0 , 0x3f8 ,
	0x400 , 0x408 , 0x410 , 0x418 , 0x420 , 0x428 , 0x430 , 0x438 ,
	0x440 , 0x448 , 0x450 , 0x458 , 0x460 , 0x468 , 0x470 , 0x478 ,
	0x480 , 0x488 , 0x490 , 0x498 , 0x4a0 , 0x4a8 , 0x4b0 , 0x4b8 ,
	0x4c0 , 0x4c8 , 0x4d0 , 0x4d8 , 0x4e0 , 0x4e8 , 0x4f0 , 0x4f8 ,
	0x500 , 0x508 , 0x510 , 0x518 , 0x520 , 0x528 , 0x530 , 0x538 ,
	0x540 , 0x548 , 0x550 , 0x558 , 0x560 , 0x568 , 0x570 , 0x578 ,
	0x580 , 0x588 , 0x590 , 0x598 , 0x5a0 , 0x5a8 , 0x5b0 , 0x5b8 ,
	0x5c0 , 0x5c8 , 0x5d0 , 0x5d8 , 0x5e0 , 0x5e8 , 0x5f0 , 0x5f8 ,
	0x600 , 0x608 , 0x610 , 0x618 , 0x620 , 0x628 , 0x630 , 0x638 ,
	0x640 , 0x648 , 0x650 , 0x658 , 0x660 , 0x668 , 0x670 , 0x678 ,
	0x680 , 0x688 , 0x690 , 0x698 , 0x6a0 , 0x6a8 , 0x6b0 , 0x6b8 ,
	0x6c0 , 0x6c8 , 0x6d0 , 0x6d8 , 0x6e0 , 0x6e8 , 0x6f0 , 0x6f8 ,
	0x700 , 0x708 , 0x710 , 0x718 , 0x720 , 0x728 , 0x730 , 0x738 ,
	0x740 , 0x748 , 0x750 , 0x758 , 0x760 , 0x768 , 0x770 , 0x778 ,
	0x780 , 0x788 , 0x790 , 0x798 , 0x7a0 , 0x7a8 , 0x7b0 , 0x7b8 ,
	0x7c0 , 0x7c8 , 0x7d0 , 0x7d8 , 0x7e0 , 0x7e8 , 0x7f0 , 0x0   ,
	0x0
    };


LOCAL UTINY rom_8x16_data_table[] = {

	/*******	SCAN LINE #1  ********/
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0xff, 0x0 , 0xff, 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x38,
	0xc , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x11, 0xaa, 0xdd, 0x18,
	0x18, 0x18, 0x36, 0x0 , 0x0 , 0x36, 0x36, 0x0 , 0x36, 0x36, 0x18, 0x0 ,
	0x18, 0x18, 0x0 , 0x18, 0x0 , 0x18, 0x18, 0x36, 0x36, 0x0 , 0x36, 0x0 ,
	0x36, 0x0 , 0x36, 0x18, 0x36, 0x0 , 0x0 , 0x36, 0x18, 0x0 , 0x0 , 0x36,
	0x18, 0x18, 0x0 , 0xff, 0x0 , 0xf0, 0xf , 0xff, 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x18, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 ,

	/*******	SCAN LINE #2  ********/
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0xff, 0x0 , 0xff, 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x36, 0x0 ,
	0x0 , 0x0 , 0x0 , 0xc , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x10, 0x0 ,
	0x18, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0xc , 0x30,
	0x0 , 0x60, 0x38, 0x0 , 0x30, 0x0 , 0x30, 0x0 , 0x18, 0x60, 0xc6, 0x6c,
	0x18, 0x0 , 0x0 , 0x30, 0x0 , 0x30, 0x30, 0x60, 0xc6, 0xc6, 0xc6, 0x0 ,
	0x38, 0x66, 0xfc, 0xe , 0xc , 0xc , 0xc , 0x18, 0x0 , 0x76, 0x3c, 0x38,
	0x0 , 0x0 , 0x0 , 0x60, 0x60, 0x0 , 0x0 , 0x0 , 0x44, 0x55, 0x77, 0x18,
	0x18, 0x18, 0x36, 0x0 , 0x0 , 0x36, 0x36, 0x0 , 0x36, 0x36, 0x18, 0x0 ,
	0x18, 0x18, 0x0 , 0x18, 0x0 , 0x18, 0x18, 0x36, 0x36, 0x0 , 0x36, 0x0 ,
	0x36, 0x0 , 0x36, 0x18, 0x36, 0x0 , 0x0 , 0x36, 0x18, 0x0 , 0x0 , 0x36,
	0x18, 0x18, 0x0 , 0xff, 0x0 , 0xf0, 0xf , 0xff, 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x18, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 ,

	/*******	SCAN LINE #3  ********/
	0x0 , 0x7e, 0x7c, 0x0 , 0x0 , 0x0 , 0x10, 0x0 , 0xff, 0x0 , 0xff, 0x1e,
	0x3c, 0x1e, 0x3e, 0x18, 0x0 , 0x0 , 0x18, 0x66, 0x7f, 0x7c, 0x0 , 0x18,
	0x18, 0x18, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x18, 0x36, 0x6c,
	0x18, 0x0 , 0x38, 0xc , 0xc , 0x30, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x7c, 0x18, 0x7c, 0x7c, 0xc , 0xfe, 0x7c, 0xfe, 0x7c, 0x7c, 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x7c, 0x7c, 0x38, 0xfc, 0x3c, 0xf8, 0xfe, 0xfe, 0x7c,
	0xc6, 0x3c, 0x3c, 0xc6, 0xf0, 0xc6, 0xc6, 0x7c, 0xfc, 0x7c, 0xfc, 0x7c,
	0x7e, 0xc6, 0xc6, 0xc6, 0xc6, 0x66, 0xfe, 0x7c, 0x0 , 0x7c, 0x38, 0x0 ,
	0x18, 0x0 , 0xe0, 0x0 , 0x1c, 0x0 , 0x1c, 0x0 , 0xe0, 0x18, 0xc , 0xe0,
	0x38, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x30, 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0xe , 0x18, 0x70, 0x76, 0x0 , 0x3c, 0xc6, 0x18, 0x78,
	0xcc, 0x30, 0x6c, 0x0 , 0x78, 0xcc, 0x18, 0x66, 0x3c, 0x30, 0xc6, 0x38,
	0x30, 0x0 , 0x7e, 0x78, 0xc6, 0x18, 0x78, 0x30, 0xc6, 0xc6, 0xc6, 0x18,
	0x6c, 0x66, 0xc6, 0x1b, 0x18, 0x18, 0x18, 0x30, 0x76, 0xdc, 0x6c, 0x6c,
	0x30, 0x0 , 0x0 , 0x60, 0x60, 0x18, 0x0 , 0x0 , 0x11, 0xaa, 0xdd, 0x18,
	0x18, 0x18, 0x36, 0x0 , 0x0 , 0x36, 0x36, 0x0 , 0x36, 0x36, 0x18, 0x0 ,
	0x18, 0x18, 0x0 , 0x18, 0x0 , 0x18, 0x18, 0x36, 0x36, 0x0 , 0x36, 0x0 ,
	0x36, 0x0 , 0x36, 0x18, 0x36, 0x0 , 0x0 , 0x36, 0x18, 0x0 , 0x0 , 0x36,
	0x18, 0x18, 0x0 , 0xff, 0x0 , 0xf0, 0xf , 0xff, 0x0 , 0x0 , 0xfe, 0x0 ,
	0xfe, 0x0 , 0x0 , 0x0 , 0xfe, 0x0 , 0x38, 0x3e, 0x0 , 0x2 , 0x0 , 0x7c,
	0x0 , 0x0 , 0x30, 0xc , 0x0 , 0x18, 0x0 , 0x0 , 0x78, 0x0 , 0x0 , 0x1f,
	0xd8, 0x70, 0x0 ,

	/*******	SCAN LINE #4  ********/
	0x0 , 0x81, 0xfe, 0x6c, 0x10, 0x10, 0x38, 0x0 , 0xff, 0x0 , 0xff, 0xe ,
	0x66, 0x1a, 0x36, 0xdb, 0x80, 0x2 , 0x3c, 0x66, 0xdb, 0xc6, 0x0 , 0x3c,
	0x3c, 0x18, 0x0 , 0x0 , 0x0 , 0x0 , 0x10, 0xfe, 0x0 , 0x3c, 0x36, 0x6c,
	0x18, 0x0 , 0x6c, 0xc , 0x18, 0x18, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0xc6, 0x78, 0xc6, 0xc6, 0x1c, 0xc0, 0xc6, 0xc6, 0xc6, 0xc6, 0x0 , 0x0 ,
	0xc , 0x0 , 0x60, 0xc6, 0xc6, 0x6c, 0x66, 0x66, 0x6c, 0x66, 0x66, 0xc6,
	0xc6, 0x18, 0x18, 0xc6, 0x60, 0xc6, 0xc6, 0xc6, 0x66, 0xc6, 0x66, 0xc6,
	0x5a, 0xc6, 0xc6, 0xc6, 0xc6, 0x66, 0xc6, 0x60, 0x0 , 0xc , 0x6c, 0x0 ,
	0x18, 0x0 , 0x60, 0x0 , 0xc , 0x0 , 0x36, 0x0 , 0x60, 0x18, 0xc , 0x60,
	0x18, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x30, 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x18, 0x18, 0x18, 0xdc, 0x0 , 0x66, 0xc6, 0x30, 0xcc,
	0xcc, 0x18, 0x38, 0x0 , 0xcc, 0xcc, 0xc , 0x66, 0x66, 0x18, 0x0 , 0x0 ,
	0x0 , 0x0 , 0xd8, 0xcc, 0xc6, 0xc , 0xcc, 0x18, 0x0 , 0x0 , 0x0 , 0x18,
	0x60, 0x66, 0xc6, 0x18, 0x30, 0x30, 0x30, 0x60, 0xdc, 0x0 , 0x6c, 0x6c,
	0x30, 0x0 , 0x0 , 0x62, 0x62, 0x18, 0x0 , 0x0 , 0x44, 0x55, 0x77, 0x18,
	0x18, 0x18, 0x36, 0x0 , 0x0 , 0x36, 0x36, 0x0 , 0x36, 0x36, 0x18, 0x0 ,
	0x18, 0x18, 0x0 , 0x18, 0x0 , 0x18, 0x18, 0x36, 0x36, 0x0 , 0x36, 0x0 ,
	0x36, 0x0 , 0x36, 0x18, 0x36, 0x0 , 0x0 , 0x36, 0x18, 0x0 , 0x0 , 0x36,
	0x18, 0x18, 0x0 , 0xff, 0x0 , 0xf0, 0xf , 0xff, 0x0 , 0x0 , 0x66, 0x0 ,
	0xc6, 0x0 , 0x0 , 0x0 , 0x38, 0x38, 0x6c, 0x60, 0x0 , 0x6 , 0x1c, 0xc6,
	0x0 , 0x0 , 0x18, 0x18, 0x0 , 0x18, 0x0 , 0x0 , 0xcc, 0x0 , 0x0 , 0x18,
	0x6c, 0xd8, 0x0 ,

	/*******	SCAN LINE #5  ********/
	0x0 , 0xa5, 0xfe, 0xee, 0x38, 0x38, 0x7c, 0x0 , 0xff, 0x18, 0xe7, 0x1e,
	0x66, 0x1e, 0x3e, 0x7e, 0xe0, 0xe , 0x7e, 0x66, 0xdb, 0xc6, 0x0 , 0x7e,
	0x7e, 0x18, 0x0 , 0x0 , 0x0 , 0x0 , 0x38, 0xfe, 0x0 , 0x3c, 0x36, 0x6c,
	0x7c, 0x0 , 0x38, 0x18, 0x30, 0xc , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x2 ,
	0xc6, 0x18, 0xc6, 0x6 , 0x3c, 0xc0, 0xc0, 0x6 , 0xc6, 0xc6, 0x0 , 0x0 ,
	0x18, 0x0 , 0x30, 0xc6, 0xc6, 0xc6, 0x66, 0xc2, 0x66, 0x60, 0x60, 0xc6,
	0xc6, 0x18, 0x18, 0xcc, 0x60, 0xee, 0xe6, 0xc6, 0x66, 0xc6, 0x66, 0xc0,
	0x18, 0xc6, 0xc6, 0xc6, 0xc6, 0x66, 0x86, 0x60, 0x80, 0xc , 0xc6, 0x0 ,
	0xc , 0x0 , 0x60, 0x0 , 0xc , 0x0 , 0x30, 0x0 , 0x60, 0x0 , 0x0 , 0x60,
	0x18, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x30, 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x18, 0x18, 0x18, 0x0 , 0x0 , 0xc0, 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x7c, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x38, 0x38,
	0xfe, 0x66, 0xd8, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0xc6, 0x7c, 0xc6, 0x7c,
	0x60, 0x66, 0xfc, 0x18, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0xc6, 0x3e, 0x38,
	0x0 , 0x0 , 0x0 , 0x66, 0x66, 0x0 , 0x0 , 0x0 , 0x11, 0xaa, 0xdd, 0x18,
	0x18, 0x18, 0x36, 0x0 , 0x0 , 0x36, 0x36, 0x0 , 0x36, 0x36, 0x18, 0x0 ,
	0x18, 0x18, 0x0 , 0x18, 0x0 , 0x18, 0x18, 0x36, 0x36, 0x0 , 0x36, 0x0 ,
	0x36, 0x0 , 0x36, 0x18, 0x36, 0x0 , 0x0 , 0x36, 0x18, 0x0 , 0x0 , 0x36,
	0x18, 0x18, 0x0 , 0xff, 0x0 , 0xf0, 0xf , 0xff, 0x76, 0x78, 0x62, 0x0 ,
	0x62, 0x0 , 0x66, 0x0 , 0x38, 0x6c, 0xc6, 0x60, 0x0 , 0x7c, 0x30, 0xc6,
	0xfe, 0x18, 0xc , 0x30, 0xc , 0x18, 0x18, 0x0 , 0xcc, 0x0 , 0x0 , 0x18,
	0x6c, 0x18, 0x0 ,

	/*******	SCAN LINE #6  ********/
	0x0 , 0x81, 0xd6, 0xfe, 0x7c, 0x38, 0x7c, 0x18, 0xe7, 0x3c, 0xc3, 0x36,
	0x66, 0x18, 0x36, 0x3c, 0xf0, 0x3e, 0x18, 0x66, 0xdb, 0x60, 0x0 , 0x18,
	0x18, 0x18, 0xc , 0x30, 0x0 , 0x24, 0x38, 0x7c, 0x0 , 0x3c, 0x14, 0xfe,
	0xc6, 0x62, 0x30, 0x0 , 0x30, 0xc , 0x6c, 0x18, 0x0 , 0x0 , 0x0 , 0x6 ,
	0xce, 0x18, 0x6 , 0x6 , 0x6c, 0xc0, 0xc0, 0xc , 0xc6, 0xc6, 0xc , 0xc ,
	0x30, 0x0 , 0x18, 0xc , 0xc6, 0xc6, 0x66, 0xc0, 0x66, 0x64, 0x64, 0xc0,
	0xc6, 0x18, 0x18, 0xd8, 0x60, 0xee, 0xe6, 0xc6, 0x66, 0xc6, 0x66, 0xc0,
	0x18, 0xc6, 0xc6, 0xd6, 0x6c, 0x66, 0xc , 0x60, 0xc0, 0xc , 0x0 , 0x0 ,
	0x0 , 0x78, 0x7c, 0x7c, 0x7c, 0x7c, 0x30, 0x76, 0x7c, 0x38, 0x1c, 0x66,
	0x18, 0x6c, 0xdc, 0x7c, 0xdc, 0x76, 0xdc, 0x7c, 0xfc, 0xcc, 0xc6, 0xc6,
	0xc6, 0xc6, 0xfe, 0x18, 0x18, 0x18, 0x0 , 0x10, 0xc0, 0xc6, 0x7c, 0x78,
	0x78, 0x78, 0x78, 0xc6, 0x7c, 0x7c, 0x7c, 0x38, 0x38, 0x38, 0x6c, 0x6c,
	0x60, 0xdb, 0xd8, 0x7c, 0x7c, 0x7c, 0xc6, 0xc6, 0xc6, 0xc6, 0xc6, 0xc6,
	0xf0, 0x3c, 0xc0, 0x18, 0x78, 0x38, 0x7c, 0xcc, 0xbc, 0xc6, 0x0 , 0x0 ,
	0x30, 0x0 , 0x0 , 0x6c, 0x6c, 0x18, 0x36, 0xd8, 0x44, 0x55, 0x77, 0x18,
	0x18, 0x18, 0x36, 0x0 , 0x0 , 0x36, 0x36, 0x0 , 0x36, 0x36, 0x18, 0x0 ,
	0x18, 0x18, 0x0 , 0x18, 0x0 , 0x18, 0x18, 0x36, 0x36, 0x0 , 0x36, 0x0 ,
	0x36, 0x0 , 0x36, 0x18, 0x36, 0x0 , 0x0 , 0x36, 0x18, 0x0 , 0x0 , 0x36,
	0x18, 0x18, 0x0 , 0xff, 0x0 , 0xf0, 0xf , 0xff, 0xdc, 0xcc, 0x60, 0xfe,
	0x30, 0x7e, 0x66, 0x76, 0x6c, 0xc6, 0xc6, 0x3c, 0x7e, 0xce, 0x60, 0xc6,
	0x0 , 0x18, 0x6 , 0x60, 0x1e, 0x18, 0x18, 0x0 , 0x78, 0x0 , 0x0 , 0x18,
	0x6c, 0x30, 0x7e,

	/*******	SCAN LINE #7  ********/
	0x0 , 0x81, 0xfe, 0xfe, 0xfe, 0x10, 0xfe, 0x3c, 0xc3, 0x66, 0x99, 0x78,
	0x3c, 0x18, 0x36, 0x66, 0xfc, 0x7e, 0x18, 0x66, 0xdb, 0x7c, 0x0 , 0x18,
	0x18, 0x18, 0xe , 0x70, 0xc0, 0x66, 0x38, 0x7c, 0x0 , 0x3c, 0x0 , 0x6c,
	0xc0, 0x66, 0x76, 0x0 , 0x30, 0xc , 0x38, 0x18, 0x0 , 0x0 , 0x0 , 0xc ,
	0xde, 0x18, 0xc , 0x3c, 0xcc, 0xfc, 0xfc, 0x18, 0x7c, 0xc6, 0xc , 0xc ,
	0x60, 0xfe, 0xc , 0x18, 0xde, 0xc6, 0x7c, 0xc0, 0x66, 0x7c, 0x7c, 0xc0,
	0xfe, 0x18, 0x18, 0xf0, 0x60, 0xfe, 0xf6, 0xc6, 0x66, 0xc6, 0x7c, 0x70,
	0x18, 0xc6, 0xc6, 0xd6, 0x38, 0x66, 0x18, 0x60, 0x60, 0xc , 0x0 , 0x0 ,
	0x0 , 0xc , 0x66, 0xc6, 0xcc, 0xc6, 0xfc, 0xce, 0x66, 0x18, 0xc , 0x66,
	0x18, 0xfe, 0x66, 0xc6, 0x66, 0xcc, 0x66, 0xc6, 0x30, 0xcc, 0xc6, 0xc6,
	0xc6, 0xc6, 0x86, 0x70, 0x0 , 0xe , 0x0 , 0x38, 0xc0, 0xc6, 0xc6, 0xc ,
	0xc , 0xc , 0xc , 0xc0, 0xc6, 0xc6, 0xc6, 0x18, 0x18, 0x18, 0xc6, 0xc6,
	0x60, 0x1b, 0xd8, 0xc6, 0xc6, 0xc6, 0xc6, 0xc6, 0xc6, 0xc6, 0xc6, 0xc0,
	0x60, 0x18, 0xcc, 0x7e, 0xc , 0x18, 0xc6, 0xcc, 0x66, 0xe6, 0x7e, 0x7c,
	0x30, 0x0 , 0x0 , 0x18, 0x18, 0x18, 0x6c, 0x6c, 0x11, 0xaa, 0xdd, 0x18,
	0x18, 0xf8, 0x36, 0x0 , 0xf8, 0xf6, 0x36, 0xfe, 0xf6, 0x36, 0xf8, 0x0 ,
	0x18, 0x18, 0x0 , 0x18, 0x0 , 0x18, 0x1f, 0x36, 0x37, 0x3f, 0xf7, 0xff,
	0x37, 0xff, 0xf7, 0xff, 0x36, 0xff, 0x0 , 0x36, 0x1f, 0x1f, 0x0 , 0x36,
	0xff, 0x18, 0x0 , 0xff, 0x0 , 0xf0, 0xf , 0xff, 0xd8, 0xd8, 0x60, 0x6c,
	0x18, 0xd8, 0x66, 0xdc, 0xc6, 0xc6, 0xc6, 0x66, 0xdb, 0xde, 0x60, 0xc6,
	0x0 , 0x7e, 0xc , 0x30, 0x1a, 0x18, 0x0 , 0x76, 0x0 , 0x0 , 0x0 , 0x18,
	0x6c, 0x60, 0x7e,

	/*******	SCAN LINE #8  ********/
	0x0 , 0xbd, 0xfe, 0xfe, 0x7c, 0x6c, 0xfe, 0x3c, 0xc3, 0x66, 0x99, 0xcc,
	0x18, 0x18, 0x76, 0x66, 0xfe, 0xfe, 0x18, 0x66, 0x7b, 0xf6, 0x0 , 0x18,
	0x18, 0x18, 0xff, 0xfe, 0xc0, 0xff, 0x7c, 0x7c, 0x0 , 0x18, 0x0 , 0x6c,
	0x78, 0xc , 0x7e, 0x0 , 0x30, 0xc , 0xfe, 0x7e, 0x0 , 0xfe, 0x0 , 0x18,
	0xf6, 0x18, 0x18, 0x6 , 0xcc, 0x6 , 0xc6, 0x30, 0xc6, 0x7e, 0x0 , 0x0 ,
	0xc0, 0x0 , 0x6 , 0x18, 0xde, 0xfe, 0x66, 0xc0, 0x66, 0x64, 0x64, 0xc0,
	0xc6, 0x18, 0x18, 0xf0, 0x60, 0xd6, 0xde, 0xc6, 0x7c, 0xc6, 0x78, 0x1c,
	0x18, 0xc6, 0xc6, 0xd6, 0x38, 0x3c, 0x30, 0x60, 0x30, 0xc , 0x0 , 0x0 ,
	0x0 , 0x7c, 0x66, 0xc0, 0xcc, 0xc6, 0x30, 0xc6, 0x66, 0x18, 0xc , 0x6c,
	0x18, 0xd6, 0x66, 0xc6, 0x66, 0xcc, 0x60, 0xc0, 0x30, 0xcc, 0xc6, 0xd6,
	0x6c, 0xc6, 0xc , 0x18, 0x18, 0x18, 0x0 , 0x38, 0xc6, 0xc6, 0xc6, 0x7c,
	0x7c, 0x7c, 0x7c, 0xc0, 0xc6, 0xc6, 0xc6, 0x18, 0x18, 0x18, 0xc6, 0xc6,
	0x7c, 0x7f, 0xfe, 0xc6, 0xc6, 0xc6, 0xc6, 0xc6, 0xc6, 0xc6, 0xc6, 0xc0,
	0x60, 0x7e, 0xde, 0x18, 0x7c, 0x18, 0xc6, 0xcc, 0x66, 0xf6, 0x0 , 0x0 ,
	0x30, 0x7e, 0x7e, 0x30, 0x36, 0x3c, 0xd8, 0x36, 0x44, 0x55, 0x77, 0x18,
	0x18, 0x18, 0x36, 0x0 , 0x18, 0x6 , 0x36, 0x6 , 0x6 , 0x36, 0x18, 0x0 ,
	0x18, 0x18, 0x0 , 0x18, 0x0 , 0x18, 0x18, 0x36, 0x30, 0x30, 0x0 , 0x0 ,
	0x30, 0x0 , 0x0 , 0x0 , 0x36, 0x0 , 0x0 , 0x36, 0x18, 0x18, 0x0 , 0x36,
	0x18, 0x18, 0x0 , 0xff, 0x0 , 0xf0, 0xf , 0xff, 0xd8, 0xfc, 0x60, 0x6c,
	0x18, 0xcc, 0x66, 0x18, 0xc6, 0xfe, 0xc6, 0xc6, 0xdb, 0xf6, 0x7c, 0xc6,
	0xfe, 0x18, 0x18, 0x18, 0x18, 0x18, 0x7e, 0xdc, 0x0 , 0x18, 0x0 , 0x18,
	0x6c, 0xf8, 0x7e,

	/*******	SCAN LINE #9  ********/
	0x0 , 0x99, 0xba, 0xfe, 0x38, 0xee, 0xfe, 0x3c, 0xc3, 0x66, 0x99, 0xcc,
	0x7e, 0x18, 0xf6, 0x3c, 0xfc, 0x7e, 0x18, 0x66, 0x1b, 0xde, 0xfe, 0x7e,
	0x18, 0x18, 0xe , 0x70, 0xc0, 0x66, 0x7c, 0x38, 0x0 , 0x18, 0x0 , 0xfe,
	0x3c, 0x18, 0xcc, 0x0 , 0x30, 0xc , 0x38, 0x18, 0x0 , 0x0 , 0x0 , 0x30,
	0xe6, 0x18, 0x30, 0x6 , 0xfe, 0x6 , 0xc6, 0x30, 0xc6, 0x6 , 0x0 , 0x0 ,
	0x60, 0xfe, 0xc , 0x18, 0xde, 0xc6, 0x66, 0xc0, 0x66, 0x60, 0x60, 0xce,
	0xc6, 0x18, 0x18, 0xd8, 0x60, 0xd6, 0xce, 0xc6, 0x60, 0xc6, 0x6c, 0x6 ,
	0x18, 0xc6, 0xc6, 0xfe, 0x6c, 0x18, 0x60, 0x60, 0x18, 0xc , 0x0 , 0x0 ,
	0x0 , 0xcc, 0x66, 0xc0, 0xcc, 0xfe, 0x30, 0xc6, 0x66, 0x18, 0xc , 0x78,
	0x18, 0xd6, 0x66, 0xc6, 0x66, 0xcc, 0x60, 0x7c, 0x30, 0xcc, 0xc6, 0xd6,
	0x38, 0xc6, 0x18, 0x18, 0x18, 0x18, 0x0 , 0x6c, 0x66, 0xc6, 0xfe, 0xcc,
	0xcc, 0xcc, 0xcc, 0xc6, 0xfe, 0xfe, 0xfe, 0x18, 0x18, 0x18, 0xfe, 0xfe,
	0x60, 0xd8, 0xd8, 0xc6, 0xc6, 0xc6, 0xc6, 0xc6, 0xce, 0xc6, 0xc6, 0xc6,
	0x60, 0x18, 0xcc, 0x18, 0xcc, 0x18, 0xc6, 0xcc, 0x66, 0xde, 0x0 , 0x0 ,
	0x60, 0x60, 0x6 , 0x60, 0x6e, 0x3c, 0x6c, 0x6c, 0x11, 0xaa, 0xdd, 0x18,
	0xf8, 0xf8, 0xf6, 0xfe, 0xf8, 0xf6, 0x36, 0xf6, 0xfe, 0xfe, 0xf8, 0xf8,
	0x1f, 0xff, 0xff, 0x1f, 0xff, 0xff, 0x1f, 0x37, 0x3f, 0x37, 0xff, 0xf7,
	0x37, 0xff, 0xf7, 0xff, 0xff, 0xff, 0xff, 0x3f, 0x1f, 0x1f, 0x3f, 0xff,
	0xff, 0xf8, 0x1f, 0xff, 0xff, 0xf0, 0xf , 0x0 , 0xd8, 0xc6, 0x60, 0x6c,
	0x30, 0xcc, 0x66, 0x18, 0x6c, 0xc6, 0x6c, 0xc6, 0xdb, 0xf6, 0x60, 0xc6,
	0x0 , 0x18, 0x30, 0xc , 0x18, 0x18, 0x0 , 0x0 , 0x0 , 0x18, 0x18, 0xd8,
	0x0 , 0x0 , 0x7e,

	/*******	SCAN LINE #10	********/
	0x0 , 0x81, 0xc6, 0x7c, 0x10, 0x6c, 0x6c, 0x18, 0xe7, 0x3c, 0xc3, 0xcc,
	0x18, 0x78, 0x66, 0x7e, 0xf0, 0x3e, 0x7e, 0x0 , 0x1b, 0x7c, 0xfe, 0x3c,
	0x18, 0x7e, 0xc , 0x30, 0xfe, 0x24, 0xfe, 0x38, 0x0 , 0x0 , 0x0 , 0x6c,
	0x6 , 0x30, 0xcc, 0x0 , 0x30, 0xc , 0x6c, 0x18, 0xc , 0x0 , 0x0 , 0x60,
	0xc6, 0x18, 0x60, 0x6 , 0xc , 0x6 , 0xc6, 0x30, 0xc6, 0x6 , 0xc , 0xc ,
	0x30, 0x0 , 0x18, 0x0 , 0xdc, 0xc6, 0x66, 0xc2, 0x66, 0x60, 0x60, 0xc6,
	0xc6, 0x18, 0xd8, 0xcc, 0x62, 0xd6, 0xce, 0xc6, 0x60, 0xd6, 0x66, 0x6 ,
	0x18, 0xc6, 0x6c, 0xee, 0xc6, 0x18, 0xc2, 0x60, 0xc , 0xc , 0x0 , 0x0 ,
	0x0 , 0xcc, 0x66, 0xc0, 0xcc, 0xc0, 0x30, 0xce, 0x66, 0x18, 0xc , 0x6c,
	0x18, 0xc6, 0x66, 0xc6, 0x66, 0xcc, 0x60, 0x6 , 0x30, 0xcc, 0x6c, 0xd6,
	0x6c, 0xce, 0x30, 0x18, 0x18, 0x18, 0x0 , 0x6c, 0x3c, 0xc6, 0xc0, 0xcc,
	0xcc, 0xcc, 0xcc, 0x7c, 0xc0, 0xc0, 0xc0, 0x18, 0x18, 0x18, 0xc6, 0xc6,
	0x60, 0xd8, 0xd8, 0xc6, 0xc6, 0xc6, 0xc6, 0xc6, 0x76, 0xc6, 0xc6, 0x7c,
	0x66, 0x3c, 0xcc, 0x18, 0xcc, 0x18, 0xc6, 0xcc, 0x66, 0xce, 0x0 , 0x0 ,
	0xc6, 0x60, 0x6 , 0xdc, 0xde, 0x3c, 0x36, 0xd8, 0x44, 0x55, 0x77, 0x18,
	0x18, 0x18, 0x36, 0x36, 0x18, 0x36, 0x36, 0x36, 0x0 , 0x0 , 0x0 , 0x18,
	0x0 , 0x0 , 0x18, 0x18, 0x0 , 0x18, 0x18, 0x36, 0x0 , 0x36, 0x0 , 0x36,
	0x36, 0x0 , 0x36, 0x0 , 0x0 , 0x18, 0x36, 0x0 , 0x0 , 0x18, 0x36, 0x36,
	0x18, 0x0 , 0x18, 0xff, 0xff, 0xf0, 0xf , 0x0 , 0xd8, 0xc6, 0x60, 0x6c,
	0x62, 0xcc, 0x7c, 0x18, 0x38, 0xc6, 0x6c, 0xc6, 0x7e, 0x7c, 0x60, 0xc6,
	0x0 , 0x0 , 0x0 , 0x0 , 0x18, 0x18, 0x18, 0x76, 0x0 , 0x0 , 0x0 , 0xd8,
	0x0 , 0x0 , 0x7e,

	/*******	SCAN LINE #11	********/
	0x0 , 0x81, 0xfe, 0x38, 0x0 , 0x10, 0x10, 0x0 , 0xff, 0x18, 0xe7, 0xcc,
	0x18, 0xf8, 0xe , 0xdb, 0xe0, 0xe , 0x3c, 0x66, 0x1b, 0xc , 0xfe, 0x18,
	0x18, 0x3c, 0x0 , 0x0 , 0x0 , 0x0 , 0xfe, 0x10, 0x0 , 0x18, 0x0 , 0x6c,
	0xc6, 0x66, 0xcc, 0x0 , 0x18, 0x18, 0x0 , 0x0 , 0xc , 0x0 , 0x18, 0xc0,
	0xc6, 0x18, 0xc6, 0xc6, 0xc , 0xc6, 0xc6, 0x30, 0xc6, 0xc6, 0xc , 0xc ,
	0x18, 0x0 , 0x30, 0x18, 0xc0, 0xc6, 0x66, 0x66, 0x6c, 0x66, 0x60, 0xc6,
	0xc6, 0x18, 0xd8, 0xc6, 0x66, 0xc6, 0xc6, 0xc6, 0x60, 0xd6, 0x66, 0xc6,
	0x18, 0xc6, 0x38, 0xc6, 0xc6, 0x18, 0xc6, 0x60, 0x6 , 0xc , 0x0 , 0x0 ,
	0x0 , 0xdc, 0x66, 0xc6, 0xcc, 0xc6, 0x30, 0x76, 0x66, 0x18, 0xc , 0x66,
	0x18, 0xc6, 0x66, 0xc6, 0x7c, 0x7c, 0x60, 0xc6, 0x36, 0xcc, 0x38, 0xfe,
	0xc6, 0x76, 0x62, 0x18, 0x18, 0x18, 0x0 , 0xfe, 0x18, 0xce, 0xc6, 0xdc,
	0xdc, 0xdc, 0xdc, 0x18, 0xc6, 0xc6, 0xc6, 0x18, 0x18, 0x18, 0xc6, 0xc6,
	0x60, 0xdf, 0xd8, 0xc6, 0xc6, 0xc6, 0xce, 0xce, 0x6 , 0xc6, 0xc6, 0x18,
	0xf6, 0x18, 0xcc, 0x18, 0xdc, 0x18, 0xc6, 0xdc, 0x66, 0xc6, 0x0 , 0x0 ,
	0xc6, 0x60, 0x6 , 0x36, 0x36, 0x3c, 0x0 , 0x0 , 0x11, 0xaa, 0xdd, 0x18,
	0x18, 0x18, 0x36, 0x36, 0x18, 0x36, 0x36, 0x36, 0x0 , 0x0 , 0x0 , 0x18,
	0x0 , 0x0 , 0x18, 0x18, 0x0 , 0x18, 0x18, 0x36, 0x0 , 0x36, 0x0 , 0x36,
	0x36, 0x0 , 0x36, 0x0 , 0x0 , 0x18, 0x36, 0x0 , 0x0 , 0x18, 0x36, 0x36,
	0x18, 0x0 , 0x18, 0xff, 0xff, 0xf0, 0xf , 0x0 , 0xdc, 0xe6, 0x60, 0x6c,
	0xc6, 0xd8, 0x60, 0x18, 0x38, 0x6c, 0x6c, 0xcc, 0x0 , 0x60, 0x30, 0xc6,
	0xfe, 0x0 , 0x0 , 0x0 , 0x18, 0x58, 0x18, 0xdc, 0x0 , 0x0 , 0x0 , 0x78,
	0x0 , 0x0 , 0x7e,

	/*******	SCAN LINE #12	********/
	0x0 , 0x7e, 0x7c, 0x10, 0x0 , 0x38, 0x38, 0x0 , 0xff, 0x0 , 0xff, 0x78,
	0x18, 0x70, 0x1e, 0x18, 0x80, 0x2 , 0x18, 0x66, 0x1b, 0xc6, 0xfe, 0x7e,
	0x18, 0x18, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x18, 0x0 , 0x6c,
	0x7c, 0xc6, 0x76, 0x0 , 0xc , 0x30, 0x0 , 0x0 , 0xc , 0x0 , 0x18, 0x80,
	0x7c, 0x7e, 0xfe, 0x7c, 0x1e, 0x7c, 0x7c, 0x30, 0x7c, 0x7c, 0x0 , 0xc ,
	0xc , 0x0 , 0x60, 0x18, 0x7e, 0xc6, 0xfc, 0x3c, 0xf8, 0xfe, 0xf0, 0x7c,
	0xc6, 0x3c, 0x70, 0xc6, 0xfe, 0xc6, 0xc6, 0x7c, 0xf0, 0x7c, 0xe6, 0x7c,
	0x3c, 0x7c, 0x10, 0xc6, 0xc6, 0x3c, 0xfe, 0x7c, 0x2 , 0x7c, 0x0 , 0x0 ,
	0x0 , 0x76, 0xfc, 0x7c, 0x7e, 0x7c, 0x78, 0x6 , 0xe6, 0x3c, 0xcc, 0xe6,
	0x3c, 0xc6, 0x66, 0x7c, 0x60, 0xc , 0xf0, 0x7c, 0x1c, 0x76, 0x10, 0x6c,
	0xc6, 0x6 , 0xfe, 0xe , 0x18, 0x70, 0x0 , 0x0 , 0xc , 0x76, 0x7c, 0x76,
	0x76, 0x76, 0x76, 0xc , 0x7c, 0x7c, 0x7c, 0x3c, 0x3c, 0x3c, 0xc6, 0xc6,
	0xfe, 0x76, 0xde, 0x7c, 0x7c, 0x7c, 0x76, 0x76, 0x6 , 0x7c, 0x7c, 0x18,
	0x6c, 0x18, 0xc6, 0x18, 0x76, 0x3c, 0x7c, 0x76, 0xe6, 0xc6, 0x0 , 0x0 ,
	0x7c, 0x0 , 0x0 , 0xc , 0x7e, 0x18, 0x0 , 0x0 , 0x44, 0x55, 0x77, 0x18,
	0x18, 0x18, 0x36, 0x36, 0x18, 0x36, 0x36, 0x36, 0x0 , 0x0 , 0x0 , 0x18,
	0x0 , 0x0 , 0x18, 0x18, 0x0 , 0x18, 0x18, 0x36, 0x0 , 0x36, 0x0 , 0x36,
	0x36, 0x0 , 0x36, 0x0 , 0x0 , 0x18, 0x36, 0x0 , 0x0 , 0x18, 0x36, 0x36,
	0x18, 0x0 , 0x18, 0xff, 0xff, 0xf0, 0xf , 0x0 , 0x76, 0xdc, 0x60, 0x6c,
	0xfe, 0x70, 0xc0, 0x18, 0xfe, 0x38, 0xee, 0x78, 0x0 , 0xc0, 0x1c, 0xc6,
	0x0 , 0x7e, 0x7e, 0x7e, 0x18, 0x78, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x38,
	0x0 , 0x0 , 0x0 ,

	/*******	SCAN LINE #13	********/
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0xff, 0x0 , 0xff, 0x0 ,
	0x0 , 0x0 , 0xc , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0xc6, 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x18, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x18, 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x18,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x6 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0xc6, 0x0 , 0x0 , 0xcc, 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x60, 0xc , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0xc6, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0xcc, 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x6c, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0xc6, 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0xd8, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x18, 0x6 , 0x0 , 0x0 , 0x0 , 0x11, 0xaa, 0xdd, 0x18,
	0x18, 0x18, 0x36, 0x36, 0x18, 0x36, 0x36, 0x36, 0x0 , 0x0 , 0x0 , 0x18,
	0x0 , 0x0 , 0x18, 0x18, 0x0 , 0x18, 0x18, 0x36, 0x0 , 0x36, 0x0 , 0x36,
	0x36, 0x0 , 0x36, 0x0 , 0x0 , 0x18, 0x36, 0x0 , 0x0 , 0x18, 0x36, 0x36,
	0x18, 0x0 , 0x18, 0xff, 0xff, 0xf0, 0xf , 0x0 , 0x0 , 0xc0, 0x0 , 0x0 ,
	0x0 , 0x0 , 0x80, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x18, 0x30, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x18,
	0x0 , 0x0 , 0x0 ,

	/*******	SCAN LINE #14	********/
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0xff, 0x0 , 0xff, 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x7c, 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x18, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0xff,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x7c, 0x0 , 0x0 , 0x78, 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0xf0, 0x1e, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x7c, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x38, 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x38, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x7c, 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x70, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x3e, 0x6 , 0x0 , 0x0 , 0x0 , 0x44, 0x55, 0x77, 0x18,
	0x18, 0x18, 0x36, 0x36, 0x18, 0x36, 0x36, 0x36, 0x0 , 0x0 , 0x0 , 0x18,
	0x0 , 0x0 , 0x18, 0x18, 0x0 , 0x18, 0x18, 0x36, 0x0 , 0x36, 0x0 , 0x36,
	0x36, 0x0 , 0x36, 0x0 , 0x0 , 0x18, 0x36, 0x0 , 0x0 , 0x18, 0x36, 0x36,
	0x18, 0x0 , 0x18, 0xff, 0xff, 0xf0, 0xf , 0x0 , 0x0 , 0xc0, 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x18, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 ,

	/*******	SCAN LINE #15	********/
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0xff, 0x0 , 0xff, 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x11, 0xaa, 0xdd, 0x18,
	0x18, 0x18, 0x36, 0x36, 0x18, 0x36, 0x36, 0x36, 0x0 , 0x0 , 0x0 , 0x18,
	0x0 , 0x0 , 0x18, 0x18, 0x0 , 0x18, 0x18, 0x36, 0x0 , 0x36, 0x0 , 0x36,
	0x36, 0x0 , 0x36, 0x0 , 0x0 , 0x18, 0x36, 0x0 , 0x0 , 0x18, 0x36, 0x36,
	0x18, 0x0 , 0x18, 0xff, 0xff, 0xf0, 0xf , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x18, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 ,

	/*******	SCAN LINE #16	********/
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0xff, 0x0 , 0xff, 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x44, 0x55, 0x77, 0x18,
	0x18, 0x18, 0x36, 0x36, 0x18, 0x36, 0x36, 0x36, 0x0 , 0x0 , 0x0 , 0x18,
	0x0 , 0x0 , 0x18, 0x18, 0x0 , 0x18, 0x18, 0x36, 0x0 , 0x36, 0x0 , 0x36,
	0x36, 0x0 , 0x36, 0x0 , 0x0 , 0x18, 0x36, 0x0 , 0x0 , 0x18, 0x36, 0x36,
	0x18, 0x0 , 0x18, 0xff, 0xff, 0xf0, 0xf , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0 , 0x0 , 0x18, 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 ,
	0x0 , 0x0 , 0x0
    };


LOCAL FONT  rom_8x8 = { (UWORD *) rom_8x8_offset_table,
			   (UTINY_FAR *) rom_8x8_data_table,
			   255, 8, 0, 255, 8, 7, 8, 0
			 };

LOCAL FONT rom_8x14 = { (UWORD *) rom_8x14_offset_table,
			   (UTINY_FAR *) rom_8x14_data_table,
			   255, 14, 0, 255, 8, 11, 14, 0
			 };

LOCAL FONT rom_8x16 = { (UWORD *) rom_8x16_offset_table,
			   (UTINY_FAR *) rom_8x16_data_table,
			   255, 16, 0, 255, 8, 13, 16, 0
			 };

FONT *ramromfonts[] = { (FONT *) 0, &rom_8x8, &rom_8x14, &rom_8x16 };

Void_FCN _gfx32_init_ramrom_fonts(void)
{
INT fh;
IMPORT UTINY_FAR *extended_8x8_font_ptr;

extended_8x8_font_ptr = (UTINY_FAR *) (rom_8x8_data_table + 128 * 8);
for (fh = 1; fh <= 3; fh++) {
     _gfx_get_FONT_ATTR_struct(fh, &(ramromfonts[fh]->attr));
	_gfx_set_font_handle(fh, (DMEM_HANDLE) ramromfonts[fh]);
	}
}


#endif

