PROG = hello1 hello2 hello3 hellog

CC = CC
LINK = CC
CPP_EXTENSION = .cpp
CC_FLAGS = 
LINK_FLAGS = 
ZINC_INC_DIR = ../../include
ZINC_MOTIF_LIB = _mtf_zil
ZINC_CURSES_LIB = _crs_zil
ZINC_XKEY_LIB = _xky_zil
ZINC_LIB_NAME = $(ZINC_MOTIF_LIB)
ZINC_LIB_DIR = ../../lib
ZINC_LIB_PATH = $(ZINC_LIB_DIR)/lib$(ZINC_LIB_NAME).a
INCLUDE_DIR = -I/usr/include/X11R5 -I/usr/include/Motif1.2
LIBS = 
LIB_DIRS = -L/usr/lib/Motif1.2 -L/usr/lib/X11R5
Z_INCLUDE_DIR = -I$(ZINC_INC_DIR) $(INCLUDE_DIR)
GUI_LIBS = -lXm -lXt -lX11
Z_LIBS = -l$(ZINC_LIB_NAME) $(GUI_LIBS) $(LIBS)
Z_LIB_DIRS = -L$(ZINC_LIB_DIR) $(LIB_DIRS)
TARGET = motif

.SUFFIXES:
.SUFFIXES: .o $(CPP_EXTENSION)

$(CPP_EXTENSION).o:
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -c $<

$(TARGET): hello1 hello2 hello3 hellog

hello1: hello1.o $(ZINC_LIB_PATH)
	$(LINK) $(LINK_FLAGS) -o $@ $@.o $(Z_LIB_DIRS) $(Z_LIBS)

hello2: hello2.o $(ZINC_LIB_PATH)
	$(LINK) $(LINK_FLAGS) -o $@ $@.o $(Z_LIB_DIRS) $(Z_LIBS)

hello3: hello3.o hello.o $(ZINC_LIB_PATH)
	$(LINK) $(LINK_FLAGS) -o $@ $@.o hello.o $(Z_LIB_DIRS) $(Z_LIBS)

hellog: hellog.o $(ZINC_LIB_PATH)
	$(LINK) $(LINK_FLAGS) -o $@ $@.o $(Z_LIB_DIRS) $(Z_LIBS)

clean:
	-rm -f hello1 hello2 hello3 hellog *.o
