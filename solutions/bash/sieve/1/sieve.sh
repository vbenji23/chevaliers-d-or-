#!/usr/bin/env bash

main() {
    local limit="$1"

    # Numbers less than 2 have no primes
    if (( limit < 2 )); then
        echo ""
        return 0
    fi

    # Initialize a boolean array where 0 = prime (unmarked) and 1 = composite (marked)
    local is_composite=()
    local primes=()
    local i j

    # Sieve of Eratosthenes algorithm
    for (( i = 2; i <= limit; i++ )); do
        if [[ -z "${is_composite[i]}" ]]; then
            primes+=("$i")

            # Mark all multiples of i starting from i*i (or i+i)
            for (( j = i * i; j <= limit; j += i )); do
                is_composite[j]=1
            done
        fi
    done

    # Output space-separated list of prime numbers
    echo "${primes[*]}"
}

main "$@"