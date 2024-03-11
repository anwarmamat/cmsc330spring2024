(* arith : user-defined variant datatype for arithmetic expressions  *)

type expr = 
  Num of int 
  | Add of expr * expr 
  | Mult of expr * expr
(*
  function a_to_str : arith -> string
        converts arithmetic expression into a string
*)

let rec expr_to_str a =
  match a with
  | Num n -> string_of_int n (* from Pervasives *)
  | Add (a1, a2) -> "(" ^ expr_to_str a1 ^ " + " ^ expr_to_str a2 ^ ")"
  | Mult (a1, a2) -> "(" ^ expr_to_str a1 ^ " * " ^ expr_to_str a2 ^ ")"

(*
  finds value of arithmetic expression.  always returns (Num n)
*)
let rec eval e =
  match e with
  | Num n -> n
  | Add (a1, a2) -> ( match (eval a1, eval a2) with n1, n2 -> n1 + n2)
  | Mult (a1, a2) -> ( match (eval a1, eval a2) with n1, n2 -> n1 * n2)


exception IllegalExpression of string
exception ParseError of string
(* Scanner *)

type token =
  | Tok_Num of string
  | Tok_Add
  | Tok_Mult
  | Tok_LParen
  | Tok_RParen
  | Tok_END
;;

#load "str.cma"

let re_num = Str.regexp "[0-9]+" (* single digit number *)
let re_add = Str.regexp "+"
let re_mult = Str.regexp "*"
let re_lparen = Str.regexp "("
let re_rparen = Str.regexp ")"
let re_space = Str.regexp " "

(*----------------------------------------------------------
  function tokenize : string -> token list
  converts string into a list of tokens
*)
let tokenize str =
  let rec tok pos s =
    if pos >= String.length s then [ Tok_END ]
    else if Str.string_match re_num s pos then
      let token = Str.matched_string s in
      let len = String.length token in
      Tok_Num token :: tok (pos + len) s
    else if Str.string_match re_space s pos then tok (pos + 1) s
    else if Str.string_match re_add s pos then Tok_Add :: tok (pos + 1) s
    else if Str.string_match re_mult s pos then Tok_Mult :: tok (pos + 1) s
    else if Str.string_match re_lparen s pos then Tok_LParen :: tok (pos + 1) s
    else if Str.string_match re_rparen s pos then Tok_RParen :: tok (pos + 1) s
    else raise (IllegalExpression "tokenize")
  in
  tok 0 str

(*
  function tok_to_str : token -> string
  converts token into a string
*)

let string_of_token t =
  match t with
  | Tok_Num v -> v (*(Char.escaped v)*)
  | Tok_Add -> "+"
  | Tok_Mult -> "*"
  | Tok_LParen -> "("
  | Tok_RParen -> ")"
  | Tok_END -> "END"


(* Parser *)
(*
   function lookahead : token list -> (token * token list)
   Returns tuple of head of token list & tail of token list
*)
let lookahead tokens =
  match tokens with [] -> raise (ParseError "no tokens") | h :: t -> h

let match_token (toks : token list) (tok : token) =
  match toks with
  | [] -> raise (ParseError (string_of_token tok))
  | h :: t when h = tok -> t
  | h :: _ -> raise (ParseError (string_of_token tok))

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

(*
  function eval_str : given string, parse string, build AST,
  	evaluate value of AST
*)

let eval_str str =
  let tokens = tokenize str in

  print_string "Input token list = ";
  List.iter (fun x -> print_string (" " ^ string_of_token x)) tokens;
  print_endline "";

  let a, t = parse_S tokens in

  if t <> [ Tok_END ] then raise (IllegalExpression "parse_S");

  print_string "AST produced = ";
  print_endline (expr_to_str a);

  let v = eval a in

  print_string "Value of AST = ";
  print_int v;
  print_endline "";

  v
;;

eval_str "1*2*3*4*5*6";;
eval_str "1+2+3*4*5+6";;
eval_str "1+(2+3)*4*5+6";;
eval_str "100 *      (10 + 20)";;
(* eval_str "(2^5)*2";;  error *)
(* eval_str "1++12" error *)
