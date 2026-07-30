#!/usr/bin/env bash

main() {
    local -i n=$1

    # Bounds for 'a': 1 <= a < n / 3
    local -i max_a=$(( (n - 1) / 3 ))

    for (( a = 1; a <= max_a; a++ )); do
        local -i num=$(( n * (n - 2 * a) ))
        local -i den=$(( 2 * (n - a) ))

        # Check if b is an integer
        if (( num % den == 0 )); then
            local -i b=$(( num / den ))
            if (( b > a )); then
                local -i c=$(( n - a - b ))
                echo "${a},${b},${c}"
            fi
        fi
    done
}

main "$@"