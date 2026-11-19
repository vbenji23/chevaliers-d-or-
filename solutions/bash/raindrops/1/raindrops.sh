#!/usr/bin/env bash

main() {
    local -r number=$1
    local result=""

    # Check divisibility by 3, 5, and 7
    (( number % 3 == 0 )) && result+="Pling"
    (( number % 5 == 0 )) && result+="Plang"
    (( number % 7 == 0 )) && result+="Plong"

    # If result is empty, default to the original number
    echo "${result:-$number}"
}

main "$@"