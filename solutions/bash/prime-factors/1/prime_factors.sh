#!/usr/bin/env bash

main() {
    local n="$1"
    local factor=2
    local factors=()

    # Trial division algorithm up to sqrt(n)
    while (( factor * factor <= n )); do
        while (( n % factor == 0 )); do
            factors+=("$factor")
            n=$(( n / factor ))
        done
        factor=$(( factor + 1 ))
    done

    # If remaining n is greater than 1, it is itself a prime factor
    if (( n > 1 )); then
        factors+=("$n")
    fi

    # Output space-separated factors
    echo "${factors[*]}"
}

main "$@"