# ----- General Definitions -------------------------------------------------
VERSION=mvcpp150

DOSHARDWAREDEP=i_mscat.obj
DOSHARDWARELIB=+i_mscat.obj
D16HARDWAREDEP=i_mscat.o16
D16HARDWARELIB=+i_mscat.o16

.SUFFIXES : .c .cpp .obj .o16 .obw

# ----- DOS compiler options ------------------------------------------------
# for debug:    add -Zi to CPP_OPTS
#               and /CO to LINK_OPTS
DOS_CPP=cl
DOS_LINK=link
DOS_LIBRARIAN=lib

DOS_CPP_OPTS=-c -AL -BATCH -Gs -Os -nologo
DOS_LINK_OPTS=/NOI /NOE /NOD /BATCH /SEGMENTS:256 /STACK:5120 /EXE
DOS_LIB_OPTS=/NOI
DOS_OBJS=

# --- Use the next line for UI_GRAPHICS_DISPLAY ---
DOS_LIBS=dos_zil dos_gfx ms_lgfx llibce graphics oldnames
# --- Use the next line for UI_MSC_DISPLAY ---
#DOS_LIBS=dos_zil dos_msc llibce graphics oldnames

.cpp.obj:
	$(DOS_CPP) $(DOS_CPP_OPTS) $<

!IF !DEFINED(PHARLAP16) && !DEFINED(RATIONAL16)
# Note:  Set the following variable to PHARLAP16 for Pharlap or RATIONAL16
# for DOS16M. Default is PHARLAP16.
PHARLAP16=1
# Use one of the following command lines to override this setting.
#  nmake "PHARLAP16=" -fmvcpp150.mak dos16
#  nmake "RATIONAL16=" -fmvcpp150.mak dos16
!ENDIF

# for debug:    add -Zi to CPP_OPTS
#               and /CO to LINK_OPTS
D16_CPP=cl
D16_LINK=link
D16_LIBRARIAN=lib

# ----Pharlap----
!IF DEFINED(PHARLAP16)
D16_CPP_OPTS=-c -AL -BATCH -Gs2 -DDOSX286 -D$(FONT) -nologo
D16_LINK_OPTS=/NOI /NOE /NOD /B /SE:256 /ST:12288 /ON:N
D16_OBJS=graphp.obj
D16_DEF_FILE=m16.def
D16_BIND=bind286
PHARLAP_RTL=c:\phar286\rtk
D16_LOAD=run286a
# --- Use the next line for UI_GRAPHICS_DISPLAY ---
D16_LIBS=phapi d16_zil d16_gfx ms_16gfx llibcep graphics oldnames
# --- Use the next line for UI_MSC_DISPLAY ---
#D16_LIBS=phapi llibcep graphics d16_msc d16_zil oldnames
!ENDIF

!IF DEFINED(RATIONAL16)
# ---- DOS16M----
D16_CPP_OPTS=-c -AL -BATCH -Gs2 -DDOS16M -nologo
D16_LINK_OPTS=/NOI /NOE /BATCH /SE:256 /ON:N
D16_OBJS=crt0_16m.obj+crt0datn.obj+emoem.obj+qccore.obj+llvesa
D16_DEF_FILE=dos16m.def
# --- Use the next line for UI_GRAPHICS_DISPLAY ---
D16_LIBS=msc80lse msc80l msc80lg dos16 d16libc d16_zil d16_gfx ms_16gfx 
# --- Use the next line for UI_MSC_DISPLAY ---
#D16_LIBS=msc80lse msc80l msc80lg dos16 d16_zil d16_msc graphics
D16_PATH=\dos16m\bin
!ENDIF

.cpp.o16:
	$(D16_CPP) $(D16_CPP_OPTS) -Fo$*.o16 $<

# ----- Windows compiler options --------------------------------------------
# for debug:    add -Zi to CPP_OPTS
#               and /CO to LINK_OPTS
WIN_CPP=cl
WIN_LINK=link
WIN_LIBRARIAN=lib
WIN_RC=rc

WIN_CPP_OPTS=-c -AL -BATCH -Gsw -Os -nologo
WIN_RC_OPTS=-k
WIN_LINK_OPTS=/NOE /NOD /BATCH /SEGMENTS:256 /ON:N
WIN_LIB_OPTS=/NOI
WIN_OBJS=
WIN_LIBS=win_zil libw llibcew oldnames 

.cpp.obw:
	$(WIN_CPP) $(WIN_CPP_OPTS) -Fo$*.obw $<

# ----- Usage --------------------------------------------------------------
usage:
	@echo ...........
	@echo ...........
	@echo To generate the library modules for specific environments type:
	@echo nmake -fmvcpp150.mak dos
	@echo nmake -fmvcpp150.mak dos16
	@echo nmake -fmvcpp150.mak windows
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
dos: copy gfx_copy dos_msc.lib dos_gfx.lib ms_lgfx.lib test.exe

test.exe: test.obj dos_zil.lib
	$(DOS_LINK) $(DOS_LINK_OPTS) @<<zil.rsp
$(DOS_OBJS)+test.obj
$*,NUL,$(DOS_LIBS),NUL
<<

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
	$(DOSHARDWAREDEP)
	-@del dos_zil.lib
	$(DOS_LIBRARIAN) $(DOS_LIB_OPTS) @<<zil.rsp
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
	+d_win2.obj &
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
NUL
<<
	-@md ..\lib\$(VERSION)
	copy dos_zil.lib ..\lib\$(VERSION)

dos_msc.lib : d_mscdsp.obj d_mscprn.obj z_appmsc.obj
	-@del dos_msc.lib
	$(DOS_LIBRARIAN) $(DOS_LIB_OPTS) @<<zil.rsp
$* &
+d_mscdsp.obj+d_mscprn.obj+z_appmsc.obj
NUL
<<
	-@md ..\lib\$(VERSION)
	copy dos_msc.lib ..\lib\$(VERSION)

dos_gfx.lib : d_gfxdsp.obj d_gfxprn.obj z_appgfx.obj \
	OEM_smal.obj OEM_dial.obj OEM_syst.obj \
	ISO_smal.obj ISO_dial.obj ISO_syst.obj
	-@del dos_gfx.lib
	$(DOS_LIBRARIAN) $(DOS_LIB_OPTS) @<<zil.rsp
$* &
+d_gfxdsp.obj+d_gfxprn.obj+z_appgfx.obj &
+OEM_smal.obj+OEM_dial.obj+OEM_syst.obj &
+ISO_smal.obj+ISO_dial.obj+ISO_syst.obj
NUL
<<
	-@md ..\lib\$(VERSION)
	copy dos_gfx.lib ..\lib\$(VERSION)

ms_lgfx.lib:
	@cd gfx\source
	nmake -fmvcpp150.mak dos
	@cd ..\..

# ----- 16 bit DOS Extender Libraries and Programs --------------------------
dos16: copy gfx_copy d16_gfx.lib d16_msc.lib test16.exe

test16.exe: test.o16 ms_16gfx.lib d16_zil.lib
	$(D16_LINK) $(D16_LINK_OPTS) @<<zil.rsp
$(D16_OBJS)+test.o16
$*,NUL,$(D16_LIBS),$(D16_DEF_FILE)
<<

d16_zil.lib : \
	d_bnum.o16 \
	d_border.o16 \
	d_button.o16 \
	d_combo.o16 \
	d_cursor.o16 \
	d_date.o16 \
	d_error.o16 \
	d_error1.o16 \
	d_event.o16 \
	d_fmtstr.o16 \
	d_group.o16 \
	d_hlist.o16 \
	d_icon.o16 \
	d_image.o16 \
	d_int.o16 \
	d_intl.o16 \
	d_keybrd.o16 \
	d_max.o16 \
	d_min.o16 \
	d_mouse.o16 \
	d_notebk.o16 \
	d_plldn.o16 \
	d_plldn1.o16 \
	d_popup.o16 \
	d_popup1.o16 \
	d_prompt.o16 \
	d_real.o16 \
	d_sbar.o16 \
	d_scroll.o16 \
	d_spin.o16 \
	d_string.o16 \
	d_sys.o16 \
	d_table.o16 \
	d_table1.o16 \
	d_table2.o16 \
	d_tbar.o16 \
	d_tdsp.o16 \
	d_text.o16 \
	d_time.o16 \
	d_title.o16 \
	d_vlist.o16 \
	d_win.o16 \
	d_win1.o16 \
	d_win2.o16 \
	z_bnum.o16 \
	z_bnum1.o16 \
	z_bnum2.o16 \
	z_border.o16 \
	z_button.o16 \
	z_combo.o16 \
	z_cursor.o16 \
	z_date.o16 \
	z_date1.o16 \
	z_decor.o16 \
	z_device.o16 \
	z_dialog.o16 \
	z_dsp.o16 \
	z_error.o16 \
	z_error1.o16 \
	z_event.o16 \
	z_file.o16 \
	z_fmtstr.o16 \
	z_gmgr.o16 \
	z_gmgr1.o16 \
	z_gmgr2.o16 \
	z_gmgr3.o16 \
	z_group.o16 \
	z_help.o16 \
	z_help1.o16 \
	z_hlist.o16 \
	z_icon.o16 \
	z_image.o16 \
	z_i18n.o16 \
	z_int.o16 \
	z_intl.o16 \
	z_lang.o16 \
	z_list.o16 \
	z_list1.o16 \
	z_locale.o16 \
	z_map1.o16 \
	z_map2.o16 \
	z_max.o16 \
	z_min.o16 \
	z_msgwin.o16 \
	z_notebk.o16 \
	z_path.o16 \
	z_plldn.o16 \
	z_plldn1.o16 \
	z_popup.o16 \
	z_popup1.o16 \
	z_printf.o16 \
	z_prompt.o16 \
	z_real.o16 \
	z_region.o16 \
	z_sbar.o16 \
	z_scanf.o16 \
	z_scroll.o16 \
	z_spin.o16 \
	z_stdarg.o16 \
	z_stored.o16 \
	z_storer.o16 \
	z_storew.o16 \
	z_string.o16 \
	z_sys.o16 \
	z_table.o16 \
	z_table1.o16 \
	z_table2.o16 \
	z_tbar.o16 \
	z_text.o16 \
	z_time.o16 \
	z_time1.o16 \
	z_timer.o16 \
	z_title.o16 \
	z_utils.o16 \
	z_utime.o16 \
	z_utime1.o16 \
	z_vlist.o16 \
	z_win.o16 \
	z_win1.o16 \
	z_win2.o16 \
	z_win3.o16 \
	z_win4.o16 \
	g_dsp.o16 \
	g_event.o16 \
	g_evt.o16 \
	g_gen.o16 \
	g_i18n.o16 \
	g_jump.o16 \
	g_lang.o16 \
	g_lang1.o16 \
	g_loc.o16 \
	g_loc1.o16 \
	g_mach.o16 \
	g_pnorm.o16 \
	g_win.o16 \
	i_file.o16 \
	i_map.o16 \
	i_str1.o16 \
	i_str2.o16 \
	i_str3.o16 \
	i_str4.o16 \
	i_str5.o16 \
	i_type.o16 \
	$(D16HARDWAREDEP)
	-@del d16_zil.lib
	$(D16_LIBRARIAN) $(D16_LIB_OPTS) @<<zil.rsp
$* &
	+d_bnum.o16 &
	+d_border.o16 &
	+d_button.o16 &
	+d_combo.o16 &
	+d_cursor.o16 &
	+d_date.o16 &
	+d_error.o16 &
	+d_error1.o16 &
	+d_event.o16 &
	+d_fmtstr.o16 &
	+d_group.o16 &
	+d_hlist.o16 &
	+d_icon.o16 &
	+d_image.o16 &
	+d_int.o16 &
	+d_intl.o16 &
	+d_keybrd.o16 &
	+d_max.o16 &
	+d_min.o16 &
	+d_mouse.o16 &
	+d_notebk.o16 &
	+d_plldn.o16 &
	+d_plldn1.o16 &
	+d_popup.o16 &
	+d_popup1.o16 &
	+d_prompt.o16 &
	+d_real.o16 &
	+d_sbar.o16 &
	+d_scroll.o16 &
	+d_spin.o16 &
	+d_string.o16 &
	+d_sys.o16 &
	+d_table.o16 &
	+d_table1.o16 &
	+d_table2.o16 &
	+d_tbar.o16 &
	+d_tdsp.o16 &
	+d_text.o16 &
	+d_time.o16 &
	+d_title.o16 &
	+d_vlist.o16 &
	+d_win.o16 &
	+d_win1.o16 &
	+d_win2.o16 &
	+z_bnum.o16 &
	+z_bnum1.o16 &
	+z_bnum2.o16 &
	+z_border.o16 &
	+z_button.o16 &
	+z_combo.o16 &
	+z_cursor.o16 &
	+z_date.o16 &
	+z_date1.o16 &
	+z_decor.o16 &
	+z_device.o16 &
	+z_dialog.o16 &
	+z_dsp.o16 &
	+z_error.o16 &
	+z_error1.o16 &
	+z_event.o16 &
	+z_file.o16 &
	+z_fmtstr.o16 &
	+z_gmgr.o16 &
	+z_gmgr1.o16 &
	+z_gmgr2.o16 &
	+z_gmgr3.o16 &
	+z_group.o16 &
	+z_help.o16 &
	+z_help1.o16 &
	+z_hlist.o16 &
	+z_icon.o16 &
	+z_image.o16 &
	+z_i18n.o16 &
	+z_int.o16 &
	+z_intl.o16 &
	+z_lang.o16 &
	+z_list.o16 &
	+z_list1.o16 &
	+z_locale.o16 &
	+z_map1.o16 &
	+z_map2.o16 &
	+z_max.o16 &
	+z_min.o16 &
	+z_msgwin.o16 &
	+z_notebk.o16 &
	+z_path.o16 &
	+z_plldn.o16 &
	+z_plldn1.o16 &
	+z_popup.o16 &
	+z_popup1.o16 &
	+z_printf.o16 &
	+z_prompt.o16 &
	+z_real.o16 &
	+z_region.o16 &
	+z_sbar.o16 &
	+z_scanf.o16 &
	+z_scroll.o16 &
	+z_spin.o16 &
	+z_stdarg.o16 &
	+z_stored.o16 &
	+z_storer.o16 &
	+z_storew.o16 &
	+z_string.o16 &
	+z_sys.o16 &
	+z_table.o16 &
	+z_table1.o16 &
	+z_table2.o16 &
	+z_tbar.o16 &
	+z_text.o16 &
	+z_time.o16 &
	+z_time1.o16 &
	+z_timer.o16 &
	+z_title.o16 &
	+z_utils.o16 &
	+z_utime.o16 &
	+z_utime1.o16 &
	+z_vlist.o16 &
	+z_win.o16 &
	+z_win1.o16 &
	+z_win2.o16 &
	+z_win3.o16 &
	+z_win4.o16 &
	+g_dsp.o16 &
	+g_event.o16 &
	+g_evt.o16 &
	+g_gen.o16 &
	+g_i18n.o16 &
	+g_jump.o16 &
	+g_lang.o16 &
	+g_lang1.o16 &
	+g_loc.o16 &
	+g_loc1.o16 &
	+g_mach.o16 &
	+g_pnorm.o16 &
	+g_win.o16 &
	+i_file.o16 &
	+i_map.o16 &
	+i_str1.o16 &
	+i_str2.o16 &
	+i_str3.o16 &
	+i_str4.o16 &
	+i_str5.o16 &
	+i_type.o16 &
	$(D16HARDWARELIB)
NUL
<<
	-@md ..\lib\$(VERSION)
	copy d16_zil.lib ..\lib\$(VERSION)

d16_msc.lib : d_mscdsp.o16 d_mscprn.o16 z_appmsc.o16
	-@del d16_msc.lib
	$(D16_LIBRARIAN) $(D16_LIB_OPTS) @<<zil.rsp
$* &
+d_mscdsp.o16+d_mscprn.o16+z_appmsc.o16
NUL
<<
	-@md ..\lib\$(VERSION)
	copy d16_msc.lib ..\lib\$(VERSION)

d16_gfx.lib : d_gfxdsp.o16 d_gfxprn.o16 i_gfx.o16 z_appgfx.o16 \
	OEM_smal.o16 OEM_dial.o16 OEM_syst.o16 \
	ISO_smal.o16 ISO_dial.o16 ISO_syst.o16
	-@del d16_gfx.lib
	$(D16_LIBRARIAN) $(D16_LIB_OPTS) @<<zil.rsp
$* &
+d_gfxdsp.o16+d_gfxprn.o16+i_gfx.o16+z_appgfx.o16 &
+OEM_smal.o16+OEM_dial.o16+OEM_syst.o16 &
+ISO_smal.o16+ISO_dial.o16+ISO_syst.o16
NUL
<<
	-@md ..\lib\$(VERSION)
	copy d16_gfx.lib ..\lib\$(VERSION)

ms_16gfx.lib:
	@cd gfx\source
!IF DEFINED(PHARLAP16)
	nmake "PHARLAP16=" -fmvcpp150.mak dos16
!ENDIF
!IF DEFINED(RATIONAL16)
	nmake "RATIONAL16=" -fmvcpp150.mak dos16
!ENDIF
	@cd ..\..

# ----- Windows Libraries and Programs --------------------------------------
windows: copy wtest.exe

wtest.exe: test.obw win_zil.lib
	$(WIN_LINK) $(WIN_LINK_OPTS) @<<zil.rsp
$(WIN_OBJS)+test.obw
$*,NUL,$(WIN_LIBS),wtest.def
<<
	$(WIN_RC) $(WIN_RC_OPTS) wtest.rc $*.exe

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
	w_prompt.obw \
	w_real.obw \
	w_print.obw \
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
	$(WIN_LIBRARIAN) $(WIN_LIB_OPTS) @<<zil.rsp
$* &
	+w_dsp.obw &
	+w_keybrd.obw &
	+w_mouse.obw &
	+w_notebk.obw &
	+w_cursor.obw &
	+w_date.obw &
	+w_event.obw &
	+w_bnum.obw &
	+w_border.obw &
	+w_button.obw &
	+w_combo.obw &
	+w_fmtstr.obw &
	+w_group.obw &
	+w_hlist.obw &
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
	+w_prompt.obw &
	+w_real.obw &
	+w_print.obw &
	+w_sbar.obw &
	+w_table.obw &
	+w_table1.obw &
	+w_table2.obw &
	+w_tbar.obw &
	+w_vlist.obw &
	+w_win.obw &
	+w_win1.obw &
	+w_win2.obw &
	+w_error.obw &
	+w_error1.obw &
	+w_int.obw &
	+w_intl.obw &
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
	+z_timer.obw &
	+z_time1.obw &
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
NUL
<<
	-@md ..\lib\$(VERSION)
	copy win_zil.lib ..\lib\$(VERSION)

# --- Done with libraries ---------------------------------------------------

z_appmsc.obj: z_app.cpp
	$(DOS_CPP) -DMSC $(DOS_CPP_OPTS) -Fo$@ $?

z_appgfx.obj: z_app.cpp
	$(DOS_CPP) -DGFX $(DOS_CPP_OPTS) -Fo$@ $?

z_appmsc.o16: z_app.cpp
	$(D16_CPP) -DMSC $(D16_CPP_OPTS) -Fo$@ $?

z_appgfx.o16: z_app.cpp
	$(D16_CPP) -DGFX $(D16_CPP_OPTS) -Fo$@ $?

z_apptxt.obj: z_app.cpp
	$(DOS_CPP) -DTEXT $(DOS_CPP_OPTS) -Fo$@ $?

d_mscprn.obj: d_print.cpp
	$(DOS_CPP) -DMSC $(DOS_CPP_OPTS) -Fo$@ $?

d_gfxprn.obj: d_print.cpp
	$(DOS_CPP) -DGFX $(DOS_CPP_OPTS) -Fo$@ $?

d_mscprn.o16: d_print.cpp
	$(D16_CPP) -DMSC $(D16_CPP_OPTS) -Fo$@ $?

d_gfxprn.o16: d_print.cpp
	$(D16_CPP) -DGFX $(D16_CPP_OPTS) -Fo$@ $?

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
