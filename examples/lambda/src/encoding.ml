open Exp

let myzero =  Lam ("f", Lam ("x", Var "x"))
let myone = Lam ("f", Lam ("x", App (Var "f", Var "x")))
let mytwo = Lam ("f", Lam ("x", App (Var "f", App (Var "f", Var "x"))))
let mythree = Lam ("f", Lam ("x", App (Var "f", App (Var "f", App (Var "f", Var "x")))))  (* "Lf. Lx. f (f (f x))" *)
let mysucc = Lam ("n",
Lam ("f", Lam ("x", App (Var "f", App (App (Var "n", Var "f"), Var "x"))))) (*"Ln. Lf. Lx. f (n f x)" *)
let myplus = Lam ("m",
Lam ("n",
 Lam ("f",
  Lam ("x",
   App (App (Var "m", Var "f"), App (App (Var "n", Var "f"), Var "x"))))))
   (*parse "Lm. Ln. Lf. Lx. m f (n f x)"*)
let mymult = Lam ("m", Lam ("n", Lam ("f", App (Var "m", App (Var "n", Var "f"))))) (* "Lm. Ln. Lf. m (n f)"*)
let mytrue = Lam ("x", Lam ("y", Var "x")) (* "Lx. Ly. x" *)
let myfalse = Lam ("x", Lam ("y", Var "y")) (* "Lx.Ly. y" *)
let myif = Lam ("a", Lam ("b", Lam ("c", App (App (Var "a", Var "b"), Var "c")))) (* "La. Lb. Lc. a b c" *)
let mynot = Lam ("b", Lam ("x", Lam ("y", App (App (Var "b", Var "y"), Var "x")))) (* "Lb. Lx. Ly.  b y x" *)
let myand = Lam ("a",
Lam ("b",
 Lam ("x",
  Lam ("y",
   App (App (Var "b", App (App (Var "a", Var "x"), Var "y")), Var "y"))))) (* "La. Lb. Lx. Ly. b (a x y) y" *)
let myor = Lam ("a",
Lam ("b",
 Lam ("x",
  Lam ("y",
   App (App (Var "b", Var "x"), App (App (Var "a", Var "x"), Var "y")))))) (*"La. Lb. Lx. Ly.  b x (a x y)" *)
let iszero = Lam ("n",
App (App (Var "n", Lam ("x", Lam ("x", Lam ("y", Var "y")))),
 Lam ("x", Lam ("y", Var "x")))) (* "Ln. n (Lx. (Lx.Ly. y)) (Lx. Ly. x)" *)
let mypred = Lam ("n",
Lam ("f",
 Lam ("x",
  App
   (App
     (App (Var "n",
       Lam ("g", Lam ("h", App (Var "h", App (Var "g", Var "f"))))),
     Lam ("u", Var "x")),
   Lam ("u", Var "u"))))) (* "Ln. Lf. Lx. n (Lg.  Lh.  h (g f)) (Lu.x) (Lu. u)" *)

let myminus =Lam ("m",
Lam ("n",
 App
  (App (Var "n",
    Lam ("n",
     Lam ("f",
      Lam ("x",
       App
        (App
          (App (Var "n",
            Lam ("g", Lam ("h", App (Var "h", App (Var "g", Var "f"))))),
          Lam ("u", Var "x")),
        Lam ("u", Var "u")))))),
  Var "m"))) 
  (* "Lm. Ln. (n Ln. Lf. Lx. n (Lg.  Lh.  h (g f)) (Lu.x) (Lu. u)) m" *)

let mydiv = Lam ("n",
App
 (App
   (Lam ("f",
     App (Lam ("x", App (Var "x", Var "x")),
      Lam ("x", App (Var "f", App (Var "x", Var "x"))))),
   Lam ("c",
    Lam ("n",
     Lam ("m",
      Lam ("f",
       Lam ("x",
        App
         (Lam ("d",
           App
            (App
              (App
                (Lam ("n",
                  App
                   (App (Var "n", Lam ("x", Lam ("a", Lam ("b", Var "b")))),
                   Lam ("a", Lam ("b", Var "a")))),
                Var "d"),
              App (App (Lam ("f", Lam ("x", Var "x")), Var "f"), Var "x")),
            App (Var "f",
             App (App (App (App (Var "c", Var "d"), Var "m"), Var "f"),
              Var "x")))),
         App
          (App
            (Lam ("m",
              Lam ("n",
               App
                (App (Var "n",
                  Lam ("n",
                   Lam ("f",
                    Lam ("x",
                     App
                      (App
                        (App (Var "n",
                          Lam ("g",
                           Lam ("h", App (Var "h", App (Var "g", Var "f"))))),
                        Lam ("u", Var "x")),
                      Lam ("u", Var "u")))))),
                Var "m"))),
            Var "n"),
          Var "m")))))))),
 App
  (Lam ("n",
    Lam ("f", Lam ("x", App (Var "f", App (App (Var "n", Var "f"), Var "x"))))),
  Var "n")))