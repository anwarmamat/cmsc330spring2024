open Parser2.Lexer
open Parser2.Parser
open Parser2.Parsetree

let root:Node.t = {id=0;label="E"};;

(*
  E → id = n | { L }
  L → E ; L | ε
 *)


let main () =
  let e = "{x=3; {y=4;};}" in
  let tokens = tokenize e in 
  let (_,ast) = parse_E root tokens in
  let _ = g_to_dot g "parsetree.dot" in 
  Printf.printf "exp:%s\tast:%s\n" e (ast_to_str ast)
  
let _ = main ();;

