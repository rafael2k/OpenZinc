# ----- General Definitions -------------------------------------------------
VERSION=btcpp310

# ----- DOS compiler options ------------------------------------------------
# --- DOS ---
DOS_CPP=bcc
DOS_LINK=tlink
DOS_LIBRARIAN=tlib
DOS_CPP_OPTS=-c  -ml -O1  -Vs -w -H=ZIL.SYM
DOS_LINK_OPTS=/c /x
DOS_LIB_OPTS=/C
DOS_OBJS=c0l

# --- Use the next line for UI_GRAPHICS_DISPLAY ---
DOS_LIBS=dos_zil dos_zil2 dos_gfx bc_lgfx emu mathl cl
# --- Use the next line for UI_BGI_DISPLAY ---
#DOS_LIBS=dos_zil dos_zil2 dos_bgi graphics emu mathl cl

.cpp.obj:
	$(DOS_CPP) $(DOS_CPP_OPTS) {$< }

# --- VROOM ---
DOS_OVL_CPP=bcc
DOS_OVL_LINK=tlink
DOS_OVL_LIBRARIAN=tlib
DOS_OVL_CPP_OPTS=-c  -ml -O1  -Vs -Y -w -H=ZIL.SYM
DOS_OVL_LINK_OPTS=/c /x
DOS_OVL_LIB_OPTS=/C
DOS_OVL_OBJS=c0l

# --- Use the next line for UI_GRAPHICS_DISPLAY ---
DOS_OVL_LIBS=/o+ dos_zilo /o- dos_zil dos_zil2 dos_gfx bc_lgfx overlay emu mathl cl
# --- Use the next line for UI_BGI_DISPLAY ---
#DOS_OVL_LIBS=/o+ dos_zilo /o- dos_zil dos_zil2 dos_bgi overlay graphics emu mathl cl

.cpp.ovl:
	$(DOS_OVL_CPP) $(DOS_OVL_CPP_OPTS) -o$*.ovl {$< }

# ----- Windows compiler options --------------------------------------------
WIN_CPP=bcc
WIN_LINK=tlink
WIN_LIBRARIAN=tlib
WIN_RC=rc

WIN_CPP_OPTS=-c -d  -ml -O1  -Vf -WE -w
WIN_RC_OPTS=-k
WIN_LINK_OPTS=/c /C /Twe /x
WIN_LIB_OPTS=/C

WIN_OBJS=c0wl
WIN_LIBS=win_zil win_zil2 import mathwl cwl ctl3dv2

.cpp.obw:
	$(WIN_CPP) $(WIN_CPP_OPTS) -o$*.obw {$< }

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean

# ----- DOS -----------------------------------------------------------------
# DOS - Library support only
dos : stredit.obj
	-@del stredit.lib
	$(DOS_LIBRARIAN) $(DOS_LIB_OPTS) @&&!
stredit.lib &
+stredit.obj
!
	copy stredit.hpp ..\..\include
	copy stredit.lib ..\..\lib\$(VERSION)
	copy p_string.dat ..\..\bin\p_string.znc

# DOS OVERLAY - Library support only
dosovl : stredit.ovl
	-@del stredito.lib
	$(DOS_OVL_LIBRARIAN) $(DOS_OVL_LIB_OPTS) @&&!
stredito.lib &
+stredit.ovl
!
	copy stredit.hpp ..\..\include
	copy stredito.lib ..\..\lib\$(VERSION)
	copy p_string.dat ..\..\bin\p_string.znc

# ----- Windows -------------------------------------------------------------
windows: wstredit.exe

wstredit.exe: main.obw wstredit.lib
	$(WIN_LINK) $(WIN_LINK_OPTS) @&&!
$(WIN_OBJS)+main.obw
$*, , wstredit wservice $(WIN_LIBS), wstredit.def
!
	$(WIN_RC) $(WIN_RC_OPTS) wstredit.rc $<

wstredit.lib : stredit.obw
	-@del wstredit.lib
	$(WIN_LIBRARIAN) $(WIN_LIB_OPTS) @&&!
$* &
+stredit.obw
!
	copy stredit.hpp ..\..\include
	copy wstredit.lib ..\..\lib\$(VERSION)
	copy p_string.dat ..\..\bin\p_string.znc


