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
windows: wfile.exe
	copy wfile.exe ..\..\bin

wfile.exe: main.obw wfile.lib
	$(WIN_LINK) $(WIN_LINK_OPTS) @&&!
$(WIN_OBJS)+main.obw
$*, , wstorage wstredit wfile wdirect wservice $(WIN_LIBS), wfile.def
!
	$(WIN_RC) $(WIN_RC_OPTS) wfile.rc $<

wfile.lib : file.obw
	-@del wfile.lib
	$(WIN_LIBRARIAN) $(WIN_LIB_OPTS) @&&!
$* &
+file.obw
!
	copy file.hpp ..\..\include
	copy wfile.lib ..\..\lib\$(VERSION)
	copy p_file.dat ..\..\bin\p_file.znc


