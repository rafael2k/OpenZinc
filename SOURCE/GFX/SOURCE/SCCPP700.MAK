# ----- General Definitions -------------------------------------------------
VERSION=sccpp700
TRANS=-DZIL_TRANS

# ----- DOS compiler options ------------------------------------------------
DOS_CPP=sc
DOS_LIBRARIAN=lib
DOS_CPP_OPTS=-c -a1 -bx -o+space -ml -p -DPM=0 $(TRANS) -R
DOS_LIB_OPTS=/C /N /B /NOI

.c.obj:
	$(DOS_CPP) $(DOS_CPP_OPTS) $<

# ----- DOS Overlay (VCM) compiler options ----------------------------------
OVL_CPP=sc
OVL_LIBRARIAN=lib
OVL_CPP_OPTS=-c -a1 -bx -mv -R -p -DPM=0 $(TRANS) -R
OVL_LIB_OPTS=/C /N /B /NOI

.c.ovl:
	$(OVL_CPP) $(OVL_CPP_OPTS) -o$@ $<

# ----- DOS extender compiler options ---------------------------------------
D32_CPP=sc
D32_LIBRARIAN=lib
D32_CPP_OPTS=-c -bx -mx -p -w7 -DDOSX16=4 -DPM=32 $(TRANS) -R
D32_LIB_OPTS=/C /N /B /NOI

.c.o32:
	$(D32_CPP) $(D32_CPP_OPTS) -o$@ $<

# ----- Usage ---------------------------------------------------------------
usage:
	@echo ...........
	@echo ...........
	@echo To generate the GFX library for specific environments type:
	@echo smake -fsccpp700.mak dos
	@echo smake -fsccpp700.mak dosovl
	@echo smake -fsccpp700.mak dos32
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean.bat

# ----- DOS Libraries -------------------------------------------------------

dos: sc_lgfx.lib

sc_lgfx.lib : gfx.obj ..\asm\sygfxasm.lib
	-@del sc_lgfx.lib
	$(DOS_LIBRARIAN) $@ $(DOS_LIB_OPTS) +gfx.obj+..\asm\sygfxasm.lib, NUL;
	-@md ..\..\..\lib\$(VERSION)
	copy sc_lgfx.lib ..\..\..\lib\$(VERSION)

# ----- DOS Overlay (VCM) Libraries -----------------------------------------
dosovl: sc_lgfxv.lib

sc_lgfxv.lib : gfx.ovl ..\asm\sygfxasm.lib
	-@del sc_lgfxo.lib
	$(DOS_LIBRARIAN) $@ $(DOS_LIB_OPTS) +gfx.ovl+..\asm\sygfxasm.lib, NUL;
	-@md ..\..\..\lib\$(VERSION)
	copy sc_lgfxv.lib ..\..\..\lib\$(VERSION)

# ----- Dos extender Libraries ----------------------------------------------
dos32: sc_32gfx.lib

sc_32gfx.lib : gfx.o32 ..\asm\sygfxa32.lib
	-@del sc_32gfx.lib
	$(DOS_LIBRARIAN) $@ $(DOS_LIB_OPTS) +gfx.o32+..\asm\sygfxa32.lib, NUL;
	-@md ..\..\..\lib\$(VERSION)
	copy sc_32gfx.lib ..\..\..\lib\$(VERSION)

