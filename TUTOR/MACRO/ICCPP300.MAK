# MACRO tutorial makefile

#    make -f iccpp300.mak os2             (makes all the OS/2 macro tutorials)

# Be sure to update your INCLUDE and LIB to include the Zinc paths, e.g.:
#   set INCLUDE=%INCLUDE%;;C:\ZINC\INCLUDE
#   set LIB=%LIB%;C:\ZINC\LIB\ICCPP300

## Compiler and linker: (Add /Ti+ to CPP_OPTS and /DE[BUG] to LINK_OPTS for debug.)

# ----- OS/2 compiler options -----------------------------------------------
OS2_CPP=icc
OS2_LINK=ilink
OS2_RC=rc

OS2_CPP_OPTS=/c /D__OS2__ /Gx+ /Sp1
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
os2: omacro.exe

omacro.exe: macro.obo
	$(OS2_LINK) /OUT:$*.exe $(OS2_LINK_OPTS) $(OS2_OBJS) macro.obo $(OS2_LIBS) omacro.def
	$(OS2_RC) $(OS2_RC_OPTS) omacro.rc $*.exe

