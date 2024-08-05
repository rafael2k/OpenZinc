# MOVIE tutorial makefile

#    nmake -fmvcpp150.mak dos          (makes all the DOS movie tutorials)
#    nmake -fmvcpp150.mak dosovl       (makes all the DOS overlay movie tutorials)
#    nmake -fmvcpp150.mak dos16        (makes all the DOS extender movie tutorials)
#    nmake -fmvcpp150.mak windows      (makes all the Windows movie tutorials)

# Be sure to set the LIB and INCLUDE environment variables for Zinc, e.g.:
#    set INCLUDE=.;C:\ZINC\INCLUDE;C:\MSVC\INCLUDE
#    set LIB=.;C:\ZINC\LIB\MVCPP150;C:\MSVC\LIB

# ----- DOS compiler options ------------------------------------------------
# for debug:    add -Zi to CPP_OPTS
#               and /CO to LINK_OPTS
DOS_CPP=cl
DOS_LINK=link

DOS_CPP_OPTS=-c -AL -BATCH -Gs
DOS_LINK_OPTS=/NOI /NOE /NOD /B /ST:12288 /SE:256 /ON:N
DOS_OVL_LINK_OPTS=/NOI /NOE /NOD /B /DY:475 /ST:12288 /SE:256 /ON:N
DOS_OBJS=
# --- Use the next line for UI_GRAPHICS_DISPLAY ---
DOS_LIBS=dos_zil dos_gfx ms_lgfx llibce graphics oldnames
# --- Use the next line for UI_MSC_DISPLAY ---
#DOS_LIBS=dos_zil dos_msc llibce graphics oldnames

.cpp.obj:
	$(DOS_CPP) $(DOS_CPP_OPTS) $<

# ----- Dos Extender ---------------------------------------------------------
!IF !DEFINED(PHARLAP16) && !DEFINED(RATIONAL16)
# Note:  Set the following variable to PHARLAP16 for Pharlap or RATIONAL16
# for DOS16M. Default is PHARLAP16.
PHARLAP16=1
# Use one of the following command lines to override this setting.
#  nmake "PHARLAP16=" -fmvcpp150.mak dos16
#  nmake "RATIONAL16=" -fmvcpp150.mak dos16
!ENDIF

# for debug:    add -Zi to CPP_OPTS
#               and /CO to LINK_OPTS
D16_CPP=cl
D16_LINK=link

# ----Pharlap----
!IF DEFINED(PHARLAP16)
D16_CPP_OPTS=-c -AL -BATCH -Gs2 -DDOSX286 -D$(FONT) -nologo
D16_LINK_OPTS=/NOI /NOE /NOD /B /SE:256 /ST:12288 /ON:N
D16_OBJS=graphp.obj
D16_DEF_FILE=m16.def
# --- Use the next line for UI_GRAPHICS_DISPLAY ---
D16_LIBS=phapi d16_zil d16_gfx ms_16gfx llibcep graphics oldnames
# --- Use the next line for UI_MSC_DISPLAY ---
#D16_LIBS=phapi llibcep graphics d16_msc d16_zil oldnames
!ENDIF

!IF DEFINED(RATIONAL16)
# ---- DOS16M----
D16_CPP_OPTS=-c -AL -BATCH -Gs2 -DDOS16M -nologo
D16_LINK_OPTS=/NOI /NOE /BATCH /SE:256 /ON:N
D16_OBJS=crt0_16m.obj+crt0datn.obj+emoem.obj+qccore.obj+llvesa
D16_DEF_FILE=dos16m.def
# --- Use the next line for UI_GRAPHICS_DISPLAY ---
D16_LIBS=msc80lse msc80l msc80lg dos16 d16libc d16_zil d16_gfx ms_16gfx 
# --- Use the next line for UI_MSC_DISPLAY ---
#D16_LIBS=msc80lse msc80l msc80lg dos16 d16_zil d16_msc graphics
!ENDIF

.cpp.o16:
	$(D16_CPP) $(D16_CPP_OPTS) -Fo$*.o16 $<

# ----- Windows compiler options --------------------------------------------
# for debug:    add -Zi to CPP_OPTS
#               and /CO to LINK_OPTS
WIN_CPP=cl
WIN_LINK=link
WIN_RC=rc

WIN_CPP_OPTS=-c -AL -BATCH -Gsw
WIN_RC_OPTS=-k
WIN_LINK_OPTS=/NOE /NOD /NOI /BATCH /SEGMENTS:256
WIN_OBJS=
WIN_LIBS=win_zil libw llibcew oldnames 

.cpp.obw:
	$(WIN_CPP) $(WIN_CPP_OPTS) -Fo$*.obw $<

# ----- Usage --------------------------------------------------------------
usage:
	@echo ...........
	@echo ...........
	@echo To make this Zinc tutorial for Visual C++ type:
	@echo nmake -fmvcpp150.mak dos
	@echo nmake -fmvcpp150.mak dosovl
	@echo nmake -fmvcpp150.mak dos16
	@echo nmake -fmvcpp150.mak windows
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean

# ----- DOS -----------------------------------------------------------------
dos: movie.exe movie1.exe movie2.exe movie3.exe movie4.exe movie5.exe movie6.exe movie7.exe

movie.exe: movie.obj p_movie.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) @<<zil.rsp
$(DOS_OBJS)+movie.obj+p_movie.obj
$*,NUL,$(DOS_LIBS),NUL
<<

movie1.exe: movie1.obj p_movie1.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) @<<zil.rsp
$(DOS_OBJS)+movie1.obj+p_movie1.obj
$*,NUL,$(DOS_LIBS),NUL
<<

movie2.exe: movie2.obj p_movie2.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) @<<zil.rsp
$(DOS_OBJS)+movie2.obj+p_movie2.obj
$*,NUL,$(DOS_LIBS),NUL
<<

movie3.exe: movie3.obj p_movie3.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) @<<zil.rsp
$(DOS_OBJS)+movie3.obj+p_movie3.obj
$*,NUL,$(DOS_LIBS),NUL
<<

movie4.exe: movie4.obj p_movie4.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) @<<zil.rsp
$(DOS_OBJS)+movie4.obj+p_movie4.obj
$*,NUL,$(DOS_LIBS),NUL
<<

movie5.exe: movie5.obj p_movie5.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) @<<zil.rsp
$(DOS_OBJS)+movie5.obj+p_movie5.obj
$*,NUL,$(DOS_LIBS),NUL
<<

movie6.exe: movie6.obj p_movie6.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) @<<zil.rsp
$(DOS_OBJS)+movie6.obj+p_movie6.obj
$*,NUL,$(DOS_LIBS),NUL
<<

movie7.exe: movie7.obj p_movie7.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) @<<zil.rsp
$(DOS_OBJS)+movie7.obj+p_movie7.obj
$*,NUL,$(DOS_LIBS),NUL
<<

# ----- DOS Overlay ---------------------------------------------------------
dosovl: moviev.exe movie1v.exe movie2v.exe movie3v.exe movie4v.exe movie5v.exe movie6v.exe movie7v.exe

moviev.exe: movie.obj p_movie.obj
	$(DOS_LINK) $(DOS_OVL_LINK_OPTS) @<<zil.rsp
$(DOS_OBJS)+movie.obj+p_movie.obj
$*,NUL,$(DOS_LIBS),mvc_ovl.def
<<

movie1v.exe: movie1.obj p_movie1.obj
	$(DOS_LINK) $(DOS_OVL_LINK_OPTS) @<<zil.rsp
$(DOS_OBJS)+movie1.obj+p_movie1.obj
$*,NUL,$(DOS_LIBS),mvc_ovl.def
<<

movie2v.exe: movie2.obj p_movie2.obj
	$(DOS_LINK) $(DOS_OVL_LINK_OPTS) @<<zil.rsp
$(DOS_OBJS)+movie2.obj+p_movie2.obj
$*,NUL,$(DOS_LIBS),mvc_ovl.def
<<

movie3v.exe: movie3.obj p_movie3.obj
	$(DOS_LINK) $(DOS_OVL_LINK_OPTS) @<<zil.rsp
$(DOS_OBJS)+movie3.obj+p_movie3.obj
$*,NUL,$(DOS_LIBS),mvc_ovl.def
<<

movie4v.exe: movie4.obj p_movie4.obj
	$(DOS_LINK) $(DOS_OVL_LINK_OPTS) @<<zil.rsp
$(DOS_OBJS)+movie4.obj+p_movie4.obj
$*,NUL,$(DOS_LIBS),mvc_ovl.def
<<

movie5v.exe: movie5.obj p_movie5.obj
	$(DOS_LINK) $(DOS_OVL_LINK_OPTS) @<<zil.rsp
$(DOS_OBJS)+movie5.obj+p_movie5.obj
$*,NUL,$(DOS_LIBS),mvc_ovl.def
<<

movie6v.exe: movie6.obj p_movie6.obj
	$(DOS_LINK) $(DOS_OVL_LINK_OPTS) @<<zil.rsp
$(DOS_OBJS)+movie6.obj+p_movie6.obj
$*,NUL,$(DOS_LIBS),mvc_ovl.def
<<

movie7v.exe: movie7.obj p_movie7.obj
	$(DOS_LINK) $(DOS_OVL_LINK_OPTS) @<<zil.rsp
$(DOS_OBJS)+movie7.obj+p_movie7.obj
$*,NUL,$(DOS_LIBS),mvc_ovl.def
<<

# ----- DOS Extender ---------------------------------------------------------
dos16: movie16.exe movie116.exe movie216.exe movie316.exe movie416.exe movie516.exe movie616.exe movie716.exe

movie16.exe: movie.o16 p_movie.o16
	$(D16_LINK) $(D16_LINK_OPTS) @<<zil.rsp
$(D16_OBJS)+movie.o16+p_movie.o16
$*,NUL,$(D16_LIBS),$(D16_DEF_FILE)
<<

movie116.exe: movie1.o16 p_movie1.o16
	$(D16_LINK) $(D16_LINK_OPTS) @<<zil.rsp
$(D16_OBJS)+movie1.o16+p_movie1.o16
$*,NUL,$(D16_LIBS),$(D16_DEF_FILE)
<<

movie216.exe: movie2.o16 p_movie2.o16
	$(D16_LINK) $(D16_LINK_OPTS) @<<zil.rsp
$(D16_OBJS)+movie2.o16+p_movie2.o16
$*,NUL,$(D16_LIBS),$(D16_DEF_FILE)
<<

movie316.exe: movie3.o16 p_movie3.o16
	$(D16_LINK) $(D16_LINK_OPTS) @<<zil.rsp
$(D16_OBJS)+movie3.o16+p_movie3.o16
$*,NUL,$(D16_LIBS),$(D16_DEF_FILE)
<<

movie416.exe: movie4.o16 p_movie4.o16
	$(D16_LINK) $(D16_LINK_OPTS) @<<zil.rsp
$(D16_OBJS)+movie4.o16+p_movie4.o16
$*,NUL,$(D16_LIBS),$(D16_DEF_FILE)
<<

movie516.exe: movie5.o16 p_movie5.o16
	$(D16_LINK) $(D16_LINK_OPTS) @<<zil.rsp
$(D16_OBJS)+movie5.o16+p_movie5.o16
$*,NUL,$(D16_LIBS),$(D16_DEF_FILE)
<<

movie616.exe: movie6.o16 p_movie6.o16
	$(D16_LINK) $(D16_LINK_OPTS) @<<zil.rsp
$(D16_OBJS)+movie6.o16+p_movie6.o16
$*,NUL,$(D16_LIBS),$(D16_DEF_FILE)
<<

movie716.exe: movie7.o16 p_movie7.o16
	$(D16_LINK) $(D16_LINK_OPTS) @<<zil.rsp
$(D16_OBJS)+movie7.o16+p_movie7.o16
$*,NUL,$(D16_LIBS),$(D16_DEF_FILE)
<<

# ----- Windows -------------------------------------------------------------
windows: wmovie.exe wmovie1.exe wmovie2.exe wmovie3.exe wmovie4.exe wmovie5.exe wmovie6.exe wmovie7.exe

wmovie.exe: movie.obw p_movie.obw
	$(WIN_LINK) $(WIN_LINK_OPTS) @<<zil.rsp
$(WIN_OBJS)+movie.obw+p_movie.obw
$*,NUL,$(WIN_LIBS),wmovie.def
<<
	$(WIN_RC) $(WIN_RC_OPTS) wmovie.rc $*.exe

wmovie1.exe: movie1.obw p_movie1.obw
	$(WIN_LINK) $(WIN_LINK_OPTS) @<<zil.rsp
$(WIN_OBJS)+movie1.obw+p_movie1.obw
$*,NUL,$(WIN_LIBS),wmovie.def
<<
	$(WIN_RC) $(WIN_RC_OPTS) wmovie.rc $*.exe

wmovie2.exe: movie2.obw p_movie2.obw
	$(WIN_LINK) $(WIN_LINK_OPTS) @<<zil.rsp
$(WIN_OBJS)+movie2.obw+p_movie2.obw
$*,NUL,$(WIN_LIBS),wmovie.def
<<
	$(WIN_RC) $(WIN_RC_OPTS) wmovie.rc $*.exe

wmovie3.exe: movie3.obw p_movie3.obw
	$(WIN_LINK) $(WIN_LINK_OPTS) @<<zil.rsp
$(WIN_OBJS)+movie3.obw+p_movie3.obw
$*,NUL,$(WIN_LIBS),wmovie.def
<<
	$(WIN_RC) $(WIN_RC_OPTS) wmovie.rc $*.exe

wmovie4.exe: movie4.obw p_movie4.obw
	$(WIN_LINK) $(WIN_LINK_OPTS) @<<zil.rsp
$(WIN_OBJS)+movie4.obw+p_movie4.obw
$*,NUL,$(WIN_LIBS),wmovie.def
<<
	$(WIN_RC) $(WIN_RC_OPTS) wmovie.rc $*.exe

wmovie5.exe: movie5.obw p_movie5.obw
	$(WIN_LINK) $(WIN_LINK_OPTS) @<<zil.rsp
$(WIN_OBJS)+movie5.obw+p_movie5.obw
$*,NUL,$(WIN_LIBS),wmovie.def
<<
	$(WIN_RC) $(WIN_RC_OPTS) wmovie.rc $*.exe

wmovie6.exe: movie6.obw p_movie6.obw
	$(WIN_LINK) $(WIN_LINK_OPTS) @<<zil.rsp
$(WIN_OBJS)+movie6.obw+p_movie6.obw
$*,NUL,$(WIN_LIBS),wmovie.def
<<
	$(WIN_RC) $(WIN_RC_OPTS) wmovie.rc $*.exe

wmovie7.exe: movie7.obw p_movie7.obw
	$(WIN_LINK) $(WIN_LINK_OPTS) @<<zil.rsp
$(WIN_OBJS)+movie7.obw+p_movie7.obw
$*,NUL,$(WIN_LIBS),wmovie.def
<<
	$(WIN_RC) $(WIN_RC_OPTS) wmovie.rc $*.exe
