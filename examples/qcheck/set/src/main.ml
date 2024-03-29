
module SS = Set.Make(String)

let s = SS.empty

let s = SS.add "alice" s

let s =  SS.add "cat" s

let s = SS.add "bob" s

let print_set t = 
     SS.iter print_endline t
;;
print_set s
