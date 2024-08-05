TARGET = motif

default: $(TARGET)

motif:
	(cd source; make motif)
	(cd source/storage; make motif)
	(cd source/intl; make motif)
	(cd tutor; make motif)
	(cd example; make motif)
	(cd design; make motif)

curses:
	(cd source; make curses)
	(cd source/storage; make curses)
	(cd source/intl; make curses)
	(cd tutor; make curses)
	(cd example; make curses)
	(cd design; make curses)

clean:
	(cd source; make clean)
	(cd source/storage; make clean)
	(cd source/intl; make clean)
	(cd tutor; make clean)
	(cd example; make clean)
	(cd design; make clean)
	-rm -f lib/*.a include/*.hpp bin/*

