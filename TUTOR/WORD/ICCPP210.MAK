# WORD tutorial makefile

#    nmake -f iccpp210.mak os2	(makes all the OS/2 word tutorials)

# ----- OS/2 compiler options -----------------------------------------------
OS2_CPP=icc
OS2_LINK=link386
OS2_LIBRARIAN=lib
OS2_RC=rc

OS2_CPP_OPTS=/c /D__OS2__ /O+
OS2_LINK_OPTS=/NOE /NOI /BASE:0x10000 /PM:PM
OS2_LIB_OPTS=
OS2_RC_OPTS=

OS2_OBJS=
OS2_LIBS=os2_zil.lib

.SUFFIXES : .cpp

.c.obj:
	$(OS2_CPP) $(OS2_CPP_OPTS) $<

.cpp.obj:
	$(OS2_CPP) $(OS2_CPP_OPTS) $<

# ----- Usage --------------------------------------------------------------
usage:
	@echo ...........
	@echo ...........
	@echo To make this Zinc tutorial for IBM C++ type:
	@echo nmake -f iccpp210.mak os2
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean.cmd

# ----- OS/2 ----------------------------------------------------------------
os2: oword2.exe oword3.exe

oword2.exe: word2.obj
	$(OS2_LINK) $(OS2_LINK_OPTS) @<<zil.rsp
$(OS2_OBJS)+word2.obj
$*,NUL,$(OS2_LIBS),oword.def
<<
	$(OS2_RC) $(OS2_RC_OPTS) oword.rc $*.exe

oword3.exe: word3.obj word_win.obj
	$(OS2_LINK) $(OS2_LINK_OPTS) @<<zil.rsp
$(OS2_OBJS)+word3.obj+word_win.obj
$*,NUL,$(OS2_LIBS),oword.def
<<
	$(OS2_RC) $(OS2_RC_OPTS) oword.rc $*.exe
