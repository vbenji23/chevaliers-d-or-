#!/usr/bin/env bash

main() {
    local input="$1"

    # Strip spaces from the input
    local clean_input="${input// /}"

    # Check length: strings of length <= 1 are invalid
    if (( ${#clean_input} <= 1 )); then
        echo "false"
        return 0
    fi

    # Disallow non-digit characters
    if [[ ! "$clean_input" =~ ^[0-9]+$ ]]; then
        echo "false"
        return 0
    fi

    local sum=0
    local double=0
    local len=${#clean_input}
    local i digit

    # Iterate from right to left
    for (( i = len - 1; i >= 0; i-- )); do
        digit="${clean_input:i:1}"

        if (( double )); then
            (( digit *= 2 ))
            if (( digit > 9 )); then
                (( digit -= 9 ))
            fi
            double=0
        else
            double=1
        fi

        (( sum += digit ))
    done

    # Validate sum divisibility by 10
    if (( sum % 10 == 0 )); then
        echo "true"
    else
        echo "false"
    fi
}

main "$@"