# MOVIE tutorial makefile

#    make -f bccpp200.mak os2             (makes all the OS/2 movie tutorials)

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
	@echo make -f bccpp200.mak os2
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean

# ----- OS/2 ----------------------------------------------------------------
os2: omovie.exe omovie1.exe omovie2.exe omovie3.exe omovie4.exe omovie5.exe omovie6.exe omovie7.exe

omovie.exe: movie.obo p_movie.obo
	$(LINK) $(OS2_LINK_OPTS) @&&!
$(OS2_OBJS)+movie.obo+p_movie.obo
$*, ,$(OS2_LIBS),omovie.def
!

omovie1.exe: movie1.obo p_movie1.obo
	$(LINK) $(OS2_LINK_OPTS) @&&!
$(OS2_OBJS)+movie1.obo+p_movie1.obo
$*, ,$(OS2_LIBS),omovie.def
!

omovie2.exe: movie2.obo p_movie2.obo
	$(LINK) $(OS2_LINK_OPTS) @&&!
$(OS2_OBJS)+movie2.obo+p_movie2.obo
$*, ,$(OS2_LIBS),omovie.def
!

omovie3.exe: movie3.obo p_movie3.obo
	$(LINK) $(OS2_LINK_OPTS) @&&!
$(OS2_OBJS)+movie3.obo+p_movie3.obo
$*, ,$(OS2_LIBS),omovie.def
!

omovie4.exe: movie4.obo p_movie4.obo
	$(LINK) $(OS2_LINK_OPTS) @&&!
$(OS2_OBJS)+movie4.obo+p_movie4.obo
$*, ,$(OS2_LIBS),omovie.def
!

omovie5.exe: movie5.obo p_movie5.obo
	$(LINK) $(OS2_LINK_OPTS) @&&!
$(OS2_OBJS)+movie5.obo+p_movie5.obo
$*, ,$(OS2_LIBS),omovie.def
!

omovie6.exe: movie6.obo p_movie6.obo
	$(LINK) $(OS2_LINK_OPTS) @&&!
$(OS2_OBJS)+movie6.obo+p_movie6.obo
$*, ,$(OS2_LIBS),omovie.def
!

omovie7.exe: movie7.obo p_movie7.obo
	$(LINK) $(OS2_LINK_OPTS) @&&!
$(OS2_OBJS)+movie7.obo+p_movie7.obo
$*, ,$(OS2_LIBS),omovie.def
!



