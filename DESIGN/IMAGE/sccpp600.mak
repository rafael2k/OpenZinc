VERSION=sccpp600

# ----- DOS 32 bit compiler options -----------------------------------------
D32_CPP=sc
D32_LINK=link
D32_LIBRARIAN=lib
D32_CPP_OPTS=-c -bx -mx -o+space -R
D32_LINK_OPTS=/NOI
D32_LIB_OPTS=/N /B /NOI
D32_OBJS=cx
D32_LIBS=d32_zil d32_gfx sc_32gfx

.cpp.o32:
	$(D32_CPP) $(D32_CPP_OPTS) -o$@ $<

# ----- Windows compiler options --------------------------------------------
WIN_CPP=sc
WIN_LINK=link
WIN_LIBRARIAN=lib
WIN_RC=rc

WIN_CPP_OPTS=-c -a1 -bx -ml -W2 -R
WIN_RC_OPTS=-k
WIN_LINK_OPTS=/NOI /PACKC:42000
WIN_LIB_OPTS=/N /B

WIN_OBJS=
WIN_LIBS=win_zil libw

.cpp.obw:
	$(WIN_CPP) $(WIN_CPP_OPTS) -o$@ $<

# ----- Usage --------------------------------------------------------------
usage:
	@echo ...........
	@echo ...........
	@echo To generate the library modules for specific environments type:
	@echo make -fsccpp600.mak dos32
	@echo make -fsccpp600.mak windows
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
	$(WIN_RC) wimage.rc $*.exe

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

