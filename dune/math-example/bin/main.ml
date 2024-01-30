open Lib

let () =
  let result = Math.add 2 3 in
  Printf.printf "Result = %d\n" result;
  let result = Math.sub 3 1 in
  Printf.printf "Result = %d\n" result
