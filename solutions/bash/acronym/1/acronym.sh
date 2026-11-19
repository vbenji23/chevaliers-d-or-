#!/usr/bin/env bash

main() {
    local phrase=$1

    # Replace hyphens and underscores with spaces (word separators)
    phrase=${phrase//[-_]/ }

    # Strip out any remaining punctuation (keep letters, numbers, and spaces)
    phrase=${phrase//[^a-zA-Z0-9 ]/}

    local acronym=""
    local word

    # Iterate through each word safely (prevents globbing on '*')
    for word in $phrase; do
        acronym+="${word:0:1}"
    done

    # Output in uppercase
    echo "${acronym^^}"
}

main "$@"