type tree = Leaf |
            Node of int * int * tree * tree

(** [mem x t] is [true] iff [x] is a member of [t]. *)
let rec mem x t =
  match t with
  | Leaf -> false
  | Node (k,v, l, r) ->
    x = k || (x < k && mem x l) || mem x r

(** [insert x t] is [t] . *)
let rec insert (x,y) t =
  match t with
  | Leaf -> Node (x,y, Leaf, Leaf)
  | Node (k,v, l, r)  ->
    if x = k then Node (k,y,l,r)
    else if x < k then Node (k,v, insert (x,y) l, r)
    else Node (k,v, l, insert (x,y) r)


let tree_gen n =
  match n with
  | 0 -> Leaf
  | n ->let l = Gen.generate ~n:n (Gen.pair Gen.nat Gen.nat) in
    List.fold_left (fun a (k,v) -> insert (k,v) a)  Leaf l 
