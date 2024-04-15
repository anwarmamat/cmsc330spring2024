open Liststack;;

Printf.printf "ListStack Exmple\n"
   
let t = ListStack.empty

let t2 = ListStack.push 10 t

let t3 = ListStack.push 20 t2
let t4 = ListStack.push 30 t3

let t5 = ListStack.peek t4

let x:int = t5;;
Printf.printf "%d\n" x

let t4 = ListStack.pop t4
       
let t5 = ListStack.peek t4
let x:int = t5;;
Printf.printf "%d\n" x;;

 
