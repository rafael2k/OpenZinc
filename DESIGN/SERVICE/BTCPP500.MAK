# ----- General Definitions -------------------------------------------------
VERSION=btcpp500

# ----- DOS compiler options ------------------------------------------------
# --- DOS ---
DOS_CPP=bcc
DOS_LINK=tlink
DOS_LIBRARIAN=tlib
DOS_CPP_OPTS=-c -dc -ml -O1 -x- -RT- -Vs -w -H=ZIL.SYM
DOS_LINK_OPTS=/c /x
DOS_LIB_OPTS=/C
DOS_OBJS=c0l

# --- Use the next line for UI_GRAPHICS_DISPLAY ---
DOS_LIBS=dos_zil dos_gfx bc_lgfx emu mathl cl
# --- Use the next line for UI_BGI_DISPLAY ---
#DOS_LIBS=dos_zil dos_bgi graphics emu mathl cl

.cpp.obj:
	$(DOS_CPP) $(DOS_CPP_OPTS) {$< }

# --- VROOM ---
DOS_OVL_CPP=bcc
DOS_OVL_LINK=tlink
DOS_OVL_LIBRARIAN=tlib
DOS_OVL_CPP_OPTS=-c -dc -ml -O1 -x- -RT- -Vs -Y -w -H=ZIL.SYM
DOS_OVL_LINK_OPTS=/c /x
DOS_OVL_LIB_OPTS=/C
DOS_OVL_OBJS=c0l

# --- Use the next line for UI_GRAPHICS_DISPLAY ---
DOS_OVL_LIBS=/o+ dos_zilo /o- dos_zil dos_gfx bc_lgfx overlay emu mathl cl
# --- Use the next line for UI_BGI_DISPLAY ---
#DOS_OVL_LIBS=/o+ dos_zilo /o- dos_zil dos_bgi overlay graphics emu mathl cl

.cpp.ovl:
	$(DOS_OVL_CPP) $(DOS_OVL_CPP_OPTS) -o$*.ovl {$< }

# --- D16 ---
!if !$d(PHARLAP16) && !$d(RATIONAL16) && !$d(POWERPACK16)
PHARLAP16=
!endif

!if $d(PHARLAP16)
D16_CPP=bcc286
D16_CPP_OPTS=-c -dc -ml -O1 -x- -RT- -V -w -H=ZIL.SYM
D16_LINK_OPTS=/c /C /x
D16_LIB_OPTS=/C /p32
D16_OBJS=c0pl.obj
D16_DEF=b16.def
# --- Use the next line for UI_GRAPHICS_DISPLAY ---
D16_LIBS=phapi d16_zil d16_gfx bc_16gfx emu286 emu mathl bcl286
# --- Use the next line for UI_BGI_DISPLAY ---
#D16_LIBS=phapi d16_zil d16_bgi graph286 emu286 emu mathl bcl286

!elif $d(RATIONAL16)
D16_CPP=bcc
D16_CPP_OPTS=-c -dc -ml -O1 -x- -RT- -2 -f87 -Vf -w -DDOS16M -H=ZIL.SYM
D16_LINK_OPTS=/c /x /C
D16_LIB_OPTS=/C /P1024
D16_OBJS=\dos16m\lib\bcc40\bcc40c0l.obj
D16_DEF=dos16m.def
# --- Use the next line for UI_GRAPHICS_DISPLAY ---
D16_LIBS=bcc40lse bcc40l d16_zil d16_gfx bc_16gfx dos16 d16libc fp87 mathl cl
# --- Use the next line for UI_BGI_DISPLAY ---
#D16_LIBS=bcc40lse bcc40l d16_zil d16_bgi dos16 d16libc fp87 mathl cl

!elif $d(POWERPACK16)
D16_CPP=bcc
D16_CPP_OPTS=-c -dc -WX -ml -O1 -x- -RT- -V -w -DDOS16PP -H=ZIL.SYM
D16_LINK_OPTS=/Txe /c /C /x
D16_LIB_OPTS=/C /p32
D16_OBJS=c0x.obj
D16_DEF=b16pp.def
# --- Use the next line for UI_GRAPHICS_DISPLAY ---
#D16_LIBS=dpmi16 d16_zil d16_gfx bc_16gfx emux mathwl cwl
# --- Use the next line for UI_BGI_DISPLAY ---
D16_LIBS=dpmi16 d16_zil d16_bgi bgi16 emux mathwl cwl
!endif

D16_LINK=tlink
D16_LIBRARIAN=tlib

.cpp.o16:
	$(D16_CPP) $(D16_CPP_OPTS) -o$*.o16 {$< }

D32_CPP=bcc32
D32_CPP_OPTS=-c -WX -O1 -x- -RT- -V -w -DDOS32PP -H=ZIL.SYM
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

# ----- Windows compiler options --------------------------------------------
WIN_CPP=bcc
WIN_LINK=tlink
WIN_LIBRARIAN=tlib
WIN_RC=brc

WIN_CPP_OPTS=-c -d -dc -ml -O1 -x- -RT- -Vf -WE -w -H=ZIL.SYM
WIN_RC_OPTS=-k
WIN_LINK_OPTS=/c /C /Twe /x
WIN_LIB_OPTS=/C

WIN_OBJS=c0wl
WIN_LIBS=win_zil import mathwl cwl ctl3dv2

.cpp.obw:
	$(WIN_CPP) $(WIN_CPP_OPTS) -o$*.obw {$< }

# ----- Windows NT compiler options -----------------------------------------
WNT_CPP=bcc32
WNT_LINK=tlink32
WNT_LIBRARIAN=tlib
WNT_RC=brc32

WNT_CPP_OPTS=-c -O1 -x- -RT- -W -H=ZIL.SYM
WNT_LINK_OPTS=-Tpe -aa -c -x
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
W32_LIBRARIAN=tlib
W32_RC=brc32

W32_CPP_OPTS=-c -O1 -x- -RT- -W -DZIL_WIN32 -H=ZIL.SYM
W32_LINK_OPTS=-Tpe -aa -c -x
W32_RC_OPTS=-w32
W32_LIB_OPTS=/C

W32_OBJS=c0w32
W32_LIBS=w32_zil import32 cw32 ctl3d32

.cpp.ob9:
	$(W32_CPP) $(W32_CPP_OPTS) -o$*.ob9 {$< }

.rc.rbj:
	$(W32_RC) -r $(W32_RC_OPTS) -fo$*.rbj $<

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean

# ----- DOS -----------------------------------------------------------------
# DOS - Library support only
dos : service.obj
	-@del service.lib
	$(DOS_LIBRARIAN) $(DOS_LIB_OPTS) @&&!
service.lib &
+service.obj
!
	-@del zil.sym
	copy service.hpp ..\..\include
	copy service.lib ..\..\lib\$(VERSION)
	copy p_servic.dat ..\..\bin\p_servic.znc

# DOS OVERLAY - Library support only
dosovl : service.ovl
	-@del service.lib
	$(DOS_OVL_LIBRARIAN) $(DOS_OVL_LIB_OPTS) @&&!
service.lib &
+service.ovl
!
	-@del zil.sym
	copy service.hpp ..\..\include
	copy service.lib ..\..\lib\$(VERSION)
	copy p_servic.dat ..\..\bin\p_servic.znc

dos16: test.exe

test.exe: main.o16 service.lib
	$(D16_LINK) $(D16_LINK_OPTS) @&&!
$(D16_OBJS)+main.o16
$*, , service.lib $(D16_LIBS), $(D16_DEF)
!
	-@del zil.sym

service.lib : service.o16
	-@del service.lib
	$(D16_LIBRARIAN) $(D16_LIB_OPTS) @&&!
$* &
+service.o16
!
	-@del zil.sym
	copy service.hpp ..\..\include
	copy service.lib ..\..\lib\$(VERSION)
	copy p_servic.dat ..\..\bin\p_servic.znc


dos32: test32.exe

test32.exe: main.o32 servic32.lib
	$(D32_LINK) $(D32_LINK_OPTS) @&&!
$(D32_OBJS)+main.o32
$*, , servic32.lib $(D32_LIBS)
!
	-@del zil.sym

servic32.lib : service.o32
	-@del servic32.lib
	$(D32_LIBRARIAN) $(D32_LIB_OPTS) @&&!
$* &
+service.o32
!
	-@del zil.sym
	copy service.hpp ..\..\include
	copy servic32.lib ..\..\lib\$(VERSION)
	copy p_servic.dat ..\..\bin\p_servic.znc

# ----- Windows -------------------------------------------------------------
windows: wtest.exe

wtest.exe: main.obw wservice.lib
	$(WIN_LINK) $(WIN_LINK_OPTS) @&&!
$(WIN_OBJS)+main.obw
$*, , wservice $(WIN_LIBS), wtest.def
!
	$(WIN_RC) $(WIN_RC_OPTS) wtest.rc $<

wservice.lib : service.obw
	-@del wservice.lib
	$(WIN_LIBRARIAN) $(WIN_LIB_OPTS) @&&!
$* &
+service.obw
!
	-@del zil.sym
	copy service.hpp ..\..\include
	copy wservice.lib ..\..\lib\$(VERSION)
	copy p_servic.dat ..\..\bin\p_servic.znc

# ----- Windows NT ----------------------------------------------------------
winnt: ntest.exe

ntest.exe: main.obn nservice.lib wtest.rbj
	$(WNT_LINK) $(WNT_LINK_OPTS) @&&!
$(WNT_OBJS)+main.obn
$*, , nservice $(WNT_LIBS), wtest.def, wtest.rbj
!

nservice.lib : service.obn
	-@del nservice.lib
	$(WNT_LIBRARIAN) $(WNT_LIB_OPTS) @&&!
$* &
+service.obn
!
	-@del zil.sym
	copy service.hpp ..\..\include
	copy nservice.lib ..\..\lib\$(VERSION)
	copy p_servic.dat ..\..\bin\p_servic.znc

# ----- 32 bit Windows ------------------------------------------------------
win32: 9test.exe

9test.exe: main.ob9 9service.lib wtest.rbj
	$(W32_LINK) $(W32_LINK_OPTS) @&&!
$(W32_OBJS)+main.ob9
$*, , 9service $(W32_LIBS), , wtest.rbj
!

9service.lib : service.ob9
	-@del 9service.lib
	$(W32_LIBRARIAN) $(W32_LIB_OPTS) @&&!
$* &
+service.ob9
!
	-@del zil.sym
	copy service.hpp ..\..\include
	copy 9service.lib ..\..\lib\$(VERSION)
	copy p_servic.dat ..\..\bin\p_servic.znc
