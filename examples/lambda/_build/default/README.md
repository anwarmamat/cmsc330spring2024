Lambda Calculus OCaml Implementation

* Compile
```
dune build
```
* Run
```
dune exec lambda
```
* Output
```ocaml
Lambda Expression: λx.x y           
Lambda Expression: Lam(x,App(Var x,Var y))
parsed string: 
λx. x y

Example: if expression

if true then 1 else 2 = 1

if false then 1 else 2 = 2

Example: Addition
3 + 2 = 5

Example: Multiplication
5 * 4 = 20
(5 + 4) * 20 = 180

Example: Integer Deivision
succ(3)/2 =  2

Example: Recursion: Factorial
fact(3) = 6
fact(4) = 24
```

