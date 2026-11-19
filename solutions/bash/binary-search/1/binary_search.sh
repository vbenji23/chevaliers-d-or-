#!/usr/bin/env bash

main() {
    local target="$1"
    shift
    local arr=("$@")

    local left=0
    local right=$((${#arr[@]} - 1))

    # Binary search algorithm
    while (( left <= right )); do
        local mid=$(( (left + right) / 2 ))

        if (( arr[mid] == target )); then
            echo "$mid"
            return 0
        elif (( arr[mid] < target )); then
            left=$(( mid + 1 ))
        else
            right=$(( mid - 1 ))
        fi
    done

    # If element is not found in array
    echo "-1"
}

main "$@"