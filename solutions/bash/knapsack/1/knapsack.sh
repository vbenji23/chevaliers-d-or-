#!/usr/bin/env bash

# Solve the 0/1 Knapsack Problem using Dynamic Programming.
#
# Arguments:
#   $1 - Maximum weight capacity
#   $2.. - Items represented as "weight:value"

main() {
    # Check if maximum weight argument is provided
    if (( $# < 1 )); then
        echo "Error: Capacity required" >&2
        exit 1
    fi

    local capacity="$1"
    shift
    local -a items=("$@")

    # Array to hold the DP table: dp[w] = max value for capacity w
    local -a dp=()

    # Initialize DP array with zeros
    for (( w=0; w<=capacity; w++ )); do
        dp[w]=0
    done

    # Iterate over each item
    for item in "${items[@]}"; do
        # Parse weight and value from "weight:value" format
        IFS=':' read -r weight value <<< "$item"

        # Update DP table in reverse to prevent using the same item multiple times
        for (( w=capacity; w>=weight; w-- )); do
            local prev_w=$(( w - weight ))
            local candidate=$(( dp[prev_w] + value ))
            if (( candidate > dp[w] )); then
                dp[w]=$candidate
            fi
        done
    done

    echo "${dp[capacity]}"
}

main "$@"