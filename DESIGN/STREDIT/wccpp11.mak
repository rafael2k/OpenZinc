# ----- General Definitions -------------------------------------------------
VERSION=wccpp11

.EXTENSIONS:
.EXTENSIONS: .o32 .obw .obn .ob9 .obo .obm .o .cpp

# ----- DOS extender compiler options ---------------------------------------
D32_CPP=wpp386
D32_LINK=wlink
D32_LIBRARIAN=wlib
D32_CPP_OPTS=/bt=dos
D32_LINK_OPTS=SYSTEM dos4g OP stack=20000
D32_LIB_OPTS=-p=64

# --- Use the next line for UI_GRAPHICS_DISPLAY ---
#D32_OBJS=
#D32_LIBS=d32_zil,d32_gfx,wc_32gfx
# --- Use the next line for UI_WCC_DISPLAY ---
D32_OBJS=
D32_LIBS=d32_zil,d32_wcc

# ----- Windows compiler options --------------------------------------------
WIN_CPP=wpp
WIN_LINK=wlink
WIN_LIBRARIAN=wlib
WIN_RC=wrc
WIN_LIB_OPTS=/p=64
WIN_CPP_OPTS= -zW -oaxt -w4 -ml
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

# ----- OS/2 compiler options -----------------------------------------------
OS2_CPP=wpp386
OS2_LINK=wlink
OS2_LIBRARIAN=wlib
OS2_RC=rc
OS2_CPP_OPTS=/bt=OS2
OS2_LINK_OPTS=SYSTEM os2v2_pm OP ST=96000
OS2_LIB_OPTS=/p=64
OS2_RC_OPTS=
OS2_OBJS=
OS2_LIBS=os2_zil

# ----- DESQview/X MOTIF compiler options -----------------------------------
DVX_CPP=wpp386
DVX_LINK=wlink
DVX_LIBRARIAN=wlib
DVX_CPP_OPTS=-d__DVX__ -zp4 -zq -4s
DVX_LINK_OPTS=SYSTEM dos4g OP quiet OP stack=20000
DVX_LIB_OPTS=-p=32
DVX_OBJS=
DVX_LIBS=dvx_zil,xm,xt,x,sys

# ----- QNX Motif compiler options -----------------------------------------
QNX_INC_DIRS= -I../../include
QNX_LIB_DIRS= -L../../lib -L/usr/lib/X11
QNX_LIB_NAME= ../../lib/lib_mtf_zil.a
QNX_MODULE_LIB= ../../lib/libZstredit.a
QNX_DESIGN_LIBS= -l../../lib/libZservice.a
QNX_CPP= CC
QNX_LINK= CC
QNX_LIBRARIAN= wlib

QNX_CPP_OPTS=
QNX_LINK_OPTS= -@3m
QNX_LIB_OPTS= -p=128

QNX_OBJS=
QNX_LIBS= -l$(QNX_LIB_NAME) -l$(QNX_MODULE_LIB) $(QNX_DESIGN_LIBS) \
	-lXm_s -lXt_s -lX11_s -lXqnx_s -lsocket

.cpp.o:
	$(QNX_CPP) $(QNX_CPP_OPTS) $(QNX_INC_DIRS) -c $<

.cpp.o32:
	$(D32_CPP) $(D32_CPP_OPTS) -fo=$[*.o32 $<

.cpp.obw:
	$(WIN_CPP) $(WIN_CPP_OPTS) -fo=$[*.obw $<

.cpp.obn:
	$(WNT_CPP) $(WNT_CPP_OPTS) -fo=$[*.obn $<

.cpp.ob9:
	$(W32_CPP) $(W32_CPP_OPTS) -fo=$[*.ob9 $<

.cpp.obo:
	$(OS2_CPP) $(OS2_CPP_OPTS) -fo=$[*.obo $<

.cpp.obm:
	$(DVX_CPP) $(DVX_CPP_OPTS) -fo=$[*.obm $<

# ----- Clean ---------------------------------------------------------------
clean: .SYMBOLIC
	z_clean

# ----- DOS extender --------------------------------------------------------
dos32: stredit.exe .SYMBOLIC

stredit.exe: main.o32 stredit.lib
	%create d32_zil.rsp
	@%append d32_zil.rsp $(D32_LINK_OPTS)
	@%append d32_zil.rsp N stredit
	@%append d32_zil.rsp F main.o32
	@%append d32_zil.rsp L stredit.lib service.lib $(D32_LIBS)
	$(D32_LINK) @d32_zil.rsp
	del d32_zil.rsp

stredit.lib : stredit.o32
	-@del stredit.lib
	$(D32_LIBRARIAN) $(D32_LIB_OPTS) $* +stredit.o32

	copy stredit.hpp ..\..\include
	copy stredit.lib ..\..\lib\$(VERSION)
	copy p_string.dat ..\..\bin\p_string.znc

# ----- Windows -------------------------------------------------------------
windows: wstredit.exe .SYMBOLIC

wstredit.exe: main.obw wstredit.lib
	%create win_zil.rsp
	@%append win_zil.rsp $(WIN_LINK_OPTS)
	@%append win_zil.rsp N wstredit
	@%append win_zil.rsp F main.obw
	@%append win_zil.rsp L wstredit.lib wservice.lib $(WIN_LIBS)
	$(WIN_LINK) @win_zil.rsp
	del win_zil.rsp

wstredit.lib : stredit.obw
	-@del wstredit.lib
	$(WIN_LIBRARIAN) $(WIN_LIB_OPTS) $* +stredit.obw

	copy stredit.hpp ..\..\include
	copy wstredit.lib ..\..\lib\$(VERSION)
	copy p_string.dat ..\..\bin\p_string.znc

# ----- Windows NT (and WIN32s) ---------------------------------------------
winnt: nstredit.exe .SYMBOLIC

nstredit.exe: main.obn nstredit.lib
	%create wnt_zil.rsp
	@%append wnt_zil.rsp $(WNT_LINK_OPTS)
	@%append wnt_zil.rsp N nstredit
	@%append wnt_zil.rsp F main.obn
	@%append wnt_zil.rsp L nstredit.lib nservice.lib $(WNT_LIBS)
	$(WNT_LINK) @wnt_zil.rsp
	del wnt_zil.rsp

nstredit.lib : stredit.obn
	-@del nstredit.lib
	$(WNT_LIBRARIAN) $(WNT_LIB_OPTS) $* +stredit.obn

	copy stredit.hpp ..\..\include
	copy nstredit.lib ..\..\lib\$(VERSION)
	copy p_string.dat ..\..\bin\p_string.znc

# ----- 32 bit Windows ------------------------------------------------------
win32: 9stredit.exe .SYMBOLIC

9stredit.exe: main.ob9 9stredit.lib
	%create w32_zil.rsp
	@%append w32_zil.rsp $(W32_LINK_OPTS)
	@%append w32_zil.rsp N 9stredit
	@%append w32_zil.rsp F main.ob9
	@%append w32_zil.rsp L 9stredit.lib 9service.lib $(W32_LIBS)
	$(W32_LINK) @w32_zil.rsp
	del w32_zil.rsp

9stredit.lib : stredit.ob9
	-@del 9stredit.lib
	$(W32_LIBRARIAN) $(W32_LIB_OPTS) $* +stredit.ob9

	copy stredit.hpp ..\..\include
	copy 9stredit.lib ..\..\lib\$(VERSION)
	copy p_string.dat ..\..\bin\p_string.znc

# ----- OS/2 ----------------------------------------------------------------
os2: ostredit.exe .SYMBOLIC

ostredit.exe: main.obo ostredit.lib
	%create os2_zil.rsp
	@%append os2_zil.rsp $(OS2_LINK_OPTS)
	@%append os2_zil.rsp N ostredit
	@%append os2_zil.rsp F main.obo
	@%append os2_zil.rsp L ostredit.lib oservice.lib $(OS2_LIBS)
	$(OS2_LINK) @os2_zil.rsp
	del os2_zil.rsp

ostredit.lib : stredit.obo
	-@del ostredit.lib
	$(OS2_LIBRARIAN) $(OS2_LIB_OPTS) $* +stredit.obo

	copy stredit.hpp ..\..\include
	copy ostredit.lib ..\..\lib\$(VERSION)
	copy p_string.dat ..\..\bin\p_string.znc

# ----- DESQview/X Motif ----------------------------------------------------
dvx: mstredit.exe .SYMBOLIC

mstredit.exe: main.obm mstredit.lib
	%create dvx_zil.rsp
	@%append dvx_zil.rsp $(DVX_LINK_OPTS)
	@%append dvx_zil.rsp N mstredit
	@%append dvx_zil.rsp F main.obm
	@%append dvx_zil.rsp L mstredit.lib mservice.lib $(DVX_LIBS)
	$(DVX_LINK) @dvx_zil.rsp
	del dvx_zil.rsp

mstredit.lib : stredit.obm
	-@del mstredit.lib
	$(DVX_LIBRARIAN) $(DVX_LIB_OPTS) $* +stredit.obm

	copy stredit.hpp ..\..\include
	copy mstredit.lib ..\..\lib\$(VERSION)
	copy p_string.dat ..\..\bin\p_string.znc

# ----- QNX Motif Libraries and Programs -----------------------------
qnx: main
	cp main ../../bin

main: main.o $(QNX_MODULE_LIB)
	$(QNX_LINK) $(QNX_LINK_OPTS) -o $@ $@.o $(QNX_LIB_DIRS) $(QNX_LIBS)

qnx_module: $(QNX_MODULE_LIB)

$(QNX_MODULE_LIB): stredit.o
	rm -f $(QNX_MODULE_LIB)
	$(QNX_LIBRARIAN) $(QNX_LIB_OPTS) $@ $?
	cp stredit.hpp ../../include
	cp p_string.dat ../../bin/p_string.znc
	
qclean:
	rm -f $(QNX_MODULE_LIB) main *.o
