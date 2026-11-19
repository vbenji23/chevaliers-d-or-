#!/usr/bin/env bash

error_exit() {
    echo "$1" >&2
    exit 1
}

main() {
    local input_base="$1"
    local digits_str="$2"
    local output_base="$3"

    # Validate bases: both must be >= 2
    if (( input_base < 2 )); then
        error_exit "input base must be >= 2"
    fi

    if (( output_base < 2 )); then
        error_exit "output base must be >= 2"
    fi

    # Read digits string into an array
    read -r -a digits <<< "$digits_str"

    # Step 1: Convert input digits from input_base to a decimal integer value
    local decimal_value=0
    for digit in "${digits[@]}"; do
        # Validate individual digits: must be >= 0 and < input_base
        if (( digit < 0 || digit >= input_base )); then
            error_exit "all digits must satisfy 0 <= d < input_base"
        fi

        (( decimal_value = decimal_value * input_base + digit ))
    done

    # If the value is 0 (or empty input), the output is simply 0
    if (( decimal_value == 0 )); then
        echo "0"
        return 0
    fi

    # Step 2: Convert decimal_value into the target output_base
    local result_digits=()
    while (( decimal_value > 0 )); do
        local rem=$(( decimal_value % output_base ))
        result_digits=("$rem" "${result_digits[@]}")
        (( decimal_value /= output_base ))
    done

    # Output the converted digits joined by spaces
    echo "${result_digits[*]}"
}

main "$@"