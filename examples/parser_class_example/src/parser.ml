open Lexer
open Parsetree
(*
Parser slides (slide number 6) example:

Given the CFG

E → id = n | { L }
L → E ; L | ε

Tokenize and parse 

{ x = 3 ; { y = 4 ; } ; }
 *)
             
exception ParseError of string
                      
let lookahead tokens =
  match tokens with
    [] -> raise (ParseError "no tokens")
  | h::_ -> h
          
let match_tok tokens a =
  match tokens with
  (* checks lookahead; advances on match *)
  | (h::t) when a = h ->
     (*let _= Printf.printf "match: %s\n" (tok_to_str h) in*)
     t 
  | _ -> raise (ParseError ("bad match:" ^ (tok_to_str a)))
       

(*
  E → id = n | { L }
  L → E ; L | ε
 *)
       
(* AST *)
       
type exp =
  Assign of string * int | Seq of l
and
l = L of exp * l|Skip
                 
(*
{ x = 3 ; { y = 4 ; } ; }
is represented by the AST
*)          
let e = Seq (
            L (
                Assign ("x", 3),
                L (
                    Seq(
                        L (Assign ("y", 4), Skip)
                          ),Skip
                      )
                  )
          )


      
(* print the ast *)

let rec l_to_str t =
    match t with
    |L (e1,e2) -> (ast_to_str e1) ^ ";" ^ (l_to_str e2) 
    |Skip->""
and 
  ast_to_str ast =
  match ast with
  |Assign (var, v) -> var ^ "=" ^ (string_of_int v)
  |Seq l -> "{" ^ (l_to_str l) ^ "}"
          
          
(* Parser 
   parse_E: token list -> token list * ast
*)

let rec parse_E parent tokens  =
  let t = lookahead tokens in
  match t with
    Tok_ID id->
     let tokens = match_tok tokens t in 
     let tokens = match_tok tokens Tok_Assign in 
     let t2 = lookahead tokens in
     (
       match t2 with
         Tok_Num n->
          let tokens = match_tok tokens t2 in
          let lb = id ^ "=" ^ (string_of_int n) in
          (* adds an edge from parant to node lb on the parsetree graph*)
          let _ = addnode g parent lb in  
          (tokens, Assign (id,n))
        |_ -> raise (ParseError "parse_E Assignment")
     )
   |Tok_LCurly ->
     let tokens = match_tok tokens Tok_LCurly in
     let _ = addnode g parent "{" in 
     let n = addnode g parent "L" in
     let (tokens,a2) = parse_L n tokens in
     let tokens = match_tok tokens Tok_RCurly in
     let _ = addnode g parent "}" in
     (tokens, Seq a2)
   | _ -> raise (ParseError "parse_E Bracket") 
  and
    parse_L parent tokens =
    let t = lookahead tokens in
    match t with
    | Tok_ID _  | Tok_LCurly ->
       let nd = addnode g parent "E" in
       let (tokens, e) = parse_E nd tokens in
       let tokens = match_tok tokens Tok_Semi in 
       let _ = addnode g parent ";" in 
       let nd = addnode g parent "L" in
       let (tokens, l) = parse_L nd tokens in
       (tokens,L(e,l))
    |_->let _ = addnode g parent "e" in
        (tokens, Skip)
                                   
