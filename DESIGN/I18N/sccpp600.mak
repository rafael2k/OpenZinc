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
dos32: i18edit.exe

i18edit.exe: main.o32 i18n.lib
	$(D32_LINK) $(D32_LINK_OPTS) $(D32_OBJS)+main.o32, $*, ,i18n storage direct stredit service $(D32_LIBS)

i18n.lib : i18n.o32 language.o32 locale.o32 \
	export.o32 import.o32 \
	z_bnum.o32 z_curr.o32 z_date.o32 z_date1.o32 z_day.o32 z_error.o32 \
	z_help.o32 z_int.o32 z_month.o32 z_msg.o32 z_num.o32 z_real.o32 \
	z_sys.o32 z_time.o32 z_time1.o32 z_time2.o32 z_win.o32
	-@del i18n.lib
	$(D32_LIBRARIAN) /C $(D32_LIB_OPTS) @d32_zil.rsp

	copy i18n.hpp ..\..\include
	copy i18n.lib ..\..\lib\$(VERSION)
	copy p_i18n.dat ..\..\bin\p_i18n.znc

# ----- Windows Libraries and Programs --------------------------------------

windows: wi18edit.exe

wi18edit.exe: main.obw wi18n.lib
	$(WIN_LINK) $(WIN_LINK_OPTS) $(WIN_OBJS)+main.obw, $*, ,wi18n wstorage wdirect wstredit wservice $(WIN_LIBS), wi18edit.def
	$(WIN_RC) wi18edit.rc $*.exe

wi18n.lib : i18n.obw language.obw locale.obw \
	export.obw import.obw \
	z_bnum.obw z_curr.obw z_date.obw z_date1.obw z_day.obw z_error.obw \
	z_help.obw z_int.obw z_month.obw z_msg.obw z_num.obw z_real.obw \
	z_sys.obw  z_time.obw z_time1.obw z_time2.obw z_win.obw
	-@del wi18n.lib
	$(WIN_LIBRARIAN) $(WIN_LIB_OPTS) @win_zil.rsp

	copy i18n.hpp ..\..\include
	copy wi18n.lib ..\..\lib\$(VERSION)
	copy p_i18n.dat ..\..\bin\p_i18n.znc

