# WORD tutorial makefile

#    make -fsccpp600.mak dos  	      	(makes all the DOS word tutorials)
#    make -fsccpp600.mak dosovl      	(makes all the DOS VCM overlay word tutorials)
#    make -fsccpp600.mak dos32	      	(makes all the DOS extender word tutorials)
#    make -fsccpp600.mak windows      	(makes all the Windows word tutorials)

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

.c.obj:
	$(DOS_CPP) $(DOS_CPP_OPTS) $<

.cpp.obj:
	$(DOS_CPP) $(DOS_CPP_OPTS) $<

# ----- DOS Overlay (VCM) compiler options ----------------------------------
OVL_CPP=sc
OVL_LINK=link
OVL_CPP_OPTS=-c -a1 -mv -o+space -R
OVL_LINK_OPTS=/NOI /F /PAC
OVL_OBJS=
OVL_LIBS=dos_zilv dos_gfxv sc_lgfxv

.c.ovl:
	$(OVL_CPP) $(OVL_CPP_OPTS) -o$*.ovl $<

.cpp.ovl:
	$(OVL_CPP) $(OVL_CPP_OPTS) -o$*.ovl $<

# ----- DOS extender compiler options ---------------------------------------
D32_CPP=sc
D32_LINK=link

D32_CPP_OPTS=-c -bx -mx -D$(FONT)
D32_LINK_OPTS=/NOI
D32_LIB_OPTS=/C /N /B

D32_OBJS=cx
# --- Use the next line for UI_GRAPHICS_DISPLAY ---
D32_LIBS=d32_zil d32_gfx sc_32gfx

.cpp.o32:
	$(D32_CPP) $(D32_CPP_OPTS) -o$@ $<

.c.o32:
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

.c.obw:
	$(WIN_CPP) $(WIN_CPP_OPTS) -o$*.obw $<

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
dos: word2.exe word3.exe

word2.exe: word2.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) $(DOS_OBJS)+word2.obj,$*,NUL,$(DOS_LIBS),NUL

word3.exe: word3.obj word_win.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) $(DOS_OBJS)+word3.obj+word_win.obj,$*,NUL,$(DOS_LIBS),NUL

# ----- DOS Overlay (VCM) ---------------------------------------------------
dosovl: word2v.exe word3v.exe

word2v.exe: word2.ovl
	$(OVL_LINK) $(OVL_LINK_OPTS) $(OVL_OBJS)+word2.ovl,$*, ,$(OVL_LIBS)

word3v.exe: word3.ovl word_win.ovl
	$(OVL_LINK) $(OVL_LINK_OPTS) $(OVL_OBJS)+word3.ovl+word_win.ovl,$*, ,$(OVL_LIBS)

# ----- Dos extender --------------------------------------------------------
dos32: word232.exe word332.exe

word232.exe: word2.o32
	$(D32_LINK) $(D32_LINK_OPTS) $(D32_OBJS)+word2.o32,$*, ,$(D32_LIBS)

word332.exe: word3.o32 word_win.o32
	$(D32_LINK) $(D32_LINK_OPTS) $(D32_OBJS)+word3.o32+word_win.o32,$*, ,$(D32_LIBS)

# ----- Windows -------------------------------------------------------------
windows: wword2.exe wword3.exe

wword2.exe: word2.obw
	$(WIN_LINK) $(WIN_LINK_OPTS) $(WIN_OBJS)+word2.obw,$*,NUL,$(WIN_LIBS),wword.def
	$(WIN_RC) $(WIN_RC_OPTS) wword.rc $*.exe

wword3.exe: word3.obw word_win.obw
	$(WIN_LINK) $(WIN_LINK_OPTS) $(WIN_OBJS)+word3.obw+word_win.obw,$*,NUL,$(WIN_LIBS),wword.def
	$(WIN_RC) $(WIN_RC_OPTS) wword.rc $*.exe

