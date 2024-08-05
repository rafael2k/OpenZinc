# DESIGN makefile

#    wmake -f ow14.mak dos32       (makes the DOS designer)
#    wmake -f ow14.mak windows     (makes the Windows designer)
#    wmake -f ow14.mak winnt       (makes the Windows NT designer)
#    wmake -f ow14.mak os2         (makes the OS/2 designer)
#    wmake -f ow14.mak dvx         (makes the DESQView/X designer)
#    make -f ow14.mak qnx          (makes the QNX designer)

# Be sure to set the LIB and INCLUDE environment variables for Zinc, e.g.:
# DOS:
#    set INCLUDE=.;C:\ow14\H;C:\ZINC\INCLUDE
#    set LIB=.;C:\ow14\LIB386\DOS;C:\ow14\LIB386;C:\ZINC\LIB\ow14
# WINDOWS:
#    set INCLUDE=.;C:\ow14\H;C:\ow14\H\WIN;C:\ZINC\INCLUDE
#    set LIB=.;C:\ow14\LIB286\WIN;C:\ow14\LIB286;C:\ZINC\LIB\ow14
# WIN NT:
#    set INCLUDE=.;C:\ow14\H;C:\ow14\H\NT;C:\ZINC\INCLUDE
#    set LIB=.;C:\ow14\LIB386\NT;C:\ow14\LIB386;C:\ZINC\LIB\ow14
# OS/2:
#    set INCLUDE=.;C:\ow14\H;C:\ow14\H\OS2;C:\ZINC\INCLUDE
#    set LIB=.;C:\ow14\LIB386\OS2;C:\ow14\LIB386;C:\ZINC\LIB\ow14
# DESQView/X:
#    set INCLUDE=.;C:\DVX\INCLUDE;C:\ow14\H;C:\ZINC\INCLUDE
#    set LIB=.;C:\DVX\LIB\C386;C:\ow14\LIB386\DOS;C:\ow14\LIB386;C:\ZINC\LIB\ow14

.EXTENSIONS:
.EXTENSIONS: .o32 .obw .obn .ob9 .obo .obm .o .cpp .c

# Compiler and linker: (Add -d2 to CPP_OPTS and DEBUG ALL to LINK_OPTS for debug.)

# ----- DOS extender compiler options ---------------------------------------
D32_CPP=wpp386
D32_LINK=wlink
D32_CPP_OPTS=/bt=dos /dDOS386 /zq
D32_LINK_OPTS=SYSTEM dos4g OP stack=48000 DISA 1124

# --- Use the next line for UI_GRAPHICS_DISPLAY ---
#D32_OBJS=
#D32_LIBS=,d32_zil,d32_gfx,wc_32gfx
# --- Use the next line for UI_WCC_DISPLAY ---
D32_OBJS=
D32_LIBS=,d32_zil,d32_wcc

# ----- Windows compiler options --------------------------------------------
WIN_CPP=wpp
WIN_LINK=wlink
WIN_RC=wrc
WIN_CPP_OPTS= -zW -oaxt -w4 -ml
WIN_LINK_OPTS=SYS windows OP heapsize=16k OP stack=30k
WIN_RC_OPTS=/bt=windows
WIN_OBJS=
WIN_LIBS=,commdlg,windows,win_zil

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

# ----- Windows 32 (and WIN32s) compiler options ----------------------------
W32_CPP=wpp386
W32_LINK=wlink
W32_LIBRARIAN=wlib
W32_RC=wrc

W32_CPP_OPTS=/bt=nt
W32_RC_OPTS=/bt=nt
W32_LINK_OPTS=SYS nt_win
W32_LIB_OPTS=/p=32

W32_OBJS=
W32_LIBS=,nt,w32_zil

# ----- OS/2 compiler options -----------------------------------------------
OS2_CPP=wpp386
OS2_LINK=wlink
OS2_RC=wrc
OS2_CPP_OPTS=/bt=OS2
OS2_LINK_OPTS=SYSTEM os2v2_pm OP ST=96000
OS2_RC_OPTS=
OS2_OBJS=
OS2_LIBS=,os2_zil

# ----- DESQview/X MOTIF compiler options -----------------------------------
DVX_CPP=wpp386
DVX_LINK=wlink
DVX_CPP_OPTS=-d__DVX__ -zp4 -zq -4s
DVX_LINK_OPTS=SYSTEM dos4g OP quiet OP stack=48000
DVX_OBJS=
DVX_LIBS=,dvx_zil,xm,xt,x,sys

# ----- QNX Motif compiler options -----------------------------------------
QNX_INC_DIRS= -I../include
QNX_LIB_DIRS= -L../lib -L/usr/lib/X11
QNX_LIB_NAME= ../lib/lib_mtf_zil.a
QNX_DESIGN_LIBS= -l../lib/libZwindow.a -l../lib/libZi18n.a -l../lib/libZhelp.a -l../lib/libZmessage.a \
	-l../lib/libZimage -l../lib/libZstorage.a -l../lib/libZdirect.a \
	-l../lib/libZstredit.a -l../lib/libZservice.a
QNX_CPP= CC
QNX_LINK= CC
QNX_LIBRARIAN= wlib

QNX_CPP_OPTS=
QNX_LINK_OPTS= -@3m -N48k
QNX_LIB_OPTS= -p=128

QNX_OBJS=
QNX_LIBS= -l$(QNX_LIB_NAME) $(QNX_DESIGN_LIBS) -lXm_s -lXt_s -lX11_s -lXqnx_s -lsocket

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

# ----- Usage --------------------------------------------------------------
usage: .SYMBOLIC
	@echo ...........
	@echo ...........
	@echo To make the Zinc designer for ow14 C++ type:
	@echo wmake -f ow14.mak dos32
	@echo wmake -f ow14.mak windows
	@echo wmake -f ow14.mak winnt
	@echo wmake -f ow14.mak os2
	@echo wmake -f ow14.mak dvx
	@echo make -f ow14.mak qnx
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean: .SYMBOLIC
	z_clean
#	----- Level 1 Applications -----
	@cd service
	wmake -f ow14.mak clean
	@cd ..
#	----- Level 2 Applications -----
	@cd storage
	wmake -f ow14.mak clean
	@cd ..
	@cd direct
	wmake -f ow14.mak clean
	@cd ..
	@cd stredit
	wmake -f ow14.mak clean
	@cd ..
#	----- Level 3 Applications -----
	@cd help
	wmake -f ow14.mak clean
	@cd ..
	@cd message
	wmake -f ow14.mak clean
	@cd ..
	@cd image
	wmake -f ow14.mak clean
	@cd ..
	@cd window
	wmake -f ow14.mak clean
	@cd ..
	@cd i18n
	wmake -f ow14.mak clean
	@cd ..
	@cd file
	wmake -f ow14.mak clean
	@cd ..

# ----- DOS extender --------------------------------------------------------
dos32: design.exe .SYMBOLIC
	copy design.exe ..\bin

design.exe: make_dos32_modules main.o32
	%create d32_zil.rsp
	@%append d32_zil.rsp $(D32_LINK_OPTS)
	@%append d32_zil.rsp N design
	@%append d32_zil.rsp F main.o32
	@%append d32_zil.rsp L window.lib,i18n.lib,help.lib,message.lib,image.lib
	@%append d32_zil.rsp L storage.lib,direct.lib,stredit.lib,service.lib$(D32_LIBS)
	$(D32_LINK) @d32_zil.rsp
	del d32_zil.rsp

make_dos32_modules:	.SYMBOLIC
#	----- Level 1 Applications -----
	@cd service
	wmake -f ow14.mak service.lib
	@cd ..
#	----- Level 2 Applications -----
	@cd storage
	wmake -f ow14.mak storage.lib
	@cd ..
	@cd direct
	wmake -f ow14.mak direct.lib
	@cd ..
	@cd stredit
	wmake -f ow14.mak stredit.lib
	@cd ..
#	----- Level 3 Applications -----
	@cd help
	wmake -f ow14.mak help.lib
	@cd ..
	@cd message
	wmake -f ow14.mak message.lib
	@cd ..
	@cd image
	wmake -f ow14.mak image.lib
	@cd ..
	@cd i18n
	wmake -f ow14.mak i18n.lib
	@cd ..
	@cd file
	wmake -f ow14.mak file.lib
	@cd ..
	@cd window
	wmake -f ow14.mak window.lib
	@cd ..

# ----- Windows -------------------------------------------------------------
windows: wdesign.exe .SYMBOLIC
	copy wdesign.exe ..\bin

wdesign.exe: make_windows_modules main.obw
	%create win_zil.rsp
	@%append win_zil.rsp $(WIN_LINK_OPTS)
	@%append win_zil.rsp N wdesign
	@%append win_zil.rsp F main.obw
	@%append win_zil.rsp L wwindow.lib,wi18n.lib,whelp.lib,wmessage.lib,wimage.lib
	@%append win_zil.rsp L wstorage.lib,wdirect.lib,wstredit.lib,wservice.lib$(WIN_LIBS)
	$(WIN_LINK) @win_zil.rsp
	del win_zil.rsp
#	wrc $(WIN_RC_OPTS) $*.rc $*.exe

make_windows_modules: .SYMBOLIC
#	----- Level 1 Applications -----
	@cd service
	wmake -f ow14.mak wservice.lib
	@cd ..
#	----- Level 2 Applications -----
	@cd storage
	wmake -f ow14.mak wstorage.lib
	@cd ..
	@cd direct
	wmake -f ow14.mak wdirect.lib
	@cd ..
	@cd stredit
	wmake -f ow14.mak wstredit.lib
	@cd ..
#	----- Level 3 Applications -----
	@cd help
	wmake -f ow14.mak whelp.lib
	@cd ..
	@cd message
	wmake -f ow14.mak wmessage.lib
	@cd ..
	@cd image
	wmake -f ow14.mak wimage.lib
	@cd ..
	@cd i18n
	wmake -f ow14.mak wi18n.lib
	@cd ..
	@cd file
	wmake -f ow14.mak wfile.lib
	@cd ..
	@cd window
	wmake -f ow14.mak wwindow.lib
	@cd ..

# ----- Windows NT (and WIN32s) ---------------------------------------------
winnt: ndesign.exe .SYMBOLIC
	copy ndesign.exe ..\bin

ndesign.exe: make_winnt_modules main.obn
	%create wnt_zil.rsp
	@%append wnt_zil.rsp $(WNT_LINK_OPTS)
	@%append wnt_zil.rsp N ndesign
	@%append wnt_zil.rsp F main.obn
	@%append wnt_zil.rsp L nwindow.lib,ni18n.lib,nhelp.lib,nmessage.lib,nimage.lib
	@%append wnt_zil.rsp L nstorage.lib,ndirect.lib,nstredit.lib,nservice.lib$(WNT_LIBS)
	$(WNT_LINK) @wnt_zil.rsp
	del wnt_zil.rsp
#	wrc $(WNT_RC_OPTS) ndesign ndesign

make_winnt_modules:	.SYMBOLIC
#	----- Level 1 Applications -----
	@cd service
	wmake -f ow14.mak nservice.lib
	@cd ..
#	----- Level 2 Applications -----
	@cd storage
	wmake -f ow14.mak nstorage.lib
	@cd ..
	@cd direct
	wmake -f ow14.mak ndirect.lib
	@cd ..
	@cd stredit
	wmake -f ow14.mak nstredit.lib
	@cd ..
#	----- Level 3 Applications -----
	@cd help
	wmake -f ow14.mak nhelp.lib
	@cd ..
	@cd message
	wmake -f ow14.mak nmessage.lib
	@cd ..
	@cd image
	wmake -f ow14.mak nimage.lib
	@cd ..
	@cd i18n
	wmake -f ow14.mak ni18n.lib
	@cd ..
	@cd file
	wmake -f ow14.mak nfile.lib
	@cd ..
	@cd window
	wmake -f ow14.mak nwindow.lib
	@cd ..

# ----- 32 bit Windows ------------------------------------------------------
win32: 9design.exe .SYMBOLIC
	copy 9design.exe ..\bin

9design.exe: make_win32_modules main.ob9
	%create w32_zil.rsp
	@%append w32_zil.rsp $(W32_LINK_OPTS)
	@%append w32_zil.rsp N 9design
	@%append w32_zil.rsp F main.ob9
	@%append w32_zil.rsp L 9window.lib,9i18n.lib,9help.lib,9message.lib,9image.lib
	@%append w32_zil.rsp L 9storage.lib,9direct.lib,9stredit.lib,9service.lib$(W32_LIBS)
	$(W32_LINK) @w32_zil.rsp
	del w32_zil.rsp
#	wrc $(W32_RC_OPTS) 9design 9design

make_win32_modules:	.SYMBOLIC
#	----- Level 1 Applications -----
	@cd service
	wmake -f ow14.mak 9service.lib
	@cd ..
#	----- Level 2 Applications -----
	@cd storage
	wmake -f ow14.mak 9storage.lib
	@cd ..
	@cd direct
	wmake -f ow14.mak 9direct.lib
	@cd ..
	@cd stredit
	wmake -f ow14.mak 9stredit.lib
	@cd ..
#	----- Level 3 Applications -----
	@cd help
	wmake -f ow14.mak 9help.lib
	@cd ..
	@cd message
	wmake -f ow14.mak 9message.lib
	@cd ..
	@cd image
	wmake -f ow14.mak 9image.lib
	@cd ..
	@cd i18n
	wmake -f ow14.mak 9i18n.lib
	@cd ..
	@cd file
	wmake -f ow14.mak 9file.lib
	@cd ..
	@cd window
	wmake -f ow14.mak 9window.lib
	@cd ..

# ----- OS/2 ----------------------------------------------------------------
os2: odesign.exe .SYMBOLIC
	copy odesign.exe ..\bin

odesign.exe: make_os2_modules main.obo
	%create os2_zil.rsp
	@%append os2_zil.rsp $(OS2_LINK_OPTS)
	@%append os2_zil.rsp N odesign
	@%append os2_zil.rsp F main.obo
	@%append os2_zil.rsp L owindow.lib,oi18n.lib,ohelp.lib,omessage.lib,oimage.lib
	@%append os2_zil.rsp L ostorage.lib,odirect.lib,ostredit.lib,oservice.lib$(OS2_LIBS)
	$(OS2_LINK) @os2_zil.rsp
	del os2_zil.rsp
	$(OS2_RC) $(OS2_RC_OPTS) $*.exe
	
make_os2_modules: .SYMBOLIC
#	----- Level 1 Applications -----
	@cd service
	wmake -f ow14.mak oservice.lib
	@cd ..
#	----- Level 2 Applications -----
	@cd storage
	wmake -f ow14.mak ostorage.lib
	@cd ..
	@cd direct
	wmake -f ow14.mak odirect.lib
	@cd ..
	@cd stredit
	wmake -f ow14.mak ostredit.lib
	@cd ..
#	----- Level 3 Applications -----
	@cd help
	wmake -f ow14.mak ohelp.lib
	@cd ..
	@cd message
	wmake -f ow14.mak omessage.lib
	@cd ..
	@cd image
	wmake -f ow14.mak oimage.lib
	@cd ..
	@cd window
	wmake -f ow14.mak owindow.lib
	@cd ..
	@cd i18n
	wmake -f ow14.mak oi18n.lib
	@cd ..
	@cd file
	wmake -f ow14.mak ofile.lib
	@cd ..

# ----- DESQview/X Motif ----------------------------------------------------
dvx: mdesign.exe .SYMBOLIC
	copy mdesign.exe ..\bin

mdesign.exe: make_dvx_modules main.obm
	%create dvx_zil.rsp
	@%append dvx_zil.rsp $(DVX_LINK_OPTS)
	@%append dvx_zil.rsp N mdesign
	@%append dvx_zil.rsp F main.obm
	@%append dvx_zil.rsp L mwindow.lib,mi18n.lib,mhelp.lib,mmessage.lib,mimage.lib
	@%append dvx_zil.rsp L mstorage.lib,mdirect.lib,mstredit.lib,mservice.lib$(DVX_LIBS)
	$(DVX_LINK) @dvx_zil.rsp
	del dvx_zil.rsp

make_dvx_modules: .SYMBOLIC
#	----- Level 1 Applications -----
	@cd service
	wmake -f ow14.mak mservice.lib
	@cd ..
#	----- Level 2 Applications -----
	@cd storage
	wmake -f ow14.mak mstorage.lib
	@cd ..
	@cd direct
	wmake -f ow14.mak mdirect.lib
	@cd ..
	@cd stredit
	wmake -f ow14.mak mstredit.lib
	@cd ..
#	----- Level 3 Applications -----
	@cd help
	wmake -f ow14.mak mhelp.lib
	@cd ..
	@cd message
	wmake -f ow14.mak mmessage.lib
	@cd ..
	@cd image
	wmake -f ow14.mak mimage.lib
	@cd ..
	@cd window
	wmake -f ow14.mak mwindow.lib
	@cd ..
	@cd i18n
	wmake -f ow14.mak mi18n.lib
	@cd ..
	@cd file
	wmake -f ow14.mak mfile.lib
	@cd ..

# ----- QNX Motif Libraries and Programs -----------------------------
qnx: design
	cp design ../bin

design: make_qnx_modules main.o
	$(QNX_LINK) $(QNX_LINK_OPTS) -o $@ main.o $(QNX_LIB_DIRS) $(QNX_LIBS)

make_qnx_modules:
#	----- Level 1 Applications -----
	(cd service;make -f ow14.mak qnx_module)
#	----- Level 2 Applications -----
	(cd storage;make -f ow14.mak qnx_module)
	(cd direct;make -f ow14.mak qnx_module)
	(cd stredit;make -f ow14.mak qnx_module)
#	----- Level 3 Applications -----
	(cd help;make -f ow14.mak qnx_module)
	(cd message;make -f ow14.mak qnx_module)
	(cd image;make -f ow14.mak qnx_module)
	(cd window;make -f ow14.mak qnx_module)
	(cd i18n;make -f ow14.mak qnx_module)
	(cd file;make -f ow14.mak qnx_module)

qclean:
	rm -f design *.o
#	----- Level 1 Applications -----
	(cd service;make -f ow14.mak qclean)
#	----- Level 2 Applications -----
	(cd storage;make -f ow14.mak qclean)
	(cd direct;make -f ow14.mak qclean)
	(cd stredit;make -f ow14.mak qclean)
#	----- Level 3 Applications -----
	(cd help;make -f ow14.mak qclean)
	(cd message;make -f ow14.mak qclean)
	(cd image;make -f ow14.mak qclean)
	(cd window;make -f ow14.mak qclean)
	(cd i18n;make -f ow14.mak qclean)
	(cd file;make -f ow14.mak qclean)
