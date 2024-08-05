# ----- General Definitions -------------------------------------------------
VERSION=ow17

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
QNX_MODULE_LIB= ../../lib/libZi18n.a
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
dos32: i18edit.exe .SYMBOLIC
	copy i18edit.exe ..\..\bin

i18edit.exe: main.o32 i18n.lib
	%create d32_zil.rsp
	@%append d32_zil.rsp $(D32_LINK_OPTS)
	@%append d32_zil.rsp N i18edit
	@%append d32_zil.rsp F main.o32
	@%append d32_zil.rsp L i18n.lib,storage.lib,stredit.lib,direct.lib
	@%append d32_zil.rsp L service.lib$(D32_LIBS)
	$(D32_LINK) @d32_zil.rsp
	del d32_zil.rsp

i18n.lib : i18n.o32 language.o32 locale.o32 &
	export.o32 import.o32 &
	z_bnum.o32 z_curr.o32 z_date.o32 z_date1.o32 z_day.o32 z_error.o32 &
	z_help.o32 z_int.o32 z_month.o32 z_msg.o32 z_num.o32 z_real.o32 &
	z_sys.o32 z_time.o32 z_time1.o32 z_time2.o32 z_win.o32
	
	-@del i18n.lib
	$(D32_LIBRARIAN) $(D32_LIB_OPTS) @i18n.wcc

	copy i18n.hpp ..\..\include
	copy i18n.lib ..\..\lib\$(VERSION)
	copy p_i18n.dat ..\..\bin\p_i18n.znc

# ----- Windows -------------------------------------------------------------
windows: wi18edit.exe .SYMBOLIC
	copy wi18edit.exe ..\..\bin

wi18edit.exe: main.obw wi18n.lib
	%create win_zil.rsp
	@%append win_zil.rsp $(WIN_LINK_OPTS)
	@%append win_zil.rsp N wi18edit
	@%append win_zil.rsp F main.obw
	@%append win_zil.rsp L wi18n.lib,wstorage.lib,wstredit.lib,wdirect.lib
	@%append win_zil.rsp L wservice.lib$(WIN_LIBS)
	$(WIN_LINK) @win_zil.rsp
	del win_zil.rsp

wi18n.lib : i18n.obw language.obw locale.obw &
	export.obw import.obw &
	z_bnum.obw z_curr.obw z_date.obw z_date1.obw z_day.obw z_error.obw &
	z_help.obw z_int.obw z_month.obw z_msg.obw z_num.obw z_real.obw &
	z_sys.obw z_time.obw z_time1.obw z_time2.obw z_win.obw
	
	-@del wi18n.lib
	$(WIN_LIBRARIAN) $(WIN_LIB_OPTS) @wi18n.wcc

	copy i18n.hpp ..\..\include
	copy wi18n.lib ..\..\lib\$(VERSION)
	copy p_i18n.dat ..\..\bin\p_i18n.znc

# ----- Windows NT (and WIN32s) ---------------------------------------------
winnt: ni18edit.exe .SYMBOLIC
	copy ni18edit.exe ..\..\bin

ni18edit.exe: main.obn ni18n.lib
	%create wnt_zil.rsp
	@%append wnt_zil.rsp $(WNT_LINK_OPTS)
	@%append wnt_zil.rsp N ni18edit
	@%append wnt_zil.rsp F main.obn
	@%append wnt_zil.rsp L ni18n.lib,nstorage.lib,nstredit.lib,ndirect.lib
	@%append wnt_zil.rsp L nservice.lib$(WNT_LIBS)
	$(WNT_LINK) @wnt_zil.rsp
	del wnt_zil.rsp

ni18n.lib : i18n.obn language.obn locale.obn &
	export.obn import.obn &
	z_bnum.obn z_curr.obn z_date.obn z_date1.obn z_day.obn z_error.obn &
	z_help.obn z_int.obn z_month.obn z_msg.obn z_num.obn z_real.obn &
	z_sys.obn z_time.obn z_time1.obn z_time2.obn z_win.obn
	
	-@del ni18n.lib
	$(WNT_LIBRARIAN) $(WNT_LIB_OPTS) @ni18n.wcc

	copy i18n.hpp ..\..\include
	copy ni18n.lib ..\..\lib\$(VERSION)
	copy p_i18n.dat ..\..\bin\p_i18n.znc

# ----- 32 bit Windows ------------------------------------------------------
win32: 9i18edit.exe .SYMBOLIC
	copy 9i18edit.exe ..\..\bin

9i18edit.exe: main.ob9 9i18n.lib
	%create w32_zil.rsp
	@%append w32_zil.rsp $(W32_LINK_OPTS)
	@%append w32_zil.rsp N 9i18edit
	@%append w32_zil.rsp F main.ob9
	@%append w32_zil.rsp L 9i18n.lib,9storage.lib,9stredit.lib,9direct.lib
	@%append w32_zil.rsp L 9service.lib$(W32_LIBS)
	$(W32_LINK) @w32_zil.rsp
	del w32_zil.rsp

9i18n.lib : i18n.ob9 language.ob9 locale.ob9 &
	export.ob9 import.ob9 &
	z_bnum.ob9 z_curr.ob9 z_date.ob9 z_date1.ob9 z_day.ob9 z_error.ob9 &
	z_help.ob9 z_int.ob9 z_month.ob9 z_msg.ob9 z_num.ob9 z_real.ob9 &
	z_sys.ob9 z_time.ob9 z_time1.ob9 z_time2.ob9 z_win.ob9
	
	-@del 9i18n.lib
	$(W32_LIBRARIAN) $(W32_LIB_OPTS) @9i18n.wcc

	copy i18n.hpp ..\..\include
	copy 9i18n.lib ..\..\lib\$(VERSION)
	copy p_i18n.dat ..\..\bin\p_i18n.znc

# ----- OS/2 ----------------------------------------------------------------
os2: oi18edit.exe .SYMBOLIC
	copy oi18edit.exe ..\..\bin

oi18edit.exe: main.obo oi18n.lib
	%create os2_zil.rsp
	@%append os2_zil.rsp $(OS2_LINK_OPTS)
	@%append os2_zil.rsp N oi18edit
	@%append os2_zil.rsp F main.obo
	@%append os2_zil.rsp L oi18n.lib,ostorage.lib,ostredit.lib,odirect.lib
	@%append os2_zil.rsp L oservice.lib$(OS2_LIBS)
	$(OS2_LINK) @os2_zil.rsp
	del os2_zil.rsp

oi18n.lib : i18n.obo language.obo locale.obo &
	export.obo import.obo &
	z_bnum.obo z_curr.obo z_date.obo z_date1.obo z_day.obo z_error.obo &
	z_help.obo z_int.obo z_month.obo z_msg.obo z_num.obo z_real.obo &
	z_sys.obo z_time.obo z_time1.obo z_time2.obo z_win.obo
	
	-@del oi18n.lib
	$(OS2_LIBRARIAN) $(OS2_LIB_OPTS) @oi18n.wcc

	copy i18n.hpp ..\..\include
	copy oi18n.lib ..\..\lib\$(VERSION)
	copy p_i18n.dat ..\..\bin\p_i18n.znc

# ----- DESQview/X Motif ----------------------------------------------------
dvx: mi18edit.exe .SYMBOLIC
	copy mi18edit.exe ..\..\bin

mi18edit.exe: main.obm mi18n.lib
	%create dvx_zil.rsp
	@%append dvx_zil.rsp $(DVX_LINK_OPTS)
	@%append dvx_zil.rsp N mi18edit
	@%append dvx_zil.rsp F main.obm
	@%append dvx_zil.rsp L mi18n.lib,mstorage.lib,mstredit.lib,mdirect.lib
	@%append dvx_zil.rsp L mservice.lib$(DVX_LIBS)
	$(DVX_LINK) @dvx_zil.rsp
	del dvx_zil.rsp

mi18n.lib : i18n.obm language.obm locale.obm &
	export.obm import.obm &
	z_bnum.obm z_curr.obm z_date.obm z_date1.obm z_day.obm z_error.obm &
	z_help.obm z_int.obm z_month.obm z_msg.obm z_num.obm z_real.obm &
	z_sys.obm z_time.obm z_time1.obm z_time2.obm z_win.obm
	
	-@del mi18n.lib
	$(DVX_LIBRARIAN) $(DVX_LIB_OPTS) @mi18n.wcc

	copy i18n.hpp ..\..\include
	copy mi18n.lib ..\..\lib\$(VERSION)
	copy p_i18n.dat ..\..\bin\p_i18n.znc

# ----- QNX Motif Libraries and Programs -----------------------------
qnx: main
	cp main ../../bin

main: main.o $(QNX_MODULE_LIB)
	$(QNX_LINK) $(QNX_LINK_OPTS) -o $@ $@.o $(QNX_LIB_DIRS) $(QNX_LIBS)

qnx_module: $(QNX_MODULE_LIB)

$(QNX_MODULE_LIB): i18n.o language.o locale.o \
	export.o import.o \
	z_bnum.o z_curr.o z_date.o z_date1.o z_day.o z_error.o \
	z_help.o z_int.o z_month.o z_msg.o z_num.o z_real.o \
	z_sys.o z_time.o z_time1.o z_time2.o z_win.o
	rm -f $(QNX_MODULE_LIB)
	$(QNX_LIBRARIAN) $(QNX_LIB_OPTS) $@ $?
	cp i18n.hpp ../../include
	cp p_i18n.dat ../../bin/p_i18n.znc
	
qclean:
	rm -f $(QNX_MODULE_LIB) main *.o
