open Add
module Addimpl1: ADD = 
struct
  type t = int
  let add = fun x->fun y -> x+ y
                                 
  let toString (x:t):string = string_of_int x;

end;;

    
