(*
require "ocamlgraph"
 *)
open Graph
(* open Graphviz *)
(* representation of a node -- must be hashable *)
module Node = struct
   type t = int
   let compare = Pervasives.compare
   let hash = Hashtbl.hash
   let equal = (=)
end

(* representation of an edge -- must be comparable *)
module Edge = struct
   type t = string
   let compare = Pervasives.compare
   let equal = (=)
   let default = ""
end

(* a functional/persistent graph *)

(* module G = Persistent.Graph.Concrete(Node)(Edge);;*)
module G =  Graph.Persistent.Digraph.ConcreteBidirectionalLabeled(Node)(Edge)
let g = G.empty

(*
    (6)
   /
  /
(1)---(2)
 |     | \
 |     |  (5)
 |     | /
(3)---(4)
 *)

let v1 = G.V.create 1
let g = G.add_vertex g v1
let g = G.add_vertex g (G.V.create 2)
let g = G.add_vertex g (G.V.create 3)
let g = G.add_vertex g (G.V.create 4)
let g = G.add_vertex g (G.V.create 5)

let g = G.add_vertex g (G.V.create 6)

let _= G.iter_vertex (fun x->print_int x) g

let g = G.add_edge g 1 2
let g = G.add_edge g 1 3
let g = G.add_edge g 2 4
let g = G.add_edge g 3 4
let g = G.add_edge g 2 5
let g = G.add_edge g 4 5
let g = G.add_edge g 1 6
;;
(* successors of 1 *)
List.iter print_int (G.succ g 1)


(* BFS traversal of G *)

module M1 = Traverse.Bfs(G)

(* print BFS traversal *)
let m1 = M1.iter (fun x-> print_int x) g
(*
 module D = Graphviz.Dot(G)
 *)
(*
 let _ =
   let file = open_out_bin "mygraph.dot" in
   D.output_graph file g
;;
 *)
(*
  if D.has_cycle g     then ... else ...
 *)
module Dot = Graph.Graphviz.Dot(struct
   include G (* use the graph module from above *)
   let edge_attributes (_, e, _) = [`Label e; `Color 4711]
   let default_edge_attributes _ = []
   let get_subgraph _ = None
   let vertex_attributes _ = [`Shape `Box]
   let vertex_name v = string_of_int v
   let default_vertex_attributes _ = []
  let graph_attributes _ = []
               end)
               
let _ =                                                                                                   
   let file = open_out_bin "bfs.dot" in                                                               
   Dot.output_graph file g
     
