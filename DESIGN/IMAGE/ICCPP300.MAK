# ----- General Definitions -------------------------------------------------
VERSION=iccpp300

# ----- OS/2 compiler options -----------------------------------------------
OS2_CPP=icc
OS2_LINK=ilink
OS2_LIBRARIAN=ilib
OS2_RC=rc

OS2_CPP_OPTS=/c /D__OS2__ /Gx+ /Sp
OS2_LINK_OPTS=/OUT:oimgedit /NOE /NOI /BASE:0x10000 /PM:PM
OS2_LIB_OPTS=
OS2_RC_OPTS=

OS2_OBJS=
OS2_LIBS=os2_zil.lib

.SUFFIXES : .cpp

.cpp.obj:
	$(OS2_CPP) $(OS2_CPP_OPTS) $<

# ----- Usage --------------------------------------------------------------
usage:
	@echo ...........
	@echo ...........
	@echo To make this Zinc example for IBM C++ type:
	@echo nmake -f iccpp300.mak os2
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean.cmd

# ----- OS/2 ----------------------------------------------------------------
os2: oimgedit.exe
	copy oimgedit.exe ..\..\bin

oimgedit.exe: main.obj oimage.lib
	$(OS2_LINK) $(OS2_LINK_OPTS) main.obj $(OS2_OBJS) oimage.lib ostredit.lib odirect.lib ostorage.lib oservice.lib $(OS2_LIBS) oimage.def

oimage.lib : odib.obj odib1.obj odib2.obj \
	wdib.obj wdib1.obj wdib2.obj \
	wico.obj wico1.obj wico2.obj \
	xpm.obj xpm1.obj xpm2.obj \
	znc1.obj znc2.obj \
	image.obj image1.obj image2.obj color.obj draw.obj \
	export.obj import.obj \
	o_image.obj
	-@del oimage.lib
	-@del $(OS2_PCH)
	$(OS2_LIBRARIAN) $(OS2_LIB_OPTS) @<<zil.rsp
$* &
+odib.obj+odib1.obj+odib2.obj &
+wdib.obj+wdib1.obj+wdib2.obj &
+wico.obj+wico1.obj+wico2.obj &
+xpm.obj+xpm1.obj+xpm2.obj &
+znc1.obj+znc2.obj &
+image.obj+image1.obj+image2.obj+color.obj+draw.obj &
+export.obj+import.obj &
+o_image.obj
NUL
<<
	copy image.hpp ..\..\include
	copy oimage.lib ..\..\lib\$(VERSION)
	copy p_image.dat ..\..\bin\p_image.znc
