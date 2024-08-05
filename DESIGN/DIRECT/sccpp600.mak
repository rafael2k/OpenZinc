VERSION=sccpp600

# --- DOS ---
DOS_CPP=sc
DOS_LINK=link
DOS_LIBRARIAN=lib
DOS_CPP_OPTS=-c -a1 -bx -ml -o+space -R
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
OVL_CPP_OPTS=-c -a1 -bx -mv -R
OVL_LINK_OPTS=/NOI /F /PAC
OVL_LIB_OPTS=/N /B /NOI
OVL_OBJS=
OVL_LIBS=dos_zilv dos_gfxv sc_lgfxv

.cpp.ovl:
	$(OVL_CPP) $(OVL_CPP_OPTS) -o$@ $<

# ----- DOS compiler options ------------------------------------------------
D32_CPP=sc
D32_LINK=link
D32_LIBRARIAN=lib
D32_CPP_OPTS=-c -bx -mx -R
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
WIN_LIBS=win_zil libw commdlg

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

# ----- DOS 16 bit extender (Rational DOS16M) compiler options --------------
# DOS - Library support only
dos : d_direct.obj
	-@del direct.lib
	$(DOS_LIBRARIAN) /C $(DOS_LIB_OPTS) direct.lib+d_direct.obj;

	copy direct.hpp ..\..\include
	copy direct.lib ..\..\lib\$(VERSION)
	copy p_direct.dat ..\..\bin\p_direct.znc

# DOS OVERLAY - Library support only
dosovl : d_direct.ovl
	-@del direct.lib
	$(OVL_LIBRARIAN) /C $(OVL_LIB_OPTS) direct.lib+d_direct.ovl;

	copy direct.hpp ..\..\include
	copy direct.lib ..\..\lib\$(VERSION)
	copy p_direct.dat ..\..\bin\p_direct.znc

# ----- DOS 32 bit extender (X-32VM) compiler options -----------------------
dos32: test32.exe

test32.exe: main.o32 direct.lib
	$(D32_LINK) $(D32_LINK_OPTS) $(D32_OBJS)+main.o32, $*, ,direct service $(D32_LIBS)

direct.lib : d_direct.o32
	-@del direct.lib
	$(D32_LIBRARIAN) /C $(D32_LIB_OPTS) direct+d_direct.o32;

	copy direct.hpp ..\..\include
	copy direct.lib ..\..\lib\$(VERSION)
	copy p_direct.dat ..\..\bin\p_direct.znc

# ----- Windows Libraries and Programs --------------------------------------

windows: wtest.exe

wtest.exe: main.obw wdirect.lib
	$(WIN_LINK) $(WIN_LINK_OPTS) $(WIN_OBJS)+main.obw, $*, ,wdirect wservice $(WIN_LIBS), wtest.def
	$(WIN_RC) wtest.rc $*.exe

wdirect.lib : w_direct.obw
	-@del wdirect.lib
	$(WIN_LIBRARIAN) $(WIN_LIB_OPTS) wdirect+w_direct.obw;

	copy direct.hpp ..\..\include
	copy wdirect.lib ..\..\lib\$(VERSION)
	copy p_direct.dat ..\..\bin\p_direct.znc

