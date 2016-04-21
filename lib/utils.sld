(define-library (utils)
  (import (scheme base)
          (scheme write)
          (srfi 1))
  (export stuff-peak
          atom?
          lat?)
  (begin

    (define (atom? x) (not (or (pair? x) (null? x))))
    
    (define (lat? l)
      (cond ((null? l) #t)
            ((atom? (car l)) (lat? (cdr l)))
            (else #f)))
    
    ;; ("foo" "bar"), ((()) ())
    ;; --->
    ;; ((("foo" "bar")) ())
    (define (stuff-peak a ls)
      (deep-insert "foo" 0 '(((0)) ())))

    (define (deep-insert new key lst )
      (apply append
             (map (lambda ( x )
                        (if (atom? x)
                            (if (equal? key x) (list new) (list x))
                            (list (deep-insert new key x))))
                     lst)))))
