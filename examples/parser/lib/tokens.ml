type token =
  | Tok_Num of string
  | Tok_Add
  | Tok_Mult
  | Tok_LParen
  | Tok_RParen
  | Tok_END
  [@@deriving show { with_path = false }]


let string_of_token t =
  match t with
  | Tok_Num v -> v (*(Char.escaped v)*)
  | Tok_Add -> "+"
  | Tok_Mult -> "*"
  | Tok_LParen -> "("
  | Tok_RParen -> ")"
  | Tok_END -> "END"
  [@@deriving show { with_path = false }]