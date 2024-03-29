# QCheck: Property Based Testing for OCaml

## install qcheck:
```ocaml
opam install qcheck
```
## open QCheck in toplevel (utop or ocaml)
```
#require "qcheck";;
open QCheck;;
#show QCheck
```

## A Simple Example
```ocaml
open QCheck
let mytest = Test.make float (fun f -> floor f <= f)
let _ = QCheck_runner.run_tests [mytest];;
# success (ran 1 tests)
```

## Generate Random Values
An 'a QCheck.Gen.t is a function that takes in a Pseudorandom number generator, uses it to produce a random value of type 'a. For example, QCheck.Gen.int generates random integers, while  QCheck.Gen.string generates random strings. Let us look at some examples here:

### Generate 100 random integers
```ocaml
Gen.generate ~n:100 Gen.int;;
```
### Generate 2 int lists
```ocaml
let t = Gen.generate ~n:2 (Gen.list Gen.int);;
```
or
```ocaml
let t = Gen.generate ~n:2 (Gen.list Gen.small_int);;
List.map (fun x ->List.length x) t;;
# int list = [46; 32]
```
### generate 2 string list
```ocaml
let s = Gen.generate ~n:2 (Gen.list Gen.string);;
s = [ ["a";"z"]; ["abc";"xyz"...]]
```
### generate a string consists of 'a'-'z'
```ocaml
Gen.generate1 (Gen.string_of (Gen.char_range 'a' 'z'));;
```
## Property Test for List.rev
```ocaml
let rec reverse = List.rev;;
let prop_reverse l = rev (rev l) = l

let test =QCheck.Test.make ~count:1000 
~name:"reverse_test" 
QCheck.(list small_int) (fun x-> prop_reverse x);;
QCheck_runner.run_tests [test];;
```


### buggy reverse 
```ocaml
let rev l = l;;
(* The following property fails to catch the bug *)
let prop_reverse l =
    rev (rev l) = l

(* improved property test *)
let prop_reverse2 l1 x l2 =
             rev (l1@[x]@l2) = rev l2 @ [x] @ rev l1

```


# Another example: delete from a list 
```ocaml
let rec delete x l = match l with
   [] -> []
 | (y::ys) -> if x == y then ys
              else y::(delete x ys)
```
Property of `delete`
```ocaml
let prop_delete x l =
   not (List.mem x (delete x l))
```
Create the test
```ocaml
let test =QCheck.Test.make ~count:1000 ~name:"reverse_test"
(QCheck.pair QCheck.small_int QCheck.(list small_int))
(fun( x, l)-> prop_delete x l)
```
Run the test
```ocaml
QCheck_runner.run_tests [test];;
--- Failure --------------------
(0, [0; 0])
```
The `delete` function failed to delete the other occurences of the given item. Here is fixed `delete':
```ocaml
let rec delete x l = match l with
   [] -> []
 | (y::ys) -> if x == y then (delete x ys)
              else y::(delete x ys)
```


## Advanced Features

### QCheck Iter
```ocaml
let t1 = Iter.of_list [1;2;3];;

t1 (fun x-> Printf.printf "%d\t" x);;
```
*Output*
```
1	2	3
 : unit = ()
```
```
let t2 = Iter.of_list [4;5;6];;
let t3 = Iter.append t1 t2;;

(* let t3 = Iter.(<+>) t1 t2;; *)

t3 (fun x-> Printf.printf "%d\t" x);;
```
*Output*
```
1	2	3	4	5	6
```

### <*>
val (<*>) : ('a -> 'b) t -> 'a t -> 'b t

*convert int list iter to string list iter*

```
let s1 = Iter.(<*>) (Iter.return string_of_int)) t1;;
s1 print_string;;
(*
123- : unit = ()
*)
```
### map
```
let s1 = Iter.map string_of_int t1;;
(* val s1 : string Iter.t = <fun>*)
s1 print_string;;
(*
123
*)
```

### pair
```ocaml
let p1 = Iter.pair t1 s1;;
(*
val p1 : (int * string) Iter.t = <fun>
*)

p1 (fun (a,b)->Printf.printf "%d\t%s\n" a b) ;;

1	1
1	2
1	3
2	1
2	2
2	3
3	1
3	2
3	3
```
