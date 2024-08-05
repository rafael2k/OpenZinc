VERSION=sccpp720

# ----- DOS 16 bit extender (Rational DOS16M) compiler options --------------
# --- DOS ---
DOS_CPP=sc
DOS_LINK=link
DOS_LIBRARIAN=lib
DOS_CPP_OPTS=-c -a1 -bx -ml -o+space -R -R
DOS_LINK_OPTS=/NOI
DOS_LIB_OPTS=/N /B /NOI
DOS_OBJS=
DOS_LIBS=dos_zil dos_gfx sc_lgfx

.cpp.obj:
	$(DOS_CPP) $(DOS_CPP_OPTS) $<

# --- VROOM ---
OVL_CPP=sc
OVL_LINK=link
OVL_LIBRARIAN=lib
OVL_CPP_OPTS=-c -a1 -mv -R
OVL_LINK_OPTS=/NOI /F /PAC
OVL_LIB_OPTS=/N /B /NOI
OVL_LIB_OPTS=/N /B /NOI
OVL_OBJS=
OVL_LIBS=dos_zilv dos_gfxv sc_lgfxv

.cpp.ovl:
	$(OVL_CPP) $(OVL_CPP_OPTS) -o$@ $<

# ----- DOS 32 bit extender (X-32VM) compiler options -----------------------
D32_CPP=sc
D32_LINK=link
D32_LIBRARIAN=lib
D32_CPP_OPTS=-c -mx -R
D32_LINK_OPTS=/NOI
D32_LIB_OPTS=/N /B /NOI
D32_LIB_OPTS=/N /B /NOI
D32_OBJS=cx
D32_LIBS=d32_zil d32_gfx sc_32gfx x32

.cpp.o32:
	$(D32_CPP) $(D32_CPP_OPTS) -o$@ $<

# ----- Windows compiler options --------------------------------------------
WIN_CPP=sc
WIN_LINK=link
WIN_LIBRARIAN=lib
WIN_RC=rc

WIN_CPP_OPTS=-c -a1 -ml -W2 -R
WIN_RC_OPTS=-k
WIN_LINK_OPTS=/NOI /PACKC:42000
WIN_LIB_OPTS=/N /B

WIN_OBJS=
WIN_LIBS=wwindow whelp wi18n wmessage wimage wstorage wdirect wstredit wservice win_zil commdlg libw

.cpp.obw:
	$(WIN_CPP) $(WIN_CPP_OPTS) -o$@ $<

# ----- Windows NT (and WIN32s) compiler options ----------------------------
WNT_CPP=sc
WNT_LINK=link
WNT_LIBRARIAN=lib
WNT_RC=rc

WNT_CPP_OPTS=-c -4 -mn -WA
WNT_RC_OPTS=
WNT_LINK_OPTS=/NOI
WNT_LIB_OPTS=/N /B

WNT_OBJS=
WNT_LIBS=wnt_zil kernel32 user32 gdi32 ctl3d32

.cpp.obn:
	$(WNT_CPP) $(WNT_CPP_OPTS) -o$@ $<

# ----- Windows 32 compiler options ----------------------------
W32_CPP=sc
W32_LINK=link
W32_LIBRARIAN=lib
W32_RC=rc

W32_CPP_OPTS=-c -4 -mn -WA -DZIL_WIN32
W32_RC_OPTS=
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
	@echo make -fsccpp720.mak dos32
	@echo make -fsccpp720.mak windows
	@echo make -fsccpp720.mak winnt
	@echo make -fsccpp720.mak win32
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

# ----- Winnt Libraries and Programs --------------------------------------

winnt: nwinedit.exe

nwinedit.exe: main.obn nwindow.lib
	$(WNT_LINK) $(WNT_LINK_OPTS) $(WNT_OBJS)+main.obn, $*, ,nwindow nstorage ndirect nstredit nservice $(WNT_LIBS)

nwindow.lib: advanced.obn derive.obn export.obn \
	geometry.obn group.obn import.obn object.obn \
	position.obn prefer.obn window.obn window1.obn \
	z_bnum.obn z_border.obn z_button.obn z_combo.obn \
	z_date.obn z_fmtstr.obn z_gmgr.obn z_group.obn \
	z_hlist.obn z_icon.obn z_int.obn z_max.obn z_min.obn z_notebk.obn z_obj.obn \
	z_plldn.obn z_plldn1.obn z_popup.obn z_popup1.obn z_prompt.obn \
	z_real.obn z_scroll.obn z_sbar.obn z_spin.obn z_string.obn z_sys.obn \
	z_table.obn z_tbar.obn z_text.obn z_time.obn z_title.obn z_vlist.obn z_win.obn
	-@del nwindow.lib
	$(WNT_LIBRARIAN) $(WNT_LIB_OPTS) @wnt_zil.rsp

	copy window.hpp ..\..\include
	copy nwindow.lib ..\..\lib\$(VERSION)
	copy p_window.dat ..\..\bin\p_window.znc

# ----- Win32 Libraries and Programs --------------------------------------

win32: 9winedit.exe

9winedit.exe: main.ob9 9window.lib
	$(W32_LINK) $(W32_LINK_OPTS) $(W32_OBJS)+main.ob9, $*, ,9window 9storage 9direct 9stredit 9service $(W32_LIBS)

9window.lib: advanced.ob9 derive.ob9 export.ob9 \
	geometry.ob9 group.ob9 import.ob9 object.ob9 \
	position.ob9 prefer.ob9 window.ob9 window1.ob9 \
	z_bnum.ob9 z_border.ob9 z_button.ob9 z_combo.ob9 \
	z_date.ob9 z_fmtstr.ob9 z_gmgr.ob9 z_group.ob9 \
	z_hlist.ob9 z_icon.ob9 z_int.ob9 z_max.ob9 z_min.ob9 z_notebk.ob9 z_obj.ob9 \
	z_plldn.ob9 z_plldn1.ob9 z_popup.ob9 z_popup1.ob9 z_prompt.ob9 \
	z_real.ob9 z_scroll.ob9 z_sbar.ob9 z_spin.ob9 z_string.ob9 z_sys.ob9 \
	z_table.ob9 z_tbar.ob9 z_text.ob9 z_time.ob9 z_title.ob9 z_vlist.ob9 z_win.ob9
	-@del 9window.lib
	$(W32_LIBRARIAN) $(W32_LIB_OPTS) @w32_zil.rsp

	copy window.hpp ..\..\include
	copy 9window.lib ..\..\lib\$(VERSION)
	copy p_window.dat ..\..\bin\p_window.znc

