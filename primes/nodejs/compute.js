const PRIME_COUNT = Number(process.env.PRIME_COUNT);
if(isNaN(PRIME_COUNT)) {
    console.log("Please set PRIME_COUNT environment variable.");
    process.exit(-1);
}

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
            process.stdout.write(number+"\n");
            primes.push(number);
        }
        number++;
    }
    process.stdout.write("end\n", function() {
        process.exit(0);
    });
});
