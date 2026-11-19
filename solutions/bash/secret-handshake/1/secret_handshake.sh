#!/usr/bin/env bash

main() {
    local -i number=$1
    local -a actions=()

    # Bitwise checks for actions
    (( number & 1 ))  && actions+=("wink")
    (( number & 2 ))  && actions+=("double blink")
    (( number & 4 ))  && actions+=("close your eyes")
    (( number & 8 ))  && actions+=("jump")

    # If the 16 bit (10000 in binary) is set, reverse the array
    if (( number & 16 )); then
        local -a reversed=()
        for (( i = ${#actions[@]} - 1; i >= 0; i-- )); do
            reversed+=("${actions[i]}")
        done
        actions=("${reversed[@]}")
    fi

    # Join elements with commas
    IFS=,
    echo "${actions[*]}"
}

main "$@"