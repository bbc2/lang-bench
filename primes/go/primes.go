package main

import "fmt"
import "strconv"
import "os"

func main() {
	var PRIME_COUNT_STR = os.Getenv("PRIME_COUNT")
	var PRIME_COUNT, err = strconv.Atoi(PRIME_COUNT_STR)
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
			fmt.Println(number)
			primes = append(primes, number)
		}
		number++
	}
	fmt.Println("end")
	os.Stdout.Sync()
}
