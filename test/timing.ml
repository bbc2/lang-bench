module Timing = struct
  type t = int Bench_lib.Timing.t
  [@@deriving eq,ord,show]
end

let counter () =
  let count = ref 0 in
  fun () ->
    let current = !count in
    count := !count + 1;
    current

let test ~name ~input ~expected =
  ( name
  , `Quick
  , fun () ->
    let actual =
      let accumulator = Bench_lib.Timing.accumulator ~get_time:(counter ()) in
      input
      |> List.fold_left
        (fun a b -> accumulator.Bench_lib.Accumulator.fold b a)
        accumulator.Bench_lib.Accumulator.init
      |> accumulator.Bench_lib.Accumulator.finalize
    in
    Alcotest.(check (module Timing)) name expected actual
  )

let accumulator =
  [ test
      ~name:"Empty"
      ~input:[]
      ~expected:(Error "Missing \"begin\"")
  ; test
      ~name:"Missing begin"
      ~input:["invalid"]
      ~expected:(Error "\"begin\" should be the first line")
  ; test
      ~name:"Only begin"
      ~input:["begin"]
      ~expected:(Error "Missing \"end\"")
  ; test
      ~name:"Only delimiters"
      ~input:["begin"; "end"]
      ~expected:(Ok (0, 1))
  ; test
      ~name:"Some lines"
      ~input:["begin"; "line 1"; "line 2"; "end"]
      ~expected:(Ok (0, 1))
  ; test
      ~name:"Missing end"
      ~input:["begin"]
      ~expected:(Error "Missing \"end\"")
  ; test
      ~name:"Line after end"
      ~input:["begin"; "end"; "extra line"]
      ~expected:(Error "\"end\" should be the last line")
  ]

let () =
  Alcotest.run
    "Timing"
    [ ("accumulator", accumulator)
    ]
