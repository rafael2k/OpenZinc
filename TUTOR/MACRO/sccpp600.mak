# MACRO tutorial makefile

#    make -fsccpp600.mak dos		(makes the DOS macro program)
#    make -fsccpp600.mak dosovl	(makes the DOS VCM overlay macro program)
#    make -fsccpp600.mak dos32		(makes the DOS extender macro program)
#    make -fsccpp600.mak windows	(makes the Windows macro program)

# Be sure to set the LIB and INCLUDE environment variables for Zinc, e.g.:
#    set INCLUDE=.;C:\ZINC\INCLUDE;C:\SC\INCLUDE
#    set LIB=.;C:\ZINC\LIB\sccpp600;C:\SC\LIB

## Compiler and linker: (Add -g to CPP_OPTS and /CO to LINK_OPTS for debug.)

# ----- DOS compiler options ------------------------------------------------
DOS_CPP=sc
DOS_LINK=link
DOS_CPP_OPTS=-c -a1 -ml -o+space
DOS_LINK_OPTS=/NOI /SEG:300
DOS_OBJS=
DOS_LIBS=dos_zil dos_gfx sc_lgfx

.cpp.obj:
	$(DOS_CPP) $(DOS_CPP_OPTS) $<

# ----- DOS Overlay (VCM) compiler options ----------------------------------
OVL_CPP=sc
OVL_LINK=link
OVL_CPP_OPTS=-c -a1 -mv -o+space -R
OVL_LINK_OPTS=/NOI /F /PAC
OVL_OBJS=
OVL_LIBS=dos_zilv dos_gfxv sc_lgfxv

.cpp.ovl:
	$(OVL_CPP) $(OVL_CPP_OPTS) -o$*.ovl $<

# ----- DOS extender compiler options ---------------------------------------
D32_CPP=sc
D32_LINK=link
D32_CPP_OPTS=-c -bx -mx -D$(FONT)
D32_LINK_OPTS=/NOI
D32_OBJS=cx
D32_LIBS=d32_zil d32_gfx sc_32gfx

.cpp.o32:
	$(D32_CPP) $(D32_CPP_OPTS) -o$@ $<

# ----- Windows compiler options --------------------------------------------
WIN_CPP=sc
WIN_LINK=link
WIN_RC=rc

WIN_CPP_OPTS=-c -a1 -bx -ml -W2
WIN_RC_OPTS=-k
WIN_LINK_OPTS=/NOI
WIN_OBJS=
WIN_LIBS=win_zil libw

.cpp.obw:
	$(WIN_CPP) $(WIN_CPP_OPTS) -o$*.obw $<

# ----- Usage ---------------------------------------------------------------
usage:
	@echo ...........
	@echo ...........
	@echo To make this Zinc tutorial for Symantec C++ type:
	@echo make -fsccpp600.mak dos
	@echo make -fsccpp600.mak dosovl
	@echo make -fsccpp600.mak dos32
	@echo make -fsccpp600.mak windows
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean.bat

# ----- DOS -----------------------------------------------------------------
dos: macro.exe

macro.exe: macro.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) $(DOS_OBJS)+macro.obj,$*,NUL,$(DOS_LIBS),NUL

# ----- DOS Overlay (VCM) ---------------------------------------------------
dosovl: macrov.exe

macrov.exe: macro.ovl
	$(OVL_LINK) $(OVL_LINK_OPTS) $(OVL_OBJS)+macro.ovl,$*, ,$(OVL_LIBS)

# ----- Dos extender --------------------------------------------------------
dos32: macro32.exe

macro32.exe: macro.o32
	$(D32_LINK) $(D32_LINK_OPTS) $(D32_OBJS)+macro.o32,$*, ,$(D32_LIBS)

# ----- Windows -------------------------------------------------------------
windows: wmacro.exe

wmacro.exe: macro.obw
	$(WIN_LINK) $(WIN_LINK_OPTS) $(WIN_OBJS)+macro.obw,$*,NUL,$(WIN_LIBS),wmacro.def
	$(WIN_RC) $(WIN_RC_OPTS) wmacro.rc $*.exe

