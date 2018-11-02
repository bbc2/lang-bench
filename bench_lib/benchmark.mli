type commands =
  { build : Docker.t
  ; run : Docker.t
  }
(** The [build] command must be executed before any of its corresponding [run] command.
    Then, the [run] command can be executed as many times as desired. *)

type t =
  { properties : (string * string) list  (** List of parameters encoded as [(key, value)]. *)
  ; commands : commands
  }
