# ----- General Definitions -------------------------------------------------
VERSION=mvcpp150
TRANS=-DZIL_TRANS

# ----- DOS compiler options ------------------------------------------------
DOS_CPP=cl
DOS_LIBRARIAN=lib

DOS_CPP_OPTS=-c -AL -Oas -Gs $(TRANS)
DOS_LIB_OPTS=/NOI 

.c.obj:
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

D16_CPP=cl
D16_LIBRARIAN=lib

# ----Pharlap----
!IF DEFINED(PHARLAP16)
D16_CPP_OPTS=-c -AL -Lp -Oas -Gs -DPM=16 -DDOSX16=1 $(TRANS)
!ENDIF

!IF DEFINED(RATIONAL16)
# ---- DOS16M----
D16_CPP_OPTS=-c -AL -Oas -Gs -DPM=16 -DDOS16M=1 $(TRANS)
!ENDIF

D16_LIB_OPTS=/NOI

.c.o16:
	$(D16_CPP) $(D16_CPP_OPTS) -Fo$*.o16 $<

# ----- Usage --------------------------------------------------------------
usage:
	@echo ...........
	@echo ...........
	@echo To generate the GFX library for specific environments type:
	@echo nmake -fmvcpp150.mak dos
	@echo nmake -fmvcpp150.mak dos16
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean.bat

# ----- DOS Libraries -------------------------------------------------------
dos: ms_lgfx.lib

ms_lgfx.lib : gfx.obj ..\asm\msgfxasm.lib
	-@del ms_lgfx.lib
	$(DOS_LIBRARIAN) $(DOS_LIB_OPTS) @<<zil.rsp
$* &
+gfx.obj+..\asm\msgfxasm.lib
NUL
<<
	-@md ..\..\..\lib\$(VERSION)
	copy ms_lgfx.lib ..\..\..\lib\$(VERSION)


# ----- DOS Extender Libraries ----------------------------------------------
dos16: ms_16gfx.lib

ms_16gfx.lib : gfx.o16 ..\asm\msgfxasm.lib
	-@del ms_16gfx.lib
	$(D16_LIBRARIAN) $(D16_LIB_OPTS) @<<zil.rsp
$* &
+gfx.o16+..\asm\msgfxasm.lib
NUL
<<
	-@md ..\..\..\lib\$(VERSION)
	copy ms_16gfx.lib ..\..\..\lib\$(VERSION)
