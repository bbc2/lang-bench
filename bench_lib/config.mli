val runs_per_benchmark : int
(** Number of times each benchmark will be run.  Each run, if successful, yields an
    execution time. *)

val benchmarks : Benchmark.t list
(** Hardcoded list of benchmarks. *)
