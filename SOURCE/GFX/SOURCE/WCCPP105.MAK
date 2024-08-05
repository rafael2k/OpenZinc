# ----- General Definitions -------------------------------------------------
VERSION=wccpp105
TRANS=/DZIL_TRANS

.EXTENSIONS:
.EXTENSIONS: .exe .o32 .c .cpp

# ----- DOS compiler options ------------------------------------------------
D32_CPP=wcc386
D32_LINK=wlink
D32_LIBRARIAN=wlib

D32_CPP_OPTS=/bt=dos /3r /s /DDOSX16=2 /DPM=32 $(TRANS)
D32_LINK_OPTS=SYSTEM dos4g OP stack=20000
D32_LIB_OPTS=-p=32 -n

.c.o32:
	$(D32_CPP) $(D32_CPP_OPTS) -fo=$[*.o32 $<

# ----- Usage ---------------------------------------------------------------
usage: .SYMBOLIC
	@echo ...........
	@echo ...........
	@echo To generate the GFX library for specific environments type:
	@echo wmake -f wccpp.mak dos32
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean: .SYMBOLIC
	z_clean.bat

# ----- D32 Libraries -------------------------------------------------------

dos32: wc_32gfx.lib .SYMBOLIC

wc_32gfx.lib : gfx.o32 ..\asm\wcgfxa32.lib
	-@del wc_lgfx.lib
	$(D32_LIBRARIAN) $(D32_LIB_OPTS) $@ +gfx.o32+..\asm\wcgfxa32.lib
	-@md ..\..\..\lib\$(VERSION)
	copy wc_32gfx.lib ..\..\..\lib\$(VERSION)
