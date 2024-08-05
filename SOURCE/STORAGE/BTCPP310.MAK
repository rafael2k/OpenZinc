# ----- DOS compiler options ------------------------------------------------
DOS_CPP_OPTS=-c -ml -O -w -I..
DOS_LINK_OPTS=/c /x
DOS_OBJS=c0l
DOS_LIBS=dos_zil1 dos_zil2 emu mathl cl

DOS_CPP=bcc
DOS_LINK=tlink

.cpp.obj:
	$(DOS_CPP) $(DOS_CPP_OPTS) {$< }

# ----- Usage --------------------------------------------------------------
usage:
	@echo ...........
	@echo ...........
	@echo To generate the storage utilities for type:
	@echo make -f btcpp310.mak dos
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean

# ----- DOS -----------------------------------------------------------------
dos: browse.exe zdump.exe rrmdir.exe cppath.exe chkfile.exe gc.exe strip.exe

chkfile.exe: chkfile.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) @&&!
$(DOS_OBJS)+chkfile.obj
$*, ,$(DOS_LIBS)
!

gc.obj: cppath.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DDOGC -ogc.obj cppath.cpp

gc.exe: gc.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) @&&!
$(DOS_OBJS)+gc.obj
$*, ,$(DOS_LIBS)
!

strip.obj: cppath.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DSTRIP -ostrip.obj cppath.cpp

strip.exe: strip.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) @&&!
$(DOS_OBJS)+strip.obj
$*, ,$(DOS_LIBS)
!

cppath.exe: cppath.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) @&&!
$(DOS_OBJS)+cppath.obj
$*, ,$(DOS_LIBS)
!

rrmdir.exe: rrmdir.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) @&&!
$(DOS_OBJS)+rrmdir.obj
$*, ,$(DOS_LIBS)
!

zdump.exe: zdump.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) @&&!
$(DOS_OBJS)+zdump.obj
$*, ,$(DOS_LIBS)
!

browse.exe: browse.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) @&&!
$(DOS_OBJS)+browse.obj
$*, ,$(DOS_LIBS)
!
