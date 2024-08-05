# INTERPOL tutorial makefile

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



# ----- Usage ---------------------------------------------------------------
usage:
	@echo ...........
	@echo ...........
	@echo To make this Zinc tutorial for Symantec C++ type:
	@echo make -fsccpp700.mak  dos
	@echo make -fsccpp700.mak  dos32
	@echo make -fsccpp700.mak  windows
	@echo make -fsccpp700.mak  winnt
	@echo make -fsccpp700.mak  win32
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean.bat

# ----- DOS -----------------------------------------------------------------
dos: intrpol1.exe intrpol2.exe

intrpol1.exe: intrpol1.obj ipolwin1.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) $(DOS_OBJS)+intrpol1.obj+ipolwin1.obj,$*,NUL,$(DOS_LIBS),NUL

intrpol2.exe: intrpol2.obj ipolwin2.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) $(DOS_OBJS)+intrpol2.obj+ipolwin2.obj,$*,NUL,$(DOS_LIBS),NUL

# ----- DOS Overlay (VCM) ---------------------------------------------------
# SCM overlay no longer supported
dosovl: intrpo1v.exe intrpo2v.exe

intrpo1v.exe: intrpol1.ovl ipolwin1.ovl
	$(OVL_LINK) $(OVL_LINK_OPTS) $(OVL_OBJS)+intrpol1.ovl+ipolwin1.ovl,$*, ,$(OVL_LIBS)

intrpo2v.exe: intrpol2.ovl ipolwin2.ovl
	$(OVL_LINK) $(OVL_LINK_OPTS) $(OVL_OBJS)+intrpol2.ovl+ipolwin2.ovl,$*, ,$(OVL_LIBS)

# ----- Dos extender --------------------------------------------------------
dos32: intrp132.exe intrp232.exe

intrp132.exe: intrpol1.o32 ipolwin1.o32
	$(D32_LINK) $(D32_LINK_OPTS) $(D32_OBJS)+intrpol1.o32+ipolwin1.o32,$*, ,$(D32_LIBS)

intrp232.exe: intrpol2.o32 ipolwin2.o32
	$(D32_LINK) $(D32_LINK_OPTS) $(D32_OBJS)+intrpol2.o32+ipolwin2.o32,$*, ,$(D32_LIBS)

# ----- Windows -------------------------------------------------------------
windows: wintrpo1.exe wintrpo2.exe

wintrpo1.exe: intrpol1.obw ipolwin1.obw
	$(WIN_LINK) $(WIN_LINK_OPTS) $(WIN_OBJS)+intrpol1.obw+ipolwin1.obw,$*,NUL,$(WIN_LIBS),windows.def
	$(WIN_RC) $(WIN_RC_OPTS)  windows.rc

wintrpo2.exe: intrpol2.obw ipolwin2.obw
	$(WIN_LINK) $(WIN_LINK_OPTS) $(WIN_OBJS)+intrpol2.obw+ipolwin2.obw,$*,NUL,$(WIN_LIBS),windows.def
	$(WIN_RC) $(WIN_RC_OPTS) windows.rc

# ----- Winnt -------------------------------------------------------------
winnt: nintrpo1.exe nintrpo2.exe

nintrpo1.exe: intrpol1.obn ipolwin1.obn
	$(WNT_LINK) $(WNT_LINK_OPTS) $(WNT_OBJS)+intrpol1.obn+ipolwin1.obn,$*,NUL,$(WNT_LIBS)

nintrpo2.exe: intrpol2.obn ipolwin2.obn
	$(WNT_LINK) $(WNT_LINK_OPTS) $(WNT_OBJS)+intrpol2.obn+ipolwin2.obn,$*,NUL,$(WNT_LIBS)

# ----- Win32 -------------------------------------------------------------
win32: 9intrpo1.exe 9intrpo2.exe

9intrpo1.exe: intrpol1.ob9 ipolwin1.ob9
	$(W32_LINK) $(W32_LINK_OPTS) $(W32_OBJS)+intrpol1.ob9+ipolwin1.ob9,$*,NUL,$(W32_LIBS)

9intrpo2.exe: intrpol2.ob9 ipolwin2.ob9
	$(W32_LINK) $(W32_LINK_OPTS) $(W32_OBJS)+intrpol2.ob9+ipolwin2.ob9,$*,NUL,$(W32_LIBS)


