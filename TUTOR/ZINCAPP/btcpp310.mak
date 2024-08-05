# ZINCAPP tutorial makefile

#    make -fbtcpp310.mak dos           (makes the DOS zincapp program)
#    make -fbtcpp310.mak dosovl        (makes the DOS overlay zincapp program)
#    make -fbtcpp310.mak windows       (makes the Windows zincapp program)

# Be sure to update your TURBOC.CFG file to include the Zinc paths, e.g.:
#   -I.;C:\ZINC\INCLUDE;C:\BC45\INCLUDE
#   -L.;C:\ZINC\LIB\btcpp310;C:\BC45\LIB
# and your TLINK.CFG file to include the Zinc paths, e.g.:
#   -L.;C:\ZINC\LIB\btcpp310;C:\BC45\LIB

CPP=bcc
LINK=tlink
RC=rc

## Compiler and linker: (Add -v to CPP_OPTS and /v to LINK_OPTS for debug.)

# ----- DOS compiler options ------------------------------------------------
DOS_CPP_OPTS=-c -ml -O1  -w
DOS_LINK_OPTS=/c /x
DOS_OBJS=c0l
# --- Use the next line for UI_GRAPHICS_DISPLAY ---
DOS_LIBS=dos_zil dos_zil2 dos_gfx bc_lgfx emu mathl cl
# --- Use the next line for UI_BGI_DISPLAY ---
#DOS_LIBS=dos_zil dos_zil2 dos_bgi graphics emu mathl cl

.cpp.obj:
	$(CPP) $(DOS_CPP_OPTS) {$< }

# ----- DOS VROOM overlay compiler options ---------------------------------
DOS_OVL_CPP_OPTS=-c -ml -O1  -Z -Vs -Y -w
DOS_OVL_LINK_OPTS=/c /x
DOS_OVL_OBJS=c0l
# --- Use the next line for UI_GRAPHICS_DISPLAY ---
DOS_OVL_LIBS=/o+ dos_zilo /o- dos_zil dos_zil2 dos_gfx bc_lgfx overlay emu mathl cl
# --- Use the next line for UI_BGI_DISPLAY ---
#DOS_OVL_LIBS=/o+ dos_zilo /o- dos_zil dos_zil2 dos_bgi overlay graphics emu mathl cl

.cpp.ovl:
	$(CPP) $(DOS_OVL_CPP_OPTS) -o$*.ovl {$< }

# ----- Windows compiler options --------------------------------------------
WIN_CPP_OPTS=-c -ml -O1  -Vf -WE -w
WIN_RC_OPTS=
WIN_LINK_OPTS=/c /C /Twe /x
WIN_OBJS=c0wl
WIN_LIBS=win_zil win_zil2 mathwl import cwl  

.cpp.obw:
	$(CPP) $(WIN_CPP_OPTS) -o$*.obw {$< }


# ----- Usage --------------------------------------------------------------
usage:
	@echo ...........
	@echo ...........
	@echo To make this Zinc tutorial for Borland C++ type:
	@echo make -fbtcpp310.mak dos
	@echo make -fbtcpp310.mak dosovl
	@echo make -fbtcpp310.mak windows
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean

# ----- DOS -----------------------------------------------------------------
dos: zincapp.exe

zincapp.exe: zincapp.obj control.obj display.obj window.obj event.obj help.obj support.obj
	$(LINK) $(DOS_LINK_OPTS) @&&!
$(DOS_OBJS)+zincapp.obj+control.obj+display.obj+window.obj+event.obj+help.obj+support.obj
$*, ,$(DOS_LIBS)
!

# ----- DOS VROOM -----------------------------------------------------------
dosovl: zincappv.exe

zincappv.exe: zincapp.ovl control.ovl display.ovl window.ovl event.ovl help.ovl support.ovl
	$(LINK) $(DOS_OVL_LINK_OPTS) @&&!
$(DOS_OVL_OBJS)+zincapp.ovl+control.ovl+display.ovl+window.ovl+event.ovl+help.ovl+support.ovl
$*, , $(DOS_OVL_LIBS)
!

# ----- Windows -------------------------------------------------------------
windows: wzincapp.exe

wzincapp.exe: zincapp.obw control.obw display.obw window.obw event.obw help.obw support.obw
	$(LINK) $(WIN_LINK_OPTS) @&&!
$(WIN_OBJS)+zincapp.obw+control.obw+display.obw+window.obw+event.obw+help.obw+support.obw
$*, ,$(WIN_LIBS),wzincapp.def
!
	$(RC) $(WIN_RC_OPTS) $<


