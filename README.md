# Recipe Machine

This is a basic "recipe" machine. It receives algorithmic formulas (recipes) and data (ingredients) in the form of JSON and returns computed values in a readable manner.

Ingredients may themselves be recipes.

It's written in [R7RS-small Scheme](http://trac.sacrideo.us/wg/wiki/R7RSHomePage) and compiled with [Chibi Scheme](http://synthcode.com/wiki/chibi-scheme).

## Install

Once you've cloned this repo, all you have to do is install an R7RS-compliant Scheme (I like chibi, but it'll work with any R7RS Scheme) and the macduffie json dependency:

##### via Homebrew

1. `$ brew install chibi-scheme`
2. `$ snow-chibi install "(macduffie json)"`

##### via Git

1. `$ git clone https://github.com/ashinn/chibi-scheme.git`
2. `$ cd chibi-scheme; make; cd ..;`
3. `$ ./chibi-scheme/snow-chibi install "(macduffie json)"`

## Example

Just run `example.scm`:

1. `$ chibi-scheme example.scm`
2. profit

## API

The machine works like this:

##### Load the library

```scheme
(import (machine))
```

##### Instantiate the class:

```scheme
(define net-profit (make-recipe my-hash-table-of-data))
```

##### Compute a value:

```scheme
(value-for net-profit '2015-02-28) ;; => 4907.89
(value-for net-profit '2016-12-31) ;; => nil
```

You can also use the lexer or the "shunting-yard" parser by themselves:

```scheme
(import (lexer)
        (infix))

;; lex takes an infix string and returns an infix expression
(lex "1 + 2")  ;; '(1 + 2)

;; infix->sexp takes an infix expression and returns an s-expression
(infix->sexp '(1 + 2)) ;; (+ 1 2)
```
## Test

Running tests are easy, too.

1. `$ chibi-scheme ./test.scm`

```
machine: ...
3 out of 3 (100.0%) tests passed in 0.00248599052429199 seconds.
lex: ........
8 out of 8 (100.0%) tests passed in 0.00141692161560059 seconds.
infix: ......
6 out of 6 (100.0%) tests passed in 0.000358104705810547 seconds.
```
