# VLIST tutorial makefile

#    make -fbtcpp550.mak dos             (makes all the DOS vlist tutorials)
#    make -fbtcpp550.mak dosovl          (makes the DOS overlay vlist tutorials)
#    make -fbtcpp550.mak dos16           (makes all the DOS extender vlist tutorials)
#    make -fbtcpp550.mak dos32           (makes all the DOS extender vlist tutorials)
#    make -fbtcpp550.mak windows         (makes all the Windows vlist tutorials)
#    make -f btcpp550.mak winnt          (makes all the Windows NT vlist tutorials)

# Be sure to update your TURBOC.CFG file to include the Zinc paths, e.g.:
#   -I.;C:\ZINC\INCLUDE;C:\BC50\INCLUDE
#   -L.;C:\ZINC\LIB\BTCPP500;C:\BC50\LIB
# and your TLINK.CFG file to include the Zinc paths, e.g.:
#   -L.;C:\ZINC\LIB\BTCPP500;C:\BC50\LIB

CPP=bcc
LINK=tlink
RC=brc

## Compiler and linker: (Add -v to CPP_OPTS and /v to LINK_OPTS for debug.)

# ----- DOS compiler options ------------------------------------------------
DOS_CPP_OPTS=-c -ml -O1 -x- -RT- -w
DOS_LINK_OPTS=/c /x
DOS_OBJS=c0l
# --- Use the next line for UI_GRAPHICS_DISPLAY ---
DOS_LIBS=dos_zil dos_gfx bc_lgfx emu mathl cl
# --- Use the next line for UI_BGI_DISPLAY ---
#DOS_LIBS=dos_zil dos_bgi graphics emu mathl cl

.c.obj:
	$(CPP) $(DOS_CPP_OPTS) {$< }

.cpp.obj:
	$(CPP) $(DOS_CPP_OPTS) {$< }

# ----- DOS VROOM overlay compiler options ---------------------------------
DOS_OVL_CPP_OPTS=-c -ml -O1 -x- -RT- -Z -Vs -Y -w
DOS_OVL_LINK_OPTS=/c /x
DOS_OVL_OBJS=c0l
# --- Use the next line for UI_GRAPHICS_DISPLAY ---
DOS_OVL_LIBS=/o+ dos_zilo /o- dos_zil dos_gfx bc_lgfx overlay emu mathl cl
# --- Use the next line for UI_BGI_DISPLAY ---
#DOS_OVL_LIBS=/o+ dos_zilo /o- dos_zil dos_bgi overlay graphics emu mathl cl

.c.ovl:
	$(CPP) $(DOS_OVL_CPP_OPTS) -o$*.ovl {$< }

.cpp.ovl:
	$(CPP) $(DOS_OVL_CPP_OPTS) -o$*.ovl {$< }

# ----- DOS Extender options. -----------------------------------------------
!if !$d(PHARLAP16) && !$d(RATIONAL16) && !$d(POWERPACK16)
# Note:  Set the following variable to PHARLAP16 for Pharlap, RATIONAL16
# for DOS16M, or POWERPACK16 for PowerPack DPMI16.  Default is POWERPACK16.
POWERPACK16=
# Use one of the following command lines to override this setting.
#  make -fbtcpp550.mak -DPHARLAP16 dos16
#  make -fbtcpp550.mak -DRATIONAL16 dos16
#  make -fbtcpp550.mak -DPOWERPACK16 dos16
!endif

!if $d(PHARLAP16)
D16_CPP=bcc286
D16_CPP_OPTS=-c -ml -O1 -x- -RT- -V -w
D16_LINK_OPTS=/c /C /x
D16_OBJS=c0pl.obj
D16_DEF=b16.def
# --- Use the next line for UI_GRAPHICS_DISPLAY ---
D16_LIBS=phapi d16_zil d16_gfx bc_16gfx emu286 emu mathl bcl286
# --- Use the next line for UI_BGI_DISPLAY ---
#D16_LIBS=phapi d16_zil d16_bgi graph286 emu286 emu mathl bcl286

!elif $d(RATIONAL16)
D16_CPP=bcc
D16_CPP_OPTS=-c -ml -O1 -x- -RT- -2 -Vf -f87 -w -DDOS16M
D16_LINK_OPTS=/e /c /x /C
D16_OBJS=\dos16m\lib\bcc40\bcc40c0l.obj
D16_DEF=dos16m.def
D16_PATH=\dos16m\bin
# --- Use the next line for UI_GRAPHICS_DISPLAY ---
D16_LIBS=bcc40lse bcc40l d16_zil d16_gfx bc_16gfx dos16 d16libc fp87 mathl cl
# --- Use the next line for UI_BGI_DISPLAY ---
#D16_LIBS=bcc40lse bcc40l d16_zil d16_bgi dos16 d16libc fp87 mathl cl

!elif $d(POWERPACK16)
D16_CPP=bcc
D16_CPP_OPTS=-c -WX -ml -O1 -x- -RT- -V -w -DDOS16PP
D16_LINK_OPTS=/Txe /c /C /x
D16_OBJS=c0x.obj
D16_DEF=b16pp.def
# --- Use the next line for UI_GRAPHICS_DISPLAY ---
#D16_LIBS=dpmi16 d16_zil d16_gfx bc_16gfx emux mathwl cwl
# --- Use the next line for UI_BGI_DISPLAY ---
D16_LIBS=dpmi16 d16_zil d16_bgi bgi16 emux mathwl cwl
!endif

.cpp.o16:
	$(D16_CPP) $(D16_CPP_OPTS) -o$*.o16 {$< }

# PowerPack 32
D32_CPP=bcc32
D32_CPP_OPTS=-c -WX -O1 -x- -RT- -V -w -DDOS32PP
D32_LINK=ilink32
D32_LINK_OPTS=/Tpe /ax /c /x
D32_OBJS=c0x32.obj
# --- Use the next line for UI_GRAPHICS_DISPLAY ---
#D32_LIBS=dpmi32 d32_zil d32_gfx bc_32gfx cw32
# --- Use the next line for UI_BGI_DISPLAY ---
D32_LIBS=dpmi32 d32_zil d32_bgi bgi32 cw32

.cpp.o32:
	$(D32_CPP) $(D32_CPP_OPTS) -o$*.o32 {$< }

# ----- Windows compiler options --------------------------------------------
WIN_CPP_OPTS=-c -ml -O1 -x- -RT- -Vf -WE -w
WIN_RC_OPTS=-k
WIN_LINK_OPTS=/c /C /Twe /x
WIN_OBJS=c0wl
WIN_LIBS=win_zil mathwl import cwl ctl3dv2

.cpp.obw:
	$(CPP) $(WIN_CPP_OPTS) -o$*.obw {$< }

# ----- Windows NT compiler options -----------------------------------------
WNT_CPP=bcc32
WNT_LINK=ilink32
WNT_RC=brc32

WNT_CPP_OPTS=-c -O1 -x- -RT- -W
#WNT_CPP_OPTS=-c
WNT_LINK_OPTS=-Tpe -aa -x -c
WNT_CON_LINK_OPTS=/Tpe /ap /x /c
WNT_RC_OPTS=-w32
WNT_LIB_OPTS=/C

WNT_OBJS=c0w32
WNT_CON_OBJS=c0x32
WNT_LIBS=wnt_zil import32 cw32 
WNT_CON_LIBS=wnt_zil import32 cw32

.c.obn:
	$(WNT_CPP) $(WNT_CPP_OPTS) -o$*.obn {$< }

.cpp.obn:
	$(WNT_CPP) $(WNT_CPP_OPTS) -o$*.obn {$< }

.rc.rbj:
	$(WNT_RC) -r $(WNT_RC_OPTS) -fo$*.rbj $<

# ----- Windows 32 bit compiler options -------------------------------------
W32_CPP=bcc32
W32_LINK=ilink32
W32_RC=brc32

W32_CPP_OPTS=-c -O1 -x- -RT- -W -DZIL_WIN32
#W32_CPP_OPTS=-c
W32_LINK_OPTS=-Tpe -aa -x -c -Lc:\bc55\lib;c:\z421bc55\lib\btcpp550
W32_RC_OPTS=-w32
W32_LIB_OPTS=/C

W32_OBJS=c0w32
W32_LIBS=w32_zil import32 cw32 

.c.ob9:
	$(W32_CPP) $(W32_CPP_OPTS) -o$*.ob9 {$< }

.cpp.ob9:
	$(W32_CPP) $(W32_CPP_OPTS) -o$*.ob9 {$< }

.rc.rbj:
	$(W32_RC) -r $(W32_RC_OPTS) -fo$*.rbj $<

# ----- Usage --------------------------------------------------------------
usage:
	@echo ...........
	@echo ...........
	@echo To make this Zinc tutorial for Borland C++ type:
	@echo make -fbtcpp550.mak dos
	@echo make -fbtcpp550.mak dosovl
	@echo make -fbtcpp550.mak dos16
	@echo make -fbtcpp550.mak dos32
	@echo make -fbtcpp550.mak windows
	@echo make -f btcpp550.mak winnt
	@echo make -f btcpp550.mak win32
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean

# ----- DOS -----------------------------------------------------------------
dos: vlist.exe

vlist.exe: vlist.obj g_jump.obj
	$(LINK) $(DOS_LINK_OPTS) @&&!
$(DOS_OBJS)+vlist.obj+g_jump.obj
$*, ,$(DOS_LIBS)
!

# ----- DOS VROOM -----------------------------------------------------------
dosovl: vlistv.exe

vlistv.exe: vlist.ovl g_jump.ovl
	$(LINK) $(DOS_OVL_LINK_OPTS) @&&!
$(DOS_OVL_OBJS)+vlist.ovl+g_jump.ovl
$*, , $(DOS_OVL_LIBS)
!

# ----- DOS Extender ----------------------------------------------------------
dos16: vlist16.exe

vlist16.exe: vlist.o16 g_jump.o16
	$(LINK) $(D16_LINK_OPTS) @&&!
$(D16_OBJS)+vlist.o16+g_jump.o16
$*, ,$(D16_LIBS),$(D16_DEF)
!

dos32: vlist32.exe

vlist32.exe: vlist.o32 g_jump.o32
	$(D32_LINK) $(D32_LINK_OPTS) @&&!
$(D32_OBJS)+vlist.o32+g_jump.o32
$*, ,$(D32_LIBS)
!

# ----- Windows -------------------------------------------------------------
windows: wvlist.exe

wvlist.exe: vlist.obw g_jump.obw
	$(LINK) $(WIN_LINK_OPTS) @&&!
$(WIN_OBJS)+vlist.obw+g_jump.obw
$*, ,$(WIN_LIBS),wvlist.def
!
	$(RC) $(WIN_RC_OPTS) wvlist.rc $<

# ----- Windows NT ----------------------------------------------------------
winnt: nvlist.exe

nvlist.exe: vlist.obn g_jump.obn wvlist.rbj
	$(WNT_LINK) $(WNT_LINK_OPTS) @&&!
$(WNT_OBJS)+vlist.obn+g_jump.obn
$*, ,$(WNT_LIBS),wvlist.def,wvlist.rbj
!

# ----- 32 bit Windows ------------------------------------------------------
win32: 9vlist.exe

9vlist.exe: vlist.ob9 g_jump.ob9 wvlist.rbj
	$(W32_LINK) $(W32_LINK_OPTS) @&&!
$(W32_OBJS)+vlist.ob9+g_jump.ob9
$*, ,$(W32_LIBS),wvlist.def,wvlist.rbj
!
