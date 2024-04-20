(* Untyped lambda calculus interpreter *)
open LambdaCalc
open Lambda
open Exp
open Encoding
open Pp
open Format

let rec to_int e =
  match e with
  | App (x, y) -> 1 + to_int x + to_int y
  | Lam (_a, b) -> to_int b
  | _ -> 0

(* Example 0 *)
let r = Lam ("x", App (Var "x", Var "y"));;

print_string "Lambda Expression: λx.x y";;
print_string "\nLambda Expression: ";;
print_string (lambda_exp_2_str r);;
print_string "\nparsed string: ";;
print_lambda r;;
print_string "\n";;



Printf.printf "\nExample: if expression\n"

(* and true true  *)
let e = App (App (myand, mytrue), mytrue);;

(*  if e then 1 else 2 *)
let e2 = App (App (App (myif, e), myone), mytwo)
let e2 = reduce_multi e2
let () = Printf.printf "\nif true then 1 else 2 = %d\n" (to_int e2)

(*Example 2 *)

(* and true false  *)
let e = App (App (myand, mytrue), myfalse)

(*
   let e = false
   e2 = if e then 1  else 2
*)
let e2 = App (App (App (myif, e), myone), mytwo)
let e2 = reduce_multi e2;;
let () = Printf.printf "\nif false then 1 else 2 = %d\n" (to_int e2)
;;
(* Example 3: Addition
   3 + 2
*)
Printf.printf "\nExample: Addition\n"
let e1 = App (App (myplus, mythree), mytwo)
let e2 = reduce_multi e1;;
let () = Printf.printf "3 + 2 = %d\n" (to_int e2);;

(* Example 4  Multiplication
   let e1 = 3 + 2
   let e2 = 3 + 1
   let e3 = e1 * e2
*)
Printf.printf "\nExample: Multiplication\n"
let e1 = App (App (myplus, mythree), mytwo)
let e2 = App (mysucc, mythree)
let e3 = App (App (mymult, e1), e2)
let e4 = reduce_multi e3
let () = Printf.printf "5 * 4 = %d\n" (to_int e4)

(* let e5 = (e3+e2) * e4
            (5 + 4 ) * 20
*)
let e5 = App (App (mymult, App (App (myplus, e1), e2)), e4)
let e6 = reduce_multi e5
let () = Printf.printf "(5 + 4) * 20 = %d\n" (to_int e6);;

Printf.printf "\nExample: Integer Deivision\n"

(*   4 / 2  *)
let e = App(App(mydiv,App(mysucc,mythree)),mytwo);;
Printf.printf "succ(3)/2 =  %d\n" (to_int (reduce_multi e));;

Printf.printf "\nExample: Recursion: Factorial\n";;
(*
   Y = \f.(\x. f (x x)) (\x. f (x x))
  fact = \f.\n. if n = 0 then 1 else n * (f (n -1))
 *)

(* Example 4
   fact(3)
*)

let yfix = Lam ("f",
App (Lam ("x", App (Var "f", App (Var "x", Var "x"))),
 Lam ("x", App (Var "f", App (Var "x", Var "x")))))
 (*  "Lf.(Lx. f (x x)) (Lx. f (x x))" *)
let if2 (a, b, c) = App (App (App (myif, a), b), c)

let fact1 =
  Lam
    ( "f",
      Lam
        ( "n",
          if2
            ( App (iszero, Var "n"),
              (* condition *)
              myone,
              (* if branch *)
              App (App (mymult, Var "n"), App (Var "f", App (mypred, Var "n")))
              (* else *) ) ) )

(* calculate factorial of 3  *)
let e = App (App (yfix, fact1), mythree)

(* print the factorial 3 as int *)
let x = to_int (reduce_multi e) (*  6 *);;

Printf.printf "fact(3) = %d\n" x;;


(* calculate factorial of 4  *)

let four = reduce_multi (App(mysucc,mythree));;
let e  = App(App(yfix, fact1), four);;

(* print the factorial 3 as int *)
let x = to_int (reduce_multi e)   (*  6 *)
;;
Printf.printf "fact(4) = %d\n" x;;
