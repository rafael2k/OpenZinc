# ----- General Definitions -------------------------------------------------
VERSION=mvcpp600

.SUFFIXES : .c .cpp .o32 .obn .ob9

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

# ----- Windows NT compiler options -----------------------------------------
# for debug:    add /Zi to CPP_OPTS
#               add /DEBUG:MAPPED,FULL /DEBUGTYPE:CV to LINK_OPTS
WNT_CPP=cl
WNT_LINK=link
WNT_LIBRARIAN=lib

WNT_CPP_OPTS= -c -W3 -D_X86_=1 -DWIN32
WNT_LINK_OPTS=-align:0x1000 -subsystem:windows -entry:WinMainCRTStartup
WNT_CON_LINK_OPTS=-align:0x1000 -subsystem:console -entry:mainCRTStartup
WNT_LIB_OPTS=/machine:i386 /subsystem:WINDOWS

WNT_OBJS=
WNT_LIBS=libc.lib kernel32.lib user32.lib gdi32.lib comdlg32.lib winspool.lib wnt_zil.lib oldnames.lib ctl3d32.lib
WNT_CON_LIBS=libc.lib kernel32.lib wnt_zil.lib oldnames.lib

.cpp.obn:
	$(WNT_CPP) $(WNT_CPP_OPTS) -Fo$*.obn $<

# ----- 32 bit Windows compiler options -------------------------------------
# for debug:    add /Zi to CPP_OPTS
#               add /DEBUG:MAPPED,FULL /DEBUGTYPE:CV to LINK_OPTS
W32_CPP=cl
W32_LINK=link
W32_LIBRARIAN=lib

W32_CPP_OPTS= -c -W3 -D_X86_=1 -DWIN32 -DZIL_WIN32
W32_LINK_OPTS=-align:0x1000 -subsystem:windows -entry:WinMainCRTStartup
W32_LIB_OPTS=/machine:i386 /subsystem:WINDOWS

W32_OBJS=
W32_LIBS=libc.lib kernel32.lib user32.lib gdi32.lib comctl32.lib comdlg32.lib winspool.lib w32_zil.lib oldnames.lib ctl3d32.lib

.cpp.ob9:
	$(W32_CPP) $(W32_CPP_OPTS) -Fo$*.ob9 $<

# ----- Usage --------------------------------------------------------------
usage:
	@echo ...........
	@echo ...........
	@echo To generate the library modules for specific environments type:
	@echo nmake -f $(VERSION).mak dos32
	@echo nmake -f $(VERSION).mak winnt
	@echo nmake -f $(VERSION).mak win32
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean.bat
#	----- Level 1 Applications -----
	@cd service
	nmake -fmvcpp600.mak clean
	@cd ..
#	----- Level 2 Applications -----
	@cd storage
	nmake -fmvcpp600.mak clean
	@cd ..
	@cd direct
	nmake -fmvcpp600.mak clean
	@cd ..
	@cd stredit
	nmake -fmvcpp600.mak clean
	@cd ..
#	----- Level 3 Applications -----
	@cd help
	nmake -fmvcpp600.mak clean
	@cd ..
	@cd message
	nmake -fmvcpp600.mak clean
	@cd ..
	@cd image
	nmake -fmvcpp600.mak clean
	@cd ..
	@cd i18n
	nmake -fmvcpp600.mak clean
	@cd ..
	@cd file
	nmake -fmvcpp600.mak clean
	@cd ..
	@cd window
	nmake -fmvcpp600.mak clean
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
	nmake -f mvcpp600.mak servic32.lib
	@cd ..
#	----- Level 2 Applications -----
	@cd storage
	nmake -f mvcpp600.mak storag32.lib
	@cd ..
	@cd direct
	nmake -f mvcpp600.mak direct32.lib
	@cd ..
	@cd stredit
	nmake -f mvcpp600.mak stredi32.lib
	@cd ..
#	----- Level 3 Applications -----
	@cd help
	nmake -f mvcpp600.mak help32.lib
	@cd ..
	@cd message
	nmake -f mvcpp600.mak messag32.lib
	@cd ..
	@cd image
	nmake -f mvcpp600.mak image32.lib
	@cd ..
	@cd i18n
	nmake -f mvcpp600.mak i18n32.lib
	@cd ..
	@cd file
	nmake -f mvcpp600.mak file32.lib
	@cd ..
	@cd window
	nmake -f mvcpp600.mak window32.lib
	@cd ..

# ----- Windows NT Libraries and Programs -----------------------------------
winnt: ndesign.exe
	copy ndesign.exe ..\bin

ndesign.exe: make_winnt_modules main.obn
	$(WNT_LINK) $(WNT_LINK_OPTS) -out:ndesign.exe $(WNT_OBJS) main.obn ni18n.lib nwindow.lib nhelp.lib nmessage.lib nimage.lib nstorage.lib ndirect.lib nstredit.lib nservice.lib $(WNT_LIBS)

make_winnt_modules:
#	----- Level 1 Applications -----
	@cd service
	nmake -f $(VERSION).mak nservice.lib
	@cd ..
#	----- Level 2 Applications -----
	@cd storage
	nmake -f $(VERSION).mak nstorage.lib
	@cd ..
	@cd direct
	nmake -f $(VERSION).mak ndirect.lib
	@cd ..
	@cd stredit
	nmake -f $(VERSION).mak nstredit.lib
	@cd ..
#	----- Level 3 Applications -----
	@cd help
	nmake -f $(VERSION).mak nhelp.lib
	@cd ..
	@cd message
	nmake -f $(VERSION).mak nmessage.lib
	@cd ..
	@cd image
	nmake -f $(VERSION).mak nimage.lib
	@cd ..
	@cd i18n
	nmake -f $(VERSION).mak ni18n.lib
	@cd ..
	@cd file
	nmake -f $(VERSION).mak nfile.lib
	@cd ..
	@cd window
	nmake -f $(VERSION).mak nwindow.lib
	@cd ..

# ----- 32 bit Windows Libraries and Programs -------------------------------
win32: 9design.exe
	copy 9design.exe ..\bin

9design.exe: make_win32_modules main.ob9
	$(W32_LINK) $(W32_LINK_OPTS) -out:9design.exe $(W32_OBJS) main.ob9 9i18n.lib 9window.lib 9help.lib 9message.lib 9image.lib 9storage.lib 9direct.lib 9stredit.lib 9service.lib $(W32_LIBS)

make_win32_modules:
#	----- Level 1 Applications -----
	@cd service
	nmake -f $(VERSION).mak 9service.lib
	@cd ..
#	----- Level 2 Applications -----
	@cd storage
	nmake -f $(VERSION).mak 9storage.lib
	@cd ..
	@cd direct
	nmake -f $(VERSION).mak 9direct.lib
	@cd ..
	@cd stredit
	nmake -f $(VERSION).mak 9stredit.lib
	@cd ..
#	----- Level 3 Applications -----
	@cd help
	nmake -f $(VERSION).mak 9help.lib
	@cd ..
	@cd message
	nmake -f $(VERSION).mak 9message.lib
	@cd ..
	@cd image
	nmake -f $(VERSION).mak 9image.lib
	@cd ..
	@cd i18n
	nmake -f $(VERSION).mak 9i18n.lib
	@cd ..
	@cd file
	nmake -f $(VERSION).mak 9file.lib
	@cd ..
	@cd window
	nmake -f $(VERSION).mak 9window.lib
	@cd ..
