type id = string
type num = int
type exp = 
| Ident of id 
| Num of num
| Plus of exp * exp
| Let of id * exp * exp

(*  substitute x in e2 with e1  *)

let rec subst x e1 e2 = 
	match e2 with
  | Ident y -> if x=y then e1 else e2
  | Num c -> Num c
  | Plus(el,er) -> Plus(subst x e1 el, subst x e1 er)
  | Let(y,ebind,ebody) ->
    if x=y then Let(y, subst x e1 ebind, ebody)
    else Let(y, subst x e1 ebind, subst x e1 ebody)
;;


let rec eval exp =
	match exp with
		|Num n -> n
		|Plus(e1,e2)->
			let n1 = eval e1 in 
			let n2 = eval e2 in 
			let n3 = n1 + n2
			in n3
 		|Let (x,e1,e2) ->
     		let e2' = subst x e1 e2 in
     		let v2 = eval e2' in v2
    |_->failwith "error 1"

;;	

(*

eval (Let("x", Num 10, Plus(Ident "x",Num 10)));;
- : num = 20

let x = 10 in let y = x+1 in x+y;;

Let("x", Num 10, Let("y", Plus(Ident "x", Num 1),Plus(Ident "x", Ident "y")))

let e2 =(Let("y", Plus(Ident "x", Num 1),Plus(Ident "x", Ident "y")));;
# eval (Let("x", Num 10, e2));;
- : num = 21
*)
