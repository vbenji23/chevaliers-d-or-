#!/usr/bin/env bash

main() {
    # Convert input to lowercase
    local input="${1,,}"

    # Remove non-alphabetic characters (spaces and hyphens)
    local cleaned="${input//[^a-z]/}"

    # Track seen letters using an associative array
    local -A seen

    local i char
    for (( i = 0; i < ${#cleaned}; i++ )); do
        char="${cleaned:i:1}"
        if [[ -n "${seen[$char]}" ]]; then
            echo "false"
            return 0
        fi
        seen["$char"]=1
    done

    echo "true"
}

main "$@"