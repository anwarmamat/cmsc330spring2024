(* 
  File simple_set.ml  
  * This file defines the module Simple_set which is a simple functional multiset data structure.
  * Each item (function or type decl) in the file can be accessed as Simple_set.item outside of the module
*)

(* This type declaration is the data structure storing the actual sets (just a list here) 
   Note how we call the type just "t", that is because the full name will be Simple_set.t 
   -- "simple set's type" is how you can read this.  
   OCaml uses a similar convention, e.g. List.t is List's type
    *)


type 'a t = 'a list

let emptyset : 'a t = []

let add (x : 'a) (s : 'a t) = (x :: s)

let rec remove (x : 'a) (s: 'a t)  =
  match s with
  | [] -> failwith "item is not in set"
  | hd :: tl ->
    if  hd = x then tl
    else hd :: remove x tl

let rec contains (x: 'a) (s: 'a t) =
  match s with
  | [] -> false
  | hd :: tl ->
    if x = hd then true else contains x tl



(*
  inline tests
    *)
let%test _ = contains 1000 emptyset = false
let%test _ = contains "alice" emptyset = false
let%test _ = contains 1000 (add 1000 emptyset) = true
let%test _ = contains "alice" (add "alice" emptyset) = false
