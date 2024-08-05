VERSION=sccpp720

# ----- DOS 16 bit extender (Rational DOS16M) compiler options --------------
# --- DOS ---
DOS_CPP=sc
DOS_LINK=link
DOS_LIBRARIAN=lib
DOS_CPP_OPTS=-c -a1 -bx -ml -o+space -R -R
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
OVL_CPP_OPTS=-c -a1 -mv -R
OVL_LINK_OPTS=/NOI /F /PAC
OVL_LIB_OPTS=/N /B /NOI
OVL_LIB_OPTS=/N /B /NOI
OVL_OBJS=
OVL_LIBS=dos_zilv dos_gfxv sc_lgfxv

.cpp.ovl:
	$(OVL_CPP) $(OVL_CPP_OPTS) -o$@ $<

# ----- DOS 32 bit extender (X-32VM) compiler options -----------------------
D32_CPP=sc
D32_LINK=link
D32_LIBRARIAN=lib
D32_CPP_OPTS=-c -mx -R
D32_LINK_OPTS=/NOI
D32_LIB_OPTS=/N /B /NOI
D32_LIB_OPTS=/N /B /NOI
D32_OBJS=cx
D32_LIBS=d32_zil d32_gfx sc_32gfx x32

.cpp.o32:
	$(D32_CPP) $(D32_CPP_OPTS) -o$@ $<

# ----- Windows compiler options --------------------------------------------
WIN_CPP=sc
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
WNT_CPP=sc
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
W32_CPP=sc
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
	@echo make -fsccpp720.mak dos32
	@echo make -fsccpp720.mak windows
	@echo make -fsccpp720.mak winnt
	@echo make -fsccpp720.mak win32
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean
#	----- Level 1 Applications -----
	@cd service
	make -fsccpp720.mak clean
	@cd ..
#	----- Level 2 Applications -----
	@cd storage
	make -fsccpp720.mak clean
	@cd ..
	@cd direct
	make -fsccpp720.mak clean
	@cd ..
	@cd stredit
	make -fsccpp720.mak clean
	@cd ..
#	----- Level 3 Applications -----
	@cd help
	make -fsccpp720.mak clean
	@cd ..
	@cd message
	make -fsccpp720.mak clean
	@cd ..
	@cd image
	make -fsccpp720.mak clean
	@cd ..
	@cd i18n
	make -fsccpp720.mak clean
	@cd ..
	@cd file
	make -fsccpp720.mak clean
	@cd ..
	@cd window
	make -fsccpp720.mak clean
	@cd ..


doss:
#	----- Level 1 Applications -----
	@cd service
	make -fsccpp720.mak dos
	@cd ..
#	----- Level 2 Applications -----
	@cd storage
	make -fsccpp720.mak dos
	@cd ..
	@cd direct
	make -fsccpp720.mak dos
	@cd ..
	@cd stredit
	make -fsccpp720.mak dos
	@cd ..

# ----- DOS 32 bit extender (X-32VM) compiler options -----------------------
dos32: design32.exe
	copy design32.exe ..\bin

design32.exe: d32_mods main.o32
	$(D32_LINK) $(D32_LINK_OPTS) $(D32_OBJS)+main.o32+storage.o32, $*, ,@sd32_zil.rsp

d32_mods:
#	----- Level 1 Applications -----
	@cd service
	make -fsccpp720.mak service.lib
	@cd ..
#	----- Level 2 Applications -----
	@cd storage
	make -fsccpp720.mak storage.lib
	@cd ..
	@cd direct
	make -fsccpp720.mak direct.lib
	@cd ..
	@cd stredit
	make -fsccpp720.mak stredit.lib
	@cd ..
#	----- Level 3 Applications -----
	@cd help
	make -fsccpp720.mak help.lib
	@cd ..
	@cd message
	make -fsccpp720.mak message.lib
	@cd ..
	@cd image
	make -fsccpp720.mak image.lib
	@cd ..
	@cd i18n
	make -fsccpp720.mak i18n.lib
	@cd ..
	@cd file
	make -fsccpp720.mak file.lib
	@cd ..
	@cd window
	make -fsccpp720.mak window.lib
	@cd ..


# ----- Windows Libraries and Programs --------------------------------------

windows: wdesign.exe
	copy wdesign.exe ..\bin

wdesign.exe: win_mods main.obw
	$(WIN_LINK) $(WIN_LINK_OPTS) $(WIN_OBJS)+main.obw, $*, , @win_zil.rsp, windows.def

	$(WIN_RC) wdesign.rc

win_mods:
#	----- Level 1 Applications -----
	@cd service
	make -fsccpp720.mak wservice.lib
	@cd ..
#	----- Level 2 Applications -----
	@cd storage
	make -fsccpp720.mak wstorage.lib
	@cd ..
	@cd direct
	make -fsccpp720.mak wdirect.lib
	@cd ..
	@cd stredit
	make -fsccpp720.mak wstredit.lib
	@cd ..
#	----- Level 3 Applications -----
	@cd help
	make -fsccpp720.mak whelp.lib
	@cd ..
	@cd message
	make -fsccpp720.mak wmessage.lib
	@cd ..
	@cd image
	make -fsccpp720.mak wimage.lib
	@cd ..
	@cd i18n
	make -fsccpp720.mak wi18n.lib
	@cd ..
	@cd file
	make -fsccpp720.mak wfile.lib
	@cd ..
	@cd window
	make -fsccpp720.mak wwindow.lib
	@cd ..

# ----- Winnt Libraries and Programs --------------------------------------

winnt: ndesign.exe
	copy ndesign.exe ..\bin

ndesign.exe: wnt_mods main.obn
	$(WNT_LINK) $(WNT_LINK_OPTS) $(WNT_OBJS)+main.obn, $*, , @wnt_zil.rsp

wnt_mods:
#	----- Level 1 Applications -----
	@cd service
	make -fsccpp720.mak nservice.lib
	@cd ..
#	----- Level 2 Applications -----
	@cd storage
	make -fsccpp720.mak nstorage.lib
	@cd ..
	@cd direct
	make -fsccpp720.mak ndirect.lib
	@cd ..
	@cd stredit
	make -fsccpp720.mak nstredit.lib
	@cd ..
#	----- Level 3 Applications -----
	@cd help
	make -fsccpp720.mak nhelp.lib
	@cd ..
	@cd message
	make -fsccpp720.mak nmessage.lib
	@cd ..
	@cd image
	make -fsccpp720.mak nimage.lib
	@cd ..
	@cd i18n
	make -fsccpp720.mak ni18n.lib
	@cd ..
	@cd file
	make -fsccpp720.mak nfile.lib
	@cd ..
	@cd window
	make -fsccpp720.mak nwindow.lib
	@cd ..


# ----- Win32 Libraries and Programs --------------------------------------

win32: 9design.exe
	copy 9design.exe ..\bin

9design.exe: w32_mods main.ob9
	$(W32_LINK) $(W32_LINK_OPTS) $(W32_OBJS)+main.ob9, $*, , @w32_zil.rsp

w32_mods:
#	----- Level 1 Applications -----
	@cd service
	make -fsccpp720.mak 9service.lib
	@cd ..
#	----- Level 2 Applications -----
	@cd storage
	make -fsccpp720.mak 9storage.lib
	@cd ..
	@cd direct
	make -fsccpp720.mak 9direct.lib
	@cd ..
	@cd stredit
	make -fsccpp720.mak 9stredit.lib
	@cd ..
#	----- Level 3 Applications -----
	@cd help
	make -fsccpp720.mak 9help.lib
	@cd ..
	@cd message
	make -fsccpp720.mak 9message.lib
	@cd ..
	@cd image
	make -fsccpp720.mak 9image.lib
	@cd ..
	@cd i18n
	make -fsccpp720.mak 9i18n.lib
	@cd ..
	@cd file
	make -fsccpp720.mak 9file.lib
	@cd ..
	@cd window
	make -fsccpp720.mak 9window.lib
	@cd ..




