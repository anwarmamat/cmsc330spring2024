(* 
  Expression evaluator   
*)
type expr =
  | Num of int
  | Add of expr * expr
  | Sub of expr * expr
  | Mul of expr * expr
  | Div of expr * expr
  | Power of expr * expr

let rec power x y = if y <= 1 then x else x * power x (y - 1)

let rec eval e =
  match e with
  | Num x -> x
  | Add (e1, e2) -> eval e1 + eval e2
  | Sub (e1, e2) -> eval e1 - eval e2
  | Mul (e1, e2) -> eval e1 * eval e2
  | Div (e1, e2) -> eval e1 / eval e2
  | Power (e1, e2) -> power (eval e1) (eval e2)

let rec str_of_expr e =
  match e with
  | Num x -> string_of_int x
  | Add (a, b) -> "(" ^ str_of_expr a ^ "+" ^ str_of_expr b ^ ")"
  | Sub (a, b) -> "(" ^ str_of_expr a ^ "-" ^ str_of_expr b ^ ")"
  | Mul (a, b) -> "(" ^ str_of_expr a ^ "*" ^ str_of_expr b ^ ")"
  | Div (a, b) -> "(" ^ str_of_expr a ^ "/" ^ str_of_expr b ^ ")"
  | Power (a, b) -> "(" ^ str_of_expr a ^ "^" ^ str_of_expr b ^ ")"

(*    (5 + (4 * 3)) ^ 2 = 149 *)
let e = Add (Num 5, Power (Mul (Num 4, Num 3), Num 2))

let _ = Printf.printf "%s=%d\n" (str_of_expr e) (eval e)
(*  (5+((4*3)^2))=149 *)