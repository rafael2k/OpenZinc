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
WNT_LIB_OPTS=/p=64

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
W32_LIB_OPTS=/p=64

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
DVX_LINK_OPTS=SYSTEM dos4g OP quiet OP stack=48000
DVX_LIB_OPTS=-p=32
DVX_OBJS=
DVX_LIBS=dvx_zil,xm,xt,x,sys

# ----- QNX Motif compiler options -----------------------------------------
QNX_INC_DIRS= -I../../include
QNX_LIB_DIRS= -L../../lib -L/usr/lib/X11
QNX_LIB_NAME= ../../lib/lib_mtf_zil.a
QNX_MODULE_LIB= ../../lib/libZwindow.a
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
dos32: winedit.exe .SYMBOLIC
	copy winedit.exe ..\..\bin

winedit.exe: ..\main.o32 window.lib
	%create d32_zil.rsp
	@%append d32_zil.rsp $(D32_LINK_OPTS)
	@%append d32_zil.rsp N winedit
	@%append d32_zil.rsp F main.o32
	@%append d32_zil.rsp L window.lib storage.lib stredit.lib direct.lib
	@%append d32_zil.rsp L service.lib $(D32_LIBS)
	$(D32_LINK) @d32_zil.rsp
	del d32_zil.rsp

window.lib : advanced.o32 derive.o32 export.o32 &
	geometry.o32 group.o32 import.o32 object.o32 &
	position.o32 prefer.o32 window.o32 window1.o32 &
	z_bnum.o32 z_border.o32 z_button.o32 z_combo.o32 &
	z_date.o32 z_fmtstr.o32 z_gmgr.o32 z_group.o32 &
	z_hlist.o32 z_icon.o32 z_int.o32 z_max.o32 z_min.o32 z_notebk.o32 &
	z_obj.o32 z_plldn.o32 z_plldn1.o32 z_popup.o32 z_popup1.o32 &
	z_prompt.o32 z_real.o32 z_scroll.o32 z_sbar.o32 z_spin.o32 &
	z_string.o32 z_sys.o32 z_table.o32 z_tbar.o32 z_text.o32 &
	z_time.o32 z_title.o32 z_vlist.o32 z_win.o32

	-@del window.lib
	$(D32_LIBRARIAN) $(D32_LIB_OPTS) @window.wcc

	copy window.hpp ..\..\include
	copy window.lib ..\..\lib\$(VERSION)
	copy p_window.dat ..\..\bin\p_window.znc

# ----- Windows -------------------------------------------------------------
windows: wwinedit.exe .SYMBOLIC
	copy wwinedit.exe ..\..\bin

wwinedit.exe: main.obw wwindow.lib
	%create win_zil.rsp
	@%append win_zil.rsp $(WIN_LINK_OPTS)
	@%append win_zil.rsp N wwinedit
	@%append win_zil.rsp F main.obw
	@%append win_zil.rsp L wwindow.lib wstorage.lib wstredit.lib wdirect.lib
	@%append win_zil.rsp L wservice.lib $(WIN_LIBS)
	$(WIN_LINK) @win_zil.rsp
	del win_zil.rsp

wwindow.lib: advanced.obw derive.obw export.obw &
	geometry.obw group.obw import.obw object.obw &
	position.obw prefer.obw window.obw window1.obw &
	z_bnum.obw z_border.obw z_button.obw z_combo.obw &
	z_date.obw z_fmtstr.obw z_gmgr.obw z_group.obw &
	z_hlist.obw z_icon.obw z_int.obw z_max.obw z_min.obw z_notebk.obw z_obj.obw &
	z_plldn.obw z_plldn1.obw z_popup.obw z_popup1.obw z_prompt.obw &
	z_real.obw z_scroll.obw z_sbar.obw z_spin.obw z_string.obw z_sys.obw &
	z_table.obw z_tbar.obw z_text.obw z_time.obw z_title.obw z_vlist.obw z_win.obw

	-@del wwindow.lib
	$(WIN_LIBRARIAN) $(WIN_LIB_OPTS) @wwindow.wcc

	copy window.hpp ..\..\include
	copy wwindow.lib ..\..\lib\$(VERSION)
	copy p_window.dat ..\..\bin\p_window.znc

# ----- Windows NT (and WIN32s) ---------------------------------------------
winnt: nwinedit.exe .SYMBOLIC
	copy nwinedit.exe ..\..\bin

nwinedit.exe: main.obn nwindow.lib
	%create wnt_zil.rsp
	@%append wnt_zil.rsp $(WNT_LINK_OPTS)
	@%append wnt_zil.rsp N nwinedit
	@%append wnt_zil.rsp F main.obn
	@%append wnt_zil.rsp L nwindow.lib nstorage.lib nstredit.lib ndirect.lib
	@%append wnt_zil.rsp L nservice.lib $(WNT_LIBS)
	$(WNT_LINK) @wnt_zil.rsp
	del wnt_zil.rsp

nwindow.lib: advanced.obn derive.obn export.obn &
	geometry.obn group.obn import.obn object.obn &
	position.obn prefer.obn window.obn window1.obn &
	z_bnum.obn z_border.obn z_button.obn z_combo.obn &
	z_date.obn z_fmtstr.obn z_gmgr.obn z_group.obn &
	z_hlist.obn z_icon.obn z_int.obn z_max.obn z_min.obn z_notebk.obn z_obj.obn &
	z_plldn.obn z_plldn1.obn z_popup.obn z_popup1.obn z_prompt.obn &
	z_real.obn z_scroll.obn z_sbar.obn z_spin.obn z_string.obn z_sys.obn &
	z_table.obn z_tbar.obn z_text.obn z_time.obn z_title.obn z_vlist.obn z_win.obn

	-@del nwindow.lib
	$(WNT_LIBRARIAN) $(WNT_LIB_OPTS) @nwindow.wcc

	copy window.hpp ..\..\include
	copy nwindow.lib ..\..\lib\$(VERSION)
	copy p_window.dat ..\..\bin\p_window.znc

# ----- 32 bit Windows ------------------------------------------------------
win32: 9winedit.exe .SYMBOLIC
	copy 9winedit.exe ..\..\bin

9winedit.exe: main.ob9 9window.lib
	%create w32_zil.rsp
	@%append w32_zil.rsp $(W32_LINK_OPTS)
	@%append w32_zil.rsp N 9winedit
	@%append w32_zil.rsp F main.ob9
	@%append w32_zil.rsp L 9window.lib 9storage.lib 9stredit.lib 9direct.lib
	@%append w32_zil.rsp L 9service.lib $(W32_LIBS)
	$(W32_LINK) @w32_zil.rsp
	del w32_zil.rsp

9window.lib: advanced.ob9 derive.ob9 export.ob9 &
	geometry.ob9 group.ob9 import.ob9 object.ob9 &
	position.ob9 prefer.ob9 window.ob9 window1.ob9 &
	z_bnum.ob9 z_border.ob9 z_button.ob9 z_combo.ob9 &
	z_date.ob9 z_fmtstr.ob9 z_gmgr.ob9 z_group.ob9 &
	z_hlist.ob9 z_icon.ob9 z_int.ob9 z_max.ob9 z_min.ob9 z_notebk.ob9 z_obj.ob9 &
	z_plldn.ob9 z_plldn1.ob9 z_popup.ob9 z_popup1.ob9 z_prompt.ob9 &
	z_real.ob9 z_scroll.ob9 z_sbar.ob9 z_spin.ob9 z_string.ob9 z_sys.ob9 &
	z_table.ob9 z_tbar.ob9 z_text.ob9 z_time.ob9 z_title.ob9 z_vlist.ob9 z_win.ob9

	-@del 9window.lib
	$(W32_LIBRARIAN) $(W32_LIB_OPTS) @9window.wcc

	copy window.hpp ..\..\include
	copy 9window.lib ..\..\lib\$(VERSION)
	copy p_window.dat ..\..\bin\p_window.znc

# ----- OS/2 ----------------------------------------------------------------
os2: owinedit.exe .SYMBOLIC
	copy owinedit.exe ..\..\bin

owinedit.exe: main.obo owindow.lib
	%create os2_zil.rsp
	@%append os2_zil.rsp $(OS2_LINK_OPTS)
	@%append os2_zil.rsp N owinedit
	@%append os2_zil.rsp F main.obo
	@%append os2_zil.rsp L owindow.lib ostorage.lib ostredit.lib odirect.lib
	@%append os2_zil.rsp L oservice.lib $(OS2_LIBS)
	$(OS2_LINK) @os2_zil.rsp
	del os2_zil.rsp

owindow.lib: advanced.obo derive.obo export.obo &
	geometry.obo group.obo import.obo object.obo &
	position.obo prefer.obo window.obo window1.obo &
	z_bnum.obo z_border.obo z_button.obo z_combo.obo &
	z_date.obo z_fmtstr.obo z_gmgr.obo z_group.obo &
	z_hlist.obo z_icon.obo z_int.obo z_max.obo z_min.obo z_notebk.obo z_obj.obo &
	z_plldn.obo z_plldn1.obo z_popup.obo z_popup1.obo z_prompt.obo &
	z_real.obo z_scroll.obo z_sbar.obo z_spin.obo z_string.obo z_sys.obo &
	z_table.obo z_tbar.obo z_text.obo z_time.obo z_title.obo z_vlist.obo z_win.obo

	-@del owindow.lib
	$(OS2_LIBRARIAN) $(OS2_LIB_OPTS) @owindow.wcc

	copy window.hpp ..\..\include
	copy owindow.lib ..\..\lib\$(VERSION)
	copy p_window.dat ..\..\bin\p_window.znc

# ----- DESQview/X Motif ----------------------------------------------------
dvx: mwinedit.exe .SYMBOLIC
	copy mwinedit.exe ..\..\bin

mwinedit.exe: main.obm mwindow.lib
	%create dvx_zil.rsp
	@%append dvx_zil.rsp $(DVX_LINK_OPTS)
	@%append dvx_zil.rsp N mwinedit
	@%append dvx_zil.rsp F main.obm
	@%append dvx_zil.rsp L mwindow.lib mstorage.lib mstredit.lib mdirect.lib
	@%append dvx_zil.rsp L mservice.lib $(DVX_LIBS)
	$(DVX_LINK) @dvx_zil.rsp
	del dvx_zil.rsp

mwindow.lib: advanced.obm derive.obm export.obm &
	geometry.obm group.obm import.obm object.obm &
	position.obm prefer.obm window.obm window1.obm &
	z_bnum.obm z_border.obm z_button.obm z_combo.obm &
	z_date.obm z_fmtstr.obm z_gmgr.obm z_group.obm &
	z_hlist.obm z_icon.obm z_int.obm z_max.obm z_min.obm z_notebk.obm z_obj.obm &
	z_plldn.obm z_plldn1.obm z_popup.obm z_popup1.obm z_prompt.obm &
	z_real.obm z_scroll.obm z_sbar.obm z_spin.obm z_string.obm z_sys.obm &
	z_table.obm z_tbar.obm z_text.obm z_time.obm z_title.obm z_vlist.obm z_win.obm

	-@del mwindow.lib
	$(DVX_LIBRARIAN) $(DVX_LIB_OPTS) @mwindow.wcc

	copy window.hpp ..\..\include
	copy mwindow.lib ..\..\lib\$(VERSION)
	copy p_window.dat ..\..\bin\p_window.znc

# ----- QNX Motif Libraries and Programs -----------------------------
qnx: winedit
	cp winedit ../../bin

winedit: main.o $(QNX_MODULE_LIB)
	$(QNX_LINK) $(QNX_LINK_OPTS) -o winedit main.o $(QNX_LIB_DIRS) $(QNX_LIBS)

qnx_module: $(QNX_MODULE_LIB)

$(QNX_MODULE_LIB): advanced.o derive.o export.o \
	geometry.o group.o import.o object.o \
	position.o prefer.o window.o window1.o \
	z_bnum.o z_border.o z_button.o z_combo.o \
	z_date.o z_fmtstr.o z_gmgr.o z_group.o \
	z_hlist.o z_icon.o z_int.o z_max.o z_min.o z_notebk.o z_obj.o \
	z_plldn.o z_plldn1.o z_popup.o z_popup1.o z_prompt.o \
	z_real.o z_scroll.o z_sbar.o z_spin.o z_string.o z_sys.o \
	z_table.o z_tbar.o z_text.o z_time.o z_title.o z_vlist.o z_win.o
	rm -f $(QNX_MODULE_LIB)
	$(QNX_LIBRARIAN) $(QNX_LIB_OPTS) $@ $?
	cp window.hpp ../../include
	cp p_window.dat ../../bin/p_window.znc
	
qclean:
	rm -f $(QNX_MODULE_LIB) winedit *.o
