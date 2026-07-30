#!/usr/bin/env bash

main() {
    local text="$1"
    local key="$2"

    # Normalize key to range 0-25 using modular arithmetic
    key=$(( key % 26 ))

    local lower="abcdefghijklmnopqrstuvwxyz"
    local upper="ABCDEFGHIJKLMNOPQRSTUVWXYZ"

    # Construct rotated alphabets using string slicing
    local rotated_lower="${lower:key}${lower:0:key}"
    local rotated_upper="${upper:key}${upper:0:key}"

    # Translate input text using tr
    tr "${lower}${upper}" "${rotated_lower}${rotated_upper}" <<< "$text"
}

main "$@"