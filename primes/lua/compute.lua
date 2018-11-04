local PRIME_COUNT = assert(
    os.getenv("PRIME_COUNT"),
    "Please set PRIME_COUNT environment variable."
)
PRIME_COUNT = tonumber(PRIME_COUNT)
local BENCH_DEBUG = os.getenv("BENCH_DEBUG")

local primes = {}
local function is_prime(number)
    for _, prime in ipairs(primes) do
        if number % prime == 0 then
            return false
        end
    end
    return true
end

print("begin")
io.stdout:flush()

local number = 2
while #primes < PRIME_COUNT do
    if is_prime(number) then
        table.insert(primes, number)
    end
    number = number + 1
end

if BENCH_DEBUG == "true" then
    print(table.concat(primes, "\n"))
end

print("end")
io.stdout:flush()
