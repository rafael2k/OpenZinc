PROG = intrpol1 intrpol2 

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
NO_GUI_LIBS = -l$(ZINC_LIB_NAME) $(LIBS)
Z_LIB_DIRS = -L$(ZINC_LIB_DIR) $(LIB_DIRS)
TARGET = motif
RS6000 = -qlanglvl=compat
SYSTEM = $(HP)

.SUFFIXES:
.SUFFIXES: .o .c $(CPP_EXTENSION)

$(CPP_EXTENSION).o:
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -c $<

.c.o:
	cc $(CC_FLAGS) $(Z_INCLUDE_DIR) -c $<

$(TARGET): intrpol1 intrpol2 

intrpol1: intrpol1.o ipolwin1.o $(ZINC_LIB_PATH)
	$(LINK) $(LINK_FLAGS) -o $@ intrpol1.o ipolwin1.o $(Z_LIB_DIRS) $(Z_LIBS)

intrpol2: intrpol2.o ipolwin2.o $(ZINC_LIB_PATH)
	$(LINK) $(LINK_FLAGS) -o $@ intrpol2.o ipolwin2.o $(Z_LIB_DIRS) $(Z_LIBS)

clean:
	-rm -f $(PROG) *.o
