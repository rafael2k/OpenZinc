# ----- General Definitions -------------------------------------------------
VERSION=bccpp200

# ----- OS/2 compiler options -----------------------------------------------
OS2_CPP=bcc
OS2_LINK=tlink
OS2_LIBRARIAN=tlib
OS2_RC=rc

#OS2_CPP_OPTS=-c -D$(FONT)
#OS2_LINK_OPTS=/c /B:0x10000 /aa
OS2_CPP_OPTS=-c -v -D$(FONT)
OS2_LINK_OPTS=/c /B:0x10000 /v /aa
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
os2: otest.exe

otest.exe: main.obo odirect.lib
	$(OS2_LINK) $(OS2_LINK_OPTS) @&&!
$(OS2_OBJS)+main.obo
$*, , odirect oservice $(OS2_LIBS), otest.def
!

odirect.lib : o_direct.obo
	-@del odirect.lib
	$(OS2_LIBRARIAN) $(OS2_LIB_OPTS) @&&!
$* &
+o_direct.obo
!
	copy direct.hpp ..\..\include
	copy odirect.lib ..\..\lib\$(VERSION)
	copy p_direct.dat ..\..\bin\p_direct.znc

