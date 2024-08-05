# ----- General Definitions -------------------------------------------------
VERSION=btcpp310

# ----- Windows compiler options --------------------------------------------
WIN_CPP=bcc
WIN_LINK=tlink
WIN_LIBRARIAN=tlib
WIN_RC=rc

WIN_CPP_OPTS=-c -d  -ml -O1  -Vf -WE -w -H=ZIL.SYM
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


