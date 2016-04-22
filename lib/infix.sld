;; Infix
;; This lib parses a lexified 
;; Suggested reading:

;; the shunting-yard algorithm
;; https://en.wikipedia.org/wiki/Shunting-yard_algorithm
(define-library (infix)
  (import (scheme base)
          (scheme write)
          (srfi 1)) ;; circular lists & more!
  (export infix->sexp)
  (begin
    (define ops '(+ - * /))

    ;; Order Of Operations
    ;; <Symbol> -> <Number>
    ;; '+ -> 1
    (define (ooo item)
      (car (cdr (assq item '((bos 0) (+ 1) (- 1) (* 2) (/ 2))))))
    
    ;; <Symbol> -> <Symbol>
    ;; (1 + 2) -> (+ 1 2)
    (define (infix->sexp expression)
      (let loop ((expr expression)
                 (operands '())
                 (operators (circular-list 'bos)))
        (define (apply-operator)
          (loop expr
                (cons (list (car operators)
                            (list-ref operands 1)
                            (list-ref operands 0))
                      (cdr (cdr operands)))
                (cdr operators)))
        (if (null? expr)
            (if (eq? (car operators) 'bos)
                (car operands)
                (apply-operator))
            (let ((atom (car expr)))
              (cond ((member atom ops) (if (> (ooo atom) (ooo (car operators)))
                                           (loop (cdr expr) operands (cons atom operators))
                                           (apply-operator)))
                    (else (loop (cdr expr) (cons atom operands) operators)))))))))
