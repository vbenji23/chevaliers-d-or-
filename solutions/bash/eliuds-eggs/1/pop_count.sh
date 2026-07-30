#!/usr/bin/env bash

main() {
    local number=$1
    local count=0

    # Brian Kernighan's algorithm: clears the lowest set bit in each iteration
    while (( number > 0 )); do
        number=$(( number & (number - 1) ))
        (( count++ ))
    done

    echo "$count"
}

main "$@"