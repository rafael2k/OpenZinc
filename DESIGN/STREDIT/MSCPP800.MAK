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
	@echo nmake -f mscpp800.mak winnt
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean.bat

# ----- Windows NT Libraries and Programs -----------------------------------
winnt: nstredit.exe

nstredit.exe: main.obn nstredit.lib
	$(link) $(linkdebug) $(guiflags) main.obn $(guilibs) VERSION.LIB nstredit.lib nservice.lib $(WNT_ZINC_LIBS) -out:$*.exe

nstredit.lib : stredit.obn
	-@del nstredit.lib
	$(implib) /out:$*.lib $(WNT_LIB_OPTS) @<<zil.rsp
stredit.obn
<<
	copy stredit.hpp ..\..\include
	copy nstredit.lib ..\..\lib\$(VERSION)
	copy p_string.dat ..\..\bin\p_string.znc

