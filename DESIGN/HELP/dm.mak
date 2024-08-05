VERSION=dm84

# ----- DOS 16 bit extender (Rational DOS16M) compiler options --------------
# --- DOS ---
DOS_CPP=dmc
DOS_LINK=link
DOS_LIBRARIAN=lib
DOS_CPP_OPTS=-c -a1 -ml -o+space -R
DOS_LINK_OPTS=/NOI
DOS_LIB_OPTS=/N /B /NOI
DOS_OBJS=
DOS_LIBS=dos_zil dos_gfx dm_lgfx

.cpp.obj:
	$(DOS_CPP) $(DOS_CPP_OPTS) $<

# --- VROOM ---
OVL_CPP=dmc
OVL_LINK=link
OVL_LIBRARIAN=lib
OVL_CPP_OPTS=-c -a1 -mv -R
OVL_LINK_OPTS=/NOI /F /PAC
OVL_LIB_OPTS=/N /B /NOI
OVL_OBJS=
OVL_LIBS=dos_zilv dos_gfxv dm_lgfxv

.cpp.ovl:
	$(OVL_CPP) $(OVL_CPP_OPTS) -o$@ $<

# ----- DOS 32 bit extender (X-32VM) compiler options -----------------------
D32_CPP=dmc
D32_LINK=link
D32_LIBRARIAN=lib
D32_CPP_OPTS=-c -mx -R
D32_LINK_OPTS=/NOI
D32_LIB_OPTS=/N /B /NOI
D32_OBJS=cx
D32_LIBS=d32_zil d32_gfx dm_32gfx x32

.cpp.o32:
	$(D32_CPP) $(D32_CPP_OPTS) -o$@ $<

# ----- Windows compiler options --------------------------------------------
WIN_CPP=dmc
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
WNT_CPP=dmc
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
W32_CPP=dmc
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
	@echo make -fdm.mak dos32
	@echo make -fdm.mak windows
	@echo make -fdm.mak winnt
	@echo make -fdm.mak win32
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean.bat

# ----- DOS 32 bit extender (X-32VM) compiler options -----------------------
dos32: hlpedit.exe

hlpedit.exe: main.o32 help.lib
	$(D32_LINK) $(D32_LINK_OPTS) $(D32_OBJS)+main.o32, $*, ,help storage direct stredit service $(D32_LIBS)

help.lib : help.o32 help1.o32 import.o32 export.o32
	-@del help.lib
	$(D32_LIBRARIAN) /C $(D32_LIB_OPTS) help+help.o32+help1.o32+import.o32+export.o32;

	copy help.hpp ..\..\include
	copy help.lib ..\..\lib\$(VERSION)
	copy p_help.dat ..\..\bin\p_help.znc

# ----- Windows Libraries and Programs --------------------------------------

windows: whlpedit.exe

whlpedit.exe: main.obw whelp.lib
	$(WIN_LINK) $(WIN_LINK_OPTS) $(WIN_OBJS)+main.obw, $*, ,whelp wstorage wdirect wstredit wservice $(WIN_LIBS), whelp.def
	$(WIN_RC) whelp.rc 

whelp.lib : help.obw help1.obw import.obw export.obw
	-@del whelp.lib
	$(WIN_LIBRARIAN) $(WIN_LIB_OPTS) whelp+help.obw+help1.obw+import.obw+export.obw;

	copy help.hpp ..\..\include
	copy whelp.lib ..\..\lib\$(VERSION)
	copy p_help.dat ..\..\bin\p_help.znc

# ----- Winnt Libraries and Programs --------------------------------------

winnt: nhlpedit.exe

nhlpedit.exe: main.obn nhelp.lib
	$(WNT_LINK) $(WNT_LINK_OPTS) $(WNT_OBJS)+main.obn, $*, ,nhelp nstorage ndirect nstredit nservice $(WNT_LIBS)

nhelp.lib : help.obn help1.obn import.obn export.obn
	-@del nhelp.lib
	$(WNT_LIBRARIAN) $(WNT_LIB_OPTS) nhelp+help.obn+help1.obn+import.obn+export.obn;

	copy help.hpp ..\..\include
	copy nhelp.lib ..\..\lib\$(VERSION)
	copy p_help.dat ..\..\bin\p_help.znc

# ----- Win32 Libraries and Programs --------------------------------------

win32: 9hlpedit.exe

9hlpedit.exe: main.ob9 9help.lib
	$(W32_LINK) $(W32_LINK_OPTS) $(W32_OBJS)+main.ob9, $*, ,9help 9storage 9direct 9stredit 9service $(W32LIBS)

9help.lib : help.ob9 help1.ob9 import.ob9 export.ob9
	-@del 9help.lib
	$(W32_LIBRARIAN) $(W32_LIB_OPTS) 9help+help.ob9+help1.ob9+import.ob9+export.ob9;

	copy help.hpp ..\..\include
	copy 9help.lib ..\..\lib\$(VERSION)
	copy p_help.dat ..\..\bin\p_help.znc

