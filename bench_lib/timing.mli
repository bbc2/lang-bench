type 'time state

type 'time t = ('time * 'time, string) result
[@@deriving eq,ord,show]
(** Returned by [accumulator.Accumulator.finalize] called on the final state.

    The ['time * 'time] couple is the result of calling [get_time] at the beginning and
    end of the input sequence. *)

val accumulator : get_time:(unit -> 'time) -> (string, ('time state, string) result, 'time t) Accumulator.t
(** Accumulator for measuring the execution time of a process based on its well-formed
    standard output.

    It expects a sequence of strings as input.  The first string must be ["begin"] and the
    final string must be ["end"].  It will call [get_time] when it receives ["begin"] or
    ["end"], and will return the two times as a tuple.  The user can then, for instance,
    compute the delta between the two times. *)
