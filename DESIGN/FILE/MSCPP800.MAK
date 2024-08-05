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

# ----- Copy files ----------------------------------------------------------
copy:
	copy ui_*.hpp ..\include
	copy z_clean.* ..\bin

# ----- Windows NT Libraries and Programs -----------------------------------
winnt: nfile.exe
	copy nfile.exe ..\..\bin

nfile.exe: main.obn nfile.lib
	$(link) $(linkdebug) $(guiflags) main.obn $(guilibs) VERSION.LIB nstorage.lib nstredit.lib nfile.lib ndirect.lib nservice.lib $(WNT_ZINC_LIBS) -out:$*.exe


nfile.lib : file.obn
	-@del nfile.lib
	$(implib) /out:$*.lib $(WNT_LIB_OPTS) @<<zil.rsp
file.obn
<<
	copy file.hpp ..\..\include
	copy nfile.lib ..\..\lib\$(VERSION)
	copy p_file.dat ..\..\bin\p_file.znc
