val loop_stream : count:int -> unit Lwt_stream.t
(** Return a stream of [count] [unit] elements.

    This is useful for executing an asynchronous function several times.  *)
