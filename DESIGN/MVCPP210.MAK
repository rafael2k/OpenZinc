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
D32_LIBS=dosx32.lib dos32.lib errno.lib d32_zil.lib d32_gfx.lib ms_32gfx.lib oldnames.lib
# --- Use the next line for UI_MSC_DISPLAY ---
#D32_LIBS=dosx32.lib dos32.lib tntapi.lib errno.lib d32_zil.lib d32_msc.lib oldnames.lib

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
#	----- Level 1 Applications -----
	@cd service
	nmake -fmvcpp210.mak clean
	@cd ..
#	----- Level 2 Applications -----
	@cd storage
	nmake -fmvcpp210.mak clean
	@cd ..
	@cd direct
	nmake -fmvcpp210.mak clean
	@cd ..
	@cd stredit
	nmake -fmvcpp210.mak clean
	@cd ..
#	----- Level 3 Applications -----
	@cd help
	nmake -fmvcpp210.mak clean
	@cd ..
	@cd message
	nmake -fmvcpp210.mak clean
	@cd ..
	@cd image
	nmake -fmvcpp210.mak clean
	@cd ..
	@cd i18n
	nmake -fmvcpp210.mak clean
	@cd ..
	@cd file
	nmake -fmvcpp210.mak clean
	@cd ..
	@cd window
	nmake -fmvcpp210.mak clean
	@cd ..

# ----- 32 bit DOS Extender Libraries and Programs --------------------------
dos32: design.exe
	copy design.exe ..\bin

design.exe: d32_libs main.o32 
	$(D32_LINK) @msvc32.lnk $(D32_LINK_OPTS) -out:design.exe $(D32_OBJS) main.o32 servic32.lib storag32.lib direct32.lib stredi32.lib help32.lib messag32.lib image32.lib i18n32.lib file32.lib window32.lib $(D32_LIBS)
   markphar -dosstyle design

d32_libs:
#	----- Level 1 Applications -----
	@cd service
	nmake -f mvcpp210.mak servic32.lib
	@cd ..
#	----- Level 2 Applications -----
	@cd storage
	nmake -f mvcpp210.mak storag32.lib
	@cd ..
	@cd direct
	nmake -f mvcpp210.mak direct32.lib
	@cd ..
	@cd stredit
	nmake -f mvcpp210.mak stredi32.lib
	@cd ..
#	----- Level 3 Applications -----
	@cd help
	nmake -f mvcpp210.mak help32.lib
	@cd ..
	@cd message
	nmake -f mvcpp210.mak messag32.lib
	@cd ..
	@cd image
	nmake -f mvcpp210.mak image32.lib
	@cd ..
	@cd i18n
	nmake -f mvcpp210.mak i18n32.lib
	@cd ..
	@cd file
	nmake -f mvcpp210.mak file32.lib
	@cd ..
	@cd window
	nmake -f mvcpp210.mak window32.lib
	@cd ..

