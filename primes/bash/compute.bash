if [[ -z $PRIME_COUNT ]]; then
    echo "Please set PRIME_COUNT environment variable."
    exit -1
fi

primes=""
nb_primes=0
is_prime() {
    local number=$1
    for prime in $primes; do
        if [[ $(($number % $prime)) == 0 ]]; then
            return -1
        fi
    done
    return 0
}

number=2
echo begin
while [[ $nb_primes -lt $PRIME_COUNT ]]; do
    if is_prime $number; then
        echo $number
        primes="$primes $number"
        nb_primes=$((nb_primes + 1))
    fi
    number=$((number + 1))
done
echo end
