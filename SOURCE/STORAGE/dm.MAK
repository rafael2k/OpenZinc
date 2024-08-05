# ----- DOS compiler options ------------------------------------------------
DOS_CPP_OPTS=-c -a1 -bx -ml -I..
DOS_LINK_OPTS=/NOI
DOS_OBJS=
DOS_LIBS=dos_zil

DOS_CPP=dmc
DOS_LINK=link

.cpp.obj:
	$(DOS_CPP) $(DOS_CPP_OPTS) $<

# ----- Usage --------------------------------------------------------------
usage:
	@echo ...........
	@echo ...........
	@echo To generate the storage utilities type:
	@echo make -fdm.mak dos
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean.bat

# ----- DOS -----------------------------------------------------------------
dos: browse.exe zdump.exe rrmdir.exe cppath.exe chkfile.exe gc.exe strip.exe

chkfile.exe: chkfile.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) $(DOS_OBJS)+chkfile.obj,$*,NUL,$(DOS_LIBS),NUL

gc.obj:
	$(DOS_CPP) $(DOS_CPP_OPTS) -DDOGC -o$*.obj cppath.cpp

gc.exe: gc.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) $(DOS_OBJS)+gc.obj,$*,NUL,$(DOS_LIBS),NUL

strip.obj:
	$(DOS_CPP) $(DOS_CPP_OPTS) -DSTRIP -o$*.obj cppath.cpp

strip.exe: strip.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) $(DOS_OBJS)+strip.obj,$*,NUL,$(DOS_LIBS),NUL

cppath.exe: cppath.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) $(DOS_OBJS)+cppath.obj,$*,NUL,$(DOS_LIBS),NUL

rrmdir.exe: rrmdir.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) $(DOS_OBJS)+rrmdir.obj,$*,NUL,$(DOS_LIBS),NUL

zdump.exe: zdump.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) $(DOS_OBJS)+zdump.obj,$*,NUL,$(DOS_LIBS),NUL

browse.exe: browse.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) $(DOS_OBJS)+browse.obj,$*,NUL,$(DOS_LIBS),NUL



