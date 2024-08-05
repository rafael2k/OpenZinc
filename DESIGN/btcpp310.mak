# ----- General Definitions -------------------------------------------------
VERSION=btcpp310

# ----- DOS compiler options ------------------------------------------------
# --- DOS ---
DOS_CPP=bcc
DOS_LINK=tlink
DOS_LIBRARIAN=tlib
DOS_CPP_OPTS=-c  -ml -O1  -Vs -w
DOS_LINK_OPTS=/c /x
DOS_LIB_OPTS=/C
DOS_OBJS=c0l

# --- Use the next line for UI_GRAPHICS_DISPLAY ---
DOS_LIBS=dos_zil dos_zil2 dos_gfx bc_lgfx emu mathl cl
# --- Use the next line for UI_BGI_DISPLAY ---
#DOS_LIBS=dos_zil dos_zil2 dos_bgi graphics emu mathl cl

.cpp.obj:
	$(DOS_CPP) $(DOS_CPP_OPTS) {$< }

# --- VROOM ---
DOS_OVL_CPP=bcc
DOS_OVL_LINK=tlink
DOS_OVL_LIBRARIAN=tlib
DOS_OVL_CPP_OPTS=-c  -ml -O1  -Vs -Y -w
DOS_OVL_LINK_OPTS=/c /x
DOS_OVL_LIB_OPTS=/C
DOS_OVL_OBJS=c0l

# --- Use the next line for UI_GRAPHICS_DISPLAY ---
DOS_OVL_LIBS=/o+ dos_zilo /o- dos_zil dos_zil2 dos_gfx bc_lgfx overlay emu mathl cl
# --- Use the next line for UI_BGI_DISPLAY ---
#DOS_OVL_LIBS=/o+ dos_zilo /o- dos_zil dos_zil2 dos_bgi overlay graphics emu mathl cl

.cpp.ovl:
	$(DOS_OVL_CPP) $(DOS_OVL_CPP_OPTS) -o$*.ovl {$< }

# ----- Windows compiler options --------------------------------------------
WIN_CPP=bcc
WIN_LINK=tlink
WIN_LIBRARIAN=tlib
WIN_RC=rc

WIN_CPP_OPTS=-c -d  -ml -O1  -Vf -WE -w
WIN_RC_OPTS=-k
WIN_LINK_OPTS=/c /C /Twe /x
WIN_LIB_OPTS=/C

WIN_OBJS=c0wl
WIN_LIBS=win_zil win_zil2 import mathwl cwl

.cpp.obw:
	$(WIN_CPP) $(WIN_CPP_OPTS) -o$*.obw {$< }


# ----- Clean ---------------------------------------------------------------
clean:
	z_clean
#	----- Level 1 Applications -----
	@cd service
	make -fbtcpp310.mak clean
	@cd ..
#	----- Level 2 Applications -----
	@cd storage
	make -fbtcpp310.mak clean
	@cd ..
	@cd direct
	make -fbtcpp310.mak clean
	@cd ..
	@cd stredit
	make -fbtcpp310.mak clean
	@cd ..
#	----- Level 3 Applications -----
	@cd help
	make -fbtcpp310.mak clean
	@cd ..
	@cd message
	make -fbtcpp310.mak clean
	@cd ..
	@cd image
	make -fbtcpp310.mak clean
	@cd ..
	@cd i18n
	make -fbtcpp310.mak clean
	@cd ..
	@cd file
	make -fbtcpp310.mak clean
	@cd ..
	@cd window
	make -fbtcpp310.mak clean
	@cd ..

# ----- DOS -----------------------------------------------------------------
dos:
#	----- Level 1 Applications -----
	@cd service
	make -fbtcpp310.mak dos
	@cd ..
#	----- Level 2 Applications -----
	@cd storage
	make -fbtcpp310.mak dos
	@cd ..
	@cd direct
	make -fbtcpp310.mak dos
	@cd ..
	@cd stredit
	make -fbtcpp310.mak dos
	@cd ..

# ----- DOS OVERLAY------------------------------------------------------------
dosovl:
#	----- Level 1 Applications -----
	@cd service
	make -fbtcpp310.mak dosovl
	@cd ..
#	----- Level 2 Applications -----
	@cd storage
	make -fbtcpp310.mak dosovl
	@cd ..
	@cd direct
	make -fbtcpp310.mak dosovl
	@cd ..
	@cd stredit
	make -fbtcpp310.mak dosovl
	@cd ..



# ----- 16 bit Windows ------------------------------------------------------
windows: wdesign.exe
	copy wdesign.exe ..\bin

wdesign.exe: make_windows_modules main.obw
	$(WIN_LINK) $(WIN_LINK_OPTS) @&&!
$(WIN_OBJS)+main.obw
$*, , wwindow whelp wi18n wmessage wimage wstorage wdirect wstredit wservice $(WIN_LIBS), wdesign.def
!
#v	$(WIN_RC) $(WIN_RC_OPTS) wdesign.rc $<

make_windows_modules:
#	----- Level 1 Applications -----
	@cd service
	make -fbtcpp310.mak wservice.lib
	@cd ..
#	----- Level 2 Applications -----
	@cd storage
	make -fbtcpp310.mak wstorage.lib
	@cd ..
	@cd direct
	make -fbtcpp310.mak wdirect.lib
	@cd ..
	@cd stredit
	make -fbtcpp310.mak wstredit.lib
	@cd ..
#	----- Level 3 Applications -----
	@cd help
	make -fbtcpp310.mak whelp.lib
	@cd ..
	@cd message
	make -fbtcpp310.mak wmessage.lib
	@cd ..
	@cd image
	make -fbtcpp310.mak wimage.lib
	@cd ..
	@cd i18n
	make -fbtcpp310.mak wi18n.lib
	@cd ..
	@cd file
	make -fbtcpp310.mak wfile.lib
	@cd ..
	@cd window
	make -fbtcpp310.mak wwindow.lib
	@cd ..


