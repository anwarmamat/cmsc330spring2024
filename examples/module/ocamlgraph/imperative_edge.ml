open Core
open Graph

module Node = struct
  type nodeType = 
    Branch_start
  |Branch_end
  |Flow
  |Block
(*  [@@deriving sexp, show]*)

  type t = {
      id:int;
      label:string;
      mutable node_type:nodeType
    }
  let hash = Hashtbl.hash
  let equal n1 n2 = n1.id = n2.id 
  let create id lbl = {id = id; label = lbl; node_type = Block}
  let setType node t = node.node_type <-t
  let getType node = node.node_type
  let id n = n.id
  let compare x y = Int.compare (x.id) (y.id)
end


(* representation of an edge -- must be comparable *)
module Label = struct
  type t = ((int, Int.comparator_witness) Set.t) ref
  let to_string e = "[" ^ String.concat ~sep:"," (List.map ~f:(string_of_int) (Set.to_list (!e))) ^ "]"
  let compare e1 e2=
    let e1 = !e1 in
    let e2 = !e2 in
    Set.compare_direct e1 e2
  let add edge lbl = edge :=  (Set.add (!edge) lbl)
  let remove edge lbl = ref (Set.remove (!edge) lbl)
  let mem edge lbl = Set.mem (!edge) lbl
  let equal = (=)
  let default = ref (Set.empty (module Int))
  let create () = ref (Set.empty (module Int))
end

module G = Imperative.Digraph.ConcreteLabeled(Node)(Label)

module Dot = Graph.Graphviz.Dot(struct
                 include G (* use the graph module from above *)
                 let edge_attributes (_, e, _) = [`Label (Label.to_string e); `Color 4711]
                 let default_edge_attributes _ = []
                 let get_subgraph _ = None
                 let vertex_attributes v = [`Shape `Box ;`Fontsize 24;`Label (G.V.label v).label]
                 let vertex_name v = (string_of_int (G.V.label v).id)
                 let default_vertex_attributes _ = []
                 let graph_attributes _ = [`OrderingOut; `Rankdir `TopToBottom; `Orientation `Landscape]
               end)
let g_to_dot gr filename=
  let file = Caml.open_out_bin filename in
  Dot.output_graph file gr

let main () =
  
  let g = G.create () in 

  let v1 = Node.create 1000 "A" in
  let v2 = Node.create 1001 "B" in
  let l1 = Label.create () in
  let _ = Label.add l1 1 in
  let e = G.E.create v1 l1  v2 in
  G.add_edge_e g e;
  Label.add (G.E.label e) 2;
  Label.add (G.E.label e) 3;

  let l2 = Label.create () in 
  let _ = Label.add l2 4 in
  let _ = Label.add l2 5 in
  let _ = Label.remove l2 4 in


  let e3 = G.E.create v2 l2 v1 in
  G.add_edge_e g e3;

  let l3 = Label.create () in 
  let _ = Label.add l3 10 in
  let _ = Label.add l3 20 in
  let _ = Label.add l3 30 in


  let e4 = G.E.create v2 l3 v1 in
  G.add_edge_e g e4;


  g_to_dot g "imperative_graph.dot";
  let edge = G.find_edge g v1 v2 in 
  Printf.printf "Edge: (%d,%s,%d)\n" (Node.id (G.E.src edge)) (Label.to_string (G.E.label edge)) (Node.id (G.E.dst edge)) ;
  Printf.printf "e3=e4: %d\n" (G.E.compare e3 e4)

 let _ = main ();;
