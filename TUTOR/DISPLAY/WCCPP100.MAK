# DISPLAY example makefile

#    wmake -f wccpp.mak dos32       (makes the DOS display tutorial)
#    wmake -f wccpp.mak windows     (makes the Windows display tutorial)
#    wmake -f wccpp.mak winnt       (makes the Windows NT display tutorial)
#    wmake -f wccpp.mak os2         (makes the OS/2 display tutorial)
#    wmake -f wccpp.mak dvx         (makes the DESQView/X display tutorial)
#    make -f wccpp.mak qnx          (makes the QNX display tutorial)

# Be sure to set the LIB and INCLUDE environment variables for Zinc, e.g.:
# DOS:
#    set INCLUDE=.;C:\WATCOM\H;C:\ZINC\INCLUDE
#    set LIB=.;C:\WATCOM\LIB386\DOS;C:\WATCOM\LIB386;C:\ZINC\LIB\WCCPP
# WINDOWS:
#    set INCLUDE=.;C:\WATCOM\H;C:\WATCOM\H\WIN;C:\ZINC\INCLUDE
#    set LIB=.;C:\WATCOM\LIB286\WIN;C:\WATCOM\LIB286;C:\ZINC\LIB\WCCPP
# WIN NT:
#    set INCLUDE=.;C:\WATCOM\H;C:\WATCOM\H\NT;C:\ZINC\INCLUDE
#    set LIB=.;C:\WATCOM\LIB386\NT;C:\WATCOM\LIB386;C:\ZINC\LIB\WCCPP
# OS/2:
#    set INCLUDE=.;C:\WATCOM\H;C:\WATCOM\H\OS2;C:\ZINC\INCLUDE
#    set LIB=.;C:\WATCOM\LIB386\OS2;C:\WATCOM\LIB386;C:\ZINC\LIB\WCCPP
# DESQView/X:
#    set INCLUDE=.;C:\DVX\INCLUDE;C:\WATCOM\H;C:\ZINC\INCLUDE
#    set LIB=.;C:\DVX\LIB\C386;C:\WATCOM\LIB386\DOS;C:\WATCOM\LIB386;C:\ZINC\LIB\WCCPP

.EXTENSIONS:
.EXTENSIONS: .o32 .obw .obn .ob9 .obo .obm .o .cpp .c

# Compiler and linker: (Add -d2 to CPP_OPTS and DEBUG ALL to LINK_OPTS for debug.)

# ----- DOS extender compiler options ---------------------------------------
# --- Watcom display options ---
#D32_CPP=wpp386
#D32_LINK=wlink
#D32_CPP_OPTS=/bt=dos
#D32_LINK_OPTS=SYSTEM dos4g OP stack=20000 DISA 1124

# --- GFX display options ---
D32_CPP=wpp386
D32_LINK=wlink
D32_CPP_OPTS=/bt=dos -DGFX_DISPLAY
#D32_LINK_OPTS=SYSTEM dos4g OP stack=20000
D32_LINK_OPTS=SYSTEM dos4g OP stack=20000 DISA 1124
# --- Use the next 2 lines for UI_GRAPHICS_DISPLAY ---
D32_OBJS=
D32_LIBS=d32_zil,d32_gfx,wc_32gfx
# --- Use the next 2 lines for UI_WCC_DISPLAY ---
#D32_OBJS=
#D32_LIBS=d32_zil,d32_wcc

.cpp.o32:
	$(D32_CPP) $(D32_CPP_OPTS) -fo=$[*.o32 $<

# ----- Usage --------------------------------------------------------------
usage: .SYMBOLIC
	@echo ...........
	@echo ...........
	@echo To make this Zinc example for Watcom C++ type:
	@echo wmake -f wccpp.mak dos32
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
