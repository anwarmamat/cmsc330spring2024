### OCaml Exceptions
* Exceptions are declared with exception
They may appear in the signature as well
* Exceptions may take arguments
Just like type constructors
May also have no arguments
* Catch exceptions with try...with...
    * Pattern-matching can be used in with
    * If an exception is uncaught
        * Current function exits immediately
        * Control transfers up the call chain
*   Until the exception is caught, or until it reaches the top level

```ocaml
exception My_exception of int
let f n =
  if n > 0 then
    raise (My_exception n)
  else
    raise (Failure "foo")

(* Handle the exception with try-with *)
let bar n =
  try
    f n
  with My_exception n ->
      Printf.printf "Caught %d\n" n
    | Failure s ->
      Printf.printf "Caught %s\n" s
```

* `failwith s`:Raises exception Failure s (s is a string).
* `Not_found`:Exception raised by library functions if the object does not exist
* `invalid_arg s`:Raises exception Invalid_argument s

### Example
The function `div` throws an exception if the divisor is zero.
```ocaml
let div x y = 
  if y = 0 then failwith "div by 0" 
  else x/y;;
```
`List.assoc` throws `Not_Found` exception if the key is not found in the associative list. 
```ocaml
let lst =[(1,"alice");(2,"bob");(3,"cat")];;

let lookup key lst = 
  try
    List.assoc key lst 
  with      
    Not_found -> "key does not exist"
```