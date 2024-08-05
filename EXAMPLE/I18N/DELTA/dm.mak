PROG = delta

#    make -fdm.mak dos
#    make -fdm.mak dosovl  VCM overlays no longer supported!
#    make -fdm.mak dos32  
#    make -fdm.mak windows
#    make -fdm.mak winnt
#    make -fdm.mak win32


# Be sure to set the LIB and INCLUDE environment variables for Zinc, e.g.:
#    set INCLUDE=.;C:\ZINC\INCLUDE;C:\dm\INCLUDE
#    set LIB=.;C:\ZINC\LIB\dm;C:\dm\LIB

## Compiler and linker: (Add -g to CPP_OPTS and /CO to LINK_OPTS for debug.)

# ----- DOS compiler options ------------------------------------------------
DOS_CPP=dmc
DOS_LINK=link
DOS_CPP_OPTS=-c -a1 -ml -o+space
DOS_LINK_OPTS=/NOI /SEG:300
DOS_OBJS=
DOS_LIBS=dos_zil dos_gfx dm_lgfx

.cpp.obj:
	$(DOS_CPP) $(DOS_CPP_OPTS) $<

# ----- DOS Overlay (VCM) compiler options ---------------------------------
#      overlays no longer supported
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
D32_CPP_OPTS=-c -mx -D$(FONT)
D32_LINK_OPTS=/NOI
D32_OBJS=cx
D32_LIBS=d32_zil d32_gfx dm_32gfx x32

.cpp.o32:
	$(D32_CPP) $(D32_CPP_OPTS) -o$@ $<

# ----- Windows compiler options --------------------------------------------
WIN_CPP=dmc
WIN_LINK=link
WIN_RC=rc

WIN_CPP_OPTS=-c -a1 -ml -W2
WIN_RC_OPTS=
WIN_LINK_OPTS=/NOI
WIN_OBJS=
WIN_LIBS=win_zil libw

.cpp.obw:
	$(WIN_CPP) $(WIN_CPP_OPTS) -o$*.obw $<
	
# ----- Windows NT (and WIN32s) compiler options ----------------------------
WNT_CPP=dmc
WNT_LINK=link
WNT_LIBRARIAN=lib
WNT_RC=rc

WNT_CPP_OPTS=-c -4 -mn -WA
WNT_RC_OPTS=-k
WNT_LINK_OPTS=/NOI
WNT_LIB_OPTS=/N /B

WNT_OBJS=
WNT_LIBS=wnt_zil kernel32 user32 gdi32 ctl3d32

.cpp.obn:
	$(WNT_CPP) $(WNT_CPP_OPTS) -o$@ $<

# ----- Windows 32 compiler options ----------------------------
W32_CPP=dmc
W32_LINK=link
W32_LIBRARIAN=lib
W32_RC=rc

W32_CPP_OPTS=-c -4 -mn -WA -DZIL_WIN32
W32_RC_OPTS=-k
W32_LINK_OPTS=/NOI
W32_LIB_OPTS=/N /B

W32_OBJS=
W32_LIBS=w32_zil kernel32 user32 gdi32 ctl3d32 comctl32

.cpp.ob9:
	$(W32_CPP) $(W32_CPP_OPTS) -o$@ $<


# ----- Usage ---------------------------------------------------------------
usage:
	@echo ...........
	@echo ...........
	@echo To make this Zinc example for Symantec C++ type:
	@echo smake -fdm.mak dos
#	@echo smake -fdm.mak dosovl  VCM Overlays no longer supported
	@echo smake -fdm.mak dos32
	@echo smake -fdm.mak windows
	@echo smake -fdm.mak winnt
	@echo smake -fdm.mak win32
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
#         VCM overlays no longer supported
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
	$(WIN_RC) $(WIN_RC_OPTS) windows.rc 
	
# ----- Windows NT -------------------------------------------------------------
winnt: n$(PROG).exe
n$(PROG).exe: $(PROG).obn
	$(WNT_LINK) $(WNT_LINK_OPTS) $(WNT_OBJS)+$(PROG).obn,$*,NUL,$(WNT_LIBS)

# ----- Windows 32 -------------------------------------------------------------
win32: 9$(PROG).exe
9$(PROG).exe: $(PROG).ob9
	$(W32_LINK) $(W32_LINK_OPTS) $(W32_OBJS)+$(PROG).ob9,$*,NUL,$(W32_LIBS)

