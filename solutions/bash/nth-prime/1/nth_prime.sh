#!/usr/bin/env bash

# Function to check if a number is prime
is_prime() {
    local -i n=$1
    if (( n < 2 )); then
        return 1
    fi
    if (( n == 2 || n == 3 )); then
        return 0
    fi
    if (( n % 2 == 0 || n % 3 == 0 )); then
        return 1
    fi

    # Check factors up to sqrt(n) using 6k ± 1 optimization
    local -i i=5
    while (( i * i <= n )); do
        if (( n % i == 0 || n % (i + 2) == 0 )); then
            return 1
        fi
        (( i += 6 ))
    done

    return 0
}

main() {
    local -i target=$1

    # Input validation: target must be a positive integer >= 1
    if (( target < 1 )); then
        echo "invalid input" >&2
        exit 1
    fi

    # 1st prime is 2
    if (( target == 1 )); then
        echo 2
        return 0
    fi

    local -i count=1  # We already count '2' as the 1st prime
    local -i candidate=3

    # Loop through odd numbers to find primes
    while (( count < target )); do
        if is_prime "$candidate"; then
            (( count++ ))
        fi
        if (( count == target )); then
            echo "$candidate"
            return 0
        fi
        (( candidate += 2 ))
    done
}

main "$@"