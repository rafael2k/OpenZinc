# ----- General Definitions -------------------------------------------------
VERSION=mvcpp150

.SUFFIXES : .cpp .obj .o16 .obw

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

# for debug:    add -Zi to CPP_OPTS
#               and /CO to LINK_OPTS
D16_CPP=cl
D16_LINK=link

# ----Pharlap----
!IF DEFINED(PHARLAP16)
D16_CPP_OPTS=-c -AL -BATCH -Gs2 -DDOSX286 -D$(FONT) -nologo
D16_LINK_OPTS=/NOI /NOE /NOD /B /SE:325 /ST:12288 /ON:N
D16_OBJS=graphp.obj
D16_DEF_FILE=m16.def
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
D16_LINK_OPTS=/NOI /NOE /BATCH /SE:325 /ON:N
D16_OBJS=crt0_16m.obj+crt0datn.obj+emoem.obj+qccore.obj+llvesa
D16_DEF_FILE=dos16m.def
# --- Use the next line for UI_GRAPHICS_DISPLAY ---
D16_LIBS=msc80lse msc80l msc80lg dos16 d16libc d16_zil d16_gfx ms_16gfx 
# --- Use the next line for UI_MSC_DISPLAY ---
#D16_LIBS=msc80lse msc80l msc80lg dos16 d16_zil d16_msc graphics
D16_PATH=\dos16m\bin
!ENDIF

.cpp.o16:
	$(D16_CPP) $(D16_CPP_OPTS) -Fo$*.o16 $<

# ----- Windows compiler options --------------------------------------------
# for debug:    add -Zi to CPP_OPTS
#               and /CO to LINK_OPTS
WIN_CPP=cl
WIN_LINK=link
WIN_RC=rc

WIN_CPP_OPTS=-c -AL -BATCH -Gsw -Os -nologo
WIN_RC_OPTS=-k
WIN_LINK_OPTS=/NOE /NOD /BATCH /SEGMENTS:512 /ON:N
WIN_LIB_OPTS=/NOI
WIN_OBJS=
WIN_LIBS=win_zil libw llibcew oldnames commdlg 

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
	z_clean
#	----- Level 1 Applications -----
	@cd service
	nmake -fmvcpp150.mak clean
	@cd ..
#	----- Level 2 Applications -----
	@cd storage
	nmake -fmvcpp150.mak clean
	@cd ..
	@cd direct
	nmake -fmvcpp150.mak clean
	@cd ..
	@cd stredit
	nmake -fmvcpp150.mak clean
	@cd ..
#	----- Level 3 Applications -----
	@cd help
	nmake -fmvcpp150.mak clean
	@cd ..
	@cd message
	nmake -fmvcpp150.mak clean
	@cd ..
	@cd image
	nmake -fmvcpp150.mak clean
	@cd ..
	@cd i18n
	nmake -fmvcpp150.mak clean
	@cd ..
	@cd file
	nmake -fmvcpp150.mak clean
	@cd ..
	@cd window
	nmake -fmvcpp150.mak clean
	@cd ..


# ----- DOS -----------------------------------------------------------------
dos16: design.exe
	copy design.exe ..\bin

!IF DEFINED(PHARLAP16)
design.exe: mods_pl main.o16
	$(D16_LINK) $(D16_LINK_OPTS) @<<zil.rsp
$(D16_OBJS)+main.o16
$*,NUL,i18n16.lib window16.lib help16.lib messag16.lib image16.lib ..\lib\mvcpp150\storag16.lib direct16.lib stredi16.lib servic16.lib $(D16_LIBS),NUL
<<
	$(D16_BIND) @<<zil.rsp
$(PHARLAP_RTL)\$(D16_LOAD)
$*
-dll $(PHARLAP_RTL)\moucalls $(PHARLAP_RTL)\int33 $(PHARLAP_RTL)\doscalls
<<
	@del zil.rsp
!ENDIF

!IF DEFINED(RATIONAL16)
design.exe: mods_16m main.o16
	$(D16_LINK) $(D16_LINK_OPTS) @<<zil.rsp
$(D16_OBJS)+main.o16
$*,NUL,i18n16.lib window16.lib help16.lib messag16.lib image16.lib ..\lib\mvcpp150\storag16.lib direct16.lib stredi16.lib servic16.lib $(D16_LIBS),$(D16_DEF_FILE)
<<
	@del zil.rsp
!ENDIF

mods_16m:
	@echo Run nmake "RATIONAL16=" -fmvcpp150.mak dos16
	@echo in each subdirectory to build the sub-libraries
	@echo first.

mods_pl:
#	----- Level 1 Applications -----
	@cd service
	nmake -fmvcpp150.mak servic16.lib
	@cd ..
#	----- Level 2 Applications -----
	@cd storage
	nmake -fmvcpp150.mak storag16.lib
	@cd ..
	@cd direct
	nmake -fmvcpp150.mak direct16.lib
	@cd ..
	@cd stredit
	nmake -fmvcpp150.mak stredi16.lib
	@cd ..
#	----- Level 3 Applications -----
	@cd help
	nmake -fmvcpp150.mak help16.lib
	@cd ..
	@cd message
	nmake -fmvcpp150.mak messag16.lib
	@cd ..
	@cd image
	nmake -fmvcpp150.mak image16.lib
	@cd ..
	@cd i18n
	nmake -fmvcpp150.mak i18n16.lib
	@cd ..
	@cd file
	nmake -fmvcpp150.mak file16.lib
	@cd ..
	@cd window
	nmake -fmvcpp150.mak window16.lib
	@cd ..

# ----- Windows Libraries and Programs --------------------------------------
windows: wdesign.exe
	copy wdesign.exe ..\bin

wdesign.exe: make_windows_modules main.obw
	$(WIN_LINK) $(WIN_LINK_OPTS) @<<zil.rsp
$(WIN_OBJS)+main.obw
$*,NUL, wi18n.lib wwindow whelp wmessage wimage wstorage wdirect wstredit wservice $(WIN_LIBS),wdesign.def
<<
	$(WIN_RC) $(WIN_RC_OPTS) wdesign.rc $*.exe

make_windows_modules:
#	----- Level 1 Applications -----
	@cd service
	nmake -f mvcpp150.mak wservice.lib
	@cd ..
#	----- Level 2 Applications -----
	@cd storage
	nmake -f mvcpp150.mak wstorage.lib
	@cd ..
	@cd direct
	nmake -f mvcpp150.mak wdirect.lib
	@cd ..
	@cd stredit
	nmake -f mvcpp150.mak wstredit.lib
	@cd ..
#	----- Level 3 Applications -----
	@cd help
	nmake -f mvcpp150.mak whelp.lib
	@cd ..
	@cd message
	nmake -f mvcpp150.mak wmessage.lib
	@cd ..
	@cd image
	nmake -f mvcpp150.mak wimage.lib
	@cd ..
	@cd i18n
	nmake -f mvcpp150.mak wi18n.lib
	@cd ..
	@cd file
	nmake -f mvcpp150.mak wfile.lib
	@cd ..
	@cd window
	nmake -f mvcpp150.mak wwindow.lib
	@cd ..
