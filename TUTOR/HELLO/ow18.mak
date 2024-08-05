# HELLO example makefile

#    wmake -f ow18.mak dos32       (makes the DOS hello tutorial)
#    wmake -f ow18.mak windows     (makes the Windows hello tutorial)
#    wmake -f ow18.mak winnt       (makes the Windows NT hello tutorial)
#    wmake -f ow18.mak win32       (makes the Windows NT hello tutorial)
#    wmake -f ow18.mak os2         (makes the OS/2 hello tutorial)
#    wmake -f ow18.mak dvx         (makes the DESQView/X hello tutorial)
#    make -f ow18.mak qnx          (makes the QNX hello tutorial)

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
WIN_LINK_OPTS=SYS windows OP heapsize=16k OP stack=24k
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
DVX_LIBS=dvx_zil,Xm,Xt,X,sys

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
dos32: hello1.exe hello2.exe hello3.exe hellog.exe .SYMBOLIC

hello1.exe: hello1.o32
	$(D32_LINK) $(D32_LINK_OPTS) N hello1.exe F hello1.o32 $(D32_OBJS) L $(D32_LIBS)

hello2.exe: hello2.o32
	$(D32_LINK) $(D32_LINK_OPTS) N hello2.exe F hello2.o32 $(D32_OBJS) L $(D32_LIBS)

hello3.exe: hello3.o32 hello.o32
	$(D32_LINK) $(D32_LINK_OPTS) N hello3.exe F hello3.o32,hello.o32 $(D32_OBJS) L $(D32_LIBS)

hellog.exe: hellog.o32
	$(D32_LINK) $(D32_LINK_OPTS) N hellog.exe F hellog.o32 $(D32_OBJS) L $(D32_LIBS)

# ----- Windows -------------------------------------------------------------
windows: whello1.exe whello2.exe whello3.exe whellog.exe .SYMBOLIC

whello1.exe: hello1.obw
	$(WIN_LINK) $(WIN_LINK_OPTS) N whello1 F hello1.obw $(WIN_OBJS) L $(WIN_LIBS)
#	wrc $(WIN_RC_OPTS) $*.rc $*.exe

whello2.exe: hello2.obw
	$(WIN_LINK) $(WIN_LINK_OPTS) N whello2 F hello2.obw $(WIN_OBJS) L $(WIN_LIBS)
#	wrc $(WIN_RC_OPTS) $*.rc $*.exe

whello3.exe: hello3.obw hello.obw
	$(WIN_LINK) $(WIN_LINK_OPTS) N whello3 F hello3.obw,hello.obw $(WIN_OBJS) L $(WIN_LIBS)
#	wrc $(WIN_RC_OPTS) $*.rc $*.exe

whellog.exe: hellog.obw
	$(WIN_LINK) $(WIN_LINK_OPTS) N whellog F hellog.obw $(WIN_OBJS) L $(WIN_LIBS)
#	wrc $(WIN_RC_OPTS) $*.rc $*.exe


# ----- Windows NT (and WIN32s) ---------------------------------------------
winnt: nhello1.exe nhello2.exe nhello3.exe nhellog.exe .SYMBOLIC

nhello1.exe: hello1.obn
	$(WNT_LINK) $(WNT_LINK_OPTS) N nhello1 F hello1.obn$(WNT_OBJS) L $(WNT_LIBS)
#	wrc $(WNT_RC_OPTS) nhello1 nhello1

nhello2.exe: hello2.obn
	$(WNT_LINK) $(WNT_LINK_OPTS) N nhello2 F hello2.obn$(WNT_OBJS) L $(WNT_LIBS)
#	wrc $(WNT_RC_OPTS) nhello2 nhello2

nhello3.exe: hello3.obn hello.obn
	$(WNT_LINK) $(WNT_LINK_OPTS) N nhello3 F hello3.obn,hello.obn$(WNT_OBJS) L $(WNT_LIBS)
#	wrc $(WNT_RC_OPTS) nhello3 nhello3

nhellog.exe: hellog.obn
	$(WNT_LINK) $(WNT_LINK_OPTS) N nhellog F hellog.obn$(WNT_OBJS) L $(WNT_LIBS)
#	wrc $(WNT_RC_OPTS) nhellog nhellog

# ----- 32 bit Windows ------------------------------------------------------
win32: 9hello1.exe 9hello2.exe 9hello3.exe 9hellog.exe .SYMBOLIC

9hello1.exe: hello1.ob9
	$(W32_LINK) $(W32_LINK_OPTS) N 9hello1 F hello1.ob9$(W32_OBJS) L $(W32_LIBS)
#	wrc $(W32_RC_OPTS) 9hello1 9hello1

9hello2.exe: hello2.ob9
	$(W32_LINK) $(W32_LINK_OPTS) N 9hello2 F hello2.ob9$(W32_OBJS) L $(W32_LIBS)
#	wrc $(W32_RC_OPTS) 9hello2 9hello2

9hello3.exe: hello3.ob9 hello.ob9
	$(W32_LINK) $(W32_LINK_OPTS) N 9hello3 F hello3.ob9,hello.ob9$(W32_OBJS) L $(W32_LIBS)
#	wrc $(W32_RC_OPTS) 9hello3 9hello3

9hellog.exe: hellog.ob9
	$(W32_LINK) $(W32_LINK_OPTS) N 9hellog F hellog.ob9$(W32_OBJS) L $(W32_LIBS)
#	wrc $(W32_RC_OPTS) 9hellog 9hellog

# ----- OS/2 ----------------------------------------------------------------
os2: ohello1.exe ohello2.exe ohello3.exe ohellog.exe .SYMBOLIC

ohello1.exe: hello1.obo
	$(OS2_LINK) $(OS2_LINK_OPTS) N ohello1.exe F hello1.obo $(OS2_OBJS) L $(OS2_LIBS)
	$(OS2_RC) $(OS2_RC_OPTS) $*.exe

ohello2.exe: hello2.obo
	$(OS2_LINK) $(OS2_LINK_OPTS) N ohello2.exe F hello2.obo $(OS2_OBJS) L $(OS2_LIBS)
	$(OS2_RC) $(OS2_RC_OPTS) $*.exe

ohello3.exe: hello3.obo hello.obo
	$(OS2_LINK) $(OS2_LINK_OPTS) N ohello3.exe F hello3.obo,hello.obo $(OS2_OBJS) L $(OS2_LIBS)
	$(OS2_RC) $(OS2_RC_OPTS) $*.exe

ohellog.exe: hellog.obo
	$(OS2_LINK) $(OS2_LINK_OPTS) N ohellog.exe F hellog.obo $(OS2_OBJS) L $(OS2_LIBS)
	$(OS2_RC) $(OS2_RC_OPTS) $*.exe


# ----- DESQview/X Motif ----------------------------------------------------
dvx: mhello1.exe mhello2.exe mhello3.exe mhellog.exe .SYMBOLIC

mhello1.exe: hello1.obm
	$(DVX_LINK) $(DVX_LINK_OPTS) N mhello1.exe F hello1.obm $(DVX_OBJS) L $(DVX_LIBS)

mhello2.exe: hello2.obm
	$(DVX_LINK) $(DVX_LINK_OPTS) N mhello2.exe F hello2.obm $(DVX_OBJS) L $(DVX_LIBS)

mhello3.exe: hello3.obm hello.obm
	$(DVX_LINK) $(DVX_LINK_OPTS) N mhello3.exe F hello3.obm,hello.obm $(DVX_OBJS) L $(DVX_LIBS)

mhellog.exe: hellog.obm
	$(DVX_LINK) $(DVX_LINK_OPTS) N mhellog.exe F hellog.obm $(DVX_OBJS) L $(DVX_LIBS)

# ----- QNX Motif -----------------------------------------------------------
qnx: hello1 hello2 hello3 hellog

hello1: hello1.o
	$(QNX_LINK) $(QNX_LINK_OPTS) -o $@ hello1.o $(QNX_LIB_DIRS) $(QNX_LIBS)

hello2: hello2.o
	$(QNX_LINK) $(QNX_LINK_OPTS) -o $@ hello2.o $(QNX_LIB_DIRS) $(QNX_LIBS)

hello3: hello3.o hello.o
	$(QNX_LINK) $(QNX_LINK_OPTS) -o $@ hello3.o hello.o $(QNX_LIB_DIRS) $(QNX_LIBS)

hellog: hellog.o
	$(QNX_LINK) $(QNX_LINK_OPTS) -o $@ hellog.o $(QNX_LIB_DIRS) $(QNX_LIBS)

qclean:
	rm -f hello1 hello2 hello3 hellog *.o
