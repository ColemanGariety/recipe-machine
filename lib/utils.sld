(define-library (utils)
  (import (scheme base)
          (scheme write)
          (chibi string)
          (srfi 1))
  (export string-split
          deep-map
          atom?
          lat?)
  (begin

    (define (atom? x) (not (or (pair? x) (null? x))))
    
    (define (lat? l)
      (cond ((null? l) #t)
            ((atom? (car l)) (lat? (cdr l)))
            (else #f)))

    (define (deep-map f l)
      (let deep ((x l))
        (cond ((null? x) x)
              ((pair? x) (map deep x))
                        (else (f x)))))))
