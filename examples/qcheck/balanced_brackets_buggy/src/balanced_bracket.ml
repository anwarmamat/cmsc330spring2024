(*
  Check balanced brackets buggy version
  counter example: []
 *)

open Base

let paired left right =
    match (left,right) with
    |Some '(', ')' -> true
    |Some '[', '[' -> true (* introduce a bug here: [[ instead of [] *) 
    |Some '{', '}' -> true
    |_-> false

(* check if the brackets are balanced. This code uses an imperative Stack *)
let balanced str =
  let s = Stack.create () in 
  let letters = String.to_list str in
  let ret  = List.fold_left
               ~f:(fun acc letter ->
                   let r = match letter with
                     |'('
                      |'{'
                      |'[' -> let () = Stack.push s letter in true
                     |')'
                      |'}'
                      |']' -> if Stack.is_empty s then false
                            else let left = Stack.pop s in
                                 paired left letter 
                     |_-> true
                   in 
                   r &&  acc
               ) ~init:true letters
  in
  ret && (Stack.is_empty s)    

