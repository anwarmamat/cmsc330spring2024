open OUnit2
open Parser2.Lexer
open Parser2.Parser
open Parser2.Parsetree
let root:Node.t = {id=0;label="E"};;

let test_assign1 _ = 
  let exps = [
      "{ x=3; {y=4;};}";
      "{}";
      "{x=3;}";
      "{{};{};}";
    ]
  in
          
  List.iter (fun e ->
      let tokens = tokenize e in 
      let (_,ast) = parse_E root tokens in
      let e2 =  (ast_to_str ast) in 
      let e =  Str.global_replace (Str.regexp "[\r\n\t ]") "" e in
      assert_equal e e2 ~msg:("src:" ^ e ^ "\tdst:" ^ e2)
    ) exps
  
let suite =
  "public" >::: [
    "assign1" >:: test_assign1
  ]

let _ = run_test_tt_main suite
