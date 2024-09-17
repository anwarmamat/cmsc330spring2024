

## OCaml Imperative Programming
So Far, Only Functional Programming We haven’t given you any way so far to change something in memory. All you can do is create new values from old. This makes programming easier since it supports mathematical (i.e., functional) reasoning. 
* Don’t care whether data is shared in memory
* Aliasing is irrelevant
* Calling a function f with the same argument always produces the same result.  For all `x` and `y`, we have `f x = f y` when `x = y`
But sometimes it is useful for values to change. We may need a unique counter that increments in every call or we may need an efficient hash table. OCaml variables are immutable, but OCaml has `references`, `fields`, and `arrays` that are actually mutable, I.e., they can change

### Refs
There are two built-in mutable data structures in OCaml: `refs` and `arrays`. `'a ref` is pointer to a mutable value of type `'a`. There are three basic operations on references:
* Allocate a reference
```ocaml
  ref  : 'a -> 'a ref
```
* Read the value stored in reference
```ocaml
  !    : 'a ref -> 'a
  ```
* Change the value stored in reference
```ocaml
  :=   : 'a ref -> 'a -> unit
```
Binding variable `x` to a reference is immutable. The contents of the reference x points to may change.
#### Example
```ocaml
# let z = 3;;
  val z : int = 3
# let x = ref z;;
  val x : int ref = {contents = 3}
# let y = x;;
  val y : int ref = {contents = 3}
```
Here, `z` is bound to 3. It is immutable.  `x` and `y` are bound to a reference. The `contents` of the reference is mutable. 
```ocaml
x := 4;;
```
will update the `contests` to 4. `x` and `y` now points to the value 4. 
```ocaml
x := 4;;
!y;;
  - : int = 4
```
Here, variables y and x are aliases. In `let y = x`, variable `x` evaluates to a location, and `y` is bound to the same location. So, changing the contents of that location will cause both `!x` and `!y` to change. 

### References: Syntax and Semantics
* Syntax: 
```ocaml
ref e
```
* Evaluation

Evaluate `e` to a value `v`, allocate a new location loc in memory to hold `v`, store `v` in `contents` of memory at loc, return loc (which is itself a value).

* Type checking 
```
(ref e)  : t ref  if  e : t 
```

* Syntax: assignment
```ocaml
e1 := e2
```
* Evaluation

Evaluate `e2` to a value `v2`, evaluate e1 to a location loc, store `v2` in `contents` of memory at loc, return `()`

* Type checking 
```ocaml
(e1 := e2)  : unit if e1 : t ref and e2 : t 
```
* Syntax: Reading the contents of a reference
```ocaml
!e
```
* Evaluation

Evaluate e to a location loc, return contents v of memory at loc 

* Type checking 
```ocaml
!e  : t if e : t ref
```

Syntax: sequence
```ocaml
e1; e2
```
`e1; e2` is the same as `let () = e1 in e2`

* Evaluation

Evaluate e1 to a value `v1`, evaluate `e2` to a value `v2`, return `v2`. It throws away `v1` – so `e1` is useful only if it has side effects, e.g., if it modifies a reference’s contents or accesses a file.

* Type checking 
```ocaml
e1;e2  : t if e1 : unit and e2 : t
```
### `;;` versus `;`
`;;` ends an expression in the top-level of OCaml. Use it to say:  “Give me the value of this expression”. It is not used in the body of a function. It is not needed after each function definition. 

`e1; e2` evaluates `e1` and then `e2`, and returns `e2`
```ocaml
let print_both (s, t) = 
  print_string s; 
  print_string t;
  "Printed s and t"
```
notice no `;` at end − it’s a separator, not a terminator. 
`print_both (”Colorless green ", ”ideas sleep")` Prints `”Colorless green ideas sleep"`, and returns `"Printed s and t"`. 

* Grouping Sequences

If you’re not sure about the scoping rules, use begin...end, or parentheses, to group together statements with semicolons
```ocaml
let x = ref 0
  let f () =
    begin
      print_string "hello";
      x := !x + 1
    end
```
```ocaml
let x = ref 0
  let f () =
    (
      print_string "hello";
      x := !x + 1
    )
```
### Examples – Semicolon
```ocaml
1 ; 2 ;;
(* 2 – value of 2nd expression is returned *)	
(1 + 2) ; 4 ;;
(* 4 – value of 2nd expression is returned *)	
1 + (2 ; 4) ;;
(* 5 – value of 2nd expression is returned to 1 + *)
1 + 2 ; 4 ;;
(* 4 – because + has higher precedence than ; *)
```
#### Implement a Counter
```ocaml
# let counter = ref 0 ;;
val counter : int ref = { contents=0 }

# let next = 
    fun () -> counter := !counter + 1; !counter ;;
val next : unit -> int = <fun>

# next ();;
 : int = 1

# next ();;
 : int = 2
```
In this implementation, the `counter` is visible outside the `next` function. For example:
```ocaml
# next ();;
 : int = 1
# next ();;
 : int = 2
let _ = count := 0;
# next ();;
 : int = 1
```
The last call to `next` did not increment the counter, instead returned 1. It is not the preferred behavior of `next`.

To avoid this, we can hide the reference
```ocaml
let next =
  let ctr = ref 0 in
  fun () -> 
      ctr := !ctr + 1; !ctr
```
Here is the visulization of hiding the Reference
![Counter](/images/counter.png "Counter")
### The Trade-Off Of Side Effects
Side effects are necessary. That’s usually why we run software!  We want something to happen that we can observe. But they also make reasoning harder. 
* Order of evaluation now matters
* No referential transparency. Calling the same function with the same arguments may produce different results
* Aliasing may result in hard-to-understand bugs. If we call a function with refs r1 and r2, it might do strange things if r1 and r2 are aliases

#### Order of Evaluation
Consider this example
```ocaml
let y = ref 1;;
let f _ z = z+1;;  (* ignores first arg *)
let w = f (y:=2) !y;;
w;;
```
* What is w if f’s arguments are evaluated left to right?
    * 3
* What if they are evaluated right to left?
    *  2

In OCaml, the order of evaluation is unspecified. This means that the language doesn’t take a stand, and different implementations may do different things. On Mac, OCaml bytecode interpreter and x86 native code evaluates right to left. You should strive to make your programs produce the same answer regardless of evaluation order. 

**Quiz: If evaluation order is left to right, rather than right to left?
Will `w`’s value differ?**
```ocaml
let y   =  ref 1 in
let f z =  z := !z+1; !z in 
let w   =  (f y) + (f y) in
w
```
Answer: No

**Quiz: If evaluation order is left to right, rather than right to left?
, will w’s value differ?**
```ocaml
let y   =  ref 1 in
let f z =  z := !z+1; !z in 
let w   =  (f y) + !y in
w
```
Answer: Yes.

** Quiz: Which f is not referentially transparent? (I.e., not the case that f x = f y for all x = y) ?***
```OCaml
A. let f z =
    let y = ref z in
    y := !y + z;
    !y
B. let f =
    let y = ref 0 in
    fun z -> 
     y := !y + z; !y
C. let f z =
    let y = z in
    y+z
D. let f z = z+1
```    
Answer: B

### Structural vs. Physical Equality
 * `=` compares objects structurally. `<>` is the negation of structural equality
* `==` compares objects physically.  `!=` is the negation of physical equality

#### Examples
```ocaml
([1;2;3]  =  [1;2;3]) = true    
([1;2;3] <> [1;2;3]) = false 
([1;2;3] == [1;2;3]) = false  
([1;2;3]  != [1;2;3]) = true
```
We mostly use `=` and `<>`. E.g., the `=` operator is used for pattern matching. But `=` is a problem with cyclic data structures. If a linked list have a cycle, `=` will not terminate. 

#### Equality of refs
Refs are compared structurally by their contents, physically by their addresses
```ocaml
ref 1 = ref 1                 (* true *)
ref 1 <> ref 2               (* true *)
ref 1 != ref 1                (* true *)
let x = ref 1 in x == x   (* true *)
```

### Mutable fields
Fields of a record type can be declared as mutable.  For example, here is a record type for students whose field `grade` is mutable: 
```ocaml
(* create a record type student with fields name, id, and grade *)
type point={name:string; id:int; mutable grade:char}
# type point = { name : string; id : int; mutable grade : char; }

(* create a student record *)
let s = {name="john"; id=1234; grade='B'};;
# val s : point = {name = "john"; id = 1234; grade = 'B'}

(* mutate the grade for the student s *)
s.grade <- 'A';;
# - : unit = ()

s;;
# - : point = {name = "john"; id = 1234; grade = 'A'}
```

#### Implementing Refs
Ref cells are essentially syntactic sugar for a record type with a mutable fiels called `contents`.
```ocaml
type 'a ref = { mutable contents: 'a }
let ref x = { contents = x }
let (!) r = r.contents
let (:=) r newval = r.contents <- newval
```
`ref` type is declared in Stdlib. `ref` functions are compiled to equivalents of above.

#### Arrays
Arrays generalize ref cells from a single mutable value to a sequence of mutable values
```ocaml
	# let v = [|0.; 1.|];;
	val v : float array = [|0.; 1.|]

	# v.(0) <- 5.;;
     - : unit = ()

	# v;;
	- : float array = [|5.; 1.|]
```
* Arrays Syntax: 
```ocaml
[|e1; ...; en|]
```
* Evaluation 

Evaluates to an n-element array, whose elements are initialized to v1 … vn, where e1 evaluates to v1, ..., en evaluates to vn
Evaluates them right to left

* Type checking
```ocml
[|e1; …; en|] : t array  If for all i, each ei : t
```

Syntax: Random access
```ocaml
e1.(e2) 
```
* Evaluation

Evaluate e2 to integer value v2, evaluate e1 to array value v1, If 0 ≤ v2 < n, where n is the length of array v1, then return element at offset v2 of v1
Else raise Invalid_argument exception

* Type checking:
```ocaml
 e1.(e2) : t if e1 : t array and e2 : int 
```

Syntax: Array update
```ocaml
e1.(e2) <- e3
```
* Evaluation

Evaluate e3 to v3, evaluate e2 to integer value v2, evaluate e1 to array value v1, if 0 ≤ v2 < n, where n is the length of array v1, then update element at offset v2 of v1 to v3, else raise Invalid_argument exception. It returns `()`.

* Type checking
```ocaml
e1.(e2) <- e3 : unit if e1 : t array and e2 : int and e3 : t
``` 

#### Control structures
Traditional loop structures are useful with imperative features:
```ocaml
while e1 do e2 done
for x=e1 to e2 do e3 done
for x=e1 downto e2 do e3 done
```
#### Example
```ocaml
for i = 1 to 5  do
  Printf.printf "%d " i
done;;
1 2 3 4 5,
```

#### Hashtbl Module
```ocaml
let h = Hashtbl.create 1331;
Hashtbl.add h "alice" 100;;     
Hashtbl.add h "bob" 200;;
Hashtbl.iter (Printf.printf "(%s,%d)\n")  h;;


(alice,100)
(bob,200)
```
#### List.assoc as Map
An association list is an easy implementation of a map (aka dictionary)
```ocaml
let d = [("alice", 100); ("bob", 200); 
        ("cathy", 300)]. (* (string * int) list *)
# List.assoc "alice" d;;
    - : int = 100

List.assoc "frank" d;;
  Exception: Not_found.
```

#### Build a Map Using Functions
```ocaml
let empty v = fun _-> 0;;
let update m k v = fun s->if k=s then v else m s
let m = empty 0;;
let m = update m "foo" 100;;
let m = update m "bar" 200;;
let m = update m "baz" 300;;
m "foo";; (* 100 *)
m "bar";; (* 200 *) 
let m = update m "foo" 101;;
m "foo";; (* 101 *)
```
**Challenge: change the code to return all the values for a key**
