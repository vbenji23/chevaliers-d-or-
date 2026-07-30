#!/usr/bin/env bash

main() {
    local input="$1"

    # Normalize input: lowercase and remove non-alphanumeric characters
    local normalized
    normalized=$(echo "$input" | tr '[:upper:]' '[:lower:]' | tr -cd 'a-z0-9')

    local len=${#normalized}

    # If normalized string is empty, output empty string
    if (( len == 0 )); then
        echo ""
        return 0
    fi

    # Determine dimensions: c columns, r rows
    # Smallest c such that c >= r and c * r >= len and c - r <= 1
    local c=0 r=0
    while (( c * c < len )); do
        (( c++ ))
    done

    if (( c * (c - 1) >= len )); then
        r=$(( c - 1 ))
    else
        r=$c
    fi

    # Build the ciphertext by reading column by column
    local encoded_chunks=()
    local col row index char

    for (( col = 0; col < c; col++ )); do
        local chunk=""
        for (( row = 0; row < r; row++ )); do
            index=$(( row * c + col ))
            if (( index < len )); then
                char="${normalized:index:1}"
            else
                char=" "
            fi
            chunk+="$char"
        done
        encoded_chunks+=("$chunk")
    done

    # Output space-separated chunks
    echo "${encoded_chunks[*]}"
}

main "$@"