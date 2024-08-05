PROG = lstitm

#    nmake -f mscpp800.mak winnt

# Be sure to set the LIB and INCLUDE environment variables for Zinc, e.g.:
#    set INCLUDE=.;C:\ZINC\INCLUDE;C:\MSTOOLS\H
#    set LIB=.;C:\ZINC\LIB\MVCPP100;C:\MSTOOLS\LIB

.SUFFIXES : .c .cpp .obn

# ----- Windows NT compiler options -----------------------------------------
# for debug:    add /Zi to CPP_OPTS
#               add /DEBUG:MAPPED,FULL /DEBUGTYPE:CV to LINK_OPTS
# for debug:    comment out next line
NODEBUG=1
!include <NTWIN32.MAK>

WNT_LIBS=$(guilibs) VERSION.LIB wnt_zil.lib
WNT_LINK=$(link)
WNT_LINK_OPTS=$(linkdebug) $(guiflags)

.cpp.obn:
	$(cc) $(cflags) $(cvars) $(cdebug) -Fo$*.obn $<

# ----- Usage --------------------------------------------------------------
usage:
	@echo ...........
	@echo ...........
	@echo To make this Zinc example for Visual C++ type:
	@echo nmake -f mscpp800.mak winnt
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean

# ----- Windows NT ----------------------------------------------------------
winnt: n$(PROG).exe

n$(PROG).exe: $(PROG).obn
	$(WNT_LINK) $(WNT_LINK_OPTS) -out:n$(PROG).exe $(WNT_OBJS) $(PROG).obn $(WNT_LIBS)

