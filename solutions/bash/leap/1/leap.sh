#!/usr/bin/env bash

main() {
    # Check that exactly one argument is provided
    if (( $# != 1 )); then
        echo "Usage: leap.sh <year>"
        exit 1
    fi

    local year=$1

    # Validate that the argument is a positive integer (or 0)
    if [[ ! "$year" =~ ^[0-9]+$ ]]; then
        echo "Usage: leap.sh <year>"
        exit 1
    fi

    # Leap year logic:
    # Divisible by 4 AND (not divisible by 100 OR divisible by 400)
    if (( year % 4 == 0 && (year % 100 != 0 || year % 400 == 0) )); then
        echo "true"
    else
        echo "false"
    fi
}

main "$@"