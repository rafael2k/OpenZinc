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
dos32: file32.exe

file32.exe: main.o32 file.lib
	$(D32_LINK) $(D32_LINK_OPTS) $(D32_OBJS)+main.o32, $*, ,storage stredit file direct service $(D32_LIBS)

file.lib : file.o32
	-@del file.lib
	$(D32_LIBRARIAN) /C $(D32_LIB_OPTS) file+file.o32;

	copy file.hpp ..\..\include
	copy file.lib ..\..\lib\$(VERSION)
	copy p_file.dat ..\..\bin\p_file.znc

# ----- Windows Libraries and Programs --------------------------------------

windows: wfile.exe

wfile.exe: main.obw wfile.lib
	$(WIN_LINK) $(WIN_LINK_OPTS) $(WIN_OBJS)+main.obw, $*, ,wstorage wstredit wfile wservice wdirect $(WIN_LIBS), wfile.def
	$(WIN_RC) wfile.rc 

wfile.lib : file.obw
	-@del wfile.lib
	$(WIN_LIBRARIAN) $(WIN_LIB_OPTS) wfile+file.obw;

	copy file.hpp ..\..\include
	copy wfile.lib ..\..\lib\$(VERSION)
	copy p_file.dat ..\..\bin\p_file.znc

# ----- Winnt Libraries and Programs --------------------------------------

winnt: nfile.exe

nfile.exe: main.onw nfile.lib
	$(WNT_LINK) $(WNT_LINK_OPTS) $(WNT_OBJS)+main.obn, $*, ,nstorage nstredit nfile nservice ndirect $(WNT_LIBS)

nfile.lib : file.obn
	-@del nfile.lib
	$(WNT_LIBRARIAN) $(WNT_LIB_OPTS) nfile+file.obn;

	copy file.hpp ..\..\include
	copy nfile.lib ..\..\lib\$(VERSION)
	copy p_file.dat ..\..\bin\p_file.znc

# ----- Win32 Libraries and Programs --------------------------------------

win32: 9file.exe

9file.exe: main.on9 9file.lib
	$(W32_LINK) $(W32_LINK_OPTS) $(W32_OBJS)+main.ob9, $*, ,9storage 9stredit 9file 9service 9direct $(W332_LIBS)

9file.lib : file.ob9
	-@del 9file.lib
	$(W32_LIBRARIAN) $(W32_LIB_OPTS) 9file+file.ob9;

	copy file.hpp ..\..\include
	copy 9file.lib ..\..\lib\$(VERSION)
	copy p_file.dat ..\..\bin\p_file.znc

