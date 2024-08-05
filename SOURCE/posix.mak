CC = CC
LINK = CC
LIBRARIAN = ar
CPP_EXTENSION = .cpp
CC_FLAGS =
LINK_FLAGS =
AR_FLAGS = r
ZINC_INC_DIR = ../include
ZINC_MOTIF_LIB = _mtf_zil
ZINC_CURSES_LIB = _crs_zil
ZINC_XKEY_LIB = _xky_zil
ZINC_LIB_NAME = $(ZINC_MOTIF_LIB)
ZINC_LIB_DIR = ../lib
INCLUDE_DIR = -I/usr/include/X11R5 -I/usr/include/Motif1.2
LIBS =
LIB_DIRS = -L/usr/lib/Motif1.2 -L/usr/lib/X11R5
RANLIB =
Z_INCLUDE_DIR = -I$(ZINC_INC_DIR) $(INCLUDE_DIR)
GUI_LIBS = -lXm -lXt -lX11
Z_LIBS = -l$(ZINC_LIB_NAME) $(GUI_LIBS) $(LIBS)
Z_LIB_DIRS = -L$(ZINC_LIB_DIR) $(LIB_DIRS)
TARGET = motif

.SUFFIXES:
.SUFFIXES: .o $(CPP_EXTENSION)

$(CPP_EXTENSION).o:
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -c $<

## Library name:
LIB_NAME = $(ZINC_LIB_DIR)/lib$(ZINC_LIB_NAME).a

## Include files:
INCLUDE_FILES = $(ZINC_INC_DIR)/ui_env.hpp $(ZINC_INC_DIR)/ui_gen.hpp \
	$(ZINC_INC_DIR)/ui_dsp.hpp $(ZINC_INC_DIR)/ui_evt.hpp \
	$(ZINC_INC_DIR)/ui_map.hpp $(ZINC_INC_DIR)/ui_win.hpp

all: $(TARGET)

motif:	$(INCLUDE_FILES) $(LIB_NAME)

curses:	$(INCLUDE_FILES) $(LIB_NAME)

xkey:	$(INCLUDE_FILES) $(LIB_NAME)

COMMON_OBJS = \
	g_dsp.o g_event.o g_evt.o g_gen.o g_i18n.o g_jump.o g_mach.o \
	g_lang.o g_lang1.o g_loc.o g_loc1.o g_pnorm.o g_win.o \
	i_file.o i_map.o i_str1.o i_str2.o i_str3.o i_str4.o i_str5.o i_type.o \
	z_app.o z_bnum.o z_bnum1.o z_bnum2.o z_border.o z_button.o \
	z_combo.o z_cursor.o z_date.o z_date1.o z_decor.o \
	z_device.o z_dialog.o z_dsp.o z_error.o \
	z_error1.o z_event.o z_file.o z_fmtstr.o z_gmgr.o z_gmgr1.o z_gmgr2.o z_gmgr3.o \
	z_group.o z_help.o z_help1.o z_hlist.o z_i18n.o z_icon.o z_image.o z_int.o \
	z_intl.o z_lang.o z_list.o z_list1.o \
	z_locale.o z_map1.o z_map2.o z_max.o \
	z_min.o z_msgwin.o z_notebk.o z_path.o z_plldn.o z_plldn1.o \
	z_popup.o z_popup1.o z_stdarg.o z_printf.o \
	z_prompt.o z_real.o z_region.o z_sbar.o z_scanf.o z_scroll.o \
	z_spin.o z_stored.o z_storer.o z_storew.o \
	z_string.o z_sys.o z_table.o z_table1.o z_table2.o \
	z_tbar.o z_text.o z_time.o \
	z_time1.o z_timer.o z_title.o z_utils.o z_utime.o z_utime1.o z_vlist.o \
	z_win.o z_win1.o z_win2.o z_win3.o z_win4.o

$(ZINC_LIB_DIR)/lib$(ZINC_MOTIF_LIB).a: \
	$(COMMON_OBJS) \
	m_bitmap.o m_bnum.o m_border.o m_button.o m_combo.o m_cursor.o \
	m_date.o m_dsp.o m_error.o m_error1.o m_event.o m_fmtstr.o \
	m_group.o m_hlist.o m_icon.o m_image.o m_int.o m_intl.o m_keybrd.o \
	m_max.o m_min.o m_mouse.o m_notebk.o m_plldn.o m_plldn1.o \
	m_popup.o m_popup1.o m_print.o m_prompt.o m_real.o m_sbar.o \
	m_scroll.o m_spin.o m_string.o m_sys.o m_table.o m_table1.o \
	m_table2.o m_tbar.o m_text.o m_time.o m_title.o m_vlist.o \
	m_win.o m_win1.o m_win2.o
	$(LIBRARIAN) $(AR_FLAGS) $@ $?
	$(RANLIB)

$(ZINC_LIB_DIR)/lib$(ZINC_CURSES_LIB).a: \
	$(COMMON_OBJS) \
	d_bnum.o \
	d_border.o \
	d_button.o \
	d_combo.o \
	d_cursor.o \
	d_date.o \
	d_error.o \
	d_error1.o \
	d_event.o \
	d_fmtstr.o \
	d_group.o \
	d_hlist.o \
	d_icon.o \
	d_image.o \
	d_int.o \
	d_intl.o \
	d_keybrd.o \
	d_max.o \
	d_min.o \
	d_mouse.o \
	d_notebk.o \
	d_plldn.o \
	d_plldn1.o \
	d_popup.o \
	d_popup1.o \
	d_print.o \
	d_prompt.o \
	d_real.o \
	d_sbar.o \
	d_scroll.o \
	d_spin.o \
	d_string.o \
	d_sys.o \
	d_table.o \
	d_table1.o \
	d_table2.o \
	d_tbar.o \
	d_tdsp.o \
	d_text.o \
	d_time.o \
	d_title.o \
	d_vlist.o \
	d_win.o \
	d_win1.o \
	d_win2.o \
	i_curses.o
	$(LIBRARIAN) $(AR_FLAGS) $@ $?
	$(RANLIB)

$(ZINC_LIB_DIR)/lib$(ZINC_XKEY_LIB).a: \
	$(COMMON_OBJS) \
	d_border.o d_button.o d_combo.o d_cursor.o d_error.o d_error1.o \
	d_event.o d_fmtstr.o d_group.o d_hlist.o d_keybrd.o d_max.o d_min.o \
	d_notebk.o \
	d_plldn.o d_plldn1.o d_popup.o d_popup1.o d_prompt.o d_sbar.o d_scroll.o \
	d_spin.o d_string.o d_sys.o d_vlist.o d_table.o d_table1.o d_table2.o \
	d_tbar.o d_text.o d_title.o d_win.o d_win1.o d_win2.o \
	img_def.o i_xkey.o \
	x_bitmap.o x_dsp.o x_event.o x_icon.o x_image.o x_intl.o x_mouse.o \
	x_print.o
	$(LIBRARIAN) $(AR_FLAGS) $@ $?
	$(RANLIB)

test: updateIncludes test.o $(LIB_NAME)
	$(LINK) $(LINK_FLAGS) -o $@ test.o $(Z_LIB_DIRS) $(Z_LIBS)

$(INCLUDE_FILES):$$(@F)
	-rm -f $@
	cp $? $@
	chmod 644 $@

updateIncludes:
	-cp *.hpp ../include
	chmod +w ../include/*.hpp

clean:
	-rm -f $(LIB_NAME) *.o test

###
d_bnum.o: ui_win.hpp
d_border.o: ui_win.hpp
d_button.o: ui_win.hpp
d_combo.o: ui_win.hpp img_def.cpp
d_cursor.o: ui_evt.hpp
d_date.o: ui_win.hpp
d_error.o: ui_win.hpp
d_error1.o: ui_win.hpp
d_event.o: ui_evt.hpp
d_fmtstr.o: ui_win.hpp
d_group.o: ui_win.hpp
d_hlist.o: ui_win.hpp
d_icon.o: ui_win.hpp
d_image.o: ui_win.hpp
d_int.o: ui_win.hpp
d_intl.o: ui_gen.hpp
d_keybrd.o: ui_evt.hpp
d_max.o: ui_win.hpp
d_min.o: ui_win.hpp
d_mouse.o: ui_evt.hpp img_def.cpp
d_notebk.o: ui_win.hpp
d_plldn.o: ui_win.hpp
d_plldn1.o: ui_win.hpp
d_popup.o: ui_win.hpp
d_popup1.o: ui_win.hpp
d_print.o: ui_dsp.hpp
d_prompt.o: ui_win.hpp
d_real.o: ui_win.hpp
d_sbar.o: ui_win.hpp
d_scroll.o: ui_win.hpp img_def.cpp
d_spin.o: ui_win.hpp
d_string.o: ui_win.hpp
d_sys.o: ui_win.hpp
d_table.o: ui_win.hpp
d_table1.o: ui_win.hpp
d_table2.o: ui_win.hpp
d_tbar.o: ui_win.hpp
d_tdsp.o: ui_dsp.hpp
d_text.o: ui_win.hpp
d_time.o: ui_win.hpp
d_title.o: ui_win.hpp
d_vlist.o: ui_win.hpp
d_win.o: ui_win.hpp
d_win1.o: ui_win.hpp
d_win2.o: ui_win.hpp
g_dsp.o: ui_dsp.hpp
g_event.o: ui_win.hpp
g_evt.o: ui_evt.hpp
g_gen.o: ui_gen.hpp
g_i18n.o: loc_def.cpp
g_jump.o: ui_win.hpp
g_lang.o: ui_gen.hpp
g_lang1.o: ui_gen.hpp
g_loc.o: ui_gen.hpp
g_loc1.o: ui_gen.hpp
g_mach.o: ui_gen.hpp
g_pnorm.o: ui_win.hpp
g_win.o: ui_win.hpp
i_curses.o: ui_evt.hpp
i_file.o: ui_env.hpp ui_gen.hpp
i_map.o: ui_env.hpp ui_gen.hpp
i_str1.o: ui_env.hpp ui_gen.hpp
i_str2.o: ui_env.hpp ui_gen.hpp
i_str3.o: ui_env.hpp ui_gen.hpp
i_str4.o: ui_env.hpp ui_gen.hpp
i_str5.o: ui_env.hpp ui_gen.hpp
i_type.o: ui_env.hpp ui_gen.hpp
i_xkey.o: ui_evt.hpp
m_bitmap.o: ui_win.hpp
m_bnum.o: ui_win.hpp
m_border.o: ui_win.hpp
m_button.o: ui_win.hpp
m_combo.o: ui_win.hpp
m_cursor.o: ui_evt.hpp
m_date.o: ui_win.hpp
m_dsp.o: ui_dsp.hpp
m_error.o: ui_win.hpp
m_error1.o: ui_win.hpp
m_event.o: ui_evt.hpp
m_fmtstr.o: ui_win.hpp
m_group.o: ui_win.hpp
m_hlist.o: ui_win.hpp
m_icon.o: ui_win.hpp
m_image.o: ui_win.hpp
m_int.o: ui_win.hpp
m_intl.o: ui_gen.hpp
m_keybrd.o: ui_win.hpp
m_max.o: ui_win.hpp
m_min.o: ui_win.hpp
m_mouse.o: ui_win.hpp
m_notebk.o: ui_win.hpp
m_plldn.o: ui_win.hpp
m_plldn1.o: ui_win.hpp
m_popup.o: ui_win.hpp
m_popup1.o: ui_win.hpp
m_print.o: ui_dsp.hpp
m_prompt.o: ui_win.hpp
m_real.o: ui_win.hpp
m_sbar.o: ui_win.hpp
m_scroll.o: ui_win.hpp
m_spin.o: ui_win.hpp
m_string.o: ui_win.hpp
m_sys.o: ui_win.hpp
m_table.o: ui_win.hpp
m_table1.o: ui_win.hpp
m_table2.o: ui_win.hpp
m_tbar.o: ui_win.hpp
m_text.o: ui_win.hpp
m_time.o: ui_win.hpp
m_title.o: ui_win.hpp
m_vlist.o: ui_win.hpp
m_win.o: ui_win.hpp
m_win1.o: ui_win.hpp
m_win2.o: ui_win.hpp
x_bitmap.o: ui_win.hpp
x_dsp.o: ui_dsp.hpp
x_event.o: ui_evt.hpp
x_icon.o: ui_win.hpp
x_image.o: ui_win.hpp
x_intl.o: ui_gen.hpp
x_mouse.o: ui_win.hpp
x_print.o: ui_dsp.hpp
z_app.o: ui_win.hpp
z_bnum.o: ui_gen.hpp
z_bnum1.o: ui_gen.hpp
z_bnum2.o: ui_win.hpp lang_def.cpp
z_border.o: ui_win.hpp
z_button.o: ui_win.hpp img_def.cpp
z_combo.o: ui_win.hpp
z_cursor.o: ui_evt.hpp
z_date.o: ui_gen.hpp
z_date1.o: ui_win.hpp lang_def.cpp
z_decor.o: ui_gen.hpp img_def.cpp
z_device.o: ui_evt.hpp
z_dialog.o: ui_win.hpp
z_dsp.o: ui_dsp.hpp
z_dsp.o: ui_dsp.hpp
z_error.o: ui_win.hpp z_stdarg.hpp
z_error1.o: ui_win.hpp lang_def.cpp
z_event.o: ui_evt.hpp
z_file.o: ui_gen.hpp
z_fmtstr.o: ui_win.hpp
z_gmgr.o: ui_win.hpp
z_gmgr1.o: ui_win.hpp
z_gmgr2.o: ui_win.hpp
z_gmgr3.o: ui_win.hpp
z_group.o: ui_win.hpp
z_help.o: ui_win.hpp lang_def.cpp
z_help1.o: ui_win.hpp lang_def.cpp
z_hlist.o: ui_win.hpp
z_i18n.o: ui_gen.hpp
z_icon.o: ui_win.hpp
z_image.o: ui_win.hpp
z_int.o: ui_win.hpp lang_def.cpp
z_intl.o: ui_dsp.hpp
z_lang.o: ui_gen.hpp lang_def.cpp
z_list.o: ui_gen.hpp
z_list1.o: ui_gen.hpp
z_locale.o: ui_gen.hpp
z_map1.o: ui_win.hpp
z_map2.o: ui_win.hpp
z_max.o: ui_win.hpp img_def.cpp
z_min.o: ui_win.hpp img_def.cpp
z_msgwin.o: z_stdarg.hpp lang_def.cpp
z_notebk.o: ui_win.hpp
z_path.o: ui_gen.hpp
z_plldn.o: ui_win.hpp
z_plldn1.o: ui_win.hpp
z_popup.o: ui_win.hpp
z_popup1.o: ui_win.hpp img_def.cpp
z_printf.o: ui_gen.hpp z_stdarg.hpp
z_prompt.o: ui_win.hpp
z_real.o: ui_win.hpp lang_def.cpp
z_region.o: ui_dsp.hpp
z_sbar.o: ui_win.hpp
z_scanf.o: ui_gen.hpp z_stdarg.hpp
z_scroll.o: ui_win.hpp
z_spin.o: ui_win.hpp img_def.cpp
z_stdarg.o: ui_gen.hpp z_stdarg.hpp
z_stored.o: ui_gen.hpp
z_storer.o: ui_gen.hpp z_store.hpp
z_storew.o: ui_gen.hpp z_store.hpp
z_string.o: ui_win.hpp
z_sys.o: ui_win.hpp lang_def.cpp img_def.cpp
z_table.o: ui_win.hpp
z_table1.o: ui_win.hpp
z_table2.o: ui_win.hpp
z_tbar.o: ui_win.hpp
z_text.o: ui_win.hpp
z_time.o: ui_gen.hpp
z_timer.o: ui_win.hpp
z_time1.o: ui_win.hpp lang_def.cpp
z_title.o: ui_win.hpp
z_utils.o: ui_gen.hpp
z_utime.o: ui_gen.hpp lang_def.cpp
z_utime1.o: ui_gen.hpp
z_vlist.o: ui_win.hpp
z_win.o: ui_win.hpp
z_win1.o: ui_win.hpp lang_def.cpp
z_win2.o: ui_win.hpp
z_win3.o: ui_win.hpp
z_win4.o: ui_win.hpp
test.o: ui_win.hpp
