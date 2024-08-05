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

# ----- DOS 16 bit extender (Rational DOS16M) compiler options --------------
dos : storage.obj
	-@del storage.lib
	$(DOS_LIBRARIAN) /C $(DOS_LIB_OPTS) storage.lib+storage.obj;

	copy storage.hpp ..\..\include
	copy storage.lib ..\..\lib\$(VERSION)
	copy p_store.dat ..\..\bin\p_store.znc

dosovl : storage.ovl
	-@del storage.lib
	$(OVL_LIBRARIAN) /C $(OVL_LIB_OPTS) storage.lib+storage.ovl;

	copy storage.hpp ..\..\include
	copy storage.lib ..\..\lib\$(VERSION)
	copy p_store.dat ..\..\bin\p_store.znc

# ----- DOS 32 bit extender (X-32VM) compiler options -----------------------
dos32: browse.exe

browse.exe: main.o32 storage.lib
	$(D32_LINK) $(D32_LINK_OPTS) $(D32_OBJS)+main.o32, $*, ,storage direct service $(D32_LIBS)

storage.lib : storage.o32
	-@del storage.lib
	$(D32_LIBRARIAN) /C $(D32_LIB_OPTS) storage+storage.o32;

	copy storage.hpp ..\..\include
	copy storage.lib ..\..\lib\$(VERSION)
	copy p_store.dat ..\..\bin\p_store.znc

# ----- Windows Libraries and Programs --------------------------------------

windows: wtest.exe

wtest.exe: main.obw wstorage.lib
	$(WIN_LINK) $(WIN_LINK_OPTS) $(WIN_OBJS)+main.obw, $*, ,wstorage wdirect wservice $(WIN_LIBS), wtest.def
	$(WIN_RC) wtest.rc $*.exe

wstorage.lib : storage.obw
	-@del wstorage.lib
	$(WIN_LIBRARIAN) $(WIN_LIB_OPTS) wstorage+storage.obw;

	copy storage.hpp ..\..\include
	copy wstorage.lib ..\..\lib\$(VERSION)
	copy p_store.dat ..\..\bin\p_store.znc

