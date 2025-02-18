PROG = design

CC = CC
LINK = CC
CPP_EXTENSION = .cpp
CC_FLAGS = 
LINK_FLAGS = 
ZINC_INC_DIR = ../include
ZINC_LIB_DIR = ../lib
ZINC_BIN_DIR = ../bin
ZINC_MOTIF_LIB = _mtf_zil
ZINC_CURSES_LIB = _crs_zil
ZINC_LIB_NAME = $(ZINC_MOTIF_LIB)
ZINC_LIB_PATH = $(ZINC_LIB_DIR)/lib$(ZINC_LIB_NAME).a
INCLUDE_DIR = -I/usr/include/X11R5 -I/usr/include/Motif1.2

LIBS = 
LIB_DIRS = -L/usr/lib/Motif1.2 -L/usr/lib/X11R5
Z_INCLUDE_DIR = -I$(ZINC_INC_DIR) $(INCLUDE_DIR)
GUI_LIBS = -lXm -lXt -lX11
MODULE_LIBRARY = $(ZINC_LIB_DIR)/libZwindow.a
DESIGN_LIBS = $(MODULE_LIBRARY) -lZimage -lZhelp -lZmessage \
	-lZi18n -lZservice -lZdirect -lZstorage -lZstredit
Z_LIBS = $(DESIGN_LIBS) -l$(ZINC_LIB_NAME) $(GUI_LIBS) $(LIBS)
Z_LIB_DIRS = -L$(ZINC_LIB_DIR) $(LIB_DIRS)
LIBRARIAN = ar
UNIX_LIB_OPTS = r
INCLUDE_FILES = $(ZINC_INC_DIR)/window.hpp
DAT_FILE = $(ZINC_BIN_DIR)/p_window.znc

.SUFFIXES:
.SUFFIXES: .o $(CPP_EXTENSION)

TARGET = motif
OBJS = main.o

$(CPP_EXTENSION).o:
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -c $<

default: $(TARGET) $(PROG)

$(PROG): $(OBJS) $(ZINC_LIB_PATH) $(MODULE_LIBRARY) 
	$(LINK) $(LINK_FLAGS) -o $@ $(OBJS) $(Z_LIB_DIRS) $(Z_LIBS)

subprogs:
	(cd service; make $(SUBTARGET))
	(cd direct; make $(SUBTARGET))
	(cd storage; make $(SUBTARGET))
	(cd stredit; make $(SUBTARGET))
	(cd help; make $(SUBTARGET))
	(cd message; make $(SUBTARGET))
	(cd image; make $(SUBTARGET))
	(cd window; make $(SUBTARGET))
	(cd i18n; make $(SUBTARGET))
	(cd file; make $(SUBTARGET))

motif curses:
	make subprogs SUBTARGET=$@
	make $(PROG)
	-cp $(PROG) ../bin

clean:
	make subprogs SUBTARGET=$@
	-rm -f *.o $(PROG)
	-rm -f ../bin/*.z?? ../bin/$(PROG)
