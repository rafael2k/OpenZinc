# MOVIE tutorial makefile

#    nmake -f iccpp210.mak os2	(makes all the OS/2 movie tutorials)

# ----- OS/2 compiler options -----------------------------------------------
OS2_CPP=icc
OS2_LINK=link386
OS2_LIBRARIAN=lib
OS2_RC=rc

OS2_CPP_OPTS=/c /D__OS2__ /O+
OS2_LINK_OPTS=/NOE /NOI /BASE:0x10000 /PM:PM
OS2_LIB_OPTS=
OS2_RC_OPTS=

OS2_OBJS=
OS2_LIBS=os2_zil.lib

.SUFFIXES : .cpp

.c.obj:
	$(OS2_CPP) $(OS2_CPP_OPTS) $<

.cpp.obj:
	$(OS2_CPP) $(OS2_CPP_OPTS) $<

# ----- Usage --------------------------------------------------------------
usage:
	@echo ...........
	@echo ...........
	@echo To make this Zinc tutorial for IBM C++ type:
	@echo nmake -f iccpp210.mak os2
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean.cmd

# ----- OS/2 ----------------------------------------------------------------
os2: omovie.exe omovie1.exe omovie2.exe omovie3.exe omovie4.exe omovie5.exe omovie6.exe omovie7.exe 

omovie.exe: movie.obj p_movie.obj
	$(OS2_LINK) $(OS2_LINK_OPTS) @<<zil.rsp
$(OS2_OBJS)+movie.obj+p_movie.obj
$*,NUL,$(OS2_LIBS),omovie.def
<<
	$(OS2_RC) $(OS2_RC_OPTS) omovie.rc $*.exe

omovie1.exe: movie1.obj p_movie1.obj
	$(OS2_LINK) $(OS2_LINK_OPTS) @<<zil.rsp
$(OS2_OBJS)+movie1.obj+p_movie1.obj
$*,NUL,$(OS2_LIBS),omovie.def
<<
	$(OS2_RC) $(OS2_RC_OPTS) omovie.rc $*.exe

omovie2.exe: movie2.obj p_movie2.obj
	$(OS2_LINK) $(OS2_LINK_OPTS) @<<zil.rsp
$(OS2_OBJS)+movie2.obj+p_movie2.obj
$*,NUL,$(OS2_LIBS),omovie.def
<<
	$(OS2_RC) $(OS2_RC_OPTS) omovie.rc $*.exe

omovie3.exe: movie3.obj p_movie3.obj
	$(OS2_LINK) $(OS2_LINK_OPTS) @<<zil.rsp
$(OS2_OBJS)+movie3.obj+p_movie3.obj
$*,NUL,$(OS2_LIBS),omovie.def
<<
	$(OS2_RC) $(OS2_RC_OPTS) omovie.rc $*.exe

omovie4.exe: movie4.obj p_movie4.obj
	$(OS2_LINK) $(OS2_LINK_OPTS) @<<zil.rsp
$(OS2_OBJS)+movie4.obj+p_movie4.obj
$*,NUL,$(OS2_LIBS),omovie.def
<<
	$(OS2_RC) $(OS2_RC_OPTS) omovie.rc $*.exe

omovie5.exe: movie5.obj p_movie5.obj
	$(OS2_LINK) $(OS2_LINK_OPTS) @<<zil.rsp
$(OS2_OBJS)+movie5.obj+p_movie5.obj
$*,NUL,$(OS2_LIBS),omovie.def
<<
	$(OS2_RC) $(OS2_RC_OPTS) omovie.rc $*.exe

omovie6.exe: movie6.obj p_movie6.obj
	$(OS2_LINK) $(OS2_LINK_OPTS) @<<zil.rsp
$(OS2_OBJS)+movie6.obj+p_movie6.obj
$*,NUL,$(OS2_LIBS),omovie.def
<<
	$(OS2_RC) $(OS2_RC_OPTS) omovie.rc $*.exe

omovie7.exe: movie7.obj p_movie7.obj
	$(OS2_LINK) $(OS2_LINK_OPTS) @<<zil.rsp
$(OS2_OBJS)+movie7.obj+p_movie7.obj
$*,NUL,$(OS2_LIBS),omovie.def
<<
	$(OS2_RC) $(OS2_RC_OPTS) omovie.rc $*.exe
