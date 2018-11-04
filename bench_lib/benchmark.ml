type commands =
  { build : Docker.t
  ; run : Docker.t
  }

type t =
  { properties : (string * string) list
  ; commands : commands
  }
