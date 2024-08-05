# ----- General Definitions -------------------------------------------------
VERSION=iccpp210

# ----- OS/2 compiler options -----------------------------------------------
OS2_CPP=icc
OS2_LINK=link386
OS2_LIBRARIAN=lib
OS2_RC=rc

# ZIL_STDARG::RearrangeArgs is not compatible with /O+ optimizations.
OS2_STDARG_CPP_OPTS=/c /D__OS2__
OS2_CPP_OPTS=$(OS2_STDARG_CPP_OPTS) /O+
OS2_LINK_OPTS=/BASE:0x10000 /PM:PM /NOI
#OS2_CPP_OPTS=-C -Ti -D__OS2__
#OS2_LINK_OPTS=/BASE:0x10000 /PM:PM /DE /NOE /NOI
OS2_LIB_OPTS=/pagesize:32
OS2_RC_OPTS=

OS2_OBJS=
OS2_LIBS=os2_zil.lib

.SUFFIXES : .cpp

z_stdarg.obj:
	$(OS2_CPP) $(OS2_STDARG_CPP_OPTS) z_stdarg.cpp

.cpp.obj:
	$(OS2_CPP) $(OS2_CPP_OPTS) $<

# ----- Usage --------------------------------------------------------------
usage:
	@echo ...........
	@echo ...........
	@echo To generate the library modules for OS/2 type:
	@echo nmake -f iccpp210.mak os2
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

otest.exe: test.obj os2_zil.lib
	$(OS2_LINK) $(OS2_LINK_OPTS) @<<zil.rsp
$(OS2_OBJS)+test.obj
$*,NUL,$(OS2_LIBS),otest.def
<<
	$(OS2_RC) $(OS2_RC_OPTS) otest.rc $*.exe

os2_zil.lib : \
	o_bnum.obj \
	o_border.obj \
	o_button.obj \
	o_combo.obj \
	o_cursor.obj \
	o_date.obj \
	o_dsp.obj \
	o_error.obj \
	o_error1.obj \
	o_event.obj \
	o_fmtstr.obj \
	o_group.obj \
	o_hlist.obj \
	o_icon.obj \
	o_image.obj \
	o_int.obj \
	o_intl.obj \
	o_keybrd.obj \
	o_max.obj \
	o_min.obj \
	o_mouse.obj \
	o_notebk.obj \
	o_plldn.obj \
	o_plldn1.obj \
	o_popup.obj \
	o_popup1.obj \
	o_print.obj \
	o_prompt.obj \
	o_real.obj \
	o_sbar.obj \
	o_scroll.obj \
	o_spin.obj \
	o_string.obj \
	o_sys.obj \
	o_table.obj \
	o_table1.obj \
	o_table2.obj \
	o_tbar.obj \
	o_text.obj \
	o_time.obj \
	o_title.obj \
	o_vlist.obj \
	o_win.obj \
	o_win1.obj \
	o_win2.obj \
	z_app.obj \
	z_bnum.obj \
	z_bnum1.obj \
	z_bnum2.obj \
	z_border.obj \
	z_button.obj \
	z_combo.obj \
	z_cursor.obj \
	z_date.obj \
	z_date1.obj \
	z_decor.obj \
	z_device.obj \
	z_dialog.obj \
	z_dsp.obj \
	z_error.obj \
	z_error1.obj \
	z_event.obj \
	z_file.obj \
	z_fmtstr.obj \
	z_gmgr.obj \
	z_gmgr1.obj \
	z_gmgr2.obj \
	z_gmgr3.obj \
	z_group.obj \
	z_help.obj \
	z_help1.obj \
	z_hlist.obj \
	z_icon.obj \
	z_image.obj \
	z_i18n.obj \
	z_int.obj \
	z_intl.obj \
	z_lang.obj \
	z_list.obj \
	z_list1.obj \
	z_locale.obj \
	z_map1.obj \
	z_map2.obj \
	z_max.obj \
	z_min.obj \
	z_msgwin.obj \
	z_path.obj \
	z_plldn.obj \
	z_plldn1.obj \
	z_popup.obj \
	z_popup1.obj \
	z_printf.obj \
	z_prompt.obj \
	z_real.obj \
	z_region.obj \
	z_sbar.obj \
	z_scanf.obj \
	z_scroll.obj \
	z_spin.obj \
	z_stdarg.obj \
	z_stored.obj \
	z_storer.obj \
	z_storew.obj \
	z_string.obj \
	z_sys.obj \
	z_table.obj \
	z_table1.obj \
	z_table2.obj \
	z_tbar.obj \
	z_text.obj \
	z_time.obj \
	z_time1.obj \
	z_timer.obj \
	z_title.obj \
	z_utils.obj \
	z_utime.obj \
	z_utime1.obj \
	z_vlist.obj \
	z_win.obj \
	z_win1.obj \
	z_win2.obj \
	z_win3.obj \
	z_win4.obj \
	g_dsp.obj \
	g_event.obj \
	g_evt.obj \
	g_gen.obj \
	g_i18n.obj \
	g_jump.obj \
	g_lang.obj \
	g_lang1.obj \
	g_loc.obj \
	g_loc1.obj \
	g_mach.obj \
	g_pnorm.obj \
	g_win.obj \
	i_file.obj \
	i_map.obj \
	i_str1.obj \
	i_str2.obj \
	i_str3.obj \
	i_str4.obj \
	i_str5.obj \
	i_type.obj
	-@del os2_zil.lib
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
	-@md ..\lib\$(VERSION)
	copy os2_zil.lib ..\lib\$(VERSION)

