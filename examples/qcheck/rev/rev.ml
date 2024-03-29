(*try this example in UTOP *)

#require "qcheck";;

open QCheck

let reverse = List.rev;;

let prop_reverse l = reverse (reverse l) = l;;

let test =
  Test.make
  ~count:1000 
  ~name:"reverse_test" 
  QCheck.(list small_int) 
 (fun x-> prop_reverse x)
;;

 QCheck_runner.run_tests ~verbose:true [test];;


                                                             
