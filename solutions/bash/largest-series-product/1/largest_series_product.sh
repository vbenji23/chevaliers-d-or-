#!/usr/bin/env bash

main() {
    local -r digits=$1
    local -r span=$2

    # Validation: Negative span
    if (( span < 0 )); then
        echo "span must not be negative"
        exit 1
    fi

    # Validation: Span longer than digits string length
    if (( span > ${#digits} )); then
        echo "span must not exceed string length"
        exit 1
    fi

    # Validation: Digits input must only contain numeric digits
    if [[ "$digits" =~ [^0-9] ]]; then
        echo "digits input must only contain digits"
        exit 1
    fi

    local max_product=0
    local -i i j product digit

    # Slide the window across the string
    for (( i = 0; i <= ${#digits} - span; i++ )); do
        product=1
        for (( j = 0; j < span; j++ )); do
            digit=${digits:i+j:1}
            (( product *= digit ))
        done

        if (( product > max_product )); then
            max_product=$product
        fi
    done

    echo "$max_product"
}

main "$@"