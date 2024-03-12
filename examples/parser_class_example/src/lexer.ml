(*open Str*)
   
(*
Given the CFG

E → id = n | { L }
L → E ; L | ε

Tokenize and parse 

{ x = 3 ; { y = 4 ; } ; }
 *)

type token =
  Tok_ID of string
| Tok_Num of int
| Tok_Semi
| Tok_LCurly
| Tok_RCurly
| Tok_Assign
| Tok_END
;;


(* #load "str.cma"*)

let re_num = Str.regexp "[1-9][0-9]*"
let re_id = Str.regexp "[a-z][a-z]*"
let re_semi = Str.regexp ";"
let re_rightparen = Str.regexp "}"
let re_leftparen = Str.regexp "{"
let re_assign = Str.regexp "="                  
let re_space = Str.regexp "[ \n\r\t]+"
exception IllegalExpression of string
                             
                             
(*
  tokenize : string -> token list
  converts string into a list of tokens (i.e., terminals)
 *)
let tokenize str =
  let rec tok pos s =
    (*let _= Printf.printf "%s\t%d\n" s pos in *)
    if pos >= String.length s then
      [Tok_END]
    else
      if (Str.string_match re_num s pos) then
        let token = Str.matched_string s in
        (Tok_Num (int_of_string token))::(tok (pos+ (String.length token)) s)
      else if (Str.string_match re_id s pos) then
        let token = Str.matched_string s in
        (Tok_ID token)::(tok (pos + (String.length token)) s)
      else if (Str.string_match re_space s pos) then
        let token = Str.matched_string s in
        (tok (pos + (String.length token)) s)
      else if (Str.string_match re_semi s pos) then
        Tok_Semi::(tok (pos+1) s)
      else if (Str.string_match re_leftparen s pos) then
        Tok_LCurly::(tok (pos+1) s)
      else if (Str.string_match re_rightparen s pos) then
        Tok_RCurly::(tok (pos+1) s)
      else if (Str.string_match re_assign s pos) then
        Tok_Assign::(tok (pos+1) s)
      else
        raise (IllegalExpression "tokenize")
  in
  tok 0 str
  
(*
  tok_to_str : token -> string
  converts token into a string
*)
let tok_to_str t =
  match t with
    Tok_Num v -> (string_of_int v)
  | Tok_ID s -> s
  | Tok_Semi -> ";"
  | Tok_LCurly -> "{"
  | Tok_RCurly -> "}"
  | Tok_Assign -> "="
  | Tok_END -> "Tok_END"
