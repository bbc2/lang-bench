local N = assert(
    os.getenv("PRIME_LIMIT"),
    "Please specify how many numbers you want to check."
)

local primes = {}
local function is_prime(num)
    for _, p in ipairs(primes) do
        if num % p == 0 then
            return false
        end
    end
    return true
end

for i = 2, N-1 do
    if is_prime(i) then
        table.insert(primes, i)
    end
end

print(table.concat(primes, "\n"))
