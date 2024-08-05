# ----- General Definitions -------------------------------------------------
VERSION=iccpp300

# ----- OS/2 compiler options -----------------------------------------------
OS2_CPP=icc
OS2_LINK=ilink
OS2_LIBRARIAN=ilib
OS2_RC=rc

# ----- Compile, Link, and Lib options --------------------------------------
OS2_CPP_OPTS=/c /D__OS2__ /Gx+ /Sp1
# ----- Next line for pre-compiled headers ----------------------------------
#OS2_CPP_OPTS=/c /D__OS2__ /Gx+ /Sp1 /FiZIL.SYM /SiZIL.SYM
OS2_LINK_OPTS=/OUT:otest.exe /BASE:0x10000 /PM:PM /NOI
OS2_LIB_OPTS=
OS2_RC_OPTS=

OS2_OBJS=
OS2_LIBS=os2_zil.lib

.SUFFIXES : .cpp

.cpp.obo:
	$(OS2_CPP) $(OS2_CPP_OPTS) /Fo$*.obo $<

# ----- Usage --------------------------------------------------------------
usage:
	@echo ...........
	@echo ...........
	@echo To generate the library modules for OS/2 type:
	@echo nmake -f iccpp300.mak os2
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean.cmd

# ----- Copy files ----------------------------------------------------------
copy:
	copy ui_*.hpp ..\include
	copy z_clean.* ..\bin

# ----- DOS -----------------------------------------------------------------
dos:
	@echo IBM does not support DOS libraries and programs.

# ----- Windows -------------------------------------------------------------
windows:
	@echo IBM does not support Windows libraries and programs.

# ----- OS/2 ----------------------------------------------------------------

os2: copy otest.exe

otest.exe: test.obo os2_zil.lib
	$(OS2_LINK) $(OS2_LINK_OPTS) test.obo $(OS2_OBJS) $(OS2_LIBS) otest.def
	$(OS2_RC) $(OS2_RC_OPTS) otest.rc $*.exe

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
	-@ren *.obo *.obj
	$(OS2_LIBRARIAN) $(OS2_LIB_OPTS) @<<zil.rsp
$* &
	+o_bnum.obj &
	+o_border.obj &
	+o_button.obj &
	+o_combo.obj &
	+o_cursor.obj &
	+o_date.obj &
	+o_dsp.obj &
	+o_error.obj &
	+o_error1.obj &
	+o_event.obj &
	+o_fmtstr.obj &
	+o_group.obj &
	+o_hlist.obj &
	+o_icon.obj &
	+o_image.obj &
	+o_int.obj &
	+o_intl.obj &
	+o_keybrd.obj &
	+o_max.obj &
	+o_min.obj &
	+o_mouse.obj &
	+o_notebk.obj &
	+o_plldn.obj &
	+o_plldn1.obj &
	+o_popup.obj &
	+o_popup1.obj &
	+o_print.obj &
	+o_prompt.obj &
	+o_real.obj &
	+o_sbar.obj &
	+o_scroll.obj &
	+o_spin.obj &
	+o_string.obj &
	+o_sys.obj &
	+o_table.obj &
	+o_table1.obj &
	+o_table2.obj &
	+o_tbar.obj &
	+o_text.obj &
	+o_time.obj &
	+o_title.obj &
	+o_vlist.obj &
	+o_win.obj &
	+o_win1.obj &
	+o_win2.obj &
	+z_app.obj &
	+z_bnum.obj &
	+z_bnum1.obj &
	+z_bnum2.obj &
	+z_border.obj &
	+z_button.obj &
	+z_combo.obj &
	+z_cursor.obj &
	+z_date.obj &
	+z_date1.obj &
	+z_decor.obj &
	+z_device.obj &
	+z_dialog.obj &
	+z_dsp.obj &
	+z_error.obj &
	+z_error1.obj &
	+z_event.obj &
	+z_file.obj &
	+z_fmtstr.obj &
	+z_gmgr.obj &
	+z_gmgr1.obj &
	+z_gmgr2.obj &
	+z_gmgr3.obj &
	+z_group.obj &
	+z_help.obj &
	+z_help1.obj &
	+z_hlist.obj &
	+z_icon.obj &
	+z_image.obj &
	+z_i18n.obj &
	+z_int.obj &
	+z_intl.obj &
	+z_lang.obj &
	+z_list.obj &
	+z_list1.obj &
	+z_locale.obj &
	+z_map1.obj &
	+z_map2.obj &
	+z_max.obj &
	+z_min.obj &
	+z_msgwin.obj &
	+z_path.obj &
	+z_plldn.obj &
	+z_plldn1.obj &
	+z_popup.obj &
	+z_popup1.obj &
	+z_printf.obj &
	+z_prompt.obj &
	+z_real.obj &
	+z_region.obj &
	+z_sbar.obj &
	+z_scanf.obj &
	+z_scroll.obj &
	+z_spin.obj &
	+z_stdarg.obj &
	+z_stored.obj &
	+z_storer.obj &
	+z_storew.obj &
	+z_string.obj &
	+z_sys.obj &
	+z_table.obj &
	+z_table1.obj &
	+z_table2.obj &
	+z_tbar.obj &
	+z_text.obj &
	+z_time.obj &
	+z_time1.obj &
	+z_timer.obj &
	+z_title.obj &
	+z_utils.obj &
	+z_utime.obj &
	+z_utime1.obj &
	+z_vlist.obj &
	+z_win.obj &
	+z_win1.obj &
	+z_win2.obj &
	+z_win3.obj &
	+z_win4.obj &
	+g_dsp.obj &
	+g_event.obj &
	+g_evt.obj &
	+g_gen.obj &
	+g_i18n.obj &
	+g_jump.obj &
	+g_lang.obj &
	+g_lang1.obj &
	+g_loc.obj &
	+g_loc1.obj &
	+g_mach.obj &
	+g_pnorm.obj &
	+g_win.obj &
	+i_file.obj &
	+i_map.obj &
	+i_str1.obj &
	+i_str2.obj &
	+i_str3.obj &
	+i_str4.obj &
	+i_str5.obj &
	+i_type.obj
NUL
<<
	-@ren *.obj *.obo
	-@md ..\lib\$(VERSION)
	copy os2_zil.lib ..\lib\$(VERSION)

