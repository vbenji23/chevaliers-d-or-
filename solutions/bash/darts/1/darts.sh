#!/usr/bin/env bash

# Function to check if a string is a valid floating-point number
is_numeric() {
    [[ $1 =~ ^[+-]?([0-9]+\.?[0-9]*|\.[0-9]+)$ ]]
}

main() {
    # Validate argument count
    if (( $# != 2 )); then
        echo "Error: Expected exactly 2 arguments (x and y coordinates)." >&2
        return 1
    fi

    local x=$1
    local y=$2

    # Validate that both inputs are numeric
    if ! is_numeric "$x" || ! is_numeric "$y"; then
        echo "Error: Both arguments must be numeric values." >&2
        return 1
    fi

    # Calculate distance squared: x^2 + y^2
    # Thresholds squared:
    #   Inner circle  (r = 1)  -> r^2 = 1
    #   Middle circle (r = 5)  -> r^2 = 25
    #   Outer circle  (r = 10) -> r^2 = 100
    local dist_sq
    dist_sq=$(bc -l <<< "$x * $x + $y * $y")

    # Determine score based on distance squared
    if (( $(bc -l <<< "$dist_sq <= 1") )); then
        echo "10"
    elif (( $(bc -l <<< "$dist_sq <= 25") )); then
        echo "5"
    elif (( $(bc -l <<< "$dist_sq <= 100") )); then
        echo "1"
    else
        echo "0"
    fi
}

main "$@"