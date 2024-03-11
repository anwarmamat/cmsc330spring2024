open Tokens

exception IllegalExpression of string
(* Scanner *)

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