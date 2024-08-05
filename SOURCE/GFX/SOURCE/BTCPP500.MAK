# ----- General Definitions -------------------------------------------------
VERSION=btcpp500
TRANS=-DZIL_TRANS

# ----- DOS compiler options ------------------------------------------------
DOS_CPP=bcc
DOS_LIBRARIAN=tlib

DOS_CPP_OPTS=-c -ml -x- -RT- -Y -Z -DPM=0 $(TRANS)
DOS_LIB_OPTS=/C

.c.obj:
	$(DOS_CPP) $(DOS_CPP_OPTS) {$< }


# ----- Dos Extender ---------------------------------------------------------

!if !$d(PHARLAP16) && !$d(RATIONAL16) && !$d(POWERPACK16)
# Note:  Set the following variable to PHARLAP16 for Pharlap, RATIONAL16 for
# DOS16M, or POWERPACK16 for PowerPack DPMI.  Default is set to POWERPACK16.
POWERPACK16=1
# Use one of the following command lines to override this setting.
#  make -fbtcpp450.mak -DPHARLAP16 dos16
#  make -fbtcpp450.mak -DRATIONAL16 dos16
#  make -fbtcpp450.mak -DPOWERPACK16 dos16
!endif

!if $d(PHARLAP16)
D16_CPP=bcc286
D16_CPP_OPTS=-c -ml -x- -RT- -Z -DPM=16 -DDOSX16=1 $(TRANS)
!elif $d(RATIONAL16)
D16_CPP=bcc
D16_CPP_OPTS=-c -ml -x- -RT- -Z -DPM=16 -DDOS16M=1 $(TRANS)
!elif $d(POWERPACK16)
D16_CPP=bcc
D16_CPP_OPTS=-c -ml -WX -x- -RT- -Z -DPM=16 $(TRANS)
!endif

D16_LIB_OPTS=/C 
D16_LIBRARIAN=tlib

.c.o16:
	$(D16_CPP) $(D16_CPP_OPTS) -o$*.o16 {$< }

# ----- Usage --------------------------------------------------------------
usage:
	@echo ...........
	@echo ...........
	@echo To generate the GFX library for specific environments type:
	@echo make -fbtcpp450.mak dos
	@echo make -fbtcpp450.mak dos16
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean

# ----- DOS Libraries and Programs ------------------------------------------

dos: bc_lgfx.lib

bc_lgfx.lib : gfx.obj ..\asm\bcgfxasm.lib
	-@del bc_lgfx.lib
	$(DOS_LIBRARIAN) $(DOS_LIB_OPTS) @&&!
$* &
+gfx.obj+..\asm\bcgfxasm.lib
!
	-@md ..\..\..\lib\$(VERSION)
	copy bc_lgfx.lib ..\..\..\lib\$(VERSION)


# ----- DOS Extender Libraries and Programs -----------------------------------

dos16: bc_16gfx.lib


bc_16gfx.lib : gfx.o16 ..\asm\bcgfxasm.lib
	-@del bc_16gfx.lib
	$(D16_LIBRARIAN) $(D16_LIB_OPTS) @&&!
$* &
+gfx.o16+..\asm\bcgfxasm.lib
!
	-@md ..\..\..\lib\$(VERSION)
	copy bc_16gfx.lib ..\..\..\lib\$(VERSION)

