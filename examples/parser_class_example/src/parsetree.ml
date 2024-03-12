(*
require "ocamlgraph"
 *)
(*open Graph*)
(* open Graphviz *)
(* representation of a node -- must be hashable *)

module Node   = struct
  (*type t = int*)
   type t = {id:int;label:string}

   (* let compare = Stdlib.compare*)
   let hash = Hashtbl.hash
   let equal = (=)
   
   let create id label = {id; label}
    let label n = n.label
    let id n = n.id
    let compare x y = compare x.id y.id
                    
end

(* representation of an edge -- must be comparable *)
module Edge = struct
   type t = string
   let compare = Stdlib.compare
   let equal = (=)
   let default = ""
end

(* a functional/persistent graph *)

(* module G = Persistent.Graph.Concrete(Node)(Edge);;*)
module G = Graph.Imperative.Digraph.ConcreteBidirectionalLabeled(Node)(Edge)

let g = G.create ()
;;
(*G.add_vertex g {id=1000;label="A"};;
G.add_vertex g {id=2000;label="B"};;
G.add_vertex g {id=3;label="C"};;
G.add_edge g {id=1000;label="A"} {id=2000;label="B"};;
 *)
module Dot = Graph.Graphviz.Dot(struct
                 include G (* use the graph module from above *)
                 let edge_attributes (_, e, _) = [`Label e; `Color 4711]
                 let default_edge_attributes _ = []
                 let get_subgraph _ = None
                 let vertex_attributes v = [`Shape `Box ;`Fontsize 24;`Label (G.V.label v).label]
                 let vertex_name v = (string_of_int (G.V.label v).id)
                 let default_vertex_attributes _ = []
                 let graph_attributes _ = [`OrderingOut; `Rankdir `TopToBottom]
               end)
;;
let next  =
  let cnt = ref 0 in
  fun () -> cnt:= !cnt+1; !cnt

let addnode graph parent lbl =
          let nd:Node.t = {id=next (); label=lbl} in 
          let _ = G.add_vertex graph nd  in
          let _= G.add_edge graph parent nd in
    nd

let g_to_dot gr filename=
  let file = open_out_bin filename in                                                               
  Dot.output_graph file gr
    
