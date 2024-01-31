
# OCaml

Caml is a dialect of the ML programming language family, developed in France at INRIA. OCaml is the main implementation of the programming language Caml. The features of ML include:
* First-class functions
  * Functions can be data, too: parameters and return values
* Favor immutability (assign onceâ)
* Data types and pattern matching
  * Convenient for certain kinds of data structures
* Type inference
  * No need to write types in the source language
    * But the language is statically typed
  * Supports parametric polymorphism
    * Generics in Java, templates in C++
* Exceptions
* Garbage collection

## Resources
### Books
* Developing Applications with Objective Caml (https://caml.inria.fr/pub/docs/oreilly-book/ocaml-ora-book.pdf)
* Introduction to the Objective Caml Programming Language (http://courses.cms.caltech.edu/cs134/cs134b/book.pdf)
* Real World OCaml 2nd Edition (https://dev.realworldocaml.org/)
* OCaml from the Very Beginning (https://johnwhitington.net/ocamlfromtheverybeginning/mlbook.pdf)

## Working with OCaml

* OCaml programs can be compiled using `ocamlc`
  * Produces `.cmo` (compiled object) and `.cmi` (compiled interface) files
   * Use -o to set output file name
   * Use -c to compile only to `.cmo/.cmi` and not to link
* Can also compile with ocamlopt
  * Produces `.cmx` files, which contain native code
  * Faster, but not platform-independent (or as easily debugged)

## OCaml Basics

OCaml files are written with a ``.ml`` extension. An OCaml file is similar to a Python file: when run, it evaluates the file directly. There is no special main function. An OCaml file consists of

* A series of open statements for including other modules
* A series of declarations for defining datatypes, functions, and constants
* A series of (though often just one) toplevel expressions to evaluate.

### Example: hello.ml:
```ocaml
(* A small OCaml program *)
print_string "Hello world!\n";;
```
Or
```ocaml
open Printf
let message = "Hello world";;
(printf "%s\n" message)
```
The first line includes the built-in library for printing, which provides functions similar to fprintf and printf from stdlib in C. The next two lines define a constant named message, and then call the printf function with a format string (where %s means “format as string”), and the constant message we defined on the line before.


To compile and run
```ocaml
ocamlc hello.ml
./a.out
Hello world!
```

We can also compile multiple files to generate a single executable. 


main.ml
```ocaml
let main () =
print_int (Util.add 10 20); print_string "\n"
let () = main ()
```
 
util.ml
```ocaml
let add x y = x+y
```
Compile and run:
```ocaml
ocamlc util.ml main.ml
```
Or compile separately

```ocaml
ocamlc -c util.ml
ocamlc util.cmo main.ml
```

It generates an executable a.out. We can execute it by
```ocaml
./a.out
```

### OCaml toplevel, a REPL for OCaml
We will begin exploration of OCaml in the interactive top level. A top level is also called a read-eval-print loop and it works like a terminal shell. To run the ocaml topleve, simply run `ocaml`
```ocaml
 % ocaml
 OCaml version 4.14.1
 # print_string "Hello world!\n";;
    Hello world!
 - : unit = ()
```

There is an alternative toplevel called `utop`. It is more user friendly, and we will be using `utop` in the class. You can install `utop` by runnung `opam install utop`.

Follow the instructions in the project 0 for installing opam and ocaml. 

To load a file into top level:
```ocaml
#use "filename.ml"
```
To exit the top-level, type ^D (ControlÂ D) or call the exit 0
```ocaml
# exit 0;;
```

### First OCaml Example
```ocaml
(* A small OCaml program (* with nested comments *) *)
let x = 37;;
let y = x + 5;;
print_int y;;
print_string "\n";;
```

OCaml is strictly typed. It does not implicitly cast types. For example, `print_int` only prints `int`s. 
```ocaml
print_int 10;;
    10- : unit = ()
```
`()` is called unit. It is similar to `void` in other languages. Following expressions do not type check
```ocaml
print_int 10.5;;
    Error: This expression has type float but an expression was expected of type int
```
becase `print_int` does not take `float` as an argument. The following code does not typecheck because `+` operator requires both operands are integers.  
```ocaml
1 + 0.5;;
Error: This expression has type float but an expression was expected of type int

1 + true;;
    Error: This expression has type bool but an expression was expected of type int
```
As expected, `print_int` does not a string as an argument.
```
print_int "This function expected an int";;
    Error: This expression has type string but an expression was expected of type int
```

## Expressions
 Expressions are our primary building block, akin to statements in imperative languages. Every kind of expression has syntax and semantics. Semantics include:
  * Type checking rules (static semantics): produce a type or fail with an error message
  * Evaluation rules (dynamic semantics): produce a value or an exception or infinite loop. Evaluation rules are used only on expressions that type-check

We use metavariable `e` to designate an arbitrary expression.

## Values
A value is an expression that is final. For example, `34` and `true` are values because they are and we cannot evaluate them any further. On the contrary, `34+17` is an expression, but not a value because we can it is not final. Evaluating an expression means running it until it’s a value. For example `34+17` evaluates to 51, which is a value. We use metavariable `v` to designate an arbitrary value

## Types
Types classify expressions. It is the set of values an expression could evaluate to. Examples include `int`, `bool`, `string`, and more. We use metavariable `t` to designate an arbitrary type. Expression `e` has type `t` if `e` will (always) evaluate to a value of type `t`. For example `0`, `1`, and `-1` are values of type `int` while `true` has type `bool`. `34+17` is an expression of type `int`, since it evaluates to `51`, which has type `int`. We usually write `e : t` to say `e` has type `t`.  The process of determining `e` has type `t` is called `type checking` simply, `typing`.

### if expression

Syntax
```ocaml
if e1 then e2 else e3
```
Type checking rules

- if `e1 : bool` and `e2 : t` and `e3 : t` then 
    - `if e1 then e2 else e3 : t`

Examples:
```ocaml
 if 7 > 42 then "hello" else "goodbye";;
    - : string = "goodbye"
```
The follwing expression does not type check because the two branches of the `if` expressin do not return the same type. The `true` branch returns `string`, while the `false` branch returns `int`
```ocaml
if 7 > 42 then "hello" else 10;;
    Error: This expression has type int but an expression was expected of type string
```

Evaluating an expression returns a value. For example, evaluaing `(if 10>5 then 100 else 200)` retuens `100`. 
```ocaml
print_int (if 10>5 then 100 else 200);;
100- : unit = ()
```

## Functions
OCaml functions are like mathematical functions. They compute a result from provided arguments. 

We use `let` to define a function:

Factorial function:
```ocaml
let rec fact n =
  if n = 0 then
     1
  else
     n * fact (n-1);;
```
`rec` keyword is used to define `recursive` functions. 

### Calling Functions (Function Application)
Syntax 
```ocaml
f e1 e2 … en
```

Parentheses are not required around argument(s). There are no commas between the arguments. Instead, we use spaces. 

Evaluation

* Find the definition of f i.e., `let rec f x1 … xn = e`
* Evaluate arguments `e1 … en` to values `v1 … vn`
* Substitute arguments `v1, … vn` for params `x1, ... xn` in body e 
  * Call the resulting expression `e’`
* Evaluate `e’` to value v, which is the final result

Follwoing is an example of evaluating `fact 2`
```ocaml
let rec fact n =
    if n = 0 then
       1
    else
       n * fact (n-1)


fact 2 (* substitute every occurence of n inside the body of fact with 2 *)
if 2=0 then 1 else 2*fact(2-1) (* evaluate the if expression *)
2 * fact 1 (* result of the else branch *)
2 * (if 1=0 then 1 else 1*fact(1-1)) (* substitute n with 1 *)
2 * 1 * fact 0
2 * 1 * (if 0=0 then 1 else 0*fact(0-1))
2 * 1 * 1
2
```

### Function Types

In OCaml, `->` is the function type constructor. Type `t1 -> t` is a function with argument or domain type `t1` and return or range type `t`. Type `t1 -> t2 -> t` is a function that takes two inputs, of types `t1` and `t2`, and returns a value of type `t`.


### Type Checking of Function application
As we have seen before, the syntax of a function application is 
```ocaml
f e1 … en
```
We use the following type checking rule for the function application:
If `f : t1 -> … -> tn -> u` and   `e1 : t1,  …, en : tn` then the type of `f e1 … en` is `u`. For example: the type of `not true` is `bool` because `not : bool -> bool` and `true : bool`. 


#### More Examples on Function Type Checking

The function `next` calculates the next integer. 
```ocaml
let next x = x + 1;;
```
If you enter the above code to `utop`, it shows the type `next` as
```ocaml
next : int -> int
```
Here is how `ocaml` inferred the type of `next` as `int->int`: `+` is an integer addition operator. Both operands of `+` must be integer. It means `x` must be an integer. There the argument type and return type are `int`. `next` is a function, which takes an `int` as n argument, and returns an `int` value.
```ocaml
next 10;;
- : int = 11

# next 10.5;;
Error: This expression has type float but an expression was expected of type int. 
```
The functions `swap` and `eq` are polymorphic function. The types `'a` and `'b` can be read as `for all type a and b`
```ocaml
(* Swapping two values *)
let swap (x,y) = (y,x);;
swap : 'a * 'b -> 'b * 'a

(* Comparing other types *)
let eq (x,y) = x = y;; 
eq : 'a * 'a -> bool

(* Adding two integers *)
let add x y = x + y;;
add : int -> int -> int

let fn x = (int_of_float x) * 3;;
fn : float -> int = <fun>

(* factorial function *)
fact;;
fact: int -> int
```
