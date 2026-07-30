#!/usr/bin/env bash

main() {
    local strand="$1"

    # Validate that the strand contains only A, C, G, T characters (or is empty)
    if [[ "$strand" =~ [^ACGT] ]]; then
        echo "Invalid nucleotide in strand" >&2
        return 1
    fi

    local a=0 c=0 g=0 t=0
    local i char

    # Iterate through each character in the strand
    for (( i = 0; i < ${#strand}; i++ )); do
        char="${strand:i:1}"
        case "$char" in
            A) (( a++ )) ;;
            C) (( c++ )) ;;
            G) (( g++ )) ;;
            T) (( t++ )) ;;
        esac
    done

    # Output formatted count without extra spaces before colons
    echo "A: $a"
    echo "C: $c"
    echo "G: $g"
    echo "T: $t"
}

main "$@"