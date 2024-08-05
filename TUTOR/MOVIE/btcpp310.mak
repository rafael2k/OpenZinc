# MOVIE tutorial makefile

#    make -fbtcpp310.mak dos             (makes all the DOS movie tutorials)
#    make -fbtcpp310.mak dosovl          (makes the DOS overlay movie tutorials)
#    make -fbtcpp310.mak windows         (makes all the Windows movie tutorials)

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

# ----- Windows -------------------------------------------------------------
windows: wmovie.exe wmovie1.exe wmovie2.exe wmovie3.exe wmovie4.exe wmovie5.exe wmovie6.exe wmovie7.exe

wmovie.exe: movie.obw p_movie.obw
	$(LINK) $(WIN_LINK_OPTS) @&&!
$(WIN_OBJS)+movie.obw+p_movie.obw
$*, ,$(WIN_LIBS),wmovie.def
!
	$(RC) $(WIN_RC_OPTS) $<

wmovie1.exe: movie1.obw p_movie1.obw
	$(LINK) $(WIN_LINK_OPTS) @&&!
$(WIN_OBJS)+movie1.obw+p_movie1.obw
$*, ,$(WIN_LIBS),wmovie.def
!
	$(RC) $(WIN_RC_OPTS) $<

wmovie2.exe: movie2.obw p_movie2.obw
	$(LINK) $(WIN_LINK_OPTS) @&&!
$(WIN_OBJS)+movie2.obw+p_movie2.obw
$*, ,$(WIN_LIBS),wmovie.def
!
	$(RC) $(WIN_RC_OPTS) $<

wmovie3.exe: movie3.obw p_movie3.obw
	$(LINK) $(WIN_LINK_OPTS) @&&!
$(WIN_OBJS)+movie3.obw+p_movie3.obw
$*, ,$(WIN_LIBS),wmovie.def
!
	$(RC) $(WIN_RC_OPTS) $<

wmovie4.exe: movie4.obw p_movie4.obw
	$(LINK) $(WIN_LINK_OPTS) @&&!
$(WIN_OBJS)+movie4.obw+p_movie4.obw
$*, ,$(WIN_LIBS),wmovie.def
!
	$(RC) $(WIN_RC_OPTS) $<

wmovie5.exe: movie5.obw p_movie5.obw
	$(LINK) $(WIN_LINK_OPTS) @&&!
$(WIN_OBJS)+movie5.obw+p_movie5.obw
$*, ,$(WIN_LIBS),wmovie.def
!
	$(RC) $(WIN_RC_OPTS) $<

wmovie6.exe: movie6.obw p_movie6.obw
	$(LINK) $(WIN_LINK_OPTS) @&&!
$(WIN_OBJS)+movie6.obw+p_movie6.obw
$*, ,$(WIN_LIBS),wmovie.def
!
	$(RC) $(WIN_RC_OPTS) $<

wmovie7.exe: movie7.obw p_movie7.obw
	$(LINK) $(WIN_LINK_OPTS) @&&!
$(WIN_OBJS)+movie7.obw+p_movie7.obw
$*, ,$(WIN_LIBS),wmovie.def
!
	$(RC) $(WIN_RC_OPTS) $<


