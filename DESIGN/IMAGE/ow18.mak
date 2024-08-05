# ----- General Definitions -------------------------------------------------
VERSION=ow18

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
QNX_MODULE_LIB= ../../lib/libZimage.a
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
dos32: imgedit.exe .SYMBOLIC
	copy imgedit.exe ..\..\bin

imgedit.exe: main.o32 image.lib
	%create d32_zil.rsp
	@%append d32_zil.rsp $(D32_LINK_OPTS)
	@%append d32_zil.rsp N imgedit
	@%append d32_zil.rsp F main.o32
	@%append d32_zil.rsp L image.lib,storage.lib,stredit.lib,direct.lib
	@%append d32_zil.rsp L service.lib$(D32_LIBS)
	$(D32_LINK) @d32_zil.rsp
	del d32_zil.rsp

image.lib : odib.o32 odib1.o32 odib2.o32 &
	wdib.o32 wdib1.o32 wdib2.o32 &
	wico.o32 wico1.o32 wico2.o32 &
	xpm.o32 xpm1.o32 xpm2.o32 &
	znc1.o32 znc2.o32 &
	image.o32 image1.o32 image2.o32 color.o32 draw.o32 &
	export.o32 import.o32 &
	d_image.o32
	
	-@del image.lib
	$(D32_LIBRARIAN) $(D32_LIB_OPTS) @image.wcc

	copy image.hpp ..\..\include
	copy image.lib ..\..\lib\$(VERSION)
	copy p_image.dat ..\..\bin\p_image.znc

# ----- Windows -------------------------------------------------------------
windows: wimgedit.exe .SYMBOLIC
	copy wimgedit.exe ..\..\bin

wimgedit.exe: main.obw wimage.lib
	%create win_zil.rsp
	@%append win_zil.rsp $(WIN_LINK_OPTS)
	@%append win_zil.rsp N wimgedit
	@%append win_zil.rsp F main.obw
	@%append win_zil.rsp L wimage.lib,wstorage.lib,wstredit.lib,wdirect.lib
	@%append win_zil.rsp L wservice.lib$(WIN_LIBS)
	$(WIN_LINK) @win_zil.rsp
	del win_zil.rsp

wimage.lib : odib.obw odib1.obw odib2.obw &
	wdib.obw wdib1.obw wdib2.obw &
	wico.obw wico1.obw wico2.obw &
	xpm.obw xpm1.obw xpm2.obw &
	znc1.obw znc2.obw &
	image.obw image1.obw image2.obw color.obw draw.obw &
	export.obw import.obw &
	w_image.obw
	
	-@del wimage.lib
	$(WIN_LIBRARIAN) $(WIN_LIB_OPTS) @wimage.wcc

	copy image.hpp ..\..\include
	copy wimage.lib ..\..\lib\$(VERSION)
	copy p_image.dat ..\..\bin\p_image.znc

# ----- Windows NT (and WIN32s) ---------------------------------------------
winnt: nimgedit.exe .SYMBOLIC
	copy nimgedit.exe ..\..\bin

nimgedit.exe: main.obn nimage.lib
	%create wnt_zil.rsp
	@%append wnt_zil.rsp $(WNT_LINK_OPTS)
	@%append wnt_zil.rsp N nimgedit
	@%append wnt_zil.rsp F main.obn
	@%append wnt_zil.rsp L nimage.lib,nstorage.lib,nstredit.lib,ndirect.lib
	@%append wnt_zil.rsp L nservice.lib$(WNT_LIBS)
	$(WNT_LINK) @wnt_zil.rsp
	del wnt_zil.rsp

nimage.lib : odib.obn odib1.obn odib2.obn &
	wdib.obn wdib1.obn wdib2.obn &
	wico.obn wico1.obn wico2.obn &
	xpm.obn xpm1.obn xpm2.obn &
	znc1.obn znc2.obn &
	image.obn image1.obn image2.obn color.obn draw.obn &
	export.obn import.obn &
	w_image.obn
	
	-@del nimage.lib
	$(WNT_LIBRARIAN) $(WNT_LIB_OPTS) @nimage.wcc

	copy image.hpp ..\..\include
	copy nimage.lib ..\..\lib\$(VERSION)
	copy p_image.dat ..\..\bin\p_image.znc

# ----- 32 bit Windows ------------------------------------------------------
win32: 9imgedit.exe .SYMBOLIC
	copy 9imgedit.exe ..\..\bin

9imgedit.exe: main.ob9 9image.lib
	%create w32_zil.rsp
	@%append w32_zil.rsp $(W32_LINK_OPTS)
	@%append w32_zil.rsp N 9imgedit
	@%append w32_zil.rsp F main.ob9
	@%append w32_zil.rsp L 9image.lib,9storage.lib,9stredit.lib,9direct.lib
	@%append w32_zil.rsp L 9service.lib$(W32_LIBS)
	$(W32_LINK) @w32_zil.rsp
	del w32_zil.rsp

9image.lib : odib.ob9 odib1.ob9 odib2.ob9 &
	wdib.ob9 wdib1.ob9 wdib2.ob9 &
	wico.ob9 wico1.ob9 wico2.ob9 &
	xpm.ob9 xpm1.ob9 xpm2.ob9 &
	znc1.ob9 znc2.ob9 &
	image.ob9 image1.ob9 image2.ob9 color.ob9 draw.ob9 &
	export.ob9 import.ob9 &
	w_image.ob9

	-@del 9image.lib
	$(W32_LIBRARIAN) $(W32_LIB_OPTS) @9image.wcc

	copy image.hpp ..\..\include
	copy 9image.lib ..\..\lib\$(VERSION)
	copy p_image.dat ..\..\bin\p_image.znc

# ----- OS/2 ----------------------------------------------------------------
os2: oimgedit.exe .SYMBOLIC
	copy oimgedit.exe ..\..\bin

oimgedit.exe: main.obo oimage.lib
	%create os2_zil.rsp
	@%append os2_zil.rsp $(OS2_LINK_OPTS)
	@%append os2_zil.rsp N oimgedit
	@%append os2_zil.rsp F main.obo
	@%append os2_zil.rsp L oimage.lib,ostorage.lib,ostredit.lib,odirect.lib
	@%append os2_zil.rsp L oservice.lib$(OS2_LIBS)
	$(OS2_LINK) @os2_zil.rsp
	del os2_zil.rsp

oimage.lib : odib.obo odib1.obo odib2.obo &
	wdib.obo wdib1.obo wdib2.obo &
	wico.obo wico1.obo wico2.obo &
	xpm.obo xpm1.obo xpm2.obo &
	znc1.obo znc2.obo &
	image.obo image1.obo image2.obo color.obo draw.obo &
	export.obo import.obo &
	o_image.obo
	
	-@del oimage.lib
	$(OS2_LIBRARIAN) $(OS2_LIB_OPTS) @oimage.wcc

	copy image.hpp ..\..\include
	copy oimage.lib ..\..\lib\$(VERSION)
	copy p_image.dat ..\..\bin\p_image.znc

# ----- DESQview/X Motif ----------------------------------------------------
dvx: mimgedit.exe .SYMBOLIC
	copy mimgedit.exe ..\..\bin

mimgedit.exe: main.obm mimage.lib
	%create dvx_zil.rsp
	@%append dvx_zil.rsp $(DVX_LINK_OPTS)
	@%append dvx_zil.rsp N mimgedit
	@%append dvx_zil.rsp F main.obm
	@%append dvx_zil.rsp L mimage.lib,mstorage.lib,mstredit.lib,mdirect.lib
	@%append dvx_zil.rsp L mservice.lib$(DVX_LIBS)
	$(DVX_LINK) @dvx_zil.rsp
	del dvx_zil.rsp

mimage.lib : odib.obm odib1.obm odib2.obm &
	wdib.obm wdib1.obm wdib2.obm &
	wico.obm wico1.obm wico2.obm &
	xpm.obm xpm1.obm xpm2.obm &
	znc1.obm znc2.obm &
	image.obm image1.obm image2.obm color.obm draw.obm &
	export.obm import.obm &
	m_image.obm
	
	-@del mimage.lib
	$(DVX_LIBRARIAN) $(DVX_LIB_OPTS) @mimage.wcc

	copy image.hpp ..\..\include
	copy mimage.lib ..\..\lib\$(VERSION)
	copy p_image.dat ..\..\bin\p_image.znc

# ----- QNX Motif Libraries and Programs -----------------------------
qnx: main
	cp main ../../bin

main: main.o $(QNX_MODULE_LIB)
	$(QNX_LINK) $(QNX_LINK_OPTS) -o $@ $@.o $(QNX_LIB_DIRS) $(QNX_LIBS)

qnx_module: $(QNX_MODULE_LIB)

$(QNX_MODULE_LIB): odib.o odib1.o odib2.o \
	wdib.o wdib1.o wdib2.o \
	wico.o wico1.o wico2.o \
	xpm.o xpm1.o xpm2.o \
	znc1.o znc2.o \
	image.o image1.o image2.o color.o draw.o \
	export.o import.o \
	m_image.o
	rm -f $(QNX_MODULE_LIB)
	$(QNX_LIBRARIAN) $(QNX_LIB_OPTS) $@ $?
	cp image.hpp ../../include
	cp p_image.dat ../../bin/p_image.znc
	
qclean:
	rm -f $(QNX_MODULE_LIB) main *.o
