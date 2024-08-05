# ----- General Definitions -------------------------------------------------
VERSION=mscpp800

.SUFFIXES : .c .cpp .obj .o16 .o32 .obw .obn
# ----- Windows NT compiler options -----------------------------------------
# for debug:    comment out next line
NODEBUG=1
!include <NTWIN32.MAK>

WNT_ZINC_LIBS=wnt_zil.lib
WNT_LIB_OPTS=/MACHINE:ALPHA /SUBSYSTEM:WINDOWS

.cpp.obn:
	$(cc) $(cflags) $(cvars) $(cdebug) -Fo$*.obn $<

.rc.rbj:
    $(rc) $(rcvars) -r -fo $*.rbj $(cvars) $<

# ----- Usage --------------------------------------------------------------
usage:
	@echo ...........
	@echo ...........
	@echo To generate the library modules for specific environments type:
	@echo nmake -f mvcpp800.mak winnt
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean.bat

# ----- Windows NT Libraries and Programs -----------------------------------
winnt: ntest.exe

ntest.exe: main.obn ndirect.lib
	$(link) $(linkdebug) $(guiflags) main.obn $(guilibs) VERSION.LIB ndirect.lib nservice.lib $(WNT_ZINC_LIBS) -out:$*.exe

ndirect.lib : w_direct.obn
	-@del ndirect.lib
	$(implib) /out:$*.lib $(WNT_LIB_OPTS) @<<zil.rsp
w_direct.obn
<<
	copy direct.hpp ..\..\include
	copy ndirect.lib ..\..\lib\$(VERSION)
	copy p_direct.dat ..\..\bin\p_direct.znc


