# ----- OS/2 compiler options -----------------------------------------------
OS2_CPP_OPTS=-c -I..
OS2_LINK_OPTS=/c /ap
OS2_OBJS=c02.obj
OS2_LIBS=os2_zil.lib c2.lib os2.lib

OS2_CPP=bcc
OS2_LINK=tlink

.cpp.obo:
	$(OS2_CPP) $(OS2_CPP_OPTS) -o$*.obo {$< }

# ----- Usage --------------------------------------------------------------
usage:
	@echo ...........
	@echo ...........
	@echo To generate the storage utilities for type:
	@echo make -f bccpp150.mak os2
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean

# ----- OS/2 ----------------------------------------------------------------
os2: obrowse.exe ozdump.exe orrmdir.exe ocppath.exe ochkfile.exe ogc.exe ostrip.exe

ochkfile.exe: chkfile.obo
	$(OS2_LINK) $(OS2_LINK_OPTS) @&&!
$(OS2_OBJS)+chkfile.obo
$*, ,$(OS2_LIBS),
!

gc.obo:
	$(OS2_CPP) $(OS2_CPP_OPTS) -DDOGC -ogc.obo cppath.cpp

ogc.exe: gc.obo
	$(OS2_LINK) $(OS2_LINK_OPTS) @&&!
$(OS2_OBJS)+gc.obo
$*, ,$(OS2_LIBS),
!

strip.obo:
	$(OS2_CPP) $(OS2_CPP_OPTS) -DSTRIP -ostrip.obo cppath.cpp

ostrip.exe: strip.obo
	$(OS2_LINK) $(OS2_LINK_OPTS) @&&!
$(OS2_OBJS)+strip.obo
$*, ,$(OS2_LIBS),
!

ocppath.exe: cppath.obo
	$(OS2_LINK) $(OS2_LINK_OPTS) @&&!
$(OS2_OBJS)+cppath.obo
$*, ,$(OS2_LIBS),
!

orrmdir.exe: rrmdir.obo
	$(OS2_LINK) $(OS2_LINK_OPTS) @&&!
$(OS2_OBJS)+rrmdir.obo
$*, ,$(OS2_LIBS),
!

ozdump.exe: zdump.obo
	$(OS2_LINK) $(OS2_LINK_OPTS) @&&!
$(OS2_OBJS)+zdump.obo
$*, ,$(OS2_LIBS),
!

obrowse.exe: browse.obo
	$(OS2_LINK) $(OS2_LINK_OPTS) @&&!
$(OS2_OBJS)+browse.obo
$*, ,$(OS2_LIBS),
!

