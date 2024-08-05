# ----- General Definitions -------------------------------------------------
VERSION=iccpp300

# ----- OS/2 compiler options -----------------------------------------------
OS2_CPP=icc
OS2_LINK=ilink
OS2_LIBRARIAN=ilib
OS2_RC=rc

OS2_CPP_OPTS=/c /D__OS2__ /Gx+ /Sp
OS2_LINK_OPTS=/OUT:ohlpedit /NOE /NOI /BASE:0x10000 /PM:PM
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
os2: ohlpedit.exe
	copy ohlpedit.exe ..\..\bin

ohlpedit.exe: main.obj ohelp.lib
	$(OS2_LINK) $(OS2_LINK_OPTS) main.obj $(OS2_OBJS) ohelp.lib ostorage.lib odirect.lib ostredit.lib oservice.lib $(OS2_LIBS) ohelp.def

ohelp.lib : help.obj help1.obj import.obj export.obj
	-@del ohelp.lib
	$(OS2_LIBRARIAN) $(OS2_LIB_OPTS) @<<zil.rsp
$* &
+help.obj+help1.obj+import.obj+export.obj
NUL
<<
	copy help.hpp ..\..\include
	copy ohelp.lib ..\..\lib\$(VERSION)
	copy p_help.dat ..\..\bin\p_help.znc
