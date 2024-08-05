# ----- General Definitions -------------------------------------------------
VERSION=iccpp210

# ----- OS/2 compiler options -----------------------------------------------
OS2_CPP=icc
OS2_LINK=link386
OS2_LIBRARIAN=lib
OS2_RC=rc

OS2_CPP_OPTS=/c /D__OS2__ /O+
OS2_LINK_OPTS=/NOE /NOI /BASE:0x10000 /PM:PM
OS2_LIB_OPTS=
OS2_RC_OPTS=

OS2_OBJS=
OS2_LIBS=os2_zil.lib

.SUFFIXES : .cpp

.cpp.obj:
	$(OS2_CPP) $(OS2_CPP_OPTS) $<

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean
#	----- Level 1 Applications -----
	@cd service
	nmake -f iccpp210.mak clean
	@cd ..
#	----- Level 2 Applications -----
	@cd direct
	nmake -f iccpp210.mak clean
	@cd ..
	@cd storage
	nmake -f iccpp210.mak clean
	@cd ..
	@cd stredit
	nmake -f iccpp210.mak clean
	@cd ..
#	----- Level 3 Applications -----
	@cd help
	nmake -f iccpp210.mak clean
	@cd ..
	@cd message
	nmake -f iccpp210.mak clean
	@cd ..
	@cd image
	nmake -f iccpp210.mak clean
	@cd ..
	@cd window
	nmake -f iccpp210.mak clean
	@cd ..
	@cd i18n
	nmake -f iccpp210.mak clean
	@cd ..
	@cd file
	nmake -f iccpp210.mak clean
	@cd ..

# ----- OS/2 ----------------------------------------------------------------
os2: odesign.exe
	copy odesign.exe ..\bin

odesign.exe: nmake_os2_modules main.obj
	$(OS2_LINK) $(OS2_LINK_OPTS) @<<zil.rsp
$(OS2_OBJS)+main.obj
$*,NUL,owindow ohelp omessage oimage ostorage odirect ostredit oservice oi18n ofile $(OS2_LIBS),odesign.def
<<
	$(OS2_RC) $(OS2_RC_OPTS) odesign.rc $*.exe

nmake_os2_modules:
#	----- Level 1 Applications -----
	@cd service
	nmake -f iccpp210.mak oservice.lib
	@cd ..
#	----- Level 2 Applications -----
	@cd direct
	nmake -f iccpp210.mak odirect.lib
	@cd ..
	@cd storage
	nmake -f iccpp210.mak ostorage.lib
	@cd ..
	@cd stredit
	nmake -f iccpp210.mak ostredit.lib
	@cd ..
#	----- Level 3 Applications -----
	@cd help
	nmake -f iccpp210.mak ohelp.lib
	@cd ..
	@cd message
	nmake -f iccpp210.mak omessage.lib
	@cd ..
	@cd image
	nmake -f iccpp210.mak oimage.lib
	@cd ..
	@cd window
	nmake -f iccpp210.mak owindow.lib
	@cd ..
	@cd i18n
	nmake -f iccpp210.mak oi18n.lib
	@cd ..
	@cd file
	nmake -f iccpp210.mak ofile.lib
	@cd ..
