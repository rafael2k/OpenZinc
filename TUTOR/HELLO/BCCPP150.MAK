# HELLO tutorial makefile

#    make -f bccpp150.mak os2             (makes the OS/2 hello tutorials)

# Be sure to update your TURBOC.CFG file to include the Zinc paths, e.g.:
#   -I.;C:\ZINC\INCLUDE;C:\BORLANDC\INCLUDE
#   -L.;C:\ZINC\LIB\BCCPP100;C:\BORLANDC\LIB
# and your TLINK.CFG file to include the Zinc paths, e.g.:
#   -L.;C:\ZINC\LIB\BCCPP100;C:\BORLANDC\LIB

## Compiler and linker: (Add -v to CPP_OPTS and /v to LINK_OPTS for debug.)

# ----- OS/2 compiler options -----------------------------------------------
OS2_CPP_OPTS=-c
OS2_LINK_OPTS=/c /B:0x10000 /aa
OS2_OBJS=c02.obj
OS2_LIBS=os2_zil.lib c2.lib os2.lib

CPP=bcc
LINK=tlink
RC=rc

.cpp.obo:
	$(CPP) $(OS2_CPP_OPTS) -o$*.obo {$< }

# ----- Usage --------------------------------------------------------------
usage:
	@echo ...........
	@echo ...........
	@echo To make the Zinc tutorials for Borland C++ type:
	@echo make -f bccpp150.mak os2
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean

# ----- OS/2 ----------------------------------------------------------------
os2: ohello1.exe ohello2.exe ohello3.exe ohellog.exe

ohello1.exe: hello1.obo
	$(LINK) $(OS2_LINK_OPTS) @&&!
$(OS2_OBJS)+hello1.obo
$*, ,$(OS2_LIBS),ohello.def
!
	$(RC) ohello.rc $<

ohello2.exe: hello2.obo
	$(LINK) $(OS2_LINK_OPTS) @&&!
$(OS2_OBJS)+hello2.obo
$*, ,$(OS2_LIBS),ohello.def
!
	$(RC) ohello.rc $<

ohello3.exe: hello3.obo hello.obo
	$(LINK) $(OS2_LINK_OPTS) @&&!
$(OS2_OBJS)+hello3.obo+hello.obo
$*, ,$(OS2_LIBS),ohello.def
!
	$(RC) ohello.rc $<

ohellog.exe: hellog.obo
	$(LINK) $(OS2_LINK_OPTS) @&&!
$(OS2_OBJS)+hellog.obo
$*, ,$(OS2_LIBS),ohello.def
!
	$(RC) ohello.rc $<


