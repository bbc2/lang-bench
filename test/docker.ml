module Command = struct
  type t = string * string array
  [@@deriving eq,ord,show]
end

let test ~name ~docker ~expected =
  ( name
  , `Quick
  , fun () ->
    let actual = Bench_lib.Docker.to_command docker in
    Alcotest.(check (module Command)) name expected actual
  )

let to_command =
  [ test
      ~name:"Build without args"
      ~docker:
        ( Bench_lib.Docker.Build
            {file = "file"; tag = "tag"; path = "path"; build_args = []}
        )
      ~expected:("docker", [|"docker"; "build"; "--force-rm"; "--file"; "file"; "--tag"; "tag"; "path"|])
  ; test
      ~name:"Build with args"
      ~docker:
        ( Bench_lib.Docker.Build
            {file = "file"; tag = "tag"; path = "path"; build_args = [("foo", "bar")]}
        )
      ~expected:
        ( "docker"
        , [|"docker"; "build"; "--force-rm"; "--file"; "file"; "--build-arg"; "foo=bar"; "--tag"; "tag"; "path"|]
        )
  ; test
      ~name:"Run without env"
      ~docker:(Bench_lib.Docker.Run {tag = "tag"; env = []})
      ~expected:("docker", [|"docker"; "run"; "--rm"; "tag"|])
  ; test
      ~name:"Run with env"
      ~docker:(Bench_lib.Docker.Run {tag = "tag"; env = [("foo", "bar")]})
      ~expected:("docker", [|"docker"; "run"; "--rm"; "--env"; "foo=bar"; "tag"|])
  ]

let () =
  Alcotest.run
    "Docker"
    [ ("to_command", to_command)
    ]
