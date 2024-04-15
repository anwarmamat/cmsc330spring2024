
(** 
    Stack Implemented as List. This implementation of Stack 
    uses OCaml's built-in list to represent a stack.
 *)
open Stack
   
module ListStack : Stack = struct
  type 'a stack = 'a list

  let empty = []
  let is_empty s = s = []
  let push x s = x :: s
  let peek = function 
    | []   -> failwith "Empty"
    | x::_ -> x
  let pop = function 
    | []    -> failwith "Empty"
    | _::xs -> xs
end
                             
