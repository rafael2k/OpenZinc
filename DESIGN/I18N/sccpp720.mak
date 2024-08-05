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
dos32: i18edit.exe

i18edit.exe: main.o32 i18n.lib
	$(D32_LINK) $(D32_LINK_OPTS) $(D32_OBJS)+main.o32, $*, ,i18n storage direct stredit service $(D32_LIBS)

i18n.lib : i18n.o32 language.o32 locale.o32 \
	export.o32 import.o32 \
	z_bnum.o32 z_curr.o32 z_date.o32 z_date1.o32 z_day.o32 z_error.o32 \
	z_help.o32 z_int.o32 z_month.o32 z_msg.o32 z_num.o32 z_real.o32 \
	z_sys.o32 z_time.o32 z_time1.o32 z_time2.o32 z_win.o32
	-@del i18n.lib
	$(D32_LIBRARIAN) /C $(D32_LIB_OPTS) @d32_zil.rsp

	copy i18n.hpp ..\..\include
	copy i18n.lib ..\..\lib\$(VERSION)
	copy p_i18n.dat ..\..\bin\p_i18n.znc

# ----- Windows Libraries and Programs --------------------------------------

windows: wi18edit.exe

wi18edit.exe: main.obw wi18n.lib
	$(WIN_LINK) $(WIN_LINK_OPTS) $(WIN_OBJS)+main.obw, $*, ,wi18n wstorage wdirect wstredit wservice $(WIN_LIBS), wi18edit.def
	$(WIN_RC) wi18edit.rc

wi18n.lib : i18n.obw language.obw locale.obw \
	export.obw import.obw \
	z_bnum.obw z_curr.obw z_date.obw z_date1.obw z_day.obw z_error.obw \
	z_help.obw z_int.obw z_month.obw z_msg.obw z_num.obw z_real.obw \
	z_sys.obw  z_time.obw z_time1.obw z_time2.obw z_win.obw
	-@del wi18n.lib
	$(WIN_LIBRARIAN) $(WIN_LIB_OPTS) @win_zil.rsp

	copy i18n.hpp ..\..\include
	copy wi18n.lib ..\..\lib\$(VERSION)
	copy p_i18n.dat ..\..\bin\p_i18n.znc

# ----- Winnt Libraries and Programs --------------------------------------

winnt: ni18edit.exe

ni18edit.exe: main.obn ni18n.lib
	$(WNT_LINK) $(WNT_LINK_OPTS) $(WNT_OBJS)+main.obn, $*, ,ni18n nstorage ndirect nstredit nservice $(WNT_LIBS)

ni18n.lib : i18n.obn language.obn locale.obn \
	export.obn import.obn \
	z_bnum.obn z_curr.obn z_date.obn z_date1.obn z_day.obn z_error.obn \
	z_help.obn z_int.obn z_month.obn z_msg.obn z_num.obn z_real.obn \
	z_sys.obn  z_time.obn z_time1.obn z_time2.obn z_win.obn
	-@del ni18n.lib
	$(WNT_LIBRARIAN) $(WNT_LIB_OPTS) @wnt_zil.rsp

	copy i18n.hpp ..\..\include
	copy ni18n.lib ..\..\lib\$(VERSION)
	copy p_i18n.dat ..\..\bin\p_i18n.znc

# ----- Win32 Libraries and Programs --------------------------------------

win32: 9i18edit.exe

9i18edit.exe: main.ob9 9i18n.lib
	$(W32_LINK) $(W32_LINK_OPTS) $(W32_OBJS)+main.ob9, $*, ,9i18n 9storage 9direct 9stredit 9service $(W32_LIBS)

9i18n.lib : i18n.ob9 language.ob9 locale.ob9 \
	export.ob9 import.ob9 \
	z_bnum.ob9 z_curr.ob9 z_date.ob9 z_date1.ob9 z_day.ob9 z_error.ob9 \
	z_help.ob9 z_int.ob9 z_month.ob9 z_msg.ob9 z_num.ob9 z_real.ob9 \
	z_sys.ob9  z_time.ob9 z_time1.ob9 z_time2.ob9 z_win.ob9
	-@del 9i18n.lib
	$(W32_LIBRARIAN) $(W32_LIB_OPTS) @w32_zil.rsp

	copy i18n.hpp ..\..\include
	copy 9i18n.lib ..\..\lib\$(VERSION)
	copy p_i18n.dat ..\..\bin\p_i18n.znc

