# ----- General Definitions -------------------------------------------------
VERSION=btcpp310


# ----- Windows compiler options --------------------------------------------
WIN_CPP=bcc
WIN_LINK=tlink
WIN_LIBRARIAN=tlib
WIN_RC=rc

WIN_CPP_OPTS=-c -d  -ml -O1  -Vf -WE -w
WIN_RC_OPTS=-k
WIN_LINK_OPTS=/c /C /Twe /x
WIN_LIB_OPTS=/C

WIN_OBJS=c0wl
WIN_LIBS=win_zil win_zil2 import mathwl cwl ctl3dv2

.cpp.obw:
	$(WIN_CPP) $(WIN_CPP_OPTS) -o$*.obw {$< }

# ----- Windows -------------------------------------------------------------
windows: whlpedit.exe
	copy whlpedit.exe ..\..\bin

whlpedit.exe: main.obw whelp.lib
	$(WIN_LINK) $(WIN_LINK_OPTS) @&&!
$(WIN_OBJS)+main.obw
$*, , whelp wstorage wdirect wstredit wservice $(WIN_LIBS), whelp.def
!
	$(WIN_RC) $(WIN_RC_OPTS) whelp.rc $<

whelp.lib : help.obw help1.obw import.obw export.obw
	-@del whelp.lib
	$(WIN_LIBRARIAN) $(WIN_LIB_OPTS) @&&!
$* &
+help.obw+help1.obw+import.obw+export.obw
!
	copy help.hpp ..\..\include
	copy whelp.lib ..\..\lib\$(VERSION)
	copy p_help.dat ..\..\bin\p_help.znc


