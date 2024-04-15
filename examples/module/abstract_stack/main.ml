open Liststack

open Varstack       
;;

Printf.printf "ListStack Exmple\n"
   
(* create an empty stack *)
let t1 = ListStack.empty

(* add items to the stack *)
let t2 = ListStack.push 10 t1
let t3 = ListStack.push 20 t2
let t4 = ListStack.push 30 t3
let v1:int = ListStack.peek t4

let _ = Printf.printf "%d\n" v1
let t4 = ListStack.pop t4  
let v2 = ListStack.peek t4
let () = Printf.printf "%d\n" v2;;

           
(* ---------------------- *)
Printf.printf "VariantStack Exmple\n"
   
let t = VarStack.empty
let t2 = VarStack.push 10 t
let t3 = VarStack.push 20 t2
let t4 = VarStack.push 30 t3
let v1 = VarStack.peek t4

let _ = Printf.printf "%d\n" v1

let t4 = VarStack.pop t4     
let v2 = VarStack.peek t4
let _= Printf.printf "%d\n" v2

