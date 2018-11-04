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

let compute_primes ~max_prime_count =
  let primes = Array.make max_prime_count 0 in
  let rec loop ~prime_count ~candidate =
    if prime_count = max_prime_count then
      ()
    else if is_prime ~primes ~prime_count ~candidate then (
      primes.(prime_count) <- candidate;
      Printf.printf "%d\n" candidate;
      loop ~prime_count:(prime_count + 1) ~candidate:(candidate + 1)
    ) else
      loop ~prime_count ~candidate:(candidate + 1)
  in
  loop ~prime_count:0 ~candidate:2

let () =
  Printf.printf "begin\n%!";
  let max_prime_count = int_of_string (Sys.getenv "PRIME_COUNT") in
  compute_primes ~max_prime_count;
  Printf.printf "end\n%!"
