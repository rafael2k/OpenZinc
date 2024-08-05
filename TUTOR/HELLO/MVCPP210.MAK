# HELLO tutorial makefile

#    nmake -fmvcpp210.mak dos32        (makes the DOS TNT extender hello tutorials)

# Be sure to set the LIB and INCLUDE environment variables for Zinc, e.g.:
#    set INCLUDE=.;C:\ZINC\INCLUDE;C:\MSVC\INCLUDE
#    set LIB=.;C:\ZINC\LIB\MVCPP210;C:\MSVC\LIB

# ----- DOS TNT Extender options --------------------------------------------
# for debug:    add -Zi to CPP_OPTS
#               and -CV to LINK_OPTS
D32_CPP=cl
D32_LINK=link
D32_CPP_OPTS=-c -DDOS386 -nologo
D32_LINK_OPTS=
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
	@echo To make this Zinc tutorial for Visual C++ type:
	@echo nmake -fmvcpp210.mak dos32
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean

# ----- DOS 32 bit TNT Extender ---------------------------------------------
dos32: hello132.exe hello232.exe hello332.exe hellog32.exe

hello132.exe: hello1.o32
	$(D32_LINK) @msvc32.lnk $(D32_LINK_OPTS) -out:hello132.exe $(D32_OBJS) hello1.o32 $(D32_LIBS)

hello232.exe: hello2.o32
	$(D32_LINK) @msvc32.lnk $(D32_LINK_OPTS) -out:hello232.exe $(D32_OBJS) hello2.o32 $(D32_LIBS)

hello332.exe: hello3.o32 hello.o32
	$(D32_LINK) @msvc32.lnk $(D32_LINK_OPTS) -out:hello332.exe $(D32_OBJS) hello3.o32 hello.o32 $(D32_LIBS)

hellog32.exe: hellog.o32
	$(D32_LINK) @msvc32.lnk $(D32_LINK_OPTS) -out:hellog32.exe $(D32_OBJS) hellog.o32 $(D32_LIBS)

