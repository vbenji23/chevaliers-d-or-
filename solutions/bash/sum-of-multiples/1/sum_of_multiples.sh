#!/usr/bin/env bash

main() {
    local limit="$1"
    shift
    local factors=("$@")

    # If limit is 0 or less, or no factors provided, return 0
    if (( limit <= 1 )) || (( ${#factors[@]} == 0 )); then
        echo "0"
        return 0
    fi

    # Mark non-zero multiples as present using an associative array
    # to naturally prevent duplicate values
    declare -A unique_multiples

    for factor in "${factors[@]}"; do
        # Ignore factor 0 as it doesn't contribute non-zero multiples
        if (( factor == 0 )); then
            continue
        fi

        for (( m = factor; m < limit; m += factor )); do
            unique_multiples["$m"]=1
        done
    done

    # Calculate sum of all unique multiples
    local sum=0
    for val in "${!unique_multiples[@]}"; do
        (( sum += val ))
    done

    echo "$sum"
}

main "$@"