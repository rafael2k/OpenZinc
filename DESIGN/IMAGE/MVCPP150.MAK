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
dos16: imgedit.exe
	copy imgedit.exe ..\..\bin

!IF DEFINED(PHARLAP16)
imgedit.exe: main.o16 image16.lib
	$(D16_LINK) $(D16_LINK_OPTS) @<<zil.rsp
$(D16_OBJS)+main.o16
$*,NUL,image16.lib stredi16.lib direct16.lib storag16.lib servic16.lib $(D16_LIBS),NUL
<<
	$(D16_BIND) @<<zil.rsp
$(PHARLAP_RTL)\$(D16_LOAD)
$*
-dll $(PHARLAP_RTL)\moucalls $(PHARLAP_RTL)\int33 $(PHARLAP_RTL)\doscalls
<<
	@del zil.rsp
!ENDIF

!IF DEFINED(RATIONAL16)
imgedit.exe: main.o16 image16.lib
	$(D16_LINK) $(D16_LINK_OPTS) @<<zil.rsp
$(D16_OBJS)+main.o16
$*,NUL,image16.lib stredi16.lib direct16.lib storag16.lib servic16.lib $(D16_LIBS),$(D16_DEF_FILE)
<<
	@del zil.rsp
!ENDIF

image16.lib : odib.o16 odib1.o16 odib2.o16 \
	wdib.o16 wdib1.o16 wdib2.o16 \
	wico.o16 wico1.o16 wico2.o16 \
	xpm.o16 xpm1.o16 xpm2.o16 \
	znc1.o16 znc2.o16 \
	image.o16 image1.o16 image2.o16 color.o16 draw.o16 \
	export.o16 import.o16 \
	d_image.o16
	-@del image16.lib
	$(D16_LIBRARIAN) $(D16_LIB_OPTS) @<<zil.rsp
$* &
+odib.o16+odib1.o16+odib2.o16 &
+wdib.o16+wdib1.o16+wdib2.o16 &
+wico.o16+wico1.o16+wico2.o16 &
+xpm.o16+xpm1.o16+xpm2.o16 &
+znc1.o16+znc2.o16 &
+image.o16+image1.o16+image2.o16+color.o16+draw.o16 &
+export.o16+import.o16 &
+d_image.o16
NUL
<<
	copy image.hpp ..\..\include
	copy image16.lib ..\..\lib\$(VERSION)
	copy p_image.dat ..\..\bin\p_image.znc

# ----- Windows Libraries and Programs --------------------------------------
windows: wimgedit.exe
	copy wimgedit.exe ..\..\bin

wimgedit.exe: main.obw wimage.lib
	$(WIN_LINK) $(WIN_LINK_OPTS) @<<zil.rsp
$(WIN_OBJS)+test.obw
$*,NUL, wimage wstredit wstorage wdirect wservice $(WIN_LIBS),wtest.def
<<
	$(WIN_RC) $(WIN_RC_OPTS) wtest.rc $*.exe

wimage.lib : odib.obw odib1.obw odib2.obw \
	wdib.obw wdib1.obw wdib2.obw \
	wico.obw wico1.obw wico2.obw \
	xpm.obw xpm1.obw xpm2.obw \
	znc1.obw znc2.obw \
	image.obw image1.obw image2.obw color.obw draw.obw \
	export.obw import.obw \
	w_image.obw
	-@del wimage.lib
	$(WIN_LIBRARIAN) $(WIN_LIB_OPTS) @<<zil.rsp
$* &
+odib.obw+odib1.obw+odib2.obw &
+wdib.obw+wdib1.obw+wdib2.obw &
+wico.obw+wico1.obw+wico2.obw &
+xpm.obw+xpm1.obw+xpm2.obw &
+znc1.obw+znc2.obw &
+image.obw+image1.obw+image2.obw+color.obw+draw.obw &
+export.obw+import.obw &
+w_image.obw
NUL
<<
	copy image.hpp ..\..\include
	copy wimage.lib ..\..\lib\$(VERSION)
	copy p_image.dat ..\..\bin\p_image.znc
