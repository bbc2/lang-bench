type ('input, 'acc, 'result) t =
  { init : 'acc
  ; fold : 'input -> 'acc -> 'acc
  ; finalize : 'acc -> 'result
  }

let empty =
  { init = ()
  ; fold = (fun _input acc -> acc)
  ; finalize = (fun acc -> acc)
  }
