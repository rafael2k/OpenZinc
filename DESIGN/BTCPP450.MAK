# ----- General Definitions -------------------------------------------------
VERSION=btcpp450

# ----- DOS compiler options ------------------------------------------------
# --- DOS ---
DOS_CPP=bcc
DOS_LINK=tlink
DOS_LIBRARIAN=tlib
DOS_CPP_OPTS=-c -dc -ml -O1 -x- -RT- -Vs -w
DOS_LINK_OPTS=/c /x
DOS_LIB_OPTS=/C
DOS_OBJS=c0l

# --- Use the next line for UI_GRAPHICS_DISPLAY ---
DOS_LIBS=dos_zil dos_gfx bc_lgfx emu mathl cl
# --- Use the next line for UI_BGI_DISPLAY ---
#DOS_LIBS=dos_zil dos_bgi graphics emu mathl cl

.cpp.obj:
	$(DOS_CPP) $(DOS_CPP_OPTS) {$< }

# --- VROOM ---
DOS_OVL_CPP=bcc
DOS_OVL_LINK=tlink
DOS_OVL_LIBRARIAN=tlib
DOS_OVL_CPP_OPTS=-c -dc -ml -O1 -x- -RT- -Vs -Y -w
DOS_OVL_LINK_OPTS=/c /x
DOS_OVL_LIB_OPTS=/C
DOS_OVL_OBJS=c0l

# --- Use the next line for UI_GRAPHICS_DISPLAY ---
DOS_OVL_LIBS=/o+ dos_zilo /o- dos_zil dos_gfx bc_lgfx overlay emu mathl cl
# --- Use the next line for UI_BGI_DISPLAY ---
#DOS_OVL_LIBS=/o+ dos_zilo /o- dos_zil dos_bgi overlay graphics emu mathl cl

.cpp.ovl:
	$(DOS_OVL_CPP) $(DOS_OVL_CPP_OPTS) -o$*.ovl {$< }

# --- D16 ---
!if !$d(PHARLAP16) && !$d(RATIONAL16) && !$d(POWERPACK16)
# Note:  Set the following variable to PHARLAP16 for Pharlap, RATIONAL16
# for DOS16M, or POWERPACK16 for PowerPack DPMI16.  Default is PHARLAP16.
PHARLAP16=
# Use one of the following command lines to override this setting.
#  make -fbtcpp450.mak -DPHARLAP16 dos16
#  make -fbtcpp450.mak -DRATIONAL16 dos16
#  make -fbtcpp450.mak -DPOWERPACK16 dos16
#  make -fbtcpp450.mak dos32
!endif

!if $d(PHARLAP16)
D16_CPP=bcc286
D16_CPP_OPTS=-c -dc -ml -O1 -x- -RT- -V -w
D16_LINK_OPTS=/c /C /x
D16_LIB_OPTS=/C /p32
D16_OBJS=c0pl.obj
D16_DEF=b16.def
D16_BIND=bind286
PHARLAP_RTL=c:\phar286\rtk
D16_LOAD=run286a
# --- Use the next line for UI_GRAPHICS_DISPLAY ---
D16_LIBS=phapi d16_zil d16_gfx bc_16gfx emu286 emu mathl bcl286
# --- Use the next line for UI_BGI_DISPLAY ---
#D16_LIBS=phapi d16_zil d16_bgi graph286 emu286 emu mathl bcl286

!elif $d(RATIONAL16)
D16_CPP=bcc
D16_CPP_OPTS=-c -dc -ml -O1 -x- -RT- -2 -f87 -Vf -w -DDOS16M
D16_LINK_OPTS=/c /x /C
D16_LIB_OPTS=/C /P1024
D16_OBJS=\dos16m\lib\bcc40\bcc40c0l.obj
D16_DEF=dos16m.def
# --- Use the next line for UI_GRAPHICS_DISPLAY ---
D16_LIBS=bcc40lse bcc40l d16_zil d16_gfx bc_16gfx dos16 d16libc fp87 mathl cl
# --- Use the next line for UI_BGI_DISPLAY ---
#D16_LIBS=bcc40lse bcc40l d16_zil d16_bgi dos16 d16libc fp87 mathl cl

!elif $d(POWERPACK16)
D16_CPP=bcc
D16_CPP_OPTS=-c -dc -WX -ml -O1 -x- -RT- -V -w -DDOS16PP
D16_LINK_OPTS=/Txe /c /C /x
D16_LIB_OPTS=/C /p32
D16_OBJS=c0x.obj
D16_DEF=b16pp.def
# --- Use the next line for UI_GRAPHICS_DISPLAY ---
#D16_LIBS=dpmi16 d16_zil d16_gfx bc_16gfx emux mathwl cwl
# --- Use the next line for UI_BGI_DISPLAY ---
D16_LIBS=dpmi16 d16_zil d16_bgi bgi16 emux mathwl cwl
!endif

D16_LINK=tlink
D16_LIBRARIAN=tlib

.cpp.o16:
	$(D16_CPP) $(D16_CPP_OPTS) -o$*.o16 {$< }

D32_CPP=bcc32
D32_CPP_OPTS=-c -WX -O1 -x- -RT- -V -w -DDOS32PP
D32_LINK=tlink32
D32_LINK_OPTS=/Tpe /ax /c /x
D32_LIBRARIAN=tlib
D32_LIB_OPTS=/C /p32
D32_OBJS=c0x32.obj
# --- Use the next line for UI_GRAPHICS_DISPLAY ---
#D32_LIBS=dpmi32 d32_zil d32_gfx bc_32gfx cw32
# --- Use the next line for UI_BGI_DISPLAY ---
D32_LIBS=dpmi32 d32_zil d32_bgi bgi32 cw32

.cpp.o32:
	$(D32_CPP) $(D32_CPP_OPTS) -o$*.o32 {$< }

# ----- Windows compiler options --------------------------------------------
WIN_CPP=bcc
WIN_LINK=tlink
WIN_LIBRARIAN=tlib
WIN_RC=rc

WIN_CPP_OPTS=-c -d -dc -ml -O1 -x- -RT- -Vf -WE -w
WIN_RC_OPTS=-k
WIN_LINK_OPTS=/c /C /Twe /x
WIN_LIB_OPTS=/C

WIN_OBJS=c0wl
WIN_LIBS=win_zil import mathwl cwl ctl3dv2

.cpp.obw:
	$(WIN_CPP) $(WIN_CPP_OPTS) -o$*.obw {$< }

# ----- Windows NT compiler options -----------------------------------------
WNT_CPP=bcc32
WNT_LINK=tlink32
WNT_LIBRARIAN=tlib
WNT_RC=brc32

WNT_CPP_OPTS=-c -O1 -x- -RT- -W
WNT_LINK_OPTS=-Tpe -aa -c -x
WNT_RC_OPTS=-w32
WNT_LIB_OPTS=/C

WNT_OBJS=c0w32
WNT_LIBS=wnt_zil import32 cw32 ctl3d32

.cpp.obn:
	$(WNT_CPP) $(WNT_CPP_OPTS) -o$*.obn {$< }

.rc.rbj:
	$(WNT_RC) -r $(WNT_RC_OPTS) -fo$*.rbj $<

# ----- 32 bit Windows compiler options -------------------------------------
W32_CPP=bcc32
W32_LINK=tlink32
W32_LIBRARIAN=tlib
W32_RC=brc32

W32_CPP_OPTS=-c -O1 -x- -RT- -W -DZIL_WIN32
W32_LINK_OPTS=-Tpe -aa -c -x 
W32_RC_OPTS=-w32
W32_LIB_OPTS=/C

W32_OBJS=c0w32
W32_LIBS=w32_zil import32 cw32 ctl3d32

.cpp.ob9:
	$(W32_CPP) $(W32_CPP_OPTS) -o$*.ob9 {$< }

.rc.rbj:
	$(W32_RC) -r $(W32_RC_OPTS) -fo$*.rbj $<

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean
#	----- Level 1 Applications -----
	@cd service
	make -fbtcpp450.mak clean
	@cd ..
#	----- Level 2 Applications -----
	@cd storage
	make -fbtcpp450.mak clean
	@cd ..
	@cd direct
	make -fbtcpp450.mak clean
	@cd ..
	@cd stredit
	make -fbtcpp450.mak clean
	@cd ..
#	----- Level 3 Applications -----
	@cd help
	make -fbtcpp450.mak clean
	@cd ..
	@cd message
	make -fbtcpp450.mak clean
	@cd ..
	@cd image
	make -fbtcpp450.mak clean
	@cd ..
	@cd i18n
	make -fbtcpp450.mak clean
	@cd ..
	@cd file
	make -fbtcpp450.mak clean
	@cd ..
	@cd window
	make -fbtcpp450.mak clean
	@cd ..

# ----- DOS -----------------------------------------------------------------
dos:
#	----- Level 1 Applications -----
	@cd service
	make -fbtcpp450.mak dos
	@cd ..
#	----- Level 2 Applications -----
	@cd storage
	make -fbtcpp450.mak dos
	@cd ..
	@cd direct
	make -fbtcpp450.mak dos
	@cd ..
	@cd stredit
	make -fbtcpp450.mak dos
	@cd ..

dos16: design.exe
	copy design.exe ..\bin

design.exe: make_dos16_modules main.o16
	$(D16_LINK) $(D16_LINK_OPTS) @&&!
$(D16_OBJS)+main.o16
$*, , window.lib i18n.lib help.lib message.lib image.lib storage.lib direct.lib stredit.lib service.lib $(D16_LIBS), $(D16_DEF)
!
!if $d(PHARLAP16)
	$(D16_BIND) @&&!
$(PHARLAP_RTL)\$(D16_LOAD)
$*
-dll $(PHARLAP_RTL)\moucalls
     $(PHARLAP_RTL)\int33
     $(PHARLAP_RTL)\doscalls
!
!endif

make_dos16_modules:

!if $d(PHARLAP16)
#	----- Level 1 Applications -----
	@cd service
	make -fbtcpp450.mak -DPHARLAP16 service.lib
	@cd ..
#	----- Level 2 Applications -----
	@cd storage
	make -fbtcpp450.mak -DPHARLAP16 storage.lib
	@cd ..
	@cd direct
	make -fbtcpp450.mak -DPHARLAP16 direct.lib
	@cd ..
	@cd stredit
	make -fbtcpp450.mak -DPHARLAP16 stredit.lib
	@cd ..
#	----- Level 3 Applications -----
	@cd help
	make -fbtcpp450.mak -DPHARLAP16 help.lib
	@cd ..
	@cd message
	make -fbtcpp450.mak -DPHARLAP16 message.lib
	@cd ..
	@cd image
	make -fbtcpp450.mak -DPHARLAP16 image.lib
	@cd ..
	@cd i18n
	make -fbtcpp450.mak -DPHARLAP16 i18n.lib
	@cd ..
	@cd file
	make -fbtcpp450.mak -DPHARLAP16 file.lib
	@cd ..
	@cd window
	make -fbtcpp450.mak -DPHARLAP16 window.lib
	@cd ..

!elif $d(RATIONAL16)
#	----- Level 1 Applications -----
	@cd service
	make -fbtcpp450.mak -DRATIONAL16 service.lib
	@cd ..
#	----- Level 2 Applications -----
	@cd storage
	make -fbtcpp450.mak -DRATIONAL16 storage.lib
	@cd ..
	@cd direct
	make -fbtcpp450.mak -DRATIONAL16 direct.lib
	@cd ..
	@cd stredit
	make -fbtcpp450.mak -DRATIONAL16 stredit.lib
	@cd ..
#	----- Level 3 Applications -----
	@cd help
	make -fbtcpp450.mak -DRATIONAL16 help.lib
	@cd ..
	@cd message
	make -fbtcpp450.mak -DRATIONAL16 message.lib
	@cd ..
	@cd image
	make -fbtcpp450.mak -DRATIONAL16 image.lib
	@cd ..
	@cd i18n
	make -fbtcpp450.mak -DRATIONAL16 i18n.lib
	@cd ..
	@cd file
	make -fbtcpp450.mak -DRATIONAL16 file.lib
	@cd ..
	@cd window
	make -fbtcpp450.mak -DRATIONAL16 window.lib
	@cd ..

!elif $d(POWERPACK16)
#	----- Level 1 Applications -----
	@cd service
	make -fbtcpp450.mak -DPOWERPACK16 service.lib
	@cd ..
#	----- Level 2 Applications -----
	@cd storage
	make -fbtcpp450.mak -DPOWERPACK16 storage.lib
	@cd ..
	@cd direct
	make -fbtcpp450.mak -DPOWERPACK16 direct.lib
	@cd ..
	@cd stredit
	make -fbtcpp450.mak -DPOWERPACK16 stredit.lib
	@cd ..
#	----- Level 3 Applications -----
	@cd help
	make -fbtcpp450.mak -DPOWERPACK16 help.lib
	@cd ..
	@cd message
	make -fbtcpp450.mak -DPOWERPACK16 message.lib
	@cd ..
	@cd image
	make -fbtcpp450.mak -DPOWERPACK16 image.lib
	@cd ..
	@cd i18n
	make -fbtcpp450.mak -DPOWERPACK16 i18n.lib
	@cd ..
	@cd file
	make -fbtcpp450.mak -DPOWERPACK16 file.lib
	@cd ..
	@cd window
	make -fbtcpp450.mak -DPOWERPACK16 window.lib
	@cd ..
!endif

dos32: design32.exe
	copy design32.exe ..\bin

design32.exe: make_dos32_modules main.o32
	$(D32_LINK) $(D32_LINK_OPTS) @&&!
$(D32_OBJS)+main.o32
$*, , window32.lib i18n32.lib help32.lib messag32.lib image32.lib storag32.lib direct32.lib stredi32.lib servic32.lib $(D32_LIBS)
!

make_dos32_modules:
#	----- Level 1 Applications -----
	@cd service
	make -fbtcpp450.mak servic32.lib
	@cd ..
#	----- Level 2 Applications -----
	@cd storage
	make -fbtcpp450.mak storag32.lib
	@cd ..
	@cd direct
	make -fbtcpp450.mak direct32.lib
	@cd ..
	@cd stredit
	make -fbtcpp450.mak stredi32.lib
	@cd ..
#	----- Level 3 Applications -----
	@cd help
	make -fbtcpp450.mak help32.lib
	@cd ..
	@cd message
	make -fbtcpp450.mak messag32.lib
	@cd ..
	@cd image
	make -fbtcpp450.mak image32.lib
	@cd ..
	@cd i18n
	make -fbtcpp450.mak i18n32.lib
	@cd ..
	@cd file
	make -fbtcpp450.mak file32.lib
	@cd ..
	@cd window
	make -fbtcpp450.mak window32.lib
	@cd ..

# ----- 16 bit Windows ------------------------------------------------------
windows: wdesign.exe
	copy wdesign.exe ..\bin

wdesign.exe: make_windows_modules main.obw
	$(WIN_LINK) $(WIN_LINK_OPTS) @&&!
$(WIN_OBJS)+main.obw
$*, , wwindow whelp wi18n wmessage wimage wstorage wdirect wstredit wservice $(WIN_LIBS), wdesign.def
!
	$(WIN_RC) $(WIN_RC_OPTS) wdesign.rc $<

make_windows_modules:
#	----- Level 1 Applications -----
	@cd service
	make -fbtcpp450.mak wservice.lib
	@cd ..
#	----- Level 2 Applications -----
	@cd storage
	make -fbtcpp450.mak wstorage.lib
	@cd ..
	@cd direct
	make -fbtcpp450.mak wdirect.lib
	@cd ..
	@cd stredit
	make -fbtcpp450.mak wstredit.lib
	@cd ..
#	----- Level 3 Applications -----
	@cd help
	make -fbtcpp450.mak whelp.lib
	@cd ..
	@cd message
	make -fbtcpp450.mak wmessage.lib
	@cd ..
	@cd image
	make -fbtcpp450.mak wimage.lib
	@cd ..
	@cd i18n
	make -fbtcpp450.mak wi18n.lib
	@cd ..
	@cd file
	make -fbtcpp450.mak wfile.lib
	@cd ..
	@cd window
	make -fbtcpp450.mak wwindow.lib
	@cd ..

# ----- Windows NT ----------------------------------------------------------
winnt: ndesign.exe
	copy ndesign.exe ..\bin

ndesign.exe: make_winnt_modules main.obn wdesign.rbj
	$(WNT_LINK) $(WNT_LINK_OPTS) @&&!
$(WNT_OBJS)+main.obn
$*, , nwindow nhelp ni18n nmessage nimage nstorage ndirect nstredit nservice $(WNT_LIBS), wdesign.def, wdesign.rbj
!

make_winnt_modules:
#	----- Level 1 Applications -----
	@cd service
	make -fbtcpp450.mak nservice.lib
	@cd ..
#	----- Level 2 Applications -----
	@cd storage
	make -fbtcpp450.mak nstorage.lib
	@cd ..
	@cd direct
	make -fbtcpp450.mak ndirect.lib
	@cd ..
	@cd stredit
	make -fbtcpp450.mak nstredit.lib
	@cd ..
#	----- Level 3 Applications -----
	@cd help
	make -fbtcpp450.mak nhelp.lib
	@cd ..
	@cd message
	make -fbtcpp450.mak nmessage.lib
	@cd ..
	@cd image
	make -fbtcpp450.mak nimage.lib
	@cd ..
	@cd i18n
	make -fbtcpp450.mak ni18n.lib
	@cd ..
	@cd file
	make -fbtcpp450.mak nfile.lib
	@cd ..
	@cd window
	make -fbtcpp450.mak nwindow.lib
	@cd ..

# ----- 32 bit Windows ------------------------------------------------------
win32: 9design.exe
	copy 9design.exe ..\bin

9design.exe: make_win32_modules main.ob9 wdesign.rbj
	$(W32_LINK) $(W32_LINK_OPTS) @&&!
$(W32_OBJS)+main.ob9 
$*, , 9window 9help 9i18n 9message 9image 9storage 9direct 9stredit 9service $(W32_LIBS), , wdesign.rbj
!

make_win32_modules:
#	----- Level 1 Applications -----
	@cd service
	make -fbtcpp450.mak 9service.lib
	@cd ..
#	----- Level 2 Applications -----
	@cd storage
	make -fbtcpp450.mak 9storage.lib
	@cd ..
	@cd direct
	make -fbtcpp450.mak 9direct.lib
	@cd ..
	@cd stredit
	make -fbtcpp450.mak 9stredit.lib
	@cd ..
#	----- Level 3 Applications -----
	@cd help
	make -fbtcpp450.mak 9help.lib
	@cd ..
	@cd message
	make -fbtcpp450.mak 9message.lib
	@cd ..
	@cd image
	make -fbtcpp450.mak 9image.lib
	@cd ..
	@cd i18n
	make -fbtcpp450.mak 9i18n.lib
	@cd ..
	@cd file
	make -fbtcpp450.mak 9file.lib
	@cd ..
	@cd window
	make -fbtcpp450.mak 9window.lib
	@cd ..
