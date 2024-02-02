
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



### Type annotations
OCaml compiler infers the types. But type inference is tricky. It gives vague error messages. We can annotate types manually. 
```ocaml
let (x : int) = 3;;
val x : int = 3
```
```ocaml
let fn (x:int):float = (float_of_int x) *. 3.14;;
    val fn : int → float
```
```ocaml
let add (x:int) (y:int):int = x + y
let id x = x (* 'a → 'a *)
let id (x:int) = x (* int → int *)
```

## Lists in OCaml
List is a basic data structure in OCaml. Lists can be of arbitrary length and implemented as a linked data structure. Lists must be homogeneous, meaning all elements have the same type. We will learn how to construct lists and destruct them via pattern matching. 

### Evaluation
`[ ]` is a value. To evaluate `[e1; e1;...;en]`, we evaluate `e1` to a value `v1`, `e2` to a value `v2`, and `en` to a value `vn`, and return `[v1;…;vn]`.
`e1::e2` is a desugaring of [e1;e2].

### Examples
```ocaml
# let y = [1; 1+1; 1+1+1] ;;
val y : int list = [1; 2; 3]

# let x = 4::y ;;
val x : int list = [4; 1; 2; 3]

# let z = 5::y ;;
val z : int list = [5; 1; 2; 3]

# let m = “hello”::”bob”::[];;
val m : string list = [“hello”; “bob”]
```

### Typing
The type of `Nil` is `'a list` i.e., empty list `[ ]` has type `t` list for any type `t`. The type of `Cons` is 
```ocaml 
If e1 : t and e2 : t list then e1::e2 : t list
```

With parens for clarity: 
```ocaml
If e1 : t and e2 : (t list) then (e1::e2) : (t list) 
```
### Examples
```ocaml
# let m = [[1];[2;3]];;
val y : int list list = [[1]; [2; 3]]

# let y = 0::[1;2;3] ;;
val y : int list = [0; 1; 2; 3]

# let x = [1;"world"] ;; (* all elements must have same type *)

This expression has type string but an expression was expected of type int
```
`::` operator appends a single item, not a list, to the front of another list. The left argument of `::` is an element, the right is a list
```ocaml
# let w = [1;2]::y ;; 
This expression has type int list but is here used with type int list list
```

Can you construct a list y such that [1;2]::y makes sense? 

Yes. If the type of `y` is `int list list`,i.e., `[1;2]::[[3;4]]`. Each element of this list is an `int list`.

Lists in Ocaml are Linked. `[1;2;3]` is represented as:
![image](lists.png). 

A nonempty list is a `pair (element, rest of list)`. The `element` is the head of the list, and `rest of the list` is itself a list. Thus in math (i.e., inductively) a list is either 
* The empty list [ ]
*  Or a pair consisting of an element and a list

This recursive structure will come in handy shortly

### Lists of Lists
Lists can be nested arbitrarily. For exmaple: `[ [9; 10; 11]; [5; 4; 3; 2] ]`. Type `int list list`, also written as `(int list) list`.  Lists are Immutable. 	No way to mutate (change) an element of a list. 	Instead, build up new lists out of old, e.g., using `::`. 

### Pattern Matching
To pull lists apart, we use the `match` construct. The pattern-matching part of the `match` is a sequence of clauses, each one of the form: `pattern -> expr`, separated by vertical bars (|). The clauses are processed in order, and only the `expr` of first matching clause is evaluated. The value of the entire match expression is the value of the `expr` of the matching clause; If no `pattern` matches `expr`, your match is said to be `non-exhaustive` and when a match fails it raise the exception `Match_failure`.
Syntax
```ocaml
match e with 
| p1 -> e1 
| … 
| pn -> en
```
### Pattern Matching Example
```ocaml
(* get  the head of a list *)
let hd l = 
  match l with 
  (h::t) -> h

hd [1;2;3](* evaluates to 1 *)
hd [2;3]  (* evaluates to 2 *)
hd [3]    (* evaluates to 3 *)
hd []	    (* Exception: Match_failure *)
```
 
### "Deep" pattern matching 
You can nest patterns for more precise matches
* `a::b` matches lists with **at least one element** 
	* It matches `[1;2;3]`, binding `a` to `1` and `b` to `[2;3]` 
* `a::[]` matches lists with **exactly one element**
	* It matches `[1]`, binding `a` to `1`. we could also write pattern `a::[]` as `[a]` 
* `a::b::[]` matches lists with **exactly two elements** 
	* It matches [1;2], binding a to 1 and b to 2. We could also write pattern a::b::[] as [a;b] 
* `a::b::c::d` matches lists with **at least three elements**. It matches `[1;2;3]`, binding `a` to `1`, `b` to `2`, `c` to `3`, and `d` to `[]`.

**Cannot write pattern as [a;b;c]::d (why?)**

### Wildcards
An underscore `_` is a wildcard pattern. It matches anything, but doesn’t add any bindings. It is useful to hold a place but discard the value i.e., when the variable does not appear in the branch expression. 

In previous examples, many values of h or t ignored. We can replace with wildcard `_`. 

#### Example
```ocaml
(* cehck if a list is empty *)
let is_empty l = 
  match l with
 [] -> true	 
 | (_::_) -> false

let hd l = match l with (h::_) -> h 
let tl l = match l with (_::t) -> t
```

Outputs
```ocaml
is_empty[1](* evaluates to false *) 
is_empty[ ](* evaluates to true  *)
hd [1;2;3] (* evaluates to 1     *) 
hd [1]     (* evaluates to 1     *)
tl [1;2;3] (* evaluates to [2;3] *)
tl [1]     (* evaluates to [ ]   *)
```
### Pattern Matching – An Abbreviation
If f there’s only one acceptable input, the pattern matching `let f x = match x with p -> e` can be abbreviated to `let f p = e`.  For example: 
```ocaml
let hd l = 
  match l with
  |h::_-> h
```
can be wrriten as:
```ocaml
let hd (h::_) = h
```
```ocaml
let hd l = 
  match l with
  |_::t-> t
```
can be wrriten as:
```ocaml
let tl (_::t) = t
```
```ocaml
let f lst = 
match lst with 
|(x::y::_) -> x + y
```
can be wrriten as:
```ocaml
let f (x::y::_) = x + y
```
```ocaml
let f lst = 
  match lst with 
  |(x::y::[]) -> x + y
```
can be wrriten as:
```ocaml
let g [x; y] = x + y
```
### Pattern Matching Typing
If `e` and `p1`, ..., `pn` each have type `ta`
and `e1`, ..., `en` each have type `tb`, then entire match expression has type `tb`. 

### Polymorphic Types
The sum function works only for int  lists, but the `hd` function works for any type of list. 
```
hd [1; 2; 3]		(* returns 1 *)
hd ["a"; "b"; "c"]	(* returns "a" *)
```
OCaml gives such functions polymorphic types. 
```ocaml
hd : 'a list -> 'a
```
This says the function takes a list of any element type `'a`, and returns something of that same type. These are basically generic types in Java. 
`'a list` is like `List<T>`. 
### Examples Of Polymorphic Types
```ocaml
let tl (_::t) = t
# tl [1; 2; 3];;
- : int list = [2; 3]
# tl [1.0; 2.0];;
- : float list = [2.0]
(* tl : 'a list -> 'a list *)
```
```ocaml
let fst x y = x
# fst 1 “hello”;;
- : int = 1
# fst [1; 2] 1;;
- : int list = [1; 2]
(* fst : 'a -> 'b -> 'a *)
```

```ocaml
let eq x y = x = y   (* let eq x y = (x = y) *)
# eq 1 2;;
-	: bool = false
# eq “hello” “there”;;
- : bool = false
# eq “hello” 1     -- type error
(* eq : 'a -> ’a -> bool *)
```
OCaml can detect non-exhaustive patterns and warn you about them. For example:
```ocaml
let hd l = match l with (h::_) -> h;;
Warning: this pattern-matching is not exhaustive.
Here is an example of a value that is not matched: []

# hd [];;
Exception: Match_failure ("", 1, 11).
```
Therefore, You can’t forget a case because compiler issues inexhaustive pattern-match warning. You can’t duplicate a case because compiler issues unused match case warning. Pattern matching leads to elegant, concise, beautiful code . 

### Lists and Recursion
Lists have a recursive structure and so most functions over lists will be recursive. 
```ocaml
let rec length l = 
  match l with
  |[] -> 0
  | (_::t) -> 1 + (length t)
```
This is just like an inductive definition: 
* The length of the empty list is zero
* The length of a nonempty list is 1 plus the length of the tail. 

Type of length is `'a list -> int`

```ocaml
(* sum of elts in l *) 
let rec sum l = match l with
    [] -> 0
  | (h::t) -> h + (sum t)
```
```ocaml
(* negate elements in list *)
let rec negate l = 
	match l with
     [] -> []
     | (h::t) -> (-h) :: (negate t)
```
```ocaml
(* last element of l *)
let rec last l = match l with
    [x] -> x
  | (h::t) -> last t
```

```ocaml
(* return a list containing all the elements in the list l followed by all the elements in list m *)
•	append l m
let rec append l m = match l with
   [] -> m
 | (x::xs) -> x::(append xs m)
```
```ocaml
rev l  (* reverse list; hint: use append *)
let rec rev l = match l with
    [] -> []
  | (x::xs) -> append (rev xs) (x::[])
```
`rev` takes O(n2) time.  Can you do better? Here is a  clever version of reverse
```ocaml
let rec rev_helper l a = match l with
    [] -> a
  | (x::xs) -> rev_helper xs (x::a)

let rev l = rev_helper l []
```
Let’s give it a try
```ocaml
rev [1; 2; 3] →
rev_helper [1;2;3] [] →
rev_helper [2;3] [1] →
rev_helper [3] [2;1] →
rev_helper [] [3;2;1] →
[3;2;1]
```
```ocaml
(* Check if a value is odd *)

let is_odd x =
		match x mod 2 with
		0 -> false
		| 1 -> true
		| _ -> raise (Invalid_argument "is_odd");;    (* why do we need this? *)
(* try -1 mod 2 *)
```
Negate a value
```ocaml
let neg b = 
	match b with
	| true -> false
	| false -> true;;
	
neg true;;
- : bool = false
neg (10 >20);;
- : bool = true
```
```ocaml
(* Logical implication *)
let imply v = match v with 
		 (true,true)   -> true
	   | (true,false)  -> false
	   | (false,true)  -> true
	   | (false,false) -> true;;
	
val imply : bool * bool -> bool = <fun>
```	
Or, we can make it even simpler:
```ocaml
let imply v = match v with 
  (true,x)  -> x
  | (false,x) -> true;;
val imply : bool * bool -> bool = <fun>
```

For characters, OCaml also recognizes the range patterns in the form of 'c1' .. 'cn' as shorthand for any ASCII character in the range.
```ocaml
let is_vowel c = 
	match c with 
	('a' | 'e' | 'i' | 'o' | 'u') -> true
	| _ -> false;;
```	

```ocaml	
let is_upper x = 
  match x with 
  'A' .. 'Z' -> true
  | _ -> false;;
```	
```ocaml
(* get the last element of a list *)
let rec last l=
	match l with 
	[]->[]
	|[x]->[x]
	|_::t->last t
```	
```ocaml
(* check if x is member of a list *)
let rec member lst x=
		match lst with
		|[]->false
		|h::t->if h = x then true else member t x
	;;
```
```ocaml
(* append list b to list a *)
let rec append a b=
		match a with
		|[]->b
		|h::t-> h::append t b
	;;
```
```ocaml
(* insert x into a sorted list l in sorted order *)
let rec insert x l=
	match l with 
	|[]->[x]
	|h::t->if x < h then x::h::t 
			else h::insert x t
	
(* insertion sort *)
	let rec sort l = 
		match l with 
		[]->[]
		|[x]->[x]
		|h::t->insert h (sort t)
```
	
```ocaml
(* QuickSort *)
let rec qsort = function
		| [] -> []
		| pivot :: rest ->
		let left, right = List.partition (fun x-> x < pivot) rest in
	qsort left @ [pivot] @ qsort right
```	
```ocaml
(* MergeSort *)
(** split list a into two even parts *)
	let split a = 
	let rec aux lst b c = 
		  match lst with
		  [] -> (b, c)
		| hd :: tail -> aux tail c (hd :: b)
	in aux a [] []

(* merge lists xs and ys *)
let rec merge cmp xs ys =
		match (xs, ys) with
		  ([], []) -> [] 
		| (_, []) -> xs 
		| ([], _) -> ys
		| (xhd :: xtail, yhd :: ytail) -> 
		if (cmp xhd yhd) then
			xhd :: (merge cmp xtail ys)
	  else
			yhd :: (merge cmp xs ytail)
	
let rec mergesort cmp os  = 
		match os with
		[] -> []
		| [x] -> [x]
		| _ ->
		  let (ls, rs) = split os in
	merge cmp (mergesort cmp ls) (mergesort cmp rs)
```