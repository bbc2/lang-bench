let blue =
  ANSITerminal.(sprintf [Foreground Blue])

let red =
  ANSITerminal.(sprintf [Foreground Red])

let check_status status =
  match status with
  | Unix.WEXITED 0 ->
    Ok ()
  | Unix.WEXITED code ->
    Error (Printf.sprintf "Exited with status: %d" code)
  | Unix.WSIGNALED signal ->
    Error (Printf.sprintf "Killed by signal: %d" signal)
  | Unix.WSTOPPED signal ->
    Error (Printf.sprintf "Stopped by signal: %d" signal)

let execute ~stdout_acc ~prefix command =
  let%lwt (status, accumulated) =
    Printf.eprintf "Executing: %s\n%!" (command |> snd |> Array.to_list |> String.concat " ");
    Lwt_process.with_process_full
      command
      ( fun process ->
          let%lwt acc =
            Lwt_stream.fold
              ( fun (line : string) (acc : 'a) ->
                  Printf.eprintf "%s %s\n%!" (blue "[%s]" prefix) line;
                  stdout_acc.Accumulator.fold line acc
              )
              (process#stdout |> Lwt_io.read_lines)
              stdout_acc.Accumulator.init
          in
          let%lwt () =
            process#stderr
            |> Lwt_io.read_lines
            |> Lwt_stream.iter
              ( fun line ->
                  Printf.eprintf "%s %s\n%!" (red "[%s]" prefix) line;
              )
          in
          let%lwt status = process#status in
          (status, stdout_acc.Accumulator.finalize acc)
          |> Lwt.return
      )
  in
  ( let open CCResult.Infix in
    check_status status >|= fun () ->
    accumulated
  )
  |> Lwt.return
