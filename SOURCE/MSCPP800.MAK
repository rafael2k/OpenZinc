# ----- General Definitions -------------------------------------------------
VERSION=mscpp800

.SUFFIXES : .c .cpp .obj .o16 .o32 .obw .obn

# ----- Windows NT compiler options -----------------------------------------
# for debug:    comment out next line
NODEBUG=1
!include <NTWIN32.MAK>

WNT_ZINC_LIBS=wnt_zil.lib
WNT_LIB_OPTS=/MACHINE:ALPHA /SUBSYSTEM:WINDOWS

.cpp.obn:
	$(cc) $(cflags) $(cvars) $(cdebug) -Fo$*.obn $<

# ----- Usage --------------------------------------------------------------
usage:
	@echo ...........
	@echo ...........
	@echo To generate the library modules for specific environments type:
	@echo nmake -f mscpp800.mak winnt
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean.bat

# ----- Copy files ----------------------------------------------------------
copy:
	copy ui_*.hpp ..\include
	copy z_clean.* ..\bin

# ----- Windows NT Libraries and Programs -----------------------------------
winnt: copy ntest.exe

ntest.exe: test.obn wnt_zil.lib
	$(link) $(linkdebug) $(guiflags) test.obn $(guilibs) VERSION.LIB $(WNT_ZINC_LIBS) -out:ntest.exe

wnt_zil.lib : \
	3_bnum.obn \
	3_border.obn \
	3_button.obn \
	3_combo.obn \
	3_cursor.obn \
	3_date.obn \
	3_dsp.obn \
	3_error.obn \
	3_error1.obn \
	3_event.obn \
	3_fmtstr.obn \
	3_group.obn \
	3_hlist.obn \
	3_icon.obn \
	3_image.obn \
	3_int.obn \
	3_intl.obn \
	3_keybrd.obn \
	3_max.obn \
	3_min.obn \
	3_mouse.obn \
	3_notebk.obn \
	3_plldn.obn \
	3_plldn1.obn \
	3_popup.obn \
	3_popup1.obn \
	3_print.obn \
	3_prompt.obn \
	3_real.obn \
	3_sbar.obn \
	3_scroll.obn \
	3_spin.obn \
	3_string.obn \
	3_sys.obn \
	3_table.obn \
	3_table1.obn \
	3_table2.obn \
	3_tbar.obn \
	3_text.obn \
	3_time.obn \
	3_title.obn \
	3_vlist.obn \
	3_win.obn \
	3_win1.obn \
	3_win2.obn \
	z_app.obn \
	z_bnum.obn \
	z_bnum1.obn \
	z_bnum2.obn \
	z_border.obn \
	z_button.obn \
	z_combo.obn \
	z_cursor.obn \
	z_date.obn \
	z_date1.obn \
	z_decor.obn \
	z_device.obn \
	z_dialog.obn \
	z_dsp.obn \
	z_error.obn \
	z_error1.obn \
	z_event.obn \
	z_file.obn \
	z_fmtstr.obn \
	z_gmgr.obn \
	z_gmgr1.obn \
	z_gmgr2.obn \
	z_gmgr3.obn \
	z_group.obn \
	z_help.obn \
	z_help1.obn \
	z_hlist.obn \
	z_icon.obn \
	z_image.obn \
	z_i18n.obn \
	z_int.obn \
	z_intl.obn \
	z_lang.obn \
	z_list.obn \
	z_list1.obn \
	z_locale.obn \
	z_map1.obn \
	z_map2.obn \
	z_max.obn \
	z_min.obn \
	z_msgwin.obn \
	z_notebk.obn \
	z_path.obn \
	z_plldn.obn \
	z_plldn1.obn \
	z_popup.obn \
	z_popup1.obn \
	z_printf.obn \
	z_prompt.obn \
	z_real.obn \
	z_region.obn \
	z_sbar.obn \
	z_scanf.obn \
	z_scroll.obn \
	z_spin.obn \
	z_stdarg.obn \
	z_stored.obn \
	z_storer.obn \
	z_storew.obn \
	z_string.obn \
	z_sys.obn \
	z_table.obn \
	z_table1.obn \
	z_table2.obn \
	z_tbar.obn \
	z_text.obn \
	z_time.obn \
	z_time1.obn \
	z_timer.obn \
	z_title.obn \
	z_utils.obn \
	z_utime.obn \
	z_utime1.obn \
	z_vlist.obn \
	z_win.obn \
	z_win1.obn \
	z_win2.obn \
	z_win3.obn \
	z_win4.obn \
	g_dsp.obn \
	g_event.obn \
	g_evt.obn \
	g_gen.obn \
	g_i18n.obn \
	g_jump.obn \
	g_lang.obn \
	g_lang1.obn \
	g_loc.obn \
	g_loc1.obn \
	g_mach.obn \
	g_pnorm.obn \
	g_win.obn \
	i_file.obn \
	i_map.obn \
	i_str1.obn \
	i_str2.obn \
	i_str3.obn \
	i_str4.obn \
	i_str5.obn \
	i_type.obn
	-@del wnt_zil.lib
	$(implib) /out:wnt_zil.lib $(WNT_LIB_OPTS) @<<zil.rsp
3_bnum.obn
3_border.obn
3_button.obn
3_combo.obn
3_cursor.obn
3_date.obn
3_dsp.obn
3_error.obn
3_error1.obn
3_event.obn
3_fmtstr.obn
3_group.obn
3_hlist.obn
3_icon.obn
3_image.obn
3_int.obn
3_intl.obn
3_keybrd.obn
3_max.obn
3_min.obn
3_mouse.obn
3_notebk.obn
3_plldn.obn
3_plldn1.obn
3_popup.obn
3_popup1.obn
3_print.obn
3_prompt.obn
3_real.obn
3_sbar.obn
3_scroll.obn
3_spin.obn
3_string.obn
3_sys.obn
3_table.obn
3_table1.obn
3_table2.obn
3_tbar.obn
3_text.obn
3_time.obn
3_title.obn
3_vlist.obn
3_win.obn
3_win1.obn
3_win2.obn
z_app.obn
z_bnum.obn
z_bnum1.obn
z_bnum2.obn
z_border.obn
z_button.obn
z_combo.obn
z_cursor.obn
z_date.obn
z_date1.obn
z_decor.obn
z_device.obn
z_dialog.obn
z_dsp.obn
z_error.obn
z_error1.obn
z_event.obn
z_file.obn
z_fmtstr.obn
z_gmgr.obn
z_gmgr1.obn
z_gmgr2.obn
z_gmgr3.obn
z_group.obn
z_help.obn
z_help1.obn
z_hlist.obn
z_icon.obn
z_image.obn
z_i18n.obn
z_int.obn
z_intl.obn
z_lang.obn
z_list.obn
z_list1.obn
z_locale.obn
z_map1.obn
z_map2.obn
z_max.obn
z_min.obn
z_msgwin.obn
z_notebk.obn
z_path.obn
z_plldn.obn
z_plldn1.obn
z_popup.obn
z_popup1.obn
z_printf.obn
z_prompt.obn
z_real.obn
z_region.obn
z_sbar.obn
z_scanf.obn
z_scroll.obn
z_spin.obn
z_stdarg.obn
z_stored.obn
z_storer.obn
z_storew.obn
z_string.obn
z_sys.obn
z_table.obn
z_table1.obn
z_table2.obn
z_tbar.obn
z_text.obn
z_time.obn
z_time1.obn
z_timer.obn
z_title.obn
z_utils.obn
z_utime.obn
z_utime1.obn
z_vlist.obn
z_win.obn
z_win1.obn
z_win2.obn
z_win3.obn
z_win4.obn
g_dsp.obn
g_event.obn
g_evt.obn
g_gen.obn
g_i18n.obn
g_jump.obn
g_lang.obn
g_lang1.obn
g_loc.obn
g_loc1.obn
g_mach.obn
g_pnorm.obn
g_win.obn
i_file.obn
i_map.obn
i_str1.obn
i_str2.obn
i_str3.obn
i_str4.obn
i_str5.obn
i_type.obn
<<
	-@md ..\lib\$(VERSION)
	copy wnt_zil.lib ..\lib\$(VERSION)
