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
dos32: msgedit.exe

msgedit.exe: main.o32 message.lib
	$(D32_LINK) $(D32_LINK_OPTS) $(D32_OBJS)+main.o32, $*, ,message storage direct stredit service $(D32_LIBS)

message.lib : message.o32 message1.o32 prefer.o32 \
	import.o32 export.o32
	-@del message.lib
	$(D32_LIBRARIAN) /C $(D32_LIB_OPTS) message+message.o32+message1.o32+prefer.o32+import.o32+export.o32;

	copy message.hpp ..\..\include
	copy message.lib ..\..\lib\$(VERSION)
	copy p_messag.dat ..\..\bin\p_messag.znc

# ----- Windows Libraries and Programs --------------------------------------

windows: wmsgedit.exe

wmsgedit.exe: main.obw wmessage.lib
	$(WIN_LINK) $(WIN_LINK_OPTS) $(WIN_OBJS)+main.obw, $*, ,wmessage wstorage wdirect wstredit wservice $(WIN_LIBS), wmessage.def
	$(WIN_RC) wmessage.rc $*.exe

wmessage.lib : message.obw message1.obw prefer.obw import.obw export.obw
	-@del wmessage.lib
	$(WIN_LIBRARIAN) $(WIN_LIB_OPTS) wmessage+message.obw+message1.obw+prefer.obw+import.obw+export.obw;

	copy message.hpp ..\..\include
	copy wmessage.lib ..\..\lib\$(VERSION)
	copy p_messag.dat ..\..\bin\p_messag.znc

