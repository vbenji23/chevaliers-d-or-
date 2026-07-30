#!/usr/bin/env bash

main() {
    local -a lines=()
    local line
    local -i max_len=0

    # Read all lines from standard input
    while IFS= read -r line || [[ -n "$line" ]]; do
        lines+=("$line")
        if (( ${#line} > max_len )); then
            max_len=${#line}
        fi
    done

    local -i num_lines=${#lines[@]}

    # Process column by column (which become rows in output)
    local -i col
    for (( col = 0; col < max_len; col++ )); do
        local output_row=""

        # Find the last input row that has a character at this column
        local -i max_row=-1
        local -i row
        for (( row = num_lines - 1; row >= 0; row-- )); do
            if (( col < ${#lines[row]} )); then
                max_row=$row
                break
            fi
        done

        # Build output row up to max_row (pad with spaces for shorter preceding rows)
        for (( row = 0; row <= max_row; row++ )); do
            local current_line="${lines[row]}"
            if (( col < ${#current_line} )); then
                output_row+="${current_line:col:1}"
            else
                output_row+=" "
            fi
        done

        echo "$output_row"
    done
}

main "$@"