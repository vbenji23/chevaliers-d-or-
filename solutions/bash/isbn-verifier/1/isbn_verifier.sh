#!/usr/bin/env bash

main() {
    local input="$1"

    # Remove hyphens/dashes from the input string
    local clean_input="${input//-/}"

    # An ISBN-10 must be exactly 10 characters long
    if [[ ${#clean_input} -ne 10 ]]; then
        echo "false"
        return 0
    fi

    # Verify that the first 9 characters are digits
    if [[ ! "${clean_input:0:9}" =~ ^[0-9]{9}$ ]]; then
        echo "false"
        return 0
    fi

    # Verify that the 10th character (check digit) is a digit or 'X'
    local last_char="${clean_input:9:1}"
    if [[ ! "$last_char" =~ ^[0-9X]$ ]]; then
        echo "false"
        return 0
    fi

    # Calculate the weighted sum according to the ISBN formula
    local sum=0
    local i char val weight

    for (( i = 0; i < 10; i++ )); do
        char="${clean_input:i:1}"
        
        if [[ "$char" == "X" ]]; then
            val=10
        else
            val="$char"
        fi

        weight=$(( 10 - i ))
        (( sum += val * weight ))
    done

    # Check if sum mod 11 equals 0
    if (( sum % 11 == 0 )); then
        echo "true"
    else
        echo "false"
    fi
}

main "$@"