PROG = main
PROG_OBN = 
PROG_OB9 = 

#    nmake -f mvcpp400.mak dos32
#    nmake -f mvcpp400.mak winnt
#    nmake -f mvcpp400.mak win32

# Be sure to set the LIB and INCLUDE environment variables for Zinc, e.g.:
#    set INCLUDE=.;C:\ZINC\INCLUDE;C:\MSVC\INCLUDE
#    set LIB=.;C:\ZINC\LIB\MVCPP100;C:\MSVC\LIB

.SUFFIXES : .c .cpp .o32 .obn

# ----- Windows NT compiler options -----------------------------------------
# for debug:    add /Zi to CPP_OPTS
#               add /DEBUG:MAPPED,FULL /DEBUGTYPE:CV to LINK_OPTS
WNT_CPP=cl
WNT_LINK=link
WNT_LIBRARIAN=lib
WNT_RC=rc

WNT_CPP_OPTS= -c -W3 -D_X86_=1 -DWIN32
WNT_LINK_OPTS=-align:0x1000 -subsystem:windows -entry:WinMainCRTStartup
WNT_RC_OPTS=/r
WNT_CON_LINK_OPTS=-align:0x1000 -subsystem:console -entry:mainCRTStartup
WNT_LIB_OPTS=/machine:i386 /subsystem:WINDOWS

WNT_OBJS=
WNT_LIBS=libc.lib kernel32.lib user32.lib gdi32.lib comdlg32.lib winspool.lib wnt_zil.lib oldnames.lib ctl3d32.lib

.cpp.obn:
	$(WNT_CPP) $(WNT_CPP_OPTS) -Fo$*.obn $<

.rc.rbj:
	$(WNT_RC) $(WNT_RC_OPTS) -fo$*.rbj $<

# ----- Windows 32 bit compiler options -------------------------------------
# for debug:    add /Zi to CPP_OPTS
#               add /DEBUG:MAPPED,FULL /DEBUGTYPE:CV to LINK_OPTS
W32_CPP=cl
W32_LINK=link
W32_LIBRARIAN=lib
W32_RC=rc

W32_CPP_OPTS= -c -W3 -D_X86_=1 -DWIN32 -DZIL_WIN32
W32_LINK_OPTS=-align:0x1000 -subsystem:windows -entry:WinMainCRTStartup
W32_LIB_OPTS=/machine:i386 /subsystem:WINDOWS
W32_RC_OPTS=/r

W32_OBJS=
W32_LIBS=libc.lib kernel32.lib user32.lib gdi32.lib comctl32.lib comdlg32.lib winspool.lib w32_zil.lib oldnames.lib ctl3d32.lib

.cpp.ob9:
	$(W32_CPP) $(W32_CPP_OPTS) -Fo$*.ob9 $<

.rc.rbj:
	$(W32_RC) $(W32_RC_OPTS) -fo$*.rbj $<

# ----- Usage --------------------------------------------------------------
usage:
	@echo ...........
	@echo ...........
	@echo To make this Zinc example for Visual C++ type:
	@echo nmake -f mvcpp400.mak winnt
	@echo nmake -f mvcpp400.mak win32
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean

# ----- Windows NT ----------------------------------------------------------
winnt: n$(PROG).exe

n$(PROG).exe: $(PROG).obn $(PROG_OBN) windows.rbj
	$(WNT_LINK) $(WNT_LINK_OPTS) -out:n$(PROG).exe $(WNT_OBJS) $(PROG).obn $(PROG_OBN) $(WNT_LIBS) windows.rbj

# ----- Windows 32 ----------------------------------------------------------
win32: 9$(PROG).exe

9$(PROG).exe: $(PROG).ob9 $(PROG_OB9) windows.rbj
	$(W32_LINK) $(W32_LINK_OPTS) -out:9$(PROG).exe $(W32_OBJS) $(PROG).ob9 $(PROG_OB9) $(W32_LIBS) windows.rbj
