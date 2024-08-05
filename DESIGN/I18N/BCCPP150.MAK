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
os2: oi18edit.exe

oi18edit.exe: main.obo oi18n.lib
	$(OS2_LINK) $(OS2_LINK_OPTS) @&&!
$(OS2_OBJS)+main.obo
$*, , oi18n ostorage odirect ostredit oservice $(OS2_LIBS), oi18edit.def
!

oi18n.lib : i18n.obo language.obo locale.obo \
	export.obo import.obo \
	z_bnum.obo z_curr.obo z_date.obo z_date1.obo z_day.obo z_error.obo \
	z_help.obo z_int.obo z_month.obo z_msg.obo z_num.obo z_real.obo \
	z_sys.obo z_time.obo z_time1.obo z_time2.obo z_win.obo
	-@del oi18n.lib
	$(OS2_LIBRARIAN) $(OS2_LIB_OPTS) @&&!
$* &
+i18n.obo+language.obo+locale.obo &
+export.obo+import.obo &
+z_bnum.obo+z_curr.obo+z_date.obo+z_date1.obo+z_day.obo+z_error.obo &
+z_help.obo+z_int.obo+z_month.obo+z_msg.obo+z_num.obo+z_real.obo &
+z_sys.obo+z_time.obo+z_time1.obo+z_time2.obo+z_win.obo
!
	copy i18n.hpp ..\..\include
	copy oi18n.lib ..\..\lib\$(VERSION)
	copy p_i18n.dat ..\..\bin\p_i18n.znc

