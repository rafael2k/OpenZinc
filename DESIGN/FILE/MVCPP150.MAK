# ----- General Definitions -------------------------------------------------
VERSION=mvcpp150

.SUFFIXES : .cpp .o16 .obw

# ----- 16 bit Dos Extender compiler options --------------------------------
# for debug:    add -Zi to CPP_OPTS
#               and /CO to LINK_OPTS

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
D16_LINK_OPTS=/NOI /NOE /BATCH /SE:256 /ST:12288 /ON:N
D16_LIB_OPTS=/NOI /PAGESIZE:1024
D16_OBJS=crt0_16m.obj+crt0datn.obj+emoem.obj+qccore.obj+llvesa
D16_DEF_FILE=dos16m.def
# --- Use the next line for UI_GRAPHICS_DISPLAY ---
D16_LIBS=msc80lse msc80l msc80lg d16_zil d16_gfx ms_16gfx dos16 d16libc
# --- Use the next line for UI_MSC_DISPLAY ---
#D16_LIBS=msc80lse msc80l msc80lg d16_zil d16_msc graphics dos16 d16libc
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
dos16: file.exe
	copy file.exe ..\..\bin

!IF DEFINED(PHARLAP16)
file.exe: main.o16 file16.lib
	$(D16_LINK) $(D16_LINK_OPTS) @<<zil.rsp
$(D16_OBJS)+main.o16
$*,NUL,storag16.lib stredi16.lib file16.lib direct16.lib servic16.lib $(D16_LIBS),NUL
<<
	$(D16_BIND) @<<zil.rsp
$(PHARLAP_RTL)\$(D16_LOAD)
$*
-dll $(PHARLAP_RTL)\moucalls $(PHARLAP_RTL)\int33 $(PHARLAP_RTL)\doscalls
<<
	@del zil.rsp
!ENDIF

!IF DEFINED(RATIONAL16)
file.exe: main.o16 file16.lib
	$(D16_LINK) $(D16_LINK_OPTS) @<<zil.rsp
$(D16_OBJS)+main.o16
$*,NUL,storag16.lib stredi16.lib file16.lib direct16.lib servic16.lib $(D16_LIBS),$(D16_DEF_FILE)
<<
	@del zil.rsp
!ENDIF

file16.lib : file.o16
	-@del file16.lib
	$(D16_LIBRARIAN) $(D16_LIB_OPTS) @<<zil.rsp
$* &
+file.o16
NUL
<<
	copy file.hpp ..\..\include
	copy file16.lib ..\..\lib\$(VERSION)
	copy p_file.dat ..\..\bin\p_file.znc

# ----- Windows Libraries and Programs --------------------------------------
windows: wfile.exe
	copy wfile.exe ..\..\bin

wfile.exe: main.obw wfile.lib
	$(WIN_LINK) $(WIN_LINK_OPTS) @<<zil.rsp
$(WIN_OBJS)+main.obw
$*, , wstorage wstredit wfile wdirect wservice $(WIN_LIBS), wfile.def
<<
	$(WIN_RC) $(WIN_RC_OPTS) wfile.rc $*.exe

wfile.lib : file.obw
	-@del wfile.lib
	$(WIN_LIBRARIAN) $(WIN_LIB_OPTS) @<<
$* &
+file.obw
NUL
<<
	copy file.hpp ..\..\include
	copy wfile.lib ..\..\lib\$(VERSION)
	copy p_file.dat ..\..\bin\p_file.znc

# ----- Windows NT Libraries and Programs -----------------------------------
winnt: nfile.exe
	copy nfile.exe ..\..\bin

nfile.exe: main.obn nfile.lib
	$(WNT_LINK) $(WNT_LINK_OPTS) -out:nfile.exe $(WNT_OBJS) main.obn nstorage nstredit nfile.lib ndirect.lib nservice.lib $(WNT_LIBS)


nfile.lib : file.obn
	-@del nfile.lib
	$(WNT_LIBRARIAN) /out:nfile.lib $(WNT_LIB_OPTS) @<<zil.rsp
file.obn
<<
	copy file.hpp ..\..\include
	copy nfile.lib ..\..\lib\$(VERSION)
	copy p_file.dat ..\..\bin\p_file.znc
