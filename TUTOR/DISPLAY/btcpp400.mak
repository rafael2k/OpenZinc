# DISPLAY tutorial makefile

#	make -fbtcpp400.mak dos        (makes the DOS display program)
#	make -fbtcpp400.mak dosovl     (makes the DOS overlay display program)
#	make -fbtcpp400.mak dos16      (makes the DOS extender display program)
#	make -fbtcpp400.mak dos32      (makes the DOS extender display program)

# Be sure to update your TURBOC.CFG file to include the Zinc paths, e.g.:
#   -I.;C:\ZINC\INCLUDE;C:\BC45\INCLUDE
#   -L.;C:\ZINC\LIB\btcpp400;C:\BC45\LIB
# and your TLINK.CFG file to include the Zinc paths, e.g.:
#   -L.;C:\ZINC\LIB\btcpp400;C:\BC45\LIB

CPP=bcc
LINK=tlink

## Compiler and linker: (Add -v to CPP_OPTS and /v to LINK_OPTS for debug.)

# ----- DOS compiler options ------------------------------------------------
DOS_CPP_OPTS=-c -ml -O1 -x- -RT- -w
DOS_LINK_OPTS=/c /x
DOS_OBJS=c0l
DOS_LIBS=dos_zil dos_bgi graphics emu mathl cl

.cpp.obj:
	$(CPP) $(DOS_CPP_OPTS) {$< }

# ----- DOS VROOM overlay compiler options ---------------------------------
DOS_OVL_CPP_OPTS=-c -ml -O1 -x- -RT- -Z -Vs -Y -w
DOS_OVL_LINK_OPTS=/c /x
DOS_OVL_OBJS=c0l
DOS_OVL_LIBS=/o+ dos_zilo /o- dos_zil dos_bgi overlay graphics emu mathl cl

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
D16_CPP_OPTS=-c -ml -O1 -x- -RT- -V -w -DGFX_DISPLAY
D16_LINK_OPTS=/c /C /x
D16_OBJS=c0pl.obj
D16_DEF=b16.def
D16_LIBS=phapi d16_zil d16_gfx bc_16gfx emu286 emu mathl bcl286

!elif $d(RATIONAL16)
D16_CPP=bcc
D16_CPP_OPTS=-c -ml -O1 -x- -RT- -2 -Vf -f87 -w -DDOS16M 
D16_LINK_OPTS=/e /c /x /C 
D16_OBJS=\dos16m\lib\bcc40\bcc40c0l.obj
D16_DEF=dos16m.def
D16_PATH=\dos16m\bin
D16_LIBS=bcc40lse bcc40l d16_zil d16_gfx bc_16gfx dos16 d16libc fp87 mathl cl

!elif $d(POWERPACK16)
D16_CPP=bcc
D16_CPP_OPTS=-c -WX -ml -O1 -x- -RT- -V -w -DDOS16PP
D16_LINK_OPTS=/Txe /c /C /x
D16_OBJS=c0x.obj
D16_DEF=b16pp.def
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
D32_LIBS=dpmi32 d32_zil d32_bgi bgi32 cw32

.cpp.o32:
	$(D32_CPP) $(D32_CPP_OPTS) -o$*.o32 {$< }

# ----- Usage --------------------------------------------------------------
usage:
	@echo ...........
	@echo ...........
	@echo To make this Zinc tutorial for Borland C++ type:
	@echo make -fbtcpp400.mak dos
	@echo make -fbtcpp400.mak dosovl
	@echo make -fbtcpp400.mak dos16
	@echo make -fbtcpp400.mak dos32
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean

# ----- DOS -----------------------------------------------------------------
dos: display.exe

display.exe: display.obj
	$(LINK) $(DOS_LINK_OPTS) @&&!
$(DOS_OBJS)+display.obj
$*, ,$(DOS_LIBS)
!

# ----- DOS VROOM -----------------------------------------------------------
dosovl: dispv.exe

dispv.exe: display.ovl
	$(LINK) $(DOS_OVL_LINK_OPTS) @&&!
$(DOS_OVL_OBJS)+display.ovl
$*, , $(DOS_OVL_LIBS)
!

# ----- DOS Extender ----------------------------------------------------------
dos16: disp16.exe

disp16.exe: display.o16
	$(LINK) $(D16_LINK_OPTS) @&&!
$(D16_OBJS)+display.o16
$*, ,$(D16_LIBS),$(D16_DEF)
!

dos32: disp32.exe

disp32.exe: display.o32
	$(D32_LINK) $(D32_LINK_OPTS) @&&!
$(D32_OBJS)+display.o32
$*, ,$(D32_LIBS)
!
