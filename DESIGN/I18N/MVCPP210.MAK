# ----- General Definitions -------------------------------------------------
VERSION=mvcpp210

.SUFFIXES : .c .cpp .obj .o16 .o32 .obw .obn

# ----- DOS TNT Extender options --------------------------------------------
# for debug:    add -Zi to CPP_OPTS
#               and -CV to LINK_OPTS
D32_CPP=cl
D32_LINK=link
D32_LIBRARIAN=lib
D32_CPP_OPTS=-c -DDOS386 -nologo
D32_LINK_OPTS=
D32_LIB_OPTS=
D32_OBJS=

# --- Use the next line for UI_GRAPHICS_DISPLAY ---
D32_LIBS=dosx32.lib dos32.lib d32_zil.lib d32_gfx.lib ms_32gfx.lib oldnames.lib
# --- Use the next line for UI_MSC_DISPLAY ---
#D32_LIBS=dosx32.lib dos32.lib tntapi.lib d32_zil.lib d32_msc.lib oldnames.lib

.cpp.o32:
	$(D32_CPP) $(D32_CPP_OPTS) -Fo$*.o32 $<

# ----- Usage --------------------------------------------------------------
usage:
	@echo ...........
	@echo ...........
	@echo To generate the library modules for specific environments type:
	@echo nmake -fmvcpp210.mak dos32
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean.bat

# ----- 32 bit DOS Extender Libraries and Programs --------------------------
dos32: i18edt32.exe
	copy i18edt32.exe ..\..\bin

i18edt32.exe: main.o32 i18n32.lib
	$(D32_LINK) @msvc32.lnk $(D32_LINK_OPTS) -out:i18edt32.exe $(D32_OBJS) main.o32 i18n32.lib storag32.lib direct32.lib stredi32.lib servic32.lib $(D32_LIBS)

i18n32.lib : i18n.o32 language.o32 locale.o32 \
	export.o32 import.o32 \
	z_bnum.o32 z_curr.o32 z_date.o32 z_date1.o32 z_day.o32 z_error.o32 \
	z_help.o32 z_int.o32 z_month.o32 z_msg.o32 z_num.o32 z_real.o32 \
	z_sys.o32 z_time.o32 z_time1.o32 z_time2.o32 z_win.o32
	-@del i18n32.lib
	$(D32_LIBRARIAN) $(D32_LIB_OPTS) @<<zil.rsp
/out:$*.lib
i18n.o32 language.o32 locale.o32
export.o32 import.o32
z_bnum.o32 z_curr.o32 z_date.o32 z_date1.o32 z_day.o32 z_error.o32
z_help.o32 z_int.o32 z_month.o32 z_msg.o32 z_num.o32 z_real.o32
z_sys.o32 z_time.o32 z_time1.o32 z_time2.o32 z_win.o32
<<
	copy i18n.hpp ..\..\include
	copy i18n32.lib ..\..\lib\$(VERSION)
	copy p_i18n.dat ..\..\bin\p_i18n.znc


