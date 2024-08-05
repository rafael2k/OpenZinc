# VLIST tutorial makefile

#    nmake -f mscpp800.mak winnt       (makes all the Windows vlist tutorials)

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
winnt: nvlist.exe

nvlist.exe: vlist.obn g_jump.obn
	$(WNT_LINK) $(WNT_LINK_OPTS) -out:nvlist.exe $(WNT_OBJS) vlist.obn g_jump.obn $(WNT_LIBS)

