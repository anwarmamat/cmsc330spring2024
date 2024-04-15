open Fraction
       
let f1 = Fraction.make(2,8);;
let f2 = Fraction.make(25,100);;
Printf.printf "%s + %s = %s\n"
  (Fraction.toString f1)
  (Fraction.toString f2)  
  (Fraction.toString (Fraction.add (f1,f2)));;
