                /*****************************************/
                /*  Copyright C Source, Inc. 1987 - 1993 */
                /*  All Rights Reserved                  */
                /*****************************************/

#if !defined (__GFXG_SRC_)
#define __GFXG_SRC_

#if (INCLUDE_BUILD_FILES == 1)
#include "GFX.H"
#include "GFX_ERR.H"
#include "GFX_SRC.H"
#include "GFX_PRO.H"
#include "GFXLOPRO.H"
#endif

#define IS_ROUND                1
#define USES_ANGLES             2
#define OFF_SCREEN              -1

typedef struct {int x, y;} COOR;

#define L_TO_R          0x4
#define r_find_pel(x, y, color) _gfx_find_pel(x, y, color, L_TO_R)
#define l_find_pel(x, y, color) _gfx_find_pel(x, y, color, 0x0)
#define r_find_npel(x, y, color)        _gfx_find_pel(x, y, color, 0xFF00 | L_TO_R)
#define l_find_npel(x, y, color)        _gfx_find_pel(x, y, color, 0xFF00)

#define IS_COSINE       0x01                    /* flags for _gfx_sin_cos() */
#define USE_ABS 0x80

#define GFX_TO_PCX      0x400           /* flags for _gfx_xlat_color_pal() */
#define PCX_TO_GFX      0x800


#if defined (USE_PAS_M2)

#define alloc_GFX_workspace(a,b)                AllocGFXWorkspace(a,b)
#define init_GFX_struct(a)              InitGFXStruct(a)                
#define screen(a)                                       Screen(a)
#define set_video_resolution(a, b)           SetVideoResolution(a, b)
#define map_EGA_palette(a, b)                MapEGAPalette(a, b)
#define get_SVGA_info(a,b)                      GetSVGAInfo(a,b)
#define close_view_file()                       CloseViewFile()

#elif defined (USE_UPPER_C)

#define alloc_GFX_workspace(a,b)                ALLOC_GFX_WORKSPACE(a,b)
#define init_GFX_struct(a)                INIT_GFX_STRUCT(a)    
#define screen(a)                                    SCREEN(a)
#define set_video_resolution(a, b)           SET_VIDEO_RESOLUTION(a, b)
#define map_EGA_palette(a, b)                MAP_EGA_PALETTE(a, b)
#define get_SVGA_info(a,b)                   GET_SVGA_INFO(a,b)
#define close_view_file()                    CLOSE_VIEW_FILE()
                                        
#endif                                  


/* OLD FPIC DEFINES */
typedef struct _fpic_cb {unsigned int signature, type;
                         int dos_handle, max_fpics;
                         long *pic_pos;
                        } FPIC_CB;

#define FPIC_HDR_SIZE              (sizeof(FPIC_CB) - sizeof(long *))
#define fpic_loc(fpic_cb, index)   (*((fpic_cb)->pic_pos + (index)))

#define MAX_FPIC_CB             16


typedef struct _opic {unsigned int xbytes;
                unsigned int yrows;
                unsigned int n_pels_per_row;
                unsigned char lopen_bits;
                unsigned char ropen_bits;} OLDPIC;


                /* The next two structures are used
                 * by curved routines oval, circle etc 
                 */

typedef struct _govl { int x_center, y_center;
                       int x_radius, y_radius;
                                   int x_aspect, y_aspect;
                                   int x_start, y_start, x_end, y_end;
                       int start_angle, angle_width;
                       int n_quad, quad_mask, inv_quad, n_arc_pel;
                       int flush, color, clip_oval;
                       CLIP_REGION quad_bnd[4], *clip_bnd;
                       void (_pascal *write_pix)(int, int);
                       void (_pascal *chain_arc)(int, int);
                     } OVL;



/* Version 3.0 macro definitions */

#define CLIP_COOR_PAIR          0x200
#define SET_WIDTH_HGT           0x400
#define GET_PIC_DIM                     0x600

#define GET_IMAGE_SIZE          0x200
#define GET_BEST_IMAGE_SIZE     0x400


#define _gfx_read_next_vid_line(buf, x_bytes)                           _gfx_move_next_vid_line(buf, x_bytes, x_bytes, 0, 0)
#define _gfx_write_vid_line(buf, x_bytes, show_bytes, masks)    _gfx_move_next_vid_line(buf, x_bytes, show_bytes, masks, 1)

#define PIC_SIG                         0x527A
#define is_legal_pic(pic)               (pic.signature==PIC_SIG)
#define is_legal_pic_ptr(pic)           (pic->signature==PIC_SIG)

typedef struct tl {int init_solid_color, init_pat_color, init_bkgnd_color;
                      int pat_color, bkgnd_color;
                      int n_bytes, n_rows, frame_color;
                      unsigned char *bitmap;
                     } TILE;

typedef struct _gfxpat {
          TILE fill;
          int   clip_lines;
          unsigned int line;
          void (_pascal *line_fcn)(int, int, int);
          } GFX_PAT;
          
typedef struct _gfxcoor {
          int *stack;
          int sp;
          int max_n;
          int flags;
          int elem_sz;
                } GFX_COOR;


                /* DEFINITIONS FOR SUPER VGA MODES */

#define VESA                    0x100
#define VESA_1                  0x101

#define ATI_CHIPSET             0x200
#define ATI_18800_1             0x201
#define ATI_18800_2             0x202       /* This also covers the 28800 */

#define WD_CHIPSET              0x300
#define WD_PVGA1A               0x301
#define WD_90C00             0x302
#define WD_90C10                0x303
#define WD_90C11                0x304
#define WD_90C30                0x305

#define TSENG_CHIPSET   0x400
#define TSENG_ET3000    0x401
#define TSENG_ET4000    0x402

#define HLAND_CHIPSET   0x500
#define HLAND_VEGA              0x501
#define HLAND_V7VGA_1   0x502
#define HLAND_V7VGA_4   0x503
#define HLAND_1024i      0x504

#define TRIDENT_CHIPSET 0x600
#define TRIDENT_8800BR  0x601       /* very rare: see pg.907 of Ferraro */
#define TRIDENT_8800CS  0x602
#define TRIDENT_8900     0x603
#define TRIDENT_9000     0x604

#define AHEAD_CHIPSET   0x700
#define AHEAD_V5000_A    0x701
#define AHEAD_V5000_B    0x702

#define OAK_CHIPSET             0x800
#define OAK_OTI_067      0x801

#define GENOA_CHIPSET   0x900
#define GENOA_SUPERVGA  0x901

#define S3_CHIPSET              0xA00
#define S3_86C911               0xA01

#define CIRRUS_CHIPSET  0xB00
#define CIRRUS_GD5410   0xB01
#define CIRRUS_GD542X   0xB02
#define CIRRUS_GD543X   0xB03


#define VESA_BIOS               VESA
#define ATI_BIOS                ATI_CHIPSET
#define WD_BIOS         WD_CHIPSET
#define TSENG_BIOS              TSENG_CHIPSET
#define HLAND_BIOS              HLAND_CHIPSET
#define TRIDENT_BIOS    TRIDENT_CHIPSET
#define AHEAD_BIOS              AHEAD_CHIPSET
#define OAK_BIOS         OAK_CHIPSET
#define GENOA_BIOS       GENOA_CHIPSET
#define S3_BIOS         S3_CHIPSET
#define CIRRUS_BIOS      CIRRUS_CHIPSET

                /* BLOB structures */

#define BLOB_SIGNATURE          0xCABC0100
                                       
typedef PACKED struct _blobhdr {
                                        long  signature;
                            long         item_index_pos;
                            short int n_index_items;
                            short int name_len;
                           } BLOB_HEADER; 

#define UPDATE_BLOB_FILE                0x1

typedef struct _blobcb  {BLOB_ITEM *base_index;
                         char *base_names;
                         long  item_index_pos;
                         int name_len;
                         int n_index_items;
                         int fh;
                         int flags;
                         DMEM_HANDLE mc;
                        } BLOB_CB;


/* ALT IO STRUCTURE AND DEFINES */

typedef struct _m { int is_hooked;
                                int err_nmbr;
                                union _x {int  _int;
                                                long _long;} rtn_val;
                                int (*fcn_vec[5])();
                                } ALT_IO;

#define ALT_GFX_OPEN            0
#define ALT_GFX_CLOSE           1
#define ALT_GFX_DELETE_FILE     2
#define ALT_GFX_FILE_IO         3
#define ALT_GFX_LSEEK           4


#if !defined (__MSC_32__)
#if defined (_MSC_VER) && defined (_M_IX86)
#define __MSC_32__   ( (_MSC_VER >= 800) && (_M_IX86 >= 300) )
#else
#define __MSC_32__   0
#endif
#endif

#if defined (_I386) || defined (__386__) || (defined(__ZTC__) && (__I86__ >= 3)) || (__MSC_32__ > 0)
typedef long LONG_FAR;
#elif defined (__HIGHC__)
typedef _far long LONG_FAR;
#elif (defined(__TURBOC__) && (__TURBOC__ <= 0x201)) || defined(_QC)
#define LONG_FAR   long far
#else
typedef long  far  LONG_FAR;
#endif


typedef struct _mll { unsigned int header_bytes;
                      LONG_FAR *lp;
                      void (* malloc_safe_block)(long, long);
                      void (* free_safe_block)(long);
                           } SAFE_MALLOC_LINK;

#if (INCLUDE_BUILD_FILES == 1)
#include "GFXG_PRO.H"
#endif

#endif

