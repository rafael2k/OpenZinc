# ----- DOS compiler options ------------------------------------------------
DOS_CPP_OPTS=-c -ml -O1 -x- -RT- -w -I..
DOS_LINK_OPTS=/c /x
DOS_OBJS=c0l
DOS_LIBS=dos_zil emu mathl cl

DOS_CPP=bcc
DOS_LINK=tlink

.cpp.obj:
	$(DOS_CPP) $(DOS_CPP_OPTS) {$< }

!if !$d(PHARLAP16) && !$d(RATIONAL16) && !$d(POWERPACK16)
# Note:  Set the following variable to PHARLAP16 for Pharlap, RATIONAL16
# for DOS16M, or POWERPACK16 for PowerPack DPMI16.  Default is POWERPACK16.
PHARLAP16=
# Use one of the following command lines to override this setting.
#  make -fbtcpp450.mak -DPHARLAP16 dos16
#  make -fbtcpp450.mak -DRATIONAL16 dos16
#  make -fbtcpp450.mak -DPOWERPACK16 dos16
!endif

!if $d(PHARLAP16)
D16_CPP=bcc286
D16_CPP_OPTS=-c -dc -ml -O1 -x- -RT- -V -w -v -I..
D16_LINK_OPTS=/c /C /x
D16_LIB_OPTS=/C /p32
D16_OBJS=c0pl.obj
D16_DEF=b16.def
D16_BGI=
# --- Use the next line for UI_GRAPHICS_DISPLAY ---
D16_LIBS=phapi d16_zil d16_gfx bc_16gfx emu286 emu mathl bcl286
# --- Use the next line for UI_BGI_DISPLAY ---
#D16_LIBS=phapi d16_zil d16_bgi graph286 emu286 emu mathl bcl286

!elif $d(RATIONAL16)
D16_CPP=bcc
D16_CPP_OPTS=-c -dc -ml -O1 -x- -RT- -2 -f87 -Vf -w -DDOS16M -I..
D16_LINK_OPTS=/c /x /C
D16_LIB_OPTS=/C /P1024
D16_OBJS=\dos16m\lib\bcc40\bcc40c0l.obj
D16_DEF=dos16m.def
D16_BGI=
# --- Use the next line for UI_GRAPHICS_DISPLAY ---
D16_LIBS=bcc40lse bcc40l d16_zil d16_gfx bc_16gfx dos16 d16libc fp87 mathl cl
# --- Use the next line for UI_BGI_DISPLAY ---
#D16_LIBS=bcc40lse bcc40l d16_zil d16_bgi dos16 d16libc fp87 mathl cl

!elif $d(POWERPACK16)
D16_CPP=bcc
D16_CPP_OPTS=-c -dc -WX -ml -O1 -x- -RT- -V -w -DDOS16PP -I..
D16_LINK_OPTS=/Txe /c /C /x
D16_LIB_OPTS=/C /p32
D16_OBJS=c0x.obj
D16_DEF=b16pp.def
D16_BGI=+bgi\ISO_smal.obj+bgi\ISO_dial.obj+bgi\ISO_syst.obj+bgi\OEM_smal.obj+bgi\OEM_dial.obj+bgi\OEM_syst.obj
# --- Use the next line for UI_GRAPHICS_DISPLAY ---
#D16_LIBS=dpmi16 d16_zil d16_gfx bc_16gfx emux mathwl cwl
# --- Use the next line for UI_BGI_DISPLAY ---
D16_LIBS=dpmi16 d16_zil d16_bgi bgi16 emux mathwl cwl
!endif

D16_LINK=tlink
D16_LIBRARIAN=tlib

.cpp.o16:
	$(D16_CPP) $(D16_CPP_OPTS) -o$*.o16 {$< }

# ----- 32 bit DOS extended compiler options --------------------------------
# PowerPack 32
D32_CPP=bcc32
D32_CPP_OPTS=-c -WX -O1 -x- -RT- -V -w -DDOS32PP -I..
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

# ----- Windows NT compiler options -----------------------------------------
WNT_CPP=bcc32
WNT_LINK=tlink32
WNT_LIBRARIAN=tlib32
WNT_RC=brc32

WNT_CON_CPP_OPTS=-c -O1 -x- -RT- -I..
WNT_CON_LINK_OPTS=/ap /Tpe /x /c
WNT_RC_OPTS=-w32
WNT_LIB_OPTS=/C

WNT_CON_OBJS=c0x32
WNT_CON_LIBS=wnt_zil import32 cw32

.cpp.ocn:
	$(WNT_CPP) $(WNT_CON_CPP_OPTS) -o$*.ocn {$< }

# ----- Usage --------------------------------------------------------------
usage:
	@echo ...........
	@echo ...........
	@echo To generate the storage utilities for type:
	@echo make -fbtcpp450.mak dos
	@echo make -fbtcpp450.mak dos16
	@echo make -fbtcpp450.mak dos32
	@echo make -f btcpp450.mak winnt
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean

# ----- DOS -----------------------------------------------------------------
dos: browse.exe zdump.exe rrmdir.exe cppath.exe chkfile.exe gc.exe strip.exe

chkfile.exe: chkfile.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) @&&!
$(DOS_OBJS)+chkfile.obj
$*, ,$(DOS_LIBS)
!

gc.obj: cppath.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DDOGC -ogc.obj cppath.cpp

gc.exe: gc.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) @&&!
$(DOS_OBJS)+gc.obj
$*, ,$(DOS_LIBS)
!

strip.obj: cppath.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DSTRIP -ostrip.obj cppath.cpp

strip.exe: strip.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) @&&!
$(DOS_OBJS)+strip.obj
$*, ,$(DOS_LIBS)
!

cppath.exe: cppath.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) @&&!
$(DOS_OBJS)+cppath.obj
$*, ,$(DOS_LIBS)
!

rrmdir.exe: rrmdir.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) @&&!
$(DOS_OBJS)+rrmdir.obj
$*, ,$(DOS_LIBS)
!

zdump.exe: zdump.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) @&&!
$(DOS_OBJS)+zdump.obj
$*, ,$(DOS_LIBS)
!

browse.exe: browse.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) @&&!
$(DOS_OBJS)+browse.obj
$*, ,$(DOS_LIBS)
!

# ----- DOS16 ---------------------------------------------------------------
dos16: browse16.exe zdump16.exe rrmdir16.exe cppath16.exe chkfile16.exe gc16.exe strip16.exe

chkfile16.exe: chkfile.o16
	$(D16_LINK) $(D16_LINK_OPTS) @&&!
$(D16_OBJS)+chkfile.o16
$*, ,$(D16_LIBS),$(D16_DEF)
!

gc.o16: cppath.cpp
	$(D16_CPP) $(D16_CPP_OPTS) -DDOGC -ogc.o16 cppath.cpp

gc16.exe: gc.o16
	$(D16_LINK) $(D16_LINK_OPTS) @&&!
$(D16_OBJS)+gc.o16
$*, ,$(D16_LIBS),$(D16_DEF)
!

strip.o16: cppath.cpp
	$(D16_CPP) $(D16_CPP_OPTS) -DSTRIP -ostrip.o16 cppath.cpp

strip16.exe: strip.o16
	$(D16_LINK) $(D16_LINK_OPTS) @&&!
$(D16_OBJS)+strip.o16
$*, ,$(D16_LIBS),$(D16_DEF)
!

cppath16.exe: cppath.o16
	$(D16_LINK) $(D16_LINK_OPTS) @&&!
$(D16_OBJS)+cppath.o16
$*, ,$(D16_LIBS),$(D16_DEF)
!

rrmdir16.exe: rrmdir.o16
	$(D16_LINK) $(D16_LINK_OPTS) @&&!
$(D16_OBJS)+rrmdir.o16
$*, ,$(D16_LIBS),$(D16_DEF)
!

zdump16.exe: zdump.o16
	$(D16_LINK) $(D16_LINK_OPTS) @&&!
$(D16_OBJS)+zdump.o16
$*, ,$(D16_LIBS),$(D16_DEF)
!

browse16.exe: browse.o16
	$(D16_LINK) $(D16_LINK_OPTS) @&&!
$(D16_OBJS)+browse.o16
$*, ,$(D16_LIBS),$(D16_DEF)
!

# ----- DOS32 ---------------------------------------------------------------
dos32: browse32.exe zdump32.exe rrmdir32.exe cppath32.exe chkfile32.exe gc32.exe strip32.exe

chkfile32.exe: chkfile.o32
	$(D32_LINK) $(D32_LINK_OPTS) @&&!
$(D32_OBJS)+chkfile.o32
$*, ,$(D32_LIBS)
!

gc.o32: cppath.cpp
	$(D32_CPP) $(D32_CPP_OPTS) -DDOGC -ogc.o32 cppath.cpp

gc32.exe: gc.o32
	$(D32_LINK) $(D32_LINK_OPTS) @&&!
$(D32_OBJS)+gc.o32
$*, ,$(D32_LIBS)
!

strip.o32: cppath.cpp
	$(D32_CPP) $(D32_CPP_OPTS) -DSTRIP -ostrip.o32 cppath.cpp

strip32.exe: strip.o32
	$(D32_LINK) $(D32_LINK_OPTS) @&&!
$(D32_OBJS)+strip.o32
$*, ,$(D32_LIBS)
!

cppath32.exe: cppath.o32
	$(D32_LINK) $(D32_LINK_OPTS) @&&!
$(D32_OBJS)+cppath.o32
$*, ,$(D32_LIBS)
!

rrmdir32.exe: rrmdir.o32
	$(D32_LINK) $(D32_LINK_OPTS) @&&!
$(D32_OBJS)+rrmdir.o32
$*, ,$(D32_LIBS)
!

zdump32.exe: zdump.o32
	$(D32_LINK) $(D32_LINK_OPTS) @&&!
$(D32_OBJS)+zdump.o32
$*, ,$(D32_LIBS)
!

browse32.exe: browse.o32
	$(D32_LINK) $(D32_LINK_OPTS) @&&!
$(D32_OBJS)+browse.o32
$*, ,$(D32_LIBS)
!

# ----- Windows NT ----------------------------------------------------------
winnt: nbrowse.exe nzdump.exe nrrmdir.exe ncppath.exe nchkfile.exe ngc.exe nstrip.exe

nchkfile.exe: chkfile.ocn
	$(WNT_LINK) $(WNT_CON_LINK_OPTS) @&&!
$(WNT_CON_OBJS)+chkfile.ocn
$*, ,$(WNT_CON_LIBS)
!

gc.ocn:
	$(WNT_CPP) $(WNT_CON_CPP_OPTS) -DDOGC -ogc.ocn cppath.cpp

ngc.exe: gc.ocn
	$(WNT_LINK) $(WNT_CON_LINK_OPTS) @&&!
$(WNT_CON_OBJS)+gc.ocn
$*, ,$(WNT_CON_LIBS)
!

strip.ocn:
	$(WNT_CPP) $(WNT_CON_CPP_OPTS) -DSTRIP -ostrip.ocn cppath.cpp

nstrip.exe: strip.ocn
	$(WNT_LINK) $(WNT_CON_LINK_OPTS) @&&!
$(WNT_CON_OBJS)+strip.ocn
$*, ,$(WNT_CON_LIBS)
!

ncppath.exe: cppath.ocn
	$(WNT_LINK) $(WNT_CON_LINK_OPTS) @&&!
$(WNT_CON_OBJS)+cppath.ocn
$*, ,$(WNT_CON_LIBS)
!

nrrmdir.exe: rrmdir.ocn
	$(WNT_LINK) $(WNT_CON_LINK_OPTS) @&&!
$(WNT_CON_OBJS)+rrmdir.ocn
$*, ,$(WNT_CON_LIBS)
!

nzdump.exe: zdump.ocn
	$(WNT_LINK) $(WNT_CON_LINK_OPTS) @&&!
$(WNT_CON_OBJS)+zdump.ocn
$*, ,$(WNT_CON_LIBS)
!

nbrowse.exe: browse.ocn
	$(WNT_LINK) $(WNT_CON_LINK_OPTS) @&&!
$(WNT_CON_OBJS)+browse.ocn
$*, ,$(WNT_CON_LIBS)
!

