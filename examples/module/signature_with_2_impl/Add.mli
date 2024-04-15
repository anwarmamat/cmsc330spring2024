module type ADD =
  sig
    type t = int (* hide the type *)
    val add: t -> t -> t
    val toString : t -> string
  end;;
