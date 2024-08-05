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
dos16: i18edit.exe
	copy i18edit.exe ..\..\bin

!IF DEFINED(PHARLAP16)
i18edit.exe: main.o16 i18n16.lib
	$(D16_LINK) $(D16_LINK_OPTS) @<<zil.rsp
$(D16_OBJS)+main.o16
$*,NUL, i18n16.lib storag16.lib direct16.lib stredi16.lib servic16.lib $(D16_LIBS),NUL
<<
	$(D16_BIND) @<<zil.rsp
$(PHARLAP_RTL)\$(D16_LOAD)
$*
-dll $(PHARLAP_RTL)\moucalls $(PHARLAP_RTL)\int33 $(PHARLAP_RTL)\doscalls
<<
	@del zil.rsp
!ENDIF

!IF DEFINED(RATIONAL16)
i18edit.exe: main.o16 i18n16.lib
	$(D16_LINK) $(D16_LINK_OPTS) @<<zil.rsp
$(D16_OBJS)+main.o16
$*,NUL, i18n16.lib storag16.lib direct16.lib stredi16.lib servic16.lib $(D16_LIBS),$(D16_DEF_FILE)
<<
!ENDIF

i18n16.lib : i18n.o16 language.o16 locale.o16 \
	export.o16 import.o16 \
	z_bnum.o16 z_curr.o16 z_date.o16 z_date1.o16 z_day.o16 z_error.o16 \
	z_help.o16 z_int.o16 z_month.o16 z_msg.o16 z_num.o16 z_real.o16 \
	z_sys.o16 z_time.o16 z_time1.o16 z_time2.o16 z_win.o16
	-@del i18n16.lib
	$(D16_LIBRARIAN) $(D16_LIB_OPTS) @<<zil.rsp
$* &
+i18n.o16+language.o16+locale.o16 &
+export.o16+import.o16 &
+z_bnum.o16+z_curr.o16+z_date.o16+z_date1.o16+z_day.o16+z_error.o16 &
+z_help.o16+z_int.o16+z_month.o16+z_msg.o16+z_num.o16+z_real.o16 &
+z_sys.o16+z_time.o16+z_time1.o16+z_time2.o16+z_win.o16
NUL
<<
	copy i18n.hpp ..\..\include
	copy i18n16.lib ..\..\lib\$(VERSION)
	copy p_i18n.dat ..\..\bin\p_i18n.znc

# ----- Windows Libraries and Programs --------------------------------------
windows: wi18edit.exe
	copy wi18edit.exe ..\..\bin

wi18edit.exe: main.obw wi18n.lib
	$(WIN_LINK) $(WIN_LINK_OPTS) @<<zil.rsp
$(WIN_OBJS)+main.obw
$*,NUL, wi18n.lib storage.lib direct.lib stredit.lib service.lib $(WIN_LIBS),NUL
<<
	$(WIN_RC) $(WIN_RC_OPTS) wi18edit.rc $*.exe

wi18n.lib : i18n.obw language.obw locale.obw \
	export.obw import.obw \
	z_bnum.obw z_curr.obw z_date.obw z_date1.obw z_day.obw z_error.obw \
	z_help.obw z_int.obw z_month.obw z_msg.obw z_num.obw z_real.obw \
	z_sys.obw  z_time.obw z_time1.obw z_time2.obw z_win.obw
	-@del wi18n.lib
	$(WIN_LIBRARIAN) $(WIN_LIB_OPTS) @<<zil.rsp
$* &
+i18n.obw+language.obw+locale.obw &
+export.obw+import.obw &
+z_bnum.obw+z_curr.obw+z_date.obw+z_date1.obw+z_day.obw+z_error.obw &
+z_help.obw+z_int.obw+z_month.obw+z_msg.obw+z_num.obw+z_real.obw &
+z_sys.obw+z_time.obw+z_time1.obw+z_time2.obw+z_win.obw
NUL
<<
	copy i18n.hpp ..\..\include
	copy wi18n.lib ..\..\lib\$(VERSION)
	copy p_i18n.dat ..\..\bin\p_i18n.znc
