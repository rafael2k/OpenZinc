VERSION=sccpp600

# ----- DOS 16 bit extender (Rational DOS16M) compiler options --------------
# --- DOS ---
DOS_CPP=sc
DOS_LINK=link
DOS_LIBRARIAN=lib
DOS_CPP_OPTS=-c -a1 -bx -ml -o+space -R
DOS_LINK_OPTS=/NOI
DOS_LIB_OPTS=/N /B /NOI
DOS_OBJS=
DOS_LIBS=dos_zil dos_gfx sc_lgfx

.cpp.obj:
	$(DOS_CPP) $(DOS_CPP_OPTS) $<

# --- VROOM ---
OVL_CPP=sc
OVL_LINK=link
OVL_LIBRARIAN=lib
OVL_CPP_OPTS=-c -a1 -bx -mv -R
OVL_LINK_OPTS=/NOI /F /PAC
OVL_LIB_OPTS=/N /B /NOI
OVL_OBJS=
OVL_LIBS=dos_zilv dos_gfxv sc_lgfxv

.cpp.ovl:
	$(OVL_CPP) $(OVL_CPP_OPTS) -o$@ $<

# ----- DOS 32 bit extender (X-32VM) compiler options -----------------------
D32_CPP=sc
D32_LINK=link
D32_LIBRARIAN=lib
D32_CPP_OPTS=-c -bx -mx -R
D32_LINK_OPTS=/NOI
D32_LIB_OPTS=/N /B /NOI
D32_OBJS=cx
D32_LIBS=d32_zil d32_gfx sc_32gfx

.cpp.o32:
	$(D32_CPP) $(D32_CPP_OPTS) -o$@ $<

# ----- Windows compiler options --------------------------------------------
WIN_CPP=sc
WIN_LINK=link
WIN_LIBRARIAN=lib
WIN_RC=rc

WIN_CPP_OPTS=-c -a1 -bx -ml -W2 -R
WIN_RC_OPTS=-k
WIN_LINK_OPTS=/NOI /PACKC:42000
WIN_LIB_OPTS=/N /B

WIN_OBJS=
WIN_LIBS=wwindow whelp wi18n wmessage wimage wstorage wdirect wstredit wservice win_zil commdlg libw

.cpp.obw:
	$(WIN_CPP) $(WIN_CPP_OPTS) -o$@ $<

# ----- Usage --------------------------------------------------------------
usage:
	@echo ...........
	@echo ...........
	@echo To generate the library modules for specific environments type:
	@echo make -fsccpp600.mak dos32
	@echo make -fsccpp600.mak windows
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean
#	----- Level 1 Applications -----
	@cd service
	make -fsccpp600.mak clean
	@cd ..
#	----- Level 2 Applications -----
	@cd storage
	make -fsccpp600.mak clean
	@cd ..
	@cd direct
	make -fsccpp600.mak clean
	@cd ..
	@cd stredit
	make -fsccpp600.mak clean
	@cd ..
#	----- Level 3 Applications -----
	@cd help
	make -fsccpp600.mak clean
	@cd ..
	@cd message
	make -fsccpp600.mak clean
	@cd ..
	@cd image
	make -fsccpp600.mak clean
	@cd ..
	@cd i18n
	make -fsccpp600.mak clean
	@cd ..
	@cd file
	make -fsccpp600.mak clean
	@cd ..
	@cd window
	make -fsccpp600.mak clean
	@cd ..


doss:
#	----- Level 1 Applications -----
	@cd service
	make -fsccpp600.mak dos
	@cd ..
#	----- Level 2 Applications -----
	@cd storage
	make -fsccpp600.mak dos
	@cd ..
	@cd direct
	make -fsccpp600.mak dos
	@cd ..
	@cd stredit
	make -fsccpp600.mak dos
	@cd ..

# ----- DOS 32 bit extender (X-32VM) compiler options -----------------------
dos32: design32.exe
	copy design32.exe ..\bin

design32.exe: d32_mods main.o32
	$(D32_LINK) $(D32_LINK_OPTS) $(D32_OBJS)+main.o32, $*, , @d32_zil.rsp

d32_mods:
#	----- Level 1 Applications -----
	@cd service
	make -fsccpp600.mak service.lib
	@cd ..
#	----- Level 2 Applications -----
	@cd storage
	make -fsccpp600.mak storage.lib
	@cd ..
	@cd direct
	make -fsccpp600.mak direct.lib
	@cd ..
	@cd stredit
	make -fsccpp600.mak stredit.lib
	@cd ..
#	----- Level 3 Applications -----
	@cd help
	make -fsccpp600.mak help.lib
	@cd ..
	@cd message
	make -fsccpp600.mak message.lib
	@cd ..
	@cd image
	make -fsccpp600.mak image.lib
	@cd ..
	@cd i18n
	make -fsccpp600.mak i18n.lib
	@cd ..
	@cd file
	make -fsccpp600.mak file.lib
	@cd ..
	@cd window
	make -fsccpp600.mak window.lib
	@cd ..


# ----- Windows Libraries and Programs --------------------------------------

windows: wdesign.exe
	copy wdesign.exe ..\bin

wdesign.exe: win_mods main.obw
	$(WIN_LINK) $(WIN_LINK_OPTS) $(WIN_OBJS)+main.obw, $*, , @win_zil.rsp, wdesign.def
	$(WIN_RC) wdesign.rc $*.exe

win_mods:
#	----- Level 1 Applications -----
	@cd service
	make -fsccpp600.mak wservice.lib
	@cd ..
#	----- Level 2 Applications -----
	@cd storage
	make -fsccpp600.mak wstorage.lib
	@cd ..
	@cd direct
	make -fsccpp600.mak wdirect.lib
	@cd ..
	@cd stredit
	make -fsccpp600.mak wstredit.lib
	@cd ..
#	----- Level 3 Applications -----
	@cd help
	make -fsccpp600.mak whelp.lib
	@cd ..
	@cd message
	make -fsccpp600.mak wmessage.lib
	@cd ..
	@cd image
	make -fsccpp600.mak wimage.lib
	@cd ..
	@cd i18n
	make -fsccpp600.mak wi18n.lib
	@cd ..
	@cd file
	make -fsccpp600.mak wfile.lib
	@cd ..
	@cd window
	make -fsccpp600.mak wwindow.lib
	@cd ..

