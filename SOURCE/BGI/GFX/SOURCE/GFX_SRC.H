                /*****************************************/
                /*  Copyright C Source, Inc. 1987 - 1993 */
                /*  All Rights Reserved                  */
                /*****************************************/


#if !defined (__GFX_SRC_)
#define __GFX_SRC_

       /***********************************************************
        * This section sets constants for compiling the libraries *
        ***********************************************************/

		/*  This first #define must be set to 1, to enable error display.
		 */

#define SHOW_ERR_TEXT		0    /* Set to 1 to enable display of errors */

		
		/*  The following are maximum sizes for some arrays of objects: 
		 *  you can modify the size for the array by setting a new value
		 *  for the macro constant.
		 */
				/* Constants in GFXG_C.C */
#define MAX_VIEWS			16	/* Max # of viewports open simultaneously */
#define MAX_BLOB_CB			 8	/* Max # of blob files open simultaneously */
#define MAX_VMEM_HANDLES		 0	/* Not currently used */
			     /* Constants in GFXF_C.C */
#define MAX_FONT_HANDLES		16	/* Max # of fonts open simultaneously */
			     /* Constants in GFXM_C.C */
#define MAX_EVENTS_IN_QUEUE	 6	/* Max # of events held in the event queue */
#define MAX_MENU_HOT_SPOTS	50	/* Max # of hot spots on screen simult. */


		/*  The next #define can be used if you don't want the standard
		 *  malloc() and free() functions linked into your program.
           */
#define USE_DFLT_MALLOC		1	/* You may modify this #define */


		/*  The next set of macros can be used to compile code that
		 *  lets you use file i/o that you provide, instead of the
		 *  standard GFX io functions.
		 */

#define USE_GFX_IO			1
#define USE_ALT_IO       	0
#define USE_VMEM_IO      	0	/* Do not modify this one */


		/* Don't use malloc()/free() when linking 
		 * with Turbo Pascal
		 */
#if (LINK_TO_PASCAL == 1)
#undef  USE_DFLT_MALLOC
#undef  USE_DFLT_MALLOC		0 
#endif
		/* Don't use malloc()/free() or DOS i/o when
		 * linking with VRTX Velocity System 
		 */
#if (VDOS386 == 1)
#undef  USE_DFLT_MALLOC
#undef  USE_GFX_IO
#undef  USE_ALT_IO
#undef  USE_VMEM_IO

#define USE_DFLT_MALLOC		0 
#define USE_GFX_IO			0
#define USE_ALT_IO       	1
#define USE_VMEM_IO      	0
#endif
     
      
       /*******************************************************
        * This section defines the Protected Mode Environment *
        *******************************************************/

#define REAL_MODE		0
#define PMODE_16		16
#define PMODE_32		32

#define PHAR_LAP		1
#define RATIONAL		2
#define ERGO			3
#define ZORTECH		4

#if defined (PM)
#define PROT_MODE_SYS	PM
#endif

#if defined (K32)
#define KOMPACT_32	1
#endif

#if defined (DOSX16)
#define DOS16_EXTENDER	DOSX16
#endif

#if defined (DOS16M)
#define DOS16_EXTENDER RATIONAL
#define MForceLow 3
#define LPVOID void far *
#define D16API pascal _loadds far
#endif

#if !defined (DOS16_EXTENDER)
#define DOS16_EXTENDER	0
#endif

#if defined (DOSX32)
#define DOS32_EXTENDER	DOSX32
#endif

#if !defined (DOS32_EXTENDER)
#define DOS32_EXTENDER	0
#endif

#if !defined (PROT_MODE_SYS)
#define PROT_MODE_SYS    0
#endif


       /*******************************************************
        *  Now for some data type and keyword re-definitions  *
        *******************************************************/
        
/* the pseudo storage classes
 */
#define FAST	register
#define GLOBAL extern
#define PUBLIC extern
#define IMPORT extern
#define LOCAL	static


/* the pseudo types
 */

typedef void * VOID_PTR;
typedef char TINY, TEXT;
typedef unsigned char UTINY;
typedef int BOOL, INT;
typedef unsigned int  UINT;
typedef long LONG;
typedef double DBL;

#if !defined (__MSC_32__)
#if defined (_MSC_VER) && defined (_M_IX86)
#define __MSC_32__   ( (_MSC_VER >= 800) && (_M_IX86 >= 300) )
#else
#define __MSC_32__   0
#endif
#endif

#if defined (_I386) || defined (__386__) || (defined(__ZTC__) && (__I86__ >= 3)) || (__MSC_32__ > 0)
typedef unsigned int UWORD_FAR;
typedef int INT_FAR;
typedef unsigned short int UWORD;
typedef short int WORD;
#elif defined (__HIGHC__)
typedef _far unsigned int  UWORD_FAR;
typedef _far int  INT_FAR;
typedef unsigned short int UWORD;
typedef short int WORD;
#elif (defined(__TURBOC__) && (__TURBOC__ <= 0x201)) || defined(_QC)
#define UWORD_FAR  unsigned int  far
#define INT_FAR    int far
#define UWORD 	    unsigned short int 
#define WORD 	    short int 
#else
typedef unsigned int  far  UWORD_FAR;
typedef int   far  INT_FAR;
typedef unsigned short int UWORD;
typedef short int WORD;
#endif

/* pseudo operators
*/
#define AND		&&
#define OR		||
#define then

/* system parameters
*/
#define NULL			0
#define EOF		   (-1)

#define TRUE			1
#define FALSE			0

#define YES			1
#define NO			0

#define SUCCESS		1
#define FAILURE		0

#define ON			1
#define OFF			0

#define POS			1
#define NEG		    -1

#define NULL_PTR		0
#define PTR_SHIFT		1
#define BUFSIZE		512
#if (KOMPACT_32 == 1)
#define POINTER_ON_STACK	2
#else
#define POINTER_ON_STACK sizeof(void *) / sizeof(int)
#endif
#define DMEM_HANDLE_ON_STACK	POINTER_ON_STACK


/*		 general macros
*/
#define abs(x) 		((x) < 0 ? -(x) : (x))
#define abs_flt(x)		((x) < 0.0 ? -(x) : (x))
#define inrange(a,x,b)	((a) <= (x) && (x) <= (b))
#define isdigit(c)		inrange('0', (c), '9')
#define LOOP			for(;;)
#define max(x, y)		(((x) < (y)) ? (y) : (x))
#define min(x, y)		(((x) < (y)) ? (x) : (y))
#define swap(a,b,c)		(c=a, a=b, b=c)
#define toupper(c)		(inrange('a', c, 'z') ? (c) - ('a' - 'A') : (c))

#define zfill(tp, len)	_gfx_fill(tp, len, 0)
#define strlen(tp)		_gfx_findb(tp, 1000, 0)


                      /*******************************
                      *  Some graphics definitions  *
                      *******************************/

#define MED_RES		0x100		/* Values for gfx.gfx_mode */
#define HIGH_RES		0x2
#define E_RES_MONO		0x4
#define E_RES_COLOR		0x204
#define HERCULES		0x6
#define _256_COLOR		0x8
#define MONO_BITMAP		0xA
#define UNDEFINED_GFX	0xFF08

#define MDA_MEM		0xB000		/* Values of gfx.screen_base */
#define CGA_MEM		0xB800
#define EGA_MEM		0xA000

#define SOLID_LINE_PAT		-1
#define MULTI_PLANAR		0x80			/* _gfx.sys_flags */
#define ROTATE_SCREEN_90		0x100
#define ROTATE_SCREEN_270	0x200
#define ROTATE_SCREEN		0x300

#define is_an_ega_mode()		(_gfx.gfx_mode & E_RES_MONO)
#define is_ega_color_mode()	(_gfx.gfx_mode == E_RES_COLOR)

#define turn_off_color_flags() (_gfx.color_flags = 0)
#define fill_area()			(_gfx.color_flags & (FILL_PAT+FILL_SOLID))
#define set_ega_planes()		(_gfx.sys_flags & MULTI_PLANAR)
#define turn_on_ega()		if (set_ega_planes()) then (_gfx.color_flags&XOR_PEL) ? _gfx_set_ega_modify_type(3) : _gfx_set_w2_ega_mode();
#define turn_off_ega()		if (set_ega_planes()) then _gfx_clean_up_ega();


#define is_int_view()		(_gfx.xlat_scale != FLOAT_SCALE)
#define is_float_view()		(_gfx.xlat_scale == FLOAT_SCALE)
#define FLOAT_SCALE		123

#if (VDOS386 == 1)
extern void sys_dos_return(void);
#define _gfx_exit(a)		sys_dos_return()
#else
#define _gfx_exit(a)		exit(a)
#endif

/***************************************************************************
 *  The following structure/union definitions are equivalent to structures *
 *  used in the int86() and int86x() function calls. They are followed by  *
 *  prototypes for int86() and int86x() and then macros that use them in   *
 *  the code.                                                              *
 ***************************************************************************/
   
#if (PROT_MODE_SYS == PMODE_32)
typedef PACKED struct { UTINY al, ah, xax[sizeof(int)-2];
				    UTINY bl, bh, xbx[sizeof(int)-2];
				    UTINY cl, ch, xcx[sizeof(int)-2];
				    UTINY dl, dh, xdx[sizeof(int)-2];
				    UINT si, di, cflag, flags;
				  } REG_HL;
#else
typedef struct { UTINY al, ah;
			  UTINY bl, bh;
			  UTINY cl, ch;
			  UTINY dl, dh;
			  UINT si, di, cflag, flags;
			} REG_HL;
#endif


typedef struct { UINT ax, bx, cx, dx, si, di, cflag, flags;
			} REG_X;

typedef union {  REG_HL _hl;
			  REG_X  _x;} REG;

typedef PACKED struct { UWORD es, cs, ss, ds;
				  } SREGS;

#if (DOS16_EXTENDER == PHAR_LAP) 
typedef struct {UINT es, ds, di, si, bp, sp, bx, dx, cx, ax;
			 UINT ip, cs, flags;} REGS16;
#endif


#if defined (__386__) && (defined (__WATCOMC__) || defined (__EXPRESSC__))
INT int386(INT int_nmbr, REG *in_reg, REG *out_reg);
INT int386x(INT int_nmbr, REG *in_reg, REG *out_reg, SREGS *sregs);
#define int86(a,b,c)		int386(a,b,c)
#define int86x(a,b,c,d)		int386x(a,b,c,d)
#endif

#if (__MSC_32__ > 0)
INT _gfx32_int86(INT int_nmbr, void *in_reg, void *out_reg);
INT _gfx32_int86x(INT int_nmbr, void *in_reg, void *out_reg, void *sregs);
#define int86(a,b,c)		_gfx32_int86(a,b,c)
#define int86x(a,b,c,d)		_gfx32_int86x(a,b,c,d)
#endif


#if (PROT_MODE_SYS == PMODE_16)
#define call_ns_crt(reg)	     _gfx16_ns_int86x(0x10, (REG_X *) &reg, 0, 0);
#else
#define call_ns_crt(reg)	     int86(0x10, (REG *)&reg, (REG *)&reg)
#endif

#define call_crt(reg)		int86(0x10, (REG *)&reg, (REG *)&reg)
#define call_dos(reg)		int86(0x21, (REG *)&reg, (REG *)&reg)
#define bad_dos_call(reg)	(reg.cflag != 0)
#define good_dos_call(reg)	(reg.cflag == 0)

#define call_crtx(reg, dsbuf, esbuf)	_gfx_call_86x(0x10, (REG *)&reg, (UTINY *) dsbuf, (UTINY *) esbuf)
#define call_dosx(reg, dsbuf, esbuf)	_gfx_call_86x(0x21, (REG *)&reg, (UTINY *) dsbuf, (UTINY *) esbuf)

	/* graphics cursor */
typedef struct gc {int pt_x, pt_y;
                   int ilog_x, ilog_y;
                   double flog_x, flog_y;
                  } CRSR;

            /***************************************************
             *  Macros to get the segment and offset a pointer
            ***************************************************/

#if (PROT_MODE_SYS == PMODE_32)
#if (KOMPACT_32 == 1)
#define ptr_segment(farptr) (*(unsigned short *)((unsigned *)&(farptr) + 1))
#define ptr_offset(farptr)  (*((unsigned *)&(farptr)))
#define is_far_ptr(ptr)		(YES)
#define _gfx_int86x(a,b,c,d)	int86x(a,b,c,d)
#else
#define ptr_segment(ptr)		(0)
#define ptr_offset(ptr)		((UINT)ptr)
#define is_far_ptr(ptr)		(NO)
#define _gfx_int86x(a,b,c,d)	int86(a,b,c)
#endif
#else
#if defined(__TURBOC__)
#define ptr_segment(ptr) 	((unsigned)( void _seg *)(void far *)(ptr))
#define ptr_offset(ptr)  	((unsigned)(ptr))
#else
#define ptr_segment(ptr)		(*((unsigned *)&(ptr) + 1))
#define ptr_offset(ptr)	     (*((unsigned _far *)&(ptr)))
#endif
#define is_far_ptr(ptr)		(sizeof(ptr) > sizeof(short))
#define _gfx_int86x(a,b,c,d)	int86x(a,b,c,d)
#endif

                           /********************
                            *  GFX error info  *
                           *********************/

extern int _gfx_file_write_err;
#define _gfx_error(text_string)    		_set_gfx_err_number(0, text_string)
#define _gfx_err_number(err_nmbr, fcn_nmbr)	_set_gfx_err_number(err_nmbr | fcn_nmbr)


           /*****************************************************
            *  Definitions, macros and structures for file i/o  *
           *****************************************************/


typedef struct _memio  { long buf_offset, buf_size;
	                    UTINY_FAR *buf;
	                  } VMEMIO;  

#define OPEN_FILE		0x3D02
#define OPEN_RW_FILE	0x3D02
#define OPEN_READ_FILE	0x3D00
#define CREATE_FILE		0x3C00

#define gfx_write(buf,n_bytes,fd)		gfx_file_io((UTINY_FAR *)buf,n_bytes,fd,0x4000)
#define gfx_read(buf,n_bytes,fd)		gfx_file_io((UTINY_FAR *)buf,n_bytes,fd,0x3F00)
#define gfx_huge_write(buf,n_bytes,fd)	gfx_huge_file_io((UTINY_FAR *)buf,n_bytes,fd,0x4000)
#define gfx_huge_read(buf,n_bytes,fd)	gfx_huge_file_io((UTINY_FAR *)buf,n_bytes,fd,0x3F00)

#define HUGE_TO_SMALL			10		/* for _gfx_huge_move() */
#define SMALL_TO_HUGE			20

	/* Macros for future malloc() facilities */

#if (PROT_MODE_SYS == PMODE_32)
#define _gfx_farmalloc_mc(a,b)	(UTINY_FAR *)_gfx_malloc_mc(a,b)
#define _gfx_farfree_mc(a)		_gfx_free_mc(a)
#endif

#define MOBILE_DMEM		0

#if (MOBILE_DMEM == 0)
#define _gfx_unlock_mc(a)		
#define _gfx_deref_mc(a)		(a)
#define _gfx_deref_farmc(a)	(a)
#endif

typedef struct _ws { UINT n_kbyte_buf, n_kbytes_free;
				 FAR_DMEM_HANDLE buf_mc;
				 UTINY_FAR *buf;
			    } WORKSPACE;

#if defined (USE_HPGL)
#define GFX_VVEC(a, b)	if (_gfx_vec && _gfx_vec(a, b)) return;
#define GFX_IVEC(a, b)	if (_gfx_vec && _gfx_vec(a, b)) return _gfx_vec_rtn;
#define GFX_VVEC_PRO	extern int (_pascal *_gfx_vec)(int, int *)
#define GFX_IVEC_PRO	extern int (_pascal *_gfx_vec)(int, int *), _gfx_vec_rtn
#else
#define GFX_VVEC(a, b)      
#define GFX_IVEC(a, b)        
#define GFX_VVEC_PRO        
#define GFX_IVEC_PRO        
#endif

#define PLOT			0x100
#define NO_SCALE		0x200
#define VBOX			0x01 + PLOT
#define VCIRCLE     	0x02 + PLOT
#define VCIRCLE_ARC		0x03 + PLOT
#define VDRAW_LINE		0x04 + PLOT
#define VFASTFILL		0x05 + PLOT
#define VMOVE_TO		0x06 + PLOT
#define VOVAL			0x07 + PLOT
#define VOVAL_ARC		0x08 + PLOT
#define VOVAL_PIE_SLICE  0x09 + PLOT
#define VPAINT			0x0A + PLOT
#define VPIE_SLICE		0x0B + PLOT
#define VPSET			0x0C + PLOT
#define VPOLY_LINE		0x0D + PLOT
#define VPOLY_POINT		0x0E + PLOT
#define VPRINT_FONT		0x0F + PLOT
#define VCURR_FONT 		0x10


		/* structure for keeping track of protected mode info */

typedef struct _gpm {int extender;
                     struct {int real_mem_DS;
                     	    int prot_mem_DS;
                     	    int screen_mem_DS;
                     	    int prot_mem_CS;
                     	    } selector;
	                } GFX_PM;


typedef struct _mem32 { INT pm_selector, pm_offset;
				    INT rm_segment, rm_offset;
				    INT flags; } MEM32;

#define USE_DOS_PLAP_MEM		1			/* mem32.flags */

#if defined(__SW_3S) || (WATCOM_STACK_PASSING == 1)

#define _lbitmask			__lbitmask
#define _rbitmask			__rbitmask
#define _gfx_truncate_val     __gfx_truncate_val
#define _gfx_chip_type        __gfx_chip_type
#define  qcb                   _qcb
#define _gfx_wrt_bkgnd_color	__gfx_wrt_bkgnd_color
#define _gfx_fast_char		__gfx_fast_char
#define _gfx_cursor			__gfx_cursor
#define _gfx_pm			__gfx_pm
#define prx				 _prx

#endif

#define GFX_GATE_OPEN 			
#define GFX_GATE_CLOSE 			
#define GFX_GATE_PRO		


#define _gfx_gate()	            

#if (LINK_TO_PASCAL)
#define ISTAT_0	= 0
#define ISTAT_ARR_0	= {0}
#else
#define ISTAT_0        
#define ISTAT_ARR_0	   
#endif

#endif

