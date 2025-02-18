PROG = help

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
ZINC_XKEY_LIB = _xky_zil
ZINC_LIB_NAME = $(ZINC_MOTIF_LIB)
ZINC_LIB_PATH = $(ZINC_LIB_DIR)/lib$(ZINC_LIB_NAME).a
INCLUDE_DIR = -I/usr/include/X11R5 -I/usr/include/Motif1.2

LIBS = 
LIB_DIRS = -L/usr/lib/Motif1.2 -L/usr/lib/X11R5
RANLIB =
Z_INCLUDE_DIR = -I$(ZINC_INC_DIR) $(INCLUDE_DIR)
GUI_LIBS = -lXm -lXt -lX11
MODULE_LIBRARY = $(ZINC_LIB_DIR)/libZhelp.a
DESIGN_LIBS = $(MODULE_LIBRARY) -lZservice -lZdirect -lZstorage -lZstredit
Z_LIBS = $(DESIGN_LIBS) -l$(ZINC_LIB_NAME) $(GUI_LIBS) $(LIBS)
Z_LIB_DIRS = -L$(ZINC_LIB_DIR) $(LIB_DIRS)
LIBRARIAN = ar
UNIX_LIB_OPTS = r
INCLUDE_FILES = $(ZINC_INC_DIR)/help.hpp
DAT_FILE = $(ZINC_BIN_DIR)/p_help.znc

TARGET = motif
OBJS = main.o
LIB_OBJS = help_help.o help1.o import_help.o export_help.o
COLLISIONS = help_help$(CPP_EXTENSION) import_help$(CPP_EXTENSION) \
	export_help$(CPP_EXTENSION)

.SUFFIXES:
.SUFFIXES: .o $(CPP_EXTENSION)

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

$(DAT_FILE):p_help.dat
	cp $? $@
	chmod 666 $@

clean:
	-rm -f $(PROG) *.o $(MODULE_LIBRARY)
	-rm -f *_help$(CPP_EXTENSION)


#  These dependencies are for infantile compilers (like HP's) that won't
#  let you link in two libraries that have objects that came from source
#  files of the same name, eg: two libraries can't both have a z_win.cpp.
help_help$(CPP_EXTENSION): help$(CPP_EXTENSION)
	cp $? $@

import_help$(CPP_EXTENSION): import$(CPP_EXTENSION)
	cp $? $@

export_help$(CPP_EXTENSION): export$(CPP_EXTENSION)
	cp $? $@

