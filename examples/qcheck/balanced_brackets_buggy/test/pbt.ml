open QCheck
open Base
open Balanced_bracket

(* generate balanced brackets *)
let rec gen_balanced n =
  let open Gen in 
  match n with
    0 -> Gen.return ""
  | _->  let mid = (gen_balanced (n-1)) in 
         oneof [
             mid >>= (fun x -> return ("[" ^ x ^ "]" ));
             mid >>= (fun x -> return ("(" ^ x ^ ")" ));
             mid >>= (fun x ->  return ("{" ^ x ^ "}" ))
           ]

(* insert a bracket to a string with balanced brackets *)
let gen_unbalanced n =
  let t = gen_balanced n in
  let _= Random.self_init ()  in 
  let open Gen in 
  let p = oneof [
              return "[";
              return "(";
              return "{";
              return "]";
              return ")";
              return "}"
            ]
  in 
  t  >>= fun x-> (p >>= (fun y ->
                    let len = String.length x in 
                    let i = Random.int len in 
                    let s = (Stdlib.String.sub x 0 i) ^ y ^ (Stdlib.String.sub x  i (len-i)) in
                    return s
                 ))
(* 
Shrink the string by:
1. delete a [].  Example: ([]) ==> ()
2. delete a {}.  Example: ([{}]) ==> ([])
3. delete a (). Example: [()] ==> []
4. delete the outmost bracket if it is pair. example: {[]()} ==> []()
 *)               
let shrink_brackets s  =
  let str =
    let s1 = String.substr_replace_first s ~pattern:"[]" ~with_:"" in
    let s2 = String.substr_replace_first s ~pattern:"{}" ~with_:"" in 
    let s3 = String.substr_replace_first s ~pattern:"()" ~with_:"" in
    let s4 = (String.drop_prefix (String.drop_suffix s 1) 1) in 
    let t = List.dedup_and_sort ~compare:String.compare [s1;s2;s3;s4] in
    List.filter ~f:(fun x->not (String.equal x s)) t in
  let t = String.concat str ~sep:"," in 
  let _= Stdio.print_string ("Iter:" ^ t^"\n") in 
    Iter.of_list str
;;

(* make an arbitrary with the generator and shirnker *)
(* with shrink*)
let brackets_with_shrink = make (gen_balanced 10) ?print:(Some (fun x->x)) ?shrink:(Some shrink_brackets)
(* without shrink *)
let brackets_without_shrink = make (gen_balanced 10) ?print:(Some (fun x->x))
             
(* make tests *)
let  test_unbalanced_bracket = 
  Test.make
    ~name:"test_unbalanced_bracket"
    ~count:1000 (* number of tests *)
    (int_range 1 10) (* depth of the breackets *)
    (fun n ->
      let t = Gen.generate1 (gen_unbalanced n) in 
      not (balanced t)
    )

let  test_balanced_bracket = 
  Test.make
    ~name:"test_balanced_bracket"
    ~count:1000 (* number of tests *)
    (* please try the arbitrary with/without shrink *)
    (brackets_with_shrink)    (* with shrink, the counter example always shrinks to [] *)
    (* (brackets_without_shrink)*)    (* without shrink, the counter examnple is longer *)
    (fun t ->
      balanced t
    )
;;
QCheck_runner.run_tests 
  ~verbose:true
  ?debug_shrink:(Some (Some Stdio.stdout))
  [
    test_balanced_bracket;
    test_unbalanced_bracket
  ]
;;


