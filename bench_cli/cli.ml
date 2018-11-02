let run_benchmark benchmark =
  let build_command = Bench_lib.Docker.to_command benchmark.Bench_lib.Benchmark.commands.build in
  let run_command = Bench_lib.Docker.to_command benchmark.Bench_lib.Benchmark.commands.run in
  let open Lwt_result.Infix in
  Bench_lib.Runner.execute ~stdout_acc:Bench_lib.Accumulator.empty ~prefix:"build" build_command >>= fun _ ->
  let timer = Bench_lib.Timing.accumulator ~get_time:Unix.gettimeofday in
  Lwt_stream.fold_s
    ( fun () result ->
        match result with
        | Error _ ->
          result
          |> Lwt.return
        | Ok times ->
          Bench_lib.Runner.execute ~stdout_acc:timer ~prefix:"run" run_command >>= fun acc ->
          Lwt.return acc >|= fun (begin_, end_) ->
          (end_ -. begin_) :: times
    )
    (Bench_lib.Util.loop_stream ~count:Bench_lib.Config.runs_per_benchmark)
    (Ok [])

let main_lwt () =
  let%lwt results =
    Bench_lib.Config.benchmarks
    |> Lwt_stream.of_list
    |> Lwt_stream.map_s
      ( fun benchmark ->
          let%lwt results = run_benchmark benchmark in
          {Bench_lib.Output.Benchmark.properties = benchmark.properties; times = results}
          |> Lwt.return
      )
    |> Lwt_stream.to_list
  in
  results
  |> [%to_yojson: Bench_lib.Output.t]
  |> Yojson.Safe.pretty_to_string
  |> Printf.printf "%s\n"
  |> Lwt.return

let main () =
  Lwt_main.run (main_lwt ())

let () =
  main ()
