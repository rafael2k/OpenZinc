                /*****************************************/
                /*  Copyright C Source, Inc. 1987 - 1993 */
                /*  All Rights Reserved                  */
                /*****************************************/

         /*******************************************************
          *  This file contains all the prototypes for the      *
          *  low-level, public C functionsin the GFX Graphics   *
          *  Library. Be sure to include this file if you       *
          *  use any of these functions.                        *
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


#if !defined (__GFXG_PRO_)
#define __GFXG_PRO_

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

Void_PRO _gfx_force_on_planes(void);
Void_PRO _gfx_force_off_planes(void);
Int_PRO  _gfx_get_color(int color);
Int_PRO  _gfx_in_viewport(void);
Int_PRO  _set_gfx_err_number(int err_code_name);
Void_PRO _gfx_puts(char  *tp);
Void_PRO _gfx_set_view_clip_coor(int set_to_viewport,struct _vu *view,int *clip_coor);
Void_PRO _gfx_get_card_type(void);
Int_PRO  _get_int_pt(int *arg);
Void_PRO _gfx_rotate_coor(ICOOR *);
Void_PRO _gfx_turn_on_abs_point(void);
Void_PRO _gfx_turn_off_abs_point(void);
Int_PRO  _gfx_abs_point_val(void);
Int_PRO  _gfx_xlat_coor(int type,int val);
Int_PRO  _gfx_malloc_coor_stack(int n_coor,int coor_elem_sz,int flags);
Void_PRO _gfx_free_coor_stack(void);
Void_PRO _gfx_convert_coor_pt(COOR_PT *cpt, int type);
Int_PRO  _gfx_get_box_coor_pair(int check_type_stack,int *args,struct _box_coor *bcp);
Void_PRO _gfx_clip_box_coor_pair(struct _box_coor *bcp);
Void_PRO _gfx_fillbox(int x1,int y1,int x2,int y2,int color);
Void_PRO _gfx_color_box(int x1,int y1,int x2,int y2,int color);
Int_PRO  _gfx_drawline(int x1,int y1,int x2,int y2,int color,int pattern,int start_bit);
Void_PRO _gfx_fast_hline(int x,int y,int len,int n_lines,int color);
Void_PRO _gfx_fill_fig_with_1_line(int x1,int y1,int x2,int fill_color);
Void_PRO _gfx_set_pat_frame_delta(int delta);
Void_PRO _gfx_set_fill_pat(unsigned char *pat, int pat_color, int bkgnd_color);
Void_PRO _gfx_pat_line(int x,int y,int len);
Void_PRO _gfx_cls(void);
Void_PRO _gfx_view_cls(struct _vu *view,int color);
Void_PRO _gfx_draw_oval(void);
Void_PRO _gfx_no_clip_outline_oval(int dx,int dy);
Void_PRO _gfx_no_clip_fill_oval(int dx,int dy);
Void_PRO _gfx_general_oval(int dx,int dy);
Int_PRO  _gfx_get_arc_points(void);
Void_PRO _gfx_draw_pat_arc_points(int arc_pat_mask,int start_sp,int n_dots);
Void_PRO _gfx_get_oval_values_from_stack(int *args,int type);
Uint_PRO _gfx_calc_trig_point(int angle, int radius, int is_cosine);
Long_PRO _gfx_sin_cos(int degree, int flags);
Void_PRO _gfx_draw_curve(void);
Void_PRO _gfx_record_arc_coor(int dx,int dy);
Void_PRO _gfx_set_quad_bounds(void);
Void_PRO _gfx_oval_quad_pix(int dx,int dy);
Void_PRO _gfx_record_arc_dots(int dx,int dy);
Void_PRO _gfx_draw_oval_arc(void);
Void_PRO _gfx_set_arc_parameters(void);
Int_PRO  _gfx_clip_quads(void);
Int_PRO  _gfx_oval_is_clipped(void);
Void_PRO _gfx_arc_box_1_quad(int dx,int dy);
Int_PRO  _gfx_get_DRAW_coor(int type,int *curr_log_coor,int N,int draw_scale);
Int_PRO  _gfx_scale_DRAW_coor(int coor,int scale,int type,int *curr_log_coor,int is_relative_point,int N);
Int_PRO  _gfx_get_DRAW_numeric_arg(int type);
Void_PRO _gfx_skip_blanks(void);
Int_PRO   gfx_open(char  *file_name,int type_open);
Int_PRO   gfx_close(unsigned int dos_handle);
Int_PRO   gfx_delete_file(char  *filename);
Int_PRO   gfx_open_mem_file(int mem_type,UTINY_FAR *buf,long  max_buf_size);
Int_PRO   gfx_close_mem_file(int fh);
Long_PRO  gfx_lseek(int dos_handle,long  l_offset,int mode);
Int_PRO   gfx_file_io(UTINY_FAR *bufptr,unsigned int n_bytes,int dos_handle,int fcn_type);
Long_PRO  gfx_huge_file_io(UTINY_FAR *bufptr, long buf_size, int dos_handle, int fcn_type);
Uint_PRO _gfx_huge_move(UTINY_FAR *huge_base, long huge_offset, UTINY_FAR *small_buf, unsigned int n_bytes, int dir);
Int_PRO  _gfx_curr_view_nmbr(void);
Int_PRO  _gfx_set_view_coordinates(struct _vu *view,int x,int y);
Int_PRO  _gfx_switch_view(int new_view_n, int hide_view);
Int_PRO  _gfx_swap_view_pic(struct _vu *view);
Void_PRO _gfx_restore_view_pic(struct _vu *view);
Int_PRO  get_flt_pt(int *arg);
Void_PRO _gfx_set_get_dbl_val(int set_or_get,int *user_val,int *gfx_val);
Void_PRO _gfx_reset_flog_coor(void);
Int_PRO  _gfx_DRAW_flt_args(int type,char  *arg,int scale,int is_relative_point,int set_new_log_point);
Uint_PRO _gfx_ptr_in_huge_buf(UTINY_FAR *buf,long  offset,UTINY_FAR * *norm_buf,unsigned int n_bytes);
Int_PRO  _gfx_call_86x(int int_nmbr,void *reg,unsigned char  *ds_buf,unsigned char  *es_buf);
Int_PRO  _gfx_farcall_86x(int int_nmbr,void *reg,UTINY_FAR *ds_buf,UTINY_FAR *es_buf);
Void_PRO _gfx_turn_on_grey_scale(void);
Void_PRO _gfx_set_screen_base(unsigned int segment);
Int_PRO  _gfx_create_blob_file(char *fname, int max_blobs, int name_len);
Int_PRO  _gfx_open_blob_file(char *fname, int update_file);
Int_PRO  _gfx_close_blob_file(int blob_handle);
Int_PRO  _gfx_lseek_blob(int index,int blob_handle,long  *file_size,int *blob_type,int fcn_n);
Int_PRO  _gfx_get_new_blob_handle(struct _blobcb * *new_blob_cb);
Int_PRO  _gfx_get_blob_cb(int blob_handle,struct _blobcb *blob_cb,int fcn_n);
Int_PRO  _gfx_get_blob_name_index(char *name, int blob_handle, int fcn_n);
Void_PRO _gfx_free_blob_cb(int blob_handle);
Void_PRO _gfx_write_blob_header(struct _blobcb *blob_cb);
Int_PRO  _gfx_update_blob_file(int blob_handle,int item_index,int blob_type,long  blob_size,int *file_handle,int fcn_n);
Int_PRO  _gfx_get_blob_item(struct _blobindx *blob_item,int item_index,int blob_handle,int fcn_n);
Int_PRO  _gfx_set_blob_item(struct _blobindx *blob_item,int item_index,int blob_handle,int update_file);
Int_PRO  _gfxx_get_image(struct _box_coor *bc, struct _pic *pic);
Void_PRO _gfxx_get_pic(struct _box_coor *bc, struct _pic **picptr);
int	    _gfxx_put_pic(int x, ... );
int      _gfxx_put_fpic(int x, ...);

Int_PRO  _gfx_free_pic(struct _pic *user_pic);
Void_PRO _gfx_init_pic_struct(struct _pic *pic, int image_type);
Int_PRO  _gfx_init_pic_struct_for_blob(struct _pic *pic, int item_index, int blob_handle, int flags);
Int_PRO  _gfx_delete_blob_item(int item_index, int blob_handle);
Void_PRO _gfx_set_pic_area_param(struct _pic *pic);
Int_PRO  _gfx_lo_get_image(struct _pic *, int);
Void_PRO _gfx_init_PCX_hdr(struct _pic *pic,struct _pcxhdr *usr_pcx_hdr);
Int_PRO  _gfx_open_PCX_file(char *fname, struct _pic *pic, struct _pcxhdr *hdr, int fcn_n);
Int_PRO  _gfx_read_pic_struct(DMEM_HANDLE pic_mc, struct _pic *pic, int fcn_n);
Void_PRO _gfx_write_pic_struct(DMEM_HANDLE pic_mc, struct _pic *pic);
Int_PRO  _gfx_put_ram_image(struct _pic *pic, int action, int fcn_n);
Void_PRO _gfx_xlat_color_pal(UTINY_FAR *inbuf, UTINY_FAR *outbuf, int type);
Void_PRO _gfx_get_ega16_pal(UTINY_FAR *pal16_buf);
Int_PRO  _gfx_lo_put_image(struct _pic *user_pic,int action,int fcn_n);
Void_PRO _gfx_put_PCX_16_pal(UTINY_FAR *rgb, int base_color, int n_colors);
Void_PRO _gfx_remap_256_color_pal(UTINY_FAR *color_buf, int n_colors, UTINY_FAR *source_DACs, UTINY_FAR *dest_DACs, int n_DACs);
Long_PRO _gfx_load_PCX_header(int fh,struct _pcxhdr *pcx_hdr,int *_256_pal_exists);
Long_PRO _gfx_xlat_data(int rle_2_pcx,int in_fh,int out_fh,UTINY_FAR *read_buf,unsigned int buf_size,long  image_size,int bytes_per_line,int n_planes);
UtinyFarPtr_PRO _gfx_load_blob_item(UTINY_FAR *buf, FAR_DMEM_HANDLE *mc, 
   long *read_n_bytes,int item_index,int blob_handle,int blob_type,int fcn_n);
UtinyFarPtr_PRO _gfx_load_huge_file(int source_fh,UTINY_FAR *far_buf,
   FAR_DMEM_HANDLE *mc, long  *fsize,int fcn_n);
Int_PRO  _gfx_lo_get_image_size(struct _pic *pic);
Long_PRO _gfx_move_vidram(struct _pic *user_pic,int action);
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

	/* Functions for 16-bit protected mode */
#if (PROT_MODE_SYS == PMODE_16)
Int_PRO  _gfx16_is_good_ATI_mode(int mode_n);
Uint_PRO _gfx16_alloc_selector(unsigned int segment, long segment_sz);
Int_PRO  _gfx16_free_selector(unsigned selector);
Void_PRO _gfx16_ns_int86x(int int_nmbr, void *reg, int _DS, int _ES);
Int_PRO  _gfx16_alloc_real_mem(unsigned int n_bytes, unsigned int *segment, unsigned int *selector);
Void_PRO _gfx16_free_real_mem(unsigned int selector);
Int_PRO  _gfx16_check_for_VESA(int *VESA_modes, VESA_RES *vres);
Void_PRO _gfx16_init_VESA_switching(int VESA_mode_n);
UtinyFarPtr_PRO _gfx16_xlat_real_to_prot(UTINY_FAR *real_mode_ptr);
#endif

	/* Functions for 32-bit protected mode */
#if (PROT_MODE_SYS == PMODE_32)
Void_PRO _gfx32_init_pmode(void);
Void_PRO _gfx32_pmode_screen_base(unsigned int seg);
Void_PRO _gfx32_set_video_selector(int video_seg);
Void_PRO _gfx32_free_DOS_mem(MEM32 *mem);
Int_PRO  _gfx32_alloc_DOS_mem(int n_bytes, MEM32 *mem);
Int_PRO  _gfx32_check_for_VESA(int *VESA_modes, VESA_RES *vres);
Void_PRO _gfx32_initialize_VESA_switching(int VESA_mode_n);
Long_PRO *_gfx32_add_mem_block(int selector, int n_kbytes);
#endif

	/* HPGL functions */
Int_PRO  _gfx_HPGL_vec(int fcn_n, int *args);

#if defined (__cplusplus)
	}
#endif

#endif

