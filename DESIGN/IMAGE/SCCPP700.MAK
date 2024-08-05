VERSION=sccpp700

# ----- DOS 16 bit extender (Rational DOS16M) compiler options --------------
# --- DOS ---
DOS_CPP=sc
DOS_LINK=link
DOS_LIBRARIAN=lib
DOS_CPP_OPTS=-c -a1 -bx -ml -o+space -R -R
DOS_LINK_OPTS=/NOI
DOS_LIB_OPTS=/N /B /NOI
DOS_OBJS=
DOS_LIBS=dos_zil dos_gfx sc_lgfx

.cpp.obj:
	$(DOS_CPP) $(DOS_CPP_OPTS) $<

# --- VROOM ---
OVL_CPP=sc
OVL_LINK=link
OVL_LIBRARIAN=lib
OVL_CPP_OPTS=-c -a1 -mv -R
OVL_LINK_OPTS=/NOI /F /PAC
OVL_LIB_OPTS=/N /B /NOI
OVL_LIB_OPTS=/N /B /NOI
OVL_OBJS=
OVL_LIBS=dos_zilv dos_gfxv sc_lgfxv

.cpp.ovl:
	$(OVL_CPP) $(OVL_CPP_OPTS) -o$@ $<

# ----- DOS 32 bit extender (X-32VM) compiler options -----------------------
D32_CPP=sc
D32_LINK=link
D32_LIBRARIAN=lib
D32_CPP_OPTS=-c -mx -R
D32_LINK_OPTS=/NOI
D32_LIB_OPTS=/N /B /NOI
D32_LIB_OPTS=/N /B /NOI
D32_OBJS=cx
D32_LIBS=d32_zil d32_gfx sc_32gfx x32

.cpp.o32:
	$(D32_CPP) $(D32_CPP_OPTS) -o$@ $<

# ----- Windows compiler options --------------------------------------------
WIN_CPP=sc
WIN_LINK=link
WIN_LIBRARIAN=lib
WIN_RC=rc

WIN_CPP_OPTS=-c -a1 -ml -W2 -R
WIN_RC_OPTS=-k
WIN_LINK_OPTS=/NOI /PACKC:42000
WIN_LIB_OPTS=/N /B

WIN_OBJS=
WIN_LIBS=wwindow whelp wi18n wmessage wimage wstorage wdirect wstredit wservice win_zil commdlg libw

.cpp.obw:
	$(WIN_CPP) $(WIN_CPP_OPTS) -o$@ $<

# ----- Windows NT (and WIN32s) compiler options ----------------------------
WNT_CPP=sc
WNT_LINK=link
WNT_LIBRARIAN=lib
WNT_RC=rc

WNT_CPP_OPTS=-c -4 -mn -WA
WNT_RC_OPTS=
WNT_LINK_OPTS=/NOI
WNT_LIB_OPTS=/N /B

WNT_OBJS=
WNT_LIBS=wnt_zil kernel32 user32 gdi32 ctl3d32

.cpp.obn:
	$(WNT_CPP) $(WNT_CPP_OPTS) -o$@ $<

# ----- Windows 32 compiler options ----------------------------
W32_CPP=sc
W32_LINK=link
W32_LIBRARIAN=lib
W32_RC=rc

W32_CPP_OPTS=-c -4 -mn -WA -DZIL_WIN32
W32_RC_OPTS=
W32_LINK_OPTS=/NOI
W32_LIB_OPTS=/N /B

W32_OBJS=
W32_LIBS=w32_zil kernel32 user32 gdi32 ctl3d32 comctl32

.cpp.ob9:
	$(W32_CPP) $(W32_CPP_OPTS) -o$@ $<


# ----- Usage --------------------------------------------------------------
usage:
	@echo ...........
	@echo ...........
	@echo To generate the library modules for specific environments type:
	@echo make -fsccpp700.mak dos32
	@echo make -fsccpp700.mak windows
	@echo make -fsccpp700.mak winnt
	@echo make -fsccpp700.mak win32
	@echo ...........
	@echo ...........


# ----- Clean ---------------------------------------------------------------
clean:
	z_clean.bat

# ----- DOS 32 bit extender (X-32VM) compiler options -----------------------
dos32: imgedit.exe

imgedit.exe: main.o32 image.lib
	$(D32_LINK) $(D32_LINK_OPTS) $(D32_OBJS)+main.o32, $*, ,image storage direct stredit service $(D32_LIBS)

image.lib : odib.o32 odib1.o32 odib2.o32 \
	wdib.o32 wdib1.o32 wdib2.o32 \
	wico.o32 wico1.o32 wico2.o32 \
	xpm.o32 xpm1.o32 xpm2.o32 \
	znc1.o32 znc2.o32 \
	image.o32 image1.o32 image2.o32 color.o32 draw.o32 \
	export.o32 import.o32 \
	d_image.o32
	-@del image.lib
	$(D32_LIBRARIAN) /C $(D32_LIB_OPTS) @d32_zil.rsp

	copy image.hpp ..\..\include
	copy image.lib ..\..\lib\$(VERSION)
	copy p_image.dat ..\..\bin\p_image.znc

# ----- Windows Libraries and Programs --------------------------------------

windows: wimgedit.exe

wimgedit.exe: main.obw wimage.lib
	$(WIN_LINK) $(WIN_LINK_OPTS) $(WIN_OBJS)+main.obw, $*, ,wimage wstorage wdirect wstredit wservice $(WIN_LIBS), wimage.def
	$(WIN_RC) wimage.rc

wimage.lib : odib.obw odib1.obw odib2.obw \
	wdib.obw wdib1.obw wdib2.obw \
	wico.obw wico1.obw wico2.obw \
	xpm.obw xpm1.obw xpm2.obw \
	znc1.obw znc2.obw \
	image.obw image1.obw image2.obw color.obw draw.obw \
	export.obw import.obw \
	w_image.obw
	-@del wimage.lib
	$(WIN_LIBRARIAN) $(WIN_LIB_OPTS) @win_zil.rsp

	copy image.hpp ..\..\include
	copy wimage.lib ..\..\lib\$(VERSION)
	copy p_image.dat ..\..\bin\p_image.znc

# ----- Winnt Libraries and Programs --------------------------------------

winnt: nimgedit.exe

nimgedit.exe: main.obn nimage.lib
	$(WNT_LINK) $(WNT_LINK_OPTS) $(WNT_OBJS)+main.obn, $*, ,nimage nstorage ndirect nstredit nservice $(WNT_LIBS)

nimage.lib : odib.obn odib1.obn odib2.obn \
	wdib.obn wdib1.obn wdib2.obn \
	wico.obn wico1.obn wico2.obn \
	xpm.obn xpm1.obn xpm2.obn \
	znc1.obn znc2.obn \
	image.obn image1.obn image2.obn color.obn draw.obn \
	export.obn import.obn \
	w_image.obn
	-@del wimage.lib
	$(WNT_LIBRARIAN) $(WNT_LIB_OPTS) @wnt_zil.rsp

	copy image.hpp ..\..\include
	copy nimage.lib ..\..\lib\$(VERSION)
	copy p_image.dat ..\..\bin\p_image.znc

# ----- Winnt Libraries and Programs --------------------------------------

win32: 9imgedit.exe

9imgedit.exe: main.ob9 9image.lib
	$(W32_LINK) $(W32_LINK_OPTS) $(W32_OBJS)+main.ob9, $*, ,9image 9storage 9direct 9stredit 9service $(W32_LIBS)

9image.lib : odib.ob9 odib1.ob9 odib2.ob9 \
	wdib.ob9 wdib1.ob9 wdib2.ob9 \
	wico.ob9 wico1.ob9 wico2.ob9 \
	xpm.ob9 xpm1.ob9 xpm2.ob9 \
	znc1.ob9 znc2.ob9 \
	image.ob9 image1.ob9 image2.ob9 color.ob9 draw.ob9 \
	export.ob9 import.ob9 \
	w_image.ob9
	-@del 9image.lib
	$(W32_LIBRARIAN) $(W32_LIB_OPTS) @w32_zil.rsp

	copy image.hpp ..\..\include
	copy 9image.lib ..\..\lib\$(VERSION)
	copy p_image.dat ..\..\bin\p_image.znc

