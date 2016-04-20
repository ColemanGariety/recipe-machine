# The Recipe Machine

This is a basic "recipe" machine. It receives algorithmic formulas (recipes) and data (ingredients) in the form of JSON and returns computed values in a readable manner.

It's built using [R4RS scheme](https://people.csail.mit.edu/jaffer/r4rs_toc.html) and compiled with [Stalin](https://github.com/barak/stalin). Stalin gives us a near-C-performant executable called `recipe-machine`.

## Build

1. `$ git clone whatever`
2. `$ make`

## Usage

1. `$ ./recipe-machine my-data.json`
2. profit?