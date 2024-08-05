# ----- General Definitions -------------------------------------------------
VERSION=btcpp450

# ----- DOS compiler options ------------------------------------------------
!if !$d(PHARLAP16) && !$d(RATIONAL16) && !$d(POWERPACK16)
PHARLAP16=
!endif

!if $d(PHARLAP16)
D16_CPP=bcc286
D16_CPP_OPTS=-c -dc -ml -O1 -x- -RT- -V -w -H=ZIL.SYM
D16_LINK_OPTS=/c /C /x
D16_LIB_OPTS=/C /p32
D16_OBJS=c0pl.obj
D16_DEF=b16.def
D16_BIND=bind286
PHARLAP_RTL=c:\phar286\rtk
D16_LOAD=run286a
# --- Use the next line for UI_GRAPHICS_DISPLAY ---
D16_LIBS=phapi d16_zil d16_gfx bc_16gfx emu286 emu mathl bcl286
# --- Use the next line for UI_BGI_DISPLAY ---
#D16_LIBS=phapi d16_zil d16_bgi graph286 emu286 emu mathl bcl286

!elif $d(RATIONAL16)
D16_CPP=bcc
D16_CPP_OPTS=-c -dc -ml -O1 -x- -RT- -2 -f87 -Vf -w -DDOS16M -H=ZIL.SYM
D16_LINK_OPTS=/c /x /C
D16_LIB_OPTS=/C /P1024
D16_OBJS=\dos16m\lib\bcc40\bcc40c0l.obj
D16_DEF=dos16m.def
# --- Use the next line for UI_GRAPHICS_DISPLAY ---
D16_LIBS=bcc40lse bcc40l d16_zil d16_gfx bc_16gfx dos16 d16libc fp87 mathl cl
# --- Use the next line for UI_BGI_DISPLAY ---
#D16_LIBS=bcc40lse bcc40l d16_zil d16_bgi dos16 d16libc fp87 mathl cl

!elif $d(POWERPACK16)
D16_CPP=bcc
D16_CPP_OPTS=-c -dc -WX -ml -O1 -x- -RT- -V -w -DDOS16PP -H=ZIL.SYM
D16_LINK_OPTS=/Txe /c /C /x
D16_LIB_OPTS=/C /p32
D16_OBJS=c0x.obj
D16_DEF=b16pp.def
# --- Use the next line for UI_GRAPHICS_DISPLAY ---
#D16_LIBS=dpmi16 d16_zil d16_gfx bc_16gfx emux mathwl cwl
# --- Use the next line for UI_BGI_DISPLAY ---
D16_LIBS=dpmi16 d16_zil d16_bgi bgi16 emux mathwl cwl
!endif

D16_LINK=tlink
D16_LIBRARIAN=tlib

.cpp.o16:
	$(D16_CPP) $(D16_CPP_OPTS) -o$*.o16 {$< }

D32_CPP=bcc32
D32_CPP_OPTS=-c -WX -O1 -x- -RT- -V -w -DDOS32PP -H=ZIL.SYM
D32_LINK=tlink32
D32_LINK_OPTS=/Tpe /ax /c /x
D32_LIBRARIAN=tlib
D32_LIB_OPTS=/C /p32
D32_OBJS=c0x32.obj
# --- Use the next line for UI_GRAPHICS_DISPLAY ---
#D32_LIBS=dpmi32 d32_zil d32_gfx bc_32gfx cw32
# --- Use the next line for UI_BGI_DISPLAY ---
D32_LIBS=dpmi32 d32_zil d32_bgi bgi32 cw32

.cpp.o32:
	$(D32_CPP) $(D32_CPP_OPTS) -o$*.o32 {$< }

# ----- Windows compiler options --------------------------------------------
WIN_CPP=bcc
WIN_LINK=tlink
WIN_LIBRARIAN=tlib
WIN_RC=rc

WIN_CPP_OPTS=-c -d -dc -ml -O1 -x- -RT- -Vf -WE -w -H=ZIL.SYM
WIN_RC_OPTS=-k
WIN_LINK_OPTS=/c /C /Twe /x
WIN_LIB_OPTS=/C

WIN_OBJS=c0wl
WIN_LIBS=win_zil import mathwl cwl ctl3dv2

.cpp.obw:
	$(WIN_CPP) $(WIN_CPP_OPTS) -o$*.obw {$< }

# ----- Windows NT compiler options -----------------------------------------
WNT_CPP=bcc32
WNT_LINK=tlink32
WNT_LIBRARIAN=tlib
WNT_RC=brc32

WNT_CPP_OPTS=-c -O1 -x- -RT- -W -H=ZIL.sym
WNT_LINK_OPTS=-Tpe -aa -c -x 
WNT_RC_OPTS=-w32
WNT_LIB_OPTS=/C

WNT_OBJS=c0w32
WNT_LIBS=wnt_zil import32 cw32 ctl3d32

.cpp.obn:
	$(WNT_CPP) $(WNT_CPP_OPTS) -o$*.obn {$< }

.rc.rbj:
	$(WNT_RC) -r $(WNT_RC_OPTS) -fo$*.rbj $<

# ----- Windows 32 bit compiler options -------------------------------------
W32_CPP=bcc32
W32_LINK=tlink32
W32_LIBRARIAN=tlib
W32_RC=brc32

W32_CPP_OPTS=-c -O1 -x- -RT- -W -DZIL_WIN32 -H=ZIL.SYM
W32_LINK_OPTS=-Tpe -aa -c -x
W32_RC_OPTS=-w32
W32_LIB_OPTS=/C

W32_OBJS=c0w32
W32_LIBS=w32_zil import32 cw32 ctl3d32

.cpp.ob9:
	$(W32_CPP) $(W32_CPP_OPTS) -o$*.ob9 {$< }

.rc.rbj:
	$(W32_RC) -r $(W32_RC_OPTS) -fo$*.rbj $<

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean

# ----- DOS -----------------------------------------------------------------
dos16: winedit.exe
	copy winedit.exe ..\..\bin

winedit.exe: main.o16 window.lib
	$(D16_LINK) $(D16_LINK_OPTS) @&&!
$(D16_OBJS)+main.o16
$*, , window.lib storage.lib direct.lib stredit.lib service.lib $(D16_LIBS), b16.def
!
	-@del zil.sym
	$(D16_BIND) @&&!
$(PHARLAP_RTL)\$(D16_LOAD)
$*
-dll $(PHARLAP_RTL)\moucalls
     $(PHARLAP_RTL)\int33
     $(PHARLAP_RTL)\doscalls
!

window.lib : advanced.o16 derive.o16 export.o16 \
	geometry.o16 group.o16 import.o16 object.o16 \
	position.o16 prefer.o16 window.o16 window1.o16 \
	z_bnum.o16 z_border.o16 z_button.o16 z_combo.o16 \
	z_date.o16 z_fmtstr.o16 z_gmgr.o16 z_group.o16 \
	z_hlist.o16 z_icon.o16 z_int.o16 z_max.o16 z_min.o16 z_notebk.o16 \
	z_obj.o16 z_plldn.o16 z_plldn1.o16 z_popup.o16 z_popup1.o16 \
	z_prompt.o16 z_real.o16 z_scroll.o16 z_sbar.o16 z_spin.o16 \
	z_string.o16 z_sys.o16 z_table.o16 z_tbar.o16 z_text.o16 \
	z_time.o16 z_title.o16 z_vlist.o16 z_win.o16
	-@del window.lib
	$(D16_LIBRARIAN) $(D16_LIB_OPTS) @&&!
$* &
+advanced.o16+derive.o16+export.o16 &
+geometry.o16+group.o16+import.o16+object.o16 &
+position.o16+prefer.o16+window.o16+window1.o16 &
+z_bnum.o16+z_border.o16+z_button.o16+z_combo.o16 &
+z_date.o16+z_fmtstr.o16+z_gmgr.o16+z_group.o16 &
+z_hlist.o16+z_icon.o16+z_int.o16+z_max.o16+z_min.o16+z_notebk.o16 &
+z_obj.o16+z_plldn.o16+z_plldn1.o16+z_popup.o16+z_popup1.o16 &
+z_prompt.o16+z_real.o16+z_sbar.o16+z_scroll.o16+z_spin.o16 &
+z_string.o16+z_sys.o16+z_table.o16+z_tbar.o16+z_text.o16 &
+z_time.o16+z_title.o16+z_vlist.o16+z_win.o16
!
	-@del zil.sym
	copy window.hpp ..\..\include
	copy window.lib ..\..\lib\$(VERSION)
	copy p_window.dat ..\..\bin\p_window.znc

dos32: winedi32.exe
	copy winedi32.exe ..\..\bin

winedi32.exe: main.o32 window32.lib
	$(D32_LINK) $(D32_LINK_OPTS) @&&!
$(D32_OBJS)+main.o32
$*, , window32.lib storag32.lib direct32.lib stredi32.lib servic32.lib $(D32_LIBS)
!
	-@del zil.sym

window32.lib : advanced.o32 derive.o32 export.o32 \
	geometry.o32 group.o32 import.o32 object.o32 \
	position.o32 prefer.o32 window.o32 window1.o32 \
	z_bnum.o32 z_border.o32 z_button.o32 z_combo.o32 \
	z_date.o32 z_fmtstr.o32 z_gmgr.o32 z_group.o32 \
	z_hlist.o32 z_icon.o32 z_int.o32 z_max.o32 z_min.o32 z_notebk.o32 \
	z_obj.o32 z_plldn.o32 z_plldn1.o32 z_popup.o32 z_popup1.o32 \
	z_prompt.o32 z_real.o32 z_scroll.o32 z_sbar.o32 z_spin.o32 \
	z_string.o32 z_sys.o32 z_table.o32 z_tbar.o32 z_text.o32 \
	z_time.o32 z_title.o32 z_vlist.o32 z_win.o32
	-@del window32.lib
	$(D32_LIBRARIAN) $(D32_LIB_OPTS) @&&!
$* &
+advanced.o32+derive.o32+export.o32 &
+geometry.o32+group.o32+import.o32+object.o32 &
+position.o32+prefer.o32+window.o32+window1.o32 &
+z_bnum.o32+z_border.o32+z_button.o32+z_combo.o32 &
+z_date.o32+z_fmtstr.o32+z_gmgr.o32+z_group.o32 &
+z_hlist.o32+z_icon.o32+z_int.o32+z_max.o32+z_min.o32+z_notebk.o32 &
+z_obj.o32+z_plldn.o32+z_plldn1.o32+z_popup.o32+z_popup1.o32 &
+z_prompt.o32+z_real.o32+z_sbar.o32+z_scroll.o32+z_spin.o32 &
+z_string.o32+z_sys.o32+z_table.o32+z_tbar.o32+z_text.o32 &
+z_time.o32+z_title.o32+z_vlist.o32+z_win.o32
!
	-@del zil.sym
	copy window.hpp ..\..\include
	copy window32.lib ..\..\lib\$(VERSION)
	copy p_window.dat ..\..\bin\p_window.znc

# ----- Windows -------------------------------------------------------------
windows: wwinedit.exe
	copy wwinedit.exe ..\..\bin

wwinedit.exe: main.obw wwindow.lib
	$(WIN_LINK) $(WIN_LINK_OPTS) @&&!
$(WIN_OBJS)+main.obw
$*, , wwindow wstorage wdirect wstredit wservice $(WIN_LIBS), wwindow.def
!
	$(WIN_RC) $(WIN_RC_OPTS) wwindow.rc $<

wwindow.lib: advanced.obw derive.obw export.obw \
	geometry.obw group.obw import.obw object.obw \
	position.obw prefer.obw window.obw window1.obw \
	z_bnum.obw z_border.obw z_button.obw z_combo.obw \
	z_date.obw z_fmtstr.obw z_gmgr.obw z_group.obw \
	z_hlist.obw z_icon.obw z_int.obw z_max.obw z_min.obw z_notebk.obw z_obj.obw \
	z_plldn.obw z_plldn1.obw z_popup.obw z_popup1.obw z_prompt.obw \
	z_real.obw z_scroll.obw z_sbar.obw z_spin.obw z_string.obw z_sys.obw \
	z_table.obw z_tbar.obw z_text.obw z_time.obw z_title.obw z_vlist.obw z_win.obw
	-@del wwindow.lib
	$(WIN_LIBRARIAN) $(WIN_LIB_OPTS) @&&!
$* &
+advanced.obw+derive.obw+export.obw &
+geometry.obw+group.obw+import.obw+object.obw &
+position.obw+prefer.obw+window.obw+window1.obw &
+z_bnum.obw+z_border.obw+z_button.obw+z_combo.obw &
+z_date.obw+z_fmtstr.obw+z_gmgr.obw+z_group.obw &
+z_hlist.obw+z_icon.obw+z_int.obw+z_max.obw+z_min.obw+z_notebk.obw+z_obj.obw &
+z_plldn.obw+z_plldn1.obw+z_popup.obw+z_popup1.obw+z_prompt.obw &
+z_real.obw+z_sbar.obw+z_scroll.obw+z_spin.obw+z_string.obw+z_sys.obw &
+z_table.obw+z_tbar.obw+z_text.obw+z_time.obw+z_title.obw+z_vlist.obw+z_win.obw
!
	-@del zil.sym
	copy window.hpp ..\..\include
	copy wwindow.lib ..\..\lib\$(VERSION)
	copy p_window.dat ..\..\bin\p_window.znc

# ----- Windows -------------------------------------------------------------
winnt: nwinedit.exe
	copy nwinedit.exe ..\..\bin

nwinedit.exe: main.obn nwindow.lib wwindow.rbj
	$(WNT_LINK) $(WNT_LINK_OPTS) @&&!
$(WNT_OBJS)+main.obn
$*, , nwindow nstorage ndirect nstredit nservice $(WNT_LIBS), wwindow.def, wwindow.rbj
!

nwindow.lib: advanced.obn derive.obn export.obn \
	geometry.obn group.obn import.obn object.obn \
	position.obn prefer.obn window.obn window1.obn \
	z_bnum.obn z_border.obn z_button.obn z_combo.obn \
	z_date.obn z_fmtstr.obn z_gmgr.obn z_group.obn \
	z_hlist.obn z_icon.obn z_int.obn z_max.obn z_min.obn z_notebk.obn z_obj.obn \
	z_plldn.obn z_plldn1.obn z_popup.obn z_popup1.obn z_prompt.obn \
	z_real.obn z_scroll.obn z_sbar.obn z_spin.obn z_string.obn z_sys.obn \
	z_table.obn z_tbar.obn z_text.obn z_time.obn z_title.obn z_vlist.obn z_win.obn
	-@del nwindow.lib
	$(WNT_LIBRARIAN) $(WNT_LIB_OPTS) @&&!
$* &
+advanced.obn+derive.obn+export.obn &
+geometry.obn+group.obn+import.obn+object.obn &
+position.obn+prefer.obn+window.obn+window1.obn &
+z_bnum.obn+z_border.obn+z_button.obn+z_combo.obn &
+z_date.obn+z_fmtstr.obn+z_gmgr.obn+z_group.obn &
+z_hlist.obn+z_icon.obn+z_int.obn+z_max.obn+z_min.obn+z_notebk.obn+z_obj.obn &
+z_plldn.obn+z_plldn1.obn+z_popup.obn+z_popup1.obn+z_prompt.obn &
+z_real.obn+z_sbar.obn+z_scroll.obn+z_spin.obn+z_string.obn+z_sys.obn &
+z_table.obn+z_tbar.obn+z_text.obn+z_time.obn+z_title.obn+z_vlist.obn+z_win.obn
!
	-@del zil.sym
	copy window.hpp ..\..\include
	copy nwindow.lib ..\..\lib\$(VERSION)
	copy p_window.dat ..\..\bin\p_window.znc

# ----- 32 bit Windows ------------------------------------------------------
win32: 9winedit.exe
	copy 9winedit.exe ..\..\bin

9winedit.exe: main.ob9 9window.lib wwindow.rbj
	$(W32_LINK) $(W32_LINK_OPTS) @&&!
$(W32_OBJS)+main.ob9
$*, , 9window 9storage 9direct 9stredit 9service $(W32_LIBS), ,wwindow.rbj
!

9window.lib: advanced.ob9 derive.ob9 export.ob9 \
	geometry.ob9 group.ob9 import.ob9 object.ob9 \
	position.ob9 prefer.ob9 window.ob9 window1.ob9 \
	z_bnum.ob9 z_border.ob9 z_button.ob9 z_combo.ob9 \
	z_date.ob9 z_fmtstr.ob9 z_gmgr.ob9 z_group.ob9 \
	z_hlist.ob9 z_icon.ob9 z_int.ob9 z_max.ob9 z_min.ob9 z_notebk.ob9 z_obj.ob9 \
	z_plldn.ob9 z_plldn1.ob9 z_popup.ob9 z_popup1.ob9 z_prompt.ob9 \
	z_real.ob9 z_scroll.ob9 z_sbar.ob9 z_spin.ob9 z_string.ob9 z_sys.ob9 \
	z_table.ob9 z_tbar.ob9 z_text.ob9 z_time.ob9 z_title.ob9 z_vlist.ob9 z_win.ob9
	-@del 9window.lib
	$(W32_LIBRARIAN) $(W32_LIB_OPTS) @&&!
$* &
+advanced.ob9+derive.ob9+export.ob9 &
+geometry.ob9+group.ob9+import.ob9+object.ob9 &
+position.ob9+prefer.ob9+window.ob9+window1.ob9 &
+z_bnum.ob9+z_border.ob9+z_button.ob9+z_combo.ob9 &
+z_date.ob9+z_fmtstr.ob9+z_gmgr.ob9+z_group.ob9 &
+z_hlist.ob9+z_icon.ob9+z_int.ob9+z_max.ob9+z_min.ob9+z_notebk.ob9+z_obj.ob9 &
+z_plldn.ob9+z_plldn1.ob9+z_popup.ob9+z_popup1.ob9+z_prompt.ob9 &
+z_real.ob9+z_sbar.ob9+z_scroll.ob9+z_spin.ob9+z_string.ob9+z_sys.ob9 &
+z_table.ob9+z_tbar.ob9+z_text.ob9+z_time.ob9+z_title.ob9+z_vlist.ob9+z_win.ob9
!
	-@del zil.sym
	copy window.hpp ..\..\include
	copy 9window.lib ..\..\lib\$(VERSION)
	copy p_window.dat ..\..\bin\p_window.znc
