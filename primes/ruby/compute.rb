PRIME_COUNT_STR = ENV["PRIME_COUNT"]
if PRIME_COUNT_STR == nil then
  puts "Please set PRIME_COUNT"
  exit(-1)
end
PRIME_COUNT = PRIME_COUNT_STR.to_i
BENCH_DEBUG = ENV["BENCH_DEBUG"]

puts "begin"
$stdout.flush

primes = []
number = 2
while primes.size < PRIME_COUNT do
  is_multiple = primes.detect { |p| number % p == 0 }
  if not is_multiple then
    primes << number
  end
  number += 1
end

if BENCH_DEBUG == "true" then
  primes.each do |prime|
    puts prime
  end
end

puts "end"
$stdout.flush
