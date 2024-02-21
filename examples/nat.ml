(* Natural Numbers *)
type nat = Zero | Succ of nat

(*
    How do we represent 0? 1? 2? 10?
*)

let rec nat_of_int n = if n == 0 then Zero else Succ (nat_of_int (n - 1))
let rec int_of_nat n = match n with Zero -> 0 | Succ n -> 1 + int_of_nat n
let rec plus a b = match b with Zero -> a | Succ b' -> Succ (plus a b')
let rec times a b = match b with Zero -> Zero | Succ b' -> plus a (times a b')
let two = Succ (Succ Zero)
let three = Succ two
let ten = nat_of_int 10
let m = times three ten
let _ = Printf.printf "%d\n" (int_of_nat m) (* 30 *)
