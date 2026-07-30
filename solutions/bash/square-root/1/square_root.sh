#!/usr/bin/env bash

main() {
    local target="$1"
    local low=1
    local high="$target"
    local mid sq

    # Use a binary search to find the square root.
    # This avoids using external math libraries or functions.
    while (( low <= high )); do
        # Calculate mid-point to test
        (( mid = low + (high - low) / 2 ))
        (( sq = mid * mid ))

        if (( sq == target )); then
            # Found the exact square root
            echo "$mid"
            return 0
        elif (( sq < target )); then
            # The root must be higher
            (( low = mid + 1 ))
        else
            # The root must be lower
            (( high = mid - 1 ))
        fi
    done
}

main "$@"