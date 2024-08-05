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
os2: oi18edit.exe

oi18edit.exe: main.obj oi18n.lib
	$(OS2_LINK) $(OS2_LINK_OPTS) @<<zil.rsp
$(OS2_OBJS)+main.obj
$*,NUL,oi18n ostorage odirect ostredit oservice $(OS2_LIBS),oi18n.def
<<

oi18n.lib : i18n.obj language.obj locale.obj \
	export.obj import.obj \
	z_bnum.obj z_curr.obj z_date.obj z_date1.obj z_day.obj z_error.obj \
	z_help.obj z_int.obj z_month.obj z_msg.obj z_num.obj z_real.obj \
	z_sys.obj z_time.obj z_time1.obj z_time2.obj z_win.obj
	-@del oi18n.lib
	$(OS2_LIBRARIAN) $(OS2_LIB_OPTS) @<<zil.rsp
$* &
+i18n.obj+language.obj+locale.obj &
+export.obj+import.obj &
+z_bnum.obj+z_curr.obj+z_date.obj+z_date1.obj+z_day.obj+z_error.obj &
+z_help.obj+z_int.obj+z_month.obj+z_msg.obj+z_num.obj+z_real.obj &
+z_sys.obj+z_time.obj+z_time1.obj+z_time2.obj+z_win.obj
NUL
<<
	copy i18n.hpp ..\..\include
	copy oi18n.lib ..\..\lib\$(VERSION)
	copy p_i18n.dat ..\..\bin\p_i18n.znc
