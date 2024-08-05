# ----- General Definitions -------------------------------------------------
VERSION=btcpp310

# ----- Windows compiler options --------------------------------------------
WIN_CPP=bcc
WIN_LINK=tlink
WIN_LIBRARIAN=tlib
WIN_RC=rc

WIN_CPP_OPTS=-c -d  -ml -O1  -Vf -WE -w -H=ZIL.SYM
WIN_RC_OPTS=-k
WIN_LINK_OPTS=/c /C /Twe /x
WIN_LIB_OPTS=/C

WIN_OBJS=c0wl
WIN_LIBS=win_zil win_zil2 import mathwl cwl ctl3dv2

.cpp.obw:
	$(WIN_CPP) $(WIN_CPP_OPTS) -o$*.obw {$< }


# ----- Clean ---------------------------------------------------------------
clean:
	z_clean


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


