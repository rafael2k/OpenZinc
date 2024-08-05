.EXTENSIONS:
.EXTENSIONS: .o32 .obw .obn .obo .cpp

# ----- DOS compiler options ------------------------------------------------
D32_CPP_OPTS=/bt=dos -I..
D32_LINK_OPTS=SYSTEM dos4g OP stack=20000
D32_OBJS=
D32_LIBS=d32_zil

D32_CPP=wpp386
D32_LINK=wlink

.cpp.o32:
	$(D32_CPP) $(D32_CPP_OPTS) -fo=$[*.o32 $<

# ----- OS/2 compiler options -----------------------------------------------
OS2_CPP=wpp386
OS2_LINK=wlink
OS2_RC=rc

OS2_CPP_OPTS=/bt=OS2
OS2_LINK_OPTS=SYSTEM os2v2_pm OP ST=62000
OS2_RC_OPTS=
OS2_OBJS=
OS2_LIBS=os2_zil

.cpp.obo:
	$(OS2_CPP) $(OS2_CPP_OPTS) -fo=$[*.obo $<

# ----- Usage --------------------------------------------------------------
usage:
	@echo ...........
	@echo ...........
	@echo To generate the storage utilities type:
	@echo wmake -f wccpp.mak dos32
	@echo wmake -f wccpp.mak os2
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean

# ----- DOS -----------------------------------------------------------------
dos32: browse.exe zdump.exe rrmdir.exe cppath.exe chkfile.exe gc.exe strip.exe

chkfile.exe: chkfile.o32
	$(D32_LINK) $(D32_LINK_OPTS) N chkfile F chkfile.o32 $(D32_OBJS) L $(D32_LIBS)

gc.o32:
	$(D32_CPP) $(D32_CPP_OPTS) -DDOGC -fo=gc.o32 cppath.cpp

gc.exe: gc.o32
	$(D32_LINK) $(D32_LINK_OPTS) N gc F gc.o32 $(D32_OBJS) L $(D32_LIBS)

strip.o32:
	$(D32_CPP) $(D32_CPP_OPTS) -DSTRIP -fo=strip.o32 cppath.cpp

strip.exe: strip.o32
	$(D32_LINK) $(D32_LINK_OPTS) N strip F strip.o32 $(D32_OBJS) L $(D32_LIBS)

cppath.exe: cppath.o32
	$(D32_LINK) $(D32_LINK_OPTS) N cppath F cppath.o32 $(D32_OBJS) L $(D32_LIBS)

rrmdir.exe: rrmdir.o32
	$(D32_LINK) $(D32_LINK_OPTS) N rrmdir F rrmdir.o32 $(D32_OBJS) L $(D32_LIBS)

zdump.exe: zdump.o32
	$(D32_LINK) $(D32_LINK_OPTS) N zdump F zdump.o32 $(D32_OBJS) L $(D32_LIBS)

browse.exe: browse.o32
	$(D32_LINK) $(D32_LINK_OPTS) N browse F browse.o32 $(D32_OBJS) L $(D32_LIBS)

# ----- OS/2 ----------------------------------------------------------------
os2: obrowse.exe ozdump.exe orrmdir.exe ocppath.exe ochkfile.exe ogc.exe ostrip.exe

ochkfile.exe: chkfile.obo
	$(OS2_LINK) $(OS2_LINK_OPTS) N ochkfile.exe F chkfile.obo$(OS2_OBJS) L $(OS2_LIBS)

gc.obo:
	$(OS2_CPP) $(OS2_CPP_OPTS) -DDOGC -fo=gc.obo cppath.cpp

ogc.exe: gc.obo
	$(OS2_LINK) $(OS2_LINK_OPTS) N ogc.exe F gc.obo$(OS2_OBJS) L $(OS2_LIBS)

strip.obo:
	$(OS2_CPP) $(OS2_CPP_OPTS) -DSTRIP -fo=strip.obo cppath.cpp

ostrip.exe: strip.obo
	$(OS2_LINK) $(OS2_LINK_OPTS) N ostrip.exe F strip.obo$(OS2_OBJS) L $(OS2_LIBS)

ocppath.exe: cppath.obo
	$(OS2_LINK) $(OS2_LINK_OPTS) N ocppath.exe F cppath.obo$(OS2_OBJS) L $(OS2_LIBS)

orrmdir.exe: rrmdir.obo
	$(OS2_LINK) $(OS2_LINK_OPTS) N orrmdir.exe F rrmdir.obo$(OS2_OBJS) L $(OS2_LIBS)

ozdump.exe: zdump.obo
	$(OS2_LINK) $(OS2_LINK_OPTS) N ozdump.exe F zdump.obo$(OS2_OBJS) L $(OS2_LIBS)

obrowse.exe: browse.obo
	$(OS2_LINK) $(OS2_LINK_OPTS) N obrowse.exe F browse.obo$(OS2_OBJS) L $(OS2_LIBS)



