val runs_per_benchmark : int
(** Number of times each benchmark will be run.  Each run, if successful, yields an
    execution time. *)

module Parameters : sig
  type t =
    { prime_count : int
    ; debug : bool
    }
end

val benchmarks : parameters:Parameters.t -> Benchmark.t list
(** Hardcoded list of benchmarks. *)
