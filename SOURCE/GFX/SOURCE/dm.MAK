# ----- General Definitions -------------------------------------------------
VERSION=dm84
TRANS=-DZIL_TRANS

# ----- DOS compiler options ------------------------------------------------
DOS_CPP=dmc
DOS_LIBRARIAN=lib
DOS_CPP_OPTS=-c -a1 -o+space -ml -p -DPM=0 $(TRANS) -R
DOS_LIB_OPTS=/C /N /B /NOI

.c.obj:
	$(DOS_CPP) $(DOS_CPP_OPTS) $<

# ----- DOS Overlay (VCM) compiler options ----------------------------------
OVL_CPP=dmc
OVL_LIBRARIAN=lib
OVL_CPP_OPTS=-c -a1 -mv -R -p -DPM=0 $(TRANS) -R
OVL_LIB_OPTS=/C /N /B /NOI

.c.ovl:
	$(OVL_CPP) $(OVL_CPP_OPTS) -o$@ $<

# ----- DOS extender compiler options ---------------------------------------
D32_CPP=dmc
D32_LIBRARIAN=lib
D32_CPP_OPTS=-c -mx -p -w7 -DDOSX16=4 -DPM=32 $(TRANS) -R
D32_LIB_OPTS=/C /N /B /NOI

.c.o32:
	$(D32_CPP) $(D32_CPP_OPTS) -o$@ $<

# ----- Usage ---------------------------------------------------------------
usage:
	@echo ...........
	@echo ...........
	@echo To generate the GFX library for specific environments type:
	@echo smake -fdm.mak dos
	@echo smake -fdm.mak dosovl
	@echo smake -fdm.mak dos32
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean.bat

# ----- DOS Libraries -------------------------------------------------------

dos: dm_lgfx.lib

dm_lgfx.lib : gfx.obj ..\asm\sygfxasm.lib
	-@del dm_lgfx.lib
	$(DOS_LIBRARIAN) $@ $(DOS_LIB_OPTS) +gfx.obj+..\asm\sygfxasm.lib, NUL;
	-@md ..\..\..\lib\$(VERSION)
	copy dm_lgfx.lib ..\..\..\lib\$(VERSION)

# ----- DOS Overlay (VCM) Libraries -----------------------------------------
dosovl: dm_lgfxv.lib

dm_lgfxv.lib : gfx.ovl ..\asm\sygfxasm.lib
	-@del dm_lgfxo.lib
	$(DOS_LIBRARIAN) $@ $(DOS_LIB_OPTS) +gfx.ovl+..\asm\sygfxasm.lib, NUL;
	-@md ..\..\..\lib\$(VERSION)
	copy dm_lgfxv.lib ..\..\..\lib\$(VERSION)

# ----- Dos extender Libraries ----------------------------------------------
dos32: dm_32gfx.lib

dm_32gfx.lib : gfx.o32 ..\asm\sygfxa32.lib
	-@del dm_32gfx.lib
	$(DOS_LIBRARIAN) $@ $(DOS_LIB_OPTS) +gfx.o32+..\asm\sygfxa32.lib, NUL;
	-@md ..\..\..\lib\$(VERSION)
	copy dm_32gfx.lib ..\..\..\lib\$(VERSION)

