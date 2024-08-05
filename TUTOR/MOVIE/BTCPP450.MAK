# MOVIE tutorial makefile

#    make -fbtcpp450.mak dos             (makes all the DOS movie tutorials)
#    make -fbtcpp450.mak dosovl          (makes the DOS overlay movie tutorials)
#    make -fbtcpp450.mak dos16           (makes all the DOS extender movie tutorials)
#    make -fbtcpp450.mak dos32           (makes all the DOS extender movie tutorials)
#    make -fbtcpp450.mak windows         (makes all the Windows movie tutorials)
#    make -f btcpp450.mak winnt          (makes all the Windows NT movie tutorials)

# Be sure to update your TURBOC.CFG file to include the Zinc paths, e.g.:
#   -I.;C:\ZINC\INCLUDE;C:\BC45\INCLUDE
#   -L.;C:\ZINC\LIB\BTCPP450;C:\BC45\LIB
# and your TLINK.CFG file to include the Zinc paths, e.g.:
#   -L.;C:\ZINC\LIB\BTCPP450;C:\BC45\LIB

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
#  make -fbtcpp450.mak -DPHARLAP16 dos16
#  make -fbtcpp450.mak -DRATIONAL16 dos16
#  make -fbtcpp450.mak -DPOWERPACK16 dos16
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
#WNT_CPP_OPTS=-c
WNT_LINK_OPTS=-Tpe -aa -x -c
WNT_CON_LINK_OPTS=/Tpe /ap /x /c
WNT_RC_OPTS=-w32
WNT_LIB_OPTS=/C

WNT_OBJS=c0w32
WNT_CON_OBJS=c0x32
WNT_LIBS=wnt_zil import32 cw32 ctl3d32
WNT_CON_LIBS=wnt_zil import32 cw32

.c.obn:
	$(WNT_CPP) $(WNT_CPP_OPTS) -o$*.obn {$< }

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
	@echo make -fbtcpp450.mak dos
	@echo make -fbtcpp450.mak dosovl
	@echo make -fbtcpp450.mak dos16
	@echo make -fbtcpp450.mak dos32
	@echo make -fbtcpp450.mak windows
	@echo make -f btcpp450.mak winnt
	@echo make -f btcpp450.mak win32
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean

# ----- DOS -----------------------------------------------------------------
dos: movie.exe movie1.exe movie2.exe movie3.exe movie4.exe movie5.exe movie6.exe movie7.exe

movie.exe: movie.obj p_movie.obj
	$(LINK) $(DOS_LINK_OPTS) @&&!
$(DOS_OBJS)+movie.obj+p_movie.obj
$*, ,$(DOS_LIBS)
!

movie1.exe: movie1.obj p_movie1.obj
	$(LINK) $(DOS_LINK_OPTS) @&&!
$(DOS_OBJS)+movie1.obj+p_movie1.obj
$*, ,$(DOS_LIBS)
!

movie2.exe: movie2.obj p_movie2.obj
	$(LINK) $(DOS_LINK_OPTS) @&&!
$(DOS_OBJS)+movie2.obj+p_movie2.obj
$*, ,$(DOS_LIBS)
!

movie3.exe: movie3.obj p_movie3.obj
	$(LINK) $(DOS_LINK_OPTS) @&&!
$(DOS_OBJS)+movie3.obj+p_movie3.obj
$*, ,$(DOS_LIBS)
!

movie4.exe: movie4.obj p_movie4.obj
	$(LINK) $(DOS_LINK_OPTS) @&&!
$(DOS_OBJS)+movie4.obj+p_movie4.obj
$*, ,$(DOS_LIBS)
!

movie5.exe: movie5.obj p_movie5.obj
	$(LINK) $(DOS_LINK_OPTS) @&&!
$(DOS_OBJS)+movie5.obj+p_movie5.obj
$*, ,$(DOS_LIBS)
!

movie6.exe: movie6.obj p_movie6.obj
	$(LINK) $(DOS_LINK_OPTS) @&&!
$(DOS_OBJS)+movie6.obj+p_movie6.obj
$*, ,$(DOS_LIBS)
!

movie7.exe: movie7.obj p_movie7.obj
	$(LINK) $(DOS_LINK_OPTS) @&&!
$(DOS_OBJS)+movie7.obj+p_movie7.obj
$*, ,$(DOS_LIBS)
!

# ----- DOS VROOM -----------------------------------------------------------
dosovl: moviev.exe movie1v.exe movie2v.exe movie3v.exe movie4v.exe movie5v.exe movie6v.exe movie7v.exe

moviev.exe: movie.ovl p_movie.ovl
	$(LINK) $(DOS_OVL_LINK_OPTS) @&&!
$(DOS_OVL_OBJS)+movie.ovl+p_movie.ovl
$*, , $(DOS_OVL_LIBS)
!

movie1v.exe: movie1.ovl p_movie1.ovl
	$(LINK) $(DOS_OVL_LINK_OPTS) @&&!
$(DOS_OVL_OBJS)+movie1.ovl+p_movie1.ovl
$*, , $(DOS_OVL_LIBS)
!

movie2v.exe: movie2.ovl p_movie2.ovl
	$(LINK) $(DOS_OVL_LINK_OPTS) @&&!
$(DOS_OVL_OBJS)+movie2.ovl+p_movie2.ovl
$*, , $(DOS_OVL_LIBS)
!

movie3v.exe: movie3.ovl p_movie3.ovl
	$(LINK) $(DOS_OVL_LINK_OPTS) @&&!
$(DOS_OVL_OBJS)+movie3.ovl+p_movie3.ovl
$*, , $(DOS_OVL_LIBS)
!

movie4v.exe: movie4.ovl p_movie4.ovl
	$(LINK) $(DOS_OVL_LINK_OPTS) @&&!
$(DOS_OVL_OBJS)+movie4.ovl+p_movie4.ovl
$*, , $(DOS_OVL_LIBS)
!

movie5v.exe: movie5.ovl p_movie5.ovl
	$(LINK) $(DOS_OVL_LINK_OPTS) @&&!
$(DOS_OVL_OBJS)+movie5.ovl+p_movie5.ovl
$*, , $(DOS_OVL_LIBS)
!

movie6v.exe: movie6.ovl p_movie6.ovl
	$(LINK) $(DOS_OVL_LINK_OPTS) @&&!
$(DOS_OVL_OBJS)+movie6.ovl+p_movie6.ovl
$*, , $(DOS_OVL_LIBS)
!

movie7v.exe: movie7.ovl p_movie7.ovl
	$(LINK) $(DOS_OVL_LINK_OPTS) @&&!
$(DOS_OVL_OBJS)+movie7.ovl+p_movie7.ovl
$*, , $(DOS_OVL_LIBS)
!

# ----- DOS Extender ----------------------------------------------------------
dos16: movie16.exe movie116.exe movie216.exe movie316.exe movie416.exe movie516.exe movie616.exe movie716.exe

movie16.exe: movie.o16 p_movie.o16
	$(LINK) $(D16_LINK_OPTS) @&&!
$(D16_OBJS)+movie.o16+p_movie.o16
$*, ,$(D16_LIBS),$(D16_DEF)
!

movie116.exe: movie1.o16 p_movie1.o16
	$(LINK) $(D16_LINK_OPTS) @&&!
$(D16_OBJS)+movie1.o16+p_movie1.o16
$*, ,$(D16_LIBS),$(D16_DEF)
!

movie216.exe: movie2.o16 p_movie2.o16
	$(LINK) $(D16_LINK_OPTS) @&&!
$(D16_OBJS)+movie2.o16+p_movie2.o16
$*, ,$(D16_LIBS),$(D16_DEF)
!

movie316.exe: movie3.o16 p_movie3.o16
	$(LINK) $(D16_LINK_OPTS) @&&!
$(D16_OBJS)+movie3.o16+p_movie3.o16
$*, ,$(D16_LIBS),$(D16_DEF)
!

movie416.exe: movie4.o16 p_movie4.o16
	$(LINK) $(D16_LINK_OPTS) @&&!
$(D16_OBJS)+movie4.o16+p_movie4.o16
$*, ,$(D16_LIBS),$(D16_DEF)
!

movie516.exe: movie5.o16 p_movie5.o16
	$(LINK) $(D16_LINK_OPTS) @&&!
$(D16_OBJS)+movie5.o16+p_movie5.o16
$*, ,$(D16_LIBS),$(D16_DEF)
!

movie616.exe: movie6.o16 p_movie6.o16
	$(LINK) $(D16_LINK_OPTS) @&&!
$(D16_OBJS)+movie6.o16+p_movie6.o16
$*, ,$(D16_LIBS),$(D16_DEF)
!

movie716.exe: movie7.o16 p_movie7.o16
	$(LINK) $(D16_LINK_OPTS) @&&!
$(D16_OBJS)+movie7.o16+p_movie7.o16
$*, ,$(D16_LIBS),$(D16_DEF)
!

dos32: movie32.exe movie132.exe movie232.exe movie332.exe movie432.exe movie532.exe movie632.exe movie732.exe

movie32.exe: movie.o32 p_movie.o32
	$(D32_LINK) $(D32_LINK_OPTS) @&&!
$(D32_OBJS)+movie.o32+p_movie.o32
$*, ,$(D32_LIBS)
!

movie132.exe: movie1.o32 p_movie1.o32
	$(D32_LINK) $(D32_LINK_OPTS) @&&!
$(D32_OBJS)+movie1.o32+p_movie1.o32
$*, ,$(D32_LIBS)
!

movie232.exe: movie2.o32 p_movie2.o32
	$(D32_LINK) $(D32_LINK_OPTS) @&&!
$(D32_OBJS)+movie2.o32+p_movie2.o32
$*, ,$(D32_LIBS)
!

movie332.exe: movie3.o32 p_movie3.o32
	$(D32_LINK) $(D32_LINK_OPTS) @&&!
$(D32_OBJS)+movie3.o32+p_movie3.o32
$*, ,$(D32_LIBS)
!

movie432.exe: movie4.o32 p_movie4.o32
	$(D32_LINK) $(D32_LINK_OPTS) @&&!
$(D32_OBJS)+movie4.o32+p_movie4.o32
$*, ,$(D32_LIBS)
!

movie532.exe: movie5.o32 p_movie5.o32
	$(D32_LINK) $(D32_LINK_OPTS) @&&!
$(D32_OBJS)+movie5.o32+p_movie5.o32
$*, ,$(D32_LIBS)
!

movie632.exe: movie6.o32 p_movie6.o32
	$(D32_LINK) $(D32_LINK_OPTS) @&&!
$(D32_OBJS)+movie6.o32+p_movie6.o32
$*, ,$(D32_LIBS)
!

movie732.exe: movie7.o32 p_movie7.o32
	$(D32_LINK) $(D32_LINK_OPTS) @&&!
$(D32_OBJS)+movie7.o32+p_movie7.o32
$*, ,$(D32_LIBS)
!

# ----- Windows -------------------------------------------------------------
windows: wmovie.exe wmovie1.exe wmovie2.exe wmovie3.exe wmovie4.exe wmovie5.exe wmovie6.exe wmovie7.exe

wmovie.exe: movie.obw p_movie.obw
	$(LINK) $(WIN_LINK_OPTS) @&&!
$(WIN_OBJS)+movie.obw+p_movie.obw
$*, ,$(WIN_LIBS),wmovie.def
!
	$(RC) $(WIN_RC_OPTS) wmovie.rc $<

wmovie1.exe: movie1.obw p_movie1.obw
	$(LINK) $(WIN_LINK_OPTS) @&&!
$(WIN_OBJS)+movie1.obw+p_movie1.obw
$*, ,$(WIN_LIBS),wmovie.def
!
	$(RC) $(WIN_RC_OPTS) wmovie.rc $<

wmovie2.exe: movie2.obw p_movie2.obw
	$(LINK) $(WIN_LINK_OPTS) @&&!
$(WIN_OBJS)+movie2.obw+p_movie2.obw
$*, ,$(WIN_LIBS),wmovie.def
!
	$(RC) $(WIN_RC_OPTS) wmovie.rc $<

wmovie3.exe: movie3.obw p_movie3.obw
	$(LINK) $(WIN_LINK_OPTS) @&&!
$(WIN_OBJS)+movie3.obw+p_movie3.obw
$*, ,$(WIN_LIBS),wmovie.def
!
	$(RC) $(WIN_RC_OPTS) wmovie.rc $<

wmovie4.exe: movie4.obw p_movie4.obw
	$(LINK) $(WIN_LINK_OPTS) @&&!
$(WIN_OBJS)+movie4.obw+p_movie4.obw
$*, ,$(WIN_LIBS),wmovie.def
!
	$(RC) $(WIN_RC_OPTS) wmovie.rc $<

wmovie5.exe: movie5.obw p_movie5.obw
	$(LINK) $(WIN_LINK_OPTS) @&&!
$(WIN_OBJS)+movie5.obw+p_movie5.obw
$*, ,$(WIN_LIBS),wmovie.def
!
	$(RC) $(WIN_RC_OPTS) wmovie.rc $<

wmovie6.exe: movie6.obw p_movie6.obw
	$(LINK) $(WIN_LINK_OPTS) @&&!
$(WIN_OBJS)+movie6.obw+p_movie6.obw
$*, ,$(WIN_LIBS),wmovie.def
!
	$(RC) $(WIN_RC_OPTS) wmovie.rc $<

wmovie7.exe: movie7.obw p_movie7.obw
	$(LINK) $(WIN_LINK_OPTS) @&&!
$(WIN_OBJS)+movie7.obw+p_movie7.obw
$*, ,$(WIN_LIBS),wmovie.def
!
	$(RC) $(WIN_RC_OPTS) wmovie.rc $<

# ----- Windows NT ----------------------------------------------------------
winnt: nmovie.exe nmovie1.exe nmovie2.exe nmovie3.exe nmovie4.exe nmovie5.exe nmovie6.exe nmovie7.exe

nmovie.exe: movie.obn p_movie.obn wmovie.rbj
	$(WNT_LINK) $(WNT_LINK_OPTS) @&&!
$(WNT_OBJS)+movie.obn+p_movie.obn
$*, ,$(WNT_LIBS),wmovie.def,wmovie.rbj
!

nmovie1.exe: movie1.obn p_movie1.obn wmovie.rbj
	$(WNT_LINK) $(WNT_LINK_OPTS) @&&!
$(WNT_OBJS)+movie1.obn+p_movie1.obn
$*, ,$(WNT_LIBS),wmovie.def,wmovie.rbj
!

nmovie2.exe: movie2.obn p_movie2.obn wmovie.rbj
	$(WNT_LINK) $(WNT_LINK_OPTS) @&&!
$(WNT_OBJS)+movie2.obn+p_movie2.obn
$*, ,$(WNT_LIBS),wmovie.def,wmovie.rbj
!

nmovie3.exe: movie3.obn p_movie3.obn wmovie.rbj
	$(WNT_LINK) $(WNT_LINK_OPTS) @&&!
$(WNT_OBJS)+movie3.obn+p_movie3.obn
$*, ,$(WNT_LIBS),wmovie.def,wmovie.rbj
!

nmovie4.exe: movie4.obn p_movie4.obn wmovie.rbj
	$(WNT_LINK) $(WNT_LINK_OPTS) @&&!
$(WNT_OBJS)+movie4.obn+p_movie4.obn
$*, ,$(WNT_LIBS),wmovie.def,wmovie.rbj
!

nmovie5.exe: movie5.obn p_movie5.obn wmovie.rbj
	$(WNT_LINK) $(WNT_LINK_OPTS) @&&!
$(WNT_OBJS)+movie5.obn+p_movie5.obn
$*, ,$(WNT_LIBS),wmovie.def,wmovie.rbj
!

nmovie6.exe: movie6.obn p_movie6.obn wmovie.rbj
	$(WNT_LINK) $(WNT_LINK_OPTS) @&&!
$(WNT_OBJS)+movie6.obn+p_movie6.obn
$*, ,$(WNT_LIBS),wmovie.def,wmovie.rbj
!

nmovie7.exe: movie7.obn p_movie7.obn wmovie.rbj
	$(WNT_LINK) $(WNT_LINK_OPTS) @&&!
$(WNT_OBJS)+movie7.obn+p_movie7.obn
$*, ,$(WNT_LIBS),wmovie.def,wmovie.rbj
!

# ----- 32 bit Windows ------------------------------------------------------
win32: 9movie.exe 9movie1.exe 9movie2.exe 9movie3.exe 9movie4.exe 9movie5.exe 9movie6.exe 9movie7.exe

9movie.exe: movie.ob9 p_movie.ob9 wmovie.rbj
	$(W32_LINK) $(W32_LINK_OPTS) @&&!
$(W32_OBJS)+movie.ob9+p_movie.ob9
$*, ,$(W32_LIBS),wmovie.def,wmovie.rbj
!

9movie1.exe: movie1.ob9 p_movie1.ob9 wmovie.rbj
	$(W32_LINK) $(W32_LINK_OPTS) @&&!
$(W32_OBJS)+movie1.ob9+p_movie1.ob9
$*, ,$(W32_LIBS),wmovie.def,wmovie.rbj
!

9movie2.exe: movie2.ob9 p_movie2.ob9 wmovie.rbj
	$(W32_LINK) $(W32_LINK_OPTS) @&&!
$(W32_OBJS)+movie2.ob9+p_movie2.ob9
$*, ,$(W32_LIBS),wmovie.def,wmovie.rbj
!

9movie3.exe: movie3.ob9 p_movie3.ob9 wmovie.rbj
	$(W32_LINK) $(W32_LINK_OPTS) @&&!
$(W32_OBJS)+movie3.ob9+p_movie3.ob9
$*, ,$(W32_LIBS),wmovie.def,wmovie.rbj
!

9movie4.exe: movie4.ob9 p_movie4.ob9 wmovie.rbj
	$(W32_LINK) $(W32_LINK_OPTS) @&&!
$(W32_OBJS)+movie4.ob9+p_movie4.ob9
$*, ,$(W32_LIBS),wmovie.def,wmovie.rbj
!

9movie5.exe: movie5.ob9 p_movie5.ob9 wmovie.rbj
	$(W32_LINK) $(W32_LINK_OPTS) @&&!
$(W32_OBJS)+movie5.ob9+p_movie5.ob9
$*, ,$(W32_LIBS),wmovie.def,wmovie.rbj
!

9movie6.exe: movie6.ob9 p_movie6.ob9 wmovie.rbj
	$(W32_LINK) $(W32_LINK_OPTS) @&&!
$(W32_OBJS)+movie6.ob9+p_movie6.ob9
$*, ,$(W32_LIBS),wmovie.def,wmovie.rbj
!

9movie7.exe: movie7.ob9 p_movie7.ob9 wmovie.rbj
	$(W32_LINK) $(W32_LINK_OPTS) @&&!
$(W32_OBJS)+movie7.ob9+p_movie7.ob9
$*, ,$(W32_LIBS),wmovie.def,wmovie.rbj
!
