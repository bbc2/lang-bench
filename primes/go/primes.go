package main

import "fmt"
import "strconv"
import "os"

func main() {
	var PRIME_COUNT_STR = os.Getenv("PRIME_COUNT")
	var PRIME_COUNT, err = strconv.Atoi(PRIME_COUNT_STR)
	var BENCH_DEBUG = os.Getenv("BENCH_DEBUG")
	if err != nil {
		fmt.Println("Please set the PRIME_COUNT environment variable.")
		os.Exit(-1)
	}
	primes := make([]int, 0)

	var is_prime = func(number int) bool {
		for i := 0; i < len(primes); i++ {
			if number%primes[i] == 0 {
				return false
			}
		}
		return true
	}

	var number = 2
	fmt.Println("begin")
	os.Stdout.Sync()
	for len(primes) < PRIME_COUNT {
		if is_prime(number) {
			primes = append(primes, number)
		}
		number++
	}

	if BENCH_DEBUG == "true" {
		for i := 0; i < len(primes); i++ {
			fmt.Println(primes[i])
		}
	}

	fmt.Println("end")
	os.Stdout.Sync()
}
