type t =
  | Build of
      { file : string
      ; tag : string
      ; path : string
      ; build_args : (string * string) list
      }
  | Run of
      { tag : string
      ; env : (string * string) list
      }

let key_values_to_args ~arg ~key_values =
  key_values
  |> List.to_seq
  |> Seq.flat_map
    ( fun (key, value) ->
        List.to_seq
          [ arg
          ; Printf.sprintf "%s=%s" key value
          ]
    )
  |> Array.of_seq

let to_command =
  function
  | Build {file; tag; path; build_args} ->
    ( "docker"
    , Array.concat
        [ [|"docker"; "build"; "--force-rm"; "--file"; file|]
        ; key_values_to_args ~arg:"--build-arg" ~key_values:build_args
        ; [|"--tag"; tag; path|]
        ]
    )
  | Run {tag; env} ->
    ( "docker"
    , Array.concat
        [ [|"docker"; "run"; "--rm"|]
        ; key_values_to_args ~arg:"--env" ~key_values:env
        ; [|tag|]
        ]
    )
