# INTERPOL tutorial makefile

#    nmake -f mscpp800.mak winnt       (makes all the Windows intrpol tutorials)

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
winnt: nintrpo1.exe nintrpo2.exe

nintrpo1.exe: intrpol1.obn ipolwin1.obn
	$(WNT_LINK) $(WNT_LINK_OPTS) -out:nintrpo1.exe $(WNT_OBJS) intrpol1.obn ipolwin1.obn $(WNT_LIBS)

nintrpo2.exe: intrpol2.obn ipolwin2.obn
	$(WNT_LINK) $(WNT_LINK_OPTS) -out:nintrpo2.exe $(WNT_OBJS) intrpol2.obn ipolwin2.obn $(WNT_LIBS)


