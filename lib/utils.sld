(define-library (utils)
  (import (scheme base)
          (scheme write)
          (chibi string))
  (export string-split
          formula-parser)
  (begin

    ;; "(1 + 2) + [my variable] + 5"
    ;; ->>>
    ;; ("(1 + 2)" "+" "[my variable]" "+" "5")
    (define (formula-parser formula)
      (define start (string-cursor-start formula))
      (define end (string-cursor-end formula))
      (let loop ((rv '())
                 (cur (string-cursor-end formula))
                 (last (string-cursor-end formula))
                 (variable? #f))
        (if (string-cursor=? cur start)
            (cons (substring-cursor formula cur last) rv)
            (let ((prev (string-cursor-prev formula cur)))
              (define this (string-cursor-ref formula prev))
              (define past (substring-cursor formula cur last))
              (if variable?

                  ;; variable? == true
                  (if (char=? this #\[)
                      (loop rv prev last #f) ;; AND this == [
                      (loop rv prev last variable?)) ;; AND this != [

                  ;; variable? == false
                  (cond ((char=? this #\space) (loop (cons past rv) prev prev variable?)) ;; AND this == space
                        ((char=? this #\]) (loop rv prev last #t)) ;; AND this == ]
                        (else (loop rv prev last #f)))))))) ;; AND this == )
    
    ;; "foo bar baz" -> ("foo" "bar" "baz")
    (define (string-split str delim)
      (define start (string-cursor-start str))
      (let loop ((rv '())
                 (cur (string-cursor-end str))
                 (last (string-cursor-end str)))
        (if (string-cursor=? cur start)
            (cons (substring-cursor str cur last) rv)
            (let ((prev (string-cursor-prev str cur)))
              (if (char=? (string-cursor-ref str prev) delim)
                  (loop (cons (substring-cursor str cur last) rv) prev prev)
                  (loop rv prev last))))))))
