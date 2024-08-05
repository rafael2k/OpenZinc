.SUFFIXES : .c .cpp .obj .obw 

# ----- DOS compiler options ------------------------------------------------
# for debug:    add -Zi to CPP_OPTS
#               and /CO to LINK_OPTS
DOS_CPP=cl
DOS_LINK=link

DOS_CPP_OPTS=-c -AL -BATCH -Gs -I..
DOS_LINK_OPTS=/NOI /NOE /NOD /BATCH /STACK:5120 /SEGMENTS:256
DOS_OBJS=
DOS_LIBS=dos_zil llibce graphics oldnames

.cpp.obj:
	$(DOS_CPP) $(DOS_CPP_OPTS) $<

# ----- Usage --------------------------------------------------------------
usage:
	@echo ...........
	@echo ...........
	@echo To generate the storage utilities type:
	@echo nmake -fmvcpp150.mak dos
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean

# ----- DOS -----------------------------------------------------------------
dos: browse.exe zdump.exe rrmdir.exe cppath.exe chkfile.exe gc.exe strip.exe

chkfile.exe: chkfile.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) @<<zil.rsp
$(DOS_OBJS)+chkfile.obj
$*,NUL,$(DOS_LIBS),NUL
<<

gc.obj:
	$(DOS_CPP) $(DOS_CPP_OPTS) -DDOGC -Fogc.obj  cppath.cpp

gc.exe: gc.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) @<<zil.rsp
$(DOS_OBJS)+gc.obj
$*,NUL,$(DOS_LIBS),NUL
<<

strip.obj:
	$(DOS_CPP) $(DOS_CPP_OPTS) -DSTRIP -Fostrip.obj  cppath.cpp

strip.exe: strip.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) @<<zil.rsp
$(DOS_OBJS)+strip.obj
$*,NUL,$(DOS_LIBS),NUL
<<

cppath.exe: cppath.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) @<<zil.rsp
$(DOS_OBJS)+cppath.obj
$*,NUL,$(DOS_LIBS),NUL
<<

rrmdir.exe: rrmdir.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) @<<zil.rsp
$(DOS_OBJS)+rrmdir.obj
$*,NUL,$(DOS_LIBS),NUL
<<

zdump.exe: zdump.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) @<<zil.rsp
$(DOS_OBJS)+zdump.obj
$*,NUL,$(DOS_LIBS),NUL
<<

browse.exe: browse.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) @<<zil.rsp
$(DOS_OBJS)+browse.obj
$*,NUL,$(DOS_LIBS),NUL
<<
