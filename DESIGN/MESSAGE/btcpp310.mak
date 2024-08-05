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


# ----- Clean ---------------------------------------------------------------
clean:
	z_clean


# ----- Windows -------------------------------------------------------------
windows: wmsgedit.exe
	copy wmsgedit.exe ..\..\bin

wmsgedit.exe: main.obw wmessage.lib
	$(WIN_LINK) $(WIN_LINK_OPTS) @&&!
$(WIN_OBJS)+main.obw
$*, , wmessage wstredit wstorage wdirect wservice $(WIN_LIBS), wmessage.def
!
	$(WIN_RC) $(WIN_RC_OPTS) wmessage.rc $<

wmessage.lib : message.obw message1.obw prefer.obw \
	import.obw export.obw
	-@del wmessage.lib
	$(WIN_LIBRARIAN) $(WIN_LIB_OPTS) @&&!
$* &
+message.obw+message1.obw+prefer.obw &
+import.obw+export.obw
!
	copy message.hpp ..\..\include
	copy wmessage.lib ..\..\lib\$(VERSION)
	copy p_messag.dat ..\..\bin\p_messag.znc


