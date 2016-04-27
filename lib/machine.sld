(define-library (machine)
  (import (scheme base)
          (scheme write)
          (scheme eval)
          (srfi 1)
          (srfi 69)
          (lexer)
          (infix))
  (export make-recipe
          value-for
          get-variables)
  (begin
    
    ;; {HashTable} -> {HashTable}
    ;; Validates the table and parses the formula
    (define (make-recipe recipe)
      ;; first, we validate the input
      (if (and (hash-table-exists? recipe 'type)
               (hash-table-exists? recipe 'name)
               (hash-table-exists? recipe 'formula)
               (hash-table-exists? recipe 'ingredients))

          ;; now lets parse the formula into an expression
          (begin (hash-table-set! recipe 'expression (infix->sexp (lex (hash-table-ref recipe 'formula))))

                 ;; next, let's recursively go through
                 ;; the ingredients and parse the
                 ;; formulas so we don't have to do it
                 ;; later...
                 (map (lambda (table)
                        (if (string=? (hash-table-ref table 'type) "recipe")
                            (make-recipe table)
                            table))
                      (hash-table-ref recipe 'ingredients))

                 ;; return the recipe
                 recipe)

          ;; invalid data error
          (error "Malformed input: recipe")))

    ;; {HashTable}, key -> <List>
    (define (get-variables ingredients key)
      (map (lambda (store)
             (define type (hash-table-ref store 'type))
             (define name (hash-table-ref store 'name))

             ;; ingredients get "data-for"
             ;; and recipes get "value-for"
             (cond ((string=? type "ingredient") (list (string->symbol name) (data-for store key)))
                   ((string=? type "recipe") (list (string->symbol name) (value-for store key)))))
           ingredients))

    ;; 'key -> *
    ;; This is like value-for, but for
    ;; ingredients rather than recipes
    (define (data-for ingredient key)
      (define reported-data (hash-table-ref ingredient 'reported_data))
      (if (hash-table-exists? reported-data key)
          (hash-table-ref reported-data key)
          '()))
    
    ;; {HashTable}, 'key -> {HashTable #(key)}
    (define (value-for recipe key)
      (define ingredients (hash-table-ref recipe 'ingredients))
      (define variables (get-variables ingredients key))

      ;; lets see if any of the data we
      ;; need is missing
      (if (any null? (map cadr variables))
          '()

          ;; This jargon here is actually
          ;; wrapping our formula expression
          ;; in its own private scope and
          ;; populating it with the available
          ;; data.
          (let ((formula (append (list 'let variables) (list (hash-table-ref recipe 'expression)))))
            (eval formula (environment '(scheme base))))))))
