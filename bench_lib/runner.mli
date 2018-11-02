val execute :
  stdout_acc:((string, 'acc, 'result) Accumulator.t)
  -> prefix:string
  -> Lwt_process.command
  -> ('result, string) result Lwt.t
(** Execute a command, forward its standard output to the [stdout_acc] accumulator and
    return the result of the accumulator's [finalize] function.

    The standard output the process is output on the caller's standard error, each lines
    being prefixed by [prefix].
*)
