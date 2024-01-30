
open OUnit2
open Simple_set

let tests = "test suite for rev" >::: [
  "empty"  >:: (fun _ -> assert_equal (emptyset) (emptyset));
  "3-elt"    >:: (fun _ -> assert_equal true (contains 5 (add 5 emptyset)));
  "1-elt nested" >:: (fun _ -> assert_equal false (contains 5 (remove 5 (add 5 emptyset))));
]

let _ = run_test_tt_main tests
