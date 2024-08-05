# ----- General Definitions -------------------------------------------------
VERSION=mvcpp210
TRANS=-DZIL_TRANS

# ----- Dos Extender ---------------------------------------------------------
D32_CPP=cl
D32_LIBRARIAN=lib
D32_CPP_OPTS=-c -Oas -Gs -DPM=32 $(TRANS)
D32_LIB_OPTS=

.c.o32:
        $(D32_CPP) $(D32_CPP_OPTS) -Fo$*.o32 $<

# ----- Usage --------------------------------------------------------------
usage:
	@echo ...........
	@echo ...........
	@echo To generate the GFX library for specific environments type:
	@echo nmake -fmvcpp210.mak dos32
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean.bat

# ----- DOS Extender 32 Libraries -------------------------------------------
dos32: ms_32gfx.lib

ms_32gfx.lib : gfx.o32 ..\asm\msgfxa32.lib
        -@del ms_32gfx.lib
        $(D32_LIBRARIAN) $(D32_LIB_OPTS) @<<zil.rsp
/out:$*.lib gfx.o32 ..\asm\msgfxa32.lib
<<
        -@md ..\..\..\lib\$(VERSION)
        copy ms_32gfx.lib ..\..\..\lib\$(VERSION)
