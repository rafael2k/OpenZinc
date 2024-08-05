VERSION=sccpp700

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
	@echo make -fsccpp700.mak dos32
	@echo make -fsccpp700.mak windows
	@echo make -fsccpp700.mak winnt
	@echo make -fsccpp700.mak win32
	@echo ...........
	@echo ...........


# ----- Clean ---------------------------------------------------------------
clean:
	z_clean.bat

# ----- DOS 16 bit extender (Rational DOS16M) compiler options --------------
# DOS - Library support only
dos : d_direct.obj
	-@del direct.lib
	$(DOS_LIBRARIAN) /C $(DOS_LIB_OPTS) direct.lib+d_direct.obj;

	copy direct.hpp ..\..\include
	copy direct.lib ..\..\lib\$(VERSION)
	copy p_direct.dat ..\..\bin\p_direct.znc

# DOS OVERLAY - Library support only
dosovl : d_direct.ovl
	-@del direct.lib
	$(OVL_LIBRARIAN) /C $(OVL_LIB_OPTS) direct.lib+d_direct.ovl;

	copy direct.hpp ..\..\include
	copy direct.lib ..\..\lib\$(VERSION)
	copy p_direct.dat ..\..\bin\p_direct.znc

# ----- DOS 32 bit extender (X-32VM) compiler options -----------------------
dos32: test32.exe

test32.exe: main.o32 direct.lib
	$(D32_LINK) $(D32_LINK_OPTS) $(D32_OBJS)+main.o32, $*, ,direct service $(D32_LIBS)

direct.lib : d_direct.o32
	-@del direct.lib
	$(D32_LIBRARIAN) /C $(D32_LIB_OPTS) direct+d_direct.o32;

	copy direct.hpp ..\..\include
	copy direct.lib ..\..\lib\$(VERSION)
	copy p_direct.dat ..\..\bin\p_direct.znc

# ----- Windows Libraries and Programs --------------------------------------

windows: wtest.exe

wtest.exe: main.obw wdirect.lib
	$(WIN_LINK) $(WIN_LINK_OPTS) $(WIN_OBJS)+main.obw, $*, ,wdirect wservice $(WIN_LIBS), wtest.def
	$(WIN_RC) wtest.rc 

wdirect.lib : w_direct.obw
	-@del wdirect.lib
	$(WIN_LIBRARIAN) $(WIN_LIB_OPTS) wdirect+w_direct.obw;

	copy direct.hpp ..\..\include
	copy wdirect.lib ..\..\lib\$(VERSION)
	copy p_direct.dat ..\..\bin\p_direct.znc

# ----- Winnt Libraries and Programs --------------------------------------

winnt: ntest.exe

ntest.exe: main.obn ndirect.lib
	$(WNT_LINK) $(WNT_LINK_OPTS) $(WNT_OBJS)+main.obn, $*, ,ndirect nservice $(WNT_LIBS)

ndirect.lib : w_direct.obn
	-@del ndirect.lib
	$(WNT_LIBRARIAN) $(WNT_LIB_OPTS) ndirect+w_direct.obn;

	copy direct.hpp ..\..\include
	copy ndirect.lib ..\..\lib\$(VERSION)
	copy p_direct.dat ..\..\bin\p_direct.znc


# ----- Win32 Libraries and Programs --------------------------------------

win32: 9test.exe

9test.exe: main.ob9 9direct.lib
	$(W32_LINK) $(W32_LINK_OPTS) $(W32_OBJS)+main.ob9, $*, ,9direct 9service $(W32_LIBS)

9direct.lib : w_direct.ob9
	-@del 9direct.lib
	$(W32_LIBRARIAN) $(W32_LIB_OPTS) 9direct+w_direct.ob9;

	copy direct.hpp ..\..\include
	copy 9direct.lib ..\..\lib\$(VERSION)
	copy p_direct.dat ..\..\bin\p_direct.znc


