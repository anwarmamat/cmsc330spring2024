(* expr : user-defined variant datatype for arithmetic expressions  *)

type expr = 
  Num of int 
  | Add of expr * expr 
  | Mult of expr * expr
  [@@deriving show { with_path = false }]

  (* converts arithmetic expression into a string *)

let rec expr_to_str a =
  match a with
  | Num n -> string_of_int n (* from Pervasives *)
  | Add (a1, a2) -> "(" ^ expr_to_str a1 ^ " + " ^ expr_to_str a2 ^ ")"
  | Mult (a1, a2) -> "(" ^ expr_to_str a1 ^ " * " ^ expr_to_str a2 ^ ")"
