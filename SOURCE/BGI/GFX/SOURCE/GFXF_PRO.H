                /*****************************************/
                /*  Copyright C Source, Inc. 1987 - 1993 */
                /*  All Rights Reserved                  */
                /*****************************************/

         /*******************************************************
          *  This file contains all the prototypes for the      *
          *  low-level, public C functionsin the GFX Fonts &    *
          *  Menus Library. Be sure to include this file if     *
          *  you use any of these functions.  There are three   *
          *  sets of prototypes. The first set of prototypes    *
          *  if for the file GFXF_C.C. The second set of        *
          *  prototypes is for functions in GFXF_C.C the dup-   *
          *  licate functions in GFXG_C.C and the last set      *
          *  of prototypes is for functions in GFXM_C.C.        *
          *                                                     *
          *                                                     *
          *  The definitions for the protoypes (Void_PRO etc.)  *
          *  can be found in the GFX.H header file.             *
          *                                                     *
          *                                                     *
          *  STANDARD WARNING: Use these functions at your own  *
          *  risk. You are welcome to use these functions and   *
          *  although we try to keep changes to a minimum,      *
          *  please realize that they may be modified and/or    *
          *  renamed at any time, and without warning.          *
          *                                                     *
          *  The prototypes for the low-level, public assembly  *
          *  language functions are in the GFXLOPRO.H file.     *
          *******************************************************/


#if !defined (__GFXF_PRO_)
#define __GFXF_PRO_ 

#if defined (__HIGHC__) || (__MSC_32__ > 0)

#define HC_near	  

#define LOCAL_Void_PRO		extern void HC_near 
#define LOCAL_Int_PRO		extern int HC_near 
#define LOCAL_Uint_PRO		extern unsigned int HC_near 
#define LOCAL_Long_PRO		extern longHC_near 

#define LOCAL_CharPtr_PRO	extern char * HC_near 
#define LOCAL_EventPtr_PRO	extern EVENT * HC_near 
#define LOCAL_HotSpotPtr_PRO  extern HOT_SPOT * HC_near 
#define LOCAL_SblockPtr_PRO   extern SBLOCK * HC_near 
#define LOCAL_IcoorPtr_PRO	extern ICOOR * HC_near 

#define LOCAL_Void_FCN 		static void HC_near 
#define LOCAL_Int_FCN		static int HC_near 
#define LOCAL_Uint_FCN		static unsigned int HC_near 
#define LOCAL_Long_FCN		static long HC_near 

#define LOCAL_CharPtr_FCN	static char * HC_near 
#define LOCAL_EventPtr_FCN	static EVENT * HC_near 
#define LOCAL_HotSpotPtr_FCN  static HOT_SPOT * HC_near 
#define LOCAL_SblockPtr_FCN   static SBLOCK * HC_near 
#define LOCAL_IcoorPtr_FCN	static ICOOR * HC_near 

#else

#define LOCAL_Void_PRO		static void pascal near
#define LOCAL_Int_PRO		static int  pascal near
#define LOCAL_Uint_PRO		static unsigned int  pascal near
#define LOCAL_Long_PRO		static long pascal near

#define LOCAL_CharPtr_PRO	static char * pascal near
#define LOCAL_EventPtr_PRO	static EVENT * pascal near
#define LOCAL_HotSpotPtr_PRO  static HOT_SPOT * pascal near
#define LOCAL_SblockPtr_PRO   static SBLOCK * pascal near
#define LOCAL_IcoorPtr_PRO	static ICOOR * pascal near

#define LOCAL_Void_FCN 		static void pascal near
#define LOCAL_Int_FCN		static int  pascal near
#define LOCAL_Uint_FCN		static unsigned int  pascal near
#define LOCAL_Long_FCN		static long pascal near

#define LOCAL_CharPtr_FCN	static char * pascal near
#define LOCAL_EventPtr_FCN	static EVENT * pascal near
#define LOCAL_HotSpotPtr_FCN  static HOT_SPOT * pascal near
#define LOCAL_SblockPtr_FCN   static SBLOCK * pascal near
#define LOCAL_IcoorPtr_FCN	static ICOOR * pascal near

#endif

	/* This set is for global GFX C functions */

#define Void_FCN    	void pascal
#define Int_FCN     	int  pascal
#define Uint_FCN    	unsigned int  pascal
#define Long_FCN    	long pascal
#define UtinyFarPtr_FCN UTINY_FAR * pascal
#define CharPtr_FCN      char * pascal

	/* This set is for global GFX C prototypes */

#define Void_PRO    	extern void pascal
#define Int_PRO          extern int  pascal
#define Uint_PRO         extern unsigned int  pascal
#define Long_PRO         extern long pascal
#define UtinyFarPtr_PRO extern UTINY_FAR * pascal
#define CharPtr_PRO      extern char * pascal


#if defined (__cplusplus)
extern "C" {
#endif

#if !defined (PROT_MODE_SYS)
#define PROT_MODE_SYS 	-1
#endif

#define FontPtr_FCN           FONT * pascal
#define EventPtr_FCN		EVENT *pascal

#define FontPtr_PRO           FONT * pascal
#define EventPtr_PRO		EVENT *pascal

/********************************************************************
 *  This first set of prototypes is for font functions in GFXF_C.C  *
 ********************************************************************/

Void_PRO _gfx_set_magnify_fcn(void);
Void_PRO _gfx_set_rotate_fcns(void);
Int_PRO _gfx_open_font(int  dos_handle,int  fcn_n);
Int_PRO _gfx_alloc_font_handle(void);
Int_PRO gfx_print_font(char  *_tp,int  max_char);
Void_PRO _gfx_build_fast_table(FONT *font);
Void_PRO _gfx_solid_box(int  x1,int  y1,int  x2,int  y2,int  color);
Void_PRO _gfx_init_rom_fonts(void);
FontPtr_PRO _gfx_get_font_ptr(int  fh,int  fcn_nmbr);
Void_PRO _gfx_reflect_font_attr(int  fh, FONT *fp);
int  set_get_font_status_val(int  set_or_get,int  member_n,int  *user_val);
Int_PRO _gfx_curr_font(int fh);

  /**********************************************************************
   *  This set of prototypes is for function in GFXF_C.C the duplicate  *
   *  functions that are also in the GFX Graphics Library               *
   **********************************************************************/

Void_PRO _gfx_force_on_planes(void);
Int_PRO  _gfx_get_color(int color);
Int_PRO  _set_gfx_err_number(int err_code_name);
Void_PRO _gfx_puts(char  *tp);
Int_PRO  _get_int_pt(int *arg);
Uint_PRO _gfx_ptr_in_huge_buf(UTINY_FAR *buf,long  offset,UTINY_FAR * *norm_buf,unsigned int n_bytes);
Uint_PRO _gfx_huge_move(UTINY_FAR *huge_base, long huge_offset, UTINY_FAR *small_buf, unsigned int n_bytes, int dir);
Int_PRO  _gfx_call_86x(int int_nmbr,void *reg,unsigned char  *ds_buf,unsigned char  *es_buf);
Int_PRO  _gfx_farcall_86x(int int_nmbr,void *reg,UTINY_FAR *ds_buf,UTINY_FAR *es_buf);
Void_PRO _gfx_fast_hline(int x,int y,int len,int n_lines,int color);
Int_PRO  _gfx_lseek_blob(int index,int blob_handle,long  *file_size,int *blob_type,int fcn_n);
Int_PRO  _gfx_get_DRAW_coor(int type,int *curr_log_coor,int N,int draw_scale);
Int_PRO  _gfx_scale_DRAW_coor(int coor,int scale,int type,int *curr_log_coor,int is_relative_point,int N);
Int_PRO  _gfx_get_DRAW_numeric_arg(int type);
Void_PRO _gfx_skip_blanks(void);
Int_PRO   gfx_open(char  *file_name,int type_open);
Int_PRO   gfx_close(unsigned int dos_handle);
Int_PRO   gfx_file_io(UTINY_FAR *bufptr,unsigned int n_bytes,int dos_handle,int fcn_type);
Long_PRO  gfx_lseek(int dos_handle,long  l_offset,int mode);
Long_PRO _gfx_move_vidram(PIC *user_pic,int action);

Int_PRO _gfx_get_FONT_ATTR_struct(int fh, FONT_ATTR *attr_ptr);
Int_PRO _gfx_get_FONT_struct(int fh, FONT *fp);
Int_PRO _gfx_set_FONT_struct(int fh, FONT *fp);

Void_PRO _gfx_set_font_handle(int font_handle, DMEM_HANDLE font_mc);

Int_PRO  _gfx_get_temp_workspace(UTINY_FAR **temp_buf,int n_kbytes);
Void_PRO _gfx_free_temp_workspace(UTINY_FAR *);

CharPtr_PRO _gfx_malloc_mc(unsigned int n_bytes, DMEM_HANDLE *mc);
Void_PRO _gfx_free_mc(DMEM_HANDLE mc);
#if (MOBILE_DMEM != 0)
CharPtr_PRO _gfx_deref_mc(DMEM_HANDLE mc);
Void_PRO _gfx_unlock_mc(DMEM_HANDLE mc);
#endif

#if (PROT_MODE_SYS != PMODE_32)
UtinyFarPtr_PRO _gfx_farmalloc_mc(long  n_bytes, FAR_DMEM_HANDLE *mc);
Void_PRO _gfx_farfree_mc(FAR_DMEM_HANDLE mc);
#if (MOBILE_DMEM != 0)
UtinyFarPtr_PRO _gfx_deref_farmc(DMEM_HANDLE mc);
#endif
#endif

   /********************************************************************
    *  The remaining prototypes are for functions in the GFXM_C.C file *
    ********************************************************************/

Int_PRO  _gfx_init_mouse(void);
Void_PRO _gfx_link_mouse_handler(void);
Void_PRO _gfx_ulink_mouse_handler(void);
Void_PRO _gfx_disable_timer(void);
Void_PRO _gfx_enable_timer(void);
Int_PRO  _gfx_qstring_len(int fh, char *tp);
Int_PRO  _gfx_qtext_len(int  fh,char  *tp,int  n_char);
Int_PRO  _gfx_hi_qprint(int  x,int  y,int  fh,int  color,int  hi_c,int  hi_color,int  justify,char  *tp,int  font_height);
Void_PRO _gfx_check_hot_spots(int  x,int  y);
Int_PRO  _gfx_xlat_keystroke_to_hot_spot(EVENT *ev);
EventPtr_PRO _gfx_lo_set_box(int x, int y, GFX_BOX *gbox);
Void_PRO toggle_hot_spot(HOT_SPOT *hs);
Void_PRO toggle_curr_hot_spot(void);
Void_PRO turn_on_curr_hot_spot(void);
Void_PRO turn_off_curr_hot_spot(void);
Void_PRO turn_on_hot_spot(HOT_SPOT *hs);
Void_PRO turn_off_hot_spot(HOT_SPOT *hs);
Int_PRO  _gfx_grow_hot_spot_stack(void);
Int_PRO  _gfx_check_box_dim(BOX_DIM *local_bdim,BOX_DIM *user_bdim,int  force_position);
EventPtr_PRO _gfx_get_pd_menu_item(EVENT *ev);
Int_PRO  _gfx_get_curr_menu_hot_spot_n(void);
Int_PRO  _gfx_get_scan_hot_spot_n(int  scan_code,int  check_status,int  match_n);
Int_PRO  push_video_block(int  x,int  y,int  x_pels_wide,int  y_rows);
Int_PRO  _gfx_free_sblock(int  block_n);
Int_PRO  pop_video_block(void);
Long_PRO _gfx_drive_free_space(int  disk_n);
Int_PRO  _gfx_get_dflt_drive(void);
Int_PRO  _gfx_get_gfx_font_height(int  fh);
Void_PRO _gfx_set_menu_screen_dim(void);
Int_PRO  _gfx_draw_bdim_box(BOX_DIM *bdim,COLOR_SCHEME *cs,int  save_video);
Void_PRO _gfx_set_box_dim_coor(GFX_BOX *gbox,BOX_DIM *bdim);
Int_PRO  _gfx_curr_box(int  box_n);
Void_PRO _gfx_display_page_in_box(void);
Int_PRO  _gfx_rel_line_loc(char  *tp,int  *delta_x,int  *delta_y,int  *color);
Int_PRO  _gfx_clip_item_n(int  item_n,int  max_n);
Void_PRO _gfx_init_title_box(BOX_DIM *bdim);
Void_PRO _gfx_display_page_title(BOX_DIM *bdim);
Int_PRO  _gfx_show_help(EVENT *ev);
Int_PRO  _gfx_push_mouse_pos(int  new_x,int  new_y);
Int_PRO  _gfx_pop_mouse_pos(void);
Int_PRO  _gfx_init_buttons(BOX_DIM *btn_bdim);
Void_PRO _gfx_set_gbtn_fh(int  fh);
Void_PRO _gfx_display_buttons(BOX_DIM *bdim,int  btn_pos);
Void_PRO _gfx_draw_button(BUTTON_DATA *btn,BOX_DIM *bdim,int  auto_crsr_position,int  hilight_buttons);
Void_PRO _gfx_set_cs_defaults(COLOR_SCHEME *new_cs,COLOR_SCHEME *user_cs);
Void_PRO _gfx_reset_dbox(int  item_n);
Void_PRO _gfx_init_selections(void);
Void_PRO _gfx_display_curr_selection(int  curr_choice);
Int_PRO  _gfx_init_display_page(DISPLAY_PAGE *display);
Int_PRO  _gfx_init_selection_page(void);
Int_PRO  _gfx_set_selection_hot_spots(void);
Void_PRO _gfx_reset_sbox(int  item_n,int  arrow_key);
Void_PRO _gfx_set_text_cursor(void);
EventPtr_PRO _gfx_get_curr_response(void);
EventPtr_PRO _gfx_get_font_line(int  x,int  y,char  *tp,int  max_n_char,
                 struct _ventry *entry);
Void_PRO _gfx_init_form_page(void);
Void_PRO _gfx_reset_fbox(int  resp_n);
Int_PRO  _gfx_resp_n_to_entry_n(int  response_n);
Int_PRO  _gfx_set_responses_at_page_ends(void);
Void_PRO _gfx_reset_fbox_crsr(EVENT *ev);
Int_PRO  _gfx_init_scroll_bar(BOX_DIM *bdim);
Void_PRO _gfx_reset_slide_bar_top_item_n(void);
Int_PRO  _gfx_drag_scroll_bar_button(void);
Void_PRO _gfx_display_scroll_bar(BOX_DIM *bdim);
Void_PRO _gfx_menus_box(int  x1,int  y1,int  x2,int  y2,int  color);
Void_PRO _gfx_draw_mouse_cursor(int  x,int  y);
Int_PRO  _gfx_draw_3D_border(int  border_type);

	/* Functions for 16-bit protected mode */
#if (PROT_MODE_SYS == PMODE_16)
UtinyFarPtr_PRO _gfx16_xlat_real_to_prot(UTINY_FAR *real_mode_ptr);
Uint_PRO _gfx16_alloc_selector(unsigned int segment, long segment_sz);
#endif

	/* Functions for 32-bit protected mode */
#if (PROT_MODE_SYS == PMODE_32)
Void_PRO _gfx32_init_ramrom_fonts(void);
Void_PRO _gfx32_link_mouse_interface(int link_handler);
#endif

	/* HPGL functions */
Int_PRO  _gfx_HPGL_vec(int fcn_n, int *args);

#if defined (__cplusplus)
	}
#endif

#endif
