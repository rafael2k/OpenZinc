# ----- General Definitions -------------------------------------------------
VERSION=mvcpp210

.SUFFIXES : .c .cpp .obj .o16 .o32 .obw .obn

# ----- DOS TNT Extender options --------------------------------------------
# for debug:    add -Zi to CPP_OPTS
#               and -CV to LINK_OPTS
D32_CPP=cl
D32_LINK=link
D32_LIBRARIAN=lib
D32_CPP_OPTS=-c -DDOS386 -nologo
D32_LINK_OPTS=
D32_LIB_OPTS=
D32_OBJS=

# --- Use the next line for UI_GRAPHICS_DISPLAY ---
D32_LIBS=dosx32.lib dos32.lib d32_zil.lib d32_gfx.lib ms_32gfx.lib oldnames.lib
# --- Use the next line for UI_MSC_DISPLAY ---
#D32_LIBS=dosx32.lib dos32.lib tntapi.lib d32_zil.lib d32_msc.lib oldnames.lib

.cpp.o32:
	$(D32_CPP) $(D32_CPP_OPTS) -Fo$*.o32 $<

# ----- Usage --------------------------------------------------------------
usage:
	@echo ...........
	@echo ...........
	@echo To generate the library modules for specific environments type:
	@echo nmake -fmvcpp210.mak dos32
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean.bat

# ----- 32 bit DOS Extender Libraries and Programs --------------------------
dos32: winedt32.exe
	copy winedt32.exe ..\..\bin

winedt32.exe: main.o32 window32.lib
	$(D32_LINK) @msvc32.lnk $(D32_LINK_OPTS) -out:winedt32.exe $(D32_OBJS) main.o32 window32.lib storag32.lib direct32.lib stredi32.lib servic32.lib $(D32_LIBS)

window32.lib : advanced.o32 derive.o32 geometry.o32 group.o32 object.o32 prefer.o32 \
   window.o32 window1.o32 \
	export.o32 import.o32 position.o32 \
	z_bnum.o32 z_border.o32 z_button.o32 z_combo.o32 \
	z_date.o32 z_fmtstr.o32 z_gmgr.o32 z_group.o32 \
	z_hlist.o32 z_icon.o32 z_int.o32 z_max.o32 z_min.o32 z_notebk.o32 z_obj.o32 \
	z_plldn.o32 z_plldn1.o32 z_popup.o32 z_popup1.o32 z_prompt.o32 \
	z_real.o32 z_scroll.o32 z_sbar.o32 z_spin.o32 z_string.o32 z_sys.o32 \
	z_table.o32 z_tbar.o32 z_text.o32 z_time.o32 z_title.o32 z_vlist.o32 z_win.o32
	-@del window32.lib
	$(D32_LIBRARIAN) $(D32_LIB_OPTS) @<<zil.rsp
/out:$*.lib
advanced.o32 derive.o32 geometry.o32 group.o32 object.o32 prefer.o32 window.o32 window1.o32
	export.o32 import.o32 position.o32 
	z_bnum.o32 z_border.o32 z_button.o32 z_combo.o32 
	z_date.o32 z_fmtstr.o32 z_gmgr.o32 z_group.o32 
	z_hlist.o32 z_icon.o32 z_int.o32 z_max.o32 z_min.o32 z_notebk.o32 z_obj.o32 
	z_plldn.o32 z_plldn1.o32 z_popup.o32 z_popup1.o32 z_prompt.o32 
	z_real.o32 z_scroll.o32 z_sbar.o32 z_spin.o32 z_string.o32 z_sys.o32 
	z_table.o32 z_tbar.o32 z_text.o32 z_time.o32 z_title.o32 z_vlist.o32 z_win.o32
<<
	copy window.hpp ..\..\include
	copy window32.lib ..\..\lib\$(VERSION)
	copy p_window.dat ..\..\bin\p_window.znc


