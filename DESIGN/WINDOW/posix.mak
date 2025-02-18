PROG = winedit

CC = CC
LINK = CC
CPP_EXTENSION = .cpp
CC_FLAGS = 
LINK_FLAGS = 
ZINC_INC_DIR = ../../include
ZINC_LIB_DIR = ../../lib
ZINC_BIN_DIR = ../../bin
ZINC_MOTIF_LIB = _mtf_zil
ZINC_CURSES_LIB = _crs_zil
ZINC_LIB_NAME = $(ZINC_MOTIF_LIB)
ZINC_LIB_PATH = $(ZINC_LIB_DIR)/lib$(ZINC_LIB_NAME).a
INCLUDE_DIR = -I/usr/include/X11R5 -I/usr/include/Motif1.2

LIBS = 
LIB_DIRS = -L/usr/lib/Motif1.2 -L/usr/lib/X11R5
RANLIB =
Z_INCLUDE_DIR = -I$(ZINC_INC_DIR) $(INCLUDE_DIR)
GUI_LIBS = -lXm -lXt -lX11
MODULE_LIBRARY = $(ZINC_LIB_DIR)/libZwindow.a
DESIGN_LIBS = $(MODULE_LIBRARY) -lZimage -lZhelp -lZmessage \
	-lZservice -lZdirect -lZstorage -lZstredit
Z_LIBS = $(DESIGN_LIBS) -l$(ZINC_LIB_NAME) $(GUI_LIBS) $(LIBS)
Z_LIB_DIRS = -L$(ZINC_LIB_DIR) $(LIB_DIRS)
LIBRARIAN = ar
UNIX_LIB_OPTS = r
INCLUDE_FILES = $(ZINC_INC_DIR)/window.hpp
DAT_FILE = $(ZINC_BIN_DIR)/p_window.znc

TARGET = motif
OBJS = main.o
LIB_OBJS = advanced.o derive.o export_des.o geometry.o \
	group.o import_des.o main.o object.o position.o prefer_des.o \
	window.o window1.o z_bnum_des.o z_border_des.o z_button_des.o \
	z_combo_des.o z_date_des.o z_fmtstr_des.o z_gmgr_des.o z_group_des.o \
	z_hlist_des.o z_icon_des.o z_int_des.o z_max_des.o \
	z_min_des.o z_notebk_des.o z_obj.o z_plldn_des.o \
	z_plldn1_des.o z_popup_des.o z_popup1_des.o z_prompt_des.o z_real_des.o \
	z_sbar_des.o z_scroll_des.o z_spin_des.o z_string_des.o z_sys_des.o \
	z_table_des.o z_tbar_des.o z_text_des.o \
	z_time_des.o z_title_des.o z_vlist_des.o z_win_des.o 

.SUFFIXES:
.SUFFIXES: .o $(CPP_EXTENSION)
COLLISIONS = \
	export_des$(CPP_EXTENSION) import_des$(CPP_EXTENSION) \
	prefer_des$(CPP_EXTENSION) z_bnum_des$(CPP_EXTENSION) \
	z_border_des$(CPP_EXTENSION) z_button_des$(CPP_EXTENSION) \
	z_combo_des$(CPP_EXTENSION) z_date_des$(CPP_EXTENSION) \
	z_fmtstr_des$(CPP_EXTENSION) \
	z_gmgr_des$(CPP_EXTENSION) z_group_des$(CPP_EXTENSION) z_hlist_des$(CPP_EXTENSION) \
	z_icon_des$(CPP_EXTENSION) z_int_des$(CPP_EXTENSION) \
	z_max_des$(CPP_EXTENSION) z_min_des$(CPP_EXTENSION) z_notebk_des$(CPP_EXTENSION) \
	z_plldn_des$(CPP_EXTENSION) z_plldn1_des$(CPP_EXTENSION) \
	z_popup_des$(CPP_EXTENSION) z_popup1_des$(CPP_EXTENSION) \
	z_prompt_des$(CPP_EXTENSION) z_real_des$(CPP_EXTENSION) \
	z_sbar_des$(CPP_EXTENSION) z_scroll_des$(CPP_EXTENSION) \
	z_spin_des$(CPP_EXTENSION) z_string_des$(CPP_EXTENSION) z_sys_des$(CPP_EXTENSION) \
	z_table_des$(CPP_EXTENSION) z_tbar_des$(CPP_EXTENSION) \
	z_text_des$(CPP_EXTENSION) z_time_des$(CPP_EXTENSION) \
	z_title_des$(CPP_EXTENSION) z_vlist_des$(CPP_EXTENSION) \
	z_win_des$(CPP_EXTENSION)

$(CPP_EXTENSION).o:
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -c $<

$(TARGET): $(COLLISIONS) $(INCLUDE_FILES) $(DAT_FILE) $(MODULE_LIBRARY)

$(PROG): $(OBJS) $(ZINC_LIB_PATH) $(MODULE_LIBRARY) 
	$(LINK) $(LINK_FLAGS) -o $@ $(OBJS) $(Z_LIB_DIRS) $(Z_LIBS)

$(MODULE_LIBRARY): $(LIB_OBJS)
	$(LIBRARIAN) $(UNIX_LIB_OPTS) $@ $?
	$(RANLIB)

$(INCLUDE_FILES):$$(@F)
	-rm -f $@
	cp $? $@
	chmod 644 $@

$(DAT_FILE):p_window.dat
	cp $? $@
	chmod 666 $@

clean:
	-rm -f $(PROG) *.o $(MODULE_LIBRARY)
	-rm -f *_des$(CPP_EXTENSION)


#  These dependencies are for infantile compilers (like HP's) that won't
#  let you link in two libraries that have objects that came from source
#  files of the same name, eg: two libraries can't both have a z_win.cpp.
export_des$(CPP_EXTENSION): export$(CPP_EXTENSION)
	cp $? $@

import_des$(CPP_EXTENSION): import$(CPP_EXTENSION)
	cp $? $@

prefer_des$(CPP_EXTENSION): prefer$(CPP_EXTENSION)
	cp $? $@

z_border_des$(CPP_EXTENSION): z_border$(CPP_EXTENSION)
	cp $? $@

z_bnum_des$(CPP_EXTENSION): z_bnum$(CPP_EXTENSION)
	cp $? $@

z_button_des$(CPP_EXTENSION): z_button$(CPP_EXTENSION)
	cp $? $@

z_combo_des$(CPP_EXTENSION): z_combo$(CPP_EXTENSION)
	cp $? $@

z_date_des$(CPP_EXTENSION): z_date$(CPP_EXTENSION)
	cp $? $@

z_fmtstr_des$(CPP_EXTENSION): z_fmtstr$(CPP_EXTENSION)
	cp $? $@

z_gmgr_des$(CPP_EXTENSION): z_gmgr$(CPP_EXTENSION)
	cp $? $@

z_group_des$(CPP_EXTENSION): z_group$(CPP_EXTENSION)
	cp $? $@

z_hlist_des$(CPP_EXTENSION): z_hlist$(CPP_EXTENSION)
	cp $? $@

z_icon_des$(CPP_EXTENSION): z_icon$(CPP_EXTENSION)
	cp $? $@

z_int_des$(CPP_EXTENSION): z_int$(CPP_EXTENSION)
	cp $? $@

z_max_des$(CPP_EXTENSION): z_max$(CPP_EXTENSION)
	cp $? $@

z_min_des$(CPP_EXTENSION): z_min$(CPP_EXTENSION)
	cp $? $@

z_notebk_des$(CPP_EXTENSION): z_notebk$(CPP_EXTENSION)
	cp $? $@

z_plldn_des$(CPP_EXTENSION): z_plldn$(CPP_EXTENSION)
	cp $? $@

z_plldn1_des$(CPP_EXTENSION): z_plldn1$(CPP_EXTENSION)
	cp $? $@

z_popup_des$(CPP_EXTENSION): z_popup$(CPP_EXTENSION)
	cp $? $@

z_popup1_des$(CPP_EXTENSION): z_popup1$(CPP_EXTENSION)
	cp $? $@

z_prompt_des$(CPP_EXTENSION): z_prompt$(CPP_EXTENSION)
	cp $? $@

z_real_des$(CPP_EXTENSION): z_real$(CPP_EXTENSION)
	cp $? $@

z_sbar_des$(CPP_EXTENSION): z_sbar$(CPP_EXTENSION)
	cp $? $@

z_scroll_des$(CPP_EXTENSION): z_scroll$(CPP_EXTENSION)
	cp $? $@

z_spin_des$(CPP_EXTENSION): z_spin$(CPP_EXTENSION)
	cp $? $@

z_string_des$(CPP_EXTENSION): z_string$(CPP_EXTENSION)
	cp $? $@

z_sys_des$(CPP_EXTENSION): z_sys$(CPP_EXTENSION)
	cp $? $@

z_table_des$(CPP_EXTENSION): z_table$(CPP_EXTENSION)
	cp $? $@

z_tbar_des$(CPP_EXTENSION): z_tbar$(CPP_EXTENSION)
	cp $? $@

z_text_des$(CPP_EXTENSION): z_text$(CPP_EXTENSION)
	cp $? $@

z_time_des$(CPP_EXTENSION): z_time$(CPP_EXTENSION)
	cp $? $@

z_title_des$(CPP_EXTENSION): z_title$(CPP_EXTENSION)
	cp $? $@

z_vlist_des$(CPP_EXTENSION): z_vlist$(CPP_EXTENSION)
	cp $? $@

z_win_des$(CPP_EXTENSION): z_win$(CPP_EXTENSION)
	cp $? $@
