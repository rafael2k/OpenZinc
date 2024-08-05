# ----- General Definitions -------------------------------------------------
VERSION=iccpp300

# ----- OS/2 compiler options -----------------------------------------------
OS2_CPP=icc
OS2_LINK=ilink
OS2_LIBRARIAN=ilib
OS2_RC=rc

OS2_CPP_OPTS=/c /D__OS2__ /Gx+ /Sp
OS2_LINK_OPTS=/OUT:omsgedit /NOE /NOI /BASE:0x10000 /PM:PM
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
os2: omsgedit.exe
	copy omsgedit.exe ..\..\bin

omsgedit.exe: main.obj omessage.lib
	$(OS2_LINK) $(OS2_LINK_OPTS) main.obj $(OS2_OBJS) omessage.lib ostorage.lib odirect.lib ostredit.lib oservice.lib $(OS2_LIBS) omessage.def

omessage.lib : message.obj message1.obj prefer.obj \
	import.obj export.obj
	-@del omessage.lib
	$(OS2_LIBRARIAN) $(OS2_LIB_OPTS) @<<zil.rsp
$* &
+message.obj+message1.obj+prefer.obj &
+import.obj+export.obj
NUL
<<
	copy message.hpp ..\..\include
	copy omessage.lib ..\..\lib\$(VERSION)
	copy p_messag.dat ..\..\bin\p_messag.znc
