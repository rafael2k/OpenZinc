VERSION=dm84

# ----- DOS 16 bit extender (Rational DOS16M) compiler options --------------
# --- DOS ---
DOS_CPP=dmc
DOS_LINK=link
DOS_LIBRARIAN=lib
DOS_CPP_OPTS=-c -a1 -ml -o+space -R
DOS_LINK_OPTS=/NOI
DOS_LIB_OPTS=/N /B /NOI
DOS_OBJS=
DOS_LIBS=dos_zil dos_gfx dm_lgfx

.cpp.obj:
	$(DOS_CPP) $(DOS_CPP_OPTS) $<

# --- VROOM ---
OVL_CPP=dmc
OVL_LINK=link
OVL_LIBRARIAN=lib
OVL_CPP_OPTS=-c -a1 -mv -R
OVL_LINK_OPTS=/NOI /F /PAC
OVL_LIB_OPTS=/N /B /NOI
OVL_OBJS=
OVL_LIBS=dos_zilv dos_gfxv dm_lgfxv

.cpp.ovl:
	$(OVL_CPP) $(OVL_CPP_OPTS) -o$@ $<

# ----- DOS 32 bit extender (X-32VM) compiler options -----------------------
D32_CPP=dmc
D32_LINK=link
D32_LIBRARIAN=lib
D32_CPP_OPTS=-c -mx -R
D32_LINK_OPTS=/NOI
D32_LIB_OPTS=/N /B /NOI
D32_OBJS=cx
D32_LIBS=d32_zil d32_gfx dm_32gfx x32

.cpp.o32:
	$(D32_CPP) $(D32_CPP_OPTS) -o$@ $<

# ----- Windows compiler options --------------------------------------------
WIN_CPP=dmc
WIN_LINK=link
WIN_LIBRARIAN=lib
WIN_RC=rc

WIN_CPP_OPTS=-c -a1 -ml -W2 -R
WIN_RC_OPTS=-k
WIN_LINK_OPTS=/NOI /PACKC:42000
WIN_LIB_OPTS=/N /B

WIN_OBJS=
WIN_LIBS=wwindow whelp wi18n wmessage wimage wstorage wdirect wstredit wservice win_zil commdlg libw

.cpp.obw:
	$(WIN_CPP) $(WIN_CPP_OPTS) -o$@ $<

# ----- Windows NT (and WIN32s) compiler options ----------------------------
WNT_CPP=dmc
WNT_LINK=link
WNT_LIBRARIAN=lib
WNT_RC=rc

WNT_CPP_OPTS=-c -4 -mn -WA
WNT_RC_OPTS=
WNT_LINK_OPTS=/NOI
WNT_LIB_OPTS=/N /B

WNT_OBJS=
WNT_LIBS=wnt_zil kernel32 user32 gdi32 ctl3d32 

.cpp.obn:
	$(WNT_CPP) $(WNT_CPP_OPTS) -o$@ $<

# ----- Windows 32 compiler options ----------------------------
W32_CPP=dmc
W32_LINK=link
W32_LIBRARIAN=lib
W32_RC=rc

W32_CPP_OPTS=-c -4 -mn -WA -DZIL_WIN32
W32_RC_OPTS=
W32_LINK_OPTS=/NOI
W32_LIB_OPTS=/N /B

W32_OBJS=
W32_LIBS=w32_zil kernel32 user32 gdi32 ctl3d32 comctl32 

.cpp.ob9:
	$(W32_CPP) $(W32_CPP_OPTS) -o$@ $<


# ----- Usage --------------------------------------------------------------
usage:
	@echo ...........
	@echo ...........
	@echo To generate the library modules for specific environments type:
	@echo make -fdm.mak dos32
	@echo make -fdm.mak windows
	@echo make -fdm.mak winnt
	@echo make -fdm.mak win32
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean
#	----- Level 1 Applications -----
	@cd service
	make -fdm.mak clean
	@cd ..
#	----- Level 2 Applications -----
	@cd storage
	make -fdm.mak clean
	@cd ..
	@cd direct
	make -fdm.mak clean
	@cd ..
	@cd stredit
	make -fdm.mak clean
	@cd ..
#	----- Level 3 Applications -----
	@cd help
	make -fdm.mak clean
	@cd ..
	@cd message
	make -fdm.mak clean
	@cd ..
	@cd image
	make -fdm.mak clean
	@cd ..
	@cd i18n
	make -fdm.mak clean
	@cd ..
	@cd file
	make -fdm.mak clean
	@cd ..
	@cd window
	make -fdm.mak clean
	@cd ..


doss:
#	----- Level 1 Applications -----
	@cd service
	make -fdm.mak dos
	@cd ..
#	----- Level 2 Applications -----
	@cd storage
	make -fdm.mak dos
	@cd ..
	@cd direct
	make -fdm.mak dos
	@cd ..
	@cd stredit
	make -fdm.mak dos
	@cd ..

# ----- DOS 32 bit extender (X-32VM) compiler options -----------------------
dos32: design32.exe
	copy design32.exe ..\bin

design32.exe: d32_mods main.o32
	$(D32_LINK) $(D32_LINK_OPTS) $(D32_OBJS)+main.o32, $*, ,@d32_zil.rsp

d32_mods:
#	----- Level 1 Applications -----
	@cd service
	make -fdm.mak service.lib
	@cd ..
#	----- Level 2 Applications -----
	@cd storage
	make -fdm.mak storage.lib
	@cd ..
	@cd direct
	make -fdm.mak direct.lib
	@cd ..
	@cd stredit
	make -fdm.mak stredit.lib
	@cd ..
#	----- Level 3 Applications -----
	@cd help
	make -fdm.mak help.lib
	@cd ..
	@cd message
	make -fdm.mak message.lib
	@cd ..
	@cd image
	make -fdm.mak image.lib
	@cd ..
	@cd i18n
	make -fdm.mak i18n.lib
	@cd ..
	@cd file
	make -fdm.mak file.lib
	@cd ..
	@cd window
	make -fdm.mak window.lib
	@cd ..


# ----- Windows Libraries and Programs --------------------------------------

windows: wdesign.exe
	copy wdesign.exe ..\bin

wdesign.exe: win_mods main.obw
	$(WIN_LINK) $(WIN_LINK_OPTS) $(WIN_OBJS)+main.obw, $*, , @win_zil.rsp, wdesign.def
	$(WIN_RC) wdesign.rc

win_mods:
#	----- Level 1 Applications -----
	@cd service
	make -fdm.mak wservice.lib
	@cd ..
#	----- Level 2 Applications -----
	@cd storage
	make -fdm.mak wstorage.lib
	@cd ..
	@cd direct
	make -fdm.mak wdirect.lib
	@cd ..
	@cd stredit
	make -fdm.mak wstredit.lib
	@cd ..
#	----- Level 3 Applications -----
	@cd help
	make -fdm.mak whelp.lib
	@cd ..
	@cd message
	make -fdm.mak wmessage.lib
	@cd ..
	@cd image
	make -fdm.mak wimage.lib
	@cd ..
	@cd i18n
	make -fdm.mak wi18n.lib
	@cd ..
	@cd file
	make -fdm.mak wfile.lib
	@cd ..
	@cd window
	make -fdm.mak wwindow.lib
	@cd ..

# ----- Winnt Libraries and Programs --------------------------------------

winnt: ndesign.exe
	copy ndesign.exe ..\bin

ndesign.exe: wnt_mods main.obn
	$(WNT_LINK) $(WNT_LINK_OPTS) $(WNT_OBJS)+main.obn, $*, , @wnt_zil.rsp

wnt_mods:
#	----- Level 1 Applications -----
	@cd service
	make -fdm.mak nservice.lib
	@cd ..
#	----- Level 2 Applications -----
	@cd storage
	make -fdm.mak nstorage.lib
	@cd ..
	@cd direct
	make -fdm.mak ndirect.lib
	@cd ..
	@cd stredit
	make -fdm.mak nstredit.lib
	@cd ..
#	----- Level 3 Applications -----
	@cd help
	make -fdm.mak nhelp.lib
	@cd ..
	@cd message
	make -fdm.mak nmessage.lib
	@cd ..
	@cd image
	make -fdm.mak nimage.lib
	@cd ..
	@cd i18n
	make -fdm.mak ni18n.lib
	@cd ..
	@cd file
	make -fdm.mak nfile.lib
	@cd ..
	@cd window
	make -fdm.mak nwindow.lib
	@cd ..


# ----- Win32 Libraries and Programs --------------------------------------

win32: 9design.exe
	copy 9design.exe ..\bin

9design.exe: w32_mods main.ob9
	$(W32_LINK) $(W32_LINK_OPTS) $(W32_OBJS)+main.ob9, $*, , @w32_zil.rsp

w32_mods:
#	----- Level 1 Applications -----
	@cd service
	make -fdm.mak 9service.lib
	@cd ..
#	----- Level 2 Applications -----
	@cd storage
	make -fdm.mak 9storage.lib
	@cd ..
	@cd direct
	make -fdm.mak 9direct.lib
	@cd ..
	@cd stredit
	make -fdm.mak 9stredit.lib
	@cd ..
#	----- Level 3 Applications -----
	@cd help
	make -fdm.mak 9help.lib
	@cd ..
	@cd message
	make -fdm.mak 9message.lib
	@cd ..
	@cd image
	make -fdm.mak 9image.lib
	@cd ..
	@cd i18n
	make -fdm.mak 9i18n.lib
	@cd ..
	@cd file
	make -fdm.mak 9file.lib
	@cd ..
	@cd window
	make -fdm.mak 9window.lib
	@cd ..




