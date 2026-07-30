#!/usr/bin/env bash

main() {
    local -r series=$1
    local -r len=$2
    local -r series_len=${#series}

    # Validation checks
    if [[ -z "$series" ]]; then
        echo "series cannot be empty" >&2
        exit 1
    fi

    if (( len == 0 )); then
        echo "slice length cannot be zero" >&2
        exit 1
    fi

    if (( len < 0 )); then
        echo "slice length cannot be negative" >&2
        exit 1
    fi

    if (( len > series_len )); then
        echo "slice length cannot be greater than series length" >&2
        exit 1
    fi

    local -a slices=()

    # Extract all contiguous slices of length $len
    for (( i = 0; i <= series_len - len; i++ )); do
        slices+=("${series:i:len}")
    done

    # Print space-separated slices
    echo "${slices[*]}"
}

main "$@"