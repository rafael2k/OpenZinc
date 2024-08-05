# ----- General Definitions -------------------------------------------------
VERSION=btcpp310

DOSHARDWAREDEP=i_btcat.obj
DOSHARDWARELIB=+i_btcat.obj

# ----- DOS compiler options ------------------------------------------------
DOS_CPP=bcc
DOS_LINK=tlink
DOS_LIBRARIAN=tlib
DOS_CPP_OPTS=-c -ml -O1 -Vs -w -H=ZIL.SYM -waus
DOS_LINK_OPTS=/c /x
DOS_LIB_OPTS=/C
DOS_OBJS=c0l

# --- Use the next line for UI_GRAPHICS_DISPLAY ---
DOS_LIBS=dos_zil dos_zil2 dos_gfx bc_lgfx emu mathl cl
# --- Use the next line for UI_BGI_DISPLAY ---
#DOS_LIBS=dos_zil dos_zil2 dos_bgi graphics emu mathl cl

.cpp.obj:
	$(DOS_CPP) $(DOS_CPP_OPTS) {$< }

# ----- DOS VROOM overlay compiler options ---------------------------------
DOS_OVL_CPP=bcc
DOS_OVL_LINK=tlink
DOS_OVL_LIBRARIAN=tlib
DOS_OVL_CPP_OPTS=-c -ml -O1 -w -H=ZIL.SYM -waus
DOS_OVL_LINK_OPTS=/c /x
DOS_OVL_LIB_OPTS=/C
DOS_OVL_OBJS=c0l

# --- Use the next line for UI_GRAPHICS_DISPLAY ---
DOS_OVL_LIBS=/o+ dos_zilo /o- dos_zil dos_zil2 dos_gfx bc_lgfx overlay emu mathl cl
# --- Use the next line for UI_BGI_DISPLAY ---
#DOS_OVL_LIBS=/o+ dos_zilo /o- dos_zil dos_zil2 dos_bgi overlay graphics emu mathl cl

.cpp.ovl:
	$(DOS_OVL_CPP) $(DOS_OVL_CPP_OPTS) -o$*.ovl {$< }

# ----- 16 bit Windows compiler options -------------------------------------
WIN_CPP=bcc
WIN_LINK=tlink
WIN_LIBRARIAN=tlib
WIN_RC=rc

WIN_CPP_OPTS=-c -ml -O1 -Vf -WE -w -waus
#WIN_CPP_OPTS=-c -dc -ml -O1 -x- -RT- -Vf -WSE -w -H=ZIL.SYM -waus
WIN_RC_OPTS=-k
WIN_LINK_OPTS=/c /C /Twe /x
WIN_LIB_OPTS=/C

WIN_OBJS=c0wl
WIN_LIBS=win_zil win_zil2 import mathwl cwl

.cpp.obw:
	$(WIN_CPP) $(WIN_CPP_OPTS) -o$*.obw {$< }

# ----- Usage ------------------------------------------------------------
usage:
	@echo ...........
	@echo ...........
	@echo To generate the library modules for specific environments type:
	@echo make -fbtcpp310.mak dos
	@echo make -fbtcpp310.mak dosovl
	@echo make -fbtcpp310.mak windows
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean

# ----- Copy files ----------------------------------------------------------
copy:
	copy ui_*.hpp ..\include
	copy z_clean.* ..\bin

commCopy: 
	copy z_comctl.h ..\include
gfx_copy:
	copy gfx\source\gfx.h ..\include
	copy gfx\source\gfx_pro.h ..\include

bgi_copy:
	copy bgi\*.fnt ..\bin

# ----- DOS -----------------------------------------------------------------

dos: copy gfx_copy dos_bgi.lib dos_gfx.lib bc_lgfx.lib test.exe

test.exe: test.obj dos_zil.lib dos_zil2.lib
	$(DOS_LINK) $(DOS_LINK_OPTS) @&&!
$(DOS_OBJS)+test.obj
$*, , $(DOS_LIBS)
!
	-@del zil.sym
			
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
	d_win2.obj
	-@del dos_zil.lib
	$(DOS_LIBRARIAN) $(DOS_LIB_OPTS) @&&!
$* &
	+d_bnum.obj &
	+d_border.obj &
	+d_button.obj &
	+d_combo.obj &
	+d_cursor.obj &
	+d_date.obj &
	+d_error.obj &
	+d_error1.obj &
	+d_event.obj &
	+d_fmtstr.obj &
	+d_group.obj &
	+d_hlist.obj &
	+d_icon.obj &
	+d_image.obj &
	+d_int.obj &
	+d_intl.obj &
	+d_keybrd.obj &
	+d_max.obj &
	+d_min.obj &
	+d_mouse.obj &
	+d_notebk.obj &
	+d_plldn.obj &
	+d_plldn1.obj &
	+d_popup.obj &
	+d_popup1.obj &
	+d_prompt.obj &
	+d_real.obj &
	+d_sbar.obj &
	+d_scroll.obj &
	+d_spin.obj &
	+d_string.obj &
	+d_sys.obj &
	+d_table.obj &
	+d_table1.obj &
	+d_table2.obj &
	+d_tbar.obj &
	+d_tdsp.obj &
	+d_text.obj &
	+d_time.obj &
	+d_title.obj &
	+d_vlist.obj &
	+d_win.obj &
	+d_win1.obj &
	+d_win2.obj
!
	@del zil.sym
	-@md ..\lib\$(VERSION)
	copy dos_zil.lib ..\lib\$(VERSION)
 

dos_zil2.lib : \
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
	$(DOSHARDWAREDEP)
	-@del dos_zil2.lib
	$(DOS_LIBRARIAN) $(DOS_LIB_OPTS) @&&!
$* &
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
	+z_notebk.obj &
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
	+i_type.obj &
	$(DOSHARDWARELIB)
!
	@del zil.sym
	-@md ..\lib\$(VERSION)
	copy dos_zil2.lib ..\lib\$(VERSION)

dos_bgi.lib : d_bgidsp.obj d_bgiprn.obj z_appbgi.obj
	-@del dos_bgi.lib
#	@cd bgi
#    @bgiobj /f OEM_syst.chr OEM_syst.obj _OEMSystemFont
#    @bgiobj /f OEM_dial.chr OEM_dial.obj _OEMDialogFont
#    @bgiobj /f OEM_smal.chr OEM_smal.obj _OEMSmallFont
#    @bgiobj /f ISO_syst.chr ISO_syst.obj _ISOSystemFont
#    @bgiobj /f ISO_dial.chr ISO_dial.obj _ISODialogFont
#    @bgiobj /f ISO_smal.chr ISO_smal.obj _ISOSmallFont
#	@cd ..
	$(DOS_LIBRARIAN) $(DOS_LIB_OPTS) @&&!
$* &
+d_bgidsp.obj+d_bgiprn.obj+z_appbgi.obj &
+bgi\OEM_smal.obj+bgi\OEM_dial.obj+bgi\OEM_syst.obj &
+bgi\ISO_smal.obj+bgi\ISO_dial.obj+bgi\ISO_syst.obj
!
	@del zil.sym
	-@md ..\lib\$(VERSION)
	copy dos_bgi.lib ..\lib\$(VERSION)

dos_gfx.lib : d_gfxdsp.obj d_gfxprn.obj i_gfx.obj z_appgfx.obj \
	OEM_smal.obj OEM_dial.obj OEM_syst.obj \
	ISO_smal.obj ISO_dial.obj ISO_syst.obj
	-@del dos_gfx.lib
	$(DOS_LIBRARIAN) $(DOS_LIB_OPTS) @&&!
$* &
+d_gfxdsp.obj+d_gfxprn.obj+i_gfx.obj+z_appgfx.obj &
+OEM_smal.obj+OEM_dial.obj+OEM_syst.obj &
+ISO_smal.obj+ISO_dial.obj+ISO_syst.obj
!
	@del zil.sym
	-@md ..\lib\$(VERSION)
	copy dos_gfx.lib ..\lib\$(VERSION)

bc_lgfx.lib :
	@cd gfx\source
	make -fbtcpp310.mak dos
	@cd ..\..

# ----- DOS VROOMM Overlay -------------------------------------------------
#Note: Zinc DOS libs need to be built before testovl.exe can be made.
dosovl: copy dos_zilo.lib testovl.exe

testovl.exe: test.ovl
	$(DOS_OVL_LINK) $(DOS_OVL_LINK_OPTS) @&&!
$(DOS_OVL_OBJS)+test.ovl
$*, , $(DOS_OVL_LIBS)
!
	-@del zil.sym

dos_zilo.lib : \
	d_bnum.ovl \
	d_border.ovl \
	d_combo.ovl \
	d_date.ovl \
	d_error.ovl \
	d_error1.ovl \
	d_fmtstr.ovl \
	d_group.ovl \
	d_hlist.ovl \
	d_image.ovl \
	d_max.ovl \
	d_min.ovl \
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
	d_table.ovl \
	d_table1.ovl \
	d_table2.ovl \
	d_tbar.ovl \
	d_text.ovl \
	d_time.ovl \
	d_vlist.ovl \
	z_bnum1.ovl \
	z_border.ovl \
	z_button.ovl \
	z_error.ovl \
	z_fmtstr.ovl \
	z_gmgr1.ovl \
	z_gmgr2.ovl \
	z_gmgr3.ovl \
	z_icon.ovl \
	z_image.ovl \
	z_max.ovl \
	z_min.ovl \
	z_plldn1.ovl \
	z_popup1.ovl \
	z_prompt.ovl \
	z_real.ovl \
	z_stored.ovl \
	z_storew.ovl \
	z_string.ovl \
	z_title.ovl \
	z_utils.ovl \
	z_win2.ovl
	-@del dos_zilo.lib
	$(DOS_OVL_LIBRARIAN) $(DOS_OVL_LIB_OPTS) @&&!
$* &
	+d_bnum.ovl &
	+d_border.ovl &
	+d_combo.ovl &
	+d_date.ovl &
	+d_error.ovl &
	+d_error1.ovl &
	+d_fmtstr.ovl &
	+d_group.ovl &
	+d_hlist.ovl &
	+d_image.ovl &
	+d_max.ovl &
	+d_min.ovl &
	+d_notebk.ovl &
	+d_plldn.ovl &
	+d_plldn1.ovl &
	+d_popup.ovl &
	+d_popup1.ovl &
	+d_prompt.ovl &
	+d_real.ovl &
	+d_sbar.ovl &
	+d_scroll.ovl &
	+d_spin.ovl &
	+d_table.ovl &
	+d_table1.ovl &
	+d_table2.ovl &
	+d_tbar.ovl &
	+d_text.ovl &
	+d_time.ovl &
	+d_vlist.ovl &
	+z_bnum1.ovl &
	+z_border.ovl &
	+z_button.ovl &
	+z_error.ovl &
	+z_fmtstr.ovl &
	+z_gmgr1.ovl &
	+z_gmgr2.ovl &
	+z_gmgr3.ovl &
	+z_icon.ovl &
	+z_image.ovl &
	+z_max.ovl &
	+z_min.ovl &
	+z_plldn1.ovl &
	+z_popup1.ovl &
	+z_prompt.ovl &
	+z_real.ovl &
	+z_stored.ovl &
	+z_storew.ovl &
	+z_string.ovl &
	+z_title.ovl &
	+z_utils.ovl &
	+z_win2.ovl
!
	@del zil.sym
	-@md ..\lib\$(VERSION)
	copy dos_zilo.lib ..\lib\$(VERSION)


# ----- 16 bit Windows -------------------------------------------------------------

windows: copy wtest.exe

wtest.exe: test.obw win_zil.lib win_zil2.lib
	$(WIN_LINK) $(WIN_LINK_OPTS) @&&!
$(WIN_OBJS)+test.obw
$*, , $(WIN_LIBS), wtest.def
!
#	$(WIN_RC) $(WIN_RC_OPTS) wtest.rc $<
	-@del zil.sym

win_zil.lib : \
	w_bnum.obw \
	w_border.obw \
	w_button.obw \
	w_combo.obw \
	w_cursor.obw \
	w_dsp.obw \
	w_date.obw \
	w_error.obw \
	w_error1.obw \
	w_event.obw \
	w_fmtstr.obw \
	w_group.obw \
	w_hlist.obw \
	w_int.obw \
	w_icon.obw \
	w_image.obw \
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
	w_win2.obw
	-@del win_zil.lib
	$(WIN_LIBRARIAN) $(WIN_LIB_OPTS) @&&!
$* &
	+w_dsp.obw &
	+w_keybrd.obw &
	+w_mouse.obw &
	+w_notebk.obw &
	+w_cursor.obw &
	+w_event.obw &
	+w_bnum.obw &
	+w_border.obw &
	+w_button.obw &
	+w_combo.obw &
	+w_fmtstr.obw &
	+w_group.obw &
	+w_hlist.obw &
	+w_int.obw &
	+w_icon.obw &
	+w_image.obw &
	+w_min.obw &
	+w_max.obw &
	+w_scroll.obw &
	+w_spin.obw &
	+w_string.obw &
	+w_sys.obw &
	+w_text.obw &
	+w_time.obw &
	+w_title.obw &
	+w_popup.obw &
	+w_popup1.obw &
	+w_plldn.obw &
	+w_plldn1.obw &
	+w_print.obw &
	+w_prompt.obw &
	+w_real.obw &
	+w_sbar.obw &
	+w_table.obw &
	+w_table1.obw &
	+w_table2.obw &
	+w_tbar.obw &
	+w_vlist.obw &
	+w_win.obw &
	+w_win1.obw &
	+w_win2.obw &
	+w_date.obw &
	+w_error.obw &
	+w_error1.obw &
	+w_intl.obw 
!
	-@del zil.sym
	-@md ..\lib\$(VERSION)
	copy win_zil.lib ..\lib\$(VERSION)

win_zil2.lib : \
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
	$(WIN_LIBRARIAN) $(WIN_LIB_OPTS) @&&!
$* &
	+z_app.obw &
	+z_bnum.obw &
	+z_bnum1.obw &
	+z_bnum2.obw &
	+z_border.obw &
	+z_button.obw &
	+z_combo.obw &
	+z_cursor.obw &
	+z_date.obw &
	+z_date1.obw &
	+z_decor.obw &
	+z_device.obw &
	+z_dialog.obw &
	+z_dsp.obw &
	+z_error.obw &
	+z_error1.obw &
	+z_event.obw &
	+z_file.obw &
	+z_fmtstr.obw &
	+z_gmgr.obw &
	+z_gmgr1.obw &
	+z_gmgr2.obw &
	+z_gmgr3.obw &
	+z_group.obw &
	+z_help.obw &
	+z_help1.obw &
	+z_hlist.obw &
	+z_icon.obw &
	+z_image.obw &
	+z_i18n.obw &
	+z_int.obw &
	+z_intl.obw &
	+z_lang.obw &
	+z_list.obw &
	+z_list1.obw &
	+z_locale.obw &
	+z_map1.obw &
	+z_map2.obw &
	+z_max.obw &
	+z_min.obw &
	+z_msgwin.obw &
	+z_notebk.obw &
	+z_path.obw &
	+z_plldn.obw &
	+z_plldn1.obw &
	+z_popup.obw &
	+z_popup1.obw &
	+z_printf.obw &
	+z_prompt.obw &
	+z_real.obw &
	+z_region.obw &
	+z_sbar.obw &
	+z_scanf.obw &
	+z_scroll.obw &
	+z_spin.obw &
	+z_stdarg.obw &
	+z_stored.obw &
	+z_storer.obw &
	+z_storew.obw &
	+z_string.obw &
	+z_sys.obw &
	+z_table.obw &
	+z_table1.obw &
	+z_table2.obw &
	+z_tbar.obw &
	+z_text.obw &
	+z_time.obw &
	+z_time1.obw &
	+z_timer.obw &
	+z_title.obw &
	+z_utils.obw &
	+z_utime.obw &
	+z_utime1.obw &
	+z_vlist.obw &
	+z_win.obw &
	+z_win1.obw &
	+z_win2.obw &
	+z_win3.obw &
	+z_win4.obw &
	+g_dsp.obw &
	+g_event.obw &
	+g_evt.obw &
	+g_gen.obw &
	+g_i18n.obw &
	+g_jump.obw &
	+g_lang.obw &
	+g_lang1.obw &
	+g_loc.obw &
	+g_loc1.obw &
	+g_mach.obw &
	+g_pnorm.obw &
	+g_win.obw &
	+i_file.obw &
	+i_map.obw &
	+i_str1.obw &
	+i_str2.obw &
	+i_str3.obw &
	+i_str4.obw &
	+i_str5.obw &
	+i_type.obw
!
	-@del zil.sym
	-@md ..\lib\$(VERSION)
	copy win_zil2.lib ..\lib\$(VERSION)

# --- Done with libraries ----------------------------------------------------

z_appbgi.obj: z_app.cpp
	$(DOS_CPP) -DBGI $(DOS_CPP_OPTS) -o$@ $?

z_appgfx.obj: z_app.cpp
	$(DOS_CPP) -DGFX $(DOS_CPP_OPTS) -o$@ $?

z_apptxt.obj: z_app.cpp
	$(DOS_CPP) -DTEXT $(DOS_CPP_OPTS) -o$@ $?

d_bgiprn.obj: d_print.cpp
	$(DOS_CPP) -DBGI $(DOS_CPP_OPTS) -o$@ $?

d_gfxprn.obj: d_print.cpp
	$(DOS_CPP) -DGFX $(DOS_CPP_OPTS) -o$@ $?

# ----------------------------------------------------------------------------

OEM_dial.cpp: gfx\OEM_dial.cpp
	copy gfx\OEM_dial.cpp

OEM_smal.cpp: gfx\OEM_smal.cpp
	copy gfx\OEM_smal.cpp

OEM_syst.cpp: gfx\OEM_syst.cpp
	copy gfx\OEM_syst.cpp

ISO_dial.cpp: gfx\ISO_dial.cpp
	copy gfx\ISO_dial.cpp

ISO_smal.cpp: gfx\ISO_smal.cpp
	copy gfx\ISO_smal.cpp

ISO_syst.cpp: gfx\ISO_syst.cpp
	copy gfx\ISO_syst.cpp
