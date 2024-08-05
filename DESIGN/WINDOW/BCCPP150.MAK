# ----- General Definitions -------------------------------------------------
VERSION=bccpp150

# ----- OS/2 compiler options -----------------------------------------------
OS2_CPP=bcc
OS2_LINK=tlink
OS2_LIBRARIAN=tlib
OS2_RC=rc

OS2_CPP_OPTS=-c -D$(FONT)
OS2_LINK_OPTS=/c /B:0x10000 /aa
#OS2_CPP_OPTS=-c -v -D$(FONT)
#OS2_LINK_OPTS=/c /B:0x10000 /v /aa
OS2_LIB_OPTS=
OS2_RC_OPTS=

OS2_OBJS=c02.obj
OS2_LIBS=os2_zil.lib os2.lib c2.lib

.cpp.obo:
	$(OS2_CPP) $(OS2_CPP_OPTS) -o$*.obo {$< }

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean

# ----- OS/2 ----------------------------------------------------------------
os2: owinedit.exe
	copy owinedit.exe ..\..\bin

owinedit.exe: main.obo owindow.lib
	$(OS2_LINK) $(OS2_LINK_OPTS) @&&!
$(OS2_OBJS)+main.obo
$*, , owindow ostorage odirect ostredit oservice $(OS2_LIBS), owindow.def
!

owindow.lib : advanced.obo derive.obo export.obo \
	geometry.obo group.obo import.obo object.obo \
	position.obo prefer.obo window.obo window1.obo \
	z_bnum.obo z_border.obo z_button.obo z_combo.obo \
	z_date.obo z_fmtstr.obo z_gmgr.obo z_group.obo \
	z_hlist.obo z_icon.obo z_int.obo z_max.obo z_min.obo z_notebk.obo \
	z_obj.obo z_plldn.obo z_plldn1.obo z_popup.obo z_popup1.obo \
	z_prompt.obo z_real.obo z_scroll.obo z_sbar.obo z_spin.obo \
	z_string.obo z_sys.obo z_table.obo z_tbar.obo z_text.obo \
	z_time.obo z_title.obo z_vlist.obo z_win.obo
	-@del owindow.lib
	$(OS2_LIBRARIAN) $(OS2_LIB_OPTS) @&&!
$* &
+advanced.obo+derive.obo+export.obo &
+geometry.obo+group.obo+import.obo+object.obo &
+position.obo+prefer.obo+window.obo+window1.obo &
+z_bnum.obo+z_border.obo+z_button.obo+z_combo.obo &
+z_date.obo+z_fmtstr.obo+z_gmgr.obo+z_group.obo &
+z_hlist.obo+z_icon.obo+z_int.obo+z_max.obo+z_min.obo+z_notebk.obo &
+z_obj.obo+z_plldn.obo+z_plldn1.obo+z_popup.obo+z_popup1.obo &
+z_prompt.obo+z_real.obo+z_sbar.obo+z_scroll.obo+z_spin.obo &
+z_string.obo+z_sys.obo+z_table.obo+z_tbar.obo+z_text.obo &
+z_time.obo+z_title.obo+z_vlist.obo+z_win.obo
!
	copy window.hpp ..\..\include
	copy owindow.lib ..\..\lib\$(VERSION)
	copy p_window.dat ..\..\bin\p_window.znc

