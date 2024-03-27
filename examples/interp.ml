
type id = string

(* v ::= n | true | false *)
type value = Int of int | Bool of bool

(* 
e ::= x | v | e + e | let x = e in e | eq0 e | if e then e else e
*)
type exp = 
| Ident of id 
| Val of value
| Plus of exp * exp
| Let of id * exp * exp
| Eq0 of exp
| GT of exp * exp
| If of exp * exp * exp
    
type env = (id * value) list

let extend env x v = (x,v)::env

let rec lookup env x =
  match env with
    [] -> failwith "no var"
  | (y,v)::env' -> 
    if x = y then v
    else lookup env' x

let rec eval env e =
  match e with
    Ident x -> lookup env x
  | Val v -> v
  | Plus (e1,e2) ->
     let Int n1 = eval env e1 in
     let Int n2 = eval env e2 in
     let n3 = n1+n2 in
     Int n3
  | Let (x,e1,e2) ->
     let v1 = eval env e1 in
     let env' = extend env x v1 in
     let v2 = eval env' e2 in v2
  | Eq0 e1 ->
     let Int n = eval env e1 in
     if n=0 then Bool true else Bool false
  | GT (e1,e2) ->
  	let Int v1 = eval env e1 in
  	let Int v2 = eval env e2 in
  	if v1 >= v2 then Bool true else Bool false
  	
  | If (e1,e2,e3) ->
     let Bool b = eval env e1 in
     if b then eval env e2
     else eval env e3



(*
Examples:

Env: x = 100
20 + x

eval [("x",Int 100)] (Plus(Val (Int 20),Ident "x"));;
- : value = Int 120


let x = 10 in let x = x+ 1 in x+2;;

eval [] (Let("x", Val(Int 10), Let("x", Plus(Ident "x", Val(Int 1)), 
			Plus(Ident "x", Val(Int 2)))));;



      let x = 10 in Let y = x+ 1 in x+y;;

eval [] (Let("x", Val(Int 10), Let("y", Plus(Ident "x", Val(Int 1)), 
			Plus(Ident "x", Ident "y"))));;



let x = let x = 10 in x+1 in x+ 2

eval []   (Let("x", (Let("x", Val(Int 10), Plus(Ident "x", Val(Int 1)))), 
			Plus(Ident "x", Val(Int 2))));;


if 4+2 = 0 then 100 else 200

eval [] (If(Eq0 (Plus(Val(Int 4), Val(Int 2))), Val(Int 100), Val(Int 200)));;


if 4+2 >= 6  then 100 else 200

eval [] (If(GT (Plus(Val(Int 4), Val(Int 2)), Val(Int 6)), Val(Int 100), Val(Int 200)));;
*)
