#!/usr/bin/env bash

main() {
    # Convert input string to lowercase for case-insensitivity
    local -r sentence="${1,,}"

    # Iterate over every letter from 'a' to 'z'
    for letter in {a..z}; do
        # If any letter isn't found in the sentence, it's not a pangram
        if [[ "$sentence" != *"$letter"* ]]; then
            echo "false"
            return 0
        fi
    done

    # All 26 letters were present
    echo "true"
}

main "$@"