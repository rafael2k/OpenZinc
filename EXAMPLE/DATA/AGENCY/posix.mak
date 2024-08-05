PROG = agency

CC = CC
LINK = CC
CPP_EXTENSION = .cpp
CC_FLAGS = 
LINK_FLAGS = 
ZINC_INC_DIR = ../../../include
ZINC_MOTIF_LIB = _mtf_zil
ZINC_CURSES_LIB = _crs_zil
ZINC_XKEY_LIB = _xky_zil
ZINC_LIB_NAME = $(ZINC_MOTIF_LIB)
ZINC_LIB_DIR = ../../../lib
ZINC_LIB_PATH = $(ZINC_LIB_DIR)/lib$(ZINC_LIB_NAME).a
INCLUDE_DIR = -I/usr/include/X11R5 -I/usr/include/Motif1.2
LIBS = 
LIB_DIRS = -L/usr/lib/Motif1.2 -L/usr/lib/X11R5
Z_INCLUDE_DIR = -I$(ZINC_INC_DIR) $(INCLUDE_DIR)
GUI_LIBS = -lXm -lXt -lX11
Z_LIBS = -l$(ZINC_LIB_NAME) $(GUI_LIBS) $(LIBS)
Z_LIB_DIRS = -L$(ZINC_LIB_DIR) $(LIB_DIRS)
TARGET = motif
OBJS = $(PROG).o

.SUFFIXES:
.SUFFIXES: .o $(CPP_EXTENSION)

$(CPP_EXTENSION).o:
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -c $<

$(TARGET): $(PROG)

$(PROG): $(OBJS) $(ZINC_LIB_PATH)
	$(LINK) $(LINK_FLAGS) -o $@ $(OBJS) $(Z_LIB_DIRS) $(Z_LIBS)

clean:
	-rm -f $(PROG) *.o
