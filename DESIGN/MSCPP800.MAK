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
	z_clean
#	----- Level 1 Applications -----
	@cd service
	nmake -f$(VERSION).mak clean
	@cd ..
#	----- Level 2 Applications -----
	@cd storage
	nmake -f$(VERSION).mak clean
	@cd ..
	@cd direct
	nmake -f$(VERSION).mak clean
	@cd ..
	@cd stredit
	nmake -f$(VERSION).mak clean
	@cd ..
#	----- Level 3 Applications -----
	@cd help
	nmake -f$(VERSION).mak clean
	@cd ..
	@cd message
	nmake -f$(VERSION).mak clean
	@cd ..
	@cd image
	nmake -f$(VERSION).mak clean
	@cd ..
	@cd i18n
	nmake -f$(VERSION).mak clean
	@cd ..
	@cd file
	nmake -f$(VERSION).mak clean
	@cd ..
	@cd window
	nmake -f$(VERSION).mak clean
	@cd ..

# ----- Windows NT Libraries and Programs -----------------------------------
winnt: ndesign.exe
	copy ndesign.exe ..\bin

ndesign.exe: make_winnt_modules main.obn wdesign.rbj
	$(link) $(linkdebug) $(guiflags) main.obn $(guilibs) VERSION.LIB \
		ni18n.lib nwindow.lib nhelp.lib nmessage.lib nimage.lib \
		nstorage.lib ndirect.lib nstredit.lib nservice.lib $(WNT_ZINC_LIBS) \
		wdesign.rbj -out:$*.exe

make_winnt_modules:
#	----- Level 1 Applications -----
	@cd service
	nmake -f mscpp800.mak nservice.lib
	@cd ..
#	----- Level 2 Applications -----
	@cd storage
	nmake -f mscpp800.mak nstorage.lib
	@cd ..
	@cd direct
	nmake -f mscpp800.mak ndirect.lib
	@cd ..
	@cd stredit
	nmake -f mscpp800.mak nstredit.lib
	@cd ..
#	----- Level 3 Applications -----
	@cd help
	nmake -f mscpp800.mak nhelp.lib
	@cd ..
	@cd message
	nmake -f mscpp800.mak nmessage.lib
	@cd ..
	@cd image
	nmake -f mscpp800.mak nimage.lib
	@cd ..
	@cd i18n
	nmake -f mscpp800.mak ni18n.lib
	@cd ..
	@cd file
	nmake -f mscpp800.mak nfile.lib
	@cd ..
	@cd window
	nmake -f mscpp800.mak nwindow.lib
	@cd ..

