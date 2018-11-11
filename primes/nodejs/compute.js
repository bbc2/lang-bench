const PRIME_COUNT = Number(process.env.PRIME_COUNT);
if(isNaN(PRIME_COUNT)) {
    console.log("Please set PRIME_COUNT environment variable.");
    process.exit(-1);
}
const BENCH_DEBUG = process.env.BENCH_DEBUG;

const primes = [];
function is_prime(n) {
    for(let i = 0; i < primes.length; i++) {
        if(n % primes[i] == 0) {
            return false;
        }
    }
    return true;
}

let number = 2;
process.stdout.write("begin\n", function() {
    let result = "";
    while(primes.length < PRIME_COUNT) {
        if(is_prime(number)) {
            primes.push(number);
        }
        number++;
    }
    if(BENCH_DEBUG === "true") {
        var primes_str = "";
        for(var i = 0; i < primes.length; i++) {
            primes_str += primes[i]+"\n";
        }
        console.log(primes_str.slice(0, -1));
    }
    process.stdout.write("end\n", function() {
        process.exit(0);
    });
});
