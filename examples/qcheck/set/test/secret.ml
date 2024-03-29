open OUnit2
open Strset

let test_add =
 QCheck.Test.make
 ~name:"test_insert"
 ~count:1000
 (QCheck.string)
 (fun x->
    let _= Printf.printf "%s\n" x in
    let s = SS.empty in
    let s = SS.add x s in
    SS.mem x s
)


let suite =
  "secret" >::: [
  QCheck_runner.to_ounit2_test test_add
 ]



let _ = run_test_tt_main suite
			     
			  
