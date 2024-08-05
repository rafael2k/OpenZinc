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
winnt: nmsgedit.exe
	copy nmsgedit.exe ..\..\bin

nmsgedit.exe: main.obn nmessage.lib
	$(link) $(linkdebug) $(guiflags) main.obn $(guilibs) VERSION.LIB nmessage.lib nstredit.lib nstorage.lib ndirect.lib nservice.lib $(WNT_ZINC_LIBS) -out:$*.exe

nmessage.lib : message.obn message1.obn prefer.obn \
	import.obn export.obn
	-@del nmessage.lib
	$(implib) /out:$*.lib $(WNT_LIB_OPTS) @<<zil.rsp
message.obn
message1.obn
prefer.obn
import.obn
export.obn
<<
	copy message.hpp ..\..\include
	copy nmessage.lib ..\..\lib\$(VERSION)
	copy p_messag.dat ..\..\bin\p_messag.znc

