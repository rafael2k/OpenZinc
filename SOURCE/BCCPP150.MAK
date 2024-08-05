# ----- General Definitions -------------------------------------------------
VERSION=bccpp150

# ----- OS/2 compiler options -----------------------------------------------
OS2_CPP=bcc
OS2_LINK=tlink
OS2_LIBRARIAN=tlib
OS2_RC=rc

OS2_CPP_OPTS=-c -H=ZIL.SYM
OS2_LINK_OPTS=/c /B:0x10000 /aa
#OS2_CPP_OPTS=-c -H=ZIL.SYM -v
#OS2_LINK_OPTS=/c /B:0x10000 /v /aa
OS2_LIB_OPTS=
OS2_RC_OPTS=

OS2_OBJS=c02.obj
OS2_LIBS=os2_zil.lib os2.lib c2.lib

.cpp.obo:
	$(OS2_CPP) $(OS2_CPP_OPTS) -o$*.obo {$< }

# ----- Usage --------------------------------------------------------------
usage:
	@echo ...........
	@echo ...........
	@echo To generate the library modules for borland type:
	@echo make -f bccpp150.mak os2
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean

# ----- Copy files ----------------------------------------------------------
copy:
	copy ui_*.hpp ..\include
	copy z_clean.* ..\bin

# ----- OS/2 ----------------------------------------------------------------

os2: copy otest.exe

otest.exe: test.obo os2_zil.lib 
	$(OS2_LINK) $(OS2_LINK_OPTS) @&&!
$(OS2_OBJS)+test.obo
$*, , $(OS2_LIBS),otest.def
!
	$(OS2_RC) $(OS2_RC_OPTS) otest.rc $<
	-@del zil.sym

os2_zil.lib : \
	o_bnum.obo \
	o_border.obo \
	o_button.obo \
	o_combo.obo \
	o_cursor.obo \
	o_date.obo \
	o_dsp.obo \
	o_error.obo \
	o_error1.obo \
	o_event.obo \
	o_fmtstr.obo \
	o_group.obo \
	o_hlist.obo \
	o_icon.obo \
	o_image.obo \
	o_int.obo \
	o_intl.obo \
	o_keybrd.obo \
	o_max.obo \
	o_min.obo \
	o_mouse.obo \
	o_notebk.obo \
	o_plldn.obo \
	o_plldn1.obo \
	o_popup.obo \
	o_popup1.obo \
	o_print.obo \
	o_prompt.obo \
	o_real.obo \
	o_sbar.obo \
	o_scroll.obo \
	o_spin.obo \
	o_string.obo \
	o_sys.obo \
	o_table.obo \
	o_table1.obo \
	o_table2.obo \
	o_tbar.obo \
	o_text.obo \
	o_time.obo \
	o_title.obo \
	o_vlist.obo \
	o_win.obo \
	o_win1.obo \
	o_win2.obo \
	z_app.obo \
	z_bnum.obo \
	z_bnum1.obo \
	z_bnum2.obo \
	z_border.obo \
	z_button.obo \
	z_combo.obo \
	z_cursor.obo \
	z_date.obo \
	z_date1.obo \
	z_decor.obo \
	z_device.obo \
	z_dialog.obo \
	z_dsp.obo \
	z_error.obo \
	z_error1.obo \
	z_event.obo \
	z_file.obo \
	z_fmtstr.obo \
	z_gmgr.obo \
	z_gmgr1.obo \
	z_gmgr2.obo \
	z_gmgr3.obo \
	z_group.obo \
	z_help.obo \
	z_help1.obo \
	z_hlist.obo \
	z_icon.obo \
	z_image.obo \
	z_i18n.obo \
	z_int.obo \
	z_intl.obo \
	z_lang.obo \
	z_list.obo \
	z_list1.obo \
	z_locale.obo \
	z_map1.obo \
	z_map2.obo \
	z_max.obo \
	z_min.obo \
	z_msgwin.obo \
	z_path.obo \
	z_plldn.obo \
	z_plldn1.obo \
	z_popup.obo \
	z_popup1.obo \
	z_printf.obo \
	z_prompt.obo \
	z_real.obo \
	z_region.obo \
	z_sbar.obo \
	z_scanf.obo \
	z_scroll.obo \
	z_spin.obo \
	z_stdarg.obo \
	z_stored.obo \
	z_storer.obo \
	z_storew.obo \
	z_string.obo \
	z_sys.obo \
	z_table.obo \
	z_table1.obo \
	z_table2.obo \
	z_tbar.obo \
	z_text.obo \
	z_time.obo \
	z_time1.obo \
	z_timer.obo \
	z_title.obo \
	z_utils.obo \
	z_utime.obo \
	z_utime1.obo \
	z_vlist.obo \
	z_win.obo \
	z_win1.obo \
	z_win2.obo \
	z_win3.obo \
	z_win4.obo \
	g_dsp.obo \
	g_event.obo \
	g_evt.obo \
	g_gen.obo \
	g_i18n.obo \
	g_jump.obo \
	g_lang.obo \
	g_lang1.obo \
	g_loc.obo \
	g_loc1.obo \
	g_mach.obo \
	g_pnorm.obo \
	g_win.obo \
	i_file.obo \
	i_map.obo \
	i_str1.obo \
	i_str2.obo \
	i_str3.obo \
	i_str4.obo \
	i_str5.obo \
	i_type.obo
	-@del os2_zil.lib
	$(OS2_LIBRARIAN) $(OS2_LIB_OPTS) @&&!
$* &
	+o_bnum.obo &
	+o_border.obo &
	+o_button.obo &
	+o_combo.obo &
	+o_cursor.obo &
	+o_date.obo &
	+o_dsp.obo &
	+o_error.obo &
	+o_error1.obo &
	+o_event.obo &
	+o_fmtstr.obo &
	+o_group.obo &
	+o_hlist.obo &
	+o_icon.obo &
	+o_image.obo &
	+o_int.obo &
	+o_intl.obo &
	+o_keybrd.obo &
	+o_max.obo &
	+o_min.obo &
	+o_mouse.obo &
	+o_notebk.obo &
	+o_plldn.obo &
	+o_plldn1.obo &
	+o_popup.obo &
	+o_popup1.obo &
	+o_print.obo &
	+o_prompt.obo &
	+o_real.obo &
	+o_sbar.obo &
	+o_scroll.obo &
	+o_spin.obo &
	+o_string.obo &
	+o_sys.obo &
	+o_table.obo &
	+o_table1.obo &
	+o_table2.obo &
	+o_tbar.obo &
	+o_text.obo &
	+o_time.obo &
	+o_title.obo &
	+o_vlist.obo &
	+o_win.obo &
	+o_win1.obo &
	+o_win2.obo &
	+z_app.obo &
	+z_bnum.obo &
	+z_bnum1.obo &
	+z_bnum2.obo &
	+z_border.obo &
	+z_button.obo &
	+z_combo.obo &
	+z_cursor.obo &
	+z_date.obo &
	+z_date1.obo &
	+z_decor.obo &
	+z_device.obo &
	+z_dialog.obo &
	+z_dsp.obo &
	+z_error.obo &
	+z_error1.obo &
	+z_event.obo &
	+z_file.obo &
	+z_fmtstr.obo &
	+z_gmgr.obo &
	+z_gmgr1.obo &
	+z_gmgr2.obo &
	+z_gmgr3.obo &
	+z_group.obo &
	+z_help.obo &
	+z_help1.obo &
	+z_hlist.obo &
	+z_icon.obo &
	+z_image.obo &
	+z_i18n.obo &
	+z_int.obo &
	+z_intl.obo &
	+z_lang.obo &
	+z_list.obo &
	+z_list1.obo &
	+z_locale.obo &
	+z_map1.obo &
	+z_map2.obo &
	+z_max.obo &
	+z_min.obo &
	+z_msgwin.obo &
	+z_path.obo &
	+z_plldn.obo &
	+z_plldn1.obo &
	+z_popup.obo &
	+z_popup1.obo &
	+z_printf.obo &
	+z_prompt.obo &
	+z_real.obo &
	+z_region.obo &
	+z_sbar.obo &
	+z_scanf.obo &
	+z_scroll.obo &
	+z_spin.obo &
	+z_stdarg.obo &
	+z_stored.obo &
	+z_storer.obo &
	+z_storew.obo &
	+z_string.obo &
	+z_sys.obo &
	+z_table.obo &
	+z_table1.obo &
	+z_table2.obo &
	+z_tbar.obo &
	+z_text.obo &
	+z_time.obo &
	+z_time1.obo &
	+z_timer.obo &
	+z_title.obo &
	+z_utils.obo &
	+z_utime.obo &
	+z_utime1.obo &
	+z_vlist.obo &
	+z_win.obo &
	+z_win1.obo &
	+z_win2.obo &
	+z_win3.obo &
	+z_win4.obo &
	+g_dsp.obo &
	+g_event.obo &
	+g_evt.obo &
	+g_gen.obo &
	+g_i18n.obo &
	+g_jump.obo &
	+g_lang.obo &
	+g_lang1.obo &
	+g_loc.obo &
	+g_loc1.obo &
	+g_mach.obo &
	+g_pnorm.obo &
	+g_win.obo &
	+i_file.obo &
	+i_map.obo &
	+i_str1.obo &
	+i_str2.obo &
	+i_str3.obo &
	+i_str4.obo &
	+i_str5.obo &
	+i_type.obo
!
	-@del zil.sym
	-@md ..\lib\$(VERSION)
	copy os2_zil.lib ..\lib\$(VERSION)

