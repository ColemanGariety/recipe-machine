#! /usr/bin/env chibi-scheme

(import (scheme base)
        (scheme file)
        (chibi test)
        (macduffie json)
        (srfi 69)
        (machine)
        (infix)
        (lexer))

(define nested-recipes (json-read (open-input-file "./example.json")))

(test-group "machine"
            (test-assert "make-recipe returns a hash-table" (hash-table? (make-recipe nested-recipes)))
            (test "value-for can handle invalid value with nested-recipe" '() (value-for (make-recipe nested-recipes) '|0000-00-00|))
            (test "value-for can handle valid value with nested recipe" 14147.34 (value-for (make-recipe nested-recipes) '|2015-02-28|)))

(test-group "lex"
            (test "lex can handle addition" '(1 + 2) (lex "1 + 2"))
            (test "lex can handle subtraction" '(1 - 2) (lex "1 - 2"))
            (test "lex can handle multiplication" '(1 * 2) (lex "1 * 2"))
            (test "lex can handle division" '(1 / 2) (lex "1 / 2"))
            (test "lex can handle expressions without spaces" '(1 + 2) (lex "1+2"))
            (test "lex can handle variables" '(|foo|) (lex "[foo]"))
            (test "lex can handle multi-digit numbers" '(123 + 456) (lex "123 + 456")))

(test-group "infix"
            (test "infix can handle addition" '(+ 1 2) (infix->sexp '(1 + 2)))
            (test "infix can handle subtraction" '(- 1 2) (infix->sexp '(1 - 2)))
            (test "infix can handle multiplication" '(* 1 2) (infix->sexp '(1 * 2)))
            (test "infix can handle division" '(/ 1 2) (infix->sexp '(1 / 2)))
            (test "infix can handle variables" '|foo| (infix->sexp '(|foo|)))
            (test "infix can handle multi-digit numbers" '(+ 123 456) (infix->sexp '(123 + 456))))

(test-exit)
