# ----- General Definitions -------------------------------------------------
VERSION=mvcpp150

.SUFFIXES : .cpp .o16 .obw

# ----- 16 bit Dos Extender compiler options --------------------------------
# for debug:    add -Zi to CPP_OPTS
#               and /CO to LINK_OPTS

DOS_CPP=cl
DOS_LINK=link
DOS_LIBRARIAN=lib

DOS_CPP_OPTS=-c -AL -BATCH -Gs -Os -nologo
DOS_LINK_OPTS=/NOI /NOE /NOD /BATCH /SEGMENTS:256 /STACK:5120 /EXE
DOS_LIB_OPTS=/NOI
DOS_OBJS=

# --- Use the next line for UI_GRAPHICS_DISPLAY ---
DOS_LIBS=dos_zil dos_gfx ms_lgfx llibce graphics oldnames
# --- Use the next line for UI_MSC_DISPLAY ---
#DOS_LIBS=dos_zil dos_msc llibce graphics oldnames

.cpp.obj:
	$(DOS_CPP) $(DOS_CPP_OPTS) $<

!IF !DEFINED(PHARLAP16) && !DEFINED(RATIONAL16)
# Note:  Set the following variable to PHARLAP16 for Pharlap or RATIONAL16
# for DOS16M. Default is PHARLAP16.
PHARLAP16=1
# Use one of the following command lines to override this setting.
#  nmake "PHARLAP16=" -fmvcpp150.mak dos16
#  nmake "RATIONAL16=" -fmvcpp150.mak dos16
!ENDIF

D16_CPP=cl
D16_LINK=link
D16_LIBRARIAN=lib

# ----Pharlap----
!IF DEFINED(PHARLAP16)
D16_CPP_OPTS=-c -AL -BATCH -Gs2 -DDOSX286 -D$(FONT) -nologo
D16_LINK_OPTS=/NOI /NOE /NOD /B /SE:256 /ST:12288 /ON:N
D16_LIB_OPTS=/NOI
D16_OBJS=graphp.obj
D16_BIND=bind286
PHARLAP_RTL=c:\phar286\rtk
D16_LOAD=run286a
# --- Use the next line for UI_GRAPHICS_DISPLAY ---
D16_LIBS=phapi d16_zil d16_gfx ms_16gfx llibcep graphics oldnames
# --- Use the next line for UI_MSC_DISPLAY ---
#D16_LIBS=phapi llibcep graphics d16_msc d16_zil oldnames
!ENDIF

# ---- DOS16M----
!IF DEFINED(RATIONAL16)
D16_CPP_OPTS=-c -AL -BATCH -Gs2 -DDOS16M -nologo
D16_LINK_OPTS=/NOI /NOE /BATCH /SE:256 /ON:N
D16_LIB_OPTS=/NOI /PAGESIZE:1024
D16_OBJS=crt0_16m.obj+crt0datn.obj+emoem.obj+qccore.obj+llvesa
D16_DEF_FILE=dos16m.def
# --- Use the next line for UI_GRAPHICS_DISPLAY ---
D16_LIBS=msc80lse msc80l msc80lg dos16 d16libc d16_zil d16_gfx ms_16gfx 
# --- Use the next line for UI_MSC_DISPLAY ---
#D16_LIBS=msc80lse msc80l msc80lg dos16 d16_zil d16_msc graphics
!ENDIF

.cpp.o16:
	$(D16_CPP) $(D16_CPP_OPTS) -Fo$*.o16 $<

# ----- Windows compiler options --------------------------------------------
# for debug:    add -Zi to CPP_OPTS
#               and /CO to LINK_OPTS
WIN_CPP=cl
WIN_LINK=link
WIN_LIBRARIAN=lib
WIN_RC=rc

WIN_CPP_OPTS=-c -AL -BATCH -Gsw -Os -nologo
WIN_RC_OPTS=-k
WIN_LINK_OPTS=/NOE /NOD /NOI /BATCH /SEGMENTS:256 /ON:N
WIN_LIB_OPTS=/NOI
WIN_OBJS=
WIN_LIBS=win_zil libw llibcew oldnames 

.cpp.obw:
	$(WIN_CPP) $(WIN_CPP_OPTS) -Fo$*.obw $<

# ----- Usage --------------------------------------------------------------
usage:
	@echo ...........
	@echo ...........
	@echo To generate the library modules for specific environments type:
	@echo nmake -fmvcpp150.mak dos16
	@echo nmake -fmvcpp150.mak windows
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean.bat

# ----- 16 bit DOS Extender Libraries and Programs --------------------------
# DOS - Library support only
dos : service.obj
	-@del service.lib
	$(DOS_LIBRARIAN) $(DOS_LIB_OPTS) @<<zil.rsp
service.lib &
+service.obj
NUL
<<
	copy service.hpp ..\..\include
	copy service.lib ..\..\lib\$(VERSION)
	copy p_servic.dat ..\..\bin\p_servic.znc

dos16: test.exe

!IF DEFINED(PHARLAP16)
test.exe: main.o16 servic16.lib
	$(D16_LINK) $(D16_LINK_OPTS) @<<zil.rsp
$(D16_OBJS)+main.o16
$*,NUL,servic16.lib $(D16_LIBS),NUL
<<
	$(D16_BIND) @<<zil.rsp
$(PHARLAP_RTL)\$(D16_LOAD)
$*
-dll $(PHARLAP_RTL)\moucalls $(PHARLAP_RTL)\int33 $(PHARLAP_RTL)\doscalls
<<
	@del zil.rsp
!ENDIF

!IF DEFINED(RATIONAL16)
test.exe: main.o16 servic16.lib
	$(D16_LINK) $(D16_LINK_OPTS) @<<zil.rsp
$(D16_OBJS)+main.o16
$*,NUL,servic16.lib $(D16_LIBS),$(D16_DEF_FILE)
<<
	@del zil.rsp
!ENDIF

servic16.lib : service.o16
	-@del servic16.lib
	$(D16_LIBRARIAN) $(D16_LIB_OPTS) @<<zil.rsp
$* &
+service.o16
NUL
<<
	copy service.hpp ..\..\include
	copy servic16.lib ..\..\lib\$(VERSION)
	copy p_servic.dat ..\..\bin\p_servic.znc

# ----- Windows Libraries and Programs --------------------------------------
windows: wtest.exe

wtest.exe: main.obw wservice.lib
	$(WIN_LINK) $(WIN_LINK_OPTS) @<<zil.rsp
$(WIN_OBJS)+main.obw
$*,NUL, wservice $(WIN_LIBS),wtest.def
<<
	$(WIN_RC) $(WIN_RC_OPTS) wtest.rc $*.exe

wservice.lib : service.obw
	-@del wservice.lib
	$(WIN_LIBRARIAN) $(WIN_LIB_OPTS) @<<zil.rsp
$* &
+service.obw
NUL
<<
	copy service.hpp ..\..\include
	copy wservice.lib ..\..\lib\$(VERSION)
	copy p_servic.dat ..\..\bin\p_servic.znc
