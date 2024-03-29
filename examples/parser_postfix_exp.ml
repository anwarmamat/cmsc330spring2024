(*
 Postfix expression parser   
*)
(*
Grammar:

S ⇒ N S + ∣ N S − ∣N
N ⇒ n (* n is a number *)

Example: 10 20 30 + -  ⇒  10 - (20+30) 

AST: Sub (Num 10, Add (Num 20, Num 30))

*)

(* Tokens *)
type tok = Tok_Int of int | Tok_Plus | Tok_Minus | Tok_END

(* AST *)
type ast = Num of int | Add of ast * ast | Sub of ast * ast

let lookahead lst =
  match lst with [] -> failwith "error: lookahead" | h :: t -> h

let match_tok lst tok =
  match lst with h :: t when h = tok -> t | _ -> failwith "error match_tok"

let rec parse_S tokens =
  let e1, toks = parse_N tokens in
  match (lookahead toks) with
  | Tok_Int x -> (
      let e2, toks = parse_S toks in
      match lookahead toks with
      | Tok_Plus ->
          let toks = match_tok toks Tok_Plus in
          (Add (e1, e2), toks)
      | Tok_Minus ->
          let toks = match_tok toks Tok_Minus in
          (Sub (e1, e2), toks)
      | _ -> failwith "parse_error Tok_S")
  | _ -> (e1, toks (* failwith "parse error"*))

and parse_N tokens =
  match lookahead tokens with
  | Tok_Int x ->
      let t = match_tok tokens (Tok_Int x) in
      (Num x, t)
  | _ -> failwith "error: Parse_N"

let t1 = [ Tok_Int 10; Tok_END ];;

parse_S t1

let t2 = [ Tok_Int 10; Tok_Int 20; Tok_Plus; Tok_END ];;

parse_S t2

let t3 = [ Tok_Int 10; Tok_Int 20; Tok_Int 30; Tok_Plus; Tok_Minus; Tok_END ];;
parse_S t3

let t4 = [ Tok_Int 10; Tok_Int 20; Tok_Int 30; Tok_Int 40; Tok_Int 50; Tok_Plus; Tok_Plus; Tok_Plus; Tok_Plus;  Tok_END ];;
parse_S t4
