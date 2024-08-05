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
dos32: msgedt32.exe
	copy msgedt32.exe ..\..\bin

msgedt32.exe: main.o32 messag32.lib
	$(D32_LINK) @msvc32.lnk $(D32_LINK_OPTS) -out:i18edt32.exe $(D32_OBJS) main.o32 messag32.lib storag32.lib direct32.lib stredi32.lib servic32.lib $(D32_LIBS)

messag32.lib : message.o32 message1.o32 prefer.o32 \
	import.o32 export.o32
	-@del messag32.lib
	$(D32_LIBRARIAN) $(D32_LIB_OPTS) @<<zil.rsp
/out:$*.lib
 message.o32 message1.o32 prefer.o32
 import.o32 export.o32
<<
	copy message.hpp ..\..\include
	copy messag32.lib ..\..\lib\$(VERSION)
	copy p_messag.dat ..\..\bin\p_messag.znc


