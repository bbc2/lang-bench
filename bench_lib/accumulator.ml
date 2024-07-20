type ('input, 'acc, 'result) t =
  { init : 'acc
  ; fold : 'input -> 'acc -> 'acc
  ; finalize : 'acc -> 'result
  }

let void =
  { init = ()
  ; fold = (fun _input acc -> acc)
  ; finalize = (fun acc -> acc)
  }

let cat =
  { init = []
  ; fold = CCList.cons
  ; finalize =
      ( fun acc ->
          acc
          |> CCList.rev
          |> CCString.concat "\n"
      )
  }
