# ----- General Definitions -------------------------------------------------
VERSION=bccpp200

# ----- OS/2 compiler options -----------------------------------------------
OS2_CPP=bcc
OS2_LINK=tlink
OS2_LIBRARIAN=tlib
OS2_RC=rc

OS2_CPP_OPTS=-c
OS2_LINK_OPTS=/c /B:0x10000 /aa
#OS2_CPP_OPTS=-c -v
#OS2_LINK_OPTS=/c /B:0x10000 /v /aa
OS2_LIB_OPTS=
OS2_RC_OPTS=

OS2_OBJS=c02.obj
OS2_LIBS=os2_zil.lib os2.lib c2.lib

.cpp.obo:
	$(OS2_CPP) $(OS2_CPP_OPTS) -o$*.obo {$< }

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean
#	----- Level 1 Applications -----
	@cd service
	make -fbccpp200.mak clean
	@cd ..
#	----- Level 2 Applications -----
	@cd storage
	make -fbccpp200.mak clean
	@cd ..
	@cd direct
	make -fbccpp200.mak clean
	@cd ..
	@cd stredit
	make -fbccpp200.mak clean
	@cd ..
#	----- Level 3 Applications -----
	@cd help
	make -fbccpp200.mak clean
	@cd ..
	@cd message
	make -fbccpp200.mak clean
	@cd ..
	@cd image
	make -fbccpp200.mak clean
	@cd ..
	@cd window
	make -fbccpp200.mak clean
	@cd ..
	@cd i18n
	make -fbccpp200.mak clean
	@cd ..
	@cd file
	make -fbccpp200.mak clean
	@cd ..

# ----- OS/2 ----------------------------------------------------------------
os2: odesign.exe
	copy odesign.exe ..\bin

odesign.exe: make_os2_modules main.obo
	$(OS2_LINK) $(OS2_LINK_OPTS) @&&!
$(OS2_OBJS)+main.obo
$*, , owindow ohelp omessage oimage ostorage odirect ostredit oservice oi18n ofile $(OS2_LIBS), odesign.def
!
	$(OS2_RC) $(OS2_RC_OPTS) odesign.rc $<

make_os2_modules:
#	----- Level 1 Applications -----
	@cd service
	make -fbccpp200.mak oservice.lib
	@cd ..
#	----- Level 2 Applications -----
	@cd storage
	make -fbccpp200.mak ostorage.lib
	@cd ..
	@cd direct
	make -fbccpp200.mak odirect.lib
	@cd ..
	@cd stredit
	make -fbccpp200.mak ostredit.lib
	@cd ..
#	----- Level 3 Applications -----
	@cd help
	make -fbccpp200.mak ohelp.lib
	@cd ..
	@cd message
	make -fbccpp200.mak omessage.lib
	@cd ..
	@cd image
	make -fbccpp200.mak oimage.lib
	@cd ..
	@cd window
	make -fbccpp200.mak owindow.lib
	@cd ..
	@cd i18n
	make -fbccpp200.mak oi18n.lib
	@cd ..
	@cd file
	make -fbccpp200.mak ofile.lib
	@cd ..
