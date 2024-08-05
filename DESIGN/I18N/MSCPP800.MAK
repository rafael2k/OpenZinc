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
winnt: ni18edit.exe
	copy ni18edit.exe ..\..\bin

ni18edit.exe: main.obn ni18n.lib
	$(link) $(linkdebug) $(guiflags) main.obn $(guilibs) VERSION.LIB ni18n.lib nstorage.lib ndirect.lib nstredit.lib nservice.lib $(WNT_ZINC_LIBS) -out:$*.exe

ni18n.lib : i18n.obn language.obn locale.obn \
	export.obn import.obn \
	z_bnum.obn z_curr.obn z_date.obn z_date1.obn z_day.obn z_error.obn \
	z_help.obn z_int.obn z_month.obn z_msg.obn z_num.obn z_real.obn \
	z_sys.obn z_time.obn z_time1.obn z_time2.obn z_win.obn
	-@del ni18n.lib
	$(implib) /out:$*.lib $(WNT_LIB_OPTS) @<<zil.rsp
i18n.obn
language.obn
locale.obn
export.obn
import.obn
z_bnum.obn
z_curr.obn
z_date.obn
z_date1.obn
z_day.obn
z_error.obn
z_help.obn
z_int.obn
z_month.obn
z_msg.obn
z_num.obn
z_real.obn
z_sys.obn
z_time.obn
z_time1.obn
z_time2.obn
z_win.obn
<<
	copy i18n.hpp ..\..\include
	copy ni18n.lib ..\..\lib\$(VERSION)
	copy p_i18n.dat ..\..\bin\p_i18n.znc
