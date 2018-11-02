let loop_stream ~count =
  let counter = ref 0 in
  Lwt_stream.from_direct
    ( fun () ->
        if !counter >= count then
          None
        else (
          counter := !counter + 1;
          Some ()
        )
    )
