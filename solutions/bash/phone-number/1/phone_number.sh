#!/usr/bin/env bash

error_exit() {
    echo "Invalid number.  [1]NXX-NXX-XXXX N=2-9, X=0-9" >&2
    exit 1
}

main() {
    local input="$1"

    # Remove valid non-digit punctuation (spaces, hyphens, dots, parentheses, plus signs)
    local cleaned="${input//[ -\.\(\)\+]/}"

    # If there are any non-digit characters left, it's invalid
    if [[ "$cleaned" =~ [^0-9] ]]; then
        error_exit
    fi

    local len=${#cleaned}

    # Handle 11-digit numbers starting with 1
    if (( len == 11 )); then
        if [[ "${cleaned:0:1}" != "1" ]]; then
            error_exit
        fi
        cleaned="${cleaned:1}"
        len=10
    fi

    # Number must be exactly 10 digits
    if (( len != 10 )); then
        error_exit
    fi

    # Check NANP format rules: NXX NXX-XXXX where N = 2-9
    # Area code first digit (cleaned[0]) must be 2-9
    # Exchange code first digit (cleaned[3]) must be 2-9
    if [[ ! "${cleaned:0:1}" =~ [2-9] ]] || [[ ! "${cleaned:3:1}" =~ [2-9] ]]; then
        error_exit
    fi

    echo "$cleaned"
}

main "$@"