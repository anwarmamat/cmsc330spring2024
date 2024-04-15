open Fraction
       
let f1 = Fraction.make(2,8);;
let f2 = Fraction.make(25,100);;
Printf.printf "%s + %s = %s\n"
  (Fraction.toString f1)
  (Fraction.toString f2)  
  (Fraction.toString (Fraction.add (f1,f2)));;


(* User can see the a fraction is impleneted as a tuple. So they can create the fraction directly using a tuple *)

let f1 = Fraction.Frac (10,20);; (* now, f1 is not reduced*)
Printf.printf "not reduced fraction: %s\n"
  (Fraction.toString f1)



