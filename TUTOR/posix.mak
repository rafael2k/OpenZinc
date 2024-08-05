TARGET = motif

default: $(TARGET)

motif:
	(cd hello; make motif)
	(cd macro; make motif)
	(cd vlist; make motif)
	(cd word; make motif)
	(cd zincapp; make motif)
	(cd global; make motif)
	(cd movie; make motif)

curses:
	(cd hello; make curses)
	(cd macro; make curses)
	(cd vlist; make curses)
	(cd word; make curses)
	(cd zincapp; make curses)
	(cd global; make curses)
	(cd movie; make curses)

xkey:
	(cd hello; make xkey)
	(cd macro; make xkey)
	(cd word; make xkey)
	(cd zincapp; make xkey)
	(cd global; make xkey)
	(cd movie; make xkey)

clean:
	(cd hello; make clean)
	(cd macro; make clean)
	(cd vlist; make clean)
	(cd word; make clean)
	(cd zincapp; make clean)
	(cd global; make clean)
	(cd movie; make clean)
