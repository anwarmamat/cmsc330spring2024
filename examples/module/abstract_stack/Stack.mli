module type Stack = sig
  (* The type of a stack whose elements are type 'a *)
  type 'a stack

  (* The empty stack *)
  val empty : 'a stack

  (* Whether the stack is empty*)
  val is_empty : 'a stack -> bool

  (* [push x s] is the stack [s] with [x] pushed on the top *)
  val push : 'a -> 'a stack -> 'a stack

  (* [peek s] is the top element of [s]. 
     Raises Failure if [s] is empty. *)
  val peek : 'a stack -> 'a

  (* [pop s] pops and discards the top element of [s]. 
     Raises Failure if [s] is empty. *)
  val pop : 'a stack -> 'a stack
end
