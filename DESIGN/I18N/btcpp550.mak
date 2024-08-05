# ----- General Definitions -------------------------------------------------
VERSION=btcpp550

# ----- DOS compiler options ------------------------------------------------
!if !$d(PHARLAP16) && !$d(RATIONAL16) && !$d(POWERPACK16)
PHARLAP16=
!endif

!if $d(PHARLAP16)
D16_CPP=bcc286
D16_CPP_OPTS=-c -dc -ml -O1 -x- -RT- -V -w -H=ZIL.SYM
D16_LINK_OPTS=/c /C /x
D16_LIB_OPTS=/C /p32
D16_OBJS=c0pl.obj
D16_DEF=b16.def
D16_BIND=bind286
PHARLAP_RTL=c:\phar286\rtk
D16_LOAD=run286a
# --- Use the next line for UI_GRAPHICS_DISPLAY ---
D16_LIBS=phapi d16_zil d16_gfx bc_16gfx emu286 emu mathl bcl286
# --- Use the next line for UI_BGI_DISPLAY ---
#D16_LIBS=phapi d16_zil d16_bgi graph286 emu286 emu mathl bcl286

!elif $d(RATIONAL16)
D16_CPP=bcc
D16_CPP_OPTS=-c -dc -ml -O1 -x- -RT- -2 -f87 -Vf -w -DDOS16M -H=ZIL.SYM
D16_LINK_OPTS=/c /x /C
D16_LIB_OPTS=/C /P1024
D16_OBJS=\dos16m\lib\bcc40\bcc40c0l.obj
D16_DEF=dos16m.def
# --- Use the next line for UI_GRAPHICS_DISPLAY ---
D16_LIBS=bcc40lse bcc40l d16_zil d16_gfx bc_16gfx dos16 d16libc fp87 mathl cl
# --- Use the next line for UI_BGI_DISPLAY ---
#D16_LIBS=bcc40lse bcc40l d16_zil d16_bgi dos16 d16libc fp87 mathl cl

!elif $d(POWERPACK16)
D16_CPP=bcc
D16_CPP_OPTS=-c -dc -WX -ml -O1 -x- -RT- -V -w -DDOS16PP -H=ZIL.SYM
D16_LINK_OPTS=/Txe /c /C /x
D16_LIB_OPTS=/C /p32
D16_OBJS=c0x.obj
D16_DEF=b16pp.def
# --- Use the next line for UI_GRAPHICS_DISPLAY ---
#D16_LIBS=dpmi16 d16_zil d16_gfx bc_16gfx emux mathwl cwl
# --- Use the next line for UI_BGI_DISPLAY ---
D16_LIBS=dpmi16 d16_zil d16_bgi bgi16 emux mathwl cwl
!endif

D16_LINK=tlink
D16_LIBRARIAN=tlib

.cpp.o16:
	$(D16_CPP) $(D16_CPP_OPTS) -o$*.o16 {$< }

D32_CPP=bcc32
D32_CPP_OPTS=-c -WX -O1 -x- -RT- -V -w -DDOS32PP -H=ZIL.SYM
D32_LINK=ilink32
D32_LINK_OPTS=/Tpe /ax /c /x
D32_LIBRARIAN=tlib
D32_LIB_OPTS=/C /p32
D32_OBJS=c0x32.obj
# --- Use the next line for UI_GRAPHICS_DISPLAY ---
#D32_LIBS=dpmi32 d32_zil d32_gfx bc_32gfx cw32
# --- Use the next line for UI_BGI_DISPLAY ---
D32_LIBS=dpmi32 d32_zil d32_bgi bgi32 cw32

.cpp.o32:
	$(D32_CPP) $(D32_CPP_OPTS) -o$*.o32 {$< }

# ----- Windows compiler options --------------------------------------------
WIN_CPP=bcc
WIN_LINK=tlink
WIN_LIBRARIAN=tlib
WIN_RC=brc

WIN_CPP_OPTS=-c -d -dc -ml -O1 -x- -RT- -Vf -WE -w -H=ZIL.SYM
WIN_RC_OPTS=-k
WIN_LINK_OPTS=/c /C /Twe /x
WIN_LIB_OPTS=/C

WIN_OBJS=c0wl
WIN_LIBS=win_zil import mathwl cwl ctl3dv2

.cpp.obw:
	$(WIN_CPP) $(WIN_CPP_OPTS) -o$*.obw {$< }

# ----- Windows NT compiler options -----------------------------------------
WNT_CPP=bcc32
WNT_LINK=ilink32
WNT_LIBRARIAN=tlib
WNT_RC=brc32

WNT_CPP_OPTS=-c -O1 -x- -RT- -W -H=ZIL.SYM
WNT_LINK_OPTS=-Tpe -aa -c -x
WNT_RC_OPTS=-w32
WNT_LIB_OPTS=/C

WNT_OBJS=c0w32
WNT_LIBS=wnt_zil import32 cw32 

.cpp.obn:
	$(WNT_CPP) $(WNT_CPP_OPTS) -o$*.obn {$< }

.rc.rbj:
	$(WNT_RC) -r $(WNT_RC_OPTS) -fo$*.rbj $<

# ----- Windows 32 bit compiler options -------------------------------------
W32_CPP=bcc32
W32_LINK=ilink32
W32_LIBRARIAN=tlib
W32_RC=brc32

W32_CPP_OPTS=-c -O1 -x- -RT- -W -DZIL_WIN32 -H=ZIL.SYM
W32_LINK_OPTS=-Tpe -aa -c -x
W32_RC_OPTS=-w32
W32_LIB_OPTS=/C

W32_OBJS=c0w32
W32_LIBS=w32_zil import32 cw32 

.cpp.ob9:
	$(W32_CPP) $(W32_CPP_OPTS) -o$*.ob9 {$< }

.rc.rbj:
	$(W32_RC) -r $(W32_RC_OPTS) -fo$*.rbj $<

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean

# ----- DOS -----------------------------------------------------------------
dos16: i18edit.exe
	copy i18edit.exe ..\..\bin

i18edit.exe: main.o16 i18n.lib
	$(D16_LINK) $(D16_LINK_OPTS) @&&!
$(D16_OBJS)+main.o16
$*, , i18n.lib storage.lib direct.lib stredit.lib service.lib $(D16_LIBS), b16.def
!
	-@del zil.sym

i18n.lib : i18n.o16 language.o16 locale.o16 \
	export.o16 import.o16 \
	z_bnum.o16 z_curr.o16 z_date.o16 z_date1.o16 z_day.o16 z_error.o16 \
	z_help.o16 z_int.o16 z_month.o16 z_msg.o16 z_num.o16 z_real.o16 \
	z_sys.o16 z_time.o16 z_time1.o16 z_time2.o16 z_win.o16
	-@del i18n.lib
	$(D16_LIBRARIAN) $(D16_LIB_OPTS) @&&!
$* &
+i18n.o16+language.o16+locale.o16 &
+export.o16+import.o16 &
+z_bnum.o16+z_curr.o16+z_date.o16+z_date1.o16+z_day.o16+z_error.o16 &
+z_help.o16+z_int.o16+z_month.o16+z_msg.o16+z_num.o16+z_real.o16 &
+z_sys.o16+z_time.o16+z_time1.o16+z_time2.o16+z_win.o16
!
	-@del zil.sym
	copy i18n.hpp ..\..\include
	copy i18n.lib ..\..\lib\$(VERSION)
	copy p_i18n.dat ..\..\bin\p_i18n.znc

dos32: i18edi32.exe
	copy i18edi32.exe ..\..\bin

i18edi32.exe: main.o32 i18n32.lib
	$(D32_LINK) $(D32_LINK_OPTS) @&&!
$(D32_OBJS)+main.o32
$*, , i18n32.lib storag32.lib direct32.lib stredi32.lib servic32.lib $(D32_LIBS)
!
	-@del zil.sym

i18n32.lib : i18n.o32 language.o32 locale.o32 \
	export.o32 import.o32 \
	z_bnum.o32 z_curr.o32 z_date.o32 z_date1.o32 z_day.o32 z_error.o32 \
	z_help.o32 z_int.o32 z_month.o32 z_msg.o32 z_num.o32 z_real.o32 \
	z_sys.o32 z_time.o32 z_time1.o32 z_time2.o32 z_win.o32
	-@del i18n32.lib
	$(D32_LIBRARIAN) $(D32_LIB_OPTS) @&&!
$* &
+i18n.o32+language.o32+locale.o32 &
+export.o32+import.o32 &
+z_bnum.o32+z_curr.o32+z_date.o32+z_date1.o32+z_day.o32+z_error.o32 &
+z_help.o32+z_int.o32+z_month.o32+z_msg.o32+z_num.o32+z_real.o32 &
+z_sys.o32+z_time.o32+z_time1.o32+z_time2.o32+z_win.o32
!
	-@del zil.sym
	copy i18n.hpp ..\..\include
	copy i18n32.lib ..\..\lib\$(VERSION)
	copy p_i18n.dat ..\..\bin\p_i18n.znc

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

# ----- Windows NT Libraries and Programs -----------------------------------
winnt: ni18edit.exe
	copy ni18edit.exe ..\..\bin

ni18edit.exe: main.obn ni18n.lib wi18edit.rbj
	$(WNT_LINK) $(WNT_LINK_OPTS) @&&!
$(WNT_OBJS)+main.obn
$*, , ni18n nstorage ndirect nstredit nservice $(WNT_LIBS), wi18edit.def, wi18edit.rbj
!

ni18n.lib : i18n.obn language.obn locale.obn \
	export.obn import.obn \
	z_bnum.obn z_curr.obn z_date.obn z_date1.obn z_day.obn z_error.obn \
	z_help.obn z_int.obn z_month.obn z_msg.obn z_num.obn z_real.obn \
	z_sys.obn z_time.obn z_time1.obn z_time2.obn z_win.obn
	-@del ni18n.lib
	$(WNT_LIBRARIAN) $(WNT_LIB_OPTS) @&&!
$* &
+i18n.obn+language.obn+locale.obn &
+export.obn+import.obn &
+z_bnum.obn+z_curr.obn+z_date.obn+z_date1.obn+z_day.obn+z_error.obn &
+z_help.obn+z_int.obn+z_month.obn+z_msg.obn+z_num.obn+z_real.obn &
+z_sys.obn+z_time.obn+z_time1.obn+z_time2.obn+z_win.obn
NUL
!
	-@del zil.sym
	copy i18n.hpp ..\..\include
	copy ni18n.lib ..\..\lib\$(VERSION)
	copy p_i18n.dat ..\..\bin\p_i18n.znc

# ----- Windows 32 bit Libraries and Programs -------------------------------
win32: 9i18edit.exe
	copy 9i18edit.exe ..\..\bin

9i18edit.exe: main.ob9 9i18n.lib wi18edit.rbj
	$(W32_LINK) $(W32_LINK_OPTS) @&&!
$(W32_OBJS)+main.ob9
$*, , 9i18n 9storage 9direct 9stredit 9service $(W32_LIBS), wi18edit.def, wi18edit.rbj
!

9i18n.lib : i18n.ob9 language.ob9 locale.ob9 \
	export.ob9 import.ob9 \
	z_bnum.ob9 z_curr.ob9 z_date.ob9 z_date1.ob9 z_day.ob9 z_error.ob9 \
	z_help.ob9 z_int.ob9 z_month.ob9 z_msg.ob9 z_num.ob9 z_real.ob9 \
	z_sys.ob9 z_time.ob9 z_time1.ob9 z_time2.ob9 z_win.ob9
	-@del 9i18n.lib
	$(W32_LIBRARIAN) $(W32_LIB_OPTS) @&&!
$* &
+i18n.ob9+language.ob9+locale.ob9 &
+export.ob9+import.ob9 &
+z_bnum.ob9+z_curr.ob9+z_date.ob9+z_date1.ob9+z_day.ob9+z_error.ob9 &
+z_help.ob9+z_int.ob9+z_month.ob9+z_msg.ob9+z_num.ob9+z_real.ob9 &
+z_sys.ob9+z_time.ob9+z_time1.ob9+z_time2.ob9+z_win.ob9
NUL
!
	-@del zil.sym
	copy i18n.hpp ..\..\include
	copy 9i18n.lib ..\..\lib\$(VERSION)
	copy p_i18n.dat ..\..\bin\p_i18n.znc
