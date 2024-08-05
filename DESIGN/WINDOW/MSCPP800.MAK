# ----- General Definitions -------------------------------------------------
VERSION=mscpp800

.SUFFIXES : .c .cpp .obj .o16 .o32 .obw .obn

# ----- Windows NT compiler options -----------------------------------------
# for debug:    comment out next line
NODEBUG=1
!include <NTWIN32.MAK>

WNT_ZINC_LIBS=wnt_zil.lib
WNT_LIB_OPTS=/MACHINE:ALPHA /SUBSYSTEM:WINDOWS

.cpp.obn:
	$(cc) $(cflags) $(cvars) $(cdebug) -Fo$*.obn $<

.rc.rbj:
    $(rc) $(rcvars) -r -fo $*.rbj $(cvars) $<

# ----- Usage --------------------------------------------------------------
usage:
	@echo ...........
	@echo ...........
	@echo To generate the library modules for specific environments type:
	@echo nmake -f mscpp800.mak winnt
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean.bat

# ----- Windows NT Libraries and Programs -----------------------------------
winnt: nwinedit.exe
	copy nwinedit.exe ..\..\bin

nwinedit.exe: main.obn nwindow.lib
	$(link) $(linkdebug) $(guiflags) main.obn $(guilibs) VERSION.LIB nwindow.lib nstorage.lib ndirect.lib nstredit.lib nservice.lib $(WNT_ZINC_LIBS) -out:$*.exe

nwindow.lib : advanced.obn derive.obn export.obn \
	geometry.obn group.obn import.obn object.obn \
	position.obn prefer.obn window.obn window1.obn \
	z_bnum.obn z_border.obn z_button.obn z_combo.obn \
	z_date.obn z_fmtstr.obn z_gmgr.obn z_group.obn \
	z_hlist.obn z_icon.obn z_int.obn z_max.obn z_min.obn z_notebk.obn z_obj.obn \
	z_plldn.obn z_plldn1.obn z_popup.obn z_popup1.obn z_prompt.obn \
	z_real.obn z_sbar.obn z_scroll.obn z_spin.obn z_string.obn z_sys.obn \
	z_table.obn z_tbar.obn z_text.obn z_time.obn z_title.obn z_vlist.obn z_win.obn
	-@del nwindow.lib
	$(implib) /out:$*.lib $(WNT_LIB_OPTS) @<<zil.rsp
advanced.obn
derive.obn
export.obn
geometry.obn
group.obn
import.obn
object.obn
position.obn
prefer.obn
window.obn
window1.obn
z_bnum.obn
z_border.obn
z_button.obn
z_combo.obn
z_date.obn
z_fmtstr.obn
z_gmgr.obn
z_group.obn
z_hlist.obn
z_icon.obn
z_int.obn
z_max.obn
z_min.obn
z_notebk.obn
z_obj.obn
z_plldn.obn
z_plldn1.obn
z_popup.obn
z_popup1.obn
z_prompt.obn
z_real.obn
z_sbar.obn
z_scroll.obn
z_spin.obn
z_string.obn
z_sys.obn
z_table.obn
z_tbar.obn
z_text.obn
z_time.obn
z_title.obn
z_vlist.obn
z_win.obn
<<
	copy window.hpp ..\..\include
	copy nwindow.lib ..\..\lib\$(VERSION)
	copy p_window.dat ..\..\bin\p_window.znc

