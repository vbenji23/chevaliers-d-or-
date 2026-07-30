#!/usr/bin/env bash

main() {
    # Validate: must have 1 argument and consist only of digits
    if [[ $# -ne 1 ]] || ! [[ $1 =~ ^[0-9]+$ ]]; then
        echo "Error: Only positive integers are allowed" >&2
        return 1
    fi

    local n=$1

    # Must be strictly positive (> 0)
    if (( n <= 0 )); then
        echo "Error: Only positive integers are allowed" >&2
        return 1
    fi

    local steps=0

    # Apply Collatz rules until reaching 1
    while (( n > 1 )); do
        if (( n % 2 == 0 )); then
            n=$(( n / 2 ))
        else
            n=$(( 3 * n + 1 ))
        fi
        (( steps++ ))
    done

    echo "$steps"
}

main "$@"