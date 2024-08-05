# ----- General Definitions -------------------------------------------------
VERSION=iccpp300

# ----- OS/2 compiler options -----------------------------------------------
OS2_CPP=icc
OS2_LINK=ilink
OS2_RC=rc

OS2_CPP_OPTS=/c /D__OS2__ /Gx+ /Sp
OS2_LINK_OPTS=/OUT:odesign /NOE /NOI /BASE:0x10000 /PM:PM
OS2_LIB_OPTS=
OS2_RC_OPTS=

OS2_OBJS=
OS2_LIBS=os2_zil.lib owindow.lib ohelp.lib omessage.lib oimage.lib ostorage.lib odirect.lib ostredit.lib oservice.lib oi18n.lib ofile.lib

.SUFFIXES : .cpp

.cpp.obj:
	$(OS2_CPP) $(OS2_CPP_OPTS) $<

# ----- Usage --------------------------------------------------------------
usage:
	@echo ...........
	@echo ...........
	@echo To make this Zinc example for IBM C++ type:
	@echo nmake -f iccpp300.mak os2
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean
#	----- Level 1 Applications -----
	@cd service
	nmake -f iccpp300.mak clean
	@cd ..
#	----- Level 2 Applications -----
	@cd storage
	nmake -f iccpp300.mak clean
	@cd ..
	@cd direct
	nmake -f iccpp300.mak clean
	@cd ..
	@cd stredit
	nmake -f iccpp300.mak clean
	@cd ..
#	----- Level 3 Applications -----
	@cd help
	nmake -f iccpp300.mak clean
	@cd ..
	@cd message
	nmake -f iccpp300.mak clean
	@cd ..
	@cd image
	nmake -f iccpp300.mak clean
	@cd ..
	@cd window
	nmake -f iccpp300.mak clean
	@cd ..
	@cd i18n
	nmake -f iccpp300.mak clean
	@cd ..
	@cd file
	nmake -f iccpp300.mak clean
	@cd ..

# ----- OS/2 ----------------------------------------------------------------
os2: odesign.exe
	copy odesign.exe ..\bin

odesign.exe: make_os2_modules main.obj
	$(OS2_LINK) $(OS2_LINK_OPTS) $(OS2_OBJS) main.obj $(OS2_LIBS) odesign.def
	$(OS2_RC) $(OS2_RC_OPTS) odesign.rc $*.exe

make_os2_modules:
#	----- Level 1 Applications -----
	@cd service
	nmake -f iccpp300.mak oservice.lib
	@cd ..
#	----- Level 2 Applications -----
	@cd storage
	nmake -f iccpp300.mak ostorage.lib
	@cd ..
	@cd direct
	nmake -f iccpp300.mak odirect.lib
	@cd ..
	@cd stredit
	nmake -f iccpp300.mak ostredit.lib
	@cd ..
#	----- Level 3 Applications -----
	@cd help
	nmake -f iccpp300.mak ohelp.lib
	@cd ..
	@cd message
	nmake -f iccpp300.mak omessage.lib
	@cd ..
	@cd image
	nmake -f iccpp300.mak oimage.lib
	@cd ..
	@cd window
	nmake -f iccpp300.mak owindow.lib
	@cd ..
	@cd i18n
	nmake -f iccpp300.mak oi18n.lib
	@cd ..
	@cd file
	nmake -f iccpp300.mak ofile.lib
	@cd ..
