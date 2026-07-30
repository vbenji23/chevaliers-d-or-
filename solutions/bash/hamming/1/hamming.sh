#!/usr/bin/env bash

main() {
    if (( $# != 2 )); then
        echo "Usage: hamming.sh <string1> <string2>"
        exit 1
    fi

    local -r strand1=$1
    local -r strand2=$2

    if (( ${#strand1} != ${#strand2} )); then
        echo "strands must be of equal length"
        exit 1
    fi

    local distance=0
    local -i i

    for (( i=0; i<${#strand1}; i++ )); do
        # Note the double quotes around "${strand2:i:1}" to treat glob characters literally
        if [[ "${strand1:i:1}" != "${strand2:i:1}" ]]; then
            (( distance++ ))
        fi
    done

    echo "$distance"
}

main "$@"