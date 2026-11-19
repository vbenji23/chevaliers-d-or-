#!/usr/bin/env bash

main() {
    local -i n=$1

    # Handle size 0
    if (( n == 0 )); then
        exit 0
    fi

    # Initialize boundaries
    local -i top=0 bottom=$(( n - 1 ))
    local -i left=0 right=$(( n - 1 ))
    local -i val=1

    # 2D matrix array using row,col keying
    local -A matrix

    # Traverse in a clockwise spiral filling matrix[r,c]
    while (( top <= bottom && left <= right )); do
        # 1. Fill top row (left to right)
        for (( c = left; c <= right; c++ )); do
            matrix["$top,$c"]=$(( val++ ))
        done
        (( top++ ))

        # 2. Fill right column (top to bottom)
        for (( r = top; r <= bottom; r++ )); do
            matrix["$r,$right"]=$(( val++ ))
        done
        (( right-- ))

        # 3. Fill bottom row (right to left)
        if (( top <= bottom )); then
            for (( c = right; c >= left; c-- )); do
                matrix["$bottom,$c"]=$(( val++ ))
            done
            (( bottom-- ))
        fi

        # 4. Fill left column (bottom to top)
        if (( left <= right )); then
            for (( r = bottom; r >= top; r-- )); do
                matrix["$r,$left"]=$(( val++ ))
            done
            (( left++ ))
        fi
    done

    # Print matrix row by row
    for (( r = 0; r < n; r++ )); do
        local -a row=()
        for (( c = 0; c < n; c++ )); do
            row+=("${matrix["$r,$c"]}")
        done
        echo "${row[*]}"
    done
}

main "$@"