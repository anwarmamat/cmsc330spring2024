#require "qcheck";;

open QCheck

let rec delete x l =
  match l with 
    [] -> []
  | (y::ys) -> if x == y then ys 
               else y::(delete x ys)
             
let prop_delete x l =
   not (List.mem x (delete x l))

let test_delete =
  Test.make
    ~count:1000 
    ~name:"delete_test" 
    (pair small_int (list small_int)) 
    (fun (x,l)-> prop_delete x l)
 ;;
 
 QCheck_runner.run_tests ~verbose:true [test_delete];;


                                                             
