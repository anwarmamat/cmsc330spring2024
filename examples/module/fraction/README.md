###  Fraction module 
This module can represent a fraction such as 3/4, perform addition on fractions, and convert the fraction into a string. For example:
```ocaml
let f1 = Fraction.make(2,8);;
let f2 = Fraction.make(25,100);;
let _= Printf.printf "%s + %s = %s\n"
  (Fraction.toString f1)
  (Fraction.toString f2)  
  (Fraction.toString (Fraction.add (f1,f2)))
```
Output: 
```ocaml
1/4 + 1/4 = 1/2
```
* Fraction Interface
```ocaml
module type FRACTION = sig
  type fraction = Frac of int * int (* hide the type *)

  exception BadFrac

  (*val gcd : int * int -> int*)
  (* gcd is not visible outside the module *)
  (*val reduce : fraction -> fraction*)
  val make : int * int -> fraction
  val add : fraction * fraction -> fraction
  val toString : fraction -> string
end

```
Fraction Module
```ocaml
module Fraction : FRACTION = struct
  type fraction = Frac of int * int

  exception BadFrac

  let rec gcd (x, y) =
    let x, y = if x >= y then (x, y) else (y, x) in
    if y = 0 then x else gcd (y, x mod y)

  let reduce (Frac (x, y)) =
    let d = gcd (x, y) in
    Frac (x / d, y / d)

  (* denominator cannot be 0 *)
  let make (x, y) = if y = 0 then raise BadFrac else reduce (Frac (x, y))

  let add (r1, r2) =
    match (r1, r2) with
    | Frac (a, b), Frac (c, d) -> reduce (Frac ((a * d) + (b * c), b * d))

  let toString (Frac (a, b)) =
    if b = 1 then string_of_int a
    else if a = 0 then "0"
    else string_of_int a ^ "/" ^ string_of_int b
end
```

* To Compile  and Run
```ocaml
ocamlc -c fraction.ml
ocamlc -c main.ml
ocamlc -o main fraction.cmo main.cmo

./main

Or

ocamlbuild main.byte
./main.byte
```