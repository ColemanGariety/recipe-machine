(define-library (machine)
  (import (scheme base)
          (scheme write)
          (scheme eval)
          (srfi 69)
          (lexer)
          (infix))
  (export make-recipe
          value-for
          generate-scope)
  (begin
    
    ;; {HashTable} -> {HashTable}
    ;; Validates the table and parses the formula
    (define (make-recipe recipe)
      (if (and (hash-table-exists? recipe 'type)
               (hash-table-exists? recipe 'name)
               (hash-table-exists? recipe 'formula)
               (hash-table-exists? recipe 'ingredients))
          (begin (hash-table-set! recipe 'expression (parse (hash-table-ref recipe 'formula)))
                 recipe) ;; return the recipe
          (error "Malformed input: recipe")))

    (define (parse formula)
      (infix->sexp (lex formula)))

    ;; {HashTable}, key -> <List>
    (define (generate-scope ingredients key)
      (map (lambda (table)
             (define type (hash-table-ref table 'type))
             (cond ((equal? type "ingredient") (let ((reported-data (hash-table-ref table 'reported_data))
                                                      (name (hash-table-ref table 'name)))
                                                 (if (hash-table-exists? reported-data key)
                                                     (list (string->symbol name) (hash-table-ref reported-data key))
                                                     #f)))
                   
                   ((equal? type "recipe") (let ((name (hash-table-ref table 'name)))
                                             (list (string->symbol name) (value-for (make-recipe table) key))))))
      ingredients))
    
    ;; {HashTable}, 'key -> {HashTable #(key)}
    (define (value-for recipe key)
      (define ingredients (hash-table-ref recipe 'ingredients))
      (define scope (generate-scope ingredients key))
      (if (car scope)
          (let ((formula (append (list 'let scope) (list (hash-table-ref recipe 'expression)))))
            (eval formula (environment '(scheme base))))
          "nil"))))
