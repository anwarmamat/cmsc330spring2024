(*
  Example of a main executable reading command line arguments.
   Uses the Simple_set module

  
  Install:
    opam install ppx_inline_test   
  Build:
    dune build
  Execute:
    _build/default/src/set_main.exe string file_name
    OR
    dune exec _build/default/src/set_main.exe string file_name

  Clean:
    dune clean
*)

(** Functions to get file contents as a list of strings **)

let rec strings_from_file (f : in_channel) : string list =
    try
      let l = input_line f in
      l :: strings_from_file f
    with | _ -> []

let strings_from_file_name (s : string) : string list =
      let file = open_in s in
      let st = strings_from_file file in
      let () = close_in file in
      st
      
(**  [do_search search_string filename] searches for a string in file **)

let do_search search_string filename = 
  let strings = strings_from_file_name filename in 
  let substrings = strings |> List.map (fun elt -> String.split_on_char ' ' elt) |> List.concat in
  let substring_set = 
    List.fold_left 
      (fun set -> fun elt -> Simple_set.add elt set) 
      Simple_set.emptyset 
      substrings
    in
  if Simple_set.contains search_string substring_set then 
    Printf.printf "Search string \"%s\" found in file %s\n" search_string filename
  else Printf.printf "Search string \"%s\" not found in file %s\n" search_string filename

(* 
   The main program.
  let () = ... is a common idiom in a main module: the code will run when module loaded
  So, the code below de facto is the `main()` of our beloved C/Java/etc. world.
  You can also just directly put the code in with out the let (), but the parser
  can get confused as to whether it is part of the previous function or not. 
*)

let () = 
let len = Array.length Sys.argv in 
if len != 3 then 
  Printf.printf "Usage: set_main.exe key file_name\n"
else (
let search_string = Sys.argv.(1) in
let filename = Sys.argv.(2) in 
  do_search search_string filename
)

