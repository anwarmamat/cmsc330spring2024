(*If you try this example in utop, add 

#require "qcheck";;

*)

open QCheck

(* Reverse a list *)
let rec reverse lst = 
   List.fold_left (fun acc x->x::acc) [] lst
  
(* two properties of the `reverse` function *)
let prop_reverse l = reverse (reverse l) = l;;

let prop_reverse2 l1 m l2 =
  reverse (l1 @ [m] @ l2) = reverse l2 @ [m] @ reverse l1

let test1 =
  Test.make
  ~count:1000 
  ~name:"reverse_test" 
  QCheck.(list small_int) 
 (fun x-> prop_reverse x)
;;

let test2 =
  Test.make
  ~count:1000 
  ~name:"reverse_test" 
  QCheck.(triple (list small_int) small_int (list small_int))
  (fun (l1, m, l2)-> prop_reverse2 l1 m l2 )
;;

 QCheck_runner.run_tests 
   ~verbose:true 
  [test1; test2];;


                                                             
