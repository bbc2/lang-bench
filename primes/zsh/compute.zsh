if [[ -z $PRIME_COUNT ]]; then
    echo "Please set PRIME_COUNT environment variable."
    exit -1
fi

primes=()
is_prime() {
    local number=$1
    for (( i = 1; i <= $#primes; i++ )) do
        if [[ $(( $number % $primes[i] )) == 0 ]]; then
            return -1
        fi
    done
    return 0
}

number=2
echo begin
while [[ $#primes -lt $PRIME_COUNT ]]; do
    if is_prime $number; then
        primes+=($number)
    fi
    number=$((number + 1))
done

if [[ $BENCH_DEBUG == "true" && $#primes -gt 0 ]]; then
    printf '%s\n' "${primes[@]}"
fi
echo end
