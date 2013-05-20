
libdir=/usr/lib
includedir=/usr/include

all: sqlite3.scm sqlite3-common.scm sqlite3-ffi.scm
	gsc -:daq- -link -flat -o libgambc-sqlite3.c sqlite3.scm
	gsc -:daq- -obj -cc-options "-D___LIBRARY -D___SHARED -D___PRIMAL" sqlite3.c libgambc-sqlite3.c
	gcc -shared sqlite3.o libgambc-sqlite3.o -lgambc -lsqlite3 -o libgambc-sqlite3.so

install:
	install -Dp -m0644 libgambc-sqlite3.so $(libdir)/gambit/libgambc-sqlite3.so
	install -Dp -m0644 libgambc-sqlite3.c $(includedir)/gambit/libgambc-sqlite3.c

check:
	echo "Run sqlite3-test.scm to verify the library"
	gsc -:daq- -link ./libgambc-sqlite3.c sqlite3-test.scm
	gsc -:daq- -obj sqlite3-test.c sqlite3-test_.c
	gcc sqlite3-test.o sqlite3-test_.o -lgambc -L. -lgambc-sqlite3 -o sqlite3-test
	LD_LIBRARY_PATH=. ./sqlite3-test -:daq-

clean:
	rm -fv libgambc-sqlite3.c libgambc-sqlite3.o libgambc-sqlite3.so
	rm -fv sqlite3-test sqlite3-test.c sqlite3-test.o sqlite3-test_.c sqlite3-test_.o sqlite3.c sqlite3.o
