/************************************************/
/* Copyright (c) C Source, Inc 1989, 1990, 1991 */
/************************************************/

#if !defined (__GFXF_SRC_)
#define __GFXF_SRC_

#if (INCLUDE_BUILD_FILES == 1)
#include "GFX.H"
#include "GFX_ERR.H"
#include "GFX_SRC.H"
#include "GFX_PRO.H"
#include "GFXLOPRO.H"
#include "GFXF_PRO.H"
#endif

	/*  The FCRSR function keeps the various coordinates of the font
	 *  cursor so gfx_print_font knows where to draw the text.
	 */

typedef struct fc {int x, y;			   /* physical coordinate */
			    int ilog_x, ilog_y;     /* integer logical coordinate */
			    double flog_x, flog_y;  /* floating pt logical coordinate */
			    int delta_x, delta_y;   /* length of string on screen */
			    } FCRSR;


                        /*******************
                         ****** MENUS ******
                         *******************/
	 
#define CR				13			/* some keystrokes */
#define BS				 8
#define ESC				27
#define INS				82
#define TAB				 9
#define DEL				83

#define _gfx_mouse_state(a)	mouse_state.a    

#if defined (M_I86) && !defined (__ZTC__)
#define MSTATE		MOUSE_STATE near
#else
#define MSTATE		MOUSE_STATE 
#endif

	/* Data structures for the Menus */

typedef struct _pbx { int curr_n, max_n, first_line_n, ok_scroll;
				  int n_lines, max_line_len, struct_size;
				  int row_height, font_height, font_widest_cell;
				  DISPLAY_PAGE display;
				  LAYOUT layout;
				  COLOR_SCHEME cs;
				  BOX_DIM bdim;
				} PAGE_DATA;

typedef struct _fbx { int response_x, n_total_responses;
				  int top_resp_n, bottom_resp_n, curr_resp_n;
				  int *resp_y, curpos;
				} FORM_DATA;

typedef struct _msl { int marker_c, marker_fh, marker_color, marker_width;
	                 int n_choices_selected, max_n_choices, *choice_buf;
	               } MSEL;

typedef struct _stp { int x, y, max_len;
                      char *buf;
                    } USRINP;  
                      
typedef struct _sdt { int page_n_choices, show_n_choices;
				  int n_col, n_rows, h_grid_border, v_grid_border;
				  USRINP user;
				  MSEL *multi;
				  BOX_DIM wn_bdim;
				} SELECT_DATA;

typedef struct _sbr { int slide_sz, bar_sz, bar_end, top_loc, orientation;
				  int bkgnd_color, shade_color, halftone;
				  HOT_SPOT *hs;
				  BOX_DIM bdim;
				} SBAR;

typedef struct _hsd { int total_n, pop_n_spots, base_hs_n;
				  HOT_SPOT *hs;
				} HS_DATA;

typedef struct _dpg { int box_class, last_hot_spot;
				  GFX_BOX *orig_box;
				  GFX_BOX gbox;
				  ULTD_DBOX ubx;
				  PAGE_DATA dpg;
				  FORM_DATA form;
				  SELECT_DATA select;
				  TEXT_CURSOR txe;
				  SBAR sbar;
				  HS_DATA hot_spots;
				  BOX_DIM bdim;
				} DISPLAY_BOX;


typedef struct _gbt  { int btn_width, btn_height, box_width, box_height;
				   int delta_x, delta_y, n_rows, font_height;
				   int h_border_width, v_border_width;
				   BUTTON_SET def;
				   COLOR_SCHEME cs;
				 } WORK_BUTTON;

#define v_line_width(x)			_gfx_xlat_int_coor(x, _gfx_menu.num, _gfx_menu.denom)
#define _scale_val(x, num, denom)	_gfx_xlat_int_coor(x, num, denom)

typedef struct _gmm { int dflt_fh, n_colors, color_mask;
				  int help_ascii, help_scan, help_button, in_help, no_help_beep;
				  int bios_mode, orig_max_x, orig_max_y, max_x, max_y;
				  int scale_x, scale_y, num, denom;
				  int pic_char_fh;
				  UTINY_FAR *extended_8x8_font_ptr;
				  GFX_BOX *dialog_box;
				  GFX_BOX *forms_box;
				  GFX_BOX *text_select_box;
				  GFX_BOX *icon_select_box;
				  BUTTON_SET **dflt_buttons;
				  int n_dflt_buttons;
				} MENU_STATUS;


typedef struct _gfxrt { ROOT_MENU menu;
				    MENU_DEF  pdm_def;
				    MENU_DEF  bar_def;
				    BOX_DIM   bdim;
				    int top_scan_line;
				    int title_x;
				    int menu_bkgnd;
				  } GFX_ROOT;

typedef struct _gbl { int new, curr, max_n;
				  DISPLAY_BOX *gbx_buf;
				} BOX_LEVEL;

#define DOT_PAREN        0x282E

#define next_entry_structure(e)	 (e=(FORM_ENTRY *)((char*)e+gbx.dpg.struct_size))
#define get_entry_structure(e, n)	 ((FORM_ENTRY *)((char*)e+(n*gbx.dpg.struct_size)))


#if defined (USE_PAS_M2)

#define init_mouse()				InitMouse()
#define init_auto_buttons(a, b)		InitAutoButtons(a, b)
#define init_GFX_menu(a,b,c,d)		InitGFXMenu(a,b,c,d)
#define init_GFX_struct(a)			InitGFXStruct(a)
#define init_video_storage(a,b,c)		InitVideoStorage(a,b,c)
#define curr_font(fh)				CurrFont(fh)
#define revisit_box()				RevisitBox()
#define init_auto_box(a,b)			InitAutoBox(a,b)
#define get_event(n)				GetEvent(n)
#define clear_menus()				ClearMenus()
#define clear_box() 				ClearBox()
#define init_gfx_menu(a, b, c, d)		InitGFXMenu(a, b, c, d)
#define halt_q()					HaltQ()
#define push_hot_spot(a)				PushHotSpot(a)
#define pop_hot_spots(n)				PopHotSpots(n)
#define sleep_all_hot_spots()			SleepAllHotSpots()
#define wake_hot_spots()				WakeHotSpots()
#define mod_hot_spots_status(a,b,c,d)	ModHotSpotsStatus(a,b,c,d)
#define qprint(a, b, c, d, e, f, g)	Qprint(a, b, c, d, e, f, g)
#define shade_box(a, b, c, d, e, f)	ShadeBox(a, b, c, d, e, f)
#define reset_layout(a, b)			ResetLayout(a, b)
#define scale_dim(a, b)				ScaleDim(a, b)
#define reset_color_scheme(a,b,c,d)	ResetColorScheme(a,b,c,d)
#define open_mem_font(a)				OpenMemFont(a)
#define qstring_len(a,b) 			QstringLen(a,b)
#define use_GFX_mouse_cursor() 	     UseGFXMouseCursor()

#define free_GFX_workspace()			FreeGFXWorkspace()
#define alloc_GFX_workspace(a,b)		AllocGFXWorkspace(a,b)
#define alloc_GFX_system_ram(a)		AllocGFXSystemRam(a)
#define alloc_GFX_video_ram(a)		AllocGFXVideoRam(a)

#elif defined (USE_UPPER_C)

#define curr_font(fh)				CURR_FONT(fh)

#endif

#define USE_4_PLANES	1

typedef struct _gmc { int use_gfx_cursor, byte_width, type, is_on, flags;
				  int x, y, max_x, max_y;
                      union { UTINY_FAR *sys_ram;
	                         unsigned int vid_ram_para; } save_buf;
	                 int color1, color2;
	                 CURSOR_SHAPE shape;
	               } GFX_MOUSE_CURSOR;  
        	

#define BAR_WIDTH			6
#define BOXES_ALL_CLEAR		-2
#define NO_ROOT_DEFS		USR_BIT1
#define SET_NEW_PAGE	-12283


struct memblock { unsigned int handle, drive_n;
			   union {long 	 start_offset;
					UTINY_FAR *buf;
				    } ptr;
			   long end_of_mem, mem_offset;
			 };

typedef struct _vmem { int next_sblock;
				   struct memblock mem[6];
				  } MEMCB;


#define GET_IMAGE_SIZE		0x200
#define GET_BEST_IMAGE_SIZE	0x400

#define _gfx_read_next_vid_line(buf, x_bytes)				_gfx_move_next_vid_line(buf, x_bytes, x_bytes, 0, 0)

#define	TRUNCATE_LENGTH		0x010	/* flags: _gfx_curr_font_flags */
#define   DONT_REFLECT_FONT		0x020
#define   BGI_CONTROL			0x100
#define	BGI_PRINT                0x200

#endif



