# INTERNATIONAL utilities makefile

#    make -f btcpp400.mak dos             (makes the DOS intl utilities)

.SUFFIXES : .c .cpp .obj .o16 .obw

# ----- DOS compiler options ------------------------------------------------
# for debug:    add -Zi to CPP_OPTS
#               and /CO to LINK_OPTS
DOS_CPP=cl
DOS_LINK=link
DOS_LIBRARIAN=lib

DOS_CPP_OPTS=-c -AL -BATCH -Gs -Os -nologo
DOS_LINK_OPTS=/NOI /NOE /NOD /BATCH /SEGMENTS:256 /STACK:5120 /EXE 
DOS_LIB_OPTS=/NOI

# --- Use the next line for UI_GRAPHICS_DISPLAY ---
DOS_OBJS=
DOS_LIBS=dos_zil dos_gfx ms_lgfx llibce graphics oldnames
# --- Use the next line for UI_MSC_DISPLAY ---
#DOS_OBJS=
#DOS_LIBS=dos_zil dos_msc llibce graphics oldnames

.cpp.obj:
	$(DOS_CPP) $(DOS_CPP_OPTS) $<

# ----- Windows compiler options --------------------------------------------
# for debug:    add -Zi to CPP_OPTS
#               and /CO to LINK_OPTS
WIN_CPP=cl
WIN_LINK=link
WIN_LIBRARIAN=lib
WIN_RC=rc

# --- Use the next 2 lines for Windows 3.0 compatibility ---
WIN_CPP_OPTS=-c -AL -BATCH -Gsw -Os -DWINVER=0x0300 -nologo
WIN_RC_OPTS=-k -30
# --- Use the next 2 lines for Windows 3.1 compatibility ---
#WIN_CPP_OPTS=-c -AL -BATCH -Gsw -Os -nologo
#WIN_RC_OPTS=-k
WIN_LINK_OPTS=/NOE /NOD /NOI /BATCH /SEGMENTS:256 /ON:N
WIN_LIB_OPTS=/NOI
WIN_OBJS=
WIN_LIBS=win_zil libw llibcew oldnames

.cpp.obw:
	$(WIN_CPP) $(WIN_CPP_OPTS) -Fo$*.obw $<

# ----- 16 bit Dos Extender compiler options --------------------------------
# for debug:    add -Zi to CPP_OPTS
#               and /CO to LINK_OPTS
D16_CPP=cl
D16_LINK=link

# -- Pharlap 286 Dos Extender setup
D16_LIBRARIAN=lib
D16_CPP_OPTS=-c -AL -BATCH -Gs2 -DDOSX286 -nologo
D16_LINK_OPTS=/NOI /NOE /NOD /BATCH /SEGMENTS:256 /STACK:5120 /ON:N
D16_LIB_OPTS=/NOI

# --- Use the next line for UI_GRAPHICS_DISPLAY ---
D16_OBJS=graphp.obj
D16_LIBS=phapi d16_zil d16_gfx ms_16gfx llibcep graphics oldnames
# --- Use the next lines for UI_MSC_DISPLAY ---
#D16_OBJS=graphp.obj
#D16_LIBS=phapi d16_zil d16_msc graphics llibcep oldnames

# -- Rational DOS16M Dos Extender setup
#D16_LIBRARIAN=lib /PAGESIZE:1024
#D16_CPP_OPTS=-c -Zi -AL -BATCH -Gs2 -DDOS16M -nologo
#D16_LINK_OPTS=/NOI /NOE /BATCH /CO /SEGMENTS:256 /STACK:5120 /ON:N
#D16_LIB_OPTS=/NOI

# --- Use the next line for UI_GRAPHICS_DISPLAY ---
#D16_OBJS=crt0.obj+crt0datn.obj+emoem.obj+qccore.obj+llvesa
#D16_LIBS=msc80lse msc80l msc80lg d16_zil d16_gfx ms_16gfx dos16 d16libc
# --- Use the next lines for UI_MSC_DISPLAY ---
#D16_OBJS=graphp.obj
#D16_LIBS=phapi d16_zil d16_msc graphics llibcep oldnames

.cpp.o16:
	$(D16_CPP) $(D16_CPP_OPTS) -Fo$*.o16 $<

# ----- Usage --------------------------------------------------------------
usage:
	@echo ...........
	@echo ...........
	@echo To make these Zinc Intl utilities for Microsoft C++ type:
	@echo nmake -fmvcpp150.mak dos
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean

# ----- Update --------------------------------------------------------------
update:
	copy locale.* ..\..\bin
	copy language.* ..\..\bin

# ----- DOS -----------------------------------------------------------------
dos: loc2dat.exe lang2dat.exe map2dat.exe #genloc.exe genlang.exe
#	copy genloc.exe ..\..\bin
#	copy genlang.exe ..\..\bin

dosu: uloc2dat.exe ulang2da.exe

genloc.exe: genloc.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) @<<zil.rsp
$(DOS_OBJS)+genloc.obj
$*,NUL,$(DOS_LIBS),NUL
<<

genlang.exe: genlang.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) @<<zil.rsp
$(DOS_OBJS)+genlang.obj
$*,NUL,$(DOS_LIBS),NUL
<<

loc2dat.exe: loc2dat.obj \
	loc_at.obj loc_ca.obj loc_cafr.obj loc_de.obj loc_dk.obj loc_es.obj \
	loc_fi.obj loc_fr.obj loc_gb.obj loc_it.obj loc_mx.obj loc_nl.obj \
	loc_no.obj loc_se.obj loc_us.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) @<<zil.rsp
$(DOS_OBJS)+loc2dat.obj+
loc_at.obj+loc_ca.obj+loc_cafr.obj+loc_de.obj+loc_dk.obj+loc_es.obj+
loc_fi.obj+loc_fr.obj+loc_gb.obj+loc_it.obj+loc_mx.obj+loc_nl.obj+
loc_no.obj+loc_se.obj+loc_us.obj
$*,NUL,$(DOS_LIBS),NUL
<<

uloc2dat.exe: uloc2dat.obj \
	loc_cn.obj loc_gr.obj loc_jp.obj loc_kr.obj loc_tw.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) @<<zil.rsp
$(DOS_OBJS)+uloc2dat.obj+
loc_cn.obj+loc_gr.obj+loc_jp.obj+loc_kr.obj+loc_tw.obj
$*,NUL,$(DOS_LIBS),NUL
<<

loc2dat.obj: loc2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -Fo$*.obj loc2dat.cpp
loc_at.obj: loc_at.cpp loc2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DLOCALE_NAME=at -Fo$*.obj loc2dat.cpp
loc_ca.obj: loc_ca.cpp loc2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DLOCALE_NAME=ca -Fo$*.obj loc2dat.cpp
loc_cafr.obj: loc_cafr.cpp loc2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DLOCALE_NAME=cafr -Fo$*.obj loc2dat.cpp
loc_de.obj: loc_de.cpp loc2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DLOCALE_NAME=de -Fo$*.obj loc2dat.cpp
loc_dk.obj: loc_dk.cpp loc2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DLOCALE_NAME=dk -Fo$*.obj loc2dat.cpp
loc_es.obj: loc_es.cpp loc2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DLOCALE_NAME=es -Fo$*.obj loc2dat.cpp
loc_fi.obj: loc_fi.cpp loc2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DLOCALE_NAME=fi -Fo$*.obj loc2dat.cpp
loc_fr.obj: loc_fr.cpp loc2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DLOCALE_NAME=fr -Fo$*.obj loc2dat.cpp
loc_gb.obj: loc_gb.cpp loc2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DLOCALE_NAME=gb -Fo$*.obj loc2dat.cpp
loc_gr.obj: loc_gr.cpp loc2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DLOCALE_NAME=gr -Fo$*.obj loc2dat.cpp
loc_it.obj: loc_it.cpp loc2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DLOCALE_NAME=it -Fo$*.obj loc2dat.cpp
loc_mx.obj: loc_mx.cpp loc2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DLOCALE_NAME=mx -Fo$*.obj loc2dat.cpp
loc_nl.obj: loc_nl.cpp loc2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DLOCALE_NAME=nl -Fo$*.obj loc2dat.cpp
loc_no.obj: loc_no.cpp loc2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DLOCALE_NAME=no -Fo$*.obj loc2dat.cpp
loc_se.obj: loc_se.cpp loc2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DLOCALE_NAME=se -Fo$*.obj loc2dat.cpp
loc_us.obj: loc_us.cpp loc2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DLOCALE_NAME=us -Fo$*.obj loc2dat.cpp

uloc2dat.obj: loc2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -Fo$*.obj loc2dat.cpp
loc_cn.obj: loc_cn.cpp loc2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DLOCALE_NAME=cn -Fo$*.obj loc2dat.cpp
loc_jp.obj: loc_jp.cpp loc2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DLOCALE_NAME=jp -Fo$*.obj loc2dat.cpp
loc_kr.obj: loc_kr.cpp loc2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DLOCALE_NAME=kr -Fo$*.obj loc2dat.cpp
loc_tw.obj: loc_tw.cpp loc2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DLOCALE_NAME=tw -Fo$*.obj loc2dat.cpp

lang2dat.exe: lang2dat.obj \
	lang_ca.obj lang_da.obj lang_de.obj lang_en.obj lang_es.obj \
	lang_fi.obj lang_fr.obj lang_it.obj lang_nl.obj lang_no.obj \
	lang_sv.obj 
	$(DOS_LINK) $(DOS_LINK_OPTS) @<<zil.rsp
$(DOS_OBJS)+lang2dat.obj+
lang_ca.obj+lang_da.obj+lang_de.obj+lang_en.obj+lang_es.obj+
lang_fi.obj+lang_fr.obj+lang_it.obj+lang_nl.obj+lang_no.obj+
lang_sv.obj
$*,NUL,$(DOS_LIBS),NUL
<<

ulang2da.exe: ulang2da.obj \
	lang_el.obj lang_ja.obj lang_ko.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) @<<zil.rsp
$(DOS_OBJS)+ulang2da.obj+
lang_el.obj+lang_ja.obj+lang_ko.obj
$*,NUL,$(DOS_LIBS),NUL
<<

lang2dat.obj: lang2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -Fo$*.obj lang2dat.cpp
lang_ca.obj: lang_ca.cpp lang2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DLANGUAGE_NAME=ca -Fo$*.obj lang2dat.cpp
lang_da.obj: lang_da.cpp lang2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DLANGUAGE_NAME=da -Fo$*.obj lang2dat.cpp
lang_de.obj: lang_de.cpp lang2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DLANGUAGE_NAME=de -Fo$*.obj lang2dat.cpp
lang_en.obj: lang_en.cpp lang2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DLANGUAGE_NAME=en -Fo$*.obj lang2dat.cpp
lang_es.obj: lang_es.cpp lang2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DLANGUAGE_NAME=es -Fo$*.obj lang2dat.cpp
lang_fi.obj: lang_fi.cpp lang2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DLANGUAGE_NAME=fi -Fo$*.obj lang2dat.cpp
lang_fr.obj: lang_fr.cpp lang2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DLANGUAGE_NAME=fr -Fo$*.obj lang2dat.cpp
lang_it.obj: lang_it.cpp lang2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DLANGUAGE_NAME=it -Fo$*.obj lang2dat.cpp
lang_nl.obj: lang_nl.cpp lang2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DLANGUAGE_NAME=nl -Fo$*.obj lang2dat.cpp
lang_no.obj: lang_no.cpp lang2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DLANGUAGE_NAME=no -Fo$*.obj lang2dat.cpp
lang_sv.obj: lang_sv.cpp lang2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DLANGUAGE_NAME=sv -Fo$*.obj lang2dat.cpp

ulang2da.obj: lang2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -Fo$*.obj lang2dat.cpp
lang_el.obj: lang_el.cpp lang2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DLANGUAGE_NAME=el -Fo$*.obj lang2dat.cpp
lang_ja.obj: lang_ja.cpp lang2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DLANGUAGE_NAME=ja -Fo$*.obj lang2dat.cpp
lang_ko.obj: lang_ko.cpp lang2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DLANGUAGE_NAME=ko -Fo$*.obj lang2dat.cpp

map2dat.exe: map2dat.obj \
	map437.obj map737.obj map850.obj map852.obj map855.obj map857.obj \
	map860.obj map861.obj map863.obj map865.obj map866.obj map869.obj \
	map1250.obj map1251.obj map1252.obj map1253.obj map1254.obj \
	map1255.obj map1256.obj mapmac.obj mapnext.obj
	$(DOS_LINK) $(DOS_LINK_OPTS) @<<zil.rsp
$(DOS_OBJS)+map2dat.obj+
map437.obj+map737.obj+map850.obj+map852.obj+map855.obj+map857.obj+
map860.obj+map861.obj+map863.obj+map865.obj+map866.obj+map869.obj+
map1250.obj+map1251.obj+map1252.obj+map1253.obj+map1254.obj+
map1255.obj+map1256.obj+mapmac.obj+mapnext.obj
$*,NUL,$(DOS_LIBS),NUL
<<

map2dat.obj: map2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -Fo$*.obj map2dat.cpp
map437.obj: map437.cpp map2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DMAP_NAME=437 -Fo$*.obj map2dat.cpp
map737.obj: map737.cpp map2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DMAP_NAME=737 -Fo$*.obj map2dat.cpp
map850.obj: map850.cpp map2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DMAP_NAME=850 -Fo$*.obj map2dat.cpp
map852.obj: map852.cpp map2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DMAP_NAME=852 -Fo$*.obj map2dat.cpp
map855.obj: map855.cpp map2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DMAP_NAME=855 -Fo$*.obj map2dat.cpp
map857.obj: map857.cpp map2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DMAP_NAME=857 -Fo$*.obj map2dat.cpp
map860.obj: map860.cpp map2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DMAP_NAME=860 -Fo$*.obj map2dat.cpp
map861.obj: map861.cpp map2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DMAP_NAME=861 -Fo$*.obj map2dat.cpp
map863.obj: map863.cpp map2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DMAP_NAME=863 -Fo$*.obj map2dat.cpp
map865.obj: map865.cpp map2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DMAP_NAME=865 -Fo$*.obj map2dat.cpp
map866.obj: map866.cpp map2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DMAP_NAME=866 -Fo$*.obj map2dat.cpp
map869.obj: map869.cpp map2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DMAP_NAME=869 -Fo$*.obj map2dat.cpp
map1250.obj: map1250.cpp map2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DMAP_NAME=1250 -Fo$*.obj map2dat.cpp
map1251.obj: map1251.cpp map2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DMAP_NAME=1251 -Fo$*.obj map2dat.cpp
map1252.obj: map1252.cpp map2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DMAP_NAME=1252 -Fo$*.obj map2dat.cpp
map1253.obj: map1253.cpp map2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DMAP_NAME=1253 -Fo$*.obj map2dat.cpp
map1254.obj: map1254.cpp map2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DMAP_NAME=1254 -Fo$*.obj map2dat.cpp
map1255.obj: map1255.cpp map2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DMAP_NAME=1255 -Fo$*.obj map2dat.cpp
map1256.obj: map1256.cpp map2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DMAP_NAME=1256 -Fo$*.obj map2dat.cpp
mapmac.obj: mapmac.cpp map2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DMAP_NAME=MAC -Fo$*.obj map2dat.cpp
mapnext.obj: mapnext.cpp map2dat.cpp
	$(DOS_CPP) $(DOS_CPP_OPTS) -DMAP_NAME=NeXT -Fo$*.obj map2dat.cpp
