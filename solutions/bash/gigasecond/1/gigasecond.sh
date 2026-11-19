#!/usr/bin/env bash

main() {
    local input="$1"

    # Replace 'T' with a space so GNU date / date -d can parse both 'YYYY-MM-DD' and 'YYYY-MM-DDTHH:MM:SS'
    local formatted_input="${input/T/ }"

    # Enforce UTC timezone to prevent local timezone offsets from affecting calculations
    local epoch
    epoch=$(TZ=UTC date -u -d "$formatted_input" +%s)

    # Add 1 gigasecond (10^9 seconds)
    local target_epoch=$(( epoch + 1000000000 ))

    # Format the result back into ISO-8601 (YYYY-MM-DDTHH:MM:SS) in UTC
    TZ=UTC printf '%(%Y-%m-%dT%H:%M:%S)T\n' "$target_epoch"
}

main "$@"