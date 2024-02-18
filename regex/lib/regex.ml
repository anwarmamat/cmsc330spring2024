(*
  Lists all words from "war and peace" that match the pattern

  More documentation about the Re library: https://ocaml.org/p/re/latest/doc/Re/index.html
*)

(* Read a file line by line*)
let read_lines file =
  let cwd = Sys.getcwd () in
  let file_name = cwd ^ "/" ^ file in
  let contents = In_channel.with_open_bin file_name In_channel.input_all in
  String.split_on_char '\n' contents

let str2re t = Re.Posix.compile (Re.Posix.re t)

(* Return all matched words in a Hash Table*)
let match_words p =
  let lines = read_lines "war_peace.txt" in
  let delimiter = str2re "[<>/,?!. '-()\":;*]" in
  let pattern = str2re p in
  let h = Hashtbl.create 1331 in
  let _ =
    List.iter
      (fun line ->
        let words = Re.split delimiter line in
        (* split each line into a words array *)
        List.fold_left
          (fun _acc word ->
            let word = String.lowercase_ascii word in
            if List.length (Re.matches pattern word) > 0 then
              Hashtbl.replace h word true
            else ())
          () words)
      lines
  in
  h

(*
    let r = str2re "[a-z]*([0-9]+) [a-z]*([0-9]+)";;    
    let t = Re.exec t "cmsc330 Spring2024";;
    Re.Group.get t 1;; 
    *)
