type 'time state =
  { begin_ : 'time option
  ; end_ : 'time option
  }
[@@deriving eq,ord,show]

type 'time t = ('time * 'time, string) result
[@@deriving eq,ord,show]

let fold ~get_time input acc =
  match (acc, input) with
  | (Ok {begin_ = None; end_ = None}, "begin") ->
    Ok {begin_ = Some (get_time ()); end_ = None}
  | (Ok {begin_ = None; end_ = _}, _) ->
    Error "\"begin\" should be the first line"
  | (Ok {begin_ = Some begin_; end_ = None}, "end") ->
    Ok {begin_ = Some begin_; end_ = Some (get_time ())}
  | (Ok {begin_ = Some begin_; end_ = None}, _) ->
    Ok {begin_ = Some begin_; end_ = None}
  | (Ok {begin_ = Some _; end_ = Some _}, _) ->
    Error "\"end\" should be the last line"
  | (Error _, _) ->
    acc

let finalize acc =
  match acc with
  | Ok {begin_ = None; end_ = None} ->
    Error "Missing \"begin\""
  | Ok {begin_ = Some begin_time; end_ = Some end_time} ->
    Ok (begin_time, end_time)
  | Ok {begin_ = Some _; end_ = None} ->
    Error "Missing \"end\""
  | Ok _ ->
    Error "Unknown error"
  | Error _ as error ->
    error

let accumulator ~get_time =
  { Accumulator.init =
      Ok
        { begin_ = None
        ; end_ = None
        }
  ; fold = fold ~get_time
  ; finalize
  }
