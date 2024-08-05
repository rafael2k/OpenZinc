# ----- General Definitions -------------------------------------------------
VERSION=bccpp150

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
os2: ostredit.exe

ostredit.exe: main.obo ostredit.lib
	$(OS2_LINK) $(OS2_LINK_OPTS) @&&!
$(OS2_OBJS)+main.obo
$*, , ostredit oservice $(OS2_LIBS), ostredit.def
!

ostredit.lib : stredit.obo
	-@del ostredit.lib
	$(OS2_LIBRARIAN) $(OS2_LIB_OPTS) @&&!
$* &
+stredit.obo
!
	copy stredit.hpp ..\..\include
	copy ostredit.lib ..\..\lib\$(VERSION)
	copy p_string.dat ..\..\bin\p_string.znc

