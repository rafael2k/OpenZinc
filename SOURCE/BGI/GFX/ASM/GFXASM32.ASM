      ;/************************************************************/
      ;/* Copyright (c) C Source, Inc 1987, 1988, 1989, 1990, 1991 */
      ;/************************************************************/


INCLUDE EZ_ASM.MAC
INCLUDE GFX_ASM.MAC

DEFINE_MODULE EGA_GFX


EXTERN _INT <NEAR _gfx>;

;/*^ GFXG_A32.ASM */

;/*~ EGA_HERC.ASM */

USE_ENHANCED_MODE EQU	YES
USE_HERCULES_CARD EQU	YES


IF (USE_ENHANCED_MODE EQ YES)


	START_FCN _gfx_clean_up_ega;
		mov	edx, SEQ_ADDR
		mov	al, S_MAP
		out	dx, al
		inc	edx
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
		mov	edx, GRAPH_ADDR
		mov	al, G_DATA_ROT
		out	dx, al
		inc	edx
		xor	al, al
		out	dx, al
		dec	edx
		mov	al, G_MODE
		out	dx, al
		mov	al, ah
		inc	edx
		out	dx, al

		mov	edx, GRAPH_ADDR	; set all bits in the bitmask ON
		mov	al, G_BITMASK
		out	dx, al
		inc	edx
		mov	al, 0FFH
		out	dx, al
		dec	edx

	END_FCN;

	START_FCN _gfx_set_ega_palette < <DATA_PTR, palette_ptr> >
	PROLOGUE <ES>

	       .les	edx, palette_ptr
		mov	eax, 1002H
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

   EXTERN _INT _gfx_pm

	START_FCN _gfx_set_hercules_mode;

		cld
		push	eax
		push	ebx
		push	ecx

		push	ds
		pop	es
		mov	edx, CNTRL		  ; turn off the screen
		out	dx, al

				; initialize the 6845

		mov	edx, INDEX
		mov	ecx, 12
		xor	ah, ah
	parms:	mov	al, ah
		out	dx, al
		inc	edx
		lodsb
		out	dx, al
		inc	ah
		dec	edx
		loop	parms

	       .smov	es, <_gfx_pm .sl_real_mem>
		mov	edi, 0B0000H
		pop	ecx
		pop	eax
	rep	stosw

		mov	edx, CNTRL
		pop	eax
		add	al, SCREEN_ON
		out	dx, al
	END_FCN;


	START_FCN _gfx_set_herc_gfx_mode
	PROLOGUE <SI, DI, ES, DS>;
		mov	edx, LOCK_GFX
		mov	al, GRAPHIX_MODE
		out	dx, al
		lea	esi, gtable
		xor	ebx, ebx
		mov	ecx, 4000H
		call	_gfx_set_hercules_mode
		mov	ebx, 449H
		mov	byte ptr es:[ebx], 6
	END_FCN;


	START_FCN _gfx_set_herc_text_mode;
	PROLOGUE <SI, DI, ES, DS>;
		mov	edx, LOCK_GFX
		xor	eax, eax
		out	dx, al
		inc	edx
		out	dx, al

		mov	eax, 7
		int	10

		mov	al, TEXT_MODE
		lea	esi, ttable
		mov	ebx, 720H
		mov	ecx, 2000
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
	lea	ebx, put_pel_jmp_table
	mov	dword ptr[ebx],   offset CS_LBL:MRES
	mov	dword ptr[ebx+2], offset CS_LBL:HRES
	mov	dword ptr[ebx+4], offset CS_LBL:ERES
	mov	dword ptr[ebx+6], offset CS_LBL:R256
EOTP2:
ENDIF
	mov	ecx, x
	mov	eax, y
        mov	bl, FCN_PUT_PEL
       .call	_00xy_to_ram
	mov	ecx, 0
	jc	 XIT
	inc	ecx
	and	edi, 7
	jmp	dword ptr DS_LBL:put_pel_jmp_table[ebx]

HRES:	mov	ebx, edi
       .smov	ah, <_0hi_res_pel_mask [ebx]>		; HIGH RES
	mov	bl, color
       .smov	al, <_0hi_res_color_mask [ebx]>
	jmp	short W_PIX

MRES:	mov	ebx, edi
	and	ebx, 3			  ; MEDIUM RES
       .smov	ah, <_0med_res_pel_mask [ebx]>
	mov	bl, color
       .smov	al, <_0med_res_color_mask [ebx]>

W_PIX:	and	al, ah				; SET CGA CARD PEL
	not	ah
       .if	XOR_PEL bit_is_on_in <_gfx .color_flags>, then_goto <short XOR_PIX>
       .smov	es, <_gfx .screen_base>
	and	es:[esi], ah
	or	es:[esi], al
	jmp	short XIT

XOR_PIX:
       .smov	es, <_gfx .screen_base>
	xor	es:[esi], al
	jmp	short XIT

ERES:	mov	edx, GRAPH_ADDR		    ; ENHANCED RES
	mov	ebx, edi
	mov	al, G_BITMASK
	out	dx, al
       .smov	al, <_0hi_res_pel_mask [ebx]>
	inc	edx
	out	dx, al
	mov	al, color
       .smov	es, <_gfx .screen_base>
	mov	ah, es:[esi]
	mov	es:[esi], al
	jmp	short XIT

R256:	mov	al, color
       .smov	es, <_gfx .screen_base>
       .if	XOR_PEL bit_is_off_in <_gfx .color_flags>, then_goto <short RM256>
	xor	es:[esi], al
	jmp	short XIT
RM256:	mov	es:[esi], al

XIT:	mov	eax, ecx			; 0==>out of bounds
END_FCN;



START_FCN _gfx_clip_gfx, < < CHAR, clip_it> >;
PROLOGUE;

       .smov	ebx, <_INT _00xy_to_ram>
	mov	eax, offset CS_LBL:_0xy_to_ram
       .if	clip_it EQ NO, then_goto <short E1>
	mov	eax, offset CS_LBL:_clip_xy_to_ram
E1:    .smov	<_INT _00xy_to_ram>, eax
	sub	eax, ebx
END_FCN;


	;			_0xy_to_ram
	;
	;	entering:   ecx = x
	;		    eax = y
	;
	;	exiting:    esi = byte of point in screen ram
	;		    edi = original x
	;		    bl = jump index (0=MRES, 2=HRES, 4=ERES)
	;		    dl = resolution (0=HI, 1=MED, 2=ENHANCED)
	;
	;	_clip_xy_to_ram can be called by routines that want to make
	;	sure that the point being translated is 'in bounds'.  If
	;	it isn't then the carry bit will be set on return.


IF (.$$DATA_SIZE NE ._LARGE_DATA)

START_FCN <NEAR _clip_xy_to_ram>;

       .if	<_gfx .min_x> GT ecx, then_goto <short OUT_OF_BOUNDS>
       .if	<_gfx .max_x> LT ecx, then_goto <short OUT_OF_BOUNDS>
       .if	<_gfx .min_y> GT eax, then_goto <short OUT_OF_BOUNDS>
       .if	<_gfx .max_y> GE eax, then_goto <short _0xy_to_ram>

OUT_OF_BOUNDS:
	stc				; set out-of-bounds flag
END_FCN;

ELSE

START_FCN <NEAR _clip_xy_to_ram>;

	push	ds
	mov	ebx, seg _gfx
	mov	ds, bx
       .if	ecx GT _gfx.max_x, then_goto <short OUT_OF_BOUNDS>
       .if	ecx LT _gfx.min_x, then_goto <short OUT_OF_BOUNDS>
       .if	eax LT _gfx.min_y, then_goto <short OUT_OF_BOUNDS>
       .if	eax GT _gfx.max_y, then_goto <short OUT_OF_BOUNDS>
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
	lea	ebx, xy_jmp_table
	mov	dword ptr[ebx],   offset CS_LBL:_MRES
	mov	dword ptr[ebx+2], offset CS_LBL:_HRES
	mov	dword ptr[ebx+4], offset CS_LBL:_ERES
	mov	dword ptr[ebx+6], offset CS_LBL:_HERC
	mov	dword ptr[ebx+8], offset CS_LBL:_R256
	mov	dword ptr[ebx+10], offset CS_LBL:ERR_EXIT
XYTP2:
ENDIF
	mov	edi, ecx			    ; save for return
        shr	ecx, 2			  ; assume medium res
       .smov	ebx, <_gfx .gfx_mode>
	mov	dl, bh
	xor	bh, bh
	shl	ebx, 1
	jmp	dword ptr DS_LBL:xy_jmp_table[ebx]

ERR_EXIT:
       .call	_gfx_no_init
_HRES:	shr	ecx, 1			  ; HIGH RES
_MRES:	shr	eax, 1
	jnc	short MROW
	add	ecx, 2000H
MROW:	mov	ah, 80
	mul	ah
	jmp	short R3

_HERC:  ror	ax, 2			  ; HERCULES CARD, AT&T 640x400
	mov	esi, eax
	shr	esi, 1
	and	esi, 6000H
	shr	ecx, 1
	add	ecx, esi
	mov	ebx, 1 * INT_SZ
       .smov	ah, <CHAR _gfx .bytes_per_row>
	mul	ah
R3:    .smov	esi, <_gfx .screen_offset>   ; add base of screen
	add	esi, ecx
	add	esi, eax
	clc
	ret

SETPG:	mov	al, dl				; set 16- or 256-color page
	mov	DS_LBL:$256_page_n, al
	call	dword ptr DS_LBL:$set_256_page
	pop	edx
	clc
	ret

_R256:	mov	ebx, 3 * INT_SZ			; 256-color
	mov	ecx, edi
	jmp	short _RC0

_ERES:	shr	ecx, 1				; 16-color

_RC0:	push	edx
       .smov	edx, <_gfx .bytes_per_row>
	mul	edx
	add	eax, ecx

IFNDEF CWC32
	push	ds
	pop	gs
ENDIF
	shld	edx, eax, 16
	movzx	eax, ax
	and	edx, 0FFH
       .sadd	eax, <_gfx .screen_offset>


	mov	esi, eax
       .if	dl NE DS_LBL:$256_page_n, then_goto <short SETPG>
	clc
	pop	edx

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
	push	eax
	push	ds

	push	DS_REG_DUP
	pop	ds


	lahf
       .if	al EQ DS_LBL:$256_page_n, then_goto <short _0sbye>
	mov	DS_LBL:$256_page_n, al
	call	dword ptr DS_LBL:$set_256_page
_0sbye:	pop	ds
	pop	eax
END_FCN

START_FCN <NEAR _DSnext_256_page>
	stc
	jmp	short _0next_256_page
END_FCN NO_RET

START_FCN <NEAR _ESnext_256_page>
	clc
END_FCN NO_RET

START_FCN <NEAR _0next_256_page>
	push	eax
	push	ds

	push	DS_REG_DUP
	pop	ds


	lahf
	mov	al, DS_LBL:$256_page_n
	inc	al
	mov	DS_LBL:$256_page_n, al
	call	dword ptr DS_LBL:$set_256_page
	pop	ds
	pop	eax
END_FCN

START_FCN <NEAR _DSprev_256_page>
	stc
	jmp	short _0prev_256_page
END_FCN NO_RET

START_FCN <NEAR _ESprev_256_page>
	clc
END_FCN NO_RET

START_FCN <NEAR _0prev_256_page>
	push	eax
	push	ds

	push	DS_REG_DUP
	pop	ds


	lahf
	mov	al, DS_LBL:$256_page_n
	dec	al
	mov	DS_LBL:$256_page_n, al
	call	dword ptr DS_LBL:$set_256_page
	pop	ds
	pop	eax
END_FCN


START_FCN _gfx_set_vidram < <_INT x>, <_INT y> >
PROLOGUE <SI, DI>
	mov	ecx, x
	mov	eax, y
	mov	bl, FCN_SET_VIDRAM
       .call	_0xy_to_ram
	mov	eax, esi
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
EXTERN _INT _gfx_pm
EXTERN FCN  <NEAR _0xy_to_ram>;
ENDIF


		; al == $256_page_n (where pagesize == 64k)

START_FCN <NEAR _0set_V7VGA_256>
	push	edx
	push	ebx
	mov	dl, al
	and	dl, 0CH
	mov	bh, dl
        shr	dl, 2
	or	bh, dl
	mov	bl, al
	and	bl, 1
	and	al, 2
        shl	al, 4
	mov	ah, al
	mov	edx, 3CCH
	in	al, dx
	and	al, not 20H
	or	al, ah
	mov	edx, 3C2H
	out	dx, al
	inc	edx
	inc	edx
	mov	al, 0F9H
	mov	ah, bl
	out	dx, ax
	mov	al, 0F6H
	out	dx, al
	inc	edx
	in	al, dx
	and	al, 0F0H
	or	al, bh
	out	dx, al
	pop	ebx
	pop	edx
V7Bye:
END_FCN



		; al == $256_page_n (where pagesize == 64k)

START_FCN <NEAR _0set_V7VGA_16>
	mov	ah, al
        shl	ah, 2
	or	ah, al
	push	edx
	mov	edx, 3C4H
	mov	al, 0F6H
	out	dx, al
	inc	edx
	in	al, dx
	and	al, 0F0H
	or	al, ah
	out	dx, al
	pop	edx
END_FCN


START_FCN _gfx_init_V7VGA
	mov	edx, 3C4H
	mov	eax, 0EA06H
	out	dx, ax
       .if	<_gfx .n_colors> EQ 16, then_goto <short IV716>
	mov	dword ptr DS_LBL:$set_256_page, offset CS_LBL:_0set_V7VGA_256
	jmp	short IV7BYE
IV716:	mov	dword ptr DS_LBL:$set_256_page, offset CS_LBL:_0set_V7VGA_16

IV7BYE:
END_FCN


STATIC _INT	_ATI_port, <0, 0>

ATI_SELECT_PAGE		EQU	0B2H
ATI_RW_PAGE_MASK	EQU	0E1H

START_FCN <NEAR _0set_ATI_256>
	and	al, 0FH
	mov	ah, al

	push	edx
	mov	edx, DS_LBL:_ATI_port
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
	pop	edx
END_FCN

START_FCN _gfx_set_ATI_port < <_INT port_n> >
PROLOGUE
	mov	eax, port_n
       .smov	_ATI_port, eax
END_FCN


START_FCN _gfx_is_good_ATI_mode < <_INT mode_n> >
PROLOGUE <SI, ES>
	push	ebp
	mov	ah, 12H
	mov	al, mode_n
	mov	ebx, 5506H
	mov	ebp, -1
	xor	esi, esi
	int	10H
	xor	eax, eax
       .if	bp EQ -1, then_goto ATI_BYE
	inc	eax
ATI_BYE:
	pop	ebp
END_FCN


START_FCN _gfx_init_ATI_18800
	mov	dword ptr DS_LBL:$set_256_page, offset CS_LBL:_0set_ATI_256
END_FCN



START_FCN _gfx_init_TSENG_ET4000
	mov	dword ptr DS_LBL:$set_256_page, offset CS_LBL:_0set_TSENG_ET4000
END_FCN

START_FCN _gfx_init_TSENG_ET3000
	mov	dword ptr DS_LBL:$set_256_page, offset CS_LBL:_0set_TSENG_ET3000
END_FCN


TSENG_SELECT_PAGE	EQU	03CDH

START_FCN <NEAR _0set_TSENG_ET4000>
	and	al, 0FH
	mov	ah, al
        shl	ah, 4
	or	al, ah
	push	edx
	mov	edx, TSENG_SELECT_PAGE
	out	dx, al
	pop	edx
END_FCN


START_FCN <NEAR _0set_TSENG_ET3000>
	and	al, 7H
	mov	ah, al
        shl	ah, 3
	or	al, ah
	or	al, 40H
	push	edx
	mov	edx, TSENG_SELECT_PAGE
	out	dx, al
	pop	edx
END_FCN



START_FCN _gfx_init_TRIDENT_8800CS
	mov	edx, 3C4H
	mov	al, 0BH
	out	dx, al
	inc	edx
	in	al, dx
	mov	edx, 3CEH
	mov	eax, 506H
	out	dx, ax
	mov	dword ptr DS_LBL:$set_256_page, offset CS_LBL:_0set_TRIDENT_8800CS
	xor	ax, ax
	call	dword ptr DS_LBL:$set_256_page
END_FCN


START_FCN <NEAR _0set_TRIDENT_8800CS>
	push	edx
	mov	ah, al
	mov	edx, 3C4H
	mov	al, 0EH
	out	dx, al
	inc	edx
	in	al, dx
	and	eax, 0FF0H
	or	al, ah
	xor	al, 2
	out	dx, al
	pop	edx
END_FCN

START_FCN _gfx_WD_SVGA_bug
	mov	eax, 1130H		; bug fix for snow in high res modes
	mov	ebx, 600H		; don't know why it works, it just does
	push	ebp
	int	10H
	pop	ebp
END_FCN

START_FCN _gfx_init_WD
	mov	edx, 3CEH
	mov	al, 0FH
	out	dx, al
	inc	edx
	in	al, dx
	and	al, 0F8H
	or	al, 5H
	out	dx, al
	mov	edx, 3C4H		; set single 64k r/w page
	mov	al, 11H
	out	dx, al
	inc	edx
	in	al, dx
	and	al, 7FH
	out	dx, al
	mov	edx, 3CEH
	mov	al, 0BH
	out	dx, al
	inc	edx
	in	al, dx
	and	al, 0F7H
	out	dx, al
	mov	dword ptr DS_LBL:$set_256_page, offset CS_LBL:_0set_WD
END_FCN


START_FCN <NEAR _0set_WD>
	push	edx
	mov	edx, 3CEH
	mov	ah, al
	mov	al, 09H
        shl	ah, 4
	out	dx, ax
	pop	edx
END_FCN


START_FCN _gfx_init_OAK
	mov	edx, 3CEH		; set single 64k r/w page
	mov	al, 6
	out	dx, al
	inc	edx
	in	al, dx
	and	al, 0F3H
	or	al, 4
	out	dx, al
	mov	dword ptr DS_LBL:$set_256_page, offset CS_LBL:_0set_OAK
END_FCN


START_FCN <NEAR _0set_OAK>
	push	edx
	mov	edx, 3DEH
	mov	ah, al
	mov	al, 011H
	out	dx, al
	inc	edx
	and	ah, 7H
	mov	al, ah
        shl	ah, 4
	or	ah, al
	in	al, dx
	and	al, 88H
	or	al, ah
	out	dx, al
	pop	edx
END_FCN


START_FCN _gfx_init_S3
	mov	dword ptr DS_LBL:$set_256_page, offset CS_LBL:_0set_S3
	xor	ax, ax
	call	dword ptr DS_LBL:$set_256_page
END_FCN


START_FCN <NEAR _0set_S3>
        push	ebx			; save cpu registers
        push	edx
        and	al, 0FH			; save video page in bl
        mov	bl, al
	mov	eax, 4838H		; unlock the S3 registers
	mov	edx, 03D4H
	out	dx, ax
	mov	al, 35H			; read in the video page register
	out	dx, al
	inc	dx
	in	al, dx
	and	al, 0F0H		; set new video page number
	or	al, bl
	out	dx, al			; write it
	dec	dx			; lock the S3 registers
	mov	eax, 48H
        out	dx, ax
	pop	edx			; restore cpu registers
	pop	ebx
END_FCN


START_FCN _gfx_init_CIRRUS_GD542X
	mov	dword ptr DS_LBL:$set_256_page, offset CS_LBL:_0set_CIRRUS_GD542X
        mov	edx, 03CEH
        mov	al, 0BH
        out	dx, al
        inc	edx
        in	al, dx
        and	al, 0FEH
        out	dx, al
        dec	edx
        mov	eax, 9
        out	dx, ax
END_FCN

START_FCN <NEAR _0set_CIRRUS_GD542X>
        push	edx
        shl	al, 4 
        mov	ah, al
        mov	edx, 03CEH
        in	al, dx
        push	eax
        mov	al, 09H
        out	dx, ax
	pop	eax
	out	dx, al
	pop	edx
END_FCN


START_FCN _gfx_init_CIRRUS_GD5410
	mov	dword ptr DS_LBL:$set_256_page, offset CS_LBL:_0set_CIRRUS_GD5410
        mov	edx, 03CEH
        mov	al, 0DH
        out	dx, al
        inc	edx
        in	al, dx
        and	al, 0F8H
        or	al, 3
        out	dx, al
        dec	edx
        mov	eax, 0EH
        out	dx, ax
END_FCN


START_FCN <NEAR _0set_CIRRUS_GD5410>
        push	edx
        mov	edx, 03CEH
        shl	al, 4 
        mov	ah, al
        mov	al, 0EH
        out	dx, ax
	pop	edx
END_FCN


STATIC _INT VESA_fcn, <0,0>

START_FCN _gfx_init_VESA < <LONG VESA_fcn_ptr>, <_INT _type > >
PROLOGUE
	mov	eax, VESA_fcn_ptr
	mov	VESA_fcn, eax
	mov	eax, _type
       .if	eax AB 100H,  then_goto <short VSPM>
VS1:	mov	word ptr DS_LBL:$set_256_page, ax
	jmp	short VSBYE
VSPM: movzx	eax, al
VSBYE:
END_FCN

START_FCN <NEAR _0set_VESA>
_4K:	shl	al, 1
_8K:	shl	al, 1
_16K:	shl	al, 1
_32K:	shl	al, 1
_64K:	push	edx
	push	ebx
	xor	edx, edx
	mov	dl, al
	mov	ebx, 0
	call	dword ptr VESA_fcn
	pop	ebx
	pop	edx
END_FCN

STATIC _INT parm_block <0, 0, 0, 0, 0, 0>

START_FCN <NEAR _0set_VESA_for_pm>
	pushad
	and	eax, 0FFH
	mov	parm_block[5*INT_SZ], eax
	mov	dword ptr parm_block[3*INT_SZ], 0
	mov	ebx, VESA_FCN
	xor	ecx, ecx
	lea	edx, parm_block
	mov	eax, 2510H
	int	21H
	popad
END_FCN





PLAPBLOCK STRUC
	INT_NO	   dw	?
	DS_REG	   dw	?
	ES_REG	   dw	?
	GS_REG	   dw	?
	FS_REG 	   dw	?
	EAX_REG	   dd	?
	EDX_REG	   dd	?
PLAPBLOCK ENDS

STATIC _INT $PLAP_data_block <0, 0, 0, 0, 0, 0>

START_FCN _gfx32_call_VESA < <_INT _EAX>, <_INT _ECX>, <_INT _EDI>, <_INT _ES>, <DATA_PTR dpmi_buf> >
PROLOGUE <DI, SI, ES>
       .if	<_gfx_pm .extender> EQ 1, then_goto <short PL0>
	mov	edi, dpmi_buf
	mov	eax, _EAX
	mov	[edi+1CH], eax
	mov	eax, _ECX
	mov	[edi+18H], eax
	mov	eax, _EDI
	mov	[edi+0], eax
	mov	eax, _ES
	mov	[edi+22H], eax
	mov	ecx, 0
	mov	ebx, 10H
	mov	eax, 300H
	push	ds
	pop	es
	int	31H
	mov	eax, es:[edi].1CH
	jmp	short VB

PL0:	lea	edx, $PLAP_data_block
	mov     [edx].INT_NO, 10H
	mov	eax, _ES
	mov	dword ptr [edx].ES_REG, eax
	mov	eax, _EAX
	mov	[edx].EAX_REG, eax
	mov	ecx, _ECX
	mov	edi, _EDI
	mov	eax, 2511H
	int	21H
VB:	movzx	eax, ax
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

SIGN_BIT equ 80000000H

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
	lea	ebx, asmline_jmp_table
	mov	dword ptr[ebx],   offset CS_LBL:LMRES
	mov	dword ptr[ebx+2], offset CS_LBL:LHRES
	mov	dword ptr[ebx+4], offset CS_LBL:LERES
	mov	dword ptr[ebx+6], offset CS_LBL:LHRES
	lea	ebx, jmp256
	mov	dword ptr[ebx],   offset CS_LBL:AM01
	mov	dword ptr[ebx+2], offset CS_LBL:MM01
	mov	dword ptr[ebx+4], offset CS_LBL:AM0
	mov	dword ptr[ebx+6], offset CS_LBL:MM0
	mov	dword ptr[ebx+8], offset CS_LBL:AX01
	mov	dword ptr[ebx+10], offset CS_LBL:XX01
	mov	dword ptr[ebx+12], offset CS_LBL:AX0
	mov	dword ptr[ebx+14], offset CS_LBL:XX0
EOTP4:
ENDIF
       .if	pattern EQ -1, then_goto <short LL0>
	mov	cl, start_bit
	rol	dword ptr pattern, cl

LL0:	mov	ecx, x
	mov	eax, y
	mov	bl, FCN_ASM_INE
       .call	_0xy_to_ram
	mov	ecx, edi
	mov	edi, d
	xor	bh, bh
	jmp	asmline_jmp_table[ebx]

LHRES:	and	cl, 7
	mov	ah, 80H
	ror	ah, cl
	mov	cl, 1
	mov	bl, color
       .smov	al, <_0hi_res_color_mask [ebx]>
	jmp	short L0

LMRES:	and	cl, 3				; MEDIUM RES
	shl	cl, 1
	mov	ah, 0C0H
	ror	ah, cl
	mov	cl, 2
	mov	bl, color
       .smov	al, <_0med_res_color_mask [ebx]>

L0:    .smov	edx, <_gfx .color_flags>
	and	edx, XOR_PEL
	mov	ch, dh
	and	al, ah
	not	ah
       .smov	edx, <_gfx .last_video_row>
	mov	ebx, count
       .smov	ds, <_gfx .screen_base>
       .if	dir NE 0 then_goto <short L300>
	or	step, 2000H
	jns	short LDOT0
	mov	step, -2000H
	neg	edx

LDOT0:	rol	dword ptr pattern , 1
	jnc	short L02
	or	ch, ch
	jz	short L01
	xor	[esi], al
	jmp	short L02

L01:	and	[esi], ah			  ; SET CGA CARD PEL
	or	[esi], al

L02:   .if	edi GE 0, then_goto <short L1>
	add	edi, _d1
	jmp	short L2
L1:	add	edi, _d2
	add	esi, step
       .if	esi BL edx, then_goto <short L2>
	sub	esi, edx
L2:	ror	al, cl
	ror	ah, cl
	cmc
	adc	esi, 0
	dec	ebx
	jnz	short LDOT0
	jmp	LXIT

L300:

LDOT01: rol	dword ptr pattern , 1
	jnc	short L302

       .if	ch EQ 0, then_goto <short L301>
	xor	[esi], al
	jmp	short L302

L301:	and	[esi], ah			  ; SET CGA CARD PEL
	or	[esi], al

L302:  .if	edi GE 0, then_goto <short L30>
	add	edi, _d1
	jmp	short L40

L30:	add	edi, _d2
       .if	step BE 0FFH, then_goto <short L32>
L31:	rol	al, cl
	rol	ah, cl
	cmc
	sbb	esi, 0
	jmp	short L40
L32:	ror	al, cl
	ror	ah, cl
	cmc
	adc	esi, 0

L40:	add	esi, 2000H
       .if	esi BL edx, then_goto <short L41>
	sub	esi, edx
L41:	dec	ebx
	jnz	short LDOT01
	jmp	LXIT

LERES:	mov	eax, _d1			      ; ENHANCED RES
       .smov	_0_d1, eax
	mov	eax, _d2
       .smov	_0_d2, eax
	mov	eax, pattern
       .smov	_0pattern, eax
	and	ecx, 7
	mov	al, 80H
	ror	al, cl
	mov	ecx, count
	mov	ah, color
	mov	edx, GRAPH_ADDR+1
       .smov	ebx, <_gfx .bytes_per_row>
       .smov	es, <_gfx .screen_base>
       .if	dir NE 0 then_goto <short eLE2000>
       .if	pattern EQ -1, then_goto <short LEX>
	jmp	LEPX
ELE2000:jmp	LE2000

LEX:	cmp	dword ptr step, 0
	mov	ebp, ebx
	jge	short LE00
	jmp	short LE10

LE0A:  .call	_ESnext_256_page		; l to r and down
	jmp	short LE00
LEDOT0: ror	al, 1
	adc	si, 0
	jc	short LE0A

LE00:	out	dx, al
	mov	bh, ah
	xchg	bh, es:[esi]
       .if	SIGN_BIT bit_is_off_in edi, then_goto <short LE01>
       .sadd	edi, _0_d1
	loop	LEDOT0
	jmp	LXIT

LE01:  .sadd	edi, _0_d2
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
	xchg	bh, es:[esi]
       .if	SIGN_BIT bit_is_off_in edi, then_goto <short LE11>
       .sadd	edi, _0_d1
	loop	LEDOT1
	jmp	LXIT

LE11:  .sadd	edi, _0_d2
	sub	si, bp
	jc	short LE12
	loop	LEDOT1
	jmp	LXIT
LE12:  .call	_ESprev_256_page
	loop	LEDOT1
	jmp	LXIT


LE2000:.if	pattern EQ -1, then_goto <short LE2X>
	jmp	LEP2000
LE2X:	xchg	ebx, step
	mov	ebp, step

       .if	bh EQ 0, then_goto <short LE300>
	jmp	short LE200

LE2A:  .call	_ESnext_256_page		; r to l and down
	jmp	short LE200
LEDOT2: add	si, bp
	jc	short LE2A

LE200:	out	dx, al
	mov	bl, ah
	xchg	bl, es:[esi]
       .if	SIGN_BIT bit_is_off_in edi, then_goto <short LE201>

       .sadd	edi, _0_d1
	loop	LEDOT2
	jmp	LXIT

LE201: .sadd	edi, _0_d2
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
	xchg	bl, es:[esi]
       .if	SIGN_BIT bit_is_off_in edi, then_goto <short LE301>

       .sadd	edi, _0_d1
	loop	LEDOT3
	jmp	LXIT

LE301: .sadd	edi, _0_d2
	ror	al, 1
	adc	si, 0
	jc	short LE302
	loop	LEDOT3
	jmp	LXIT
LE302: .call	_ESnext_256_page
	loop	LEDOT3
	jmp	LXIT


LEPX:	cmp	dword ptr step, 0		; Pattern EGA/VGA Line
	mov	ebp, ebx
	jge	short LEP00
	jmp	short LEP10


LEP00A:.call	_ESnext_256_page
	jmp	short LEP00
LEPDOT0:ror	al, 1				; l to r and down
	adc	si, 0
	jc	short LEP00A

LEP00:	rol	dword ptr _0pattern, 1
	jnc	short LEP01
	out	dx, al
	mov	bh, ah
	xchg	bh, es:[esi]

LEP01: .if	SIGN_BIT bit_is_off_in edi, then_goto <short LEP02>
       .sadd	edi, _0_d1
	loop	LEPDOT0
	jmp	LXIT

LEP02: .sadd	edi, _0_d2
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

LEP10:	rol	dword ptr _0pattern, 1
	jnc	short LEP11
	out	dx, al
	mov	bh, ah
	xchg	bh, es:[esi]

LEP11: .if	SIGN_BIT bit_is_off_in edi, then_goto <short LEP12>
       .sadd	edi, _0_d1
	loop	LEPDOT1
	jmp	LXIT

LEP12: .sadd	edi, _0_d2
	sub	si, bp
	jc	short LEP13
	loop	LEPDOT1
	jmp	LXIT
LEP13: .call	_ESprev_256_page
	loop	LEPDOT1
	jmp	LXIT

LEP2000:xchg	ebx, step
	mov	ebp, step

       .if	bh EQ 0, then_goto <short LEP300>
	jmp	short LEP200

LEP2A: .call	_ESnext_256_page
	jmp	short LEP200
LEPDOT2:add	si, bp
	jc	short LEP2A

LEP200: rol	dword ptr _0pattern, 1
	jnc	short LEP20A

	out	dx, al
	mov	bl, ah
	xchg	bl, es:[esi]

LEP20A:.if	SIGN_BIT bit_is_off_in edi, then_goto <short LEP201>

       .sadd	edi, _0_d1
	loop	LEPDOT2
	jmp	LXIT

LEP201:.sadd	edi, _0_d2
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

LEP300: rol	dword ptr _0pattern, 1
	jnc	short LEP30A

	out	dx, al
	mov	bl, ah
	xchg	bl, es:[esi]

LEP30A:.if	SIGN_BIT bit_is_off_in edi, then_goto <short LEP301>

       .sadd	edi, _0_d1
	loop	LEPDOT3
	jmp	LXIT

LEP301:.sadd	edi, _0_d2
	ror	al, 1
	adc	si, 0
	jc	short LEP302
	loop	LEPDOT3
	jmp	LXIT
LEP302:.call	_ESnext_256_page
	loop	LEPDOT3
	jmp	LXIT

L256:  .smov	ebx, <_gfx .bytes_per_row>
	mov	ecx, 1
	xor	edx, edx
       .if	dir EQ 0, then_goto <short AA0>
       .if	step EQ 0, then_goto <short AA3>
	inc	edx
	jmp	short AA3
AA0:   .if	step EQ 0, then_goto <short AA2>
	inc	edx
AA2:	mov	ecx, ebx
	mov	ebx, 1
AA3:	mov	step, ecx

       .if	pattern EQ -1, then_goto <short AA4>
	or	dl, 2
AA4:   .if	XOR_PEL	bit_is_off_in <_gfx .color_flags>, then_goto <short AA5>
	or	dl, 4
AA5:	shl	edx, INT_SZ/2
	mov	edi, edx
	mov	edx, DS_LBL:jmp256[edi]

	mov	ecx, count
	mov	edi, d
	mov	al, color
       .smov	es, <_gfx .screen_base>
	jecxz	short AA51
	jmp	edx
AA51:	jmp	LXIT

AX0:	rol	dword ptr pattern, 1
	jnc	short AL1
AX01:	xor	es:[esi], al
	jmp	short AL1

AM0:	rol	dword ptr pattern, 1
	jnc	short AL1
AM01:	mov	es:[esi], al

AL1:	add	si, bx
	jc	short AL1B
AL1R:  .if	edi GE 0 then_goto <short AL2>
	add	edi, _d1
	dec	ecx
	jz	short LXIT
	jmp	edx
AL2:	add	edi, _d2
	add	si, step
	jc	short AL2B
AL2R:	dec	ecx
	jz	short LXIT
	jmp	edx
AL1B:  .call	_ESnext_256_page
	jmp	AL1R
AL2B:  .call	_ESnext_256_page
	jmp	AL2R


MX0:	rol	dword ptr pattern, 1
	jnc	short ML1
MX01:	xor	es:[esi], al
	jmp	short ML1

MM0:	rol	dword ptr pattern, 1
	jnc	short ML1
MM01:	mov	es:[esi], al

ML1:	add	si, bx
	jc	short ML1B
ML1R:  .if	edi GE 0 then_goto <short ML2>
	add	edi, _d1
	dec	ecx
	jz	short LXIT
	jmp	edx
ML2:	add	edi, _d2
	sub	si, step
	jc	short ML2B
ML2R:	dec	ecx
	jz	short LXIT
	jmp	edx
ML1B:  .call	_ESnext_256_page
	jmp	ML1R
ML2B:  .call	_ESprev_256_page
	jmp	ML2R

LXIT:
END_FCN;


;/*~ PATORDER.ASM */

START_FCN _gfx_rev_pat_order < <_int pattern> >;
PROLOGUE

	mov	edx, pattern
	xor	eax, eax
	mov	ecx, 16
LM0:	rol	edx, 1
	rcr	eax, 1
	rol	edx, 1
	rcr	eax, 1
	loop	LM0

END_FCN;



START_FCN _gfx_ror_pattern < < _int pattern >, < _int  ror_n_bits> >;
PROLOGUE
	mov	eax, pattern
	mov	cl, ror_n_bits
	and	cl, 1FH
	ror	eax, cl
END_FCN


START_FCN _gfx_arc_rot_pat_masks < <DATA_PTR masks> >
PROLOGUE<DS>

       .lds	ebx, masks
	add	ebx, 3 * INT_SZ
	xor	eax, eax
	mov	ecx, 8

AP_TOP: rol	dword ptr [ebx], 1
	mov	edx, [ebx]
	and	edx, ecx
	or	eax, edx
	shr	ecx, 1
	sub	ebx, INT_SZ
	ror	dword ptr [ebx], 1
	mov	edx, [ebx]
	and	edx, ecx
	or	eax, edx
	sub	ebx, INT_SZ
	shr	ecx, 1
	jnz	short AP_TOP

END_FCN


;/*~ SETCPAIR.ASM */

IFDEF TURBO_PASCAL
    ; Pascal Version

START_FCN _gfx_set_coor_pair < < DATA_PTR cpair > >
PROLOGUE <SI, DI, ES>

       .smov	ecx, <_gfx .min_y>
       .smov	edx, <_gfx .max_y>
       .les	esi, cpair
	mov	edi, esi
	add	edi, 2

CP0:	mov	eax, es:[esi+2*INT_SZ]
	mov	ebx, es:[esi]
       .if	eax LT ebx, then_goto <short CP1>
	xchg	eax, ebx

CP1:   .if	eax GT edx, then_goto <short CP_ERR>
       .if	ebx LT ecx, then_goto <short CP_ERR>

       .if	eax GE ecx, then_goto <short CP2>
	mov	eax, ecx
CP2:   .if	ebx LE edx, then_goto <short CP3>
	mov	ebx, edx
CP3:	mov	es:[esi+2*INT_SZ], eax
	mov	es:[esi], ebx
       .if	esi EQ edi, then_goto <short CP4>
	inc	esi
	inc	esi
       .smov	ecx, <_gfx .min_x>
       .smov	edx, <_gfx .max_x>
	mov	eax, es:[esi+2*INT_SZ]
	mov	ebx, es:[esi]
       .if	eax LT ebx, then_goto <short CP1>
	xchg	eax, ebx
	jmp	CP1

CPERR:	xor	eax, eax
	jmp	CPBYE

CP4:   mov	eax, 1

CPBYE:
END_FCN

ELSE


    ; C Version

START_FCN _gfx_set_coor_pair < < DATA_PTR cpair > >
AUTO < <_int n_loops> >
PROLOGUE <SI, DI, ES>

       .smov	ecx, <_gfx .min_x>
       .smov	edx, <_gfx .max_x>
       .les	esi, cpair
	mov	byte ptr n_loops, 2
	xor	edi, edi

CP0:	mov	eax, es:[esi]
	mov	ebx, es:[esi+(INT_SZ*2)]
       .if	eax LT ebx, then_goto <short CP1>
	xchg	eax, ebx

CP1:   .if	eax GT edx, then_goto <short CP_ERR>
       .if	ebx LT ecx, then_goto <short CP_ERR>

       .if	eax GE ecx, then_goto <short CP2>
	mov	eax, ecx
	inc	edi
CP2:   .if	ebx LE edx, then_goto <short CP3>
	mov	ebx, edx
	inc	edi
CP3:	mov	es:[esi], eax
	mov	es:[esi+(INT_SZ*2)], ebx
	dec	byte ptr n_loops
	jz	short CPBYE
	add	esi, INT_SZ
	push	es
       .smov	ecx, <_gfx .min_y>
       .smov	edx, <_gfx .max_y>
	pop	es
	jmp	CP0

CP_ERR: mov	edi, 5
	jmp	CPBYE

CPBYE:	mov	eax, edi
END_FCN

ENDIF

;/*~ RCDLNPNT.ASM */

START_FCN _gfx_record_line_points < <_int,x>,<_int,y>,<_int,d>,<_int,_d1>,<_int,_d2>,<_int,step>,<_int,count>,<_int,dir>, <DATA_PTR _stack>, <_int stack_pos>, <_int elem_sz> >;
PROLOGUE <SI, DI, DS>

       .lds	ebx, _stack
	mov	eax, stack_pos
	mov	ecx, elem_sz
	mul	ecx
	add	ebx, eax
	mov	edx, ecx

	mov	eax, d
	mov	ecx, count
	mov	esi, x
	mov	edi, y
       .if	dir EQ 0, then_goto <short DEDOT2>

DEDOT1:	mov	[ebx], esi	    ; save x
	mov	[ebx+INT_SZ], edi   ; save y
	add	ebx, edx	    ; point to next record
	inc	edi		; y++

       .if	eax GE 0, then_goto <short DE10>
	add	eax, _d1
	loop	DEDOT1
	jmp	RXIT

DE10:	add	eax, _d2
	add	esi, step
	loop	DEDOT1
	jmp	RXIT


DEDOT2: mov	[ebx], esi	    ; save x
	mov	[ebx+INT_SZ], edi   ; save y
	add	ebx, edx	    ; point to next record
	inc	esi	      ; x++

       .if	eax GE 0, then_goto <short DE20>
	add	eax, _d1
	loop	DEDOT2
	jmp	RXIT

DE20:	add	eax, _d2
	add	edi, step
	loop	DEDOT2

RXIT:
END_FCN;


;/*~ _IDIV.ASM */

	;  _gfx_idiv divides one integer by another, rounding the remainder to
	;  the nearest whole value.

START_FCN _gfx_idiv < <_int, num>, <_int, denom> >;
PROLOGUE;

	mov	ebx, denom
	mov	eax, num
	xor	edx, edx
	div	ebx
	shl	edx, 1
       .if	edx LT ebx, then_goto <short MZ>
	inc	eax
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
	lea	ebx, get_pel_jmp_table
	mov	dword ptr[ebx],   offset CS_LBL:MRES_
	mov	dword ptr[ebx+2], offset CS_LBL:HRES_
	mov	dword ptr[ebx+4], offset CS_LBL:ERES_
	mov	dword ptr[ebx+6], offset CS_LBL:C256_
EOTP5:
ENDIF
	mov	ecx, x
	mov	eax, y
        mov	bl, FCN_GET_PEL
       .call	_00xy_to_ram
	mov	eax, -1			  ; out of bounds==> -1
	jc	short XITR
	jmp	dword ptr DS_LBL:get_pel_jmp_table[ebx]

HRES_:	mov	ecx, 7			  ; HIGH RES
	and	edi, 7
	sub	ecx, edi
	mov	ah, 1
	jmp	short R_PIX

MRES_:	mov	ecx, 3			  ; MEDIUM RES
	and	edi, 3
	sub	ecx, edi
	shl	ecx, 1
	mov	ah, 3

R_PIX: .smov	ds, <_gfx .screen_base>   ; GET CGA CARD PEL
	lodsb				  ; get the byte
	shr	al, cl			  ; shift pel to low bits
	and	al, ah			  ; mask out high bits
	and	eax, 0FH		  ; zero out all high bits
	jmp	short XITR		  ; got it ==> bye

ERES_:	.call	_gfx_clean_up_ega
	mov	edx, GRAPH_ADDR		  ; read one plane at a time
	mov	al, G_READ_MAP
	out	dx, al
	inc	edx
	mov	al, 3			  ; read planes 3-2-1-0

       .smov	ds, <_gfx .screen_base>   ; load screen segment
	mov	ecx, edi		  ; get pel # in byte
	and	ecx, 7
	xor	ebx, ebx		  ; bh will hold the color

E0:	out	dx, al			  ; specify plane to read
	mov	bl, [esi]		  ; read the byte
	shl	bl, cl			  ; rotate bit in bl's sign bit
	shl	ebx, 1			  ; build the color in bh
	dec	al			  ; get ready for next plane
	jns	short E0
					  ; clean up by pointing
	dec	edx			  ; to 'bitmask' register
	mov	al, G_BITMASK
	out	dx, al
					  ; return color in eax
	xor	eax, eax
	mov	al, bh
	jmp	short XITR

C256_: .smov	ds, <_gfx .screen_base>   ; get 256 color pixel
	xor	eax, eax
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

	sub	eax, eax
	mov	ecx, arr_len	; load arr_len
	mov	edx, ecx	; save for later
	jecxz	short RTN	; check for a find of 0 bytes

       .les	edi, array	; load address of array to be searched
	mov	al, _c		; load character to be matched in array

repnz scasb			; search a byte at a time

	mov	eax, edx	; assume no match, and return arr_len
	jne	short RTN
	sub	eax, ecx	; if match, return its index
	dec	eax
RTN:

END_FCN;

;/*~ CALL_DOS.ASM */

	;  _gfx_call_dos is a simple function designed for DOS calls that
	;  only need to use the AX and DX registers.

START_FCN _gfx_call_dos, < <_int, fcn_n>, <_int, val> >;
PROLOGUE
	mov	ah, fcn_n;
	mov	edx, val;
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


START_FCN _gfx_far_move
END_FCN NO_RET


START_FCN _gfx_move < <DATA_PTR from>, <DATA_PTR to>, <_int, n_bytes> >
PROLOGUE <SI, DI, ES, DS>;

SM0:
SM1:	cld
       .lds	esi, from
       .les	edi, to
	mov	ecx, n_bytes

MB2:	push	ecx
	shr	ecx, 2
rep	movsd
	pop	ecx
	and	ecx, 3
rep	movsb

MB3:
END_FCN;


;/*~ RWSCRNTX.ASM */

ODD EQU 1

	; _gfx_rw_screen_text can read/write a line of data when in text mode.

IFNDEF TURBO_PASCAL
START_FCN _gfx_rw_screen_text, < <_int, x>, <_int, y>, <DATA_PTR, tp>, <_int, n_words>, <CHAR, to_screen> >;
PROLOGUE <SI, DI, ES, DS>;

	mov	ecx, n_words		  ; # of words to move
	jecxz	short W2
	cld
	mov	edi, x		  ; calculate screen buffer address
	dec	edi
	shl	edi, 1
	mov	eax, y
	dec	eax
       .smov	bl, <CHAR _gfx .bytes_per_row>
	shl	bl, 1
	mul	bl
	add	edi, eax
	xor	ebx, ebx
       .smov	es, <_gfx .screen_base>
	xor	eax, eax
	mov	ax, es
       .if	eax LT 0B800H, then_goto <short W00>
	inc	ebx	       ; mark possible CGA card
	mov	edx,	3DAh	       ; load status port address of 6845

W00:   .lds	esi, tp

       .if	to_screen EQ YES, then_goto <short W0>
	xchg	esi, edi
	push	ds
	push	es
	pop	ds
	pop	es

W0:    .if	ebx EQ YES, then_goto <short W1>
		; special handling for CGA snow
WLO:	in	al, dx			; wait for proper gfx status
       .if	ODD bit_is_on_in al, then_goto <short WLO>

WHIGH:	in	al, dx
       .if	ODD bit_is_off_in al, then_goto <short WHIGH>

W1:	movsw				; write the character/attribute
	loop	W0			; loop to next character

W2:	mov	eax, n_words		  ; return the # of words moved

END_FCN;

ENDIF


;/*~ LOSTRTCH.ASM */

START_FCN _gfx_xpand_bits < <FAR_PTR src_buf>, <FAR_PTR dest_buf>, <_INT swath>, <_INT src_len>, <_INT dest_len>, <_INT bits> >
AUTO < <_INT orig_swath>, <_INT n_planes> >
PROLOGUE <SI, DI, ES, DS>

	mov	dword ptr n_planes, 0
       .if	src_len EQ 0, then_goto <short CPX>
	mov	dword ptr n_planes, 4
CPX:	cld
       .lds	esi, src_buf
       .les	edi, dest_buf
	mov	ebx, esi
	add	ebx, swath
	xor	ecx, ecx
       .if	bits EQ 8, then_goto <short CP40>

				;  Expand 1-bit string
	mov	orig_swath, ebx
	mov	ch, 8
CP00:	mov	dl, 9
	mov	dh, [esi]
	inc	esi
CP01:	dec	dl
	jz	short CP00
CP02:	mov	cl, [ebx]
	inc	ebx
	or	cl, cl
	js	short CP30

CP10:	mov	ah, 0
	shl	dh, 1
	sbb	ah, 0
	cwde
	rol	eax, cl
	sub	ch, cl
	jg	short CP01
	mov	cl, 0
	jz	short CP20
	mov	cl, ch
	neg	cl
	ror	eax, cl
CP20:	stosb
	mov	ch, 8
	sub	ch, cl
	rol	eax, cl
	jmp	short CP01

CP30:	mov	cl, ch
	shl	eax, cl
	stosb
	dec	dword ptr n_planes
	jz	short CPBYE
	mov	esi, src_buf
	add	esi, src_len
	mov	src_buf, esi
	mov	edi, dest_buf
	add	edi, dest_len
	mov	dest_buf, edi
	mov	ebx, orig_swath
	mov	ch, 8
	jmp	short CP00
			;  Expand 8-bit string

CP40:	mov	cl, [ebx]
	inc	ebx
	lodsb
       .if	cl EQ 0FFH, then_goto <short CPBYE>
rep	stosb
	jmp	short CP40

CPBYE:
END_FCN


START_FCN _gfx_set_swath < <FAR_PTR swath_buf>, <_INT n_stretch_dots>, <_INT n_orig_dots>, <_INT lead_pad> >
PROLOGUE <SI, DI, DS>

	cld
       .les	edi, swath_buf
	mov	ecx, lead_pad
	mov	eax, 1
rep	stosb
	mov	ecx, n_orig_dots
	xor	eax, eax
rep	stosb
       .lds	esi, swath_buf
	add	esi, lead_pad
	xor	edx, edx
	mov	eax, n_orig_dots
	mov	ecx, n_stretch_dots
	div	ecx
	mov	edi, eax
	div	ecx
	jz	short FP00
	shl	edx, 1
	adc	eax, 0
FP00:	xor	edx, edx
	xor	ebx, ebx
	jmp	short FP1

FP0:	add	edx, eax
	adc	ebx, edi
FP1:	inc	byte ptr [esi+ebx]
	loop	FP0

	mov	edi, esi
	add	esi, ebx
	add	edi, n_orig_dots
	dec	edi
FP2:	cmp	esi, edi
	je	short FPBYE
	jb	short FP3
	mov	al, [esi]
	add	[edi], al
	dec	esi
	jmp	short FP2
FP3:	mov	al, [esi]
	dec	si
       .if	al EQ 0, then_goto <short FP3>
	dec	byte ptr [esi+1]
	inc	byte ptr [edi]

FPBYE:	mov	byte ptr [edi+1], 0FFH

END_FCN



;/*~ SHFTBLOK.ASM */

IFNDEF ASSEMBLE_WHOLE_FILE
EXTERN _INT <NEAR _gfx_chip_type>
EXTERN FCN $SMV
ENDIF

.386

START_FCN  _gfx_shift_block, < <FAR_PTR, inbuf>, <FAR_PTR, outbuf>, <_int, n_bytes>, <_int, shift_n_bits> >;
PROLOGUE <SI, DI, DS, ES>;

	mov	ecx, shift_n_bits
       .if	ecx NE 0, then_goto <short SB0>
	jmp	$SMV
SB0:	cld
;	.smov	eax, _gfx_chip_type
	.lds	esi, inbuf
	.les	edi, outbuf
	mov	ebx, n_bytes

;IFNDEF USE_386
;	.if	ax GE 386, then_goto <short SHIFT386>
       .if	cx LT 0, then_goto <short SL0>
	xor	edx, edx
	xor	eax, eax
SR1:	lodsb					; shift bits to right
	mov	ah, dl
	mov	dl, al
	shr	eax, cl
	stosb
	dec	ebx
	jnz	SR1
	jmp	short SHIFTBLOCKBYE

SL0:	neg	ecx				; shift bits to left
	mov	dl, [esi]
	inc	esi
	dec	ebx
	jz	short SL1A
SL1:	lodsb
	mov	ah, dl
	mov	dl, al
	shl	eax, cl
	mov	al, ah
	stosb
	dec	ebx
	jnz	SL1
SL1A:	mov	al, dl
	shl	eax, cl
	stosb
;	 jmp	SHIFTBLOCKBYE
; ENDIF

comment @

SHIFT386:				; version for 386 chip
       .if	ecx LT 0, then_goto <short SL0A>
	xor	edx, edx

SR00:	lodsd
	xchg	ah, al
	rol	eax, 16
	xchg	ah, al
	shrd	dx, ax, 8
	shrd	eax, edx, cl
	xchg	ah, al
	rol	eax, 16
	xchg	ah, al
	sub	ebx, 4
	jle	short SX10
	stosd
	jmp	short SR00

SL0A:	neg	ecx
SL00:	lodsd
	xchg	ah, al
	rol	eax, 16
	xchg	ah, al
	mov	edx, [esi+1]
	shld	eax, edx, cl
	xchg	ah, al
	rol	eax, 16
	xchg	ah, al
	sub	ebx, 4
	jle	short SX10
	stosd
	jmp	short SL00

SX10:	jnz	short SX11
	stosd
	jmp	short SHIFTBLOCKBYE

SX11:	mov	ecx, ebx
	add	ecx, 4
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
       .les	edi, xpand_buf
       .lds	esi, pcx_buf
	mov	ebx, xlat_x_bytes
	xor	eax, eax
       .if	ebx EQ 0, then_goto <short GBYE>
	mov	ax, n_planes
       .if	ax LE 1, then_goto <short G1>
       .if	ax LE 4, then_goto <short G0A>
	mov	dword ptr n_planes, 4
G0A:	mul	bx
	mov	bx, ax
	add	edi, 12

G1:	lodsb
	mov	ah, al
	and	ah, 0C0H

       .if	ah EQ 0C0H, then_goto <short G2>	; EXPAND SINGLE BYTE
	stosb
	dec	ebx
	jnz	short G1
	jmp	short G3

G2:	mov	ecx, eax			    ; EXPAND MULTIPLE BYTES
	and	ecx, 3FH
	sub	ebx, ecx
	lodsb
	mov	ah, al
	shr	ecx, 1
rep	stosw
	jnc	short G20
	stosb

G20:   .if	ebx GT 0,  then_goto <short G1>

G3:	mov	eax, esi
	sub	eax, pcx_buf
	mov	ebx, n_planes
	dec	ebx
	jle	short GBYE
	push	eax
       .lds	esi, xpand_buf
	mov	edi, esi
	add	esi, 12
	mov	dx, xlat_x_bytes

G30:	mov	cx, dx
	shr	cx, 1
rep	movsw
	jnc	short G31
	movsb
G31:	add	edi, 4
	dec	ebx
	jnz	G30
	pop	eax
GBYE:

END_FCN


START_FCN _gfx_pcx_count_rows < <FAR_PTR pcx_buf>, <_INT buf_size>, <_INT x_bytes>, <DATA_PTR max_y_rows>, <_INT n_planes> >
AUTO < <_INT next_row>, <_INT last_row> >
PROLOGUE <SI, DI, ES, DS>

	cld
       .les	esi, max_y_rows
	mov	ecx, es:[esi]
       .lds	esi, pcx_buf
	mov	next_row, esi
	mov	edi, esi
	add	edi, buf_size
	mov	eax, x_bytes
	mul	dword ptr n_planes
	mov	x_bytes, eax

POA:	mov	edx, x_bytes

POB:	lodsb
	mov	ah, al
	and	ah, 0C0H
       .if	ah NE 0C0H, then_goto <short POC>
	inc	esi
	and	eax, 3FH
	sub	edx, eax
	jg	short POB
	jmp	POD
POC:	dec	edx
	jnz	short POB

POD:   .if	esi AB edi, then_goto <short POBYE>
	mov	last_row, esi
	loop	POA

POBYE:	mov	esi, max_y_rows
	sub	es:[esi], ecx
	mov	eax, last_row
	sub	eax, pcx_buf

END_FCN



;/*~ PIC2PCX.ASM */

START_FCN _gfx_pcx_compress_row < <FAR_PTR xpand_buf>, <FAR_PTR pcx_buf>, <_INT xlat_x_bytes>, <_INT pad_byte>, <_INT n_planes> >
PROLOGUE <SI, DI, ES, DS>

	cld
	xor	eax, eax
	.lds	esi, pcx_buf
	.les	edi, xpand_buf
	mov	ebx, xlat_x_bytes
       .if	ebx EQ 0, then_goto <short JXBYE>

JX0:	mov	ecx, 3FH
	mov	al, es:[edi]
	inc	edi
repe	scasb
	dec	edi
	mov	edx, 3FH
	sub	edx, ecx
	sub	ebx, edx
	jns	short JX1
	add	edx, ebx
	add	edi, ebx
	xor	ebx, ebx
JX1:   .if	dl GT 1, then_goto <short JX2>
	mov	ah, al
	and	ah, 0C0H
       .if	ah NE 0C0H, then_goto <short JX3>

JX2:	or	dl, 0C0H
	mov	[esi], dl
	inc	esi
JX3:	mov	[esi], al
	inc	esi
JX4:   .if	ebx NE 0, then_goto <short JX0>
	mov	ebx, xlat_x_bytes
	add	edi, pad_byte
	dec	dword ptr n_planes
	jnz	short JX0

JXBYE:	mov	eax, esi
	sub	eax, pcx_buf

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
       .lds	esi, xpand_buf
       .les	edi, rle_buf
	xor	eax, eax
	mov	edx, xlat_x_bytes
       .if	edx GT 2, then_goto <short F1>
       .if	edx EQ 0, then_goto <short F0>
	jmp	F80A
F0:	jmp	FBYE

F1:	mov	al, [esi]
	mov	ah, al
       .if	ax NE [esi+1], then_goto <short F2>
F1A:	mov	bl, 80H
       .if	al NE 0, then_goto <short F10>
	mov	bl, 0H
F10:   .if	al NE 0FFH, then_goto <short F11>
	mov	bl, 40H
F11:	mov	ecx, edx
	xchg	esi, edi
repe	scasb
	jz	short F11A
	inc	ecx
	dec	edi
F11A:
	xchg	esi, edi
	jecxz	short F5
	jmp	short F4

F2:	mov	bl, 0C0H
	mov	ecx, edx
F30:	cmp	ax, [esi+1]
	je	short F32
	inc	esi
	mov	al, [esi]
	mov	ah, al
	loop	F30
	jmp	short F5
F32:   .if	ecx GT 2, then_goto <short F4>
	add	esi, ecx
	xor	ecx, ecx
	jmp	short F5

F4:	neg	ecx
	add	ecx, edx
	sub	edx, ecx

F5:    .if	ecx GE 20H, then_goto <short F6>
	mov	ch, cl
	or	ch, bl
	mov	es:[edi], ch
	inc	edi
	and	ecx, 1FH
	jnz	short F7
	xchg	ecx, edx
	jmp	short F7

F6:	or	ch, 20H
	or	ch, bl
	mov	es:[edi], ch
	inc	edi
	mov	es:[edi], cl
	inc	edi
	and	ecx, 1FFH

F7:	shl	bl, 1
	jnc	short F8
	shl	bl, 1
	jnc	short F70
	sub	esi, ecx
rep	movsb
	jmp	short F8
F70:	stosb

F8:    .if	edx LE 2, then_goto <short F80>
	jmp	F1
F80:   .if	edx EQ 0, then_goto <short F81>
F80A:	mov	byte ptr es:[edi], 0C0H
        inc	edi
        mov	ecx, edx
rep	movsb
F81:	dec	dword ptr n_planes
	jz	short FBYE
	mov	edx, xlat_x_bytes
	add	esi, pad_byte
       .if	edx LE 2, then_goto <short F80A>
	jmp	F1

FBYE:	mov	eax, edi
	sub	eax, rle_buf
END_FCN


START_FCN _gfx_rle_expand_row < <FAR_PTR xpand_buf>, <FAR_PTR rle_buf>, <_INT xlat_x_bytes>, <_INT pad_byte>, <_INT n_planes> >
PROLOGUE <SI, DI, ES, DS>

	cld
	xor	ecx, ecx
	.lds	esi, rle_buf
	.les	edi, xpand_buf
	jmp	short MPL1

MPLANE: add	edi, pad_byte
	dec	dword ptr n_planes
	jz	short M0BYE
MPL1:	mov	edx, xlat_x_bytes
	xor	ebx, ebx

M00:	sub	edx, ebx
	jle	short MPLANE
	lodsb
	mov	cl, al
	and	ecx, 3FH
	jz	short M0A
       .if	20H bit_is_on_in cl, then_goto <short M0B>

M01:	mov	ebx, ecx
	and	al, 0C0H
	jz	short M04
	jns	short M02
       .if	al NE 0C0H, then_goto <short M03>

	shr	ecx, 1
	jz	short M01A
rep	movsw
	jnc	short M00
M01A:	movsb
	jmp	M00

M02:	mov	al, 0FFH
	jmp	short M04
M03:	lodsb
M04:	shr	ecx, 1
	jz	short M04A
	mov	ah, al
rep	stosw
	jnc	short M00
M04A:	stosb
	jmp	M00


M0A:	mov	ecx, edx
	jmp	M01
M0B:	and	cl, 1FH
	mov	ch, cl
	mov	cl, [esi]
	inc	esi
	jmp	M01

M0BYE:	mov	eax, esi
	sub	eax, rle_buf

END_FCN


START_FCN _gfx_rle_count_rows < <FAR_PTR rle_buf>, <_INT buf_size>, <_INT x_bytes>, <DATA_PTR max_y_rows>, <_INT n_planes> >
AUTO < <_INT next_row>, <_INT n_rows> >
PROLOGUE <SI, DI, ES, DS>

	cld
       .les	esi, max_y_rows
	mov	ecx, es:[esi]
	mov	n_rows, ecx
	.lds	esi, rle_buf
	mov	next_row, esi
	mov	edi, esi
	add	edi, buf_size

R0A:	mov	ah, n_planes
R0B:	mov	edx, x_bytes
R0C:	lodsb
	mov	bl, al
	and	ebx, 3FH
	jnz	short R1
	mov	ebx, edx
	jmp	short R2
R1:    .if	20H bit_is_off_in bl, then_goto <short R2>
	and	bl, 1FH
	mov	bh, bl
	mov	bl, [esi]
	inc	esi
R2:	shl	al, 1
	jnc	short R3
	shl	al, 1
	jc	short R20
	inc	esi
	jmp	short R3
R20:	add	esi, ebx

R3:    .if	esi AB edi, then_goto <short R5>
	sub	edx, ebx
	jg	short R0C
	jl	short R4
	dec	ah
	jnz	short R0B
	mov	next_row, esi
	loop	R0A
	jmp	short R5

R4:	mov	ecx, n_rows
	inc	ecx

R5:	mov	esi, max_y_rows
	sub	es:[esi], ecx
	mov	eax, next_row
	sub	eax, rle_buf
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

CGA_BANKS equ 80000000H

COLOR_PLANES	equ	2 * INT_SZ
COLOR_256	equ	3 * INT_SZ

START_FCN _gfx_init_move_vid_line < <_INT x>, <_INT y> >
PROLOGUE <SI, DI>

	mov	ecx, x
	mov	eax, y
	mov	bl, FCN_INIT_MOVE_VID_LINE
       .if	eax GE 0, then_goto <short PM00>
	xor	eax, eax
PM00:  .call	_0xy_to_ram
       .smov	$next_tv_offset, esi
       .smov	$res_type, ebx
       .if	<_gfx .gfx_mode> NE 4, then_goto <short PM0A>
	mov	$res_type, 2
PM0A:	xor	eax, eax
       .smov	al, $256_page_n
       .smov	$tv_page, eax
	xor	eax, eax
       .if	<_gfx .last_video_row> AB 8000H, then_goto <short PM01>
	mov	eax, CGA_BANKS
PM01:  .smov	$card_flags, eax
       .smov	eax, <_gfx .bytes_per_row>
       .if	ebx GE COLOR_PLANES, then_goto <short PMBYE>
	mov	eax, 2000H
PMBYE: .smov	$next_line, eax

END_FCN


START_FCN _gfx_move_next_vid_line < <FAR_PTR buf>, <_INT show_x_bytes>, <_INT x_bytes>, <_INT masks>, <_INT action> >
AUTO < <_INT vid_buf>, <_INT next_plane>, <_INT skip_x_bytes>, <_INT res_type>, <_INT cpu>, <_INT ml_offset>, <_INT maskbits>, <_INT sbase>, <_INT pg256> >
PROLOGUE <SI, DI, ES, DS>

       .smov	eax, $next_tv_offset
	mov	vid_buf, eax		 ; save video buffer offset
       .smov	ebx, $next_line
	add	ax, bx
	jc	short PQA
       .sdo	test $card_flags, CGA_BANKS+1
	jz	short PQ0
	jns	short PQB
       .smov	ebx, <_gfx .last_video_row>
       .if	eax BL ebx, then_goto <short PQ0>
	sub	eax, ebx
	jmp	short PQ0
PQA:   .sdo	or $card_flags, 1H
       .sinc	$tv_page
	jmp	short PQ0
PQB:   .smov	$card_flags, 0
	push	eax
       .smov	eax, $tv_page
       .call	_0new_256_page
	pop	eax

PQ0:   .smov	$next_tv_offset, eax
	cld
	mov	esi, vid_buf
	mov	ecx, show_x_bytes	 ; load # of bytes to be moved
       .smov	eax, $res_type
	mov	edx, eax
	mov	res_type, eax
	mov	eax, x_bytes
	sub	eax, show_x_bytes
	mov	skip_x_bytes, eax
	xor	eax, eax
	mov	ml_offset, eax
	mov	pg256, eax
       .smov	ebx, <_gfx .screen_base>

	mov	eax, action
	cmp	al, 1
	je	short PQWW
	jl	short PQR0
	mov	dword ptr next_plane, 1
	mov	sbase, ebx
	mov	eax, _gfx_chip_type
	mov	cpu, eax
       .if	dl NE COLOR_256, then_goto <short PQX0>
	mov	eax, show_x_bytes
	jmp	short PQX1
PQWW:	jmp	PQW0
PQX0:	mov	eax, x_bytes
	shl	eax, 1
       .if	dl NE COLOR_PLANES, then_goto <short PQX1>
	shl	eax, 1
	mov	dword ptr next_plane, 4
PQX1:	mov	ml_offset, eax
       .if	action NE 5, then_goto <short PQR0>
	mov	edi, buf
	add	edi, eax
	mov	maskbits, edi
	add	eax, x_bytes
	mov	ml_offset, eax

				; ****************** READ LINE
PQR0:	.les	edi, buf
	add	edi, ml_offset
	mov	ds, bx
	xor	ebx, ebx
	xor	edx, edx
	mov	ecx, x_bytes
       .if	res_type EQ COLOR_PLANES, then_goto <short PQR2>
       .if	res_type NE COLOR_256, then_goto <short PQREAD>

	mov	eax, vid_buf		; 256-color
	add	ax, cx
	jnc	short PQREAD
	movzx	eax, ax
	mov	ebx, eax
	sub	ecx, eax
	jmp	short PQREAD

PQR2:	mov	edx, GRAPH_ADDR		; set for reading from ega/vga buf
	mov	al, G_READ_MAP
	out	dx, al
	inc	edx
PQR2A:	mov	al, bl			; rotate to read next plane
	out	dx, al
	mov	esi, vid_buf
	mov	ecx, x_bytes

PQREAD:	shr	ecx, 1
rep	movsw
	jnc	short PQR3
	movsb

PQR3:  .if	edx EQ 0, then_goto <short PQR4A>
	add	esi, skip_x_bytes
	inc	ebx
       .if	bl LT 4, then_goto <short PQR2A>
	jmp	short PQR5

PQR4:  .call	_DSnext_256_page
	inc	dword ptr pg256
	mov	ecx, ebx
	xor	ebx, ebx
	mov	esi, vid_buf
	xor	si, si
	jmp	short PQREAD
PQXIT:	jmp	PQEXIT
PQR4A: .if	ebx NE 0, then_goto <short PQR4>

PQR5:  .if	action EQ 0, then_goto <short PQXIT>

				;*************** MODIFY LINE
	.lds	edi, buf
	mov	esi, edi
	add	esi, ml_offset
	mov	ml_offset, esi

	xor	eax, eax
	mov	al, action
       .if	eax EQ 5, then_goto <short AMATTE>
	mov	ecx, x_bytes
       .if	next_plane LE 1, then_goto <short ML0>
        shl	ecx, 3
ML0:	shr	ecx, 1
	sub	eax, 3
	mov	eax, 0
	jz	short AOR
	jg	short AXOR
	dec	eax

AAND:	lodsw			; action == 2  AND
	and	[edi], eax
	add	edi, 2
	loop	AAND
	jmp	ABYE

AOR:	lodsw			; action == 3  OR
	or	[edi], eax
	add	edi, 2
	loop	AOR
	jmp	ABYE

AXOR:	lodsw			; action == 4  XOR
	xor	[edi], eax
	add	edi, 2
	loop	AXOR
	jmp	short ABYE

AMATTE: .if	res_type EQ COLOR_256, then_goto <short A256MATTE>

A1PUT:	dec	dword ptr next_plane
	jl	short ABYE
	mov	ebx, maskbits	 ; action == 5	MATTE  (PUT w/ a mask)
	mov	ecx, x_bytes
	shr	ecx, 1
A2PUT:	lodsw
	mov	edx, [ebx]
	or	edx, 0FFFF0000H
	add	ebx, 2
	and	[edi], edx
	not	edx
	and	eax, edx
	or	[edi], eax
	add	edi, 2
	loop	A2PUT
	mov	ecx, x_bytes
	and	ecx, 1
	add	edi, ecx
	add	esi, ecx
	jmp	short A1PUT

A256MATTE:
	mov	ebx, x_bytes
	mov	al, masks
	mov	dword ptr masks, 0
AX0:	dec	ebx
	js	short ABYE
       .if	al NE [edi+ebx], then_goto <short AX0>
	mov	ah, [esi+ebx]
	mov	[edi+ebx], ah
	jmp	short AX0

ABYE:	mov	ebx, sbase
	mov	esi, vid_buf
       .if	pg256 EQ 0, then_goto <short PQW0>
       .call	_DSprev_256_page

				;*************** WRITE LINE
PQW0:	mov	es, bx
	mov	edi, esi
	.lds	esi, buf
	mov	eax, x_bytes
	mov	ecx, show_x_bytes
	sub	eax, ecx
	jle	short PQW2
	mov	dword ptr skip_x_bytes, eax

PQW2:  .if	res_type NE COLOR_PLANES, then_goto <short PQ5>
       .if	masks EQ 0, then_goto <short PQ30C>
	mov	edx, GRAPH_ADDR
	mov	al, G_READ_MAP
	out	dx, al
	inc	edx
	mov	ecx, 4
	mov	ebx, show_x_bytes
	dec	ebx
PQ30A:	mov	al, cl
	dec	al
	out	dx, al
	mov	ah, es:[edi]
	mov	al, es:[edi+ebx]
	push	eax
	loop	PQ30A

PQ30C:	mov	edx, SEQ_ADDR		; set for writing ega/vga buf
	mov	al, S_MAP
	out	dx, al
	inc	edx
	mov	bl, 11H
	mov	dword ptr next_plane, offset CS_LBL:PQ30D

PQ30D:	mov	al, bl			; rotate to write to next plane
	out	dx, al
	mov	edi, vid_buf
	mov	ecx, show_x_bytes
	shl	bl, 1
	jnc	short PQ8

PQ32:	xor	edx, edx
	xor	ebx, ebx
	jmp	short PQ8

PQ5:	xor	ebx, ebx
	xor	edx, edx
       .if	res_type NE COLOR_256 then_goto <short PQ7>

	mov	eax, vid_buf				; 256-color
	add	ax, cx
	jnc	short PQ81
	movzx	eax, ax
	mov	ebx, eax
	sub	ecx, eax
	jmp	short PQ81

PQ7:   .if	masks EQ 0, then_goto <short PQ81>		; mono-plane bitmap
	xchg	ebx, show_x_bytes
	dec	ebx
	mov	ah, es:[edi]
	mov	al, es:[edi+ebx]
	jmp	short PQ80A

PQ8:   .if	masks EQ 0, then_goto <short PQ81>
	xchg	ebx, show_x_bytes
	dec	ebx
	pop	eax
PQ80A:	mov	ecx, masks
	and	eax, ecx
	not	ecx
	and	[esi], ch
	or	[esi], ah
	and	[esi+ebx], cl
	or	[esi+ebx], al
	inc	ebx
	mov	ecx, ebx
	xchg	ebx, show_x_bytes

PQ81:	shr	ecx, 1
rep	movsw
PQ9:	jnc	short PQ10
	movsb

PQ10:  .if	edx EQ 0, then_goto <short PQ11>
	add	esi, skip_x_bytes
	jmp	dword ptr next_plane

PQ11:  .if	ebx EQ 0, then_goto <short PQEXIT>
       .call	_ESnext_256_page
	mov	ecx, ebx
	xor	ebx, ebx
	xor	edx, edx
	mov	edi, vid_buf
	xor	di, di
	jmp	PQ81
PQEXIT:

END_FCN


START_FCN _gfx_xlat_256_colors < <FAR_PTR cdata>, <FAR_PTR cmap>, <_INT n_bytes> >
PROLOGUE <DI, ES, DS>
	cld
       .les	edi, cdata
       .lds	ebx, cmap
	mov	ecx, n_bytes
        shr	ecx, 2
	jz	short VC1

VC0:	mov	eax, es:[edi]
	xlatb
	xchg	ah, al
	xlatb
	xchg	ah, al
	stosw
	mov	eax, es:[edi]
	xlatb
	xchg	ah, al
	xlatb
	xchg	ah, al
	stosw
	loop	short VC0

VC1:	mov	ecx, n_bytes
	and	ecx, 3
	jz	short VCBYE

VC2:	mov	al, es:[edi]
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
	.lds	esi, src_buf
	.les	edi, dest_ptr
	mov	ecx, len
	mov	ebx, ecx
	mov	edx, base_color

	cmp	dword ptr _type, 2
	je	short MXA4
	jg	short MXB00
	or	edx, 10H
					; mono -> 16 colors
MXA1:	mov	esi, src_buf
	mov	ecx, len
	shr	edx, 1
	jz	short MXXBYE
	jnc	short MXA2
	shr	ecx, 1
rep	movsw
	jnc	short MXA1
	movsb
	jmp	short MXA1
MXA2:	xor	eax, eax
	shr	ecx, 1
rep	stosw
	jnc	short MXA1
	stosb
	jmp	short MXA1

					; mono -> 256 colors
MXA4:	lodsb
	mov	ah, al
	mov	ecx, 8
MXA40:	mov	al, 0
	shl	ah, 1
	jnc	short MXA41
	mov	al, dl
MXA41:	stosb
	loop	short MXA40
	dec	ebx
	jnz	MXA4
MXXBYE:	jmp	MXBYE

					; 16 -> 256 colors
MXB00:	mov	eax, len
	mov	_type, eax
MXB0:	mov	cl, [esi]
	mov	ebx, len
	mov	ch, [esi+ebx]
	add	ebx, ebx
	mov	dl, [esi+ebx]
	add	bx, len
	mov	dh, [esi+ebx]
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
	dec	dword ptr _type
	jnz	short MXB0
	jmp	short MXBYE


MXC01:	mov	ah, 1

MXC02:	shl	ecx, 1
	shl	edx, 1
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
	mov	es:[edi], cl
	mov	es:[edi+ebx], ch
	mov	eax, ebx
	add	ebx, ebx
	mov	es:[edi+ebx], dl
	add	ebx, eax
	mov	es:[edi+ebx], dh
	mov	ebx, eax
	inc	edi
	sub	dword ptr len, 8
	jg	short MXC01

MXBYE:

END_FCN


;/*~ BLD16MSK.ASM */

START_FCN _gfx_build_16_mask < <FAR_PTR src_buf>, <FAR_PTR mask_buf>, <_INT len>, <_INT color> >
AUTO < <_INT plane_1>, <_INT plane_2>, <_INT plane_3>, <_INT plane_4> >
PROLOGUE <SI, DI, ES, DS>

	.lds	esi, src_buf
	.les	edi, mask_buf
	mov	ecx, len
	mov	ebx, ecx
	mov	edx, color
	cld

       .if	edx NE 0, then_goto <short BZ2B>
	mov	edx, ecx
	shr	ecx, 1
BZ2A:	mov	eax, [esi]			; mask for color zero
	mov	ebx, edx
	or	eax, [esi+ebx]
	add	ebx, edx
	or	eax, [esi+ebx]
	add	ebx, edx
	or	eax, [esi+ebx]
	stosw
	add	esi, 2
	loop	BZ2A
	jmp	short BZEND

BZ2B:	xor	eax, eax			; mask for any color
	mov	dword ptr plane_1, eax
	shr	edx, 1
	sbb	dword ptr plane_1, eax
	mov	dword ptr plane_2, eax
	shr	edx, 1
	sbb	dword ptr plane_2, eax
	mov	dword ptr plane_3, eax
	shr	edx, 1
	sbb	dword ptr plane_3, eax
	mov	dword ptr plane_4, eax
	shr	edx, 1
	sbb	dword ptr plane_4, eax
	shr	ecx, 1

BZ2C:	mov	eax, [esi]
	xor	eax, plane_1
	mov	ebx, len
	mov	edx, [esi+ebx]
	xor	edx, plane_2
	or	eax, edx
	add	ebx, ebx
	mov	edx, [esi+ebx]
	xor	edx, plane_3
	or	eax, edx
	add	ebx, len
	mov	edx, [esi+ebx]
	xor	edx, plane_4
	or	eax, edx
	stosw
	add	esi, 2
	loop	BZ2C

BZEND:
END_FCN




;/*~ REVBLOCK.ASM */

	; _gfx_reverse_block is used to complement all the bytes in an array.

START_FCN _gfx_reverse_block < <DATA_PTR block>, <_INT, n_bytes> >
PROLOGUE <L_DS>
	mov	ecx, n_bytes
	jecxz	short Q2
       .lds	ebx, block
Q1:	not	byte ptr [ebx]
	inc	ebx
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
XZ1:	mov	edx, GRAPH_ADDR
	mov	al, G_DATA_ROT
	out	dx, al
	mov	al, mod_type
	and	al, 3
        shl	al, 3
	inc	edx
	out	dx, al
	dec	edx

	mov	al, G_BITMASK  ; set all bits in the bitmask ON
	out	dx, al
	inc	edx
	mov	al, 0FFH
	out	dx, al

END_FCN;


;/*~ GFXLPEEK.ASM */

IFNDEF TURBO_PASCAL
START_FCN _gfx_lpeek < <FAR_PTR, mem_ptr> >
PROLOGUE <ES>

      .les	ebx, mem_ptr
       xor	eax, eax
       mov	al, es:[ebx]

END_FCN;
ENDIF

;/*~ CHKCRSRR.ASM */

START_FCN _gfx_check_crsr_reg < <_INT, port_n> >
PROLOGUE

	mov	edx, port_n
	mov	al, 0FH
	out	dx, al
	inc	edx
	in	al, dx
	mov	bl, al
	mov	al, 5AH
	out	dx, al
	mov	ecx, 4
Z1:	dec	ecx
	jnz	short Z1
	in	al, dx
	.if	al NE 5AH, then_goto <short Z2>
	inc	ecx
Z2:	mov	al, bl
	out	dx, al
	mov	eax, ecx

END_FCN;

;/*~ CHKHERC.ASM */

	; _gfx_check_hercules_card checks for the presence of a Hercules card.

START_FCN _gfx_check_hercules_card
	mov	edx, 3BAH
	in	al, dx
	and	al, 80H
	mov	ah, al

	mov	ecx, 8000H
XX1:	in	al, dx
	and	al, 80H
	cmp	ah, al
	loope	XX1

	mov	eax, 0
	je	short XX2
	inc	eax
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
       .lds	ebx, pattern		  ; address of bit pattern
       .les	edi, new_pattern	  ; destination buffer
	mov	ecx, n_bytes		  ; length of bit pattern

O1:	mov	eax, 8000H		  ; set marker
	mov	dl, [ebx]		  ; read bit pattern byte
	inc	ebx			  ; point to next byte
O2:	shr	dl, 1			; loop through the bits
	rcr	eax, 1		  ; constructing a double bit pattern
	sar	eax, 1
	jnc	short O2
	shr	eax, 16
	xchg	ah, al			; when done, write out the new pattern
	not	eax
	stosw
	loop	O1			; loop for next byte

END_FCN


;/*~ ROLBITS.ASM */

	; _gfx_rol does a rotate left of a value and returns it.

START_FCN _gfx_rol < <_INT, val>, <_INT, n_bits> >
PROLOGUE;
	mov	eax, val
	mov	ecx, n_bits
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
	lea	ebx, jmp_table
	mov	dword ptr[ebx],   offset CS_LBL:DM00
	mov	dword ptr[ebx+2], offset CS_LBL:DH00
	mov	dword ptr[ebx+4], offset CS_LBL:DE00
	mov	dword ptr[ebx+6], offset CS_LBL:D256
EOTP7:
ENDIF
	mov	ecx, x
	mov	eax, y
	mov	bl, FCN_ASM_PAT_HLINE
       .call	_0xy_to_ram

       .smov	ecx, <_gfx .color_flags>
	mov	ah, color
	mov	color, ecx
	mov	ecx, line_len
	mov	edi, esi
	mov	edx, pat_len
       .smov	es, <_gfx .screen_base>
	jmp	dword ptr DS_LBL:jmp_table[ebx]

DM00:  .lds	esi, pat_ptr
	shl	edx, 1
	add	esi, edx
	neg	edx
	mov	ebx, init_offset	  ; CGA Medium Res
	add	ebx, edx
	mov	ch, lmask
       .if	XOR_PEL bit_is_on_in color, then_goto <short DXM00>

DM01:	mov	al, [esi+ebx]
	or	al, ch
	and	es:[edi], al
	not	al
	and	al, ah
	not	ch
	and	al, ch
	or	es:[edi], al
	inc	edi
	inc	ebx
	jnz	short DM02
	mov	ebx, edx
DM02:	mov	ch, 0
	dec	cl
	jg	short DM01
	js	short DMXIT
	mov	ch, rmask
	jmp	DM01

DXM00:	not	ch
DXM01:	mov	al, [esi+ebx]
	not	al
	and	al, ah
	and	al, ch
	xor	es:[edi], al
	inc	edi
	inc	ebx
	jnz	short DXM02
	mov	ebx, edx
DXM02:	mov	ch, 0FFH
	dec	cl
	jg	short DXM01
	js	short DMXIT
	mov	ch, rmask
	jmp	DXM00
DMXIT:	jmp	DXIT

DH00:	mov	ebx, init_offset	  ; CGA Hi Res
       .lds	esi, pat_ptr
	add	esi, edx
	neg	edx
	add	ebx, edx
       .if	XOR_PEL bit_is_on_in color, then_goto <short DXH00>
	mov	al, lmask

DH01:	and	al, [esi+ebx]
       .if	ah NE 0, then_goto <short DH02>
	not	al
	and	es:[edi], al
	jmp	DH03
DH02:	or	es:[edi], al
DH03:	inc	edi
	inc	ebx
	jnz	short DH04
	mov	ebx, edx
DH04:	mov	al, 0FFH
	dec	ecx
	jg	short DH01
	js	short DXIT
	mov	al, rmask
	jmp	DH01

DXH00:	mov	al, lmask
DXH01:	and	al, [esi+ebx]
	xor	es:[edi], al
	inc	edi
	inc	ebx
	jnz	short DXH02
	mov	ebx, edx
DXH02:	mov	al, 0FFH
	dec	ecx
	jg	short DXH01
	js	short DXIT
	mov	al, rmask
	jmp	DXH01

DE00:	mov	ebx, init_offset	  ; EGA
       .lds	esi, pat_ptr
	add	esi, edx
	mov	edx, GRAPH_ADDR+1
	neg	dword ptr pat_len
	add	ebx, pat_len
	mov	al, lmask

DE01:	and	al, [esi+ebx]
	out	dx, al
	mov	al, es:[edi]		  ; prime the latches
	mov	es:[edi], ah
	inc	edi
	inc	ebx
	jnz	short DE02
	mov	ebx, pat_len
DE02:	mov	al, 0FFH
	dec	ecx
	jg	short DE01
	js	short DXIT
	mov	al, rmask
	jmp	DE01

DXIT:	jmp	DBYE

D256:	mov	ebx, ecx				; ebx = line_len
       .lds	esi, pat_ptr
	add	edx, esi				; end_of_pat = esi + pat_len
	mov	end_of_pat, edx
	add	esi, init_offset
	lodsb
       .if	esi LT end_of_pat, then_goto <short D2A>
	mov	esi, pat_ptr
D2A:	mov	ecx, x
	and	ecx, 7
	mov	edx, ecx
	add	edx, ebx
       .if	edx GE 8, then_goto <short D2A1>
	xchg	edx, ebx
       .smov	bl, <_rbitmask [ebx]>
	and	al, bl
	mov	ebx, edx

D2A1:	jecxz	short D2A2
	shl	al, cl
	neg	cl
D2A2:	add	cl, 8
	sub	ebx, ecx
;      .smov	es, <_gfx .screen_base>
       .if	XOR_PEL bit_is_off_in color, then_goto <short D2F>
	jmp	short D2D

D2B:	lodsb
       .if	esi LT end_of_pat, then_goto <short D2C>
	mov	esi, pat_ptr
D2C:	mov	ecx, 8
	sub	ebx, ecx
	jns	short D2C0
	add	ecx, ebx
D2C0:	jmp	edx

D2D:	mov	edx, offset CS_LBL:D2E
D2E:	shl	al, 1
	jnc	short D2H
	xor	es:[edi], ah
	jmp	short D2H

D2F:	mov	edx, offset CS_LBL:D2G
D2G:	shl	al, 1
	jnc	short D2H
	mov	es:[edi], ah

D2H:	inc	di
	jz	short D2HB
D2HR:	dec	ecx
	jz	short D2I
	jmp	edx
D2HB:  .call	_ESnext_256_page
	jmp	D2HR
D2I:   .if	ebx GT 0, then_goto <short D2B>

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
	lea	ebx, vline_jmp_table
	mov	dword ptr[ebx],   offset CS_LBL:VMRES
	mov	dword ptr[ebx+2], offset CS_LBL:VHRES
	mov	dword ptr[ebx+4], offset CS_LBL:VERES
EOTP8:
ENDIF
	mov	ecx, x
	mov	eax, y
	mov	bl, FCN_ASM_VLINE
       .call	_0xy_to_ram
	and	edi, 7
	mov	ecx, len
	jmp	dword ptr DS_LBL:vline_jmp_table[ebx]

VHRES:	mov	ebx, edi
       .smov	ah, <_0hi_res_pel_mask [ebx]>		; HIGH RES
	mov	bl, color
       .smov	al, <_0hi_res_color_mask [ebx]>
	jmp	short VW_PIX

VMRES:	mov	ebx, edi
	and	ebx, 3			  ; MEDIUM RES
       .smov	ah, <_0med_res_pel_mask [ebx]>
	mov	bl, color
       .smov	al, <_0med_res_color_mask [ebx]>

VW_PIX: and	al, ah				; SET CGA CARD PEL
	not	ah
       .smov	edx, <_gfx .last_video_row>
       .smov	edi, <_gfx .color_flags>
       .smov	es, <_gfx .screen_base>
	lea	ebx, CS_LBL:V0_PIX
       .if	XOR_PEL bit_is_off_in edi, then_goto <short V0_PIX>
	lea	ebx, CS_LBL:VX_PIX

VX_PIX:	xor	es:[esi], al
	jmp	short V0APIX
V0_PIX: and	es:[esi], ah	      ; put pel
	or	es:[esi], al
V0APIX: add	esi, 2000H		  ; next row
       .if	esi BE edx, then_goto <short V1_PIX>	; check for wrap around
	sub	esi, edx
V1_PIX: dec	ecx
	jz	short eVXIT
	jmp	ebx

VERES:	mov	ebx, edi		; ENHANCED RES
	mov	edx, GRAPH_ADDR
	mov	al, G_BITMASK
	out	dx, al
       .smov	al, <_0hi_res_pel_mask [ebx]>
	inc	edx
	out	dx, al
	mov	al, color
       .smov	edx, <_gfx .bytes_per_row>
       .smov	es, <_gfx .screen_base>

VX0:	mov	ah, es:[esi]
	mov	es:[esi], al
	add	si, dx
	jc	short VX1B
VX1A:	loop	VX0
	sti
EVXIT:	jmp	short VXIT
VX1B:  .call	_ESnext_256_page
	jmp	short VX1A

V256:  .smov	edx, <_gfx .bytes_per_row>
       .smov	es, <_gfx .screen_base>
	mov	al, color
	lea	ebx, CS_LBL:V256A
       .if	XOR_PEL bit_is_off_in <_gfx .color_flags>, then_goto <short V256A>
	lea	ebx, CS_LBL:V256X

V256X:	xor	es:[esi], al
	jmp	short V256AA
V256A:	mov	es:[esi], al
V256AA:	add	si, dx
	jc	short V256B
V256A0: dec	ecx
	jz	short VXIT
	jmp	ebx
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
AUTO < <_int, start_esi>, <_int, start_di>, <_int, write_row>, <_int, next_row>, <_int, last_row>, <_int _386_scrn_offset> >
PROLOGUE <SI, DI, ES>;

IFDEF TURBO_PASCAL	    ; initialize TURBO PASCAL jump table
       .if  SetAsmHlineJmpTable EQ 1, then_goto <short EOTP9>
       .smov	SetAsmHlineJmpTable, 1
	lea	ebx, _asm_hline_jmp_table
	mov	dword ptr[ebx],   offset CS_LBL:$MED_RES_FASTLINE
	mov	dword ptr[ebx+2], offset CS_LBL:D1
	mov	dword ptr[ebx+4], offset CS_LBL:D0
EOTP9:
ENDIF
	mov	ecx, x
	mov	eax, y
	mov	bl, FCN_ASM_HLINE
       .call	_0xy_to_ram
	cld
       .if	bl NE 3*INT_SZ, then_goto <short D0A>
	jmp	M256
D0A:	xchg	edi, esi
	mov	ecx, n_pels
       .if	XOR_PEL bit_is_off_in <_gfx .color_flags>, then_goto <short D00>
	or	dl, _XOR_PELS
D00:   .if	n_rows EQ 1, then_goto <short START_DRAW>

	mov	start_esi, esi
	mov	start_di, edi
	mov	eax, 2000H
       .if	ebx LT 2*INT_SZ, then_goto <short D01>
       .smov	eax, <_gfx .bytes_per_row>
D01:	mov	next_row, eax
	mov	eax, DS_LBL:_asm_hline_jmp_table[ebx]
	mov	write_row, eax
       .smov	eax, <_gfx .last_video_row>
	mov	last_row, eax

START_DRAW:
	jmp	dword ptr DS_LBL:_asm_hline_jmp_table[ebx]

D0:	or	dl, 2			; mark as enhanced resolution card
	mov	dword ptr last_row, -1

D1:	mov	ebx, color
       .smov	dh, <_0hi_res_color_mask [ebx]>
	mov	ebx, esi
	and	ebx, 7
       .smov	ah, <_lbitmask [ebx]>
       .smov	es, <_gfx .screen_base>

D11:   .if	E_RES_CARD bit_is_off_in dl, then_goto <short D2>

	push	edx			    ; set partial for EGA card
	mov	edx, GRAPH_ADDR+1
	mov	al, ah
	out	dx, al
	pop	edx

	mov	al, color
	mov	ah, es:[edi]		  ; prime the latches
	stosb
	jmp	short D3

D2:	mov	al, dh			; set partial for HI RES
	and	al, ah

       .if	_XOR_PELS bit_is_off_in dl, then_goto <short D21>
	xor	es:[edi], al
	jmp	short D22

D21:	not	ah
	and	es:[edi], ah
	or	es:[edi], al

D22:	inc	edi
	mov	al, dh

D3:    .if	_2ND_PASS bit_is_on_in dl, then_goto <short DDONE>
	add	ecx, ebx
	sub	ecx, 8
	jle	short DDONE
       .if	ecx LT 8, then_goto <short D5>
       .if	E_RES_CARD bit_is_off_in dl, then_goto <short D4>
	or	ebx, ebx
	jz	short D4
	xor	ebx, ebx
	mov	ah, 0FFH
	jmp	D11

D4:	mov	ebx, ecx
        shr	ecx, 3
	jz	short D43

       .if	_XOR_PELS bit_is_off_in dl, then_goto <short D422>
       .if	E_RES_CARD bit_is_off_in dl, then_goto <short D421>
	mov	ah, al

D420:	mov	al, ah			; xor EGA
	xchg	es:[edi], al
	inc	edi

	loop	D420
	jmp	short D43

D421:	xor	es:[edi], al		  ; xor monochrome
	inc	edi
	loop	D421
	jmp	short D43

D422:	rep	stosb			; blast out the color

D43:	mov	ecx, ebx

D5:	mov	ebx, ecx
	and	ebx, 7
	jz	short DDONE
	or	dl, _2ND_PASS
       .smov	ah, <_rbitmask [ebx]>
       .lsmov	es, <_gfx .screen_base>
	jmp	D11

DDONE:	and	dl, NOT _2ND_PASS		; turn off 2nd Pass bit
	jmp	MDONE

$MED_RES_FASTLINE:
	mov	ebx, color
	and	ebx, 3
       .smov	dh, <_0med_res_color_mask [ebx]>
	mov	ebx, esi
	and	ebx, 3
	shl	ebx, 1
       .smov	ah, <_lbitmask [ebx]>
	shr	ebx, 1

	mov	al, dh
	and	al, ah
	not	ah
       .smov	es, <_gfx .screen_base>
       .if	_XOR_PELS bit_is_off_in dl, then_goto <short M00>
	xor	es:[edi], al
	jmp	short M0

M00:	and	es:[edi], ah
	or	es:[edi], al

M0:	inc	edi

	add	ecx, ebx
	sub	ecx, 4
	jle	short MDONE

	mov	ebx, ecx
        shr	ecx, 2
	jz	short M2
	mov	al, dh
	shr	ecx, 1
	jnc	short M1
       .if	_XOR_PELS bit_is_off_in dl, then_goto <short M01>
	xor	es:[edi], al
	inc	edi
	jmp	short M02
M01:	stosb
M02:	jecxz	short M2

M1:	mov	ah, dh

       .if	_XOR_PELS bit_is_off_in dl, then_goto <short M11>
M10:	mov	al, ah
	xor	es:[edi], ax
	add	edi, 2
	loop	M10
	jmp	short M2

M11:	rep	stosw

M2:	and	ebx, 3
	jz	short MDONE
	shl	ebx, 1
       .smov	ah, <_rbitmask [ebx]>
       .lsmov	es, <_gfx .screen_base>
	mov	al, dh
	and	al, ah
	not	ah

       .if	_XOR_PELS bit_is_off_in dl, then_goto <short M21>
	xor	es:[edi], al
	jmp	short MDONE

M21:	and	es:[edi], ah
	or	es:[edi], al

MDONE:	dec	dword ptr n_rows
	jz	short MD2
	mov	edi, start_di
	add	di, next_row
	jc	short MD10
       .if	last_row AB edi, then_goto <short MD1>
	sub	edi, last_row
MD1:	mov	start_di, edi
	mov	esi, start_esi
	mov	ecx, n_pels
	jmp	dword ptr write_row
MD10:  .call	_ESnext_256_page
	jmp	short MD1
MD2:	jmp	MMDONE

M256:	mov	al, color
	mov	ah, al
       .smov	edx, <_gfx .bytes_per_row>
	mov	next_row, edx
       .smov	ebx, <_gfx .color_flags>
       .smov	es, <_gfx .screen_base>
	mov	edx, offset CS_LBL:M256F
       .if	XOR_PEL bit_is_off_in ebx, then_goto <short M256K>
	mov	edx, offset CS_LBL:M256C
	jmp	short M256K

M256C:	shr	ecx, 1
	movzx	eax, ax
	jnc	short M256D0
	xor	es:[edi], al
	inc	edi
M256D0:	jcxz	short M256G
M256D:	xor	es:[edi], ax
	add	edi, 2
	loop	M256D
	jmp	short M256G

M256F:	shr	ecx, 1
rep	stosw
	jnc	short M256G
	stosb

M256G:	mov	ecx, ebx
	jecxz	short M256_NEXTLINE
	xor	ebx, ebx
	movzx	edi, di
       .sadd	edi, <_gfx .screen_offset>
       .call	_ESnext_256_page
	jmp	edx

M256_NEXTLINE:
	dec	dword ptr n_rows
	jz	short MMDONE
	dec	di
       .if	edi BE esi, then_goto <short M256K>
       .call	_ESnext_256_page
M256K:	mov	edi, esi
	add	si, next_row
M256L:	mov	ecx, n_pels
	mov	ebx, ecx
	add	bx, di
	jc	short M256M
	xor	ebx, ebx
	jmp	edx
M256M:	sub	cx, bx
	jmp	edx

MMDONE:

END_FCN;


;/*~ XINTCOOR.ASM */

	; _gfx_xlat_int_coor takes a value mutiplies it by mul_val, divides
	; the result with div_val, rounds to the nearer whole # and returns.

EXTERN _INT <NEAR _gfx_truncate_val>

START_FCN _gfx_xlat_int_coor < <_INT, val>, <_INT mul_val>, <_INT, div_val> >
PROLOGUE

	mov	eax, val	    ; load value to be scaled
	mov	ebx, div_val
       .if	ebx EQ mul_val, then_goto <short VBYE>
	imul	dword ptr mul_val   ; first multiply
	idiv	ebx		    ; now divide
       .if	_gfx_truncate_val NE 0, then_goto <short VBYE>
	shl	edx, 1		    ; get ready to round
	jnc	short XX0
	dec	edx		    ; round a negative number
	add	ebx, edx	    ; by using negative remainder in edx
	adc	eax, -1
	jmp	short VBYE
XX0:	inc	edx		    ; round a positive number
	sub	ebx, edx	    ; by using positive remainder in edx
	adc	eax, 0
VBYE:
END_FCN


;/*~ REFSHVID.ASM */

START_FCN _gfx_off_video_refresh
	mov	cl, 0
	jmp	short RV0
END_FCN NO_RET

START_FCN _gfx_on_video_refresh
	mov	cl, 1

RV0:	mov	edx, 03DAH
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
	mov	edx, 3DAH
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
	mov	ecx, new_address
	mov	edx, 3d4h
	mov	al, 0ch
	out	dx, al
	mov	al, ch		; the high address byte
	inc	edx
	out	dx, al
	dec	edx

	mov	al, 0dh 	 ; the low address byte
	out	dx, al
	inc	edx
	mov	al, cl
	out	dx, al

	sti			; enable interrupts

END_FCN

START_FCN _gfx_copy_video_page < <_INT scrn_base>, <_INT from>, <_INT to>, <_INT pg_size> >
PROLOGUE <SI, DI, ES, DS>

	cld
	mov	ecx, pg_size
	mov	eax, from
       .if	eax EQ to, then_goto <short S00>
	mul	ecx
	mov	esi, eax
	mov	eax, to
	mul	ecx
	mov	edi, eax
	mov	eax, scrn_base
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

       .lds	ebx, box_ptr
	mov	edx, _dx
	mov	esi, dy
	mov	cl, quad_mask
	mov	edi, 2

BX00:	mov	ch, 1
	xor	eax, eax
	jmp	short BX2

BX0:   .if	edx LT [ebx+_MIN_X] then_goto <short BX1>
       .if	edx GT [ebx+_MAX_X] then_goto <short BX1>
       .if	esi LT [ebx+_MIN_Y] then_goto <short BX1>
       .if	esi GT [ebx+_MAX_Y] then_goto <short BX1>
	or	al, ch

BX1:	add	ebx, COOR_SZ
	shl	ch, 1
BX2:	shr	cl, 1
	jc	short BX0
	jnz	short BX1

	dec	edi
	jz	short BX_BYE
	xor	al, inv_quad

       .if	clip_quad EQ 0, then_goto <short BX_BYE>
       .lds	ebx, clip_view
	mov	cl, al
	jmp	BX00

BX_BYE:

END_FCN


START_FCN _gfx_quick_4_pel < < _int, x>, < _int, y>, <_int, delta_x>, <_int, delta_y>, < _int, color> >;
PROLOGUE <SI, DI, ES>
	mov	ecx, 0FH
	mov	eax, x
       .smov	ebx, <_gfx .min_x>
       .smov	edx, <_gfx .max_x>
       .if	eax GT edx, then_goto <short ZMDROP>
       .if	eax LT ebx, then_goto <short ZM1>
	and	cl, 0111B
ZM1:	add	eax, delta_x
       .if	eax LT ebx, then_goto <short ZMDROP>
       .if	eax GT edx, then_goto <short ZM2>
	and	cl, 1011B

ZM2:   .smov	ebx, <_gfx .min_y>
       .smov	edx, <_gfx .max_y>
	mov	eax, y
       .if	eax GT edx, then_goto <short ZMDROP>
       .if	eax LT ebx, then_goto <short ZM3>
	and	cl, 1101B
ZM3:	add	eax, delta_y
       .if	eax LT ebx, then_goto <short ZMDROP>
       .if	eax GT edx, then_goto <short ZM4>
	and	cl, 1110B
ZM4:	jecxz	short X40
	mov	eax, ecx
	jmp	short ZMBYE

ZMDROP: mov	eax, 0FH

ZMBYE:

END_FCN


TRANSPARENT EQU 8000H

START_FCN _gfx_4_pel, < < _int, x>, < _int, y>, <_int, delta_x>, <_int, delta_y>, < _int, color> >;
AUTO < <_INT n_bytes_in_row> >
PROLOGUE <SI, DI, ES>;

X40:   .if	TRANSPARENT BIT_IS_ON_IN color, then_goto <short XXIT>
	mov	ecx, x
	mov	eax, y
	mov	bl, FCN_4_PEL
       .call	_0xy_to_ram
       .if	ebx LT 2*INT_SZ, then_goto <short Y00>
	jmp	EY0
XXIT:	jmp	YXIT

Y00:	mov	eax, delta_y
	mov	ecx, eax
       .if	<_gfx .gfx_mode> NE 6, then_goto <short YY0>

        shr	eax, 2				; Hercules or AT&T Card
       .smov	ah, <CHAR _gfx .bytes_per_row>
	mul	ah
	mov	edx, eax
	add	edx, esi
	and	ecx, 3
	jz	short Y03
	add	edx, 2000H
	dec	ecx
	jz	short Y0A
	add	edx, 2000H
	dec	ecx
	jz	short Y0A
	add	edx, 2000H
Y0A:   .if	edx BE 8000H, then_goto <short Y03>
       .ssub	edx, <_gfx .last_video_row>

YY0:	jecxz	short Y03		      ; CGA Med & Hi res
	shr	eax, 1
       .smov	ah, <CHAR _gfx .bytes_per_row>
	mul	ah
	mov	edx, eax
	add	edx, esi
	shr	ecx, 1
	jnc	short Y03
	add	edx, 2000H
       .if	edx BE 4000H, then_goto <short Y03>
	sub	edx, 4000H - 80

Y03:	mov	cl, 2
       .if	ebx EQ 0, then_goto <short YY>

HY:	mov	ch, 1
	mov	ebx, edi
HY1:	and	ebx, 7
	mov	edi, ebx
       .smov	ah, <_0hi_res_pel_mask [ebx]>	   ; HIGH RES
	mov	bl, color
       .smov	al, <_0hi_res_color_mask [ebx]>
	jmp	short WRTY

YY:	mov	ch, 0			; MEDIUM RES
	mov	ebx, edi
YY1:	and	ebx, 3
	mov	edi, ebx
       .smov	ah, <_0med_res_pel_mask [ebx]>
	mov	bl, color
       .smov	al, <_0med_res_color_mask [ebx]>

WRTY:	and	al, ah				    ; SET CGA CARD PEL
	not	ah
       .if	XOR_PEL bit_is_on_in <_gfx .color_flags>, then_goto <short XORY>
       .smov	es, <_gfx .screen_base>
	and	es:[esi], ah
	or	es:[esi], al
       .if	delta_y EQ 0 then_goto <short XY3>
	xchg	esi, edx
	and	es:[esi], ah
	or	es:[esi], al
	xchg	esi, edx
WY3:	jmp	short XY3


XORY:  .smov	es, <_gfx .screen_base>
	xor	es:[esi], al
       .if	delta_y EQ 0 then_goto <short XY3>
	xchg	esi, edx
	xor	es:[esi], al
	xchg	esi, edx

XY3:	dec	cl
	jz	short JXIT
       .if	delta_x EQ 0, then_goto <short JXIT>
	mov	eax, edi
	add	eax, delta_x
	mov	ebx, eax
        shr	eax, 2
	or	ch, ch
	jz	short YY3
	shr	eax, 1
	add	esi, eax
	add	edx, eax
	jmp	HY1
YY3:	add	esi, eax
	add	edx, eax
	jmp	YY1
JXIT:	jmp	YXIT
EY256:	jmp	Y256

EY0:   .if	ebx EQ 3*INT_SZ, then_goto <short EY256>
       .if	<_gfx .max_y> GT 600, then_goto	<short EY0A>
	jmp	EOY0
EY0A:  .smov	eax, <_gfx .bytes_per_row>
	mov	n_bytes_in_row, eax
	xor	edx, edx
	mov	ebx, edi
	and	ebx, 7
       .smov	dh, <_0hi_res_pel_mask [ebx]>
       .if	delta_x EQ 0, then_goto <short EY1>
	mov	eax, edi
	add	edi, delta_x
	mov	ebx, edi
	and	ebx, 7
       .smov	dl, <_0hi_res_pel_mask [ebx]>
        shr	edi, 3
        shr	eax, 3
	sub	edi, eax
	mov	delta_x, edi

EY1:	mov	ebx, edx
	mov	ch, color
       .smov	es, <_gfx .screen_base>
	mov	edx, GRAPH_ADDR		    ; ENHANCED RES over 800x600
	mov	al, G_BITMASK
	out	dx, al

EY2:	mov	edx, GRAPH_ADDR+1
	mov	al, bh
	out	dx, al
	mov	al, ch
	xchg	al, es:[esi]
       .if	bl EQ 0, then_goto <short EY_NEXT_PAIR>
	mov	al, bl
	out	dx, al
	add	esi, edi
	mov	al, ch
	xchg	al, es:[esi]
	sub	esi, edi
EY_NEXT_PAIR:
       .if	delta_y EQ 0, then_goto <short EYBYE>
	mov	eax, delta_y
	mov	dword ptr delta_y, 0
	mov	edx, n_bytes_in_row
	mul	dx
	add	si, ax
	adc	dx, 0
	mov	ax, dx
	jz	short EY2
	add	al, DS_LBL:$256_page_n
       .call	_ESnew_256_page
	jmp	short EY2
EYBYE:	jmp	YXIT


EOY0:  .smov	eax, <_gfx .bytes_per_row>
	mul	dword ptr delta_y
	mov	ebx, edi
	mov	edi, eax
	mov	cl, 2
	mov	ch, color
       .smov	es, <_gfx .screen_base>

	mov	edx, GRAPH_ADDR		    ; ENHANCED RES
	mov	al, G_BITMASK
	out	dx, al
	inc	edx
EOY2:	and	ebx, 7
       .smov	al, <_0hi_res_pel_mask [ebx]>
       .lsmov	es, <_gfx .screen_base>
	out	dx, al
	mov	al, ch
	xchg	al, es:[esi]
	or	edi, edi
	jz	short EOY3
	add	esi, edi
	mov	al, ch
	xchg	al, es:[esi]
EOY3:	dec	cl
	jz	short EYBYE

	mov	eax, delta_x
       .if	eax EQ 0, then_goto <short EYBYE>
	add	ebx, eax
	mov	eax, ebx
        shr	eax, 3
	sub	esi, edi
	add	esi, eax
	jmp	short EOY2


Y256:	mov	ecx, delta_y
	mov	edi, delta_x
       .smov	edx, <_gfx .bytes_per_row>
       .smov	ebx, <_gfx .color_flags>
       .smov	es, <_gfx .screen_base>
	mov	al, color
       .if	XOR_PEL bit_is_off_in ebx, then_goto <short YM256>

YX256:	xor	es:[esi], al
       .if	edi EQ 0, then_goto <short Y256_NEXT_PAIR>
	add	si, di
	jc	short YX1B
YX1R:	xor	es:[esi], al
	jmp	short Y256_NEXT_PAIR

YM256:	mov	es:[esi], al
       .if	edi EQ 0, then_goto <short Y256_NEXT_PAIR>
	add	si, di
	jc	short YM1B
YM1R:	mov	es:[esi], al

Y256_NEXT_PAIR:
	jecxz	short YXIT
	push	eax
	mov	eax, y
	add	eax, ecx
	xor	ecx, ecx
	mul	edx
	add	eax, x
	movzx	esi, ax
       .sadd	esi, <_gfx .screen_offset>
	shr	eax, 16
       .call	_ESnew_256_page
	pop	eax
       .if	XOR_PEL bit_is_off_in ebx, then_goto <short YM256>
	jmp	YX256

YX1B:  .call	_ESnext_256_page
	jmp	YX1R
YM1B:  .call	_ESnext_256_page
	jmp	YM1R

YXIT:	xor	eax, eax

END_FCN;


;/*~ LO_QSORT.ASM */

START_FCN <NEAR STATIC $lo_qsort>

	mov	eax, edi		; edi == r, j
	sub	eax, esi		; esi == l, i	(r > l)
	xor	edx, edx
	mov	ebx, ecx		; ecx = struct_size
	shl	ebx, 1			; pivot (x) = l + ((r-l)/2);
	div	ebx
	mul	ecx
	mov	ebx, eax
	add	ebx, esi

	mov	eax, [ebx+INT_SZ]	; eax = x.y
	mov	ebx, [ebx]		; ebx = x.x

	mov	edx, esi		; save for later
	push	edi
	jmp	short A0

A00:	add	esi, ecx
A0:	cmp	[esi+INT_SZ], eax	; while (i < x) i++;
	jl	short A00
	jg	short A1
	cmp	[esi], ebx
	jl	short A00
	jmp	short A1

A01:	sub	edi, ecx
A1:	cmp	eax, [edi+INT_SZ]	; while (x < j) j--;
	jl	short A01
	jg	short A2
	cmp	ebx, [edi]
	jl	short A01

A2:	cmp	esi, edi
	ja	short A3
	je	short A21

	push	eax
	mov	eax, [esi]		; i <--> j (swap)
	xchg	eax, [edi]
	mov	[esi], eax
	mov	eax, [esi+INT_SZ]
	xchg	eax, [edi+INT_SZ]
	mov	[esi+INT_SZ], eax
       .if	cl EQ INT_SZ*2, then_goto <short A20>
	mov	eax, [esi+INT_SZ*2]
	xchg	eax, [edi+INT_SZ*2]
	mov	[esi+INT_SZ*2], eax
A20:	pop	eax

A21:	add	esi, ecx		; next element (struct)
       .if	edi EQ edx then_goto <short A4>
	sub	edi, ecx		; previous element (struct)
       .if	esi BE edi, then_goto <short A0>

A3:    .if	edx AE edi, then_goto <short A4>
	push	esi
	mov	esi, edx
	call	$lo_qsort
	pop	esi

A4:	pop	edi
       .if	esi AE edi, then_goto <short ABYE>
	call	$lo_qsort
ABYE:
END_FCN


START_FCN _gfx_qsort < <DATA_PTR base>, <_int n_elem>, <_int elem_sz> >
PROLOGUE <SI, DI, DS>

       .lds	esi, base
	mov	eax, n_elem
	dec	eax
	mov	ecx, elem_sz
	mul	ecx
	mov	edi, eax
	add	edi, esi
	call	$lo_qsort

END_FCN

;/*~ FILL.ASM */

IFNDEF TURBO_PASCAL

START_FCN _gfx_fill < <DATA_PTR tp>, <_int n_bytes>, <_int _c> >
PROLOGUE <DI, ES>

	cld
	mov	al, _c
	mov	ah, al
       .les	edi, tp
	mov	ecx, n_bytes
	shr	ecx, 1
rep	stosw
	jnc	short WZ1
	stosb
WZ1:

END_FCN

ENDIF


;/*~ LOPORTIO.ASM */

START_FCN _gfx_inp < <_INT port_n> >
PROLOGUE
	mov	edx, port_n
	xor	eax, eax
	in	al, dx
END_FCN

START_FCN _gfx_outp < <_INT port_n>, <_INT val> >
PROLOGUE
	mov	edx, port_n
	mov	al, val
	out	dx, al
END_FCN


;/*~ GFX_SEGS.ASM */

START_FCN _gfx_get_ds
	xor	eax, eax
	mov	ax, ds
END_FCN

START_FCN _gfx_set_ds < <_INT _ds_reg> >
PROLOGUE
	mov	ds, _ds_reg
END_FCN

START_FCN _gfx_get_es
	xor	eax, eax
	mov	ax, es
END_FCN

START_FCN _gfx_get_cs
	xor	eax, eax
	mov	ax, cs
END_FCN


;/*~ LOVGAPAL.ASM */

START_FCN _gfx_lo_write_VGA_pal < <_INT first_color>, <_INT _n_colors>, <FAR_PTR pal_buf> >
PROLOGUE <SI, DS>

	cld
	mov	edx, 3C8H
	mov	eax, first_color
	out	dx, al
	.lds	esi, pal_buf
	mov	ecx, _n_colors
	shl	ecx, 1
	add	ecx, _n_colors
	mov	edx, 3C4H
	mov	al, 1
	inc	edx
	in	al, dx
	mov	bl, al
	and	al, 1FH
	out	dx, al
	mov	edx, 3C9H

AM1:	lodsb
	out	dx, al
	nop
	loop	AM1

	mov	edx, 3C5H
	mov	al, bl
	out	dx, al
END_FCN


START_FCN _gfx_lo_read_VGA_pal < <_INT first_color>, <_INT _n_colors>, <FAR_PTR pal_buf> >
PROLOGUE <DI, ES>

	cld
	mov	edx, 3C7H
	mov	eax, first_color
	out	dx, al
	add	edx, 2
	.les	edi, pal_buf
	mov	ecx, _n_colors
	shl	ecx, 1
	add	ecx, _n_colors

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


/*~ INT86_32.ASM */

IFDEF CMS32

START_FCN _gfx32_int86 < <_INT int_n>, <DATA_PTR inregs>, <DATA_PTR outregs> >
PROLOGUE <SI, DI>

	push	ds
	push	es
	mov	edi, inregs
	mov	eax, [edi]
	mov	ebx, [edi+4]
	mov	ecx, [edi+8]
	mov	edx, [edi+12]
	mov	esi, [edi+16]
	mov	edi, [edi+20]
	push	ebp

         .if	int_n NE 010H, then_goto <short XI21>
	int	10H
	jmp	short XBACK
XI21:  .if	int_n NE 021H, then_goto <short XI11>
	int	21H
	jmp	short XBACK
XI11:  .if	int_n NE 011H, then_goto <short XI16>
	int	11H
	jmp	short XBACK
XI16:  .if	int_n NE 016H, then_goto <short XI31>
	int	16H
	jmp	short XBACK
XI31:  .if	int_n NE 031H, then_goto <short XI1A>
	int	31H
	jmp	short XBACK
XI1A:  .if	int_n NE 01AH, then_goto <short XI17>
	int	1AH
	jmp	short XBACK
XI17:  .if	int_n NE 017H, then_goto <short XI2F>
	int	17H
	jmp	short XBACK
XI2F:  .if	int_n NE 02FH, then_goto <short XBACK>
	int	2FH

XBACK:	pop	ebp
	pushfD                            ; save flags for return
	push    edi
	mov	edi, outregs
	mov	dword ptr [edi],   eax	  ; save registers in outregs
	mov	dword ptr [edi+4], ebx
	mov	dword ptr [edi+8], ecx
	mov	dword ptr [edi+12],edx
	mov	dword ptr [edi+16],esi
	pop	eax
	mov	dword ptr [edi+20],eax   ; get EDI back
	pop	eax                      ; return the register flags
	mov	dword ptr [edi+24],eax   ; save the carry flag in outregs
	and	dword ptr [edi+24],1
	mov	dword ptr [edi+28],eax   ; save the flags in outregs

	pop	es
	pop	ds
END_FCN    	


START_FCN _gfx32_int86x < <_INT int_n>, <DATA_PTR inregs>, <DATA_PTR outregs>, <DATA_PTR sregs> >
PROLOGUE <SI, DI>
	push	es
	push	ds
	mov	edi, inregs
	mov	eax, [edi]
	mov	ebx, [edi+4]
	mov	ecx, [edi+8]
	mov	edx, [edi+12]
	mov	esi, [edi+16]
	mov	edi, [edi+20]

	push	edi
	push	eax
	mov	edi, sregs
	movzx	eax, word ptr [edi]
       .if	eax EQ 0, then_goto <short XY0>
	mov	es, ax
XY0:	movzx	eax, word ptr [edi+6]
         .if	eax EQ 0, then_goto <short XY1>
          mov	ds, ax
XY1:	pop	eax
	pop	edi
	push	ebp

         .if	int_n NE 010H, then_goto <short YI21>
	int	10H
	jmp	short YBACK
YI21:  .if	int_n NE 021H, then_goto <short YI11>
	int	21H
	jmp	short YBACK
YI11:  .if	int_n NE 011H, then_goto <short YI16>
	int	11H
	jmp	short YBACK
YI16:  .if	int_n NE 016H, then_goto <short YI31>
	int	16H
	jmp	short YBACK
YI31:  .if	int_n NE 031H, then_goto <short YI1A>
	int	31H
	jmp	short YBACK
YI1A:  .if	int_n NE 01AH, then_goto <short YI17>
	int	1AH
	jmp	short YBACK
YI17:  .if	int_n NE 017H, then_goto <short YI2F>
	int	17H
	jmp	short YBACK
YI2F:  .if	int_n NE 02FH, then_goto <short YBACK>
	int	2FH

YBACK:	pop	ebp
	push	ds
	pushfD                            ; save flags for return
	push    edi
	mov	edi, outregs
	mov	dword ptr [edi],   eax	  ; save registers in outregs
	mov	dword ptr [edi+4], ebx
	mov	dword ptr [edi+8], ecx
	mov	dword ptr [edi+12],edx
	mov	dword ptr [edi+16],esi
	pop	eax
	mov	dword ptr [edi+20],eax   ; get EDI back
	pop	eax                      ; return the register flags
	mov	dword ptr [edi+24],eax   ; save the carry flag in outregs
	and	dword ptr [edi+24], 1
	mov	dword ptr [edi+28],eax   ; save the flags in outregs
	
	mov	edi, sregs		 ; now save ES and DS
	mov	word ptr [edi], es
	pop	ecx
	mov	word ptr [edi+6], cx
	
	pop	ds
	pop	es

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
	mov	ebx, INT_CAP
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
	mov	ebx, INT_STEP
	jmp	_gfx_ivec1args
END_FCN	NO_RET

EXTERN FCN _gfx_oval_fcn

START_FCN Oval
       .set_fcn_vec _gfx_oval_fcn
	jmp	_gfx_ivec0args
END_FCN NO_RET


START_FCN OvalRel
       .set_fcn_vec _gfx_oval_fcn
	mov	ebx, INT_STEP
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
	mov	ebx, INT_STEP
	jmp	_gfx_ivec1args
END_FCN	NO_RET

EXTERN FCN _gfx_oval_arc

START_FCN OvalArc
       .set_fcn_vec _gfx_oval_arc
	jmp	_gfx_ivec0args
END_FCN NO_RET

START_FCN OvalArcRel
       .set_fcn_vec _gfx_oval_arc
	mov	ebx, INT_STEP
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
	mov	ebx, INT_CAP
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
	mov	ebx, INT_STEP
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
	mov	ebx, INT_CAP
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
	mov	ebx, INT_CAP
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
	mov	ebx, INT_CAP
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
	mov	ebx, INT_STEP
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
	mov	ebx, INT_STEP
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
	mov	ebx, INT_STEP
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
	mov	ebx, INT_STEP
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
	mov	ebx, INT_STEP
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
	mov	ebx, INT_STEP
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
	mov	ebx, INT_STEP
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
	mov	ebx, INT_STEP
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
	mov	ebx, INT_STEP
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
	mov	ebx, INT_STEP
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
	mov	ebx, INT_STEP
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
	mov	ebx, INT_STEP
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
	mov	ebx, INT_STEP
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
	mov	ebx, INT_CAP
	jmp	_gfx_ivec1args
END_FCN	NO_RET

EXTERN FCN <NEAR _gfx_ivec2args>

START_FCN PrintAreaToRel
       .set_fcn_vec _gfx_print_area
	jmp	_gfx_ivec2args
END_FCN	NO_RET



;/*~ IVECPM.ASM */

STATIC _INT _gfx_vec_ptr_offset <0, 0>;
STATIC _INT _gfx_vec_ptr_segment <0>;
STATIC _INT _gfx_save_vec <0, 0>

START_FCN  <NEAR _gfx_ivec0args>
       .if	 <_gfx .xlat_scale> EQ FLOAT_SCALE, then_goto <short _gfx_ivec_err_exit>
       .jmp_cfunc
END_FCN NO_RET


START_FCN  <NEAR _gfx_ivec1args>
       .if	 <_gfx .xlat_scale> EQ FLOAT_SCALE, then_goto <short _gfx_ivec_err_exit>
       .save_ret_vec
	push	ebx
       .call_cfunc
	add	esp, INT_SZ
       .restore_ret_vec
       .ret
END_FCN NO_RET


START_FCN  <NEAR _gfx_ivec2args>
       .if	 <_gfx .xlat_scale> EQ FLOAT_SCALE, then_goto <short _gfx_ivec_err_exit>
       .save_ret_vec
	mov	eax, INT_STEP
	push	eax
	mov	eax, INT_CAP
	push	eax
       .call_cfunc
	add	esp, 4
       .restore_ret_vec
       .ret
END_FCN NO_RET

START_CODE
_gfx_ivec_err_exit:
       .smov	 <_gfx .err_number>, -1
	xor	eax, eax
       .ret
END_CODE



; ********* HERE IS THE FLOATING POINT FRONT END ***********


;/*^ GFXF_A32.ASM */

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

S00:   .smov	eax, <_gfx .color_flags>
	mov	xor_c, eax
       .smov	eax, <_gfx .bios_mode>
	mov	_mode, eax
       .smov	eax, <_gfx .last_video_row>
	mov	lvr, eax
	mov	esi, char_bit_offset	; bit offset of char
	mov	edx, char_width		; bit offset of next char

	mov	edi, start_of_scrn_row
	mov	eax, x			; calculate byte and pel
	mov	ecx, eax			; offset for the char
	and	ecx, 7
        shr	eax, 3
	add	edi, eax
					; check for fast char write
	mov	ebx, ecx
	add	ebx, edx
       .if	_gfx_fast_char EQ 0, then_goto <short S01>
	jmp	FAST_CHAR
S01:
		; get the bitmasks for the left and right side of the char

	xor	eax, eax
	mov	ebx, esi
	and	ebx, 7
       .smov	al, <_lbitmask .[ebx]>
	mov	lmask, eax
	add	ebx, edx
	and	ebx, 7
       .smov	al, <_lbitmask .[ebx]>
	jz	short S20
	not	al
S20:	mov	rmask, eax

	mov	ebx, esi
	and	ebx, 7
	add	ebx, edx
	mov	eax, form_width
	dec	ebx
        shr	ebx, 3
	jnz	short S30
	mov	dl, rmask
	and	lmask, dl
S30:	sub	eax, ebx
	dec	eax
	mov	next_font_row, eax

       .smov	eax, <_gfx .bytes_per_row>
	sub	eax, ebx
	dec	eax
	mov	next_scrn_row, eax

	mov	bh, bl

	mov	edx, esi
        shr	esi, 3
       .if	<_gfx .bios_mode> GT 10, then_goto <short EGA_CHAR>
	jmp	CGA_CHAR

EGA_CHAR:
       .smov	es, <_gfx .screen_base>
	add	dword ptr next_scrn_row, 2
	.lds	eax, char_bitmap
	add	esi, eax
	and	edx, 7
	sub	ecx, edx

	mov	edx, GRAPH_ADDR
	mov	al, G_BITMASK
	out	dx, al
	mov	edx, GRAPH_ADDR+1

	jge	short ER35
	neg	ecx
	dec	edi
	jmp	EL36

ER30:	xor	ah, ah
	ror	ax, cl
	or	al, ch
	mov	ch, ah
	jz	short ER32

ER31:	out	dx, al
	mov	al, es:[edi]
	mov	al, color
	mov	es:[edi], al

ER32:	inc	edi
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
	mov	al, es:[edi]
	mov	al, color
	mov	es:[edi], al

ER34:	dec	dword ptr n_rows
	jz	short ELRBYE
	mov	bl, bh
	add	esi, next_font_row
	dec	di
	add	di, next_scrn_row
	jc	short ERPG
	dec	edi

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
	mov	al, es:[edi]
	mov	al, color
	mov	es:[edi], al

EL32:	inc	edi
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
	mov	al, es:[edi]
	mov	al, color
	mov	es:[edi], al

EL35:	dec	dword ptr n_rows
	jz	short ELRBYE
	mov	bl, bh
	add	esi, next_font_row
	dec	di
	add	di, next_scrn_row
	jc	short ELPG
	dec	edi
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
	mov	eax, 1FFFH
	sub	al, bl
       .if	_mode LT 6, then_goto <short MRES_CHAR>
	mov	next_scrn_row, eax
	mov	dword ptr inccgan, 1
	mov	eax, offset CS_LBL:$$wrt_hi_res_bit_pattern
       .if	XOR_PEL bit_is_off_in xor_c, then_goto <short H00>
	mov	eax, offset CS_LBL:$$xor_hi_res_bit_pattern
	jmp	H00

MRES_CHAR:
	dec	eax
	sub	al, bl
	mov	next_scrn_row, eax

	mov	edi, start_of_scrn_row
	mov	eax, x
        shr	eax, 2
	and	al, 0FEH
	add	edi, eax

MR0:	mov	dword ptr inccgan, 2
	mov	eax, offset CS_LBL:$$wrt_med_res_bit_pattern
       .if	XOR_PEL bit_is_off_in xor_c, then_goto <short H00>
	mov	eax, offset CS_LBL:$$xor_med_res_bit_pattern

H00:	mov	wcgabp, eax
	mov	eax, lvr
	mov	last_row, eax
	.lds	eax, char_bitmap
	add	esi, eax
	and	edx, 7
	sub	ecx, edx
	mov	dl, color
	jge	short HR35
	neg	ecx
	sub	edi, inccgan
	jmp	HL36

HR30:	xor	ah, ah
	ror	ax, cl
	or	al, ch
	mov	ch, ah
	jz	short HR31
	call	dword ptr wcgabp

HR31:	add	edi, inccgan
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
	call	dword ptr wcgabp

HR34:	dec	dword ptr n_rows
	jz	short S3BYE
	mov	bl, bh
	add	esi, next_font_row
	add	edi, next_scrn_row
       .if	edi BE last_row, then_goto <short HR35>
	sub	edi, last_row

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
	call	dword ptr wcgabp

HL31:	add	edi, inccgan
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
	call	dword ptr wcgabp

HL35:	dec	dword ptr n_rows
	jz	short S3BYE
	mov	bl, bh
	add	esi, next_font_row
	add	edi, next_scrn_row

       .if	edi BE last_row, then_goto <short HL36>
	sub	edi, last_row

HL36:	lodsb
	and	al, lmask
	shl	al, cl
	mov	ch, al
	jmp	HL31
S3BYE:	jmp	XWBYE

XW256:	mov	eax, char_bit_offset
	mov	ecx, eax
        shr	eax, 3
	add	char_bitmap, eax
	and	ecx, 7
	mov	ebx, ecx
	mov	ch, char_width
	mov	ofs_npel, ecx

	add	ebx, char_width
       .if	ebx, GE 16, then_goto <short XW00>
	mov	ebx, char_width
XW00:	mov	edx, ebx
	and	ebx, 07H
	mov	al, 0
       .smov	ah, <_rbitmask .[ebx]>
	and	dl, 8H
	jz	short XW01
	mov	al, ah
	mov	ah, 0FFH
XW01:	mov	rmask, eax

       .smov	eax, <_gfx .bytes_per_row>
	mov	next_scrn_row, eax

	mov	ebx, offset CS_LBL:XWM2
	mov	eax, offset CS_LBL:XCM2
       .if	XOR_PEL bit_is_off_in <_gfx .color_flags>, then_goto <short XWA0>
	mov	ebx, offset CS_LBL:XWX2
	mov	eax, offset CS_LBL:XCX2
XWA0:	mov	npg, eax

       .smov	edx, <_gfx .screen_base>
       .les	esi, char_bitmap

	mov	edi, start_of_scrn_row
	add	di, x
	jnc	short XWA1
       .call	_DSnext_256_page
XWA1:	push	edi
	push	esi
	mov	ds, dx

XWA:	mov	dx, es:[esi]
	add	esi, 2
	xchg	dh, dl
	mov	ecx, ofs_npel	; cl = offset	ch = n_pels_wide
	shl	dx, cl
	mov	eax, 16
	sub	al, cl
	sub	ch, al
	xchg	eax, ecx
	mov	al, color
	add	cx, di
	jc	short XWE
XWB:   .if	ah GE 0, then_goto <short XWC>
	and	edx, rmask
	jz	short NEXTSCANLINE
XWC:	jmp	ebx

XWX0:	xor	[edi], al
XWX1:	inc	edi
XWX2:	shl	dx, 1
	jc	short XWX0
	jnz	short XWX1
	jmp	short XWD

XWM0:	mov	[edi], al
XWM1:	inc	edi
XWM2:	shl	dx, 1
	jc	short XWM0
	jnz	short XWM1

XWD:   .if	ah GT 0, then_goto <short XWD0>

NEXTSCANLINE:
	mov	eax, edi
	pop	esi				; start_bitmask_line
	pop	edi				; start_screen_line
	dec	byte ptr n_rows
	jz	short XWDONE
	add	esi, form_width
	add	di, next_scrn_row
	push	edi
	push	esi
	jnc	short XWA
       .if	ax BE di, then_goto <short XWA>
       .call	_DSnext_256_page
	jmp	XWA

XWD0:	sub	ah, 16
	mov	dx, es:[esi]
	add	esi, 2
	xchg	dh, dl
       .if	di AB cx, then_goto <short XWE0>
XWD1:	mov	di, cx
	add	ecx, 16
XWE:	mov	ebx, npg
	jmp	short XWB
XWE0:  .call	_DSnext_256_page
	jmp	short XWD1

XCX0:	xor	[edi], al
XCX1:	inc	di
	jz	short XCB
XCX2:	shl	dx, 1
	jc	short XCX0
	jnz	short XCX1
	jmp	XWD

XCM0:	mov	[edi], al
XCM1:	inc	di
	jz	short XCB
XCM2:	shl	dx, 1
	jc	short XCM0
	jnz	short XCM1
	jmp	XWD

XCB:   .call	_DSnext_256_page
	jmp	ebx

XWDONE:.if	eax AB start_of_scrn_row, then_goto <short XWBYE>
       .call	_DSprev_256_page

XWBYE:	jmp	CHAR_BYE

			; 16-bit fast write characters
FAST_CHAR:
       .smov	eax, <_gfx .bytes_per_row>
	mov	next_scrn_row, eax
       .smov	eax, _gfx_wrt_bkgnd_color
        mov	bc, eax	
	mov	edx, char_bit_offset
	mov	esi, edx
        shr	esi, 3

PP0:   .smov	es, <_gfx .screen_base>
       .lds	eax, char_bitmap
	add	esi, eax

	mov	edx, GRAPH_ADDR
	mov	al, G_BITMASK
	out	dx, al
	inc	edx
	
	mov	ebx, form_width
       .if	cl NE 0, then_goto <short PQWN>	
	mov	ah, color
	mov	ecx, n_rows
	mov	al, bc
       .if	al LT 0, then_goto <short PQW8> 
        jmp	short PQW8C0

PQNP0: .call	_ESnext_256_page
PQWN:	mov	ch, color
	mov	dword ptr rmask, -1
       .if	char_width EQ 8, then_goto <short PQWN8>	
	inc	dword ptr rmask
	jmp	short PQWN8
PQWN80:	dec	dword ptr n_rows         ; non-byte-aligned 
	jz	short FAST_CHAR_BYE
	add	esi, ebx
	add	di, next_scrn_row
	jc	short PQNP0
PQWN8:	mov	ah, [si]
	mov	al, 0
	shr	eax, cl
	and	al, rmask
	jz      short PQWN81
	out	dx, al
	mov	al, es:[edi+1]
	mov	al, ch
	mov	es:[edi+1], al
PQWN81:	or	ah, ah
	jz      short PQWN80
	mov	al, ah
	out	dx, al
	mov	al, es:[edi]
	mov	al, ch
	mov	es:[edi], al
	jmp	short PQWN80

PQNP1: .call	_ESnext_256_page
	jmp	short PQW8
PQW80:	dec	ecx                              ; byte-aligned w/ xparent bkgnd
	jz	short FAST_CHAR_BYE
	add	esi, ebx			        
	add	di, next_scrn_row
	jc	short PQNP1
PQW8:	mov	al, [esi]
	or	al, al
	jz	short PQW80
	out	dx, al
	mov	al, es:[edi]
	mov	al, ah
	mov	es:[edi], al
	jmp	short PQW80

FAST_CHAR_BYE:
       .if	edi AB start_of_scrn_row, then_goto <short CHAR_BYE>
       .call	_ESprev_256_page

PQW8C0:	mov	al, 0FFH                        ; byte-aligned w/ bkgnd color
	out	dx, al
	mov	al, bc
	mov	es:[edi], al
	mov	al, es:[edi]
PQW8C:  mov	al, [esi]
        out	dx, al
        mov	es:[edi], ah
	add	esi, ebx
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
        mov	ecx, x
        and	ecx, 7
        shr	bl, cl

PQW8B: .if	bh LT 0, then_goto PQW8B0       ; byte-aligned - clipped
	mov	al, bl
	out	dx, al
	mov	al, bh
	xchg	es:[edi], al
PQW8B0:	mov	al, [esi]
        and	al, bl
        jz	short PQW8B1
	out	dx, al
	mov	al, ah
	xchg	es:[edi], al
PQW8B1:	add	esi, form_width
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
	mov	eax, 8000H
EX0:	shr	dh, 1
	rcr	eax, 1
	sar	eax, 1
	jnc	short EX0
	shr	eax, 16
	xchg	ah, al
	not	eax
	and	es:[edi], ax
	not	eax
	and	ah, dl
	and	al, dl
	or	es:[edi], ax

END_FCN


START_FCN <NEAR $$xor_med_res_bit_pattern>

	mov	dh, al
	mov	eax, 8000H
EX1:	shr	dh, 1
	rcr	eax, 1
	sar	eax, 1
	jnc	short EX1
	shr	eax, 16
	xchg	ah, al
	and	ah, dl
	and	al, dl
	xor	es:[edi], ax

END_FCN


START_FCN <NEAR $$wrt_hi_res_bit_pattern>

	or	dl, dl
	jz	short BDOT
	or	es:[edi], al
	ret
BDOT:	not	al
	and	es:[edi], al

END_FCN

START_FCN <NEAR $$xor_hi_res_bit_pattern>

	or	dl, dl
	jnz	short BDOT1
	not	al
BDOT1:	xor	es:[edi], al

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
       .smov	eax, <_gfx .bytes_per_row>
	mul	dword ptr y
	add	ax, x
	adc	edx, 0
	mov	x, eax
	mov	y, edx
END_FCN NO_RET

EXTERN FCN <NEAR _0new_256_page>

START_FCN _gfx_ptr_vram256_to_buf < <_int page_offset>, <_int page_n>, <_int n_bytes>, <_int n_rows>, <FAR_PTR buf> >
PROLOGUE <SI, DI, ES, DS>

	mov	eax, page_n
       .if	al EQ $256_page_n, then_goto <short B0>
	call	_0new_256_page
B0:	mov	esi, page_offset
       .sadd	esi, <_gfx .screen_offset>
       .smov	edx, <_gfx .bytes_per_row>
	sub	edx, n_bytes
	inc	edx
	.les	edi, buf
       .smov	ds, <_gfx .screen_base>
	cld
B1:	mov	ecx, n_bytes
	xor	ebx, ebx
	mov	eax, esi
	add	ax, cx
	jnc	short B2
	mov	ebx, eax
	sub	ecx, eax
B2:	shr	ecx, 1
rep	movsw
	jnc	short B3
	movsb
B3:	or	ebx, ebx
	jz	short B4
	mov	ecx, ebx
       .call	_DSnext_256_page
	xor	esi, esi
	xor	ebx, ebx
	jmp	short B2

B4:	dec	dword ptr n_rows
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
       .smov	eax, <_gfx .bytes_per_row>
	mul	dword ptr y
	add	ax, x
	adc	edx, 0
	mov	x, eax
	mov	y, edx
END_FCN NO_RET


START_FCN _gfx_buf_to_ptr_vram256 < <FAR_PTR buf>, <_int page_offset>, <_int page_n>, <_int n_bytes>, <_int n_rows> >
PROLOGUE <SI, DI, ES, DS>

	mov	eax, page_n
       .if	al EQ $256_page_n, then_goto <short C0>
	call	_0new_256_page
C0:	mov	edi, page_offset
       .sadd	edi, <_gfx .screen_offset>
       .smov	edx, <_gfx .bytes_per_row>
	sub	edx, n_bytes
	inc	edx
       .smov	es, <_gfx .screen_base>
	.lds	esi, buf
	cld

C1:	mov	ecx, n_bytes
	xor	ebx, ebx
	mov	eax, edi
	add	ax, cx
	jnc	short C2
	mov	ebx, eax
	sub	ecx, eax
C2:	shr	ecx, 1
rep	movsw
	jnc	short C3
	movsb
C3:	mov	ecx, ebx
	jecxz	C4
       .call	_ESnext_256_page
	xor	edi, edi
	xor	ebx, ebx
	jmp	short C2

C4:	dec	dword ptr n_rows
	jz	short CBYE
	dec	di
	add	di, dx
	jnc	short C1
       .call	_ESnext_256_page
	jmp	C1
CBYE:
END_FCN


