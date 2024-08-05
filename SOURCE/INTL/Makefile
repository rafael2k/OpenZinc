# INTERNATIONAL utilities makefile
PROG = loc2dat lang2dat map2dat

CC = g++
LINK = g++
CPP_EXTENSION = .cpp
CC_FLAGS = -fno-enforce-eh-specs -fno-rtti
LINK_FLAGS = 
ZINC_INC_DIR = ../../include
ZINC_MOTIF_LIB = _mtf_zil
ZINC_CURSES_LIB = _crs_zil
ZINC_LIB_NAME = $(ZINC_MOTIF_LIB)
ZINC_LIB_DIR = ../../lib
ZINC_LIB_PATH = $(ZINC_LIB_DIR)/lib$(ZINC_LIB_NAME).a
INCLUDE_DIR = 
LIBS = -lm
LIB_DIRS = -L/usr/X11R6/lib -L/usr/lib -L/usr/lib/gcc-lib/i386-redhat-linux/3.2.2
Z_INCLUDE_DIR = -I$(ZINC_INC_DIR) $(INCLUDE_DIR)
GUI_LIBS = -lXm -lXt -lX11 -lMrm -lXpm -lXext
Z_LIBS = -l$(ZINC_LIB_NAME) $(GUI_LIBS) $(LIBS)
Z_LIB_DIRS = -L$(ZINC_LIB_DIR) $(LIB_DIRS)
RS6000 = -qlanglvl=compat
TARGET = motif

.SUFFIXES:
.SUFFIXES: .o $(CPP_EXTENSION)

$(CPP_EXTENSION).o:
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -c $<

$(TARGET): $(PROG)

motifu: uloc2dat ulang2dat

LOC2DAT_OBJS = loc2dat_at.o loc2dat_ca.o loc2dat_cafr.o loc2dat_de.o \
	loc2dat_dk.o loc2dat_es.o loc2dat_fi.o loc2dat_fr.o loc2dat_gb.o \
	loc2dat_it.o loc2dat_mx.o loc2dat_nl.o loc2dat_no.o loc2dat_se.o \
	loc2dat_us.o loc2dat.o

loc2dat: $(LOC2DAT_OBJS) $(ZINC_LIB_PATH)
	$(LINK) $(LINK_FLAGS) -o loc2dat $(LOC2DAT_OBJS) $(Z_LIB_DIRS) $(Z_LIBS)

LANG2DAT_OBJS = lang2dat_ca.o lang2dat_da.o lang2dat_de.o lang2dat_en.o \
	lang2dat_es.o lang2dat_fi.o lang2dat_fr.o lang2dat_it.o lang2dat_nl.o \
	lang2dat_no.o lang2dat_sv.o lang2dat.o

lang2dat: $(LANG2DAT_OBJS) $(ZINC_LIB_PATH)
	$(LINK) $(LINK_FLAGS) -o lang2dat $(LANG2DAT_OBJS) $(Z_LIB_DIRS) $(Z_LIBS)

ULOC2DAT_OBJS: loc2dat_cn.o loc2dat_gr.o loc2dat_jp.o loc2dat_kr.o \
	loc2dat_tw.o loc2dat.o

uloc2dat: $(ULOC2DAT_OBJS) $(ZINC_LIB_PATH)
	$(LINK) $(LINK_FLAGS) -o uloc2dat $(ULOC2DAT_OBJS) $(Z_LIB_DIRS) $(Z_LIBS)

ULANG2DAT_OBJS: lang2dat_el.o lang2dat_ja.o lang2dat_ko.o lang2dat.o

ulang2dat: $(ULANG2DAT_OBJS) $(ZINC_LIB_PATH)
	$(LINK) $(LINK_FLAGS) -o ulang2dat $(ULANG2DAT_OBJS) $(Z_LIB_DIRS) $(Z_LIBS)

MAP2DAT_OBJS = map2dat_437.o map2dat_737.o map2dat_850.o map2dat_852.o \
	map2dat_855.o map2dat_857.o map2dat_860.o map2dat_861.o map2dat_863.o \
	map2dat_865.o map2dat_866.o map2dat_869.o map2dat_1250.o map2dat_1251.o \
	map2dat_1252.o map2dat_1253.o map2dat_1254.o map2dat_1255.o map2dat_1256.o \
	map2dat_mac.o map2dat_next.o map2dat.o

map2dat: $(MAP2DAT_OBJS) $(ZINC_LIB_PATH)
	$(LINK) $(LINK_FLAGS) -o map2dat $(MAP2DAT_OBJS) $(Z_LIB_DIRS) $(Z_LIBS)
 
clean:
	-rm -f $(PROG) uloc2dat ulang2dat loc2dat_* lang2dat_* map2dat_* *.o

# Build the locale specific map tables.
loc2dat.o: loc2dat$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -c $<
loc2dat_at.o: loc_at.cpp loc2dat$(CPP_EXTENSION)
	cp loc2dat$(CPP_EXTENSION) loc2dat_at$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -DLOCALE_NAME=at -c loc2dat_at$(CPP_EXTENSION)
loc2dat_ca.o: loc_ca.cpp loc2dat$(CPP_EXTENSION)
	cp loc2dat$(CPP_EXTENSION) loc2dat_ca$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -DLOCALE_NAME=ca -c loc2dat_ca$(CPP_EXTENSION)
loc2dat_cafr.o: loc_cafr.cpp loc2dat$(CPP_EXTENSION)
	cp loc2dat$(CPP_EXTENSION) loc2dat_cafr$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -DLOCALE_NAME=cafr -c loc2dat_cafr$(CPP_EXTENSION)
loc2dat_de.o: loc_de.cpp loc2dat$(CPP_EXTENSION)
	cp loc2dat$(CPP_EXTENSION) loc2dat_de$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -DLOCALE_NAME=de -c loc2dat_de$(CPP_EXTENSION)
loc2dat_dk.o: loc_dk.cpp loc2dat$(CPP_EXTENSION)
	cp loc2dat$(CPP_EXTENSION) loc2dat_dk$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -DLOCALE_NAME=dk -c loc2dat_dk$(CPP_EXTENSION)
loc2dat_es.o: loc_es.cpp loc2dat$(CPP_EXTENSION)
	cp loc2dat$(CPP_EXTENSION) loc2dat_es$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -DLOCALE_NAME=es -c loc2dat_es$(CPP_EXTENSION)
loc2dat_fi.o: loc_fi.cpp loc2dat$(CPP_EXTENSION)
	cp loc2dat$(CPP_EXTENSION) loc2dat_fi$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -DLOCALE_NAME=fi -c loc2dat_fi$(CPP_EXTENSION)
loc2dat_fr.o: loc_fr.cpp loc2dat$(CPP_EXTENSION)
	cp loc2dat$(CPP_EXTENSION) loc2dat_fr$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -DLOCALE_NAME=fr -c loc2dat_fr$(CPP_EXTENSION)
loc2dat_gb.o: loc_gb.cpp loc2dat$(CPP_EXTENSION)
	cp loc2dat$(CPP_EXTENSION) loc2dat_gb$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -DLOCALE_NAME=gb -c loc2dat_gb$(CPP_EXTENSION)
loc2dat_it.o: loc_it.cpp loc2dat$(CPP_EXTENSION)
	cp loc2dat$(CPP_EXTENSION) loc2dat_it$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -DLOCALE_NAME=it -c loc2dat_it$(CPP_EXTENSION)
loc2dat_mx.o: loc_mx.cpp loc2dat$(CPP_EXTENSION)
	cp loc2dat$(CPP_EXTENSION) loc2dat_mx$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -DLOCALE_NAME=mx -c loc2dat_mx$(CPP_EXTENSION)
loc2dat_nl.o: loc_nl.cpp loc2dat$(CPP_EXTENSION)
	cp loc2dat$(CPP_EXTENSION) loc2dat_nl$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -DLOCALE_NAME=nl -c loc2dat_nl$(CPP_EXTENSION)
loc2dat_no.o: loc_no.cpp loc2dat$(CPP_EXTENSION)
	cp loc2dat$(CPP_EXTENSION) loc2dat_no$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -DLOCALE_NAME=no -c loc2dat_no$(CPP_EXTENSION)
loc2dat_se.o: loc_se.cpp loc2dat$(CPP_EXTENSION)
	cp loc2dat$(CPP_EXTENSION) loc2dat_se$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -DLOCALE_NAME=se -c loc2dat_se$(CPP_EXTENSION)
loc2dat_us.o: loc_us.cpp loc2dat$(CPP_EXTENSION)
	cp loc2dat$(CPP_EXTENSION) loc2dat_us$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -DLOCALE_NAME=us -c loc2dat_us$(CPP_EXTENSION)

# Build the locale specific map tables for Unicode
uloc2dat.o: loc2dat$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -c $<
loc2dat_cn.o: loc_cn.cpp loc2dat$(CPP_EXTENSION)
	cp loc2dat$(CPP_EXTENSION) loc2dat_cn$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -DLOCALE_NAME=cn -c loc2dat_cn$(CPP_EXTENSION)
loc2dat_gr.o: loc_gr.cpp loc2dat$(CPP_EXTENSION)
	cp loc2dat$(CPP_EXTENSION) loc2dat_gr$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -DLOCALE_NAME=gr -c loc2dat_gr$(CPP_EXTENSION)
loc2dat_jp.o: loc_jp.cpp loc2dat$(CPP_EXTENSION)
	cp loc2dat$(CPP_EXTENSION) loc2dat_jp$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -DLOCALE_NAME=jp -c loc2dat_jp$(CPP_EXTENSION)
loc2dat_kr.o: loc_kr.cpp loc2dat$(CPP_EXTENSION)
	cp loc2dat$(CPP_EXTENSION) loc2dat_kr$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -DLOCALE_NAME=kr -c loc2dat_kr$(CPP_EXTENSION)
loc2dat_tw.o: loc_tw.cpp loc2dat$(CPP_EXTENSION)
	cp loc2dat$(CPP_EXTENSION) loc2dat_tw$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -DLOCALE_NAME=tw -c loc2dat_tw$(CPP_EXTENSION)

# Build the language specific map tables
lang2dat.o: lang2dat$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -c $<
lang2dat_ca.o: lang_ca.cpp lang2dat$(CPP_EXTENSION)
	cp lang2dat$(CPP_EXTENSION) lang2dat_ca$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -DLANGUAGE_NAME=ca -c lang2dat_ca$(CPP_EXTENSION)
lang2dat_da.o: lang_da.cpp lang2dat$(CPP_EXTENSION)
	cp lang2dat$(CPP_EXTENSION) lang2dat_da$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -DLANGUAGE_NAME=da -c lang2dat_da$(CPP_EXTENSION)
lang2dat_de.o: lang_de.cpp lang2dat$(CPP_EXTENSION)
	cp lang2dat$(CPP_EXTENSION) lang2dat_de$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -DLANGUAGE_NAME=de -c lang2dat_de$(CPP_EXTENSION)
lang2dat_en.o: lang_en.cpp lang2dat$(CPP_EXTENSION)
	cp lang2dat$(CPP_EXTENSION) lang2dat_en$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -DLANGUAGE_NAME=en -c lang2dat_en$(CPP_EXTENSION)
lang2dat_es.o: lang_es.cpp lang2dat$(CPP_EXTENSION)
	cp lang2dat$(CPP_EXTENSION) lang2dat_es$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -DLANGUAGE_NAME=es -c lang2dat_es$(CPP_EXTENSION)
lang2dat_fi.o: lang_fi.cpp lang2dat$(CPP_EXTENSION)
	cp lang2dat$(CPP_EXTENSION) lang2dat_fi$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -DLANGUAGE_NAME=fi -c lang2dat_fi$(CPP_EXTENSION)
lang2dat_fr.o: lang_fr.cpp lang2dat$(CPP_EXTENSION)
	cp lang2dat$(CPP_EXTENSION) lang2dat_fr$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -DLANGUAGE_NAME=fr -c lang2dat_fr$(CPP_EXTENSION)
lang2dat_it.o: lang_it.cpp lang2dat$(CPP_EXTENSION)
	cp lang2dat$(CPP_EXTENSION) lang2dat_it$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -DLANGUAGE_NAME=it -c lang2dat_it$(CPP_EXTENSION)
lang2dat_nl.o: lang_nl.cpp lang2dat$(CPP_EXTENSION)
	cp lang2dat$(CPP_EXTENSION) lang2dat_nl$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -DLANGUAGE_NAME=nl -c lang2dat_nl$(CPP_EXTENSION)
lang2dat_no.o: lang_no.cpp lang2dat$(CPP_EXTENSION)
	cp lang2dat$(CPP_EXTENSION) lang2dat_no$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -DLANGUAGE_NAME=no -c lang2dat_no$(CPP_EXTENSION)
lang2dat_sv.o: lang_sv.cpp lang2dat$(CPP_EXTENSION)
	cp lang2dat$(CPP_EXTENSION) lang2dat_sv$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -DLANGUAGE_NAME=sv -c lang2dat_sv$(CPP_EXTENSION)

# Build the language specific map tables for Unicode
ulang2dat.o: lang2dat$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -c $<
lang2dat_el.o: lang_el.cpp lang2dat$(CPP_EXTENSION)
	cp lang2dat$(CPP_EXTENSION) lang2dat_el$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -DLANGUAGE_NAME=el -c lang2dat_el$(CPP_EXTENSION)
lang2dat_ja.o: lang_ja.cpp lang2dat$(CPP_EXTENSION)
	cp lang2dat$(CPP_EXTENSION) lang2dat_ja$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -DLANGUAGE_NAME=ja -c lang2dat_ja$(CPP_EXTENSION)
lang2dat_ko.o: lang_ko.cpp lang2dat$(CPP_EXTENSION)
	cp lang2dat$(CPP_EXTENSION) lang2dat_ko$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -DLANGUAGE_NAME=ko -c lang2dat_ko$(CPP_EXTENSION)

# Build the general character mapping tables
map2dat.o: map2dat$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -c $<
map2dat_437.o: map437.cpp map2dat$(CPP_EXTENSION)
	cp map2dat$(CPP_EXTENSION) map2dat_437$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -DMAP_NAME=437 -c map2dat_437$(CPP_EXTENSION)
map2dat_737.o: map737.cpp map2dat$(CPP_EXTENSION)
	cp map2dat$(CPP_EXTENSION) map2dat_737$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -DMAP_NAME=737 -c map2dat_737$(CPP_EXTENSION)
map2dat_850.o: map850.cpp map2dat$(CPP_EXTENSION)
	cp map2dat$(CPP_EXTENSION) map2dat_850$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -DMAP_NAME=850 -c map2dat_850$(CPP_EXTENSION)
map2dat_852.o: map852.cpp map2dat$(CPP_EXTENSION)
	cp map2dat$(CPP_EXTENSION) map2dat_852$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -DMAP_NAME=852 -c map2dat_852$(CPP_EXTENSION)
map2dat_855.o: map855.cpp map2dat$(CPP_EXTENSION)
	cp map2dat$(CPP_EXTENSION) map2dat_855$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -DMAP_NAME=855 -c map2dat_855$(CPP_EXTENSION)
map2dat_857.o: map857.cpp map2dat$(CPP_EXTENSION)
	cp map2dat$(CPP_EXTENSION) map2dat_857$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -DMAP_NAME=857 -c map2dat_857$(CPP_EXTENSION)
map2dat_860.o: map860.cpp map2dat$(CPP_EXTENSION)
	cp map2dat$(CPP_EXTENSION) map2dat_860$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -DMAP_NAME=860 -c map2dat_860$(CPP_EXTENSION)
map2dat_861.o: map861.cpp map2dat$(CPP_EXTENSION)
	cp map2dat$(CPP_EXTENSION) map2dat_861$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -DMAP_NAME=861 -c map2dat_861$(CPP_EXTENSION)
map2dat_863.o: map863.cpp map2dat$(CPP_EXTENSION)
	cp map2dat$(CPP_EXTENSION) map2dat_863$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -DMAP_NAME=863 -c map2dat_863$(CPP_EXTENSION)
map2dat_865.o: map865.cpp map2dat$(CPP_EXTENSION)
	cp map2dat$(CPP_EXTENSION) map2dat_865$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -DMAP_NAME=865 -c map2dat_865$(CPP_EXTENSION)
map2dat_866.o: map866.cpp map2dat$(CPP_EXTENSION)
	cp map2dat$(CPP_EXTENSION) map2dat_866$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -DMAP_NAME=866 -c map2dat_866$(CPP_EXTENSION)
map2dat_869.o: map869.cpp map2dat$(CPP_EXTENSION)
	cp map2dat$(CPP_EXTENSION) map2dat_869$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -DMAP_NAME=869 -c map2dat_869$(CPP_EXTENSION)
map2dat_1250.o: map1250.cpp map2dat$(CPP_EXTENSION)
	cp map2dat$(CPP_EXTENSION) map2dat_1250$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -DMAP_NAME=1250 -c map2dat_1250$(CPP_EXTENSION)
map2dat_1251.o: map1251.cpp map2dat$(CPP_EXTENSION)
	cp map2dat$(CPP_EXTENSION) map2dat_1251$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -DMAP_NAME=1251 -c map2dat_1251$(CPP_EXTENSION)
map2dat_1252.o: map1252.cpp map2dat$(CPP_EXTENSION)
	cp map2dat$(CPP_EXTENSION) map2dat_1252$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -DMAP_NAME=1252 -c map2dat_1252$(CPP_EXTENSION)
map2dat_1253.o: map1253.cpp map2dat$(CPP_EXTENSION)
	cp map2dat$(CPP_EXTENSION) map2dat_1253$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -DMAP_NAME=1253 -c map2dat_1253$(CPP_EXTENSION)
map2dat_1254.o: map1254.cpp map2dat$(CPP_EXTENSION)
	cp map2dat$(CPP_EXTENSION) map2dat_1254$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -DMAP_NAME=1254 -c map2dat_1254$(CPP_EXTENSION)
map2dat_1255.o: map1255.cpp map2dat$(CPP_EXTENSION)
	cp map2dat$(CPP_EXTENSION) map2dat_1255$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -DMAP_NAME=1255 -c map2dat_1255$(CPP_EXTENSION)
map2dat_1256.o: map1256.cpp map2dat$(CPP_EXTENSION)
	cp map2dat$(CPP_EXTENSION) map2dat_1256$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -DMAP_NAME=1256 -c map2dat_1256$(CPP_EXTENSION)
map2dat_mac.o: mapmac.cpp map2dat$(CPP_EXTENSION)
	cp map2dat$(CPP_EXTENSION) map2dat_mac$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -DMAP_NAME=MAC -c map2dat_mac$(CPP_EXTENSION)
map2dat_next.o: mapnext.cpp map2dat$(CPP_EXTENSION)
	cp map2dat$(CPP_EXTENSION) map2dat_next$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -DMAP_NAME=NeXT -c map2dat_next$(CPP_EXTENSION)

