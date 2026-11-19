#!/usr/bin/env bash

main() {
    local -r name=$1
    local -r number=$2

    # Calculate modulo values for suffix rules:
    # mod100 determines exceptions like 11, 12, 13
    # mod10 determines standard ending digits (1, 2, 3)
    local -i mod100=$(( number % 100 ))
    local -i mod10=$(( number % 10 ))
    local suffix="th"

    if (( mod100 >= 11 && mod100 <= 13 )); then
        suffix="th"
    elif (( mod10 == 1 )); then
        suffix="st"
    elif (( mod10 == 2 )); then
        suffix="nd"
    elif (( mod10 == 3 )); then
        suffix="rd"
    fi

    echo "${name}, you are the ${number}${suffix} customer we serve today. Thank you!"
}

main "$@"