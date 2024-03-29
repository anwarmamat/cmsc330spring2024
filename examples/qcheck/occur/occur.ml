open OUnit2
open QCheck

let fold = List.fold_left
let contains_elem lst e = fold (fun a x -> if e = x then true else a) false lst
let is_present lst x = List.map (fun a -> if a = x then 1 else 0) lst

let count_occ lst target =
  (*	fold (fun a x -> if x = target then a + 1 else a) 0 lst *)
  fold ( + ) 0 (is_present lst target)

let gen_occur =
  make
    (let open Gen in
     small_int >>= fun n ->
     list (int_range min_int (n - 1)) >>= fun l1 ->
     list (int_range (n + 1) (max_int - 1)) >>= fun l2 ->
     list (return n) >>= fun l3 ->
     let a = shuffle_l (l1 @ l2 @ l3) in
     let b = return (List.length l3) in
     triple a b (return n))

(* Tests for count_occ *)
let test_count_occ =
  Test.make ~name:"test_count_occ2" ~count:1000 gen_occur
    (fun (lst, count, item) -> count_occ lst item = count)

let suite = "public" >::: [ QCheck_runner.to_ounit2_test test_count_occ ]
let _ = run_test_tt_main suite
