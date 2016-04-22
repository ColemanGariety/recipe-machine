(define-library (parser)
  (import (scheme base)
          (scheme write)
          (chibi regexp)
          (srfi 69)
          (lexer))
  (export parse
          value-of)
  (begin
    
    ;; {HashTable}:
    ;;     "[revenue] - [expenses]" -> #<procedure>
    (define (parse-formula recipe)
      (define ingredients (hash-table-ref recipe 'ingredients))
      (define formula (hash-table-ref recipe 'formula))
      (hash-table-set! recipe
                       'formula
                       (lambda (key)
                         (tokenize "(12) + 3 + (2 + 3) + [my variable]")))
      recipe)
    
    ;; {HashTable} -> VALIDATED {HashTable}
    (define (parse recipe)
      (if (and (hash-table-exists? recipe 'type)
               (hash-table-exists? recipe 'name)
               (hash-table-exists? recipe 'formula)
               (hash-table-exists? recipe 'ingredients))
          (parse-formula recipe)
          (error "Malformed recipe data")))

    ;; {HashTable}, 'key -> {HashTable #(key)}
    (define (value-of recipe key)
      (define formula (hash-table-ref recipe 'formula))
      (cond ((string? key) (formula (string->symbol key)))
            ((symbol? key) (formula key))))))
