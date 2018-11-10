let tag = "lang-bench"

let prime_count = ("PRIME_COUNT", "10")

let runs_per_benchmark = 3

module Alpine = struct
  type t =
    | V_3_8
end

module Debian = struct
  type t =
    | Stretch
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
    | Debian Stretch -> "stretch"

  let tag distribution =
    Printf.sprintf "%s-%s" (name distribution) (version distribution)
end

module Languages = struct
  let bash =
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
            Docker.Run
              { tag
              ; env = [prime_count]
              }
        }
    }

  let go ~version ~distribution =
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
            Docker.Run
              { tag
              ; env = [prime_count]
              }
        }
    }

  let lua ~version ~distribution =
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
            Docker.Run
              { tag
              ; env = [prime_count]
              }
        }
    }

  let luajit ~version ~distribution =
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
            Docker.Run
              { tag
              ; env = [prime_count]
              }
        }
    }

  let nodejs ~version ~distribution =
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
            Docker.Run
              { tag
              ; env = [prime_count]
              }
        }
    }

  let ruby ~version ~distribution =
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
            Docker.Run
              { tag
              ; env = [prime_count]
              }
        }
    }

  let ocaml =
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
            Docker.Run
              { tag
              ; env = [prime_count]
              }
        }
    }

  let zsh =
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
            Docker.Run
              { tag
              ; env = [prime_count]
              }
        }
    }

  let rust ~version ~debug =
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
            Docker.Run
              { tag
              ; env = [prime_count]
              }
        }
    }
end

let benchmarks =
  [ Languages.bash
  ; Languages.go ~version:"1.11.2" ~distribution:(Debian Stretch)
  ; Languages.lua ~version:"5.3" ~distribution:(Debian Stretch)
  ; Languages.lua ~version:"5.3" ~distribution:(Alpine V_3_8)
  ; Languages.luajit ~version:"5.3" ~distribution:(Debian Stretch)
  ; Languages.luajit ~version:"5.3" ~distribution:(Alpine V_3_8)
  ; Languages.nodejs ~version:"8.12.0" ~distribution:(Debian Stretch)
  ; Languages.ruby ~version:"2.5.3" ~distribution:(Debian Stretch)
  ; Languages.rust ~version:"1.30.0" ~debug:"false"
  ; Languages.ocaml
  ; Languages.zsh
  ]
