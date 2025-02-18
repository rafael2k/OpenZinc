PROG = movie movie1 movie2 movie3 movie4 movie5 movie6 movie7

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

$(TARGET): movie movie1 movie2 movie3 movie4 movie5 movie6 movie7

movie: movie.o p_movie.o $(ZINC_LIB_PATH)
	$(LINK) $(LINK_FLAGS) -o $@ movie.o p_movie.o $(Z_LIB_DIRS) $(Z_LIBS)

movie1: movie1.o p_movie1.o $(ZINC_LIB_PATH)
	$(LINK) $(LINK_FLAGS) -o $@ movie1.o p_movie1.o $(Z_LIB_DIRS) $(Z_LIBS)

movie2: movie2.o p_movie2.o $(ZINC_LIB_PATH)
	$(LINK) $(LINK_FLAGS) -o $@ movie2.o p_movie2.o $(Z_LIB_DIRS) $(Z_LIBS)

movie3: movie3.o p_movie3.o $(ZINC_LIB_PATH)
	$(LINK) $(LINK_FLAGS) -o $@ movie3.o p_movie3.o $(Z_LIB_DIRS) $(Z_LIBS)

movie4: movie4.o p_movie4.o $(ZINC_LIB_PATH)
	$(LINK) $(LINK_FLAGS) -o $@ movie4.o p_movie4.o $(Z_LIB_DIRS) $(Z_LIBS)

movie5: movie5.o p_movie5.o $(ZINC_LIB_PATH)
	$(LINK) $(LINK_FLAGS) -o $@ movie5.o p_movie5.o $(Z_LIB_DIRS) $(Z_LIBS)

movie6: movie6.o p_movie6.o $(ZINC_LIB_PATH)
	$(LINK) $(LINK_FLAGS) -o $@ movie6.o p_movie6.o $(Z_LIB_DIRS) $(Z_LIBS)

movie7: movie7.o p_movie7.o $(ZINC_LIB_PATH)
	$(LINK) $(LINK_FLAGS) -o $@ movie7.o p_movie7.o $(Z_LIB_DIRS) $(Z_LIBS)

clean:
	-rm -f movie movie1 movie2 movie3 movie4 movie5 movie6 movie7 *.o
