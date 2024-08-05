# ----- General Definitions -------------------------------------------------
VERSION=iccpp210

# ----- OS/2 compiler options -----------------------------------------------
OS2_CPP=icc
OS2_LINK=link386
OS2_LIBRARIAN=lib
OS2_RC=rc

OS2_CPP_OPTS=/c /D__OS2__ /O+
OS2_LINK_OPTS=/NOE /NOI /BASE:0x10000 /PM:PM
OS2_LIB_OPTS=
OS2_RC_OPTS=

OS2_OBJS=
OS2_LIBS=os2_zil.lib

.SUFFIXES : .cpp

.cpp.obj:
	$(OS2_CPP) $(OS2_CPP_OPTS) $<

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean

# ----- OS/2 ----------------------------------------------------------------
os2: owinedit.exe
	copy owinedit.exe ..\..\bin

owinedit.exe: main.obj owindow.lib
	$(OS2_LINK) $(OS2_LINK_OPTS) @<<zil.rsp
$(OS2_OBJS)+main.obj
$*,NUL,owindow ostorage odirect ostredit oservice $(OS2_LIBS),owindow.def
<<

owindow.lib : advanced.obj derive.obj export.obj \
	geometry.obj group.obj import.obj object.obj \
	position.obj prefer.obj window.obj window1.obj \
	z_bnum.obj z_border.obj z_button.obj z_combo.obj \
	z_date.obj z_fmtstr.obj z_gmgr.obj z_group.obj \
	z_hlist.obj z_icon.obj z_int.obj z_max.obj z_min.obj z_notebk.obj \
	z_obj.obj z_plldn.obj z_plldn1.obj z_popup.obj z_popup1.obj \
	z_prompt.obj z_real.obj z_scroll.obj z_sbar.obj z_spin.obj \
	z_string.obj z_sys.obj z_table.obj z_tbar.obj z_text.obj \
	z_time.obj z_title.obj z_vlist.obj z_win.obj
	-@del owindow.lib
	$(OS2_LIBRARIAN) $(OS2_LIB_OPTS) @<<zil.rsp
$* &
+advanced.obj+derive.obj+export.obj &
+geometry.obj+group.obj+import.obj+object.obj &
+position.obj+prefer.obj+window.obj+window1.obj &
+z_bnum.obj+z_border.obj+z_button.obj+z_combo.obj &
+z_date.obj+z_fmtstr.obj+z_gmgr.obj+z_group.obj &
+z_hlist.obj+z_icon.obj+z_int.obj+z_max.obj+z_min.obj+z_notebk.obj &
+z_obj.obj+z_plldn.obj+z_plldn1.obj+z_popup.obj+z_popup1.obj &
+z_prompt.obj+z_real.obj+z_sbar.obj+z_scroll.obj+z_spin.obj &
+z_string.obj+z_sys.obj+z_table.obj+z_tbar.obj+z_text.obj &
+z_time.obj+z_title.obj+z_vlist.obj+z_win.obj
NUL
<<
	copy window.hpp ..\..\include
	copy owindow.lib ..\..\lib\$(VERSION)
	copy p_window.dat ..\..\bin\p_window.znc
