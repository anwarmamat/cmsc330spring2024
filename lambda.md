# Lambda Calculus ( λ-calculus)

* Turing Completeness

Turing machines are the most powerful description of computation possible. They define the Turing-computable functions. A programming language is Turing complete if:
* It can map every Turing machine to a program.
* A program can be written to emulate a Turing machine. 
* It is a superset of a known Turing-complete language

Real programming languages are more expressive. So what language features are needed to express all computable functions? What’s a minimal language that is Turing Complete? Some features exist just for convenience. For example:
* Multi-argument functions	`foo ( a, b, c )` can be implemented using currying or tuples
* Loops	`while (a < b) …`  can implemtned using recursion 
* Side effects `a := 1`. We can use functional programming pass “heap” as an argument to each function, return it when with function’s result: effectful : ‘a → ‘s → (‘s * ‘a)

It is not difficult to achieve Turing Completeness. Lots of things are ‘accidentally’ Turing Complete. 

Some fun examples:
* x86_64 `mov` instruction
* Minecraft			
* Magic: The Gathering
* Java Generics

But: What is a “core” language that is TC?

### Lambda Calculus (λ-calculus)
Proposed in 1930s by Alonzo Church. It is a formal system designed to investigate functions & recursion and for exploration of foundations of mathematics. Now it is used as a tool for investigating computability. It is the basis of functional programming languages Lisp, Scheme, ML, OCaml, Haskell…

It is a “core” language, very small but still Turing complete. With it , we can explore general ideas such as Language features, semantics, proof systems, algorithms. Many ideas in Lambda calculus such as higher-order, anonymous functions (aka lambdas) are now very popular in other modern languages. 

### Lambda Calculus Syntax
A lambda calculus expression is defined as
```ocaml
e ::=    x	    		variable
         |  λx.e		abstraction (fun def)
         |  e e			application (fun call)

```
### Three Conventions
* Scope of λ extends as far right as possible unless the scope is delimited by parentheses. For example: 
    * `λx. λy.x y` is same as `λx.(λy.(x y))`. 
    * `λx.(y z)` is same as `λx.y z`. 
    * `λx.x a b` is same as `(λx.((x a) b))`

* Function application is left-associative
`x y z` is `(x y) z`. This is same rule as OCaml

* As a convenience, we use the following “syntactic sugar” for local declarations
`let x = e1 in e2` is short for `(λx.e2) e1`


### Lambda Calculus Semantics

* Evaluation: 

All that’s involved are function calls `(λx.e1) e2`. It evaluates `e1` with `x` replaced by `e2`. This application is called `beta-reduction`. 
```ocaml
(λx.e1) e2 → e1[x:=e2]
```
`e1[x:=e2]` is `e1` with occurrences of `x` replaced by `e2`. This operation is called substitution. It replaces formals with actuals instead of using environment to map formals to actuals. We allow reductions to occur anywhere in a term and order reductions are applied does not affect final value. When a term cannot be reduced further it is in beta normal form. 

* Beta Reduction Examples
```
(λx.λz.x z) y 			
→ (λx.(λz.(x z))) y 	// since λ extends to right

→ (λx.(λz.(x z))) y 	// apply (λx.e1) e2 → e1[x:=e2]
                        // where e1 = λz.(x z), e2 = y

→ λz.(y z)	 		// final result
```

* Call by value
Before doing a beta reduction, we make sure the argument cannot, itself, be further evaluated. This is known as call-by-value (CBV). For example:
```
(λz.z) ((λy.y) x) → (λz.z) x → x

```
Call by name
Instead of the CBV strategy, we can specifically choose to perform beta-reduction before we evaluate the argument. This is known as call-by-name (CBN). For example:
```
(λz.z) ((λy.y) x) → (λy.y) x → x
```
### Static Scoping & Alpha Conversion
Lambda calculus uses static scoping. Consider the following
```
(λx.x (λx.x)) z → ?
```
The rightmost “x” refers to the second binding. This is a function that takes its argument and applies it to the identity function. This function is “the same” as 
```
(λx.x (λy.y))
```
Renaming bound variables consistently preserves meaning. This is called `alpha-renaming` or `alpha conversion`.
Example:
```
λx.x = λy.y = λz.z
λy.λx.y = λz.λx.z
```
To beta reduce `(λx.λy.x y) y`, when we replace `y` inside, we don’t want it to be captured by the inner binding of `y`, as this violates static scoping:
I.e., `(λx.λy.x y) y ≠ λy.y y`. 

Because `(λx.λy.x y)` is “the same” as `(λx.λz.x z)` due to alpha conversion, we alpha-convert `(λx.λy.x y) y` to `(λx.λz.x z) y` first. Now 
```
(λx.λz.x z) y → λz.y z
```
### Defining Substitution
Use recursion on structure of terms
* x[x:=e] = e	// Replace x by e
* y[x:=e] = y 	// y is different than x, so no effect
* (e1 e2)[x:=e] = (e1[x:=e]) (e2[x:=e])
            // Substitute both parts of application
* (λx.e’)[x:=e] = λx.e’
    * In λx.e’, the x is a parameter, and thus a local variable that is different from other x’s. Implements static scoping.
    So the substitution has no effect in this case, since the x being substituted for is different from the parameter x that is in e’
* (λy.e’)[x:=e] = λw.((e’ [y:=w]) [x:=e]) (w is fresh)
    *   The parameter y does not share the same name as x, the variable being substituted for

### Implement Lambda Calculus in OCaml

[Lambda Calculus OCaml Cource Code](examples/lambda)

```
type var = string

type exp =
    Var of var
  | Lam of var * exp
  | App of exp * exp
```
Example:
| λ Expression | AST |
| - | - |
|y | Var “y”
| λx.x | Lam (“x”, Var “x”) |
| λx.λy.x y | Lam (“x”,(Lam(“y”,App (Var “x”, Var “y”)))) |
|(λx.λy.x y) (λx.x x) |App (Lam(“x”,Lam(“y”,App(Var“x”,Var“y”))), Lam (“x”, App (Var “x”, Var “x”)))



  ### Church Encodings
  Church encoding is a means of representing data and operators in the lambda calculus. Chruch encodign maps constructs such as 
* Let bindings
* Booleans
* Pairs
* Natural numbers & arithmetic
* Looping

to higher order functions. 

#### Let bindings

Local variable declarations are like defining a function and applying it immediately (once):
```
let x = e1 in e2 = (λx.e2) e1
```
Example:
```
let x = (λy.y) in x x = (λx.x x) (λy.y) 
```
where `(λx.x x) (λy.y)` can be reduced to
```
(λx.x x) (λy.y) → (λx.x x) (λy.y) → (λy.y) (λy.y) → (λy.y)
```
#### Booleans


```
true = λx.λy.x
false = λx.λy.y
if a then b else c = a b c
```
Examples
```
if true then b else c = (λx.λy.x) b c → (λy.b) c → b
if false then b else c = (λx.λy.y) b c → (λy.y) c → c
```
Other Boolean operations
* not
```
not = λx.x false true
```
Example:
```
true = λx.λy.x
false = λx.λy.y
not = λx.x false true = (λx.x (λx.λy.y) (λx.λy.x))

not true =
(λx.x (λx.λy.y) (λx.λy.x)) (λx.λy.x)
(λx.x(λx.λy.y)(λx.λy.x))(λx.λy.x)
(λx.λy.x)(λx.λy.y)(λx.λy.x)
(λy.λx.λy.y)(λx.λy.x)
λx.λy.y = false

not false =
(λx.x(λx.λy.y)(λx.λy.x))(λx.λy.y)
(λx.λy.y)(λx.λy.y)(λx.λy.x)
(λy.y)(λx.λy.x)
λx.λy.x = true
```
* and 
```
and = λx.λy.x y false
and x y = if x then y else false
```
Examples:
```
true = λx.λy.x
false = λx.λy.y
and = λx.λy.x y false

and true true = 
(λx.λy.x y (λx.λy.y)) (λx.λy.x) (λx.λy.x)
(λx.λy.xy(λx.λy.y))(λx.λy.x)(λx.λy.x)
(λy.(λx.λy.x)y(λx.λy.y))(λx.λy.x)
(λx.λy.x)(λx.λy.x)(λx.λy.y)
(λy.λx.λy.x)(λx.λy.y)
λx.λy.x = true


and true false = 
(λx.λy.xy(λx.λy.y))(λx.λy.x)(λx.λy.y)
(λy.(λx.λy.x)y(λx.λy.y))(λx.λy.y)
(λx.λy.x)(λx.λy.y)(λx.λy.y)
(λy.λx.λy.y)(λx.λy.y)
λx.λy.y = false

```
* or
```
or = λx.λy.x true y
```
Examples:
```
true = λx.λy.x
false = λx.λy.y
or = λx.λy.x true y = λx.λy.x (λx.λy.x) y

or true false = 
(λx.λy.x (λx.λy.x) y) (λx.λy.x) (λx.λy.y)
(λx.λy.x(λx.λy.x)y)(λx.λy.x)(λx.λy.y)
(λy.(λx.λy.x)(λx.λy.x)y)(λx.λy.y)
(λx.λy.x)(λx.λy.x)(λx.λy.y)
(λy.λx.λy.x)(λx.λy.y)
λx.λy.x = true

or false false = 
(λx.λy.x (λx.λy.x) y) (λx.λy.y) (λx.λy.y)
(λx.λy.x(λx.λy.x)y)(λx.λy.y)(λx.λy.y)
(λy.(λx.λy.y)(λx.λy.x)y)(λx.λy.y)
(λx.λy.y)(λx.λy.x)(λx.λy.y)
(λy.y)(λx.λy.y)
λx.λy.y = false
```
Given these operations, we can build up a logical inference system
#### Pairs
#### Natural Numbers
#### Arithmetic Using Church Numerals
#### Looping+Recursion
