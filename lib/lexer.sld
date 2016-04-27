;; Lexer
(define-library (lexer)
  (import (scheme base)
          (scheme write)
          (srfi 69) ;; hash-table-related things
          (chibi string)) ;; string-cursor-related things
  (export lex
          push)
  (begin
    
    ;; MAIN
    ;; <String> -> <Symbol>
    ;; "1 * 2 + 3 + 4 + [my variable]" <String>
    ;; --->
    ;; (1 * 2 + 3 + 4 + |my variable|) <Symbol>
    (define (lex str)
      (let loop ((acc '())
                 (cur (string-cursor-start str)))
        (if (string-cursor=? cur (string-cursor-end str))
            acc
            (let ((this (string-cursor-ref str cur))
                   (next (string-cursor-next str cur)))

              (cond ((char=? this #\*) (loop (push acc '*) next)) ;; multiply
                    ((char=? this #\/) (loop (push acc '/) next)) ;; divide
                    ((char=? this #\+) (loop (push acc '+) next)) ;; add
                    ((char=? this #\-) (loop (push acc '-) next)) ;; subtract

                    ;; numbers are a special case for the lexer.
                    ;; we can't match a discreet char so we must
                    ;; attempt to parse it. Then, we also need to
                    ;; "peek" the next non-number and skip to it
                    ((string->number (string this)) (let ((next-non-number (string-find str (lambda (char) (not (string->number (string char)))) cur)))
                                                      (loop (push acc (string->number (substring-cursor str cur next-non-number))) next-non-number)))
                    
                    ;; variables are handled similarly to numbers
                    ;; except we can just peek a discrete char: #\]
                    ((char=? this #\[) (let ((next-var-close (string-find str #\] cur)))
                                         (loop (push acc (string->symbol (substring-cursor str next next-var-close))) next-var-close)))

                    ((char=? this #\]) (loop acc next)) ;; we can skip these guys
                    ((char=? this #\space) (loop acc next)) ;; and these guys
                    
                    (else (error (string-append "Malformed input: formula")))))))) ;; error case

    ;; does what it says
    (define (push ls str)
      (append ls (list str)))))
