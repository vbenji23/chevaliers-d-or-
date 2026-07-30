#!/usr/bin/env bash

main() {
    local num_rows="$1"

    # If 0 rows requested, output nothing and exit
    if (( num_rows <= 0 )); then
        return 0
    fi

    local prev_row=()

    for (( row = 0; row < num_rows; row++ )); do
        local current_row=()

        for (( col = 0; col <= row; col++ )); do
            if (( col == 0 || col == row )); then
                current_row+=(1)
            else
                local left=$(( prev_row[col - 1] ))
                local right=$(( prev_row[col] ))
                current_row+=( $(( left + right )) )
            fi
        done

        # Leading spaces for triangular alignment: (num_rows - row - 1) spaces
        local indent_count=$(( num_rows - row - 1 ))
        local indent=""
        if (( indent_count > 0 )); then
            printf -v indent "%*s" "$indent_count" ""
        fi

        # Print leading spaces followed by row numbers separated by single spaces
        printf "%s%s\n" "$indent" "${current_row[*]}"

        # Save current row as previous row for next iteration
        prev_row=("${current_row[@]}")
    done
}

main "$@"