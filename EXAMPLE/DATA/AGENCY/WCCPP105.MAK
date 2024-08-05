PROG = agency
#    wmake -f wccpp.mak dos32
#    wmake -f wccpp.mak windows
#    wmake -f wccpp.mak winnt
#    wmake -f wccpp.mak win32
#    wmake -f wccpp.mak os2
#    wmake -f wccpp.mak dvx
#    wmake -f wccpp.mak qnx

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
D32_CPP=wpp386
D32_LINK=wlink
D32_CPP_OPTS=/bt=dos
D32_LINK_OPTS=SYSTEM dos4g OP stack=20000

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
WIN_LINK_OPTS=SYS windows OP heapsize=16k OP stack=34k
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

W32_CPP_OPTS=/bt=nt /DZIL_WIN32
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
OS2_RC=rc
OS2_CPP_OPTS=/bt=OS2
OS2_LINK_OPTS=SYSTEM os2v2_pm OP ST=96000
OS2_RC_OPTS=
OS2_OBJS=
OS2_LIBS=os2_zil

# ----- DESQview/X MOTIF compiler options -----------------------------------
DVX_CPP=wpp386
DVX_LINK=wlink
DVX_CPP_OPTS=-d__DVX__ -zp4 -zq -4s
DVX_LINK_OPTS=SYSTEM dos4g OP quiet OP stack=56000
DVX_OBJS=
DVX_LIBS=dvx_zil,Xm,Xt,X,sys

# ----- QNX Motif compiler options -----------------------------------------
QNX_INC_DIRS= -I../../../include
QNX_LIB_DIRS= -L../../../lib -L/usr/lib/X11
QNX_LIB_NAME= ../../../lib/lib_mtf_zil.a
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
	@echo To make this Zinc example for Watcom C++ type:
	@echo wmake -f wccpp.mak dos32
	@echo wmake -f wccpp.mak os2
	@echo wmake -f wccpp.mak windows
	@echo wmake -f wccpp.mak winnt
	@echo wmake -f wccpp.mak win32
	@echo wmake -f wccpp.mak dvx
	@echo make -f wccpp.mak qnx
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean: .SYMBOLIC
	z_clean

# ----- DOS extender --------------------------------------------------------
dos32: $(PROG).exe .SYMBOLIC

$(PROG).exe: $(PROG).o32
	$(D32_LINK) $(D32_LINK_OPTS) N $(PROG).exe F $(PROG).o32 $(D32_OBJS) L $(D32_LIBS)

# ----- Windows -------------------------------------------------------------
windows: w$(PROG).exe .SYMBOLIC

w$(PROG).exe: $(PROG).obw
	$(WIN_LINK) $(WIN_LINK_OPTS) N w$(PROG) F $(PROG).obw $(WIN_OBJS) L $(WIN_LIBS)
#	wrc $(WIN_RC_OPTS) windows.rc $*.exe

# ----- Windows NT (and WIN32s) ---------------------------------------------
winnt: n$(PROG).exe .SYMBOLIC

n$(PROG).exe: $(PROG).obn
	$(WNT_LINK) $(WNT_LINK_OPTS) N n$(PROG) F $(PROG).obn$(WNT_OBJS) L $(WNT_LIBS)
#	wrc $(WNT_RC_OPTS) winnt n$(PROG)

# ----- 32 bit Windows ------------------------------------------------------
win32: 9$(PROG).exe .SYMBOLIC

9$(PROG).exe: $(PROG).ob9
	$(W32_LINK) $(W32_LINK_OPTS) N 9$(PROG) F $(PROG).ob9$(W32_OBJS) L $(W32_LIBS)
#	wrc $(W32_RC_OPTS) win32 9$(PROG)

# ----- OS/2 ----------------------------------------------------------------
os2: o$(PROG).exe .SYMBOLIC

o$(PROG).exe: $(PROG).obo
	$(OS2_LINK) $(OS2_LINK_OPTS) N o$(PROG).exe F $(PROG).obo $(OS2_OBJS) L $(OS2_LIBS)
	#       $(OS2_RC) $(OS2_RC_OPTS) os2.rc $*.exe

# ----- DESQview/X Motif ----------------------------------------------------
dvx: m$(PROG).exe .SYMBOLIC

m$(PROG).exe: $(PROG).obm
	$(DVX_LINK) $(DVX_LINK_OPTS) N m$(PROG).exe F $(PROG).obm $(DVX_OBJS) L $(DVX_LIBS)

# ----- QNX Motif -----------------------------------------------------------
qnx: $(PROG)

$(PROG): $(PROG).o
	$(QNX_LINK) $(QNX_LINK_OPTS) -o $@ $@.o $(QNX_LIB_DIRS) $(QNX_LIBS)

qclean:
	rm -f $(PROG) $(PROG).o
