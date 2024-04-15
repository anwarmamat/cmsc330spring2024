open Add
module Addimpl2: ADD = 
struct
  type t = int
  let add a b = a + b
                                 
  let toString (x:t):string = string_of_int x;

end;;

    
