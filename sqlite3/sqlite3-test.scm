;; Gambit-c's sqlite3 binding. Test.
;;
;; Copyright (C) 2008 Marco Benelli <mbenelli@yahoo.com>
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;;

(define *dbname* "test.db")

(define (expected-promise query)
  (let ([p (open-process (list path: "/usr/bin/sqlite3"
			       arguments: (list *dbname*)))])
    (display query p)
    (newline p)
    (force-output p)
    (let ([res (read-line p)])
      (close-port p)
      res)))

(define (get-expected query)
  (delay (expected-promise query)))

(define (test-query query fn seed expected)
  (call-with-values
      (lambda () (sqlite3 *dbname*))
    (lambda (db-fold-left close)
      (let [(res (db-fold-left fn seed query))]
       (close)
	   (if (equal? res (force expected))
         (begin
           (print "\tpassed.\n")
           #t)
         (begin
           (print "\tfailed.\n")
           #f))))))

(define (run-tests)
  (list
    
    (let ([q "CREATE TABLE tb1 (c0 INTEGER, c1 TEXT, c2 REAL);"])
      (test-query q values q (get-expected ".schema tb1")))
    
    (test-query "INSERT INTO tb1 VALUES(1, 'one', 1.001);"
                values
                "1|one|1.001"
                (get-expected "select * from tb1;"))

    (let ([fn (lambda (seed c0 c1 c2)
                (values #t (with-output-to-string
                             seed
                             (lambda ()
                               (print c0 "|" c1 "|" c2)))))])
      (test-query "SELECT * FROM tb1;" fn ""
                  (get-expected "select * from tb1;")))))


(define (run)
  (if (file-exists? *dbname*)
    (delete-file *dbname*))

  (let ((res (time (run-tests))))
    (delete-file *dbname*)
    (not (member #f res))))

(if (run)
  (exit 0)
  (exit 1))
