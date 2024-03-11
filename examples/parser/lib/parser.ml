
open Ast 
open Tokens
exception ParseError of string

(*
   function lookahead : token list -> (token * token list)
   Returns tuple of head of token list & tail of token list
*)
let lookahead tokens =
  match tokens with [] -> raise (ParseError "no tokens") | h :: _ -> h

let match_token (toks : token list) (tok : token) =
  match toks with
  | [] -> raise (ParseError (string_of_token tok))
  | h :: t when h = tok -> t
  | _ :: _ -> raise (ParseError (string_of_token tok))

(*
   recursive descent parser

   Returns tuple of ast & token list for remainder of string

   Arithmetic expression grammar:

   S -> A + S | A
   A -> B * A | B
   B -> n | (S)

  [Basic grammar with tokens]

    S -> A Tok_Add S | A
    A -> B Tok_Mult A | B
    B -> Tok_Num | Tok_LParen S Tok_RParen
*)

let rec parse_S tokens =
  let e1, t1 = parse_A tokens in
  match lookahead t1 with
  | Tok_Add ->
      (* S -> A Tok_Add E *)
      let t2 = match_token t1 Tok_Add in
      let e2, t3 = parse_S t2 in
      (Add (e1, e2), t3)
  | _ -> (e1, t1)
(* S -> A *)

and parse_A tokens =
  let e1, tokens = parse_B tokens in
  match lookahead tokens with
  | Tok_Mult ->
      (* A -> B Tok_Mult A *)
      let t2 = match_token tokens Tok_Mult in
      let e2, t3 = parse_A t2 in
      (Mult (e1, e2), t3)
  | _ -> (e1, tokens)

and parse_B tokens =
  match lookahead tokens with
  (* B -> Tok_Num *)
  | Tok_Num c ->
      let t = match_token tokens (Tok_Num c) in
      (Num (int_of_string c), t)
  (* B -> Tok_LParen E Tok_RParen *)
  | Tok_LParen ->
      let t = match_token tokens Tok_LParen in
      let e2, t2 = parse_S t in
      let _=Printf.printf "%s\n" (string_of_token (lookahead tokens)) in 
      if lookahead t2 = Tok_RParen then (e2, match_token t2 Tok_RParen)
      else raise (ParseError "parse_B 1")
  | _ -> raise (ParseError "parse_B 2")


