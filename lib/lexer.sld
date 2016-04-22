(define-library (lexer)
  (import (scheme base)
          (scheme write)
          (srfi 69)
          (chibi string)
          (utils))
  (export tokenize
          evaluate)
  (begin
    
    (define (evaluate formula variables)
      formula)

    (define (lexeme char)
      (cond ((string->number (string char)) 'number)
            ((char=? char #\[) 'var-open)
            ((char=? char #\]) 'var-close)
            ((char=? char #\space) 'space)
            ((char=? char #\() 'paren-open)
            ((char=? char #\)) 'paren-close)
            ((char=? char #\+) '+)
            ((char=? char #\-) '-)
            ((char=? char #\*) '*)
            ((char=? char #\/) '/)
            (else (error (string-append "Formula contains unknown character")))))
    
    ;; "(1 * (2 + 3) + 4) + [my variable]"
    ;; --->
    ;; (("1 *" ("2 + 3") "+ 4") "+ [my variable]")
    (define (push-string ls str)
      (if (equal? str "") ls (append ls (list str))))

    (define (unshift-string ls str)
      (if (equal? str "") ls (cons str ls)))
    
    (define (handle-number str loop acc cur this next)
      (define next-non-number (string-find str
                                           (lambda (char)
                                             (not (equal? (lexeme char) 'number)))
                                           cur))
      (loop (push-string acc (string->number (substring-cursor str cur next-non-number)))
            next-non-number))

    (define (handle-paren str loop acc cur this next)
      (define next-paren-close (string-find str #\) cur))
      (loop (push-string acc (parse-parens (substring-cursor str next next-paren-close)))
            next-paren-close))

    (define (handle-variable str loop acc cur this next)
      (define next-var-close (string-find str #\] cur))
      (loop (push-string acc (string->symbol (substring-cursor str next next-var-close)))
            next-var-close))
    
    (define (parse-parens str)
      (define start (string-cursor-start str))
      (define end (string-cursor-end str))
      (let loop ((acc '())
                 (cur start))
        (if (string-cursor=? cur end)
            acc
            (let* ((this (string-cursor-ref str cur))
                   (next (string-cursor-next str cur)))
              (cond ((equal? (lexeme this) 'paren-open) (handle-paren str loop acc cur this next))
                    ((equal? (lexeme this) 'var-open) (handle-variable str loop acc cur this next))
                    ((equal? (lexeme this) 'number) (handle-number str loop acc cur this next))
                    ((equal? (lexeme this) '*) (loop (push-string acc '*) next))
                    ((equal? (lexeme this) '/) (loop (push-string acc '/) next))
                    ((equal? (lexeme this) '+) (loop (push-string acc '+) next))
                    ((equal? (lexeme this) '-) (loop (push-string acc '-) next))
                    (else (loop acc next)))))))
    
    (define (sexp->ast)
      "foo")
    
    (define (tokenize formula)
      (parse-parens formula))))
