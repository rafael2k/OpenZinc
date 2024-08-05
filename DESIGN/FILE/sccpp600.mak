# ----- General Definitions -------------------------------------------------
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
dos32: file32.exe

file32.exe: main.o32 file.lib
	$(D32_LINK) $(D32_LINK_OPTS) $(D32_OBJS)+main.o32, $*, ,storage stredit file direct service $(D32_LIBS)

file.lib : file.o32
	-@del file.lib
	$(D32_LIBRARIAN) /C $(D32_LIB_OPTS) file+file.o32;

	copy file.hpp ..\..\include
	copy file.lib ..\..\lib\$(VERSION)
	copy p_file.dat ..\..\bin\p_file.znc

# ----- Windows Libraries and Programs --------------------------------------

windows: wfile.exe

wfile.exe: main.obw wfile.lib
	$(WIN_LINK) $(WIN_LINK_OPTS) $(WIN_OBJS)+main.obw, $*, ,wstorage wstredit wfile wservice wdirect $(WIN_LIBS), wfile.def
	$(WIN_RC) wfile.rc $*.exe

wfile.lib : file.obw
	-@del wfile.lib
	$(WIN_LIBRARIAN) $(WIN_LIB_OPTS) wfile+file.obw;

	copy file.hpp ..\..\include
	copy wfile.lib ..\..\lib\$(VERSION)
	copy p_file.dat ..\..\bin\p_file.znc

