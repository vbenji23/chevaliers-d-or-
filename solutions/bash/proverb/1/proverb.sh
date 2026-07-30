#!/usr/bin/env bash

main() {
    # If no arguments are passed, output nothing and exit cleanly
    if (( $# == 0 )); then
        return 0
    fi

    local items=("$@")
    local count=${#items[@]}
    local i

    # Loop through consecutive pairs of words
    for (( i = 0; i < count - 1; i++ )); do
        echo "For want of a ${items[i]} the ${items[i+1]} was lost."
    done

    # Output the concluding line referencing the first item
    echo "And all for the want of a ${items[0]}."
}

main "$@"