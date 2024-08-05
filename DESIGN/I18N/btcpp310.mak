# ----- General Definitions -------------------------------------------------
VERSION=btcpp310


# ----- Windows compiler options --------------------------------------------
WIN_CPP=bcc
WIN_LINK=tlink
WIN_LIBRARIAN=tlib
WIN_RC=rc

WIN_CPP_OPTS=-c -d  -ml -O1  -Vf -WE -w -H=ZIL.SYM
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


# ----- Windows Libraries and Programs --------------------------------------
windows: wi18edit.exe
	copy wi18edit.exe ..\..\bin

wi18edit.exe: main.obw wi18n.lib
	$(WIN_LINK) $(WIN_LINK_OPTS) @&&!
$(WIN_OBJS)+main.obw
$*, , wi18n wstorage wdirect wstredit wservice $(WIN_LIBS), wi18edit.def
!
	$(WIN_RC) $(WIN_RC_OPTS) wi18edit.rc $*.exe

wi18n.lib : i18n.obw language.obw locale.obw \
	export.obw import.obw \
	z_bnum.obw z_curr.obw z_date.obw z_date1.obw z_day.obw z_error.obw \
	z_help.obw z_int.obw z_month.obw z_msg.obw z_num.obw z_real.obw \
	z_sys.obw z_time.obw z_time1.obw z_time2.obw z_win.obw
	-@del wi18n.lib
	$(WIN_LIBRARIAN) $(WIN_LIB_OPTS) @&&!
$* &
+i18n.obw+language.obw+locale.obw &
+export.obw+import.obw &
+z_bnum.obw+z_curr.obw+z_date.obw+z_date1.obw+z_day.obw+z_error.obw &
+z_help.obw+z_int.obw+z_month.obw+z_msg.obw+z_num.obw+z_real.obw &
+z_sys.obw+z_time.obw+z_time1.obw+z_time2.obw+z_win.obw
NUL
!
	-@del zil.sym
	copy i18n.hpp ..\..\include
	copy wi18n.lib ..\..\lib\$(VERSION)
	copy p_i18n.dat ..\..\bin\p_i18n.znc


