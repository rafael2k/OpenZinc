# VLIST tutorial makefile

#    make -fbtcpp310.mak dos             (makes all the DOS vlist tutorials)
#    make -fbtcpp310.mak dosovl          (makes the DOS overlay vlist tutorials)
#    make -fbtcpp310.mak windows         (makes all the Windows vlist tutorials)

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

.c.obj:
	$(CPP) $(DOS_CPP_OPTS) {$< }

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

.c.ovl:
	$(CPP) $(DOS_OVL_CPP_OPTS) -o$*.ovl {$< }

.cpp.ovl:
	$(CPP) $(DOS_OVL_CPP_OPTS) -o$*.ovl {$< }

# ----- Windows compiler options --------------------------------------------
WIN_CPP_OPTS=-c -ml -O1  -Vf -WE -w
WIN_RC_OPTS=-k
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

# ----- Windows -------------------------------------------------------------
windows: wvlist.exe

wvlist.exe: vlist.obw g_jump.obw
	$(LINK) $(WIN_LINK_OPTS) @&&!
$(WIN_OBJS)+vlist.obw+g_jump.obw
$*, ,$(WIN_LIBS),wvlist.def
!
	$(RC) $(WIN_RC_OPTS) $<


