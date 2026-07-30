#!/usr/bin/env bash

main() {
    local n="$1"

    # Input validation: must be a positive integer (> 0)
    if [[ ! "$n" =~ ^[0-9]+$ ]] || (( n <= 0 )); then
        echo "Classification is only possible for positive integers." >&2
        return 1
    fi

    # 1 has no proper divisors, so its aliquot sum is 0
    if (( n == 1 )); then
        echo "deficient"
        return 0
    fi

    local sum=1
    local i

    # Optimize factor finding up to sqrt(n)
    for (( i = 2; i * i <= n; i++ )); do
        if (( n % i == 0 )); then
            sum=$(( sum + i ))
            # If factors are distinct (not a perfect square root), add the paired factor
            if (( i * i != n )); then
                sum=$(( sum + n / i ))
            fi
        fi
    done

    # Classify based on the aliquot sum
    if (( sum == n )); then
        echo "perfect"
    elif (( sum > n )); then
        echo "abundant"
    else
        echo "deficient"
    fi
}

main "$@"