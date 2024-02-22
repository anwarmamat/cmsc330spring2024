## OCaml Data Types (Variants)
So far, we’ve seen the following kinds of data:
* Basic types (int, float, char, string)
* Lists: One kind of data structure. A list is either `[ ]` or `h::t`, deconstructed with pattern matching
* Tuples and Records: Let you collect data together in fixed-size pieces
* Functions

Sometimes, building everything from lists and tuples is awkward. How can we build other data structures?

### User Defined Types
We can introduce new types using the `type` keyword. In simplest form, it is like a C `enum`. They let you represent data that may take on multiple different forms, where each form is marked by an explicit tag. User defined types are also called variants or algebraic data types. 

```ocaml
type color = Red | Green | Blue | Yellow;;

let c = Red
val c : color = Red
```
The different constructors can also carry other values with them. For example, suppose we want a type `gen` that can either be an integers, a string, or a float. It can be declared as follows: 
```ocaml
type gen = 
  |Int of int 
  |Str of string;;
  Float of float
let ls = [Int 10; Str "alice"; Int 20; Float 1.5]

(* print a gen type value *)
let print_gen x = 
  match x with 
   |Int i -> Printf.printf "%d\n" i
   |Str s -> Printf.printf "%d\n" s
(* print a gen list *) 
List.iter print_gen ls
```
### More Examples
```ocaml
type suit = Club | Diamond | Heart | Spade
type value = Jack | Queen | King | Ace | Num of int
type card = Card of value * suit
type hand = card list

([Card(Ace, Spade); Card(Num 7, Heart)]:hand);;
    - : hand = [Card (Ace, Spade); Card (Num 7, Heart)]
```
Another example: 
```ocaml
type coin = Heads | Tails

let flip x =
  match x with
    Heads -> Tails
  | Tails -> Heads

let rec count_heads x =
  match x with
    [] -> 0
  | (Heads::x') -> 1 + count_heads x'
  | (_::x') -> count_heads x'
```

### Definition of Variants
* Syntax
```ocaml
type t = C1 [of t1] |... | Cn [of tn]
```
the `Ci` are called constructors

* Evaluation

A constructor `Ci` is a value if it has no associated data. `Ci vi` is a value if it does.
Destructing a value of type `t` is by pattern matching. Patterns are constructors `Ci` with data components, if any. 
* Type Checking
```ocaml
Ci [vi] : t [if vi has type ti]
```
### Examples
We can define variants that “carry data” too
```ocaml
type shape =
   Rect of float * float (* width*length *)
 | Circle of float       (* radius *)
```

`Rect` and `Circle` are constructors, so a shape is either
* `Rect(w,l)`	for any floats w and l, or
* `Circle r`	for any float r
We can use pattern matching to destruct a variant. 
```ocaml
let area s =
  match s with
      Rect (w, l) -> w *. l
    | Circle r -> r  *. r *. 3.14

area (Rect (3.0, 4.0));; (* 12.0  *)
area (Circle 3.0);;      (* 28.26 *)
```
We can also creates of list of shapes:
```ocaml
let lst = [Rect (3.0, 4.0) ; Circle 3.0]
 - : shape list`
```
### Option Type
Option values explicitly indicate the presence or absence of a value. Comparing to Java, `None` is like `null`, while `Some i` is like an `Integer(i)` object
```ocaml
type optional_int =
  None
 | Some of int
```
`Some v` reprents the presence of a value `v`, and `None` represents the absence of a value. 
```ocaml
let divide x y =
  if y != 0 then Some (x/y)
  else None

let string_of_opt o =
  match o with
    Some i -> string_of_int i
  | None -> "nothing"

let p = divide 1 0;;
  print_string 
    (string_of_opt p);;  
```

#### Polymorphic Option Type
```ocaml
type 'a option =
  Some of 'a
| None
```
Previously, we implemented the `hd` function as:
```ocaml
let hd l =
  match l with
  | h::_ ->h
```
This implementaion throws a `Match_failure` exception when the input is an empty list.
```ocaml
hd [];;
Exception: Match_failure
```
Now, we can reimplement the `hd` function for the list using an option type. 
```ocaml
let hd l =
  match l with
  [] -> None
  | x::_ -> Some x
let p = hd [];;    (* p = None *)
let q = hd [1;2];; (* q = Some 1 *) 
let r = hd ["a"];; (* r = Some “a” *)
```

### Recursive Data Types
A type is recursive if in its implementation it
refers to to its own definition. Functions over a recursive type are often defined by recursion. 

We can write our own version of lists using variant types. Suppose we want to define values that act like linked lists of integers. A linked list is either empty, or it has an integer followed by another list containing the rest of the list elements. This leads to a the following type declaration:
```ocaml
type intlist = 
   Nil 
  | Cons of (int * intlist)
```
This type has two constructors, `Nil` and `Cons`. It is a recursive type because it mentions itself in its own definition in the Cons constructor.

Any list of integers can be represented by using this type. For example, the empty list is just the constructor `Nil`, and `Cons` corresponds to the operator `::`. Here are some examples of lists: 
```ocaml
Nil;;   (* empty list *)
- : intlist = Nil
# Cons(1,Nil);;  (* 1-->Nil *)
- : intlist = Cons (1, Nil)
# Cons(1, Cons(2,Cons(3,Nil)));; (* 1-->2-->3-->Nil *)
- : intlist = Cons (1, Cons (2, Cons (3, Nil)))
```

#### Polymorphic List
```ocaml
type 'a mylist = 
   Nil 
  | Cons of (int * mylist)
```
#### List Operations
* Length of a list
```ocaml
(* length of the list *)
let rec len = function
   Nil -> 0
 | Cons (_, t) -> 1 + (len t)

len (Cons (10, Cons (20, Cons (30, Nil))))
(* evaluates to 3 *)
```
(* Remove repeated elements from the list *)
```ocaml
let rec uniq lst = 
  match lst with 
  |Nil -> Nil
  | Cons(x, Nil) -> Cons(x, Nil)
  | Cons(x, Cons(y, t)) -> 
     if x = y then uniq (Cons (y , t))
     else Cons(x , uniq (Cons(y , t)))
  
# let l = Cons(1, Cons(2, Cons(2, Cons(3,Nil))));;
val l : intlist = Cons (1, Cons (2, Cons (2, Cons (3, Nil))))
# uniq l;;
- : intlist = Cons (1, Cons (2, Cons (3, Nil))) (* duplicate 2 is deleted *)
```
```ocaml
(* Create an mylist from an OCaml list *)

let rec mylist_of_list (ls : 'a list) : 'a mylist = 
		match ls with
		[] -> Nil
	  | h::t -> Cons(h, (my_list_of_list t));;

	let ol = my_list_of_list [1;2;3;4];;

(* sum of a mylist *)

let rec list_sum l = 
  match l with 
	|Nil->0	
	|Cons(h,t) -> h + (list_sum t);;
	
let m = list_sum ol;;

let c = Cons(10,Cons(20,Cons(30,Nil)));;
print_int (list_sum c);; (* 60 *)
```

#### Binary Trees
We can use variants to represnt tree data structures as well. Here is the definition of a binary tree:
```ocaml
type 'a tree =
   Leaf
 | Node of 'a tree * 'a * 'a tree

let empty = Leaf
let t = Node(Leaf, 100, Node(Leaf,200,Leaf))

(* t represnts the following tree *)

       100
      /   \
    /      \
 Leaf      200
         /   \
      Leaf   Leaf

let t2 =
		Node(Node(Node(Leaf, 'd', Leaf),'b', Node(Leaf,'e', Leaf)), 'a', Node(Leaf,'c', Node(Node(Leaf, 'g', Leaf),'f', Leaf)));;

        a
      /    \
    b       c
   / \     / \
  /   \        \
  d    e        g
 /\    /\       /\    
```
#### Recusrive function on a tree
```ocaml
(* sun of an int tree *)
let rec sum t = 
  match t with
    Leaf -> 0
   | Node(l,v,r)-> (sum l) + v + (sum r)
```
```ocaml


(* Count the number of nodes *)

	let rec count tree = 
		match tree with
		Leaf->0
		|Node(l,v,r)->1 + count(l) + count(r);;

(* Coune the number of leaves *)

	let rec count_leaves = function
		| Leaf -> 0
		| Node(Leaf,_, Leaf) -> 1
		| Node(l,_, r) -> count_leaves l + count_leaves r;;

(* Collect values of leaf nodes in a list *) 

	let rec leaves = function
		| Leaf -> []
		| Node(Leaf, c, Leaf) -> [c]
		| Node(l, _, r) -> leaves l @ leaves r

(* Collect the internal nodes of a binary tree in a list *)

let rec internals = function
	| Leaf | Node(Leaf,_, Leaf) -> []
	| Node(l, v, r) -> internals l @ (v :: internals r)
		
(* Collect the nodes at a given level in a list *)

let rec at_level t n = match t with
	| Leaf -> []
	| Node(left, c, right) ->
		if n = 1 then [c]
		else at_level left (n - 1) @ at_level right (n - 1)
 
 # at_level t2 2;;
- : char list = ['b'; 'c']

(* insert an item to a binary search tree *)
let rec insert t n =
	match r with 
	|Leaf->Node(Leaf, n,Leaf)
	|Node(left,value,right)-> 
    if n < value then Node((insert left n), value,right) 
    else 
      if n > value then Node(left, value,(insert right n))
      else Node(left,value,right)

(* Height of a tree *)

let rec height t=
	match t with 
	|Leaf -> 0
	|Node(l,v,r)->1 + max (height l) (height r)

(* Inorder traversal *)
let rec inorder t = 
	match t with 
	|Leaf->[]
	|Node(l,v,r)-> (inorder l)@[v]@(inorder r)

# inorder t2;;
- : char list = ['d'; 'b'; 'e'; 'a'; 'c'; 'g'; 'f']

(* Preorder traversal *)
let rec preorder t = 
	match t with 
	|Leaf->[]
	|Node(l,v,r)->
			 v::(preorder l) @ (preorder r)

# preorder t2;;
- : char list = ['a'; 'b'; 'd'; 'e'; 'c'; 'f'; 'g']

let rec postorder t = 
	match t with 
	|Leaf->[]
	|Node(l,v,r)->
			(postorder l)@
			(postorder r)@
	    [v]

# postorder t2;;
- : char list = ['d'; 'e'; 'b'; 'g'; 'f'; 'c'; 'a']

(* Level order traversal *)
let levelOrder t = 
	let q=Queue.create () in 
  let _ = Queue.push t q in 
  let rec aux queue =
		if Queue.is_empty queue then () else
		let c = Queue.pop queue in
			match c with 
			|Leaf ->aux queue
			|Node(l,v,r)->Printf.printf "%c," v;
				let _= Queue.push l queue in
				let _ = Queue.push r queue in
		aux queue
  in aux q

# levelOrder t2;;
a,b,c,d,e,f,g,- : unit = ()

(* Build a binary search tree from a list *)
```ocaml
let root = List.fold_left insert Leaf [100;50;200;10;60;250;300];;

preorder root;;
inorder root;;
postorder root;
level_order root;;
```
#### N-ary Trees
N-ary tree is a collection of nodes where each node stores a data of type `'a` and its children, a list of `'a trees`. When this list is empty, then the Node is implicitly a leaf node. Note that leaf and inner nodes all contain data in this representation of a tree. Type:
```ocaml
type 'a n_tree = Node of 'a * 'a n_tree list
```
Here is a tree that you can use for simple tests of your functions.
```ocaml
             1
          /     \
         /        \
        2          7
     /  |  \        \
    3   4   5        8
        |
        6

let t =
  Node
    ( 1,
      [
        Node
          ( 2,
            [ 
              Node (3, []); 
              Node (4, [ Node (6, []) ]); 
              Node (5, []) 
            ]
          );
        Node (7, [ Node (8, []) ]);
      ] )
```
* Count the nodes in an n-ary tree
```ocaml
let rec nodes t =
  match t with
  | Node (x, children) -> 1 + List.fold_left ( + ) 0 (List.map nodes children)

# nodes t;;
- : int = 8
```
* Calculate the sum an int n-ary tree
```ocaml
let rec sum t =
  match t with
  | Node (x, children) -> x + List.fold_left ( + ) 0 (List.map sum children)

# sum t;;
- : int = 36
```
* Print an n-anry tree
```ocaml
let rec print t =
  match t with
  | Node (x, children) ->
      Printf.printf "%d," x;
      List.iter print children

# print t;;
1,2,3,4,6,5,7,8,- : unit = ()
```