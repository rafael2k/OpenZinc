# MOVIE tutorial makefile

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
dos: movie.exe movie1.exe movie2.exe movie3.exe movie4.exe movie5.exe movie6.exe movie7.exe

movie.exe: movie.obj p_movie.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) $(DOS_OBJS)+movie.obj+p_movie.obj,$*,NUL,$(DOS_LIBS),NUL

movie1.exe: movie1.obj p_movie1.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) $(DOS_OBJS)+movie1.obj+p_movie1.obj,$*,NUL,$(DOS_LIBS),NUL

movie2.exe: movie2.obj p_movie2.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) $(DOS_OBJS)+movie2.obj+p_movie2.obj,$*,NUL,$(DOS_LIBS),NUL

movie3.exe: movie3.obj p_movie3.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) $(DOS_OBJS)+movie3.obj+p_movie3.obj,$*,NUL,$(DOS_LIBS),NUL

movie4.exe: movie4.obj p_movie4.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) $(DOS_OBJS)+movie4.obj+p_movie4.obj,$*,NUL,$(DOS_LIBS),NUL

movie5.exe: movie5.obj p_movie5.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) $(DOS_OBJS)+movie5.obj+p_movie5.obj,$*,NUL,$(DOS_LIBS),NUL

movie6.exe: movie6.obj p_movie6.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) $(DOS_OBJS)+movie6.obj+p_movie6.obj,$*,NUL,$(DOS_LIBS),NUL

movie7.exe: movie7.obj p_movie7.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) $(DOS_OBJS)+movie7.obj+p_movie7.obj,$*,NUL,$(DOS_LIBS),NUL

# ----- DOS Overlay (VCM) ---------------------------------------------------
# no longer supported
dosovl: moviev.exe movie1v.exe movie2v.exe movie4v.exe movie4v.exe movie5v.exe movie6v.exe movie7v.exe

moviev.exe: movie.ovl p_movie.ovl
	$(OVL_LINK) $(OVL_LINK_OPTS) $(OVL_OBJS)+movie.ovl+p_movie.ovl,$*, ,$(OVL_LIBS)

movie1v.exe: movie1.ovl p_movie1.ovl
	$(OVL_LINK) $(OVL_LINK_OPTS) $(OVL_OBJS)+movie1.ovl+p_movie1.ovl,$*, ,$(OVL_LIBS)

movie2v.exe: movie2.ovl p_movie2.ovl
	$(OVL_LINK) $(OVL_LINK_OPTS) $(OVL_OBJS)+movie2.ovl+p_movie2.ovl,$*, ,$(OVL_LIBS)

movie3v.exe: movie3.ovl p_movie3.ovl
	$(OVL_LINK) $(OVL_LINK_OPTS) $(OVL_OBJS)+movie3.ovl+p_movie3.ovl,$*, ,$(OVL_LIBS)

movie4v.exe: movie4.ovl p_movie4.ovl
	$(OVL_LINK) $(OVL_LINK_OPTS) $(OVL_OBJS)+movie4.ovl+p_movie4.ovl,$*, ,$(OVL_LIBS)

movie5v.exe: movie5.ovl p_movie5.ovl
	$(OVL_LINK) $(OVL_LINK_OPTS) $(OVL_OBJS)+movie5.ovl+p_movie5.ovl,$*, ,$(OVL_LIBS)

movie6v.exe: movie6.ovl p_movie6.ovl
	$(OVL_LINK) $(OVL_LINK_OPTS) $(OVL_OBJS)+movie6.ovl+p_movie6.ovl,$*, ,$(OVL_LIBS)

movie7v.exe: movie7.ovl p_movie7.ovl
	$(OVL_LINK) $(OVL_LINK_OPTS) $(OVL_OBJS)+movie7.ovl+p_movie7.ovl,$*, ,$(OVL_LIBS)

# ----- Dos extender --------------------------------------------------------
dos32: movie32.exe movie132.exe movie232.exe movie332.exe movie432.exe movie532.exe movie632.exe movie732.exe

movie32.exe: movie.o32 p_movie.o32
	$(D32_LINK) $(D32_LINK_OPTS) $(D32_OBJS)+movie.o32+p_movie.o32,$*, ,$(D32_LIBS)

movie132.exe: movie1.o32 p_movie1.o32
	$(D32_LINK) $(D32_LINK_OPTS) $(D32_OBJS)+movie1.o32+p_movie1.o32,$*, ,$(D32_LIBS)

movie232.exe: movie2.o32 p_movie2.o32
	$(D32_LINK) $(D32_LINK_OPTS) $(D32_OBJS)+movie2.o32+p_movie2.o32,$*, ,$(D32_LIBS)

movie332.exe: movie3.o32 p_movie3.o32
	$(D32_LINK) $(D32_LINK_OPTS) $(D32_OBJS)+movie3.o32+p_movie3.o32,$*, ,$(D32_LIBS)

movie432.exe: movie4.o32 p_movie4.o32
	$(D32_LINK) $(D32_LINK_OPTS) $(D32_OBJS)+movie4.o32+p_movie4.o32,$*, ,$(D32_LIBS)

movie532.exe: movie5.o32 p_movie5.o32
	$(D32_LINK) $(D32_LINK_OPTS) $(D32_OBJS)+movie5.o32+p_movie5.o32,$*, ,$(D32_LIBS)

movie632.exe: movie6.o32 p_movie6.o32
	$(D32_LINK) $(D32_LINK_OPTS) $(D32_OBJS)+movie6.o32+p_movie6.o32,$*, ,$(D32_LIBS)

movie732.exe: movie7.o32 p_movie7.o32
	$(D32_LINK) $(D32_LINK_OPTS) $(D32_OBJS)+movie7.o32+p_movie7.o32,$*, ,$(D32_LIBS)

# ----- Windows ------------------------------------------------
windows: wmovie.exe wmovie1.exe wmovie2.exe wmovie3.exe wmovie4.exe wmovie5.exe wmovie6.exe wmovie7.exe

wmovie.exe: movie.obw p_movie.obw
	$(WIN_LINK) $(WIN_LINK_OPTS) $(WIN_OBJS)+movie.obw+p_movie.obw,$*,NUL,$(WIN_LIBS),wmovie.def
	$(WIN_RC) $(WIN_RC_OPTS) wmovie.rc 

wmovie1.exe: movie1.obw p_movie1.obw
	$(WIN_LINK) $(WIN_LINK_OPTS) $(WIN_OBJS)+movie1.obw+p_movie1.obw,$*,NUL,$(WIN_LIBS),wmovie.def
	$(WIN_RC) $(WIN_RC_OPTS) wmovie.rc 

wmovie2.exe: movie2.obw p_movie2.obw
	$(WIN_LINK) $(WIN_LINK_OPTS) $(WIN_OBJS)+movie2.obw+p_movie2.obw,$*,NUL,$(WIN_LIBS),wmovie.def
	$(WIN_RC) $(WIN_RC_OPTS) wmovie.rc 

wmovie3.exe: movie3.obw p_movie3.obw
	$(WIN_LINK) $(WIN_LINK_OPTS) $(WIN_OBJS)+movie3.obw+p_movie3.obw,$*,NUL,$(WIN_LIBS),wmovie.def
	$(WIN_RC) $(WIN_RC_OPTS) wmovie.rc 

wmovie4.exe: movie4.obw p_movie4.obw
	$(WIN_LINK) $(WIN_LINK_OPTS) $(WIN_OBJS)+movie4.obw+p_movie4.obw,$*,NUL,$(WIN_LIBS),wmovie.def
	$(WIN_RC) $(WIN_RC_OPTS) wmovie.rc 

wmovie5.exe: movie5.obw p_movie5.obw
	$(WIN_LINK) $(WIN_LINK_OPTS) $(WIN_OBJS)+movie5.obw+p_movie5.obw,$*,NUL,$(WIN_LIBS),wmovie.def
	$(WIN_RC) $(WIN_RC_OPTS) wmovie.rc 

wmovie6.exe: movie6.obw p_movie6.obw
	$(WIN_LINK) $(WIN_LINK_OPTS) $(WIN_OBJS)+movie6.obw+p_movie6.obw,$*,NUL,$(WIN_LIBS),wmovie.def
	$(WIN_RC) $(WIN_RC_OPTS) wmovie.rc 

wmovie7.exe: movie7.obw p_movie7.obw
	$(WIN_LINK) $(WIN_LINK_OPTS) $(WIN_OBJS)+movie7.obw+p_movie7.obw,$*,NUL,$(WIN_LIBS),wmovie.def
	$(WIN_RC) $(WIN_RC_OPTS) wmovie.rc 

# ----- Winnt ------------------------------------------------
winnt: nmovie.exe nmovie1.exe nmovie2.exe nmovie3.exe nmovie4.exe nmovie5.exe nmovie6.exe nmovie7.exe

nmovie.exe: movie.obn p_movie.obn
	$(WNT_LINK) $(WNT_LINK_OPTS) $(WNT_OBJS)+movie.obn+p_movie.obn,$*,NUL,$(WNT_LIBS)

nmovie1.exe: movie1.obn p_movie1.obn
	$(WNT_LINK) $(WNT_LINK_OPTS) $(WNT_OBJS)+movie1.obn+p_movie1.obn,$*,NUL,$(WNT_LIBS)

nmovie2.exe: movie2.obn p_movie2.obn
	$(WNT_LINK) $(WNT_LINK_OPTS) $(WNT_OBJS)+movie2.obn+p_movie2.obn,$*,NUL,$(WNT_LIBS)

nmovie3.exe: movie3.obn p_movie3.obn
	$(WNT_LINK) $(WNT_LINK_OPTS) $(WNT_OBJS)+movie3.obn+p_movie3.obn,$*,NUL,$(WNT_LIBS) 

nmovie4.exe: movie4.obn p_movie4.obn
	$(WNT_LINK) $(WNT_LINK_OPTS) $(WNT_OBJS)+movie4.obn+p_movie4.obn,$*,NUL,$(WNT_LIBS) 

nmovie5.exe: movie5.obn p_movie5.obn
	$(WNT_LINK) $(WNT_LINK_OPTS) $(WNT_OBJS)+movie5.obn+p_movie5.obn,$*,NUL,$(WNT_LIBS) 

nmovie6.exe: movie6.obn p_movie6.obn
	$(WNT_LINK) $(WNT_LINK_OPTS) $(WNT_OBJS)+movie6.obn+p_movie6.obn,$*,NUL,$(WNT_LIBS) 

nmovie7.exe: movie7.obn p_movie7.obn
	$(WNT_LINK) $(WNT_LINK_OPTS) $(WNT_OBJS)+movie7.obn+p_movie7.obn,$*,NUL,$(WNT_LIBS) 

# ----- Win32 ------------------------------------------------
win32: 9movie.exe 9movie1.exe 9movie2.exe 9movie3.exe 9movie4.exe 9movie5.exe 9movie6.exe 9movie7.exe

9movie.exe: movie.ob9 p_movie.ob9
	$(W32_LINK) $(W32_LINK_OPTS) $(W32_OBJS)+movie.ob9+p_movie.ob9,$*,NUL,$(W32_LIBS)

9movie1.exe: movie1.ob9 p_movie1.ob9
	$(W32_LINK) $(W32_LINK_OPTS) $(W32_OBJS)+movie1.ob9+p_movie1.ob9,$*,NUL,$(W32_LIBS)

9movie2.exe: movie2.ob9 p_movie2.ob9
	$(W32_LINK) $(W32_LINK_OPTS) $(W32_OBJS)+movie2.ob9+p_movie2.ob9,$*,NUL,$(W32_LIBS)

9movie3.exe: movie3.ob9 p_movie3.ob9
	$(W32_LINK) $(W32_LINK_OPTS) $(W32_OBJS)+movie3.ob9+p_movie3.ob9,$*,NUL,$(W32_LIBS) 

9movie4.exe: movie4.ob9 p_movie4.ob9
	$(W32_LINK) $(W32_LINK_OPTS) $(W32_OBJS)+movie4.ob9+p_movie4.ob9,$*,NUL,$(W32_LIBS) 

9movie5.exe: movie5.ob9 p_movie5.ob9
	$(W32_LINK) $(W32_LINK_OPTS) $(W32_OBJS)+movie5.ob9+p_movie5.ob9,$*,NUL,$(W32_LIBS) 

9movie6.exe: movie6.ob9 p_movie6.ob9
	$(W32_LINK) $(W32_LINK_OPTS) $(W32_OBJS)+movie6.ob9+p_movie6.ob9,$*,NUL,$(W32_LIBS) 

9movie7.exe: movie7.ob9 p_movie7.ob9
	$(W32_LINK) $(W32_LINK_OPTS) $(W32_OBJS)+movie7.ob9+p_movie7.ob9,$*,NUL,$(W32_LIBS) 

