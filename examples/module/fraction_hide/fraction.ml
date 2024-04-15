(* Fraction module *)
module type FractionInt = sig
  type fraction (* hide the type *)

  exception BadFrac

  val make : int * int -> fraction
  val add : fraction * fraction -> fraction
  val toString : fraction -> string
end

module Fraction : FractionInt = struct
  type fraction = Frac of int * int

  exception BadFrac

  let rec gcd (x, y) =
    let x, y = if x >= y then (x, y) else (y, x) in
    if y = 0 then x else gcd (y, x mod y)

  let reduce (Frac (x, y)) =
    let d = gcd (x, y) in
    Frac (x / d, y / d)

  (* denominator cannot be 0 *)
  let make (x, y) = if y = 0 then raise BadFrac else reduce (Frac (x, y))

  let add (f1, f2) =
    match (f1, f2) with
    | Frac (a, b), Frac (c, d) -> reduce (Frac ((a * d) + (b * c), b * d))

  let toString (Frac (a, b)) =
    if b = 1 then string_of_int a
    else if a = 0 then "0"
    else string_of_int a ^ "/" ^ string_of_int b

  let t n = n + 1
end
