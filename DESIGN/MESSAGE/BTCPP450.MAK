# ----- General Definitions -------------------------------------------------
VERSION=btcpp450

# ----- DOS compiler options ------------------------------------------------
!if !$d(PHARLAP16) && !$d(RATIONAL16) && !$d(POWERPACK16)
PHARLAP16=
!endif

!if $d(PHARLAP16)
D16_CPP=bcc286
D16_CPP_OPTS=-c -dc -ml -O1 -x- -RT- -V -w
D16_LINK_OPTS=/c /C /x
D16_LIB_OPTS=/C /p32
D16_OBJS=c0pl.obj
D16_DEF=b16.def
D16_BIND=bind286
PHARLAP_RTL=c:\phar286\rtk
D16_LOAD=run286a
# --- Use the next line for UI_GRAPHICS_DISPLAY ---
D16_LIBS=phapi d16_zil d16_gfx bc_16gfx emu286 emu mathl bcl286
# --- Use the next line for UI_BGI_DISPLAY ---
#D16_LIBS=phapi d16_zil d16_bgi graph286 emu286 emu mathl bcl286

!elif $d(RATIONAL16)
D16_CPP=bcc
D16_CPP_OPTS=-c -dc -ml -O1 -x- -RT- -2 -f87 -Vf -w -DDOS16M
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
D16_CPP_OPTS=-c -dc -WX -ml -O1 -x- -RT- -V -w -DDOS16PP
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
D32_CPP_OPTS=-c -WX -O1 -x- -RT- -V -w -DDOS32PP
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
WIN_RC=rc

WIN_CPP_OPTS=-c -d -dc -ml -O1 -x- -RT- -Vf -WE -w
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

WNT_CPP_OPTS=-c -O1 -x- -RT- -W
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

W32_CPP_OPTS=-c -O1 -x- -RT- -W -DZIL_WIN32
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
dos16: msgedit.exe
	copy msgedit.exe ..\..\bin

msgedit.exe: main.o16 message.lib
	$(D16_LINK) $(D16_LINK_OPTS) @&&!
$(D16_OBJS)+main.o16
$*, , message.lib storage.lib direct.lib stredit.lib service.lib $(D16_LIBS), b16.def
!
!if $d(PHARLAP16)
	$(D16_BIND) @&&!
$(PHARLAP_RTL)\$(D16_LOAD)
$*
-dll $(PHARLAP_RTL)\moucalls
     $(PHARLAP_RTL)\int33
     $(PHARLAP_RTL)\doscalls
!
!endif

message.lib : message.o16 message1.o16 prefer.o16 \
	import.o16 export.o16
	-@del message.lib
	$(D16_LIBRARIAN) $(D16_LIB_OPTS) @&&!
$* &
+message.o16+message1.o16+prefer.o16 &
+import.o16+export.o16
!
	copy message.hpp ..\..\include
	copy message.lib ..\..\lib\$(VERSION)
	copy p_messag.dat ..\..\bin\p_messag.znc

dos32: msgedi32.exe
	copy msgedi32.exe ..\..\bin

msgedi32.exe: main.o32 messag32.lib
	$(D32_LINK) $(D32_LINK_OPTS) @&&!
$(D32_OBJS)+main.o32
$*, , messag32.lib storag32.lib direct32.lib stredi32.lib servic32.lib $(D32_LIBS)
!

messag32.lib : message.o32 message1.o32 prefer.o32 \
	import.o32 export.o32
	-@del messag32.lib
	$(D32_LIBRARIAN) $(D32_LIB_OPTS) @&&!
$* &
+message.o32+message1.o32+prefer.o32 &
+import.o32+export.o32
!
	copy message.hpp ..\..\include
	copy messag32.lib ..\..\lib\$(VERSION)
	copy p_messag.dat ..\..\bin\p_messag.znc

# ----- Windows -------------------------------------------------------------
windows: wmsgedit.exe
	copy wmsgedit.exe ..\..\bin

wmsgedit.exe: main.obw wmessage.lib
	$(WIN_LINK) $(WIN_LINK_OPTS) @&&!
$(WIN_OBJS)+main.obw
$*, , wmessage wstredit wstorage wdirect wservice $(WIN_LIBS), wmessage.def
!
	$(WIN_RC) $(WIN_RC_OPTS) wmessage.rc $<

wmessage.lib : message.obw message1.obw prefer.obw \
	import.obw export.obw
	-@del wmessage.lib
	$(WIN_LIBRARIAN) $(WIN_LIB_OPTS) @&&!
$* &
+message.obw+message1.obw+prefer.obw &
+import.obw+export.obw
!
	copy message.hpp ..\..\include
	copy wmessage.lib ..\..\lib\$(VERSION)
	copy p_messag.dat ..\..\bin\p_messag.znc

# ----- Windows NT ----------------------------------------------------------
winnt: nmsgedit.exe
	copy nmsgedit.exe ..\..\bin

nmsgedit.exe: main.obn nmessage.lib wmessage.rbj
	$(WNT_LINK) $(WNT_LINK_OPTS) @&&!
$(WNT_OBJS)+main.obn
$*, , nmessage nstredit nstorage ndirect nservice $(WNT_LIBS), wmessage.def, wmessage.rbj
!

nmessage.lib : message.obn message1.obn prefer.obn \
	import.obn export.obn
	-@del nmessage.lib
	$(WNT_LIBRARIAN) $(WNT_LIB_OPTS) @&&!
$* &
+message.obn+message1.obn+prefer.obn &
+import.obn+export.obn
!
	copy message.hpp ..\..\include
	copy nmessage.lib ..\..\lib\$(VERSION)
	copy p_messag.dat ..\..\bin\p_messag.znc

# ----- 32 bit Windows ------------------------------------------------------
win32: 9msgedit.exe
	copy 9msgedit.exe ..\..\bin

9msgedit.exe: main.ob9 9message.lib wmessage.rbj
	$(W32_LINK) $(W32_LINK_OPTS) @&&!
$(W32_OBJS)+main.ob9
$*, , 9message 9stredit 9storage 9direct 9service $(W32_LIBS), , wmessage.rbj
!

9message.lib : message.ob9 message1.ob9 prefer.ob9 \
	import.ob9 export.ob9
	-@del 9message.lib
	$(W32_LIBRARIAN) $(W32_LIB_OPTS) @&&!
$* &
+message.ob9+message1.ob9+prefer.ob9 &
+import.ob9+export.ob9
!
	copy message.hpp ..\..\include
	copy 9message.lib ..\..\lib\$(VERSION)
	copy p_messag.dat ..\..\bin\p_messag.znc
