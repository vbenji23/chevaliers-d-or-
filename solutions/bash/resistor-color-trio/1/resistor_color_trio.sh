#!/usr/bin/env bash

# Map color to its corresponding numerical value
color_to_value() {
    case "$1" in
        black)  echo 0 ;;
        brown)  echo 1 ;;
        red)    echo 2 ;;
        orange) echo 3 ;;
        yellow) echo 4 ;;
        green)  echo 5 ;;
        blue)   echo 6 ;;
        violet) echo 7 ;;
        grey)   echo 8 ;;
        white)  echo 9 ;;
        *)
            echo "Invalid color: $1" >&2
            return 1
            ;;
    esac
}

main() {
    if (( $# < 3 )); then
        echo "Error: expected at least 3 color arguments" >&2
        exit 1
    fi

    # Lookup color values
    local v1 v2 zeros
    v1=$(color_to_value "$1") || exit 1
    v2=$(color_to_value "$2") || exit 1
    zeros=$(color_to_value "$3") || exit 1

    # Calculate total value in ohms using base 10 arithmetic
    # (Using 10# force avoids treating leading zeros as octal)
    local raw_val=$(( (10#$v1 * 10 + 10#$v2) * (10 ** zeros) ))

    # Determine metric prefix
    local prefix="ohms"
    if (( raw_val >= 1000000000 )); then
        raw_val=$(( raw_val / 1000000000 ))
        prefix="gigaohms"
    elif (( raw_val >= 1000000 )); then
        raw_val=$(( raw_val / 1000000 ))
        prefix="megaohms"
    elif (( raw_val >= 1000 && raw_val % 1000 == 0 )); then
        raw_val=$(( raw_val / 1000 ))
        prefix="kiloohms"
    fi

    echo "$raw_val $prefix"
}

main "$@"