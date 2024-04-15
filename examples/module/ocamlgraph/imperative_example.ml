(* ocamlfind ocamlc -linkpkg -package ocamlgraph imperative_example.ml -o g.exe *)
open Graph

module Node = struct
   type t = int
   let compare = Pervasives.compare
   let hash = Hashtbl.hash
   let equal = (=)
end

(* representation of an edge -- must be comparable *)
module Edge = struct
   type t = int * string (* id and name *)
   let compare (x,_) (y,_) = Pervasives.compare x y 
   let equal = (=)
   let default = (0,"")
   let label (a,b) = "["^string_of_int a ^ "," ^ b ^ "]"
   (* return the edge as a string in (src,label,dst) format*) 
   let to_string e = "" 
   let id e = 0 (* returns the id of the label *)

end

module G = Imperative.Digraph.ConcreteLabeled(Node)(Edge)

let g = G.create ()

let e1 = G.E.create 1 (100,"A") 2

let _= G.add_edge_e g e1 

let e2 = G.E.create 1 (200,"B") 2

let _= G.add_edge_e g e2 

let _= G.iter_edges_e (fun e-> Printf.printf "(%s,%s,%s)\n" (string_of_int (G.E.src e)) (Edge.label (G.E.label e)) (string_of_int (G.E.dst e)) ) g

let _= Printf.printf "e1=e2: %d\n" (G.E.compare e1 e2)


(*
I want the module Edge or G.E to have all edge functions. I want to do wither

G.E.id
G.E.to_string 

or 

Edge.src 
Edge.dst 
*)
