use std::io::{self, Write};
struct PrimeSeeker {
    primes: Vec<usize>,
    current_number: usize,
}

impl PrimeSeeker {
    fn new() -> Self {
        Self {
            primes: vec!(),
            current_number: 2,
        }
    }

    fn is_prime(&self, number: usize) -> bool {
        for prime in self.primes.iter() {
            if number % prime == 0 {
                return false;
            }
        }
        return true;
    }

    fn seek_up_to(&mut self, prime_count: usize) {
        let mut number = self.current_number;
        while self.primes.len() < prime_count {
            if self.is_prime(number) {
                self.primes.push(number);
            }
            number += 1;
        }
        self.current_number = number;
    }

    fn print_primes(&self) {
        for prime in self.primes.iter() {
            println!("{}", prime);
        }
    }
}

fn main() {
    let prime_count = match std::env::var("PRIME_COUNT") {
        Ok(val) => val.parse::<usize>().unwrap(),
        Err(e) => panic!("Please set the PRIME_COUNT environment variable.\n{:?}", e),
    };
    let bench_debug = match std::env::var("BENCH_DEBUG") {
        Ok(val) => val == "true",
        Err(_) => false,
    };

    println!("begin");
    io::stdout().flush().expect("Flush failed");
    let mut prime_seeker = PrimeSeeker::new();
    prime_seeker.seek_up_to(prime_count);

    if bench_debug {
        prime_seeker.print_primes();
    }
    println!("end");
    io::stdout().flush().expect("Flush failed");
}
