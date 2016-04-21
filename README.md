# Recipe Machine

This is a basic "recipe" machine. It receives algorithmic formulas (recipes) and data (ingredients) in the form of JSON and returns computed values in a readable manner.

It's built using [R7RS-small Scheme](http://trac.sacrideo.us/wg/wiki/R7RSHomePage) and compiled with [Chibi Scheme](http://synthcode.com/wiki/chibi-scheme).

## Install

Once you've cloned this gist, all you have to do is install a Scheme implementation. I like chibi:

1. `$ brew install chibi-scheme`

or

1. `$ git clone https://github.com/ashinn/chibi-scheme.git`
2. `$ cd chibi-scheme`
3. `$ make`

It works with anything R7RS-compliant, though (chibi, chicken, foment, kawa, larceny, and sagittarius).

## API

The machine works like this:

1. Load the library

    (import (parser))

2. Instantiate the class:

    (define net-profit (parse my-hash-table-of-data))

3. Compute a value:

    (value-of net-profit '2015-02-28) ;; => 4907.89
    (value-of (parse recipe) '2016-12-31) ;; => nil

## Example

Just run `example.scm`:

1. `$ path/to/chibi-scheme main.scm`
2. profit