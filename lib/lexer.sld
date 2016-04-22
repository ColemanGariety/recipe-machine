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
      (define start (string-cursor-start str))
      (define end (string-cursor-end str))
      (let loop ((acc '())
                 (cur start))
        (if (string-cursor=? cur end)
            acc
            (let* ((this (string-cursor-ref str cur))
                   (next (string-cursor-next str cur)))
              (cond ((equal? (lexeme this) 'var-open) (handle-variable str loop acc cur this next))
                    ((equal? (lexeme this) 'number) (handle-number str loop acc cur this next))
                    ((equal? (lexeme this) '*) (loop (push acc '*) next))
                    ((equal? (lexeme this) '/) (loop (push acc '/) next))
                    ((equal? (lexeme this) '+) (loop (push acc '+) next))
                    ((equal? (lexeme this) '-) (loop (push acc '-) next))
                    (else (loop acc next)))))))

    ;; #\1 -> 1
    ;; #\+ -> '+
    ;; etc.
    (define (lexeme char)
      (cond ((string->number (string char)) 'number)
            ((char=? char #\[) 'var-open)
            ((char=? char #\]) 'var-close)
            ((char=? char #\space) 'space)
            ((char=? char #\+) '+)
            ((char=? char #\-) '-)
            ((char=? char #\*) '*)
            ((char=? char #\/) '/)
            (else (error (string-append "Malformed input: formula")))))

    ;; invoked from lex
    (define (handle-number str loop acc cur this next)
      (define next-non-number (string-find str
                                           (lambda (char)
                                             (not (equal? (lexeme char) 'number)))
                                           cur))
      (loop (push acc (string->number (substring-cursor str cur next-non-number)))
            next-non-number))


    ;; invoked by lex
    (define (handle-variable str loop acc cur this next)
      (define next-var-close (string-find str #\] cur))
      (loop (push acc (string->symbol (substring-cursor str next next-var-close)))
            next-var-close))

    ;; does what it says
    (define (push ls str)
      (if (equal? str "") ls (append ls (list str))))))
