# HELLO tutorial makefile

#    nmake -f mscpp800.mak winnt       (makes all the Windows hello tutorials)

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
winnt: nhello1.exe nhello2.exe nhello3.exe nhellog.exe

nhello1.exe: hello1.obn
	$(WNT_LINK) $(WNT_LINK_OPTS) -out:nhello1.exe $(WNT_OBJS) hello1.obn $(WNT_LIBS)

nhello2.exe: hello2.obn
	$(WNT_LINK) $(WNT_LINK_OPTS) -out:nhello2.exe $(WNT_OBJS) hello2.obn $(WNT_LIBS)

nhello3.exe: hello3.obn hello.obn
	$(WNT_LINK) $(WNT_LINK_OPTS) -out:nhello3.exe $(WNT_OBJS) hello3.obn hello.obn $(WNT_LIBS)

nhellog.exe: hellog.obn
	$(WNT_LINK) $(WNT_LINK_OPTS) -out:nhellog.exe $(WNT_OBJS) hellog.obn $(WNT_LIBS)

