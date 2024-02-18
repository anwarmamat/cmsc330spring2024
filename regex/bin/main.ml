let () =
  (*
"^b[a-z]*s$"
"^a*b*c*d*e*f*g*h*i*j*k*l*m*n*o*p*r*t*u*v*w*x*y*z*$"
"[^b]*b[^b]*b[^b]*b[^b]*$" #contains 3 b's, may not be consecutive.
["^c[aouei][a-z]*$"]	#starts with c, followed by one vowel,and any number of letters 
#"^a*b*c*d*e*f*g*h*i*j*k*l*m*n*o*p*r*t*$" # all letters are in alphabetic order
#pattern << "ruby"	#contains "ruby"
#pattern << "s{3}|c{3}" #contains sss or ccc
#["^c[aouei][a-z]*$"] #starts with c, a vowel, and any letter any number of times
#pattern << "(ab){2}" #contains 2 ab
#pattern << "b{2}"  #contins 2b
#"^a[a-z]?$"  #starts with a, 0 or 1 letter after that
#"(ab|ba)+" # contains one or more ab
#"^ste(ve|phen|ven)$"  #steve, steven, or stephen
#^ste(ve|phe|)n?$#steve, steven, or stephen
#"^(..)*$"   #even length string
#"^([^aouei]*[aouei][^aouei]*[aouei][^aouei]*)*$"  #even number of vowels
#| (^[^b]+(b+[^b])* )      # starts with not-b, 0 or more times of any number of b followed by one nont-b
"^(b([^b]+b* )*[^b])$"
#"^[^ab]*ab[^ab]*ab[^ab]*$" # 2 ab's
*)
  let pattern = "[^b]*b[^b]*b[^b]*b[^b]*$" in
  Hashtbl.iter
    (fun word _ -> Printf.printf "%s\n" word)
    (Regex.match_words pattern)
