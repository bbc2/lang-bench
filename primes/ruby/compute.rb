PRIME_COUNT = ENV["PRIME_COUNT"].to_i

puts "begin"
$stdout.flush

primes = []
number = 2
while primes.size < PRIME_COUNT do
  is_multiple = primes.detect { |p| number % p == 0 }
  if not is_multiple then
    primes << number
    puts number
  end
  number += 1
end

puts "end"
$stdout.flush
