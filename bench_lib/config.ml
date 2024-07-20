let tag = "lang-bench"

let runs_per_benchmark = 3

module Alpine = struct
  type t =
    | V_3_8
end

module Debian = struct
  type t =
    | Bookworm
end

module Distribution = struct
  type t =
    | Alpine of Alpine.t
    | Debian of Debian.t

  let name distribution =
    match distribution with
    | Alpine _ -> "alpine"
    | Debian _ -> "debian"

  let version distribution =
    match distribution with
    | Alpine V_3_8 -> "3.8"
    | Debian Bookworm -> "bookworm"

  let tag distribution =
    Printf.sprintf "%s-%s" (name distribution) (version distribution)
end

module Languages = struct
  let bash ~env =
    { Benchmark.properties =
        [ ("language", "bash")
        ]
    ; commands =
        { build =
            Docker.Build
              { file = "primes/bash/Dockerfile"
              ; tag
              ; path = "primes/bash"
              ; build_args = []
              }
        ; run =
            Docker.Run {tag; env}
        }
    }

  let go ~env ~version ~distribution =
    { Benchmark.properties =
        [ ("language", "go")
        ; ("distribution", Distribution.version distribution)
        ; ("version", version)
        ]
    ; commands =
        { build =
            Docker.Build
              { file = "primes/go/Dockerfile"
              ; tag
              ; path = "primes/go"
              ; build_args =
                  [ ("DISTRIBUTION", Distribution.version distribution)
                  ; ("VERSION", version)
                  ]
              }
        ; run =
            Docker.Run {tag; env}
        }
    }

  let lua ~env ~version ~distribution =
    { Benchmark.properties =
        [ ("language", "lua")
        ; ("version", version)
        ; ("distribution", Distribution.tag distribution)
        ]
    ; commands =
        { build =
            Docker.Build
              { file =
                  Printf.sprintf
                    "primes/lua/lua-%s.dockerfile"
                    (Distribution.name distribution)
              ; tag
              ; path = "primes/lua"
              ; build_args =
                  [ ("DISTRIBUTION_VERSION", Distribution.version distribution)
                  ; ("LUA_VERSION", version)
                  ]
              }
        ; run =
            Docker.Run {tag; env}
        }
    }

  let luajit ~env ~version ~distribution =
    { Benchmark.properties =
        [ ("language", "luajit")
        ; ("version", version)
        ; ("distribution", Distribution.tag distribution)
        ]
    ; commands =
        { build =
            Docker.Build
              { file =
                  Printf.sprintf
                    "primes/lua/luajit-%s.dockerfile"
                    (Distribution.name distribution)
              ; tag
              ; path = "primes/lua"
              ; build_args =
                  [ ("DISTRIBUTION_VERSION", Distribution.version distribution)
                  ; ("LUA_VERSION", version)
                  ]
              }
        ; run =
            Docker.Run {tag; env}
        }
    }

  let nodejs ~env ~version ~distribution =
    { Benchmark.properties =
        [ ("language", "nodejs")
        ; ("version", version)
        ; ("distribution", Distribution.tag distribution)
        ]
    ; commands =
        { build =
            Docker.Build
              { file = "primes/nodejs/Dockerfile"
              ; tag
              ; path = "primes/nodejs"
              ; build_args =
                  [ ("DISTRIBUTION", Distribution.version distribution)
                  ; ("VERSION", version)
                  ]
              }
        ; run =
            Docker.Run {tag; env}
        }
    }

  let ruby ~env ~version ~distribution =
    { Benchmark.properties =
        [ ("language", "ruby")
        ; ("distribution", Distribution.version distribution)
        ; ("version", version)
        ]
    ; commands =
        { build =
            Docker.Build
              { file = "primes/ruby/Dockerfile"
              ; tag
              ; path = "primes/ruby"
              ; build_args =
                  [ ("DISTRIBUTION", Distribution.version distribution)
                  ; ("VERSION", version)
                  ]
              }
        ; run =
            Docker.Run {tag; env}
        }
    }

  let ocaml ~env =
    { Benchmark.properties =
        [ ("language", "ocaml")
        ; ("version", "4.07.0")
        ]
    ; commands =
        { build =
            Docker.Build
              { file = "primes/ocaml/Dockerfile"
              ; tag
              ; path = "primes/ocaml"
              ; build_args = []
              }
        ; run =
            Docker.Run {tag; env}
        }
    }

  let zsh ~env =
    { Benchmark.properties =
        [ ("language", "zsh")
        ]
    ; commands =
        { build =
            Docker.Build
              { file = "primes/zsh/Dockerfile"
              ; tag
              ; path = "primes/zsh"
              ; build_args = []
              }
        ; run =
            Docker.Run {tag; env}
        }
    }

  let rust ~env ~version ~debug =
    { Benchmark.properties =
        [ ("language", "rust")
        ; ("debug", debug)
        ; ("version", version)
        ]
    ; commands =
        { build =
            Docker.Build
              { file = "primes/rust/Dockerfile"
              ; tag
              ; path = "primes/rust"
              ; build_args =
                  [ ("DEBUG", debug)
                  ; ("VERSION", version)
                  ]
              }
        ; run =
            Docker.Run {tag; env}
        }
    }
end

module Parameters = struct
  type t =
    { prime_count : int
    ; debug : bool
    }

  let to_docker_env parameters =
    [ ("PRIME_COUNT", string_of_int parameters.prime_count)
    ; ("BENCH_DEBUG", if parameters.debug then "true" else "false")
    ]
end

let benchmarks ~parameters =
  let env = Parameters.to_docker_env parameters in
  [ Languages.bash ~env
  ; Languages.go ~env ~version:"1.22" ~distribution:(Debian Bookworm)
  ; Languages.lua ~env ~version:"5.3" ~distribution:(Debian Bookworm)
  ; Languages.lua ~env ~version:"5.3" ~distribution:(Alpine V_3_8)
  ; Languages.luajit ~env ~version:"5.3" ~distribution:(Debian Bookworm)
  ; Languages.luajit ~env ~version:"5.3" ~distribution:(Alpine V_3_8)
  ; Languages.nodejs ~env ~version:"20.15.1" ~distribution:(Debian Bookworm)
  ; Languages.ruby ~env ~version:"3.3.4" ~distribution:(Debian Bookworm)
  ; Languages.rust ~env ~version:"1.30.0" ~debug:"false"
  ; Languages.ocaml ~env
  ; Languages.zsh ~env
  ]
