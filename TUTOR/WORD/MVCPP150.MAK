# WORD tutorial makefile

#    nmake -fmvcpp150.mak dos          (makes all the DOS word tutorials)
#    nmake -fmvcpp150.mak dosovl       (makes all the DOS overlay word tutorials)
#    nmake -fmvcpp150.mak dos16        (makes all the DOS extender word tutorials)
#    nmake -fmvcpp150.mak windows      (makes all the Windows word tutorials)

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

.c.obj:
	$(DOS_CPP) $(DOS_CPP_OPTS) $<
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
dos: word2.exe word3.exe

word2.exe: word2.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) @<<zil.rsp
$(DOS_OBJS)+word2.obj
$*,NUL,$(DOS_LIBS),NUL
<<

word3.exe: word3.obj word_win.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) @<<zil.rsp
$(DOS_OBJS)+word3.obj+word_win.obj
$*,NUL,$(DOS_LIBS),NUL
<<

# ----- DOS Overlay ---------------------------------------------------------
dosovl: word2v.exe word3v.exe

word2v.exe: word2.obj
	$(DOS_LINK) $(DOS_OVL_LINK_OPTS) @<<zil.rsp
$(DOS_OBJS)+word2.obj
$*,NUL,$(DOS_LIBS),mvc_ovl.def
<<

word3v.exe: word3.obj word_win.obj
	$(DOS_LINK) $(DOS_OVL_LINK_OPTS) @<<zil.rsp
$(DOS_OBJS)+word3.obj+word_win.obj
$*,NUL,$(DOS_LIBS),mvc_ovl.def
<<

# ----- DOS Extender ---------------------------------------------------------
dos16: word216.exe word316.exe

word216.exe: word2.o16
	$(D16_LINK) $(D16_LINK_OPTS) @<<zil.rsp
$(D16_OBJS)+word2.o16
$*,NUL,$(D16_LIBS),$(D16_DEF_FILE)
<<

word316.exe: word3.o16 word_win.o16
	$(D16_LINK) $(D16_LINK_OPTS) @<<zil.rsp
$(D16_OBJS)+word3.o16+word_win.o16
$*,NUL,$(D16_LIBS),$(D16_DEF_FILE)
<<

# ----- Windows -------------------------------------------------------------
windows: wword2.exe wword3.exe

wword2.exe: word2.obw
	$(WIN_LINK) $(WIN_LINK_OPTS) @<<zil.rsp
$(WIN_OBJS)+word2.obw
$*,NUL,$(WIN_LIBS),wword.def
<<
	$(WIN_RC) $(WIN_RC_OPTS) wword.rc $*.exe

wword3.exe: word3.obw word_win.obw
	$(WIN_LINK) $(WIN_LINK_OPTS) @<<zil.rsp
$(WIN_OBJS)+word3.obw+word_win.obw
$*,NUL,$(WIN_LIBS),wword.def
<<
	$(WIN_RC) $(WIN_RC_OPTS) wword.rc $*.exe


