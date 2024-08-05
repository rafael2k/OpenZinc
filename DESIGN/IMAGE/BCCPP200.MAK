# ----- General Definitions -------------------------------------------------
VERSION=bccpp200

# ----- OS/2 compiler options -----------------------------------------------
OS2_CPP=bcc
OS2_LINK=tlink
OS2_LIBRARIAN=tlib
OS2_RC=rc

OS2_CPP_OPTS=-c -D$(FONT)
OS2_LINK_OPTS=/c /B:0x10000 /aa
#OS2_CPP_OPTS=-c -v -D$(FONT)
#OS2_LINK_OPTS=/c /B:0x10000 /v /aa
OS2_LIB_OPTS=
OS2_RC_OPTS=

OS2_OBJS=c02.obj
OS2_LIBS=os2_zil.lib os2.lib c2.lib

.cpp.obo:
	$(OS2_CPP) $(OS2_CPP_OPTS) -o$*.obo {$< }

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean

# ----- OS/2 ----------------------------------------------------------------
os2: oimgedit.exe
	copy oimgedit.exe ..\..\bin

oimgedit.exe: main.obo oimage.lib
	$(OS2_LINK) $(OS2_LINK_OPTS) @&&!
$(OS2_OBJS)+main.obo
$*, , oimage ostredit odirect ostorage oservice $(OS2_LIBS), oimage.def
!

oimage.lib : odib.obo odib1.obo odib2.obo \
	wdib.obo wdib1.obo wdib2.obo \
	wico.obo wico1.obo wico2.obo \
	xpm.obo xpm1.obo xpm2.obo \
	znc1.obo znc2.obo \
	image.obo image1.obo image2.obo color.obo draw.obo \
	export.obo import.obo \
	o_image.obo
	-@del oimage.lib
	$(OS2_LIBRARIAN) $(OS2_LIB_OPTS) @&&!
$* &
+odib.obo+odib1.obo+odib2.obo &
+wdib.obo+wdib1.obo+wdib2.obo &
+wico.obo+wico1.obo+wico2.obo &
+xpm.obo+xpm1.obo+xpm2.obo &
+znc1.obo+znc2.obo &
+image.obo+image1.obo+image2.obo+color.obo+draw.obo &
+export.obo+import.obo &
+o_image.obo
!
	copy image.hpp ..\..\include
	copy oimage.lib ..\..\lib\$(VERSION)
	copy p_image.dat ..\..\bin\p_image.znc

