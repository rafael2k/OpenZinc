# ----- General Definitions -------------------------------------------------
VERSION=ow14

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
#D32_LIBS=,d32_zil,d32_gfx,wc_32gfx
# --- Use the next line for UI_WCC_DISPLAY ---
D32_OBJS=
D32_LIBS=,d32_zil,d32_wcc

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
WIN_LIBS=,windows,win_zil

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
WNT_LIBS=,nt,wnt_zil

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
W32_LIBS=,nt,w32_zil

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
OS2_LIBS=,os2_zil

# ----- DESQview/X MOTIF compiler options -----------------------------------
DVX_CPP=wpp386
DVX_LINK=wlink
DVX_LIBRARIAN=wlib
DVX_CPP_OPTS=-d__DVX__ -zp4 -zq -4s
DVX_LINK_OPTS=SYSTEM dos4g OP quiet OP stack=20000
DVX_LIB_OPTS=-p=32
DVX_OBJS=
DVX_LIBS=,dvx_zil,xm,xt,x,sys

# ----- QNX Motif compiler options -----------------------------------------
QNX_INC_DIRS= -I../../include
QNX_LIB_DIRS= -L../../lib -L/usr/lib/X11
QNX_LIB_NAME= ../../lib/lib_mtf_zil.a
QNX_MODULE_LIB= ../../lib/libZmessage.a
QNX_DESIGN_LIBS= -l../../lib/libZstorage.a -l../../lib/libZstredit.a \
	-l../../lib/libZdirect.a -l../../lib/libZservice.a
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
dos32: msgedit.exe .SYMBOLIC
	copy msgedit.exe ..\..\bin

msgedit.exe: main.o32 message.lib
	%create d32_zil.rsp
	@%append d32_zil.rsp $(D32_LINK_OPTS)
	@%append d32_zil.rsp N msgedit
	@%append d32_zil.rsp F main.o32 
	@%append d32_zil.rsp L message.lib, storage.lib, stredit.lib, direct.lib
	@%append d32_zil.rsp L service.lib$(D32_LIBS)
	$(D32_LINK) @d32_zil.rsp
	del d32_zil.rsp

message.lib : message.o32 message1.o32 prefer.o32 &
	import.o32 export.o32
	-@del message.lib
	$(D32_LIBRARIAN) $(D32_LIB_OPTS) @message.wcc

	copy message.hpp ..\..\include
	copy message.lib ..\..\lib\$(VERSION)
	copy p_messag.dat ..\..\bin\p_messag.znc

# ----- Windows -------------------------------------------------------------
windows: wmsgedit.exe .SYMBOLIC
	copy wmsgedit.exe ..\..\bin

wmsgedit.exe: main.obw wmessage.lib
	%create win_zil.rsp
	@%append win_zil.rsp $(WIN_LINK_OPTS)
	@%append win_zil.rsp N wmsgedit
	@%append win_zil.rsp F main.obw
	@%append win_zil.rsp L wmessage.lib,wstorage.lib,wstredit.lib,wdirect.lib
	@%append win_zil.rsp L wservice.lib$(WIN_LIBS)
	$(WIN_LINK) @win_zil.rsp
	del win_zil.rsp

wmessage.lib : message.obw message1.obw prefer.obw &
	import.obw export.obw
	-@del wmessage.lib
	$(WIN_LIBRARIAN) $(WIN_LIB_OPTS) $*  +message.obw  +message1.obw +prefer.obw &
	+import.obw +export.obw

	copy message.hpp ..\..\include
	copy wmessage.lib ..\..\lib\$(VERSION)
	copy p_messag.dat ..\..\bin\p_messag.znc

# ----- Windows NT (and WIN32s) ---------------------------------------------
winnt: nmsgedit.exe .SYMBOLIC
	copy nmsgedit.exe ..\..\bin

nmsgedit.exe:  nmessage.lib
	%create wnt_zil.rsp
	@%append wnt_zil.rsp $(WNT_LINK_OPTS)
	@%append wnt_zil.rsp N nmsgedit
	@%append wnt_zil.rsp F main.obn
	@%append wnt_zil.rsp L nmessage.lib,nstorage.lib,nstredit.lib,ndirect.lib
	@%append wnt_zil.rsp L nservice.lib$(WNT_LIBS)
	$(WNT_LINK) @wnt_zil.rsp
	del wnt_zil.rsp

nmessage.lib : message.obn message1.obn prefer.obn &
	import.obn export.obn
	-@del nmessage.lib
	$(WNT_LIBRARIAN) $(WNT_LIB_OPTS) $* +message.obn  +message1.obn +prefer.obn &
	+import.obn +export.obn

	copy message.hpp ..\..\include
	copy nmessage.lib ..\..\lib\$(VERSION)
	copy p_messag.dat ..\..\bin\p_messag.znc

# ----- 32 bit Windows ------------------------------------------------------
win32: 9msgedit.exe .SYMBOLIC
	copy 9msgedit.exe ..\..\bin

9msgedit.exe:  9message.lib
	%create w32_zil.rsp
	@%append w32_zil.rsp $(W32_LINK_OPTS)
	@%append w32_zil.rsp N 9msgedit
	@%append w32_zil.rsp F main.ob9
	@%append w32_zil.rsp L 9message.lib,9storage.lib,9stredit.lib,9direct.lib
	@%append w32_zil.rsp L 9service.lib$(W32_LIBS)
	$(W32_LINK) @w32_zil.rsp
	del w32_zil.rsp

9message.lib : message.ob9 message1.ob9 prefer.ob9 &
	import.ob9 export.ob9
	-@del 9message.lib
	$(W32_LIBRARIAN) $(W32_LIB_OPTS) $* +message.ob9  +message1.ob9 +prefer.ob9 &
	+import.ob9 +export.ob9

	copy message.hpp ..\..\include
	copy 9message.lib ..\..\lib\$(VERSION)
	copy p_messag.dat ..\..\bin\p_messag.znc

# ----- OS/2 ----------------------------------------------------------------
os2: omsgedit.exe .SYMBOLIC
	copy omsgedit.exe ..\..\bin

omsgedit.exe: main.obo omessage.lib
	%create os2_zil.rsp
	@%append os2_zil.rsp $(OS2_LINK_OPTS)
	@%append os2_zil.rsp N omsgedit
	@%append os2_zil.rsp F main.obo
	@%append os2_zil.rsp L omessage.lib,ostorage.lib,ostredit.lib,odirect.lib
	@%append os2_zil.rsp L oservice.lib$(OS2_LIBS)
	$(OS2_LINK) @os2_zil.rsp
	del os2_zil.rsp

omessage.lib : message.obo message1.obo prefer.obo &
	import.obo export.obo
	-@del omessage.lib
	$(OS2_LIBRARIAN) $(OS2_LIB_OPTS) $* +message.obo  +message1.obo +prefer.obo &
	+import.obo +export.obo

	copy message.hpp ..\..\include
	copy omessage.lib ..\..\lib\$(VERSION)
	copy p_messag.dat ..\..\bin\p_messag.znc

# ----- DESQview/X Motif ----------------------------------------------------
dvx: mmsgedit.exe .SYMBOLIC
	copy mmsgedit.exe ..\..\bin

mmsgedit.exe: main.obm mmessage.lib
	%create dvx_zil.rsp
	@%append dvx_zil.rsp $(DVX_LINK_OPTS)
	@%append dvx_zil.rsp N mmsgedit
	@%append dvx_zil.rsp F main.obm
	@%append dvx_zil.rsp L mmessage.lib,mstorage.lib,mstredit.lib,mdirect.lib
	@%append dvx_zil.rsp L mservice.lib$(DVX_LIBS)
	$(DVX_LINK) @dvx_zil.rsp
	del dvx_zil.rsp

mmessage.lib : message.obm message1.obm prefer.obm &
	import.obm export.obm
	-@del mmessage.lib
	$(DVX_LIBRARIAN) $(DVX_LIB_OPTS) $* +message.obm & +message1.obm +prefer.obm &
	+import.obm +export.obm

	copy message.hpp ..\..\include
	copy mmessage.lib ..\..\lib\$(VERSION)
	copy p_messag.dat ..\..\bin\p_messag.znc

# ----- QNX Motif Libraries and Programs -----------------------------
qnx: main
	cp main ../../bin

main: main.o $(QNX_MODULE_LIB)
	$(QNX_LINK) $(QNX_LINK_OPTS) -o $@ $@.o $(QNX_LIB_DIRS) $(QNX_LIBS)

qnx_module: $(QNX_MODULE_LIB)

$(QNX_MODULE_LIB): message.o message1.o prefer.o \
	import.o export.o
	rm -f $(QNX_MODULE_LIB)
	$(QNX_LIBRARIAN) $(QNX_LIB_OPTS) $@ $?
	cp message.hpp ../../include
	cp p_messag.dat ../../bin/p_messag.znc
	
qclean:
	rm -f $(QNX_MODULE_LIB) main *.o
