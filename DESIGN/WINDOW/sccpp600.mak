VERSION=sccpp600

# ----- DOS 32 bit compiler options -----------------------------------------
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

WIN_CPP_OPTS=-c -a1 -bx -ml -W2 -R
WIN_RC_OPTS=-k
WIN_LINK_OPTS=/NOI /PACKC:42000
WIN_LIB_OPTS=/N /B

WIN_OBJS=
WIN_LIBS=win_zil libw

.cpp.obw:
	$(WIN_CPP) $(WIN_CPP_OPTS) -o$@ $<

# ----- Usage --------------------------------------------------------------
usage:
	@echo ...........
	@echo ...........
	@echo To generate the library modules for specific environments type:
	@echo make -fsccpp600.mak dos32
	@echo make -fsccpp600.mak windows
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean.bat

# ----- DOS 32 bit extender (X-32VM) compiler options -----------------------
dos32: winedit.exe

winedit.exe: main.o32 window.lib
	$(D32_LINK) $(D32_LINK_OPTS) $(D32_OBJS)+main.o32, $*, ,window storage direct stredit service $(D32_LIBS)

window.lib : advanced.o32 derive.o32 export.o32 \
	geometry.o32 group.o32 import.o32 object.o32 \
	position.o32 prefer.o32 window.o32 window1.o32 \
	z_bnum.o32 z_border.o32 z_button.o32 z_combo.o32 \
	z_date.o32 z_fmtstr.o32 z_gmgr.o32 z_group.o32 \
	z_hlist.o32 z_icon.o32 z_int.o32 z_max.o32 z_min.o32 z_notebk.o32 \
	z_obj.o32 z_plldn.o32 z_plldn1.o32 z_popup.o32 z_popup1.o32 \
	z_prompt.o32 z_real.o32 z_scroll.o32 z_sbar.o32 z_spin.o32 \
	z_string.o32 z_sys.o32 z_table.o32 z_tbar.o32 z_text.o32 \
	z_time.o32 z_title.o32 z_vlist.o32 z_win.o32
	-@del window.lib
	$(D32_LIBRARIAN) /C $(D32_LIB_OPTS) @d32_zil.rsp

	copy window.hpp ..\..\include
	copy window.lib ..\..\lib\$(VERSION)
	copy p_window.dat ..\..\bin\p_window.znc

# ----- Windows Libraries and Programs --------------------------------------

windows: wwinedit.exe

wwinedit.exe: main.obw wwindow.lib
	$(WIN_LINK) $(WIN_LINK_OPTS) $(WIN_OBJS)+main.obw, $*, ,wwindow wstorage wdirect wstredit wservice $(WIN_LIBS), wwindow.def
	$(WIN_RC) wwindow.rc $*.exe

wwindow.lib: advanced.obw derive.obw export.obw \
	geometry.obw group.obw import.obw object.obw \
	position.obw prefer.obw window.obw window1.obw \
	z_bnum.obw z_border.obw z_button.obw z_combo.obw \
	z_date.obw z_fmtstr.obw z_gmgr.obw z_group.obw \
	z_hlist.obw z_icon.obw z_int.obw z_max.obw z_min.obw z_notebk.obw z_obj.obw \
	z_plldn.obw z_plldn1.obw z_popup.obw z_popup1.obw z_prompt.obw \
	z_real.obw z_scroll.obw z_sbar.obw z_spin.obw z_string.obw z_sys.obw \
	z_table.obw z_tbar.obw z_text.obw z_time.obw z_title.obw z_vlist.obw z_win.obw
	-@del wwindow.lib
	$(WIN_LIBRARIAN) $(WIN_LIB_OPTS) @win_zil.rsp

	copy window.hpp ..\..\include
	copy wwindow.lib ..\..\lib\$(VERSION)
	copy p_window.dat ..\..\bin\p_window.znc

