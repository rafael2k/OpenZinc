PROG = makemap

#    smake -fdm.mak dos
#    smake -fdm.mak dosovl
#    smake -fdm.mak dos32
#    smake -fdm.mak windows

# Be sure to set the LIB and INCLUDE environment variables for Zinc, e.g.:
#    set INCLUDE=.;C:\ZINC\INCLUDE;C:\SC\INCLUDE
#    set LIB=.;C:\ZINC\LIB\SCCPP610;C:\SC\LIB

## Compiler and linker: (Add -g to CPP_OPTS and /CO to LINK_OPTS for debug.)

# ----- DOS compiler options ------------------------------------------------
DOS_CPP=dmc
DOS_LINK=link
DOS_CPP_OPTS=-c -a1 -ml -o+space
DOS_LINK_OPTS=/NOI
DOS_OBJS=
DOS_LIBS=dos_zil dos_gfx dm_lgfx

.cpp.obj:
	$(DOS_CPP) $(DOS_CPP_OPTS) $<

# ----- DOS Overlay (VCM) compiler options ----------------------------------
OVL_CPP=dmc
OVL_LINK=link386
OVL_CPP_OPTS=-c -a1 -mv -o+space -R
OVL_LINK_OPTS=/NOI /F /PAC
OVL_OBJS=
OVL_LIBS=dos_zilv dos_gfxv dm_lgfxv

.cpp.ovl:
	$(OVL_CPP) $(OVL_CPP_OPTS) -o$*.ovl $<

# ----- DOS extender compiler options ---------------------------------------
D32_CPP=dmc
D32_LINK=link386
D32_CPP_OPTS=-c -bx -mx -D$(FONT)
D32_LINK_OPTS=/NOI
D32_OBJS=cx
D32_LIBS=d32_zil d32_gfx dm_32gfx

.cpp.o32:
	$(D32_CPP) $(D32_CPP_OPTS) -o$@ $<

# ----- Windows compiler options --------------------------------------------
WIN_CPP=dmc
WIN_LINK=link
WIN_RC=rc

# --- Use the next 2 lines for Windows 3.0 compatibility ---
WIN_CPP_OPTS=-c -a1 -bx -ml -W2 -DWINVER=0x0300
WIN_RC_OPTS=-k -30
# --- Use the next 2 lines for Windows 3.1 compatibility ---
#WIN_CPP_OPTS=-c -a1 -bx -ml -W2
#WIN_RC_OPTS=-k
WIN_LINK_OPTS=/NOI
WIN_OBJS=
WIN_LIBS=win_zil libw

.cpp.obw:
	$(WIN_CPP) $(WIN_CPP_OPTS) -o$*.obw $<

# ----- Usage ---------------------------------------------------------------
usage:
	@echo ...........
	@echo ...........
	@echo To make this Zinc example for Symantec C++ type:
	@echo smake -fdm.mak dos
	@echo smake -fdm.mak dosovl
	@echo smake -fdm.mak dos32
	@echo smake -fdm.mak windows
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean.bat

# ----- DOS -----------------------------------------------------------------
dos: $(PROG).exe

$(PROG).exe: $(PROG).obj
	$(DOS_LINK) $(DOS_LINK_OPTS) $(DOS_OBJS)+$(PROG).obj,$*,NUL,$(DOS_LIBS),NUL

# ----- DOS Overlay (VCM) ---------------------------------------------------
dosovl: $(PROG)v.exe

$(PROG)v.exe: $(PROG).ovl
	$(OVL_LINK) $(OVL_LINK_OPTS) $(OVL_OBJS)+$(PROG).ovl,$*, ,$(OVL_LIBS)

# ----- Dos extender --------------------------------------------------------
dos32: $(PROG)32.exe

$(PROG)32.exe: $(PROG).o32
	$(D32_LINK) $(D32_LINK_OPTS) $(D32_OBJS)+$(PROG).o32,$*, ,$(D32_LIBS)

# ----- Windows -------------------------------------------------------------
windows: w$(PROG).exe

w$(PROG).exe: $(PROG).obw
	$(WIN_LINK) $(WIN_LINK_OPTS) $(WIN_OBJS)+$(PROG).obw,$*,NUL,$(WIN_LIBS),windows.def
	$(WIN_RC) $(WIN_RC_OPTS) windows.rc $*.exe
