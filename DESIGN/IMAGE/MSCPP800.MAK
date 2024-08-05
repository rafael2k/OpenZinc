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
winnt: nimgedit.exe
	copy nimgedit.exe ..\..\bin

nimgedit.exe: main.obn nimage.lib
	$(link) $(linkdebug) $(guiflags) main.obn $(guilibs) VERSION.LIB nimage.lib nstredit.lib nstorage.lib ndirect.lib nservice.lib $(WNT_ZINC_LIBS) -out:$*.exe

nimage.lib : odib.obn odib1.obn odib2.obn \
	wdib.obn wdib1.obn wdib2.obn \
	wico.obn wico1.obn wico2.obn \
	xpm.obn xpm1.obn xpm2.obn \
	znc1.obn znc2.obn \
	image.obn image1.obn image2.obn color.obn draw.obn \
	export.obn import.obn \
	w_image.obn
	del nimage.lib
	$(implib) /out:$*.lib $(WNT_LIB_OPTS) @<<zil.rsp
odib.obn
odib1.obn
odib2.obn
wdib.obn
wdib1.obn
wdib2.obn
wico.obn
wico1.obn
wico2.obn
xpm.obn
xpm1.obn
xpm2.obn
znc1.obn
znc2.obn
image.obn
image1.obn
image2.obn
color.obn
draw.obn
w_image.obn
export.obn
import.obn
<<
	copy image.hpp ..\..\include
	copy nimage.lib ..\..\lib\$(VERSION)
	copy p_image.dat ..\..\bin\p_image.znc

