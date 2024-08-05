# ----- General Definitions -------------------------------------------------
VERSION=btcpp550

# ----- DOS compiler options ------------------------------------------------
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
D16_BIND=bind286
PHARLAP_RTL=c:\phar286\rtk
D16_LOAD=run286a
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
D32_LINK=ilink32
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
WNT_LINK=ilink32
WNT_LIBRARIAN=tlib
WNT_RC=brc32

WNT_CPP_OPTS=-c -O1 -x- -RT- -W -H=ZIL.SYM
WNT_LINK_OPTS=-Tpe -aa -c -x
WNT_RC_OPTS=-w32
WNT_LIB_OPTS=/C

WNT_OBJS=c0w32
WNT_LIBS=wnt_zil import32 cw32 

.cpp.obn:
	$(WNT_CPP) $(WNT_CPP_OPTS) -o$*.obn {$< }

.rc.rbj:
	$(WNT_RC) -r $(WNT_RC_OPTS) -fo$*.rbj $<

# ----- Windows 32 bit compiler options -------------------------------------
W32_CPP=bcc32
W32_LINK=ilink32
W32_LIBRARIAN=tlib
W32_RC=brc32

W32_CPP_OPTS=-c -O1 -x- -RT- -W -DZIL_WIN32 -H=ZIL.SYM
W32_LINK_OPTS=-Tpe -aa -c -x
W32_RC_OPTS=-w32
W32_LIB_OPTS=/C

W32_OBJS=c0w32
W32_LIBS=w32_zil import32 cw32 

.cpp.ob9:
	$(W32_CPP) $(W32_CPP_OPTS) -o$*.ob9 {$< }

.rc.rbj:
	$(W32_RC) -r $(W32_RC_OPTS) -fo$*.rbj $<

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean

# ----- DOS -----------------------------------------------------------------
dos16: imgedit.exe
	copy imgedit.exe ..\..\bin

imgedit.exe: main.o16 image.lib
	$(D16_LINK) $(D16_LINK_OPTS) @&&!
$(D16_OBJS)+main.o16
$*, , image.lib stredit.lib direct.lib storage.lib service.lib $(D16_LIBS), b16.def
!
	-@del zil.sym
!if $d(PHARLAP16)
	$(D16_BIND) @&&!
$(PHARLAP_RTL)\$(D16_LOAD)
$*
-dll $(PHARLAP_RTL)\moucalls
     $(PHARLAP_RTL)\int33
     $(PHARLAP_RTL)\doscalls
!
!endif

image.lib : odib.o16 odib1.o16 odib2.o16 \
	wdib.o16 wdib1.o16 wdib2.o16 \
	wico.o16 wico1.o16 wico2.o16 \
	xpm.o16 xpm1.o16 xpm2.o16 \
	znc1.o16 znc2.o16 \
	image.o16 image1.o16 image2.o16 color.o16 draw.o16 \
	export.o16 import.o16 \
	d_image.o16
	-@del image.lib
	$(D16_LIBRARIAN) $(D16_LIB_OPTS) @&&!
$* &
+odib.o16+odib1.o16+odib2.o16 &
+wdib.o16+wdib1.o16+wdib2.o16 &
+wico.o16+wico1.o16+wico2.o16 &
+xpm.o16+xpm1.o16+xpm2.o16 &
+znc1.o16+znc2.o16 &
+image.o16+image1.o16+image2.o16+color.o16+draw.o16 &
+export.o16+import.o16 &
+d_image.o16
!
	-@del zil.sym
	copy image.hpp ..\..\include
	copy image.lib ..\..\lib\$(VERSION)
	copy p_image.dat ..\..\bin\p_image.znc

dos32: imgedi32.exe
	copy imgedi32.exe ..\..\bin

imgedi32.exe: main.o32 image32.lib
	$(D32_LINK) $(D32_LINK_OPTS) @&&!
$(D32_OBJS)+main.o32
$*, , image32.lib stredi32.lib direct32.lib storag32.lib servic32.lib $(D32_LIBS)
!

image32.lib : odib.o32 odib1.o32 odib2.o32 \
	wdib.o32 wdib1.o32 wdib2.o32 \
	wico.o32 wico1.o32 wico2.o32 \
	xpm.o32 xpm1.o32 xpm2.o32 \
	znc1.o32 znc2.o32 \
	image.o32 image1.o32 image2.o32 color.o32 draw.o32 \
	export.o32 import.o32 \
	d_image.o32
	-@del image32.lib
	$(D32_LIBRARIAN) $(D32_LIB_OPTS) @&&!
$* &
+odib.o32+odib1.o32+odib2.o32 &
+wdib.o32+wdib1.o32+wdib2.o32 &
+wico.o32+wico1.o32+wico2.o32 &
+xpm.o32+xpm1.o32+xpm2.o32 &
+znc1.o32+znc2.o32 &
+image.o32+image1.o32+image2.o32+color.o32+draw.o32 &
+export.o32+import.o32 &
+d_image.o32
!
	-@del zil.sym
	copy image.hpp ..\..\include
	copy image32.lib ..\..\lib\$(VERSION)
	copy p_image.dat ..\..\bin\p_image.znc

# ----- Windows -------------------------------------------------------------
windows: wimgedit.exe
	copy wimgedit.exe ..\..\bin

wimgedit.exe: main.obw wimage.lib
	$(WIN_LINK) $(WIN_LINK_OPTS) @&&!
$(WIN_OBJS)+main.obw
$*, , wimage wstorage wstredit wdirect wservice $(WIN_LIBS), wimage.def
!
	$(WIN_RC) $(WIN_RC_OPTS) wimage.rc $<

wimage.lib : odib.obw odib1.obw odib2.obw \
	wdib.obw wdib1.obw wdib2.obw \
	wico.obw wico1.obw wico2.obw \
	xpm.obw xpm1.obw xpm2.obw \
	znc1.obw znc2.obw \
	image.obw image1.obw image2.obw color.obw draw.obw \
	export.obw import.obw \
	w_image.obw
	-@del wimage.lib
	$(WIN_LIBRARIAN) $(WIN_LIB_OPTS) @&&!
$* &
+odib.obw+odib1.obw+odib2.obw &
+wdib.obw+wdib1.obw+wdib2.obw &
+wico.obw+wico1.obw+wico2.obw &
+xpm.obw+xpm1.obw+xpm2.obw &
+znc1.obw+znc2.obw &
+image.obw+image1.obw+image2.obw+color.obw+draw.obw &
+export.obw+import.obw &
+w_image.obw
!
	-@del zil.sym
	copy image.hpp ..\..\include
	copy wimage.lib ..\..\lib\$(VERSION)
	copy p_image.dat ..\..\bin\p_image.znc

# ----- Windows NT ----------------------------------------------------------
winnt: nimgedit.exe
	copy nimgedit.exe ..\..\bin

nimgedit.exe: main.obn nimage.lib wimage.rbj
	$(WNT_LINK) $(WNT_LINK_OPTS) @&&!
$(WNT_OBJS)+main.obn
$*, , nimage nstorage nstredit ndirect nservice $(WNT_LIBS), wimage.def, wimage.rbj
!

nimage.lib : odib.obn odib1.obn odib2.obn \
	wdib.obn wdib1.obn wdib2.obn \
	wico.obn wico1.obn wico2.obn \
	xpm.obn xpm1.obn xpm2.obn \
	znc1.obn znc2.obn \
	image.obn image1.obn image2.obn color.obn draw.obn \
	export.obn import.obn \
	w_image.obn
	-@del nimage.lib
	$(WNT_LIBRARIAN) $(WNT_LIB_OPTS) @&&!
$* &
+odib.obn+odib1.obn+odib2.obn &
+wdib.obn+wdib1.obn+wdib2.obn &
+wico.obn+wico1.obn+wico2.obn &
+xpm.obn+xpm1.obn+xpm2.obn &
+znc1.obn+znc2.obn &
+image.obn+image1.obn+image2.obn+color.obn+draw.obn &
+export.obn+import.obn &
+w_image.obn
!
	-@del zil.sym
	copy image.hpp ..\..\include
	copy nimage.lib ..\..\lib\$(VERSION)
	copy p_image.dat ..\..\bin\p_image.znc

# ----- Windows 32 bit ------------------------------------------------------
win32: 9imgedit.exe
	copy 9imgedit.exe ..\..\bin

9imgedit.exe: main.ob9 9image.lib wimage.rbj
	$(W32_LINK) $(W32_LINK_OPTS) @&&!
$(W32_OBJS)+main.ob9
$*, , 9image 9storage 9stredit 9direct 9service $(W32_LIBS), , wimage.rbj
!

9image.lib : odib.ob9 odib1.ob9 odib2.ob9 \
	wdib.ob9 wdib1.ob9 wdib2.ob9 \
	wico.ob9 wico1.ob9 wico2.ob9 \
	xpm.ob9 xpm1.ob9 xpm2.ob9 \
	znc1.ob9 znc2.ob9 \
	image.ob9 image1.ob9 image2.ob9 color.ob9 draw.ob9 \
	export.ob9 import.ob9 \
	w_image.ob9
	-@del 9image.lib
	$(W32_LIBRARIAN) $(W32_LIB_OPTS) @&&!
$* &
+odib.ob9+odib1.ob9+odib2.ob9 &
+wdib.ob9+wdib1.ob9+wdib2.ob9 &
+wico.ob9+wico1.ob9+wico2.ob9 &
+xpm.ob9+xpm1.ob9+xpm2.ob9 &
+znc1.ob9+znc2.ob9 &
+image.ob9+image1.ob9+image2.ob9+color.ob9+draw.ob9 &
+export.ob9+import.ob9 &
+w_image.ob9
!
	-@del zil.sym
	copy image.hpp ..\..\include
	copy 9image.lib ..\..\lib\$(VERSION)
	copy p_image.dat ..\..\bin\p_image.znc
