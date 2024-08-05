# WORD tutorial makefile

#    nmake -f mscpp800.mak winnt       (makes all the Windows word tutorials)

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
winnt: nword2.exe nword3.exe

nword2.exe: word2.obn
	$(WNT_LINK) $(WNT_LINK_OPTS) -out:nword2.exe $(WNT_OBJS) word2.obn $(WNT_LIBS)

nword3.exe: word3.obn word_win.obn
	$(WNT_LINK) $(WNT_LINK_OPTS) -out:nword3.exe $(WNT_OBJS) word3.obn word_win.obn $(WNT_LIBS)


