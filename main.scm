#! /usr/bin/env chibi-scheme

(import (scheme base)
        (scheme write)
        (scheme file)
        (macduffie json)
        (parser))

(define data (json-read (open-input-file "./example.json")))

(define net-profit (parse data))

(display (value-of net-profit '|2015-02-28|))
