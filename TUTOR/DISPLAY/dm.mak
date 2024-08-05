# DISPLAY tutorial makefile

#	make -fdm.mak dos		(makes the DOS display program)
#	make -fdm.mak dosovl		(makes the DOS VCM overlay display program)
#	make -fdm.mak dos32		(makes the DOS extender display program)

# Be sure to set the LIB and INCLUDE environment variables for Zinc, e.g.:
#    set INCLUDE=.;C:\ZINC\INCLUDE;C:\dm\INCLUDE
#    set LIB=.;C:\ZINC\LIB\dm84;C:\dm\LIB

## Compiler and linker: (Add -g to CPP_OPTS and /CO to LINK_OPTS for debug.)

# ----- DOS compiler options ------------------------------------------------
DOS_CPP=dmc
DOS_LINK=link
DOS_CPP_OPTS=-c -a1 -ml -o+space -DGFX_DISPLAY
DOS_LINK_OPTS=/NOI /SEG:300
DOS_OBJS=
DOS_LIBS=dos_zil dos_gfx dm_lgfx

.c.obj:
	$(DOS_CPP) $(DOS_CPP_OPTS) $<

.cpp.obj:
	$(DOS_CPP) $(DOS_CPP_OPTS) $<

# ----- DOS Overlay (VCM) compiler options ----------------------------------
OVL_CPP=dmc
OVL_LINK=link
OVL_CPP_OPTS=-c -a1 -mv -o+space -R
OVL_LINK_OPTS=/NOI /F /PAC
OVL_OBJS=
OVL_LIBS=dos_zilv dos_gfxv dm_lgfxv

.cpp.ovl:
	$(OVL_CPP) $(OVL_CPP_OPTS) -o$*.ovl $<

# ----- DOS extender compiler options ---------------------------------------
D32_CPP=dmc
D32_LINK=link
D32_CPP_OPTS=-c -mx -D$(FONT) -DGFX_DISPLAY
D32_LINK_OPTS=/NOI
D32_LIB_OPTS=/C /N /B
D32_OBJS=cx
D32_LIBS=d32_zil d32_gfx dm_32gfx x32

.cpp.o32:
	$(D32_CPP) $(D32_CPP_OPTS) -o$@ $<

# ----- Usage ---------------------------------------------------------------
usage:
	@echo ...........
	@echo ...........
	@echo To make this Zinc tutorial for Symantec C++ type:
	@echo smake -fdm.mak dos
	@echo sake -fdm.mak dosovl
	@echo sake -fdm.mak dos32
	@echo (This tutorial is not supported in OS/2)
	@echo (This tutorial is not supported in Windows)
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean.bat

# ----- DOS -----------------------------------------------------------------
dos: display.exe

display.exe: display.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) $(DOS_OBJS)+display.obj,$*,NUL,$(DOS_LIBS),NUL

# ----- DOS Overlay (VCM) ---------------------------------------------------
dosovl: displayv.exe

displayv.exe: display.ovl
	$(OVL_LINK) $(OVL_LINK_OPTS) $(OVL_OBJS)+display.ovl,$*, ,$(OVL_LIBS)

# ----- Dos extender --------------------------------------------------------
dos32: disp32.exe

disp32.exe: display.o32
	$(D32_LINK) $(D32_LINK_OPTS) $(D32_OBJS)+display.o32,$*, ,$(D32_LIBS)

windows:
	@echo (This tutorial is not supported in Windows or OS/2)

os2:
	@echo (This tutorial is not supported in Windows or OS/2)

