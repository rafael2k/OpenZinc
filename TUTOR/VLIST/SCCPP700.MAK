# VLIST tutorial makefile

#    make -fsccpp700.mak  dos  	      	(makes all the DOS tutorials)
#    make -fsccpp700.mak  dosovl      	(makes all the DOS VCM overlay tutorials) VCM overlay no longer supported
#    make -fsccpp700.mak  dos32	      	(makes all the DOS extender  tutorials)
#    make -fsccpp700.mak  windows      	(makes all the Windows  tutorials)
#    make -fsccpp700.mak  winnt      	(makes all the Winnt tutorials)
#    make -fsccpp700.mak  win32      	(makes all the Win32 tutorials)
#
# Be sure to set the LIB and INCLUDE environment variables for Zinc, e.g.:
#    set INCLUDE=.;C:\ZINC\INCLUDE;C:\sc7\INCLUDE
#    set LIB=.;C:\ZINC\LIB\sccpp700;C:\sc7\LIB

## Compiler and linker: (Add -g to CPP_OPTS and /CO to LINK_OPTS for debug.)

# ----- DOS compiler options ------------------------------------------------
DOS_CPP=sc
DOS_LINK=link
DOS_CPP_OPTS=-c -a1 -bx -ml -o+space -R
DOS_LINK_OPTS=/NOI /SEG:300
DOS_LIB_OPTS=/N /B /NOI
DOS_OBJS=
DOS_LIBS=dos_zil dos_gfx sc_lgfx

.c.obj:
	$(DOS_CPP) $(DOS_CPP_OPTS) $<

.cpp.obj:
	$(DOS_CPP) $(DOS_CPP_OPTS) $<

# ----- DOS Overlay (VCM) compiler options ----------------------------------
# VCM overlay no longer supported
OVL_CPP=sc
OVL_LINK=link
OVL_CPP_OPTS=-c -a1 -bx -mv -o+space -R
OVL_LINK_OPTS=/NOI /F /PAC
OVL_LIB_OPTS=/N /B /NOI
OVL_OBJS=
OVL_LIBS=dos_zilv dos_gfxv sc_lgfxv

.c.ovl:
	$(OVL_CPP) $(OVL_CPP_OPTS) -o$*.ovl $<

.cpp.ovl:
	$(OVL_CPP) $(OVL_CPP_OPTS) -o$*.ovl $<

# ----- DOS extender compiler options ---------------------------------------
D32_CPP=sc
D32_LINK=link
D32_CPP_OPTS=-c -bx -mx -o+space -R
D32_LINK_OPTS=/NOI
D32_LIB_OPTS=/C /N /B
D32_LIB_OPTS=/N /B /NOI
D32_OBJS=cx
D32_LIBS=d32_zil d32_gfx sc_32gfx x32

.cpp.o32:
	$(D32_CPP) $(D32_CPP_OPTS) -o$@ $<

.c.o32:
	$(D32_CPP) $(D32_CPP_OPTS) -o$@ $<

# ----- Windows compiler options --------------------------------------------
WIN_CPP=sc
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

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean.bat

# ----- DOS -----------------------------------------------------------------
dos: vlist.exe

vlist.exe: vlist.obj g_jump.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) $(DOS_OBJS)+vlist.obj+g_jump.obj,$*,NUL,$(DOS_LIBS),NUL

# ----- DOS Overlay (VCM)---------------------------------------
# no longer supported

dosovl: vlistv.exe

vlistv.exe: vlist.ovl g_jump.ovl
	$(OVL_LINK) $(OVL_LINK_OPTS) $(OVL_OBJS)+vlist.ovl+g_jump.ovl,$*, ,$(OVL_LIBS)

# ----- Dos extender --------------------------------------------------------
dos32: vlist32.exe

vlist32.exe: vlist.o32 g_jump.o32
	$(D32_LINK) $(D32_LINK_OPTS) $(D32_OBJS)+vlist.o32+g_jump.o32,$*, ,$(D32_LIBS)

# ----- Windows-------------------------------------------------
windows: wvlist.exe

wvlist.exe: vlist.obw g_jump.obw
	$(WIN_LINK) $(WIN_LINK_OPTS) $(WIN_OBJS)+vlist.obw+g_jump.obw,$*,NUL,$(WIN_LIBS),wvlist.def
	$(WIN_RC) $(WIN_RC_OPTS) wvlist.rc

# ----- Winnt-------------------------------------------------
winnt: nvlist.exe

nvlist.exe: vlist.obn g_jump.obn
	$(WNT_LINK) $(WNT_LINK_OPTS) $(WNT_OBJS)+vlist.obn+g_jump.obn,$*,NUL,$(WNT_LIBS)

# ----- Windows-------------------------------------------------
win32: 9vlist.exe

9vlist.exe: vlist.ob9 g_jump.ob9
	$(W32_LINK) $(W32_LINK_OPTS) $(W32_OBJS)+vlist.ob9+g_jump.ob9,$*,NUL,$(W32_LIBS) 


