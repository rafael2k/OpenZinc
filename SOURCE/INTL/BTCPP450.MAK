# INTERNATIONAL utilities makefile

#    make -f btcpp450.mak dos             (makes the DOS intl utilities)

# Be sure to update your TURBOC.CFG file to include the Zinc paths, e.g.:
#   -I.;C:\ZINC\INCLUDE;C:\BC45\INCLUDE
#   -L.;C:\ZINC\LIB\BTCPP450;C:\BC45\LIB
# and your TLINK.CFG file to include the Zinc paths, e.g.:
#   -L.;C:\ZINC\LIB\BTCPP450;C:\BC45\LIB

## Compiler and linker: (Add -v to CPP_OPTS and /v to LINK_OPTS for debug.)

# ----- DOS compiler options ------------------------------------------------
DOS_CPP_OPTS=-c -ml -O1 -x- -RT- -w
DOS_LINK_OPTS=/c /x
DOS_OBJS=c0l
# --- Use the next line for UI_GRAPHICS_DISPLAY ---
DOS_LIBS=dos_zil dos_gfx bc_lgfx emu mathl cl
# --- Use the next line for UI_BGI_DISPLAY ---
#DOS_LIBS=dos_zil dos_bgi graphics emu mathl cl

# ----- Windows compiler options --------------------------------------------

# --- Use the next 2 lines for Windows 3.0 compatibility ---
WIN_CPP_OPTS=-c -ml -O1 -x- -RT- -Vf -WE -w -DWINVER=0x0300
WIN_RC_OPTS=-k -30
# --- Use the next 2 lines for Windows 3.1 compatibility ---
#WIN_CPP_OPTS=-c -ml -O1 -x- -RT- -Vf -WE -w
#WIN_RC_OPTS=-k
WIN_LINK_OPTS=/c /C /Twe /x
WIN_OBJS=c0wl
WIN_LIBS=win_zil mathwl import cwl

CPP=bcc
LINK=tlink
RC=rc

.cpp.obj:
	$(CPP) $(DOS_CPP_OPTS) {$< }

.cpp.obw:
	$(CPP) $(WIN_CPP_OPTS) -o$*.obw {$< }

# --- Use the next line for PharLap Extended programs. ---
D16_CPP=bcc286
D16_LINK=tlink

D16_CPP_OPTS=-c -ml -O1 -x- -RT- -V -w
D16_LINK_OPTS=/c /x /C
D16_LIB_OPTS=/C

D16_OBJS=c0pl.obj
# --- Use the next line for UI_GRAPHICS_DISPLAY ---
D16_LIBS=phapi d16_zil d16_gfx bc_16gfx emu286 emu mathl bcl286
# --- Use the next line for UI_BGI_DISPLAY ---
#D16_LIBS=phapi d16_zil d16_bgi graph286 emu286 mathl bcl286

.cpp.o16:
	$(D16_CPP) $(D16_CPP_OPTS) -o$*.o16 {$< }

# ----- Usage --------------------------------------------------------------
usage:
	@echo ...........
	@echo ...........
	@echo To make these Zinc Intl utilities for Borland C++ type:
	@echo make -fbtcpp450.mak dos
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

dosu: uloc2dat.exe ulang2dat.exe

genloc.exe: genloc.obj
	$(LINK) $(DOS_LINK_OPTS) @&&!
$(DOS_OBJS)+genloc.obj
$*, ,$(DOS_LIBS)
!

genlang.exe: genlang.obj
	$(LINK) $(DOS_LINK_OPTS) @&&!
$(DOS_OBJS)+genlang.obj
$*, ,$(DOS_LIBS)
!

loc2dat.exe: loc2dat.obj \
	loc_at.obj loc_ca.obj loc_cafr.obj loc_de.obj loc_dk.obj loc_es.obj \
	loc_fi.obj loc_fr.obj loc_gb.obj loc_it.obj loc_mx.obj loc_nl.obj \
	loc_no.obj loc_se.obj loc_us.obj
	$(LINK) $(DOS_LINK_OPTS) @&&!
$(DOS_OBJS)+loc2dat.obj \
+loc_at.obj+loc_ca.obj+loc_cafr.obj+loc_de.obj+loc_dk.obj+loc_es.obj \
+loc_fi.obj+loc_fr.obj+loc_gb.obj+loc_it.obj+loc_mx.obj+loc_nl.obj \
+loc_no.obj+loc_se.obj+loc_us.obj
$*, ,$(DOS_LIBS)
!

uloc2dat.exe: uloc2dat.obj \
	loc_cn.obj loc_gr.obj loc_jp.obj loc_kr.obj loc_tw.obj
	$(LINK) $(DOS_LINK_OPTS) @&&!
$(DOS_OBJS)+uloc2dat.obj \
+loc_cn.obj+loc_gr.obj+loc_jp.obj+loc_kr.obj+loc_tw.obj
$*, ,$(DOS_LIBS)
!

loc2dat.obj: loc2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -o$*.obj loc2dat.cpp
loc_at.obj: loc_at.cpp loc2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -DLOCALE_NAME=at -o$*.obj loc2dat.cpp
loc_ca.obj: loc_ca.cpp loc2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -DLOCALE_NAME=ca -o$*.obj loc2dat.cpp
loc_cafr.obj: loc_cafr.cpp loc2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -DLOCALE_NAME=cafr -o$*.obj loc2dat.cpp
loc_de.obj: loc_de.cpp loc2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -DLOCALE_NAME=de -o$*.obj loc2dat.cpp
loc_dk.obj: loc_dk.cpp loc2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -DLOCALE_NAME=dk -o$*.obj loc2dat.cpp
loc_es.obj: loc_es.cpp loc2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -DLOCALE_NAME=es -o$*.obj loc2dat.cpp
loc_fi.obj: loc_fi.cpp loc2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -DLOCALE_NAME=fi -o$*.obj loc2dat.cpp
loc_fr.obj: loc_fr.cpp loc2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -DLOCALE_NAME=fr -o$*.obj loc2dat.cpp
loc_gb.obj: loc_gb.cpp loc2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -DLOCALE_NAME=gb -o$*.obj loc2dat.cpp
loc_it.obj: loc_it.cpp loc2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -DLOCALE_NAME=it -o$*.obj loc2dat.cpp
loc_mx.obj: loc_mx.cpp loc2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -DLOCALE_NAME=mx -o$*.obj loc2dat.cpp
loc_nl.obj: loc_nl.cpp loc2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -DLOCALE_NAME=nl -o$*.obj loc2dat.cpp
loc_no.obj: loc_no.cpp loc2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -DLOCALE_NAME=no -o$*.obj loc2dat.cpp
loc_se.obj: loc_se.cpp loc2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -DLOCALE_NAME=se -o$*.obj loc2dat.cpp
loc_us.obj: loc_us.cpp loc2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -DLOCALE_NAME=us -o$*.obj loc2dat.cpp

uloc2dat.obj: loc2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -o$*.obj loc2dat.cpp
loc_cn.obj: loc_cn.cpp loc2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -DLOCALE_NAME=cn -o$*.obj loc2dat.cpp
loc_gr.obj: loc_gr.cpp loc2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -DLOCALE_NAME=gr -o$*.obj loc2dat.cpp
loc_jp.obj: loc_jp.cpp loc2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -DLOCALE_NAME=jp -o$*.obj loc2dat.cpp
loc_kr.obj: loc_kr.cpp loc2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -DLOCALE_NAME=kr -o$*.obj loc2dat.cpp
loc_tw.obj: loc_tw.cpp loc2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -DLOCALE_NAME=tw -o$*.obj loc2dat.cpp

lang2dat.exe: lang2dat.obj \
	lang_ca.obj lang_da.obj lang_de.obj lang_en.obj lang_es.obj \
	lang_fi.obj lang_fr.obj lang_it.obj lang_nl.obj lang_no.obj \
	lang_sv.obj 
	$(LINK) $(DOS_LINK_OPTS) @&&!
$(DOS_OBJS)+lang2dat.obj \
+lang_ca.obj+lang_da.obj+lang_de.obj+lang_en.obj+lang_es.obj \
+lang_fi.obj+lang_fr.obj+lang_it.obj+lang_nl.obj+lang_no.obj \
+lang_sv.obj
$*, ,$(DOS_LIBS)
!

ulang2dat.exe: ulang2dat.obj \
	lang_el.obj lang_ja.obj lang_ko.obj
	$(LINK) $(DOS_LINK_OPTS) @&&!
$(DOS_OBJS)+ulang2dat.obj \
+lang_el.obj+lang_ja.obj+lang_ko.obj
$*, ,$(DOS_LIBS)
!

lang2dat.obj: lang2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -o$*.obj lang2dat.cpp
lang_ca.obj: lang_ca.cpp lang2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -DLANGUAGE_NAME=ca -o$*.obj lang2dat.cpp
lang_da.obj: lang_da.cpp lang2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -DLANGUAGE_NAME=da -o$*.obj lang2dat.cpp
lang_de.obj: lang_de.cpp lang2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -DLANGUAGE_NAME=de -o$*.obj lang2dat.cpp
lang_en.obj: lang_en.cpp lang2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -DLANGUAGE_NAME=en -o$*.obj lang2dat.cpp
lang_es.obj: lang_es.cpp lang2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -DLANGUAGE_NAME=es -o$*.obj lang2dat.cpp
lang_fi.obj: lang_fi.cpp lang2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -DLANGUAGE_NAME=fi -o$*.obj lang2dat.cpp
lang_fr.obj: lang_fr.cpp lang2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -DLANGUAGE_NAME=fr -o$*.obj lang2dat.cpp
lang_it.obj: lang_it.cpp lang2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -DLANGUAGE_NAME=it -o$*.obj lang2dat.cpp
lang_nl.obj: lang_nl.cpp lang2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -DLANGUAGE_NAME=nl -o$*.obj lang2dat.cpp
lang_no.obj: lang_no.cpp lang2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -DLANGUAGE_NAME=no -o$*.obj lang2dat.cpp
lang_sv.obj: lang_sv.cpp lang2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -DLANGUAGE_NAME=sv -o$*.obj lang2dat.cpp

ulang2dat.obj: lang2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -o$*.obj lang2dat.cpp
lang_el.obj: lang_el.cpp lang2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -DLANGUAGE_NAME=el -o$*.obj lang2dat.cpp
lang_ja.obj: lang_ja.cpp lang2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -DLANGUAGE_NAME=ja -o$*.obj lang2dat.cpp
lang_ko.obj: lang_ko.cpp lang2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -DLANGUAGE_NAME=ko -o$*.obj lang2dat.cpp

map2dat.exe: map2dat.obj \
	map437.obj map737.obj map850.obj map852.obj map855.obj map857.obj \
	map860.obj map861.obj map863.obj map865.obj map866.obj map869.obj \
	map1250.obj map1251.obj map1252.obj map1253.obj map1254.obj \
	map1255.obj map1256.obj mapmac.obj mapnext.obj
	$(LINK) $(DOS_LINK_OPTS) @&&!
$(DOS_OBJS)+map2dat.obj \
+map437.obj+map737.obj+map850.obj+map852.obj+map855.obj+map857.obj \
+map860.obj+map861.obj+map863.obj+map865.obj+map866.obj+map869.obj \
+map1250.obj+map1251.obj+map1252.obj+map1253.obj+map1254.obj \
+map1255.obj+map1256.obj+mapmac.obj+mapnext.obj
$*, ,$(DOS_LIBS)
!
 
map2dat.obj: map2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -o$*.obj map2dat.cpp
map437.obj: map437.cpp map2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -DMAP_NAME=437 -o$*.obj map2dat.cpp
map737.obj: map737.cpp map2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -DMAP_NAME=737 -o$*.obj map2dat.cpp
map850.obj: map850.cpp map2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -DMAP_NAME=850 -o$*.obj map2dat.cpp
map852.obj: map852.cpp map2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -DMAP_NAME=852 -o$*.obj map2dat.cpp
map855.obj: map855.cpp map2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -DMAP_NAME=855 -o$*.obj map2dat.cpp
map857.obj: map857.cpp map2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -DMAP_NAME=857 -o$*.obj map2dat.cpp
map860.obj: map860.cpp map2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -DMAP_NAME=860 -o$*.obj map2dat.cpp
map861.obj: map861.cpp map2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -DMAP_NAME=861 -o$*.obj map2dat.cpp
map863.obj: map863.cpp map2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -DMAP_NAME=863 -o$*.obj map2dat.cpp
map865.obj: map865.cpp map2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -DMAP_NAME=865 -o$*.obj map2dat.cpp
map866.obj: map866.cpp map2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -DMAP_NAME=866 -o$*.obj map2dat.cpp
map869.obj: map869.cpp map2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -DMAP_NAME=869 -o$*.obj map2dat.cpp
map1250.obj: map1250.cpp map2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -DMAP_NAME=1250 -o$*.obj map2dat.cpp
map1251.obj: map1251.cpp map2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -DMAP_NAME=1251 -o$*.obj map2dat.cpp
map1252.obj: map1252.cpp map2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -DMAP_NAME=1252 -o$*.obj map2dat.cpp
map1253.obj: map1253.cpp map2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -DMAP_NAME=1253 -o$*.obj map2dat.cpp
map1254.obj: map1254.cpp map2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -DMAP_NAME=1254 -o$*.obj map2dat.cpp
map1255.obj: map1255.cpp map2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -DMAP_NAME=1255 -o$*.obj map2dat.cpp
map1256.obj: map1256.cpp map2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -DMAP_NAME=1256 -o$*.obj map2dat.cpp
mapmac.obj: mapmac.cpp map2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -DMAP_NAME=MAC -o$*.obj map2dat.cpp
mapnext.obj: mapnext.cpp map2dat.cpp
	$(CPP) $(DOS_CPP_OPTS) -DMAP_NAME=NeXT -o$*.obj map2dat.cpp
