Name: gambit-bh-db-sqlite3
Version: 1.0
Release: alt1
Summary: SQLite3 database library for Gambit-C Scheme programming system
License: GPL
Group: Development/Scheme
URL: http://okmij.org/ftp/Scheme/#databases

Packager: Paul Wolneykien <manowar@altlinux.ru>

BuildPreReq: sqlite3 libsqlite3-devel

Source: %name-%version.tar.gz

%description
SQLite3 database library for Gambit-C Scheme programming system

%prep
%setup -q

%build
gsc -:daq- -link -o libgambc-sqlite3.c sqlite3.scm
gsc -:daq- -obj -cc-options "-D___SHARED" sqlite3.c libgambc-sqlite3.c
gcc -shared sqlite3.o libgambc-sqlite3.o -lgambc -lsqlite3 -o libgambc-sqlite3.so

%install
install -Dp -m0644 libgambc-sqlite3.so %buildroot%{_libdir}/gambit/libgambc-sqlite3.so

%check
echo "Run sqlite3-test.scm to verify the library"
gsc -:daq- -exe -o sqlite3-test -ld-options "-L%buildroot%{_libdir}/gambit -lgambc-sqlite3" sqlite3-test.scm
./sqlite3-test -:daq-

%files
%doc README COPYRIGHT
%{_libdir}/gambit/libgambc-sqlite3.so

%changelog
* Thu Sep 10 2009 Paul Wolneykien <manowar@altlinux.ru> 1.0-alt1
- Initial build for ALTLinux.
