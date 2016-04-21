(define-library (lexer)
  (import (scheme base)
          (scheme write)
          (chibi string)
          (utils))
  (export tokenize
          evaluate)
  (begin

    (define (evaluate formula variables)
      formula)

    ;; Basically what needs to happen here is that
    ;; the cons calls need to be something like
    ;; list-set-deep whereof the "depth" used
    ;; is (length markers). If we are going "in"
    ;; then we use exactly (length markers). If
    ;; we are going "out" we use (- (length markers) 1)
    ;; so that it goes in the larger scope.
    
    ;; What it needed is basically a "deep insert":
    
    ;; bos -> ()
    ;; ( -> (() . "")
    ;; (( -> ((() . "1 *") . "")
    ;; (() -> ((("2 + 3") . "1 *") . "")
    ;; (()) -> (("+ 4" ("2 + 3") "1 *") .  "")
    ;; eos -> ("+ [my variable]" ("+ 4" ("2 + 3") "1 *") "")
    
    ;; then, last but not least, we need a "deep reverse"
    ;; so that all the innter lists get reversed also:
    
    ;; ("" ("1 *" ("2 + 3") "+ 4") "+ [my variable]")
    
    ;; "(1 * (2 + 3) + 4) + [my variable]"
    ;; --->
    ;; (("1 *" ("2 + 3") "+ 4") "+ [my variable]")

    ;; "(1 + (2 + 3) + 4)"
    ;; --->
    ;; ("1 + " ("2 + 3") " + 4")
    (define (push-string ls str)
      (if (equal? str "") ls (append ls (list str))))

    (define (unshift-string ls str)
      (if (equal? str "") ls (cons str ls)))

    (define (parse-parens str)
      (define start (string-cursor-start str))
      (define end (string-cursor-end str))

      (display str)
      (newline)

      (let loop ((acc '())
                 (cur start)
                 (last start))
        (if (string-cursor=? cur end)
            (push-string acc (substring-cursor str last cur))
            (let* ((this (string-cursor-ref str cur))
                   (next (string-cursor-next str cur))
                   (close (string-find-right str #\))))
              (cond ((char=? this #\() (loop (unshift-string (cons (parse-parens (substring-cursor str
                                                                                                   next
                                                                                                   (string-cursor-prev str close)))
                                                                   acc)
                                                             (substring-cursor str last cur))
                                             close
                                             close))
                    (else (loop acc next last)))))))

    (define (tokenize formula)
      (parse-parens formula))))
