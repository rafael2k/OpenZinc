# HELLO tutorial makefile

#    make -fbtcpp400.mak dos             (makes the DOS hello tutorials)
#    make -fbtcpp400.mak dosovl          (makes the DOS overlay hello tutorials)
#    make -fbtcpp400.mak dos16           (makes the DOS extender hello tutorials)
#    make -fbtcpp400.mak dos32           (makes the DOS extender hello tutorials)
#    make -fbtcpp400.mak windows         (makes the Windows hello tutorials)
#    make -f btcpp400.mak winnt          (makes the Windows NT hello tutorials)

# Be sure to update your TURBOC.CFG file to include the Zinc paths, e.g.:
#   -I.;C:\ZINC\INCLUDE;C:\BC45\INCLUDE
#   -L.;C:\ZINC\LIB\btcpp400;C:\BC45\LIB
# and your TLINK.CFG file to include the Zinc paths, e.g.:
#   -L.;C:\ZINC\LIB\btcpp400;C:\BC45\LIB

CPP=bcc
LINK=tlink
RC=rc

## Compiler and linker: (Add -v to CPP_OPTS and /v to LINK_OPTS for debug.)

# ----- DOS compiler options ------------------------------------------------
DOS_CPP_OPTS=-c -ml -O1 -x- -RT- -w
DOS_LINK_OPTS=/c /x
DOS_OBJS=c0l
# --- Use the next line for UI_GRAPHICS_DISPLAY ---
DOS_LIBS=dos_zil dos_gfx bc_lgfx emu mathl cl
# --- Use the next line for UI_BGI_DISPLAY ---
#DOS_LIBS=dos_zil dos_bgi graphics emu mathl cl

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

.cpp.ovl:
	$(CPP) $(DOS_OVL_CPP_OPTS) -o$*.ovl {$< }

# ----- DOS Extender options. -----------------------------------------------
!if !$d(PHARLAP16) && !$d(RATIONAL16) && !$d(POWERPACK16)
# Note:  Set the following variable to PHARLAP16 for Pharlap, RATIONAL16
# for DOS16M, or POWERPACK16 for PowerPack DPMI16.  Default is POWERPACK16.
POWERPACK16=
# Use one of the following command lines to override this setting.
#  make -fbtcpp400.mak -DPHARLAP16 dos16
#  make -fbtcpp400.mak -DRATIONAL16 dos16
#  make -fbtcpp400.mak -DPOWERPACK16 dos16
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
D32_LINK=tlink32
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
WNT_LINK=tlink32
WNT_RC=brc32

WNT_CPP_OPTS=-c -O1 -x- -RT- -W
WNT_LINK_OPTS=-Tpe -aa -x -c
WNT_RC_OPTS=-w32
WNT_LIB_OPTS=/C

WNT_OBJS=c0w32
WNT_LIBS=wnt_zil import32 cw32 ctl3d32

.cpp.obn:
	$(WNT_CPP) $(WNT_CPP_OPTS) -o$*.obn {$< }

.rc.rbj:
	$(WNT_RC) -r $(WNT_RC_OPTS) -fo$*.rbj $<

# ----- Windows 32 bit compiler options -------------------------------------
W32_CPP=bcc32
W32_LINK=tlink32
W32_RC=brc32

W32_CPP_OPTS=-c -O1 -x- -RT- -W -DZIL_WIN32
W32_LINK_OPTS=-Tpe -aa -x -c
W32_RC_OPTS=-w32
W32_LIB_OPTS=/C

W32_OBJS=c0w32
W32_LIBS=w32_zil import32 cw32 ctl3d32

.cpp.ob9:
	$(W32_CPP) $(W32_CPP_OPTS) -o$*.ob9 {$< }

.rc.rbj:
	$(W32_RC) -r $(W32_RC_OPTS) -fo$*.rbj $<

# ----- Usage --------------------------------------------------------------
usage:
	@echo ...........
	@echo ...........
	@echo To make this Zinc tutorial for Borland C++ type:
	@echo make -fbtcpp400.mak dos
	@echo make -fbtcpp400.mak dosovl
	@echo make -fbtcpp400.mak dos16
	@echo make -fbtcpp400.mak dos32
	@echo make -fbtcpp400.mak windows
	@echo make -f btcpp400.mak winnt
	@echo make -f btcpp400.mak win32
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean

# ----- DOS -----------------------------------------------------------------
dos: hello1.exe hello2.exe hello3.exe hellog.exe

hello1.exe: hello1.obj
	$(LINK) $(DOS_LINK_OPTS) @&&!
$(DOS_OBJS)+hello1.obj
$*, ,$(DOS_LIBS)
!

hello2.exe: hello2.obj
	$(LINK) $(DOS_LINK_OPTS) @&&!
$(DOS_OBJS)+hello2.obj
$*, ,$(DOS_LIBS)
!

hello3.exe: hello3.obj hello.obj
	$(LINK) $(DOS_LINK_OPTS) @&&!
$(DOS_OBJS)+hello3.obj+hello.obj
$*, ,$(DOS_LIBS)
!

hellog.exe: hellog.obj
	$(LINK) $(DOS_LINK_OPTS) @&&!
$(DOS_OBJS)+hellog.obj
$*, ,$(DOS_LIBS)
!

# ----- DOS VROOM -----------------------------------------------------------
dosovl: hello1v.exe hello2v.exe hello3v.exe hellogv.exe

hello1v.exe: hello1.ovl
	$(LINK) $(DOS_OVL_LINK_OPTS) @&&!
$(DOS_OVL_OBJS)+hello1.ovl
$*, , $(DOS_OVL_LIBS)
!

hello2v.exe: hello2.ovl
	$(LINK) $(DOS_OVL_LINK_OPTS) @&&!
$(DOS_OVL_OBJS)+hello2.ovl
$*, , $(DOS_OVL_LIBS)
!

hello3v.exe: hello3.ovl hello.ovl
	$(LINK) $(DOS_OVL_LINK_OPTS) @&&!
$(DOS_OVL_OBJS)+hello3.ovl+hello.ovl
$*, , $(DOS_OVL_LIBS)
!

hellogv.exe: hellog.ovl
	$(LINK) $(DOS_OVL_LINK_OPTS) @&&!
$(DOS_OVL_OBJS)+hellog.ovl
$*, , $(DOS_OVL_LIBS)
!

# ----- DOS Extender --------------------------------------------------------
dos16: hello116.exe hello216.exe hello316.exe hellog16.exe

hello116.exe: hello1.o16
	$(LINK) $(D16_LINK_OPTS) @&&!
$(D16_OBJS)+hello1.o16
$*, ,$(D16_LIBS),$(D16_DEF)
!

hello216.exe: hello2.o16
	$(LINK) $(D16_LINK_OPTS) @&&!
$(D16_OBJS)+hello2.o16
$*, ,$(D16_LIBS),$(D16_DEF)
!

hello316.exe: hello3.o16 hello.o16
	$(LINK) $(D16_LINK_OPTS) @&&!
$(D16_OBJS)+hello3.o16+hello.o16
$*, ,$(D16_LIBS),$(D16_DEF)
!

hellog16.exe: hellog.o16
	$(LINK) $(D16_LINK_OPTS) @&&!
$(D16_OBJS)+hellog.o16
$*, ,$(D16_LIBS),$(D16_DEF)
!

dos32: hello132.exe hello232.exe hello332.exe hellog32.exe

hello132.exe: hello1.o32
	$(D32_LINK) $(D32_LINK_OPTS) @&&!
$(D32_OBJS)+hello1.o32
$*, ,$(D32_LIBS)
!

hello232.exe: hello2.o32
	$(D32_LINK) $(D32_LINK_OPTS) @&&!
$(D32_OBJS)+hello2.o32
$*, ,$(D32_LIBS)
!

hello332.exe: hello3.o32 hello.o32
	$(D32_LINK) $(D32_LINK_OPTS) @&&!
$(D32_OBJS)+hello3.o32+hello.o32
$*, ,$(D32_LIBS)
!

hellog32.exe: hellog.o32
	$(D32_LINK) $(D32_LINK_OPTS) @&&!
$(D32_OBJS)+hellog.o32
$*, ,$(D32_LIBS)
!

# ----- Windows -------------------------------------------------------------
windows: whello1.exe whello2.exe whello3.exe whellog.exe

whello1.exe: hello1.obw
	$(LINK) $(WIN_LINK_OPTS) @&&!
$(WIN_OBJS)+hello1.obw
$*, ,$(WIN_LIBS),whello.def
!
	$(RC) $(WIN_RC_OPTS) whello.rc $<

whello2.exe: hello2.obw
	$(LINK) $(WIN_LINK_OPTS) @&&!
$(WIN_OBJS)+hello2.obw
$*, ,$(WIN_LIBS),whello.def
!
	$(RC) $(WIN_RC_OPTS) whello.rc $<

whello3.exe: hello3.obw hello.obw
	$(LINK) $(WIN_LINK_OPTS) @&&!
$(WIN_OBJS)+hello3.obw+hello.obw
$*, ,$(WIN_LIBS),whello.def
!
	$(RC) $(WIN_RC_OPTS) whello.rc $<

whellog.exe: hellog.obw
	$(LINK) $(WIN_LINK_OPTS) @&&!
$(WIN_OBJS)+hellog.obw
$*, ,$(WIN_LIBS),whello.def
!
	$(RC) $(WIN_RC_OPTS) whello.rc $<

# ----- Windows NT ----------------------------------------------------------
winnt: nhello1.exe nhello2.exe nhello3.exe nhellog.exe

nhello1.exe: hello1.obn whello.rbj
	$(WNT_LINK) $(WNT_LINK_OPTS) @&&!
$(WNT_OBJS)+hello1.obn
$*, ,$(WNT_LIBS),whello.def,whello.rbj
!

nhello2.exe: hello2.obn whello.rbj
	$(WNT_LINK) $(WNT_LINK_OPTS) @&&!
$(WNT_OBJS)+hello2.obn
$*, ,$(WNT_LIBS),whello.def,whello.rbj
!

nhello3.exe: hello3.obn hello.obn whello.rbj
	$(WNT_LINK) $(WNT_LINK_OPTS) @&&!
$(WNT_OBJS)+hello3.obn+hello.obn
$*, ,$(WNT_LIBS),whello.def,whello.rbj
!

nhellog.exe: hellog.obn whello.rbj
	$(WNT_LINK) $(WNT_LINK_OPTS) @&&!
$(WNT_OBJS)+hellog.obn
$*, ,$(WNT_LIBS),whello.def,whello.rbj
!

# ----- 32 bit Windows ------------------------------------------------------
win32: 9hello1.exe 9hello2.exe 9hello3.exe 9hellog.exe

9hello1.exe: hello1.ob9 whello.rbj
	$(W32_LINK) $(W32_LINK_OPTS) @&&!
$(W32_OBJS)+hello1.ob9
$*, ,$(W32_LIBS),whello.def,whello.rbj
!

9hello2.exe: hello2.ob9 whello.rbj
	$(W32_LINK) $(W32_LINK_OPTS) @&&!
$(W32_OBJS)+hello2.ob9
$*, ,$(W32_LIBS),whello.def,whello.rbj
!

9hello3.exe: hello3.ob9 hello.ob9 whello.rbj
	$(W32_LINK) $(W32_LINK_OPTS) @&&!
$(W32_OBJS)+hello3.ob9+hello.ob9
$*, ,$(W32_LIBS),whello.def,whello.rbj
!

9hellog.exe: hellog.ob9 whello.rbj
	$(W32_LINK) $(W32_LINK_OPTS) @&&!
$(W32_OBJS)+hellog.ob9
$*, ,$(W32_LIBS),whello.def,whello.rbj
!
