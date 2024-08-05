# VLIST example makefile

#    wmake -f ow18.mak dos32       (makes the DOS vlist tutorial)
#    wmake -f ow18.mak windows     (makes the Windows vlist tutorial)
#    wmake -f ow18.mak winnt       (makes the Windows NT vlist tutorial)
#    wmake -f ow18.mak win32       (makes the Windows NT vlist tutorial)
#    wmake -f ow18.mak os2         (makes the OS/2 vlist tutorial)
#    wmake -f ow18.mak dvx         (makes the DESQView/X vlist tutorial)
#    make -f ow18.mak qnx          (makes the QNX vlist tutorial)

# Be sure to set the LIB and INCLUDE environment variables for Zinc, e.g.:
# DOS:
#    set INCLUDE=.;C:\ow18\H;C:\ZINC\INCLUDE
#    set LIB=.;C:\ow18\LIB386\DOS;C:\ow18\LIB386;C:\ZINC\LIB\ow18
# WINDOWS:
#    set INCLUDE=.;C:\ow18\H;C:\ow18\H\WIN;C:\ZINC\INCLUDE
#    set LIB=.;C:\ow18\LIB286\WIN;C:\ow18\LIB286;C:\ZINC\LIB\ow18
# WIN NT:
#    set INCLUDE=.;C:\ow18\H;C:\ow18\H\NT;C:\ZINC\INCLUDE
#    set LIB=.;C:\ow18\LIB386\NT;C:\ow18\LIB386;C:\ZINC\LIB\ow18
# OS/2:
#    set INCLUDE=.;C:\ow18\H;C:\ow18\H\OS2;C:\ZINC\INCLUDE
#    set LIB=.;C:\ow18\LIB386\OS2;C:\ow18\LIB386;C:\ZINC\LIB\ow18
# DESQView/X:
#    set INCLUDE=.;C:\DVX\INCLUDE;C:\ow18\H;C:\ZINC\INCLUDE
#    set LIB=.;C:\DVX\LIB\C386;C:\ow18\LIB386\DOS;C:\ow18\LIB386;C:\ZINC\LIB\ow18

.EXTENSIONS:
.EXTENSIONS: .o32 .obw .obn .ob9 .obo .obm .o .cpp .c

# Compiler and linker: (Add -d2 to CPP_OPTS and DEBUG ALL to LINK_OPTS for debug.)

# ----- DOS extender compiler options ---------------------------------------
D32_CPP=wpp386
D32_LINK=wlink
D32_CPP_OPTS=/bt=dos
D32_LINK_OPTS=SYSTEM dos4g OP stack=20000 DISA 1124

# --- Use the next line for UI_GRAPHICS_DISPLAY ---
#D32_OBJS=
#D32_LIBS=d32_zil,d32_gfx,wc_32gfx
# --- Use the next line for UI_WCC_DISPLAY ---
D32_OBJS=
D32_LIBS=d32_zil,d32_wcc

# ----- Windows compiler options --------------------------------------------
WIN_CPP=wpp
WIN_LINK=wlink
WIN_RC=wrc
WIN_CPP_OPTS= -zW -zc -oas -w4 -ml
WIN_LINK_OPTS=SYS windows OP heapsize=16k OP stack=30k
WIN_RC_OPTS=/bt=windows
WIN_OBJS=
WIN_LIBS=windows,win_zil

# ----- Windows NT (and WIN32s) compiler options ----------------------------
WNT_CPP=wpp386
WNT_LINK=wlink
WNT_LIBRARIAN=wlib
WNT_RC=wrc

WNT_CPP_OPTS=/bt=nt
WNT_RC_OPTS=/bt=nt
WNT_LINK_OPTS=SYS nt_win
WNT_LIB_OPTS=/p=32

WNT_OBJS=
WNT_LIBS=nt,wnt_zil

.cpp.obn:
	$(WNT_CPP) $(WNT_CPP_OPTS) -fo=$[*.obn $<

# ----- Windows 32 bit compiler options -------------------------------------
W32_CPP=wpp386
W32_LINK=wlink
W32_LIBRARIAN=wlib
W32_RC=wrc

W32_CPP_OPTS=/bt=nt -DZIL_WIN32
W32_RC_OPTS=/bt=nt
W32_LINK_OPTS=SYS nt_win
W32_LIB_OPTS=/p=32

W32_OBJS=
W32_LIBS=nt,w32_zil

.cpp.ob9:
	$(W32_CPP) $(W32_CPP_OPTS) -fo=$[*.ob9 $<

# ----- OS/2 compiler options -----------------------------------------------
OS2_CPP=wpp386
OS2_LINK=wlink
OS2_RC=wrc
OS2_CPP_OPTS=/bt=OS2
OS2_LINK_OPTS=SYSTEM os2v2_pm OP ST=96000
OS2_RC_OPTS=
OS2_OBJS=
OS2_LIBS=os2_zil

# ----- DESQview/X MOTIF compiler options -----------------------------------
DVX_CPP=wpp386
DVX_LINK=wlink
DVX_CPP_OPTS=-d__DVX__ -zp4 -zq -4s
DVX_LINK_OPTS=SYSTEM dos4g OP quiet OP stack=48000
DVX_OBJS=
DVX_LIBS=dvx_zil,xm,xt,x,sys

# ----- QNX Motif compiler options -----------------------------------------
QNX_INC_DIRS= -I../../include
QNX_LIB_DIRS= -L../../lib -L/usr/lib/X11
QNX_LIB_NAME= ../../lib/lib_mtf_zil.a
QNX_CPP= CC
QNX_LINK= CC

QNX_CPP_OPTS=
QNX_LINK_OPTS= -@3m -N48k

QNX_OBJS=
QNX_LIBS= -l$(QNX_LIB_NAME) -lXm_s -lXt_s -lX11_s -lXqnx_s -lsocket

.cpp.o:
	$(QNX_CPP) $(QNX_CPP_OPTS) $(QNX_INC_DIRS) -c $<

.cpp.o32:
	$(D32_CPP) $(D32_CPP_OPTS) -fo=$[*.o32 $<

.c.o32:
	$(D32_CPP) $(D32_CPP_OPTS) -fo=$[*.o32 $<

.cpp.obw:
	$(WIN_CPP) $(WIN_CPP_OPTS) -fo=$[*.obw $<

.cpp.obo:
	$(OS2_CPP) $(OS2_CPP_OPTS) -fo=$[*.obo $<

.cpp.obm:
	$(DVX_CPP) $(DVX_CPP_OPTS) -fo=$[*.obm $<

# ----- Usage --------------------------------------------------------------
usage: .SYMBOLIC
	@echo ...........
	@echo ...........
	@echo To make this Zinc example for ow18 C++ type:
	@echo wmake -f ow18.mak dos32
	@echo wmake -f ow18.mak os2
	@echo wmake -f ow18.mak windows
	@echo wmake -f ow18.mak winnt
	@echo wmake -f ow18.mak win32
	@echo wmake -f ow18.mak dvx
	@echo make -f ow18.mak qnx
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean: .SYMBOLIC
	z_clean

# ----- DOS extender --------------------------------------------------------
dos32: vlist.exe .SYMBOLIC

vlist.exe: vlist.o32 g_jump.o32
	$(D32_LINK) $(D32_LINK_OPTS) N vlist.exe F vlist.o32,g_jump.o32 $(D32_OBJS) L $(D32_LIBS)

# ----- Windows -------------------------------------------------------------
windows: wvlist.exe .SYMBOLIC

wvlist.exe: vlist.obw g_jump.obw
	$(WIN_LINK) $(WIN_LINK_OPTS) N wvlist F vlist.obw,g_jump.obw $(WIN_OBJS) L $(WIN_LIBS)
#	wrc $(WIN_RC_OPTS) $*.rc $*.exe

# ----- Windows NT (and WIN32s) ---------------------------------------------
winnt: nvlist.exe .SYMBOLIC

nvlist.exe: vlist.obn g_jump.obn
	$(WNT_LINK) $(WNT_LINK_OPTS) N nvlist F vlist.obn,g_jump.obn $(WNT_OBJS) L $(WNT_LIBS)
#	wrc $(WNT_RC_OPTS) nvlist nvlist

# ----- 32 bit Windows ------------------------------------------------------
win32: 9vlist.exe .SYMBOLIC

9vlist.exe: vlist.ob9 g_jump.ob9
	$(W32_LINK) $(W32_LINK_OPTS) N 9vlist F vlist.ob9,g_jump.ob9 $(W32_OBJS) L $(W32_LIBS)
#	wrc $(W32_RC_OPTS) 9vlist 9vlist

# ----- OS/2 ----------------------------------------------------------------
os2: ovlist.exe .SYMBOLIC

ovlist.exe: vlist.obo g_jump.obo
	$(OS2_LINK) $(OS2_LINK_OPTS) N ovlist.exe F vlist.obo,g_jump.obo $(OS2_OBJS) L $(OS2_LIBS)

# ----- DESQview/X Motif ----------------------------------------------------
dvx: mvlist.exe .SYMBOLIC

mvlist.exe: vlist.obm g_jump.obm
	$(DVX_LINK) $(DVX_LINK_OPTS) N mvlist.exe F vlist.obm,g_jump.obm $(DVX_OBJS) L $(DVX_LIBS)

# ----- QNX Motif -----------------------------------------------------------
qnx: vlist

vlist: vlist.o g_jump.o
	$(QNX_LINK) $(QNX_LINK_OPTS) -o $@ vlist.o g_jump.o $(QNX_LIB_DIRS) $(QNX_LIBS)

qclean:
	rm -f vlist *.o
