
libdir=/usr/lib
includedir=/usr/include

BASENAME=sqlite3
#LIBS=
LIBS=-l$(BASENAME)

all: libgambc-$(BASENAME).so

libgambc-$(BASENAME).c: $(BASENAME).scm $(BASENAME)-common.scm $(BASENAME)-ffi.scm
	gsc -:daq- -link -flat -o libgambc-$(BASENAME).c $(BASENAME).scm

$(BASENAME).c: libgambc-$(BASENAME).c
	[ -f $< ]

libgambc-$(BASENAME).o: $(BASENAME).c libgambc-$(BASENAME).c
	gsc -:daq- -obj -cc-options "-D___LIBRARY -D___SHARED -D___PRIMAL" $(BASENAME).c libgambc-$(BASENAME).c

$(BASENAME).o: libgambc-$(BASENAME).o
	[ -f $< ]

libgambc-$(BASENAME).so: $(BASENAME).o libgambc-$(BASENAME).o
	gcc -shared $(BASENAME).o libgambc-$(BASENAME).o -lgambc $(LIBS) -o libgambc-$(BASENAME).so

install: libgambc-$(BASENAME).so libgambc-$(BASENAME).c
	install -Dp -m0644 libgambc-$(BASENAME).so $(libdir)/gambit/libgambc-$(BASENAME).so
	install -Dp -m0644 libgambc-$(BASENAME).c $(includedir)/gambit/libgambc-$(BASENAME).c

$(BASENAME)-test: $(BASENAME)-test.scm libgambc-$(BASENAME).so
	echo "Run $(BASENAME)-test.scm to verify the library"
	gsc -:daq- -link ./libgambc-$(BASENAME).c $(BASENAME)-test.scm
	gsc -:daq- -obj $(BASENAME)-test.c $(BASENAME)-test_.c
	gcc $(BASENAME)-test.o $(BASENAME)-test_.o -lgambc -L. -lgambc-$(BASENAME) -o $(BASENAME)-test

check: $(BASENAME)-test
	LD_LIBRARY_PATH=. ./$(BASENAME)-test -:daq-

clean:
	rm -fv libgambc-$(BASENAME).c libgambc-$(BASENAME).o libgambc-$(BASENAME).so
	rm -fv $(BASENAME)-test $(BASENAME)-test.c $(BASENAME)-test.o $(BASENAME)-test_.c $(BASENAME)-test_.o $(BASENAME).c $(BASENAME).o
