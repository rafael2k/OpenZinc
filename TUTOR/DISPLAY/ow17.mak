# DISPLAY example makefile

#    wmake -f ow17.mak dos32       (makes the DOS display tutorial)
#    wmake -f ow17.mak windows     (makes the Windows display tutorial)
#    wmake -f ow17.mak winnt       (makes the Windows NT display tutorial)
#    wmake -f ow17.mak os2         (makes the OS/2 display tutorial)
#    wmake -f ow17.mak dvx         (makes the DESQView/X display tutorial)
#    make -f ow17.mak qnx          (makes the QNX display tutorial)

# Be sure to set the LIB and INCLUDE environment variables for Zinc, e.g.:
# DOS:
#    set INCLUDE=.;C:\ow17\H;C:\ZINC\INCLUDE
#    set LIB=.;C:\ow17\LIB386\DOS;C:\ow17\LIB386;C:\ZINC\LIB\ow17
# WINDOWS:
#    set INCLUDE=.;C:\ow17\H;C:\ow17\H\WIN;C:\ZINC\INCLUDE
#    set LIB=.;C:\ow17\LIB286\WIN;C:\ow17\LIB286;C:\ZINC\LIB\ow17
# WIN NT:
#    set INCLUDE=.;C:\ow17\H;C:\ow17\H\NT;C:\ZINC\INCLUDE
#    set LIB=.;C:\ow17\LIB386\NT;C:\ow17\LIB386;C:\ZINC\LIB\ow17
# OS/2:
#    set INCLUDE=.;C:\ow17\H;C:\ow17\H\OS2;C:\ZINC\INCLUDE
#    set LIB=.;C:\ow17\LIB386\OS2;C:\ow17\LIB386;C:\ZINC\LIB\ow17
# DESQView/X:
#    set INCLUDE=.;C:\DVX\INCLUDE;C:\ow17\H;C:\ZINC\INCLUDE
#    set LIB=.;C:\DVX\LIB\C386;C:\ow17\LIB386\DOS;C:\ow17\LIB386;C:\ZINC\LIB\ow17

.EXTENSIONS:
.EXTENSIONS: .o32 .obw .obn .ob9 .obo .obm .o .cpp .c

# Compiler and linker: (Add -d2 to CPP_OPTS and DEBUG ALL to LINK_OPTS for debug.)

# ----- DOS extender compiler options ---------------------------------------
# --- ow17 display options ---
D32_CPP=wpp386
D32_LINK=wlink
D32_CPP_OPTS=/bt=dos
D32_LINK_OPTS=SYSTEM dos4g OP stack=20000 DISA 1124

# --- GFX display options ---
#D32_CPP=wpp386
#D32_LINK=wlink
#D32_CPP_OPTS=/bt=dos -DGFX_DISPLAY
#D32_LINK_OPTS=SYSTEM dos4g OP stack=20000
D32_LINK_OPTS=SYSTEM dos4g OP stack=20000 DISA 1124
# --- Use the next 2 lines for UI_GRAPHICS_DISPLAY ---
#D32_OBJS=
#D32_LIBS=d32_zil,d32_gfx,wc_32gfx
# --- Use the next 2 lines for UI_WCC_DISPLAY ---
D32_OBJS=
D32_LIBS=d32_zil,d32_wcc

.cpp.o32:
	$(D32_CPP) $(D32_CPP_OPTS) -fo=$[*.o32 $<

# ----- Usage --------------------------------------------------------------
usage: .SYMBOLIC
	@echo ...........
	@echo ...........
	@echo To make this Zinc example for ow17 C++ type:
	@echo wmake -f ow17.mak dos32
	@echo (This tutorial is not supported in Windows)
	@echo (This tutorial is not supported in Windows NT)
	@echo (This tutorial is not supported in Windows 95)
	@echo (This tutorial is not supported in OS/2)
	@echo (This tutorial is not supported in DESQview/X)
	@echo (This tutorial is not supported in QNX)
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean: .SYMBOLIC
	z_clean

# ----- DOS extender --------------------------------------------------------
dos32: display.exe .SYMBOLIC

display.exe: display.o32
	$(D32_LINK) $(D32_LINK_OPTS) N display.exe F display.o32 $(D32_OBJS) L $(D32_LIBS)

# ----- Windows -------------------------------------------------------------
windows: .SYMBOLIC
	@echo (This tutorial is not supported in Windows)

# ----- Windows -------------------------------------------------------------
winnt: .SYMBOLIC
	@echo (This tutorial is not supported in Windows NT)

# ----- Windows -------------------------------------------------------------
win32: .SYMBOLIC
	@echo (This tutorial is not supported in Windows 95)

# ----- OS/2 ----------------------------------------------------------------
os2: .SYMBOLIC
	@echo (This tutorial is not supported in OS/2)

# ----- DESQview/X Motif ----------------------------------------------------
dvx: .SYMBOLIC
	@echo (This tutorial is not supported in DESQview/X)

# ----- QNX Motif -----------------------------------------------------------
qnx:
	@echo (This tutorial is not supported in QNX)
