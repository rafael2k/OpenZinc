# HELLO tutorial makefile

#    make -fsccpp600.mak dos  	      	(makes all the DOS hello tutorials)
#    make -fsccpp600.mak dosovl      	(makes all the DOS VCM overlay tutorials)
#    make -fsccpp600.mak dos32	      	(makes all the DOS extender hello tutorials)
#    make -fsccpp600.mak windows      	(makes all the Windows hello tutorials)

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

# ----- DOS 32 bit extender compiler options --------------------------------
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
dos: hello1.exe hello2.exe hello3.exe hellog.exe

hello1.exe: hello1.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) $(DOS_OBJS)+hello1.obj,$*,NUL,$(DOS_LIBS),NUL

hello2.exe: hello2.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) $(DOS_OBJS)+hello2.obj,$*,NUL,$(DOS_LIBS),NUL

hello3.exe: hello3.obj hello.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) $(DOS_OBJS)+hello3.obj+hello.obj,$*,NUL,$(DOS_LIBS),NUL

hellog.exe: hellog.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) $(DOS_OBJS)+hellog.obj,$*,NUL,$(DOS_LIBS),NUL

# ----- DOS Overlay (VCM) ---------------------------------------------------
dosovl: hello1v.exe hello2v.exe hello3v.exe hellogv.exe

hello1v.exe: hello1.ovl
	$(OVL_LINK) $(OVL_LINK_OPTS) $(OVL_OBJS)+hello1.ovl,$*, ,$(OVL_LIBS)

hello2v.exe: hello2.ovl
	$(OVL_LINK) $(OVL_LINK_OPTS) $(OVL_OBJS)+hello2.ovl,$*, ,$(OVL_LIBS)

hello3v.exe: hello3.ovl hello.ovl
	$(OVL_LINK) $(OVL_LINK_OPTS) $(OVL_OBJS)+hello3.ovl+hello.ovl,$*, ,$(OVL_LIBS)

hellogv.exe: hellog.ovl
	$(OVL_LINK) $(OVL_LINK_OPTS) $(OVL_OBJS)+hellog.ovl,$*, ,$(OVL_LIBS)

# ----- Dos extender --------------------------------------------------------
dos32: hello132.exe hello232.exe hello332.exe hellog32.exe

hello132.exe: hello1.o32
	$(D32_LINK) $(D32_LINK_OPTS) $(D32_OBJS)+hello1.o32,$*, ,$(D32_LIBS)

hello232.exe: hello2.o32
	$(D32_LINK) $(D32_LINK_OPTS) $(D32_OBJS)+hello2.o32,$*, ,$(D32_LIBS)

hello332.exe: hello3.o32 hello.o32
	$(D32_LINK) $(D32_LINK_OPTS) $(D32_OBJS)+hello3.o32+hello.o32,$*, ,$(D32_LIBS)

hellog32.exe: hellog.o32
	$(D32_LINK) $(D32_LINK_OPTS) $(D32_OBJS)+hellog.o32,$*, ,$(D32_LIBS)

# ----- Windows -------------------------------------------------------------
windows: whello1.exe whello2.exe whello3.exe whellog.exe

whello1.exe: hello1.obw
	$(WIN_LINK) $(WIN_LINK_OPTS) $(WIN_OBJS)+hello1.obw,$*,NUL,$(WIN_LIBS),whello.def
	$(WIN_RC) $(WIN_RC_OPTS) whello.rc $*.exe

whello2.exe: hello2.obw
	$(WIN_LINK) $(WIN_LINK_OPTS) $(WIN_OBJS)+hello2.obw,$*,NUL,$(WIN_LIBS),whello.def
	$(WIN_RC) $(WIN_RC_OPTS) whello.rc $*.exe

whello3.exe: hello3.obw hello.obw
	$(WIN_LINK) $(WIN_LINK_OPTS) $(WIN_OBJS)+hello3.obw+hello.obw,$*,NUL,$(WIN_LIBS),whello.def
	$(WIN_RC) $(WIN_RC_OPTS) whello.rc $*.exe

whellog.exe: hellog.obw
	$(WIN_LINK) $(WIN_LINK_OPTS) $(WIN_OBJS)+hellog.obw,$*,NUL,$(WIN_LIBS),whello.def
	$(WIN_RC) $(WIN_RC_OPTS) whello.rc $*.exe

