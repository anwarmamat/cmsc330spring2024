open QCheck

(* buggy even number function. It fails if the input is greater than 101 *)   
let even n = 
  if n > 101 then false 
  else n mod 2 = 0
;;

(* Srinks the integer by subtracting 2 *)
let shrink_int32 x yield =
    if x>0 then yield (x-2);
    ()

let g = set_shrink shrink_int32  (int_range 1 200);;
let t = set_shrink Shrink.nil  (int_range 1 1000);;


(* Property test for even  *)
let  test_even = 
  Test.make
    ~name:"test_even"
    ~count:1000 (* number of tests *)
   (set_shrink shrink_int32  (int_range 1 200))
    (fun n ->
      even n  = (n mod 2 = 0) 
    )
;;

(* run the test *)
(* 
debug_shrink shows the steps of shrinking a random integer by repeatedly subtracting 2*)

QCheck_runner.run_tests 
  ~verbose:true
  ?debug_shrink:(Some (Some Stdio.stdout))
  [
    test_even
  ]
;;
