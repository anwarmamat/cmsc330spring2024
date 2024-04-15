### Fraction module
This module can represent a fraction, but hides how the fraction is implemented. Users have to create the fraction using `make`, but cannot create fractions using `Frac` directly. For example
```
let f = Frac (100,200)
```
will not work. 
```ocaml
let f = Frac (1,2)
```
creates a fraction and reduces it to `1/2`. 

* Fraction Interface
```ocaml
(* Fraction module *)
module type FractionInt = sig
  type fraction (* hide the type *)

  exception BadFrac

  val make : int * int -> fraction
  val add : fraction * fraction -> fraction
  val toString : fraction -> string
end
```

* Compile and Run
```ocaml
ocamlc -c fraction.ml
ocamlc -c main.ml
ocamlc -o main fraction.cmo main.cmo

./main
```