#;;;;;;;;;;
#
# Compiles Zinc for 32 bit DOS (X-32VM)
#
#    wmake -f wccpp10a.mak x32fg
#
# Be sure to set the WATCOM, LIB, INCLUDE environment variables for Zinc
#       The FlashGraphics directory MUST be included AFTER the Watcom include
#       directory.  The X-32vm include directory should be included before
#   any others.
#

# ----- General Definitions -------------------------------------------------
VERSION=wccpp

# FONT can be OEM or ISO (ISO uses ISO-8859 character set, OEM uses PC set)
FONT=ISO

.EXTENSIONS:
.EXTENSIONS: .oxv .obw .obn .obo .obm .cpp .c 

# ----- DOS 32 bit (X-32VM extender) compiler options -----------------------
X32_CPP=wpp386
X32_LINK=wlink
X32_LIBRARIAN=wlib

X32_LINK_OPTS=SYSTEM x32rv OPTION MAP DISA 1124 
X32_LIB_OPTS=-p=32
X32_FG_CPP_OPTS=/3r /I. /dDOS386 /dFG 
x32_fg_libs=x32_fzil,x32vB,fgw,x32_fg
x32_fg_objs=

.cpp.oxv:
	$(X32_CPP) $(X32_FG_CPP_OPTS) -fo=$[*.oxv $<

.c.oxv:
	$(X32_CPP) $(X32_FG_CPP_OPTS) -fo=$[*.oxv $<

# ----- Usage --------------------------------------------------------------
usage: .SYMBOLIC
	@echo ...........
	@echo ...........
	@echo To generate the library modules for specific environments type:
	@echo wmake -f wccpp10a.mak x32fg
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean: .SYMBOLIC
	z_clean.bat

# ----- Copy files ----------------------------------------------------------
copy: .SYMBOLIC
	copy ui_*.hpp ..\include
	copy z_clean.* ..\bin

# ----- DOS 32 bit (X-32VM extender) Libraries and Programs -----------------
x32fg: copy x32_fzil.lib x32_fg.lib testxfg.exe .SYMBOLIC

testxfg.exe: testxfg.oxv x32_fzil.lib x32_fg.lib
	$(X32_LINK) $(x32_LINK_OPTS) n $* F testxfg.oxv L $(x32_fg_libs)
	x32fix $*

x32_fzil.lib : d_bnum.oxv d_border.oxv d_button.oxv &
	d_combo.oxv d_cursor.oxv d_date.oxv d_error.oxv &
	d_error1.oxv d_event.oxv d_group.oxv d_hlist.oxv &
	d_icon.oxv d_int.oxv d_keybrd.oxv &
	d_max.oxv d_min.oxv d_sbar.oxv d_spin.oxv &
	d_table.oxv d_table1.oxv d_table2.oxv d_notebk.oxv &
	d_real.oxv d_plldn.oxv d_plldn1.oxv d_popup.oxv &
	d_popup1.oxv d_prompt.oxv d_scroll.oxv d_string.oxv &
	d_sys.oxv d_tbar.oxv d_text.oxv &
	d_title.oxv d_vlist.oxv d_win.oxv d_win1.oxv d_win2.oxv &
	d_tdsp.oxv d_fmtstr.oxv d_time.oxv z_bnum.oxv &
	z_bnum1.oxv z_bnum2.oxv z_border.oxv z_button.oxv &
	z_combo.oxv z_cursor.oxv z_date.oxv z_date1.oxv &
	z_device.oxv z_decor.oxv z_gmgr.oxv z_gmgr1.oxv &
	z_gmgr2.oxv z_i18n.oxv z_gmgr3.oxv z_dialog.oxv &
	z_dsp.oxv z_error.oxv z_error1.oxv z_event.oxv &
	z_fmtstr.oxv z_group.oxv z_help.oxv z_hlist.oxv &
	z_icon.oxv z_int.oxv z_lang.oxv z_locale.oxv &
	z_msgwin.oxv z_notebk.oxv z_sbar.oxv &
	z_intl.oxv z_list.oxv z_list1.oxv z_map1.oxv z_map2.oxv &
	z_max.oxv z_min.oxv z_path.oxv z_plldn.oxv z_plldn1.oxv &
	z_popup.oxv z_popup1.oxv z_printf.oxv z_prompt.oxv &
	z_real.oxv z_region.oxv z_scanf.oxv z_scroll.oxv &
	z_stored.oxv z_string.oxv z_spin.oxv z_stdarg.oxv &
	z_storer.oxv z_storew.oxv z_table.oxv z_table1.oxv &
	z_table2.oxv z_timer.oxv z_utime.oxv &
	z_utime1.oxv z_win4.oxv z_dialog.oxv &
	z_sys.oxv z_tbar.oxv z_text.oxv z_time.oxv z_time1.oxv &
	z_title.oxv z_utils.oxv z_vlist.oxv z_win.oxv z_win1.oxv &
	z_win2.oxv z_win3.oxv g_dsp.oxv g_event.oxv g_evt.oxv &
	g_gen.oxv g_jump.oxv g_lang.oxv g_lang1.oxv g_loc.oxv &
	g_loc1.oxv g_mach.oxv g_pnorm.oxv g_win.oxv g_i18n.oxv&
	i_file.oxv i_map.oxv i_str1.oxv i_str2.oxv i_str3.oxv 
	i_str4.oxv i_str5.oxv i_type.oxv 
	del x32_fzil.lib
	$(x32_LIBRARIAN) $(x32_LIB_OPTS) @x32fgzil.wcc
	-@md ..\lib\$(VERSION)
	copy x32_fzil.lib ..\lib\$(VERSION)

x32_fg.lib : d_fgdspx.oxv z_appfg.oxv fg_cstm.oxv &
	g_fgdspx.oxv i_wccfgx.oxv d_mousex.oxv d_intlx.oxv
	del x32_fg.lib
	$(x32_LIBRARIAN) $(x32_LIB_OPTS) @x32_fg.wcc
	-@md ..\lib\$(VERSION)
	copy x32_fg.lib ..\lib\$(VERSION)

