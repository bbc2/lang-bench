module Benchmark : sig
  type t =
    { properties : (string * string) list  (** List of parameters encoded as [(key, value)]. *)
    ; times : (float list, string) result  (** List of execution wall-clock times if the
                                               all the runs were successful. *)
    }
  [@@deriving eq,ord,show]
end

type t = Benchmark.t list
[@@deriving eq,ord,show]
(** Output type for benchmarks.  Use [to_yojson] to get JSON. *)

val to_yojson : t -> Yojson.Safe.t
(** Output JSON of benchmarks. *)
