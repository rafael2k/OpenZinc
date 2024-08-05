VERSION=sccpp600

# ----- DOS compiler options ------------------------------------------------
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
dos32: hlpedit.exe

hlpedit.exe: main.o32 help.lib
	$(D32_LINK) $(D32_LINK_OPTS) $(D32_OBJS)+main.o32, $*, ,help storage direct stredit service $(D32_LIBS)

help.lib : help.o32 help1.o32 import.o32 export.o32
	-@del help.lib
	$(D32_LIBRARIAN) /C $(D32_LIB_OPTS) help+help.o32+help1.o32+import.o32+export.o32;

	copy help.hpp ..\..\include
	copy help.lib ..\..\lib\$(VERSION)
	copy p_help.dat ..\..\bin\p_help.znc

# ----- Windows Libraries and Programs --------------------------------------

windows: whlpedit.exe

whlpedit.exe: main.obw whelp.lib
	$(WIN_LINK) $(WIN_LINK_OPTS) $(WIN_OBJS)+main.obw, $*, ,whelp wstorage wdirect wstredit wservice $(WIN_LIBS), whelp.def
	$(WIN_RC) whelp.rc $*.exe

whelp.lib : help.obw help1.obw import.obw export.obw
	-@del whelp.lib
	$(WIN_LIBRARIAN) $(WIN_LIB_OPTS) whelp+help.obw+help1.obw+import.obw+export.obw;

	copy help.hpp ..\..\include
	copy whelp.lib ..\..\lib\$(VERSION)
	copy p_help.dat ..\..\bin\p_help.znc

