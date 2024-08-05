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
D16_LINK_OPTS=/NOI /NOE /BATCH /SE:275 /ON:N
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
dos16: winedit.exe
	copy winedit.exe ..\..\bin

!IF DEFINED(PHARLAP16)
winedit.exe: main.o16 window16.lib
	$(D16_LINK) $(D16_LINK_OPTS) @<<zil.rsp
$(D16_OBJS)+main.o16
$*,NUL,window16.lib storag16.lib direct16.lib stredi16.lib servic16.lib $(D16_LIBS),NUL
<<
	$(D16_BIND) @<<zil.rsp
$(PHARLAP_RTL)\$(D16_LOAD)
$*
-dll $(PHARLAP_RTL)\moucalls $(PHARLAP_RTL)\int33 $(PHARLAP_RTL)\doscalls
<<
	@del zil.rsp
!ENDIF

!IF DEFINED(RATIONAL16)
winedit.exe: main.o16 window16.lib
	$(D16_LINK) $(D16_LINK_OPTS) @<<zil.rsp
$(D16_OBJS)+main.o16
$*,NUL,window16.lib storag16.lib direct16.lib stredi16.lib servic16.lib $(D16_LIBS),$(D16_DEF_FILE)
<<
	@del zil.rsp
!ENDIF

window16.lib : advanced.o16 derive.o16 export.o16 \
	geometry.o16 group.o16 import.o16 object.o16 \
	position.o16 prefer.o16 window.o16 window1.o16 \
	z_bnum.o16 z_border.o16 z_button.o16 z_combo.o16 \
	z_date.o16 z_fmtstr.o16 z_gmgr.o16 z_group.o16 \
	z_hlist.o16 z_icon.o16 z_int.o16 z_max.o16 z_min.o16 z_notebk.o16 \
	z_obj.o16 z_plldn.o16 z_plldn1.o16 z_popup.o16 z_popup1.o16 \
	z_prompt.o16 z_real.o16 z_sbar.o16 z_scroll.o16 z_spin.o16 \
	z_string.o16 z_sys.o16 z_table.o16 z_tbar.o16 z_text.o16 \
	z_time.o16 z_title.o16 z_vlist.o16 z_win.o16
	-@del window16.lib
	$(D16_LIBRARIAN) $(D16_LIB_OPTS) @<<zil.rsp
$* &
+advanced.o16+derive.o16+export.o16 &
+geometry.o16+group.o16+import.o16+object.o16 &
+position.o16+prefer.o16+window.o16+window1.o16 &
+z_bnum.o16+z_border.o16+z_button.o16+z_combo.o16 &
+z_date.o16+z_fmtstr.o16+z_gmgr.o16+z_group.o16 &
+z_hlist.o16+z_icon.o16+z_int.o16+z_max.o16+z_min.o16+z_notebk.o16 &
+z_obj.o16+z_plldn.o16+z_plldn1.o16+z_popup.o16+z_popup1.o16 &
+z_prompt.o16+z_real.o16+z_sbar.o16+z_scroll.o16+z_spin.o16 &
+z_string.o16+z_sys.o16+z_table.o16+z_tbar.o16+z_text.o16 &
+z_time.o16+z_title.o16+z_vlist.o16+z_win.o16
NUL
<<
	copy window.hpp ..\..\include
	copy window16.lib ..\..\lib\$(VERSION)
	copy p_window.dat ..\..\bin\p_window.znc

# ----- Windows Libraries and Programs --------------------------------------
windows: wwinedit.exe
	copy wwinedit.exe ..\..\bin

wwinedit.exe: main.obw wwindow.lib
	$(WIN_LINK) $(WIN_LINK_OPTS) @<<zil.rsp
$(WIN_OBJS)+main.obw
$*,NUL, wwindow wstorage wdirect wstredit wservice $(WIN_LIBS),wwindow.def
<<
	$(WIN_RC) $(WIN_RC_OPTS) wwindow.rc $*.exe

wwindow.lib : advanced.obw derive.obw export.obw \
	geometry.obw group.obw import.obw object.obw \
	position.obw prefer.obw window.obw window1.obw \
	z_bnum.obw z_border.obw z_button.obw z_combo.obw \
	z_date.obw z_fmtstr.obw z_gmgr.obw z_group.obw \
	z_hlist.obw z_icon.obw z_int.obw z_max.obw z_min.obw z_notebk.obw z_obj.obw \
	z_plldn.obw z_plldn1.obw z_popup.obw z_popup1.obw z_prompt.obw \
	z_real.obw z_scroll.obw z_sbar.obw z_spin.obw z_string.obw z_sys.obw \
	z_table.obw z_tbar.obw z_text.obw z_time.obw z_title.obw z_vlist.obw z_win.obw
	-@del wwindow.lib
	$(WIN_LIBRARIAN) $(WIN_LIB_OPTS) @<<zil.rsp
$* &
+advanced.obw+derive.obw+export.obw &
+geometry.obw+group.obw+import.obw+object.obw &
+position.obw+prefer.obw+window.obw+window1.obw &
+z_bnum.obw+z_border.obw+z_button.obw+z_combo.obw &
+z_date.obw+z_fmtstr.obw+z_gmgr.obw+z_group.obw &
+z_hlist.obw+z_icon.obw+z_int.obw+z_max.obw+z_min.obw+z_notebk.obw+z_obj.obw &
+z_plldn.obw+z_plldn1.obw+z_popup.obw+z_popup1.obw+z_prompt.obw &
+z_real.obw+z_sbar.obw+z_scroll.obw+z_spin.obw+z_string.obw+z_sys.obw &
+z_table.obw+z_tbar.obw+z_text.obw+z_time.obw+z_title.obw+z_vlist.obw+z_win.obw
NUL
<<
	copy window.hpp ..\..\include
	copy wwindow.lib ..\..\lib\$(VERSION)
	copy p_window.dat ..\..\bin\p_window.znc


