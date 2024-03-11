open Ast
(*
   finds value of arithmetic expression always returns (Num n)
*)
let rec eval e =
  match e with
  | Num n -> n
  | Add (a1, a2) -> ( match (eval a1, eval a2) with n1, n2 -> n1 + n2)
  | Mult (a1, a2) -> ( match (eval a1, eval a2) with n1, n2 -> n1 * n2)
