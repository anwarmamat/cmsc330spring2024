## OCaml Modules

When a program is small enough, we can keep all the details of the program in one file. Real application programs are simply too large and complex to hold all their details in our heads. The application code is composed of many different code modules that are developed separately. Modules group associated types, functions, and data together. For lots of sample modules, see the OCaml standard library, e.g., List, Str, etc.

#### Creating A Module In OCaml

Modules in OCaml are implemented by module definitions that have the following syntax:
```ocaml
    (*Module names must begin with an uppercase letter.*)
    module ModuleName = struct 
        (* definitions *) 
    end 
```
* Module Example: ListStack
```ocaml
module ListStack = struct
 let empty = [] 
 let is_empty s = (s = [])
 let push x s = x :: s
 let peek = function
   | [] -> failwith "Empty”
   | x::_ -> x
  let pop = function 
   | [] -> failwith "Empty" 
   | _::xs -> xs 
end 
```
### Scope

After a module has been defined, you can access the names within it using the . operator. For example:
```ocaml
# module M = struct 
    let x = 42 
  end;; 

# M.x;; 
- : int = 42
```
Opening a module brings all the definitions of a module into the current scope. For example:
```ocaml
# module M = struct 
    let x = 42 
  end;;
 
# x;;
Error: Unbound value x 
# open M;; 
# x;; 
- : int = 42
```
If two modules both define the same name, and you open both, any names defined later shadow names defined earlier. 
```ocaml
module M = struct 
    let x = 42 
end
 
module N = struct
 let x = ”CMSC330" 
end 
open M 
open N
```
`x` is `CMSC330` in this scope.

When opening multiple modules, to not to pollute the current scope, you can locally open a module:
```ocaml
Without opening List
let f x = 
  let y = List.filter ((>) 0) x in ... 

```
Or open the List locally
```ocaml
let f x = let open List in
  let y = filter ((>) 0) x in (*[filter] is now  bound to [List.filter]*)
  ...
```

### Module Signatures
* Signatures are interfaces for structures. 

* A signature specifies which components of a structure are accessible from the outside, and with which type.

* It can be used to hide some components of a structure (e.g. local function definitions)

* Convention: Signature names in all-caps. This isn't a strict requirement, though

* Items can be omitted from a module signature. This provides the ability to hide values

* The default signature for a module hides nothing. This is what OCaml gives you if you just type in a module with no signature at the top-level

```ocaml
module type FOO =
  sig
    val add : int -> int -> int
end

module Foo : FOO =
  struct
    let add x y = x + y
    let mult x y = x * y
end

Foo.add 3 4;;    (* OK *)
Foo.mult 3 4;;  (* not accessible *)
```
Because `mult` is not defined in the signature, it is not visible outside the scope of `Foo` module. 

#### Implementing a Signature
```ocaml
module type Sig = 
 sig
  val f : int -> int
 end 

module M1 : Sig = struct
 let f x = x+1 (* Exact the type specified by Sig: int->int *)
end 

module M2 : Sig = struct 
   let f x = x (* Type: 'a -> ‘a, safe to use it for int->int *)
end
```

```
# M2.f;;
- : int -> int
```
#### ListStack
* Signature
```ocaml
module type Stack = sig
  type 'a stack = 'a list  
  val empty    : 'a stack
  val is_empty : 'a stack -> bool
  val push     : 'a -> 'a stack -> 'a stack
  val peek     : 'a stack -> 'a
  val pop      : 'a stack -> 'a stack
end
```
* Implementation
```ocaml
module ListStack: Stack = struct
 type 'a stack = 'a list  
 let empty = []
 let is_empty s = (s = [])

 let push x s = x :: s

 let peek = function
    | [] -> failwith "Empty"
    | x::_ -> x

 let pop = function
    | [] -> failwith "Empty"
    | _::xs -> xs
end
```
* Example
```ocaml
let t = ListStack.empty;;
val t : 'a ListStack.stack = [] (* Implementation is visible to user *)

# let t2 = ListStack.push 10 t;;
val t2 : int ListStack.stack = [10]

# let t3 = ListStack.push 20 t2;;
val t3 : int ListStack.stack = [20; 10]

# ListStack.peek t3;;
- : int = 20

# let t4 = ListStack.pop t3;;
val t4 : int ListStack.stack = [10]
```
#### Abstract Types
* The type 'a stack below is abstract
* A module that implements Stack
    * must specify concrete types for the abstract type 'a stack
    * define all the names declared in the signature. 

* Signature 
```ocaml
module type Stack = sig
  type 'a stack (* Type is abstract *)
  val empty    : 'a stack
  val is_empty : 'a stack -> bool
  val push     : 'a -> 'a stack -> 'a stack
  val peek     : 'a stack -> 'a
  val pop      : 'a stack -> 'a stack
end
```
* Implementation:
```ocaml
module ListStack: Stack = struct
 type 'a stack = 'a list  
 let empty = []
 let is_empty s = (s = [])

 let push x s = x :: s

 let peek = function
    | [] -> failwith "Empty"
    | x::_ -> x

 let pop = function
    | [] -> failwith "Empty"
    | _::xs -> xs
end
```
* Example
```ocaml
let t = ListStack.empty;;
val t : 'a ListStack.stack = <abstr>

# let t2 = ListStack.push 10 t;;
val t2 : int ListStack.stack = <abstr>

# let t3 = ListStack.push 20 t2;;
val t3 : int ListStack.stack = <abstr>

# ListStack.peek t3;;
- : int = 20

# let t4 = ListStack.pop t3;;
val t4 : int ListStack.stack = <abstr>
```

* Another Implementation: VariantStack
```ocaml
module MyStack : Stack = struct
  type 'a stack = 
    | Empty 
    | Entry of 'a * 'a stack

  let empty = Empty
  let is_empty s = s = Empty
  let push x s = Entry (x, s)
  let peek = function
    | Empty -> failwith "Empty"
    | Entry(x,_) -> x
  let pop = function
    | Empty -> failwith "Empty"
    | Entry(_,s) -> s
end
```

#### Functional Data Structures
* Immutable, Persistent data structures
* Updating the data structure with one of its operations does not change the existing version of the data structure but instead produces a new version
```ocaml
# open ListStack;;
let s = empty;;
let s2 = push 10 s
let s3 = push 20 s2 (* Push to s2 does not destroy s2, but creates new s3*)
```

#### Loading Compiled Modules into Toplevel
```ocaml
#directory "_build";;
#load "liststack.cmo";;
# open Liststack;;

#show ListStack;;
module ListStack : Stack.Stack

# ListStack.empty;;
- : 'a Liststack.ListStack.stack = <abstr>
```

Suppose we wanted to add a function max to the List module that returns the max item from the list
```ocaml
module MyList = struct include List
  let max lst = … (* implementation *)
end;;

#show MyList;;
- All the list function and max
```