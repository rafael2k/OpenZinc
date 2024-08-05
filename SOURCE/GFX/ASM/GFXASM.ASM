      ;/************************************************************/
      ;/* Copyright (c) C Source, Inc 1987, 1988, 1989, 1990, 1991 */
      ;/************************************************************/


INCLUDE EZ_ASM.MAC
INCLUDE GFX_ASM.MAC

DEFINE_MODULE EGA_GFX


EXTERN _INT <NEAR _gfx>;

;/*^ GFXG_ASM.ASM */

;/*~ EGA_HERC.ASM */

USE_ENHANCED_MODE EQU	YES
USE_HERCULES_CARD EQU	YES


IF (USE_ENHANCED_MODE EQ YES)


	START_FCN _gfx_clean_up_ega;
		mov	dx, SEQ_ADDR
		mov	al, S_MAP
		out	dx, al
		inc	dx
		mov	al, 0FFH
		out	dx, al
	END_FCN NO_RET;


	START_FCN _gfx_set_w0_ega_mode;
		mov	ah, WRITE_MODE_0
		jmp	short $ega_mode
	END_FCN NO_RET;

	START_FCN _gfx_set_w1_ega_mode;
		mov	ah, WRITE_MODE_1
		jmp	short $ega_mode
	END_FCN NO_RET;

	START_FCN _gfx_set_w2_ega_mode;
		mov	ah, WRITE_MODE_2
		jmp	short $ega_mode
	END_FCN NO_RET;

	START_FCN _gfx_set_rd_cmp_mode;
		mov	ah, READ_CMP
	END_FCN NO_RET;

	START_FCN <STATIC $ega_mode>;
		mov	dx, GRAPH_ADDR
		mov	al, G_DATA_ROT
		out	dx, al
		inc	dx
		xor	al, al
		out	dx, al
		dec	dx
		mov	al, G_MODE
		out	dx, al
		mov	al, ah
		inc	dx
		out	dx, al

		mov	dx, GRAPH_ADDR	; set all bits in the bitmask ON
		mov	al, G_BITMASK
		out	dx, al
		inc	dx
		mov	al, 0FFH
		out	dx, al
		dec	dx

	END_FCN;

	START_FCN _gfx_set_ega_palette < <DATA_PTR, palette_ptr> >
	PROLOGUE <ES>

	       .les	dx, palette_ptr
		mov	ax, 1002H
		int	10H

	END_FCN


ELSE
	START_FCN _gfx_set_w0_ega_mode;
	END_FCN NO_RET;

	START_FCN _gfx_set_w1_ega_mode;
	END_FCN NO_RET;

	START_FCN _gfx_set_w2_ega_mode;
	END_FCN NO_RET;

	START_FCN _gfx_set_rd_cmp_mode;
	END_FCN NO_RET;

	START_FCN $ega_mode;
	END_FCN NO_RET;

	START_FCN $set_bitmask;
	END_FCN NO_RET;

	START_FCN _gfx_set_ega_palette;
	END_FCN NO_RET;

	START_FCN _gfx_clean_up_ega;
	END_FCN;
ENDIF


IF (USE_HERCULES_CARD EQ YES)

	INDEX		EQU	03B4H		; Port Addresses
	CNTRL		EQU	03B8H
	LOCK_GFX	EQU	03BFH

	SCREEN_ON	EQU	8		; Control Codes
	GRAPHIX_MODE	EQU	3
	TEXT_MODE	EQU	21H

IFDEF TURBO_PASCAL
	EXTERN CHAR gtable
	EXTERN CHAR ttable
ELSE
	STATIC CHAR gtable, <35H, 2DH, 2EH, 07H, 5BH, 02H, 57H, 57H, 02H, 03H, 00H, 00H>;
	STATIC CHAR ttable, <61H, 50H, 52H, 0FH, 19H, 06H, 19H, 19H, 02H, 0DH, 0BH, 0CH>;
ENDIF


	START_FCN _gfx_set_hercules_mode;

		cld
		push	ax
		push	bx
		push	cx

		push	ds
		pop	es
		mov	dx, CNTRL		  ; turn off the screen
		out	dx, al

				; initialize the 6845

		mov	dx, INDEX
		mov	cx, 12
		xor	ah, ah
	parms:	mov	al, ah
		out	dx, al
		inc	dx
		lodsb
		out	dx, al
		inc	ah
		dec	dx
		loop	parms

	       .smov	es, <_gfx .screen_base>
		xor	di, di
		pop	cx
		pop	ax
	rep	stosw

		mov	dx, CNTRL
		pop	ax
		add	al, SCREEN_ON
		out	dx, al
	END_FCN;


	START_FCN _gfx_set_herc_gfx_mode
	PROLOGUE <SI, DI, ES, DS>;
		mov	dx, LOCK_GFX
		mov	al, GRAPHIX_MODE
		out	dx, al
		lea	si, gtable
		xor	bx, bx
		mov	cx, 4000H
		call	_gfx_set_hercules_mode
		mov	ax, 40H
		mov	es, ax
		mov	bx, 49H
		mov	byte ptr es:[bx], 6
	END_FCN;


	START_FCN _gfx_set_herc_text_mode;
	PROLOGUE <SI, DI, ES, DS>;
		mov	dx, LOCK_GFX
		xor	ax, ax
		out	dx, al
		inc	dx
		out	dx, al

		mov	ax, 7
		int	10

		mov	al, TEXT_MODE
		lea	si, ttable
		mov	bx, 720H
		mov	cx, 2000
		call	_gfx_set_hercules_mode

	END_FCN;



ELSE
	START_FCN _gfx_set_herc_gfx_mode
	END_FCN NO_RET;

	START_FCN _gfx_set_herc_text_mode;
	END_FCN NO_RET;


	START_FCN setmd;
	END_FCN;

ENDIF


;/*~ PUT_PEL.ASM */

IFDEF TURBO_PASCAL
  EXTERN CHAR SetPutPelJmpTable
  EXTERN CHAR _0med_res_color_mask
  EXTERN CHAR _0hi_res_color_mask
  EXTERN NEAR_CODE_PTR <<NEAR _00xy_to_ram>, <NEAR _clip_xy_to_ram>>;
  EXTERN CHAR <NEAR _0hi_res_pel_mask>
  EXTERN CHAR <NEAR _0med_res_pel_mask>
  EXTERN CHAR <NEAR _lbitmask>
  EXTERN CHAR <NEAR _rbitmask>

  START_DATA
    put_pel_jmp_table DW 3 DUP(?)
  END_DATA

ELSE
  GLOBAL CHAR _0med_res_color_mask,  <0, 55H, 0AAH, 0FFH>;
  GLOBAL CHAR _0hi_res_color_mask,   <0, 0FFH>;
  GLOBAL NEAR_CODE_PTR _00xy_to_ram, _clip_xy_to_ram;

  GLOBAL CHAR _0hi_res_pel_mask, <80H, 40H, 20H, 10H, 8, 4, 2, 1>;
  GLOBAL CHAR _0med_res_pel_mask, <0C0H, 030H, 0CH, 03H>

  STATIC NEAR_PTR put_pel_jmp_table, <offset CS_LBL:MRES, offset CS_LBL:HRES, offset CS_LBL:ERES, offset CS_LBL:R256>;

  GLOBAL CHAR _lbitmask,  <0FFH, 07FH, 03FH, 01FH, 0FH, 7, 3, 1, 0>
  GLOBAL CHAR _rbitmask,  <0, 080H, 0C0H, 0E0H, 0F0H, 0F8H, 0FCH, 0FEH, 0FFH>

ENDIF

START_FCN _gfx_put_pel, < < _int, x>, < _int, y>, < _int, color> >;
PROLOGUE <SI, DI, ES>;

IFDEF TURBO_PASCAL	    ; initialize TURBO PASCAL jump table
       .if	SetPutPelJmpTable EQ 1, then_goto <short EOTP2>
       .smov	SetPutPelJmpTable, 1
	lea	bx, put_pel_jmp_table
	mov	word ptr[bx],   offset CS_LBL:MRES
	mov	word ptr[bx+2], offset CS_LBL:HRES
	mov	word ptr[bx+4], offset CS_LBL:ERES
	mov	word ptr[bx+6], offset CS_LBL:R256
EOTP2:
ENDIF
	mov	cx, x
	mov	ax, y
        mov	bl, FCN_PUT_PEL
       .call	_00xy_to_ram
	mov	cx, 0
	jc	 XIT
	inc	cx
	and	di, 7
	jmp	word ptr DS_LBL:put_pel_jmp_table[bx]

HRES:	mov	bx, di
       .smov	ah, <_0hi_res_pel_mask [bx]>		; HIGH RES
	mov	bl, color
       .smov	al, <_0hi_res_color_mask [bx]>
	jmp	short W_PIX

MRES:	mov	bx, di
	and	bx, 3			  ; MEDIUM RES
       .smov	ah, <_0med_res_pel_mask [bx]>
	mov	bl, color
       .smov	al, <_0med_res_color_mask [bx]>

W_PIX:	and	al, ah				; SET CGA CARD PEL
	not	ah
       .if	XOR_PEL bit_is_on_in <_gfx .color_flags>, then_goto <short XOR_PIX>
       .smov	es, <_gfx .screen_base>
	and	es:[si], ah
	or	es:[si], al
	jmp	short XIT

XOR_PIX:
       .smov	es, <_gfx .screen_base>
	xor	es:[si], al
	jmp	short XIT

ERES:	mov	dx, GRAPH_ADDR		    ; ENHANCED RES
	mov	bx, di
	mov	al, G_BITMASK
	out	dx, al
       .smov	al, <_0hi_res_pel_mask [bx]>
	inc	dx
	out	dx, al
	mov	al, color
       .smov	es, <_gfx .screen_base>
	mov	ah, es:[si]
	mov	es:[si], al
	jmp	short XIT

R256:	mov	al, color
       .smov	es, <_gfx .screen_base>
       .if	XOR_PEL bit_is_off_in <_gfx .color_flags>, then_goto <short RM256>
	xor	es:[si], al
	jmp	short XIT
RM256:	mov	es:[si], al

XIT:	mov	ax, cx			; 0==>out of bounds
END_FCN;



START_FCN _gfx_clip_gfx, < < CHAR, clip_it> >;
PROLOGUE;

       .smov	bx, <_INT _00xy_to_ram>
	mov	ax, offset CS_LBL:_0xy_to_ram
       .if	clip_it EQ NO, then_goto <short E1>
	mov	ax, offset CS_LBL:_clip_xy_to_ram
E1:    .smov	<_INT _00xy_to_ram>, ax
	sub	ax, bx
END_FCN;


	;			_0xy_to_ram
	;
	;	entering:   cx = x
	;		    ax = y
	;
	;	exiting:    si = byte of point in screen ram
	;		    di = original x
	;		    bl = jump index (0=MRES, 2=HRES, 4=ERES)
	;		    dl = resolution (0=HI, 1=MED, 2=ENHANCED)
	;
	;	_clip_xy_to_ram can be called by routines that want to make
	;	sure that the point being translated is 'in bounds'.  If
	;	it isn't then the carry bit will be set on return.


IF (.$$DATA_SIZE NE ._LARGE_DATA)

START_FCN <NEAR _clip_xy_to_ram>;

       .if	<_gfx .min_x> GT cx, then_goto <short OUT_OF_BOUNDS>
       .if	<_gfx .max_x> LT cx, then_goto <short OUT_OF_BOUNDS>
       .if	<_gfx .min_y> GT ax, then_goto <short OUT_OF_BOUNDS>
       .if	<_gfx .max_y> GE ax, then_goto <short _0xy_to_ram>

OUT_OF_BOUNDS:
	stc				; set out-of-bounds flag
END_FCN;

ELSE

START_FCN <NEAR _clip_xy_to_ram>;

	push	ds
	mov	bx, seg _gfx
	mov	ds, bx
       .if	cx GT _gfx.max_x, then_goto <short OUT_OF_BOUNDS>
       .if	cx LT _gfx.min_x, then_goto <short OUT_OF_BOUNDS>
       .if	ax LT _gfx.min_y, then_goto <short OUT_OF_BOUNDS>
       .if	ax GT _gfx.max_y, then_goto <short OUT_OF_BOUNDS>
	pop	ds
	jmp	_0xy_to_ram

OUT_OF_BOUNDS:
	pop	ds
	stc				; set out-of-bounds flag
END_FCN;

ENDIF


comment @
; This function is used for Modula-2 function call to _gfx_no_init
;
; for Stoney Brook
EXTERN FCN GFXBase_NoInit

START_FCN no_init
  .call GFXBase_NoInit
END_FCN

;for TopSpeed Modula-2
START_FCN no_init
  .call GFXBase$NoInit
END_FCN

@
;this will go to conditional for TP or C
EXTERN FCN _gfx_no_init

IFDEF TURBO_PASCAL
  EXTERN CHAR SetXYJmpTable

  START_DATA
    xy_jmp_table DW 5 DUP(?)
  END_DATA

ELSE

STATIC NEAR_PTR xy_jmp_table, <offset CS_LBL:_MRES, offset CS_LBL:_HRES, offset CS_LBL:_ERES, offset CS_LBL:_HERC, offset CS_LBL:_R256, offset CS_LBL:ERR_EXIT>

ENDIF

START_FCN <NEAR $no_256_page>
END_FCN

GLOBAL _INT  $set_256_page, <offset CS_LBL:$no_256_page>
GLOBAL CHAR  $256_page_n, 0

START_FCN <NEAR _0xy_to_ram>;
IFDEF TURBO_PASCAL	    ; initialize TURBO PASCAL jump table
       .if	SetXYJmpTable EQ 1, then_goto <short XYTP2>
       .smov	SetXYJmpTable, 1
	lea	bx, xy_jmp_table
	mov	word ptr[bx],   offset CS_LBL:_MRES
	mov	word ptr[bx+2], offset CS_LBL:_HRES
	mov	word ptr[bx+4], offset CS_LBL:_ERES
	mov	word ptr[bx+6], offset CS_LBL:_HERC
	mov	word ptr[bx+8], offset CS_LBL:_R256
	mov	word ptr[bx+10], offset CS_LBL:ERR_EXIT
XYTP2:
ENDIF
	mov	di, cx			    ; save for return
       .shr	cx, 2			  ; assume medium res
       .smov	bx, <_gfx .gfx_mode>
	mov	dl, bh
	xor	bh, bh
	jmp	word ptr DS_LBL:xy_jmp_table[bx]

ERR_EXIT:
       .call	_gfx_no_init
_HRES:	shr	cx, 1			  ; HIGH RES
_MRES:	shr	ax, 1
	jnc	short MROW
	add	cx, 2000H
MROW:	mov	ah, 80
	mul	ah
	jmp	short R3

_HERC: .ror	ax, 2			  ; HERCULES CARD, AT&T 640x400
	mov	si, ax
	shr	si, 1
	and	si, 6000H
	shr	cx, 1
	add	cx, si
	mov	bx, 1 * INT_SZ
       .smov	ah, <CHAR _gfx .bytes_per_row>
	mul	ah
R3:    .smov	si, <_gfx .screen_offset>   ; add base of screen
	add	si, cx
	add	si, ax
	clc
	ret

SETPG:	mov	al, dl				; set 16- or 256-color page
	mov	DS_LBL:$256_page_n, al
	call	word ptr DS_LBL:$set_256_page
	pop	dx
	clc
	ret

_R256:	mov	bx, 3 * INT_SZ			; 256-color
	mov	cx, di
	jmp	short _RC0

_ERES:	shr	cx, 1				; 16-color

_RC0:	push	dx
       .smov	dx, <_gfx .bytes_per_row>
	mul	dx
	add	ax, cx


	adc	dx, 0
       .sadd	ax, <_gfx .screen_offset>
	adc	dx, 0

	mov	si, ax
       .if	dl NE DS_LBL:$256_page_n, then_goto <short SETPG>
	clc
	pop	dx

END_FCN;

		; al == $256_page_n (where pagesize == 64k)

START_FCN <NEAR _DSnew_256_page>
	stc
	jmp	short _0new_256_page
END_FCN NO_RET

START_FCN <NEAR _ESnew_256_page>
	clc
END_FCN NO_RET


START_FCN <NEAR _0new_256_page>
	push	ax
	push	ds


	push	ax
	mov	ax, DS_SEG
	mov	ds, ax
	pop	ax

	lahf
       .if	al EQ DS_LBL:$256_page_n, then_goto <short _0sbye>
	mov	DS_LBL:$256_page_n, al
	call	word ptr DS_LBL:$set_256_page
_0sbye:	pop	ds
	pop	ax
END_FCN

START_FCN <NEAR _DSnext_256_page>
	stc
	jmp	short _0next_256_page
END_FCN NO_RET

START_FCN <NEAR _ESnext_256_page>
	clc
END_FCN NO_RET

START_FCN <NEAR _0next_256_page>
	push	ax
	push	ds


	mov	ax, DS_SEG
	mov	ds, ax

	lahf
	mov	al, DS_LBL:$256_page_n
	inc	al
	mov	DS_LBL:$256_page_n, al
	call	word ptr DS_LBL:$set_256_page
	pop	ds
	pop	ax
END_FCN

START_FCN <NEAR _DSprev_256_page>
	stc
	jmp	short _0prev_256_page
END_FCN NO_RET

START_FCN <NEAR _ESprev_256_page>
	clc
END_FCN NO_RET

START_FCN <NEAR _0prev_256_page>
	push	ax
	push	ds


	mov	ax, DS_SEG
	mov	ds, ax

	lahf
	mov	al, DS_LBL:$256_page_n
	dec	al
	mov	DS_LBL:$256_page_n, al
	call	word ptr DS_LBL:$set_256_page
	pop	ds
	pop	ax
END_FCN


START_FCN _gfx_set_vidram < <_INT x>, <_INT y> >
PROLOGUE <SI, DI>
	mov	cx, x
	mov	ax, y
	mov	bl, FCN_SET_VIDRAM
       .call	_0xy_to_ram
	mov	ax, si
END_FCN

comment #
IFNDEF USE_386

.286P

START_FCN _gfx_get_cpu_type
	push	bp
	mov	bx, 86
	push    sp
	pop     ax
       .if	ax NE sp, then_goto  CPU_BYE
	
	mov	bx, 286
	sub     sp, 6
	mov     bp, sp
	sgdt    pword ptr[bp]
	pop	ax
	pop	ax
	pop     ax
       .if	ax EQ -1, then_goto CPU_BYE
	mov	bx, 386

CPU_BYE:mov	ax, bx	
	pop	bp
END_FCN

ENDIF								
#

;/*~ BANK_256.ASM */

IFNDEF ASSEMBLE_WHOLE_FILE
EXTERN _INT $set_256_page
EXTERN FCN  <NEAR _0xy_to_ram>;
ENDIF


		; al == $256_page_n (where pagesize == 64k)

START_FCN <NEAR _0set_V7VGA_256>
	push	dx
	push	bx
	mov	dl, al
	and	dl, 0CH
	mov	bh, dl
       .shr	dl, 2
	or	bh, dl
	mov	bl, al
	and	bl, 1
	and	al, 2
       .shl	al, 4
	mov	ah, al
	mov	dx, 3CCH
	in	al, dx
	and	al, not 20H
	or	al, ah
	mov	dx, 3C2H
	out	dx, al
	inc	dx
	inc	dx
	mov	al, 0F9H
	mov	ah, bl
	out	dx, ax
	mov	al, 0F6H
	out	dx, al
	inc	dx
	in	al, dx
	and	al, 0F0H
	or	al, bh
	out	dx, al
	pop	bx
	pop	dx
V7Bye:
END_FCN



		; al == $256_page_n (where pagesize == 64k)

START_FCN <NEAR _0set_V7VGA_16>
	mov	ah, al
       .shl	ah, 2
	or	ah, al
	push	dx
	mov	dx, 3C4H
	mov	al, 0F6H
	out	dx, al
	inc	dx
	in	al, dx
	and	al, 0F0H
	or	al, ah
	out	dx, al
	pop	dx
END_FCN


START_FCN _gfx_init_V7VGA
	mov	dx, 3C4H
	mov	ax, 0EA06H
	out	dx, ax
       .if	<_gfx .n_colors> EQ 16, then_goto <short IV716>
	mov	word ptr DS_LBL:$set_256_page, offset CS_LBL:_0set_V7VGA_256
	jmp	short IV7BYE
IV716:	mov	word ptr DS_LBL:$set_256_page, offset CS_LBL:_0set_V7VGA_16

IV7BYE:
END_FCN


STATIC _INT	_ATI_port, 0

ATI_SELECT_PAGE		EQU	0B2H
ATI_RW_PAGE_MASK	EQU	0E1H

START_FCN <NEAR _0set_ATI_256>
	and	al, 0FH
	mov	ah, al

	push	dx
	mov	dx, DS_LBL:_ATI_port
	mov	al, ATI_SELECT_PAGE
	out	dx, al
	inc	dl
	in	al, dx
	and	al, ATI_RW_PAGE_MASK
	shl	ah, 1
	or	ah, al
	mov	al, ATI_SELECT_PAGE
	dec	dl
	out	dx, ax
	pop	dx
END_FCN

START_FCN _gfx_set_ATI_port < <_INT port_n> >
PROLOGUE
	mov	ax, port_n
       .smov	_ATI_port, ax
END_FCN


START_FCN _gfx_is_good_ATI_mode < <_INT mode_n> >
PROLOGUE <SI, ES>
	push	bp
	mov	ah, 12H
	mov	al, mode_n
	mov	bx, 5506H
	mov	bp, -1
	xor	si, si
	int	10H
	xor	ax, ax
       .if	bp EQ -1, then_goto ATI_BYE
	inc	ax
ATI_BYE:
	pop	bp
END_FCN


START_FCN _gfx_init_ATI_18800
	mov	word ptr DS_LBL:$set_256_page, offset CS_LBL:_0set_ATI_256
END_FCN



START_FCN _gfx_init_TSENG_ET4000
	mov	word ptr DS_LBL:$set_256_page, offset CS_LBL:_0set_TSENG_ET4000
END_FCN

START_FCN _gfx_init_TSENG_ET3000
	mov	word ptr DS_LBL:$set_256_page, offset CS_LBL:_0set_TSENG_ET3000
END_FCN


TSENG_SELECT_PAGE	EQU	03CDH

START_FCN <NEAR _0set_TSENG_ET4000>
	and	al, 0FH
	mov	ah, al
       .shl	ah, 4
	or	al, ah
	push	dx
	mov	dx, TSENG_SELECT_PAGE
	out	dx, al
	pop	dx
END_FCN


START_FCN <NEAR _0set_TSENG_ET3000>
	and	al, 7H
	mov	ah, al
       .shl	ah, 3
	or	al, ah
	or	al, 40H
	push	dx
	mov	dx, TSENG_SELECT_PAGE
	out	dx, al
	pop	dx
END_FCN



START_FCN _gfx_init_TRIDENT_8800CS
	mov	dx, 3C4H
	mov	al, 0BH
	out	dx, al
	inc	dx
	in	al, dx
	mov	dx, 3CEH
	mov	ax, 506H
	out	dx, ax
	mov	word ptr DS_LBL:$set_256_page, offset CS_LBL:_0set_TRIDENT_8800CS
	xor	ax, ax
	call	word ptr DS_LBL:$set_256_page
END_FCN


START_FCN <NEAR _0set_TRIDENT_8800CS>
	push	dx
	mov	ah, al
	mov	dx, 3C4H
	mov	al, 0EH
	out	dx, al
	inc	dx
	in	al, dx
	and	ax, 0FF0H
	or	al, ah
	xor	al, 2
	out	dx, al
	pop	dx
END_FCN

START_FCN _gfx_WD_SVGA_bug
	mov	ax, 1130H		; bug fix for snow in high res modes
	mov	bx, 600H		; don't know why it works, it just does
	push	bp
	int	10H
	pop	bp
END_FCN

START_FCN _gfx_init_WD
	mov	dx, 3CEH
	mov	al, 0FH
	out	dx, al
	inc	dx
	in	al, dx
	and	al, 0F8H
	or	al, 5H
	out	dx, al
	mov	dx, 3C4H		; set single 64k r/w page
	mov	al, 11H
	out	dx, al
	inc	dx
	in	al, dx
	and	al, 7FH
	out	dx, al
	mov	dx, 3CEH
	mov	al, 0BH
	out	dx, al
	inc	dx
	in	al, dx
	and	al, 0F7H
	out	dx, al
	mov	word ptr DS_LBL:$set_256_page, offset CS_LBL:_0set_WD
END_FCN


START_FCN <NEAR _0set_WD>
	push	dx
	mov	dx, 3CEH
	mov	ah, al
	mov	al, 09H
       .shl	ah, 4
	out	dx, ax
	pop	dx
END_FCN


START_FCN _gfx_init_OAK
	mov	dx, 3CEH		; set single 64k r/w page
	mov	al, 6
	out	dx, al
	inc	dx
	in	al, dx
	and	al, 0F3H
	or	al, 4
	out	dx, al
	mov	word ptr DS_LBL:$set_256_page, offset CS_LBL:_0set_OAK
END_FCN


START_FCN <NEAR _0set_OAK>
	push	dx
	mov	dx, 3DEH
	mov	ah, al
	mov	al, 011H
	out	dx, al
	inc	dx
	and	ah, 7H
	mov	al, ah
       .shl	ah, 4
	or	ah, al
	in	al, dx
	and	al, 88H
	or	al, ah
	out	dx, al
	pop	dx
END_FCN


START_FCN _gfx_init_S3
	mov	word ptr DS_LBL:$set_256_page, offset CS_LBL:_0set_S3
	xor	ax, ax
	call	word ptr DS_LBL:$set_256_page
END_FCN


START_FCN <NEAR _0set_S3>
        push	bx			; save cpu registers
        push	dx
        and	al, 0FH			; save video page in bl
        mov	bl, al
	mov	ax, 4838H		; unlock the S3 registers
	mov	dx, 03D4H
	out	dx, ax
	mov	al, 35H			; read in the video page register
	out	dx, al
	inc	dx
	in	al, dx
	and	al, 0F0H		; set new video page number
	or	al, bl
	out	dx, al			; write it
	dec	dx			; lock the S3 registers
	mov	ax, 48H
        out	dx, ax
	pop	dx			; restore cpu registers
	pop	bx
END_FCN


START_FCN _gfx_init_CIRRUS_GD542X
	mov	word ptr DS_LBL:$set_256_page, offset CS_LBL:_0set_CIRRUS_GD542X
        mov	dx, 03CEH
        mov	al, 0BH
        out	dx, al
        inc	dx
        in	al, dx
        and	al, 0FEH
        out	dx, al
        dec	dx
        mov	ax, 9
        out	dx, ax
END_FCN

START_FCN <NEAR _0set_CIRRUS_GD542X>
        push	dx
       .shl	al, 4 
        mov	ah, al
        mov	dx, 03CEH
        in	al, dx
        push	ax
        mov	al, 09H
        out	dx, ax
	pop	ax
	out	dx, al
	pop	dx
END_FCN


START_FCN _gfx_init_CIRRUS_GD5410
	mov	word ptr DS_LBL:$set_256_page, offset CS_LBL:_0set_CIRRUS_GD5410
        mov	dx, 03CEH
        mov	al, 0DH
        out	dx, al
        inc	dx
        in	al, dx
        and	al, 0F8H
        or	al, 3
        out	dx, al
        dec	dx
        mov	ax, 0EH
        out	dx, ax
END_FCN


START_FCN <NEAR _0set_CIRRUS_GD5410>
        push	dx
        mov	dx, 03CEH
       .shl	al, 4 
        mov	ah, al
        mov	al, 0EH
        out	dx, ax
	pop	dx
END_FCN


STATIC _INT VESA_fcn, <0,0>

START_FCN _gfx_init_VESA < <LONG VESA_fcn_ptr>, <_INT _type > >
PROLOGUE
	mov	ax, VESA_fcn_ptr
	mov	VESA_fcn, ax
	mov	ax, VESA_fcn_ptr+2
	mov	VESA_fcn+2, ax
	mov	ax, _type
       .if	ax AB 100H,  then_goto <short VSPM>
       .if	ax EQ 4,  then_goto <short VS4K>	
       .if	ax EQ 8,  then_goto <short VS8K>	
       .if	ax EQ 16, then_goto <short VS16K>	
       .if	ax EQ 32, then_goto <short VS32K>	
	jmp	short VS64K
VS4K:	mov	ax, offset CS_LBL:_4K
	jmp	short VS1
VS8K:	mov	ax, offset CS_LBL:_8K
	jmp	short VS1
VS16K:	mov	ax, offset CS_LBL:_16K
	jmp	short VS1
VS32K:	mov	ax, offset CS_LBL:_32K
	jmp	short VS1
VS64K:	mov	ax, offset CS_LBL:_64K
VS1:	mov	word ptr DS_LBL:$set_256_page, ax
	jmp	short VSBYE
VSPM: mov	ah, 0
       .if	ax EQ 4,  then_goto <short VP4K>	
       .if	ax EQ 8,  then_goto <short VP8K>	
       .if	ax EQ 16, then_goto <short VP16K>	
       .if	ax EQ 32, then_goto <short VP32K>	
	jmp	short VP64K
VP4K:	mov	ax, offset CS_LBL:_4P
	jmp	short VP1
VP8K:	mov	ax, offset CS_LBL:_8P
	jmp	short VP1
VP16K:	mov	ax, offset CS_LBL:_16P
	jmp	short VP1
VP32K:	mov	ax, offset CS_LBL:_32P
	jmp	short VP1
VP64K:	mov	ax, offset CS_LBL:_64P
VP1:	mov	word ptr DS_LBL:$set_256_page, ax
VSBYE:
END_FCN

START_FCN <NEAR _0set_VESA>
_4K:	shl	al, 1
_8K:	shl	al, 1
_16K:	shl	al, 1
_32K:	shl	al, 1
_64K:	push	dx
	push	bx
	xor	dx, dx
	mov	dl, al
	mov	bx, 0
	call	dword ptr VESA_fcn
	pop	bx
	pop	dx
END_FCN


.286

EXTERN FCN <FAR DosRealFarCall>

START_FCN <NEAR _0set_VESA_for_pm>
_4P:	shl	al, 1
_8P:	shl	al, 1
_16P:	shl	al, 1
_32P:	shl	al, 1
_64P:	push	dx
	push	es
	pusha
	xor	bx, bx
	push	bx		; flags
	push	bx              ; cs
	push	bx              ; ip
	push	bx		; ax
	push	bx		; cx
	mov	ah, 0
	push	ax		; dx
	push	bx		; bx
	push	bx		; sp
	push	bx		; bp
	push	bx		; si
	push	bx		; di
	push	bx		; ds
	push	bx		; es  - 26 bytes
	mov	ax, sp
	push	bx
	push	bx
	push    bx
	push    bx
	push	bx
	push	bx
	push	ss
	push	ax
	push	word ptr DS_LBL:VESA_fcn+2
	push	word ptr DS_LBL:VESA_fcn	; - 20 bytes
	call	DosRealFarCall
	add	sp, 26+20
	popa
	pop	es
END_FCN




;/*~ FASTLINE.ASM */

	; _gfx_asm_line draws a line using Bresenham's alogrithm with parameters
	; that have already been calculated in the drawline() function.

IFNDEF ASSEMBLE_WHOLE_FILE
EXTERN FCN  <NEAR _0xy_to_ram>;
EXTERN FCN  <NEAR _ESnext_256_page>;
EXTERN FCN  <NEAR _ESprev_256_page>;
EXTERN CHAR < <NEAR _0med_res_color_mask>, <NEAR _0hi_res_color_mask> >;
EXTERN CHAR < <NEAR _lbitmask>, <NEAR _rbitmask> >;
ENDIF

SIGN_BIT equ 8000H

IFDEF TURBO_PASCAL
EXTERN _INT SetAsmlineJmpTable
START_DATA
  asmline_jmp_table DW 4 DUP(?)
  jmp256	    DW 8 DUP(?)
END_DATA
EXTERN _INT <NEAR _0_d1>;
EXTERN _INT <NEAR _0_d2>;
EXTERN _INT <NEAR _0pattern>;

ELSE
STATIC NEAR_PTR asmline_jmp_table, <offset CS_LBL:LMRES, offset CS_LBL:LHRES, offset CS_LBL:LERES, offset CS_LBL:L256>;
STATIC NEAR_PTR jmp256, <offset CS_LBL:AM01, offset CS_LBL:MM01, offset CS_LBL:AM0, offset CS_LBL:MM0, offset CS_LBL:AX01, offset CS_LBL:MX01, offset CS_LBL:AX0, offset CS_LBL:MX0>;
STATIC _INT _0_d1, 0;
STATIC _INT _0_d2, 0;
STATIC _INT _0pattern, 0;
ENDIF


START_FCN _gfx_asm_line, <<_int,x>,<_int,y>,<_int,color>,<_int,d>,<_int,_d1>,<_int,_d2>,<_int,step>,< _int,count>,<CHAR,dir>,<_int,pattern>,<_int,start_bit>>;
PROLOGUE <SI, DI, ES, DS>;

IFDEF TURBO_PASCAL	    ; initialize TURBO PASCAL jump table
       .if	SetAsmlineJmpTable EQ 1, then_goto <short EOTP4>
       .smov	SetAsmlineJmpTable, 1
	lea	bx, asmline_jmp_table
	mov	word ptr[bx],   offset CS_LBL:LMRES
	mov	word ptr[bx+2], offset CS_LBL:LHRES
	mov	word ptr[bx+4], offset CS_LBL:LERES
	mov	word ptr[bx+6], offset CS_LBL:LHRES
	lea	bx, jmp256
	mov	word ptr[bx],   offset CS_LBL:AM01
	mov	word ptr[bx+2], offset CS_LBL:MM01
	mov	word ptr[bx+4], offset CS_LBL:AM0
	mov	word ptr[bx+6], offset CS_LBL:MM0
	mov	word ptr[bx+8], offset CS_LBL:AX01
	mov	word ptr[bx+10], offset CS_LBL:XX01
	mov	word ptr[bx+12], offset CS_LBL:AX0
	mov	word ptr[bx+14], offset CS_LBL:XX0
EOTP4:
ENDIF
       .if	pattern EQ -1, then_goto <short LL0>
	mov	cl, start_bit
	rol	word ptr pattern, cl

LL0:	mov	cx, x
	mov	ax, y
	mov	bl, FCN_ASM_INE
       .call	_0xy_to_ram
	mov	cx, di
	mov	di, d
	xor	bh, bh
	jmp	asmline_jmp_table[bx]

LHRES:	and	cl, 7
	mov	ah, 80H
	ror	ah, cl
	mov	cl, 1
	mov	bl, color
       .smov	al, <_0hi_res_color_mask [bx]>
	jmp	short L0

LMRES:	and	cl, 3				; MEDIUM RES
	shl	cl, 1
	mov	ah, 0C0H
	ror	ah, cl
	mov	cl, 2
	mov	bl, color
       .smov	al, <_0med_res_color_mask [bx]>

L0:    .smov	dx, <_gfx .color_flags>
	and	dx, XOR_PEL
	mov	ch, dh
	and	al, ah
	not	ah
       .smov	dx, <_gfx .last_video_row>
	mov	bx, count
       .smov	ds, <_gfx .screen_base>
       .if	dir NE 0 then_goto <short L300>
	or	step, 2000H
	jns	short LDOT0
	mov	step, -2000H
	neg	dx

LDOT0:	rol	word ptr pattern , 1
	jnc	short L02
	or	ch, ch
	jz	short L01
	xor	[si], al
	jmp	short L02

L01:	and	[si], ah			  ; SET CGA CARD PEL
	or	[si], al

L02:   .if	di GE 0, then_goto <short L1>
	add	di, _d1
	jmp	short L2
L1:	add	di, _d2
	add	si, step
       .if	si BL dx, then_goto <short L2>
	sub	si, dx
L2:	ror	al, cl
	ror	ah, cl
	cmc
	adc	si, 0
	dec	bx
	jnz	short LDOT0
	jmp	LXIT

L300:

LDOT01: rol	word ptr pattern , 1
	jnc	short L302

       .if	ch EQ 0, then_goto <short L301>
	xor	[si], al
	jmp	short L302

L301:	and	[si], ah			  ; SET CGA CARD PEL
	or	[si], al

L302:  .if	di GE 0, then_goto <short L30>
	add	di, _d1
	jmp	short L40

L30:	add	di, _d2
       .if	step BE 0FFH, then_goto <short L32>
L31:	rol	al, cl
	rol	ah, cl
	cmc
	sbb	si, 0
	jmp	short L40
L32:	ror	al, cl
	ror	ah, cl
	cmc
	adc	si, 0

L40:	add	si, 2000H
       .if	si BL dx, then_goto <short L41>
	sub	si, dx
L41:	dec	bx
	jnz	short LDOT01
	jmp	LXIT

LERES:	mov	ax, _d1			      ; ENHANCED RES
       .smov	_0_d1, ax
	mov	ax, _d2
       .smov	_0_d2, ax
	mov	ax, pattern
       .smov	_0pattern, ax
	and	cx, 7
	mov	al, 80H
	ror	al, cl
	mov	cx, count
	mov	ah, color
	mov	dx, GRAPH_ADDR+1
       .smov	bx, <_gfx .bytes_per_row>
       .smov	es, <_gfx .screen_base>
       .if	dir NE 0 then_goto <short LE2000>
       .if	pattern EQ -1, then_goto <short LEX>
	jmp	LEPX

LEX:	cmp	word ptr step, 0
	mov	bp, bx
	jge	short LE00
	jmp	short LE10

LE0A:  .call	_ESnext_256_page		; l to r and down
	jmp	short LE00
LEDOT0: ror	al, 1
	adc	si, 0
	jc	short LE0A

LE00:	out	dx, al
	mov	bh, ah
	xchg	bh, es:[si]
       .if	SIGN_BIT bit_is_off_in di, then_goto <short LE01>
       .sadd	di, _0_d1
	loop	LEDOT0
	jmp	LXIT

LE01:  .sadd	di, _0_d2
	add	si, bp
	jc	short LE02
	loop	LEDOT0
	jmp	LXIT
LE02:  .call	_ESnext_256_page
	loop	LEDOT0
	jmp	LXIT

LE1A:  .call	_ESnext_256_page		; l to r and up
	jmp	short LE10
LEDOT1: ror	al, 1
	adc	si, 0
	jc	short LE1A

LE10:	out	dx, al
	mov	bh, ah
	xchg	bh, es:[si]
       .if	SIGN_BIT bit_is_off_in di, then_goto <short LE11>
       .sadd	di, _0_d1
	loop	LEDOT1
	jmp	LXIT

LE11:  .sadd	di, _0_d2
	sub	si, bp
	jc	short LE12
	loop	LEDOT1
	jmp	LXIT
LE12:  .call	_ESprev_256_page
	loop	LEDOT1
	jmp	LXIT


LE2000:.if	pattern EQ -1, then_goto <short LE2X>
	jmp	LEP2000
LE2X:	xchg	bx, step
	mov	bp, step

       .if	bh EQ 0, then_goto <short LE300>
	jmp	short LE200

LE2A:  .call	_ESnext_256_page		; r to l and down
	jmp	short LE200
LEDOT2: add	si, bp
	jc	short LE2A

LE200:	out	dx, al
	mov	bl, ah
	xchg	bl, es:[si]
       .if	SIGN_BIT bit_is_off_in di, then_goto <short LE201>

       .sadd	di, _0_d1
	loop	LEDOT2
	jmp	LXIT

LE201: .sadd	di, _0_d2
	rol	al, 1
	sbb	si, 0
	jc	short LE202
	loop	LEDOT2
	jmp	LXIT
LE202: .call	_ESprev_256_page
	loop	LEDOT2
	jmp	LXIT


LE3A:  .call	_ESnext_256_page
	jmp	short LE300
LEDOT3: add	si, bp			; l to r and down
	jc	short LE3A

LE300:	out	dx, al
	mov	bl, ah
	xchg	bl, es:[si]
       .if	SIGN_BIT bit_is_off_in di, then_goto <short LE301>

       .sadd	di, _0_d1
	loop	LEDOT3
	jmp	LXIT

LE301: .sadd	di, _0_d2
	ror	al, 1
	adc	si, 0
	jc	short LE302
	loop	LEDOT3
	jmp	LXIT
LE302: .call	_ESnext_256_page
	loop	LEDOT3
	jmp	LXIT


LEPX:	cmp	word ptr step, 0		; Pattern EGA/VGA Line
	mov	bp, bx
	jge	short LEP00
	jmp	short LEP10


LEP00A:.call	_ESnext_256_page
	jmp	short LEP00
LEPDOT0:ror	al, 1				; l to r and down
	adc	si, 0
	jc	short LEP00A

LEP00:	rol	word ptr _0pattern, 1
	jnc	short LEP01
	out	dx, al
	mov	bh, ah
	xchg	bh, es:[si]

LEP01: .if	SIGN_BIT bit_is_off_in di, then_goto <short LEP02>
       .sadd	di, _0_d1
	loop	LEPDOT0
	jmp	LXIT

LEP02: .sadd	di, _0_d2
	add	si, bp
	jc	short LEP03
	loop	LEPDOT0
	jmp	LXIT
LEP03: .call	_ESnext_256_page
	loop	LEPDOT0
	jmp	LXIT

LEP10A:.call	_ESnext_256_page
	jmp	short LEP10
LEPDOT1:ror	al, 1				; l to r and up
	adc	si, 0
	jc	short LEP10A

LEP10:	rol	word ptr _0pattern, 1
	jnc	short LEP11
	out	dx, al
	mov	bh, ah
	xchg	bh, es:[si]

LEP11: .if	SIGN_BIT bit_is_off_in di, then_goto <short LEP12>
       .sadd	di, _0_d1
	loop	LEPDOT1
	jmp	LXIT

LEP12: .sadd	di, _0_d2
	sub	si, bp
	jc	short LEP13
	loop	LEPDOT1
	jmp	LXIT
LEP13: .call	_ESprev_256_page
	loop	LEPDOT1
	jmp	LXIT

LEP2000:xchg	bx, step
	mov	bp, step

       .if	bh EQ 0, then_goto <short LEP300>
	jmp	short LEP200

LEP2A: .call	_ESnext_256_page
	jmp	short LEP200
LEPDOT2:add	si, bp
	jc	short LEP2A

LEP200: rol	word ptr _0pattern, 1
	jnc	short LEP20A

	out	dx, al
	mov	bl, ah
	xchg	bl, es:[si]

LEP20A:.if	SIGN_BIT bit_is_off_in di, then_goto <short LEP201>

       .sadd	di, _0_d1
	loop	LEPDOT2
	jmp	LXIT

LEP201:.sadd	di, _0_d2
	rol	al, 1
	sbb	si, 0
	jc	short LEP202
	loop	LEPDOT2
	jmp	LXIT
LEP202:.call	_ESprev_256_page
	loop	LEPDOT2
	jmp	LXIT

LEP3A: .call	_ESnext_256_page
	jmp	short LEP300
LEPDOT3:add	si, bp
	jc	short LEP3A

LEP300: rol	word ptr _0pattern, 1
	jnc	short LEP30A

	out	dx, al
	mov	bl, ah
	xchg	bl, es:[si]

LEP30A:.if	SIGN_BIT bit_is_off_in di, then_goto <short LEP301>

       .sadd	di, _0_d1
	loop	LEPDOT3
	jmp	LXIT

LEP301:.sadd	di, _0_d2
	ror	al, 1
	adc	si, 0
	jc	short LEP302
	loop	LEPDOT3
	jmp	LXIT
LEP302:.call	_ESnext_256_page
	loop	LEPDOT3
	jmp	LXIT

L256:  .smov	bx, <_gfx .bytes_per_row>
	mov	cx, 1
	xor	dx, dx
       .if	dir EQ 0, then_goto <short AA0>
       .if	step EQ 0, then_goto <short AA3>
	inc	dx
	jmp	short AA3
AA0:   .if	step EQ 0, then_goto <short AA2>
	inc	dx
AA2:	mov	cx, bx
	mov	bx, 1
AA3:	mov	step, cx

       .if	pattern EQ -1, then_goto <short AA4>
	or	dl, 2
AA4:   .if	XOR_PEL	bit_is_off_in <_gfx .color_flags>, then_goto <short AA5>
	or	dl, 4
AA5:	shl	dx, INT_SZ/2
	mov	di, dx
	mov	dx, DS_LBL:jmp256[di]

	mov	cx, count
	mov	di, d
	mov	al, color
       .smov	es, <_gfx .screen_base>
	jcxz	short AA51
	jmp	dx
AA51:	jmp	LXIT

AX0:	rol	word ptr pattern, 1
	jnc	short AL1
AX01:	xor	es:[si], al
	jmp	short AL1

AM0:	rol	word ptr pattern, 1
	jnc	short AL1
AM01:	mov	es:[si], al

AL1:	add	si, bx
	jc	short AL1B
AL1R:  .if	di GE 0 then_goto <short AL2>
	add	di, _d1
	dec	cx
	jz	short LXIT
	jmp	dx
AL2:	add	di, _d2
	add	si, step
	jc	short AL2B
AL2R:	dec	cx
	jz	short LXIT
	jmp	dx
AL1B:  .call	_ESnext_256_page
	jmp	AL1R
AL2B:  .call	_ESnext_256_page
	jmp	AL2R


MX0:	rol	word ptr pattern, 1
	jnc	short ML1
MX01:	xor	es:[si], al
	jmp	short ML1

MM0:	rol	word ptr pattern, 1
	jnc	short ML1
MM01:	mov	es:[si], al

ML1:	add	si, bx
	jc	short ML1B
ML1R:  .if	di GE 0 then_goto <short ML2>
	add	di, _d1
	dec	cx
	jz	short LXIT
	jmp	dx
ML2:	add	di, _d2
	sub	si, step
	jc	short ML2B
ML2R:	dec	cx
	jz	short LXIT
	jmp	dx
ML1B:  .call	_ESnext_256_page
	jmp	ML1R
ML2B:  .call	_ESprev_256_page
	jmp	ML2R

LXIT:
END_FCN;


;/*~ PATORDER.ASM */

START_FCN _gfx_rev_pat_order < <_int pattern> >;
PROLOGUE

	mov	dx, pattern
	xor	ax, ax
	mov	cx, 8
LM0:	rol	dx, 1
	rcr	ax, 1
	rol	dx, 1
	rcr	ax, 1
	loop	LM0

END_FCN;



START_FCN _gfx_ror_pattern < < _int pattern >, < _int  ror_n_bits> >;
PROLOGUE
	mov	ax, pattern
	mov	cl, ror_n_bits
	and	cl, 0FH
	ror	ax, cl
END_FCN


START_FCN _gfx_arc_rot_pat_masks < <DATA_PTR masks> >
PROLOGUE<DS>

       .lds	bx, masks
	add	bx, 3 * INT_SZ
	xor	ax, ax
	mov	cx, 8

AP_TOP: rol	word ptr [bx], 1
	mov	dx, [bx]
	and	dx, cx
	or	ax, dx
	shr	cx, 1
	sub	bx, INT_SZ
	ror	word ptr [bx], 1
	mov	dx, [bx]
	and	dx, cx
	or	ax, dx
	sub	bx, INT_SZ
	shr	cx, 1
	jnz	short AP_TOP

END_FCN


;/*~ SETCPAIR.ASM */

IFDEF TURBO_PASCAL
    ; Pascal Version

START_FCN _gfx_set_coor_pair < < DATA_PTR cpair > >
PROLOGUE <SI, DI, ES>

       .smov	cx, <_gfx .min_y>
       .smov	dx, <_gfx .max_y>
       .les	si, cpair
	mov	di, si
	add	di, 2

CP0:	mov	ax, es:[si+2*INT_SZ]
	mov	bx, es:[si]
       .if	ax LT bx, then_goto <short CP1>
	xchg	ax, bx

CP1:   .if	ax GT dx, then_goto <short CP_ERR>
       .if	bx LT cx, then_goto <short CP_ERR>

       .if	ax GE cx, then_goto <short CP2>
	mov	ax, cx
CP2:   .if	bx LE dx, then_goto <short CP3>
	mov	bx, dx
CP3:	mov	es:[si+2*INT_SZ], ax
	mov	es:[si], bx
       .if	si EQ di, then_goto <short CP4>
	inc	si
	inc	si
       .smov	cx, <_gfx .min_x>
       .smov	dx, <_gfx .max_x>
	mov	ax, es:[si+2*INT_SZ]
	mov	bx, es:[si]
       .if	ax LT bx, then_goto <short CP1>
	xchg	ax, bx
	jmp	CP1

CPERR:	xor	ax, ax
	jmp	CPBYE

CP4:   mov	ax, 1

CPBYE:
END_FCN

ELSE


    ; C Version

START_FCN _gfx_set_coor_pair < < DATA_PTR cpair > >
AUTO < <_int n_loops> >
PROLOGUE <SI, DI, ES>

       .smov	cx, <_gfx .min_x>
       .smov	dx, <_gfx .max_x>
       .les	si, cpair
	mov	byte ptr n_loops, 2
	xor	di, di

CP0:	mov	ax, es:[si]
	mov	bx, es:[si+(INT_SZ*2)]
       .if	ax LT bx, then_goto <short CP1>
	xchg	ax, bx

CP1:   .if	ax GT dx, then_goto <short CP_ERR>
       .if	bx LT cx, then_goto <short CP_ERR>

       .if	ax GE cx, then_goto <short CP2>
	mov	ax, cx
	inc	di
CP2:   .if	bx LE dx, then_goto <short CP3>
	mov	bx, dx
	inc	di
CP3:	mov	es:[si], ax
	mov	es:[si+(INT_SZ*2)], bx
	dec	byte ptr n_loops
	jz	short CPBYE
	add	si, INT_SZ
	push	es
       .smov	cx, <_gfx .min_y>
       .smov	dx, <_gfx .max_y>
	pop	es
	jmp	CP0

CP_ERR: mov	di, 5
	jmp	CPBYE

CPBYE:	mov	ax, di
END_FCN

ENDIF

;/*~ RCDLNPNT.ASM */

START_FCN _gfx_record_line_points < <_int,x>,<_int,y>,<_int,d>,<_int,_d1>,<_int,_d2>,<_int,step>,<_int,count>,<_int,dir>, <DATA_PTR _stack>, <_int stack_pos>, <_int elem_sz> >;
PROLOGUE <SI, DI, DS>

       .lds	bx, _stack
	mov	ax, stack_pos
	mov	cx, elem_sz
	mul	cx
	add	bx, ax
	mov	dx, cx

	mov	ax, d
	mov	cx, count
	mov	si, x
	mov	di, y
       .if	dir EQ 0, then_goto <short DEDOT2>

DEDOT1:	mov	[bx], si	    ; save x
	mov	[bx+INT_SZ], di   ; save y
	add	bx, dx	    ; point to next record
	inc	di		; y++

       .if	ax GE 0, then_goto <short DE10>
	add	ax, _d1
	loop	DEDOT1
	jmp	RXIT

DE10:	add	ax, _d2
	add	si, step
	loop	DEDOT1
	jmp	RXIT


DEDOT2: mov	[bx], si	    ; save x
	mov	[bx+INT_SZ], di   ; save y
	add	bx, dx	    ; point to next record
	inc	si	      ; x++

       .if	ax GE 0, then_goto <short DE20>
	add	ax, _d1
	loop	DEDOT2
	jmp	RXIT

DE20:	add	ax, _d2
	add	di, step
	loop	DEDOT2

RXIT:
END_FCN;


;/*~ _IDIV.ASM */

	;  _gfx_idiv divides one integer by another, rounding the remainder to
	;  the nearest whole value.

START_FCN _gfx_idiv < <_int, num>, <_int, denom> >;
PROLOGUE;

	mov	bx, denom
	mov	ax, num
	xor	dx, dx
	div	bx
	shl	dx, 1
       .if	dx LT bx, then_goto <short MZ>
	inc	ax
MZ:
END_FCN;


;/*~ GET_PEL.ASM */

	;  _gfx_get_pel returns the value of a pel at the specified location.
	;  To get a pel's color for medium res or monochrome mode, we need to
	;  identify the bits in a byte, shift them to the low end of the byte
	;  and mask out the extra high bits.  For an EGA card, we need to
	;  construct the color by reading the four bitplanes


IFNDEF ASSEMBLE_WHOLE_FILE
EXTERN NEAR_CODE_PTR _00xy_to_ram
EXTERN FCN _gfx_clean_up_ega;
ENDIF

IFDEF TURBO_PASCAL
EXTERN CHAR SetGetPelJmpTable
START_DATA
  get_pel_jmp_table DW 3 DUP(?)
END_DATA
ELSE

STATIC NEAR_PTR get_pel_jmp_table, <offset CS_LBL:MRES_, offset CS_LBL:HRES_, offset CS_LBL:ERES_, offset CS_LBL:C256_>;
ENDIF

START_FCN _gfx_get_pel, < < _int, x>, < _int, y> >;
PROLOGUE <SI, DI, DS>;

IFDEF TURBO_PASCAL	    ; initialize TURBO PASCAL jump table
       .if  SetGetPelJmpTable EQ 1, then_goto <short EOTP5>
       .smov	SetGetPelJmpTable, 1
	lea	bx, get_pel_jmp_table
	mov	word ptr[bx],   offset CS_LBL:MRES_
	mov	word ptr[bx+2], offset CS_LBL:HRES_
	mov	word ptr[bx+4], offset CS_LBL:ERES_
	mov	word ptr[bx+6], offset CS_LBL:C256_
EOTP5:
ENDIF
	mov	cx, x
	mov	ax, y
        mov	bl, FCN_GET_PEL
       .call	_00xy_to_ram
	mov	ax, -1			  ; out of bounds==> -1
	jc	short XITR
	jmp	word ptr DS_LBL:get_pel_jmp_table[bx]

HRES_:	mov	cx, 7			  ; HIGH RES
	and	di, 7
	sub	cx, di
	mov	ah, 1
	jmp	short R_PIX

MRES_:	mov	cx, 3			  ; MEDIUM RES
	and	di, 3
	sub	cx, di
	shl	cx, 1
	mov	ah, 3

R_PIX: .smov	ds, <_gfx .screen_base>   ; GET CGA CARD PEL
	lodsb				  ; get the byte
	shr	al, cl			  ; shift pel to low bits
	and	al, ah			  ; mask out high bits
	and	ax, 0FH		  ; zero out all high bits
	jmp	short XITR		  ; got it ==> bye

ERES_:	.call	_gfx_clean_up_ega
	mov	dx, GRAPH_ADDR		  ; read one plane at a time
	mov	al, G_READ_MAP
	out	dx, al
	inc	dx
	mov	al, 3			  ; read planes 3-2-1-0

       .smov	ds, <_gfx .screen_base>   ; load screen segment
	mov	cx, di		  ; get pel # in byte
	and	cx, 7
	xor	bx, bx		  ; bh will hold the color

E0:	out	dx, al			  ; specify plane to read
	mov	bl, [si]		  ; read the byte
	shl	bl, cl			  ; rotate bit in bl's sign bit
	shl	bx, 1			  ; build the color in bh
	dec	al			  ; get ready for next plane
	jns	short E0
					  ; clean up by pointing
	dec	dx			  ; to 'bitmask' register
	mov	al, G_BITMASK
	out	dx, al
					  ; return color in ax
	xor	ax, ax
	mov	al, bh
	jmp	short XITR

C256_: .smov	ds, <_gfx .screen_base>   ; get 256 color pixel
	xor	ax, ax
	lodsb

XITR:
END_FCN;


;/*~ FINDB.ASM */

	;  _gfx_findb searches for a byte in an array and passes the byte's
	;  index in the array.	The length of the array is returned if the
	;  byte can't be found.

START_FCN  _gfx_findb, < <DATA_PTR, array>, <_int, arr_len>, < _int, _c> >;
PROLOGUE <ES, DI>;

	cld			; clear direction flag

	sub	ax, ax
	mov	cx, arr_len	; load arr_len
	mov	dx, cx	; save for later
	jcxz	short RTN	; check for a find of 0 bytes

       .les	di, array	; load address of array to be searched
	mov	al, _c		; load character to be matched in array

repnz scasb			; search a byte at a time

	mov	ax, dx	; assume no match, and return arr_len
	jne	short RTN
	sub	ax, cx	; if match, return its index
	dec	ax
RTN:

END_FCN;

;/*~ CALL_DOS.ASM */

	;  _gfx_call_dos is a simple function designed for DOS calls that
	;  only need to use the AX and DX registers.

START_FCN _gfx_call_dos, < <_int, fcn_n>, <_int, val> >;
PROLOGUE
	mov	ah, fcn_n;
	mov	dx, val;
	int	21H
END_FCN


;/*~ _GFXMOVE.ASM */
.386

	;  _gfx_move is a move function which asumes that the two areas do
	;  not overlap.

EXTERN _INT <NEAR _gfx_chip_type>

START_FCN $SMV

IF (DATA_PTR EQ ._SMALL_DATA_PTR)
	jmp	short SM0
	ELSE
	jmp	short SM1
	ENDIF

END_FCN NO_RET


IF (DATA_PTR EQ ._SMALL_DATA_PTR)

START_FCN _gfx_far_move < <FAR_PTR from>, <FAR_PTR to>, <_int, n_bytes> >
PROLOGUE <SI, DI, ES, DS>;

SM0:	cld
	lds	si, from
	les	di, to
	mov	cx, n_bytes
       .if	_gfx_chip_type GE 386, then_goto <short MB2>
	jmp	short MB1

ELSE
START_FCN _gfx_far_move
ENDIF
END_FCN NO_RET


START_FCN _gfx_move < <DATA_PTR from>, <DATA_PTR to>, <_int, n_bytes> >
PROLOGUE <SI, DI, ES, DS>;

SM1:	cld
	mov	ax, _gfx_chip_type
       .lds	si, from
       .les	di, to
	mov	cx, n_bytes
       .if	ax GE 386, then_goto <short MB2>
MB1:	shr	cx, 1
rep	movsw
	jnc	short MB3
	movsb
	jmp	short MB3

MB2:	push	cx
	shr	cx, 2
rep	movsd
	pop	cx
	and	cx, 3
rep	movsb

MB3:
END_FCN;


;/*~ RWSCRNTX.ASM */

ODD EQU 1

	; _gfx_rw_screen_text can read/write a line of data when in text mode.

IFNDEF TURBO_PASCAL
START_FCN _gfx_rw_screen_text, < <_int, x>, <_int, y>, <DATA_PTR, tp>, <_int, n_words>, <CHAR, to_screen> >;
PROLOGUE <SI, DI, ES, DS>;

	mov	cx, n_words		  ; # of words to move
	jcxz	short W2
	cld
	mov	di, x		  ; calculate screen buffer address
	dec	di
	shl	di, 1
	mov	ax, y
	dec	ax
       .smov	bl, <CHAR _gfx .bytes_per_row>
	shl	bl, 1
	mul	bl
	add	di, ax
	xor	bx, bx
       .smov	es, <_gfx .screen_base>
	xor	ax, ax
	mov	ax, es
       .if	ax LT 0B800H, then_goto <short W00>
	inc	bx	       ; mark possible CGA card
	mov	dx,	3DAh	       ; load status port address of 6845

W00:   .lds	si, tp

       .if	to_screen EQ YES, then_goto <short W0>
	xchg	si, di
	push	ds
	push	es
	pop	ds
	pop	es

W0:    .if	bx EQ YES, then_goto <short W1>
		; special handling for CGA snow
WLO:	in	al, dx			; wait for proper gfx status
       .if	ODD bit_is_on_in al, then_goto <short WLO>

WHIGH:	in	al, dx
       .if	ODD bit_is_off_in al, then_goto <short WHIGH>

W1:	movsw				; write the character/attribute
	loop	W0			; loop to next character

W2:	mov	ax, n_words		  ; return the # of words moved

END_FCN;

ENDIF


;/*~ LOSTRTCH.ASM */

START_FCN _gfx_xpand_bits < <FAR_PTR src_buf>, <FAR_PTR dest_buf>, <_INT swath>, <_INT src_len>, <_INT dest_len>, <_INT bits> >
AUTO < <_INT orig_swath>, <_INT n_planes> >
PROLOGUE <SI, DI, ES, DS>

	mov	word ptr n_planes, 0
       .if	src_len EQ 0, then_goto <short CPX>
	mov	word ptr n_planes, 4
CPX:	cld
       .lds	si, src_buf
       .les	di, dest_buf
	mov	bx, si
	add	bx, swath
	xor	cx, cx
       .if	bits EQ 8, then_goto <short CP40>

				;  Expand 1-bit string
	mov	orig_swath, bx
	mov	ch, 8
CP00:	mov	dl, 9
	mov	dh, [si]
	inc	si
CP01:	dec	dl
	jz	short CP00
CP02:	mov	cl, [bx]
	inc	bx
	or	cl, cl
	js	short CP30

CP10:	mov	ah, 0
	shl	dh, 1
	sbb	ah, 0
	rol	ax, cl
	sub	ch, cl
	jg	short CP01
	mov	cl, 0
	jz	short CP20
	mov	cl, ch
	neg	cl
	ror	ax, cl
CP20:	stosb
	mov	ch, 8
	sub	ch, cl
	rol	ax, cl
	jmp	short CP01

CP30:	mov	cl, ch
	shl	ax, cl
	stosb
	dec	word ptr n_planes
	jz	short CPBYE
	mov	si, src_buf
	add	si, src_len
	mov	src_buf, si
	mov	di, dest_buf
	add	di, dest_len
	mov	dest_buf, di
	mov	bx, orig_swath
	mov	ch, 8
	jmp	short CP00
			;  Expand 8-bit string

CP40:	mov	cl, [bx]
	inc	bx
	lodsb
       .if	cl EQ 0FFH, then_goto <short CPBYE>
rep	stosb
	jmp	short CP40

CPBYE:
END_FCN


START_FCN _gfx_set_swath < <FAR_PTR swath_buf>, <_INT n_stretch_dots>, <_INT n_orig_dots>, <_INT lead_pad> >
PROLOGUE <SI, DI, DS>

	cld
       .les	di, swath_buf
	mov	cx, lead_pad
	mov	ax, 1
rep	stosb
	mov	cx, n_orig_dots
	xor	ax, ax
rep	stosb
       .lds	si, swath_buf
	add	si, lead_pad
	xor	dx, dx
	mov	ax, n_orig_dots
	mov	cx, n_stretch_dots
	div	cx
	mov	di, ax
	div	cx
	jz	short FP00
	shl	dx, 1
	adc	ax, 0
FP00:	xor	dx, dx
	xor	bx, bx
	jmp	short FP1

FP0:	add	dx, ax
	adc	bx, di
FP1:	inc	byte ptr [si+bx]
	loop	FP0

	mov	di, si
	add	si, bx
	add	di, n_orig_dots
	dec	di
FP2:	cmp	si, di
	je	short FPBYE
	jb	short FP3
	mov	al, [si]
	add	[di], al
	dec	si
	jmp	short FP2
FP3:	mov	al, [si]
	dec	si
       .if	al EQ 0, then_goto <short FP3>
	dec	byte ptr [si+1]
	inc	byte ptr [di]

FPBYE:	mov	byte ptr [di+1], 0FFH

END_FCN



;/*~ SHFTBLOK.ASM */

IFNDEF ASSEMBLE_WHOLE_FILE
EXTERN _INT <NEAR _gfx_chip_type>
EXTERN FCN $SMV
ENDIF

.386

START_FCN  _gfx_shift_block, < <FAR_PTR, inbuf>, <FAR_PTR, outbuf>, <_int, n_bytes>, <_int, shift_n_bits> >;
PROLOGUE <SI, DI, DS, ES>;

	mov	cx, shift_n_bits
       .if	cx NE 0, then_goto <short SB0>
	jmp	$SMV
SB0:	cld
;	.smov	ax, _gfx_chip_type
	.lds	si, inbuf
	.les	di, outbuf
	mov	bx, n_bytes

;IFNDEF USE_386
;	.if	ax GE 386, then_goto <short SHIFT386>
       .if	cx LT 0, then_goto <short SL0>
	xor	dx, dx
	xor	ax, ax
SR1:	lodsb					; shift bits to right
	mov	ah, dl
	mov	dl, al
	shr	ax, cl
	stosb
	dec	bx
	jnz	SR1
	jmp	short SHIFTBLOCKBYE

SL0:	neg	cx				; shift bits to left
	mov	dl, [si]
	inc	si
	dec	bx
	jz	short SL1A
SL1:	lodsb
	mov	ah, dl
	mov	dl, al
	shl	ax, cl
	mov	al, ah
	stosb
	dec	bx
	jnz	SL1
SL1A:	mov	al, dl
	shl	ax, cl
	stosb
;	 jmp	SHIFTBLOCKBYE
; ENDIF

comment @

SHIFT386:				; version for 386 chip
       .if	cx LT 0, then_goto <short SL0A>
	xor	dx, dx

SR00:	lodsd
	xchg	ah, al
	rol	eax, 16
	xchg	ah, al
	shrd	dx, ax, 8
	shrd	eax, edx, cl
	xchg	ah, al
	rol	eax, 16
	xchg	ah, al
	sub	bx, 4
	jle	short SX10
	stosd
	jmp	short SR00

SL0A:	neg	cx
SL00:	lodsd
	xchg	ah, al
	rol	eax, 16
	xchg	ah, al
	mov	edx, [si+1]
	shld	eax, edx, cl
	xchg	ah, al
	rol	eax, 16
	xchg	ah, al
	sub	bx, 4
	jle	short SX10
	stosd
	jmp	short SL00

SX10:	jnz	short SX11
	stosd
	jmp	short SHIFTBLOCKBYE

SX11:	mov	cx, bx
	add	cx, 4
SX11A:	rol	eax, 8
	stosb
	loop	SX11A

@
SHIFTBLOCKBYE:

END_FCN


;/*~ PCX2PIC.ASM */

START_FCN _gfx_pcx_expand_row < <FAR_PTR xpand_buf>, <FAR_PTR pcx_buf>, <_INT xlat_x_bytes>, <_INT pad_bytes>, <_INT n_planes> >
PROLOGUE <SI, DI, ES, DS>

	cld
       .les	di, xpand_buf
       .lds	si, pcx_buf
	mov	bx, xlat_x_bytes
	xor	ax, ax
       .if	bx EQ 0, then_goto <short GBYE>
	mov	ax, n_planes
       .if	ax LE 1, then_goto <short G1>
       .if	ax LE 4, then_goto <short G0A>
	mov	word ptr n_planes, 4
G0A:	mul	bx
	mov	bx, ax
	add	di, 12

G1:	lodsb
	mov	ah, al
	and	ah, 0C0H

       .if	ah EQ 0C0H, then_goto <short G2>	; EXPAND SINGLE BYTE
	stosb
	dec	bx
	jnz	short G1
	jmp	short G3

G2:	mov	cx, ax			    ; EXPAND MULTIPLE BYTES
	and	cx, 3FH
	sub	bx, cx
	lodsb
	mov	ah, al
	shr	cx, 1
rep	stosw
	jnc	short G20
	stosb

G20:   .if	bx GT 0,  then_goto <short G1>

G3:	mov	ax, si
	sub	ax, pcx_buf
	mov	bx, n_planes
	dec	bx
	jle	short GBYE
	push	ax
       .lds	si, xpand_buf
	mov	di, si
	add	si, 12
	mov	dx, xlat_x_bytes

G30:	mov	cx, dx
	shr	cx, 1
rep	movsw
	jnc	short G31
	movsb
G31:	add	di, 4
	dec	bx
	jnz	G30
	pop	ax
GBYE:

END_FCN


START_FCN _gfx_pcx_count_rows < <FAR_PTR pcx_buf>, <_INT buf_size>, <_INT x_bytes>, <DATA_PTR max_y_rows>, <_INT n_planes> >
AUTO < <_INT next_row>, <_INT last_row> >
PROLOGUE <SI, DI, ES, DS>

	cld
       .les	si, max_y_rows
	mov	cx, es:[si]
       .lds	si, pcx_buf
	mov	next_row, si
	mov	di, si
	add	di, buf_size
	mov	ax, x_bytes
	mul	word ptr n_planes
	mov	x_bytes, ax

POA:	mov	dx, x_bytes

POB:	lodsb
	mov	ah, al
	and	ah, 0C0H
       .if	ah NE 0C0H, then_goto <short POC>
	inc	si
	and	ax, 3FH
	sub	dx, ax
	jg	short POB
	jmp	POD
POC:	dec	dx
	jnz	short POB

POD:   .if	si AB di, then_goto <short POBYE>
	mov	last_row, si
	loop	POA

POBYE:	mov	si, max_y_rows
	sub	es:[si], cx
	mov	ax, last_row
	sub	ax, pcx_buf

END_FCN



;/*~ PIC2PCX.ASM */

START_FCN _gfx_pcx_compress_row < <FAR_PTR xpand_buf>, <FAR_PTR pcx_buf>, <_INT xlat_x_bytes>, <_INT pad_byte>, <_INT n_planes> >
PROLOGUE <SI, DI, ES, DS>

	cld
	.lds	si, pcx_buf
	.les	di, xpand_buf
	mov	bx, xlat_x_bytes
       .if	bx EQ 0, then_goto <short JXBYE>

JX0:	mov	cx, 3FH
	mov	al, es:[di]
	inc	di
repe	scasb
	dec	di
	mov	dx, 3FH
	sub	dx, cx
	sub	bx, dx
	jns	short JX1
	add	dx, bx
	add	di, bx
	xor	bx, bx
JX1:   .if	dl GT 1, then_goto <short JX2>
	mov	ah, al
	and	ah, 0C0H
       .if	ah NE 0C0H, then_goto <short JX3>

JX2:	or	dl, 0C0H
	mov	[si], dl
	inc	si
JX3:	mov	[si], al
	inc	si
JX4:   .if	bx NE 0, then_goto <short JX0>
	mov	bx, xlat_x_bytes
	add	di, pad_byte
	dec	word ptr n_planes
	jnz	short JX0

JXBYE:	mov	ax, si
	sub	ax, pcx_buf

END_FCN


;/*~ XPANDRLE.ASM */

IFNDEF ASSEMBLE_WHOLE_FILE
EXTERN FCN <NEAR _ESnext_256_page>
EXTERN FCN <NEAR _DSnext_256_page>
EXTERN FCN < <NEAR _0xy_to_ram> >;
ENDIF


START_FCN _gfx_rle_compress_row < <FAR_PTR xpand_buf>, <FAR_PTR rle_buf>, <_INT xlat_x_bytes>, <_INT pad_byte>, <_INT n_planes> >
PROLOGUE <SI, DI, ES, DS>

	cld
       .lds	si, xpand_buf
       .les	di, rle_buf
	xor	ax, ax
	mov	dx, xlat_x_bytes
       .if	dx GT 2, then_goto <short F1>
       .if	dx EQ 0, then_goto <short F0>
	jmp	F80A
F0:	jmp	FBYE

F1:	mov	al, [si]
	mov	ah, al
       .if	ax NE [si+1], then_goto <short F2>
F1A:	mov	bl, 80H
       .if	al NE 0, then_goto <short F10>
	mov	bl, 0H
F10:   .if	al NE 0FFH, then_goto <short F11>
	mov	bl, 40H
F11:	mov	cx, dx
	xchg	si, di
	mov	ds, rle_buf+INT_SZ
repe	scasb
	jz	short F11A
	inc	cx
	dec	di
F11A:
	mov	ds, xpand_buf+INT_SZ
	xchg	si, di
	jcxz	short F5
	jmp	short F4

F2:	mov	bl, 0C0H
	mov	cx, dx
F30:	cmp	ax, [si+1]
	je	short F32
	inc	si
	mov	al, [si]
	mov	ah, al
	loop	F30
	jmp	short F5
F32:   .if	cx GT 2, then_goto <short F4>
	add	si, cx
	xor	cx, cx
	jmp	short F5

F4:	neg	cx
	add	cx, dx
	sub	dx, cx

F5:    .if	cx GE 20H, then_goto <short F6>
	mov	ch, cl
	or	ch, bl
	mov	es:[di], ch
	inc	di
	and	cx, 1FH
	jnz	short F7
	xchg	cx, dx
	jmp	short F7

F6:	or	ch, 20H
	or	ch, bl
	mov	es:[di], ch
	inc	di
	mov	es:[di], cl
	inc	di
	and	cx, 1FFH

F7:	shl	bl, 1
	jnc	short F8
	shl	bl, 1
	jnc	short F70
	sub	si, cx
rep	movsb
	jmp	short F8
F70:	stosb

F8:    .if	dx LE 2, then_goto <short F80>
	jmp	F1
F80:   .if	dx EQ 0, then_goto <short F81>
F80A:	mov	byte ptr es:[di], 0C0H
        inc	di
        mov	cx, dx
rep	movsb
F81:	dec	word ptr n_planes
	jz	short FBYE
	mov	dx, xlat_x_bytes
	add	si, pad_byte
       .if	dx LE 2, then_goto <short F80A>
	jmp	F1

FBYE:	mov	ax, di
	sub	ax, rle_buf
END_FCN


START_FCN _gfx_rle_expand_row < <FAR_PTR xpand_buf>, <FAR_PTR rle_buf>, <_INT xlat_x_bytes>, <_INT pad_byte>, <_INT n_planes> >
PROLOGUE <SI, DI, ES, DS>

	cld
	.lds	si, rle_buf
	.les	di, xpand_buf
	jmp	short MPL1

MPLANE: add	di, pad_byte
	dec	word ptr n_planes
	jz	short M0BYE
MPL1:	mov	dx, xlat_x_bytes
	xor	bx, bx

M00:	sub	dx, bx
	jle	short MPLANE
	lodsb
	mov	cl, al
	and	cx, 3FH
	jz	short M0A
       .if	20H bit_is_on_in cl, then_goto <short M0B>

M01:	mov	bx, cx
	and	al, 0C0H
	jz	short M04
	jns	short M02
       .if	al NE 0C0H, then_goto <short M03>

	shr	cx, 1
	jz	short M01A
rep	movsw
	jnc	short M00
M01A:	movsb
	jmp	M00

M02:	mov	al, 0FFH
	jmp	short M04
M03:	lodsb
M04:	shr	cx, 1
	jz	short M04A
	mov	ah, al
rep	stosw
	jnc	short M00
M04A:	stosb
	jmp	M00


M0A:	mov	cx, dx
	jmp	M01
M0B:	and	cl, 1FH
	mov	ch, cl
	mov	cl, [si]
	inc	si
	jmp	M01

M0BYE:	mov	ax, si
	sub	ax, rle_buf

END_FCN


START_FCN _gfx_rle_count_rows < <FAR_PTR rle_buf>, <_INT buf_size>, <_INT x_bytes>, <DATA_PTR max_y_rows>, <_INT n_planes> >
AUTO < <_INT next_row>, <_INT n_rows> >
PROLOGUE <SI, DI, ES, DS>

	cld
       .les	si, max_y_rows
	mov	cx, es:[si]
	mov	n_rows, cx
	.lds	si, rle_buf
	mov	next_row, si
	mov	di, si
	add	di, buf_size

R0A:	mov	ah, n_planes
R0B:	mov	dx, x_bytes
R0C:	lodsb
	mov	bl, al
	and	bx, 3FH
	jnz	short R1
	mov	bx, dx
	jmp	short R2
R1:    .if	20H bit_is_off_in bl, then_goto <short R2>
	and	bl, 1FH
	mov	bh, bl
	mov	bl, [si]
	inc	si
R2:	shl	al, 1
	jnc	short R3
	shl	al, 1
	jc	short R20
	inc	si
	jmp	short R3
R20:	add	si, bx

R3:    .if	si AB di, then_goto <short R5>
	sub	dx, bx
	jg	short R0C
	jl	short R4
	dec	ah
	jnz	short R0B
	mov	next_row, si
	loop	R0A
	jmp	short R5

R4:	mov	cx, n_rows
	inc	cx

R5:	mov	si, max_y_rows
	sub	es:[si], cx
	mov	ax, next_row
	sub	ax, rle_buf
END_FCN


;/*~ SCRNLNIO.ASM */

IFNDEF ASSEMBLE_WHOLE_FILE
EXTERN FCN  <NEAR _0xy_to_ram>;
EXTERN FCN _gfx_clean_up_ega
EXTERN FCN <NEAR _DSnext_256_page>;
EXTERN FCN <NEAR _DSprev_256_page>;
EXTERN FCN <NEAR _ESnext_256_page>;
EXTERN FCN <NEAR _0new_256_page>;
EXTERN CHAR < <NEAR $256_page_n> >
EXTERN _INT <NEAR _gfx_chip_type>
EXTERN _INT <NEAR _gfx>
ENDIF

STATIC _INT $next_tv_offset, 0
STATIC _INT $next_line, 0
STATIC _INT $res_type, 0
STATIC _INT $tv_page, 0

	; $card_flags -- bit  0 ==> set a new 256 page (found in low byte)
	;		 bit 15 ==> banked card (CGA, HERC etc.)

STATIC _INT $card_flags, 0

CGA_BANKS equ 8000H

COLOR_PLANES	equ	2 * INT_SZ
COLOR_256	equ	3 * INT_SZ

START_FCN _gfx_init_move_vid_line < <_INT x>, <_INT y> >
PROLOGUE <SI, DI>

	mov	cx, x
	mov	ax, y
	mov	bl, FCN_INIT_MOVE_VID_LINE
       .if	ax GE 0, then_goto <short PM00>
	xor	ax, ax
PM00:  .call	_0xy_to_ram
       .smov	$next_tv_offset, si
       .smov	$res_type, bx
       .if	<_gfx .gfx_mode> NE 4, then_goto <short PM0A>
	mov	$res_type, 2
PM0A:	xor	ax, ax
       .smov	al, $256_page_n
       .smov	$tv_page, ax
	xor	ax, ax
       .if	<_gfx .last_video_row> AB 8000H, then_goto <short PM01>
	mov	ax, CGA_BANKS
PM01:  .smov	$card_flags, ax
       .smov	ax, <_gfx .bytes_per_row>
       .if	bx GE COLOR_PLANES, then_goto <short PMBYE>
	mov	ax, 2000H
PMBYE: .smov	$next_line, ax

END_FCN


START_FCN _gfx_move_next_vid_line < <FAR_PTR buf>, <_INT show_x_bytes>, <_INT x_bytes>, <_INT masks>, <_INT action> >
AUTO < <_INT vid_buf>, <_INT next_plane>, <_INT skip_x_bytes>, <_INT res_type>, <_INT cpu>, <_INT ml_offset>, <_INT maskbits>, <_INT sbase>, <_INT pg256> >
PROLOGUE <SI, DI, ES, DS>

       .smov	ax, $next_tv_offset
	mov	vid_buf, ax		 ; save video buffer offset
       .sadd	ax, $next_line
	jc	short PQA
       .sdo	test $card_flags, CGA_BANKS+1
	jz	short PQ0
	jns	short PQB
       .smov	bx, <_gfx .last_video_row>
       .if	ax BL bx, then_goto <short PQ0>
	sub	ax, bx
	jmp	short PQ0
PQA:   .sdo	or $card_flags, 1H
       .sinc	$tv_page
	jmp	short PQ0
PQB:   .smov	$card_flags, 0
	push	ax
       .smov	ax, $tv_page
       .call	_0new_256_page
	pop	ax

PQ0:   .smov	$next_tv_offset, ax
	cld
	mov	si, vid_buf
	mov	cx, show_x_bytes	 ; load # of bytes to be moved
       .smov	ax, $res_type
	mov	dx, ax
	mov	res_type, ax
	mov	ax, x_bytes
	sub	ax, show_x_bytes
	mov	skip_x_bytes, ax
	xor	ax, ax
	mov	ml_offset, ax
	mov	pg256, ax
       .smov	bx, <_gfx .screen_base>

	mov	ax, action
	cmp	al, 1
	je	short PQWW
	jl	short PQR0
	mov	word ptr next_plane, 1
	mov	sbase, bx
	mov	ax, _gfx_chip_type
	mov	cpu, ax
       .if	dl NE COLOR_256, then_goto <short PQX0>
	mov	ax, show_x_bytes
	jmp	short PQX1
PQWW:	jmp	PQW0
PQX0:	mov	ax, x_bytes
	shl	ax, 1
       .if	dl NE COLOR_PLANES, then_goto <short PQX1>
	shl	ax, 1
	mov	word ptr next_plane, 4
PQX1:	mov	ml_offset, ax
       .if	action NE 5, then_goto <short PQR0>
	mov	di, buf
	add	di, ax
	mov	maskbits, di
	add	ax, x_bytes
	mov	ml_offset, ax

				; ****************** READ LINE
PQR0:	.les	di, buf
	add	di, ml_offset
	mov	ds, bx
	xor	bx, bx
	xor	dx, dx
	mov	cx, x_bytes
       .if	res_type EQ COLOR_PLANES, then_goto <short PQR2>
       .if	res_type NE COLOR_256, then_goto <short PQREAD>

	mov	ax, vid_buf		; 256-color
	add	ax, cx
	jnc	short PQREAD
	mov	bx, ax
	sub	cx, ax
	jmp	short PQREAD

PQR2:	mov	dx, GRAPH_ADDR		; set for reading from ega/vga buf
	mov	al, G_READ_MAP
	out	dx, al
	inc	dx
PQR2A:	mov	al, bl			; rotate to read next plane
	out	dx, al
	mov	si, vid_buf
	mov	cx, x_bytes

PQREAD:	shr	cx, 1
rep	movsw
	jnc	short PQR3
	movsb

PQR3:  .if	dx EQ 0, then_goto <short PQR4A>
	add	si, skip_x_bytes
	inc	bx
       .if	bl LT 4, then_goto <short PQR2A>
	jmp	short PQR5

PQR4:  .call	_DSnext_256_page
	inc	word ptr pg256
	mov	cx, bx
	xor	bx, bx
	jmp	short PQREAD
PQXIT:	jmp	PQEXIT
PQR4A: .if	bx NE 0, then_goto <short PQR4>

PQR5:  .if	action EQ 0, then_goto <short PQXIT>

				;*************** MODIFY LINE
	.lds	di, buf
	mov	si, di
	add	si, ml_offset
	mov	ml_offset, si

	xor	ax, ax
	mov	al, action
       .if	ax EQ 5, then_goto <short AMATTE>
	mov	cx, x_bytes
       .if	next_plane LE 1, then_goto <short ML0>
       .shl	cx, 3
ML0:	shr	cx, 1
	sub	ax, 3
	jz	short AOR
	jg	short AXOR

AAND:	lodsw			; action == 2  AND
	and	[di], ax
	add	di, 2
	loop	AAND
	jmp	ABYE

AOR:	lodsw			; action == 3  OR
	or	[di], ax
	add	di, 2
	loop	AOR
	jmp	ABYE

AXOR:	lodsw			; action == 4  XOR
	xor	[di], ax
	add	di, 2
	loop	AXOR
	jmp	short ABYE

AMATTE: .if	res_type EQ COLOR_256, then_goto <short A256MATTE>

A1PUT:	dec	word ptr next_plane
	jl	short ABYE
	mov	bx, maskbits	 ; action == 5	MATTE  (PUT w/ a mask)
	mov	cx, x_bytes
	shr	cx, 1
A2PUT:	lodsw
	mov	dx, [bx]
	add	bx, 2
	and	[di], dx
	not	dx
	and	ax, dx
	or	[di], ax
	add	di, 2
	loop	A2PUT
	mov	cx, x_bytes
	and	cx, 1
	add	di, cx
	add	si, cx
	jmp	short A1PUT

A256MATTE:
	mov	bx, x_bytes
	mov	al, masks
	mov	word ptr masks, 0
AX0:	dec	bx
	js	short ABYE
       .if	al NE [di+bx], then_goto <short AX0>
	mov	ah, [si+bx]
	mov	[di+bx], ah
	jmp	short AX0

ABYE:	mov	bx, sbase
	mov	si, vid_buf
       .if	pg256 EQ 0, then_goto <short PQW0>
       .call	_DSprev_256_page

				;*************** WRITE LINE
PQW0:	mov	es, bx
	mov	di, si
	.lds	si, buf
	mov	ax, x_bytes
	mov	cx, show_x_bytes
	sub	ax, cx
	jle	short PQW2
	mov	word ptr skip_x_bytes, ax

PQW2:  .if	res_type NE COLOR_PLANES, then_goto <short PQ5>
       .if	masks EQ 0, then_goto <short PQ30C>
	mov	dx, GRAPH_ADDR
	mov	al, G_READ_MAP
	out	dx, al
	inc	dx
	mov	cx, 4
	mov	bx, show_x_bytes
	dec	bx
PQ30A:	mov	al, cl
	dec	al
	out	dx, al
	mov	ah, es:[di]
	mov	al, es:[di+bx]
	push	ax
	loop	PQ30A

PQ30C:	mov	dx, SEQ_ADDR		; set for writing ega/vga buf
	mov	al, S_MAP
	out	dx, al
	inc	dx
	mov	bl, 11H
	mov	word ptr next_plane, offset CS_LBL:PQ30D

PQ30D:	mov	al, bl			; rotate to write to next plane
	out	dx, al
	mov	di, vid_buf
	mov	cx, show_x_bytes
	shl	bl, 1
	jnc	short PQ8

PQ32:	xor	dx, dx
	xor	bx, bx
	jmp	short PQ8

PQ5:	xor	bx, bx
	xor	dx, dx
       .if	res_type NE COLOR_256 then_goto <short PQ7>

	mov	ax, vid_buf				; 256-color
	add	ax, cx
	jnc	short PQ81
	mov	bx, ax
	sub	cx, ax
	jmp	short PQ81

PQ7:   .if	masks EQ 0, then_goto <short PQ81>		; mono-plane bitmap
	xchg	bx, show_x_bytes
	dec	bx
	mov	ah, es:[di]
	mov	al, es:[di+bx]
	jmp	short PQ80A

PQ8:   .if	masks EQ 0, then_goto <short PQ81>
	xchg	bx, show_x_bytes
	dec	bx
	pop	ax
PQ80A:	mov	cx, masks
	and	ax, cx
	not	cx
	and	[si], ch
	or	[si], ah
	and	[si+bx], cl
	or	[si+bx], al
	inc	bx
	mov	cx, bx
	xchg	bx, show_x_bytes

PQ81:	shr	cx, 1
rep	movsw
PQ9:	jnc	short PQ10
	movsb

PQ10:  .if	dx EQ 0, then_goto <short PQ11>
	add	si, skip_x_bytes
	jmp	word ptr next_plane

PQ11:  .if	bx EQ 0, then_goto <short PQEXIT>
       .call	_ESnext_256_page
	mov	cx, bx
	xor	bx, bx
	xor	dx, dx
	jmp	PQ81
PQEXIT:

END_FCN


START_FCN _gfx_xlat_256_colors < <FAR_PTR cdata>, <FAR_PTR cmap>, <_INT n_bytes> >
PROLOGUE <DI, ES, DS>
	cld
       .les	di, cdata
       .lds	bx, cmap
	mov	cx, n_bytes
       .shr	cx, 2
	jz	short VC1

VC0:	mov	ax, es:[di]
	xlatb
	xchg	ah, al
	xlatb
	xchg	ah, al
	stosw
	mov	ax, es:[di]
	xlatb
	xchg	ah, al
	xlatb
	xchg	ah, al
	stosw
	loop	short VC0

VC1:	mov	cx, n_bytes
	and	cx, 3
	jz	short VCBYE

VC2:	mov	al, es:[di]
	xlatb
	stosb
	loop	short VC2

VCBYE:

END_FCN




;/*~ PROMCOLR.ASM */

  ; type==1 (1->16), type==2 (1->256), type==3 (16->256), type==4(256->16)

START_FCN _gfx_promote_colors < <FAR_PTR src_buf>, <FAR_PTR dest_ptr>, <_INT len>, <_INT base_color>, <_INT _type> >
PROLOGUE <SI, DI, ES, DS>

	cld
	.lds	si, src_buf
	.les	di, dest_ptr
	mov	cx, len
	mov	bx, cx
	mov	dx, base_color

	cmp	word ptr _type, 2
	je	short MXA4
	jg	short MXB00
	or	dx, 10H
					; mono -> 16 colors
MXA1:	mov	si, src_buf
	mov	cx, len
	shr	dx, 1
	jz	short MXXBYE
	jnc	short MXA2
	shr	cx, 1
rep	movsw
	jnc	short MXA1
	movsb
	jmp	short MXA1
MXA2:	xor	ax, ax
	shr	cx, 1
rep	stosw
	jnc	short MXA1
	stosb
	jmp	short MXA1

					; mono -> 256 colors
MXA4:	lodsb
	mov	ah, al
	mov	cx, 8
MXA40:	mov	al, 0
	shl	ah, 1
	jnc	short MXA41
	mov	al, dl
MXA41:	stosb
	loop	short MXA40
	dec	bx
	jnz	MXA4
MXXBYE:	jmp	MXBYE

					; 16 -> 256 colors
MXB00:	mov	ax, len
	mov	_type, ax
MXB0:	mov	cl, [si]
	mov	bx, len
	mov	ch, [si+bx]
	add	bx, bx
	mov	dl, [si+bx]
	add	bx, len
	mov	dh, [si+bx]
	mov	bl, base_color
	mov	ah, cl
	mov	cl, 8
	inc	si

MXB1:	mov	al, 0
	shl	dh, 1
	adc	al, 0
	shl	al, 1
	shl	dl, 1
	adc	al, 0
	shl	al, 1
	shl	ch, 1
	adc	al, 0
	rol	ax, 1
	add	al, bl
	stosb
	dec	cl
	jnz	short MXB1
	dec	word ptr _type
	jnz	short MXB0
	jmp	short MXBYE


MXC01:	mov	ah, 1

MXC02:	shl	cx, 1
	shl	dx, 1
	lodsb
	shr	al, 1
	adc	cl, 0
	shr	al, 1
	adc	ch, 0
	shr	al, 1
	adc	dl, 0
	shr	al, 1
	adc	dh, 0
	shl	ah, 1
	jnz	short MXC02
	mov	es:[di], cl
	mov	es:[di+bx], ch
	mov	ax, bx
	add	bx, bx
	mov	es:[di+bx], dl
	add	bx, ax
	mov	es:[di+bx], dh
	mov	bx, ax
	inc	di
	sub	word ptr len, 8
	jg	short MXC01

MXBYE:

END_FCN


;/*~ BLD16MSK.ASM */

START_FCN _gfx_build_16_mask < <FAR_PTR src_buf>, <FAR_PTR mask_buf>, <_INT len>, <_INT color> >
AUTO < <_INT plane_1>, <_INT plane_2>, <_INT plane_3>, <_INT plane_4> >
PROLOGUE <SI, DI, ES, DS>

	.lds	si, src_buf
	.les	di, mask_buf
	mov	cx, len
	mov	bx, cx
	mov	dx, color
	cld

       .if	dx NE 0, then_goto <short BZ2B>
	mov	dx, cx
	shr	cx, 1
BZ2A:	mov	ax, [si]			; mask for color zero
	mov	bx, dx
	or	ax, [si+bx]
	add	bx, dx
	or	ax, [si+bx]
	add	bx, dx
	or	ax, [si+bx]
	stosw
	add	si, 2
	loop	BZ2A
	jmp	short BZEND

BZ2B:	xor	ax, ax			; mask for any color
	mov	word ptr plane_1, ax
	shr	dx, 1
	sbb	word ptr plane_1, ax
	mov	word ptr plane_2, ax
	shr	dx, 1
	sbb	word ptr plane_2, ax
	mov	word ptr plane_3, ax
	shr	dx, 1
	sbb	word ptr plane_3, ax
	mov	word ptr plane_4, ax
	shr	dx, 1
	sbb	word ptr plane_4, ax
	shr	cx, 1

BZ2C:	mov	ax, [si]
	xor	ax, plane_1
	mov	bx, len
	mov	dx, [si+bx]
	xor	dx, plane_2
	or	ax, dx
	add	bx, bx
	mov	dx, [si+bx]
	xor	dx, plane_3
	or	ax, dx
	add	bx, len
	mov	dx, [si+bx]
	xor	dx, plane_4
	or	ax, dx
	stosw
	add	si, 2
	loop	BZ2C

BZEND:
END_FCN




;/*~ REVBLOCK.ASM */

	; _gfx_reverse_block is used to complement all the bytes in an array.

START_FCN _gfx_reverse_block < <DATA_PTR block>, <_INT, n_bytes> >
PROLOGUE <L_DS>
	mov	cx, n_bytes
	jcxz	short Q2
       .lds	bx, block
Q1:	not	byte ptr [bx]
	inc	bx
	LOOP	Q1
Q2:
END_FCN


;/*~ EGAMODFY.ASM */

IFNDEF ASSEMBLE_WHOLE_FILE
EXTERN FCN _gfx_set_w2_ega_mode
ENDIF

	;  _gfx_set_ega_modify_type specifies how the EGA/VGA card will write
	;  data to the screen, by setting the Function select in the Data
	;  Rotate Register.  The following values produce:
	;
	;		0 -- Data unmodified
	;		1 -- Data ANDed with latched data
	;		2 -- Data Ored with latched data
	;		3 -- Data XOred with latched data

START_FCN _gfx_set_ega_modify_type, < <_int, mod_type> >;
PROLOGUE;

       .if	8 bit_is_on_in mod_type, then_goto <short XZ1>
       .call	_gfx_set_w2_ega_mode
XZ1:	mov	dx, GRAPH_ADDR
	mov	al, G_DATA_ROT
	out	dx, al
	mov	al, mod_type
	and	al, 3
       .shl	al, 3
	inc	dx
	out	dx, al
	dec	dx

	mov	al, G_BITMASK  ; set all bits in the bitmask ON
	out	dx, al
	inc	dx
	mov	al, 0FFH
	out	dx, al

END_FCN;


;/*~ GFXLPEEK.ASM */

IFNDEF TURBO_PASCAL
START_FCN _gfx_lpeek < <FAR_PTR, mem_ptr> >
PROLOGUE <ES>

      .les	bx, mem_ptr
       xor	ax, ax
       mov	al, es:[bx]

END_FCN;
ENDIF

;/*~ CHKCRSRR.ASM */

START_FCN _gfx_check_crsr_reg < <_INT, port_n> >
PROLOGUE

	mov	dx, port_n
	mov	al, 0FH
	out	dx, al
	inc	dx
	in	al, dx
	mov	bl, al
	mov	al, 5AH
	out	dx, al
	mov	cx, 4
Z1:	dec	cx
	jnz	short Z1
	in	al, dx
	.if	al NE 5AH, then_goto <short Z2>
	inc	cx
Z2:	mov	al, bl
	out	dx, al
	mov	ax, cx

END_FCN;

;/*~ CHKHERC.ASM */

	; _gfx_check_hercules_card checks for the presence of a Hercules card.

START_FCN _gfx_check_hercules_card
	mov	dx, 3BAH
	in	al, dx
	and	al, 80H
	mov	ah, al

	mov	cx, 8000H
XX1:	in	al, dx
	and	al, 80H
	cmp	ah, al
	loope	XX1

	mov	ax, 0
	je	short XX2
	inc	ax
XX2:

END_FCN


;/*~ DBLPAT.ASM */

	;  _gfx_dbl_pattern takes a bit patter and doubles the value of every
	;  bit.  This is needed for writing bit patterns in a medium
	;  resolution screen, because every pel needs two bits.  The
	;  approach is two read in a byte, double each bit and then write a
	;  word out to the destination buffer.

START_FCN _gfx_dbl_pattern < <DATA_PTR pattern>, <DATA_PTR new_pattern>, <_INT n_bytes> >;
PROLOGUE <DI, ES, DS>

	cld
       .lds	bx, pattern		  ; address of bit pattern
       .les	di, new_pattern	  ; destination buffer
	mov	cx, n_bytes		  ; length of bit pattern

O1:	mov	ax, 8000H		  ; set marker
	mov	dl, [bx]		  ; read bit pattern byte
	inc	bx			  ; point to next byte
O2:	shr	dl, 1			; loop through the bits
	rcr	ax, 1		  ; constructing a double bit pattern
	sar	ax, 1
	jnc	short O2
	xchg	ah, al			; when done, write out the new pattern
	not	ax
	stosw
	loop	O1			; loop for next byte

END_FCN


;/*~ ROLBITS.ASM */

	; _gfx_rol does a rotate left of a value and returns it.

START_FCN _gfx_rol < <_INT, val>, <_INT, n_bits> >
PROLOGUE;
	mov	ax, val
	mov	cx, n_bits
	rol	ax, cl

END_FCN;


;/*~ PATHLINE.ASM */

IFNDEF ASSEMBLE_WHOLE_FILE
EXTERN FCN <NEAR _0xy_to_ram>;
EXTERN FCN <NEAR _ESnext_256_page>
EXTERN CHAR < <NEAR _rbitmask> >;
ENDIF


	; _gfx_asm_pat_hline draws a horizontal line with a bit pattern.

IFDEF TURBO_PASCAL
EXTERN _INT SetAsmPatJmpTable
START_DATA
  jmp_table DW 3 DUP(?)
END_DATA
ELSE
STATIC NEAR_PTR jmp_table, <offset CS_LBL:DM00, offset CS_LBL:DH00, offset CS_LBL:DE00, offset CS_LBL:D256>;
ENDIF

START_FCN _gfx_asm_pat_hline <<_INT x>,<_INT y>,<_INT color>,<_INT line_len>,<DATA_PTR pat_ptr>,<_INT pat_len>,<_INT init_offset>,<_INT rmask>,<_INT lmask>>;
AUTO < <_int end_of_pat> >;
PROLOGUE <SI, DI, ES, DS>

IFDEF TURBO_PASCAL	    ; initialize TURBO PASCAL jump table
       .if  SetAsmPatJmpTable EQ 1, then_goto <short EOTP7>
       .smov	SetAsmPatJmpTable, 1
	lea	bx, jmp_table
	mov	word ptr[bx],   offset CS_LBL:DM00
	mov	word ptr[bx+2], offset CS_LBL:DH00
	mov	word ptr[bx+4], offset CS_LBL:DE00
	mov	word ptr[bx+6], offset CS_LBL:D256
EOTP7:
ENDIF
	mov	cx, x
	mov	ax, y
	mov	bl, FCN_ASM_PAT_HLINE
       .call	_0xy_to_ram

       .smov	cx, <_gfx .color_flags>
	mov	ah, color
	mov	color, cx
	mov	cx, line_len
	mov	di, si
	mov	dx, pat_len
       .smov	es, <_gfx .screen_base>
	jmp	word ptr DS_LBL:jmp_table[bx]

DM00:  .lds	si, pat_ptr
	shl	dx, 1
	add	si, dx
	neg	dx
	mov	bx, init_offset	  ; CGA Medium Res
	add	bx, dx
	mov	ch, lmask
       .if	XOR_PEL bit_is_on_in color, then_goto <short DXM00>

DM01:	mov	al, [si+bx]
	or	al, ch
	and	es:[di], al
	not	al
	and	al, ah
	not	ch
	and	al, ch
	or	es:[di], al
	inc	di
	inc	bx
	jnz	short DM02
	mov	bx, dx
DM02:	mov	ch, 0
	dec	cl
	jg	short DM01
	js	short DMXIT
	mov	ch, rmask
	jmp	DM01

DXM00:	not	ch
DXM01:	mov	al, [si+bx]
	not	al
	and	al, ah
	and	al, ch
	xor	es:[di], al
	inc	di
	inc	bx
	jnz	short DXM02
	mov	bx, dx
DXM02:	mov	ch, 0FFH
	dec	cl
	jg	short DXM01
	js	short DMXIT
	mov	ch, rmask
	jmp	DXM00
DMXIT:	jmp	DXIT

DH00:	mov	bx, init_offset	  ; CGA Hi Res
       .lds	si, pat_ptr
	add	si, dx
	neg	dx
	add	bx, dx
       .if	XOR_PEL bit_is_on_in color, then_goto <short DXH00>
	mov	al, lmask

DH01:	and	al, [si+bx]
       .if	ah NE 0, then_goto <short DH02>
	not	al
	and	es:[di], al
	jmp	DH03
DH02:	or	es:[di], al
DH03:	inc	di
	inc	bx
	jnz	short DH04
	mov	bx, dx
DH04:	mov	al, 0FFH
	dec	cx
	jg	short DH01
	js	short DXIT
	mov	al, rmask
	jmp	DH01

DXH00:	mov	al, lmask
DXH01:	and	al, [si+bx]
	xor	es:[di], al
	inc	di
	inc	bx
	jnz	short DXH02
	mov	bx, dx
DXH02:	mov	al, 0FFH
	dec	cx
	jg	short DXH01
	js	short DXIT
	mov	al, rmask
	jmp	DXH01

DE00:	mov	bx, init_offset	  ; EGA
       .lds	si, pat_ptr
	add	si, dx
	mov	dx, GRAPH_ADDR+1
	neg	word ptr pat_len
	add	bx, pat_len
	mov	al, lmask

DE01:	and	al, [si+bx]
	out	dx, al
	mov	al, es:[di]		  ; prime the latches
	mov	es:[di], ah
	inc	di
	inc	bx
	jnz	short DE02
	mov	bx, pat_len
DE02:	mov	al, 0FFH
	dec	cx
	jg	short DE01
	js	short DXIT
	mov	al, rmask
	jmp	DE01

DXIT:	jmp	DBYE

D256:	mov	bx, cx				; bx = line_len
       .lds	si, pat_ptr
	add	dx, si				; end_of_pat = si + pat_len
	mov	end_of_pat, dx
	add	si, init_offset
	lodsb
       .if	si LT end_of_pat, then_goto <short D2A>
	mov	si, pat_ptr
D2A:	mov	cx, x
	and	cx, 7
	mov	dx, cx
	add	dx, bx
       .if	dx GE 8, then_goto <short D2A1>
	xchg	dx, bx
       .smov	bl, <_rbitmask [bx]>
	and	al, bl
	mov	bx, dx

D2A1:	jcxz	short D2A2
	shl	al, cl
	neg	cl
D2A2:	add	cl, 8
	sub	bx, cx
;      .smov	es, <_gfx .screen_base>
       .if	XOR_PEL bit_is_off_in color, then_goto <short D2F>
	jmp	short D2D

D2B:	lodsb
       .if	si LT end_of_pat, then_goto <short D2C>
	mov	si, pat_ptr
D2C:	mov	cx, 8
	sub	bx, cx
	jns	short D2C0
	add	cx, bx
D2C0:	jmp	dx

D2D:	mov	dx, offset CS_LBL:D2E
D2E:	shl	al, 1
	jnc	short D2H
	xor	es:[di], ah
	jmp	short D2H

D2F:	mov	dx, offset CS_LBL:D2G
D2G:	shl	al, 1
	jnc	short D2H
	mov	es:[di], ah

D2H:	inc	di
	jz	short D2HB
D2HR:	dec	cx
	jz	short D2I
	jmp	dx
D2HB:  .call	_ESnext_256_page
	jmp	D2HR
D2I:   .if	bx GT 0, then_goto <short D2B>

DBYE:

END_FCN


;/*~ ASMVLINE.ASM */

IFNDEF ASSEMBLE_WHOLE_FILE
EXTERN FCN <NEAR _0xy_to_ram>;
EXTERN FCN <NEAR _ESnext_256_page>
EXTERN CHAR < <NEAR _0med_res_color_mask>, <NEAR _0hi_res_color_mask> >;
EXTERN CHAR < <NEAR _0med_res_pel_mask>, <NEAR _0hi_res_pel_mask> >;
ENDIF

    ; _gfx_asm_vline draws a solid, vertical line. Note that it is just
    ; a slightly modified _gfx_get_pel. It loops and writes a dot at a time.

IFDEF TURBO_PASCAL
EXTERN CHAR SetVlineJmpTable
START_DATA
  vline_jmp_table DW 3 DUP(?)
END_DATA
ELSE
STATIC NEAR_PTR vline_jmp_table, <offset CS_LBL:VMRES, offset CS_LBL:VHRES, offset CS_LBL:VERES, offset CS_LBL:V256>;
ENDIF

START_FCN _gfx_asm_vline, < < _int, x>, < _int, y>, <_int, len>, < _int, color> >
PROLOGUE <SI, DI, ES>;

IFDEF TURBO_PASCAL	    ; initialize TURBO PASCAL jump table
       .if  SetVlineJmpTable EQ 1, then_goto <short EOTP8>
       .smov	SetVlineJmpTable, 1
	lea	bx, vline_jmp_table
	mov	word ptr[bx],   offset CS_LBL:VMRES
	mov	word ptr[bx+2], offset CS_LBL:VHRES
	mov	word ptr[bx+4], offset CS_LBL:VERES
EOTP8:
ENDIF
	mov	cx, x
	mov	ax, y
	mov	bl, FCN_ASM_VLINE
       .call	_0xy_to_ram
	and	di, 7
	mov	cx, len
	jmp	word ptr DS_LBL:vline_jmp_table[bx]

VHRES:	mov	bx, di
       .smov	ah, <_0hi_res_pel_mask [bx]>		; HIGH RES
	mov	bl, color
       .smov	al, <_0hi_res_color_mask [bx]>
	jmp	short VW_PIX

VMRES:	mov	bx, di
	and	bx, 3			  ; MEDIUM RES
       .smov	ah, <_0med_res_pel_mask [bx]>
	mov	bl, color
       .smov	al, <_0med_res_color_mask [bx]>

VW_PIX: and	al, ah				; SET CGA CARD PEL
	not	ah
       .smov	dx, <_gfx .last_video_row>
       .smov	di, <_gfx .color_flags>
       .smov	es, <_gfx .screen_base>
	lea	bx, CS_LBL:V0_PIX
       .if	XOR_PEL bit_is_off_in di, then_goto <short V0_PIX>
	lea	bx, CS_LBL:VX_PIX

VX_PIX:	xor	es:[si], al
	jmp	short V0APIX
V0_PIX: and	es:[si], ah	      ; put pel
	or	es:[si], al
V0APIX: add	si, 2000H		  ; next row
       .if	si BE dx, then_goto <short V1_PIX>	; check for wrap around
	sub	si, dx
V1_PIX: dec	cx
	jz	short VXIT
	jmp	bx

VERES:	mov	bx, di		; ENHANCED RES
	mov	dx, GRAPH_ADDR
	mov	al, G_BITMASK
	out	dx, al
       .smov	al, <_0hi_res_pel_mask [bx]>
	inc	dx
	out	dx, al
	mov	al, color
       .smov	dx, <_gfx .bytes_per_row>
       .smov	es, <_gfx .screen_base>

VX0:	mov	ah, es:[si]
	mov	es:[si], al
	add	si, dx
	jc	short VX1B
VX1A:	loop	VX0
	sti
EVXIT:	jmp	short VXIT
VX1B:  .call	_ESnext_256_page
	jmp	short VX1A

V256:  .smov	dx, <_gfx .bytes_per_row>
       .smov	es, <_gfx .screen_base>
	mov	al, color
	lea	bx, CS_LBL:V256A
       .if	XOR_PEL bit_is_off_in <_gfx .color_flags>, then_goto <short V256A>
	lea	bx, CS_LBL:V256X

V256X:	xor	es:[si], al
	jmp	short V256AA
V256A:	mov	es:[si], al
V256AA:	add	si, dx
	jc	short V256B
V256A0: dec	cx
	jz	short VXIT
	jmp	bx
V256B: .call	_ESnext_256_page
	jmp	short V256A0

VXIT:
END_FCN;




;/*~ ASMHLINE.ASM */

IFNDEF ASSEMBLE_WHOLE_FILE
EXTERN FCN <NEAR _0xy_to_ram>;
EXTERN FCN <NEAR _ESnext_256_page>
EXTERN CHAR < <NEAR _0med_res_color_mask>, <NEAR _0hi_res_color_mask> >;
EXTERN CHAR < <NEAR _lbitmask>, <NEAR _rbitmask> >;
ENDIF
	; _gfx_asm_hline draws a line of a solid color.

_2ND_PASS	EQU	80H
_XOR_PELS	EQU	20H
E_RES_CARD	EQU	E_RES_COLOR

IFDEF TURBO_PASCAL
EXTERN CHAR SetAsmHlineJmpTable
START_DATA
  _asm_hline_jmp_table DW 3 DUP(?)
END_DATA
ELSE

STATIC NEAR_PTR _asm_hline_jmp_table, <offset CS_LBL:$MED_RES_FASTLINE, offset CS_LBL:D1, offset CS_LBL:D0>;
ENDIF

START_FCN _gfx_asm_hline, < < _int, x>, < _int, y>, < _int, n_pels>, < _int, color>, <_int, n_rows> >;
AUTO < <_int, start_si>, <_int, start_di>, <_int, write_row>, <_int, next_row>, <_int, last_row>, <_int _386_scrn_offset> >
PROLOGUE <SI, DI, ES>;

IFDEF TURBO_PASCAL	    ; initialize TURBO PASCAL jump table
       .if  SetAsmHlineJmpTable EQ 1, then_goto <short EOTP9>
       .smov	SetAsmHlineJmpTable, 1
	lea	bx, _asm_hline_jmp_table
	mov	word ptr[bx],   offset CS_LBL:$MED_RES_FASTLINE
	mov	word ptr[bx+2], offset CS_LBL:D1
	mov	word ptr[bx+4], offset CS_LBL:D0
EOTP9:
ENDIF
	mov	cx, x
	mov	ax, y
	mov	bl, FCN_ASM_HLINE
       .call	_0xy_to_ram
	cld
       .if	bl NE 3*INT_SZ, then_goto <short D0A>
	jmp	M256
D0A:	xchg	di, si
	mov	cx, n_pels
       .if	XOR_PEL bit_is_off_in <_gfx .color_flags>, then_goto <short D00>
	or	dl, _XOR_PELS
D00:   .if	n_rows EQ 1, then_goto <short START_DRAW>

	mov	start_si, si
	mov	start_di, di
	mov	ax, 2000H
       .if	bx LT 2*INT_SZ, then_goto <short D01>
       .smov	ax, <_gfx .bytes_per_row>
D01:	mov	next_row, ax
	mov	ax, DS_LBL:_asm_hline_jmp_table[bx]
	mov	write_row, ax
       .smov	ax, <_gfx .last_video_row>
	mov	last_row, ax

START_DRAW:
	jmp	word ptr DS_LBL:_asm_hline_jmp_table[bx]

D0:	or	dl, 2			; mark as enhanced resolution card
	mov	word ptr last_row, -1

D1:	mov	bx, color
       .smov	dh, <_0hi_res_color_mask [bx]>
	mov	bx, si
	and	bx, 7
       .smov	ah, <_lbitmask [bx]>
       .smov	es, <_gfx .screen_base>

D11:   .if	E_RES_CARD bit_is_off_in dl, then_goto <short D2>

	push	dx			    ; set partial for EGA card
	mov	dx, GRAPH_ADDR+1
	mov	al, ah
	out	dx, al
	pop	dx

	mov	al, color
	mov	ah, es:[di]		  ; prime the latches
	stosb
	jmp	short D3

D2:	mov	al, dh			; set partial for HI RES
	and	al, ah

       .if	_XOR_PELS bit_is_off_in dl, then_goto <short D21>
	xor	es:[di], al
	jmp	short D22

D21:	not	ah
	and	es:[di], ah
	or	es:[di], al

D22:	inc	di
	mov	al, dh

D3:    .if	_2ND_PASS bit_is_on_in dl, then_goto <short DDONE>
	add	cx, bx
	sub	cx, 8
	jle	short DDONE
       .if	cx LT 8, then_goto <short D5>
       .if	E_RES_CARD bit_is_off_in dl, then_goto <short D4>
	or	bx, bx
	jz	short D4
	xor	bx, bx
	mov	ah, 0FFH
	jmp	D11

D4:	mov	bx, cx
       .shr	cx, 3
	jz	short D43

       .if	_XOR_PELS bit_is_off_in dl, then_goto <short D422>
       .if	E_RES_CARD bit_is_off_in dl, then_goto <short D421>
	mov	ah, al

D420:	mov	al, ah			; xor EGA
	xchg	es:[di], al
	inc	di

	loop	D420
	jmp	short D43

D421:	xor	es:[di], al		  ; xor monochrome
	inc	di
	loop	D421
	jmp	short D43

D422:	rep	stosb			; blast out the color

D43:	mov	cx, bx

D5:	mov	bx, cx
	and	bx, 7
	jz	short DDONE
	or	dl, _2ND_PASS
       .smov	ah, <_rbitmask [bx]>
       .lsmov	es, <_gfx .screen_base>
	jmp	D11

DDONE:	and	dl, NOT _2ND_PASS		; turn off 2nd Pass bit
	jmp	MDONE

$MED_RES_FASTLINE:
	mov	bx, color
	and	bx, 3
       .smov	dh, <_0med_res_color_mask [bx]>
	mov	bx, si
	and	bx, 3
	shl	bx, 1
       .smov	ah, <_lbitmask [bx]>
	shr	bx, 1

	mov	al, dh
	and	al, ah
	not	ah
       .smov	es, <_gfx .screen_base>
       .if	_XOR_PELS bit_is_off_in dl, then_goto <short M00>
	xor	es:[di], al
	jmp	short M0

M00:	and	es:[di], ah
	or	es:[di], al

M0:	inc	di

	add	cx, bx
	sub	cx, 4
	jle	short MDONE

	mov	bx, cx
       .shr	cx, 2
	jz	short M2
	mov	al, dh
	shr	cx, 1
	jnc	short M1
       .if	_XOR_PELS bit_is_off_in dl, then_goto <short M01>
	xor	es:[di], al
	inc	di
	jmp	short M02
M01:	stosb
M02:	jcxz	short M2

M1:	mov	ah, dh

       .if	_XOR_PELS bit_is_off_in dl, then_goto <short M11>
M10:	mov	al, ah
	xor	es:[di], ax
	add	di, 2
	loop	M10
	jmp	short M2

M11:	rep	stosw

M2:	and	bx, 3
	jz	short MDONE
	shl	bx, 1
       .smov	ah, <_rbitmask [bx]>
       .lsmov	es, <_gfx .screen_base>
	mov	al, dh
	and	al, ah
	not	ah

       .if	_XOR_PELS bit_is_off_in dl, then_goto <short M21>
	xor	es:[di], al
	jmp	short MDONE

M21:	and	es:[di], ah
	or	es:[di], al

MDONE:	dec	word ptr n_rows
	jz	short MD2
	mov	di, start_di
	add	di, next_row
	jc	short MD10
       .if	last_row AB di, then_goto <short MD1>
	sub	di, last_row
MD1:	mov	start_di, di
	mov	si, start_si
	mov	cx, n_pels
	jmp	word ptr write_row
MD10:  .call	_ESnext_256_page
	jmp	short MD1
MD2:	jmp	MMDONE

M256:	mov	al, color
	mov	ah, al
       .smov	dx, <_gfx .bytes_per_row>
	mov	next_row, dx
       .smov	bx, <_gfx .color_flags>
       .smov	es, <_gfx .screen_base>
	mov	dx, offset CS_LBL:M256F
       .if	XOR_PEL bit_is_off_in bx, then_goto <short M256K>
	mov	dx, offset CS_LBL:M256C
	jmp	short M256K

M256C:	shr	cx, 1
	jnc	short M256D0
	xor	es:[di], al
	inc	di
M256D0:	jcxz	short M256G
M256D:	xor	es:[di], ax
	add	di, 2
	loop	M256D
	jmp	short M256G

M256F:	shr	cx, 1
rep	stosw
	jnc	short M256G
	stosb

M256G:	mov	cx, bx
	jcxz	short M256_NEXTLINE
	xor	bx, bx
       .call	_ESnext_256_page
	jmp	dx

M256_NEXTLINE:
	dec	word ptr n_rows
	jz	short MMDONE
	dec	di
       .if	di BE si, then_goto <short M256K>
       .call	_ESnext_256_page
M256K:	mov	di, si
	add	si, next_row
M256L:	mov	cx, n_pels
	mov	bx, cx
	add	bx, di
	jc	short M256M
	xor	bx, bx
	jmp	dx
M256M:	sub	cx, bx
	jmp	dx

MMDONE:

END_FCN;


;/*~ XINTCOOR.ASM */

	; _gfx_xlat_int_coor takes a value mutiplies it by mul_val, divides
	; the result with div_val, rounds to the nearer whole # and returns.

EXTERN _INT <NEAR _gfx_truncate_val>

START_FCN _gfx_xlat_int_coor < <_INT, val>, <_INT mul_val>, <_INT, div_val> >
PROLOGUE

	mov	ax, val	    ; load value to be scaled
	mov	bx, div_val
       .if	bx EQ mul_val, then_goto <short VBYE>
	imul	word ptr mul_val   ; first multiply
	idiv	bx		    ; now divide
       .if	_gfx_truncate_val NE 0, then_goto <short VBYE>
	shl	dx, 1		    ; get ready to round
	jnc	short XX0
	dec	dx		    ; round a negative number
	add	bx, dx	    ; by using negative remainder in dx
	adc	ax, -1
	jmp	short VBYE
XX0:	inc	dx		    ; round a positive number
	sub	bx, dx	    ; by using positive remainder in dx
	adc	ax, 0
VBYE:
END_FCN


;/*~ REFSHVID.ASM */

START_FCN _gfx_off_video_refresh
	mov	cl, 0
	jmp	short RV0
END_FCN NO_RET

START_FCN _gfx_on_video_refresh
	mov	cl, 1

RV0:	mov	dx, 03DAH
RV1:	in	al, dx
	test	al, 8
	jz	short RV1

	mov	al, cl
	mov	ah, 12H
	mov	bl, 36H
	int	10H

END_FCN


;/*~ EGA_BUF.ASM */


START_FCN StartVertRetrace
END_FCN NO_RET

START_FCN _gfx_start_vert_retrace
	mov	dx, 3DAH
P12:	in	al, dx
	test	al, 8
	jnz	short P12

P13:	in	al, dx
	test	al, 8
	jz	short P13
END_FCN


;
;    puts the value passed in the starting address register -- EGA.

START_FCN _gfx_set_ega_video_addr < <_INT, new_address> >
PROLOGUE
				; wait for vertical retrace
	call	_gfx_start_vert_retrace

; change starting address
	mov	cx, new_address
	mov	dx, 3d4h
	mov	al, 0ch
	out	dx, al
	mov	al, ch		; the high address byte
	inc	dx
	out	dx, al
	dec	dx

	mov	al, 0dh 	 ; the low address byte
	out	dx, al
	inc	dx
	mov	al, cl
	out	dx, al

	sti			; enable interrupts

END_FCN

START_FCN _gfx_copy_video_page < <_INT scrn_base>, <_INT from>, <_INT to>, <_INT pg_size> >
PROLOGUE <SI, DI, ES, DS>

	cld
	mov	cx, pg_size
	mov	ax, from
       .if	ax EQ to, then_goto <short S00>
	mul	cx
	mov	si, ax
	mov	ax, to
	mul	cx
	mov	di, ax
	mov	ax, scrn_base
	mov	ds, ax
	mov	es, ax
rep	movsb

S00:

END_FCN


;/*~ _LO_OVAL.ASM */

IFNDEF ASSEMBLE_WHOLE_FILE
EXTERN FCN <NEAR _0xy_to_ram>
EXTERN FCN <NEAR _ESnext_256_page>
EXTERN FCN <NEAR _ESnew_256_page>
EXTERN CHAR < <NEAR _0med_res_color_mask>, <NEAR _0hi_res_color_mask> >;
EXTERN CHAR < <NEAR _0med_res_pel_mask>, <NEAR _0hi_res_pel_mask> >;
EXTERN CHAR < <NEAR $256_page_n> >
ENDIF

_MIN_X	equ 0
_MIN_Y	equ 1 * INT_SZ
_MAX_X	equ 2 * INT_SZ
_MAX_Y	equ 3 * INT_SZ

COOR_SZ equ 4 * INT_SZ


START_FCN _gfx_check_pix < <_int _dx>, <_int dy>, <_int quad_mask>, <DATA_PTR box_ptr>, <_int inv_quad>, <_int clip_quad>, <DATA_PTR clip_view> >
PROLOGUE <SI, DI, DS>

       .lds	bx, box_ptr
	mov	dx, _dx
	mov	si, dy
	mov	cl, quad_mask
	mov	di, 2

BX00:	mov	ch, 1
	xor	ax, ax
	jmp	short BX2

BX0:   .if	dx LT [bx+_MIN_X] then_goto <short BX1>
       .if	dx GT [bx+_MAX_X] then_goto <short BX1>
       .if	si LT [bx+_MIN_Y] then_goto <short BX1>
       .if	si GT [bx+_MAX_Y] then_goto <short BX1>
	or	al, ch

BX1:	add	bx, COOR_SZ
	shl	ch, 1
BX2:	shr	cl, 1
	jc	short BX0
	jnz	short BX1

	dec	di
	jz	short BX_BYE
	xor	al, inv_quad

       .if	clip_quad EQ 0, then_goto <short BX_BYE>
       .lds	bx, clip_view
	mov	cl, al
	jmp	BX00

BX_BYE:

END_FCN


START_FCN _gfx_quick_4_pel < < _int, x>, < _int, y>, <_int, delta_x>, <_int, delta_y>, < _int, color> >;
PROLOGUE <SI, DI, ES>
	mov	cx, 0FH
	mov	ax, x
       .smov	bx, <_gfx .min_x>
       .smov	dx, <_gfx .max_x>
       .if	ax GT dx, then_goto <short ZMDROP>
       .if	ax LT bx, then_goto <short ZM1>
	and	cl, 0111B
ZM1:	add	ax, delta_x
       .if	ax LT bx, then_goto <short ZMDROP>
       .if	ax GT dx, then_goto <short ZM2>
	and	cl, 1011B

ZM2:   .smov	bx, <_gfx .min_y>
       .smov	dx, <_gfx .max_y>
	mov	ax, y
       .if	ax GT dx, then_goto <short ZMDROP>
       .if	ax LT bx, then_goto <short ZM3>
	and	cl, 1101B
ZM3:	add	ax, delta_y
       .if	ax LT bx, then_goto <short ZMDROP>
       .if	ax GT dx, then_goto <short ZM4>
	and	cl, 1110B
ZM4:	jcxz	short X40
	mov	ax, cx
	jmp	short ZMBYE

ZMDROP: mov	ax, 0FH

ZMBYE:

END_FCN


TRANSPARENT EQU 8000H

START_FCN _gfx_4_pel, < < _int, x>, < _int, y>, <_int, delta_x>, <_int, delta_y>, < _int, color> >;
AUTO < <_INT n_bytes_in_row> >
PROLOGUE <SI, DI, ES>;

X40:   .if	TRANSPARENT BIT_IS_ON_IN color, then_goto <short XXIT>
	mov	cx, x
	mov	ax, y
	mov	bl, FCN_4_PEL
       .call	_0xy_to_ram
       .if	bx LT 2*INT_SZ, then_goto <short Y00>
	jmp	EY0
XXIT:	jmp	YXIT

Y00:	mov	ax, delta_y
	mov	cx, ax
       .if	<_gfx .gfx_mode> NE 6, then_goto <short YY0>

       .shr	ax, 2				; Hercules or AT&T Card
       .smov	ah, <CHAR _gfx .bytes_per_row>
	mul	ah
	mov	dx, ax
	add	dx, si
	and	cx, 3
	jz	short Y03
	add	dx, 2000H
	dec	cx
	jz	short Y0A
	add	dx, 2000H
	dec	cx
	jz	short Y0A
	add	dx, 2000H
Y0A:   .if	dx BE 8000H, then_goto <short Y03>
       .ssub	dx, <_gfx .last_video_row>

YY0:	jcxz	short Y03		      ; CGA Med & Hi res
	shr	ax, 1
       .smov	ah, <CHAR _gfx .bytes_per_row>
	mul	ah
	mov	dx, ax
	add	dx, si
	shr	cx, 1
	jnc	short Y03
	add	dx, 2000H
       .if	dx BE 4000H, then_goto <short Y03>
	sub	dx, 4000H - 80

Y03:	mov	cl, 2
       .if	bx EQ 0, then_goto <short YY>

HY:	mov	ch, 1
	mov	bx, di
HY1:	and	bx, 7
	mov	di, bx
       .smov	ah, <_0hi_res_pel_mask [bx]>	   ; HIGH RES
	mov	bl, color
       .smov	al, <_0hi_res_color_mask [bx]>
	jmp	short WRTY

YY:	mov	ch, 0			; MEDIUM RES
	mov	bx, di
YY1:	and	bx, 3
	mov	di, bx
       .smov	ah, <_0med_res_pel_mask [bx]>
	mov	bl, color
       .smov	al, <_0med_res_color_mask [bx]>

WRTY:	and	al, ah				    ; SET CGA CARD PEL
	not	ah
       .if	XOR_PEL bit_is_on_in <_gfx .color_flags>, then_goto <short XORY>
       .smov	es, <_gfx .screen_base>
	and	es:[si], ah
	or	es:[si], al
       .if	delta_y EQ 0 then_goto <short XY3>
	xchg	si, dx
	and	es:[si], ah
	or	es:[si], al
	xchg	si, dx
WY3:	jmp	short XY3


XORY:  .smov	es, <_gfx .screen_base>
	xor	es:[si], al
       .if	delta_y EQ 0 then_goto <short XY3>
	xchg	si, dx
	xor	es:[si], al
	xchg	si, dx

XY3:	dec	cl
	jz	short JXIT
       .if	delta_x EQ 0, then_goto <short JXIT>
	mov	ax, di
	add	ax, delta_x
	mov	bx, ax
       .shr	ax, 2
	or	ch, ch
	jz	short YY3
	shr	ax, 1
	add	si, ax
	add	dx, ax
	jmp	HY1
YY3:	add	si, ax
	add	dx, ax
	jmp	YY1
JXIT:	jmp	YXIT
EY256:	jmp	Y256

EY0:   .if	bx EQ 3*INT_SZ, then_goto <short EY256>
       .if	<_gfx .max_y> GT 600, then_goto	<short EY0A>
	jmp	EOY0
EY0A:  .smov	ax, <_gfx .bytes_per_row>
	mov	n_bytes_in_row, ax
	xor	dx, dx
	mov	bx, di
	and	bx, 7
       .smov	dh, <_0hi_res_pel_mask [bx]>
       .if	delta_x EQ 0, then_goto <short EY1>
	mov	ax, di
	add	di, delta_x
	mov	bx, di
	and	bx, 7
       .smov	dl, <_0hi_res_pel_mask [bx]>
       .shr	di, 3
       .shr	ax, 3
	sub	di, ax
	mov	delta_x, di

EY1:	mov	bx, dx
	mov	ch, color
       .smov	es, <_gfx .screen_base>
	mov	dx, GRAPH_ADDR		    ; ENHANCED RES over 800x600
	mov	al, G_BITMASK
	out	dx, al

EY2:	mov	dx, GRAPH_ADDR+1
	mov	al, bh
	out	dx, al
	mov	al, ch
	xchg	al, es:[si]
       .if	bl EQ 0, then_goto <short EY_NEXT_PAIR>
	mov	al, bl
	out	dx, al
	add	si, di
	mov	al, ch
	xchg	al, es:[si]
	sub	si, di
EY_NEXT_PAIR:
       .if	delta_y EQ 0, then_goto <short EYBYE>
	mov	ax, delta_y
	mov	word ptr delta_y, 0
	mov	dx, n_bytes_in_row
	mul	dx
	add	si, ax
	adc	dx, 0
	mov	ax, dx
	jz	short EY2
	add	al, DS_LBL:$256_page_n
       .call	_ESnew_256_page
	jmp	short EY2
EYBYE:	jmp	YXIT


EOY0:  .smov	ax, <_gfx .bytes_per_row>
	mul	word ptr delta_y
	mov	bx, di
	mov	di, ax
	mov	cl, 2
	mov	ch, color
       .smov	es, <_gfx .screen_base>

	mov	dx, GRAPH_ADDR		    ; ENHANCED RES
	mov	al, G_BITMASK
	out	dx, al
	inc	dx
EOY2:	and	bx, 7
       .smov	al, <_0hi_res_pel_mask [bx]>
       .lsmov	es, <_gfx .screen_base>
	out	dx, al
	mov	al, ch
	xchg	al, es:[si]
	or	di, di
	jz	short EOY3
	add	si, di
	mov	al, ch
	xchg	al, es:[si]
EOY3:	dec	cl
	jz	short EYBYE

	mov	ax, delta_x
       .if	ax EQ 0, then_goto <short EYBYE>
	add	bx, ax
	mov	ax, bx
       .shr	ax, 3
	sub	si, di
	add	si, ax
	jmp	short EOY2


Y256:	mov	cx, delta_y
	mov	di, delta_x
       .smov	dx, <_gfx .bytes_per_row>
       .smov	bx, <_gfx .color_flags>
       .smov	es, <_gfx .screen_base>
	mov	al, color
       .if	XOR_PEL bit_is_off_in bx, then_goto <short YM256>

YX256:	xor	es:[si], al
       .if	di EQ 0, then_goto <short Y256_NEXT_PAIR>
	add	si, di
	jc	short YX1B
YX1R:	xor	es:[si], al
	jmp	short Y256_NEXT_PAIR

YM256:	mov	es:[si], al
       .if	di EQ 0, then_goto <short Y256_NEXT_PAIR>
	add	si, di
	jc	short YM1B
YM1R:	mov	es:[si], al

Y256_NEXT_PAIR:
	jcxz	short YXIT
	push	ax
	mov	ax, y
	add	ax, cx
	xor	cx, cx
	mul	dx
	add	ax, x
	adc	dx, 0
       .sadd	ax, <_gfx .screen_offset>
	adc	dx, 0
	mov	si, ax
	mov	ax, dx
       .call	_ESnew_256_page
	pop	ax
       .if	XOR_PEL bit_is_off_in bx, then_goto <short YM256>
	jmp	YX256

YX1B:  .call	_ESnext_256_page
	jmp	YX1R
YM1B:  .call	_ESnext_256_page
	jmp	YM1R

YXIT:	xor	ax, ax

END_FCN;


;/*~ LO_QSORT.ASM */

START_FCN <NEAR STATIC $lo_qsort>

	mov	ax, di		; di == r, j
	sub	ax, si		; si == l, i	(r > l)
	xor	dx, dx
	mov	bx, cx		; cx = struct_size
	shl	bx, 1			; pivot (x) = l + ((r-l)/2);
	div	bx
	mul	cx
	mov	bx, ax
	add	bx, si

	mov	ax, [bx+INT_SZ]	; ax = x.y
	mov	bx, [bx]		; bx = x.x

	mov	dx, si		; save for later
	push	di
	jmp	short A0

A00:	add	si, cx
A0:	cmp	[si+INT_SZ], ax	; while (i < x) i++;
	jl	short A00
	jg	short A1
	cmp	[si], bx
	jl	short A00
	jmp	short A1

A01:	sub	di, cx
A1:	cmp	ax, [di+INT_SZ]	; while (x < j) j--;
	jl	short A01
	jg	short A2
	cmp	bx, [di]
	jl	short A01

A2:	cmp	si, di
	ja	short A3
	je	short A21

	push	ax
	mov	ax, [si]		; i <--> j (swap)
	xchg	ax, [di]
	mov	[si], ax
	mov	ax, [si+INT_SZ]
	xchg	ax, [di+INT_SZ]
	mov	[si+INT_SZ], ax
       .if	cl EQ INT_SZ*2, then_goto <short A20>
	mov	ax, [si+INT_SZ*2]
	xchg	ax, [di+INT_SZ*2]
	mov	[si+INT_SZ*2], ax
A20:	pop	ax

A21:	add	si, cx		; next element (struct)
       .if	di EQ dx then_goto <short A4>
	sub	di, cx		; previous element (struct)
       .if	si BE di, then_goto <short A0>

A3:    .if	dx AE di, then_goto <short A4>
	push	si
	mov	si, dx
	call	$lo_qsort
	pop	si

A4:	pop	di
       .if	si AE di, then_goto <short ABYE>
	call	$lo_qsort
ABYE:
END_FCN


START_FCN _gfx_qsort < <DATA_PTR base>, <_int n_elem>, <_int elem_sz> >
PROLOGUE <SI, DI, DS>

       .lds	si, base
	mov	ax, n_elem
	dec	ax
	mov	cx, elem_sz
	mul	cx
	mov	di, ax
	add	di, si
	call	$lo_qsort

END_FCN

;/*~ FILL.ASM */

IFNDEF TURBO_PASCAL

START_FCN _gfx_fill < <DATA_PTR tp>, <_int n_bytes>, <_int _c> >
PROLOGUE <DI, ES>

	cld
	mov	al, _c
	mov	ah, al
       .les	di, tp
	mov	cx, n_bytes
	shr	cx, 1
rep	stosw
	jnc	short WZ1
	stosb
WZ1:

END_FCN

ENDIF


;/*~ LOPORTIO.ASM */

START_FCN _gfx_inp < <_INT port_n> >
PROLOGUE
	mov	dx, port_n
	xor	ax, ax
	in	al, dx
END_FCN

START_FCN _gfx_outp < <_INT port_n>, <_INT val> >
PROLOGUE
	mov	dx, port_n
	mov	al, val
	out	dx, al
END_FCN


;/*~ GFX_SEGS.ASM */

START_FCN _gfx_get_ds
	xor	ax, ax
	mov	ax, ds
END_FCN

START_FCN _gfx_set_ds < <_INT _ds_reg> >
PROLOGUE
	mov	ds, _ds_reg
END_FCN

START_FCN _gfx_get_es
	xor	ax, ax
	mov	ax, es
END_FCN

START_FCN _gfx_get_cs
	xor	ax, ax
	mov	ax, cs
END_FCN


;/*~ LOVGAPAL.ASM */

START_FCN _gfx_lo_write_VGA_pal < <_INT first_color>, <_INT _n_colors>, <FAR_PTR pal_buf> >
PROLOGUE <SI, DS>

	cld
	mov	dx, 3C8H
	mov	ax, first_color
	out	dx, al
	.lds	si, pal_buf
	mov	cx, _n_colors
	shl	cx, 1
	add	cx, _n_colors
	mov	dx, 3C4H
	mov	al, 1
	inc	dx
	in	al, dx
	mov	bl, al
	and	al, 1FH
	out	dx, al
	mov	dx, 3C9H

AM1:	lodsb
	out	dx, al
	nop
	loop	AM1

	mov	dx, 3C5H
	mov	al, bl
	out	dx, al
END_FCN


START_FCN _gfx_lo_read_VGA_pal < <_INT first_color>, <_INT _n_colors>, <FAR_PTR pal_buf> >
PROLOGUE <DI, ES>

	cld
	mov	dx, 3C7H
	mov	ax, first_color
	out	dx, al
	add	dx, 2
	.les	di, pal_buf
	mov	cx, _n_colors
	shl	cx, 1
	add	cx, _n_colors

AM2:	in	al, dx
	stosb
	nop
	loop	AM2

END_FCN

END


;/*~ P3MOVE.ASM */

IFDEF USE_386

START_FCN _gfx32_farmove < <_INT src_offset>, <_INT src_seg>, <_INT dest_offset>, <_INT dest_seg>, <_INT n_bytes> >
PROLOGUE <SI, DI, DS>
	cld
	push	es
	lds	esi, src_offset
	les	edi, dest_offset
	mov	ecx, n_bytes
	push	ecx
	shr	ecx, 2
rep	movsd
	pop	ecx
	and	ecx, 3
	jz	short MNB
rep	movsb

MNB:	pop	es

END_FCN

ENDIF


;/*~ IBOX.ASM */

EXTERN FCN _gfx_box
EXTERN FCN <NEAR _gfx_ivec0args>

START_FCN Box
       .set_fcn_vec _gfx_box
	jmp	_gfx_ivec0args
END_FCN NO_RET

EXTERN FCN <NEAR _gfx_ivec1args>

START_FCN BoxTo
       .set_fcn_vec _gfx_box
	mov	bx, INT_CAP
	jmp	_gfx_ivec1args
END_FCN	NO_RET

EXTERN FCN <NEAR _gfx_ivec2args>

START_FCN BoxToRel
       .set_fcn_vec _gfx_box
	jmp	_gfx_ivec2args
END_FCN	NO_RET


;/*~ IOVAL.ASM */

EXTERN FCN _gfx_circle
EXTERN FCN <NEAR _gfx_ivec0args>

START_FCN Circle
       .set_fcn_vec _gfx_circle
	jmp	_gfx_ivec0args
END_FCN NO_RET

EXTERN FCN <NEAR _gfx_ivec1args>

START_FCN CircleRel
       .set_fcn_vec _gfx_circle
	mov	bx, INT_STEP
	jmp	_gfx_ivec1args
END_FCN	NO_RET

EXTERN FCN _gfx_oval_fcn

START_FCN Oval
       .set_fcn_vec _gfx_oval_fcn
	jmp	_gfx_ivec0args
END_FCN NO_RET


START_FCN OvalRel
       .set_fcn_vec _gfx_oval_fcn
	mov	bx, INT_STEP
	jmp	_gfx_ivec1args
END_FCN	NO_RET


;/*~ IOVALARC.ASM */

EXTERN FCN _gfx_circle_arc
EXTERN FCN <NEAR _gfx_ivec0args>

START_FCN CircleArc
       .set_fcn_vec _gfx_circle_arc
	jmp	_gfx_ivec0args
END_FCN NO_RET

EXTERN FCN <NEAR _gfx_ivec1args>

START_FCN CircleArcRel
       .set_fcn_vec _gfx_circle_arc
	mov	bx, INT_STEP
	jmp	_gfx_ivec1args
END_FCN	NO_RET

EXTERN FCN _gfx_oval_arc

START_FCN OvalArc
       .set_fcn_vec _gfx_oval_arc
	jmp	_gfx_ivec0args
END_FCN NO_RET

START_FCN OvalArcRel
       .set_fcn_vec _gfx_oval_arc
	mov	bx, INT_STEP
	jmp	_gfx_ivec1args
END_FCN	NO_RET


;/*~ IDRLINE.ASM */

EXTERN FCN _gfx_draw_line
EXTERN FCN <NEAR _gfx_ivec0args>

START_FCN DrawLine
       .set_fcn_vec _gfx_draw_line
	jmp	_gfx_ivec0args
END_FCN NO_RET

EXTERN FCN <NEAR _gfx_ivec1args>

START_FCN DrawLineTo
       .set_fcn_vec _gfx_draw_line
	mov	bx, INT_CAP
	jmp	_gfx_ivec1args
END_FCN	NO_RET

EXTERN FCN <NEAR _gfx_ivec2args>

START_FCN DrawLineToRel
       .set_fcn_vec _gfx_draw_line
	jmp	_gfx_ivec2args
END_FCN	NO_RET

;/*~ IFILL.ASM */

EXTERN FCN _gfx_fastfill
EXTERN FCN <NEAR _gfx_ivec0args>

START_FCN Fastfill
       .set_fcn_vec _gfx_fastfill
	jmp	_gfx_ivec0args
END_FCN NO_RET

EXTERN FCN <NEAR _gfx_ivec1args>

START_FCN FastfillRel
       .set_fcn_vec _gfx_fastfill
	mov	bx, INT_STEP
	jmp	_gfx_ivec1args
END_FCN	NO_RET


;/*~ IGETFPIC.ASM */

EXTERN FCN _gfx_get_fpic
EXTERN FCN <NEAR _gfx_ivec0args>

START_FCN GetFpic
       .set_fcn_vec _gfx_get_fpic
	jmp	_gfx_ivec0args
END_FCN NO_RET

EXTERN FCN <NEAR _gfx_ivec1args>

START_FCN GetFpicTo
       .set_fcn_vec _gfx_get_fpic
	mov	bx, INT_CAP
	jmp	_gfx_ivec1args
END_FCN	NO_RET

EXTERN FCN <NEAR _gfx_ivec2args>

START_FCN GetFpicToRel
       .set_fcn_vec _gfx_get_fpic
	jmp	_gfx_ivec2args
END_FCN	NO_RET


;/*~ IGETPCX.ASM */

EXTERN FCN _gfx_get_PCX_file
EXTERN FCN <NEAR _gfx_ivec0args>

START_FCN GetPCXFile
       .set_fcn_vec _gfx_get_PCX_file
	jmp	_gfx_ivec0args
END_FCN NO_RET

EXTERN FCN <NEAR _gfx_ivec1args>

START_FCN GetPCXFileTo
       .set_fcn_vec _gfx_get_PCX_file
	mov	bx, INT_CAP
	jmp	_gfx_ivec1args
END_FCN	NO_RET

EXTERN FCN <NEAR _gfx_ivec2args>

START_FCN GetPCXFileToRel
       .set_fcn_vec _gfx_get_PCX_file
	jmp	_gfx_ivec2args
END_FCN	NO_RET


;/*~ IGETPIC.ASM */

EXTERN FCN _gfx_get_pic
EXTERN FCN <NEAR _gfx_ivec0args>

START_FCN GetPic
       .set_fcn_vec _gfx_get_pic
	jmp	_gfx_ivec0args
END_FCN NO_RET

EXTERN FCN <NEAR _gfx_ivec1args>

START_FCN GetPicTo
       .set_fcn_vec _gfx_get_pic
	mov	bx, INT_CAP
	jmp	_gfx_ivec1args
END_FCN	NO_RET

EXTERN FCN <NEAR _gfx_ivec2args>

START_FCN GetPicToRel
       .set_fcn_vec _gfx_get_pic
	jmp	_gfx_ivec2args
END_FCN	NO_RET


;/*~ IPAINT.ASM */

EXTERN FCN _gfx_paint
EXTERN FCN <NEAR _gfx_ivec0args>

START_FCN Paint
       .set_fcn_vec _gfx_paint
	jmp	_gfx_ivec0args
END_FCN NO_RET

EXTERN FCN <NEAR _gfx_ivec1args>

START_FCN PaintRel
       .set_fcn_vec _gfx_paint
	mov	bx, INT_STEP
	jmp	_gfx_ivec1args
END_FCN	NO_RET


;/*~ IPISLICE.ASM */

EXTERN FCN _gfx_pie_slice
EXTERN FCN <NEAR _gfx_ivec0args>

START_FCN PieSlice
       .set_fcn_vec _gfx_pie_slice
	jmp	_gfx_ivec0args
END_FCN NO_RET

EXTERN FCN <NEAR _gfx_ivec1args>

START_FCN PieSliceRel
       .set_fcn_vec _gfx_pie_slice
	mov	bx, INT_STEP
	jmp	_gfx_ivec1args
END_FCN	NO_RET


;/*~ IOVLPISL.ASM */

EXTERN FCN _gfx_oval_pie_slice
EXTERN FCN <NEAR _gfx_ivec0args>

START_FCN OvalPieSlice
       .set_fcn_vec _gfx_oval_pie_slice
	jmp	_gfx_ivec0args
END_FCN NO_RET

EXTERN FCN <NEAR _gfx_ivec1args>

START_FCN OvalPieSliceRel
       .set_fcn_vec _gfx_oval_pie_slice
	mov	bx, INT_STEP
	jmp	_gfx_ivec1args
END_FCN	NO_RET


;/*~ IPOINT.ASM */

EXTERN FCN _gfx_point
EXTERN FCN <NEAR _gfx_ivec0args>

START_FCN Point
       .set_fcn_vec _gfx_point
	jmp	_gfx_ivec0args
END_FCN NO_RET

EXTERN FCN <NEAR _gfx_ivec1args>

START_FCN PointRel
       .set_fcn_vec _gfx_point
	mov	bx, INT_STEP
	jmp	_gfx_ivec1args
END_FCN	NO_RET



;/*~ IPLYLINE.ASM */

EXTERN FCN _gfx_poly_line
EXTERN FCN <NEAR _gfx_ivec0args>

START_FCN PolyLine
       .set_fcn_vec _gfx_poly_line
	jmp	_gfx_ivec0args
END_FCN NO_RET

EXTERN FCN <NEAR _gfx_ivec1args>

START_FCN PolyLineRel
       .set_fcn_vec _gfx_poly_line
	mov	bx, INT_STEP
	jmp	_gfx_ivec1args
END_FCN NO_RET


;/*~ IPLYPNT.ASM */

EXTERN FCN _gfx_poly_point
EXTERN FCN <NEAR _gfx_ivec1args>
EXTERN FCN <NEAR _gfx_ivec0args>

START_FCN PolyPoint
       .set_fcn_vec _gfx_poly_point
	jmp	_gfx_ivec0args
END_FCN NO_RET


START_FCN PolyPointRel
       .set_fcn_vec _gfx_poly_point
	mov	bx, INT_STEP
	jmp	_gfx_ivec1args
END_FCN NO_RET


;/*~ IPSET.ASM */

EXTERN FCN _gfx_pset
EXTERN FCN <NEAR _gfx_ivec0args>

START_FCN Pset
       .set_fcn_vec _gfx_pset
	jmp	_gfx_ivec0args
END_FCN NO_RET

EXTERN FCN <NEAR _gfx_ivec1args>

START_FCN PsetRel
       .set_fcn_vec _gfx_pset
	mov	bx, INT_STEP
	jmp	_gfx_ivec1args
END_FCN	NO_RET


;/*~ IPUTFPIC.ASM */

EXTERN FCN _gfx_put_fpic
EXTERN FCN <NEAR _gfx_ivec0args>

START_FCN PutFpic
       .set_fcn_vec _gfx_put_fpic
	jmp	_gfx_ivec0args
END_FCN NO_RET

EXTERN FCN <NEAR _gfx_ivec1args>

START_FCN PutFpicRel
       .set_fcn_vec _gfx_put_fpic
	mov	bx, INT_STEP
	jmp	_gfx_ivec1args
END_FCN	NO_RET


;/*~ IPUTPIC.ASM */

EXTERN FCN _gfx_put_pic
EXTERN FCN <NEAR _gfx_ivec0args>

START_FCN PutPic
       .set_fcn_vec _gfx_put_pic
	jmp	_gfx_ivec0args
END_FCN NO_RET

EXTERN FCN <NEAR _gfx_ivec1args>

START_FCN PutPicRel
       .set_fcn_vec _gfx_put_pic
	mov	bx, INT_STEP
	jmp	_gfx_ivec1args
END_FCN	NO_RET

;/*~ IPUTPCX.ASM */

EXTERN FCN _gfx_put_PCX_file
EXTERN FCN <NEAR _gfx_ivec0args>

START_FCN PutPCXFile
       .set_fcn_vec _gfx_put_PCX_file
	jmp	_gfx_ivec0args
END_FCN NO_RET

EXTERN FCN <NEAR _gfx_ivec1args>

START_FCN PutPcxFileRel
       .set_fcn_vec _gfx_put_PCX_file
	mov	bx, INT_STEP
	jmp	_gfx_ivec1args
END_FCN	NO_RET


;/*~ IPUTIMGE.ASM */

EXTERN FCN _gfx_put_image
EXTERN FCN <NEAR _gfx_ivec0args>

START_FCN PutImage
       .set_fcn_vec _gfx_put_image
	jmp	_gfx_ivec0args
END_FCN NO_RET

EXTERN FCN <NEAR _gfx_ivec1args>

START_FCN PutImageRel
       .set_fcn_vec _gfx_put_image
	mov	bx, INT_STEP
	jmp	_gfx_ivec1args
END_FCN	NO_RET



;/*~ IPRNFONT.ASM */

EXTERN FCN _gfx_print_font
EXTERN FCN <NEAR _gfx_ivec0args>

START_FCN PrintFont
       .set_fcn_vec _gfx_print_font
	jmp	_gfx_ivec0args
END_FCN NO_RET

EXTERN FCN <NEAR _gfx_ivec1args>

START_FCN PrintFontRel
       .set_fcn_vec _gfx_print_font
	mov	bx, INT_STEP
	jmp	_gfx_ivec1args
END_FCN	NO_RET


;/*~ ISETBOX.ASM */

EXTERN FCN _gfx_set_box
EXTERN FCN <NEAR _gfx_ivec0args>

START_FCN SetBox
       .set_fcn_vec _gfx_set_box
	jmp	_gfx_ivec0args
END_FCN NO_RET

EXTERN FCN <NEAR _gfx_ivec1args>

START_FCN SetBoxRel
       .set_fcn_vec _gfx_set_box
	mov	bx, INT_STEP
	jmp	_gfx_ivec1args
END_FCN	NO_RET


;/*~ IPRNAREA.ASM */

EXTERN FCN _gfx_print_area
EXTERN FCN <NEAR _gfx_ivec0args>

START_FCN PrintArea
       .set_fcn_vec _gfx_print_area
	jmp	_gfx_ivec0args
END_FCN NO_RET

EXTERN FCN <NEAR _gfx_ivec1args>

START_FCN PrintAreaTo
       .set_fcn_vec _gfx_print_area
	mov	bx, INT_CAP
	jmp	_gfx_ivec1args
END_FCN	NO_RET

EXTERN FCN <NEAR _gfx_ivec2args>

START_FCN PrintAreaToRel
       .set_fcn_vec _gfx_print_area
	jmp	_gfx_ivec2args
END_FCN	NO_RET



;/*~ IVECPM.ASM */

STATIC _INT _gfx_vec_ptr_offset <0>;
STATIC _INT _gfx_vec_ptr_segment <0>;
STATIC _INT _gfx_save_vec <0, 0>

START_FCN  <NEAR _gfx_ivec0args>
       .if	 <_gfx .xlat_scale> EQ FLOAT_SCALE, then_goto <short _gfx_ivec_err_exit>
       .jmp_cfunc
END_FCN NO_RET


START_FCN  <NEAR _gfx_ivec1args>
       .if	 <_gfx .xlat_scale> EQ FLOAT_SCALE, then_goto <short _gfx_ivec_err_exit>
       .save_ret_vec
	push	bx
       .call_cfunc
	add	sp, INT_SZ
       .restore_ret_vec
       .ret
END_FCN NO_RET


START_FCN  <NEAR _gfx_ivec2args>
       .if	 <_gfx .xlat_scale> EQ FLOAT_SCALE, then_goto <short _gfx_ivec_err_exit>
       .save_ret_vec
	mov	ax, INT_STEP
	push	ax
	mov	ax, INT_CAP
	push	ax
       .call_cfunc
	add	sp, 4
       .restore_ret_vec
       .ret
END_FCN NO_RET

START_CODE
_gfx_ivec_err_exit:
       .smov	 <_gfx .err_number>, -1
	xor	ax, ax
       .ret
END_CODE



; ********* HERE IS THE FLOATING POINT FRONT END ***********


;/*^ GFXF_ASM.ASM */

;/*~ WRTCHAR.ASM */

IFNDEF ASSEMBLE_WHOLE_FILE
EXTERN FCN <NEAR _DSnext_256_page>;
EXTERN FCN <NEAR _DSprev_256_page>;
EXTERN FCN <NEAR _ESnext_256_page>;
EXTERN FCN <NEAR _ESprev_256_page>;
EXTERN FCN  <NEAR _0xy_to_ram>;
IF (.$$DATA_SIZE NE ._LARGE_DATA)
EXTERN CHAR < <NEAR _lbitmask>, <NEAR _rbitmask> >;
EXTERN _INT <NEAR _gfx>
ELSE
EXTERN CHAR <_lbitmask, _rbitmask>;
EXTERN _INT <_gfx>
ENDIF
ENDIF

EXTERN _INT _gfx_wrt_bkgnd_color
EXTERN _INT _gfx_fast_char

START_FCN _gfx_write_char < <_int start_of_scrn_row>, <_int x>, <_int color>, <_int char_bit_offset>, <_int char_width>, <_int n_rows>, <_int form_width>, <FAR_PTR char_bitmap> >
AUTO <<_int,next_scrn_row>,<_int,next_font_row>,<_int,rmask>,<_int,lmask>,<_int,last_row>,<_int,inccgan>,<_int,wcgabp>,<_int,ofs_npel>,<_int,npg>,<_int,_mode>,<_int,xor_c>,<_int,lvr>,<_int bc>>
PROLOGUE <SI, DI, ES, DS>

	cld
       .if	<_gfx .gfx_mode> NE 8, then_goto <short S00>
	jmp	XW256

S00:   .smov	ax, <_gfx .color_flags>
	mov	xor_c, ax
       .smov	ax, <_gfx .bios_mode>
	mov	_mode, ax
       .smov	ax, <_gfx .last_video_row>
	mov	lvr, ax
	mov	si, char_bit_offset	; bit offset of char
	mov	dx, char_width		; bit offset of next char

	mov	di, start_of_scrn_row
	mov	ax, x			; calculate byte and pel
	mov	cx, ax			; offset for the char
	and	cx, 7
       .shr	ax, 3
	add	di, ax
					; check for fast char write
	mov	bx, cx
	add	bx, dx
       .if	_gfx_fast_char EQ 0, then_goto <short S01>
	jmp	FAST_CHAR
S01:
		; get the bitmasks for the left and right side of the char

	xor	ax, ax
	mov	bx, si
	and	bx, 7
       .smov	al, <_lbitmask .[bx]>
	mov	lmask, ax
	add	bx, dx
	and	bx, 7
       .smov	al, <_lbitmask .[bx]>
	jz	short S20
	not	al
S20:	mov	rmask, ax

	mov	bx, si
	and	bx, 7
	add	bx, dx
	mov	ax, form_width
	dec	bx
       .shr	bx, 3
	jnz	short S30
	mov	dl, rmask
	and	lmask, dl
S30:	sub	ax, bx
	dec	ax
	mov	next_font_row, ax

       .smov	ax, <_gfx .bytes_per_row>
	sub	ax, bx
	dec	ax
	mov	next_scrn_row, ax

	mov	bh, bl

	mov	dx, si
       .shr	si, 3
       .if	<_gfx .bios_mode> GT 10, then_goto <short EGA_CHAR>
	jmp	CGA_CHAR

EGA_CHAR:
       .smov	es, <_gfx .screen_base>
	add	word ptr next_scrn_row, 2
	.lds	ax, char_bitmap
	add	si, ax
	and	dx, 7
	sub	cx, dx

	mov	dx, GRAPH_ADDR
	mov	al, G_BITMASK
	out	dx, al
	mov	dx, GRAPH_ADDR+1

	jge	short ER35
	neg	cx
	dec	di
	jmp	EL36

ER30:	xor	ah, ah
	ror	ax, cl
	or	al, ch
	mov	ch, ah
	jz	short ER32

ER31:	out	dx, al
	mov	al, es:[di]
	mov	al, color
	mov	es:[di], al

ER32:	inc	di
	dec	bl
	jl	short ER33
	lodsb
	mov	ah, ch
	or	ah, al
	jz	short ER32
	or	bl, bl
	jnz	short ER30
	and	al, rmask
	jmp	ER30

ER33:	or	ch, ch
	jz	short ER34
	mov	al, ch
	out	dx, al
	mov	al, es:[di]
	mov	al, color
	mov	es:[di], al

ER34:	dec	word ptr n_rows
	jz	short ELRBYE
	mov	bl, bh
	add	si, next_font_row
	dec	di
	add	di, next_scrn_row
	jc	short ERPG
	dec	di

ER35:	lodsb
	xor	ch, ch
	and	al, lmask
	jz	short ER32
	jmp	ER30
ERPG:  .call	_ESnext_256_page
	dec	di
	jmp	ER35

ELRPG:.call	_DSprev_256_page
	jmp	XWBYE
ELRBYE:.if	di BE start_of_scrn_row, then_goto <short ELRPG>
	jmp	XWBYE

EL30:	xor	ah, ah
	shl	ax, cl
	or	ah, ch
	mov	ch, al
	jz	short EL32

EL31:	mov	al, ah
	out	dx, al
	mov	al, es:[di]
	mov	al, color
	mov	es:[di], al

EL32:	inc	di
	dec	bl
	jl	short EL34
	lodsb
	mov	ah, ch
	or	ah, al
	jz	short EL32
	or	bl, bl
	jnz	short EL30
	and	al, rmask
	jmp	EL30

EL34:	or	ch, ch
	jz	short EL35
	mov	al, ch
	out	dx, al
	mov	al, es:[di]
	mov	al, color
	mov	es:[di], al

EL35:	dec	word ptr n_rows
	jz	short ELRBYE
	mov	bl, bh
	add	si, next_font_row
	dec	di
	add	di, next_scrn_row
	jc	short ELPG
	dec	di
EL36:	lodsb
	and	al, lmask
	shl	al, cl
	mov	ch, al
	jmp	EL32
ELPG:  .call	_ESnext_256_page
	dec	di
	jmp	EL36


CGA_CHAR:
       .smov	es, <_gfx .screen_base>
	mov	ax, 1FFFH
	sub	al, bl
       .if	_mode LT 6, then_goto <short MRES_CHAR>
	mov	next_scrn_row, ax
	mov	word ptr inccgan, 1
	mov	ax, offset CS_LBL:$$wrt_hi_res_bit_pattern
       .if	XOR_PEL bit_is_off_in xor_c, then_goto <short H00>
	mov	ax, offset CS_LBL:$$xor_hi_res_bit_pattern
	jmp	H00

MRES_CHAR:
	dec	ax
	sub	al, bl
	mov	next_scrn_row, ax

	mov	di, start_of_scrn_row
	mov	ax, x
       .shr	ax, 2
	and	al, 0FEH
	add	di, ax

MR0:	mov	word ptr inccgan, 2
	mov	ax, offset CS_LBL:$$wrt_med_res_bit_pattern
       .if	XOR_PEL bit_is_off_in xor_c, then_goto <short H00>
	mov	ax, offset CS_LBL:$$xor_med_res_bit_pattern

H00:	mov	wcgabp, ax
	mov	ax, lvr
	mov	last_row, ax
	.lds	ax, char_bitmap
	add	si, ax
	and	dx, 7
	sub	cx, dx
	mov	dl, color
	jge	short HR35
	neg	cx
	sub	di, inccgan
	jmp	HL36

HR30:	xor	ah, ah
	ror	ax, cl
	or	al, ch
	mov	ch, ah
	jz	short HR31
	call	word ptr wcgabp

HR31:	add	di, inccgan
	dec	bl
	jl	short HR33
	lodsb
	mov	ah, cl
	or	ah, al
	jz	short HR31
	or	bl, bl
	jnz	short HR30
	and	al, rmask
	jmp	HR30

HR33:	or	ch, ch
	jz	short HR34
	mov	al, ch
	call	word ptr wcgabp

HR34:	dec	word ptr n_rows
	jz	short S3BYE
	mov	bl, bh
	add	si, next_font_row
	add	di, next_scrn_row
       .if	di BE last_row, then_goto <short HR35>
	sub	di, last_row

HR35:	lodsb
	xor	ch, ch
	and	al, lmask
	jz	short HR31
	jmp	HR30

HL30:	xor	ah, ah
	shl	ax, cl
	or	ah, ch
	mov	ch, al
	jz	short HL31
	mov	al, ah
	call	word ptr wcgabp

HL31:	add	di, inccgan
	dec	bl
	jl	short HL34
	lodsb
	mov	ah, ch
	or	ah, al
	jz	short HL31
	or	bl, bl
	jnz	short HL30
	and	al, rmask
	jmp	HL30

HL34:	or	ch, ch
	jz	short HL35
	mov	al, ch
	call	word ptr wcgabp

HL35:	dec	word ptr n_rows
	jz	short S3BYE
	mov	bl, bh
	add	si, next_font_row
	add	di, next_scrn_row

       .if	di BE last_row, then_goto <short HL36>
	sub	di, last_row

HL36:	lodsb
	and	al, lmask
	shl	al, cl
	mov	ch, al
	jmp	HL31
S3BYE:	jmp	XWBYE

XW256:	mov	ax, char_bit_offset
	mov	cx, ax
       .shr	ax, 3
	add	char_bitmap, ax
	and	cx, 7
	mov	bx, cx
	mov	ch, char_width
	mov	ofs_npel, cx

	add	bx, char_width
       .if	bx, GE 16, then_goto <short XW00>
	mov	bx, char_width
XW00:	mov	dx, bx
	and	bx, 07H
	mov	al, 0
       .smov	ah, <_rbitmask .[bx]>
	and	dl, 8H
	jz	short XW01
	mov	al, ah
	mov	ah, 0FFH
XW01:	mov	rmask, ax

       .smov	ax, <_gfx .bytes_per_row>
	mov	next_scrn_row, ax

	mov	bx, offset CS_LBL:XWM2
	mov	ax, offset CS_LBL:XCM2
       .if	XOR_PEL bit_is_off_in <_gfx .color_flags>, then_goto <short XWA0>
	mov	bx, offset CS_LBL:XWX2
	mov	ax, offset CS_LBL:XCX2
XWA0:	mov	npg, ax

       .smov	dx, <_gfx .screen_base>
       .les	si, char_bitmap

	mov	di, start_of_scrn_row
	add	di, x
	jnc	short XWA1
       .call	_DSnext_256_page
XWA1:	push	di
	push	si
	mov	ds, dx

XWA:	mov	dx, es:[si]
	add	si, 2
	xchg	dh, dl
	mov	cx, ofs_npel	; cl = offset	ch = n_pels_wide
	shl	dx, cl
	mov	ax, 16
	sub	al, cl
	sub	ch, al
	xchg	ax, cx
	mov	al, color
	add	cx, di
	jc	short XWE
XWB:   .if	ah GE 0, then_goto <short XWC>
	and	dx, rmask
	jz	short NEXTSCANLINE
XWC:	jmp	bx

XWX0:	xor	[di], al
XWX1:	inc	di
XWX2:	shl	dx, 1
	jc	short XWX0
	jnz	short XWX1
	jmp	short XWD

XWM0:	mov	[di], al
XWM1:	inc	di
XWM2:	shl	dx, 1
	jc	short XWM0
	jnz	short XWM1

XWD:   .if	ah GT 0, then_goto <short XWD0>

NEXTSCANLINE:
	mov	ax, di
	pop	si				; start_bitmask_line
	pop	di				; start_screen_line
	dec	byte ptr n_rows
	jz	short XWDONE
	add	si, form_width
	add	di, next_scrn_row
	push	di
	push	si
	jnc	short XWA
       .if	ax BE di, then_goto <short XWA>
       .call	_DSnext_256_page
	jmp	XWA

XWD0:	sub	ah, 16
	mov	dx, es:[si]
	add	si, 2
	xchg	dh, dl
       .if	di AB cx, then_goto <short XWE0>
XWD1:	mov	di, cx
	add	cx, 16
XWE:	mov	bx, npg
	jmp	short XWB
XWE0:  .call	_DSnext_256_page
	jmp	short XWD1

XCX0:	xor	[di], al
XCX1:	inc	di
	jz	short XCB
XCX2:	shl	dx, 1
	jc	short XCX0
	jnz	short XCX1
	jmp	XWD

XCM0:	mov	[di], al
XCM1:	inc	di
	jz	short XCB
XCM2:	shl	dx, 1
	jc	short XCM0
	jnz	short XCM1
	jmp	XWD

XCB:   .call	_DSnext_256_page
	jmp	bx

XWDONE:.if	ax AB start_of_scrn_row, then_goto <short XWBYE>
       .call	_DSprev_256_page

XWBYE:	jmp	CHAR_BYE

			; 16-bit fast write characters
FAST_CHAR:
       .smov	ax, <_gfx .bytes_per_row>
	mov	next_scrn_row, ax
       .smov	ax, _gfx_wrt_bkgnd_color
        mov	bc, ax	
	mov	dx, char_bit_offset
	mov	si, dx
       .shr	si, 3

PP0:   .smov	es, <_gfx .screen_base>
       .lds	ax, char_bitmap
	add	si, ax

	mov	dx, GRAPH_ADDR
	mov	al, G_BITMASK
	out	dx, al
	inc	dx
	
	mov	bx, form_width
       .if	cl NE 0, then_goto <short PQWN>	
	mov	ah, color
	mov	cx, n_rows
	mov	al, bc
       .if	al LT 0, then_goto <short PQW8> 
        jmp	short PQW8C0

PQNP0: .call	_ESnext_256_page
PQWN:	mov	ch, color
	mov	word ptr rmask, -1
       .if	char_width EQ 8, then_goto <short PQWN8>	
	inc	word ptr rmask
	jmp	short PQWN8
PQWN80:	dec	word ptr n_rows         ; non-byte-aligned 
	jz	short FAST_CHAR_BYE
	add	si, bx
	add	di, next_scrn_row
	jc	short PQNP0
PQWN8:	mov	ah, [si]
	mov	al, 0
	shr	ax, cl
	and	al, rmask
	jz      short PQWN81
	out	dx, al
	mov	al, es:[di+1]
	mov	al, ch
	mov	es:[di+1], al
PQWN81:	or	ah, ah
	jz      short PQWN80
	mov	al, ah
	out	dx, al
	mov	al, es:[di]
	mov	al, ch
	mov	es:[di], al
	jmp	short PQWN80

PQNP1: .call	_ESnext_256_page
	jmp	short PQW8
PQW80:	dec	cx                              ; byte-aligned w/ xparent bkgnd
	jz	short FAST_CHAR_BYE
	add	si, bx			        
	add	di, next_scrn_row
	jc	short PQNP1
PQW8:	mov	al, [si]
	or	al, al
	jz	short PQW80
	out	dx, al
	mov	al, es:[di]
	mov	al, ah
	mov	es:[di], al
	jmp	short PQW80

FAST_CHAR_BYE:
       .if	di AB start_of_scrn_row, then_goto <short CHAR_BYE>
       .call	_ESprev_256_page

PQW8C0:	mov	al, 0FFH                        ; byte-aligned w/ bkgnd color
	out	dx, al
	mov	al, bc
	mov	es:[di], al
	mov	al, es:[di]
PQW8C:  mov	al, [si]
        out	dx, al
        mov	es:[di], ah
	add	si, bx
	add	di, next_scrn_row
	jc	short PQNP2
PQW8C1:	loop	PQW8C
	jnp	short FAST_CHAR_BYE
PQNP2: .call	_ESnext_256_page 
	jmp	short PQW8C1

PQWB:	mov	bh, bc
	mov	bl, 80H
	mov	cl, char_width
	sar	bl, cl
        mov	cx, x
        and	cx, 7
        shr	bl, cl

PQW8B: .if	bh LT 0, then_goto PQW8B0       ; byte-aligned - clipped
	mov	al, bl
	out	dx, al
	mov	al, bh
	xchg	es:[di], al
PQW8B0:	mov	al, [si]
        and	al, bl
        jz	short PQW8B1
	out	dx, al
	mov	al, ah
	xchg	es:[di], al
PQW8B1:	add	si, form_width
	add	di, next_scrn_row
        jc      short PQNP3
        LOOP	PQW8
	jnp	short FAST_CHAR_BYE
PQNP3: .call	_ESnext_256_page 
	jmp	short PQW8C1


CHAR_BYE:

END_FCN;



START_FCN <NEAR $$wrt_med_res_bit_pattern>

	mov	dh, al
	mov	ax, 8000H
EX0:	shr	dh, 1
	rcr	ax, 1
	sar	ax, 1
	jnc	short EX0
	xchg	ah, al
	not	ax
	and	es:[di], ax
	not	ax
	and	ah, dl
	and	al, dl
	or	es:[di], ax

END_FCN


START_FCN <NEAR $$xor_med_res_bit_pattern>

	mov	dh, al
	mov	ax, 8000H
EX1:	shr	dh, 1
	rcr	ax, 1
	sar	ax, 1
	jnc	short EX1
	xchg	ah, al
	and	ah, dl
	and	al, dl
	xor	es:[di], ax

END_FCN


START_FCN <NEAR $$wrt_hi_res_bit_pattern>

	or	dl, dl
	jz	short BDOT
	or	es:[di], al
	ret
BDOT:	not	al
	and	es:[di], al

END_FCN

START_FCN <NEAR $$xor_hi_res_bit_pattern>

	or	dl, dl
	jnz	short BDOT1
	not	al
BDOT1:	xor	es:[di], al

END_FCN


START_FCN _gfx_get_rom_font_ptr < <CHAR fh_n> >
PROLOGUE <ES>
IFNDEF USE_386
	mov	ax, 1130H
	mov	bh, fh_n
	int	10H
       .lret	bp, es
ENDIF
END_FCN


;/*~ MOUSE256.ASM */

EXTERN FCN <NEAR _ESnext_256_page>
EXTERN FCN <NEAR _DSnext_256_page>
EXTERN FCN <NEAR _ESnew_256_page>
EXTERN FCN <NEAR _DSnew_256_page>
EXTERN FCN <NEAR _ESprev_256_page>
EXTERN FCN <NEAR _DSprev_256_page>
EXTERN FCN <NEAR _0xy_to_ram>

EXTERN CHAR  $256_page_n

START_FCN _gfx_xy_vram256_to_buf < <_int x>, <_int y>, <_int n_bytes>, <_int n_rows>, <FAR_PTR buf> >
PROLOGUE
       .smov	ax, <_gfx .bytes_per_row>
	mul	word ptr y
	add	ax, x
	adc	dx, 0
	mov	x, ax
	mov	y, dx
END_FCN NO_RET

EXTERN FCN <NEAR _0new_256_page>

START_FCN _gfx_ptr_vram256_to_buf < <_int page_offset>, <_int page_n>, <_int n_bytes>, <_int n_rows>, <FAR_PTR buf> >
PROLOGUE <SI, DI, ES, DS>

	mov	ax, page_n
       .if	al EQ $256_page_n, then_goto <short B0>
	call	_0new_256_page
B0:	mov	si, page_offset
       .sadd	si, <_gfx .screen_offset>
       .smov	dx, <_gfx .bytes_per_row>
	sub	dx, n_bytes
	inc	dx
	.les	di, buf
       .smov	ds, <_gfx .screen_base>
	cld
B1:	mov	cx, n_bytes
	xor	bx, bx
	mov	ax, si
	add	ax, cx
	jnc	short B2
	mov	bx, ax
	sub	cx, ax
B2:	shr	cx, 1
rep	movsw
	jnc	short B3
	movsb
B3:	or	bx, bx
	jz	short B4
	mov	cx, bx
       .call	_DSnext_256_page
	xor	bx, bx
	jmp	short B2

B4:	dec	word ptr n_rows
	jz	short BBYE
	dec	si
	add	si, dx
	jnc	short B1
       .call	_DSnext_256_page
	jmp	B1
BBYE:
END_FCN


START_FCN _gfx_buf_to_xy_vram256 < <FAR_PTR buf>, <_int x>, <_int y>, <_int n_bytes>, <_int n_rows> >
PROLOGUE
       .smov	ax, <_gfx .bytes_per_row>
	mul	word ptr y
	add	ax, x
	adc	dx, 0
	mov	x, ax
	mov	y, dx
END_FCN NO_RET


START_FCN _gfx_buf_to_ptr_vram256 < <FAR_PTR buf>, <_int page_offset>, <_int page_n>, <_int n_bytes>, <_int n_rows> >
PROLOGUE <SI, DI, ES, DS>

	mov	ax, page_n
       .if	al EQ $256_page_n, then_goto <short C0>
	call	_0new_256_page
C0:	mov	di, page_offset
       .sadd	di, <_gfx .screen_offset>
       .smov	dx, <_gfx .bytes_per_row>
	sub	dx, n_bytes
	inc	dx
       .smov	es, <_gfx .screen_base>
	.lds	si, buf
	cld

C1:	mov	cx, n_bytes
	xor	bx, bx
	mov	ax, di
	add	ax, cx
	jnc	short C2
	mov	bx, ax
	sub	cx, ax
C2:	shr	cx, 1
rep	movsw
	jnc	short C3
	movsb
C3:	mov	cx, bx
	jcxz	C4
       .call	_ESnext_256_page
	xor	bx, bx
	jmp	short C2

C4:	dec	word ptr n_rows
	jz	short CBYE
	dec	di
	add	di, dx
	jnc	short C1
       .call	_ESnext_256_page
	jmp	C1
CBYE:
END_FCN


