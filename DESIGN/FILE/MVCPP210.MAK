# ----- General Definitions -------------------------------------------------
VERSION=mvcpp210

.SUFFIXES : .c .cpp .obj .o16 .o32 .obw .obn

# ----- DOS TNT Extender options --------------------------------------------
# for debug:    add -Zi to CPP_OPTS
#               and -CV to LINK_OPTS
D32_CPP=cl
D32_LINK=link
D32_LIBRARIAN=lib
D32_CPP_OPTS=-c -DDOS386 -nologo
D32_LINK_OPTS=
D32_LIB_OPTS=
D32_OBJS=

# --- Use the next line for UI_GRAPHICS_DISPLAY ---
D32_LIBS=dosx32.lib dos32.lib d32_zil.lib d32_gfx.lib ms_32gfx.lib oldnames.lib
# --- Use the next line for UI_MSC_DISPLAY ---
#D32_LIBS=dosx32.lib dos32.lib tntapi.lib d32_zil.lib d32_msc.lib oldnames.lib

.cpp.o32:
	$(D32_CPP) $(D32_CPP_OPTS) -Fo$*.o32 $<

# ----- Usage --------------------------------------------------------------
usage:
	@echo ...........
	@echo ...........
	@echo To generate the library modules for specific environments type:
	@echo nmake -fmvcpp210.mak dos32
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean.bat

# ----- 32 bit DOS Extender Libraries and Programs --------------------------
dos32: file32.exe
	copy file32.exe ..\..\bin

file32.exe: main.o32 file32.lib
	$(D32_LINK) $(D32_LINK_OPTS) -out:file32.exe $(D32_OBJS) main.o32 storag32.lib stredi32.lib file32.lib direct32.lib servic32.lib $(D32_LIBS)

file32.lib : file.o32
	-@del file32.lib
	$(D32_LIBRARIAN) $(D32_LIB_OPTS) @<<zil.rsp
/out:$*.lib
file.o32
<<
	copy file.hpp ..\..\include
	copy file32.lib ..\..\lib\$(VERSION)
	copy p_file.dat ..\..\bin\p_file.znc
