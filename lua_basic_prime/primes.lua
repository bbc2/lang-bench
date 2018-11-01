local N = assert(
    os.getenv("PRIME_COUNT"),
    "Please specify how many primes you want to get."
)
N = tonumber(N)

local primes = {}
local function is_prime(num)
    for _, p in ipairs(primes) do
        if num % p == 0 then
            return false
        end
    end
    return true
end

local i = 1
while true do
    i = i + 1
    if is_prime(i) then
        table.insert(primes, i)
        if #primes == N then
            break
        end
    end
end

print(table.concat(primes, "\n"))
