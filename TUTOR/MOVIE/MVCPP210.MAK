# MOVIE tutorial makefile

#    nmake -fmvcpp210.mak dos32        (makes all the DOS TNT extender movie tutorials)

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
dos32: movie32.exe movie132.exe movie232.exe movie332.exe movie432.exe movie532.exe movie632.exe movie732.exe

movie32.exe: movie.o32 p_movie.o32
	$(D32_LINK) @msvc32.lnk $(D32_LINK_OPTS) -out:movie32.exe $(D32_OBJS) movie.o32 p_movie.o32 $(D32_LIBS)

movie132.exe: movie1.o32 p_movie1.o32
	$(D32_LINK) @msvc32.lnk $(D32_LINK_OPTS) -out:movie132.exe $(D32_OBJS) movie1.o32 p_movie1.o32 $(D32_LIBS)

movie232.exe: movie2.o32 p_movie2.o32
	$(D32_LINK) @msvc32.lnk $(D32_LINK_OPTS) -out:movie232.exe $(D32_OBJS) movie2.o32 p_movie2.o32 $(D32_LIBS)

movie332.exe: movie3.o32 p_movie3.o32
	$(D32_LINK) @msvc32.lnk $(D32_LINK_OPTS) -out:movie332.exe $(D32_OBJS) movie3.o32 p_movie3.o32 $(D32_LIBS)

movie432.exe: movie4.o32 p_movie4.o32
	$(D32_LINK) @msvc32.lnk $(D32_LINK_OPTS) -out:movie432.exe $(D32_OBJS) movie4.o32 p_movie4.o32 $(D32_LIBS)

movie532.exe: movie5.o32 p_movie5.o32
	$(D32_LINK) @msvc32.lnk $(D32_LINK_OPTS) -out:movie532.exe $(D32_OBJS) movie5.o32 p_movie5.o32 $(D32_LIBS)

movie632.exe: movie6.o32 p_movie6.o32
	$(D32_LINK) @msvc32.lnk $(D32_LINK_OPTS) -out:movie632.exe $(D32_OBJS) movie6.o32 p_movie6.o32 $(D32_LIBS)

movie732.exe: movie7.o32 p_movie7.o32
	$(D32_LINK) @msvc32.lnk $(D32_LINK_OPTS) -out:movie732.exe $(D32_OBJS) movie7.o32 p_movie7.o32 $(D32_LIBS)


