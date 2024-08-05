PROG = chkfile gc cppath rrmdir zdump browse strip

CC = CC
LINK = CC
CPP_EXTENSION = .cpp
CC_FLAGS = 
LINK_FLAGS = 
ZINC_INC_DIR = ../../include
ZINC_MOTIF_LIB = _mtf_zil
ZINC_CURSES_LIB = _crs_zil
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
RS6000 = -qlanglvl=compat
TARGET = motif
SYSTEM = $(HP)

.SUFFIXES:
.SUFFIXES: .o $(CPP_EXTENSION)

$(CPP_EXTENSION).o:
	$(CC) $(CC_FLAGS) $(Z_INCLUDE_DIR) -c $<

$(TARGET): chkfile cppath gc rrmdir zdump browse strip

chkfile: chkfile.o $(ZINC_LIB_PATH)
	$(LINK) $(LINK_FLAGS) -o chkfile chkfile.o $(Z_LIB_DIRS) $(SYSTEM) $(Z_LIBS)

cppath: cppath.o $(ZINC_LIB_PATH)
	$(LINK) $(LINK_FLAGS) -o cppath cppath.o $(Z_LIB_DIRS) $(SYSTEM) $(Z_LIBS)

gc: gc.o $(ZINC_LIB_PATH)
	$(LINK) $(LINK_FLAGS) -o gc gc.o $(Z_LIB_DIRS) $(SYSTEM) $(Z_LIBS)

strip: strip.o $(ZINC_LIB_PATH)
	$(LINK) $(LINK_FLAGS) -o strip strip.o $(Z_LIB_DIRS) $(SYSTEM) $(Z_LIBS)

rrmdir: rrmdir.o $(ZINC_LIB_PATH)
	$(LINK) $(LINK_FLAGS) -o rrmdir rrmdir.o $(Z_LIB_DIRS) $(SYSTEM) $(Z_LIBS)

zdump: zdump.o $(ZINC_LIB_PATH)
	$(LINK) $(LINK_FLAGS) -o zdump zdump.o $(Z_LIB_DIRS) $(SYSTEM) $(Z_LIBS)

browse: browse.o $(ZINC_LIB_PATH)
	$(LINK) $(LINK_FLAGS) -o browse browse.o $(Z_LIB_DIRS) $(SYSTEM) $(Z_LIBS)

gc.o: cppath$(CPP_EXTENSION) $(ZINC_LIB_PATH)
	-mv cppath.o cppath.SAV
	$(CC) -c -DDOGC $(CC_FLAGS) -I.. $(Z_INCLUDE_DIR) cppath$(CPP_EXTENSION)
	mv cppath.o gc.o
	-mv cppath.SAV cppath.o

strip.o: cppath$(CPP_EXTENSION) $(ZINC_LIB_PATH)
	-mv cppath.o cppath.SAV
	$(CC) -c -DSTRIP $(CC_FLAGS) -I.. $(Z_INCLUDE_DIR) cppath$(CPP_EXTENSION)
	mv cppath.o strip.o
	-mv cppath.SAV cppath.o

clean:
	-rm -f $(PROG) *.o

chkfile.o: chkfile$(CPP_EXTENSION)
	$(CC) $(CC_FLAGS) -DZ_STORE=\"z_store$(CPP_EXTENSION)\" -I.. $(Z_INCLUDE_DIR) -c chkfile$(CPP_EXTENSION) 
