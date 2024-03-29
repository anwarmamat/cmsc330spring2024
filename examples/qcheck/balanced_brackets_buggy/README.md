# QCheck Property Based Testing for Balanced Brackets in an Expression

Given an expression string exp, write a program to examine whether the pairs and the orders of `“{“, “}”, “(“, “)”, “[“, “]”` are correct in exp.

* Example 1:
```
    Input: exp = “[()]{}{[()()]()}” 
    Output: Balanced
```
* Example 2:
```
    Input: exp = “[(])” 
    Output: Not Balanced 
```

* Build:
```
dune build
```
* Test:
```
dune runtest -f
```
This is a `buggy` implementation of the balanced bracket checker. With the input `[]`, the solution fails. If you run the test with the `shrink`, the counter example simplifies to `[]`. 
```ocaml
let  test_balanced_bracket =
  Test.make
    ~name:"test_balanced_bracket1"
    ~count:100 (* number of tests *)
    (brackets_with_shrink) (* with shrink, the counter example always shrinks to [] 
*)
    (fun t ->  balanced t)
```
Example:
```
Test test_balanced_bracket sucessfully shrunk counter example (step 9) to:
[]
```
If you run test without the `shrink`, the counter eample will be a random long input. 
```ocaml
let  test_balanced_bracket =
  Test.make
    ~name:"test_balanced_bracket1"
    ~count:100 (* number of tests *)
    (brackets_without_shrink) (* without shrink, the counter examnple is        
longer *)
    (fun t ->  balanced t)
```
```
Test test_balanced_bracket failed (0 shrink steps):
({[((({{(())}})))]})
```