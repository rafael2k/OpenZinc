# MOVIE tutorial makefile

#    make -fsccpp600.mak dos  	      	(makes all the DOS movie tutorials)
#    make -fsccpp600.mak dosovl      	(makes all the DOS VCM overlay movie tutorials)
#    make -fsccpp600.mak dos32	      	(makes all the DOS extender movie tutorials)
#    make -fsccpp600.mak windows      	(makes all the Windows movie tutorials)

# Be sure to set the LIB and INCLUDE environment variables for Zinc, e.g.:
#    set INCLUDE=.;C:\ZINC\INCLUDE;C:\SC\INCLUDE
#    set LIB=.;C:\ZINC\LIB\sccpp600;C:\SC\LIB

## Compiler and linker: (Add -g to CPP_OPTS and /CO to LINK_OPTS for debug.)

# ----- DOS compiler options ------------------------------------------------
DOS_CPP=sc
DOS_LINK=link
DOS_CPP_OPTS=-c -a1 -ml -o+space
DOS_LINK_OPTS=/NOI /SEG:300
DOS_OBJS=
DOS_LIBS=dos_zil dos_gfx sc_lgfx

.c.obj:
	$(DOS_CPP) $(DOS_CPP_OPTS) $<

.cpp.obj:
	$(DOS_CPP) $(DOS_CPP_OPTS) $<

# ----- DOS Overlay (VCM) compiler options ----------------------------------
OVL_CPP=sc
OVL_LINK=link
OVL_CPP_OPTS=-c -a1 -mv -o+space -R
OVL_LINK_OPTS=/NOI /F /PAC
OVL_OBJS=
OVL_LIBS=dos_zilv dos_gfxv sc_lgfxv

.c.ovl:
	$(OVL_CPP) $(OVL_CPP_OPTS) -o$*.ovl $<

.cpp.ovl:
	$(OVL_CPP) $(OVL_CPP_OPTS) -o$*.ovl $<

# ----- DOS extender compiler options ---------------------------------------
D32_CPP=sc
D32_LINK=link
D32_CPP_OPTS=-c -bx -mx -D$(FONT)
D32_LINK_OPTS=/NOI
D32_LIB_OPTS=/C /N /B
D32_OBJS=cx
D32_LIBS=d32_zil d32_gfx sc_32gfx

.cpp.o32:
	$(D32_CPP) $(D32_CPP_OPTS) -o$@ $<

.c.o32:
	$(D32_CPP) $(D32_CPP_OPTS) -o$@ $<

# ----- Windows compiler options --------------------------------------------
WIN_CPP=sc
WIN_LINK=link
WIN_RC=rc

WIN_CPP_OPTS=-c -a1 -bx -ml -W2
WIN_RC_OPTS=-k
WIN_LINK_OPTS=/NOI
WIN_OBJS=
WIN_LIBS=win_zil libw

.c.obw:
	$(WIN_CPP) $(WIN_CPP_OPTS) -o$*.obw $<

.cpp.obw:
	$(WIN_CPP) $(WIN_CPP_OPTS) -o$*.obw $<


# ----- Usage ---------------------------------------------------------------
usage:
	@echo ...........
	@echo ...........
	@echo To make this Zinc tutorial for Symantec C++ type:
	@echo make -fsccpp600.mak dos
	@echo make -fsccpp600.mak dosovl
	@echo make -fsccpp600.mak dos32
	@echo make -fsccpp600.mak windows
	@echo ...........
	@echo ...........

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

# ----- Windows -------------------------------------------------------------
windows: wmovie.exe wmovie1.exe wmovie2.exe wmovie3.exe wmovie4.exe wmovie5.exe wmovie6.exe wmovie7.exe

wmovie.exe: movie.obw p_movie.obw
	$(WIN_LINK) $(WIN_LINK_OPTS) $(WIN_OBJS)+movie.obw+p_movie.obw,$*,NUL,$(WIN_LIBS),wmovie.def
	$(WIN_RC) $(WIN_RC_OPTS) wmovie.rc $*.exe

wmovie1.exe: movie1.obw p_movie1.obw
	$(WIN_LINK) $(WIN_LINK_OPTS) $(WIN_OBJS)+movie1.obw+p_movie1.obw,$*,NUL,$(WIN_LIBS),wmovie.def
	$(WIN_RC) $(WIN_RC_OPTS) wmovie.rc $*.exe

wmovie2.exe: movie2.obw p_movie2.obw
	$(WIN_LINK) $(WIN_LINK_OPTS) $(WIN_OBJS)+movie2.obw+p_movie2.obw,$*,NUL,$(WIN_LIBS),wmovie.def
	$(WIN_RC) $(WIN_RC_OPTS) wmovie.rc $*.exe

wmovie3.exe: movie3.obw p_movie3.obw
	$(WIN_LINK) $(WIN_LINK_OPTS) $(WIN_OBJS)+movie3.obw+p_movie3.obw,$*,NUL,$(WIN_LIBS),wmovie.def
	$(WIN_RC) $(WIN_RC_OPTS) wmovie.rc $*.exe

wmovie4.exe: movie4.obw p_movie4.obw
	$(WIN_LINK) $(WIN_LINK_OPTS) $(WIN_OBJS)+movie4.obw+p_movie4.obw,$*,NUL,$(WIN_LIBS),wmovie.def
	$(WIN_RC) $(WIN_RC_OPTS) wmovie.rc $*.exe

wmovie5.exe: movie5.obw p_movie5.obw
	$(WIN_LINK) $(WIN_LINK_OPTS) $(WIN_OBJS)+movie5.obw+p_movie5.obw,$*,NUL,$(WIN_LIBS),wmovie.def
	$(WIN_RC) $(WIN_RC_OPTS) wmovie.rc $*.exe

wmovie6.exe: movie6.obw p_movie6.obw
	$(WIN_LINK) $(WIN_LINK_OPTS) $(WIN_OBJS)+movie6.obw+p_movie6.obw,$*,NUL,$(WIN_LIBS),wmovie.def
	$(WIN_RC) $(WIN_RC_OPTS) wmovie.rc $*.exe

wmovie7.exe: movie7.obw p_movie7.obw
	$(WIN_LINK) $(WIN_LINK_OPTS) $(WIN_OBJS)+movie7.obw+p_movie7.obw,$*,NUL,$(WIN_LIBS),wmovie.def
	$(WIN_RC) $(WIN_RC_OPTS) wmovie.rc $*.exe
