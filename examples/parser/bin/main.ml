
open Libs.Parser
open Libs.Lexer
open Libs.Tokens
open Libs.Interp
open Libs.Ast

let pp = Printf.printf
(*
  function eval_str : given string, parse string, build AST,
  	evaluate value of AST
*)

let eval_str str =
  let tokens = tokenize str in

  pp "Input token list = ";
  List.iter (fun x -> pp " %s" (string_of_token x)) tokens;
  pp "\n";

  let (a, t) = parse_S tokens in
  if t <> [ Tok_END ] then raise (IllegalExpression "parse_S");
  pp "AST produced = %s\n" (expr_to_str a);
  let v = eval a in
  pp "Value of AST = %d\n" v;
;;

eval_str "1*2*3*4*5*6";;
eval_str "1+2+3*4*5+6";;
eval_str "1+(2+3)*4*5+6";;
eval_str "100 *      (10 + 20)";;
(* eval_str "(2^5)*2";;  error *)
(* eval_str "1++12"  error *)