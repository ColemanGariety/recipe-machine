#! /usr/bin/env chibi-scheme

(import (scheme base)
        (scheme write)
        (scheme file)
        (macduffie json)
        (machine)) ;; make-recipe and value-for

(define data (json-read (open-input-file "./example.json")))
(display "JSON... loaded!")
(newline)

(define net-profit (make-recipe data))
(display "Recipe... made!")
(newline)

(display "Net profit for 2015-02-28 => ")
(display (value-for net-profit '|2015-02-28|))
(newline)

(display "Net profit for 2015-12-31 => ")
(display (value-for net-profit '|2015-12-31|))
