type t =
  | Build of
      { file : string
      ; tag : string
      ; path : string
      ; build_args : (string * string) list
      }
  | Run of
      { tag : string
      ; env : (string * string) list
      }

val to_command : t -> string * string array
(** Convert an abstract command into arguments.  This is the same format as
    [Lwt_process.command] and the arguments have the same meaning as those for [execv(3)] in
    Linux.  *)
