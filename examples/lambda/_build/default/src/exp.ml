type var = string
type exp = Var of var | Lam of var * exp | App of exp * exp