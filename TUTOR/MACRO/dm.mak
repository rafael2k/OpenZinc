# MACRO tutorial makefile

#    make -fdm.mak dos  	      	(makes all the DOS tutorials)
#    make -fdm.mak dosovl      	(makes all the DOS VCM overlay tutorials) VCM overlay no longer supported
#    make -fdm.mak dos32	      	(makes all the DOS extender  tutorials)
#    make -fdm.mak windows      	(makes all the Windows  tutorials)
#    make -fdm.mak winnt      	(makes all the Winnt tutorials)
#    make -fdm.mak win32      	(makes all the Win32 tutorials)
#
# Be sure to set the LIB and INCLUDE environment variables for Zinc, e.g.:
#    set INCLUDE=.;C:\ZINC\INCLUDE;C:\dm\INCLUDE
#    set LIB=.;C:\ZINC\LIB\dm84;C:\dm\LIB

## Compiler and linker: (Add -g to CPP_OPTS and /CO to LINK_OPTS for debug.)

# ----- DOS compiler options ------------------------------------------------
DOS_CPP=dmc
DOS_LINK=link
DOS_CPP_OPTS=-c -a1 -ml -o+space
DOS_LINK_OPTS=/NOI /SEG:300
DOS_OBJS=
DOS_LIBS=dos_zil dos_gfx dm_lgfx

.c.obj:
	$(DOS_CPP) $(DOS_CPP_OPTS) $<

.cpp.obj:
	$(DOS_CPP) $(DOS_CPP_OPTS) $<

# ----- DOS Overlay (VCM) compiler options ----------------------------------
# VCM overlay no longer supported
OVL_CPP=dmc
OVL_LINK=link
OVL_CPP_OPTS=-c -a1 -mv -o+space -R
OVL_LINK_OPTS=/NOI /F /PAC
OVL_OBJS=
OVL_LIBS=dos_zilv dos_gfxv dm_lgfxv

.c.ovl:
	$(OVL_CPP) $(OVL_CPP_OPTS) -o$*.ovl $<

.cpp.ovl:
	$(OVL_CPP) $(OVL_CPP_OPTS) -o$*.ovl $<

# ----- DOS extender compiler options ---------------------------------------
D32_CPP=dmc
D32_LINK=link
D32_CPP_OPTS=-c -mx -D$(FONT)
D32_LINK_OPTS=/NOI
D32_LIB_OPTS=/C /N /B
D32_OBJS=cx
D32_LIBS=d32_zil d32_gfx dm_32gfx x32

.cpp.o32:
	$(D32_CPP) $(D32_CPP_OPTS) -o$@ $<

.c.o32:
	$(D32_CPP) $(D32_CPP_OPTS) -o$@ $<

# ----- Windows compiler options --------------------------------------------
WIN_CPP=dmc
WIN_LINK=link
WIN_RC=rc

WIN_CPP_OPTS=-c -a1 -ml -W2
WIN_RC_OPTS=
WIN_LINK_OPTS=/NOI
WIN_OBJS=
WIN_LIBS=win_zil libw

.c.obw:
	$(WIN_CPP) $(WIN_CPP_OPTS) -o$*.obw $<

.cpp.obw:
	$(WIN_CPP) $(WIN_CPP_OPTS) -o$*.obw $<

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


# ----- Clean ---------------------------------------------------------------
clean:
	z_clean.bat

# ----- DOS -----------------------------------------------------------------
dos: macro.exe

macro.exe: macro.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) $(DOS_OBJS)+macro.obj,$*,NUL,$(DOS_LIBS),NUL

# ---DOSOverlay
# No longer supported-------------------------------------
dosovl: macrov.exe

macrov.exe: macro.ovl
	$(OVL_LINK) $(OVL_LINK_OPTS) $(OVL_OBJS)+macro.ovl,$*, ,$(OVL_LIBS)

# ----- Dos extender --------------------------------------------------------
dos32: macro32.exe

macro32.exe: macro.o32
	$(D32_LINK) $(D32_LINK_OPTS) $(D32_OBJS)+macro.o32,$*, ,$(D32_LIBS)

# ----- Windows -----------------------------------------------
windows: wmacro.exe

wmacro.exe: macro.obw
	$(WIN_LINK) $(WIN_LINK_OPTS) $(WIN_OBJS)+macro.obw,$*,NUL,$(WIN_LIBS),wmacro.def
	$(WIN_RC) $(WIN_RC_OPTS) wmacro.rc

# ----- Winnt -----------------------------------------------
winnt: nmacro.exe

nmacro.exe: macro.obn
	$(WNT_LINK) $(WNT_LINK_OPTS) $(WNT_OBJS)+macro.obn,$*,NUL,$(WNT_LIBS)

# ----- Win32 -----------------------------------------------
win32: 9macro.exe

9macro.exe: macro.ob9
	$(W32_LINK) $(W32_LINK_OPTS) $(W32_OBJS)+macro.ob9,$*,NUL,$(W32_LIBS) 

