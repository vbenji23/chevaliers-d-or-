#!/usr/bin/env bash

main() {
    local input=$1

    if [[ "$input" == "total" ]]; then
        # 2^64 - 1
        echo "2^64 - 1" | bc
        return 0
    fi

    # Validate input: must be an integer between 1 and 64
    if ! [[ "$input" =~ ^[0-9]+$ ]] || (( input < 1 || input > 64 )); then
        echo "Error: invalid input"
        exit 1
    fi

    # 2^(square - 1)
    echo "2^($input - 1)" | bc
}

main "$@"