# ----- General Definitions -------------------------------------------------
VERSION=sccpp600

# ----- DOS compiler options ------------------------------------------------
DOS_CPP=sc
DOS_LINK=link
DOS_LIBRARIAN=lib
DOS_CPP_OPTS=-c -a1 -bx -ml -o+space -R
DOS_LINK_OPTS=/NOI /SEG:300
DOS_LIB_OPTS=/N /B /NOI
DOS_OBJS=
DOS_LIBS=dos_zil dos_gfx sc_lgfx

.cpp.obj:
	$(DOS_CPP) $(DOS_CPP_OPTS) $<

# ----- DOS Overlay (VCM) compiler options ----------------------------------
OVL_CPP=sc
OVL_LINK=link
OVL_LIBRARIAN=lib
OVL_CPP_OPTS=-c -a1 -bx -mv -o+space -R
OVL_LINK_OPTS=/NOI /F /PAC
OVL_LIB_OPTS=/N /B /NOI
OVL_OBJS=
OVL_LIBS=dos_zilv dos_gfxv sc_lgfxv

.cpp.ovl:
	$(OVL_CPP) $(OVL_CPP_OPTS) -o$@ $<

# ----- DOS 32 bit extender (X-32VM) compiler options -----------------------
D32_CPP=sc
D32_LINK=link
D32_LIBRARIAN=lib
D32_CPP_OPTS=-c -bx -mx -o+space -R
D32_LINK_OPTS=/NOI
D32_LIB_OPTS=/N /B /NOI
D32_OBJS=cx
D32_LIBS=d32_zil d32_gfx sc_32gfx

.cpp.o32:
	$(D32_CPP) $(D32_CPP_OPTS) -o$@ $<

# ----- Windows compiler options --------------------------------------------
WIN_CPP=sc
WIN_LINK=link
WIN_LIBRARIAN=lib
WIN_RC=rc

WIN_CPP_OPTS=-c -a1 -bx -ml -W2 -o+space -R
WIN_RC_OPTS=-k
WIN_LINK_OPTS=/NOI /PACKC:42000
WIN_LIB_OPTS=/N /B /PAGESIZE:32

WIN_OBJS=
WIN_LIBS=win_zil libw ctl3dv2

.cpp.obw:
	$(WIN_CPP) $(WIN_CPP_OPTS) -o$@ $<

# ----- Windows NT (and WIN32s) compiler options ----------------------------
WNT_CPP=sc
WNT_LINK=link
WNT_LIBRARIAN=lib
WNT_RC=rc

WNT_CPP_OPTS=-c -4 -mn -WA  
WNT_RC_OPTS=-k
WNT_LINK_OPTS=/NOI
WNT_LIB_OPTS=/N /B

WNT_OBJS=
WNT_LIBS=wnt_zil kernel32 user32 gdi32 ctl3d32 

.cpp.obn:
	$(WNT_CPP) $(WNT_CPP_OPTS) -o$@ $<
	
# ----- WINDOWS 32 compiler options ----------------------------
W32_CPP=sc
W32_LINK=link
W32_LIBRARIAN=lib
W32_RC=rc

W32_CPP_OPTS=-c -4 -mn -WA -DZIL_WIN32
W32_RC_OPTS=-k
W32_LINK_OPTS=/NOI
W32_LIB_OPTS=/N /B

W32_OBJS=
W32_LIBS=w32_zil kernel32 user32 gdi32 ctl3d32 comctl32

.cpp.ob9:
	$(W32_CPP) $(W32_CPP_OPTS) -o$@ $<

        
# ----- Usage --------------------------------------------------------------
usage:
	@echo ...........
	@echo ...........
	@echo To generate the library modules for specific environments type:
	@echo make -fsccpp600.mak dos
	@echo make -fsccpp600.mak dosovl
	@echo make -fsccpp600.mak dos32
	@echo make -fsccpp600.mak windows
	@echo make -fsccpp600.mak winnt
	@echo make -fsccpp600.mak win32

	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean.bat

# ----- Copy files ----------------------------------------------------------
copy:
	copy ui_*.hpp ..\include
	copy z_clean.* ..\bin

gfx_copy:
	copy gfx\source\gfx.h ..\include
	copy gfx\source\gfx_pro.h ..\include

# ----- DOS Libraries and Programs ------------------------------------------

dos: copy gfx_copy OEMfont ISOfont dos_gfx.lib sc_lgfx.lib test.exe

test.exe: test.obj dos_zil.lib
	$(DOS_LINK) $(DOS_LINK_OPTS) $(DOS_OBJS)+test.obj, $*, , $(DOS_LIBS)

dos_zil.lib : \
	d_bnum.obj \
	d_border.obj \
	d_button.obj \
	d_combo.obj \
	d_cursor.obj \
	d_date.obj \
	d_error.obj \
	d_error1.obj \
	d_event.obj \
	d_fmtstr.obj \
	d_group.obj \
	d_hlist.obj \
	d_icon.obj \
	d_image.obj \
	d_int.obj \
	d_intl.obj \
	d_keybrd.obj \
	d_max.obj \
	d_min.obj \
	d_mouse.obj \
	d_notebk.obj \
	d_plldn.obj \
	d_plldn1.obj \
	d_popup.obj \
	d_popup1.obj \
	d_prompt.obj \
	d_real.obj \
	d_sbar.obj \
	d_scroll.obj \
	d_spin.obj \
	d_string.obj \
	d_sys.obj \
	d_table.obj \
	d_table1.obj \
	d_table2.obj \
	d_tbar.obj \
	d_tdsp.obj \
	d_text.obj \
	d_time.obj \
	d_title.obj \
	d_vlist.obj \
	d_win.obj \
	d_win1.obj \
	d_win2.obj \
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
	z_notebk.obj \
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
	i_type.obj \
	i_sccat.obj
	-@del dos_zil.lib
	$(DOS_LIBRARIAN) /C $(DOS_LIB_OPTS) @dos_zil.rsp
	-@md ..\lib\$(VERSION)
	copy dos_zil.lib ..\lib\$(VERSION)

#dos_gfx.lib : d_gfxdsp.obj d_gfxprn.obj i_gfx.obj z_appgfx.obj OEMfont ISOfont
dos_gfx.lib : d_gfxdsp.obj d_gfxprn.obj i_gfx.obj z_appgfx.obj oem_smal.obj oem_dial.obj oem_syst.obj iso_smal.obj iso_dial.obj iso_syst.obj
	-@del dos_gfx.lib
	$(DOS_LIBRARIAN) $@ $(DOS_LIB_OPTS) +d_gfxdsp.obj+d_gfxprn.obj+i_gfx.obj+z_appgfx.obj;
	$(DOS_LIBRARIAN) $@ $(DOS_LIB_OPTS) +OEM_smal.obj+OEM_dial.obj+OEM_syst.obj;
	$(DOS_LIBRARIAN) $@ $(DOS_LIB_OPTS) +ISO_smal.obj+ISO_dial.obj+ISO_syst.obj;
	-@md ..\lib\$(VERSION)
	copy dos_gfx.lib ..\lib\$(VERSION)

sc_lgfx.lib :
	@cd gfx\source
	make -f sccpp600.mak dos
	@cd ..\..

# ----- DOS Overlay (VCM) Libraries and Programs ----------------------------
dosovl: copy gfx_copy dos_gfxv.lib sc_lgfxv.lib dos_zilv.lib testovl.exe

testovl.exe: test.ovl dos_zilv.lib
	$(OVL_LINK) $(OVL_LINK_OPTS) $(OVL_OBJS)+test.ovl, $*, , $(OVL_LIBS)

dos_zilv.lib : \
	d_bnum.ovl \
	d_border.ovl \
	d_button.ovl \
	d_combo.ovl \
	d_cursor.ovl \
	d_date.ovl \
	d_error.ovl \
	d_error1.ovl \
	d_event.ovl \
	d_fmtstr.ovl \
	d_group.ovl \
	d_hlist.ovl \
	d_icon.ovl \
	d_image.ovl \
	d_int.ovl \
	d_intl.ovl \
	d_keybrd.ovl \
	d_max.ovl \
	d_min.ovl \
	d_mouse.ovl \
	d_notebk.ovl \
	d_plldn.ovl \
	d_plldn1.ovl \
	d_popup.ovl \
	d_popup1.ovl \
	d_prompt.ovl \
	d_real.ovl \
	d_sbar.ovl \
	d_scroll.ovl \
	d_spin.ovl \
	d_string.ovl \
	d_sys.ovl \
	d_table.ovl \
	d_table1.ovl \
	d_table2.ovl \
	d_tbar.ovl \
	d_tdsp.ovl \
	d_text.ovl \
	d_time.ovl \
	d_title.ovl \
	d_vlist.ovl \
	d_win.ovl \
	d_win1.ovl \
	d_win2.ovl \
	z_bnum.ovl \
	z_bnum1.ovl \
	z_bnum2.ovl \
	z_border.ovl \
	z_button.ovl \
	z_combo.ovl \
	z_cursor.ovl \
	z_date.ovl \
	z_date1.ovl \
	z_decor.ovl \
	z_device.ovl \
	z_dialog.ovl \
	z_dsp.ovl \
	z_error.ovl \
	z_error1.ovl \
	z_event.ovl \
	z_file.ovl \
	z_fmtstr.ovl \
	z_gmgr.ovl \
	z_gmgr1.ovl \
	z_gmgr2.ovl \
	z_gmgr3.ovl \
	z_group.ovl \
	z_help.ovl \
	z_help1.ovl \
	z_hlist.ovl \
	z_icon.ovl \
	z_image.ovl \
	z_i18n.ovl \
	z_int.ovl \
	z_intl.ovl \
	z_lang.ovl \
	z_list.ovl \
	z_list1.ovl \
	z_locale.ovl \
	z_map1.ovl \
	z_map2.ovl \
	z_max.ovl \
	z_min.ovl \
	z_msgwin.ovl \
	z_notebk.ovl \
	z_path.ovl \
	z_plldn.ovl \
	z_plldn1.ovl \
	z_popup.ovl \
	z_popup1.ovl \
	z_printf.ovl \
	z_prompt.ovl \
	z_real.ovl \
	z_region.ovl \
	z_sbar.ovl \
	z_scanf.ovl \
	z_scroll.ovl \
	z_spin.ovl \
	z_stdarg.ovl \
	z_stored.ovl \
	z_storer.ovl \
	z_storew.ovl \
	z_string.ovl \
	z_sys.ovl \
	z_table.ovl \
	z_table1.ovl \
	z_table2.ovl \
	z_tbar.ovl \
	z_text.ovl \
	z_time.ovl \
	z_time1.ovl \
	z_timer.ovl \
	z_title.ovl \
	z_utils.ovl \
	z_utime.ovl \
	z_utime1.ovl \
	z_vlist.ovl \
	z_win.ovl \
	z_win1.ovl \
	z_win2.ovl \
	z_win3.ovl \
	z_win4.ovl \
	g_dsp.ovl \
	g_event.ovl \
	g_evt.ovl \
	g_gen.ovl \
	g_i18n.ovl \
	g_jump.ovl \
	g_lang.ovl \
	g_lang1.ovl \
	g_loc.ovl \
	g_loc1.ovl \
	g_mach.ovl \
	g_pnorm.ovl \
	g_win.ovl \
	i_file.ovl \
	i_map.ovl \
	i_str1.ovl \
	i_str2.ovl \
	i_str3.ovl \
	i_str4.ovl \
	i_str5.ovl \
	i_type.ovl \
	i_sccat.ovl
	-@del dos_zilv.lib
	$(OVL_LIBRARIAN) /C $(OVL_LIB_OPTS) @dos_zilv.rsp
	-@md ..\lib\$(VERSION)
	copy dos_zilv.lib ..\lib\$(VERSION)

dos_gfxv.lib : d_gfxdsp.ovl d_gfxprn.ovl i_gfx.ovl z_appgfx.ovl OEMfont ISOfont \
	OEM_smal.ovl OEM_dial.ovl OEM_syst.ovl ISO_smal.ovl ISO_dial.ovl ISO_syst.ovl

	-@del dos_gfxv.lib
	$(OVL_LIBRARIAN) $@ $(OVL_LIB_OPTS) +d_gfxdsp.ovl+d_gfxprn.ovl+i_gfx.ovl+z_appgfx.ovl;
	$(OVL_LIBRARIAN) $@ $(OVL_LIB_OPTS) +OEM_smal.ovl+OEM_dial.ovl+OEM_syst.ovl;
	$(OVL_LIBRARIAN) $@ $(OVL_LIB_OPTS) +ISO_smal.ovl+ISO_dial.ovl+ISO_syst.ovl;
	-@md ..\lib\$(VERSION)
	copy dos_gfxv.lib ..\lib\$(VERSION)

sc_lgfxv.lib :
	@cd gfx\source
	make -f sccpp600.mak dosovl
	@cd ..\..

# ----- DOS 32 bit extender (X-32VM) compiler options -----------------------
dos32: copy gfx_copy d32_gfx.lib sc_32gfx.lib test32.exe

test32.exe: test.o32 d32_zil.lib
	$(D32_LINK) $(D32_LINK_OPTS) $(D32_OBJS)+test.o32, $*, , $(D32_LIBS)

d32_zil.lib : \
	d_bnum.o32 \
	d_border.o32 \
	d_button.o32 \
	d_combo.o32 \
	d_cursor.o32 \
	d_date.o32 \
	d_error.o32 \
	d_error1.o32 \
	d_event.o32 \
	d_fmtstr.o32 \
	d_group.o32 \
	d_hlist.o32 \
	d_icon.o32 \
	d_image.o32 \
	d_int.o32 \
	d_intl.o32 \
	d_keybrd.o32 \
	d_max.o32 \
	d_min.o32 \
	d_mouse.o32 \
	d_notebk.o32 \
	d_plldn.o32 \
	d_plldn1.o32 \
	d_popup.o32 \
	d_popup1.o32 \
	d_prompt.o32 \
	d_real.o32 \
	d_sbar.o32 \
	d_scroll.o32 \
	d_spin.o32 \
	d_string.o32 \
	d_sys.o32 \
	d_table.o32 \
	d_table1.o32 \
	d_table2.o32 \
	d_tbar.o32 \
	d_tdsp.o32 \
	d_text.o32 \
	d_time.o32 \
	d_title.o32 \
	d_vlist.o32 \
	d_win.o32 \
	d_win1.o32 \
	d_win2.o32 \
	z_bnum.o32 \
	z_bnum1.o32 \
	z_bnum2.o32 \
	z_border.o32 \
	z_button.o32 \
	z_combo.o32 \
	z_cursor.o32 \
	z_date.o32 \
	z_date1.o32 \
	z_decor.o32 \
	z_device.o32 \
	z_dialog.o32 \
	z_dsp.o32 \
	z_error.o32 \
	z_error1.o32 \
	z_event.o32 \
	z_file.o32 \
	z_fmtstr.o32 \
	z_gmgr.o32 \
	z_gmgr1.o32 \
	z_gmgr2.o32 \
	z_gmgr3.o32 \
	z_group.o32 \
	z_help.o32 \
	z_help1.o32 \
	z_hlist.o32 \
	z_icon.o32 \
	z_image.o32 \
	z_i18n.o32 \
	z_int.o32 \
	z_intl.o32 \
	z_lang.o32 \
	z_list.o32 \
	z_list1.o32 \
	z_locale.o32 \
	z_map1.o32 \
	z_map2.o32 \
	z_max.o32 \
	z_min.o32 \
	z_msgwin.o32 \
	z_notebk.o32 \
	z_path.o32 \
	z_plldn.o32 \
	z_plldn1.o32 \
	z_popup.o32 \
	z_popup1.o32 \
	z_printf.o32 \
	z_prompt.o32 \
	z_real.o32 \
	z_region.o32 \
	z_sbar.o32 \
	z_scanf.o32 \
	z_scroll.o32 \
	z_spin.o32 \
	z_stdarg.o32 \
	z_stored.o32 \
	z_storer.o32 \
	z_storew.o32 \
	z_string.o32 \
	z_sys.o32 \
	z_table.o32 \
	z_table1.o32 \
	z_table2.o32 \
	z_tbar.o32 \
	z_text.o32 \
	z_time.o32 \
	z_time1.o32 \
	z_timer.o32 \
	z_title.o32 \
	z_utils.o32 \
	z_utime.o32 \
	z_utime1.o32 \
	z_vlist.o32 \
	z_win.o32 \
	z_win1.o32 \
	z_win2.o32 \
	z_win3.o32 \
	z_win4.o32 \
	g_dsp.o32 \
	g_event.o32 \
	g_evt.o32 \
	g_gen.o32 \
	g_i18n.o32 \
	g_jump.o32 \
	g_lang.o32 \
	g_lang1.o32 \
	g_loc.o32 \
	g_loc1.o32 \
	g_mach.o32 \
	g_pnorm.o32 \
	g_win.o32 \
	i_file.o32 \
	i_map.o32 \
	i_str1.o32 \
	i_str2.o32 \
	i_str3.o32 \
	i_str4.o32 \
	i_str5.o32 \
	i_type.o32 \
	i_sccat.o32
	-@del d32_zil.lib
	$(D32_LIBRARIAN) /C $(D32_LIB_OPTS) @d32_zil.rsp
	-@md ..\lib\$(VERSION)
	copy d32_zil.lib ..\lib\$(VERSION)

d32_gfx.lib : d_gfxdsp.o32 d_gfxprn.o32 i_gfx.o32 z_appgfx.o32 OEMfont ISOfont \
	OEM_smal.o32 OEM_dial.o32 OEM_syst.o32 ISO_smal.o32 ISO_dial.o32 ISO_syst.o32
	-@del d32_gfx.lib
	$(D32_LIBRARIAN) $@ $(D32_LIB_OPTS) +d_gfxdsp.o32+d_gfxprn.o32+i_gfx.o32+z_appgfx.o32;
	$(D32_LIBRARIAN) $@ $(D32_LIB_OPTS) +OEM_smal.o32+OEM_dial.o32+OEM_syst.o32;
	$(D32_LIBRARIAN) $@ $(D32_LIB_OPTS) +ISO_smal.o32+ISO_dial.o32+ISO_syst.o32;
	-@md ..\lib\$(VERSION)
	copy d32_gfx.lib ..\lib\$(VERSION)

sc_32gfx.lib :
	@cd gfx\source
	make -f sccpp600.mak dos32
	@cd ..\..

# ----- Windows Libraries and Programs --------------------------------------

windows: copy wtest.exe

wtest.exe: test.obw win_zil.lib
	$(WIN_LINK) $(WIN_LINK_OPTS) $(WIN_OBJS)+test.obw, $*, , $(WIN_LIBS), wtest.def
	$(WIN_RC) wtest.rc 

win_zil.lib : \
	w_bnum.obw \
	w_border.obw \
	w_button.obw \
	w_combo.obw \
	w_cursor.obw \
	w_date.obw \
	w_dsp.obw \
	w_error.obw \
	w_error1.obw \
	w_event.obw \
	w_fmtstr.obw \
	w_group.obw \
	w_hlist.obw \
	w_icon.obw \
	w_image.obw \
	w_int.obw \
	w_intl.obw \
	w_keybrd.obw \
	w_max.obw \
	w_min.obw \
	w_mouse.obw \
	w_notebk.obw \
	w_plldn.obw \
	w_plldn1.obw \
	w_popup.obw \
	w_popup1.obw \
	w_print.obw \
	w_prompt.obw \
	w_real.obw \
	w_sbar.obw \
	w_scroll.obw \
	w_spin.obw \
	w_string.obw \
	w_sys.obw \
	w_table.obw \
	w_table1.obw \
	w_table2.obw \
	w_tbar.obw \
	w_text.obw \
	w_time.obw \
	w_title.obw \
	w_vlist.obw \
	w_win.obw \
	w_win1.obw \
	w_win2.obw \
	z_app.obw \
	z_bnum.obw \
	z_bnum1.obw \
	z_bnum2.obw \
	z_border.obw \
	z_button.obw \
	z_combo.obw \
	z_cursor.obw \
	z_date.obw \
	z_date1.obw \
	z_decor.obw \
	z_device.obw \
	z_dialog.obw \
	z_dsp.obw \
	z_error.obw \
	z_error1.obw \
	z_event.obw \
	z_file.obw \
	z_fmtstr.obw \
	z_gmgr.obw \
	z_gmgr1.obw \
	z_gmgr2.obw \
	z_gmgr3.obw \
	z_group.obw \
	z_help.obw \
	z_help1.obw \
	z_hlist.obw \
	z_icon.obw \
	z_image.obw \
	z_i18n.obw \
	z_int.obw \
	z_intl.obw \
	z_lang.obw \
	z_list.obw \
	z_list1.obw \
	z_locale.obw \
	z_map1.obw \
	z_map2.obw \
	z_max.obw \
	z_min.obw \
	z_msgwin.obw \
	z_notebk.obw \
	z_path.obw \
	z_plldn.obw \
	z_plldn1.obw \
	z_popup.obw \
	z_popup1.obw \
	z_printf.obw \
	z_prompt.obw \
	z_real.obw \
	z_region.obw \
	z_sbar.obw \
	z_scanf.obw \
	z_scroll.obw \
	z_spin.obw \
	z_stdarg.obw \
	z_stored.obw \
	z_storer.obw \
	z_storew.obw \
	z_string.obw \
	z_sys.obw \
	z_table.obw \
	z_table1.obw \
	z_table2.obw \
	z_tbar.obw \
	z_text.obw \
	z_time.obw \
	z_time1.obw \
	z_timer.obw \
	z_title.obw \
	z_utils.obw \
	z_utime.obw \
	z_utime1.obw \
	z_vlist.obw \
	z_win.obw \
	z_win1.obw \
	z_win2.obw \
	z_win3.obw \
	z_win4.obw \
	g_dsp.obw \
	g_event.obw \
	g_evt.obw \
	g_gen.obw \
	g_i18n.obw \
	g_jump.obw \
	g_lang.obw \
	g_lang1.obw \
	g_loc.obw \
	g_loc1.obw \
	g_mach.obw \
	g_pnorm.obw \
	g_win.obw \
	i_file.obw \
	i_map.obw \
	i_str1.obw \
	i_str2.obw \
	i_str3.obw \
	i_str4.obw \
	i_str5.obw \
	i_type.obw
	-@del win_zil.lib
	$(WIN_LIBRARIAN) $(WIN_LIB_OPTS) @win_zil.rsp
	-@md ..\lib\$(VERSION)
	copy win_zil.lib ..\lib\$(VERSION)


# ----- Windows NT (and WIN32s) Libraries and Programs ----------------------
winnt: copy ntest.exe

ntest.exe: test.obn wnt_zil.lib
	$(WNT_LINK) $(WNT_LINK_OPTS) $(WNT_OBJS)+test.obn, $*, , $(WNT_LIBS), 
#	$(WIN_RC) ntest.rc $*.exe

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
	$(WNT_LIBRARIAN) $(WNT_LIB_OPTS) @wnt_zil.rsp
	-@md ..\lib\$(VERSION)
	copy wnt_zil.lib ..\lib\$(VERSION)
	
# ----- Windows 32 Libraries and Programs ----------------------
win32: copy 9test.exe

9test.exe: test.ob9 w32_zil.lib
	$(W32_LINK) $(W32_LINK_OPTS) $(W32_OBJS)+test.ob9, $*, , $(W32_LIBS), 
#	$(WIN_RC) ntest.rc $*.exe

w32_zil.lib : \
	9_bnum.ob9 \
	9_border.ob9 \
	9_button.ob9 \
	9_combo.ob9 \
	9_comctl.ob9\
	9_cursor.ob9 \
	9_date.ob9 \
	9_dsp.ob9 \
	9_error.ob9 \
	9_error1.ob9 \
	9_event.ob9 \
	9_fmtstr.ob9 \
	9_group.ob9 \
	9_hlist.ob9 \
	9_icon.ob9 \
	9_image.ob9 \
	9_int.ob9 \
	9_intl.ob9 \
	9_keybrd.ob9 \
	9_max.ob9 \
	9_min.ob9 \
	9_mouse.ob9 \
	9_notebk.ob9 \
	9_plldn.ob9 \
	9_plldn1.ob9 \
	9_popup.ob9 \
	9_popup1.ob9 \
	9_print.ob9 \
	9_prompt.ob9 \
	9_real.ob9 \
	9_sbar.ob9 \
	9_scroll.ob9 \
	9_spin.ob9 \
	9_string.ob9 \
	9_sys.ob9 \
	9_table.ob9 \
	9_table1.ob9 \
	9_table2.ob9 \
	9_tbar.ob9 \
	9_text.ob9 \
	9_time.ob9 \
	9_title.ob9 \
	9_vlist.ob9 \
	9_win.ob9 \
	9_win1.ob9 \
	9_win2.ob9 \
	z_app.ob9 \
	z_bnum.ob9 \
	z_bnum1.ob9 \
	z_bnum2.ob9 \
	z_border.ob9 \
	z_button.ob9 \
	z_combo.ob9 \
	z_cursor.ob9 \
	z_date.ob9 \
	z_date1.ob9 \
	z_decor.ob9 \
	z_device.ob9 \
	z_dialog.ob9 \
	z_dsp.ob9 \
	z_error.ob9 \
	z_error1.ob9 \
	z_event.ob9 \
	z_file.ob9 \
	z_fmtstr.ob9 \
	z_gmgr.ob9 \
	z_gmgr1.ob9 \
	z_gmgr2.ob9 \
	z_gmgr3.ob9 \
	z_group.ob9 \
	z_help.ob9 \
	z_help1.ob9 \
	z_hlist.ob9 \
	z_icon.ob9 \
	z_image.ob9 \
	z_i18n.ob9 \
	z_int.ob9 \
	z_intl.ob9 \
	z_lang.ob9 \
	z_list.ob9 \
	z_list1.ob9 \
	z_locale.ob9 \
	z_map1.ob9 \
	z_map2.ob9 \
	z_max.ob9 \
	z_min.ob9 \
	z_msgwin.ob9 \
	z_notebk.ob9 \
	z_path.ob9 \
	z_plldn.ob9 \
	z_plldn1.ob9 \
	z_popup.ob9 \
	z_popup1.ob9 \
	z_printf.ob9 \
	z_prompt.ob9 \
	z_real.ob9 \
	z_region.ob9 \
	z_sbar.ob9 \
	z_scanf.ob9 \
	z_scroll.ob9 \
	z_spin.ob9 \
	z_stdarg.ob9 \
	z_stored.ob9 \
	z_storer.ob9 \
	z_storew.ob9 \
	z_string.ob9 \
	z_sys.ob9 \
	z_table.ob9 \
	z_table1.ob9 \
	z_table2.ob9 \
	z_tbar.ob9 \
	z_text.ob9 \
	z_time.ob9 \
	z_time1.ob9 \
	z_timer.ob9 \
	z_title.ob9 \
	z_utils.ob9 \
	z_utime.ob9 \
	z_utime1.ob9 \
	z_vlist.ob9 \
	z_win.ob9 \
	z_win1.ob9 \
	z_win2.ob9 \
	z_win3.ob9 \
	z_win4.ob9 \
	g_dsp.ob9 \
	g_event.ob9 \
	g_evt.ob9 \
	g_gen.ob9 \
	g_i18n.ob9 \
	g_jump.ob9 \
	g_lang.ob9 \
	g_lang1.ob9 \
	g_loc.ob9 \
	g_loc1.ob9 \
	g_mach.ob9 \
	g_pnorm.ob9 \
	g_win.ob9 \
	i_file.ob9 \
	i_map.ob9 \
	i_str1.ob9 \
	i_str2.ob9 \
	i_str3.ob9 \
	i_str4.ob9 \
	i_str5.ob9 \
	i_type.ob9
	-@del w32_zil.lib
	$(W32_LIBRARIAN) $(W32_LIB_OPTS) @w32_zil.rsp
	-@md ..\lib\$(VERSION)
	copy w32_zil.lib ..\lib\$(VERSION)




# --- Done with libraries ----------------------------------------------------

z_appgfx.obj: z_app.cpp
	$(DOS_CPP) -DGFX $(DOS_CPP_OPTS) -o$@ $?

d_gfxprn.obj: d_print.cpp
	$(DOS_CPP) -DGFX $(DOS_CPP_OPTS) -o$@ $?

z_appgfx.ovl: z_app.cpp
	$(OVL_CPP) -DGFX $(OVL_CPP_OPTS) -o$@ $?

d_gfxprn.ovl: d_print.cpp
	$(OVL_CPP) -DGFX $(OVL_CPP_OPTS) -o$@ $?

z_appgfx.o16: z_app.cpp
	$(D16_CPP) -DGFX $(D16_CPP_OPTS) -o$@ $?

d_gfxprn.o16: d_print.cpp
	$(D16_CPP) -DGFX $(D16_CPP_OPTS) -o$@ $?

z_appgfx.o32: z_app.cpp
	$(D32_CPP) -DGFX $(D32_CPP_OPTS) -o$@ $?

d_gfxprn.o32: d_print.cpp
	$(D32_CPP) -DGFX $(D32_CPP_OPTS) -o$@ $?

z_apptxt.obj: z_app.cpp
	$(DOS_CPP) -DTEXT $(DOS_CPP_OPTS) -o$@ $?

OEMfont:
	copy gfx\OEM_*.cpp

ISOfont:
	copy gfx\ISO_*.cpp
