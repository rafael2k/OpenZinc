# HELLO tutorial makefile

#    make -fbtcpp310.mak dos             (makes the DOS hello tutorials)
#    make -fbtcpp310.mak dosovl          (makes the DOS overlay hello tutorials)
#    make -fbtcpp310.mak windows         (makes the Windows hello tutorials)

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


# ----- Windows -------------------------------------------------------------
windows: whello1.exe whello2.exe whello3.exe whellog.exe

whello1.exe: hello1.obw
	$(LINK) $(WIN_LINK_OPTS) @&&!
$(WIN_OBJS)+hello1.obw
$*, ,$(WIN_LIBS),whello.def
!
	$(RC) $(WIN_RC_OPTS) $<

whello2.exe: hello2.obw
	$(LINK) $(WIN_LINK_OPTS) @&&!
$(WIN_OBJS)+hello2.obw
$*, ,$(WIN_LIBS),whello.def
!
	$(RC) $(WIN_RC_OPTS) $<

whello3.exe: hello3.obw hello.obw
	$(LINK) $(WIN_LINK_OPTS) @&&!
$(WIN_OBJS)+hello3.obw+hello.obw
$*, ,$(WIN_LIBS),whello.def
!
	$(RC) $(WIN_RC_OPTS) $<

whellog.exe: hellog.obw
	$(LINK) $(WIN_LINK_OPTS) @&&!
$(WIN_OBJS)+hellog.obw
$*, ,$(WIN_LIBS),whello.def
!
	$(RC) $(WIN_RC_OPTS) $<


