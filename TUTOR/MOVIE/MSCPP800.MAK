# MOVIE tutorial makefile

#    nmake -f mscpp800.mak winnt       (makes all the Windows movie tutorials)

# Be sure to set the LIB and INCLUDE environment variables for Zinc, e.g.:
#    set INCLUDE=.;C:\ZINC\INCLUDE;C:\MSTOOLS\H
#    set LIB=.;C:\ZINC\LIB\MSCPP800;C:\MSTOOLS\LIB

# ----- Windows NT compiler options -----------------------------------------
# for debug:    comment out next line
NODEBUG=1
!include <NTWIN32.MAK>

WNT_LIBS=$(guilibs) VERSION.LIB wnt_zil.lib
WNT_LINK=$(link)
WNT_LINK_OPTS=$(linkdebug) $(guiflags)

.cpp.obn:
	$(cc) $(cflags) $(cvars) $(cdebug) -Fo$*.obn $<

# ----- Usage --------------------------------------------------------------
usage:
	@echo ...........
	@echo ...........
	@echo To make this Zinc tutorial for Visual C++ type:
	@echo nmake -f mscpp800.mak winnt
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean

# ----- Windows NT ----------------------------------------------------------
winnt: nmovie.exe nmovie1.exe nmovie2.exe nmovie3.exe nmovie4.exe nmovie5.exe nmovie6.exe nmovie7.exe

nmovie.exe: movie.obn p_movie.obn
	$(WNT_LINK) $(WNT_LINK_OPTS) -out:nmovie.exe $(WNT_OBJS) movie.obn p_movie.obn $(WNT_LIBS)

nmovie1.exe: movie1.obn p_movie1.obn
	$(WNT_LINK) $(WNT_LINK_OPTS) -out:nmovie1.exe $(WNT_OBJS) movie1.obn p_movie1.obn $(WNT_LIBS)

nmovie2.exe: movie2.obn p_movie2.obn
	$(WNT_LINK) $(WNT_LINK_OPTS) -out:nmovie2.exe $(WNT_OBJS) movie2.obn p_movie2.obn $(WNT_LIBS)

nmovie3.exe: movie3.obn p_movie3.obn
	$(WNT_LINK) $(WNT_LINK_OPTS) -out:nmovie3.exe $(WNT_OBJS) movie3.obn p_movie3.obn $(WNT_LIBS)

nmovie4.exe: movie4.obn p_movie4.obn
	$(WNT_LINK) $(WNT_LINK_OPTS) -out:nmovie4.exe $(WNT_OBJS) movie4.obn p_movie4.obn $(WNT_LIBS)

nmovie5.exe: movie5.obn p_movie5.obn
	$(WNT_LINK) $(WNT_LINK_OPTS) -out:nmovie5.exe $(WNT_OBJS) movie5.obn p_movie5.obn $(WNT_LIBS)

nmovie6.exe: movie6.obn p_movie6.obn
	$(WNT_LINK) $(WNT_LINK_OPTS) -out:nmovie6.exe $(WNT_OBJS) movie6.obn p_movie6.obn $(WNT_LIBS)

nmovie7.exe: movie7.obn p_movie7.obn
	$(WNT_LINK) $(WNT_LINK_OPTS) -out:nmovie7.exe $(WNT_OBJS) movie7.obn p_movie7.obn $(WNT_LIBS)


