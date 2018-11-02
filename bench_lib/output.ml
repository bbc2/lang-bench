module Benchmark = struct
  type t =
    { properties : (string * string) list
    ; times : (float list, string) result
    }
  [@@deriving eq,ord,show]

  let properties_to_assoc properties =
    `Assoc
      ( properties
        |> CCList.map (fun (key, value) -> (key, `String value))
      )

  let to_yojson result =
    match result with
    | {properties; times = Ok times} ->
      `Assoc
        [ ("properties", properties_to_assoc properties)
        ; ("result", `String "ok"); ("times", [%to_yojson: float list] times)
        ]
    | {properties; times = Error text} ->
      `Assoc
        [ ("properties", properties_to_assoc properties)
        ; ("result", `String "error"); ("text", `String text)
        ]
end

type t = Benchmark.t list
[@@deriving eq,ord,show,to_yojson]
