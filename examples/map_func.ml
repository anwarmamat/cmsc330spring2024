(* build a map (disctionary ) using functions *)

let empty v = fun _-> 0;;
let update m k v = fun x'->if k=x' then v else m x';;

let m = empty 0;;
(* m: fun _-> 0 *)

let m = update m "foo" 100;;
(* m: fun x -> if x = "foo" then 100 else (empty 0) *)

let m = update m "bar" 200;;
(*  fun x -> if x = "bar" then 200 else m x 
where:
    m: fun x -> if x = "foo" then 100 else (empty 0)
*)

let m = update m "baz" 300;;

m "foo";; (* 100 *)
m "bar";; (* 200 *) 
let m = update m "foo" 101;;
m "foo";; (* 101 *)


(* 
    return all the values of a key
*)

let empty2 v = fun _-> [];;
let update2 m k v = fun x'->if k=x' then v::(m x') else m x';;
let m2 = empty2 0;;
let m2 = update2 m2 "foo" 100;;
let m = update2 m2 "bar" 200;;
let m2 = update2 m2 "foo" 101;;

m2 "foo";; (* int list = [102; 100] *)