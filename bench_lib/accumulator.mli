type ('input, 'acc, 'result) t =
  { init : 'acc
  ; fold : 'input -> 'acc -> 'acc
  ; finalize : 'acc -> 'result
  }
(** Accumulators can be used to fold on sequences.

    [init] is supposed to be the initial state and [finalize] should be used on the
    ['acc] value after the fold was done. *)

val void : ('input, unit, unit) t
(** Accumulator that accepts any input and doesn't do anything with it. *)

val cat : (string, string list, string) t
(** Accumulator that returns the concatenation of input strings. *)
