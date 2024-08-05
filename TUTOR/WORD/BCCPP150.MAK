# WORD tutorial makefile

#    make -f bccpp150.mak os2             (makes all the OS/2 word tutorials)

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

.c.obo:
	$(CPP) $(OS2_CPP_OPTS) -o$*.obo {$< }

.cpp.obo:
	$(CPP) $(OS2_CPP_OPTS) -o$*.obo {$< }

# ----- Usage --------------------------------------------------------------
usage:
	@echo ...........
	@echo ...........
	@echo To make this Zinc tutorial for Borland C++ type:
	@echo make -f bccpp150.mak os2
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean

# ----- OS/2 ----------------------------------------------------------------
os2: oword2.exe oword3.exe

oword2.exe: word2.obo
	$(LINK) $(OS2_LINK_OPTS) @&&!
$(OS2_OBJS)+word2.obo
$*, ,$(OS2_LIBS),oword.def
!
	$(RC) oword.rc $<

oword3.exe: word3.obo word_win.obo
	$(LINK) $(OS2_LINK_OPTS) @&&!
$(OS2_OBJS)+word3.obo+word_win.obo
$*, ,$(OS2_LIBS),oword.def
!
	$(RC) oword.rc $<



