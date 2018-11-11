let is_prime ~primes ~prime_count ~candidate =
  let rec loop ~index =
    if index >= prime_count then
      true
    else if candidate mod primes.(index) = 0 then
      false
    else
      loop ~index:(index + 1)
  in
  loop ~index:0

let compute_primes ~max_prime_count ~bench_debug =
  let primes = Array.make max_prime_count 0 in
  let rec loop ~prime_count ~candidate =
    if prime_count = max_prime_count then
      ()
    else if is_prime ~primes ~prime_count ~candidate then (
      primes.(prime_count) <- candidate;
      loop ~prime_count:(prime_count + 1) ~candidate:(candidate + 1)
    ) else
      loop ~prime_count ~candidate:(candidate + 1)
  in
  loop ~prime_count:0 ~candidate:2;
  if bench_debug then
   Array.iter (Printf.printf "%d\n") primes

let () =
  let max_prime_count = int_of_string (Sys.getenv "PRIME_COUNT") in
  let bench_debug = match Sys.getenv_opt "BENCH_DEBUG" with
    | Some s -> s = "true"
    | None -> false in
  Printf.printf "begin\n%!";
  compute_primes ~max_prime_count ~bench_debug;
  Printf.printf "end\n%!"
