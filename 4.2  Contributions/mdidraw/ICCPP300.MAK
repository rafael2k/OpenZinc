PROG = main
PROG_OBOS =

#    nmake -f iccpp300.mak os2

# ----- OS/2 compiler options -----------------------------------------------
OS2_CPP=icc
OS2_LINK=ilink
OS2_RC=rc

OS2_CPP_OPTS=/c /D__OS2__ /Gx+ /Sp
OS2_LINK_OPTS=/NOE /NOI /BASE:0x10000 /PM:PM
OS2_LIB_OPTS=
OS2_RC_OPTS=

OS2_OBJS=
OS2_LIBS=os2_zil.lib

.SUFFIXES : .cpp

.cpp.obo:
	$(OS2_CPP) $(OS2_CPP_OPTS) /Fo$*.obo $<

# ----- Usage --------------------------------------------------------------
usage:
	@echo ...........
	@echo ...........
	@echo To make this Zinc example for IBM C++ type:
	@echo nmake -f iccpp300.mak os2
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean.cmd

# ----- OS/2 ----------------------------------------------------------------
os2: o$(PROG).exe

o$(PROG).exe: $(PROG).obo $(PROG_OBOS)
	$(OS2_LINK) /OUT:$*.exe $(OS2_LINK_OPTS) $(PROG).obo $(PROG_OBOS) $(OS2_OBJS) $(OS2_LIBS) os2.def
	$(OS2_RC) $(OS2_RC_OPTS) os2.rc $*.exe
