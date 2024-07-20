let run_benchmark benchmark =
  let open Lwt_result.Infix in
  let build_command = Bench_lib.Docker.to_command benchmark.Bench_lib.Benchmark.commands.build in
  let run_command = Bench_lib.Docker.to_command benchmark.Bench_lib.Benchmark.commands.run in
  Bench_lib.Runner.execute ~stdout_acc:Bench_lib.Accumulator.void ~prefix:"build" build_command >>= fun _ ->
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

let test_benchmark benchmark =
  let open Lwt_result.Infix in
  let build_command = Bench_lib.Docker.to_command benchmark.Bench_lib.Benchmark.commands.build in
  let run_command = Bench_lib.Docker.to_command benchmark.Bench_lib.Benchmark.commands.run in
  Bench_lib.Runner.execute ~stdout_acc:Bench_lib.Accumulator.void ~prefix:"build" build_command >>= fun _ ->
  Bench_lib.Runner.execute ~stdout_acc:Bench_lib.Accumulator.cat ~prefix:"run" run_command

let run_lwt () =
  let parameters =
    {Bench_lib.Config.Parameters.prime_count = 5; debug = false}
  in
  let%lwt results =
    Bench_lib.Config.benchmarks ~parameters
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

let test_lwt () =
  let parameters =
    {Bench_lib.Config.Parameters.prime_count = 5; debug = true}
  in
  let%lwt results =
    Bench_lib.Config.benchmarks ~parameters
    |> Lwt_stream.of_list
    |> Lwt_stream.map_s test_benchmark
    |> Lwt_stream.to_list
  in
  results
  |> [%show: (string, string) result list]
  |> Printf.printf "%s\n"
  |> Lwt.return

let run () =
  Lwt_main.run (run_lwt ())

let test () =
  Lwt_main.run (test_lwt ())

let info =
  Cmdliner.Cmd.info
      ~version:"dev"
      ~doc:"Language Benchmarks"
      "lang-bench"

let run_cmd =
  let info = Cmdliner.Cmd.info "run" in
  let term = Cmdliner.Term.(const run $ const ()) in
  Cmdliner.Cmd.v info term

let test_cmd =
  let info = Cmdliner.Cmd.info "test" in
  let term = Cmdliner.Term.(const test $ const ()) in
  Cmdliner.Cmd.v info term

let main () =
  let result =
    Cmdliner.Cmd.eval
      (Cmdliner.Cmd.group info [run_cmd; test_cmd])
  in
  exit result

let () =
  main ()
