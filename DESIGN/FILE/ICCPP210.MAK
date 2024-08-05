# ----- General Definitions -------------------------------------------------
VERSION=iccpp210

# ----- OS/2 compiler options -----------------------------------------------
OS2_CPP=icc
OS2_LINK=link386
OS2_LIBRARIAN=lib
OS2_RC=rc

OS2_CPP_OPTS=/c /D__OS2__ /O+
OS2_LINK_OPTS=/NOE /NOI /BASE:0x10000 /PM:PM
OS2_LIB_OPTS=
OS2_RC_OPTS=

OS2_OBJS=
OS2_LIBS=os2_zil.lib

.SUFFIXES : .cpp

.cpp.obj:
	$(OS2_CPP) $(OS2_CPP_OPTS) $<

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean

# ----- OS/2 ----------------------------------------------------------------
os2: ofile.exe

ofile.exe: main.obj ofile.lib
	$(OS2_LINK) $(OS2_LINK_OPTS) @<<zil.rsp
$(OS2_OBJS)+main.obj
$*,NUL,ostorage ostredit ofile odirect oservice $(OS2_LIBS),ofile.def
<<

ofile.lib : file.obj
	-@del ofile.lib
	$(OS2_LIBRARIAN) $(OS2_LIB_OPTS) @<<zil.rsp
$* &
+file.obj
NUL
<<
	copy file.hpp ..\..\include
	copy ofile.lib ..\..\lib\$(VERSION)
	copy p_file.dat ..\..\bin\p_file.znc
