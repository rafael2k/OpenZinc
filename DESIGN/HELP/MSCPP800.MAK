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
winnt: nhlpedit.exe
	copy nhlpedit.exe ..\..\bin

nhlpedit.exe: main.obn nhelp.lib
	$(link) $(linkdebug) $(guiflags) main.obn $(guilibs) VERSION.LIB nhelp.lib nstredit.lib nstorage.lib ndirect.lib nservice.lib $(WNT_ZINC_LIBS) -out:$*.exe

nhelp.lib : help.obn help1.obn import.obn export.obn
	-@del whelp.lib
	$(implib) /out:$*.lib $(WNT_LIB_OPTS) @<<zil.rsp
help.obn
help1.obn
import.obn
export.obn
<<
	copy help.hpp ..\..\include
	copy nhelp.lib ..\..\lib\$(VERSION)
	copy p_help.dat ..\..\bin\p_help.znc

