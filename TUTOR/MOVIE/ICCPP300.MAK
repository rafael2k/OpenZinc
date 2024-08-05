# MOVIE tutorial makefile

#    make -f iccpp300.mak os2             (makes all the OS/2 movie tutorials)

# Be sure to update your INCLUDE and LIB to include the Zinc paths, e.g.:
#   set INCLUDE=%INCLUDE%;;C:\ZINC\INCLUDE
#   set LIB=%LIB%;C:\ZINC\LIB\ICCPP300

## Compiler and linker: (Add /Ti+ to CPP_OPTS and /DE[BUG] to LINK_OPTS for debug.)

# ----- OS/2 compiler options -----------------------------------------------
OS2_CPP=icc
OS2_LINK=ilink
OS2_RC=rc

OS2_CPP_OPTS=/c /D__OS2__ /Gx+ /Sp1
OS2_LINK_OPTS=/NOE /NOI /BASE:0x10000 /PM:PM
OS2_LIB_OPTS=
OS2_RC_OPTS=

OS2_OBJS=
OS2_LIBS=os2_zil.lib

.SUFFIXES : .cpp

.cpp.obo:
	$(OS2_CPP) $(OS2_CPP_OPTS) /Fo$*.obo $<

# ----- Usage --------------------------------------------------------------
usage:
	@echo ...........
	@echo ...........
	@echo To make this Zinc example for IBM C++ type:
	@echo nmake -f iccpp300.mak os2
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean.cmd

# ----- OS/2 ----------------------------------------------------------------
os2: omovie.exe omovie1.exe omovie2.exe omovie3.exe omovie4.exe omovie5.exe omovie6.exe omovie7.exe

omovie.exe: movie.obo p_movie.obo
	$(OS2_LINK) /OUT:$*.exe $(OS2_LINK_OPTS) $(OS2_OBJS) movie.obo p_movie.obo $(OS2_LIBS) omovie.def
	$(OS2_RC) $(OS2_RC_OPTS) omovie.rc $*.exe

omovie1.exe: movie1.obo p_movie1.obo
	$(OS2_LINK) /OUT:$*.exe $(OS2_LINK_OPTS) $(OS2_OBJS) movie1.obo p_movie1.obo $(OS2_LIBS) omovie.def
	$(OS2_RC) $(OS2_RC_OPTS) omovie.rc $*.exe

omovie2.exe: movie2.obo p_movie2.obo
	$(OS2_LINK) /OUT:$*.exe $(OS2_LINK_OPTS) $(OS2_OBJS) movie2.obo p_movie2.obo $(OS2_LIBS) omovie.def
	$(OS2_RC) $(OS2_RC_OPTS) omovie.rc $*.exe

omovie3.exe: movie3.obo p_movie3.obo
	$(OS2_LINK) /OUT:$*.exe $(OS2_LINK_OPTS) $(OS2_OBJS) movie3.obo p_movie3.obo $(OS2_LIBS) omovie.def
	$(OS2_RC) $(OS2_RC_OPTS) omovie.rc $*.exe

omovie4.exe: movie4.obo p_movie4.obo
	$(OS2_LINK) /OUT:$*.exe $(OS2_LINK_OPTS) $(OS2_OBJS) movie4.obo p_movie4.obo $(OS2_LIBS) omovie.def
	$(OS2_RC) $(OS2_RC_OPTS) omovie.rc $*.exe

omovie5.exe: movie5.obo p_movie5.obo
	$(OS2_LINK) /OUT:$*.exe $(OS2_LINK_OPTS) $(OS2_OBJS) movie5.obo p_movie5.obo $(OS2_LIBS) omovie.def
	$(OS2_RC) $(OS2_RC_OPTS) omovie.rc $*.exe

omovie6.exe: movie6.obo p_movie6.obo
	$(OS2_LINK) /OUT:$*.exe $(OS2_LINK_OPTS) $(OS2_OBJS) movie6.obo p_movie6.obo $(OS2_LIBS) omovie.def
	$(OS2_RC) $(OS2_RC_OPTS) omovie.rc $*.exe

omovie7.exe: movie7.obo p_movie7.obo
	$(OS2_LINK) /OUT:$*.exe $(OS2_LINK_OPTS) $(OS2_OBJS) movie7.obo p_movie7.obo $(OS2_LIBS) omovie.def
	$(OS2_RC) $(OS2_RC_OPTS) omovie.rc $*.exe
