#!/usr/bin/env bash

main() {
    local number="$1"
    local result=""

    # Parallel arrays storing decimal values and their corresponding Roman symbols
    # in descending order.
    local values=(1000 900 500 400 100 90 50 40 10 9 5 4 1)
    local roman=(M CM D CD C XC L XL X IX V IV I)

    # Greedily subtract values from largest to smallest
    for i in "${!values[@]}"; do
        local val="${values[$i]}"
        local sym="${roman[$i]}"

        while (( number >= val )); do
            result+="$sym"
            (( number -= val ))
        done
    done

    echo "$result"
}

main "$@"